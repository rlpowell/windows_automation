class pictures {

  package { [ 'irfanview', 'exiftool', 'ffmpeg', 'k-litecodecpack-standard' ]:
    ensure => latest,
  }

  windows_path {'ffmpeg bin':
    ensure      => present,
    directory   => 'C:\\tools\\ffmpeg\\bin',
  }
}
