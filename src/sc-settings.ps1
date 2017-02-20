<#  
    ----------------------------------------------------------------------------------------------------------------------------------------------------
    Copyright (c) ZHEN YUAN. All rights reserved.

    THIS FOLLOWING SCRIPTION IS FOR CONFIGURING SITECORE CM. 
    SITECORE VERSION 8.2 or later
    USAGE: PUT THE PS1 FILE UNDER SITECORE SITE ROOT AND RUN THE SCCRIPT.
    THIS IS BASED ON THE 
    https://doc.sitecore.net/sitecore_experience_platform/setting_up_and_maintaining/xdb/configuring_servers/configure_a_content_management_server
    
    ----------------------------------------------------------------------------------------------------------------------------------------------------
 <#>
 
# --------------------------------------------------------------------------
# SCRIPT SETTINGS
#
# Example : 
# 
# FOR SERVER ARCHETECTURE CM+PROCESSING+REPORTING x 1  CD x 2
# 
# CM:
# $ConfigCMnProcessing = $TRUE
# $ConfigReportingOnCM =$TRUE
#
# CD:
# $ConfigCD = $TRUE
# --------------------------------------------------------------------------

 # TODO: Getting value from Octopus
 $SitecoreVersion = "v8.2.2"
 
 $ConfigCM = $FALSE
 $ConfigCD = $FALSE
 $ConfigProcessing =$FALSE
 $ConfigCMnProcessing = $FALSE
 $ConfigReportingOnCM =$FALSE
 
 # SITECORE SERVICES
 $DisableGeoIP = $TRUE
 
# --------------------------------------------------------------------------
# STEP - 1 
# Backup APP config files
# --------------------------------------------------------------------------

$source = $PSScriptRoot + "\App_Config"
$date = get-date -format yyyy-MM-dd_HH-mm-ss
$destination = $PSScriptRoot + "\temp\app_config" + $date + ".zip"
$appinclude = $source + "\include\"
$reportdashboard = "\sitecore\shell\Applications\Reports\Dashboard\"

Write-Host "current source file path is $source"

Add-Type -assembly "system.io.compression.filesystem"
[io.compression.zipfile]::CreateFromDirectory($source, $destination)

#---------------------------------------------------------------------------
# Disable GeoIp functionality completely
# SET DisableGeoIP = True to disable the GeoIP completely. 
#---------------------------------------------------------------------------
If ($DisableGeoIP) {

    Write-Host "Start to disable GeoIp functionality for version $SitecoreVersion"

    $ces = $source +  "\include\CES\"

    $array = @(
                 $ces + "Sitecore.CES.config",
                 $ces + "Sitecore.CES.DeviceDetection.config",
                 $ces + "Sitecore.CES.DeviceDetection.CheckInitialization.config",
                 $ces + "Sitecore.CES.GeoIp.config"
               )

    foreach ($element in $array) {   

        If (Test-Path $element) {

            Rename-Item  $element $element + ".disabled"
        }

        Write-Host "File $element has been disabled"
    }
}

