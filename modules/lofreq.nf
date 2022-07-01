process LOFREQ {
    cpus "${params.cpus}"
    memory "${params.memory}"
    tag "${name}"

    conda (params.enable_conda ? 'bioconda::lofreq=2.1.5' : null)

    input:
    tuple val(name), file(tumor_bam), file(tumor_bai), file(normal_bam), file(normal_bai)

    output:
      tuple val(name),
        file("${name}.somatic_final.snvs.vcf.gz"), file("${name}.somatic_final.snvs.vcf.gz.tbi"),
        file("${name}.somatic_final.indels.vcf.gz"), file("${name}.somatic_final.indels.vcf.gz.tbi"),
        file("${name}.somatic_raw.snvs.vcf.gz"), file("${name}.somatic_raw.snvs.vcf.gz.tbi"),
        file("${name}.somatic_raw.indels.vcf.gz"), file("${name}.somatic_raw.indels.vcf.gz.tbi"),
        file("${name}.tumor_stringent.snvs.vcf.gz"), file("${name}.tumor_stringent.snvs.vcf.gz.tbi"),
        file("${name}.tumor_stringent.indels.vcf.gz"), file("${name}.tumor_stringent.indels.vcf.gz.tbi"),
        file("${name}.normal_stringent.snvs.vcf.gz"), file("${name}.normal_stringent.snvs.vcf.gz.tbi"),
        file("${name}.normal_stringent.indels.vcf.gz"), file("${name}.normal_stringent.indels.vcf.gz.tbi"), emit: vcfs


    script:
    """
    lofreq viterbi -f ${params.reference} ${normal_bam} | lofreq alnqual  -b - ${params.reference} > normal.ready.bam
    samtools index normal.ready.bam

    lofreq viterbi -f ${params.reference} ${tumor_bam} | lofreq alnqual  -b - ${params.reference} > tumor.ready.bam
    samtools index tumor.ready.bam

    lofreq somatic \
    -n normal.ready.bam \
    -t tumor.ready.bam \
    -f ${params.reference} \
    --threads ${task.cpus} -o ${name}.
    """
}

process CONCAT_FILES {
    cpus 1
    memory '4g'
    publishDir "${params.output}/${name}", mode: 'copy'
    tag "${name}"

    conda (params.enable_conda ? "conda-forge::libgcc-ng=10.3.0 conda-forge::gsl=2.7 bioconda::bcftools=1.15.1" : null)

    input:
        tuple val(name),
        file(passed_snvs), file(passed_snvs_idx),
        file(passed_indels), file(passed_indels_idx),
        file(raw_snvs), file(raw_snvs_idx),
        file(raw_indels), file(raw_indels_idx),
        file(tumor_snvs), file(tumor_snvs_idx),
        file(tumor_indels), file(tumor_indels_idx),
        file(normal_snvs), file(normal_snvs_idx),
        file(normal_indels), file(normal_indels_idx)


    output:
        tuple file("${name}.lofreq.somatic.vcf.gz"),
            file("${name}.lofreq.somatic.vcf.gz.tbi"),
            file("${name}.lofreq.somatic.raw.vcf.gz"),
            file("${name}.lofreq.somatic.raw.vcf.gz.tbi"),
            file("${name}.lofreq.tumor_stringent.vcf.gz"),
            file("${name}.lofreq.tumor_stringent.vcf.gz.tbi"),
            file("${name}.lofreq.normal_stringent.vcf.gz"),
            file("${name}.lofreq.normal_stringent.vcf.gz.tbi"),
            emit: vcfs

    """
    bcftools concat --allow-overlaps ${passed_indels} ${passed_snvs} -O z > ${name}.lofreq.somatic.vcf.gz
    tabix -p vcf ${name}.lofreq.somatic.vcf.gz

    bcftools concat --allow-overlaps ${raw_indels} ${raw_snvs} -O z > ${name}.lofreq.somatic.raw.vcf.gz
    tabix -p vcf ${name}.lofreq.somatic.raw.vcf.gz

    bcftools concat --allow-overlaps ${tumor_indels} ${tumor_snvs} -O z > ${name}.lofreq.tumor_stringent.vcf.gz
    tabix -p vcf ${name}.lofreq.tumor_stringent.vcf.gz

    bcftools concat --allow-overlaps ${normal_indels} ${normal_snvs} -O z > ${name}.lofreq.normal_stringent.vcf.gz
    tabix -p vcf ${name}.lofreq.normal_stringent.vcf.gz

  	"""
}
