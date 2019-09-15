# -*-Tcl-*-
## 2007-2014 Tomasz Luczak tlu@temertech.com
# $Id: procimport.tcl 23 2014-01-04 00:03:33Z tlu $
########################################
# 
proc importV2C idKey {
    global db

    set types {
	{{V2C} {.v2c}}
	{{C2V} {.c2v}}
	{{XML} {.xml}}
	{{All Files} *}
    }
    set filename [tk_getOpenFile -filetypes $types]

    if {$filename != ""} {
	# Open the file ...
	set filehandle [open "$filename" "rb"]
	fconfigure $filehandle -translation binary
	set data [read -nonewline $filehandle]
	close $filehandle
	set QUERY "UPDATE keys SET vtoc='$data' WHERE id='$idKey'"
	db eval $QUERY
	set data ""
    }

}
#############################################
# Import licenses from file
proc importLicense idKey {
    global db filewimport
    
    source $filewimport
    ttk::entry .import.f1.e0
    .import.f1.e0 insert end $idKey
    set QUERY "SELECT number FROM keys WHERE id=$idKey"
#    puts $QUERY
    db eval $QUERY value {
	.import.f1.e insert end $value(number)
    }
    .import.f1.e configure -state disabled
##########
    .import.f4.b1 configure -command {
	set filenameopen [tk_getOpenFile -filetypes {{"TXT" {*.txt *.TXT}}}]
	if { $filenameopen ne "" } then { 
	   set filecontents [string map {\n\n \n} [readscriptall $filenameopen]]
	    .import.pane.f3.text delete 0.0 end
	    .import.pane.f2.t delete 0 end
	    .import.pane.f3.text insert 0.0 $filecontents
	    set i "1"
	    #parse file line by line
	    while {[.import.pane.f3.text get $i.0 $i.end] ne ""} {
		set licenseRecord [split [.import.pane.f3.text get $i.0 $i.end] "#"]
		set license   [string trim [lindex $licenseRecord 0]]
		set productId [string trim [lindex $licenseRecord 1]]
		set quantity [string trim [lindex $licenseRecord 2]]
		if {$quantity eq ""} then {
			set quantity 1
		}
		set keyNo     [string trim [lindex $licenseRecord 4]]
		if {[string first . [lindex $licenseRecord 5]] eq "-1"} then {
			set date ""
		} else {
			set date [split [string trim [lindex $licenseRecord 5]] "."]
			set date "[string trim [lindex $date 2]].[string trim [lindex $date 1]].[string trim [lindex $date 0]]"
		}
		if {$keyNo eq [.import.f1.e get]} then {
		    set QUERY "SELECT name,id FROM products WHERE productid=$productId"
#		    puts $QUERY
		    set product ""
		    set idProduct ""
		    db eval $QUERY value {
			set product $value(name)
			set idProduct $value(id)
		    }
#		    if {[llength $licenseRecord] eq 5} then {
#			set dateOrig [split [string trim [lindex $licenseRecord 4]] .]
#			if {[llength $dateOrig] eq 3} then {
#			    set date "[lindex $dateOrig 2].[lindex $dateOrig 1].[lindex $dateOrig 0]"
#			} 
#		    }
		    .import.pane.f2.t insert end [list $license $product $date $quantity $idProduct]
		} else {
			puts "Different dongle/HostId"
		}
		incr i
	    }
	    .import.pane.f3.text highlight 0.0 end
	}
    }

#########
    .import.f4.b2 configure -command {
	set tableSize [.import.pane.f2.t size]
	if {$tableSize ne 0} then {
	    set i 0
	    while {$i < $tableSize} {
		# recognize existed licensed for update
		set QUERY "SELECT id FROM licenses WHERE id_key=\"[.import.f1.e0 get]\" AND id_product=\"[lindex [.import.pane.f2.t get $i] 4]\""
		# puts $QUERY
		set licenseId [db eval $QUERY]
		if {$licenseId eq ""} then {
			# puts "New license"
			set QUERY "INSERT INTO licenses(id_key,id_product,license_no,valid,quantity) VALUES (\"[.import.f1.e0 get]\",\"[lindex [.import.pane.f2.t get $i] 4]\",\"[lindex [.import.pane.f2.t get $i] 0]\",\"[lindex [.import.pane.f2.t get $i] 2]\",\"[lindex [.import.pane.f2.t get $i] 3]\")"
			# puts $QUERY
			db eval $QUERY
		} else {
			# puts "Existed license"
			set QUERY "UPDATE licenses SET license_no=\"[lindex [.import.pane.f2.t get $i] 0]\",valid=\"[lindex [.import.pane.f2.t get $i] 2]\",quantity=\"[lindex [.import.pane.f2.t get $i] 3]\" WHERE id_key=\"[.import.f1.e0 get]\" AND id_product=\"[lindex [.import.pane.f2.t get $i] 4]\""
			# puts $QUERY
			db eval $QUERY
		}			
		incr i
	    }
	}
	destroy .import
    }
}
# EOF