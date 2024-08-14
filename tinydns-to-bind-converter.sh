#!/bin/bash

# Remove carriage return characters
tr -d '\r' < "$0" > temp.sh && mv temp.sh "$0"

# Read the domain name
echo "Enter the domain name:"
read -r domain_name

# Convert the records
while IFS= read -r line
do
    # Extract the record details using awk
    record_type=$(echo "$line" | awk -F':' '{print substr($1, 1, 1)}')
    record_domain=$(echo "$line" | awk -F':' '{print substr($1, 2)}')
    record_value=$(echo "$line" | awk -F':' '{print $2}')

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
            "'")
                if [[ $record_value == v=spf* ]]; then
                    echo "$record_domain. 300 SPF \"$record_value\"" >> route53_records.txt
                else
                    echo "$record_domain. 300 TXT \"$record_value\"" >> route53_records.txt
                fi
                ;;
            ":")
                echo "$record_domain. 300 SPF \"$record_value\"" >> route53_records.txt
                ;;
        esac
    fi
done < "data"

echo "Conversion completed. The Route53 compatible records are in route53_records.txt."
