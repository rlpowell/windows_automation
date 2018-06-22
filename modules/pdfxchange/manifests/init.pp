class pdfxchange {
#**************
# PDF X-Change
#**************
  # See https://github.com/flcdrg/au-packages/pull/33 for how this works.
  #
  # Note that as of 20 June 2018, this won't actually work because
  # the 7.0.325.1 version doesn't have it; see
  # https://chocolatey.org/packages/PDFXchangeEditor for whether the
  # next version has come out.  You can just double-click on the
  # xcvault file if it's not fixed yet.
  package { 'PDFXchangeEditor':
    ensure          => latest,
    install_options => ['--params', '/KeyFile:C:\Users\rlpowell\Dropbox\Windows_Automation_Secrets\PDFXChangeEditor.xcvault' ],
  }
}
