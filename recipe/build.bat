cargo build --release --no-default-features -p uu_base32 -p uu_base64 -p uu_basename -p uu_basenc -p uu_cat -p uu_cksum -p uu_comm -p uu_cp -p uu_csplit -p uu_cut -p uu_date -p uu_dd -p uu_df -p uu_dir -p uu_dircolors -p uu_dirname -p uu_echo -p uu_env -p uu_expand -p uu_expr -p uu_factor -p uu_false -p uu_fmt -p uu_fold -p uu_hashsum -p uu_head -p uu_join -p uu_link -p uu_ln -p uu_ls -p uu_mkdir -p uu_mktemp -p uu_more -p uu_mv -p uu_nl -p uu_nproc -p uu_numfmt -p uu_od -p uu_paste -p uu_pr -p uu_printenv -p uu_printf -p uu_ptx -p uu_pwd -p uu_readlink -p uu_realpath -p uu_rm -p uu_rmdir -p uu_seq -p uu_shred -p uu_shuf -p uu_sleep -p uu_sort -p uu_split -p uu_sum -p uu_sync -p uu_tac -p uu_tail -p uu_tee -p uu_test -p uu_tr -p uu_true -p uu_truncate -p uu_tsort -p uu_unexpand -p uu_uniq -p uu_vdir -p uu_wc -p uu_whoami -p uu_yes
if errorlevel 1 exit 1

for %%i in (base32 base64 basename basenc cat cksum comm cp csplit cut date dd df dir dircolors dirname echo env expand expr factor false fmt fold hashsum head join link ln ls mkdir mktemp more mv nl nproc numfmt od paste pr printenv printf ptx pwd readlink realpath rm rmdir seq shred shuf sleep sort split sum sync tac tail tee test tr true truncate tsort unexpand uniq vdir wc whoami yes) do copy target\release\%%i %LIBRARY_PREFIX%\bin\%%i.exe
if errorlevel 1 exit 1

cargo-bundle-licenses --format yaml --output THIRDPARTY.yml
if errorlevel 1 exit 1
