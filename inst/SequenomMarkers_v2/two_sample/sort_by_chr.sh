#! /bin/sh

#Created July 30, 2013
#Modified July 30, 2013
#Author: Laurie Stevison
#can be downloaded via: git clone git://github.com/lstevison/random-scripts/
#citation DOI: http://dx.doi.org/10.5281/zenodo.10287

#program sorts long bed files with multiple chromosomes by chr

#Command line object 1: file with list of chromosomes
#if wanted to remove this step: awk '{print $1}' $1 | uniq #assumes sorted file
#Command line object 2: input filename
#Command line object 3: output filename

if [ $# -eq 3 ]; then
    echo "Now splitting $2 into separate chromosomes based on $1, and outputting sorted and combined results into $3.
"
else
    echo "Error: Plase provide on command line 1) file list with chromosome names, 2) input filename, and 3) output filename.
"
    exit 1
fi

if [ -f $3 ]; then
        echo -n "Output file exists. Overwrite? (y/n) > "
        read response
        if [ "$response" == "y" ]; then
	    rm $3
        else
	    echo 'Now exiting program.'
	    exit 1
	fi
fi 

filesize="$(wc -l $1 | awk '{print $1}')"

for i in $(eval echo {1..$filesize})
do
    chr="$(awk "NR==${i} {print \$0}" $1)"
    awk "\$1==\"$chr\" {print \$0}" $2 >$chr.txt
    sort -k2n $chr.txt >>$3
    rm $chr.txt
done

echo "Done."
