# -*-Tcl-*-
## 2007-2010 Tomasz Luczak tlu@temertech.com
# $Id: procadd.tcl 14 2013-01-26 12:58:02Z tlu $
########################################
# Add
###########
# Hardlock' Products
proc addLicense idKey {
    global db filewlicense
    source $filewlicense
    wm title .license [mc "Add license"]
    #  insert data into field
    ttk::entry .license.f.e0
    .license.f.e0 insert end $idKey
    set QUERY "SELECT number FROM keys WHERE id='$idKey'"
#    puts $QUERY
    db eval $QUERY value {
	.license.f.e1 insert end $value(number)
    }
    .license.f.e1 configure -state disabled
    .license.f.e5 insert end 1
    .license.f.b1 configure -text [mc "Add"] -command {
	set QUERY "SELECT id FROM products WHERE name='[.license.f.cb2 get]'"
#	puts $QUERY
	db eval $QUERY value {
	    set productId $value(id)
	}
	set valid "[lindex [.license.f.e4 getlist] 0].[lindex [.license.f.e4 getlist] 1].[lindex [.license.f.e4 getlist] 2]"
	if {$valid eq ".."} then {
	    set valid ""
	}
	set QUERY "INSERT INTO licenses(id_key,id_product,license_no,valid,quantity) VALUES ('[.license.f.e0 get]','$productId','[.license.f.e3 get]','$valid','[.license.f.e5 get]')"
#	puts $QUERY
	db eval $QUERY
    }
}
###########
# Hardlock
# add key for customer
proc addHardlock idCustomer {
    global db f2 filewkey

    source $filewkey
    wm title .key [mc "Add hardlock"]
    ttk::entry .key.f.e0
    .key.f.e0 insert end $idCustomer
    .key.f.l01 configure -text [getGustomerName $idCustomer]
    destroy .key.f.e1 \
	.key.f.l3 .key.f.e3 \
	.key.f.l6 .key.f.cb6 \
	.key.f.l7 .key.f.e7 \
	.key.f.l9 .key.f.e9 \
	.key.f.l10 .key.f.e10
    ttk::combobox .key.f.cb1 -values [getHardlocksList "" USB] -width 16
    grid .key.f.cb1 -row 1 -column 1  -padx 1m -pady 1m -sticky w
    .key.f.cb2 set "USB"
    .key.f.e4 put 0 [clock format [clock scan now] -format %Y]
    .key.f.e4 put 1 [clock format [clock scan now] -format %m]
    .key.f.e4 put 2 [clock format [clock scan now] -format %d]
    .key.f.e8 put 0 [clock format [clock scan now] -format %Y]
    .key.f.e8 put 1 [clock format [clock scan now] -format %m]
    .key.f.e8 put 2 [clock format [clock scan now] -format %d]
    bind .key.f.cb1  <<ComboboxSelected>> {}
    bind .key.f.cb2  <<ComboboxSelected>> {
	.key.f.cb1 configure -values [getHardlocksList "" [.key.f.cb2 get]]
	.key.f.cb1 set ""
    }
    .key.f.b1 configure  -text [mc "Add"] -command {
	set number [.key.f.cb1 get]
	set type [.key.f.cb2 get]
	set date_out "[lindex [.key.f.e4 getlist] 0].[lindex [.key.f.e4 getlist] 1].[lindex [.key.f.e4 getlist] 2]"
	set date_sold "[lindex [.key.f.e8 getlist] 0].[lindex [.key.f.e8 getlist] 1].[lindex [.key.f.e8 getlist] 2]"
	if {$date_sold eq ".."} then {
	    set date_sold ""
	}
	set doc_no [.key.f.e5 get]
	set idCustomer  [.key.f.e0 get]
	set QUERY "SELECT id FROM keys WHERE number='$number'"
#	puts $QUERY
	set idKey [db eval $QUERY]
	if {$idKey ne ""} then {
	    # Sold keys
	    set QUERY "INSERT INTO soldkeys(id_key,id_customer,date_sold,date_maint,active_maint) VALUES ('$idKey','$idCustomer','$date_sold','','0')"
#	    puts $QUERY
	    db eval $QUERY
	    # Keys
	    set QUERY "UPDATE keys SET date_out='$date_out',doc_no='$doc_no' WHERE id='$idKey'"
#	    puts $QUERY
	    db eval $QUERY
   	    destroy .key
	}
    }
}
###########
# Key
# to add key database

