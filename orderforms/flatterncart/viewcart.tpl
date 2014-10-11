<script type="text/javascript" src="includes/jscript/statesdropdown.js"></script>
{literal}
<script>
  function removeItem(type,num) {
    var response = confirm("{/literal}{$LANG.cartremoveitemconfirm}{literal}");
    if (response) {
      window.location = 'cart.php?a=remove&r='+type+'&i='+num;
    }
  }
  function emptyCart(type,num) {
    var response = confirm("{/literal}{$LANG.cartemptyconfirm}{literal}");
    if (response) {
      window.location = 'cart.php?a=empty';
    }
  }
  function showloginform() {
    if (jQuery("#custtype").val()=="new") {
      jQuery("#custtype").val("existing");
      jQuery("#signupfrm").fadeToggle("slow",function(){
        jQuery("#loginfrm").fadeToggle();
      });
    } else {
      jQuery("#custtype").val("new");
      jQuery("#loginfrm").fadeToggle("slow",function(){
        jQuery("#signupfrm").fadeToggle();
      });
    }
  }
  function domaincontactchange() {
    if (jQuery("#domaincontact").val()=="addingnew") {
      jQuery("#domaincontactfields").slideDown();
    } else {
      jQuery("#domaincontactfields").slideUp();
    }
  }
  function showCCForm() {
    jQuery("#ccinputform").slideDown();
  }
  function hideCCForm() {
    jQuery("#ccinputform").slideUp();
  }
  function useExistingCC() {
    jQuery(".newccinfo").hide();
  }
  function enterNewCC() {
    jQuery(".newccinfo").show();
  }