#---------------------------------------------------------------------------
# Configure CM server
#---------------------------------------------------------------------------
If ($ConfigCM){

    Write-Host "Start to config CM server for version $SitecoreVersion"

    switch ($SitecoreVersion) {
            
            "v8.2.2" {   
               
               $array = @(
                          # Marketing Foundation
                          $appinclude + "Sitecore.Analytics.Oracle.config",
                          $appinclude + "Sitecore.Analytics.Processing.Aggregation.Services.config",
                          $appinclude + "Sitecore.Analytics.Processing.Services.config",
                          $appinclude + "Sitecore.Analytics.Tracking.Aggregation.config",
                          $appinclude + "Sitecore.Analytics.Tracking.Database.config",
                          $appinclude + "Sitecore.Analytics.Tracking.Database.ScaledCM.config",
                          $appinclude + "Sitecore.Analytics.Tracking.RobotDetection.config",
                          $appinclude + "Sitecore.Marketing.Definitions.MarketingAssets.Repositories.Lucene.Index.Web.config",
                          $appinclude + "Sitecore.EngagementAutomation.Processing.Aggregation.Services.config",
                          $appinclude + "Sitecore.Marketing.Definitions.MarketingAssets.Repositories.Lucene.Index.Web.config",
                          $appinclude + "Sitecore.Marketing.Definitions.MarketingAssets.Repositories.Solr.Index.Web.config",
                          $appinclude + "Sitecore.Marketing.Definitions.MarketingAssets.Repositories.Azure.Index.Web.config",
                          $appinclude + "Sitecore.Marketing.Definitions.MarketingAssets.RepositoriesCD.config",
                          $appinclude + "Sitecore.Marketing.Lucene.Index.Web.config",
                          $appinclude + "Sitecore.Marketing.Lucene.IndexConfiguration.config",
                          $appinclude + "Sitecore.Marketing.Solr.Index.Web.config",
                          $appinclude + "Sitecore.Marketing.Azure.Index.Web.config",
                          $appinclude + "Sitecore.Marketing.TaxonomyCD.config",
                          $appinclude + "Sitecore.MarketingCD.config",
                          $appinclude + "Sitecore.MarketingReportingRole.config",
                          $appinclude + "Sitecore.Xdb.Remote.Server.config",
                          $appinclude + "Sitecore.Xdb.Remote.Server.MarketingAssets.config",

                          # Path Analyzer
                          $appinclude + "Sitecore.PathAnalyzer.Processing.config",
                          $appinclude + "Sitecore.PathAnalyzer.Services.RemoteServer.config",

                          # Platform
                          $appinclude + "Sitecore.PipelineProfiling.config",
                          $appinclude + "SitecoreSettings.config.example",
                          $appinclude + "SiteDefinition.config.example",
                          $appinclude + "SwitchingManagers.config.example",
                          $appinclude + "WebDeploy.config.example",
                          $appinclude + "XslExtension.config.example",
                          $appinclude + "Z.SwitchMasterToWeb\SwitchMasterToWeb.config.example",
                          
                          # Platform - Publishing
                          $appinclude + "Sitecore.Publishing.DedicatedInstance.config.example",
                          $appinclude + "Sitecore.Publishing.EventProvider.Async.config",
                          $appinclude + "Sitecore.Publishing.Optimizations.config.example",
                          $appinclude + "Sitecore.Publishing.Parallel.config",
                          $appinclude + "Sitecore.Publishing.Recovery.config.example",

                          # Platform - Search
                          $appinclude + "Sitecore.ContentSearch.Lucene.Index.Web.config",
                          $appinclude + "Sitecore.ContentSearch.Lucene.Indexes.Sharded.Core.config.example",
                          $appinclude + "Sitecore.ContentSearch.Lucene.Indexes.Sharded.Master.config.example",
                          $appinclude + "Sitecore.ContentSearch.Solr.Index.Web.config.example",
                          $appinclude + "Sitecore.ContentSearch.SolrCloud.SwitchOnRebuild.config.example",
                          $appinclude + "Sitecore.ContentSearch.Azure.Index.Web.config",
                          $appinclude + "Sitecore.ContentSearch.VerboseLogging.config.example",

                          # Experience Analytics
                          $appinclude + "ExperienceAnalytics\Sitecore.ExperienceAnalytics.Aggregation.config",
                          $appinclude + "ExperienceAnalytics\Sitecore.ExperienceAnalytics.Reduce.config",
                          $appinclude + "ExperienceAnalytics\Sitecore.ExperienceAnalytics.StorageProviders.config",
                          $appinclude + "ExperienceAnalytics\Sitecore.ExperienceAnalytics.ReAggregation.config",
                          $appinclude + "ExperienceAnalytics\Sitecore.ExperienceAnalytics.ReAggregation.Scheduling.config",

                          # Social
                          $appinclude + "Social\Sitecore.Social.Klout.config.disabled",
                          $appinclude + "Social\Sitecore.Social.Lucene.Index.Web.config",
                          $appinclude + "Social\Sitecore.Social.Solr.Index.Web.config",
                          $appinclude + "Social\Sitecore.Social.Azure.Index.Web.config",

                          # xDB Cloud
                          $appinclude + "XdbCloud\Sitecore.Cloud.Xdb.config",
                          $appinclude + "XdbCloud\Sitecore.ContentSearch.Cloud.DefaultIndexConfiguration.config",
                          $appinclude + "XdbCloud\Sitecore.ContentSearch.Cloud.Index.Analytics.config",

                          # Exec Insight Dashboard
                          $reportdashboard + "CampaignCategoryDefaultSettings.config",
                          $reportdashboard + "Configuration.config",
                          $reportdashboard + "DefaultSettings.config",
                          $reportdashboard + "SingleCampaignDefaultSettings.config",
                          $reportdashboard + "SingleTrafficTypeDefaultSettings.config",

                          # Content Testing
                          $appinclude + "ContentTesting\Sitecore.ContentTesting.Processing.Aggregation.config"
                          
                         )

                foreach ($element in $array) {   

                    If (Test-Path $element) {

                        Rename-Item  $element $element + ".disabled"
                    }

                    Write-Host "File $element has been disabled"
                }
            }
    
    }
}

