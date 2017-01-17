<aside class="large-3 medium-3 columns">

    <!-- Меню каталога (The End)-->
	{include file='main_menu.tpl' categories=$categories}
    <!-- Меню каталога (The End)-->

</aside>

{literal}
 <script src="https://api-maps.yandex.ru/2.1/?lang=ru_RU" type="text/javascript"></script>

<style>

	.brdrbtm {
		border-bottom: thin dashed #ececec;
		margin: 25px 0px;
	}	
	
	.brdrbttm {
		border-bottom: thin dashed #ececec;
		margin-bottom: 15px;
	}
	
	.catcont {
		border-left: thin solid #E16BC9;
		padding-left: 15px;
	}	
	
	.dogcont {
		border-left: thin solid #6DBECF;
		padding-left: 15px;
	}
	
	#dogh3 {
		color: #6DBECF;
		border-left: thin solid #6DBECF;
		font-size: 1.9em;
		font-weight: 700;
		padding-left: 15px;
	}
	
	.sliderpets h3{
		color: #E16BC9;
		border-left: thin solid #E16BC9;
		font-size: 1.9em;
		font-weight: 700;
		padding-left: 15px;
	
	}
	.coin-slider{
		overflow: hidden;
		zoom: 1;
		position: relative;
		width: 625px;
		min-width: 625px;
		max-width: 625px;
		margin: 0 auto;
	}
	
	.coin-slider a{
	 	text-decoration: none; outline: none; border: none; 
	 }
	
	.cs-buttons { font-size: 0px; padding: 10px; float: left; }
	.cs-buttons a { margin-left: 5px; height: 10px; width: 10px; float: left; border: 1px solid #B8C4CF; color: #B8C4CF; text-indent: -1000px; }
	.cs-active { background-color: #B8C4CF; color: #FFFFFF; }
	
	.cs-title { width: 625px; padding: 10px; background-color: #000000; color: #FFFFFF; }
	
	.cs-prev, 
	.cs-next { background-color: #000000; color: #FFFFFF; padding: 0px 10px; }
	
	#large_box {width:800; height:600;}
	
	.horh{
		 writing-mode: tb-rl;
		 color: #ff5c6b;
		 font-size: 18px;
		 font-weight: 600;
		 border-bottom: thin solid #ff5c6b;
 	}
 	
	/*  а тут стили для Tabs */
	#tabs .tabs {margin-top: 35px; min-width: 625px; max-width: 625px; width: 625px; overflow: hidden; border-bottom: 1px solid #999;}	
	#tabs .tabs li {width: 33%; float: left; list-style-type: none;}
	#tabs .tabs li + li {border-left: 1px solid #999;}
	#tabs .tabs li a {display: block; padding: 8px 16px; font-size: 18px; line-height: 21px; color: #999;}
	#tabs .tabs li a.active,
	#tabs .tabs li a:hover {color: #369;}
	#tabs .tabs-content {padding: 20px; font-size: 16px; line-height: 21px;}
	
	#tabs_r .tabs_r {margin-top: 35px; min-width: 625px; max-width: 625px; width: 625px; overflow: hidden; border-bottom: 1px solid #999;}	
	#tabs_r .tabs_r li {width: 15%; float: left; list-style-type: none;}
	#tabs_r .tabs_r li + li {border-left: 1px solid #999;}
	#tabs_r .tabs_r li a {display: block; text-align: center; width: 100%; min-width: 100%; max-width: 100%; padding: 8px 16px; font-size: 18px; line-height: 21px; color: #999;}
	#tabs_r .tabs_r li a.active,
	#tabs_r .tabs_r li a:hover {color: #369;}	
	#tabs_r .tabs-content_r {padding: 20px; font-size: 16px; line-height: 21px;}
	/*  а тут стили для Tabs закончились */
	
	#layout-plist .large-2.columns.big_call{
		width: 130px;
		min-width: 130px;
		max-width: 130px;
	}
	
	#gal_ler {
		display: block;
		width: 450px;
		max-width: 450px;
		min-width: 450px;
		margin: 0 auto;
	}
	
	#1531aug {
		clear: both;
		margin-top: 45px;
		border-bottom: 2px dashed #e5554a;    
		margin-bottom: 15px;
	}
	       #map {
            width: 100%;
            height: 400px;
        }
	