</script>
{/literal}
<h2>{if $checkout}{$LANG.ordercheckout}{else}{$LANG.ordersummary}{/if}</h2>
<hr style="margin-top:0px;">
{if !$loggedin && $currencies}
<div class="row">
  <div class="col-lg-12">
   <div class="form-group">
    <form method="post" class="form-inline  pull-right" action="cart.php?a=view">
      <div class="form-group"><select name="currency" class="form-control" onchange="submit()">{foreach from=$currencies item=curr}
        <option value="{$curr.id}"{if $curr.id eq $currency.id} selected{/if}>{$curr.code}</option>
        {/foreach}</select></div><input type="submit" class="btn btn-default" value="{$LANG.go}" />
      </form> 
    </div></div></div>     
    {/if}
    {if $errormessage}
    <div class="alert alert-danger">
      <p>{$LANG.clientareaerrors}</p>
      <ul>{$errormessage}</ul>
    </div>
    {elseif $promotioncode && $rawdiscount eq "0.00"}
    <div class="alert alert-danger">{$LANG.promoappliedbutnodiscount}</div>
    {/if}
    {if $bundlewarnings}
    <div class="alert alert-danger" style="display:block;">
      <strong>{$LANG.bundlereqsnotmet}</strong>
      {foreach from=$bundlewarnings item=warning}
      {$warning}<br />
      {/foreach}
    </div>
    {/if}
    <form method="post" action="{$smarty.server.PHP_SELF}?a=view">
      <div class="row" style="border-bottom:1px solid #ddd;">
        <div class="col-lg-9"><h4>{$LANG.orderdesc}</h4></div>
        <div class="col-lg-2"><h4>{$LANG.orderprice}</h4></div>
      </div>
      {foreach key=num item=product from=$products}
      <div class="row" style="border-bottom:1px solid #ddd; padding-bottom:15px;">
        <div class="col-lg-9"><h5>{$product.productinfo.groupname} - {$product.productinfo.name}{if $product.domain} ({$product.domain}){/if}</h5>
          {if $product.configoptions}
          {foreach key=confnum item=configoption from=$product.configoptions}<span class="glyphicon glyphicon-plus-sign"></span> {$configoption.name}: {if $configoption.type eq 1 || $configoption.type eq 2}{$configoption.option}{elseif $configoption.type eq 3}{if $configoption.qty}{$LANG.yes}{else}{$LANG.no}{/if}{elseif $configoption.type eq 4}{$configoption.qty} x {$configoption.option}{/if}
          {/foreach}
          {/if}
          {if $product.allowqty}
          <p>{$LANG.cartqtyenterquantity}</p>
          <div class="row">
            <div class="col-sm-2">
              <div class="input-group input-group-sm">
                <input type="text" class="form-control" name="qty[{$num}]" value="{$product.qty}" />
                <span class="input-group-btn">
                  <button class="btn btn-default" type="submit" id="submit"><span aria-hidden="true" class="icon-refresh"></span></button>
                </span>      
              </div>
            </div>
          </div>
          {/if}
        </div>
        <div class="col-lg-2"><h5>{$product.pricingtext}{if $product.proratadate} ({$LANG.orderprorata} {$product.proratadate}){/if}</h5></div>
        <div class="col-lg-1"><h5><a href="#" onclick="removeItem('p','{$num}');return false" class="pull-right"><span class="glyphicon glyphicon-remove" style="color:#d9534f; margin-left:10px;"></span></a><a href="{$smarty.server.PHP_SELF}?a=confproduct&i={$num}" class="pull-right"><span class="glyphicon glyphicon-edit"></span></a></h5></div>
      </div>
      {foreach key=addonnum item=addon from=$product.addons}
      <div class="row">
        <div class="col-lg-9"><h6><span class="glyphicon glyphicon-plus-sign"></span> {$LANG.orderaddon} - {$addon.name}</h6></div>
        <div class="col-lg-2"><h6>{$addon.pricingtext}</h6></div>
      </div>
      {/foreach}
      {/foreach}
      {foreach key=num item=addon from=$addons}
      <div class="row">
        <div class="col-lg-9">{$addon.name} {$addon.productname}{if $addon.domainname} - {$addon.domainname}{/if} </div>
        <div class="col-lg-2">{$addon.pricingtext}</div>
      </div>
      <div class="row">
        <div class="col-lg-2"><a href="#" onclick="removeItem('a','{$num}');return false" class="textred">[{$LANG.cartremove}]</a></div>
      </div>
      {/foreach}
      {foreach key=num item=domain from=$domains}
      <div class="row" style="border-bottom:1px solid #ddd; padding-bottom:15px;">                 
        <div class="col-lg-9">{if $domain.type eq "register"}<h5><span class="badge">{$domain.regperiod} {$LANG.orderyears}</span> {$LANG.orderdomainregistration}{else}{$LANG.orderdomaintransfer}{/if} {$domain.domain} </h5>
          {if $domain.dnsmanagement}<h6><span class="glyphicon glyphicon-plus-sign"></span> {$LANG.domaindnsmanagement}</h6>
          {/if}
          {if $domain.emailforwarding}<h6><span class="glyphicon glyphicon-plus-sign"></span> {$LANG.domainemailforwarding}</h6>
          {/if}
          {if $domain.idprotection}<h6><span class="glyphicon glyphicon-plus-sign"></span> {$LANG.domainidprotection}</h6>
          {/if}
        </div>
        <div class="col-lg-2"><h5>{$domain.price}</h5></div>
        <div class="col-lg-1"><h5><a href="#" onclick="removeItem('d','{$num}');return false" class="pull-right"><span class="glyphicon glyphicon-remove" style="color:#d9534f; margin-left:10px;"></span></a> <a href="{$smarty.server.PHP_SELF}?a=confdomains" class="pull-right"> <span class="glyphicon glyphicon-edit"></span></a></h5></div>
      </div>
      {/foreach}
      {foreach key=num item=domain from=$renewals}
      <div class="row">
        <div class="col-lg-9"><h5>{$LANG.domainrenewal} - {$domain.domain} - {$domain.regperiod} {$LANG.orderyears}</h5>
          {if $domain.dnsmanagement}<span class="glyphicon glyphicon-plus-sign"></span> {$LANG.domaindnsmanagement}<br />
          {/if}
          {if $domain.emailforwarding}<span class="glyphicon glyphicon-plus-sign"></span> {$LANG.domainemailforwarding}<br />
          {/if}
          {if $domain.idprotection}<span class="glyphicon glyphicon-plus-sign"></span> {$LANG.domainidprotection}<br />
          {/if}
        </div>
        <div class="col-lg-2"><h5>$domain.price}</h5></div>
      </div>
      <div class="row">
        <div class="col-lg-9"><h5><a href="#" onclick="removeItem('r','{$num}');return false" class="pull-right"><span class="glyphicon glyphicon-remove" style="color:#d9534f; margin-left:10px;"></span></h5></a></div>
      </div>
      {/foreach}
      {if $cartitems==0}
      <div class="row">
        <div class="col-lg-12">
          {$LANG.cartempty}
        </div>
      </div>
      {/if}
      <div class="row">
        <div class="col-lg-9"><h4>{$LANG.ordersubtotal}:</h4></div>
        <div class="col-lg-2"><h4>{$subtotal}</h4></div>
      </div>
      {if $promotioncode}
      <div class="row">
        <div class="col-lg-9"><h5>{$promotiondescription}:</h5></div>
        <div class="col-lg-2"><h5>{$discount}</h5></div>
      </div>
      {/if}
      {if $taxrate}
      <div class="row">
        <div class="col-lg-9"><h5>{$taxname} @ {$taxrate}%:</h5></div>
        <div class="col-lg-2"><h5>{$taxtotal}</h5></div>
      </div>
      {/if}
      {if $taxrate2}
      <div class="row">
        <div class="col-lg-9"><h5>{$taxname2} @ {$taxrate2}%:</h5></div>
        <div class="col-lg-2"><h5>{$taxtotal2}</h5></div>
      </div>
      {/if}
      <div class="row">
        <div class="col-lg-9"><h4>{$LANG.ordertotalduetoday}:</h4></div>
        <div class="col-lg-2"><h4>{$total}</h4></div>
      </div>
      {if $totalrecurringmonthly || $totalrecurringquarterly || $totalrecurringsemiannually || $totalrecurringannually || $totalrecurringbiennially || $totalrecurringtriennially}
      <div class="row" style="padding-bottom:30px;">
        <div class="col-lg-9"><h6>{$LANG.ordertotalrecurring}:</h6></div>
        <div class="col-lg-2"><h6>{if $totalrecurringmonthly}{$totalrecurringmonthly} {$LANG.orderpaymenttermmonthly}</h6>
          {/if}
          {if $totalrecurringquarterly}<h6>{$totalrecurringquarterly} {$LANG.orderpaymenttermquarterly}</h6>
          {/if}
          {if $totalrecurringsemiannually}<h6>{$totalrecurringsemiannually} {$LANG.orderpaymenttermsemiannually}</h6>
          {/if}
          {if $totalrecurringannually}<h6>{$totalrecurringannually} {$LANG.orderpaymenttermannually}</h6>
          {/if}
          {if $totalrecurringbiennially}<h6>{$totalrecurringbiennially} {$LANG.orderpaymenttermbiennially}</h6>
          {/if}
          {if $totalrecurringtriennially}<h6>{$totalrecurringtriennially} {$LANG.orderpaymenttermtriennially}</h6>
          {/if}</div>
        </div>
        {/if}
      </form>
      <hr>
      {if !$checkout}
      <div class="row">
        <div class="col-lg-4">
          <form method="post" class="form-inline" action="{$smarty.server.PHP_SELF}?a=view">
            <input type="hidden" name="validatepromo" value="true" />
            {if $promotioncode}{$promotioncode} - {$promotiondescription}<a href="{$smarty.server.PHP_SELF}?a=removepromo"> <i class="fa fa-lg fa-times" style="color:#d9534f"></i></a>{else}
            <div class="input-group">
              <input type="text" class="form-control" name="promocode" placeholder="{$LANG.orderpromotioncode}">
              <span class="input-group-btn"><button type="submit" class="btn btn-default" value="{$LANG.orderpromovalidatebutton}" /><span class="glyphicon glyphicon-chevron-right"></span>
            </button></span>
          </div>
          {/if}
        </form>
      </div>
      <div class="col-lg-8">
        <div class="btn-group pull-right"><input type="button" class="btn btn-default" value="{$LANG.emptycart}" onclick="emptyCart();return false" />
          <input type="button" class="btn btn-default" value="{$LANG.continueshopping}" onclick="window.location='cart.php'" />
          <input type="button" class="btn btn-primary" value="{$LANG.checkout}" onclick="window.location='cart.php?a=checkout'"{if $cartitems==0} disabled{/if} />
        </div>
        {foreach from=$gatewaysoutput item=gatewayoutput}
        <div class="gateway"><strong>- {$LANG.or} -</strong><br /><br />{$gatewayoutput}</div>
        {/foreach}
      </div>
    </div>
    {else}
    <div class="alert alert-warning">
      <span class="glyphicon glyphicon-lock"></span><small> {$LANG.ordersecure} ({$ipaddress}) {$LANG.ordersecure2}</small>
    </div>
    <form method="post" action="{$smarty.server.PHP_SELF}?a=checkout&submit=true" id="mainfrm">
      <div class="panel panel-default">
        <div class="panel-heading"><h3 class="panel-title"><span class="glyphicon glyphicon-user"></span> {$LANG.yourdetails}</h3></div>
        <div class="panel-body">
          <input type="hidden" name="custtype" id="custtype" value="{$custtype}" />
          <div id="loginfrm"{if $custtype eq "existing" && !$loggedin}{else} style="display:none;"{/if}>
            <p>{$LANG.newcustomersignup|sprintf2:'<a href="#" class="btn btn-default btn-sm" onclick="showloginform();return false;">':'</a>'}</p>
            <div class="signupfieldsextra">
              <div class="col-lg-6"> 
                <label for="loginemail">{$LANG.loginemail}</label>
                <div class="form-group">
                  <input type="text" class="form-control" name="loginemail" id="loginemail" value="{$username}" />
                </div>
              </div>
              <div class="col-lg-6">
                <label for="loginpw">{$LANG.loginpassword}</label>
                <div class="form-group">
                  <input type="password" class="form-control" name="loginpw" id="loginpw" />
                </div>
              </div>
            </div>
          </div>
          <div id="signupfrm"{if $custtype eq "existing" && !$loggedin} class="subhidden"{/if}>
            {if !$loggedin}<p>{$LANG.alreadyregistered} <a class="btn btn-sm btn-default" href="{$smarty.server.PHP_SELF}?a=login" onclick="showloginform();return false;">{$LANG.clickheretologin}</a></p>{/if}

            <div class="col-lg-6">
              <label for="firstname">{$LANG.clientareafirstname}</label>
              <div class="form-group">
                <input type="text" name="firstname" id="firstname" value="{$clientsdetails.firstname}"{if $loggedin} disabled="" class="disabled form-control"{else} class="form-control"{/if} />
              </div>

              <label for="lastname">{$LANG.clientarealastname}</label>
              <div class="form-group">
                <input type="text" name="lastname" id="lastname" value="{$clientsdetails.lastname}"{if $loggedin} disabled="" class="disabled form-control"{else} class="form-control"{/if} />
              </div>

              <label for="companyname">{$LANG.clientareacompanyname}</label>
              <div class="form-group">
                <input type="text" name="companyname" id="companyname" value="{$clientsdetails.companyname}"{if $loggedin} disabled="" class="disabled form-control"{else} class="form-control"{/if} />
              </div>

              <label for="email">{$LANG.clientareaemail}</label>
              <div class="form-group">
                <input type="text" name="email" id="email" value="{$clientsdetails.email}"{if $loggedin} disabled="" class="disabled form-control"{else} class="form-control"{/if} />
              </div>
              {if !$loggedin}
              <label for="password">{$LANG.clientareapassword}</label>
              <div class="form-group">
                <input type="password" class="form-control" name="password" id="password" value="{$password}" />
              </div>
              <label for="password2">{$LANG.clientareaconfirmpassword}</label>
              <div class="form-group">
                <input type="password" class="form-control" name="password2" id="password2" value="{$password2}" />
              </div>
              <label for="email"></label>
              <div class="form-group">
                {include file="default/pwstrength.tpl"}
              </div>
              {/if}
            </div>
            <div class="col-lg-6">
              <label for="address1">{$LANG.clientareaaddress1}</label>
              <div class="form-group">
                <input type="text" name="address1" id="address1" value="{$clientsdetails.address1}"{if $loggedin} disabled="" class="disabled form-control"{else} class="form-control"{/if} />
              </div>
              <label for="address2">{$LANG.clientareaaddress2}</label>
              <div class="form-group">
                <input type="text" name="address2" id="address2" value="{$clientsdetails.address2}"{if $loggedin} disabled="" class="disabled form-control"{else} class="form-control"{/if} />
              </div>
              <label for="city">{$LANG.clientareacity}</label>
              <div class="form-group">
                <input type="text" name="city" id="city" value="{$clientsdetails.city}"{if $loggedin} disabled="" class="disabled form-control"{else} class="form-control"{/if} />
              </div>

              <label for="state">{$LANG.clientareastate}</label>
              <div class="form-group">
                {if $loggedin}<input type="text" id="state" value="{$clientsdetails.state}" disabled="" class="disabled form-control" />{else}<input type="text" class="form-control" name="state" id="state" value="{$clientsdetails.state}" />{/if}
              </div>

              <label for="postcode">{$LANG.clientareapostcode}</label>
              <div class="form-group">
                <input type="text" name="postcode" id="postcode" value="{$clientsdetails.postcode}"{if $loggedin} disabled="" class="disabled form-control"{else} class="form-control"{/if} />
              </div>

              <label for="country">{$LANG.clientareacountry}</label>
              <div class="form-group">
                {if $loggedin}<input type="text" id="country" value="{$clientsdetails.country}" disabled="" class="disabled form-control" />{else}{$clientcountrydropdown|replace:'name="country"':'name="country" style="width:100%; height: 34px; padding: 6px 12px; font-size: 14px; border-radius: 4px; vertical-align: middle; border: 1px solid #ccc; color: #555; line-height: 1.428571429;"'}{/if}
              </div>

              <label for="phonenumber">{$LANG.clientareaphonenumber}</label>
              <div class="form-group">
                <input type="text" name="phonenumber" id="phonenumber" value="{$clientsdetails.phonenumber}"{if $loggedin} disabled="" class="disabled form-control"{else} class="form-control"{/if} />
              </div>
            </div>
            {if $customfields || $securityquestions}
            <div class="col-lg-12">
              <div class="signupfieldsextra">
                {if $securityquestions && !$loggedin}
                <label for="securityqid">{$LANG.clientareasecurityquestion}</label>
                <div class="form-group">
                  <select name="securityqid" class="form-control" id="securityqid">
                    {foreach key=num item=question from=$securityquestions}
                    <option value={$question.id}>{$question.question}</option>
                    {/foreach}
                  </select>
                </div>
                <label for="securityqans">{$LANG.clientareasecurityanswer}</label>
                <div class="form-group">
                  <input type="text" class="form-control" name="securityqans" id="securityqans" />
                </div>
                {/if}
                {foreach key=num item=customfield from=$customfields}
                <label for="customfield{$customfield.id}">{$customfield.name}</label>
                <div class="form-group">
                  {$customfield.input} {$customfield.description}
                </div>
                {/foreach}
              </div>
            </div>
            {/if}
            {if $taxenabled && !$loggedin}
            <p class="textcenter">{$LANG.carttaxupdateselections} <input type="submit" value="{$LANG.carttaxupdateselectionsupdate}" name="updateonly" /></p>
            {/if}
          </div>
        </div>
      </div>
      {if $domainsinorder}
      <div class="panel panel-default">
        <div class="panel-heading">
          <h3 class="panel-title"><span class="glyphicon glyphicon-globe"></span> {$LANG.domainregistrantinfo}</h3>
        </div>
        <div class="panel-body">
          {$LANG.domainregistrantchoose}: <select name="contact" class="form-control" id="domaincontact" onchange="domaincontactchange()">
          <option value="">{$LANG.usedefaultcontact}</option>
          {foreach from=$domaincontacts item=domcontact}
          <option value="{$domcontact.id}"{if $contact==$domcontact.id} selected{/if}>{$domcontact.name}</option>
          {/foreach}
          <option value="addingnew"{if $contact eq "addingnew"} selected{/if}>{$LANG.clientareanavaddcontact}...</option>
        </select>
        <div id="domaincontactfields"{if $contact neq "addingnew"} class="subhidden"{/if}>
          <div class="col-lg-6">
            <label for="firstname">{$LANG.clientareafirstname}</label>
            <div class="form-group">
              <input type="text" class="form-control" name="domaincontactfirstname" id="domaincontactfirstname" value="{$domaincontact.firstname}" />
            </div>
            <label for="lastname">{$LANG.clientarealastname}</label>
            <div class="form-group">
              <input type="text" class="form-control" name="domaincontactlastname" id="domaincontactlastname" value="{$domaincontact.lastname}" />
            </div>
            <label for="companyname">{$LANG.clientareacompanyname}</label>
            <div class="form-group">
              <input type="text" class="form-control" name="domaincontactcompanyname" id="domaincontactcompanyname" value="{$domaincontact.companyname}" />
            </div>
            <label for="email">{$LANG.clientareaemail}</label>
            <div class="form-group">
              <input type="text" class="form-control" name="domaincontactemail" id="domaincontactemail" value="{$domaincontact.email}" />
            </div>
            <label for="phonenumber">{$LANG.clientareaphonenumber}</label>
            <div class="form-group">
              <input type="text" class="form-control" name="domaincontactphonenumber" id="domaincontactphonenumber" value="{$domaincontact.phonenumber}" />
            </div>
          </div>
          <div class="col-lg-6">
            <label for="address1">{$LANG.clientareaaddress1}</label>
            <div class="form-group">
              <input type="text" class="form-control" name="domaincontactaddress1" id="domaincontactaddress1" value="{$domaincontact.address1}" />
            </div>
            <label for="address2">{$LANG.clientareaaddress2}</label>
            <div class="form-group">
              <input type="text" class="form-control" name="domaincontactaddress2" id="domaincontactaddress2" value="{$domaincontact.address2}" />
            </div>
            <label for="city">{$LANG.clientareacity}</label>
            <div class="form-group">
              <input type="text" class="form-control" name="domaincontactcity" id="domaincontactcity" value="{$domaincontact.city}" />
            </div>
            <label for="state">{$LANG.clientareastate}</label>
            <div class="form-group">
              <input type="text" class="form-control" name="domaincontactstate" id="domaincontactstate" value="{$domaincontact.state}" />
            </div>
            <label for="postcode">{$LANG.clientareapostcode}</label>
            <div class="form-group">
             <input type="text" class="form-control" name="domaincontactpostcode" id="domaincontactpostcode" value="{$domaincontact.postcode}" />
           </div>
           <label for="country">{$LANG.clientareacountry}</label>
           <div class="form-group">
            {$domaincontactcountrydropdown|replace:'name="domaincontactcountry"':'name="domaincontactcountry" style="width:100%; height: 34px; padding: 6px 12px; font-size: 14px; border-radius: 4px; vertical-align: middle; border: 1px solid #ccc; color: #555; line-height: 1.428571429;"'|replace:'United States Outlying Islands':'US Outlying Islands'}
          </div>
        </div>
      </div>
    </div>
  </div>
  {/if}
  <div class="panel panel-default">
    <div class="panel-heading">
     <h3 class="panel-title"><span class="glyphicon glyphicon-credit-card"></span> {$LANG.orderpaymentmethod}</h3>
   </div>
   <div class="panel-body">
    {foreach key=num item=gateway from=$gateways}
    <label class="radio"><input type="radio" name="paymentmethod" value="{$gateway.sysname}" onclick="{if $gateway.type eq "CC"}showCCForm(){else}hideCCForm(){/if}"{if $selectedgateway eq $gateway.sysname} checked{/if} />{$gateway.name}</label>
    {/foreach}
  </div>
  {include file="orderforms/ccforms/$cc_form_name"}
</div>
{if $shownotesfield}
<div class="panel panel-default">
  <div class="panel-heading">
    <h3 class="panel-title">{$LANG.ordernotes}</h3>
  </div>
  <div class="panel-body">
    <textarea name="notes" rows="3" class="form-control" onFocus="if(this.value=='{$LANG.ordernotesdescription}'){ldelim}this.value='';{rdelim}" onBlur="if (this.value==''){ldelim}this.value='{$LANG.ordernotesdescription}';{rdelim}">{$notes}</textarea>
  </div>
</div>
{/if}
{if $accepttos}
<div class="row">
  <div class="col-lg-12">
    <label><input type="checkbox" name="accepttos" id="accepttos"> {$LANG.ordertosagreement} <a href="{$tosurl}" target="_blank">{$LANG.ordertos}</a></label>
  </div>
</div>
{/if}
<input type="submit" class="btn btn-success pull-right" value="{$LANG.completeorder}"{if $cartitems==0} disabled{/if} onclick="this.value='{$LANG.pleasewait}'" />
</form>
{/if}