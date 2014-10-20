## For details see http://silicon.pd.local/display/eng/HOWTO+PostgreSQL+for+Learn+-+Developer+Installation#HOWTOPostgreSQLforLearn-DeveloperInstallation-SwitchingEnvironments ##

function get_bbconfig_property {
  get_bbconfig_property_from $BLACKBOARD_HOME $1
}

function get_default_bbconfig_property {
  if [ -d $BLACKBOARD_HOME_DEFAULT ]; then
    get_bbconfig_property_from $BLACKBOARD_HOME_DEFAULT $1
  fi
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
  if [[ -d $BLACKBOARD_HOME && $cwd =~ "^($LEARN_MAINLINE|$BLACKBOARD_HOME).*" ]]; then
    db_type=$(get_bbconfig_property bbconfig.database.type)
    if [ $BLACKBOARD_HOME != "/usr/local/blackboard" ]; then
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
    if [[ -d $BLACKBOARD_HOME && $BLACKBOARD_HOME != $BLACKBOARD_HOME_DEFAULT ]]; then
      stopLearn
    fi
    switchLearn
  else
    echo "Switching to '$1' Learn instance"
    switchLearn $1
    startLearn
  fi

  cd $LEARN_MAINLINE/build/developer
}

function startLearn {
  echo "Starting Learn instance at $BLACKBOARD_HOME"
  $BLACKBOARD_TOOLS/ServiceController.sh services.start
}

function stopLearn {
  echo "Stopping Learn instance at $BLACKBOARD_HOME"
  $BLACKBOARD_TOOLS/ServiceController.sh services.stop
}

function switchLearn {
  if [ -d $BLACKBOARD_HOME ]; then
    vmControl suspend $(get_bbconfig_property bbconfig.database.type)
  fi

  if (( $# == 0 )); then
    export BLACKBOARD_HOME=$BLACKBOARD_HOME_DEFAULT
    export BB_DEVELOPER_CONFIG=$BB_DEVELOPER_CONFIG_DEFAULT
  else
    export BLACKBOARD_HOME=/usr/local/learn-$1/blackboard
    export BB_DEVELOPER_CONFIG="$BB_DEVELOPER_CONFIG_PREFIX-mac-$1.properties"
    vmControl start $1
  fi

  if [ -d $BLACKBOARD_HOME ]; then
    BLACKBOARD_TOOLS=$BLACKBOARD_HOME/tools/admin
    alias bb="cd $BLACKBOARD_HOME"
    alias b2="cd $B2_PROJECTS"
    # Aliases for admin tools
    alias sc="$BLACKBOARD_TOOLS/ServiceController.sh"
    alias b2m="$BLACKBOARD_TOOLS/B2Manager.sh"
    alias pcu="$BLACKBOARD_TOOLS/PushConfigUpdates.sh"
    # Follow the latest Tomcat standard out log
    alias lso='tail -f $(gls -t $BLACKBOARD_HOME/logs/tomcat/stdout-stderr-* | head -1)'
    # Enable and disable assertions
    alias lea='ssed -i "s/wrapper.java.additional.2=.*/wrapper.java.additional.2=-enableassertions/g" $BLACKBOARD_HOME/apps/tomcat/conf/wrapper.conf'
    alias lda='ssed -i "s/wrapper.java.additional.2=.*/wrapper.java.additional.2=/g" $BLACKBOARD_HOME/apps/tomcat/conf/wrapper.conf'
    # Enable and disable YourKit
    alias leyk='ssed -i "s/wrapper.java.additional.28=.*/wrapper.java.additional.28=\-agentpath:\/Applications\/YourKit.app\/bin\/mac\/libyjpagent.jnilib=probe_off=\*/g" $BLACKBOARD_HOME/apps/tomcat/conf/wrapper.conf'
    alias ldyk='ssed -i "s/wrapper.java.additional.28=.*/wrapper.java.additional.28=/g" $BLACKBOARD_HOME/apps/tomcat/conf/wrapper.conf'
    # Fast kill and restart of Learn Tomcat (not instance specific)
    alias lkill='pkill -9 -f WrapperStartStop'
    alias lrestart='lkill && sc services.appserver.stop && sc services.appserver.start'

    GRADLE_PROPERTIES=~/.gradle/gradle.properties
    GRADLE_LOCK=$GRADLE_PROPERTIES.lock
    lockfile $GRADLE_LOCK
    set_config_property $GRADLE_PROPERTIES bbHome "$BLACKBOARD_HOME"
    set_config_property $GRADLE_PROPERTIES bbTestServiceConfig "$BLACKBOARD_HOME/config/service-config-unittest.properties"
    set_config_property $GRADLE_PROPERTIES b2DeployTarget "$(get_bbconfig_property bbconfig.frontend.protocol)://$(get_bbconfig_property bbconfig.frontend.fullhostname):$(get_bbconfig_property bbconfig.frontend.portnumber)"
    set_config_property $GRADLE_PROPERTIES b2DeployName $(get_bbconfig_property bbconfig.database.identifier)
    rm -f $GRADLE_LOCK
  else
    echo "Could not switch Learn instances, $BLACKBOARD_HOME does not exist"
  fi
}
