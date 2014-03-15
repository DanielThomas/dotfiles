## For details see http://silicon.pd.local/display/eng/HOWTO+PostgreSQL+for+Learn+-+Developer+Installation#HOWTOPostgreSQLforLearn-DeveloperInstallation-SwitchingEnvironments ##

LEARN_MAINLINE=~/Code/learn-mainline
BB_DEVELOPER_CONFIG_PREFIX=$LEARN_MAINLINE/build/developer/config/users/dthomas/dthomas
BB_DEVELOPER_CONFIG_DEFAULT="$BB_DEVELOPER_CONFIG_PREFIX-mac.properties"
BLACKBOARD_HOME_DEFAULT=/usr/local/blackboard
BLACKBOARD_HOME=$BLACKBOARD_HOME_DEFAULT
BB_DEVELOPER_CONFIG=$BB_DEVELOPER_CONFIG_DEFAULT

## Functions ##

function get_bbconfig_property {
  get_bbconfig_property_from $BLACKBOARD_HOME $1
}

function get_default_bbconfig_property {
  get_bbconfig_property_from $BLACKBOARD_HOME_DEFAULT $1
}

function get_bbconfig_property_from {
  location=$1
  property=$2

  value=`grep "^$property=" $location/config/bb-config.properties | cut -d= -f2 | tr -d "\r"`
  if [ -z "$value" ]; then
    deprecated_property=`grep " $property" $location/config/internal/deprecated-properties.txt | sed 's, .*,,'`
    value=`grep "^$deprecated_property=" $location/config/bb-config.properties | cut -d= -f2 | tr -d "\r"`
  fi
  if [ -z "$value" ]; then
    echo "Error retrieving property $property" >&2
    exit 1
  else
    echo $value
  fi
  return
}

# Customise the Agnoster prompt
prompt_custom() {
  cwd=$(pwd)
  if [[ $cwd =~ "^($LEARN_MAINLINE|$BLACKBOARD_HOME).*" ]]; then
    db_type=$(get_bbconfig_property bbconfig.database.type)
    db_type_default=$(get_default_bbconfig_property bbconfig.database.type)
    if [ "$db_type" != "$db_type_default" ]; then
      prompt_segment yellow black
      echo -n $db_type
    fi
  fi
}

function set_config_property {
  file=$1
  new_file=$1.new
  property=$2
  value=$3
  sed "/${property}\=/d" $file > $new_file
  echo "$property=$value" >> $new_file
  mv $new_file $file
}

function learn {
  if (( $# == 0 )); then
    echo "Switching to default Learn instance"
  else
    echo "Switching to '$1' Learn instance"
  fi

  switchLearn $1
  cd $LEARN_MAINLINE/build/developer
}

function switchLearn {
  vmControl stop $(get_bbconfig_property bbconfig.database.type)
  if (( $# == 0 )); then
    export BLACKBOARD_HOME=$BLACKBOARD_HOME_DEFAULT
    export BB_DEVELOPER_CONFIG=$BB_DEVELOPER_CONFIG_DEFAULT
  else
    export BLACKBOARD_HOME=/usr/local/learn-$1/blackboard
    export BB_DEVELOPER_CONFIG="$BB_DEVELOPER_CONFIG_PREFIX-mac-$1.properties"
    vmControl start $1
  fi

  BLACKBOARD_TOOLS=$BLACKBOARD_HOME/tools/admin
  alias bb="cd $BLACKBOARD_HOME"
  alias sc="$BLACKBOARD_TOOLS/ServiceController.sh"
  alias b2m="$BLACKBOARD_TOOLS/B2Manager.sh"
  alias pcu="$BLACKBOARD_TOOLS/PushConfigUpdates.sh"

  GRADLE_PROPERTIES=~/.gradle/gradle.properties
  set_config_property $GRADLE_PROPERTIES bbHome "$BLACKBOARD_HOME"
  set_config_property $GRADLE_PROPERTIES bbTestServiceConfig "$BLACKBOARD_HOME/config/service-config-unittest.properties"
  set_config_property $GRADLE_PROPERTIES b2DeployTarget "$(get_bbconfig_property bbconfig.frontend.protocol)://$(get_bbconfig_property bbconfig.frontend.fullhostname):$(get_bbconfig_property bbconfig.frontend.portnumber)"
  set_config_property $GRADLE_PROPERTIES b2DeployName $(get_bbconfig_property bbconfig.database.identifier)
}

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

switchLearn
