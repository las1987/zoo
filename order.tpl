{literal}
	<script>
	$(document).ready(function(){

		var old_separate_delivery = $("#separate_delivery").val();
		var old_to_apartment = $("#old_to_apartment").val();
		function cost_dpd(){
			
			$("#delivery_result").text("Пожалуйста, подождите... считаем...");
			
			var url = 'http://zoo812.ru/files/cartdpd.php';
			
			// Терминал всегда выключен
			var terminal = '0';
			var weight = $("#weight_cart").val();
			var volume = $("#volume").val();
			var cityid = $("#sity option:selected").val();
			
	        $.get(
	            url,
	            {
	            	'cityid': cityid, 'weight': weight, 'volume': volume, 'terminal': terminal
	            },
	            function (result){
					var options = '';
	                    $(result).each(function(){
		                    var cost = $(this).attr('cost');
		                    var day = $(this).attr('days');
		                    var dpd_tarif = $(this).attr('serviceCode');
                			
		                    $("#delivery_result").text("Доставка курьерской службой DPD = " + cost + "р. Длительность доставки (дней): " + day + " ");	                    

		                    if ($(this).attr('cost') == null){
		                    	if ($("#apartment").prop("checked") == false){
		                    		$("#delivery_result").text("К сожалению, в Вашем городе нет терминала DPD");
		                    	}
		                    }

		                    if ($(this).attr('cost') == '0'){
		                    	if ($("#apartment").prop("checked") == false){
		                    		$("#delivery_result").text("К сожалению, в Вашем городе нет терминала DPD");
		                    	}
		                    }

		                    if ($(this).attr('cost') == null){
		                    	if ($("#apartment").prop("checked") == true){
		                    		$("#delivery_result").text("К сожалению, произошла непредвиденная ошибка. Уточняйте стоимость и саму возможность доставки у оператора.");
		                    	}
		                    }

		                    if ($(this).attr('cost') == '0'){
		                    	if ($("#apartment").prop("checked") == true){
		                    		$("#delivery_result").text("К сожалению, произошла непредвиденная ошибка. Уточняйте стоимость и саму возможность доставки у оператора.");
		                    	}
		                    }

		                    if ($(this).attr('cost') != null){
		                    	cost = parseFloat(cost);
		                    	
		                    	$("#new_cost").text(cost);
		                    	$("#new_cost").val(cost);

		                    	$("#separate_delivery").val(cost);
								
		                    	$("#dpd_tarif").text(dpd_tarif);
		                    	$("#dpd_tarif").val(dpd_tarif);

		                    	$("#new_day").val(day);
		                    	$("#new_day").text(day);   

		                    	$("#new_city").val(cityid);
		                    	$("#new_city").text(cityid);  

		                    	var new_to_apartment = 1;

		                    	$("#new_to_apartment").val(new_to_apartment);
		                    	$("#new_to_apartment").text(new_to_apartment);
		                    }
		                    
		                    if ($(this).attr('cost') == null){
		                    	$("#new_cost").text(0);
		                    	$("#new_cost").val(0);

		                    	$("#separate_delivery").val(old_separate_delivery);                   	

		                    	$("#dpd_tarif").text("");
		                    	$("#dpd_tarif").val();

		                    	$("#new_day").val();
		                    	$("#new_day").text("");

		                    	$("#new_city").val();
		                    	$("#new_city").text("");

		                    	$("#new_to_apartment").val(old_to_apartment);
		                    	$("#new_to_apartment").text(old_to_apartment);
		                    }
	                    });
	                },
	            "json"
	        );				
		}

		$(function(){
		   $.getJSON('http://zoo812.ru/files/select_region.php', function(data){
	                $.each(data, function(key, val){
	                   $('#region').append('<option value="' + val.id + '">' +  val.title + '</option>');
	                });
			});
		});
			
		$('#region').change(function (){
			
			var region_code = $("#region").val();
			var url = 'http://zoo812.ru/files/select_sity.php';
			
	        $.get(
	            url,
	            "region_code=" + region_code,
	            function (result){
					var options = '';
	                    $(result).each(function(){
	                        options += '<option value="' + $(this).attr('id') + '">' + $(this).attr('title') + '</option>';
	                    });
	                    $('#sity').html(options);
	                    $('#sity').attr('disabled', false);

	                    cost_dpd();
	                    
	                },
	            "json"
	        );
	        
		});

		$('#sity_no').click(function (){
			 
			$('#city_of_dpd').toggle();
			$('#delivery_result').toggle();
			$('#address_free').toggle();
			$('#address_dpd').toggle();	
			
			if ($("#sity_no").prop("checked") == true){
				$("#destination_id [value='666']").attr("selected", "selected");
				cost_dpd();
			}
			else{
				var cityid = $(this).data('num');
				$("#destination_id [value='" + cityid +"']").attr("selected", "selected");
				$("#separate_delivery").val(old_separate_delivery);

				$("#new_cost").text("");
            	$("#new_cost").val(null);

            	$("#dpd_tarif").text("");
            	$("#dpd_tarif").val(null);

            	$("#new_day").val(null);
            	$("#new_day").text("");

            	$("#new_city").val(null);
            	$("#new_city").text("");

            	$("#new_to_apartment").val(old_to_apartment);
            	$("#new_to_apartment").text(old_to_apartment); 			     	
			}					 
		});

		function add_id_for_dpd_to_order(id, orderid){
			var url = 'http://zoo812.ru/files/add_id_for_dpd_to_order.php';

			$.get(
		    	url,
		        {
		    		'dpdid': id, 'orderid': orderid
		        },	            
		        function (result){
		        	$(result).each(function(){
			              alert('Номер заказа в DPD добавлен в нашу базу');      
                    });
                },
           		"json"
	        );
		}

		$('#sity').change(function(){
			cost_dpd();									    
		});	

		$("#admin_log").change(function (){
			alert('А вот изменять тут ничего нелья. Ваши данные отправлены руководителю и вы будете наказаны!');
			location.reload();
		});

		$("#promokod_auto").click(function (){
		    var orderid = $(this).data('num');
		    var promocode = $("#promocode").val();

		    var url = 'http://zoo812.ru/files/promokod_auto.php';

		    $.get(
		    	url,
		        {
		        	'orderid': orderid, 'promocode': promocode
		        },	            
		        function (result){
		        	$(result).each(function(){
	                    var status = $(this).attr('status');
	                    var message = $(this).attr('message');
	                    alert(status);
	                    alert(message);

	                    if (status == 'OK'){
	                    	location.reload();
	                    }
	                                      
                    });
		        	
                },
           		"json"
	        );
		    
		});
	
		$("#dpd_createOrder").click(function (){
			
		    var orderid = $(this).data('num');
		    var datePickup = $("#data_for_dpd").val();
		    var url = 'http://zoo812.ru/files/order_to_dpd.php';
			
		    $.get(
		    	url,
		        {
		        	'orderid': orderid, 'datePickup': datePickup
		        },	            
		        function (result){
		        	$(result).each(function(){
	                    var id = $(this).attr('id');
	                    var status = $(this).attr('status');
	                    var res = $(this).attr('res');
	                    alert(status);
						
	                    if (status == 'OK'){
		                	alert('Заказ принят!');
		                	add_id_for_dpd_to_order(id, orderid);
	                    }
	                    if (status == 'OrderPending'){
		                    alert('Заказ на доставку принят, но нуждается в ручной доработке сотрудником DPD (например, по причине того, что адрес доставки не распознан автоматически). Номер заказа будет присвоен ему когда это доработка будет произведена. Печать наклейки будет возможна только после этого!');
	                    }
	                    if (status == 'OrderError'){
		                    alert('Заказ на доставку не может быть создан автоматически! Создайте его своими рукамим... ');
	                    }
						
                    });
		        	
                },
           		"json"
        	);			
		    
		 });
	});
	</script>
{/literal}		

