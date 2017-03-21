function gradle_opts_unset() {
    unset GRADLE_OPTS
    gradle_enable_daemon
}

function gradle_opts_debug() {
    export GRADLE_OPTS="-Xrunjdwp:server=y,transport=dt_socket,address=5005,suspend=y"
    gradle_disable_daemon
}

function gradle_opts_yk() {
    export GRADLE_OPTS="-agentpath:/Applications/YourKit.app/Contents/Resources/bin/mac/libyjpagent.jnilib"
    gradle_disable_daemon
}

function gradle_opts_ykcpu() {
    export GRADLE_OPTS="-agentpath:/Applications/YourKit.app/Contents/Resources/bin/mac/libyjpagent.jnilib=sampling,probe_disable=*,onexit=snapshot"
    gradle_disable_daemon
}

function gradle_opts_ykmem() {
    export GRADLE_OPTS="-agentpath:/Applications/YourKit.app/Contents/Resources/bin/mac/libyjpagent.jnilib=alloceach=10,allocsizelimit=4096,onexit=snapshot"
    gradle_disable_daemon
}

function gradle_disable_daemon() {
    gsed -i 's/org.gradle.daemon=true/org.gradle.daemon=false/g' ~/.gradle/gradle.properties
}

function gradle_enable_daemon() {
    gsed -i 's/org.gradle.daemon=false/org.gradle.daemon=true/g' ~/.gradle/gradle.properties
}

function gradle_user_home_local() {
    export GRADLE_USER_HOME="$(pwd)/.gradle"
}

function gradle_user_home_unset() {
    unset GRADLE_USER_HOME
}
