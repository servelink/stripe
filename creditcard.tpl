<script type="text/javascript" src="includes/jscript/statesdropdown.js"></script>

{include file="$template/pageheader.tpl" title=$LANG.creditcard}

<div class="alert alert-block alert-warn">
    <p class="textcenter"><strong>Paying Invoice #{$invoiceid}</strong> - Balance Due: <strong>{$balance}</strong></p>
</div>

{if $remotecode}

<div id="submitfrm" class="textcenter">

{$remotecode}

<iframe name="3dauth" width="90%" height="600" scrolling="auto" src="about:blank" style="border:1px solid #fff;"></iframe>

</div>

<br />

{literal}
<script language="javascript">
setTimeout ( "autoForward()" , 1000 );
function autoForward() {
  var submitForm = jQuery("#submitfrm").find("form");
    submitForm.submit();
}
</script>
{/literal}

{else}
{php}
  $result = select_query("tblpaymentgateways","value", array("gateway" => "stripe","setting" => "publishableKey"));
  $gateway_data = mysql_fetch_array($result);
  $this->_tpl_vars['publishableKey'] = $gateway_data['value'];
{/php}

<script type="text/javascript" src="https://js.stripe.com/v2/"></script>
<script type="text/javascript">
            // this identifies your website in the createToken call below
            Stripe.setPublishableKey('{$publishableKey}');
            var $continue_button = '{$LANG.ordercontinuebutton}';
            var $wait_button = '{$LANG.pleasewait}';
            
            {literal}
            function stripeResponseHandler(status, response) {
                if (response.error) {
                    // re-enable the submit button
                    jQuery('.submit-button').removeAttr("disabled");
                    // show the errors on the form
                    jQuery(".payment-errors").html(response.error.message);
                    jQuery('#submit-button').val($continue_button);
                    jQuery('#cc_input').show();
                    jQuery(".payment-errors").show();
                } else {
                    var form$ = jQuery("#payment-form");
                    // token contains id, last4, and card type
                    var token = response['id'];
                    // insert the token into the form so it gets submitted to the server
                    form$.append("<input type='hidden' name='stripeToken' value='" + token + "' />");
                 
                    jQuery.post("modules/gateways/stripe-php/stripesave.php", jQuery("#payment-form").serialize(), function(data) {
                      if (data == "error") {
                         jQuery('.submit-button').removeAttr("disabled");
                         jQuery(".payment-errors").html("Your card could not be saved, please try again or contact support.");
                         jQuery('#submit-button').val($continue_button);
                         jQuery(".payment-errors").show();
                         jQuery('#cc_input').show();
                     
                      }
                      else {
                         jQuery('input:radio[name=ccinfo]')[0].checked = true;   
                         form$.get(0).submit();
                      }
                     
                     });
                    
                }
            }

            jQuery(document).ready(function() {
                jQuery("#payment-form").submit(function(event) {
                    jQuery('.submit-button').attr("value",$wait_button);
                    
                    if (jQuery('input[name=ccinfo]:checked').val() == "new") {
                      // disable the submit button to prevent repeated clicks
                      jQuery('.submit-button').attr("disabled", "disabled");
                      jQuery('#cc_input').hide();
                     
                      // createToken returns immediately - the supplied callback submits the form if there are no errors
                      Stripe.createToken({
                        number: jQuery('.card-number').val(),
                        cvc: jQuery('.card-cvc').val(),
                        exp_month: jQuery('.card-expiry-month').val(),
                        exp_year: jQuery('.card-expiry-year').val(),
                        name: jQuery('#firstname').val() + ' ' + jQuery('#lastname').val(),
                        address_line1: jQuery('#address1').val(),
                        address_line2: jQuery('#address2').val(),
                        address_city: jQuery('#city').val(),
                        address_state: jQuery('#stateselect option:selected').val(),
                        address_zip:  jQuery('#postcode').val(),
                        address_country: jQuery('#country').val(),
                      }, stripeResponseHandler);
                      
                      
                      return false; // submit from callback
                    }
                    else {
                      return true;
                    }
                });
            });
        </script>
 {/literal}
<div class="alert alert-danger payment-errors" style="display:none;"></div>

<form method="post" id="payment-form" action="creditcard.php">
<input type="hidden" name="action" value="submit">
<input type="hidden" name="invoiceid" value="{$invoiceid}">

{if $errormessage}
    <div class="alert alert-error">
        <p class="bold">{$LANG.clientareaerrors}</p>
        <ul>
            {$errormessage}
        </ul>
    </div>
{/if}

