# -*-Tcl-*-
## 2007-2010 Tomasz Luczak tlu@temertech.com
# $Id: guinb1.tcl 14 2013-01-26 12:58:02Z tlu $
############################

ttk::panedwindow $frm1.f -orient vertical
pack $frm1.f -padx 2m -pady 2m  -fill both -expand 1
set f1 $frm1.f

#######################     row 1
ttk::frame $f1.f1 -relief  ridge -borderwidth 2
ttk::label $f1.f1.l -text [mc "Hardlocks and Felics"] \
    -foreground blue -font {helvetica 10 bold}

pack $f1.f1.l -side top -fill x -expand 1 -padx 2m

#######################     row 3
ttk::labelframe $f1.f2 -text [mc "List of dongles and flying licenses"]

tablelist::tablelist $f1.f2.t \
    -columns {0 "Id" 
	0 "Number" 
	0 "Kind" 
	0 "Date in" 
	0 "Date out" 
	0 "Doc No" 
	0 "Previous" 
	0 "Current" 
	0 "Maintenance" 
	0 "Maintenance Date"} \
    -stretch all \
    -labelcommand tablelist::sortByColumn \
    -xscrollcommand "$f1.f2.x set" \
    -yscrollcommand "$f1.f2.y set"
$f1.f2.t columnconfigure 0 -hide 1
$f1.f2.t columnconfigure 1 -title [mc "Number"]
$f1.f2.t columnconfigure 2 -title [mc "Kind"]
$f1.f2.t columnconfigure 3 -title [mc "Date in"]
$f1.f2.t columnconfigure 4 -title [mc "Date out"]
$f1.f2.t columnconfigure 5 -title [mc "Doc No"]
$f1.f2.t columnconfigure 6 -hide 1
$f1.f2.t columnconfigure 7 -hide 1
$f1.f2.t columnconfigure 8 -title [mc "Maintenance"]
$f1.f2.t columnconfigure 9 -title [mc "Maintenance Date"]
# scrollbars
scrollbar $f1.f2.x -orient horizontal \
    -command "$f1.f2.t xview"
scrollbar $f1.f2.y -orient vertical \
    -command "$f1.f2.t yview"
# autohide scrollbar
::autoscroll::autoscroll $f1.f2.x
#::autoscroll::autoscroll $f1.f2.y

pack $f1.f2.x -side bottom -fill x
pack $f1.f2.y -side right -fill y
pack $f1.f2.t -fill both -expand 1

#######################     row 3
ttk::frame $f1.f3

# ---- col 1
ttk::labelframe $f1.f3.f31 -text [mc "Customer"]

ttk::label $f1.f3.f31.l -foreground red -textvariable customerName -width 40
ttk::button $f1.f3.f31.b -text [mc "Go"] -command {
    if {$customerName ne ""} then {
	.f.nb select $frm2
	$f2.f2.t selection clear 0 end
	set rowNo [lsearch [$f2.f2.t getcolumns 1] "$customerName"]
	$f2.f2.t selection set $rowNo $rowNo
	$f2.f2.t see $rowNo
	set rowf2f2 $rowNo
	reloadCustomerProductsList [reloadCustomerHardlocksList [lindex [$f2.f2.t get $rowNo] 0]]
	set selectedCustomer [lindex [$f2.f2.t get $rowf2f2] 1]
    }
}
pack $f1.f3.f31.b $f1.f3.f31.l -side right -padx 2m -pady 2m

# ---- col 2
ttk::labelframe $f1.f3.f32 -text [mc "Keys"]

ttk::combobox $f1.f3.f32.cb1 -width 8 \
    -values [list "All" "USB" "HASP" "NetHASP" "LPT" "Dongles" "Flying"] -state readonly 
$f1.f3.f32.cb1 set "All"

ttk::combobox $f1.f3.f32.cb2 -width 8 \
    -values [list "Current" "Replaced" "All"] -state readonly
$f1.f3.f32.cb2 set "Current"

pack $f1.f3.f32.cb1 $f1.f3.f32.cb2 -side left -padx 1m

# ---- col 3
ttk::labelframe $f1.f3.f33 -text [mc "Licenses status"]

ttk::checkbutton $f1.f3.f33.cb1 -text [mc "Terminal"] \
    -variable licenseTerminal -command {
	if {$licenseTerminal eq 0} then {
	    set licenseExpired 0
	} 
	reloadKeysList
    }
  
