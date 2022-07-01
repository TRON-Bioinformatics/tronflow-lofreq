# TronFlow LoFreq

A nextflow (Di Tommaso, 2017) pipeline implementing the LoFreq (Wilm, 2012) pipeline for somatic variant calling of tumor-normal pairs.



## How to run it

```
$ nextflow run tron-bioinformatics/tronflow-lofreq -profile conda --help

Usage:
    nextflow run tron-bioinformatics/tronflow-lofreq -profile conda --input_files input_files --reference reference.fasta

Input:
    * input_files: the path to a tab-separated values file containing in each row the sample name, tumor bam and normal bam
    The input file does not have header!
    Example input file:
    name1	tumor_bam1	normal_bam1
    name2	tumor_bam2	normal_bam2
    * reference: path to the FASTA genome reference (indexes expected *.fai)
    
Optional input:
    * output: the folder where to publish output
    * memory: the ammount of memory used by each job (default: 16g)
    * cpus: the number of CPUs used by each job (default: 2)

Output:
    * Final somatic calls VCF
    * Raw somatic calls VCF
    * Normal calls VCF
    * Tumor calls VCF
```

## Input tables

The input table expects three tab-separated columns without a header.
Replicate BAM files can be provided comma-separated, this will be merged into a single BAM file.

| Patient name          | Tumor BAMs             |  Normal BAMs             |
|----------------------|------------------------|------------------------|
| patient_1             | /path/to/patient_1.tumor.bam | /path/to/patient_1.normal.bam |
| patient_2             | /path/to/patient_2.tumor.1.bam,/path/to/patient_2.tumor.2.bam | /path/to/patient_2.normal.1.bam,/path/to/patient_2.tumor.2.bam |


## Current limitations

Although it is recommended to provide dbSNP without somatic variants for filtering purposes, this is not supported yet.

If your BAM files were not preprocessed through GATK's BQSR, LoFreq provides an alternative, this is not supported yet.

If replicates are provided, a conservative approach would be filter out variants not detected in every pairwise combination.
A more relaxed approach would the opposite to keep them all. At the moment we just merge all reads in a single BAM, 
thus we lose the advantage of having replicates apart from having greater coverage.

## References

- Di Tommaso, P., Chatzou, M., Floden, E. W., Barja, P. P., Palumbo, E., & Notredame, C. (2017). Nextflow enables reproducible computational workflows. Nature Biotechnology, 35(4), 316–319. https://doi.org/10.1038/nbt.3820
- Wilm, A., Aw, P. P. K., Bertrand, D., Yeo, G. H. T., Ong, S. H., Wong, C. H., Khor, C. C., Petric, R., Hibberd, M. L., & Nagarajan, N. (2012). LoFreq: A sequence-quality aware, ultra-sensitive variant caller for uncovering cell-population heterogeneity from high-throughput sequencing datasets. Nucleic Acids Research, 40(22), 11189–11201. https://doi.org/10.1093/nar/gks918