#!/bin/bash
# Script to convert DNS records in a text file to another format
# Show user how to use the script
function printHelp {
  echo "[INFO] Usage instructions:"
  echo "        ./formatDnsEntries <path/to/dnsFile> <file format>"
  echo "        example: ./formatDnsEntries.sh /Users/bsmith/DNS/db.cnap.dso.mil json"
}

# Validate user input to the script and run main logic
function validateInputParameters {
  # If there are not exactly two arguments, print the help message
  if [ $# -ne 2 ]; then
    echo "[ERROR] Expected a text file and a format as an argument"
    printHelp
    exit
  else
    # Create variables
    DNS_ENTRIES_FILE=$1
    TG_FILE="terragrunt.hcl"
    JSON_FILE="DNSentries.json"
    TTL=60
    ACTION="UPSTART"
    # Run the main script logic, passing the format argument
    mainFunc "$2"
  fi
}

# Find record based on type and convert to JSON
function convertToJSON {
  # Loop through each line of the DNS records file
  while read -r line; do
    # If the current line in the DNS record file equals the argument that was passed, 
    # then parse out the needed info (name, type, ttl, records) and write to a file
    if [ "$(echo "$line" | awk '{print $4}')" = "$1" ]; then
      # Uncomment for logging
      #echo "[INFO] DNS entry being parsed is: $line"
      jq -n '{"Action": $one, "ResourceRecordSet": {"Name": $two, "ResourceRecords": [{"Value": $three}], "TTL": $four, "Type": $five}}' \
        --arg one $ACTION \
        --arg two "$(echo "$line" | awk '{print $1}')" \
        --arg three "$(echo "$line" | awk '{print $5}')" \
        --arg four $TTL \
        --arg five "$(echo "$line" | awk '{print $4}')" \ >> "$JSON_FILE"
    fi
  done <"$DNS_ENTRIES_FILE"
}

# Find record based on type and convert to Terragrunt (HCL)
function convertToTG {
  # Loop through each line of the DNS records file
  while read -r line; do
    # If the current line in the DNS record file equals the argument that was passed, 
    # then parse out the needed info (name, type, ttl, records) and write to a file
    if [ "$(echo "$line" | awk '{print $4}')" = "$1" ]; then
      # Uncomment for logging
      #echo "[INFO] DNS entry being parsed is: $line"
      #TODO: Make this more elegant by using cmd or printf instead of multi-line echos
      echo "{" >> "$TG_FILE"
      echo "name    = \"$(echo "$line" | awk '{print $1}')\"">> "$TG_FILE"
      echo "type    = \"$(echo "$line" | awk '{print $4}')\"" >> "$TG_FILE"
      echo "ttl     = \"$TTL\"" >> "$TG_FILE"
      echo "records = [\"$(echo "$line" | awk '{print $5}')\"]" >> "$TG_FILE"
      echo "}," >> "$TG_FILE"
    fi
  done <"$DNS_ENTRIES_FILE"
}

# Main script logic
function mainFunc {
  # Uncomment for logging
  #echo "[INFO] Text file being used is $DNS_ENTRIES_FILE"
  # If argument passed to script was HCL, then convert DNS entries to HCL
  if [ "$1" = "hcl" ]; then
    # Find and write the A records
    convertToTG "A"
    # Find and write the CNAME records
    convertToTG "CNAME"
  # If argument passed to script was JSON, then convert DNS entries to JSON
  elif [ "$1" = "json" ]; then
    #TODO: Build out the beginning and end of the file
    #TODO: Add commas between object blocks
    # Find and write the A records
    convertToJSON "A"
    # Find and write the CNAME records
    convertToJSON "CNAME"
  else
    echo "[ERROR] Need to enter a valid fomat (json or hcl)"
    echo "         re-run the script with a valid format flag"
    exit 
  fi
}

# Call the validate function to kick off the script
validateInputParameters "$@"
