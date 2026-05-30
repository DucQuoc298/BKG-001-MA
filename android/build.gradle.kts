import java.nio.file.Files

allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

val newBuildDir: Directory =
    rootProject.layout.buildDirectory
        .dir("../../../../../../../private/tmp/bkg_001_ma-gradle-build")
        .get()
rootProject.layout.buildDirectory.value(newBuildDir)

val flutterBuildLink = rootProject.projectDir.parentFile.resolve("build")
if (!Files.exists(flutterBuildLink.toPath())) {
    Files.createDirectories(newBuildDir.asFile.toPath())
    Files.createSymbolicLink(flutterBuildLink.toPath(), newBuildDir.asFile.toPath())
}

subprojects {
    val newSubprojectBuildDir: Directory = newBuildDir.dir(project.name)
    project.layout.buildDirectory.value(newSubprojectBuildDir)
}
subprojects {
    project.evaluationDependsOn(":app")
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}