#---------------------------------------------------------------------------
# Configure CD server
#---------------------------------------------------------------------------
If ($ConfigCD){

    Write-Host "Start to config CD server for version $SitecoreVersion"

    switch ($SitecoreVersion) {

        "v8.2.2" {

            $array = @(
                        # SPEAK
                        $appinclude + "001.Sitecore.Speak.Important.config",
                        $appinclude + "Sitecore.Speak.AntiCsrf.SheerUI.config",
                        $appinclude + "Sitecore.Speak.Applications.config",
                        $appinclude + "Sitecore.Speak.Components.AntiCsrf.config",
                        $appinclude + "Sitecore.Speak.Components.Mvc.config",
                        $appinclude + "Sitecore.Speak.Components.config",
                        $appinclude + "Sitecore.Speak.config",
                        $appinclude + "Sitecore.Speak.ContentSearch.Lucene.config",
                        $appinclude + "Sitecore.Speak.ContentSearch.Solr.config.example",
                        $appinclude + "Sitecore.Speak.ContentSearch.Azure.config",
                        $appinclude + "Sitecore.Speak.ItemWebApi.config",
                        $appinclude + "Sitecore.Speak.LaunchPad.config",
                        $appinclude + "Sitecore.Speak.Mvc.config",
                        
                        # Platform
                        $appinclude + "EventHandler.config.example",
                        $appinclude + "ForwardingSecurityEvents.config.example",
                        $appinclude + "ja-JP.config.example",
                        $appinclude + "LiveMode.config.example",
                        $appinclude + "Sitecore.Buckets.WarmupQueries.config.example",
                        $appinclude + "Sitecore.PipelineProfiling.config",
                        $appinclude + "Sitecore.Processing.config",
                        $appinclude + "Sitecore.WebDAV.config",
                        $appinclude + "SitecoreSettings.config.example",
                        $appinclude + "SiteDefinition.config.example",
                        $appinclude + "SwitchingManagers.config.example",
                        $appinclude + "WebDeploy.config.example",
                        $appinclude + "XslExtension.config.example",
                        
                        # Marketing Foundation
                        $appinclude + "Sitecore.Analytics.Oracle.config",
                        $appinclude + "Sitecore.Analytics.Processing.Aggregation.config",
                        $appinclude + "Sitecore.Analytics.Processing.Aggregation.Services.config",
                        $appinclude + "Sitecore.Analytics.Processing.config",
                        $appinclude + "Sitecore.Analytics.Processing.Services.config",
                        $appinclude + "Sitecore.Analytics.Reporting.config",
                        $appinclude + "Sitecore.Analytics.Tracking.Database.ScaledCM.config",
                        $appinclude + "Sitecore.EngagementAutomation.Processing.Aggregation.config",
                        $appinclude + "Sitecore.EngagementAutomation.Processing.Aggregation.Services.config",
                        $appinclude + "Sitecore.EngagementAutomation.Processing.config",
                        $appinclude + "Sitecore.EngagementAutomation.TimeoutProcessing.config",
                        $appinclude + "Sitecore.Marketing.Client.config",
                        $appinclude + "Sitecore.Marketing.Definitions.MarketingAssets.Repositories.Lucene.Index.Master.config",
                        $appinclude + "Sitecore.Shell.MarketingAutomation.config",
                        $appinclude + "Sitecore.Xdb.Remote.Client.config",
                        $appinclude + "Sitecore.Xdb.Remote.Client.MarketingAssets.config",
                        $appinclude + "Sitecore.Xdb.Remote.Server.config",
                        $appinclude + "Sitecore.Xdb.Remote.Server.MarketingAssets.config",
                                                
                                                
                        # Platform - Search
                        $appinclude + "Sitecore.ContentSearch.Lucene.Index.Master.config",
                        $appinclude + "Sitecore.ContentSearch.Lucene.Indexes.Sharded.Core.config.example",
                        $appinclude + "Sitecore.ContentSearch.Lucene.Indexes.Sharded.Master.config.example",
                        $appinclude + "Sitecore.ContentSearch.Lucene.Indexes.Sharded.Web.config.example",
                        $appinclude + "Sitecore.ContentSearch.Solr.Index.Core.config.example",
                        $appinclude + "Sitecore.ContentSearch.Solr.Index.Master.config.example",
                        $appinclude + "Sitecore.ContentSearch.SolrCloud.SwitchOnRebuild.config.example",
                        $appinclude + "Sitecore.ContentSearch.Azure.Index.Master.config",
                        $appinclude + "Sitecore.Marketing.Definitions.MarketingAssets.Repositories.Solr.Index.Master.config",
                        $appinclude + "Sitecore.Marketing.Definitions.MarketingAssets.Repositories.Azure.Index.Master.config",
                        $appinclude + "Sitecore.Marketing.Lucene.Index.Master.config",
                        $appinclude + "Sitecore.Marketing.Lucene.IndexConfiguration.config",
                        $appinclude + "Sitecore.Marketing.Solr.Index.Master.config",
                        $appinclude + "Sitecore.Marketing.Azure.Index.Master.config",
                        $appinclude + "Sitecore.MarketingProcessingRole.config",
                        $appinclude + "Sitecore.MarketingReportingRole.config",

                        # Platform - Publishing
                        $appinclude + "Sitecore.Publishing.DedicatedInstance.config.example",
                        $appinclude + "Sitecore.Publishing.EventProvider.Async.config",
                        $appinclude + "Sitecore.Publishing.Optimizations.config.example",
                        $appinclude + "Sitecore.Publishing.Parallel.config",
                        $appinclude + "Sitecore.Publishing.Recovery.config.example",

                        # Path Analyzer
                        $appinclude + "Sitecore.PathAnalyzer.Client.config",
                        $appinclude + "Sitecore.PathAnalyzer.config",
                        $appinclude + "Sitecore.PathAnalyzer.Processing.config",
                        $appinclude + "Sitecore.PathAnalyzer.RemoteClient.config",
                        $appinclude + "Sitecore.PathAnalyzer.RemoteClient.config",
                        $appinclude + "Sitecore.PathAnalyzer.Services.config",
                        $appinclude + "Sitecore.PathAnalyzer.Services.RemoteServer.config",
                        $appinclude + "Sitecore.PathAnalyzer.StorageProviders.config",
                        
                        # Experience Analytics
                        $appinclude + "Sitecore.ExperienceAnalytics.config",
                        $appinclude + "ExperienceAnalytics\Sitecore.ExperienceAnalytics.Aggregation.config",
                        $appinclude + "ExperienceAnalytics\Sitecore.ExperienceAnalytics.Client.config",
                        $appinclude + "ExperienceAnalytics\Sitecore.ExperienceAnalytics.Reduce.config",
                        $appinclude + "ExperienceAnalytics\Sitecore.ExperienceAnalytics.StorageProviders.config",
                        $appinclude + "ExperienceAnalytics\Sitecore.ExperienceAnalytics.WebAPI.config",
                        $appinclude + "ExperienceAnalytics\Sitecore.ExperienceAnalytics.ReAggregation.config",
                        $appinclude + "ExperienceAnalytics\Sitecore.ExperienceAnalytics.ReAggregation.Scheduling.config",

                        # Experience Profile
                        $appinclude + "ExperienceProfile\Sitecore.ExperienceProfile.Client.config",
                        $appinclude + "ExperienceProfile\Sitecore.ExperienceProfile.config",
                        $appinclude + "ExperienceProfile\Sitecore.ExperienceProfile.Reporting.config",
                        
                        # FXM
                        $appinclude + "FXM\Sitecore.FXM.Lucene.DomainsSearch.Index.Master.config",
                        $appinclude + "FXM\Sitecore.FXM.Solr.DomainsSearch.Index.Master.config",
                        $appinclude + "FXM\Sitecore.FXM.Speak.config",
                        $appinclude + "FXM\Sitecore.FXM.Azure.DomainsSearch.Index.Master.config",

                        # List Management
                        $appinclude + "ListManagement\Sitecore.ListManagement.Client.config",
                        $appinclude + "ListManagement\Sitecore.ListManagement.config",
                        $appinclude + "ListManagement\Sitecore.ListManagement.DisableListLocking.config",
                        $appinclude + "ListManagement\Sitecore.ListManagement.Lucene.Index.List.config",
                        $appinclude + "ListManagement\Sitecore.ListManagement.Lucene.IndexConfiguration.config",
                        $appinclude + "ListManagement\Sitecore.ListManagement.Services.config",
                        $appinclude + "ListManagement\Sitecore.ListManagement.Solr.Index.List.config",
                        $appinclude + "ListManagement\Sitecore.ListManagement.Solr.IndexConfiguration.config",
                        $appinclude + "ListManagement\Sitecore.ListManagement.Azure.Index.List.config",
                        $appinclude + "ListManagement\Sitecore.ListManagement.Azure.IndexConfiguration.config",
                        
                        # Social
                        $appinclude + "Social\Sitecore.Social.ExperienceProfile.config",
                        $appinclude + "Social\Sitecore.Social.Klout.config",
                        $appinclude + "Social\Sitecore.Social.Lucene.Index.Master.config",
                        $appinclude + "Social\Sitecore.Social.Lucene.Index.Master.config",

                        # Exec Insight Dashboard
                        $reportdashboard + "CampaignCategoryDefaultSettings.config",
                        $reportdashboard + "Configuration.config",
                        $reportdashboard + "DefaultSettings.config",
                        $reportdashboard + "SingleCampaignDefaultSettings.config",
                        $reportdashboard + "Sitecore.Social.Solr.Index.Master.config",
                        $reportdashboard + "Sitecore.Social.Azure.Index.Master.config",

                        # xDB Cloud
                        $appinclude + "XdbCloud\Sitecore.Cloud.Xdb.config",
                        $appinclude + "XdbCloud\Sitecore.ContentSearch.Cloud.DefaultIndexConfiguration.config",
                        $appinclude + "XdbCloud\Sitecore.ContentSearch.Cloud.Index.Analytics.config",

                        # Content Testing
                        $appinclude + "ContentTesting\Sitecore.ContentTesting.ApplicationDependencies.config",
                        $appinclude + "ContentTesting\Sitecore.ContentTesting.Client.RulePerformance.config",
                        $appinclude + "ContentTesting\Sitecore.ContentTesting.Lucene.IndexConfiguration.config",
                        $appinclude + "ContentTesting\Sitecore.ContentTesting.PreemptiveScreenshot.config",
                        $appinclude + "ContentTesting\Sitecore.ContentTesting.Processing.Aggregation.config",
                        $appinclude + "ContentTesting\Sitecore.ContentTesting.Solr.IndexConfiguration.config",
                        $appinclude + "ContentTesting\Sitecore.ContentTesting.Azure.IndexConfiguration.config"
                      )
            
            foreach ($element in $array) {   

                    If (Test-Path $element) {

                        Rename-Item  $element $element + ".disabled"
                    }

                    Write-Host "File $element has been disabled"
            }
        }
     }
}

