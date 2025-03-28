# Installation

## Installing nextflow

Nextflow is a highly portable pipeline engine. Please see the official [installation guide](https://www.nextflow.io/docs/latest/getstarted.html#installation) to learn how to set it up.

This pipeline expects Nextflow version 24.04.2 or later, available [here](https://github.com/nextflow-io/nextflow/releases/tag/v24.04.2).

## Software provisioning

This pipeline is set up to work with a range of software provisioning technologies - no need to manually install packages. 

You can choose one of the following options:

[Apptainer](https://apptainer.org/docs/admin/main/installation.html)

[Docker](https://docs.docker.com/engine/install/)

[Singularity](https://docs.sylabs.io/guides/3.11/admin-guide/)

[Podman](https://podman.io/docs/installation)

[Conda](https://github.com/conda-forge/miniforge)

The pipeline comes with simple pre-set profiles for all of these as described [here](usage.md); if you plan to use this pipeline regularly, consider adding your own custom profile to our [central repository](https://github.com/bio-raum/nf-configs) to better leverage your available resources.

## Site-specific config file

If you run on anything other than a local system, this pipeline requires a site-specific configuration file to be able to talk to your cluster or compute infrastructure. Nextflow supports a wide range of such infrastructures, including Slurm, LSF and SGE - but also Kubernetes and AWS. For more information, see [here](https://www.nextflow.io/docs/latest/executor.html).

Site-specific config-files for our pipeline ecosystem are stored centrally on [github](https://github.com/bio-raum/nf-configs). Please talk to us if you want to add your system.