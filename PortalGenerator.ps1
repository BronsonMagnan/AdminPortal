#Admin Portal Generator
    param(
        [parameter(Mandatory)][validateNotNullOrEmpty()][string]$ConfigFile,
        [parameter(Mandatory)][validateNotNullOrEmpty()][string]$WebSiteFile
    )


class HTMLImageLink {
    [string]$ALTText
    [string]$URI
    [string]$Image
    hidden [boolean]$NewTab
    HTMLImageLink ([string]$ALTText,[string]$URI,[string]$Image,[boolean]$NewTab){
        $this.ALTText = $ALTText
        $this.URI = $URI
        $this.Image = $Image
        $this.NewTab = $NewTab
    }
    [string]GetTargetCode(){
        if ($this.NewTab) { return ' target="_blank"'} else { return ""}
    }
    [string]GetHTML(){
        return "<a href=`"$($this.URI)`"$($this.GetTargetCode())><img src=`"$($this.Image)`" class=`"grid-icon`" alt=`"$($this.ALTText)`"></a>"
    }
}
 
class AdminPortalItem : HTMLImageLink{
    [string]$Category    
    AdminPortalItem([string]$Category,[string]$Label,    [string]$Image,    [string]$URI) : base ($Label,$URI,$Image,$true){
        $this.Category = $Category
    }
    [string[]]GetHTML() {
        $build = @()
        $build += ' <div class="grid-item">'
        $build += $('   ' + ([HTMLImageLink]$this).GetHTML() )
        $build += '  <p class="grid-label">' + $this.ALTText + '</p>'
        $build += ' </div>'
        return $build
    }
    
}

class AdminPortalPage {
    [AdminPortalItem[]]$Database
    AdminPortalPage(){
    }
    [void]AddRecord([AdminPortalItem]$Record){
        $this.Database += $Record
    }
    [AdminPortalItem[]]GetRecordsByCategory([string]$key){
        return $this.Database.where({$_.Category -eq $key})
    }
    [string[]]EncapsulateCategory([string]$key){
        [AdminPortalItem[]]$recordSet = $this.GetRecordsByCategory($key)
        $build = @()
        $build += '<p class="grid-container-label">' + $key + '</p>'
        $build += '<div class="grid-container">'
        foreach ($Record in $recordSet) {
            $build += $record.GetHTML()
        }
        $build += '</div>'
        return $build
    }
    [string[]]GetAllCategoriesInSet(){
        return ($this.Database).Category | Sort-Object | Select-Object -Unique
    }
    [string[]]GetHtml() {
        $Build = @()
        $build += '<!DOCTYPE html>'
        $build += '<html>'
        $build += '<head>'
        $build += '<link rel="stylesheet" type="text/css" href="index.css">'
        $build += '</head>'
        $build += '<body>'
        foreach ($Category in $this.GetAllCategoriesInSet()) {
            $build += $this.EncapsulateCategory($Category)
        }
        $build += '</body>'
        $build += '</html>'
        return $Build
    }
}


    $DB = [AdminPortalPage]::new()

    $LoadConfig = get-content -Path $ConfigFile | Convertfrom-csv 
    foreach ($Config in $LoadConfig){
        $DB.AddRecord([AdminPortalItem]::new($config.Category,$config.ALTText,$config.Image,$config.URI))
    }

    $db.GetHtml() | Set-Content -Path $WebSiteFile
