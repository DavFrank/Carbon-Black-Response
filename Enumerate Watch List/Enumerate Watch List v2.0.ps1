# Author: David Frank
# Description: This script will query Carbon Black Response and export the Watchlist
#              It will display the information in the console and create a CSV file - WatchList.csv
#              It will also display the total # of wathclist, # enabled & # disabled
#              Note: The CSV can't be used to import back in, it was created for reporting
#
# Version: 1.0 - 01/19/16 - Initial Version
#          1.1 - 04/04/17 - Added TLS info
#          1.2 - 06/12/17 - Added count for enabled / disabled watchlist
#                         - Sort Watchlist by oldest to newest
#          1.3 - 06/12/17 - Added URLDecoding to output
#          1.4 - 07/18/17 - Added output to WathcList.csv
#          2.0 - 05/06/20 - Re-ordered / removed fields for output to csv

Clear-Host

$authToken = $CBToken

$URLResource = "https://${CBServer}/api/v1/watchlist"

[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

$headers = New-Object "System.Collections.Generic.Dictionary[[String],[String]]"
$headers.add("x-auth-token",$authToken)

$watchlists = Invoke-RestMethod -Uri $URLResource -Method Get -Headers $headers

# Display results in the console
$watchlists | sort date_added | Format-Table -Property enabled, name, date_added, last_hit_count, total_hits, @{Name='Search_Query';Expression={([System.Web.HttpUtility]::UrlDecode($_.search_query))}} -AutoSize -Wrap 

# Output results to WatchList.csv
$watchlists | sort date_added | Select-Object enabled, date_added, name, description, @{Name='Search_Query';Expression={([System.Web.HttpUtility]::UrlDecode($_.search_query))}}  | Export-CSV WatchList.csv -NoTypeInformation

"Number of Enabled Watch Lists: $(@($watchlists | ? { $_.enabled -eq “True” }).Count)"
"Number of Disabled Watch Lists: $(@($watchlists | ? { $_.enabled -ne “True” }).Count)"

"Total Number of Watch Lists: $($watchlists.Count)"
""

[void](Read-Host 'Press Enter to continue…')