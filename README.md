# TronFlow LoFreq

A nextflow (Di Tommaso, 2017) pipeline implementing the LoFreq (Wilm, 2012) pipeline for somatic variant calling of tumor-normal pairs.



## How to run it

```
$ nextflow run tron-bioinformatics/tronflow-lofreq -profile conda --help

Usage:
    nextflow run tron-bioinformatics/tronflow-lofreq -profile conda --input_files input_files --reference reference.fasta

This workflow is based on the implementation at /code/iCaM/scripts/mutect2_ID.sh

Input:
    * input_files: the path to a tab-separated values file containing in each row the sample name, tumor bam and normal bam
    The input file does not have header!
    Example input file:
    name1	tumor_bam1	normal_bam1
    name2	tumor_bam2	normal_bam2
    * reference: path to the FASTA genome reference (indexes expected *.fai)
    * dbSNP: path to the dbSNP VCF, bgzipped and tabix-indexed. Somatic mutations (ie: SOA=2 and SOA=3) are expected to be filtered out from dbSNP.
    
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



## References

- Di Tommaso, P., Chatzou, M., Floden, E. W., Barja, P. P., Palumbo, E., & Notredame, C. (2017). Nextflow enables reproducible computational workflows. Nature Biotechnology, 35(4), 316–319. https://doi.org/10.1038/nbt.3820
- Benjamin, D., Sato, T., Cibulskis, K., Getz, G., Stewart, C., & Lichtenstein, L. (2019). Calling Somatic SNVs and Indels with Mutect2. BioRxiv. https://doi.org/10.1101/861054
- GATK team. Somatic short variant discovery (SNVs + Indels). Retrieved from https://gatk.broadinstitute.org/hc/en-us/articles/360035894731-Somatic-short-variant-discovery-SNVs-Indels-
- Karczewski, K.J., Francioli, L.C., Tiao, G. et al. The mutational constraint spectrum quantified from variation in 141,456 humans. Nature 581, 434–443 (2020). https://doi.org/10.1038/s41586-020-2308-7