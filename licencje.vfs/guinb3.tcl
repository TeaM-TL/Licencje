# -*-Tcl-*-
## 2007-2010 Tomasz Luczak tlu@temertech.com
# $Id: guinb3.tcl 14 2013-01-26 12:58:02Z tlu $
############################

ttk::panedwindow $frm3.f -orient vertical
pack $frm3.f -padx 2m -pady 2m -fill both -expand 1

set f3 $frm3.f

#######################     row 1
ttk::frame $f3.f1 -relief  ridge -borderwidth 2
ttk::label $f3.f1.l -text [mc "Stats"] \
    -foreground blue -font {helvetica 10 bold}

pack $f3.f1.l  -side top -fill x -expand 1 -padx 2m

#######################     row 2
ttk::labelframe $f3.f2 -text [mc "List of products"]

tablelist::tablelist $f3.f2.t \
    -columns {0 "Id" 
        0 "Name" 
        0 "Quantity" 
        0 "Main/Add"
        0 "Maintenance"} \
     -stretch all \
    -labelcommand tablelist::sortByColumn \
    -xscrollcommand "$f3.f2.x set" \
    -yscrollcommand "$f3.f2.y set"
$f3.f2.t columnconfigure 0 -hide 1
$f3.f2.t columnconfigure 1 -title [mc "Name"]
$f3.f2.t columnconfigure 2 -title [mc "Quantity"]
$f3.f2.t columnconfigure 3 -title [mc "Main/Add"]
$f3.f2.t columnconfigure 4 -title [mc "Maintenance"]

# scrollbars
scrollbar $f3.f2.x -orient horizontal \
    -command "$f3.f2.t xview"
scrollbar $f3.f2.y -orient vertical \
    -command "$f3.f2.t yview"
# autohide scrollbar
::autoscroll::autoscroll $f3.f2.x
#::autoscroll::autoscroll $f3.f2.y

pack $f3.f2.x -side bottom -fill x
pack $f3.f2.y -side right -fill y
pack $f3.f2.t -fill both -expand 1

#######################     row 4
ttk::labelframe $f3.f4 -text [mc "List of customers"]

tablelist::tablelist $f3.f4.t \
    -columns {0 "Id" 
        0 "Customer" 
        0 "Quantity"
        0 "Maintenance"} \
    -stretch all \
    -labelcommand tablelist::sortByColumn \
    -xscrollcommand "$f3.f4.x set" \
    -yscrollcommand "$f3.f4.y set"
$f3.f4.t columnconfigure 0 -hide 1
$f3.f4.t columnconfigure 1 -title [mc "Customer"]
$f3.f4.t columnconfigure 2 -title [mc "Quantity"]
$f3.f4.t columnconfigure 3 -title [mc "Maintenance"]

# scrollbars
scrollbar $f3.f4.x -orient horizontal \
    -command "$f3.f4.t xview"
scrollbar $f3.f4.y -orient vertical \
    -command "$f3.f4.t yview"
# autohide scrollbar
::autoscroll::autoscroll $f3.f4.x
#::autoscroll::autoscroll $f3.f4.y

pack $f3.f4.x -side bottom -fill x
pack $f3.f4.y -side right -fill y
pack $f3.f4.t -fill both -expand 1

############################# grid frames
grid $f3.f1 -sticky nswe -padx 2m -pady 1m
grid $f3.f2 -sticky nswe -padx 2m -pady 1m
grid $f3.f4 -sticky nswe -padx 2m -pady 1m

############################# paned windows
$f3 add $f3.f1
$f3 add $f3.f2
$f3 add $f3.f4

#####
# menu
menu .mp32
.mp32 add command -label [mc "List Export"] -command {
    generateStatList [lindex [$f3.f2.t get $rowf3f2] 0] [$f3.f4.t getcolumn 0]
}
.mp32 add separator
.mp32 add command -label [mc "Refresh"] -command reloadStatProductList
.mp32 add separator
.mp32 add command -label [mc "Close"]
#
menu .mp34
.mp34 add command -label [mc "Go"] -command {
    set idCustomer [lindex [$f3.f4.t get $rowf3f4] 0]
    if {$idCustomer ne ""} then {
	.f.nb select $frm2
	$f2.f2.t selection clear 0 end
	set rowNo [lsearch [$f2.f2.t getcolumns 0] $idCustomer]
	$f2.f2.t selection set $rowNo $rowNo
	$f2.f2.t see $rowNo
	set rowf2f2 $rowNo
	reloadCustomerProductsList [reloadCustomerHardlocksList [lindex [$f2.f2.t get $rowNo] 0]]
	set selectedCustomer [lindex [$f2.f2.t get $rowf2f2] 1]
    }
}
.mp34 add separator
.mp34 add command -label [mc "Close"]
############
# binding
bind [$f3.f2.t bodytag] <Button-1> {
    foreach {tablelist::W tablelist::x tablelist::y} \
	[tablelist::convEventFields %W %x %y] {}
    set rowf3f2 [$f3.f2.t containing $tablelist::y]
    reloadStatCustomerList
}
bind [$f3.f2.t bodytag] <Button-3> {
    foreach {tablelist::W tablelist::x tablelist::y} \
 	[tablelist::convEventFields %W %x %y] {}
    set rowf3f2 [$f3.f2.t containing $tablelist::y]
    tk_popup .mp32 %X %Y
}
bind [$f3.f2.t bodytag] <KeyRelease> {
    set rowf3f2 [$f3.f2.t curselection]
    if [info exists rowf3f2] then {
	    if {$rowf3f2 ne -1} then {
		switch -nocase %K {
		    F5 {reloadStatProductList}
		}
	    }
    }
}
######
bind [$f3.f4.t bodytag] <Button-3> {
    foreach {tablelist::W tablelist::x tablelist::y} \
	[tablelist::convEventFields %W %x %y] {}
    set rowf3f4 [$f3.f4.t containing $tablelist::y]
    tk_popup .mp34 %X %Y
}
bind [$f3.f4.t bodytag] <KeyRelease> {
    set rowf3f4 [$f3.f4.t curselection]
    if [info exists rowf3f4] then {
	    if {$rowf3f4 ne -1} then {
		switch -nocase %K {
		    Return {
			set idCustomer [lindex [$f3.f4.t get $rowf3f4] 0]
			if {$idCustomer ne ""} then {
			    .f.nb select $frm2
			    $f2.f2.t selection clear 0 end
			    set rowNo [lsearch [$f2.f2.t getcolumns 0] $idCustomer]
			    $f2.f2.t selection set $rowNo $rowNo
			    $f2.f2.t see $rowNo
			    set rowf2f2 $rowNo
			    reloadCustomerProductsList [reloadCustomerHardlocksList [lindex [$f2.f2.t get $rowNo] 0]]
			    set selectedCustomer [lindex [$f2.f2.t get $rowf2f2] 1]
			}
		    }
		}
	    }
    }
}
# EOF
