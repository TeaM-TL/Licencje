# -*-Tcl-*-
## 2007-2014 Tomasz Luczak tlu@temertech.com
# $Id: main.tcl 24 2014-01-13 13:13:19Z tlu $
############################
# Tcl/Tk 8.6.0
############################## SETTINGS
  
############### version
set VERSION "1"
set SUBVERSION "6.14"
set DATE "2014.01.11"

set user ""
catch {set user $env(USERNAME)}
puts $user

set TCLREV [info patchlevel]

set ArchOS "$tcl_platform(os) $tcl_platform(machine)"

set RELEASE "$VERSION.$SUBVERSION $DATE \[$TCLREV"
##########################
package require starkit
starkit::startup
set sourcedir $starkit::topdir
set executable [file tail [info nameofexecutable]]
set cwd [file dirname $sourcedir]

if {[string first "--debug" $argv] ne -1} then {
    set debugInfo 1
} else {
    set debugInfo 0
}
#########
#recognize Windows
if { [string tolower [file extension $executable]] eq ".exe"} then {
    set windows 1
} else {
    # recognize other platform and machine
    set windows 0
}
#########
# packages
package require Tk
append RELEASE ", [package require tile]"
append RELEASE ", [package require sqlite3]"
append RELEASE ", [package require tablelist_tile]\]"
package require autoscroll
package require mentry_tile
package require help
package require msgcat
package require ctext
#package require tooltip
package require inifile
## Setting translations
namespace import ::msgcat::mc
catch {::msgcat::mcload [file join $cwd msgs]}
# directory contains help files
set filehelpdir [file join $cwd help]
### files
# style for tablelist
source "$sourcedir/option_tile.tcl"
# procedures
set fileproc "$sourcedir/proc.tcl"
set fileprocadd "$sourcedir/procadd.tcl"
set fileprocmodify "$sourcedir/procmodify.tcl"
set fileprocreplace "$sourcedir/procreplace.tcl"
set fileprocreload "$sourcedir/procreload.tcl"
set fileprocmaint "$sourcedir/procmaint.tcl"
set fileproctex "$sourcedir/proctex.tcl"
set fileprocimport "$sourcedir/procimport.tcl"
# gui
set filegui  "$sourcedir/gui.tcl"
set filegui1 "$sourcedir/guinb1.tcl"
set filegui2 "$sourcedir/guinb2.tcl"
set filegui3 "$sourcedir/guinb3.tcl"
set filegui5 "$sourcedir/guinb5.tcl"
# add/modify window
set filewkey  "$sourcedir/wkey.tcl"
set filewkeylist "$sourcedir/wkeylist.tcl"
set filewcustomer  "$sourcedir/wcustomer.tcl"
set filewcustlist "$sourcedir/wcustlist.tcl"
set filewrelease  "$sourcedir/wrelease.tcl"
set filewproduct  "$sourcedir/wproduct.tcl"
set filewlicense  "$sourcedir/wlicense.tcl"
set filewmaintenance  "$sourcedir/wmaint.tcl"
set filewtex  "$sourcedir/wtex.tcl"
set filewcustsheet  "$sourcedir/wcustsheet.tcl"
set filewimport  "$sourcedir/wimport.tcl"
# for debug only
set filedebug "$sourcedir/debug.tcl"
set filestructure "$sourcedir/structure.tcl"
###############
### variables
set kindProduct 0
set allStatuses 1
set customerName ""
set licenseTerminal 0
set licenseExpired 0
###
###############
### Images
set checkedImg   [image create photo -file $sourcedir/checked.gif]
set uncheckedImg [image create photo -file $sourcedir/unchecked.gif]

# Connecting to SQLite
if {[catch {ini::open [file nativename [file join  $cwd licencje.ini]]} inifilehandle] eq 0} then {
    if [ ::ini::exists $inifilehandle main database ] {
	set dataBase [::ini::value $inifilehandle main database]
    } else {
	set dataBase licencje.db
    }
} else {
    set inifilehandle ""
    set dataBase licencje.db
}
    
if ![file exists $dataBase] then {
    sqlite3 db $dataBase
    source $filestructure
} else {
    sqlite3 db $dataBase
}

# variables for Customer List filter 
if {$inifilehandle ne ""} then {
    # customer list filter
    if [ini::exists $inifilehandle filter customerList] then {
	set filterCustList [split [::ini::value $inifilehandle filter customerList] ,]
	if {[llength $filterCustList] eq 10} then {
	    set fcName [lindex $filterCustList 0]
	    set fcCity [lindex $filterCustList 1]
	    set fcZip [lindex $filterCustList 2]
	    set fcAddress [lindex $filterCustList 3]
	    set fcCustomerId [lindex $filterCustList 4]
	    set fcPerson [lindex $filterCustList 5]
	    set fcEmail [lindex $filterCustList 6]
	    set fcPhone [lindex $filterCustList 7]
	    set fcComment [lindex $filterCustList 8]
	    set fcLabel  [lindex $filterCustList 9]
	}
    }
    # key list filter
    if [ini::exists $inifilehandle filter keyList] then {
	set filterKeyList [split [::ini::value $inifilehandle filter keyList] ,]
	if {[llength $filterKeyList] eq 7} then {
	    set fkNumber [lindex $filterKeyList 0]
	    set fkType [lindex $filterKeyList 1]
	    set fkDateIn [lindex $filterKeyList 2]
	    set fkDateOut [lindex $filterKeyList 3]
	    set fkDocNo [lindex $filterKeyList 4]
	    set fkCurrent [lindex $filterKeyList 5]
	    set fkPrevious [lindex $filterKeyList 6]
	}
    }
}
######
#Paths
# TMP
set pathToTMP "TMP"
if {$inifilehandle ne ""} then {
    if [ini::exists $inifilehandle main pathToTMP] then {
	set pathToTMP [::ini::value $inifilehandle main pathToTMP]	
    }
}
# PDF
set pathToPDF "PDF"
if {$inifilehandle ne ""} then {
    if [ini::exists $inifilehandle main pathToPDF] then {
	set pathToPDF [::ini::value $inifilehandle main pathToPDF]
    }
}
# TXT
set pathToTXT "TXT"
if {$inifilehandle ne ""} then {
    if [ini::exists $inifilehandle main pathToTXT] then {
	set pathToTXT [::ini::value $inifilehandle main pathToTXT]	
    }
}
# Adobe Acrobat
if {[catch {registry get HKEY_CLASSES_ROOT\\acrobat\\shell\\open\\command {}} acrobat]} {
	if {$inifilehandle ne ""} then {
		if [ini::exists $inifilehandle main pathToAcrobat] then {
			set pathToAcrobat [::ini::value $inifilehandle main pathToAcrobat]
		}
	} else {
	set pathToAcrobat "C:/Program Files/Adobe/Acrobat/Reader/AcroRD32.exe"}
} else {
	set pathToAcrobat [string range [string map {\\ /} [string range $acrobat 0 [string first " /u" $acrobat]]] 1 end-2]
}


# procedures
source $fileproc
source $fileprocadd
source $fileprocmodify
source $fileprocreplace
source $fileprocreload
source $fileprocmaint
source $fileproctex
source $fileprocimport
# painting GUI
source $filegui
#EOF