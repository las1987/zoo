{* Вкладки *}
{capture name=tabs}
	{if in_array('delivery', $manager->permissions)}<li><a href="index.php?module=SettingsAdmin">Настройки</a></li>{/if}
	{if in_array('delivery', $manager->permissions)}<li><a href="index.php?module=DeliveriesAdmin">Доставка</a></li>{/if}
    {if in_array('delivery', $manager->permissions)}<li><a href="index.php?module=DestinationsAdmin">Локации</a></li>{/if}
	{if in_array('payment', $manager->permissions)}<li><a href="index.php?module=PaymentMethodsAdmin">Оплата</a></li>{/if}
	{if in_array('managers', $manager->permissions)}<li><a href="index.php?module=ManagersAdmin">Менеджеры</a></li>{/if}
	<li class="active"><a href="index.php?module=PickupPoints">Самовывоз</a></li>
	<li><a href="index.php?module=TownsAdmin">Доставка по городам</a></li>
	<li><a href="index.php?module=AttentionAdmin">Плашка</a></li>	
{/capture}


{* Title *}
{$meta_title='Самовывоз' scope=parent}
{* Заголовок *}
<div id="header">
	<div class="row collapse">
		<div class="large-8 columns">
			{if $keyword && $pickuppoints_count}
				<h1>{$pickuppoints_count|plural:'Нашелся':'Нашлось':'Нашлись'} {$pickuppoints_count} {$pickuppoints_count|plural:'пункт самовывоза':'пунктов самовывоза':'пункта самовывоза'}</h1>
			{elseif !$type}
				<h1>{$pickuppoints_count} {$pickuppoints_count|plural:'пункт самовывоза':'пунктов самовывоза':'пункта самовывоза'}</h1>
				<a class="button rounded" href="{url module=PickupPointAdmin}"><i class="fa fa-plus"></i>Добавить пункт самовывоза</a>
			{/if}
		</div>
		<div class="large-4 columns">
			<form method="get">
				<div class="row collapse">
					<div class="large-8 columns">
						<input type="hidden" name="module" value="PickupPointsAdmin">
						<input type="text" name="keyword" value="{$keyword|escape}" />
					</div>
					<div class="large-4 columns">
						<input class="button rounded-right postfix" type="submit" value="Искать"/>
					</div>
				</div>
			</form>
		</div>
	</div>
	
</div>	


{if $pickuppoints}
<div id="main_list">
	<!-- Листалка страниц -->
	{include file='pagination.tpl'}	
	<!-- Листалка страниц (The End) -->
	
	<form id="list_form" method="post">
	<input type="hidden" name="session_id" value="{$smarty.session.id}">
	
		<div id="list" class="sortable">
			{foreach $pickuppoints as $pickuppoint}
			<div class="row {if !$pickuppoint->enabled}invisible{/if}">
				<div class="large-1 columns">
					<div class="checkbox">
						<div class="checker"><span><input type="checkbox" name="check[]" value="{$pickuppoint->id}"></span></div>
					</div>
				</div>
				<div class="large-8 columns">
					<div class="row">
						<a href="{url module=PickupPointAdmin id=$pickuppoint->id return=$smarty.server.REQUEST_URI}"><strong>{$pickuppoint->name|escape}</strong></a>
					</div>
					
					<div class="row">
						<a href="{url module=PickupPointAdmin id=$pickuppoint->id return=$smarty.server.REQUEST_URI}">({$pickuppoint->address|escape})</a>
					</div>	
					
					<div class="row">	
						<div class="large-3 columns">
							<span>Ограничения:</span>
						</div>
						<div class="large-3 columns">
							<span>По весу:<br><strong>{$pickuppoint->weight_limit}</strong></span>
						</div>
						<div class="large-3 columns">
							<span>По объему:<br><strong>{$pickuppoint->dimensions_limit}</strong></span>
						</div>						
						<div class="large-3 columns">
							<span>По сумме:<br><strong>{$pickuppoint->summ_limit}</strong></span>
						</div>						
					</div>	
					<div class="row">
						<p>График работы: {$pickuppoint->worktime}</p>
						<p>Телефон: {$pickuppoint->phone}</p>
					</div>
				</div>			
			
		 		<div class="large-2 columns">
					<div class="icons cell">
						<a class="enable" title="Активен" href="#"></a>
						<a class="delete" title="Удалить" href="#"></a>
					</div>
				</div>
		
				<div class="clear"></div>
			</div>
			{/foreach}
		</div>
	
		<div id="action">
		<label id="check_all" class='dash_link'>Выбрать все</label>
	
	
		<span id="select">
		<select name="action">
			<option value="enable">Включить</option>
			<option value="disable">Выключить</option>
			<option value="delete">Удалить</option>
		</select>
		</span>
	
		<input id="apply_action" class="button_green" type="submit" value="Применить">

	</div>
	</form>
	
	<!-- Листалка страниц -->
	{include file='pagination.tpl'}	
	<!-- Листалка страниц (The End) -->
		
</div>
{else}
Пункты самовывоза отсутствуют
{/if}

<!-- Меню -->
<div id="right_menu">
	
</div>
<!-- Меню  (The End) -->

{literal}
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
	
	// Выделить все
	$("#check_all").click(function() {
		$('#list input[type="checkbox"][name*="check"]').attr('checked', $('#list input[type="checkbox"][name*="check"]:not(:checked)').length>0);
        if ($('#list input[type="checkbox"][name*="check"]').eq(0).attr('checked'))
        {
            $('#list .checker span').toggleClass('checked', true);
        }
        else
        {
            $('#list .checker span').toggleClass('checked', false);
        }
	});	


	// Удалить 
	$("a.delete").click(function() {
		$('#list input[type="checkbox"][name*="check"]').attr('checked', false);
		$(this).closest(".row").find('input[type="checkbox"][name*="check"]').attr('checked', true);
		$(this).closest("form").find('select[name="action"] option[value=delete]').attr('selected', true);
		$(this).closest("form").submit();
	});
	
	// Включить/выключить
	$("a.enable").click(function() {
		var line        = $(this).closest(".row");
		var id          = line.find('input[type="checkbox"][name*="check"]').val();
		var state       = line.hasClass('invisible')?1:0;
		$.ajax({
			type: 'POST',
			url: 'ajax/update_object.php',
			data: {'object': 'pickuppoints', 'id': id, 'values': {'enabled': state}, 'session_id': '{/literal}{$smarty.session.id}{literal}'},
			success: function(data){
				if(state) line.removeClass('invisible');
				else line.addClass('invisible');				
			},
			dataType: 'json'
		});	
		return false;	
	});
	
	$("form#list_form").submit(function() {
		if($('#list_form select[name="action"]').val()=='delete' && !confirm('Подтвердите удаление'))
			return false;	
	});	
 	
});

</script>
{/literal}