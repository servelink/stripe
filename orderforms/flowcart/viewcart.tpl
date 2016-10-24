<link rel="stylesheet" type="text/css" href="templates/orderforms/{$carttpl}/style.css" />

<script type="text/javascript" src="https://cdnjs.cloudflare.com/ajax/libs/jquery.nicescroll/3.6.0/jquery.nicescroll.min.js"></script>
<script language="javascript">var statesTab=10;</script>
<script type="text/javascript" src="templates/orderforms/{$carttpl}/js/main.js"></script>
<script type="text/javascript" src="{$BASE_PATH_JS}/StatesDropdown.js"></script>
<script type="text/javascript" src="{$BASE_PATH_JS}/PasswordStrength.js"></script>
<script type="text/javascript" src="{$BASE_PATH_JS}/CreditCardValidation.js"></script>

<script>
window.langPasswordStrength = "{$LANG.pwstrength}";
window.langPasswordWeak = "{$LANG.pwstrengthweak}";
window.langPasswordModerate = "{$LANG.pwstrengthmoderate}";
window.langPasswordStrong = "{$LANG.pwstrengthstrong}";
</script>
{include file="orderforms/$carttpl/assets/cust_styles.tpl"}
{include file="orderforms/$carttpl/assets/cart-header.tpl" title=$LANG.rs_step4 desc=$LANG.rs_step4_desc step=4 pid=$products[0].pid}
<div class="cart-wrapper">
<div class="row">
  {if $domains || $products || $addons || $renewals}
  <div class="col-md-8">
    {else}
    <div class="col-md-12">
    {/if}
      {if $errormessage}
      <div class="alert alert-danger">
        <ul>
          {$errormessage}
        </ul>
      </div>
      {elseif $promotioncode && $rawdiscount eq "0.00"}
      <div class="alert alert-danger">
        {$LANG.promoappliedbutnodiscount}
      </div>
      {/if}
      {if $bundlewarnings}
      <div class="alert alert-danger">
        <strong>{$LANG.bundlereqsnotmet}</strong><br />
        {foreach from=$bundlewarnings item=warning}
        {$warning}<br />
        {/foreach}
      </div>
      {/if}

      {if !$domains && !$products && !$addons && !$renewals}
      <div class="row">
        <div class="col-md-4 col-md-offset-4">
          <div class="well well-sm well-nodata clearfix">
            <i class="fa fa-shopping-cart fa-3x fa-muted"></i>
            <h4>{$LANG.flowcartempty}</h4>
            <div class="form-group">
            <a href="cart.php" class="btn btn-default">{$LANG.ordernowbutton}</a>
          </div>
          </div>
        </div>
      </div>
      {/if}

      {if $cartitems!=0}
      <form method="post" action="{$smarty.server.PHP_SELF}?a=checkout" id="mainfrm">
        <input type="hidden" name="submit" value="true" />
        <input type="hidden" name="custtype" id="custtype" value="{$custtype}" />

        {if $loggedin}
        <div class="row" style="margin-top:45px;">
          <div class="col-md-4">
            <dl>
              <dt>{$LANG.clientareafirstname}</dt>
              <dd>{$clientsdetails.firstname}</dd>
            </dl>
          </div>
          <div class="col-md-4">
            <dl>
              <dt>{$LANG.clientarealastname}</dt>
              <dd>{$clientsdetails.lastname}</dd>
            </dl>
          </div>
          <div class="col-md-4">
            <dl>
              <dt>{$LANG.clientareacompanyname}</dt>
              <dd>{$clientsdetails.companyname}</dd>
            </dl>
          </div>
        </div>

        <div class="row">
          <div class="col-md-4">
            <dl>
              <dt>{$LANG.clientareaemail}</dt>
              <dd>{$clientsdetails.email}</dd>
            </dl>
          </div>
          <div class="col-md-4">
            <dl>
              <dt>{$LANG.clientareaphonenumber}</dt>
              <dd>{$clientsdetails.phonenumber}</dd>
            </dl>
          </div>
        </div>

        <div class="row">
          <div class="col-md-4">
            <dl>
              <dt>{$LANG.clientareaaddress1}</dt>
              <dd>{$clientsdetails.address1}</dd>
            </dl>
          </div>
          {if $clientsdetails.address2}
          <div class="col-md-4">
            <dl>
              <dt>{$LANG.clientareaaddress2}</dt>
              <dd>{$clientsdetails.address2}</dd>
            </dl>
          </div>
          {/if}
        </div>

        <div class="row">
          <div class="col-md-4">
            <dl>
              <dt>{$LANG.clientareacity}</dt>
              <dd>{$clientsdetails.city}</dd>
            </dl>
          </div>
          <div class="col-md-4">
            <dl>
              <dt>{$LANG.clientareastate}</dt>
              <dd>{$clientsdetails.state}</dd>
            </dl>
          </div>
          <div class="col-md-4">
            <dl>
              <dt>{$LANG.clientareapostcode}</dt>
              <dd>{$clientsdetails.postcode}</dd>
            </dl>
          </div>
        </div>

        <div class="row">
          <div class="col-md-4">
            <dl>
              <dt>{$LANG.clientareacountry}</dt>
              <dd>{$clientsdetails.country}</dd>
            </dl>
          </div>
        </div>
        <hr>
        {else}
        <div class="user-details">
          <ul class="nav nav-tabs">
            <li {if $custtype=='new' || !isset($custtype) || $custtype==''} class="active"{/if}><a href="#new" data-toggle="tab"><label class="domainoptions"><input type="radio" name="custtype" value="new" id="custtypenew" {if $loggedin}disabled{else}checked{/if} /><i class="fa fa-pencil-square-o fa-fw"></i>{$LANG.cartnewcustomer}</label> </a></li>
            <li {if $custtype=='existing'} class="active"{/if}><a href="#current" data-toggle="tab"><label class="domainoptions"><input type="radio" name="custtype" value="existing" id="custtypeexisting" {if $loggedin}checked{/if} /><i class="fa fa-sign-in fa-fw"></i>
             {$LANG.cartexistingcustomer}</label></a></li>
           </ul>

           <div class="tab-content">
            <div class="tab-pane fade in {if $custtype=='new' || !isset($custtype) || $custtype==''} active {/if} " id="new">
              <div class="row">
                <div class="col-md-4">
                  <div class="form-group form-group-xl">
                    <label class="control-label" for="firstname">{$LANG.clientareafirstname}</label>
                    <input type="text" name="firstname" id="firstname" value="{$clientsdetails.firstname}"{if in_array('firstname',$uneditablefields)} disabled="" class="disabled form-control"{else} class="form-control"{/if} />
                  </div>
                </div>

                <div class="col-md-4">
                  <div class="form-group form-group-xl">
                    <label class="control-label" for="lastname">{$LANG.clientarealastname}</label>
                    <input type="text" name="lastname" id="lastname" value="{$clientsdetails.lastname}"{if in_array('lastname',$uneditablefields)} disabled="" class="disabled form-control"{else} class="form-control"{/if} />
                  </div>
                </div>

                <div class="col-md-4">
                  <div class="form-group form-group-xl">
                    <label class="control-label" for="companyname">{$LANG.clientareacompanyname}</label>
                    <input type="text" name="companyname" id="companyname" value="{$clientsdetails.companyname}"{if in_array('companyname',$uneditablefields)} disabled="" class="disabled form-control"{else} class="form-control"{/if} />
                  </div>
                </div>
                <div class="col-md-6">
                  <div class="form-group form-group-xl">
                    <label class="control-label" for="email">{$LANG.clientareaemail}</label>
                    <input type="text" name="email" id="email" value="{$clientsdetails.email}"{if in_array('email',$uneditablefields)} disabled="" class="disabled form-control"{else} class="form-control"{/if} />
                  </div>
                </div>
                <div class="col-md-6">
                  <div class="form-group form-group-xl">
                    <label class="control-label" for="phonenumber">{$LANG.clientareaphonenumber}</label>
                    <input type="text" name="phonenumber" id="phonenumber" value="{$clientsdetails.phonenumber}"{if in_array('phonenumber',$uneditablefields)} disabled="" class="disabled form-control"{else} class="form-control"{/if} />
                  </div>
                </div>
              </div>
              <hr>
              <div class="row">
                <div class="col-md-6">
                  <div id="newPassword1" class="form-group form-group-xl">
                    <label class="control-label" for="password">{$LANG.clientareapassword}</label>
                    <input type="password" class="form-control" id="inputNewPassword1" name="password" value="{$password}" required/>

                    <span id="helpBlock" class="help-block">{include file="$template/includes/pwstrength.tpl"}</span>
                  </div>
                </div>
                <div class="col-md-6">
                  <div id="newPassword2" class="form-group form-group-xl">
                    <label class="control-label" for="password2">{$LANG.clientareaconfirmpassword}</label>
                    <input type="password" class="form-control" id="inputNewPassword2" name="password2" value="{$password2}" required/>
                    <span id="helpBlock" class="help-block"><div id="inputNewPassword2Msg"></div></span>
                  </div>
                </div>

              </div>
              <hr>
              <div class="row">
                <div class="col-md-8">
                  <div class="form-group form-group-xl">
                    <label class="control-label" for="address1">{$LANG.clientareaaddress1}</label>
                    <input type="text" name="address1" id="address1" value="{$clientsdetails.address1}"{if in_array('address1',$uneditablefields)} disabled="" class="disabled form-control"{else} class="form-control"{/if} />
                  </div>
                </div>

                <div class="col-md-4">
                  <div class="form-group form-group-xl">
                    <label class="control-label" for="address2">{$LANG.clientareaaddress2}</label>
                    <input type="text" name="address2" id="address2" value="{$clientsdetails.address2}"{if in_array('address2',$uneditablefields)} disabled="" class="disabled form-control"{else} class="form-control"{/if} />
                  </div>
                </div>

                <div class="col-md-4">
                  <div class="form-group form-group-xl">
                    <label class="control-label" for="city">{$LANG.clientareacity}</label>
                    <input type="text" name="city" id="city" value="{$clientsdetails.city}"{if in_array('city',$uneditablefields)} disabled="" class="disabled form-control"{else} class="form-control"{/if} />
                  </div>
                </div>

                <div class="col-md-4">
                  <div class="form-group form-group-xl">
                    <label class="control-label" for="state">{$LANG.clientareastate}</label>
                    <input type="text" name="state" id="state" value="{$clientsdetails.state}"{if in_array('state',$uneditablefields)} disabled="" class="disabled form-control"{else} class="form-control"{/if} />
                  </div>
                </div>

                <div class="col-md-4">
                  <div class="form-group form-group-xl">
                    <label class="control-label" for="postcode">{$LANG.clientareapostcode}</label>
                    <input type="text" name="postcode" id="postcode" value="{$clientsdetails.postcode}"{if in_array('postcode',$uneditablefields)} disabled="" class="disabled form-control"{else} class="form-control"{/if} />
                  </div>
                </div>

                <div class="col-md-8">
                  <div class="form-group form-group-xl">
                    <label class="control-label">{$LANG.clientareacountry}</label>
                    {$clientcountrydropdown}
                  </div>
                </div>

                {if $currencies}
                <div class="col-md-4">
                  <div class="form-group form-group-xl">
                    <label class="control-label" for="currency">{$LANG.choosecurrency}</label>
                    <div id="currency">
                      <select name="currency" class="form-control">
                        {foreach from=$currencies item=curr}
                        <option value="{$curr.id}"{if !$smarty.post.currency && $curr.default || $smarty.post.currency eq $curr.id } selected{/if}>{$curr.code}</option>
                        {/foreach}
                      </select>
                    </div>
                  </div>
                </div>
                {/if}
              </div>
              {foreach key=num item=customfield from=$customfields}
              <hr>
              <div class="row">
               <div class="col-md-12">
                <div class="form-group form-group-xl">
                  <label class="control-label" for="customfield{$customfield.id}">{$customfield.name}</label>
                  {$customfield.input|replace:'>':' class="form-control" >'}
                  <span id="helpBlock" class="help-block">{$customfield.description}</span>
                </div>
              </div>
            </div>
            {/foreach}
            {if $securityquestions}
            <div class="row">
              <div class="col-md-6">
                <div class="form-group form-group-xl">
                  <label class="control-label" for="securityqans">{$LANG.clientareasecurityquestion}</label>
                  <select name="securityqid" class="form-control" id="securityqid">
                    {foreach key=num item=question from=$securityquestions}
                    <option value={$question.id}>{$question.question}</option>
                    {/foreach}
                  </select>
                </div>
              </div>
              <div class="col-md-6">
                <div class="form-group form-group-xl">
                  <label class="control-label" for="securityqans">{$LANG.clientareasecurityanswer}</label>
                  <input type="password" class="form-control" name="securityqans" id="securityqans" value="{$securityqans}" />
                </div>
              </div>
            </div>
            {/if}
            <hr>
          </div><!--/tab-->
          <div class="tab-pane fade in {if $custtype=='existing'} active {/if} " id="current">
            <div class="alert alert-danger hidden" id="loginerror"></div>
            <div class="row">
              <div class="col-md-6">
                <div class="form-group form-group-xl">
                  <label class="control-label">{$LANG.clientareaemail}</label>
                  <input type="text" class="form-control" name="loginemail">
                </div>
              </div>
              <div class="col-md-6">
                <div class="form-group form-group-xl">
                  <label class="control-label">{$LANG.clientareapassword}</label>
                  <input type="password" name="loginpw" class="form-control"/>
                </div>
              </div>
            </div>
          </div><!--/tab-->
        </div>
      </div>
      {/if}
      {if $domainsinorder}
      <div class="form-group form-group-xl">
        <label class="control-label">{$LANG.domainregistrantinfo}</label>
        <select name="contact" class="form-control" id="domaincontact" onchange="domaincontactchange()">
          <option value="">{$LANG.usedefaultcontact}</option>
          {foreach from=$domaincontacts item=domcontact}
          <option value="{$domcontact.id}"{if $contact==$domcontact.id} selected{/if}>{$domcontact.name}</option>
          {/foreach}
          <option value="addingnew"{if $contact eq "addingnew"} selected{/if}>{$LANG.clientareanavaddcontact}...</option>
        </select>
      </div>
      <div id="domaincontactfields"{if $contact neq "addingnew"} class="subhidden"{/if}>
        <div class="row">
          <div class="col-lg-6">
            <label for="firstname">{$LANG.clientareafirstname}</label>
            <div class="form-group form-group-xl">
              <input type="text" class="form-control" name="domaincontactfirstname" id="domaincontactfirstname" value="{$domaincontact.firstname}" />
            </div>
            <label for="lastname">{$LANG.clientarealastname}</label>
            <div class="form-group form-group-xl">
              <input type="text" class="form-control" name="domaincontactlastname" id="domaincontactlastname" value="{$domaincontact.lastname}" />
            </div>
            <label for="companyname">{$LANG.clientareacompanyname}</label>
            <div class="form-group form-group-xl">
              <input type="text" class="form-control" name="domaincontactcompanyname" id="domaincontactcompanyname" value="{$domaincontact.companyname}" />
            </div>
            <label for="email">{$LANG.clientareaemail}</label>
            <div class="form-group form-group-xl">
              <input type="text" class="form-control" name="domaincontactemail" id="domaincontactemail" value="{$domaincontact.email}" />
            </div>
            <label for="phonenumber">{$LANG.clientareaphonenumber}</label>
            <div class="form-group form-group-xl">
              <input type="text" class="form-control" name="domaincontactphonenumber" id="domaincontactphonenumber" value="{$domaincontact.phonenumber}" />
            </div>
          </div>
          <div class="col-lg-6">
            <label for="address1">{$LANG.clientareaaddress1}</label>
            <div class="form-group form-group-xl">
              <input type="text" class="form-control" name="domaincontactaddress1" id="domaincontactaddress1" value="{$domaincontact.address1}" />
            </div>
            <label for="address2">{$LANG.clientareaaddress2}</label>
            <div class="form-group form-group-xl">
              <input type="text" class="form-control" name="domaincontactaddress2" id="domaincontactaddress2" value="{$domaincontact.address2}" />
            </div>
            <label for="city">{$LANG.clientareacity}</label>
            <div class="form-group form-group-xl">
              <input type="text" class="form-control" name="domaincontactcity" id="domaincontactcity" value="{$domaincontact.city}" />
            </div>
            <label for="state">{$LANG.clientareastate}</label>
            <div class="form-group form-group-xl">
              <input type="text" class="form-control" name="domaincontactstate" id="domaincontactstate" value="{$domaincontact.state}" />
            </div>
            <label for="postcode">{$LANG.clientareapostcode}</label>
            <div class="form-group form-group-xl">
             <input type="text" class="form-control" name="domaincontactpostcode" id="domaincontactpostcode" value="{$domaincontact.postcode}" />
           </div>
           <label for="country">{$LANG.clientareacountry}</label>
           <div class="form-group form-group-xl">
            {$domaincontactcountrydropdown}
          </div>
        </div>
      </div>
    </div>
    {/if}
    <hr>
    <h4>{$LANG.orderpaymentmethod}</h4>
    <div class="form-group">
      {foreach key=num item=gateway from=$gateways}
      <label class="radio-inline"><input type="radio" name="paymentmethod" value="{$gateway.sysname}" onclick="{if $gateway.type eq "CC"}showCCForm(){else}hideCCForm(){/if}"{if $selectedgateway eq $gateway.sysname} checked{/if} />{$gateway.name}</label>
      {/foreach}
    </div>

    <div class="alert alert-danger payment-errors" style="display:none;"></div>

    <div id="creditCardInputFields"{if $selectedgatewaytype neq "CC"} class="hidden"{/if}>
            <div class="row margin-bottom">
                <div class="col-sm-12">
                    <div class="text-center">
                        <label class="radio-inline">
                            <input type="radio" name="ccinfo" value="useexisting" id="useexisting" {if $clientsdetails.cclastfour} checked{else} disabled{/if} />
                            {$LANG.creditcarduseexisting}
                            {if $clientsdetails.cclastfour}
                                ({$clientsdetails.cclastfour})
                            {/if}
                        </label>
                        <label class="radio-inline">
                            <input type="radio" name="ccinfo" value="new" id="new" {if !$clientsdetails.cclastfour || $ccinfo eq "new"} checked{/if} />
                            {$LANG.creditcardenternewcard}
                        </label>
                    </div>
                </div>
            </div>
        <div id="newCardInfo" class="row{if $clientsdetails.cclastfour && $ccinfo neq "new"} hidden{/if}">

            <div class="col-sm-6">
                <div class="form-group prepend-icon">
                    <label for="inputCardNumber" class="field-icon">
                        <i class="fa fa-credit-card"></i>
                    </label>
                    <input type="tel" id="inputCardNumber" class="field card-number" placeholder="{$LANG.orderForm.cardNumber}" autocomplete="cc-number">
                </div>
            </div>
            <div class="col-sm-6">
                <div class="form-group prepend-icon">
                    <label for="inputCardExpiry" class="field-icon">
                        <i class="fa fa-calendar"></i>
                    </label>
                    <input type="tel" id="inputCardExpiry" class="field" placeholder="MM / YY{if $showccissuestart} ({$LANG.creditcardcardexpires}){/if}" autocomplete="cc-exp">
                    <input type="hidden" name="ccexpirymonth" id="ccexpirymonth">
                    <input type="hidden" name="ccexpiryyear" id="ccexpiryyear">

                </div>
            </div>
            <div class="col-sm-6">
                <div class="form-group prepend-icon">
                    <label for="inputCardCVV" class="field-icon">
                        <i class="fa fa-barcode"></i>
                    </label>
                    <input type="tel" id="inputCardCVV" class="field card-cvc" placeholder="{$LANG.orderForm.cvv}" autocomplete="cc-cvc">
                     <input type="hidden" name="cccvv" value="123" />
                </div>
            </div>
        </div>
        <div id="existingCardInfo" class="row{if !$clientsdetails.cclastfour || $ccinfo eq "new"} hidden{/if}">
        </div>
    </div>

        {if $flowcart_display_notes}
        <hr>
        <h4>{$LANG.orderForm.additionalNotes}</h4>
        <div class="form-group">
            <textarea name="notes" class="form-control field" rows="4" placeholder="{$LANG.ordernotesdescription}">{$orderNotes}</textarea>
        </div>
        {/if}

        <hr>
        {if $accepttos}
        <div class="form-group form-group-xl">
          <div class="checkbox">
            <label><input type="checkbox" name="accepttos" id="accepttos" /> {$LANG.ordertosagreement} <a href="{$tosurl}" target="_blank">{$LANG.ordertos} <i class="fa fa-external-link"></i></a></label>
          </div>
        </div>
        {/if}
        <div class="row action action-step">
         <div class="col-md-12">
          <button type="submit" id="btnCompleteOrder" class="btn btn-success submitbutton ordernow pull-right" >{$LANG.completeorder} <i class="fa fa-angle-right"></i></button>
          <a href="cart.php" class="btn btn-link pull-right">{$LANG.continueshopping}</a>
        </div>
      </div>
  </form>
     </div>

  {else}
  {/if}
  {if $domains || $products || $addons || $renewals}
  <div class="cart-right col-md-4">
    {include file="orderforms/$carttpl/cartsummary.tpl"}
  </div>
{else}
</div>
{/if}
</div>
</div>
{if $minimal_cart == 'on'}
    <div class="content-sm">
      <div class="row">
        <div class="col-md-12">
{/if}

<script>
{literal}
function removeItem(type,num) {
  var response = confirm("{/literal}{$LANG.cartremoveitemconfirm}{literal}");
  if (response) {
    window.location = 'cart.php?a=remove&r='+type+'&i='+num;
  }
}
{/literal}
</script>
