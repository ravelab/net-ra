IF NOT EXIST "net-ra\retroarch.cfg" (
  copy net-ra\default.cfg net-ra\retroarch.cfg
)

md etc 2> NUL
md net-ra-etc\playlists 2> NUL
md net-ra-etc\rdb 2> NUL
md net-ra-etc\remaps 2> NUL
md net-ra-etc\saves 2> NUL
md net-ra-etc\screenshots 2> NUL
md net-ra-etc\states 2> NUL
md net-ra-etc\thumbnails 2> NUL
