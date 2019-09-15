# -*-Tcl-*-
## 2007-2010 Tomasz Luczak tlu@temertech.com
# $Id: guinb2.tcl 14 2013-01-26 12:58:02Z tlu $
############################

ttk::panedwindow $frm2.f -orient vertical
#-orient vertical
pack $frm2.f -padx 2m -pady 2m -fill both -expand 1

set f2 $frm2.f

#######################     row 1
ttk::frame $f2.f1 -relief  ridge -borderwidth 2
ttk::label $f2.f1.l -text [mc "Customers"] \
    -foreground blue -font {helvetica 10 bold}
ttk::label $f2.f1.l1 -foreground red -textvariable selectedCustomer

pack $f2.f1.l $f2.f1.l1 -side left  -fill x -expand 1 -padx 2m

#######################     row 3
ttk::labelframe $f2.f2 -text [mc "List of customers"]

tablelist::tablelist $f2.f2.t \
    -columns {0 "Id" 
	0 "Name" 
	0 "City" 
	0 "CustomerId" 
	0 "Zip code" 
	0 "Address" 
	0 "Comment" 
	0 "Maintenance"} \
    -stretch all \
    -labelcommand tablelist::sortByColumn \
    -xscrollcommand "$f2.f2.x set" \
    -yscrollcommand "$f2.f2.y set" \
    -editendcommand editEndCmd
$f2.f2.t columnconfigure 0 -hide 1
$f2.f2.t columnconfigure 6 -hide 1
$f2.f2.t columnconfigure 1 -title [mc "Name"]
$f2.f2.t columnconfigure 2 -title [mc "City"]
$f2.f2.t columnconfigure 3 -title [mc "CustomerId"]
$f2.f2.t columnconfigure 4 -title [mc "Zip code"]
$f2.f2.t columnconfigure 5 -title [mc "Address"]
$f2.f2.t columnconfigure 6 -title [mc "Comment"]
$f2.f2.t columnconfigure 7 -hide 1 -title [mc "Maintenance"]

# scrollbars
scrollbar $f2.f2.x -orient horizontal \
    -command "$f2.f2.t xview"
scrollbar $f2.f2.y -orient vertical \
    -command "$f2.f2.t yview"
# autohide scrollbar
::autoscroll::autoscroll $f2.f2.x
::autoscroll::autoscroll $f2.f2.y

pack $f2.f2.x -side bottom -fill x
pack $f2.f2.y -side right -fill y
pack $f2.f2.t -fill both -expand 1

#######################     row 2
ttk::frame $f2.f3

# ---- col 1
ttk::labelframe $f2.f3.f31 -text [mc "Keys"]

ttk::combobox $f2.f3.f31.cb2 -width 8 \
    -values [list "Current" "Replaced" "All"] -state readonly
$f2.f3.f31.cb2 set "Current"
pack $f2.f3.f31.cb2 -side left -padx 2m -pady 1m

# ---- col 2
ttk::labelframe $f2.f3.f32 -text [mc "Filters of maintenanse"]

ttk::checkbutton $f2.f3.f32.cb1 -text [mc "All"] -variable allStatuses \
    -command {
	if {$allStatuses eq 1} then {
	    # all customers
	    reloadCustomerList
	    $f2.f3.f32.cb2 configure -state disable
	    $f2.f3.f34.e configure -state enable
	} else {
	    $f2.f3.f32.cb2 configure -state readonly
	    $f2.f3.f34.e configure -state disable
	    maintCustomerList [getStatusId [$f2.f3.f32.cb2 get]]
	}
    }
ttk::label  $f2.f3.f32.l2 -text [mc "Status"]
ttk::combobox $f2.f3.f32.cb2 -width 20 -values [getListStatuses] \
    -state disable
$f2.f3.f32.cb2 set "%"

ttk::label  $f2.f3.f32.l3 -text [mc "End before days:"]
ttk::entry  $f2.f3.f32.e3 -width 3 -validate key \
    -validatecommand {expr {[string is int %P] && ![string match "0*" %P]}}
$f2.f3.f32.e3 insert end 30

pack $f2.f3.f32.cb1 $f2.f3.f32.l2 $f2.f3.f32.cb2 $f2.f3.f32.l3 $f2.f3.f32.e3 \
    -side left -padx 2m -pady 1m

# ---- col 3
ttk::labelframe $f2.f3.f33 -text [mc "Licenses status"]

ttk::checkbutton $f2.f3.f33.cb1 -text [mc "Terminal"] \
    -variable licenseTerminal -command {
	if {$licenseTerminal eq 0} then {
	    set licenseExpired 0
	}
	reloadCustomerList
	reloadKeysList
    }