</style>

<script>
	$(document).ready(function(){

			
			
		    var tabs = $('#tabs');
		    $('.tabs-content > div', tabs).each(function(i){
		        if ( i != 0 ) $(this).hide(0);
		    });
		    
		    tabs.on('click', '.tabs a', function(e){
		        e.preventDefault();
				
		        var tabId = $(this).attr('href');
				
		        $('.tabs a',tabs).removeClass();
		        $(this).addClass('active');
				
		        $('.tabs-content > div').hide(0);
		        $(tabId).show();
		    });
		    
		});
</script>
{/literal}

<script>
ymaps.ready(init);

function init () {
	JSONData = JSON.stringify({$pickuppointsjson});
	var myMap = new ymaps.Map('map', {
            center: [59.89444,30.26417],
            zoom: 10
        }, {
            searchControlProvider: 'yandex#search'
        }),
        objectManager = new ymaps.ObjectManager({
            clusterize: true,
			gridSize: 32
        });

		myMap.geoObjects.add(objectManager);
		
		 
        objectManager.add(JSONData);     
}
</script>




<div class="large-9 medium-9 columns">

    {* Содержимое страницы *}
    <div class="row collapse" id="inner">
        <div class="large-12 columns">

            {include file='_inc_main-menu.tpl'}
            <div class="large-12 columns" id="active-page">
                {* Хлебные крошки *}
                <div class="row collapse">
                    <div class="large-12 columns">
                        <div class="lk-breadcrumbs">
                            <span><i class="fa fa-home"></i><a href="/">Главная</a></span><span class="divider">&gt;</span><span>Пункты самовывоза</span>
                        </div>
                    </div>
                </div>
				
				<div class="row collapse">
					<div class="large-12 columns">
						<h1>Пункты самовывоза</h1>
					</div>
				</div>
				<div class="row collapse">
					<div class="large-12 columns" id="pickuppoints">
						<div id="tabs" style="">
							<ul class="tabs">
								<li class="tab"><a class="active" href="#spisok">Списком</a></li>
								<li class="tab"><a href="#onmap">На карте</a></li>
							</ul>
						</div>
						<div class="tabs-content">
							<div id=spisok style="overflow: hidden; display: block;">
								<table>
									<tbody>
										<tr>
											<td></td>
											<td>Адрес</td>
											<td>Режим работы</td>
											<td>Телефон</td>
											<td>Макс. вес заказа</td>											
										</tr>
									{foreach from=$pickuppoints item=pickuppoint}
										<tr>
											<td>{if $pickuppoint->url}<a href="/pickuppoints/{$pickuppoint->url}">{$pickuppoint->metro_station}</a>{else}{$pickuppoint->metro_station}{/if}</td>
											<td>{if $pickuppoint->url}<a href="/pickuppoints/{$pickuppoint->url}">{$pickuppoint->address}</a>{else}{$pickuppoint->address}{/if}</td>
											<td>{if $pickuppoint->url}<a href="/pickuppoints/{$pickuppoint->url}">{$pickuppoint->worktime}</a>{else}{$pickuppoint->worktime}{/if}</td>
											<td>{if $pickuppoint->url}<a href="/pickuppoints/{$pickuppoint->url}">{$pickuppoint->phone}</a>{else}{$pickuppoint->phone}{/if}</td>
											<td>{if $pickuppoint->url}<a href="/pickuppoints/{$pickuppoint->url}">{$pickuppoint->weight_limit}</a>{else}{$pickuppoint->weight_limit}{/if}</td>									
										</tr>		
									{/foreach}
									</tbody>
								</table>
							</div>
							
							<div id=onmap style="overflow: hidden; display: none;">
								<div id="map"></div>
							</div>
				
						</div>
					</div>
					<div class="brdrbttm"></div>
				</div>
             </div>
        </div>
	</div>
	
 
</div>
