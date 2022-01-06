cat <<'EOT'>> MR_reverse.sh
#!/bin/bash
#SBATCH -c 8
#SBATCH --mem-per-cpu=9G
#SBATCH -t 72:00:00

while IFS=$'\t' read -r -a myArray

do

  trimmedfile="$(echo -e "${myArray[1]}" | tr -d '[:space:]')"


  sh mass_mr.sh $trimmedfile ${myArray[0]}


done < list.txt

EOT

cat <<'EOT'>> mass_mr.sh
#!/bin/bash
#SBATCH -n 8
#SBATCH --mem-per-cpu=9G
#SBATCH -t 72:00:00

name=$2
code=$1

echo ''${name} ${code}'' > marker.txt
echo ''$code'' > marker_name.txt
sbatch -p brc mr_script.sh
while : ; do
    [[ -f "flag.txt" ]] && break
    echo "Pausing until file exists."
    sleep 1
done
sleep 3m

EOT

cat <<'EOT'>> mr_script.sh
#!/bin/bash
#SBATCH -n 8
#SBATCH --mem-per-cpu=9G
#SBATCH -t 72:00:00

export MKL_NUM_THREADS=8
export NUMEXPR_NUM_THREADS=8
export OMP_NUM_THREADS=8

/scratch/groups/ukbiobank/KCL_Data/Software/gcta_1.92.4beta2/gcta64 \
--bfile \
/scratch/groups/ukbiobank/usr/alish/Project1_meta/1KG_Phase3.WG.CLEANED.EUR_MAF001 \
--gsmr-file \
marker.txt \
covid.txt \
--gsmr-direction 2 \
--effect-plot \
--ref-ld-chr /scratch/groups/ukbiobank/KCL_Data/Software/eur_w_ld_chr_for_mtcojo/ \
--w-ld-chr /scratch/groups/ukbiobank/KCL_Data/Software/eur_w_ld_chr_for_mtcojo/ \
--out ./output/e6 \
--gwas-thresh 5e-6 \
--clump-r2 0.05 \
--heidi-thresh 0.01 \
--gsmr-snp-min 1 \
--diff-freq 1 \
--gsmr-ld-fdr 0.05 \
--thread-num 4
EOT