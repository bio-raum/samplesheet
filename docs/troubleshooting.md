# Common issues

## The samples are named incorrectly

This pipeline tries to guess how to name and group sets of reads based on the file name. It should work without problems for canonically named Illumina reads (`LIBRARY_S1_L001_R1_001.fastq.gZ` or similar) as well as read data from SRA (e.g. `SRR12345_1.fastq.gz`).

For any other naming schema, the pipeline tries to find indicators of pairedness (_R1, _R2, _1, _2) and considers what is left as the sample name. 

However, these assumptions can be violated when your library ID contains motifs that trigger the regular expessions described above, specifically "L00", or "_R". If this is the case, please consider renaming your reads. 








