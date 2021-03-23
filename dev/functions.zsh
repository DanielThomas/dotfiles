function gradleDebug() {
    GRADLE_OPTS="-Xrunjdwp:server=y,transport=dt_socket,address=5005,suspend=y" gw --no-daemon "$@"
}

function gradleUserHomeLocal() {
    GRADLE_USER_HOME="$(pwd)/.gradle" gw "$@"
}

function gradle-profiler() {
	~/.gradle-profiler/gradlew -b ~/.gradle-profiler/build.gradle.kts installDist
	echo ""
	~/.gradle-profiler/build/install/gradle-profiler/bin/gradle-profiler "$@"
}

# Useful for profiling the Gradle launcher and adhoc profiling

function gradleYk() {
    GRADLE_OPTS="-agentpath:/Applications/YourKit.app/Contents/Resources/bin/mac/libyjpagent.dylib" gw --no-daemon "$@"
}

function gradleYkSample() {
    GRADLE_OPTS="-agentpath:/Applications/YourKit.app/Contents/Resources/bin/mac/libyjpagent.dylib=sampling,probe_disable=*,onexit=snapshot" gw --no-daemon "$@"
}

function gradleYkAlloc() {
    GRADLE_OPTS="-agentpath:/Applications/YourKit.app/Contents/Resources/bin/mac/libyjpagent.dylib=alloceach=10,allocsizelimit=4096,onexit=snapshot" gw --no-daemon "$@"
}

function gradleYkAllocCount() {
    GRADLE_OPTS="-agentpath:/Applications/YourKit.app/Contents/Resources/bin/mac/libyjpagent.dylib=alloc_object_counting,onexit=snapshot" gw --no-daemon "$@"
}