ttk::checkbutton $f2.f3.f33.cb2 -text [mc "Expired"] \
    -variable licenseExpired -command {
	if {$licenseExpired eq 1} then {
	    set licenseTerminal 1
	} 
	reloadCustomerList
	reloadKeysList
    }
pack $f2.f3.f33.cb1 $f2.f3.f33.cb2 -side left -padx 2m -pady 1m
# ---- col 4
ttk::labelframe $f2.f3.f34 -text [mc "Find"]
ttk::entry $f2.f3.f34.e
pack $f2.f3.f34.e -padx 2m -pady 1m

# ---- grid
grid $f2.f3.f31 -column 1 -row 1 -pady 1m
grid $f2.f3.f32 -column 2 -row 1 -pady 1m -padx 2m
grid $f2.f3.f33 -column 3 -row 1 -pady 1m -padx 2m
grid $f2.f3.f34 -column 4 -row 1 -pady 1m
#######################     row 4
ttk::panedwindow $f2.f4  -orient horizontal

# hardlocks
ttk::labelframe $f2.f4.f41 -text [mc "Hardlocks/Felics"]

tablelist::tablelist $f2.f4.f41.t \
    -columns {0 "IdKey" 
	0 "IdSold" 
	0 "Number" 
	0 "Type" 
	0 "Description"
	0 "Maintenace"
	0 "Date" } \
    -width 70 \
    -stretch all \
    -labelcommand tablelist::sortByColumn \
    -xscrollcommand "$f2.f4.f41.x set" \
    -yscrollcommand "$f2.f4.f41.y set"
$f2.f4.f41.t columnconfigure 0 -hide 1
$f2.f4.f41.t columnconfigure 1 -hide 1
$f2.f4.f41.t columnconfigure 2 -title [mc "Number"]
$f2.f4.f41.t columnconfigure 3 -title [mc "Type"]
$f2.f4.f41.t columnconfigure 4 -title [mc "Doc No"]
$f2.f4.f41.t columnconfigure 5 -title [mc "Maintenance"]
$f2.f4.f41.t columnconfigure 6 -title [mc "Maintenance"]

# scrollbars
scrollbar $f2.f4.f41.x -orient horizontal \
    -command "$f2.f4.f41.t xview"
scrollbar $f2.f4.f41.y -orient vertical \
    -command "$f2.f4.f41.t yview"
# autohide scrollbar
::autoscroll::autoscroll $f2.f4.f41.x
#::autoscroll::autoscroll $f2.f4.f41.y

pack $f2.f4.f41.x -side bottom -fill x
pack $f2.f4.f41.y -side right -fill y
pack $f2.f4.f41.t -fill both -expand 1


###################################
# products
ttk::labelframe $f2.f4.f42 -text [mc "List of products"]

tablelist::tablelist $f2.f4.f42.t \
    -columns {
	0 "Id" 
	0 "Hardlock" 
	0 "Product" 
	0 "License No" 
	0 "Valid" 
	0 "Quantity"} \
    -stretch all \
    -labelcommand tablelist::sortByColumn \
    -xscrollcommand "$f2.f4.f42.x set" \
    -yscrollcommand "$f2.f4.f42.y set" 
$f2.f4.f42.t columnconfigure 0 -hide 1
$f2.f4.f42.t columnconfigure 1 -title [mc "Hardlock"]
$f2.f4.f42.t columnconfigure 2 -title [mc "Product"]
$f2.f4.f42.t columnconfigure 3 -title [mc "License No"] -font {Courier 9}
$f2.f4.f42.t columnconfigure 4 -title [mc "Valid until"]
$f2.f4.f42.t columnconfigure 5 -title [mc "Quantity"]
# scrollbars
scrollbar $f2.f4.f42.x -orient horizontal \
    -command "$f2.f4.f42.t xview"
scrollbar $f2.f4.f42.y -orient vertical \
    -command "$f2.f4.f42.t yview"
# autohide scrollbar
::autoscroll::autoscroll $f2.f4.f42.x
#::autoscroll::autoscroll $f2.f4.f42.y

pack $f2.f4.f42.x -side bottom -fill x
pack $f2.f4.f42.y -side right -fill y
pack $f2.f4.f42.t -fill both -expand 1

##
grid $f2.f4.f41 -column 1 -row 1 -sticky ns -pady 1m
grid $f2.f4.f42 -column 2 -row 1 -sticky ns -pady 1m -padx 2m

#paned subframe
$f2.f4 add $f2.f4.f41
$f2.f4 add $f2.f4.f42

