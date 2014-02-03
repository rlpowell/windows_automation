class laptop {
  windows_extras::regload { "$wapath/extras/keyboard.reg":
    unless_key => 'HKEY_CURRENT_USER\Keyboard Layout\Substitutes',
    unless_check => '00010409',
  }

  $high_perf_power = regsubst("\"$wapath/extras/high_perf.pow\"", '/', '\\', 'G')
  exec { 'high performance power settinsg':
    command => "$cmd /c powercfg -S 381b4222-f694-41f0-9685-ff5bb260df2e & $cmd /c powercfg -D 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c & $cmd /c powercfg -import $high_perf_power 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c & cmd /c powercfg -S 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c",
  }
}
