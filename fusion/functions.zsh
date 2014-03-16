vm_oracle=~/Documents/Virtual\ Machines.localized/rh6x64-vm000.vmwarevm/rh6x64-vm000.vmx
vm_mssql=~/Documents/Virtual\ Machines.localized/Windows\ Server\ 2012.vmwarevm/Windows\ Server\ 2012.vmx

function vmControl {
  VMX_FILE=$(eval "echo \$vm_$2")
  if [[ -f $VMX_FILE ]]; then
    if [[ "start" == "$1" ]]; then
      echo "Starting Fusion VM $2 ($VMX_FILE)"
      /Applications/VMware\ Fusion.app/Contents/Library/vmrun -T fusion start $VMX_FILE nogui
    elif [[ "stop" == "$1" ]]; then
      echo "Stopping Fusion VM $2 ($VMX_FILE)"
      /Applications/VMware\ Fusion.app/Contents/Library/vmrun -T fusion stop $VMX_FILE soft
    else
      echo Unknown operation $1
    fi
  fi
}
