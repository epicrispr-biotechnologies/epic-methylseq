process METHYLKIT {
    label "process_medium"

    conda "${moduleDir}/environment.yml"
    container "075615082992.dkr.ecr.us-west-2.amazonaws.com/methylkit:latest"

    input:
    val qualimap_output
    path samplesheet
    path bismark_cov_dir
    val genome_assembly
    path chromhmm
    path ccre
    path blacklist
    val user
    val study

    output:
    path "*.html", emit: report
    path "*.tsv", emit: methylkit_tsv

    script:
    """
    Rscript -e "rmarkdown::render(
        '//nextflow-bin/methylkit.rmd',
        output_file = '${study}_methylkit.html',
        output_dir = '\${PWD}',
        params = list(
            study = '${study}',
            user = '${user}',
            metadata_path = '\${PWD}/${samplesheet}',
            bismark_path = '\${PWD}/${bismark_cov_dir}',
            out_path = '\${PWD}',
            assembly = '${genome_assembly}',
            gtf_path = <add the path to the gtf here>,
            ccre_path = '\${PWD}/${ccre}',
            blacklist_path = '\${PWD}/${blacklist}'
        )
    )"

    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        r-base: \$(echo \$(R --version n 2>&1) | sed 's/^.*R version //; s/ .*\$//')
        bioconductor-methylKit: \$(Rscript -e "library(methylKit); cat(as.character(packageVersion('methylKit')))")
    END_VERSIONS
    """
}