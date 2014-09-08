{php}
  if ($_REQUEST['error'] == 1) {
    $this->_tpl_vars['errormessage'] = "Your card could not be saved, please try again or contact support.";
   }
{/php}
{include file="$template/pageheader.tpl" title=$LANG.clientareanavccdetails}
{include file="$template/clientareadetailslinks.tpl"}
{if $remoteupdatecode}
<div align="center">
    {$remoteupdatecode}
</div>
{else}
{literal}
<script type="text/javascript" src="https://js.stripe.com/v2/"></script>
<script type="text/javascript">
            // this identifies your website in the createToken call below
            {/literal}
            {php}
              $result = select_query("tblpaymentgateways","value", array("gateway" => "stripe","setting" => "publishableKey"));
              $gateway_data = mysql_fetch_array($result);
              $this->_tpl_vars['publishableKey'] = $gateway_data['value'];
            {/php}
            Stripe.setPublishableKey('{$publishableKey}');
            var $customer_name = '{$clientsdetails.firstname|escape:'quotes'} {$clientsdetails.lastname|escape:'quotes'}';
            var $address_1 = '{$clientsdetails.address1|escape:'quotes'}';
            var $address_2 = '{$clientsdetails.address2|escape:'quotes'}';
            var $city = '{$clientsdetails.city|escape:'quotes'}';
            var $zip = '{$clientsdetails.postcode}';
            var $county = '{$clientsdetails.country}';
            var $state = '{$clientsdetails.state|escape:'quotes'}';
            
            var $continue_button = '{$LANG.clientareasavechanges|escape:'quotes'}';
            var $wait_button = '{$LANG.pleasewait|escape:'quotes'}';
            
            {literal}
            function stripeResponseHandler(status, response) {
                if (response.error) {
                    // re-enable the submit button
                    jQuery('.submit-button').removeAttr("disabled");
                    jQuery('.submit-button').attr("value",$continue_button);
                    // show the errors on the form
                    jQuery(".payment-errors").html(response.error.message);
                    jQuery(".payment-errors").show();
                } else {
                    var form$ = jQuery("#payment-form");
                    // token contains id, last4, and card type
                    var token = response['id'];
                     // insert the token into the form so it gets submitted to the server
                    form$.append("<input type='hidden' name='stripeToken' value='" + token + "' />");
                    // and submit
                    form$.get(0).submit();
                }
            }

            jQuery(document).ready(function() {
                jQuery("#payment-form").submit(function(event) {
                    // disable the submit button to prevent repeated clicks
                    jQuery('.submit-button').attr("disabled", "disabled");
                    jQuery('.submit-button').attr("value",$wait_button);

                    // createToken returns immediately - the supplied callback submits the form if there are no errors
                    Stripe.createToken({
                        number: jQuery('.card-number').val(),
                        cvc: jQuery('.card-cvc').val(),
                        exp_month: jQuery('.card-expiry-month').val(),
                        exp_year: jQuery('.card-expiry-year').val(),
                        name: $customer_name,
                        address_line1: $address_1,
                        address_line2: $address_2,
                        address_city: $city,
                        address_state: $state,
                        address_zip:  $zip,
                        address_country: $county,
                    }, stripeResponseHandler);
                    return false; // submit from callback
                });
            });
        </script>
 {/literal}
<hr>
<div class="alert alert-danger payment-errors" style="display:none;"></div>    
{if $successful}
<div class="alert alert-success" style="margin-top:15px;">
    <p>{$LANG.changessavedsuccessfully}</p>
</div>
{/if}
{if $errormessage}
<div class="alert alert-danger" style="margin-top:15px;">
    <p><i class="fa fa-exclamation-triangle"></i> {$LANG.clientareaerrors}</p>
    <ul>
        {$errormessage}
    </ul>
</div>
{/if}
<div class="row">
  <div class="col-lg-12">
    <div class="form-group">
        <label class="control-label">{$LANG.creditcardcardtype}</label>
        <input type="text" value="{$cardtype}" disabled="true" class="form-control" />
    </div>
    <div class="form-group">
        <label class="control-label">{$LANG.creditcardcardnumber}</label>
        <input class="form-control" type="text" value="{$cardnum}" disabled="true" />
    </div>
    <div class="form-group">
        <label class="control-label">{$LANG.creditcardcardexpires}</label>
        <input  type="text" value="{$cardexp}" disabled="true" class="form-control" />
    </div>
    {if $allowcustomerdelete && $cardtype}
    <form method="post" action="{$smarty.server.PHP_SELF}?action=creditcard">
        <input type="submit" name="remove" id="delete-form" value="{$LANG.creditcarddelete}" class="btn btn-xs btn-danger pull-right" />
    </form>
    {/if}
</div>
</div>
<hr>
<h4>{$LANG.creditcardenternewcard}</h4>
<form method="post" id="payment-form" action="modules/gateways/stripe-php/stripesave.php">
    <div class="row">
      <div class="col-lg-12">
        <div class="row">
           <div class="col-lg-5">
           <div class="form-group">
                <label class="control-label" for="ccnumber">{$LANG.creditcardcardnumber}</label>
                <input type="text" class="card-number form-control" autocomplete="off" />
            </div>
            </div>
        <div class="col-lg-3">
                <label class="control-label">{$LANG.creditcardcvvnumber} <a href="#" onclick="window.open('images/ccv.gif','','width=280,height=200,scrollbars=no,top=100,left=100');return false"><i class="fa fa-question-circle"></i></a></label>
                <input type="text" id="cardcvv" maxlength="4" class="input-mini card-cvc form-control" autocomplete="off" />
            </div>
             <div class="col-lg-2"> 
            <label class="control-label">{$LANG.creditcardcardexpires}</label>              
            <select name="card-exp-month" class="card-expiry-month form-control">{foreach from=$months item=month}<option>{$month}</option>{/foreach}</select>
                </div>
                <div class="col-lg-2">
                <label class="control-label">&nbsp;</label>  
<select name="card-exp-year" class="card-expiry-year form-control">{foreach from=$expiryyears item=year}<option>{$year}</option>{/foreach}</select>
            </div>
            </div>
        
                <div class="btn-toolbar" role="toolbar">
                    <input class="btn btn-primary submit-button pull-right" type="submit" value="{$LANG.clientareasavechanges}" />
                    <input class="btn btn-default pull-right" type="reset" value="{$LANG.cancel}" />
                </div>
            </div>
        </div>
    </form>
    {/if}