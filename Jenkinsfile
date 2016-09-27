node {

    def pipeline
    fileLoader.withGit("${env.SCRIPTS_REPO}", "master", "${env.SCRIPTS_CRED}", '') {
        pipeline = fileLoader.load("${env.SCRIPTS_PIPELINE}");
    }
    pipeline.start()
    
}
