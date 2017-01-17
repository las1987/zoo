{* Страница заказа *}

{literal}
<script>
$(document).ready(function(){

	$('#repeat').click(function (){

		{/literal}{foreach $purchases as $purchase}{literal}
		
		var variant = {/literal}"{$purchase->variant_id}"{literal};
		var amount  = {/literal}"{$purchase->amount}"{literal};
		
		$.ajax({
			url: "ajax/cart.php",
			data: {variant: variant, amount: amount},
			dataType: 'json',
			success: function(data){
				$('#cart_informer').html(data);
		        $('<div id="purchase-success" style="position: absolute; left: 0; right: 0; top: 0; bottom: 0; background: #924459; color: #ffffff; font-size: 12px; padding: 10px; z-index: 999; white-space: nowrap;">Товар успешно добавлен в корзину!</div>').appendTo('#navbar-cart').delay(2500).fadeOut(300, function(){
		            $(this).remove();
		        });
				if(button.attr('data-result-text'))
					button.val(button.attr('data-result-text'));
			}
		});
		{/literal}{/foreach}{literal}
		
		setTimeout(function () {			
			document.location.href='http://zoo812.ru/cart/';
		}, 1250); // время в мс
		
	});
});

</script>

{/literal}

<!-- Retailrocket Трекер совершения транзакции -->
{literal}
<script type="text/javascript">
    rrApiOnReady.push(function() {
        try {
            rrApi.order({
                transaction: {/literal}{$order->id}{literal},
                items: [
                {/literal}{foreach from=$purchases item=purchase name=good}{literal}
                    { 
                        id: {/literal}{$purchase->variant_id}{literal},
                        qnt: {/literal}{$purchase->amount}{literal},
                        price: {/literal}{$purchase->price}{literal}
                    }
               {/literal}{if !$smarty.foreach.good.last}{literal},{/literal}{/if}
               {/foreach}{literal}
                ]
            });
        } catch(e) {}
    })
</script>
{/literal}
<!-- Retailrocket Трекер совершения транзакции -->


{$meta_title = "Ваш заказ №{if $order->id_new == 0}{$order->id}{else}{$order->id_new}{/if}" scope=parent}

<aside class="large-3 medium-3 columns">



    <!-- Меню каталога (The End) -->
	{include file='main_menu.tpl' categories=$categories}
    <!-- Меню каталога (The End)-->

</aside>