############################# grid frames
grid $f2.f1 -sticky nswe -padx 2m -pady 1m
grid $f2.f3 -sticky nswe -padx 2m -pady 1m
grid $f2.f2 -sticky nswe -padx 2m -pady 1m
grid $f2.f4 -sticky nswe -padx 2m -pady 1m

############################# paned windows
$f2 add $f2.f1
$f2 add $f2.f3
$f2 add $f2.f2
$f2 add $f2.f4

###########################
#### menu popup
#
### Menu Custmers
menu .mp22
.mp22 add command -label [mc "Add"] -command addCustomer
.mp22 add command -label [mc "Modify"] -command {
    if {$rowf2f2 ne -1} then {
	modifyCustomer
    }
}
.mp22 add separator
.mp22 add command -label [mc "Add hardlock"] -command {
    if {$rowf2f2 ne -1} then {
	addHardlock [lindex [$f2.f2.t get $rowf2f2] 0]
    }
}
.mp22 add separator
.mp22 add command -label [mc "Maintenance"] -command {
    if {$rowf2f2 ne -1} then {
	maintenance
    }
}
.mp22 add separator
.mp22 add command -label [mc "Customer Sheet"] -command {
    if {$rowf2f2 ne -1} then {
	customerSheet [lindex [$f2.f2.t get $rowf2f2] 0]
    }
}
.mp22 add separator
.mp22 add command -label [mc "List Export"] -command {
    generateStatList "" [$f2.f2.t getcolumn 0]
}
.mp22 add separator
.mp22 add command -label [mc "Refresh"] -command reloadCustomerList
.mp22 add separator
.mp22 add command -label [mc "Close"]
###### Menu Keys
menu .mp241
.mp241 add command -label [mc "Add"] -command {
    if [info exists rowf2f2] then {
	if {$rowf2f2 ne -1} then {
	    addHardlock [lindex [$f2.f2.t get $rowf2f2] 0]
	}
    }
}
.mp241 add command -label [mc "Modify"] -command {
    if [info exists rowf2f41] then {
	if {$rowf2f41 ne -1} then {
	    modifyKey [lindex [$f2.f4.f41.t get $rowf2f41] 0]
	}
    }
}
.mp241 add command -label [mc "Remove"] -command {
    if [info exists rowf2f41] then {
	if {$rowf2f41 ne -1} then {
	    removeHardlock [lindex [$f2.f4.f41.t get $rowf2f41] 1]
	}
    }
}
.mp241 add command -label [mc "Replace"] -command {
    if [info exists rowf2f41] then {
	if {$rowf2f41 ne -1} then {
	    replaceHardlock [lindex [$f2.f4.f41.t get $rowf2f41] 0]
	}
    }
}
.mp241 add separator
.mp241 add command -label [mc "Add license"] -command {
    if [info exists rowf2f41] then {
	if {$rowf2f41 ne -1} then {
	    addLicense [lindex [$f2.f4.f41.t get $rowf2f41] 0]
	}
    }
}
.mp241 add command -label [mc "Import license"] -command {
    if [info exists rowf2f41] then {
	if {$rowf2f41 ne -1} then {
	    importLicense [lindex [$f2.f4.f41.t get $rowf2f41] 0]
	}
    }
}
.mp241 add command -label [mc "Import v2c file"] -command {
    if [info exists rowf2f41] then {
	if {$rowf2f41 ne -1} then {
	    importV2C [lindex [$f2.f4.f41.t get $rowf2f41] 0]
	}
    }
}
.mp241 add separator
.mp241 add command -label [mc "License sheet"] -command {
    if [info exists rowf2f41] then {
	if {$rowf2f41 ne -1} then {
	    generateLicense [lindex [$f2.f4.f41.t get $rowf2f41] 0]
	}
    }
}
.mp241 add command -label [mc "Export v2c file"] -command {
    if [info exists rowf2f41] then {
	if {$rowf2f41 ne -1} then {
	    exportV2C [lindex [$f2.f4.f41.t get $rowf2f41] 0]
	}
    }
}
.mp241 add separator
.mp241 add command -label [mc "List Export"] -command {
    generateKeyList [$f2.f4.f41.t getcolumn 0]
}
.mp241 add separator
.mp241 add command -label [mc "Close"]
### Menu Products
menu .mp242
.mp242 add command -label [mc "Modify"] -command {
    if [info exists rowf2f42] then {
	if {$rowf2f42 ne -1} then {
	    modifyLicense [$f2.f4.f42.t get $rowf2f42]
	}
    }
}
.mp242 add command -label [mc "Remove"] -command {
    if [info exists rowf2f42] then {
	if {$rowf2f42 ne -1} then {
	    removeLicense [$f2.f4.f42.t get $rowf2f42]
	}
    }
}
.mp242 add separator
.mp242 add command -label [mc "Close"]
##########################
# bind

