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
