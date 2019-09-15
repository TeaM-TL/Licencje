# -*-Tcl-*-
## 2007-2010 Tomasz Luczak tlu@temertech.com
# $Id: procreplace.tcl 14 2013-01-26 12:58:02Z tlu $
########################################
###########
# remove License
proc removeLicense rowData {
    global db f2 rowf2f41

    set answer [tk_messageBox  -type yesno -icon question \
		    -title [mc "Remove key"] \
		    -message [mc "Are you sure to remove this license from current key?"]]
    
    if {$answer eq "yes"} then {
    #focus $f2.f4.f42.t
	set idLicense [lindex $rowData 0]
	set QUERY "DELETE FROM licenses WHERE id='$idLicense'"
#	puts $QUERY
	db eval $QUERY
    } 
    reloadCustomerProductsList [lindex [$f2.f4.f41.t get $rowf2f41] 0]
}
###########
# remove Hardlock
proc removeHardlock idSold {
    global db 

    set answer [tk_messageBox  -type yesno -icon question \
		    -title [mc "Remove key"] \
		    -message [mc "Are you sure to remove this key from current customer?"]]
    
    if {$answer eq "yes"} then {
	set QUERY "DELETE FROM soldkeys WHERE id='$idSold'"
#	puts $QUERY
	db eval $QUERY
    } 
}
##########
# replace dongle/felics server
proc replaceHardlock idKey {
    global filewkey db 
    set keyList ""
    
    source $filewkey
    wm title .key [mc "Replace key"]
    #  insert data into field
    set QUERY "SELECT * FROM keys WHERE id=$idKey"
 #   puts "1. $QUERY"
    db eval $QUERY value {
	set keyNumber  $value(number)
	set keyType    $value(type)
	set keyDateIn  $value(date_in)
	set keyDateOut $value(date_out)
	set keyDocNo   $value(doc_no)
	set keyPrevious $value(previous)
	set keyCurrent $value(current)
    }
    ttk::entry .key.f.e0
    .key.f.e0 insert end $idKey
    #
    .key.f.e1 insert end $keyNumber
    .key.f.e1  configure -state disabled
    .key.f.cb2 insert end $keyType
    .key.f.cb2 configure -state disabled
    .key.f.e3  configure -state disabled
    .key.f.e4  configure -state disabled
    .key.f.e5  configure -state disabled
    .key.f.e7  configure -state disabled
    #
    set QUERY "SELECT id_customer FROM soldkeys WHERE id_key='$idKey'"
#    puts "2. $QUERY"
    db eval $QUERY value {
	set idCustomer $value(id_customer)
    }
    set QUERY "SELECT number FROM keys WHERE (id IN (SELECT id_key FROM soldkeys WHERE (id_customer='$idCustomer'))) AND (current='1') AND (id <> $idKey)"
#    puts "3. $QUERY"
    db eval $QUERY keysvalues {
	lappend keyList $keysvalues(number)
    }
    .key.f.cb6  configure -values $keyList
    #
    # reconfigure button
    .key.f.b1 configure -text [mc "Modify"] -command {
	set QUERY "SELECT id FROM keys WHERE number='[.key.f.cb6 get]'"
#	puts "4. $QUERY"
	db eval $QUERY value {
	    set idOld $value(id)
	}
	set QUERY "UPDATE keys SET current='0' WHERE id='$idOld'"
#	puts "5. $QUERY"
	db eval $QUERY
	set QUERY "UPDATE keys SET previous='$idOld' WHERE id='[.key.f.e0 get]'"
#	puts "6. $QUERY"
	db eval $QUERY
#	
	destroy .key
    }
}

# EOF