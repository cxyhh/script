
#!/bin/bash
for INPUT_FILE in "$@"
do
	input_name=$(basename "$INPUT_FILE")
	echo -e "\033[032mINPUT_FILE = $INPUT_FILE\033[0m"
	if [ ! -f "$INPUT_FILE" ]; then
		echo "Error: input file '$INPUT_FILE' does not exist"
		exit
	fi
	OUTPUT_FILE=add_tmp.csv
	if [[ $input_name == ac_* ]]; then 
		echo "ac"
		COLUNMN_NUM=14
	else 
		COLUNMN_NUM=7
	fi
	awk -F ',' -v column="$COLUNMN_NUM" 'BEGIN {OFS=","} {
		if (NR!=1) {
			if ($column !~ /^"/) {
				$column="\""$column"\""
			}
		}
		print
		}' "$INPUT_FILE" > "$OUTPUT_FILE"
		mv -f $OUTPUT_FILE $INPUT_FILE
		rm -rf add_tmp.csv
		chmod 775 $INPUT_FILE
done
echo "done"

