allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

val newBuildDir: Directory =
    rootProject.layout.buildDirectory
        .dir("../../build")
        .get()
rootProject.layout.buildDirectory.value(newBuildDir)

subprojects {
    val newSubprojectBuildDir: Directory = newBuildDir.dir(project.name)
    project.layout.buildDirectory.value(newSubprojectBuildDir)
}

// --- SCRIPT PENYELAMAT HARUS DI SINI (SEBELUM EVALUATION DEPENDS ON) ---
subprojects {
    afterEvaluate {
        val androidExt = extensions.findByName("android")
        if (androidExt != null) {
            val clazz = androidExt.javaClass
            try {
                // Paksa compileSdk ke 35 untuk menghindari error androidx.window dan android:attr/lStar
                clazz.getMethod("compileSdkVersion", Integer.TYPE).invoke(androidExt, 35)
            } catch (e: Exception) {
                try {
                    clazz.getMethod("setCompileSdkVersion", Integer.TYPE).invoke(androidExt, 35)
                } catch (e2: Exception) {}
            }

            try {
                val namespace = clazz.getMethod("getNamespace").invoke(androidExt)
                if (namespace == null) {
                    val groupString = project.group.toString()
                    clazz.getMethod("setNamespace", String::class.java).invoke(androidExt, groupString)
                }
            } catch (e: Exception) {
                // Abaikan jika error
            }
        }
    }
}
// ------------------------------------------------------------------------

subprojects {
    project.evaluationDependsOn(":app")
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}