ttk::checkbutton $f1.f3.f33.cb2 -text [mc "Expired"] \
    -variable licenseExpired -command {
	if {$licenseExpired eq 1} then {
	    set licenseTerminal 1
	} 
	reloadKeysList
    }

ttk::checkbutton $f1.f3.f33.cb3 -text [mc "Maintenance"] \
    -variable licenseMaintenanced -command {
	if {$licenseMaintenanced eq 1} then {
	    set licenseMaintenanced 1
	} 
#	reloadKeysList
    }

pack $f1.f3.f33.cb1 $f1.f3.f33.cb2 $f1.f3.f33.cb3 -side left -padx 1m

# --- col 4
ttk::labelframe $f1.f3.f34 -text [mc "Find"]
ttk::entry $f1.f3.f34.e -width 15
pack  $f1.f3.f34.e -padx 1m -pady 1m -side left

# ---- grid
grid $f1.f3.f31 -column 1 -row 1 -sticky ns
grid $f1.f3.f32 -column 2 -row 1 -sticky ns -padx 2m
grid $f1.f3.f33 -column 3 -row 1 -sticky ns
grid $f1.f3.f34 -column 4 -row 1 -sticky ns -padx 2m

#######################     row 4
ttk::labelframe $f1.f4 -text [mc "List of products"]

tablelist::tablelist $f1.f4.t \
    -columns {0 "Id" 
	0 "Product" 
	0 "License No" 
	0 "Valid" 
	0 "Quantity" } \
    -stretch all \
    -labelcommand tablelist::sortByColumn \
    -xscrollcommand "$f1.f4.x set" \
    -yscrollcommand "$f1.f4.y set"
$f1.f4.t columnconfigure 1 -title [mc "Product"]
$f1.f4.t columnconfigure 2 -title [mc "License No"] -font {Courier 9}
$f1.f4.t columnconfigure 3 -title [mc "Valid until"]
$f1.f4.t columnconfigure 4 -title [mc "Quantity"]
$f1.f4.t columnconfigure 0 -hide 1
# scrollbars
scrollbar $f1.f4.x -orient horizontal \
    -command "$f1.f4.t xview"
scrollbar $f1.f4.y -orient vertical \
    -command "$f1.f4.t yview"
# autohide scrollbar
::autoscroll::autoscroll $f1.f4.x
#::autoscroll::autoscroll $f1.f4.y

pack $f1.f4.x -side bottom -fill x
pack $f1.f4.y -side right -fill y
pack $f1.f4.t -fill both -expand 1

############################# grid frames
grid $f1.f1 -sticky nswe -padx 2m -pady 1m
grid $f1.f3 -sticky nswe -padx 2m -pady 1m
grid $f1.f2 -sticky nswe -padx 2m -pady 1m
grid $f1.f4 -sticky nswe -padx 2m -pady 1m

############################# paned windows
$f1 add $f1.f1
$f1 add $f1.f3
$f1 add $f1.f2
$f1 add $f1.f4

###########################
# menu popup
menu .mp12
.mp12 add command -label [mc "Add"] -command addKey
.mp12 add command -label [mc "Modify"] -command {
    if {$rowf1f2 ne -1} then {
	modifyKey [lindex [$f1.f2.t get $rowf1f2] 0]
    }
}
#.mp12 add command -label [mc "Replace"] -command {
#    if {$rowf1f2 ne "-1"} then {
#	set rowData [$f1.f2.t get $rowf1f2]
#	replaceHardlock [lindex $rowData 0]
#    }
#}
.mp12 add separator
.mp12 add command -label [mc "Add license"] -command {
    if {$rowf1f2 ne "-1"} then {
	addLicense [lindex [$f1.f2.t get $rowf1f2] 0]
    }
}
.mp12 add command -label [mc "Import license"] -command {
    if {$rowf1f2 ne "-1"} then {
	importLicense [lindex [$f1.f2.t get $rowf1f2] 0]
    }
}
.mp12 add command -label [mc "Import v2c file"] -command {
    if {$rowf1f2 ne "-1"} then {
	importV2C [lindex [$f1.f2.t get $rowf1f2] 0]
    }
}
.mp12 add separator
.mp12 add command -label [mc "License sheet"] -command {
    if {$rowf1f2 ne "-1"} then {
	generateLicense [lindex [$f1.f2.t get $rowf1f2] 0]
    }
}
.mp12 add command -label [mc "Export v2c file"] -command {
    if {$rowf1f2 ne "-1"} then {
	exportV2C [lindex [$f1.f2.t get $rowf1f2] 0]
    }
}
.mp12 add separator
.mp12 add command -label [mc "List Export"] -command {
    generateKeyList [$f1.f2.t getcolumn 0]
}
.mp12 add separator
.mp12 add command -label [mc "Refresh"] -command reloadKeysList
.mp12 add separator
.mp12 add command -label [mc "Close"]
#
menu .mp14
.mp14 add command -label [mc "Modify"] -command {
    if {$rowf1f4 ne -1} then {
	modifyLicense [linsert [$f1.f4.t get $rowf1f4] 1 [lindex [$f1.f2.t get $rowf1f2] 1]]
    }
}
.mp14 add separator
.mp14 add command -label [mc "Close"]
##########################
# bind

