#!/bin/bash

# Read the domain name
echo "Enter the domain name:"
read domain_name

# Convert the records
while IFS= read -r line
do
    # Extract the record details
    record_type=$(echo $line | cut -c1)
    record_domain=$(echo $line | cut -d':' -f1 | sed 's/^.//')
    record_value=$(echo $line | cut -d':' -f2)

    # Check if the record is for the inputted domain
    if [[ $record_domain == *"$domain_name"* ]]; then
        # Convert to Route53 format and write to output file
        case $record_type in
            ".")
                echo "$record_domain. 300 NS $record_value" >> route53_records.txt
                echo "$record_domain. 300 SOA $record_value" >> route53_records.txt
                ;;
            "@")
                echo "$record_domain. 300 MX $record_value" >> route53_records.txt
                ;;
            "=")
                echo "$record_domain. 300 A $record_value" >> route53_records.txt
                echo "$record_value. 300 PTR $record_domain." >> route53_records.txt
                ;;
            "+")
                echo "$record_domain. 300 A $record_value" >> route53_records.txt
                ;;
            "^")
                echo "$record_value. 300 PTR $record_domain." >> route53_records.txt
                ;;
            "C")
                echo "$record_domain. 300 CNAME $record_value" >> route53_records.txt
                ;;
        esac
    fi
done < "data"

echo "Conversion completed. The Route53 compatible records are in route53_records.txt."
