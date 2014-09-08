<?php

function serverping_save_stripe_token($vars) {
  $_SESSION['stripeToken'] = $vars['stripeToken'];
  $_SESSION['stripe_ccexpirymonth'] = $vars['ccexpirymonth'];
  $_SESSION['stripe_ccexpiryyear'] = $vars['ccexpiryyear'];	
}

function serverping_stripe_cc_form($vars) {
  global $whmcs;
  
  $supported_carts_form_names["modern"] = 'cardformone.tpl';
  $supported_carts_form_names["slider"] = 'cardformone.tpl';
  $supported_carts_form_names["boxes"] = 'cardformone.tpl';
  $supported_carts_form_names["cart"] = 'cardformone.tpl';
  $supported_carts_form_names["verticalsteps"] = 'cardformone.tpl';
  $supported_carts_form_names["flatterncart"] = 'cardformtwo.tpl';
  $supported_carts_form_names["comparison"] = 'cardformthree.tpl';
  
  
  if (function_exists("stripe_custom_forms")) {
    $custom_forms = stripe_custom_forms($vars);
    $supported_carts_form_names = array_merge($supported_carts_form_names,$custom_forms["stripe_custom_cart_form_names"]);
  }
  
  $cart = $vars['carttpl'];
  
  if ($vars['filename'] == 'cart' && isset($supported_carts_form_names["$cart"])) {
    return array("cc_form_name" => $supported_carts_form_names["$cart"]);
  }
  elseif($vars['filename'] == 'cart' && $vars['carttpl'] == 'ajaxcart') {
    $result = select_query("tblpaymentgateways","value", array("gateway" => "stripe","setting" => "publishableKey"));
    $gateway_data = mysql_fetch_array($result);
    
    $script = '
<script type="text/javascript" src="https://js.stripe.com/v2/"></script>
<script type="text/javascript">
            // this identifies your website in the createToken call below
            Stripe.setPublishableKey(\''. $gateway_data['value'] . '\');
            var $customer_name = \'' . addslashes($vars['clientsdetails']['firstname']). ' ' . addslashes($vars['clientsdetails']['lastname']) .'\';
            var $address_1 = \'' . addslashes($vars['clientsdetails']['address1']). '\';
            var $address_2 = \'' . addslashes($vars['clientsdetails']['address2']). '\';
            var $city = \'' . addslashes($vars['clientsdetails']['city']). '\';
            var $zip = \'' . addslashes($vars['clientsdetails']['postcode']). '\';
            var $county = \'' . addslashes($vars['clientsdetails']['country']). '\';
            var $state = \'' . addslashes($vars['clientsdetails']['state']). '\';
            
            var $continue_button = \''. $whmcs->get_lang('completeorder'). '\';
            var $wait_button = \''. $whmcs->get_lang('pleasewait'). '\';
            
            function stripeResponseHandler(status, response) {
                if (response.error) {
                    // re-enable the submit button
                    jQuery(\'.ordernow\').removeAttr("disabled");
                    jQuery(\'.ordernow\').attr("value",$continue_button);
                    // show the errors on the form
                    jQuery("#payment-errors").html(response.error.message);
                    jQuery(".payment-errors").show();
                } else {
                    var form$ = jQuery("#checkoutfrm");
                    // token contains id, last4, and card type
                    var token = response[\'id\'];
                     // insert the token into the form so it gets submitted to the server
                    form$.append("<input type=\'hidden\' name=\'stripeToken\' value=\'" + token + "\' />");
                    form$.append("<input type=\'hidden\' name=\'ccnumber\' value=\'4242424242424242\' />");
                    form$.append("<input type=\'hidden\' name=\'cccvv\' value=\'111\' />");                    
                    // and submit
                    jQuery(\'.ordernow\').removeAttr("disabled");
                    jQuery(\'.ordernow\').attr("value",$continue_button);
                    completeorder();
                }
            }

            jQuery(document).ready(function() {
                jQuery("#checkoutfrm").submit(function(event) {
                    event.preventDefault();
                    if (jQuery(\'input[name=paymentmethod]:radio:checked\').val() == "stripe" && jQuery(\'input[name=ccinfo]:checked\').val() == "new") {
                      // disable the submit button to prevent repeated clicks
                      jQuery(\'.ordernow\').attr("disabled", "disabled");
                      jQuery(\'.ordernow\').attr("value",$wait_button);

                      // createToken returns immediately - the supplied callback submits the form if there are no errors
                      if ($customer_name == " ") {
                        $customer_name = jQuery(\'[name="firstname"]\').val() + " " + jQuery(\'[name="lastname"]\').val();
                        $address_1 = jQuery(\'[name="address1"]\').val();
                        $address_2 = jQuery(\'[name="address2"]\').val();
                        $city =  jQuery(\'[name="city"]\').val();
                        $state =  jQuery(\'#stateselect option:selected\').val();
                        $zip = jQuery(\'[name="postcode"]\').val();
                        $county = jQuery(\'[name="county"]\').val();
                      }
                     
                      Stripe.setPublishableKey(\''. $gateway_data['value'] . '\');
           
                      Stripe.createToken({
                        number: jQuery(\'.card-number\').val(),
                        cvc: jQuery(\'.card-cvc\').val(),
                        exp_month: jQuery(\'.card-expiry-month\').val(),
                        exp_year: jQuery(\'.card-expiry-year\').val(),
                        name: $customer_name,
                        address_line1: $address_1,
                        address_line2: $address_2,
                        address_city: $city,
                        address_state: $state,
                        address_zip:  $zip,
                        address_country: $county,
                      }, stripeResponseHandler);
                      return false; // submit from callback
                    }
                    else {
                      completeorder();
                      return true;                    
                    }
               });
            });
        </script>';
    
    return array('cc_form_script' => $script, 'cc_form_name' => 'cardformfour.tpl');
  }
}

function serverping_stripe_cart_checkout($vars) {
  global $whmcs;
  
  $supported_carts = array("modern","slider","cart","verticalsteps","boxes","flatterncart","comparison");
 
  if (function_exists("stripe_custom_forms")) {
    $custom_forms = stripe_custom_forms($vars);
    $supported_carts = array_merge($supported_carts,$custom_forms["stripe_custom_carts"]);
  }
  
  if ($vars['filename'] == 'cart' && (in_array($vars['carttpl'], $supported_carts)) ) {
    
    if (isset($custom_forms["stripe_custom_carts_scripts"][$vars['carttpl']])) {
	  $script = $custom_forms["stripe_custom_carts_scripts"][$vars['carttpl']];
    }
    else {
      $result = select_query("tblpaymentgateways","value", array("gateway" => "stripe","setting" => "publishableKey"));
      $gateway_data = mysql_fetch_array($result);
            
      $script = '<script type="text/javascript" src="https://js.stripe.com/v2/"></script>
      <script type="text/javascript">
            // this identifies your website in the createToken call below
            Stripe.setPublishableKey(\''. $gateway_data['value'] . '\');
            var $customer_name = \'' . addslashes($vars['clientsdetails']['firstname']). ' ' . addslashes($vars['clientsdetails']['lastname']) .'\';
            var $address_1 = \'' . addslashes($vars['clientsdetails']['address1']). '\';
            var $address_2 = \'' . addslashes($vars['clientsdetails']['address2']). '\';
            var $city = \'' . addslashes($vars['clientsdetails']['city']). '\';
            var $zip = \'' . addslashes($vars['clientsdetails']['postcode']). '\';
            var $county = \'' . addslashes($vars['clientsdetails']['country']). '\';
            var $state = \'' . addslashes($vars['clientsdetails']['state']). '\';
            var $continue_button = \''. $whmcs->get_lang('completeorder'). '\';
            var $wait_button = \''. $whmcs->get_lang('pleasewait'). '\';
            
            function stripeResponseHandler(status, response) {
                if (response.error) {
                    // re-enable the submit button
                    jQuery(\'.ordernow\').removeAttr("disabled");
                    jQuery(\'.ordernow\').attr("value",$continue_button);
                    // show the errors on the form
                    jQuery(".payment-errors").html(response.error.message);
                    jQuery(".payment-errors").show();
                } else {
                    var form$ = jQuery("#mainfrm");
                    // token contains id, last4, and card type
                    var token = response[\'id\'];
                     // insert the token into the form so it gets submitted to the server
                    form$.append("<input type=\'hidden\' name=\'stripeToken\' value=\'" + token + "\' />");
                    form$.append("<input type=\'hidden\' name=\'ccnumber\' value=\'4242424242424242\' />");
                    form$.append("<input type=\'hidden\' name=\'cccvv\' value=\'111\' />");                    
                    // and submit
                    form$.get(0).submit();
                }
            }

            jQuery(document).ready(function() {
                var $buttonpressed;
                jQuery(\'.submitbutton\').click(function() {
                  $buttonpressed = $(this).attr(\'name\');
                })
                jQuery("#mainfrm").submit(function(event) {
                    if ($buttonpressed == null && jQuery(\'input[name=paymentmethod]:radio:checked\').val() == "stripe" && jQuery(\'input[name=ccinfo]:checked\').val() == "new") {
                      // disable the submit button to prevent repeated clicks
                      jQuery(\'.ordernow\').attr("disabled", "disabled");
                      jQuery(\'.ordernow\').attr("value",$wait_button);

                      // createToken returns immediately - the supplied callback submits the form if there are no errors
                      if ($customer_name == " ") {
                        $customer_name = jQuery(\'[name="firstname"]\').val() + " " + jQuery(\'[name="lastname"]\').val();
                        $address_1 = jQuery(\'[name="address1"]\').val();
                        $address_2 = jQuery(\'[name="address2"]\').val();
                        $city =  jQuery(\'[name="city"]\').val();
                        $state =  jQuery(\'#stateselect option:selected\').val();
                        $zip = jQuery(\'[name="postcode"]\').val();
                        $county = jQuery(\'[name="county"]\').val();
                      }
                     
                     
                      Stripe.createToken({
                        number: jQuery(\'.card-number\').val(),
                        cvc: jQuery(\'.card-cvc\').val(),
                        exp_month: jQuery(\'.card-expiry-month\').val(),
                        exp_year: jQuery(\'.card-expiry-year\').val(),
                        name: $customer_name,
                        address_line1: $address_1,
                        address_line2: $address_2,
                        address_city: $city,
                        address_state: $state,
                        address_zip:  $zip,
                        address_country: $county,
                      }, stripeResponseHandler);
                      return false; // submit from callback
                    }
                    else {
                      return true;
                    }
               });
            });
        </script>';
        
        }
        return $script;
  }   

}

function stripe_update_customer_with_no_invoice($vars) {
  if (isset($_SESSION['stripeToken'])) {
    $whmcs_client_id = (int)$_SESSION['uid'];
    $result = select_query("tblclients","*",array("id" => $whmcs_client_id));
    $client_data = mysql_fetch_array($result);
    $client_data['userid'] = $client_data['id'];
    $params['clientdetails'] = $client_data;
    $params['gatewayid'] = $client_data['gatewayid'];
    $params['cardexp'] = $_SESSION["stripe_ccexpirymonth"] . substr($_SESSION["stripe_ccexpiryyear"], 2, 2);
    $gateway = getGatewayVariables('stripe');
    $params = $params + $gateway;
    $result = stripe_update_customer($params);
  }
}

add_hook("ShoppingCartCheckoutCompletePage",1,"stripe_update_customer_with_no_invoice");
add_hook("ClientAreaPage",1,"serverping_stripe_cc_form");
add_hook("ClientAreaHeadOutput",1,"serverping_stripe_cart_checkout");
add_hook("ShoppingCartValidateCheckout",1,"serverping_save_stripe_token");

?>