<div class="large-9 medium-9 columns">

    {* Содержимое страницы *}
    <div class="row collapse" id="inner">
        <div class="large-12 columns">

            {include file="_inc_main-menu.tpl"}
            <div class="large-12 columns" id="active-page">

                {* Хлебные крошки *}
                <div class="row collapse">
                    <div class="large-12 columns">
                        <div class="lk-breadcrumbs">
                            <span><i class="fa fa-home"></i><a href="/{$settings->sub}">Главная</a></span><span class="divider">&gt;</span><span>Ваш заказ №{if $order->id_new == 0}{$order->id}{else}{$order->id_new}{/if} 
                                {if $order->status == 0}принят{/if}
                                {if $order->status == 1}в обработке{/if}
                                {if $order->status == 2}выполнен{/if}
                                {if $order->status == 3}аннулирован{/if}
                                {if $order->paid == 1}, оплачен{else}{/if}</span>
                        </div>
                    </div>
                </div>
                
                {if $order->status == 0}
	                {literal}
	                <style>
	                	h1{
	                		color: #F48301;
	                		background: url('../temp001/40px-done-circle-orange-ivanko-dostavka.png') no-repeat 0;
	                		padding-left: 55px;
	                		min-height: 45px;
	                		padding-top: 5px;
	                		margin-top: 10px;
	                		margin-bottom: 10px;
	                	}
	                	
	                	#main-menu p{
	                		font-size: 85% !important; 
	                		color: #929090;
	                	}
	                	
	                	.select{
	                		color: #F48301;
	                	}
	                	
	                	.border_order{
	                		border: thin dotted #F48301;
	                		padding: 10px !important;
	                		margin-top: 5px;
	                		margin-bottom: 10px;
	                	}
	                	
	                	.total_price_block{
	                		border-top: thin dotted #F48301;
	                		padding-top: 10px;
	                	}	                		                	
	                </style>	                
	                
	                {/literal}
                {/if}
                
                {if $order->status == 1}
                	{literal}
	                <style>
	                	h1{
	                		color: #F0C000;
	                		background: url('../temp001/40px-yello-inwork-ivanko-dostavka.png') no-repeat 0 0;
	                		padding-left: 45px;
	                		min-height: 45px;
	                		padding-top: 5px;
	                		margin-top: 20px;
	                		margin-bottom: 5px;
	                	}
	                	
	                	#main-menu  p{
	                		font-size: 85% !important; 
	                		color: #F0C000;
	                	}
	                	
	                	.select{
	                		color: #F0C000;
	                	}
	                	
	                	.border_order{
	                		border: thin dotted #F0C000;
	                		padding: 10px !important;
	                		margin-top: 5px;
	                		margin-bottom: 10px;
	                	}
	                	
	                	.total_price_block{
	                		border-top: thin dotted #FFDB4C;
	                		padding-top: 10px;
	                	}	                		                	
	                </style>
	                {/literal}
                {/if}
                               
                {if $order->status == 2}
                	{literal}
	                <style>
	                	h1{
	                		color: #96AA2D;
	                		background: url('../temp001/40px-delivered-style1-orange-ivanko-dostavka.png') no-repeat 0 0;
	                		padding-left: 45px;
	                		min-height: 45px;
	                		padding-top: 5px;
	                		margin-top: 20px;
	                		margin-bottom: 5px;
	                	}
	                	
	                	#main-menu  p{
	                		font-size: 85% !important; 
	                		color: #96AA2D;
	                	}
	                	
	                	.select{
	                		color: #96AA2D;
	                	}
	                	
	                	.border_order{
	                		border: thin dotted #96AA2D;
	                		padding: 10px !important;
	                		margin-top: 5px;
	                		margin-bottom: 10px;
	                	}
	                	
	                	.total_price_block{
	                		border-top: thin dotted #96AA2D;
	                		padding-top: 10px;
	                	}	                		                	
	                </style>
	                {/literal}
                {/if}
                
                {if $order->status == 3}
                	{literal}
	                <style>
	                	h1{
	                		color: #ff1814;
	                		background: url('../temp001/40px-canceled-type2-ivanko-dostavka.png') no-repeat 0 0;
	                		padding-left: 45px;
	                		min-height: 45px;
	                		padding-top: 5px;
	                		margin-top: 20px;
	                		margin-bottom: 5px;
	                	}
	                	
	                	p{
	                		font-size: 85% !important; 
	                		color: #96AA2D;
	                	}
	                	
	                	.select{
	                		color: #ff1814;
	                	}
	                	
	                	.border_order{
	                		border: thin dotted #ff1814;
	                		padding: 10px !important;
	                		margin-top: 5px;
	                		margin-bottom: 10px;
	                	}
	                	
	                	.total_price_block{
	                		border-top: thin dotted #ff1814;
	                		padding-top: 10px;
	                	}	                		                	
	                </style>
	                {/literal}
                
                {/if}

                <div class="row collapse">
                    <div class="large-12 columns">
                    	<div class="border_order">                    	
                    		<div style="overflow: hidden;">
	                        <h1 style=" {if $order->status != 0}display: block; float: left; width: 400px; max-width: 400px; min-width: 400px;{/if}">
	                        {if $order->status == 0}                        
	                        Благодарим за покупку!<br> 
	                        {/if}Ваш заказ №{if $order->id_new == 0}{$order->id}{else}{$order->id_new}{/if} 
	                            {if $order->status == 0}принят в обработку{/if}
	                            {if $order->status == 1}в обработке{/if}
	                            {if $order->status == 2}выполнен{/if}
	                            {if $order->status == 3}аннулирован{/if}
	                        </h1>
	                       	{if $order->status == 0}
		                       	{if $time}
			                       	{if (($time == 10)||($time == 11)||($time == 12)||($time == 13)||($time == 14)||
			                       		($time == 15)||($time == 16)||($time == 17)||($time == 18)||($time == 19))}
										<!--- <p>В настоящий момент Ваш заказ обрабатывается. 
																			
										{if (!($date_time_error))}										
											В течение 1 часа с Вами свяжется оператор для уточнения деталей доставки.
										{else}
											<br><br>В связи с большим количеством заказов время обработки заказа может превышать один день.
										{/if}

										</p>
										<p>Обращаем Ваше внимание на то, что окончательная стоимость заказа с учетом скидок формируется оператором после подтверждения.</p>
										<p>Если у Вас остались вопросы, просим Вас связаться с нами в рабочее время с указанием номера заказа: <span class="select">{if $order->id_new == 0}{$order->id}{else}{$order->id_new}{/if}</span></p>
			                        {else}
			                        	<p>В настоящий момент Ваш заказ обрабатывается. В рабочее время с Вами свяжется оператор для уточнения деталей доставки.</p>
										<p>Обращаем Ваше внимание на то, что окончательная стоимость заказа с учетом скидок формируется оператором после подтверждения.</p>
										<p>Если у Вас остались вопросы, просим Вас связаться с нами в рабочее время с указанием номера заказа: <span class="select">{if $order->id_new == 0}{$order->id}{else}{$order->id_new}{/if}</span></p>
										
										
										
			                        {/if}  --->
									
									<p>Ожидайте звонок оператора для подтверждения заказа. Оператор уточнит детали доставки и произведет окончательный расчет стоимости заказа с учетом всех скидок.</p>
										
									<p>Обращаем Ваше внимание, что обработка заказов операторами производится ежедневно с 9:00 до 21:00 (по Мск).</p>
										
									<p>Если Вы хотите связаться с нами самостоятельно, позвоните по телефону <a href="tel:88005551664">8 (800) 555-16-64</a> или напишите нам на электронную почту <a href="mailto:dostavka@ivanki.ru">dostavka@ivanki.ru</a></p>
									
		                        {/if}
	                        {/if}                        
	                        
	                        {if $order->status == 2}
	                		<div style="float: left; width: 230px; max-width: 230px; min-width: 230px;">
	                			<input id="repeat" type="button" class="button" value="Повторить заказ" style="width: 230px; max-width: 230px; margin-top: 20px;
	                			" />
	                		</div>
	                		{/if}
	                		
	                		<div class="clear"></div>
	                		</div>
                			<div class="clear"></div>
                		</div>
                		<div class="clear"></div>
                    </div>
                    <div class="clear"></div>
                </div>
                <div class="clear"></div>

                {* Список покупок *}
                <table id="purchases" style="margin-bottom: 3px !important;">

                    {foreach $purchases as $purchase}
                        <tr>
                            {* Изображение товара *}
                            <td class="image">
                                {$image = $purchase->product->images|first}
                                {if $image}
                                    <a href="/products/{$purchase->product->url}/"><img src="{$image->filename|resize:50:50}" alt="{$product->name|escape}"></a>
                                {/if}
                            </td>

                            {* Название товара *}
                            <td class="name">
                                <a href="/products/{$purchase->product->url}/">{$purchase->product_name|escape}</a>
                                {$purchase->variant_name|escape}
                                {if $order->paid && $purchase->variant->attachment}
                                    <a class="download_attachment" href="/order/{$order->url}/{$purchase->variant->attachment}">скачать файл</a>
                                {/if}
                                <br>
                                Арт. <span class="variant_sku">{$purchase->variant->sku}</span>
                            </td>

                            {* Цена за единицу *}
                            <td class="price">
                                {($purchase->price)|convert}&nbsp;{$currency->sign}
                            </td>

                            {* Количество *}
                            <td class="amount">
                                {$purchase->amount}&nbsp;{$settings->units}
                            </td>

                            {* Цена *}
                            <td class="price">
                                {($purchase->price*$purchase->amount)|convert}&nbsp;{$currency->sign}
                            </td>
                        </tr>
                    {/foreach}
                                                            
                    {* Скидка, если есть *}
                    {if $order->discount > 0}
                        <tr>
                            <th class="image"></th>
                            <th class="name">скидка</th>
                            <th class="price"></th>
                            <th class="amount"></th>
                            <th class="price">
                                <span style="color: #e73b3b; font-weight: bold;">{$order->discount}&nbsp;%</span>
                            </th>
                        </tr>
                    {/if}
                    {* Купон, если есть *}
                    {if $order->coupon_discount > 0}
                        <tr>
                            <th class="image"></th>
                            <th class="name">купон</th>
                            <th class="price"></th>
                            <th class="amount"></th>
                            <th class="price">
                                &minus;{$order->coupon_discount|convert}&nbsp;{$currency->sign}
                            </th>
                        </tr>
                    {/if}
                    {* Если стоимость доставки входит в сумму заказа *}
                    {if !$order->separate_delivery && $order->delivery_price>0}
                        <tr>
                            <td class="image>"</td>
                            <td class="name">{$delivery->name|escape}</td>
                            <td class="price"></td>
                            <td class="amount"></td>
                            <td class="price">
                                {$order->delivery_price|convert}&nbsp;{$currency->sign}
                            </td>
                        </tr>
                    {/if}
                    
                    {* Если есть скидка по промокоду *}
                    {if $order->discount_price_promo > 0}
                    	<tr>
                            <td class="image"></td>
                            <td class="name">Размер скидки</td>
                            <td class="price"></td>
                            <td class="amount"></td>
                            <td class="price">
                                <span style="color: #e73b3b; font-weight: bold;">{$order->discount_price_promo|convert}&nbsp;{$currency->sign}</span>
                            </td>
                        </tr>
                    {/if}
                    
                     {* Если есть стоимость доставки  *}
                    {if $order->cost_price > 0}
                    	<tr>
                            <td class="image"></td>
                            <td class="name">Сумма доставки</td>
                            <td class="price"></td>
                            <td class="amount"></td>
                            <td class="price">
                                {$order->cost_price|convert}&nbsp;{$currency->sign}
                            </td>
                        </tr>
                    {/if}

                    {* Итого *}
                    <tr>
                        <th class="image"></th>
                        <th class="name"></th>
                        <th class="price"></th>
                        <th class="amount">Итого:</th>
                        <th class="price">
                        	<b>{$order->total_price|convert}&nbsp;{$currency->sign}</b>
                        </th>
                    </tr>
                    {* Если стоимость доставки не входит в сумму заказа *}
                    {if $order->separate_delivery}
                        <tr>
                            <td class="image>"</td>
                            <td class="name">{$delivery->name|escape}</td>
                            <td class="price"></td>
                            <td class="amount"></td>
                            <td class="price">
                                {$order->delivery_price|convert}&nbsp;{$currency->sign}
                            </td>
                        </tr>
                    {/if}

                </table>

                {* Детали заказа *}
                <h2>Детали заказа</h2>
                <table class="order_info">
                    <tr>
                        <td>
                            Дата заказа
                        </td>
                        <td>
                            {$order->date|date} в
                            {$order->date|time}
                        </td>
                    </tr>
                    {if $order->name}
                        <tr>
                            <td>
                                Имя
                            </td>
                            <td>
                                {$order->name|escape}
                            </td>
                        </tr>
                    {/if}
                    {if $order->email}
                        <tr>
                            <td>
                                Email
                            </td>
                            <td>
                                {$order->email|escape}
                            </td>
                        </tr>
                    {/if}
                    {if $order->phone}
                        <tr>
                            <td>
                                Телефон
                            </td>
                            <td>
                                {$order->phone|escape}
                            </td>
                        </tr>
                    {/if}
                    {if $order->address}
                        <tr>
                            <td>
                                Адрес доставки
                            </td>
                            <td>
                                {$order->address|escape}
                            </td>
                        </tr>
                    {/if}
                    {if $order->comment}
                        <tr>
                            <td>
                                Комментарий
                            </td>
                            <td>
                                {$order->comment|escape|nl2br}
                            </td>
                        </tr>
                    {/if}
                </table>
                
				{if $order->status == 0}
                {if !$order->paid}
					
                    {* Выбраный способ оплаты *}
                    {if $payment_method}
                        <p style='color: #5A5A5A; font-size: 14px; font: 14px "Roboto", Arial, sans-serif;'>
                        	Способ оплаты: <span style="text-transform: lowercase;"><b>{$payment_method->name}</b></span>
                        </p>
                        <p>
                            {$payment_method->description}
                        </p>
                        
                        <h2 class="select total_price_block" >
                            К оплате: {$order->total_price|convert:$payment_method->currency_id}&nbsp;{$all_currencies[$payment_method->currency_id]->sign}.
                        </h2>
                        
                        {* Форма оплаты, генерируется модулем оплаты *}
                        {checkout_form order_id=$order->id_new module=$payment_method->module}
                        
                        {if $payment_method->id == 2}
                        	<a class="button radius orange" href="/files/oos-payment-page.php?orderId={if $order->id_new == 0}{$order->id}{else}{$order->id_new}{/if}">оплатить</a>
                        {/if}
                        
                    {/if}
                {/if}    
                   

                {/if}
                
                
            </div>
            <div style="clear: both;"></div>
        </div>
        <div style="clear: both;"></div>
    </div>
    <div style="clear: both;"></div>
</div>
<div style="clear: both;"></div>
</div>