{* Вкладки *}
{capture name=tabs}
	{if in_array('orders', $manager->permissions)}
		<li {if (($order->status==0)&&(!$drug_is))}class="active"{/if}><a href="index.php?module=OrdersAdmin&status=0">Новые</a></li>
		<li {if $drug_is}class="active"{/if}><a href="{url module=OrdersNurseryAdmin status=0 keyword=null id=null page=null label=null}">Новые заказы в приют</a></li>
		<li {if $order->status==1}class="active"{/if}><a href="index.php?module=OrdersAdmin&status=1">В обработке</a></li>
		<li {if $order->status==2}class="active"{/if}><a href="index.php?module=OrdersAdmin&status=2">Выполнен</a></li>
		<li {if $order->status==3}class="active"{/if}><a href="index.php?module=OrdersAdmin&status=3">Аннулирован</a></li>
	{if $keyword}
	<li class="active"><a href="{url module=OrdersAdmin keyword=$keyword id=null label=null}">Поиск</a></li>
	{/if}
	{/if}
	{if in_array('labels', $manager->permissions)}
	<li><a href="{url module=OrdersLabelsAdmin keyword=null id=null page=null label=null}">Метки</a></li>
	{/if}
{/capture}


{if $order->id}
	{$meta_title = "Заказ №`$order->id_new`" scope=parent}
{else}
	{$meta_title = 'Новый заказ' scope=parent}
{/if}

<!-- Основная форма -->
<form method=post id=order enctype="multipart/form-data">
<input type=hidden name="session_id" value="{$smarty.session.id}">

<div id="name">
	<input name=id type="hidden" value="{$order->id|escape}"/>
    <div class="row collapse">
        <div class="large-9 columns">
            <h1>{if $order->id}Заказ №{$order->id_new} - {$order->id}{else}Новый заказ{/if}
                <select class=status name="status">
                    <option value='0' {if $order->status == 0}selected{/if}>Новый</option>
                    <option value='1' {if $order->status == 1}selected{/if}>В обработке</option>
                    <option value='2' {if $order->status == 2}selected{/if}>Выполнен</option>
                    <option value='3' {if $order->status == 3}selected{/if}>Аннулирован</option>
                </select>
            </h1>
            <a href="{url view=print id=$order->id}" target="_blank" style="padding-top: 9px;"><i class="fa fa-print p3"></i>Печать заказа</a>
			{if $order->pickuppoint_id}<p style="font-size:20px;color:#FF0000;"><b>Заказ на самовывоз!</b></p>{/if}
		</div>
        <div class="large-3 columns">
            <div id=next_order>
                {if $prev_order}
                    <a class=prev_order href="{url id=$prev_order->id}">Предыдущий <i class="fa fa-arrow-circle-left p-3"></i></a>
                {/if}
                {if $next_order}
                    <a class=next_order href="{url id=$next_order->id}"><i class="fa fa-arrow-circle-right p3"></i> Следующий</a>
                {/if}
            </div>
        </div>
    </div>
