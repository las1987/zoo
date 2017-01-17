<!DOCTYPE html>
<!--[if lt IE 7]>      <html lang="ru" class="no-js lt-ie9 lt-ie8 lt-ie7"> <![endif]-->
<!--[if IE 7]>         <html lang="ru" class="no-js lt-ie9 lt-ie8"> <![endif]-->
<!--[if IE 8]>         <html lang="ru" class="no-js lt-ie9"> <![endif]-->
<!--[if IE 9 ]>        <html lang="ru" class="no-js ie9"> <![endif]-->
<!--[if gt IE 8]><!--> <html lang="ru" class="no-js"> <!--<![endif]-->
{*
    Общий вид страницы
    Этот шаблон отвечает за общий вид страниц без центрального блока.
*}

<head>
	<title>{$meta_title|escape}</title>
    <meta http-equiv="X-UA-Compatible" content="IE=edge">    
    
    	<!--[if lt IE 9]>
		<script type="text/javascript" src="http://html5shiv.googlecode.com/svn/trunk/html5.js"></script>
		<![endif]-->
				
	    {literal}
    	<style>
	    	#navbar .main_div .medium-5{
			    min-width: 250px;
			    width: 250px;
			    max-width: 250px;
			    display: block;
			    background: rgb(177, 198, 69) url("/temp001/user43.png") no-repeat scroll 10% 50%;
			    padding-left: 55px; /* чтобы текст в анкорах не заезжал на иконку */
			    height: 40px;
			    min-height: 40px;
			    max-height: 40px;
			}
			
			#navbar-login a{
			    color: rgb(255, 255, 255);
			    text-decoration: underline;
			    font-size: 1.2em;
			}
    		
    		.online_s,
    		.online_s label{
    			color: white;
    		}
    		

    		html, body, #header. .main_div, .columns, .row, p, div, span{
    			font-family: 'Roboto Condensed', 'Roboto', Arial, sans-serif !important;
    		}
    		  		   	
    		#free_cal_info_ablock{
    			position: absolute;
    			width: 370px;
    			max-width: 370px;
    			bottom: 0px;
    			right: 116px;
    			font-family: 'Roboto Condensed', 'Roboto', Arial, sans-serif !important;
    		}    	
    		
    		#header #free_cal_info_ablock p{
    			color: white;
    			font-family: 'Roboto Condensed', 'Roboto', Arial, sans-serif !important;
    		}
    		
	    	a#reformal_tab{
	    		display: none;
	    		z-index: -1000009;
	    	}
	    	
	    	.ie8_helper_header_first{
	    		position: relative;
	    	}
	    	
	    	#logo_img{
	    		width: 232px;
	    		max-width: 232px;
	    		min-width: 232px;
	    		
	    		height: 131px;
	    		min-height: 131px;
	    		max-height: 131px;
	    		
	    		position: absolute;
	    		
	    		left: 7px;
	    		top: 60px;
	    		
	    		
	    	}
	    	
	    	.cart_in_top{
				height: 40px;
				min-height: 40px;
				max-height: 40px;
			}
				
			#order-repeat-button{
				float: left;
				height: 40px;
				min-height: 40px;
				max-height: 40px;
				
				width: 48px;
				min-width: 48px;
				max-width: 48px;
				
				margin-top: -40px;
				margin-left: 286px;
				
				padding: 0 !important;
				
				font-size: 28px !important;
				font-weight: bold;
			}
					
			a.repeat{
				color: #f48301;
				font-weight: bold;
			}
			
			a.repeat:HOVER{
				color: #CA6304;
			}
			
			.social a {
				float: left;
				display: block;
			}
			
			.smforms {
				margin-left: 15px;
			}
    	</style>
    	{/literal}

    <base href="{$config->root_url}/"/>


    {* Метатеги *}
	<meta http-equiv="Cache-Control" content="max-age=4320, must-revalidate" />
    <meta name="format-detection" content="telephone=no">
    <meta name="document-state" content="Dynamic" />
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
    <meta name="description" content="{$meta_description|escape}"/>
    <meta name="keywords" content="{$meta_keywords|escape}"/>
    <meta name="viewport" content="initial-scale=1">

	{* Яндекс Вебмастер *}
	<meta name="yandex-verification" content="b66b100a455cce1e" />

    <link rel="shortcut icon" href="design/{$settings->theme|escape}/images/favicon.ico?v=2" type="image/x-icon" />

    {* Стили *}
    <link href="design/{$settings->theme|escape}/css/normalize.css" rel="stylesheet" type="text/css" media="screen"/>
    <link href="design/{$settings->theme|escape}/css/foundation.css" rel="stylesheet" type="text/css" media="screen"/>

    <link href="design/{$settings->theme|escape}/css/tipTip.css" rel="stylesheet" type="text/css" media="screen"/>

	<!--[if lte IE 8]>
    	<link href="design/{$settings->theme|escape}/css/styleie8.css" rel="stylesheet" type="text/css" media="screen"/>
	<![endif]-->

    {* Фавикон *}
    <link href="design/{$settings->theme|escape}/images/favicon.ico" rel="icon" type="image/x-icon"/>
    <link href="design/{$settings->theme|escape}/images/favicon.ico" rel="shortcut icon" type="image/x-icon"/>

    {* Шрифты *}
    <link href='http://fonts.googleapis.com/css?family=Roboto+Condensed:400,300,700&amp;subset=latin,cyrillic' rel='stylesheet' type='text/css'>
    <link href='http://fonts.googleapis.com/css?family=Roboto:300,400,700,500&amp;subset=latin,cyrillic' rel='stylesheet' type='text/css'>
    <link rel="stylesheet" href="design/{$settings->theme}/css/vendor/jquery-ui-1.10.4.custom.min.css">

    <!--[if  IE 9]>
    	<script src="http://html5shim.googlecode.com/svn/trunk/html5.js"></script>
    <![endif]-->

    {* Modernizr *}
	{* файл удалён
    <script src="design/{$settings->theme}/js/vendor/modernizr.js"></script>
    *}

    {* respond.js*}
    <!--[if lte IE 8]><script src="design/{$settings->theme}/js/respond.js"></script><![endif]-->

    {* JQuery *}
    <script src="/js/jquery/jquery.js" type="text/javascript"></script>

    <script src="design/{$settings->theme}/js/history.js"></script>

    {* Общие Javascript процедуры *}
    <script src="design/{$settings->theme}/js/jquery.mask.min.js"></script>

    {* Слайдер цен *}
    <script src="design/{$settings->theme}/js/vendor/jquery-ui-1.10.4.custom.min.js"></script>

    {* Всплывающие подсказки для администратора *}
    {if $smarty.session.admin == 'admin'}
    <script src ="js/admintooltip/admintooltip.js" type="text/javascript"></script>
    <link href="js/admintooltip/css/admintooltip.css" rel="stylesheet" type="text/css"/>
    {/if}

    {* Увеличитель картинок *}
    <script src="js/fancybox/jquery.fancybox-1.3.4.pack.js"></script>
    <link rel="stylesheet" href="js/fancybox/jquery.fancybox-1.3.4.css" type="text/css" media="screen"/>

    {* Ctrl-навигация на соседние товары *}
    <script type="text/javascript" src="js/ctrlnavigate.js"></script>

    {* Аяксовая корзина *}
    <script src="design/{$settings->theme}/js/jquery-ui.min.js"></script>
    <script src="design/{$settings->theme}/js/ajax_cart.js?v=3"></script>

    {* Всплывающие подсказки *}
    <script src="design/{$settings->theme}/js/jquery.tipTip.js"></script>

    {* Стили *}
	{assign var="filepath" value="/design/{$settings->theme}/css/style.css"}
	<link href="{$filepath|stamped_path}" rel="stylesheet" type="text/css" media="screen"/>
	{assign var="filepath" value="/design/{$settings->theme}/css/products.css"}
	<link href="{$filepath|stamped_path}" rel="stylesheet" type="text/css" media="screen"/>

    {* Автозаполнитель поиска *}
    {literal}
    <script src="js/autocomplete/jquery.autocomplete-min.js"></script>
    <style>
        .autocomplete-w1 {
            position: absolute;
            top: -43px;
            left:4px;
            _background: none;
            _margin: 1px 0 0 0;
        }

        .autocomplete {
            width: 700px !important;
            max-width: 700px !important;
            border: 1px solid #999;
            background: #FFF;
            cursor: default;
            text-align: left;
            overflow-x: auto;
            overflow-y: auto;
            margin: -6px 6px 6px -6px; /* IE6 specific: */
            _height: 350px;
            _margin: 0;
            _overflow-x: hidden;
        }

        .autocomplete .selected{
            background: #F48301;
            color: white;
            cursor: pointer;
        }

        .autocomplete .selected strong { color: #ffffff }

        .autocomplete div {
            font: 13px/15px 'Roboto', Arial, sans-serif;
            padding: 2px 5px;
            white-space: nowrap;
        }

        .autocomplete strong {
            font-weight: normal;
            color: #CE6505;
        }

		#logo-text {
			margin-top: 20px;
			display: block;
			padding: 20px;
			font-size: 18px;
			color: #FFF;
			text-shadow: 0 1px 6px #804034;
		}
		#logo {
			margin-top: 20px;
		}
    </style>

    <script>
        $(function (){
            //  Автозаполнитель поиска
            $(".input_search").autocomplete({
                serviceUrl: 'ajax/search_products.php',
                minChars: 1,
                noCache: false,
                onSelect: function (value, data) {
                    $(".input_search").closest('form').submit();
                },
                fnFormatResult: function (value, data, currentValue) {
                    var reEscape = new RegExp('(\\' + ['/', '.', '*', '+', '?', '|', '(', ')', '[', ']', '{', '}', '\\'].join('|\\') + ')', 'g');
                    var pattern = '(' + currentValue.replace(reEscape, '\\$1') + ')';
                    return (data.image ? "<img align=absmiddle src='" + data.image + "'> " : '') + value.replace(new RegExp(pattern, 'gi'), '<strong>$1<\/strong>');
                }
            });
			$(".tip").tipTip({maxWidth: "auto", defaultPosition: "top"});
        });
    </script>
    {/literal}

    {literal}
	<script type="text/javascript" charset="utf-8" id="js-email-automation">
		$(document).ready(function(){

			var deviceAgent = navigator.userAgent.toLowerCase();
		    var agentID = deviceAgent.match(/(iphone|ipod|ipad)/);
		    if (!agentID) {
		    	$("#background_img").css({ display:"block"});
		    }
		    if (agentID) {
		    	$("body").css({ background:"#c0866a"});
		    	$("#background_img").css({ display:"none"});
		    }

			$("#oos-payment_block").click(function(){
				$("#oos-payment").css({ display:"none" });
				$("#oos-payment_block").css({ display:"none" });
			});

			$("#but_oss_payment_close").click(function(){
				$("#oos-payment").css({ display:"none" });
				$("#oos-payment_block").css({ display:"none" });
			});

			$("#but_oss_payment").click(function(){
				var orderId = $("#orderId").val();

				$("#oos-payment").css({ display: "block", opacity: "1", visibility: "visible" });

				var doc_w = $(document).width();
				var doc_h = $(document).height();

				var deviceAgent = navigator.userAgent.toLowerCase();
			    var agentID = deviceAgent.match(/(iphone|ipod|ipad)/);
			    if (!agentID) {
			    	$("#oos-payment_block").css({ display: "block" , width: doc_w, height: doc_h });
			    }

				$("#iframe").load("/files/oos-payment-page.php", {'orderId': orderId });

			});

			$("#orderId").keyup(function() {
				var str = $(this).val();
				str = str.replace("№","");
				str = str.replace("#","");
				str = str.replace("a","");
				str = str.replace("b","");
				str = str.replace("c","");
				str = str.replace(" ","");
				str = str.replace("з","");
				str = str.replace("а","");
				str = str.replace("к","");
				str = str.replace("а","");
				str = str.replace("З","");


				$(this).val(str);
			});

			$("#orderId").change(function() {
				var str = $(this).val();
				str = str.replace("№","");
				str = str.replace("#","");
				str = str.replace("a","");
				str = str.replace("b","");
				str = str.replace("c","");
				str = str.replace(" ","");
				str = str.replace("з","");
				str = str.replace("а","");
				str = str.replace("к","");
				str = str.replace("а","");
				str = str.replace("З","");


				$(this).val(str);
			});


			$(window).scroll(function(){
				$(".autocomplete").css("display", "none");
				$(".input_search").val("");
	      	});

			var user_id = $("#user_id").val();
			var secured_user_id = $("#secured_user_id").val();
			var user_email = $("#user_email").val();

			window.email_automation_settings = {
				'automation_user_id': "nC1-1C/482fc090",
				'automation_url': "http://login.inboxer.pro/app/octautomation/track",
				'user_id': user_id,
				'secured_user_id': secured_user_id,
				'email': user_email,
				'extra_info': {
				}
			};

			(function () {var w = window; var d = document; function l() {var s = d.createElement('script');s.type = 'text/javascript';s.async = true;s.src = ('https:' == document.location.protocol ? 'https://' : 'http://') + 'login.inboxer.pro/plugins/octautomation/js/tracker.js';var x = d.getElementsByTagName('script')[0];x.parentNode.insertBefore(s, x);}if (w.attachEvent) {w.attachEvent('onload', l);} else {w.addEventListener('load', l, false);}})();


		});
	</script>
	{/literal}

	{literal}
	<script>
		$(document).ready( function(){
			if ($("#attention_block").is(":visible") == true){
				$("#main_block").animate({'margin-top': '40px'}, {queue: false}, 350);
			}
		});
	</script>
	{/literal}

	<!--[if IE 9]>
		{literal}
		<script>
			$(document).ready( function(){
				if ($("#attention_block").is(":visible") == true){
					$("#main_block").animate({'margin-top': '80px'}, {queue: false}, 600);
				}
			});
		</script>
		{/literal}
	<![endif]-->

	{get_gaze var=gaze}
		{if $gaze}
		{$gaze['script']}
	{/if}

	{if $promo}
		<meta property="og:image" content="http://zoo812.ru/files/promos/{$promo->image}" />
		<link rel="image_src" href="http://zoo812.ru/files/promos/{$promo->image}" />
	{/if}

	{literal}
	<script>
		$(document).ready(function(){
			$('.repeat').click(function (){
				var orderid = $(this).data('num');
				$.ajax({
					url: "ajax/cart_user.php",
					data: {orderid: orderid},
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

				setTimeout(function (){
					document.location.href='http://zoo812.ru/cart/';
				}, 1000); // время в мс

			});
		});
	</script>
	{/literal}

	<!-- Retailrocket Основной трекинг-код системы -->
	{literal}
		<script type="text/javascript">
		var rrPartnerId = "5791d7c19872e50ebcfe207e";
		var rrApi = {};
		var rrApiOnReady = rrApiOnReady || [];
		rrApi.addToBasket = rrApi.order = rrApi.categoryView = rrApi.view =
        rrApi.recomMouseDown = rrApi.recomAddToCart = function() {};
		(function(d) {
           var ref = d.getElementsByTagName('script')[0];
           var apiJs, apiJsId = 'rrApi-jssdk';
           if (d.getElementById(apiJsId)) return;
           apiJs = d.createElement('script');
           apiJs.id = apiJsId;
           apiJs.async = true;
           apiJs.src = "//cdn.retailrocket.ru/content/javascript/tracking.js";
           ref.parentNode.insertBefore(apiJs, ref);
		}(document));
		</script>
	{/literal}
	<!-- end Retailrocket Основной трекинг-код системы -->

{if $total_pages_num>1}
	{if $current_page_num==2}<link rel="prev" href="{url page=null}">{/if}
	{if $current_page_num>2}<link rel="prev" href="{url page=$current_page_num-1}">{/if}
	{if $current_page_num<$total_pages_num}<link rel="next" href="{url page=$current_page_num+1}">{/if}
{/if}
{if $smarty.get.page == 'all'}
	<link rel="canonical" href="{if $base_url}{$base_url}{else}{url page=null}{/if}">
{/if}

<meta name="google-site-verification" content="zJPSm_b6tqpAZMtjbqRpWctGfEcrhrsN5CeuDAkkF1o" />

<meta name="google-site-verification" content="_qFshkcgufHyGs9ChDKjXtT0J_Z3jSkmqvL7_YW4JzY" />

</head>
<body>
{if $order && $smarty.server.HTTP_REFERER|strpos:"/cart/"}
<!-- Данные о заказанных товарах для GA -->
<script>
window.dataLayer = window.dataLayer || [];
dataLayer.push({ldelim}
    'ecommerce': {ldelim}
        'purchase': {ldelim}
        'actionField': {ldelim}
            'id': '{if $order->id_new == 0}{$order->id}{else}{$order->id_new}{/if}',
            'affiliation': 'zoo812.ru',
            'revenue': '{$order->total_price|string_format:"%.2f"}',
            'tax':'0.00',
            'shipping': '0.00',            
        {rdelim},
        'products': [
        {foreach $purchases as $purchase}
        {ldelim}
            'name': '{$purchase->product->brand|escape} {$purchase->product_name|escape} {$purchase->variant_name|escape}',
            'id': '{if $purchase->variant->sku}{$purchase->variant->sku}{else}id-{$purchase->variant->id}{/if}',
            'price': '{($purchase->variant->price)|string_format:"%.2f"}',
            'brand': '{if $purchase->product->brand}{$purchase->product->brand|escape}{/if}',
            'category': '{$purchase->product->category->name|escape}',           
            'quantity': '{$purchase->amount}'
        {rdelim}{if not $purchase@last},{/if}
        {/foreach}
        ]
        {rdelim}
    {rdelim}
{rdelim});
</script>
<!-- End Данные о заказанных товарах для GA -->
{/if}
{literal}
<noscript><iframe src="//www.googletagmanager.com/ns.html?id=GTM-MR9JG8"
height="0" width="0" style="display:none;visibility:hidden"></iframe></noscript>
<script>(function(w,d,s,l,i){w[l]=w[l]||[];w[l].push({'gtm.start':
new Date().getTime(),event:'gtm.js'});var f=d.getElementsByTagName(s)[0],
j=d.createElement(s),dl=l!='dataLayer'?'&l='+l:'';j.async=true;j.src=
'//www.googletagmanager.com/gtm.js?id='+i+dl;f.parentNode.insertBefore(j,f);
})(window,document,'script','dataLayer','GTM-MR9JG8');</script>
		
	<noscript><div style="position:absolute;left:-10000px;">
	<img src="//top-fwz1.mail.ru/counter?id=2660457;js=na" style="border:0;" height="1" width="1" alt="Рейтинг@Mail.ru" />
	</div></noscript>
{/literal}
	
	<!-- //Rating@Mail.ru counter -->
	<div id="oos-payment" class="reveal-modal small" style="z-index: 99999999">
	    	<div id="iframe">

	    	</div>
	    	<a id="but_oss_payment_close" class="close-reveal-modal">&#215;</a>
	 </div>

     <div id="oos-payment_block" style="z-index:9;  width:100%;height:100%; background: rgba(0, 0, 0, 0.45); display:none; margin:-14px auto;position:absolute; top: 0px left:0"></div>

   {* Background fix for IE8 *}
  <!--- ЧЁРНАЯ ПЯТНИЦА <img id="background_img" src="design/{$settings->theme}/images/BlackFriday2016-background.jpg" class="bgr" alt="Фоновое изображение zoo812.ru"> --->
  
  <img id="background_img" src="design/{$settings->theme}/images/background51.jpg" class="bgr" alt="Фоновое изображение zoo812.ru">
   
   <!-- <img id="background_img" src="/design/zoo812/images/background5.jpg" class="bgr" alt="Фоновое изображение zoo812.ru">  -->
   <!--  <img id="background_img" src="/design/zoo812/images/ivanko_site-BG-81.jpg" class="bgr" alt="Фоновое изображение zoo812.ru">-->
   
<!-- Хедер -->   
<div id="header" class="row collapse padding-top-1">

	<div class="main_div">
		<!-- Sticky bar -->
		<div id="navbar">
		
			<!-- Если у пользователя ИЕ9 и ниже, то выведем плашку о том, что все у него плохо -->
			<!--[if lte IE 9]>
    			<div id="attention_block" class="row collapse" style="background-color: #e73b3b; color: white; width: 100%; height: 40px;  min-height: 40px; max-height: 40px; overflow: hidden; ">
				<div class="row collapse">
					<p style="background-color: #e73b3b; margin-top: 12px; white-space: nowrap; text-align: center; color: white; font: 13px/14px 'Roboto', Arial, sans-serif; text-shadow: 0 0 1px black;">
						Уважаемый клиент, Вы используете <strong>устаревший</strong> и небезопасный браузер. Рекомендуем Вам <a style="color: white;  font: 15px 'Roboto', Arial, sans-serif; text-shadow: 0 0 1px black; text-decoration: underline;" href="http://browsehappy.com/"><strong>обновить Ваш браузер</strong> </a>для того, чтобы использовать все возможности сайта.
					</p>
				</div>
			</div>
			<![endif]-->

			{literal}
				<style>
					a#attention_link{
						text-decoration: underline;
					}

					a#attention_link:hover{
						text-decoration: none;
					}
				</style>
			{/literal}
			
			{if $plashka}
			<!--  Красная плашка "ВНИМАНИЕ-ВНИМАНИЕ" в самом верху сайта -->			 
		    <div id="attention_block" class="row collapse" style="background: {$color_background}; color: white; width: 100%; height: 40px;  min-height: 40px; max-height: 40px; overflow: hidden; ">
				<div class="row collapse">
					<p style="margin-top: 12px; white-space: nowrap; text-align: center; color: white; font-weight: bold;  font: 18px/18px 'Roboto', Arial, sans-serif;">
						{$plashka}
					</p>
				</div>
			</div>			
			{/if}
			
			<!-- ставился в DIV выше <a id="attention_link" style="color: white;" href="/grafik-dostavki-zakazov-v-majskie-prazdniki">График доставки заказов в майские праздники</a> -->
			
			<div class="main_div">						
			    <div class="row collapse">
			        <div class="large-3 medium-5 columns" id="navbar-login">
			            {if $user}
			            	<i class="fa fa-user"></i>
			            	<a style="color: #fff;" href="/user/">
			            	{$user->name|truncate:14}</a> | 
			            	<a style="font-size: 1.2em; letter-spacing: 0px;" href="/user/logout"><b>Выход</b></a>
			            {else}
			            	<i class="fa fa-power-off"></i>
			            	<a href="/user/login"><b>Вход</b></a> | 
			            	<a href="/user/register"><b>Регистрация</b></a>
			            {/if}
			        </div>
			        <div class="large-5 medium-7 columns">
			            <form action="products">
			                <div class="row collapse" id="index-search">
			                    <div class="small-10 columns">
			                        <input type="text" name="keyword" class="input_search" placeholder="Поиск по товарам">
			                    </div>
			                    <div class="small-2 columns">
			                        <input id="index-search-button" type="submit" class="button postfix" value="">
			                    </div>
			                </div>
			            </form>
			        </div>
			        <div class="cart_in_top">
			        	<a href="cart/" title="Перейти в корзину">
			        		<div class="large-4 columns" id="navbar-cart">
			            		<img class="icon" src="design/{$settings->theme|escape}/images/basket8.png" alt="Корзина" title="Корзина">
			            		<div id="cart_informer">{include file='cart_informer.tpl'}</div>
			        		</div>
			        	</a>
			        	{if $user}
			        		<a class="button radius orange" title="Повторить заказ" id="order-repeat-button" data-reveal-id="order-repeat">&#8634;</a>
			        	{/if}
			        </div>

			        <div class="clear"></div>
			    </div>
			</div>
		</div>
		<!-- (END) Sticky bar -->
	</div>
	<div class="clear"></div>

	<div id="main_block" class="main_div" style="position: relative;">
		<div class="ie8_helper_header_first">
		    <div class="large-4 medium-3 columns" id="logo-block">
		        <a href="/"><img id="logo" src="design/{$settings->theme|escape}/images/logo.png"
		                                    title="{$settings->site_name|escape}" alt="{$settings->site_name|escape}"/></a>
		    </div>
		    <div id="logo_img">
				<a href="/" id="logo-text">товары для животных</a>
			</div> 
		    <div class="large-2 columns online_s">
		    	<!--  <form method="post" action="/files/oos-payment-page.php"> -->
		    		<div>
		    			<label for="orderId">Оплата заказа ONLINE:</label>
		    			<input name="orderId" id="orderId" type="text" placeholder="введите №заказа" style="width: 130px; max-width: 130px;">
			    		<input id="but_oss_payment" type="submit" class="tip button" title="Перед оплатой уточняйте наличие товара у оператора: тел. 8 (812) 777-04-40" name="submit" value="ОФОРМИТЬ" style="width: 130px; max-width: 130px;">
			    	</div>
			    	<div style="clear: both;"></div>
		    	<!--  </form> -->
		    </div>
	    </div>

	    <div class="ie8_helper_header" style="height: 150px; min-height: 150px; position: relative;" >
	    	<div class="large-3 medium-4 columns">
		        <div class="row collapse">
		            <div class="large-12 columns" id="header-phone">
		                <div class="phone-block">8 (812) 777-04-40</div>
		                <!--- <div class="phone-block ya-phone">8 (812) 449-77-71</div> --->

		                <div id="call-time">ПН-ВС 9:00-21:00</div>
		            </div>
		        </div>
		    </div>
		    <div class="large-3 medium-5 columns" style="float: right;">
		        <div id="order-call" class="row collapse">
		            <div class="large-12 columns">
		                <div id="header-social" class="show-for-medium-up">
		                    <a href="http://vk.com/zoo812" target="_blank"><img src="design/{$settings->theme|escape}/images/vk-icon.png" alt="Официальная группа zoo812.ru Вконтакте"></a>
		                    <a href="http://instagram.com/ivankodostavka?ref=badge" target="_blank"><img src="design/{$settings->theme|escape}/images/icons/instagram.png" alt="Официальная группа zoo812.ru в Instagram"></a>
		                    <a href="https://twitter.com/ivanko_dostavka" target="_blank"><img src="design/{$settings->theme|escape}/images/twitter-icon.png" alt="Официальная группа zoo812.ru в Twitter"></a>
		                    <a href="https://plus.google.com/101444059965583055029?rel=author"><img src="design/{$settings->theme|escape}/images/icons/googleplus.png" alt="Официальная страница zoo812.ru в Google Plus"></a>
		                </div>
		                <a class="button radius orange" id="order-call-button" data-reveal-id="call-order-dialog">Заказать звонок</a>
		            </div>
		        </div>
		    </div>
