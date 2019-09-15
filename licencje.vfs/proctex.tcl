# -*-Tcl-*-
## 2007-2010 Tomasz Luczak tlu@temertech.com
# $Id: proctex.tcl 14 2013-01-26 12:58:02Z tlu $
########################################
# 2009-02-15
proc customerSheet idCustomer {
    global db filewcustsheet
    source $filewcustsheet
    .custtex.f1.e insert end $idCustomer
    puts $idCustomer
    set QUERY "SELECT * FROM customers WHERE id=$idCustomer"
#   puts $QUERY
    db eval $QUERY value {
	.custtex.f1.l configure -text "$value(name)\n$value(zip)\n$value(city)\n$value(address)"
    }

}
############
# 2009-02-15
# generate Customer Sheet and run pdftex
proc runcusttex {} {
    global db inifilehandle pathToTMP pathToPDF windows
    set idCustomer [.custtex.f1.e get]

    # Customer data
    set QUERY "SELECT * FROM customers WHERE id=$idCustomer"
#   puts $QUERY
    db eval $QUERY value {
	.custtex.f1.l configure -text "$value(name)\n$value(zip)\n$value(city)\n$value(address)"
	set customerId $value(customer_id)
    }
    #set filecontents "\\newcommand{\\custdata}{$value(name)\\\\$value(address)\\\\$value(zip) $value(city)}\n\\newcommand{\\custperson}{$value(person), $value(phone), \\verb+$value(email)+}\n\\newcommand{\\customerno}{$value(customer_id)}"
    set filecontents "\\newcommand{\\custdata}{$value(name)\\\\$value(address)\\\\$value(zip) $value(city)}\n\\newcommand{\\custperson}{$value(person), $value(phone)}\n\\newcommand{\\customerno}{$value(customer_id)}"
    #puts $filecontents

    set filename [file join $pathToTMP customer.tex]
    writescript $filecontents $filename w+

    # Product data (dongle no, dongle type, main products, quantity)
    set filecontents ""
    set QUERY "
SELECT keys.id,keys.number,keys.type,products.name,licenses.quantity 
FROM keys,products,licenses 
WHERE keys.id IN (SELECT id_key FROM soldkeys WHERE id_customer=$idCustomer) and keys.current='1'  and  main_add='1' and products.id=licenses.id_product and licenses.id_key=keys.id"
#   puts $QUERY
    db eval $QUERY value {
	append filecontents "$value(number) & $value(type) & $value(name) -- $value(quantity),&  \\\\"

    }
    #puts $filecontents

    set filename [file join $pathToTMP products.tex]
    writescript $filecontents $filename w+

    if {$windows eq 1} then {
	executeprocess 0 inf 00_start2.bat
    } else {
	puts [pwd]
	executeprocess 0 inf ./00_start2.sh
    }
    file copy -force [file join $pathToTMP custsheet.pdf] [file join $pathToPDF sheet_$customerId.pdf]
}


#### 
proc exportV2C idKey {
    global db
    #
    set QUERY "SELECT number FROM keys WHERE id='$idKey'"
    set filenameinitial "[db eval $QUERY].v2c"
    set filename "[tk_getSaveFile -initialfile $filenameinitial]"

    if {$filename != ""} {
	#
	set QUERY "SELECT vtoc FROM keys WHERE id='$idKey'"
	set data [string range [db eval $QUERY] 1 end-1]
	# Save the file ...
	set filehandle [open "$filename" "wb"]
	fconfigure $filehandle -translation binary
	puts $filehandle $data
	close $filehandle
	set data ""
    }
}

