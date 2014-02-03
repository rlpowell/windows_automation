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

  windows_extras::regload { "$secretspath/pdfxchange_viewer.reg":
    require => Package['PDFXChangeViewer'],
    unless_key => 'HKEY_CURRENT_USER\Software\Tracker Software\PDFViewer\Registration',
    unless_check  => 'rlpowell@digitalkingdom.org',
  }
  windows_extras::regload { "$secretspath/pdfxchange_lite.reg":
    require => Package['PDFXChangeViewer'],
    unless_key => 'HKEY_CURRENT_USER\Software\Tracker Software\PDF-XChange Lite 5',
    unless_check  => 'rlpowell@digitalkingdom.org',
  }
}
