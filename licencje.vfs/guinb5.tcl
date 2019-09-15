# -*-Tcl-*-
## 2007-2010 Tomasz Luczak tlu@temertech.com
# $Id: guinb5.tcl 14 2013-01-26 12:58:02Z tlu $
############################

ttk::panedwindow $frm5.f -orient vertical
pack $frm5.f -padx 2m -pady 2m -fill both -expand 1

set f5 $frm5.f

#######################     row 1
ttk::frame $f5.f1 -relief  ridge -borderwidth 2
ttk::label $f5.f1.l -text [mc "Products and Releases"] \
    -foreground blue -font {helvetica 10 bold}

pack $f5.f1.l  -side top -fill x -expand 1 -padx 2m

#######################     row 2
ttk::labelframe $f5.f2 -text [mc "List of products"]

tablelist::tablelist $f5.f2.t \
    -columns {0 "Id" 0 "Name" 0 "Main/Add" 0 "First release" 0 "Last release" 0 "ProductId"} \
    -stretch all -setfocus 1 \
    -labelcommand tablelist::sortByColumn \
    -xscrollcommand "$f5.f2.x set" \
    -yscrollcommand "$f5.f2.y set"
$f5.f2.t columnconfigure 0 -hide 1
$f5.f2.t columnconfigure 1 -title [mc "Name"]
$f5.f2.t columnconfigure 2 -title [mc "Main/Add"]
$f5.f2.t columnconfigure 3 -title [mc "First release"]
$f5.f2.t columnconfigure 4 -title [mc "Last release"]
$f5.f2.t columnconfigure 5 -title [mc "ProductId"]
# scrollbars
scrollbar $f5.f2.x -orient horizontal \
    -command "$f5.f2.t xview"
scrollbar $f5.f2.y -orient vertical \
    -command "$f5.f2.t yview"
# autohide scrollbar
::autoscroll::autoscroll $f5.f2.x
::autoscroll::autoscroll $f5.f2.y

pack $f5.f2.x -side bottom -fill x
pack $f5.f2.y -side right -fill y
pack $f5.f2.t -fill both -expand 1

#######################     row 3
ttk::labelframe $f5.f3 -text [mc "List of releases"]

tablelist::tablelist $f5.f3.t \
    -columns {0 "Id" 0 "Name" 0 "Date start" 0 "Date end" } \
    -stretch all -setfocus 1 \
    -labelcommand tablelist::sortByColumn \
    -xscrollcommand "$f5.f3.x set" \
    -yscrollcommand "$f5.f3.y set"
$f5.f3.t columnconfigure 0 -hide 1
$f5.f3.t columnconfigure 1 -title [mc "Name"]
$f5.f3.t columnconfigure 2 -title [mc "Date start"]
$f5.f3.t columnconfigure 3 -title [mc "Date end"]
# scrollbars
scrollbar $f5.f3.x -orient horizontal \
    -command "$f5.f3.t xview"
scrollbar $f5.f3.y -orient vertical \
    -command "$f5.f3.t yview"
# autohide scrollbar
::autoscroll::autoscroll $f5.f3.x
::autoscroll::autoscroll $f5.f3.y

pack $f5.f3.x -side bottom -fill x
pack $f5.f3.y -side right -fill y
pack $f5.f3.t -fill both -expand 1

############################# grid frames
grid $f5.f1 -padx 2m -pady 1m -sticky nswe
grid $f5.f2 -padx 2m -pady 1m -sticky nswe
grid $f5.f3 -padx 2m -pady 1m -sticky nswe

############################# paned windows
$f5 add $f5.f1
$f5 add $f5.f2
$f5 add $f5.f3

############################# # menu popup
menu .mp52
.mp52 add command -label [mc "Add"] -command addProduct
.mp52 add command -label [mc "Modify"] -command {
    if {$rowf5f2 ne -1} then {
	modifyProduct
    }
}
.mp52 add command -label [mc "Refresh"] -command reloadProductList
.mp52 add separator
.mp52 add command -label [mc "Close"]

#
menu .mp53
.mp53 add command -label [mc "Add"] -command addRelease
.mp53 add command -label [mc "Modify"] -command {
    if {$rowf5f3 ne -1} then {
	modifyRelease
    }
}
.mp53 add command -label [mc "Refresh"] -command reloadReleaseList
.mp53 add separator
.mp53 add command -label [mc "Close"]
#############################
# bind
bind [$f5.f2.t bodytag] <Button-3> {
    foreach {tablelist::W tablelist::x tablelist::y} \
 	[tablelist::convEventFields %W %x %y] {}
    set rowf5f2 [$f5.f2.t containing $tablelist::y]
    tk_popup .mp52 %X %Y
}
bind [$f5.f2.t bodytag] <KeyRelease> {
    set rowf5f2 [$f5.f2.t curselection]
    if [info exists rowf5f2] then {
	    if {$rowf5f2 ne -1} then {
		switch -nocase %K {
		    F5 {reloadProductList}
		    Insert {addProduct}
		    Return {
			if {$rowf5f2 ne -1} then {
			    modifyProduct
			}
		    }
		}
	    }
    }
}
#
bind [$f5.f3.t bodytag] <Button-3> {
    foreach {tablelist::W tablelist::x tablelist::y} \
 	[tablelist::convEventFields %W %x %y] {}
    set rowf5f3 [$f5.f3.t containing $tablelist::y]
    tk_popup .mp53 %X %Y
}
bind [$f5.f3.t bodytag] <KeyRelease> {
    set rowf5f3 [$f5.f3.t curselection]
    if [info exists rowf5f3] then {
	    if {$rowf5f3 ne -1} then {
		switch -nocase %K {
		    F5 {reloadReleaseList}
		    Insert {addRelease}
		    Return {
			if {$rowf5f3 ne -1} then {
			    modifyRelease
			}
		    }
		}
	    }
    }
}
# EOF