<fieldset class="control-group">
    <div class="col-lg-6">
        <div class="internalpadding">

          {include file="$template/subheader.tpl" title=$LANG.creditcardyourinfo}

            <div class="form-group">
              <label class="control-label"  for="firstname">{$LANG.clientareafirstname}</label>
            <div class="controls">
                <input type="text" class="form-control" name="firstname" id="firstname" value="{$firstname}"{if in_array('firstname',$uneditablefields)} disabled="" class="disabled"{/if} />
            </div>
          </div>

            <div class="form-group">
              <label class="control-label" for="lastname">{$LANG.clientarealastname}</label>
            <div class="controls">
                <input type="text" class="form-control" name="lastname" id="lastname" value="{$lastname}"{if in_array('lastname',$uneditablefields)} disabled="" class="disabled"{/if} />
            </div>
          </div>

            <div class="form-group">
              <label class="control-label" for="address1">{$LANG.clientareaaddress1}</label>
            <div class="controls">
                <input type="text" class="form-control"  name="address1" id="address1" value="{$address1}"{if in_array('address1',$uneditablefields)} disabled="" class="disabled"{/if} />
            </div>
          </div>

            <div class="form-group">
              <label class="control-label" for="address2">{$LANG.clientareaaddress2}</label>
            <div class="controls">
                <input type="text" class="form-control" name="address2" id="address2" value="{$address2}"{if in_array('address2',$uneditablefields)} disabled="" class="disabled"{/if} />
            </div>
          </div>

            <div class="form-group">
              <label class="control-label" for="city">{$LANG.clientareacity}</label>
            <div class="controls">
                <input type="text" class="form-control" name="city" id="city" value="{$city}"{if in_array('city',$uneditablefields)} disabled="" class="disabled"{/if} />
            </div>
          </div>

            <div class="form-group">
              <label class="control-label" for="state">{$LANG.clientareastate}</label>
            <div class="controls">
                <input type="text" class="form-control" name="state" id="state" value="{$state}"{if in_array('state',$uneditablefields)} disabled="" class="disabled"{/if} />
            </div>
          </div>

            <div class="form-group">
              <label class="control-label" for="postcode">{$LANG.clientareapostcode}</label>
            <div class="controls">
                <input type="text" class="form-control" name="postcode" id="postcode" value="{$postcode}"{if in_array('postcode',$uneditablefields)} disabled="" class="disabled"{/if} />
            </div>
          </div>

            <div class="form-group">
              <label class="control-label" for="country">{$LANG.clientareacountry}</label>
            <div class="controls">
                {$countriesdropdown}
            </div>
          </div>


            <div class="form-group">
              <label class="control-label" for="phonenumber">{$LANG.clientareaphonenumber}</label>
            <div class="controls">
                <input type="text" class="form-control" name="phonenumber" id="phonenumber" value="{$phonenumber}"{if in_array('phonenumber',$uneditablefields)} disabled="" class="disabled"{/if} />
            </div>
          </div>

        </div>
    </div>
    <div class="col-lg-6">
           <div class="internalpadding">
            {include file="$template/subheader.tpl" title=$LANG.creditcarddetails}
            <div id="cc_input">
            <div class="radio">
            <label><input type="radio" id="ccinfo" name="ccinfo" value="useexisting" onclick="disableFields('newccinfo',true)"{if $cardnum} checked{else} disabled{/if} /> {$LANG.creditcarduseexisting}{if $cardnum} ({$cardnum}){/if}</label></div>
            <input type="hidden" name="cccvv2" value="123" />
            <div class="radio">
            <label><input type="radio" id="ccinfo" name="ccinfo" value="new" onclick="disableFields('newccinfo',false)"{if !$cardnum || $ccinfo eq "new"} checked{/if} /> {$LANG.creditcardenternewcard}</label></div>
            <div class="form-group">
                <label class="control-label" for="ccnumber">{$LANG.creditcardcardnumber}</label>
            <div class="control"><input type="text" class="card-number newccinfo form-control" size="30" value="{$ccnumber}" autocomplete="off"/></div>
          </div>        
          <div class="row">    
            <div class="col-xs-6">
            <div class="form-group">
            <label class="control-label" for="ccexpirymonth">{$LANG.creditcardcardexpires}</label>
           <select name="card-exp-month" class="card-expiry-month newccinfo form-control">{foreach from=$months item=month}
<option{if $ccexpirymonth eq $month} selected{/if}>{$month}</option>
{/foreach}</select></div></div><div class="col-xs-6"><div class="form-group"><label>&nbsp;</label><select name="card-exp-year" class="card-expiry-year newccinfo form-control">
{foreach from=$years item=year}
<option{if $ccexpiryyear eq $year} selected{/if}>{$year}</option>
{/foreach}
</select></div> 
</div>
            </div>
            <div class="row"> 
            <div class="col-xs-6">
            <div class="form-group">
                <label class="control-label" for="cccvv">{$LANG.creditcardcvvnumber} <a href="#" onclick="window.open('images/ccv.gif','','width=280,height=200,scrollbars=no,top=100,left=100');return false"><i class="fa fa-question-circle"></i></a></label>
            <input type="text" size="5" value="{$cccvv}" autocomplete="off" class="form-control card-cvc input-small newccinfo" /></div>
              </div>
              </div>              
           <input class="btn btn-large btn-primary submit-button" id="submit-button" type="submit" value="{$LANG.ordercontinuebutton}"/>
                     <div class="row">    
            <div class="col-xs-12">
<p><small><i class="fa fa-lock"></i> {$LANG.creditcardsecuritynotice}</small></p>
</div>
</div>
        </div>
    </div>
</div>

</fieldset>

{if !$cardnum || $ccinfo eq "new"}{else}
<script> disableFields('newccinfo',true); </script>
{/if}

</form>

{/if}