#---------------------------------------------------------------------------
# Configure CM + Processing server
#---------------------------------------------------------------------------
If($ConfigCMnProcessing){

     Write-Host "Start to config CM + Processing server for version $SitecoreVersion"

     switch ($SitecoreVersion) {
        
        "v8.2.2" { 

         $array =@(

                    # Marketing Foundation
                    $appinclude + "Sitecore.Analytics.Oracle.config",
                    $appinclude + "Sitecore.Analytics.Tracking.Aggregation.config",
                    $appinclude + "Sitecore.Analytics.Tracking.Database.config",
                    $appinclude + "Sitecore.Analytics.Tracking.Database.ScaledCM.config",
                    $appinclude + "Sitecore.Analytics.Tracking.RobotDetection.config",
                    $appinclude + "Sitecore.Marketing.Definitions.MarketingAssets.Repositories.Lucene.Index.Web.config",
                    $appinclude + "Sitecore.Marketing.Definitions.MarketingAssets.Repositories.Solr.Index.Web.config",
                    $appinclude + "Sitecore.Marketing.Definitions.MarketingAssets.Repositories.Azure.Index.Web.config",
                    $appinclude + "Sitecore.Marketing.Definitions.MarketingAssets.RepositoriesCD.config",
                    $appinclude + "Sitecore.Marketing.Lucene.Index.Web.config",
                    $appinclude + "Sitecore.Marketing.Lucene.IndexConfiguration.config",
                    $appinclude + "Sitecore.Marketing.Solr.Index.Web.config",
                    $appinclude + "Sitecore.Marketing.Azure.Index.Web.config",
                    $appinclude + "Sitecore.Marketing.TaxonomyCD.config",
                    $appinclude + "Sitecore.MarketingCD.config",
                    $appinclude + "Sitecore.MarketingReportingRole.config",
                    $appinclude + "Sitecore.MarketingProcessingRole.config",
                    $appinclude + "Sitecore.MarketingReportingRole.config",
                    $appinclude + "Sitecore.Xdb.Remote.Client.config",
                    $appinclude + "Sitecore.Xdb.Remote.Server.MarketingAssets.config",
                    $appinclude + "Sitecore.Xdb.Remote.Server.config",
                    $appinclude + "Sitecore.Xdb.Remote.Server.MarketingAssets.config",


                    # Path Analyzer
                    $appinclude + "Sitecore.PathAnalyzer.Services.RemoteServer.config",

                    # Platform
                    $appinclude + "EventHandler.config.example",
                    $appinclude + "ForwardingSecurityEvents.config.example",
                    $appinclude + "ja-JP.config.example",
                    $appinclude + "LiveMode.config.example",
                    $appinclude + "Sitecore.Buckets.WarmupQueries.config.example",
                    $appinclude + "Sitecore.PipelineProfiling.config",
                    $appinclude + "SitecoreSettings.config.example",
                    $appinclude + "SiteDefinition.config.example",
                    $appinclude + "SwitchingManagers.config.example",
                    $appinclude + "WebDeploy.config.example",
                    $appinclude + "XslExtension.config.example"
                    $appinclude + "Z.SwitchMasterToWeb\SwitchMasterToWeb.config.example",
                          
                    # Platform - Publishing
                    $appinclude + "Sitecore.Publishing.DedicatedInstance.config.example",
                    $appinclude + "Sitecore.Publishing.EventProvider.Async.config",
                    $appinclude + "Sitecore.Publishing.Optimizations.config.example",
                    $appinclude + "Sitecore.Publishing.Parallel.config",
                    $appinclude + "Sitecore.Publishing.Recovery.config.example",

                    # Platform - Search
                    $appinclude + "Sitecore.ContentSearch.Lucene.Index.Web.config",
                    $appinclude + "Sitecore.ContentSearch.Lucene.Indexes.Sharded.Core.config.example",
                    $appinclude + "Sitecore.ContentSearch.Lucene.Indexes.Sharded.Master.config.example",
                    $appinclude + "Sitecore.ContentSearch.Lucene.Indexes.Sharded.Web.config.example",
                    $appinclude + "Sitecore.ContentSearch.Solr.Index.Web.config.example",
                    $appinclude + "Sitecore.ContentSearch.SolrCloud.SwitchOnRebuild.config.example",
                    $appinclude + "Sitecore.ContentSearch.Azure.Index.Web.config",
                    $appinclude + "Sitecore.ContentSearch.VerboseLogging.config.example",

                    # Experience Analytics
                    $appinclude + "ExperienceAnalytics\Sitecore.ExperienceAnalytics.Reduce.config",
                    $appinclude + "ExperienceAnalytics\Sitecore.ExperienceAnalytics.ReAggregation.Scheduling.config",
                    
                    # List Management
                    $appinclude + "ListManagement\Sitecore.ListManagement.DisableListLocking.config",
                                                           
                    # Social
                    $appinclude + "Social\Sitecore.Social.Klout.config.disabled",
                    $appinclude + "Social\Sitecore.Social.Lucene.Index.Web.config",
                    $appinclude + "Social\Sitecore.Social.Solr.Index.Web.config",
                    $appinclude + "Social\Sitecore.Social.Azure.Index.Web.config",

                    # xDB Cloud
                    $appinclude + "XdbCloud\Sitecore.Cloud.Xdb.config",
                    $appinclude + "XdbCloud\Sitecore.ContentSearch.Cloud.DefaultIndexConfiguration.config",
                    $appinclude + "XdbCloud\Sitecore.ContentSearch.Cloud.Index.Analytics.config",

                    # Exec Insight Dashboard
                    $reportdashboard + "CampaignCategoryDefaultSettings.config",
                    $reportdashboard + "Configuration.config",
                    $reportdashboard + "DefaultSettings.config",
                    $reportdashboard + "SingleCampaignDefaultSettings.config",
                    $reportdashboard + "SingleTrafficTypeDefaultSettings.config"
                )            
                         
         foreach ($element in $array) {   

                    If (Test-Path $element) {

                        Rename-Item  $element $element + ".disabled"
                    }

                    Write-Host "File $element has been disabled"
            }
        }
    }
}

