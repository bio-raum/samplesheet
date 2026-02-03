# Usage information

[Basic execution](#basic-execution)

[Pipeline version](#specifying-pipeline-version)

[Resources](#resources)

## Basic execution

Please see our [installation guide](installation.md) to learn how to set up this pipeline first. 

A basic execution of the pipeline looks as follows:

a) Without a site-specific config file

```bash
nextflow run bio-raum/samplesheet -profile singularity --input /path/to/reads
```

In this example, the pipeline will assume it runs on a single computer with the singularity container engine available. Available options to provision software are:

`-profile apptainer`

`-profile singularity`

`-profile docker` 

`-profile podman` 

`-profile conda` 

Additional software provisioning tools as described [here](https://www.nextflow.io/docs/latest/container.html) may also work, but have not been tested by us. Please note that conda may not work for all packages on all platforms. If this turns out to be the case for you, please consider switching to one of the supported container engines. 

b) with a site-specific config file

Assuming you are using a personalited profile ("yourprofile"):

```bash
nextflow run bio-raum/samplesheet -profile yourprofile --input /path/to/reads
```

## Specifying pipeline version

If you are running this pipeline in a production setting, you will want to lock the pipeline to a specific version. This is natively supported through nextflow with the `-r` argument:

```bash
nextflow run bio-raum/samplesheet -profile yourprofile -r 1.0 <other options here>
```

The `-r` option specifies a github [release tag](https://github.com/bio-raum/samplesheet/releases) or branch, so could also point to `main` for the very latest code release. Please note that every major release of this pipeline (1.0, 2.0 etc) comes with a new reference data set, which has the be [installed](installation.md) separately.

## Options

### `--platform` [default = null]

When setting this option, the samplesheet will contain an additional "platform" column with a best-guess as to the sequencing technology used. This is needed by some of the bio-raum pipelines, such as [gabi](https://github.com/bio-raum/gabi). 