<div id="secondary-menu" class="row collapse">
				<div class="large-12 columns" style="float: right; width: 360px; max-width: 360px;  min-width: 360px; margin-top: 37px; margin-right: 12px;">
        <ul>
					<li><a href="/o-nas/">О нас</a></li>
					<li><a href="/contact/">Контакты</a></li>
					<li><a href="/sotrudnichestvo/">Сотрудничество</a></li>
					<li class="last"><a href="/?module=NurseryView">Помощь приюту</a></li>
        </ul>
    </div>
    <div style="clear: both;"></div>
</div>
		    <!--- <div style="clear: both;"></div>

		    <div id="free_cal_info_ablock">
 				<p><span class="phone-block">8 (800) 555-16-64</span> бесплатный звонок по России</p>
			</div> --->
	    </div>
	</div>
</div>



<!--[if lt IE 8]>
<p class="browsehappy">Вы используете <strong>устаревший</strong> и небезопасный браузер. Рекомендуем вам <a href="http://browsehappy.com/">обновить ваш браузер</a> для того, чтобы использовать все возможности Интернета.</p>
<!--[endif]-->

<!-- Вся страница -->
<div class="row collapse" id="content">
	<div class="main_div">
	    {* Контент *}
	    {$content}
	    {* Контент *}
	</div>
