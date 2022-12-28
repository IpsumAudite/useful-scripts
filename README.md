# useful-scripts
Scripts and tools to automate common things

### Script List and Descriptions
1. `workspaceUpdater.sh` - loops through every git repo in your workspace and performs a `git pull` on the chosen branch
2. `formatDnsEntries.sh` - converts a DNS entries text file to formatted JSON or HCL
3. `formatDnsEntries.py` - a cleaner, python version of the above bash script
3. `cleanBuckets.py` - removes all objects and versions from the entered bucket (option to delete bucket upon completion)
4. `mattermostAlert.py` - uses AWS Lambda to create an alert sent via webhook to chat software (in this instance, Mattermost)
