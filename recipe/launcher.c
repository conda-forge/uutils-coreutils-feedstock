/*
 * Per-utility launcher for the Windows package.
 *
 * uutils ships one multi-call `coreutils.exe`. On Unix every utility is a
 * symlink to it; Windows has no symlinks a conda package can rely on, and
 * copying the 8 MB binary once per utility is too large. Instead each
 * utility is a copy of this launcher named after it (`cp.exe`, `mkdir.exe`,
 * ...). It runs `coreutils.exe <own name> <original arguments>` from its own
 * directory and exits with the child's status.
 */
#include <windows.h>
#include <stdio.h>
#include <string.h>

/* Maximum length of a CreateProcessW command line, including the terminator. */
#define CMDLINE_MAX 32768

static int fail(const wchar_t *message)
{
    fwprintf(stderr, L"coreutils launcher: %ls\n", message);
    return 127;
}

/* Skips the program name at the start of a raw command line. */
static const wchar_t *skip_program_name(const wchar_t *cmdline)
{
    if (*cmdline == L'"') {
        cmdline++;
        while (*cmdline != L'\0' && *cmdline != L'"') {
            cmdline++;
        }
        if (*cmdline == L'"') {
            cmdline++;
        }
    } else {
        while (*cmdline != L'\0' && *cmdline != L' ' && *cmdline != L'\t') {
            cmdline++;
        }
    }
    while (*cmdline == L' ' || *cmdline == L'\t') {
        cmdline++;
    }
    return cmdline;
}

int wmain(void)
{
    static wchar_t self[CMDLINE_MAX];
    static wchar_t coreutils[CMDLINE_MAX];
    static wchar_t cmdline[CMDLINE_MAX];

    DWORD self_len = GetModuleFileNameW(NULL, self, CMDLINE_MAX);
    if (self_len == 0 || self_len >= CMDLINE_MAX) {
        return fail(L"cannot determine own path");
    }

    wchar_t *name = wcsrchr(self, L'\\');
    if (name == NULL) {
        return fail(L"own path has no directory");
    }
    name++;

    wchar_t *extension = wcsrchr(name, L'.');
    if (extension != NULL) {
        *extension = L'\0';
    }

    size_t dir_len = (size_t)(name - self);
    if (swprintf(coreutils, CMDLINE_MAX, L"%.*ls" L"coreutils.exe", (int)dir_len, self) < 0) {
        return fail(L"path to coreutils.exe is too long");
    }

    const wchar_t *arguments = skip_program_name(GetCommandLineW());
    if (swprintf(cmdline, CMDLINE_MAX, L"\"%ls\" %ls %ls", coreutils, name, arguments) < 0) {
        return fail(L"command line is too long");
    }

    /* Ctrl+C goes to the whole console; let the utility handle it and report. */
    SetConsoleCtrlHandler(NULL, TRUE);

    STARTUPINFOW startup;
    memset(&startup, 0, sizeof startup);
    startup.cb = sizeof startup;
    PROCESS_INFORMATION process;
    if (!CreateProcessW(coreutils, cmdline, NULL, NULL, TRUE, 0, NULL, NULL, &startup, &process)) {
        return fail(L"cannot start coreutils.exe");
    }
    CloseHandle(process.hThread);

    WaitForSingleObject(process.hProcess, INFINITE);
    DWORD exit_code = 1;
    GetExitCodeProcess(process.hProcess, &exit_code);
    CloseHandle(process.hProcess);
    return (int)exit_code;
}