</div> 

<div class="row collapse">
    <div class="large-12 columns">
        {if $message_error}
            <div data-alert class="alert-box alert radius">
                <span>{if $message_error=='error_closing'}Нехватка товара на складе{else}{$message_error|escape}{/if}</span>
                <a href="#" class="close">&times;</a>
            </div>
        {elseif $message_success}
            <div data-alert class="alert-box success radius">
                <span>{if $message_success=='updated'}Заказ обновлен{elseif $message_success=='added'}Заказ добавлен{else}{$message_success}{/if}</span>
                <a href="#" class="close">&times;</a>
            </div>
        {/if}
    </div>
</div>

<div class="row collapse">
    <div class="large-9 columns" id="purchases-area">
        <div id="list" class="purchases">
            {foreach from=$purchases item=purchase}
                <div class="row">
                    <div class="image cell">
                        <input type=hidden name=purchases[id][{$purchase->id}] value='{$purchase->id}'>
                        {$image = $purchase->product->images|first}
                        {if $image}
                            <img class=product_icon src='{$image->filename|resize:35:35}'>
                        {/if}
                    </div>
                    
                    <div class="purchase_name cell">
                        <div class='purchase_variant'>
							<span class=edit_purchase style='display:none;'>
							<select name=purchases[variant_id][{$purchase->id}] {if $purchase->product->variants|count==1 && $purchase->variant_name == '' && $purchase->variant->sku == ''}style='display:none;'{/if}>
			                    {if !$purchase->variant}<option price='{$purchase->price}' amount='{$purchase->amount}' value=''>{$purchase->variant_name|escape} {if $purchase->sku}(арт. {$purchase->sku}){/if}</option>{/if}
			                    {foreach $purchase->product->variants as $v}
			                        {if $v->stock>0 || $v->id == $purchase->variant->id}
			                            <option price='{$v->price}' amount='{$v->stock}' value='{$v->id}' {if $v->id == $purchase->variant_id}selected{/if} >
			                                {$v->name}
			                                {if $v->sku}(арт. {$v->sku}){/if}
			                            </option>
			                        {/if}
			                    {/foreach}
			                </select>
							</span>
							<span class=view_purchase>
								{$purchase->variant_name} {if $purchase->sku}(арт. {$purchase->sku}){/if}
							</span>
                        </div>

                        {if $purchase->product}
                            <a class="related_product_name" href="index.php?module=ProductAdmin&id={$purchase->product->id}&return={$smarty.server.REQUEST_URI|urlencode}">{$purchase->product->brand}  {$purchase->product_name}</a>
                        {else}
                            {$purchase->product_name}
                        {/if}                     
                    </div>
                    
                    <div class="price cell">
                        <span class=view_purchase>{$purchase->price}</span>
						<span class=edit_purchase style='display:none;'>
						<input type=text name=purchases[price][{$purchase->id}] value='{$purchase->price}' size=5>
						</span>
                        {$currency->sign}
                    </div>
                    <div class="amount cell">
						<span class=view_purchase>
							{$purchase->amount} {$settings->units}
						</span>
						<span class=edit_purchase style='display:none;'>
							{if $purchase->variant}
		                        {math equation="min(max(x,y),z)" x=$purchase->variant->stock+$purchase->amount*($order->closed) y=$purchase->amount z=$settings->max_order_amount assign="loop"}
		                    {else}
		                        {math equation="x" x=$purchase->amount assign="loop"}
		                    {/if}
		                    <select name=purchases[amount][{$purchase->id}]>
		                        {section name=amounts start=1 loop=501 step=1}
		                            <option value="{$smarty.section.amounts.index}" {if $purchase->amount==$smarty.section.amounts.index}selected{/if}>{$smarty.section.amounts.index} {$settings->units}</option>
		                        {/section}
		                    </select>
						</span>
                    </div>
                    <div class="icons cell">
                        {if !$order->closed}
                            {if !$purchase->product}
                                <img src='design/images/error.png' alt='Товар был удалён' title='Товар был удалён' >
                            {elseif !$purchase->variant}
                                <img src='design/images/error.png' alt='Вариант товара был удалён' title='Вариант товара был удалён' >
                            {elseif $purchase->variant->stock < $purchase->amount}
                                <img src='design/images/error.png' alt='На складе остал{$purchase->variant->stock|plural:'ся':'ось'} {$purchase->variant->stock} товар{$purchase->variant->stock|plural:'':'ов':'а'}' title='На складе остал{$purchase->variant->stock|plural:'ся':'ось'} {$purchase->variant->stock} товар{$purchase->variant->stock|plural:'':'ов':'а'}'  >
                            {/if}
                        {/if}
                        <a href='#' class="delete" title="Удалить"></a>
                    </div>
                    <div class="clear"></div>
                </div>
            {/foreach}
            
                
            <div id="new_purchase" class="row" style='display:none;'>
                <div class="image cell">
                    <input type=hidden name=purchases[id][] value=''>
                    <img class=product_icon src=''>
                </div>
                <div class="purchase_name cell">
                    <div class='purchase_variant'>
                        <select name=purchases[variant_id][] style='display:none;'></select>
                    </div>
                    <a class="purchase_name" href=""></a>
                </div>
                <div class="price cell">
                    <input type=text name=purchases[price][] value='' size=5> {$currency->sign}
                </div>
                <div class="amount cell">
                    <select name=purchases[amount][]></select>
                </div>
                <div class="icons cell">
                    <a href='#' class="delete" title="Удалить"></a>
                </div>
                <div class="clear"></div>
            </div>
        </div> 

        <style>
        	input[type=text]{
        		font-size: 0.77778rem;       	
        	}
        </style>
                  
        <div id="add_purchase" {if $purchases}style='display:none;'{/if}>
        	<input type=text name=related id='add_purchase' class="input_autocomplete" placeholder='Введите название товара или его sku (минимум 3 символа)'>
        </div>
        
        {if $purchases}
            <a href='#' class="dash_link edit_purchases">редактировать покупки</a>
        {/if}
        
        {if $purchases}
            <div class="subtotal">
                Всего<b> {$subtotal} {$currency->sign}</b>
            </div>
        {/if}
        
        {if $order->discount_price_promo > 0}
        	<p style="color: red;"><b>РАЗМЕР СКИДКИ:  {$order->discount_price_promo|convert}&nbsp;{$currency->sign} </b>
            	{if $order->promokod}
                	Введенный промокод: {$order->promokod}
                {/if}
            </p>
        {/if}        
        
        {if $order}
	        <div class="subtotal">
	           Общий вес<b> {$order->weight} кг</b>
	        </div>
        {/if}
        		
        {if $order}
	        <div class="subtotal">
	           Общий объем<b> {$order->volume} м3</b>
	        </div>
        {/if}
        
        <input name="weight" id="weight_cart" type="hidden" value="{$order->weight}" />
        <input name="volume" id="volume" type="hidden" value="{$order->volume}" />
                
        {if $order->cost_price != 0}
	        <div class="subtotal">
	           Стоимость доставки службой DPD в город {$order->cityname} (Регион: {$order->regioncode} {$order->regionname})<b> {$order->cost_price} {$currency->sign}</b><br>
	           Тариф DPD:
	           {if $order->dpd_tarif == 'BZP'}DPD 18:00{/if}
	           {if $order->dpd_tarif == 'ECN'}DPD ECONOMY{/if}
	           {if $order->dpd_tarif == 'TEN'}DPD 10:00{/if}
	           {if $order->dpd_tarif == 'DPT'}DPD 13:00{/if}
	           {if $order->dpd_tarif == 'CUR'}DPD CLASSIC{/if}
	           {if $order->dpd_tarif == 'NDY'}DPD EXPRESS{/if}
	           {if $order->dpd_tarif == 'CSM'}DPD CONSUMER{/if}
	           {if $order->dpd_tarif == 'PCL'}DPD CLASSIC Parcel{/if}
	            | Код услуги: {$order->dpd_tarif}
	        </div>
        {/if}
              
        {if $order->day_to_dpd != 0}
	        <div class="subtotal">
	          	Доставка осуществляется до <b>{if $order->to_apartment == 1}КВАРТИРЫ{/if}{if $order->to_apartment == 0}ТЕРМИНАЛА{/if}</b> в течении <b>{$order->day_to_dpd}</b> д.
	        </div>
        {/if}
        
        {if $order->day_to_dpd}
        	Доставка (дней): <b>{$order->day_to_dpd}</b><br>
        {/if}
        
		{if $order->pickuppoint_id}
			Стоимость самовывоза: <b>{$order->pickup_summ} руб</b><br>
		{/if}
		
        {if $order}
	        <div class="subtotal">
	          Итого: <b>{$order->total_price} {$currency->sign}</b>   
	        </div>
        {/if}
        
	
              

				
		{if $order->drug == 1}		
	        <div class="block discount layer">
	        	<h2>Статус оплаты заказа в приют</h2>
	            <select name="pay">
	                <option value="0" {if $order->pay == 0}selected{/if}>Не оплачен</option>
	                <option value="1" {if $order->pay == 1}selected{/if}>Оплачен</option>
	            </select>
	        </div>
        {/if}
        
        
         <div class="block discount layer">
	        	<h2>Заказ в приют?</h2>
	            <select name="drug">
	                <option value="0" {if $order->drug == 0}selected{/if}>нет</option>
	                <option value="1" {if $order->drug == 1}selected{/if}>да</option>
	            </select>
	        </div>


        <div class="block discount layer">
            <h2>Номер скидочной карты</h2>
            <input type=text name=card value='{$order->card}'>
        </div>

        <div class="block discount layer">
            <h2>Скидка</h2>
            <input style="float: left;" type=text name=discount value='{$order->discount}'> <span class=currency>%</span>
            <div style="clear: both;"></div>
        </div>
        <div>
        	<input style="width: 400px; max-width: 400px;" type="text" name="promocode" id="promocode" value='' /><br>
            <input style="min-width: 300xp; width: 300xp;" class="button_green" type="button" id="promokod_auto" data-num="{$order->id}" value="Выдать скидку по промокоду" />
        </div><br>

        <div class="subtotal layer">
            С учетом скидки<b> {($subtotal-$subtotal*$order->discount/100)|round:2} {$currency->sign}</b>
        </div>

        <div class="block discount layer">
            <h2>Купон{if $order->coupon_code} ({$order->coupon_code}){/if}</h2>
            <input type=text name=coupon_discount value='{$order->coupon_discount}'> <span class=currency>{$currency->sign}</span>
        </div>

        <div class="subtotal layer">
            С учетом купона<b> {($subtotal-$subtotal*$order->discount/100-$order->coupon_discount)|round:2} {$currency->sign}</b>
        </div>

        <div class="block delivery" style="margin-top: 10px;">
            <h2>Доставка DPD</h2>
            <div class="separate_delivery">
                <input type="text" id="separate_delivery" name="cost_price" value="{$order->cost_price}"> <label  for="separate_delivery">Стоимость доставки</label>
            </div>
        </div>

        <div class="total layer">
            Итого<b> {$order->total_price} {$currency->sign}</b>
        </div>

        <div class="block payment" >
            <h2>Оплата</h2>
            <select name="payment_method_id">
                <option value="0">Не выбрана</option>
                {foreach $payment_methods as $pm}
                    <option value="{$pm->id}" {if $pm->id==$payment_method->id}selected{/if}>{$pm->name}</option>
                {/foreach}
            </select>

            <input type=checkbox name="paid" id="paid" value="1" {if $order->paid}checked{/if}> <label for="paid" {if $order->paid}class="green"{/if}>Заказ оплачен</label>
        </div>

        {if $payment_method}
            <div class="subtotal layer">
                К оплате<b> {$order->total_price|convert:$payment_currency->id} {$payment_currency->sign}</b>
            </div>
        {/if}

        <div class="block_save">
            <input type="checkbox" value="1" id="notify_user" name="notify_user">
            <label for="notify_user">Уведомить покупателя о состоянии заказа</label>

            <input class="button_green button_save" type="submit" name="" value="Сохранить" />
        </div>
    </div>
    <div class="large-3 columns">
        <h2><a href='#' class="edit_order_details"><img src='design/images/pencil.png' alt='Редактировать' title='Редактировать'></a> Детали заказа</h2>

        <div id="user">
            <ul class="order_details">
                <li>
                    <label class=property>Дата</label>
                    <div class="edit_order_detail view_order_detail">
                        {$order->date} {$order->time}
                    </div>
                </li>
                <li>
                    <label class=property>Имя</label>
                    <div class="edit_order_detail" style='display:none;'>
                        <input name="name" class="simpla_inp" type="text" value="{$order->name|escape}" />
                    </div>
                    <div class="view_order_detail">
                        {$order->name|escape}
                    </div>
                </li>
                <li>
                    <label class=property>Email</label>
                    <div class="edit_order_detail" style='display:none;'>
                        <input name="email" class="simpla_inp" type="text" value="{$order->email|escape}" />
                    </div>
                    <div class="view_order_detail">
                        <a href="mailto:{$order->email|escape}?subject=Заказ%20№{$order->id}">{$order->email|escape}</a>
                    </div>
                </li>
                <li>
                    <label class=property>Телефон</label>
                    <div class="edit_order_detail" style='display:none;'>
                        <input name="phone" class="simpla_inp " type="text" value="{$order->phone|escape}" />
                    </div>
                    <div class="view_order_detail">
                        {if $order->phone}
                            <span class="ip_call" data-phone="{$order->phone|escape}" target="_blank">{$order->phone|escape}</span>{else}{$order->phone|escape}{/if}
                    </div>
                </li>
                <li>
                    <label class=property>Город</label>
                    <div class="edit_order_detail" style='display:none;'>
                    	<div>
	                        <select name="destination_id" id="destination_id">  
	                        	<option value="666">DPD</option>                	
	                            {foreach $destinations as $destination}
	                                <option value="{$destination->id}" {if $order->destination_id == $destination->id}selected{/if}>{$destination->location}</option>
	                            {/foreach}
	                        </select>
                        </div>
                        <br>
                        <p><input data-num={$order->destination_id} id="sity_no" type="checkbox" style="float: left;"><label style="float: left;" for="sity_no">Показать города DPD</label></p>
                        <div style="clear: both;"></div>
                        <p>Изначальный город: {$order->cityname} Регион: {$order->regioncode} {$order->regionname}</p>
          
                        <br>
                        <div id="city_of_dpd" style="display: none;">
                       		<div>
	                                <select id="region" name="region" style="width: 185px; max-width: 185px;">
									<option>(Выберите свой регион тут)</option>
								</select>
                            </div>
                                	
                            <div>
                                <select id="sity" name="sity" style="width: 185px; max-width: 185px;">
								</select>
                            </div>
                        </div>
                        <br>
                        <p id="delivery_result" style="display: none;"></p>
                    </div>
                                        
                    <div class="view_order_detail">
                    	{if !$order->cityname}
                        	{if $order->location}{$order->location}{else}Город не указан{/if}
                        {/if}
                        {if $order->cost_price}
                        	{if $order->cityname}
                        		{$order->cityname}<br>
                        	{/if}
                        	{if $order->regioncode}
                        		({$order->regioncode} {$order->regionname})
                        	{/if}
                        {/if}
                    </div>
                </li>
                <li id="address_dpd" style="display: none;">
                
                	<label for="streetAbbr_dpd">Тип улицы:</label>
                    <select name="streetAbbr_dpd" id="streetAbbr_dpd">
                    	<option value="ул." {if $order->streetAbbr_dpd=='ул.'}selected{/if}>Улица</option>
                        <option value="пр-кт" {if $order->streetAbbr_dpd=='пр-кт'}selected{/if}>Проспект</option>
                        <option value="бул." {if $order->streetAbbr_dpd=='бул.'}selected{/if}>Бульвар</option>
                        <option value="дор." {if $order->streetAbbr_dpd=='дор.'}selected{/if}>Дорога</option>
                        <option value="маг." {if $order->streetAbbr_dpd=='маг.'}selected{/if}>Магистраль</option>
                        <option value="наб." {if $order->streetAbbr_dpd=='наб.'}selected{/if}> Набережная</option>
                        <option value="пер." {if $order->streetAbbr_dpd=='пер.'}selected{/if}>Переулок</option>
                        <option value="дор." {if $order->streetAbbr_dpd=='дор.'}selected{/if}>Площадь</option>
                        <option value="пр-д" {if $order->streetAbbr_dpd=='пр-д'}selected{/if}>Проезд</option>  
                        <option value="ряд" {if $order->streetAbbr_dpd=='ряд'}selected{/if}>Ряд</option>
                        <option value="туп." {if $order->streetAbbr_dpd=='туп.'}selected{/if}>Тупик</option>
                        <option value="ш." {if $order->streetAbbr_dpd=='ш.'}selected{/if}>Шоссе</option>
                    </select>
                            	                            	
                    <label for="street_dpd">Название улицы:</label>
                    <input name="street_dpd" id="street_dpd" type="text" value="{$order->street_dpd}" />
                            	
                    <label for="house_dpd">Номер дома:</label>
                    <input name="house_dpd" id="house_dpd" type="text" value="{$order->house_dpd}" /> 
                            	                     	
                    <label for="houseKorpus_dpd">Корпус дома (если есть)</label>
                    <input name="houseKorpus_dpd" id="houseKorpus_dpd" type="text" value="{$order->houseKorpus_dpd}" />
                            	
                    <label for="houseApartment_dpd">Номер квартиры:</label>
                    <input name="houseApartment_dpd" id="houseApartment_dpd" type="text" value="{$order->houseApartment_dpd}" />
                </li>
                <li id="address_free">
                    <label class=property>Адрес <a href='http://maps.yandex.ru/' id=address_link target=_blank><img align=absmiddle src='design/images/map.png' alt='Карта в новом окне' title='Карта в новом окне'></a></label>
                    <div class="edit_order_detail" style='display:none;'>
                        <textarea name="address">{$order->address|escape}</textarea>
                    </div>
                    <div class="view_order_detail">
                        {$order->address|escape}
                    </div>
                </li>
                <li>
                    <label class=property>Комментарий пользователя</label>
                    <div class="edit_order_detail" style='display:none;'>
                        <textarea name="comment">{$order->comment|escape}</textarea>
                    </div>
                    <div class="view_order_detail">
                        {$order->comment|escape|nl2br}
                    </div>
                </li>
                <li>
					<label class=property>Пункт самовывоза</label>
					<div class="edit_order_detail" style='display:none'>
						<select class=status name="pickuppoint" style="font-size:15px; width:100%;">
							<option value='0' {if $order->pickuppoint_id == 0}selected{/if}></option>
							{foreach $pickuppoints as $pu}
								<option value='{$pu->id}' {if $order->pickuppoint_id == $pu->id}selected{/if}>{$pu->address}</option>
							{/foreach}
						</select>
					</div>
					<div class="view_order_detail">
						{$order->pickuppoint_address}
					</div>
				</li>
                {if $order->cost_price != 0}
                <li>
                    <label class=property>Доставка DPD</label>
                    <div class="view_order_detail">
                        DPD в город: <b>{$order->cityname}</b><br>
                    	Регион: <b>{$order->regioncode} {$order->regionname}</b><br>
	           			Тариф DPD:<b>
				           {if $order->dpd_tarif == 'BZP'}DPD 18:00{/if}
				           {if $order->dpd_tarif == 'ECN'}DPD ECONOMY{/if}
				           {if $order->dpd_tarif == 'TEN'}DPD 10:00{/if}
				           {if $order->dpd_tarif == 'DPT'}DPD 13:00{/if}
				           {if $order->dpd_tarif == 'CUR'}DPD CLASSIC{/if}
				           {if $order->dpd_tarif == 'NDY'}DPD EXPRESS{/if}
				           {if $order->dpd_tarif == 'CSM'}DPD CONSUMER{/if}
				           {if $order->dpd_tarif == 'PCL'}DPD CLASSIC Parcel{/if}</b><br>
	                	Код услуги в DPD: <b>{$order->dpd_tarif}</b><br>      
                        Сумма доставки: <b>{$order->cost_price} {$currency->sign}</b><br>
                        Доставка (дней): <b>{$order->day_to_dpd}</b><br>
                        Доставка до: <b>{if $order->to_apartment == 1}КВАРТИРЫ{/if}{if $order->to_apartment == 0}ТЕРМИНАЛА{/if}</b><br><br>
                        
                        <input id="data_for_dpd" name="data_for_dpd" placeholder="гггг-мм-дд" value="{$data_now}" /><br><br>
                        <input class="button_green" type="button" id="dpd_createOrder" data-num="{$order->id}" data-text="my_data" value="Оформить заказ в DPD" /><br><br>
                        <input class="button_green" type="button" id="dpd_print" data-num="{$order->id}" value="Печать наклейки" />
                    </div>
                </li>
                {/if}
                
            </ul>
        </div>

        {if $labels}
            <div class='layer'>
                <h2>Метка</h2>
                <!-- Метки -->
                <ul>
                    {foreach $labels as $l}
                        <li>
                            <label for="label_{$l->id}">
                                <div class="checker"><span><input id="label_{$l->id}" type="checkbox" name="order_labels[]" value="{$l->id}" {if in_array($l->id, $order_labels)}checked{/if}></span></div>
                                <span style="background-color:#{$l->color};" class="order_label"></span>
                                {$l->name}
                            </label>
                        </li>
                    {/foreach}
                </ul>
                <!-- Метки -->
            </div>
        {/if}


        <div class='layer'>
            <h2><a href='#' class="edit_user"><img src='design/images/pencil.png' alt='Редактировать' title='Редактировать'></a> Покупатель {if $user}<a href="#" class='delete_user'><img src='design/images/delete.png' alt='Удалить' title='Удалить'></a>{/if}</h2>
            <div class='view_user'>
                {if !$user}
                    Не зарегистрирован
                {else}
                    <a href='index.php?module=UserAdmin&id={$user->id}' target=_blank>{$user->name|escape}</a> ({$user->email|escape})
                {/if}
            </div>
            <div class='edit_user' style='display:none;'>
                <input type=hidden name=user_id value='{$user->id}'>
                <input type=text id='user' class="input_autocomplete" placeholder="Выберите пользователя">
            </div>
        </div>

        <div class='layer'>
            <h2><a href='#' class="edit_note"><img src='design/images/pencil.png' alt='Редактировать' title='Редактировать'></a> Примечание</h2>
            <ul class="order_details">
                <li>
                    <div class="edit_note">
                        <label class=property>Ваше примечание (не видно пользователю)</label>
                        <textarea name="note">{$order->note|escape}</textarea>
                    </div>
                </li>
            </ul>
        </div>
        
        <div class='layer'>
        	<textarea name="admin_log" id="admin_log" style="height: 170px; min-height: 170px; max-height: 170px; width: 220px; min-width: 220px; max-width: 220px;">{$order->admin_log}</textarea>
        </div>

    </div>