#---------------------------------------------------------------------------
# Configure Processing server
#---------------------------------------------------------------------------
If($ConfigProcessing){

    Write-Host "Start to config Processing server for version $SitecoreVersion"

     switch ($SitecoreVersion) {
        
        "v8.2.2" { 

         $array =@(
                
            )            
                         
         foreach ($element in $array) {   

                    If (Test-Path $element) {

                        Rename-Item  $element $element + ".disabled"
                    }

                    Write-Host "File $element has been disabled"
            }
        }
    }
}

#---------------------------------------------------------------------------
# Configure Reporting server on CM
#---------------------------------------------------------------------------
If($ConfigReportingOnCM){
    
    Write-Host "Start to config Reporting server for version $SitecoreVersion"

     switch ($SitecoreVersion) {
        
        "v8.2.2" { 

        $array =@(

                    # Marketing Foundation
                    $appinclude + "Sitecore.MarketingReportingRole.config",
                    $appinclude + "Sitecore.Xdb.Remote.Server.config",
                    $appinclude + "Sitecore.Xdb.Remote.Server.MarketingAssets.config",
                    
                    # Path Analyzer
                    $appinclude + "Sitecore.PathAnalyzer.Services.RemoteServer.config",

                    # Experience Analytics
                    $appinclude + "ExperienceAnalytics\Sitecore.ExperienceAnalytics.Reduce.config",
                    $appinclude + "ExperienceAnalytics\Sitecore.ExperienceAnalytics.ReAggregation.Scheduling.config"
                )             
                         
         foreach ($element in $array) {   

                    If (Test-Path $element + ".disabled") {

                        Rename-Item  $element + ".disabled" $element
                    }

                    Write-Host "File $element has been enabled for reporing server"
            }
        }
    }
}

