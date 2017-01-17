{* Вкладки *}
{capture name=tabs}
	{if in_array('delivery', $manager->permissions)}<li><a href="index.php?module=SettingsAdmin">Настройки</a></li>{/if}
	{if in_array('delivery', $manager->permissions)}<li><a href="index.php?module=DeliveriesAdmin">Доставка</a></li>{/if}
    {if in_array('delivery', $manager->permissions)}<li><a href="index.php?module=DestinationsAdmin">Локации</a></li>{/if}
	{if in_array('payment', $manager->permissions)}<li><a href="index.php?module=PaymentMethodsAdmin">Оплата</a></li>{/if}
	{if in_array('managers', $manager->permissions)}<li><a href="index.php?module=ManagersAdmin">Менеджеры</a></li>{/if}
	<li class="active"><a href="index.php?module=PickupPointsAdmin">Самовывоз</a></li>
	<li><a href="index.php?module=TownsAdmin">Доставка по городам</a></li>
	<li><a href="index.php?module=AttentionAdmin">Плашка</a></li>	
{/capture}

{if $pickuppoint->id}
{$meta_title = $pickuppoint->adress scope=parent}
{else}
{$meta_title = 'Новый пункт самовывоза' scope=parent}
{/if}

{* Подключаем Tiny MCE *}
{include file='tinymce_init.tpl'}

{* On document load *}
{literal}
<script src="design/js/jquery/jquery.js"></script>
<script src="design/js/jquery/jquery.form.js"></script>
<script src="design/js/jquery/jquery-ui.min.js"></script>

<script src="//api-maps.yandex.ru/2.1/?lang=ru_RU" type="text/javascript"></script>



<script>
	$(function(){
	// Добавление стоимости доставки в пункт выдачи
	var option = $('#new_option').clone(true);
	$('#new_option').remove().removeAttr('id');
	$('#options_block span.add').click(function() {
		if(!$('#options_block').is('.single_variant'))
		{
			$(option).clone(true).appendTo('#options').fadeIn('slow').find("input[name*=pickuppoint_options][name*=summ_min_value]").focus();
			$('span.del_option').click(function() {
			if($("#options ul").size()>0)
			{
				$(this).closest("ul").fadeOut(200, function() { $(this).remove(); });
			}
			return false;
			});
		}
		else
		{
			$('#options_block .option_id').show('slow');
			$('#options_block').removeClass('single_variant');		
		}
		return false;		
	});
	
	//удаление стоимости доставки в пункт выдачи
	$('span.del_option').click(function() {
		if($("#options ul").size()>1)
		{
			$(this).closest("ul").fadeOut(200, function() { $(this).remove(); });
		}
		else
		{
			
		}
		return false;
	});
	});
</script>

{/literal}


<script>
ymaps.ready(function () {
    var myMap = new ymaps.Map('pickupPointsMap', {
            center: [{if $pickuppoint->latitude}{$pickuppoint->latitude}{else}59.89444{/if}, {if $pickuppoint->longitude}{$pickuppoint->longitude}{else}30.26417{/if}],
            zoom: 16,
            controls: []
        }),
    // Создаем экземпляр класса ymaps.control.SearchControl
        mySearchControl = new ymaps.control.SearchControl({
            options: {
                noPlacemark: true
            }
			
        }),
    // Результаты поиска будем помещать в коллекцию.
        mySearchResults = new ymaps.GeoObjectCollection(null, {
            hintContentLayout: ymaps.templateLayoutFactory.createClass('$[properties.name]')
        });
		
		var myPlacemark = new ymaps.Placemark(myMap.getCenter(), {
        balloonContentBody: [
            '<address>',
            '<br/>',
            'Адрес: {if $pickuppoint->address}{$pickuppoint->address}{/if}',
            '<br/>',
            '</address>'
        ].join('')
    }, {
        preset: 'islands#redDotIcon'
    });
		
		myMap.geoObjects.add(myPlacemark);
		myMap.controls.add(mySearchControl);
		myMap.geoObjects.add(mySearchResults);
   
   
		mySearchResults.events.add('click', function (e) {
        e.get('target').options.set('preset', 'islands#redIcon');
		
    });
    // Выбранный результат помещаем в коллекцию.
    mySearchControl.events.add('resultselect', function (e) {
        var index = e.get('index');
        mySearchControl.getResult(index).then(function (res) {
            $('#latitude').val(res.geometry._coordinates[0]);
		    $('#longitude').val(res.geometry._coordinates[1]);
			mySearchResults.add(res);
		
        });
    }).add('submit', function () {
            mySearchResults.removeAll();
        })
});
</script>


{if $message_success}
<!-- Системное сообщение -->
<div class="message message_success">
	<span>{if $message_success == 'added'}Пункт выдачи добавлен{elseif $message_success == 'updated'}Пункт выдачи изменен{/if}</span>
	{if $smarty.get.return}
	<a class="button" href="{$smarty.get.return}">Вернуться</a>
	{/if}
</div>
<!-- Системное сообщение (The End)-->
{/if}

{if $message_error}
<!-- Системное сообщение -->
<div class="message message_error">
	<span>{$message_error}</span>
	<a class="button" href="">Вернуться</a>
</div>
<!-- Системное сообщение (The End)-->
{/if}
 