</div>
<!-- Вся страница (The End)-->

{* Функция вывода нижнего меню, населяет его *}
{function name=bottom_menu_populate}

{if $categories}
{foreach $categories as $c}
{if $c->name == 'Новое меню'}
{foreach $c->subcategories as $c2}
{if $c2->visible}
<div class="bottom-menu-block">
    <h5><a href="catalog/{$c2->url}">{$c2->name}</a></h5>
    {if $c2->subcategories}
    <ul>
        {foreach $c2->subcategories as $s}
        <li>
            <a href="catalog/{$s->url}" data-category="{$s->id}">{$s->name}</a>
        </li>
        {/foreach}
    </ul>
    {/if}
</div>
{/if}
{/foreach}
{/if}
{/foreach}
{/if}
{/function}
<a class="button radius orange" title="С новым годом" id="happy_new_year-button" data-reveal-id="happy_new_year" style="visibility: hidden;">&#8634;</a>
<!-- Нижнее меню -->
    <footer id="zoo-bottom-menu-wrapper">
    	<div class="main_div footer_main">
	        <div class="row collapse">
	        	<div class="left_footer" style="float: left;">

	        		<input name="user_id" id="user_id" type="hidden" value="{$uid}" />
	        		<input name="secured_user_id" id="secured_user_id" type="hidden" value="{$securedUserID}" />
	        		<input name="user_email" id="user_email" type="hidden" value="{$email}" />

		            <div class="large-4 medium-4 columns" id="zoo-bottom-info">
		                <div id="footer-logo">
		                    <a href="/"><img src="design/{$settings->theme|escape}/images/footer-logo.png"
		                                            title="{$settings->site_name|escape}" alt="{$settings->site_name|escape}"/></a>
		                </div>
		                <div itemscope="" itemtype="http://schema.org/Organization">
		                    <div class="footer-block">
		                        <h5><span itemprop="url">zoo812.ru</span></h5>

		                        <div class="bottom-menu-block">
				                    <ul>
				                        <li><a href="/karta-sajta/">Карта сайта</a></li>
				                    </ul>
			               		</div>
								
			               		{if !$promo}
		                        <span itemprop="name">
		                        {/if}	
		                        {if $promo}
		                        <span>
		                        {/if}		                        	
		                        	Иванко Доставка - интернет зоомагазин в Санкт-Петербурге: продажа корма для собак и кошек,
		                        	товаров для животных. Бесплатная доставка от 1000 рублей. У нас широкий ассортимент,
		                        	доступные цены и качественное обслуживание.
		                        </span>
		                    </div>
		                    <time itemprop="openingHours" datetime="Mo-Su 09:00 - 21:00"></time>

		                    <div class="bottom-menu-block" style="margin-bottom: 20px;">
		                    	<ul>
		                    		<li><a href="/politika-konfidentsialnosti-ooo-pet-on/" target="_blank">Политика конфиденциальности</a></li>
		                    	</ul>
		           			</div>
							
							<div class="social">
									<a href="https://new.vk.com/zoo812" target="_blank"><img src="/design/zoo812/images/vkontakte-ivanko-dostavka-zoo812ru.png" alt="официальная группа Иванко Доставка zoo812 в социальной сети Вконтакте VK"></a>
									<a class="smforms" href="http://ok.ru/group/54582873292821" target="_blank"><img src="/design/zoo812/images/odnoklassniki-ivanko-dostavka-zoo812ru.png" alt="официальная группа Иванко Доставка zoo812 в социальной сети Одноклассники"></a>
									<a class="smforms" href="https://www.facebook.com/IvankoDostavka/" target="_blank"><img src="/design/zoo812/images/facebook-ivanko-dostavka-zoo812ru.png" alt="официальная группа Иванко Доставка zoo812 в социальной сети Facebook"></a>
									<a class="smforms" href="https://www.instagram.com/ivankodostavka/" target="_blank"><img src="/design/zoo812/images/instagram-ivanko-dostavka-zoo812ru.png" alt="официальная группа Иванко Доставка zoo812 в социальной сети Instagram"></a>
									<a class="smforms" href="https://twitter.com/ivanko_dostavka" target="_blank"><img src="/design/zoo812/images/twitter-ivanko-dostavka-zoo812ru.png" alt="официальная группа Иванко Доставка zoo812 в социальной сети Twitter"></a>
							</div>
							
		           			<br>
		                </div>
		            </div>

		            <div class="large-8 medium-8 columns" id="zoo-bottom-menu">
		                {*  {bottom_menu_populate} *}

		                <div class="bottom-menu-block" style="height: 320px;">
		                    <div itemprop="address" class="footer-block">
		                        <h5>Адрес</h5>
		                        <span itemprop="streetAddress">проспект Обуховской обороны, д. 295</span>
		                        <span itemprop="postalCode">192012</span>
		                        <span itemprop="addressLocality">Санкт-Петербург</span>
		                    </div>

		                    <div id="footer-phone" style="overflow: hidden;">

		                    	<div class="footer-email">
				                    <h5>Телефон:</h5>
				                    <!--- <span class="ya-phone" itemprop="telephone">8 (812) 449-77-71</span><br> --->
				                    <span>8 (812) 777-04-40</span><br>
				                    <!--- <span class="ya-phone" itemprop="telephone">+7 967 594-77-77</span><br> --->
				                    <!--- <span itemprop="telephone">8 800 555-16-64 (бесплатный звонок по России)</span> --->
			                    </div>

				                <div class="footer-email">
				                    <h5>Электронный адрес</h5>
				                    <span>
				                    	<script language="javascript" type="text/javascript">
										    <!--
										    var prefix = '&#109;a'+'i&#108;'+'&#116;o'; // mailto
										    var path = 'hr'+'ef'+'='; // href=
										    var addr = '&#100;&#111;&#115;&#116;&#97;&#118;&#107;&#97;'+'&#64;'; // a
										    addr = addr+'&#105;&#118;&#97;&#110;&#107;&#105;'+'&#46;'+'r&#117;'; // .ru
										    document.write('<a '+path+'"'+prefix+':'+addr+'">');
										    document.write(' '+addr+' ');
										    document.write('</a>');
										    // -->
										</script>
										<script language="javascript" type="text/javascript">
										    <!--
										    document.write('<span style="display: none;">');
										    // -->
										</script>
										Этот email-адрес защищен от спам-ботов, вам необходимо включить Java Script, чтобы его увидеть.
										<script language="javascript" type="text/javascript">
										    <!--
										    document.write('</');
										    document.write('span>');
										    // -->
										</script>
									</span>
			                	</div>

				                <div class="footer-email" style="overflow: hidden;">
				                    <h5>Письмо директору</h5>
				                    <span>
					                    <script language="javascript" type="text/javascript">
										    <!--
										    var prefix = '&#109;a'+'i&#108;'+'&#116;o'; // mailto
										    var path = 'hr'+'ef'+'='; // href=
										    var addr = '&#122;&#111;&#111;&#56;&#49;&#50;'+'&#64;'; // a
										    addr = addr+'&#105;&#118;&#97;&#110;&#107;&#105;'+'&#46;'+'r&#117;'; // .ru
										    document.write('<a '+path+'"'+prefix+':'+addr+'">');
										    document.write(' '+addr+' ');
										    document.write('</a>');
										    // -->
										</script>
										<script language="javascript" type="text/javascript">
										    <!--
										    document.write('<span style="display: none;">');
										    // -->
										</script>
										Этот email-адрес защищен от спам-ботов, вам необходимо включить Java Script, чтобы его увидеть.
										<script language="javascript" type="text/javascript">
										    <!--
										    document.write('</');
										    document.write('span>');
										    // -->
										</script>
									</span>
				                </div>
		                	</div>
		                </div>

		                <div class="bottom-menu-block" style="margin-left: 5%; float: left;">
		                    <h5>Покупателю</h5>
		                    <ul>
		                        <li><a href="/dostavka/">Доставка</a></li>
		                        <li><a href="/oplata-i-vozvrat/">Оплата и возврат</a></li>
		                        <li><a href="/promos/">Акции</a></li>
		                        <li><a href="/proizvoditeli/">Производители</a></li>
		                        <li><a href="/o-nas/">О нас</a></li>
		                        <li><a href="/sotrudnichestvo/">Сотрудничество</a></li>
		                        <li><a href="/contact/">Контакты</a></li>
		                        <li><a href="/contact/">Обратная связь</a></li>
		                    </ul>
		                </div>
		            </div>
		        </div>
	        </div>

	        <div class="market_ya_block" style="float: left; width: 235px;">
	              <a href="http://clck.yandex.ru/redir/dtype=stred/pid=47/cid=1248/*http://market.yandex.ru/shop/228286/reviews/add"><img src="http://clck.yandex.ru/redir/dtype=stred/pid=47/cid=1248/*http://img.yandex.ru/market/informer2.png" alt="Оцените качество магазина на Яндекс.Маркете." /></a>
	        </div>
	        
	        <div class="orphus_block">
	        	<script src="/design/zoo812/js/orphus.js"></script>
	        	<p>Если Вы нашли орфографическую ошибку - выделите ее и нажмите Ctrl+Enter</p>
		   		<a href="http://www.orphus.ru" id="orphus" target="_blank" rel="nofollow"><img alt="Система Orphus" src="/design/{$settings->theme}/js/orphus.gif" border="0" width="88" height="31" /></a>
	        </div>
	        
	        <a href="/oplata-online/">
	        	<div class="oline_pay_icone"></div>
	        </a>	        
	        <div>	        
	        
			<!-- end of Top100 code -->
       	</div>
    </footer>

    <div id="call-order-dialog" class="reveal-modal small" data-reveal>
        <div id="order-call-content">
            <form onsubmit="return false">
                <div class="row collapse">
                    <div class="large-12 columns">
                        <h2>Заказ обратного звонка</h2>
                    </div>
                </div>
                <div class="row collapse">
                    <div class="large-3 columns">
                        <label for="call-order-phone">Укажите телефон</label>
                    </div>
                    <div class="large-1 small-3 columns">
                        <span class="phone-pretext">+7</span>
                    </div>
                    <div class="large-8 small-9 columns">
                        <input name="call-order-phone" id="call-order-phone" type="text">
                    </div>
                </div>
                <div class="row collapse">
                    <div class="large-3 columns">
                        <label for="call-order-phone">Меня зовут</label>
                    </div>
                    <div class="large-9 columns">
                        <input name="call-order-name" id="call-order-name" type="text">
                    </div>
                </div>
                <div class="row collapse">
                    <div class="large-3 columns">
                        <label for="call-order-comments">Ваш комментарий</label>
                    </div>
                    <div class="large-9 columns">
                        <textarea name="call-order-comments" id="call-order-comments" placeholder="Например: прошу перезвонить в 14-00"></textarea>
                    </div>
                </div>
                <br>
                <div class="row collapse">
                    <div class="large-3 columns">
                        <input type="submit" class="button" name="submit" value="Заказать звонок" onclick="console.log('hi'); return requestOrderCall();">
                    </div>
                </div>
            </form>
        </div>
        <a class="close-reveal-modal">&#215;</a>
    </div>
    
    <div id="order-repeat" class="reveal-modal small" data-reveal  style="min-width: 692px; width: 692px; max-width: 692px;">
        <div id="order-repeat-content">
            <form onsubmit="return false">
                <div class="row collapse">
                    <div class="large-12 columns">
                        <h2>Повторить заказ</h2>
                        <p>История Ваших выполненных заказов:</p>
                    </div>
                </div>                
                
                {foreach name=orders item=order from=$orders}
               	{if $order->status == 2}
                <div class="row collapse" style="min-width: 638px; width: 638px; max-width: 638px; border-bottom: dotted 3px #D1D1D1; padding-bottom: 5px;  margin-bottom: 5px;">
                    <div class="large-3 columns">
                        <a href='order/{$order->url}'>Заказ №{if $order->id_new == 0}{$order->id}{else}{$order->id_new}{/if}</a>
                    </div>
                    <div class="large-2 small-3 columns">
                       {$order->total_price} руб.
                    </div>
                    <div class="large-7 small-9 columns">
                       ({$order->date} по МСК)
                       <a style="padding-left: 20px;" data-num="{$order->id}" class="repeat">повторить</a>
                    </div>
                </div>
                {/if}
                {/foreach}
                
            </form>
        </div>
        <a class="close-reveal-modal">&#215;</a>
    </div>
          	
    <!-- Подключаем Foundation -->
    <script src="design/{$settings->theme|escape}/js/foundation.min.js"></script>
    <script>
        Foundation.libs.abide.settings.patterns.alpha_numeric = /^[a-zA-Zа-яА-ЯЁё0-9_\-\s]{literal}{6,20}{/literal}$/;
        Foundation.libs.abide.settings.patterns.password = /^[a-zA-Zа-яА-ЯЁё0-9_\-\s]{literal}{5,14}{/literal}$/;
        $(document).foundation();
    </script>

    {* Общие JS функции *}
    <script src="design/{$settings->theme}/js/routines.min.js?v=14"></script>

    <script src="design/{$settings->theme|escape}/js/unslider.min.js"></script>

	{literal}
		<script>
			$(function (){
				$('.banner').unslider({
					keys: true,
					dots: true,
					speed: 0,
					delay: 5000,
					complete: function() {},
					fluid: true
				});
			});
		</script>
		<!-- BEGIN JIVOSITE CODE  -->
		<script type='text/javascript'>
		(function(){ var widget_id = '109183';
		var s = document.createElement('script'); s.type = 'text/javascript'; s.async = true; s.src = '//code.jivosite.com/script/widget/'+widget_id; var ss = document.getElementsByTagName('script')[0]; ss.parentNode.insertBefore(s, ss);})();</script>
	{/literal}
    {* Фильтр *}
	{assign var="filepath" value="/design/{$settings->theme|escape}/js/filter.lambrusco.jquery.js"}

    <script src="{$filepath|stamped_path}"></script>
    <script type="text/javascript" src="design/{$settings->theme|escape}/js/scrolltotop.js"></script>
    
    {literal}
	    <!-- Traffic tracking code -->
		<script type="text/javascript">
		(function(w, p){
			var a, s;
			(w[p] = w[p] || []).push({
				counter_id: 413010594
			});
			a = document.createElement('script'); a.type = 'text/javascript'; a.async = true;
			a.src = ('https:' == document.location.protocol ? 'https://' : 'http://') + 'autocontext.begun.ru/analytics.js';
			s = document.getElementsByTagName('script')[0]; s.parentNode.insertBefore(a, s);
		})(window, 'begun_analytics_params');
		</script>
	{/literal}
	
</body>
</html>