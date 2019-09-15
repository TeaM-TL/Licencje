# -*-Tcl-*-
## 2007-2010 Tomasz Luczak tlu@temertech.com
# $Id: wtex.tcl 14 2013-01-26 12:58:02Z tlu $
############################
if [winfo exists .tex] then { 
    destroy .tex
}

toplevel .tex
wm title .tex [mc "License sheet"]

#############################  pane
ttk::panedwindow .tex.pane -orient vertical
pack .tex.pane -padx 2m -pady 2m -expand 1 -fill both

#############################  f2
ttk::labelframe .tex.pane.f2 -text [mc "License sheet"]

ctext .tex.pane.f2.text -relief sunken \
    -xscrollcommand ".tex.pane.f2.x set" \
    -yscrollcommand ".tex.pane.f2.y set" \
    -bd 2 -setgrid 1 -undo 1 -wrap none \
    -font {Courier 9}  -height 15 -width 80
ttk::scrollbar .tex.pane.f2.x -command ".tex.pane.f2.text xview" \
    -orient horizontal
ttk::scrollbar .tex.pane.f2.y -command ".tex.pane.f2.text yview"
pack .tex.pane.f2.x -side bottom -fill x
pack .tex.pane.f2.y -side right -fill y
pack .tex.pane.f2.text -expand yes -fill both

# autohide scroll
::autoscroll::autoscroll .tex.pane.f2.x
#::autoscroll::autoscroll .tex.pane.f2.y
# syntax highlight
ctext::addHighlightClassForRegexp .tex.pane.f2.text texred red {^#[^#]*}
ctext::addHighlightClassForRegexp .tex.pane.f2.text texblue blue {^[^#]+}
ctext::addHighlightClassForSpecialChars .tex.pane.f2.text texmagenta magenta {#}

#############################  f3
ttk::frame .tex.f3

ttk::label .tex.f3.l -text [mc "Number/HostId"]
ttk::entry .tex.f3.e

ttk::button .tex.f3.b1 -text [mc "Generate PDF"] -command {runtex}
ttk::button .tex.f3.b2 -text [mc "View PDF"] -command {viewpdf license.pdf}
ttk::button .tex.f3.b3 -text [mc "Save to file"] -command {saveELCAD_ID}
ttk::button .tex.f3.b4 -text [mc "Close"] -command {destroy .tex}

pack .tex.f3.l .tex.f3.e .tex.f3.b1 .tex.f3.b2 .tex.f3.b3 .tex.f3.b4 -side left -padx 2m

############################ frames
pack .tex.pane.f2 -padx 2m -pady 1m -expand 1 -fill both
pack .tex.f3 -padx 2m -pady 1m 

############################# paned windows
.tex.pane add .tex.pane.f2

# EOF