#!/usr/bin/env nextflow

nextflow.enable.dsl = 2

/**
===============================
bio-raum samplesheet pipeline
===============================

This Pipeline generates bio-raum compliant samplesheets

### Homepage / git
git@github.com:bio-raum/samplesheet.git

**/

include { SAMPLESHEET } from './workflows/samplesheet'

workflow {

    WorkflowMain.initialise(workflow, params, log)

    WorkflowPipeline.initialise(params, log)

    multiqc_report = Channel.from([])

    SAMPLESHEET()

    multiqc_report = multiqc_report.mix(SAMPLESHEET.out.qc).toList()
}

workflow.onComplete {
    hline = '========================================='
    log.info hline
    log.info "Duration: $workflow.duration"
    log.info hline

    emailFields = [:]
    emailFields['version'] = workflow.manifest.version
    emailFields['session'] = workflow.sessionId
    emailFields['runName'] = run_name
    emailFields['success'] = workflow.success
    emailFields['dateStarted'] = workflow.start
    emailFields['dateComplete'] = workflow.complete
    emailFields['duration'] = workflow.duration
    emailFields['exitStatus'] = workflow.exitStatus
    emailFields['errorMessage'] = (workflow.errorMessage ?: 'None')
    emailFields['errorReport'] = (workflow.errorReport ?: 'None')
    emailFields['commandLine'] = workflow.commandLine
    emailFields['projectDir'] = workflow.projectDir
    emailFields['script_file'] = workflow.scriptFile
    emailFields['launchDir'] = workflow.launchDir
    emailFields['user'] = workflow.userName
    emailFields['Pipeline script hash ID'] = workflow.scriptId
    emailFields['manifest'] = workflow.manifest
    emailFields['summary'] = summary

    email_info = ''
    for (s in emailFields) {
        email_info += "\n${s.key}: ${s.value}"
    }

    outputDir = new File("${params.outdir}/pipeline_info/")
    if (!outputDir.exists()) {
        outputDir.mkdirs()
    }

    outputTf = new File(outputDir, 'pipeline_report.txt')
    outputTf.withWriter { w -> w << email_info }

    // make txt template
    engine = new groovy.text.GStringTemplateEngine()

    tf = new File("$baseDir/assets/email_template.txt")
    txtTemplate = engine.createTemplate(tf).make(emailFields)
    emailText = txtTemplate.toString()

    // make email template
    hf = new File("$baseDir/assets/email_template.html")
    htmlTemplate = engine.createTemplate(hf).make(emailFields)
    emailHtml = htmlTemplate.toString()

    subject = "Pipeline finished ($run_name)."

    if (params.email) {
        mqcReport = null
        try {
            if (workflow.success && !params.skip_multiqc) {
                mqcReport = multiqc_report.getVal()
                if (mqcReport.getClass() == ArrayList) {
                    // TODO: Update name of pipeline
                    log.warn "[bio-raum/samplesheet] Found multiple reports from process 'multiqc', will use only one"
                    mqcReport = mqcReport[0]
                }
            }
        } catch (all) {
            // TODO: Update name of pipeline
            log.warn '[bio-raum/samplesheet] Could not attach MultiQC report to summary email'
        }

        smailFields = [ email: params.email, subject: subject, emailText: emailText,
            emailHtml: emailHtml, baseDir: "$baseDir", mqcFile: mqcReport,
            mqcMaxSize: params.maxMultiqcEmailFileSize.toBytes()
        ]
        sf = new File("$baseDir/assets/sendmailTemplate.txt")
        sendmailTemplate = engine.createTemplate(sf).make(smailFields)
        sendmailHtml = sendmailTemplate.toString()

        try {
            if (params.plaintext_email) { throw GroovyException('Send plaintext e-mail, not HTML') }
            // Try to send HTML e-mail using sendmail
            [ 'sendmail', '-t' ].execute() << sendmailHtml
        } catch (all) {
            // Catch failures and try with plaintext
            [ 'mail', '-s', subject, params.email ].execute() << emailText
        }
    }
}

