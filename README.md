# DNS Record Converter

This is a Bash script that converts DNS records into a format compatible with Amazon Route53.

## Usage

1. Make sure you have Bash installed on your system.
2. Run the script using the command `./tinydns-to-bind-converter.sh`.
3. When prompted, enter the domain name for which you want to convert the records.
4. The script will read the DNS records from a file named `data` in the same directory. The records should be in the following format:

    ```
    .:ns1.example.com
    @:mail.example.com
    =:www.example.com:192.0.2.1
    +:ftp.example.com:192.0.2.2
    ^:192.0.2.3:api.example.com
    C:blog.example.com:blogs.example.com
    ```

    Each line represents a DNS record. The first character is the record type, followed by a colon, then the domain name, and for some record types, another colon and the IP address.

5. The script will output the converted records to a file named `route53_records.txt` in the same directory.

## Record Types

The script supports the following record types:

- `.`: NS and SOA records. The script will create two records for each line, one NS and one SOA.
- `@`: MX records.
- `=`: A and PTR records. The script will create two records for each line, one A and one PTR.
- `+`: A records.
- `^`: PTR records.
- `C`: CNAME records.

## Note

The script will remove carriage return characters from itself before running. This is to ensure compatibility with different operating systems.
