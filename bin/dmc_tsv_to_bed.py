#!/usr/bin/env python3
import argparse

def main():
    parser = argparse.ArgumentParser(description="Convert DMC TSV to BED format right now only working for this specific file due to sample number")
    parser.add_argument("-i", help="Input TSV file", dest="input_file", type=str, required=True)
    parser.add_argument("-o", help="Output BED file", dest="output_file", type=str, required=True)
    args = parser.parse_args()

    with open(args.input_file, "r") as tsv_file, open(args.output_file, "w") as bed_file:
        tsv_file.readline()  # Skip the header line
        for line in tsv_file:
            fields = line.strip().split("\t")
            chrom = fields[7]
            start = fields[8]
            end = fields[9]
            name = "."
            score = float(fields[12])    # q-value
            strand = fields[10]
            thickStart = start
            thickEnd = end
            if score < 0.05:
                itemRgb = "255,0,0"
            else:
                itemRgb = "192,192,192"
            score = str(score)
            bed_file.write(f"{chrom}\t{start}\t{end}\t{name}\t{score}\t{strand}\t{thickStart}\t{thickEnd}\t{itemRgb}\n")

if __name__ == "__main__":
    main()
