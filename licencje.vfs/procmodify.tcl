# -*-Tcl-*-
## 2007-2010 Tomasz Luczak tlu@temertech.com
# $Id: procmodify.tcl 14 2013-01-26 12:58:02Z tlu $
########################################
# Modify

###########
proc modifyLicense rowData {
    global filewlicense db wkeyActive wkeyMaint f2 rowf2f41

    source $filewlicense
    wm title .license [mc "Modify license"]
    #  insert data into field
    ttk::entry .license.f.e0
    .license.f.e0 insert end [lindex $rowData 0]

    .license.f.e1 insert end [lindex $rowData 1]
    .license.f.e1 configure -state disabled
    .license.f.cb2 set [lindex $rowData 2]
    .license.f.e3 insert end [lindex $rowData 3]
    set valid [lindex $rowData 4]
    if {$valid ne ""} then {
	.license.f.e4 put 0 [lindex [split $valid .] 0]
	.license.f.e4 put 1 [lindex [split $valid .] 1]
	.license.f.e4 put 2 [lindex [split $valid .] 2]
    } 
    .license.f.e5 insert end [lindex $rowData 5]
    # button
    .license.f.b1 configure -text [mc "Modify"] -command {
	set QUERY "SELECT id FROM products WHERE name='[.license.f.cb2 get]'"
#	puts $QUERY
	db eval $QUERY value {
	    set productId $value(id)
	}
	set valid "[lindex [.license.f.e4 getlist] 0].[lindex [.license.f.e4 getlist] 1].[lindex [.license.f.e4 getlist] 2]"
	if {$valid eq ".."} then {
	    set valid ""
	}
	set idLicense [.license.f.e0 get]
	set QUERY "UPDATE licenses SET id_product='$productId',license_no='[.license.f.e3 get]',valid='$valid',quantity='[.license.f.e5 get]' WHERE id='$idLicense'"
#	puts $QUERY
	db eval $QUERY
	destroy .license
    reloadCustomerProductsList [lindex [$f2.f4.f41.t get $rowf2f41] 0]
    }
}
###########
# Key
# modify hardlock/dongle/Host-ID
proc modifyKey idKey {
    global filewkey db wkeyActive wkeyMaint
    
    source $filewkey
    wm title .key [mc "Modify key"]
    ttk::entry .key.f.e0
    .key.f.e0 insert end $idKey
    
    set QUERY "SELECT id_customer FROM soldkeys WHERE id_key='$idKey'"
#    puts $QUERY
    db eval $QUERY value {
	.key.f.l01 configure -text [getGustomerName $value(id_customer)]
    }
    #  insert data into field
    set QUERY "SELECT * FROM keys WHERE id=$idKey"
#    puts $QUERY
    db eval $QUERY value {
	set keyNumber  $value(number)
	set keyType    $value(type)
	set keyDateIn  $value(date_in)
	set keyDateOut $value(date_out)
	set keyDocNo   $value(doc_no)
	set keyPrevious $value(previous)
	set wkeyActive $value(current)
    }
    .key.f.e1 insert end $keyNumber
    .key.f.cb2 insert end $keyType
    
    if {$keyDateIn ne ""} then {
	.key.f.e3 put 0 [lindex [split $keyDateIn .] 0]
	.key.f.e3 put 1 [lindex [split $keyDateIn .] 1]
	.key.f.e3 put 2 [lindex [split $keyDateIn .] 2]
    }
    if {$keyDateOut ne ""} then {
	.key.f.e4 put 0 [lindex [split $keyDateOut .] 0]
	.key.f.e4 put 1 [lindex [split $keyDateOut .] 1]
	.key.f.e4 put 2 [lindex [split $keyDateOut .] 2]
    }
    .key.f.e5 insert end $keyDocNo
    if {$keyPrevious ne ""} then {
	set QUERY "SELECT number FROM keys WHERE id='$keyPrevious'"
#	puts $QUERY
	.key.f.cb6 set [db eval $QUERY]
    }
    .key.f.cb6 configure -state disabled

    # Maintenance
    set QUERY "SELECT * FROM soldkeys WHERE id_key=$idKey"
    db eval $QUERY value {
	if {$value(date_sold) ne ""} then {
	    .key.f.e8 put 0 [lindex [split $value(date_sold) .] 0]
	    .key.f.e8 put 1 [lindex [split $value(date_sold) .] 1]
	    .key.f.e8 put 2 [lindex [split $value(date_sold) .] 2]
	}
	if {$value(date_maint) ne ""} then {
	    .key.f.e10 put 0 [lindex [split $value(date_maint) .] 0]
	    .key.f.e10 put 1 [lindex [split $value(date_maint) .] 1]
	    .key.f.e10 put 2 [lindex [split $value(date_maint) .] 2]
	}
	set wkeyMaint $value(active_maint)
    }
	

    # configure button
    .key.f.b1 configure -text [mc "Modify"] -command {
	set number   [.key.f.e1 get]
	set type     [.key.f.cb2 get]
	set date_in "[lindex [.key.f.e3 getlist] 0].[lindex [.key.f.e3 getlist] 1].[lindex [.key.f.e3 getlist] 2]"
	if {$date_in eq ".."} then {
	    set date_in ""
	}
	set date_out "[lindex [.key.f.e4 getlist] 0].[lindex [.key.f.e4 getlist] 1].[lindex [.key.f.e4 getlist] 2]"
	if {$date_out eq ".."} then {
	    set date_out ""
	}
	set doc_no   [.key.f.e5 get]
	set id [.key.f.e0 get]
	set QUERY "
UPDATE keys 
SET number='$number',type='$type',date_in='$date_in',date_out='$date_out',doc_no='$doc_no',current='$wkeyActive' 
WHERE id='$id'"
#	puts $QUERY
	db eval $QUERY
	####
	# soldkeys
	set date_maint "[lindex [.key.f.e10 getlist] 0].[lindex [.key.f.e10 getlist] 1].[lindex [.key.f.e10 getlist] 2]"
	if {$date_maint eq ".."} then {
	    set date_maint ""
	}
	set QUERY "
UPDATE soldkeys 
SET date_maint='$date_maint',active_maint='$wkeyMaint' 
WHERE id_key='$id'"
#	puts $QUERY
	db eval $QUERY
	reloadKeysList
	destroy .key
    }
}
########
# Product
proc modifyProduct {} {
    global filewproduct db f5 rowf5f2 kindProduct
    
    source $filewproduct
    wm title .product [mc "Modify product"]
    #  insert data into field 
    set rowData [$f5.f2.t get $rowf5f2]
    .product.f.e1 insert end [lindex $rowData 1]
    set kindProduct [lindex $rowData 2]
    .product.f.cb3 set [lindex $rowData 3]
    .product.f.cb4 set [lindex $rowData 4]
    .product.f.e5 insert end [lindex $rowData 5]
    .product.f.b1 configure -text [mc "Modify"] -command {
	set id [lindex [$f5.f2.t get $rowf5f2] 0]
	set product [.product.f.e1 get]
	set kind $kindProduct
	set firstRelease [getReleaseId [.product.f.cb3 get]]
	set lastRelease [getReleaseId [.product.f.cb4 get]]
	set productId [.product.f.e5 get]
	set QUERY "UPDATE products SET name='$product',main_add='$kind',id_release_first='$firstRelease',id_release_last='$lastRelease',productid='$productId' WHERE id='$id'"
#	puts $QUERY
	db eval $QUERY
	reloadProductList
	destroy .product
    }
}
########
# Release
proc modifyRelease {} {
    tk_messageBox -message "Not ready yet"
}
########
# Customer
proc modifyCustomer {} {
    global filewcustomer db f2 rowf2f2
    
    source $filewcustomer
    wm title .customer [mc "Modify customer"]
    #  insert data into field
    set rowData [$f2.f2.t get $rowf2f2]
    set QUERY "SELECT * FROM customers WHERE id='[lindex $rowData 0]'"
#    puts $QUERY
    db eval $QUERY values {
	.customer.f.e1 insert end $values(name)
	.customer.f.e2 insert end $values(city)
	.customer.f.e3 insert end $values(customer_id)
	.customer.f.e4 insert end $values(zip)
	.customer.f.e5 insert end $values(address)
	.customer.f.e6 insert end $values(comment)
	.customer.f.e7 insert end $values(person)
	.customer.f.e8 insert end $values(phone)
	.customer.f.e9 insert end $values(email)
    }
    # reconfigure button
    .customer.f.b1 configure -text [mc "Modify"] -command {
	set name [.customer.f.e1 get]
	set city [.customer.f.e2 get]
	set customerId [.customer.f.e3 get]
	set zipcode [.customer.f.e4 get]
	set address [.customer.f.e5 get]
	set comment [.customer.f.e6 get]
	set person [.customer.f.e7 get]
	set phone [.customer.f.e8 get]
	set email [.customer.f.e9 get]
	set id [lindex [$f2.f2.t get $rowf2f2] 0]
	set QUERY "UPDATE customers SET name='$name',city='$city',customer_id='$customerId',zip='$zipcode',address='$address',comment='$comment',person='$person',phone='$phone',email='$email' WHERE id='$id'"
#	puts $QUERY
	db eval $QUERY
	reloadCustomerList
	destroy .customer
    }
}

# EOF