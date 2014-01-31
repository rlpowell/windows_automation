class pdfxchange {
#**************
# PDF X-Change
#**************
  # Don't have an Editor license yet
  # package { [ 'pdfxchangelite', 'PDFXChangeViewer', 'PDFXchangeEditor' ]:
  package { [ 'pdfxchangelite', 'PDFXChangeViewer' ]:
    ensure => installed,
    provider => chocolatey,
  }

  $viewer_reg = regsubst("\"$secretspath/pdfxchange_viewer.reg\"", '/', '\\', 'G')
  $lite_reg = regsubst("\"$secretspath/pdfxchange_lite.reg\"", '/', '\\', 'G')

  exec { 'pdfxchange viewer reg':
    command => "$cmd /c regedit /s $viewer_reg",
    require => Package['PDFXChangeViewer'],
  }

  exec { 'pdfxchange lite reg':
    command => "$cmd /c regedit /s $lite_reg",
    require => Package['pdfxchangelite'],
  }
}
