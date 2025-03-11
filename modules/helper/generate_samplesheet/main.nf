process HELPER_GENERATE_SAMPLESHEET {
    tag 'Samplesheet'
    label 'short_serial'

    conda "${moduleDir}/environment.yml"
    container 'gregdenay/taxidtools:3.1.0'

    input:
    path(read_folder)   

    output:
    path('*.tsv')       , emit: tsv
    path 'versions.yml' , emit: versions

    script:
    def prefix = task.ext.prefix ?: params.run_name
    def args = task.ext.args ?: ""
    """
    generate_samplesheet.py \\
    -f $read_folder \\
    $args \\
    --output ${prefix}.tsv

    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        generate_samplesheet.py: \$(generate_samplesheet.py --version)
        python3: \$(python3 --version  | sed -e "s/Python //")
    END_VERSIONS
    """
}
