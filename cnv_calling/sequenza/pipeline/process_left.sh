#! /bin/bash
# Run under /public/home/wangshx/wangshx/PRAD_Sig

pbs_dir=WES_calling_step2
res_dir=../seqz_wes_result
rm_pbs_out=True  # Remove previous PBS output

cd $pbs_dir
for f in $(ls *.pbs | xargs -n1)
do
	echo "=> Checking file $f..."
	name=$(echo $f | sed 's/\.pbs//')
	check=$(ls -l $res_dir | grep $name)
	if [ -z "$check" ]
	then 
		echo "==> Result is not generated by $f"
		if [ $rm_pbs_out == True ]
		then
			echo "==> Catting pbs standard output and error, then removing this file"
			cat *$name*".o"*
			rm *$name*".o"*
		fi
		echo "==> Run it again, submitting $f"
		qsub $f
	else
		echo "==> Result has been generated for $f"
		echo "==> Skipping..."
	fi
done