<!-- Основная форма -->
<form method=post id=pickuppoint enctype="multipart/form-data">
	<input type=hidden name="session_id" value="{$smarty.session.id}">
	<div class="row collapse">
		 <div id="name" class=name>
			<input id=name  name=name type="text" value="{$pickuppoint->name}"/> 
			<input name=id type="hidden" value="{$pickuppoint->id}"/> 
		 </div>
		 <div class="large-2 columns">
			<div class="checkbox">
				<input name=enabled value='1' type="checkbox" id="active_checkbox" {if $pickuppoint->enabled}checked{/if}/> <label for="active_checkbox">Активен</label>
			</div>
		 </div>		
	</div>
	
	<div class="row collapse">
		<div class="large-5 columns">
			<div id="pickupPointsMap" style="height:350px;"></div>		
		</div>
		<div class="large-6 columns">
			<h2>Координаты пункта выдачи</h2>
			<div class="row collapse">
				<div class="large-5 columns">
					<label class=property>Широта</label><input id=latitude name=latitude type="text" value="{$pickuppoint->latitude}"/> 	
				</div>
				<div class="large-5 columns">
					<label class=property>Долгота</label><input id=longitude name=longitude type="text" value="{$pickuppoint->longitude}"/> 
				</div>
			</div>
				
			<div class="row collapse">
				<div class="large-3 columns">
					<label class=property>Метро</label><input id=metro_station name=metro_station type="text" value="{$pickuppoint->metro_station}"/> 
				</div>

				<div class="large-8 columns">
					<label class=property>Адрес пункта самовывоза</label><input id="Address" class="name" name=address type="text" value="{$pickuppoint->address|escape}"/> 
				</div>			
			</div>
			<div class="row collapse">	
				<div class="large-5 columns">
					<label class=property>Время работы</label><input id=worktime name=worktime type="text" value="{$pickuppoint->worktime}"/> 	
				</div>
				<div class="large-5 columns">
					<label class=property>Телефон</label><input id=phone name=phone type="text" value="{$pickuppoint->phone}"/> 
				</div>
			</div>
				
			<div class="row collapse">
				<div class="large-12 columns">
					<label class=property>Сайт</label><input id=url name=url type="text" value="{$pickuppoint->url}"/> 
				</div>
			</div>
			<div class="row collapse">
				<h2>Ограничения для пункта выдачи</h2>
				<div class="large-3 columns">
					<label class=property>По сумме ({$currency->sign}.)</label><input id=summ_limit name=summ_limit type="number" value="{$pickuppoint->summ_limit}"/> 
				</div>

				<div class="large-3 columns" style="padding:0 4px;">
					<label class=property>По весу(кг.)</label><input id=weight_limit name=weight_limit type="number" value="{$pickuppoint->weight_limit}"/> 
				</div>
				<div class="large-3 columns">
					<label class=property>Макс. габарит (см.)</label><input id=size_limit name=size_limit type="number" value="{$pickuppoint->size_limit}"/> 		
				</div>
				<div class="large-3 columns" style="padding:0 4px;">
					<label class=property>3 стороны (см.)</label><input id=sides_limit name=sides_limit type="number" value="{$pickuppoint->sides_limit}"/> 		
				</div>
			</div>
		</div>			
	</div>
	<div class="row collapse">
		<h2>Стоимость доставки в пункт выдачи</h2><span>(Если не указано или не удовлетворяет критериям - Бесплатно)</span>
		<div id="options_block">
			<ul id="header">
				<li class="option_id"></li> 
				<li class="option_summfrom">Сумма от ({$currency->sign})</li>	
				<li class="option_summto">Сумма до ({$currency->sign})</li>	
				<li class="option_price">Стоимость доставки ({$currency->sign})</li>	
			</ul>
			<div id=options>
				{foreach from=$pickuppoint_options item=option}
					<ul class="my_opt">
						<li class="option_id">      		<input name="pickuppoint_options[id][]"            	  	type="hidden" 	value="{$option->id|escape}" /><span class="del_option"><img src="design/images/cross-circle-frame.png" alt="" /></span></li>		
						<li class="option_summfrom">       	<input name="pickuppoint_options[summ_min_value][]"     type="number"   value="{$option->summ_min_value|escape}" /></li>
						<li class="option_summto">     		<input name="pickuppoint_options[summ_max_value][]"     type="number"   value="{$option->summ_max_value|escape}" /></li>
						<li class="option_price">  			<input name="pickuppoint_options[pickup_price_value][]" type="number"   value="{$option->pickup_price_value|escape}" /></li>
					</ul>
				{/foreach}				
			</div>
			<ul id=new_option style='display:none;'>
				<li class="option_id"><input name="pickuppoint_options[id][]" type="hidden" value="" /><span class="del_option"><img src="design/images/cross-circle-frame.png" alt="" /></span></li>
				<li class="option_summfrom"><input name="pickuppoint_options[summ_min_value][]" type="number" value="" /></li>
				<li class="option_summto"><input name="pickuppoint_options[summ_max_value][]" type="number" value="" /></li>
				<li class="option_price"><input name="pickuppoint_options[pickup_price_value][]" type="number" value="" /></li>
			</ul>
		
			
			<input class="button_green button_save" type="submit" name="" value="Сохранить" />
			<span class="add" id="add_pickuppoints_options"><i class="dash_link">Добавить стоимость доставки</i></span>
		</div>
	</div>
	
	<!-- Описание товара (The End)-->
	<div class="row collapse">
		<input class="button_green button_save" type="submit" name="" value="Сохранить" />
	</div>
</form>
<!-- Основная форма (The End) -->


