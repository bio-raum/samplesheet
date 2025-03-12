
// Modules
include { HELPER_GENERATE_SAMPLESHEET } from './../modules/helper/generate_samplesheet'
include { CUSTOM_DUMPSOFTWAREVERSIONS } from './../modules/custom/dumpsoftwareversions'
include { MULTIQC }                     from './../modules/multiqc'

workflow SAMPLESHEET {

    main:

    ch_multiqc_config = params.multiqc_config   ? Channel.fromPath(params.multiqc_config, checkIfExists: true).collect() : Channel.value([])
    ch_multiqc_logo   = params.multiqc_logo     ? Channel.fromPath(params.multiqc_logo, checkIfExists: true).collect() : Channel.value([])

    ch_versions = Channel.from([])
    multiqc_files = Channel.from([])

    ch_reads = params.input ? Channel.fromPath(params.input, checkIfExists: true) : Channel.from([])

    HELPER_GENERATE_SAMPLESHEET(
        ch_reads
    )
    ch_versions = HELPER_GENERATE_SAMPLESHEET.out.versions

    HELPER_GENERATE_SAMPLESHEET.out.tsv.map { s ->
        parse_samplesheet(s)
    }

    CUSTOM_DUMPSOFTWAREVERSIONS(
        ch_versions.unique().collectFile(name: 'collated_versions.yml')
    )

    multiqc_files = multiqc_files.mix(CUSTOM_DUMPSOFTWAREVERSIONS.out.mqc_yml)

    MULTIQC(
        multiqc_files.collect(),
        ch_multiqc_config,
        ch_multiqc_logo
    )

    emit:
    qc = MULTIQC.out.report
}

def parse_samplesheet(ss) {

    def lines = file(ss).readLines()
    lines.pop()
    def samples = []
    // a sample may have more than one pair of files, so we count unique sample ids rather than just lines
    lines.each { line ->
        def sample = line.split("\t")[0]
        samples << sample
    }
    def nsamples = samples.unique().size()
    log.info "Found $nsamples samples - please make sure this is correct!"
    
}
