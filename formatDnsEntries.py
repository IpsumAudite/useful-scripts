import sys
import json

# Define variables
dns_entries_file=(str(sys.argv[1]))
a_record_type="A"
cname_record_type="CNAME"
json_output_file="DNSentries.json"
ttl=60
name_ending=".test.domain.com"
action="UPSTART"
dict_to_convert={
                    "Comment": "DNS Entries to update",
                    "Changes": []
                }

def convertToJson (record_type):
    with open(dns_entries_file) as dns_file:
        for line in dns_file:
            # If the current line's type in the DNS record file equals the argument that was passed, 
            # then parse out the needed info (name, type, ttl, records) and write to a file
            split_dict=line.split()
            if len(split_dict)>4:
                if record_type == split_dict[3]:
                    dict_to_convert["Changes"].append({"Action": action, "ResourceRecordSet": {"Name": split_dict[0]+name_ending, "ResourceRecords": [{"Value": split_dict[4]}], "TTL": ttl, "Type": split_dict[3]}})

convertToJson(a_record_type)
convertToJson(cname_record_type)

# Serializing json
json_object = json.dumps(dict_to_convert, separators=(',', ':'), indent=4)
 
# Writing to json file
with open(json_output_file, "w") as outfile:
    outfile.write(json_object)
