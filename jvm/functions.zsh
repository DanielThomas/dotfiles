function gradleDebug() {
    GRADLE_OPTS="-Xrunjdwp:server=y,transport=dt_socket,address=5005,suspend=y" gw --no-daemon "$@"
}

function gradleUserHomeLocal() {
    GRADLE_USER_HOME="$(pwd)/.gradle" gw "$@"
}

function gradle-profiler() {
	~/.gradle-profiler/gradlew -b ~/.gradle-profiler/build.gradle installDist
	echo ""
	~/.gradle-profiler/build/install/gradle-profiler/bin/gradle-profiler "$@"
}

# Useful for profiling the Gradle launcher

function gradleYk() {
    GRADLE_OPTS="-agentpath:/Applications/YourKit.app/Contents/Resources/bin/mac/libyjpagent.jnilib" gw --no-daemon "$@"
}

function gradleOptsYkSample() {
    GRADLE_OPTS="-agentpath:/Applications/YourKit.app/Contents/Resources/bin/mac/libyjpagent.jnilib=sampling,probe_disable=*,onexit=snapshot" gw --no-daemon "$@"
}

function gradleOptsYkAlloc() {
    GRADLE_OPTS="-agentpath:/Applications/YourKit.app/Contents/Resources/bin/mac/libyjpagent.jnilib=alloceach=10,allocsizelimit=4096,onexit=snapshot" gw --no-daemon "$@"
}

function gradleOptsYkAllocCount() {
    GRADLE_OPTS="-agentpath:/Applications/YourKit.app/Contents/Resources/bin/mac/libyjpagent.jnilib=alloc_object_counting,onexit=snapshot" gw --no-daemon "$@"
}