<html>
<head>
    <style type="text/css">
        ${css}
        pre {font-family:helvetica; font-size:12;}
    </style>
</head>
<body>
    <style  type="text/css">
     table {
       width: 100%;
       page-break-after:auto;
       border-collapse: collapse;
       cellspacing="0";
       font-size:12px;
           }
     td { margin: 0px; padding: 3px; border: 1px solid lightgrey;  vertical-align: top; }
     pre {font-family:helvetica; font-size:15;}
    </style>
    <%
    def carriage_returns(text):
        return text.replace('\n', '<br />')
    %>

    %for inv in objects :
    <% setLang(inv.partner_id.lang) %>
<br>
    <table  >
<!-- ****************************
left Address
******************************-->
        %if inv.company_id.address_label_position == 'left':
         <tr>
         <td style="width:50%">
%if inv.type in ('in_invoice','in_refund'):
${_("Supplier Address")}
<hr>
%endif
${inv.address_invoice_id.address_label|carriage_returns}
         </td>
         <td style="width:50%">
<table {border:none} >
         %if inv.address_invoice_id.phone :
<tr>
<td> ${_("Phone")}</td><td> ${inv.address_invoice_id.phone|entity} </td
</tr>
        %endif
        %if inv.address_invoice_id.fax :
<tr>
<td>${_("Fax")}</td><td> ${inv.address_invoice_id.fax|entity} </td>
</tr>
        %endif
        %if inv.address_invoice_id.email :
<tr>
<td>${_("Mail")}</td><td>${inv.address_invoice_id.email|entity} </td>
</tr>
        %endif
        %if inv.partner_id.vat :
<tr>
<td>${_("VAT")}</td><td> ${inv.partner_id.vat|entity} </td>
</tr>
        %endif
</table>
         </td>
        </tr>
        %endif
<!-- ****************************
right Address
******************************-->
        %if inv.company_id.address_label_position == 'right' or not inv.company_id.address_label_position:
         <tr>
         <td style="width:50%">
<table {border:none} >
         %if inv.address_invoice_id.phone :
<tr>
<td> ${_("Phone")}</td><td> ${inv.address_invoice_id.phone|entity} </td
</tr>
        %endif
        %if inv.address_invoice_id.fax :
<tr>
<td>${_("Fax")}</td><td> ${inv.address_invoice_id.fax|entity} </td>
</tr>
        %endif
        %if inv.address_invoice_id.email :
<tr>
<td>${_("Mail")}</td><td>${inv.address_invoice_id.email|entity} </td>
</tr>
        %endif
        %if inv.partner_id.vat :
<tr>
<td>${_("VAT")}</td><td> ${inv.partner_id.vat|entity} </td>
</tr>
        %endif
</table>
         </td>
         <td style="width:50%">
%if inv.type in ('in_invoice','in_refund'):
${_("Supplier Address")}
<hr>
%endif
${inv.address_invoice_id.address_label|carriage_returns}
         </td>
        </tr>
        %endif

    </table>
    <br>
    <br>
    %if inv.type == 'out_invoice' :
    <h1 style="clear:both;">${_("Customer Invoice")} ${inv.number or ''|entity}</h1>
    %elif inv.type == 'in_invoice' :
    <h1 style="clear:both;">${_("Supplier Invoice")} ${inv.number or ''|entity}</h1>
    %elif inv.type == 'out_refund' :
    <h1 style="clear:both;">${_("Customer Refund")} ${inv.number or ''|entity}</h1>
    %elif inv.type == 'in_refund' :
    <h1 style="clear:both;">${_("Supplier Refund")} ${inv.number or ''|entity}</h1>
    <span class="title">${_("Supplier Refund")} ${inv.number or ''|entity}</span> 
    %endif
    %if inv.state == 'cancel' :
    <h1 style="clear:both;">${inv.state}</h1> 
    %endif
    <br/>
    <br/>
    <table >
        <tr>
          %if inv.name :
            <td>${_("Customer Ref")}</td>
          %endif
          %if inv.origin:
            <td>${_("Origin")}</td>
          %endif
          %if inv.reference:
            <td>${_("Reference")}</td>
          %endif
            <td style="white-space:nowrap">${_("Invoice Date")}</td>
            <td style="white-space:nowrap">${_("Payment Term")}</td>
            <td style="white-space:nowrap">${_("Due Date")}</td>
            <td>${_("Curr")}</td>
        </tr>
        <tr>
          %if inv.name :
            <td>${inv.name.rfind(':') > 0 and inv.name[:inv.name.rfind(':')] or inv.name}</td>
          %endif
          %if inv.origin :
            <td>${inv.origin} </td>
          %endif
          %if inv.reference :
             <td>${inv.reference}</td>
          %endif
          <td>${formatLang(inv.date_invoice, date=True)|entity}</td>
          <td>${inv.payment_term.name or ''}</td>
          <td>${inv.date_due or ''}</td>
         <td>${inv.currency_id.name}</td></tr>
    </table>
    <h1><br /></h1>
    <table >
        <thead>
          <tr>
