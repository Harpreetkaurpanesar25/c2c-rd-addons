{
     "name"         : "Product by Stock Location",
     "version"      : "1.0",
     "author"       : "Camptocamp Austria",
     "website"      : "http://www.camptocamp.com",
     "description"  : """Shows quantity and amount of products per stock location
""",
     "category"     : "Warehouse Management",
     "depends"      : ["stock"],
     "init_xml"     : [],
     "demo_xml"     : [],
     "update_xml"   : ["stock_product_by_location_view.xml","security/ir.model.access.csv"],
     "active"       : False,
     "installable"  : True
}