proc addKey {} {
    global db filewkey wkeyActive

    set wkeyActive 1
    set wkeyMaint '1'

    source $filewkey
    wm title .key [mc "Add key"]
    destroy .key.f.l0 .key.f.l01 \
	.key.f.l4 .key.f.e4 \
	.key.f.l6 .key.f.cb6 \
	.key.f.l8 .key.f.e8 \
	.key.f.l9 .key.f.e9 \
	.key.f.l10 .key.f.e10
    
    .key.f.cb2 set "USB"
    .key.f.cb2 configure -state readonly
    .key.f.e3 put 0 [clock format [clock scan now] -format %Y]
    .key.f.e3 put 1 [clock format [clock scan now] -format %m]
    .key.f.e3 put 2 [clock format [clock scan now] -format %d]
    
    .key.f.b1 configure -text [mc "Add"] -command {
	set number [.key.f.e1 get]
	set QUERY "SELECT id FROM keys WHERE number='$number'"
#	puts $QUERY
	if {[db eval $QUERY] eq ""} then {
	    set type [.key.f.cb2 get]
	    set date_in "[lindex [.key.f.e3 getlist] 0].[lindex [.key.f.e3 getlist] 1].[lindex [.key.f.e3 getlist] 2]"
	    if {$date_in eq ".."} then {
		set date_in ""
	    }
	    set date_out ""
	    set doc_no [.key.f.e5 get]
	    set QUERY "INSERT INTO keys(number,type,date_in,date_out,doc_no,current) VALUES ('$number','$type','$date_in','$date_out','$doc_no','$wkeyActive')"
#	    puts $QUERY
	    db eval $QUERY
	    reloadKeysList
	} else {
	    tk_messageBox -title [mc "Oops"] -message [mc "Key exists"]
	}
    }
}
########
# Product
proc addProduct {} {
    global db filewproduct
    
    source $filewproduct
    wm title .product [mc "Add product"]
    .product.f.cb3 configure -state readonly
    .product.f.b1 configure -text [mc "Add"] -command {
	set product [.product.f.e1 get]
	set productId [.product.f.e5 get]
	set QUERY "SELECT id FROM products WHERE name='$product'"
#	puts $QUERY
	if {[db eval $QUERY] eq ""} then {
	    set kind $kindProduct
	    set firstRelease [getReleaseId [.product.f.cb3 get]]
	    set lastRelease [getReleaseId [.product.f.cb4 get]]
	    set QUERY "INSERT INTO products(name,main_add,id_release_first,id_release_last,productid) VALUES ('$product','$kind','$firstRelease','$lastRelease','$productId')"
#	    puts $QUERY
	    db eval $QUERY
	    reloadProductList
	} else {
	    tk_messageBox -title [mc "Oops"] -message [mc "Product exists"]
	}
    }
}
########
# Release
proc addRelease {} {
    global db filewrelease
    
    source $filewrelease
    wm title .release [mc "Add release"]
    .release.f.b1 configure -text [mc "Add"] -command {
	set name [.release.f.e1 get]
	set dateStart "[lindex [.release.f.e2 getlist] 0].[lindex [.release.f.e2 getlist] 1].[lindex [.release.f.e2 getlist] 2]"
	set dateEnd "[lindex [.release.f.e3 getlist] 0].[lindex [.release.f.e3 getlist] 1].[lindex [.release.f.e3 getlist] 2]"
	if {$dateStart eq ".."} then {
	    set dateStart ""
	}
	if {$dateEnd eq ".."} then {
	    set dateEnd ""
	}
	set QUERY "INSERT INTO releases(name,date_start,date_end) VALUES ('$name','$dateStart','$dateEnd')"
#	puts $QUERY
	db eval $QUERY
	reloadReleaseList
    }
}
########
# Customer
proc addCustomer {} {
    global db filewcustomer

    source $filewcustomer
    wm title .customer [mc "Add customer"]
    .customer.f.b1 configure -text [mc "Add"] -command {
	set name [.customer.f.e1 get]
	set city [.customer.f.e2 get]
	set customerId [.customer.f.e3 get]
	set zipcode [.customer.f.e4 get]
	set address [.customer.f.e5 get]
	set comment [.customer.f.e6 get]
	set person [.customer.f.e7 get]
	set phone [.customer.f.e8 get]
	set email [.customer.f.e9 get]
	set QUERY "INSERT INTO customers(name,city,customer_id,zip,address,comment,person,phone,email) VALUES ('$name','$city','$customerId','$zipcode','$address','$comment','$person','$phone','$email')"
#	puts $QUERY
	db eval $QUERY
	reloadCustomerList
    }
}

# EOF