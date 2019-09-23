# AdminPortal
Admin Portal Aggregator

In your environment you may have hundreds of the following:
1. Out of band server mangement cards
2. UPS management cards
3. Switches
4. Printers
5. SaaS management portals
6. Self-hosted application management portals

This is a tool to aggregate all of these items together into a single IIS site.

Requirements:
1. IIS server
2. A collection of 64x64 pixel icons to represent each portal, hint: start with a default one, and add them over time.
3. This script that generates the index.htm file
4. The index.css file, which you may retheme to your pleasure.
5. The config.csv file, which contains the information for each portal you want to add. I thought CSV would be the best format because alot of admins have this type of information already stored in Excel.

This script when supplied with a configuration CSV file will create a webpage that aggregates administrative web portals. 

Each record in the CSV is as follows:
1. Category: Which tile set the portal link will be grouped in, i.e. Site:LasVegas, or SaaS_Apps
2. ALTText: This is the text description of the portal link
3. URI: This is the actual webaddress of the portal
4. Image: The relative path to the image file

Put the powershell script in the website folder and run it as a scheduled task, or as needed to refresh the updated CSV.

Sample usage
```.\PortalGenerator.ps1 -ConfigFile .\config.csv -WebSiteFile .\index.html```

Screenshots:
![1](https://github.com/BronsonMagnan/AdminPortal/blob/master/newCSSSamples.png)