%if inv.print_code:
            <th>${_("Code")}</th>
            <th>${_("Description")}</th>
%else:
            <th>${_("Description")}</th>
%endif
%if inv.print_ean:
            <th>${_("EAN")}</th>
%endif
            <th class>${_("Taxes")}</th>
            <th class style="text-align:left;">${_("QTY")}</th>
            <th class>${_("Unit")}</th>
            <th style="text-align:left;white-space:nowrap;">${_("Unit Price")}</th>
          %if inv.print_price_unit_id == True:
            <th style="text-align:left;">${_("Price/Unit")}</th>
          %endif
          %if inv.amount_discount != 0:
            <th style="text-align:left;">${_("Disc.(%)")}</th>
          %endif
            <th style="text-align:left;">${_("Price")}</th>
         </tr>
        </thead>
        %for line in inv.invoice_line :
        <tbody>
        <tr>
%if inv.print_code:
           <td>${line.product_id.default_code or ''|entity}</td>
           <td>${line.product_id.name or line.name|entity}</td>
%else:
           <td>${line.name|entity}</td>
%endif
%if inv.print_ean:
            <td>${line.product_id.ean13 or ''}</td>
%endif
           <td>${ ', '.join([ tax.name or '' for tax in line.invoice_line_tax_id ])|entity}</td>
           <td style="white-space:nowrap;text-align:right;">${line.quantity}</td>
           <td style="white-space:nowrap;text-align:left;">${line.uos_id.name or _("Unit")}</td>
           <td style="white-space:nowrap;text-align:right;">${formatLang('price_unit_pu' in line._columns and line.price_unit_pu or line.price_unit,digits=2)}</td>
          %if inv.print_price_unit_id == True:
           <td style="white-space:nowrap;text-align:left;">${line.price_unit_id.name or ''}</td>
          %endif
          %if inv.amount_discount != 0:
           <td style="white-space:nowrap;text-align:right;">${line.discount or 0.00}</td>
          %endif
           <td style="white-space:nowrap;text-align:right;">${formatLang(line.price_subtotal)}
         </td></tr>
        %if line.note and len(line.note.replace('\n','')) > 0 :
           %if inv.amount_discount != 0:
        <tr><td colspan="6" style="border-style:none"><style="font-family:Helvetica;padding-left:20px;font-size:9">${line.note |carriage_returns}</td></tr>
           %else:
        <tr><td colspan="5" style="border-style:none"><style="font-family:Helvetica;padding-left:20px;font-size:9">${line.note |carriage_returns}</td></tr>
           %endif
        %endif
        %endfor
        <tr>
           <td colspan="${inv.cols}" style="border-style:none"/>
           <td style="border-top:2px solid;white-space:nowrap"><b>${_("Net Total")}:</b></td>
           <td style="border-top:2px solid;text-align:right">${formatLang(inv.amount_untaxed)}</td>
        </tr>
        <tr>
           <td colspan="${inv.cols}" style="border-style:none"/>
           <td style="border-style:none"><b>${_("Taxes")}:</b></td>
           <td style="text-align:right">${formatLang(inv.amount_tax)}</td></tr>
        <tr> 
           <td colspan="${inv.cols}" style="border-style:none"/>
           <td style="border:2px solid;font-weight:bold;white-space:nowrap">${_("Total")} ${inv.currency_id.name}:</td>
           <td style="border:2px solid;text-align:right;font-weight:bold">${formatLang(inv.amount_total)}</td></tr>
        </tbody>
    </table>
<br>
       %if inv.tax_line :
    <table class="list_table" style="width:40%;border:1px solid grey">
        <tr><th>${_("Tax")}</th><th style="text-align:left;">${_("Base")}</th><th style="text-align:left;">${_("Amount")}</th></tr>
        %for t in inv.tax_line :
        <tr>
            <td style="border:1px solid grey">${ t.name|entity } </td>
            <td style="text-align:right;border:1px solid grey">${ formatLang(t.base)}</td>
            <td style="text-align:right;border:1px solid grey">${ formatLang(t.amount) }</td>
        </tr>
        %endfor
        <tr>
            <td style="border-style:none"/>
            <td style="border-top:0px solid;text-align:right;"><b>${_("Total Tax:")}</b></td>
            <td style="border-top:0px solid;text-align:right;">${ formatLang(inv.amount_tax) }</td>
        </tr>
        %endif
    </table>        
    %if inv.comment:
     <br>  ${inv.comment|carriage_returns}
    %endif:
    <p style="page-break-after:always"></p>
    %endfor
</body>
</html>