############
# 2011-06-26
proc generateLicense idKey {
    global db filewtex pathToTXT
    
    source $filewtex
    set QUERY "SELECT number FROM keys WHERE id=$idKey"
    ttk::entry .tex.f3.e0
    .tex.f3.e0 insert end $idKey
#   puts $QUERY
    db eval $QUERY value {
	.tex.f3.e insert end $value(number)
    }
    .tex.f3.e configure -state disabled
    #
    .tex.pane.f2.text delete 0.0 end
    .tex.pane.f2.text insert 0.0 "# Dongle/HostId [.tex.f3.e get]"
    if {$idKey ne ""} then {
	set QUERY "SELECT licenses.quantity, licenses.valid, licenses.license_no, licenses.id_product, products.name, products.productid, products.main_add FROM licenses,products WHERE products.id = licenses.id_product AND licenses.id_key=$idKey ORDER BY products.main_add DESC, products.name ASC"
#	puts $QUERY
	db eval $QUERY values {
	    .tex.pane.f2.text insert end "\n$values(license_no) # $values(quantity) # $values(productid) $values(name) # $values(valid) "
	}
    }
    .tex.pane.f2.text highlight 0.0 end
}

############
# 2009-02-15
# generate tex and run pdftex
proc runtex {} {
    global inifilehandle pathToTMP pathToPDF windows
    
    puts "runtex"
    cursorwait 1
    buttonlock 1

    #customer
    set QUERY "SELECT id_customer FROM soldkeys WHERE id_key='[.tex.f3.e0 get]'"
#   puts $QUERY
    set QUERY "SELECT * FROM customers WHERE id=[db eval $QUERY]"
#   puts $QUERY
    db eval $QUERY value {
	set filecontents "\\newcommand{\\customer}{$value(name)\\\\$value(address)\\\\$value(zip) $value(city)}\n\\newcommand{\\customerno}{$value(customer_id)}"
    #puts $filecontents
    } 
    
    set filename [file join $pathToTMP customer.tex]
    writescript $filecontents $filename w+

    #key
    set filecontents "\\newcommand{\\key}{[.tex.f3.e get]}"
    set filename [file join $pathToTMP key.tex]
    writescript $filecontents $filename w+

    #table of license
    set filecontents ""
    set i "2"
    while {[.tex.pane.f2.text get $i.0 $i.end] ne ""} {
	set record [split [.tex.pane.f2.text get $i.0 $i.end] #]
	#puts $record
	append filecontents "[lindex $record 2] & [lindex $record 1] & \\texttt{[lindex $record 0]}\\\\ \\hline\n"
	 incr i
    }
	    
    set filename [file join $pathToTMP table.tex]    
    writescript $filecontents $filename w+
    if {$windows eq 1} then {
	puts "Windows"
	executeprocess 0 inf 00_start1.bat
    } else {
	executeprocess 0 inf ./00_start1.sh
    }
    file copy -force [file join $pathToTMP license.pdf] [file join $pathToPDF [.tex.f3.e get].pdf]
    cursorwait 0
    buttonlock 0
}

######
# view PDF
proc viewpdf pdffile {
    global pathToTMP pathToAcrobat
    set filenamepdf [file join $pathToTMP $pdffile]
    if [file exists $filenamepdf] then {
	#catch {exec acroread  $filemainpdfready &}
	catch {exec $pathToAcrobat  $filenamepdf &}
    } 
}
#####
# save into file ELCAD_ID
proc saveELCAD_ID {} {
    global inifilehandle pathToTXT

#    .tex.f3.b3 configure -command {
#	tk_getSaveFile -initialdir $pathToTXT
#    }
    set filecontents [.tex.pane.f2.text get 0.0 end]
    set filename [file join $pathToTXT ELCAD_ID.[.tex.f3.e get]]   
    writescript $filecontents $filename w+

}
#####
# 2011.06.26
proc generateStatList {productId customerIdList} {
    global db filewcustlist
    global fcName fcCity fcZip fcAddress fcCustomerId fcPerson fcEmail fcPhone fcComment fcLabel
  
    source $filewcustlist

    if {$productId ne ""} then {
	set QUERY "SELECT name FROM products WHERE id='$productId'"
#	puts $QUERY
	db eval $QUERY value {
	    .custlist.f4.e insert end $value(name)
	}
    }
    .custlist.f4.e configure -state disabled
    #
    .custlist.pane.f2.text delete 0.0 end
    if {$productId ne ""} then {
	.custlist.pane.f2.text insert 0.0 "# [mc "Product"]: [.custlist.f4.e get]"
    } else {
	.custlist.pane.f2.text insert 0.0 "% [mc "Customer list"]\n"
    }
    if {$customerIdList ne ""} then {
	foreach i $customerIdList {
	    set QUERY "SELECT * FROM customers WHERE id=$i"
#	    puts $QUERY
	    db eval $QUERY values {
		if {$fcLabel eq "0"} then {
			if {$fcName eq "1"} then {set name $values(name)} else {set name ""}
			if {$fcCity eq "1"} then {set city "# $values(city)"} else {set city ""}
			if {$fcZip eq "1"} then {set zip "# $values(zip)"} else {set zip ""}
			if {$fcAddress eq "1"} then {set address "# $values(address)"} else {set address ""}
			if {$fcCustomerId eq "1"} then {set customerId "# $values(customer_id)"} else {set customerId ""}
			if {$fcPerson eq "1"} then {set person "# $values(person)"} else {set person ""}
			if {$fcEmail eq "1"} then {set email "# $values(email)"} else {set email ""}
			if {$fcPhone eq "1"} then {set phone "# $values(phone)"} else {set phone ""}
			if {$fcComment eq "1"} then {set comment "# $values(comment)"} else {set comment ""}
			.custlist.pane.f2.text insert end "\n$name $city $zip $address $customerId $person $email $phone $comment"
		} else {
			set persons [split $values(person) ";"]
			foreach person $persons {
				.custlist.pane.f2.text insert end "Sz.P. $person\n$values(name)\n$values(address)\n$values(zip) $values(city)\n\n"
			}
		}
	    }
	}
    }
    .custlist.pane.f2.text highlight 0.0 end
    #
    .custlist.f4.b3 configure -command {
	if {$inifilehandle ne ""} then {
	    if [ini::exists $inifilehandle main pathToTXT] then {
		set pathToTXT [::ini::value $inifilehandle main pathToTXT]
	    } else {
		set pathToTXT ""
	    }
	} else {
	    set pathToTXT ""
	}
	set filecontents [.custlist.pane.f2.text get 0.0 end]
	set filename [tk_getSaveFile -initialdir $pathToTXT]
	writescript $filecontents $filename w+
    }
}
########
# 2011-06-26
proc generateKeyList keyIdList {
    global db filewkeylist
    global fkNumber fkType fkDateIn fkDateOut fkDocNo fkCurrent fkPrevious
    
    source $filewkeylist

    .keylist.pane.f2.text delete 0.0 end
    .keylist.pane.f2.text insert 0.0 "# [mc "List of dongles and flying licenses"]"
    if {$keyIdList ne ""} then {
	foreach idKey $keyIdList {
	    set QUERY "SELECT * FROM keys WHERE id=$idKey"
#	    puts $QUERY
	    db eval $QUERY values {
		if {$fkNumber eq 1} then {set number $values(number)} else {set number ""}
		if {$fkType eq 1} then {set type "# $values(type)"} else {set type ""}
		if {$fkDateIn eq 1} then {set dateIn "# $values(date_in)"} else {set dateIn ""}
		if {$fkDateOut eq 1} then {set dateOut "# $values(date_out)"} else {set dateOut ""}
		if {$fkDocNo eq 1} then {set docNo "# $values(doc_no)"} else {set docNo ""}
		if {$fkCurrent eq 1} then {set current "# $values(current)"} else {set current ""}
		if {$fkPrevious eq 1} then {
		    set QUERY "SELECT number FROM keys WHERE id='$values(previous)'"
#		    puts $QUERY
		    set previous "# [db eval $QUERY]"
		} else {set previous ""}
		.keylist.pane.f2.text insert end "\n$number $type $dateIn $dateOut $docNo $current $previous"
	    }
	}
	.keylist.pane.f2.text highlight 0.0 end
    }
    # Save to file
    .keylist.f4.b3 configure -command {
	if {$inifilehandle ne ""} then {
	    if [ini::exists $inifilehandle main pathToTXT] then {
		set pathToTXT [::ini::value $inifilehandle main pathToTXT]
	    } else {
		set pathToTXT ""
	    }
	} else {
	    set pathToTXT ""
	}
	tk_getSaveFile -initialdir $pathToTXT
    }
}
# EOF