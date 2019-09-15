# -*-Tcl-*-
## 2007-2010 Tomasz Luczak tlu@temertech.com
# $Id: wcustlist.tcl 14 2013-01-26 12:58:02Z tlu $
############################
if [winfo exists .custlist] then { 
    destroy .custlist
}

toplevel .custlist
wm title .custlist [mc "Customer list"]

#############################  pane
ttk::panedwindow .custlist.pane -orient vertical
pack .custlist.pane -padx 2m -pady 2m -expand 1 -fill both

#############################  f2
ttk::labelframe .custlist.pane.f2 -text [mc "Customer list"]

ctext .custlist.pane.f2.text -relief sunken \
    -xscrollcommand ".custlist.pane.f2.x set" \
    -yscrollcommand ".custlist.pane.f2.y set" \
    -bd 2 -setgrid 1 -undo 1 -wrap none \
    -font {Courier 9}  -height 15 -width 100
ttk::scrollbar .custlist.pane.f2.x -command ".custlist.pane.f2.text xview" \
    -orient horizontal
ttk::scrollbar .custlist.pane.f2.y -command ".custlist.pane.f2.text yview"
pack .custlist.pane.f2.x -side bottom -fill x
pack .custlist.pane.f2.y -side right -fill y
pack .custlist.pane.f2.text -expand yes -fill both

# syntax highlight
ctext::addHighlightClassForRegexp .custlist.pane.f2.text custred red {^%.*}
ctext::addHighlightClassForRegexp .custlist.pane.f2.text custblue blue {^[^#%]+}
ctext::addHighlightClassForSpecialChars  .custlist.pane.f2.text custmagenta magenta {#}

#############################  f3
ttk::labelframe .custlist.f3 -text [mc "Filters"]

ttk::checkbutton .custlist.f3.cb1 -text [mc "Name"]       -variable fcName
ttk::checkbutton .custlist.f3.cb2 -text [mc "City"]       -variable fcCity
ttk::checkbutton .custlist.f3.cb3 -text [mc "Zip code"]   -variable fcZip
ttk::checkbutton .custlist.f3.cb4 -text [mc "Address"]    -variable fcAddress
ttk::checkbutton .custlist.f3.cb5 -text [mc "CustomerId"] -variable fcCustomerId
ttk::checkbutton .custlist.f3.cb6 -text [mc "Person"]     -variable fcPerson
ttk::checkbutton .custlist.f3.cb7 -text [mc "e-mail"]     -variable fcEmail
ttk::checkbutton .custlist.f3.cb8 -text [mc "Phone"]      -variable fcPhone
ttk::checkbutton .custlist.f3.cb9 -text [mc "Comment"]    -variable fcComment
ttk::checkbutton .custlist.f3.cb10 -text [mc "Labels"]    -variable fcLabel

ttk::button .custlist.f3.br -text [mc "Refresh"]
pack .custlist.f3.cb1 .custlist.f3.cb2 .custlist.f3.cb3 .custlist.f3.cb4 \
	.custlist.f3.cb5 .custlist.f3.cb6 .custlist.f3.cb7 .custlist.f3.cb8 \
	.custlist.f3.cb9 .custlist.f3.cb10 \
    -side left -padx 2m
if ![info exists fcName] then {set fcName "1"}
if ![info exists fcCity] then {set fcCity "1"}
if ![info exists fcZip] then {set fcZip "0"}
if ![info exists fcAddress] then {set fcAddress "0"}
if ![info exists fcCustomerId] then {set fcCustomerId "0"}
if ![info exists fcPerson] then {set fcPerson "0"}
if ![info exists fcEmail] then {set fcEmail "0"}
if ![info exists fcPhone] then {set fcPhone "0"}
if ![info exists fcComment] then {set fcComment "1"}

#############################  f4
ttk::frame .custlist.f4

ttk::label .custlist.f4.l -text [mc "Product"]
ttk::entry .custlist.f4.e

ttk::button .custlist.f4.b1 -text [mc "Generate PDF"] -command {
	set filecontents [.custlist.f2.text get 0.0 end]
	set filename [file join $pathToTMP label.dat] 
	writescript $filecontents $filename w+
	if {$windows eq 1} then {
		puts "Windows"
		executeprocess 0 inf 00_start3.bat
	} else {
		executeprocess 0 inf ./00_start3.sh
	}
}
ttk::button .custlist.f4.b2 -text [mc "View PDF"] -command {viewpdf label.pdf}
ttk::button .custlist.f4.b3 -text [mc "Save to file"]
ttk::button .custlist.f4.b4 -text [mc "Close"] -command {destroy .custlist}

pack  .custlist.f4.l .custlist.f4.e .custlist.f4.b3 .custlist.f4.b4 -side left -padx 2m
if {$fcLabel eq "1"} then {pack  .custlist.f4.b1 .custlist.f4.b2 -side left -padx 2m}


############################# frames 
pack .custlist.pane.f2 -padx 2m -pady 1m -expand 1 -fill both
pack .custlist.f3 -padx 2m -pady 1m 
pack .custlist.f4 -padx 2m -pady 1m 

############################# paned windows
.custlist.pane add .custlist.pane.f2

# EOF