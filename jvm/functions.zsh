function gradleOptsUnset() {
    unset GRADLE_OPTS
    gradleEnableDaemon
}

function gradleOptsDebug() {
    export GRADLE_OPTS="-Xrunjdwp:server=y,transport=dt_socket,address=5005,suspend=y"
    gradleDisableDaemon
}

function gradleOptsYk() {
    export GRADLE_OPTS="-agentpath:/Applications/YourKit.app/Contents/Resources/bin/mac/libyjpagent.jnilib"
    gradleDisableDaemon
}

function gradleOptsYkSample() {
    export GRADLE_OPTS="-agentpath:/Applications/YourKit.app/Contents/Resources/bin/mac/libyjpagent.jnilib=sampling,probe_disable=*,onexit=snapshot"
    gradleDisableDaemon
}

function gradleOptsYkAlloc() {
    export GRADLE_OPTS="-agentpath:/Applications/YourKit.app/Contents/Resources/bin/mac/libyjpagent.jnilib=alloceach=10,allocsizelimit=4096,onexit=snapshot"
    gradleDisableDaemon
}

function gradleOptsYkAllocCount() {
    export GRADLE_OPTS="-agentpath:/Applications/YourKit.app/Contents/Resources/bin/mac/libyjpagent.jnilib=alloc_object_counting,onexit=snapshot"
    gradleDisableDaemon
}

function gradleDisableDaemon() {
    gsed -i 's/org.gradle.daemon=true/org.gradle.daemon=false/g' ~/.gradle/gradle.properties
}

function gradleEnableDaemon() {
    gsed -i 's/org.gradle.daemon=false/org.gradle.daemon=true/g' ~/.gradle/gradle.properties
}

function gradleUserHomeLocal() {
    export GRADLE_USER_HOME="$(pwd)/.gradle"
}

function gradleUserHomeUnset() {
    unset GRADLE_USER_HOME
}
