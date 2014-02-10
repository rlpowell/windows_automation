for /d %%A in (7z,arj,bz2,bzip2,cab,cpio,deb,dmg,gz,gzip,hfs,iso,lha,lxz,lzh,lzma,rar,rpm,split,swm,tar,taz,tbz,tbz2,tgz,tpz,wim,xar,xz,z,zip) do (
  assoc .%%A=7-zip.%%A
  ftype 7-Zip.%%A="C:\Program Files\7-Zip\7zFM.exe" "%%1"
  reg add HKEY_CLASSES_ROOT\7-Zip.%%A\DefaultIcon /f /ve /t REG_SZ /d "C:\Program Files\7-Zip\7z.dll,16"
)
