#!/bin/bash

#	Script generates network diagnostics reports based on HTTP requests
#	Requires Apache Benchmark (FOSS)
#
#	Nb. Script will generate logs in the dir where it is executed,
#	If script runs multiple times on the same day the logs will append to the
#	log file specific to that day

# Check requirements:
if ! command -v ab &> /dev/null
then
    echo "Apache Benchmark could not be found, to install: sudo apt-get install apache2-utils"
    exit
fi


# Decare servers here:
declare -a servers=("https://yahoo.com/" 
                    "https://google.com/"
                    "https://www.offensive-security.com/")                   
getDomain() {
    echo $1 | cut -d / -f 3 
}

                    
# Gets current date, uses for file names
d=$(date +%Y-%m-%d)
t=$(date +%T)            
            

# Start tests on servers:
for i in "${servers[@]}"
do    
    domain_string=$(getDomain $i)  
    echo "Testing $domain_string"
    ab -k -n 10000 -c 100 -t 20 $i >> $domain_string_$d.log
    
    # Cut and trim log output for CSV file
    to_csv=$(cat $domain_string_$d.log | grep Total: | tail -1 | awk '{ printf("%d", $3) }')
    [ -z "$to_csv" ] && prod=999
    echo $domain_string,$d,$t,$to_csv, >> NetworkSpeed.csv
done


echo "All tests completed, CSV updated and log files generated"