# filter
bind $f1.f3.f34.e <KeyRelease> reloadKeysList

# Comboboxes
bind $f1.f3.f32.cb1 <<ComboboxSelected>> reloadKeysList

bind $f1.f3.f32.cb2 <<ComboboxSelected>> reloadKeysList

# Window 1
bind [$f1.f2.t bodytag] <Button-1> {
    foreach {tablelist::W tablelist::x tablelist::y} \
	[tablelist::convEventFields %W %x %y] {}
    set rowf1f2 [$f1.f2.t containing $tablelist::y]
    
    set idKey [lindex [$f1.f2.t get $rowf1f2] 0]
    set customerName [getCustomerName $idKey]
    reloadKeyProductsList $idKey
}
#
bind [$f1.f2.t bodytag] <Button-2> {
    foreach {tablelist::W tablelist::x tablelist::y} \
	[tablelist::convEventFields %W %x %y] {} 
    puts "clicked on cell [$f1.f2.t containingcell $tablelist::x $tablelist::y]"
    puts "clicked on row [$f1.f2.t containing $tablelist::y]"
    set rowf1f2 [$f1.f2.t containing $tablelist::y]
    set customerName [getCustomerName [lindex [$f1.f2.t get $rowf1f2] 0]]
}
#
bind [$f1.f2.t bodytag] <Button-3> {
    foreach {tablelist::W tablelist::x tablelist::y} \
 	[tablelist::convEventFields %W %x %y] {}
    set rowf1f2 [$f1.f2.t containing $tablelist::y]
    set customerName [getCustomerName [lindex [$f1.f2.t get $rowf1f2] 0]]
    tk_popup .mp12 %X %Y
}
#
bind [$f1.f2.t bodytag] <KeyRelease> {
    set rowf1f2 [$f1.f2.t curselection]
    if [info exists rowf1f2] then {
	    if {$rowf1f2 ne -1} then {
		switch -nocase %K {
		    Up {
			set idKey [lindex [$f1.f2.t get $rowf1f2] 0]
			set customerName [getCustomerName $idKey]
			reloadKeyProductsList $idKey
		    }
		    Down {
			set idKey [lindex [$f1.f2.t get $rowf1f2] 0]
			set customerName [getCustomerName $idKey]
			reloadKeyProductsList $idKey
		    }
		    Return {modifyKey [lindex [$f1.f2.t get $rowf1f2] 0]}
		    Insert {addKey}
		    F5 {reloadKeysList}
		}
	    }
    }
}
# Window 2
bind [$f1.f4.t bodytag] <Button-3> {
    foreach {tablelist::W tablelist::x tablelist::y} \
 	[tablelist::convEventFields %W %x %y] {}
    set rowf1f4 [$f1.f4.t containing $tablelist::y]
    tk_popup .mp14 %X %Y
}
bind [$f1.f4.t bodytag] <KeyRelease> {
    set rowf1f4 [$f1.f4.t curselection]
    if [info exists rowf1f4] then {
	    if {$rowf1f4 ne -1} then {
		switch -nocase %K {
		    Return {
			modifyLicense [linsert [$f1.f4.t get $rowf1f4] 1 [lindex [$f1.f2.t get $rowf1f2] 1]]
		    }
		}
	    }
    }
}
# EOF