# filter
bind $f2.f3.f34.e <KeyRelease> reloadCustomerList
#
bind $f2.f3.f31.cb2 <<ComboboxSelected>> {
    if [info exists rowf2f2] then {
	reloadCustomerProductsList [reloadCustomerHardlocksList [lindex [$f2.f2.t get $rowf2f2] 0]]	
    }
}
# customer
bind [$f2.f2.t bodytag] <Button-1> {
    foreach {tablelist::W tablelist::x tablelist::y} \
	[tablelist::convEventFields %W %x %y] {}
    set rowf2f2 [$f2.f2.t containing $tablelist::y]
    reloadCustomerProductsList [reloadCustomerHardlocksList [lindex [$f2.f2.t get $rowf2f2] 0]]
    set selectedCustomer [lindex [$f2.f2.t get $rowf2f2] 1]
}
bind [$f2.f2.t bodytag] <Button-3> {
    foreach {tablelist::W tablelist::x tablelist::y} \
 	[tablelist::convEventFields %W %x %y] {}
    set rowf2f2 [$f2.f2.t containing $tablelist::y]
    tk_popup .mp22 %X %Y
}
bind [$f2.f2.t bodytag] <KeyRelease> {
    set rowf2f2 [$f2.f2.t curselection]
    if [info exists rowf2f2] then {
	    if {$rowf2f2 ne -1} then {
		switch -nocase %K {
		    Up {
			reloadCustomerProductsList [reloadCustomerHardlocksList [lindex [$f2.f2.t get $rowf2f2] 0]]
			set selectedCustomer [lindex [$f2.f2.t get $rowf2f2] 1]
		    }
		    Down {
			reloadCustomerProductsList [reloadCustomerHardlocksList [lindex [$f2.f2.t get $rowf2f2] 0]]
			set selectedCustomer [lindex [$f2.f2.t get $rowf2f2] 1]
		    }
		    Return {modifyCustomer}
		    Insert {addCustomer}
		    F5 {reloadCustomerList}
		}
	    }
    }
}
# hardlocks
bind [$f2.f4.f41.t bodytag] <Button-1> {
    foreach {tablelist::W tablelist::x tablelist::y} \
	[tablelist::convEventFields %W %x %y] {}
    set rowf2f41 [$f2.f4.f41.t containing $tablelist::y]
    reloadCustomerProductsList [lindex [$f2.f4.f41.t get $rowf2f41] 0]
}
#
bind [$f2.f4.f41.t bodytag] <Button-3> {
    foreach {tablelist::W tablelist::x tablelist::y} \
 	[tablelist::convEventFields %W %x %y] {}
    set rowf2f41 [$f2.f4.f41.t containing $tablelist::y]
    tk_popup .mp241 %X %Y
}
bind [$f2.f4.f41.t bodytag] <KeyRelease> {
    set rowf2f41 [$f2.f4.f41.t curselection]
    if [info exists rowf2f41] then {
	    if {$rowf2f41 ne -1} then {
		switch -nocase %K {
		    Up {reloadCustomerProductsList [lindex [$f2.f4.f41.t get $rowf2f41] 0]}
		    Down {reloadCustomerProductsList [lindex [$f2.f4.f41.t get $rowf2f41] 0]}
		    Return {modifyKey [lindex [$f2.f4.f41.t get $rowf2f41] 0]}
		}
	    }
    }
}
# Products
bind [$f2.f4.f42.t bodytag] <Button-3> {
    foreach {tablelist::W tablelist::x tablelist::y} \
 	[tablelist::convEventFields %W %x %y] {}
    set rowf2f42 [$f2.f4.f42.t containing $tablelist::y]
    tk_popup .mp242 %X %Y
}
bind [$f2.f4.f42.t bodytag] <KeyRelease> {
    set rowf2f42 [$f2.f4.f42.t curselection]
    if [info exists rowf2f42] then {
	    if {$rowf2f42 ne -1} then {
		switch -nocase %K {
	            Return {modifyLicense [$f2.f4.f42.t get $rowf2f42]}
	            Delete {removeLicense [$f2.f4.f42.t get $rowf2f42]}
		}
	    }
    }
}
bind $f2.f3.f32.cb2 <<ComboboxSelected>> {
    if {$allStatuses eq 0} then {
	maintCustomerList [getStatusId [$f2.f3.f32.cb2 get]]
    }
}
# EOF