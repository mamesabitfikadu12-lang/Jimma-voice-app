allprojects {
    repositories {
        google()
        mavenCentral()
    }
}
gradle.beforeProject {
    if (project.name != "app" && project.name != rootProject.name) {
        project.extensions.extraProperties.set("flutter", mapOf("compileSdkVersion" to 35, "minSdkVersion" to 23, "targetSdkVersion" to 35, "ndkVersion" to "27.0.12077973"))
    }
}
val newBuildDir: Directory = rootProject.layout.buildDirectory.dir("../../build").get()
rootProject.layout.buildDirectory.value(newBuildDir)
subprojects {
    val newSubprojectBuildDir: Directory = newBuildDir.dir(project.name)
    project.layout.buildDirectory.value(newSubprojectBuildDir)
}
tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}
