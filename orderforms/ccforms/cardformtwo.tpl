<div id="ccinputform"{if $selectedgatewaytype neq "CC"} style="display:none;"{/if}>
    <div class="alert alert-error payment-errors" style="display:none;"></div>
<table class="table">
        <tr>
          <td class="fieldarea"></td>
          <td><label><input type="radio" name="ccinfo" value="useexisting" id="useexisting" onclick="useExistingCC()"{if $clientsdetails.cclastfour} checked{else} disabled{/if} /> {$LANG.creditcarduseexisting}{if $clientsdetails.cclastfour} ({$clientsdetails.cclastfour}){/if}</label><br />
              <label><input type="radio" name="ccinfo" value="new" id="new" onclick="enterNewCC()"{if !$clientsdetails.cclastfour || $ccinfo eq "new"} checked{/if} /> {$LANG.creditcardenternewcard}</label>
          </td>
        </tr>
        <tr class="newccinfo"{if $clientsdetails.cclastfour && $ccinfo neq "new"} style="display:none;"{/if}>
          <td class="fieldarea">{$LANG.creditcardcardnumber}</td>
          <td><div class="col-xs-10"><input type="text" class="card-number form-control" size="30" autocomplete="off" /></div></td>
        </tr>
        <tr class="newccinfo" {if $clientsdetails.cclastfour && $ccinfo neq "new"} style="display:none;"{/if}>
          <td class="fieldarea">{$LANG.creditcardcardexpires}</td>
          <td>
          <div class="col-xs-3">
          <select name="ccexpirymonth" id="ccexpirymonth" class="card-expiry-month newccinfo form-control">
{foreach from=$months item=month}
<option{if $ccexpirymonth eq $month} selected{/if}>{$month}</option>
{/foreach}</select></div><div class="col-xs-3"><select name="ccexpiryyear" class="card-expiry-year newccinfo form-control">
{if !isset($expiryyears)}
{assign var="expiryyears" value=$years}
{/if}
{foreach from=$expiryyears item=year}
<option{if $ccexpiryyear eq $year} selected{/if}>{$year}</option>
{/foreach}
</select>
</div>
<input type="hidden" name="cccvv" value="123" />
          </td>
        </tr>
        <tr class="newccinfo" {if $clientsdetails.cclastfour && $ccinfo neq "new"} style="display:none;"{/if}>
          <td class="fieldarea">{$LANG.creditcardcvvnumber}</td>
          <td><div class="col-xs-3"><input type="text" size="5" class="card-cvc form-control" autocomplete="off" /></div> <div class="col-xs-9"><h5><a href="#" onclick="window.open('images/ccv.gif','','width=280,height=200,scrollbars=no,top=100,left=100');return false"><i class="fa fa-question-circle"></i> {$LANG.creditcardcvvwhere}</a></h5></div></td>
        </tr>
      </table>
      <br />
</div>