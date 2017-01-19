{literal}
<style>
	ul.even{
		background: white;
	}
</style>
{/literal}

{literal}
	<script>
		// Инициализация при загрузке страницы
		jQuery(window).load(function(){
	    	$( "ul.my_var:even").addClass('even');
		});
	</script>
{/literal}

{capture name=tabs}
	<li {if $is_drug}{else}class="active"{/if}><a href="{url module=ProductsAdmin category_id=$product->category_id return=null brand_id=null id=null is_drug=null drug=null}">Товары</a></li>
	{if in_array('categories', $manager->permissions)}<li><a href="?module=CategoriesAdmin">Категории</a></li>{/if}
	{if in_array('brands', $manager->permissions)}<li><a href="?module=BrandsAdmin">Бренды</a></li>{/if}
	{if in_array('features', $manager->permissions)}<li><a href="?module=FeaturesAdmin">Свойства</a></li>{/if}
	<li {if $is_drug}class="active"{/if}><a href="?module=DrugProductsAdmin">Приют</a></li>
{/capture}

{if $product->id}
{$meta_title = $product->name scope=parent}
{else}
{$meta_title = 'Новый товар' scope=parent}
{/if}

{* Подключаем Tiny MCE *}
{include file='tinymce_init.tpl'}

{* On document load *}
{literal}
<script src="design/js/autocomplete/jquery.autocomplete-min.js"></script>
<style>
	.autocomplete-w1 {position:absolute; top:0px; left:0px; margin:6px 0 0 6px; /* IE6 fix: */ _background:none; _margin:1px 0 0 0; }
	.autocomplete { border:1px solid #999; background:#FFF; cursor:default; text-align:left; overflow-x:auto; min-width: 300px; overflow-y: auto; margin:-6px 6px 6px -6px; /* IE6 specific: */ _height:350px;  _margin:0; _overflow-x:hidden; }
	.autocomplete .selected { background:#F0F0F0; }
	.autocomplete div { padding:2px 5px; white-space:nowrap; }
	.autocomplete strong { font-weight:normal; color:#3399FF; }
</style>

<script>
$(function(){

	// Добавление категории
	$('#product_categories .add').click(function() {
		$("#product_categories ul li:last").clone(false).appendTo('#product_categories ul').fadeIn('slow').find("select[name*=categories]:last").focus();
		$("#product_categories ul li:last span.add").hide();
		$("#product_categories ul li:last span.delete").show();
		return false;		
	});

	// Удаление категории
	$("#product_categories .delete").live('click', function() {
		$(this).closest("li").fadeOut(200, function() { $(this).remove(); });
		return false;
	});

	// Сортировка вариантов
	$("#variants_block").sortable({ items: '#variants ul' , axis: 'y',  cancel: '#header', handle: '.move_zone' });
	// Сортировка вариантов
	$("table.related_products").sortable({ items: 'tr' , axis: 'y',  cancel: '#header', handle: '.move_zone' });
	
	// Сортировка связанных товаров
	$(".sortable").sortable({
		items: "div.row",
		tolerance:"pointer",
		scrollSensitivity:40,
		opacity:0.7,
		handle: '.move_zone'
	});
		
	// Сортировка изображений
	$(".images ul").sortable({ tolerance: 'pointer'});

	// Удаление изображений
	$(".images a.delete").live('click', function(){
		 $(this).closest("li").fadeOut(200, function() { $(this).remove(); });
		 return false;
	});
	// Загрузить изображение с компьютера
	$('#upload_image').click(function(){
		$("<input class='upload_image' name=images[] type=file multiple>").appendTo('div#add_image').focus().click();
	});
	
	// Или с URL
	$('#add_image_url').click(function(){
		$("<input class='remote_image' name=images_urls[] type=text value='http://'>").appendTo('div#add_image').focus().select();
	});	
 
	// Удаление варианта
	$('a.del_variant').click(function() {
		if($("#variants ul").size()>1)
		{
			$(this).closest("ul").fadeOut(200, function() { $(this).remove(); });
		}
		else
		{
			$('#variants_block .variant_name input[name*=variant][name*=name]').val('');
			$('#variants_block .variant_name').hide('slow');
			$('#variants_block').addClass('single_variant');
		}
		return false;
	});

	// Загрузить файл к варианту
	$('#variants_block a.add_attachment').click(function(){
		$(this).hide();
		$(this).closest('li').find('div.browse_attachment').show('fast');
		$(this).closest('li').find('input[name*=attachment]').attr('disabled', false);
		
		return false;		
	});
	
	// Удалить файл к варианту
	$('#variants_block a.remove_attachment').click(function(){
		closest_li = $(this).closest('li');
		closest_li.find('.attachment_name').hide('fast');
		$(this).hide('fast');
		closest_li.find('input[name*=delete_attachment]').val('1');
		closest_li.find('a.add_attachment').show('fast');
		
		return false;		
	});

	// Добавление варианта
	var variant = $('#new_variant').clone(true);
	$('#new_variant').remove().removeAttr('id');
	$('#variants_block span.add').click(function() {
		if(!$('#variants_block').is('.single_variant'))
		{
			$(variant).clone(true).appendTo('#variants').fadeIn('slow').find("input[name*=variant][name*=name]").focus();
		}
		else
		{
			$('#variants_block .variant_name').show('slow');
			$('#variants_block').removeClass('single_variant');		
		}
		return false;		
	});
	
	
	function show_category_features(category_id){
		
		$('ul.prop_ul li').hide();
		if(categories_features[category_id] !== undefined)
		{
			$('ul.prop_ul li').filter(function(){return jQuery.inArray($(this).attr("feature_id"), categories_features[category_id])>-1;}).show();	
		}
		
	}
	
	// Изменение набора свойств при изменении категории
	$('select[name="categories[]"]:first').change(function(){
		show_category_features($("option:selected",this).val());
	});
	
	show_category_features($('select[name="categories[]"]:first option:selected').val());
	
	// Добавление нового свойства товара
	var feature = $('#new_feature').clone(true);
	$('#new_feature').remove().removeAttr('id');
	$('#add_new_feature').click(function() {
		$(feature).clone(true).appendTo('ul.new_features').fadeIn('slow').find("input[name*=new_feature_name]").focus();

		return false;		
	});
	
	// Подсказки для свойств
	$('input[name*="options"]').each(function(index){
		f_id = $(this).closest('li').attr('feature_id');
		ac = $(this).autocomplete({
			serviceUrl:'ajax/options_autocomplete.php',
			minChars:0,
			params: {feature_id:f_id},
			noCache: false
		});
	});
		
	// Удаление связанного товара
	$(".related_products a.delete").live('click', function() {
		 $(this).closest("div.row").fadeOut(200, function() { $(this).remove(); });
		 return false;
	});
 

	// Добавление связанного товара 
	var new_related_product = $('#new_related_product').clone(true);
	$('#new_related_product').remove().removeAttr('id');
 
	$("input#related_products").autocomplete({
		serviceUrl:'ajax/search_products.php',
		minChars:0,
		noCache: false, 
		onSelect:
			function(value, data){
				new_item = new_related_product.clone().appendTo('.related_products');
				new_item.removeAttr('id');
				new_item.find('a.related_product_name').html(data.name);
				new_item.find('a.related_product_name').attr('href', 'index.php?module=ProductAdmin&id='+data.id);
				new_item.find('input[name*="related_products"]').val(data.id);
				if(data.image)
					new_item.find('img.product_icon').attr("src", data.image);
				else
					new_item.find('img.product_icon').remove();
				$("#related_products").val(''); 
				new_item.show();
			},
		fnFormatResult:
			function(value, data, currentValue){
				var reEscape = new RegExp('(\\' + ['/', '.', '*', '+', '?', '|', '(', ')', '[', ']', '{', '}', '\\'].join('|\\') + ')', 'g');
				var pattern = '(' + currentValue.replace(reEscape, '\\$1') + ')';
  				return (data.image?"<img align=absmiddle src='"+data.image+"'> ":'') + value.replace(new RegExp(pattern, 'gi'), '<strong>$1<\/strong>');
			}

	});
  

	// infinity
	$("input[name*=variant][name*=stock]").focus(function() {
		if($(this).val() == '∞')
			$(this).val('');
		return false;
	});

	$("input[name*=variant][name*=stock]").blur(function() {
		if($(this).val() == '')
			$(this).val('∞');
	});
	
	// Волшебные изображения
	name_changed = false;
	$("input[name=name]").change(function() {
		name_changed = true;
		images_loaded = 0;
	});	
	images_num = 8;
	images_loaded = 0;
	old_wizar_dicon_src = $('#images_wizard img').attr('src');
	$('#images_wizard').click(function() {
		
		$('#images_wizard img').attr('src', 'design/images/loader.gif');
		if(name_changed)
			$('div.images ul li.wizard').remove();
		name_changed = false;
		key = $('input[name=name]').val();
		$.ajax({
 			 url: "ajax/get_images.php",
 			 	data: {keyword: key, start: images_loaded},
 			 	dataType: 'json',
  				success: function(data){
    				for(i=0; i<Math.min(data.length, images_num); i++)
    				{
	    				image_url = data[i];
						$("<li class=wizard><a href='' class='delete'><img src='design/images/cross-circle-frame.png'></a><a href='"+image_url+"' target=_blank><img onerror='$(this).closest(\"li\").remove();' width=100 src='"+image_url+"' /><input name=images_urls[] type=hidden value='"+image_url+"'></a></li>").appendTo('div .images ul');
    				}
					$('#images_wizard img').attr('src', old_wizar_dicon_src);
					images_loaded += images_num;
  				}
		});
		return false;
	});
	
	// Волшебное описание
	name_changed = false;
	$("input[name=name]").change(function(){
		name_changed = true;
	});	
	old_prop_wizard_icon_src = $('#properties_wizard img').attr('src');
	$('#properties_wizard').click(function() {
		
		$('#properties_wizard img').attr('src', 'design/images/loader.gif');
		if(name_changed)
			$('div.images ul li.wizard').remove();
		name_changed = false;
		key = $('input[name=name]').val();
		$.ajax({
 			 url: "ajax/get_info.php",
 			 	data: {keyword: key},
 			 	dataType: 'json',
  				success: function(data){
  					if(data)
  					{
  						$('li#new_feature').remove();
	    				for(i=0; i<data.options.length; i++)
	    				{
	    					option_name = data.options[i].name;
	    					option_value = data.options[i].value;
							// Добавление нового свойства товара
							exists = false;
							if(!$('label.property:visible:contains('+option_name+')').closest('li').find('input[name*=options]').val(option_value).length)
							{
								f = $(feature).clone(true);
								f.find('input[name*=new_features_names]').val(option_name);
								f.find('input[name*=new_features_values]').val(option_value);
								f.find('input[name*=new_features_types]').val(option_type);
								f.appendTo('ul.new_features').fadeIn('slow');
							}
	   					}
	   					
   					}
					$('#properties_wizard img').attr('src', old_prop_wizard_icon_src);
					
				},
				error: function(xhr, textStatus, errorThrown){
                	alert("Error: " +textStatus);
           		}
		});
		return false;
	});
	

	// Автозаполнение мета-тегов
	meta_title_touched = true;
	meta_keywords_touched = true;
	meta_description_touched = true;
	url_touched = true;
	
	if($('input[name="meta_title"]').val() == generate_meta_title() || $('input[name="meta_title"]').val() == '')
		meta_title_touched = false;
	if($('input[name="meta_keywords"]').val() == generate_meta_keywords() || $('input[name="meta_keywords"]').val() == '')
		meta_keywords_touched = false;
	if($('textarea[name="meta_description"]').val() == generate_meta_description() || $('textarea[name="meta_description"]').val() == '')
		meta_description_touched = false;
	if($('input[name="url"]').val() == generate_url() || $('input[name="url"]').val() == '')
		url_touched = false;
		
	$('input[name="meta_title"]').change(function() { meta_title_touched = true; });
	$('input[name="meta_keywords"]').change(function() { meta_keywords_touched = true; });
	$('textarea[name="meta_description"]').change(function() { meta_description_touched = true; });
	$('input[name="url"]').change(function() { url_touched = true; });
	
	$('input[name="name"]').keyup(function() { set_meta(); });
	$('select[name="brand_id"]').change(function() { set_meta(); });
	$('select[name="categories[]"]').change(function() { set_meta(); });
	
});

function set_meta()
{
	if(!meta_title_touched)
		$('input[name="meta_title"]').val(generate_meta_title());
	if(!meta_keywords_touched)
		$('input[name="meta_keywords"]').val(generate_meta_keywords());
	if(!meta_description_touched)
		$('textarea[name="meta_description"]').val(generate_meta_description());
	if(!url_touched)
		$('input[name="url"]').val(generate_url());
}

function generate_meta_title()
{
	name = $('input[name="name"]').val();
	return name;
}

function generate_meta_keywords()
{
	name = $('input[name="name"]').val();
	result = name;
	brand = $('select[name="brand_id"] option:selected').attr('brand_name');
	if(typeof(brand) == 'string' && brand!='')
			result += ', '+brand;
	$('select[name="categories[]"]').each(function(index) {
		c = $(this).find('option:selected').attr('category_name');
		if(typeof(c) == 'string' && c != '')
    		result += ', '+c;
	}); 
	return result;
}

function generate_meta_description()
{
	if(typeof(tinyMCE.get("annotation")) =='object')
	{
		description = tinyMCE.get("annotation").getContent().replace(/(<([^>]+)>)/ig," ").replace(/(\&nbsp;)/ig," ").replace(/^\s+|\s+$/g, '').substr(0, 512);
		return description;
	}
	else
		return $('textarea[name=annotation]').val().replace(/(<([^>]+)>)/ig," ").replace(/(\&nbsp;)/ig," ").replace(/^\s+|\s+$/g, '').substr(0, 512);
}

function generate_url()
{
	url = $('input[name="name"]').val();
	url = url.replace(/[\s]+/gi, '-');
	url = translit(url);
	url = url.replace(/[^0-9a-z_\-]+/gi, '').toLowerCase();	
	return url;
}

function translit(str)
{
	var ru=("А-а-Б-б-В-в-Ґ-ґ-Г-г-Д-д-Е-е-Ё-ё-Є-є-Ж-ж-З-з-И-и-І-і-Ї-ї-Й-й-К-к-Л-л-М-м-Н-н-О-о-П-п-Р-р-С-с-Т-т-У-у-Ф-ф-Х-х-Ц-ц-Ч-ч-Ш-ш-Щ-щ-Ъ-ъ-Ы-ы-Ь-ь-Э-э-Ю-ю-Я-я").split("-")   
	var en=("A-a-B-b-V-v-G-g-G-g-D-d-E-e-E-e-E-e-ZH-zh-Z-z-I-i-I-i-I-i-J-j-K-k-L-l-M-m-N-n-O-o-P-p-R-r-S-s-T-t-U-u-F-f-H-h-TS-ts-CH-ch-SH-sh-SCH-sch-'-'-Y-y-'-'-E-e-YU-yu-YA-ya").split("-")   
 	var res = '';
	for(var i=0, l=str.length; i<l; i++)
	{ 
		var s = str.charAt(i), n = ru.indexOf(s); 
		if(n >= 0) { res += en[n]; } 
		else { res += s; } 
    } 
    return res;  
}

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



{if $message_success}
<!-- Системное сообщение -->
<div class="message message_success">
	<span>{if $message_success=='added'}Товар добавлен{elseif $message_success=='updated'}Товар изменен{else}{$message_success|escape}{/if}</span>
	<a class="link" target="_blank" href="../products/{$product->url}">Открыть товар на сайте</a>
	{if $smarty.get.return}
	<a class="button" href="{$smarty.get.return}">Вернуться</a>
	{/if}
</div>
<!-- Системное сообщение (The End)-->
{/if}

{if $message_error}
<!-- Системное сообщение -->
<div class="message message_error">
	<span>{if $message_error=='url_exists'}Товар с таким адресом уже существует{elseif $message_error=='empty_name'}Введите название{else}{$message_error|escape}{/if}</span>
	{if $smarty.get.return}
	<a class="button" href="{$smarty.get.return}">Вернуться</a>
	{/if}
</div>
<!-- Системное сообщение (The End)-->
{/if}


<!-- Основная форма -->
<form method=post id=product enctype="multipart/form-data">
<input type=hidden name="session_id" value="{$smarty.session.id}">

 	<div id="name">
		<input class="name" name=name type="text" value="{if $no_node}{$no_node}{else}{$product->name|escape}{/if}"/>
        <input class="new_name" name=new_name type="text" value="{if $no_title}{$no_title}{else}{$product->new_name|escape}{/if}"/>
        <input name=id type="hidden" value="{$product->id|escape}"/>
	</div>
	
	<div style="margin-bottom: 25px;">
	
		<div style="width: 250px; min-width: 250px; max-width: 250px; float: left;">
			<input style="width: 120px; min-width: 120px; max-width: 120px; margin-bottom: 3px;" id="created" class="date_created" name=created type="text" value="{$product->created}" placeholder="yyyy-mm-dd hh-mm-ss" />
			<label for="created" style="padding-left: 5px;">Дата добавления</label>
		</div>		
			
		<div style="width: 550px; min-width: 550px; max-width: 550px; float: right;">
		
			<div class="checkbox">
				<input name=visible value='1' type="checkbox" id="active_checkbox" {if $product->visible}checked{/if}/> <label for="active_checkbox">Активен</label>
			</div>
			
			<div class="checkbox">
				<input name=featured value="1" type="checkbox" id="featured_checkbox" {if $product->featured}checked{/if}/> <label for="featured_checkbox">Рекомендуемый</label>
			</div>
			
			<div class="checkbox">
				<input name=in_new_list  value='1' type="checkbox" id="in_new_list_checkbox" {if $is_drug == 1}{else}{if $product->in_new_list == 1}checked{/if}{/if}/> <label for="active_checkbox">Участвует в списке новых товаров</label>
			</div>
			
			<div class="checkbox">
				<input name="drug" value='1' type="checkbox" id="drug" {if $product->drug == 1}checked{elseif $is_drug == 1}checked{/if}/> <label for="drug">В приют "Друг"</label>
			</div>
			
		</div>
		
		<div style="clear: both;"></div>
		
	</div>
	
	<div id="product_brand" {if !$brands}style='display:none;'{/if}>
		<label>Бренд</label>
		<select name="brand_id" required="">
			 <option value='' {if !$product->brand_id}selected{/if} brand_name=''>Не указан</option>
       		{foreach from=$brands item=brand}
            	<option value='{$brand->id}' {if $product->brand_id == $brand->id}selected{/if} brand_name='{$brand->name|escape}'>{$brand->name|escape}</option>
        	{/foreach}
		</select>
	</div>

	<div id="product_categories" {if !$categories}style='display:none;'{/if}>
		<label>Категория</label>
		<div>
			<ul>
				{foreach name=categories from=$product_categories item=product_category}
				<li>
					<select name="categories[]" required="">
						<option value="">Выберите вариант категории</option>
						{function name=category_select level=0}
						{foreach from=$categories item=category}
								<option value='{$category->id}' {if $category->id == $selected_id}selected{/if} category_name='{$category->name|escape}'>{section name=sp loop=$level}&nbsp;&nbsp;&nbsp;&nbsp;{/section}{$category->name|escape}</option>
								{category_select categories=$category->subcategories selected_id=$selected_id  level=$level+1}
						{/foreach}
						{/function}
						{category_select categories=$categories selected_id=$product_category->id}
					</select>
					<span {if not $smarty.foreach.categories.first}style='display:none;'{/if} class="add"><i class="dash_link">Дополнительная категория</i></span>
					<span {if $smarty.foreach.categories.first}style='display:none;'{/if} class="delete"><i class="dash_link">Удалить</i></span>
				</li>
				{/foreach}		
			</ul>
		</div>
	</div>

    {* Блок вариантов товара *}
    {*<div class="row collapse">
        <div class="large-12 columns">
            <div class="row semi-collapse">
                <div class="large-2 columns">
                    &nbsp;
                </div>
                <div class="large-2 columns">
                    Название варианта
                </div>
                <div class="large-2 columns">
                    Артикул
                </div>
                <div class="large-2 columns">
                    Цена, {$currency->sign}
                </div>
                <div class="large-2 columns">
                    Старая, {$currency->sign}
                </div>
                <div class="large-2 columns">
                    Количество
                </div>
            </div>
            <div class="row semi-collapse">
                <div class="large-2 columns">
                    <div class="move_zone"></div>
                </div>
                <div class="large-2 columns">
                    <input name="variants[id][]" type="hidden" value="{$variant->id|escape}" />
                    <input name="variants[name][]" type="text" value="{$variant->name|escape}" />
                    <a class="del_variant" href="">
                        <img src="design/images/cross-circle-frame.png" alt="" />
                    </a>
                </div>
                <div class="large-2 columns">
                    <input name="variants[sku][]" type="text" value="{if $no_sku}{$no_sku}{else}{$variant->sku|escape}{/if}" /></li>
                </div>
                <div class="large-2 columns">
                    <input name="variants[price][]" type="text" value="{if $no_price}{$no_price}{else}{$variant->price|escape}{/if}" /></li>
                </div>
                <div class="large-2 columns">
                    <input name="variants[compare_price][]" type="text" value="{$variant->compare_price|escape}" /></li>
                </div>
                <div class="large-2 columns">
                    <input name="variants[stock][]" type="text" value="{if $no_stock}{$no_stock}{else}{if $variant->infinity || $variant->stock == ''}∞{else}{$variant->stock|escape}{/if}{/if}" />{$settings->units}
                </div>
            </div>
        </div>
    </div>*}

 	<!-- Варианты товара -->
	<div id="variants_block" {assign var=first_variant value=$product_variants|@first}{if $product_variants|@count <= 1 && !$first_variant->name}class=single_variant{/if}>
		<ul id="header">
			<li class="variant_move"></li>
			<li class="variant_name">Название варианта</li>	
			<li class="variant_sku">Артикул</li>	
			<li class="variant_price">Цена, {$currency->sign}</li>	
			<li class="variant_discount">Старая, {$currency->sign}</li>	
			<li class="variant_amount">Кол-во</li>
            <li class="variant_yml">Yandex Market</li> 
            <li class="variant_avito">Avito</li>
            <li class="variant_avito">Sale</li>
		</ul>
		<div id="variants">
		{foreach from=$product_variants item=variant}
		<ul class="my_var">
			<li class="variant_move"><div class="move_zone"></div></li>
			<li class="variant_name">      <input name="variants[id][]"            type="hidden" value="{$variant->id|escape}" /><input name="variants[name][]" type="" value="{$variant->name|escape}" /> <a class="del_variant" href=""><img src="design/images/cross-circle-frame.png" alt="" /></a></li>
			<li class="variant_sku">       <input name="variants[sku][]"           type="text"   value="{if $no_sku}{$no_sku}{else}{$variant->sku|escape}{/if}" /></li>
			<li class="variant_price">     <input name="variants[price][]"         type="text"   value="{if $no_price}{$no_price}{else}{$variant->price|escape}{/if}" /></li>
			<li class="variant_discount">  <input name="variants[compare_price][]" type="text"   value="{$variant->compare_price|escape}" /></li>
			<li class="variant_amount">    <input name="variants[stock][]"         type="text"   value="{if $no_stock}{$no_stock}{else}{if $variant->infinity || $variant->stock == ''}0{else}{$variant->stock|escape}{/if}{/if}" />{$settings->units}</li>
			<li class="variant_yml">
                <select name="variants[yml][]">
                    <option value="0" {if $variant->yml == 0}selected{/if}>Не участвует</option>
                    <option value="1" {if $variant->yml == 1 or $variant->yml == null}selected{/if}>Участвует</option>
                </select>
            </li>
            
            <li class="variant_avito">
                <select name="variants[avito][]">
                    <option value="0" {if $variant->avito == 0}selected{/if}>Не участвует</option>
                    <option value="1" {if $variant->avito == 1}selected{/if}>Участвует</option>
                </select>
            </li>
            
            <li class="variant_avito">
                <select name="variants[sale][]">
                    <option value="0" {if $variant->sale == 0}selected{/if}>Не участвует</option>
                    <option value="1" {if $variant->sale == 1}selected{/if}>Участвует</option>
                </select>
            </li>

            <li class="variant_weight">
            	<lable for="variants[weight][]">Вес:</lable>
            	<input name="variants[weight][]" type="text" value="{if $no_weight}{$no_weight}{else}{$variant->weight|escape}{/if}" />
            </li>
            <li class="variant_width">
            	<lable for="variants[width][]">Ширина:</lable>
            	<input name="variants[width][]" type="text" value="{$variant->width|escape}" />
            </li>
            <li class="variant_length">
            	<lable for="variants[length][]">Длина:</lable>
            	<input name="variants[length][]" type="text" value="{$variant->length|escape}" />
            </li>
            <li class="variant_height">
            	<lable for="variants[height][]">Высота:</lable>
            	<input name="variants[height][]" type="text" value="{$variant->height|escape}" />
            </li>
            <li  class="variant_height">
				<lable for="variants[stockday][]">Stockday</lable>
				<input name="variants[stockday][]" type="text" value="{if $no_stockday}{$no_stockday}{else}{if $variant->stockday}{$variant->stockday}{else}0{/if}{/if}" />
            </li>
             <li  class="variant_height">
				<lable for="variants[stockday][]"><b>ID в 1C:</b></lable>
				<input name="variants[id_1c][]" type="text" value="{$variant->id_1c|escape}" />
            </li>
            <li  class="variant_height">
				<lable for="variants[multiplicity][]"><b>Кратность</b></lable>
				<input id="variants[multiplicity][]" name="variants[multiplicity][]" type="text" value="{$variant->multiplicity}" />
            </li>
			
			<!-- Запрет самовывоза варианта товара -->
			<li class="variant_height">
				<lable for="variants[pickup_ban][]"><b>Запрет с/в</b></lable>	
				 <select name="variants[pickup_ban][]">
                    <option value="0" {if $variant->pickup_ban == 0}selected{/if}>Нет</option>
                    <option value="1" {if $variant->pickup_ban == 1}selected{/if}>Да</option>
                </select>
			</li>
			<!-- //Запрет самовывоза варианта товара -->
						
             <li class="variant_yml" style="width: 120px; min-width: 120px; max-width: 120px;">
             	<lable style="width: 120px; min-width: 120px; max-width: 120px;" for="compare_price_status"><b>$old_price</b></lable><br>
             	<select name="variants[compare_price_status][]" id="compare_price_status">
             		<option value="1" {if ($variant->compare_price_status == '1')}selected{/if}>да</option>
             		<option value="0" {if ($variant->compare_price_status == '0')}selected{/if}>нет</option>
             		
             	</select>             
            </li>

		</ul>
		{/foreach}		
		</div>

		<ul id=new_variant style='display:none;'>
			<li class="variant_move"><div class="move_zone"></div></li>
			<li class="variant_name"><input name="variants[id][]" type="hidden" value="" /><input name="variants[name][]" type="" value="" /><a class="del_variant" href=""><img src="design/images/cross-circle-frame.png" alt="" /></a></li>
			<li class="variant_sku"><input name="variants[sku][]" type="" value="" /></li>
			<li class="variant_price"><input  name="variants[price][]" type="" value="" /></li>
			<li class="variant_discount"><input name="variants[compare_price][]" type="" value="" /></li>
			<li class="variant_amount"><input name="variants[stock][]" type="" value="∞" />{$settings->units}</li>
            <li class="variant_yml"><div class="checker"><span><input type="checkbox" name="variants[yml][]" value="1"></span></div></li>
		</ul>

		<input class="button_green button_save" type="submit" name="" value="Сохранить" />
		<span class="add" id="add_variant"><i class="dash_link">Добавить вариант</i></span>
 	</div>
	<!-- Варианты товара (The End)--> 
	
 	<!-- Левая колонка свойств товара -->
	<div id="column_left">
			
		<!-- Параметры страницы -->
		<div class="block layer">
			<h2>Параметры страницы</h2>
			<ul>
				<li><a class="link" target="_blank" href="../products/{$product->url}">Открыть товар на сайте</a></li>
				<li><label class=property>Адрес</label><div class="page_url"> /products/</div><input name="url" class="page_url" type="text" value="{$product->url|escape}" /></li>
				<li><label class=property>Заголовок</label><input name="meta_title" class="simpla_inp" type="text" value="{$product->meta_title|escape}" /></li>
				<li><label class=property>Ключевые слова</label><input name="meta_keywords" class="simpla_inp" type="text" value="{$product->meta_keywords|escape}" /></li>
				<li><label class=property>Описание</label><textarea name="meta_description" class="simpla_inp" />{$product->meta_description|escape}</textarea></li>
			</ul>
		</div>
		<!-- Параметры страницы (The End)-->
		
		<!-- Свойства товара -->
		<script>
		var categories_features = new Array();
		{foreach from=$categories_features key=c item=fs}
		categories_features[{$c}]  = Array({foreach from=$fs item=f}'{$f}', {/foreach}0);
		{/foreach}
		</script>
		
		<!-- Добавление новых свойств (Lambrusco) -->
		<div class="block layer" {if !$categories}style='display:none;'{/if}>
			<h2>Cвойства товара
			<a href="#" id=properties_wizard><img src="design/images/wand.png" alt="Подобрать автоматически" title="Подобрать автоматически"/></a>
			</h2>
			
			<ul class="prop_ul">
				{foreach $features as $feature}
					{assign var=feature_id value=$feature->id}
					<li feature_id={$feature_id} style='display:none;'><label class=property>{$feature->name}</label><input class="options[{$feature_id}]" type="text" name="options[{$feature_id}]" value="{$options[$feature_id].value}" /></li>
				{/foreach}
			</ul>
			<!-- Новые свойства -->
			<ul class=new_features>
				<li id=new_feature>
					<label class=property>
						<input type=text name=new_features_names_t[]>
					</label>
					<input class="simpla_inp" type="text" name=new_features_values_t[] />
					<select name=new_features_types_t[] style="margin-top: 10px;">
						<option value="0">Список с чекбоксами</option>
						<option value="1">Расширенный список с чекбоксами</option>
						<option value="2">Выпадающий список</option>
						<option value="3">Слайдер</option>
						<option value="4">Выбор цвета</option>						
					</select>
				</li>
			</ul>
			<span class="add"><i class="dash_link" id="add_new_feature">Добавить новое свойство</i></span>
			<input class="button_green button_save" type="submit" name="" value="Сохранить" />			
		</div>		
		<!-- Добавление новых свойств (The End) -->

	</div>
	<!-- Левая колонка свойств товара (The End)--> 
	
	<!-- Правая колонка свойств товара -->	
	<div id="column_right">
		
		<!-- Изображения товара -->	
		<div class="block layer images">
			<h2>Изображения товара
			<a href="#" id=images_wizard><img src="design/images/wand.png" alt="Подобрать автоматически" title="Подобрать автоматически"/></a>
			
			</h2>
			<ul>{foreach from=$product_images item=image}<li>
					<a href='#' class="delete"><img src='design/images/cross-circle-frame.png'></a>
					<img src="{$image->filename|resize:100:100}" alt="" />
					<input type=hidden name='images[]' value='{$image->id}'>
				</li>{/foreach}</ul>
			<span class=upload_image><i class="dash_link" id="upload_image">Добавить изображение</i></span> или <span class=add_image_url><i class="dash_link" id="add_image_url">загрузить из интернета</i></span>
			<div id=add_image></div>
			
		</div>
		

		<div class="block layer">
			<h2>Связанные товары</h2>
			<div id=list class="sortable related_products">
				{foreach from=$related_products item=related_product}
				<div class="row">
					<div class="move cell">
						<div class="move_zone"></div>
					</div>
					<div class="image cell">
					<input type=hidden name=related_products[] value='{$related_product->id}'>
					<a href="{url id=$related_product->id}">
					<img class=product_icon src='{$related_product->images[0]->filename|resize:35:35}'>
					</a>
					</div>
					<div class="name cell">
					<a href="{url id=$related_product->id}">{$related_product->name}</a>
					</div>
					<div class="icons cell">
					<a href='#' class="delete"></a>
					</div>
					<div class="clear"></div>
				</div>
				{/foreach}
				<div id="new_related_product" class="row" style='display:none;'>
					<div class="move cell">
						<div class="move_zone"></div>
					</div>
					<div class="image cell">
					<input type=hidden name=related_products[] value=''>
					<img class=product_icon src=''>
					</div>
					<div class="name cell">
					<a class="related_product_name" href=""></a>
					</div>
					<div class="icons cell">
					<a href='#' class="delete"></a>
					</div>
					<div class="clear"></div>
				</div>
			</div>
			<input type=text name=related id='related_products' class="input_autocomplete" placeholder='Выберите товар чтобы добавить его'>
		</div>

		<input class="button_green button_save" type="submit" name="" value="Сохранить" />
		
	</div>
	<!-- Правая колонка свойств товара (The End)--> 

	<!-- Описагние товара -->
	<div class="block layer">
		<h2>Краткое описание</h2>
		<textarea name="annotation" class="editor_small">{$product->annotation|escape}</textarea>
	</div>
		
	<div class="block">		
		<h2>Полное  описание</h2>
		<textarea name="body" class="editor_large">{$product->body|escape}</textarea>
	</div>

    <div class="block layer">
        <h2>Ингредиенты</h2>
        <textarea name="ingredients" class="editor_small">{$product_ext->ingredients|escape}</textarea>
    </div>

    <div class="block layer">
        <h2>Гарантированный состав</h2>
        <textarea name="nutrition" class="editor_small">{$product_ext->nutrition|escape}</textarea>
    </div>

    <div class="block layer">
        <h2>Нормы кормления</h2>
        <textarea name="feeding" class="editor_small">{$product_ext->feeding|escape}</textarea>
    </div>
	<!-- Описание товара (The End)-->
	<input class="button_green button_save" type="submit" name="" value="Сохранить" />
	
</form>
<!-- Основная форма (The End) -->