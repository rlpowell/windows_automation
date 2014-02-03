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
  }
  windows_extras::regload { "$secretspath/pdfxchange_lite.reg":
    require => Package['PDFXChangeViewer'],
  }
}