</div>

<input name="new_cost" id="new_cost" type="hidden" value="" />
<input name="new_day" id="new_day" type="hidden" value="" />
<input name="dpd_tarif" id="dpd_tarif" type="hidden" value="" />
<input name="new_city" id="new_city" type="hidden" value="" />
<input name="old_to_apartment" id="old_to_apartment" type="hidden" value="{$order->to_apartment}" />
<input name="new_to_apartment" id="new_to_apartment" type="hidden" value="" />

</form>
<!-- Основная форма (The End) -->

{* On document load *}
{literal}
<script src="design/js/autocomplete/jquery.autocomplete-min.js"></script>
<style>
.autocomplete-w1 { background:url(img/shadow.png) no-repeat bottom right; position:absolute; top:0px; left:0px; margin:6px 0 0 6px; /* IE6 fix: */ _background:none; _margin:1px 0 0 0; }
.autocomplete { border:1px solid #999; background:#FFF; cursor:default; text-align:left; overflow-x:auto; min-width: 625px; overflow-y: auto; margin:-6px 6px 6px -6px; /* IE6 specific: */ _height:350px;  _margin:0; _overflow-x:hidden; }
.autocomplete .selected { background:#F0F0F0; }
.autocomplete div { padding:2px 5px; white-space:nowrap; }
.autocomplete strong { font-weight:normal; color:#3399FF; }
</style>

<script>
$(function() {

	// Раскраска строк
	function colorize()
	{
		$("#list div.row:even").addClass('even');
		$("#list div.row:odd").removeClass('even');
	}
	// Раскрасить строки сразу
	colorize();
	
	// Удаление товара
	$(".purchases a.delete").live('click', function() {
		 $(this).closest(".row").fadeOut(200, function() { $(this).remove(); });
		 return false;
	});
 
	// Добавление товара
  	var new_purchase = $('.purchases #new_purchase').clone(true);
  	$('.purchases #new_purchase').remove().removeAttr('id');
  	  
	$("input#add_purchase").autocomplete({

  	serviceUrl:'ajax/add_order_product.php',
  	minChars: 3,
  	noCache: false,
  	onSelect:
  		function(value, data){
  			new_item = new_purchase.clone().appendTo('.purchases');
  			new_item.removeAttr('id');
  			new_item.find('a.purchase_name').html(data.name);
  			new_item.find('a.purchase_name').attr('href', 'index.php?module=ProductAdmin&id='+data.id);
  			
  			// Добавляем варианты нового товара
  			var variants_select = new_item.find('select[name*=purchases][name*=variant_id]');
			for(var i in data.variants)
  				variants_select.append("<option value='"+data.variants[i].id+"' price='"+data.variants[i].price+"' amount='"+data.variants[i].stock+"'>"+data.variants[i].name+"</option>");
  			
  			if(data.variants.length>1 || data.variants[0].name != '')
  				variants_select.show();
  				  				
			variants_select.bind('change', function(){change_variant(variants_select);});
				change_variant(variants_select);
  			
  			if(data.image)
  				new_item.find('img.product_icon').attr("src", data.image);
  			else
  				new_item.find('img.product_icon').remove();
  			
			$("input#add_purchase").val('');
  			new_item.show();
  			$(".button_save").click();
  		},
		fnFormatResult:
			function(value, data, currentValue){
				var reEscape = new RegExp('(\\' + ['/', '.', '*', '+', '?', '|', '(', ')', '[', ']', '{', '}', '\\'].join('|\\') + ')', 'g');
				var pattern = '(' + currentValue.replace(reEscape, '\\$1') + ')';
  				return (data.image?"<img align=absmiddle src='"+data.image+"'> ":'') + value.replace(new RegExp(pattern, 'gi'), '<strong>$1<\/strong>');
			}
  });

	
  /* $("input#add_purchase").autocomplete({
	  serviceUrl: 'http://zoo812.ru/ajax/search_products.php',
	  minChars: 1,
	  noCache: false,
	  onSelect: function (value, data) {
			
			variants_select.bind('change', function(){change_variant(variants_select);});
				change_variant(variants_select);
			
			if(data.image)
				new_item.find('img.product_icon').attr("src", data.image);
			else
				new_item.find('img.product_icon').remove();

			$("input#add_purchase").val('');
			new_item.show();
	      
	  },
	  fnFormatResult: function (value, data, currentValue){
	      var reEscape = new RegExp('(\\' + ['/', '.', '*', '+', '?', '|', '(', ')', '[', ']', '{', '}', '\\'].join('|\\') + ')', 'g');
	      var pattern = '(' + currentValue.replace(reEscape, '\\$1') + ')';
	      return (data.image ? "<img align=absmiddle src='" + data.image + "'> " : '') + value.replace(new RegExp(pattern, 'gi'), '<strong>$1<\/strong>');
	  }

  }); */
  
   // Изменение цены и макс количества при изменении варианта
   function change_variant(element){
		price = element.find('option:selected').attr('price');
		amount = element.find('option:selected').attr('amount');
		element.closest('.row').find('input[name*=purchases][name*=price]').val(price);
		
		// 
		amount_select = element.closest('.row').find('select[name*=purchases][name*=amount]');
		selected_amount = amount_select.val();
		amount_select.html('');
		for(i=1; i<=amount; i++)
			amount_select.append("<option value='"+i+"'>"+i+" {/literal}{$settings->units}{literal}</option>");
		amount_select.val(Math.min(selected_amount, amount));

		return false;
   }
 
	// Редактировать покупки
	$("a.edit_purchases").click( function(){
		 $(".purchases span.view_purchase").hide();
		 $(".purchases span.edit_purchase").show();
		 $(".edit_purchases").hide();
		 $("div#add_purchase").show();
		 return false;
	});
  
	// Редактировать получателя
	$("a.edit_order_details").click(function(){
		 $("ul.order_details .view_order_detail").hide();
		 $("ul.order_details .edit_order_detail").show();
		 return false;
	});
  
	// Редактировать примечание
	$("a.edit_note").click(function(){
		 $("div.view_note").hide();
		 $("div.edit_note").show();
		 return false;
	});
  
	// Редактировать пользователя
	$("a.edit_user").click(function(){
		 $("div.view_user").hide();
		 $("div.edit_user").show();
		 return false;
	});
	
	$("input#user").autocomplete({
		serviceUrl:'ajax/search_users.php',
		minChars:0,
		noCache: false, 
		onSelect:
			function(value, data){
				$('input[name="user_id"]').val(data.id);
			}
	});
  
	// Удалить пользователя
	$("div#order_details a.delete_user").click(function() {
		$('input[name="user_id"]').val(0);
		$('div.view_user').hide();
		$('div.edit_user').hide();
		return false;
	});

	// Посмотреть адрес на карте
	$("a#address_link").attr('href', 'http://maps.yandex.ru/?text='+$('#order_details textarea[name="address"]').val());
  
	// Подтверждение удаления
	$('select[name*=purchases][name*=variant_id]').bind('change', function(){change_variant($(this));});
	$("input[name='status_deleted']").click(function(){
		if(!confirm('Подтвердите удаление'))
			return false;
	});

});

</script>

<style>
.ui-autocomplete{
background-color: #ffffff; width: 100px; overflow: hidden;
border: 1px solid #e0e0e0;
padding: 5px;
}
.ui-autocomplete li.ui-menu-item{
overflow: hidden;
white-space:nowrap;
display: block;
}
.ui-autocomplete a.ui-corner-all{
overflow: hidden;
white-space:nowrap;
display: block;
}
</style>
{/literal}
