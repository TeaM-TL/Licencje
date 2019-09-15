# -*-Tcl-*-
## 2007-2010 Tomasz Luczak tlu@temertech.com
# $Id: wcustsheet.tcl 14 2013-01-26 12:58:02Z tlu $
############################
if [winfo exists .custtex] then { 
    destroy .custtex
}

toplevel .custtex
wm title .custtex [mc "Customer Sheet"]
###
ttk::frame .custtex.f1

ttk::label .custtex.f1.l
ttk::entry .custtex.f1.e
grid .custtex.f1.l -padx 2m

###
#ttk::labelframe .custtex.f2 -text [mc "Data"]


###
ttk::frame .custtex.f3


ttk::button .custtex.f3.b1 -text [mc "Generate PDF"] -command {runcusttex}
ttk::button .custtex.f3.b2 -text [mc "View PDF"] -command {viewpdf custsheet.pdf}
ttk::button .custtex.f3.b3 -text [mc "Close"] -command {destroy .custtex}

pack .custtex.f3.b1 .custtex.f3.b2 .custtex.f3.b3 -side left -padx 2m

#
grid .custtex.f1 -row 1 -column 1 -padx 2m -pady 1m
#grid .custtex.f2 -row 2 -column 1 -padx 2m -pady 1m
grid .custtex.f3 -row 3 -column 1 -padx 2m -pady 1m
# EOF