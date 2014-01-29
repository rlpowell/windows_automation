include 'stdlib'
#include 'chocolatey'

$homepath="$env_home"
$appdatapath="$env_appdata"
$dbpath="$homepath/Dropbox"
$wapath="$dbpath/Windows_Automation"
$secretspath="$dbpath/Windows_Automation_Secrets"

File {
	source_permissions => ignore
}

include 'conemu'
include 'misc'
