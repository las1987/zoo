{literal}
	<style>
		#geo{
			min-height: 22px;
		}
		
		#geo a.change_city{		
			color: #4d4d4d;
		}

		#purchases tr{
			border: none;
		}
		
		#purchases th.total-price{
			font-size: 1.2em;
		}
		
		.large-middle1{
			width: 47%;
			min-width: 47%;
			max-width: 47%;			
		}
		
		.large-middle2{
			width: 53%;
			min-width: 53%;
			max-width: 53%;
		}

		#geo{
			background: #e7e7e7;
			padding: 20px;
			width: 705px;
			min-width: 705px;
			max-width: 705px;
			margin-left: -20px;
			font: 20px dct;
			margin-bottom: 5px;
			height: 70px;
			min-height: 70px;
			max-height: 70px;
			margin-top: 5px;
			margin-bottom: 15px;
		}
		
		.yes_no{
			width: 25%;
			float: right;
			font-weight: bold;
			color: #4d4d4d;
		}
		
		.yes{
			color: #e73b3b;
			border-bottom: 1px dotted;
		}
		
		.confirm{
			background: url('http://zoo812.ru/temp001/approve-ivanko-dostavka-zoo812ru-30x30px-green-8EAB11.png');
			width: 30px;
			min-width: 30px;
			max-width: 30px;	
			height: 30px;
			min-height: 30px;
			float: right;
			display: none;
			margin-right: 30px;
		}
		
		.location_geo{
			border-bottom: 1px dotted;
			color: #e73b3b;
			margin-left: 12px;
		}
		
		/*Стиль выбора доставка или самовывоз*/
		.tabs input[type=radio]{
			display:none;
		}
		
		.tabs label{
			font-size: 26px !important;
		}
		
		.tabs input[type=radio] + label span {
			display:inline-block;
			width:40px;
			height:40px;
			margin:-1px 4px 0 0;
			vertical-align:middle;
			cursor:pointer;		
		}
		
		.tabs input[type=radio]:checked + label span {	
			background: url('../temp001/40px-done-circle-orange-ivanko-dostavka.png') left top no-repeat;
		}
		
	</style>
{/literal}


{literal}
	<script src="https://api-maps.yandex.ru/2.1/?lang=ru_RU" type="text/javascript"></script>
	<script>
		$(document).ready(function (){
			$("#cost_card_block").hide();
		});
	</script>
{/literal}

{literal}
<script>
$(document).ready(function (){
	
	$('#street_dpd_no').change(function(){
		var xxx = "";	
		$("#address").val(xxx);
		$("#address_new").val(xxx);
	});

	$('#street_dpd').change(function(){
		var xxx = "";
		$("#address").val(xxx);
		$("#address_new").val(xxx);
	});

	$('.yes').click(function(){
		$(".yes_no").toggle();
		$(".confirm").toggle();
		$('.location_geo').css('color', '#8EAB11');		
	});

	$('#streetAbbr_dpd_no').change(function(){
		x = $(this).val();
		$("#streetAbbr_dpd").val(x);
	});

	$('#street_dpd_no').change(function(){
		x = $(this).val();
		$("#street_dpd").val(x);
	});

	$('#house_dpd_no').change(function(){
		x = $(this).val();
		$("#house_dpd").val(x);
	});

	$('#houseApartment_dpd_no').change(function(){
		x = $(this).val();
		$("#houseApartment_dpd").val(x);
	});

});
</script>
{/literal}

{literal}
<script>
$(document).ready(function (){
	
	function change_city(){

		$("#cost_card_block").hide();

		var total_price = $("#total_price").val();
		total_price = parseInt(total_price);

		var card_user = $("#card").val();
		var email_user = $("#email").val();
		var url_user = 'http://zoo812.ru/files/card_in_cart.php';
	
		if ((card_user != '')||(card_user != null)){
			$.get(
				url_user,
	            {
	            	'card_user': card_user, 'email_user': email_user
	            },
	            function (result){
												
                    $(result).each(function(){
	                    var is_true = $(this).attr('is_true');

	                    if (is_true == true){
		                    						
	                    	var x = $("#sity_no").prop("checked");							
	                    	var y = null;
	                    		                    	
	                    	if ($("#sity_div_new").length > 0){
	                    		var y = $("#sity_div_new").val();
	                    	}
	                    			                    
	                    	if ((x == false)&&(y == null)){
	                    		var total_p = total_price;		                    	
		                    	total_x = total_p*0.9;	
		                    	total_x = total_x.toFixed();
		                    	
		                    	var cost_card_val = total_p - total_x;
		                    	cost_card_val = cost_card_val.toFixed();
		                    		                    	
		                    	$("#cost_card").text(cost_card_val);
		                    	$("#total_p").text(total_x);

		                    	$("#cost_card_block").show();
		                    	
		                    	total_price = total_x;
	                    	}
	                    }
                    });
	             },
	            "json"
		    );				
		};
		
    	$("#cost").text(0);
    	$("#cost").val(0);

    	$("#cost_span").text("бесплатно");
		
		var min_price = $("#destination_id option:selected").data('num');
		var price = $("#total_price").val();
		
		var min_price_t = parseInt(min_price, 10);
		var price_t = parseInt(price, 10);
		
		var my_tmp_city_var_tmp = $("#destination_id option:selected").text();

		/*if (my_tmp_city_var_tmp == 'Москва'){
			$(".in_mkad_block").show();

			$("#cost").text("250");
        	$("#cost").val(250);

        	var total_price = $("#total_price").val();

        	total_price = parseFloat(total_price);
        	cost = 250;
        	
        	var total_p = total_price + cost;
        	$("#total_p").text(total_p.toFixed(0));

        	$("#cost_span").text("" + cost + " руб.");

        	$("#cost").text(cost);
        	$("#cost").val(cost);

        	$("#ots1 [value='2']").attr("selected", "selected");
		}
		else{*/
			$(".in_mkad_block").hide();

			$("#cost").text("0");
        	$("#cost").val(0);

        	var total_price = $("#total_price").val();

        	total_price = parseFloat(total_price);
        	cost = 0;
        	
        	var total_p = total_price + cost;
        	$("#total_p").text(total_p.toFixed(0));

        	$("#cost_span").text("бесплатно");

        	$("#cost").text(cost);
        	$("#cost").val(cost);
		//}

		var my_tmp_city_var = $("#destination_id option:selected").text();
			
		if ($("#oferta").prop("checked") == true){
				$("#btn_submit").attr("disabled", false);

				$("#alertdist").hide();
				$("#dostavka").hide();
		}
		
		$("#city_selected").text(my_tmp_city_var);
		$("#cost_selected").text(min_price);
		
		$("#city_selected_top").text(my_tmp_city_var);
		$("#cost_selected_top").text(min_price);			

		if (my_tmp_city_var == 'Санкт-Петербург'){
			$(".spb_inf").text("для владельцев дисконтных карт (для остальных – от 1000 рублей)");
		}
		else{
			$(".spb_inf").text("");
		}
	}
	
	var destinations_id =  $("#destinations_id").val();
	var destinations_location = $("#destinations_location").val();
	
	var my_dpd_citys_id = $("#my_dpd_citys_id").val();
	var my_dpd_citys_cityid = $("#my_dpd_citys_cityid").val();
	var my_dpd_citys_countrycode = $("#my_dpd_citys_countrycode").val();
	var my_dpd_citys_countryname = $("#my_dpd_citys_countryname").val();
	var my_dpd_citys_regioncode = $("#my_dpd_citys_regioncode").val();
	var my_dpd_citys_regionname =  $("#my_dpd_citys_regionname").val();
	var my_dpd_citys_cityname =  $("#my_dpd_citys_cityname").val();

	if (destinations_id != null){
		//alert(destinations_id);
	}

	if($("#sity_div_new").length > 0) {
		//cost_dpd();
	}
	
	$("#destination_id [value='3']").remove();
	$("#destination_id [value='39']").remove();
	
	$("#destination_id").prepend( $('<option data-num="2500" style="font-weight: bold;" value="39">Москва</option>'));
	$("#destination_id").prepend( $('<option data-num="1" style="font-weight: bold;" value="3">Санкт-Петербург</option>'));
	
	$("#destination_id [value='3']").attr("selected", "selected");
	
	$('.plus_block').click(function (){
		var element = $(this).data('text');
		var amaunt = $(this).data('num');
		amaunt = parseInt(amaunt);
		var select_now = $("select[id='"+element+"']").val();
		select_now = parseInt(select_now) + parseInt(amaunt);
		if (select_now >= 200) select_now = 200;
		var select_now = $("select[id='"+element+"']").val(select_now);
		
		document.cart.submit();
	});

	$('.minus_block').click(function (){
		var element = $(this).data('text');
		var amaunt = $(this).data('num');
		amaunt = parseInt(amaunt);
		
		var select_now = $("select[id='"+element+"']").val();
		
		select_now = parseInt(select_now) - parseInt(amaunt);
		
		if (select_now <= 1) select_now = amaunt;
		
		var select_now = $("select[id='"+element+"']").val(select_now);
		
		document.cart.submit();
	});

	$('.fake_amount_number').change(function (){
		var element = $(this).data('text');
		var amaunt = $(this).data('num');
		amaunt = parseInt(amaunt);	
		
		var select_now = $(this).val();
		
		select_now = parseInt(select_now);
		var v = (select_now % amaunt);
		
		if (v != 0) alert("Данный товар выписывается кратно " + amaunt);
		
		var g = parseInt(select_now) - parseInt(v);
		
		select_now = g;
		
		if (select_now >= 200) select_now = 200;
		if (select_now < amaunt) select_now = amaunt;

		var select_now = $("select[id='"+element+"']").val(select_now);
		document.cart.submit();
	});
	
	
	var placeholder_classic ="Введите сюда промокод, если он у Вас есть.";
	var placeholder_drug = "К сожалению, промокоды не распространяются на заказы в приют.";
	var oldadress = $("#address").val();
	
	
	
	/*$('#destination_id').change(function (){
		
		var total_price = $("#total_price").val();
    	$("#total_p").text(total_price);
    	$("#cost").text(0);
    	$("#cost").val(0);
		
    	$("#cost_span").text("бесплатно");
		
		var min_price = $("#destination_id option:selected").data('num');
		var price = $("#total_price").val();
		
		var min_price_t = parseInt(min_price, 10);
		var price_t = parseInt(price, 10);
					
		var my_tmp_city_var_tmp = $("#destination_id option:selected").text();

		if (my_tmp_city_var_tmp == 'Москва'){
			$(".in_mkad_block").show();

			$("#cost").text("250");
        	$("#cost").val(250);

        	var total_price = $("#total_price").val();

        	total_price = parseFloat(total_price);
        	cost = 250;
        	
        	var total_p = total_price + cost;
        	$("#total_p").text(total_p.toFixed(0));

        	$("#cost_span").text("" + cost + " руб.");

        	$("#cost").text(cost);
        	$("#cost").val(cost);

        	$("#ots1 [value='2']").attr("selected", "selected");
		}
		else{
			$(".in_mkad_block").hide();

			$("#cost").text("0");
        	$("#cost").val(0);

        	var total_price = $("#total_price").val();

        	total_price = parseFloat(total_price);
        	cost = 0;
        	
        	var total_p = total_price + cost;
        	$("#total_p").text(total_p.toFixed(0));

        	$("#cost_span").text("бесплатно");

        	$("#cost").text(cost);
        	$("#cost").val(cost);
		}

		var my_tmp_city_var = $("#destination_id option:selected").text();
		
		if (price_t < min_price_t){
			//$("#btn_submit").attr("disabled", true);
			//$("#alertdist").show();
			//$("#dostavka").show();
			
		}
		else{
			if ($("#oferta").prop("checked") == true){
				$("#btn_submit").attr("disabled", false);
				$("#alertdist").hide();
				$("#dostavka").hide();
			}
		}
		
		$("#city_selected").text(my_tmp_city_var);
		$("#cost_selected").text(min_price);
		
		$("#city_selected_top").text(my_tmp_city_var);
		$("#cost_selected_top").text(min_price);
		
		if (my_tmp_city_var == 'Санкт-Петербург'){
			$(".spb_inf").text("для владельцев дисконтных карт (для остальных – от 1000 рублей)");
		}
		else{
			$(".spb_inf").text("");
		}
		
	});*/

	var price = $("#total_price").val();
	/*if (price < 490){
		
		var drug_is = false;
		
		{/literal}
		{if $drug_is == true}
		{literal}
		
		drug_is = true;
		
		{/literal}
		{/if}
		{literal}

		if (!drug_is){
			$("#btn_submit").attr("disabled", true);
		}
	}

	$('.amounts_select').change(function (){
					
		var price = $("#total_price").val();							
		var drug_is = false;

		{/literal}
		{if $drug_is == true}
		{literal}
		
		drug_is = true;
		
		{/literal}
		{/if}
		{literal}

		if (!drug_is){
			if (price < 490){
				$("#btn_submit").attr("disabled", true);
			}
			else{
				if ($("#oferta").prop("checked") == true){
					$("#btn_submit").attr("true", false);
				}
			}
		}
		
	});*/
	
	var item = localStorage.getItem('name');

	if ($('#name').val() == ''){
		$('#name').val(item);
	}

	$('#name').change(function (){
		var value = $('#name').val();
		localStorage.setItem('name', value);
	});

	item = localStorage.getItem('email');

	if ($('#email').val() == ''){
		$('#email').val(item);
	}
	
	$('#email').change(function (){
		var value = $('#email').val();
		localStorage.setItem('email', value);
	});

	item = localStorage.getItem('phone');

	if ($('#phone').val() == ''){
		$('#phone').val(item);
	}
	
	$('#phone').change(function (){
		var value = $('#phone').val();
		localStorage.setItem('phone', value);
	});

	item = localStorage.getItem('address');

	if ($('#address').val() == ''){
		$('#address').val(item);
	}

	$('#address').change(function (){
		var value = $('#address').val();
		localStorage.setItem('address', value);
	});					

	$('#address').change(function (){
		
		var drug_is = false;

		{/literal}
		{if $drug_is == true}
		{literal}
		
		drug_is = true;

		{/literal}
		{/if}					
		{literal}

		$('#address_new').change(function (){
			var value = $('#address_new').val();
			localStorage.setItem('address_new', value);
			$('#address').val(value);
		});

		if ($("#to_drug").prop("checked")){
			drug_is = true;
		}

		if (drug_is){
			alert('В вашей корзине присутствуют товары, предназначенные для приюта «Помощь бездомным собакам», пока в корзине присутствуют данные товары, изменить адрес доставки невозможно. После оплаты заказ будет отправлен на адрес приюта.');
			var str_tmp = 'АНО «Помощь бездомным собакам» 192148, г. Санкт-Петербург, Большой Смоленский пр. д.7-9, литер А';
			$('#address').val(str_tmp);
			$('#address_new').val(str_tmp);
		}
		else{
			var value = $('#address').val();
			
			if (value != "АНО «Помощь бездомным собакам» 192148, г. Санкт-Петербург, Большой Смоленский пр. д.7-9, литер А"){
				localStorage.setItem('address', value);
			}
			else{
				value = '(Пожалуйста, заполните это поле в своем личном кабинете)';
				localStorage.setItem('address', value);
			}
		}
	});

			function cost_dpd(){

				$("#cost_card_block").hide();

				var region_var =  $(".region").css('display');
								
				if (region_var == 'inline-block'){
					
					$("#delivery_result").text("Пожалуйста, подождите... считаем...");
					var total_price = "...завершите расчет стоимости доставки...";
	            	$("#total_p").text(total_price);
					var url = 'http://zoo812.ru/files/cartdpd.php';
					
					if ($("#apartment").prop("checked") == true){
						var terminal = '0';
					}
					else{
						var terminal = '1';
					}
	
					var terminal = '0';
					
					var dpd_coefficient = $("#dpd_coefficient").val();
					
					var weight = $("#weight_cart").val();
					var volume = $("#volume").val();
					var cityid = $(".sity option:selected").val();
					
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
				                    	var total_price = $("#total_price").val();
	
				                    	total_price = parseFloat(total_price);
				                    	cost = parseFloat(cost);
				                    	
				                    	var total_p = total_price + cost;
				                    	$("#total_p").text(total_p.toFixed(0));
	
				                    	$("#cost_span").text("" + cost + " руб.");
	
				                    	$("#cost").text(cost);
				                    	$("#cost").val(cost);
	
				                    	$("#dpd_tarif").text(dpd_tarif);
				                    	$("#dpd_tarif").val(dpd_tarif);
				                    	$("#cost_card_block").hide();
	
				                    	$("#day").val(day);
				                    	$("#day").text(day); 
				                    }
	
				                    if ($(this).attr('cost') == null){
				                    	var total_price = $("#total_price").val();
				                    	$("#total_p").text(total_price);
				                    	$("#cost").text(0);
				                    	$("#cost").val(0);
	
				                    	$("#cost_span").text("бесплатно");
				                    	$("#dpd_tarif").text("");
				                    	$("#dpd_tarif").val();
	
				                    	$("#day").val();
				                    	$("#day").text("");
				                    }
			                    });
			                },
			            "json"
			        );

				}
				else{
					$(".in_mkad_block").hide();					
				}
			}
			
			function cost_dpd_x(cityid){

				$("#cost_card_block").hide();

				var region_var =  $(".region").css('display');

				if (region_var == 'inline-block'){
				
					$("#delivery_result").text("Пожалуйста, подождите... считаем...");
					var total_price = "...завершите расчет стоимости доставки...";
	            	$("#total_p").text(total_price);            					
					var url = 'http://zoo812.ru/files/cartdpd.php';
									
					if ($("#apartment").prop("checked") == true){
						var terminal = '0';
					}
					else{
						var terminal = '1';
					}
	
					var terminal = '0';
					
					var dpd_coefficient = $("#dpd_coefficient").val();
					
					var weight = $("#weight_cart").val();
					var volume = $("#volume").val();
					//var cityid = $(".sity option:selected").val();
					
					//alert(cityid);
					
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
				                    	var total_price = $("#total_price").val();
	
				                    	total_price = parseFloat(total_price);
				                    	cost = parseFloat(cost);
				                    	
				                    	var total_p = total_price + cost;
				                    	$("#total_p").text(total_p.toFixed(0));
	
				                    	$("#cost_span").text("" + cost + " руб.");
	
				                    	$("#cost").text(cost);
				                    	$("#cost").val(cost);
	
				                    	$("#dpd_tarif").text(dpd_tarif);
				                    	$("#dpd_tarif").val(dpd_tarif);
				                    	$("#cost_card_block").hide();
				                    	
				                    	$("#day").val(day);
				                    	$("#day").text(day); 
				                    }
	
				                    if ($(this).attr('cost') == null){
				                    	var total_price = $("#total_price").val();
				                    	$("#total_p").text(total_price);
				                    	$("#cost").text(0);
				                    	$("#cost").val(0);
	
				                    	$("#cost_span").text("бесплатно");
				                    	$("#dpd_tarif").text("");
				                    	$("#dpd_tarif").val();
	
				                    	$("#day").val();
				                    	$("#day").text("");
				                    }
			                    });
			                },
			            "json"
			        );
				}
				else{
					$(".in_mkad_block").hide();
									
				}
			}

	$('#apartment').click(function (){
		//cost_dpd();
	});

	/*$(function(){
		$.getJSON('http://zoo812.ru/files/select_region.php', function(data){
            $.each(data, function(key, val){
            	$('.region').append('<option value="' + val.id + '">' +  val.title + '</option>');
        	});
		});
	});*/

   $('.region').change(function (){

	   //alert(1);
	   
		//var region_code = $(this).val();
		//var url = 'http://zoo812.ru/files/select_sity.php';
		
        /*$.get(
            url,
            "region_code=" + region_code,
            function (result){
				var options = '';
                    $(result).each(function(){
                        options += '<option value="' + $(this).attr('id') + '">' + $(this).attr('title') + '</option>';
                    });
                    $('.sity').html(options);
                    $('.sity').attr('disabled', false);
                    
                    cost_dpd();
                },
            "json"
        );*/
    });
    
	$('#oferta').click(function(){
							
		if ($("#oferta").prop("checked") == true){
			var price = $("#total_price").val();

			if (price >= 700){
				$("#btn_submit").attr("disabled", false);
			}
		}
		else{
			$("#btn_submit").attr("disabled", true);
		}
	});

	$('#sity_no').click(function (){

		
		
		var drug_is = false;
		
		{/literal}									
		{if $drug_is == true}							
		{literal}
		
		drug_is = true;
		
		{/literal}
		{/if}
		{literal}

		if ($("#to_drug").prop("checked")){
			drug_is = true;
		}
		
		if (!drug_is){
		
			var option_cash = "<option id='select_cash' value='1'>Наличными</option>";
			var mycity = $("#sity_no").prop("checked");
		
			if (mycity == true){
				$("#ots1 [value='1']").remove();
			}
			else{
				$("#ots1").prepend( $(option_cash));
				$("#ots1 [value='1']").attr("selected", "selected");
			}
		
			$('#sity_div').toggle();
					
			if ($("#sity_no").prop("checked") == true){

				$(function(){
					$.getJSON('http://zoo812.ru/files/select_region.php', function(data){

					
						
			            $.each(data, function(key, val){
						
			            	$('.region').append('<option value="' + val.id + '">' +  val.title + '</option>');
			        	});
					});
				});
				
				$('#destination_id').toggle();
				$("#label_for_free_d").toggle();
				$("#address_free").toggle();
				$("#address_dpd").toggle();
				$("#address_no").show();

				//$("#address_no").attr("display", "block");
										
				//cost_dpd();
				
			}
			
			if ($("#sity_no").prop("checked") == false){
							
				$('#destination_id').toggle();
				$("#label_for_free_d").toggle();
				$("#address_free").toggle();
				$("#address_dpd").toggle();
				//$("#address_no").toggle();
				
				var total_price = $("#total_price").val();
				
	            $("#total_p").text(total_price);
	            $("#cost").text(0);
	            $("#cost").val(0);
	            $(".region").empty();
	            $(".sity").empty();
	            $("#cost_span").text("бесплатно");
	            $("#dpd_tarif").text("");
	            $("#dpd_tarif").val();
	            $("#day").val();
	            $("#day").text("");                	
			}
		}
		else{
			alert('В вашей корзине присутствуют товары, предназначенные для приюта «Помощь бездомным собакам», пока в корзине присутствуют данные товары, изменить адрес доставки невозможно. После оплаты заказ будет отправлен на адрес приюта.');						
			$('#sity_no').removeAttr("checked");
		}
			
		var sity_div = $("#sity_div").css('display');
		
		var in_mkad_block = $(".in_mkad_block").css('display'); 
		
		if ((in_mkad_block == 'block')&&(sity_div == 'block')){
		
			$(".in_mkad_block").toggle();

			$("#cost").text("0");
        	$("#cost").val(0);

        	var total_price = $("#total_price").val();
			
        	total_price = parseFloat(total_price);
        	cost = 0;
        	
        	var total_p = total_price + cost;
        	$("#total_p").text(total_p.toFixed(0));

        	$("#cost_span").text("бесплатно");

        	$("#cost").text(cost);
        	$("#cost").val(cost);
		}
		else{
			var my_tmp_city_var_tmp = $("#destination_id option:selected").text();

			if (my_tmp_city_var_tmp == 'Москва'){
				$(".in_mkad_block").show();

				var mkad_in = $("#mkad_in option:selected").val();
				
				if (mkad_in == "out"){
					$("#cost").text("400");
				    $("#cost").val(400);
					
				    var total_price = $("#total_price").val();
					
			        total_price = parseFloat(total_price);
			        cost = 400;
			        
			        var total_p = total_price + cost;
			        $("#total_p").text(total_p.toFixed(0));
			        $("#cost_span").text("" + cost + " руб.");
			        $("#cost").text(cost);
			        $("#cost").val(cost);
				}
				else{
					$("#cost").text("250");
				    $("#cost").val(250);
					
				    var total_price = $("#total_price").val();
					
			        total_price = parseFloat(total_price);
			        cost = 250;
			        
			        var total_p = total_price + cost;
					
			        $("#total_p").text(total_p.toFixed(0));
					
			        $("#cost_span").text("" + cost + " руб.");
					
			        $("#cost").text(cost);
			        $("#cost").val(cost);
				}
			}
		}
	});

	$('.sity').change(function(){
		//var x = $(this).val();
		//cost_dpd_x(x);
	});

	$('#to_drug').click(function (){
		if ($("#to_drug").prop("checked")){

			$("#promokod").val("");
			$('#promokod').attr('disabled', true);					
			var el = document.getElementById("promokod");					
			el.placeholder = placeholder_drug;
			
			$("#btn_submit").attr("disabled", false);
			$("#alertdist").hide();
			$("#dostavka").hide();
			
			if ($("#sity_no").prop("checked") == true){
				
				$('#sity_div').toggle();
				
				$("#destination_id").attr("display", false);
				$("#label_for_free_d").attr("display", false);		
				
				$('#destination_id').toggle();
				$("#label_for_free_d").toggle();
				$("#address_free").toggle();
				$("#address_dpd").toggle();
				
				var total_price = $("#total_price").val();
				
	            $("#total_p").text(total_price);
	            $("#cost").text(0);
	            $("#cost_span").text("бесплатно");
	            $("#dpd_tarif").text("");
	            $("#dpd_tarif").val();
	            $("#day").val();
	            $("#day").text("");
				
	            $("#sity_no").prop("checked") = false;
			}
			
			$('#address').val('АНО «Помощь бездомным собакам» 192148, г. Санкт-Петербург, Большой Смоленский пр. д.7-9, литер А');
						
			$('#address_new').val('АНО «Помощь бездомным собакам» 192148, г. Санкт-Петербург, Большой Смоленский пр. д.7-9, литер А');
			$('#order_comment').val('В приют. Благотворительность.');
			
			$('#ots1 option[value=2]').attr('selected', 'selected');
	        $('#ots1 option[id=select_cash]').attr("disabled", "disabled");
		}
		else{
			var min_price = $("#destination_id option:selected").data('num');
			var price = $("#total_price").val();
			
			var min_price_t = parseInt(min_price, 10);
			var price_t = parseInt(price, 10);
			
			if (price_t < min_price_t){
				$("#btn_submit").attr("disabled", true);
				$("#alertdist").show();
				$("#dostavka").show();
			}
			else{
				if ($("#oferta").prop("checked") == true){
					$("#btn_submit").attr("disabled", false);
					$("#alertdist").hide();
					$("#dostavka").hide();
				}
			}
			
			$('#promokod').attr('disabled', false);
			var el = document.getElementById("promokod");
			el.placeholder = placeholder_classic;
			
			$('#ots1 option[id=select_cash]').removeAttr('disabled');
			$('#ots1 option[value=1]').attr('selected', 'selected');
			
			$('#order_comment').val('');
			
			if ($('#address').length > 0){
				var address_tmp = localStorage.getItem('address');
				$('#address').val(address_tmp);
			}

			if ($('#address_new').length > 0){
				var address_new_tmp = localStorage.getItem('address_new');
				$('#address_new').val(address_new_tmp);
			}
			
		}
	});	

	$('#mkad_in').change(function(){

		var mkad_in = $("#mkad_in option:selected").val();

		if (mkad_in == "out"){
			$("#cost").text("400");
		    $("#cost").val(400);
	
		    var total_price = $("#total_price").val();
	
	        total_price = parseFloat(total_price);
	        cost = 400;
	                	
	        var total_p = total_price + cost;
	        $("#total_p").text(total_p.toFixed(0));
	        $("#cost_span").text("" + cost + " руб.");
	        $("#cost").text(cost);
	        $("#cost").val(cost);
		}
		else{
			$("#cost").text("250");
		    $("#cost").val(250);
	
		    var total_price = $("#total_price").val();
	
	        total_price = parseFloat(total_price);
	        cost = 250;
	                	
	        var total_p = total_price + cost;
	
	        $("#total_p").text(total_p.toFixed(0));
	
	        $("#cost_span").text("" + cost + " руб.");
	
	        $("#cost").text(cost);
	        $("#cost").val(cost);				
		}
	});

});
</script>
{/literal}

{literal}
<script>
$(document).ready(function (){

	var xvf = '{/literal}{$my_destinations->location}{literal}';
	var id_des = '{/literal}{$my_destinations->id}{literal}';	
	var my_dpd_citys = '{/literal}{$my_dpd_citys[0]["cityid"]}{literal}';

	if (xvf == 'Москва'){
	
		$("#cost").text("0");
	    $("#cost").val(0);
	
	    var total_price = $("#total_price").val();
	
	    total_price = parseFloat(total_price);
	    cost = 0;
	            	
	    var total_p = total_price + cost;
	
	    $("#total_p").text(total_p.toFixed(0));
	
	    $("#cost_span").text("" + cost + " руб.");
	
	    $("#cost").text(cost);
	    $("#cost").val(cost);
	}
	 
	if ($('#geo').is(":visible")){
		$('#destination_id :contains("'+xvf+'")').attr("selected", "selected");	
	}

	if (xvf == null){
		if (my_dpd_citys > 0){
	
			//alert(my_dpd_citys);
						
			var r_id = $("#region_dpd option:selected").val();
			var r_name = $("#region_dpd :selected").text();
				
			var s_id = $("#sity_div_new option:selected").val();
			var s_name = $("#sity_div_new :selected").text();
				
			$("#region_1").empty();
			$("#old_sity").empty();
				
			$("#region_1").prepend($('<option value='+r_id+'>'+r_name+'</option>'));
			$("#old_sity").prepend($('<option value='+s_id+'>'+s_name+'</option>'));
				
			$("#region_1 [value='"+r_id+"']").attr("selected", "selected");
			$("#old_sity [value='"+s_id+"']").attr("selected", "selected");
			
			//cost_dpd();
		}
	}
});
</script>
{/literal}

{literal}
	<script>
	$(document).ready(function (){
		window.my_great_d = 0;		
		
		var user_card_h = $("#user_card_h").val();

		if ((user_card_h != '')&&(user_card_h != null)){

				var card_user = user_card_h;
				var email_user = $("#email").val();
				var url_user = 'http://zoo812.ru/files/card_in_cart.php';
	
				$.get(
					url_user,
		            {
		            	'card_user': user_card_h, 'email_user': email_user
		            },
		            function (result){
	
	                    $(result).each(function(){
		                    var is_true = $(this).attr('is_true');
	
		                    if (is_true == true){

		                    	var x = $("#sity_no").prop("checked");
		                    	var y = null;
		                    	
		                    	if ($("#sity_div_new").length > 0){
		                    		var y = $("#sity_div_new").val();
		                    	}
			                    
		                    	if ((x == false)&&(y == null)){                    	
		                    		{/literal}
			                    		{if $cart->purchases}
			                    		{foreach from=$cart->purchases item=purchase}
				                    		{literal}
											var variant_id = {/literal}{$purchase->variant->id}{literal}
											var amount = {/literal}{$purchase->amount}{literal}

											var url_d  = 'http://zoo812.ru/files/discount_for_cart.php';
											 
											$.get(
												url_d,
									            {
									            	'amount': amount, 'email': email_user, 'variant_id': variant_id, 'card_user': card_user
									            },
									            function (result){
								
								                    $(result).each(function(){
									                    var my_d = $(this).attr('discount');
									                    
									                    my_great_d = $("#my_dis_in").val();
									                   	
									                    if (my_great_d == '') my_great_d = 0;
									               				                    
									                    my_great_d = parseFloat(my_d) + parseFloat(my_great_d);
									                  	
									                    $("#my_dis_in").val(my_great_d);
									            		
									                    var total_p = $("#total_price").val();

									                    total_x = total_p - my_great_d;
									                	total_x = Math.round(total_x);	 

									                	var f = Math.round(my_great_d);									                
														
									                	$("#cost_card").text(f);
									                	$("#total_p").text(total_x);
									                	
									                	$("#cost_card_block").show();

								                    });
								                   
									             },
									            "json"
											);
												
											{/literal}
			                    		{/foreach}
			                    		{literal}
			                    		
										
			                    		{/literal}
				                    				                    		
			                    		{/if}
			                    		{literal}
		                    	}
		                    }
	                    });	                    
	
		             },
		            "json"
			    );			    
			
		}
		
	});
	</script>
{/literal}

{literal}

{/literal}


{literal}
<style>
	span.star{
		color: #CD683A;
	}
	
	input.star{
		border: 1px solid #CD683A !important;
	}
	
	input:focus{
		box-shadow: 0 0 10px rgba(0,0,0,0.5);
	}
	
	#dostavka{
		text-align: left;
	    display: block;
		color: #FFF;
		background: #CD683A;
		padding: 10px 22px;
		margin-left: -20px;
		margin-right: -20px;
		font-size: 1.2em !important;
		font-weight: 300;
	}
	
	#dostavka a{
		color: white;
		text-shadow: 1px 2px 1px #AE573B;
		text-decoration: underline;
	}
	
	.usldost{
		background: #CD683A url(/files/uploads/icon-i-40.png) no-repeat 2% 50%;
		padding: 0px 22px;
		margin-left: -20px;
		margin-right: -20px;
		font-weight: 100 !important;
		overflow: hidden;
		display:none;
	}
	
	.usldost a{
		color: #FFF;
		text-shadow: 1px 2px 1px #AE573B;
	}
	
	#ordering{
		display: block;
		border-left: thin solid #CD683A;
		padding-left: 30px;
		margin: 20px 0px;
		color: #CD683A;
		font-size: 26px;
		font-weight: 400;
	}	
	
	#ordering2{
		display: block;		
		margin: 20px 0px;
		color: #424242;
		font-size: 26px;
		font-weight: 400;
	}
	
	.newlable{
		color: #909090 !important;
		font-weight: light;
	}
	
	#ots1{
		margin-top: 7px;
	}
	
	.capbord{
	    border: 2px dashed #CD683A;
		padding-left: 23px !important;
		padding-right: 20px !important;
		padding-bottom: 10px !important;
		margin-left: -10px;
	}
	
	.att1{
		font-size: 1.2em !important;
	}
	
	#txtcap{
		max-width: 150px;
		min-width: 150px;
		width: 150px;
		text-align: center;
		margin-left: 15px;
		margin-top: 6px;
	}
	
	.brdrcap{
		max-width: 150px;
		min-width: 150px;
	    width: 150px;
		margin-left: 15px !important;
		margin-top: 7px !important;
		border: 2px dashed #CD683A !important;
	}
	
	.priutord{
		border-top: thin dashed #CD683A;
		border-bottom: thin dashed #CD683A;
		padding-top: 15px;
		padding-bottom: 10px;
		margin-top: 10px;
		background: url(/files/uploads/icon-catndog-50.png) no-repeat 50% 50%;
	}
	
	.priutord a{
		color: #CD683A !important;
	}
	
	#aleu1 {
		font-size: 16px;
		color: #c16439;
	}

	#aleu2 {
		font-size: 16px;
		color: #424242;
	}
	
	#aleu3 {
	    margin-top: 39px;
		width: 705px;
		min-width: 705px;
		background: #cf6a36;
		margin-left: -20px;
		padding: 20px;
		color: #fff;
		font-size: 1.2em !important;
		margin-bottom: -34px;
	}
	
	#aleu3 a{
		color: white;
		text-decoration: underline;
	}
</style>
{/literal}

{* Шаблон корзины *}
{$meta_title = "Корзина" scope=parent}

<aside class="large-3 medium-3 columns">


	{include file='main_menu.tpl' categories=$categories}
    <!-- Меню каталога (The End)-->
</aside>

<div class="large-9 medium-9 columns" id="page-content">

    {* Содержимое страницы *}
    <div class="row collapse" id="inner">
        <div class="large-12 columns">

			{include file='_inc_main-menu.tpl'}
			<div class="large-12 columns" id="active-page">

                {* Хлебные крошки *}
                <div class="row collapse">
                    <div class="large-12 columns">
                        <div class="lk-breadcrumbs">
                            <span><i class="fa fa-home"></i><a href="/{$settings->sub}">Главная</a></span><span class="divider">&gt;</span><span>Корзина</span>
                        </div>
                    </div>
                </div>

                <div class="row collapse">
                    <div class="large-12 columns">
                        <h1 data-page="Корзина">{if $cart->purchases}В корзине {$cart->total_products} {$cart->total_products|plural:'товар':'товаров':'товара'}
                            {else}В Вашей корзине еще нет товаров...{/if}</h1>
                    </div>
                </div>

                <div>{$smarty.cookies.view}</div>

                {if $cart->purchases}
                
                	<input id="destinations_id"  name="destinations_id" type="hidden" value="{$my_destinations->id}" />                       	
               		<input id="destinations_location"  name="destinations_location" type="hidden" value="{$my_destinations->location}" />
               		<input id="user_card_h"  name="user_card_h" type="hidden" value="{$card}" />
               		
               		<input id="my_dis_in"  name="my_dis_in" type="hidden" value="0" />
               		
               		<input id="my_dpd_citys_id" name="my_dpd_citys_id" type="hidden" value="{$my_dpd_citys[0]['id']}" /> 
               		<input id="my_dpd_citys_cityid" name="my_dpd_citys_cityid" type="hidden" value="{$my_dpd_citys[0]['cityid']}" /> 
               		<input id="my_dpd_citys_countrycode" name="my_dpd_citys_countrycode" type="hidden" value="{$my_dpd_citys[0]['countrycode']}" /> 
               		<input id="my_dpd_citys_countryname" name="my_dpd_citys_countryname" type="hidden" value="{$my_dpd_citys[0]['countryname']}" /> 
                	<input id="my_dpd_citys_regioncode" name="my_dpd_citys_regioncode" type="hidden" value="{$my_dpd_citys[0]['regioncode']}" /> 
                	<input id="my_dpd_citys_regionname" name="my_dpd_citys_regionname" type="hidden" value="{$my_dpd_citys[0]['regionname']}" /> 
                	<input id="my_dpd_citys_cityname" name="my_dpd_citys_cityname" type="hidden" value="{$my_dpd_citys[0]['cityname']}" /> 
                
                    <form method="post" name="cart" id="order-form" onsubmit="yaCounter1646121.reachGoal('CONVERTED_ORDER'); ga('send', 'event', 'Orders', 'Converted Order'); return true;">
             
                    {* Список покупок *}
                    <table id="purchases">

                        {* Заголовок таблицы *}
                        <tr class="table-header">
                            <th>Фото</th>
                            <th>Название товара</th>
                            <th>Цена за ед.</th>
                            <th>Количество</th>
                            <th>Сумма</th>
                            <th>&nbsp;</th>
                        </tr>
						
						{foreach from=$cart->purchases item=purchase}							
                            <tr>
                                {* Изображение товара *}
                                <td class="image" width="10%">
                                    {$image = $purchase->product->images|first}
                                    {if $image}
									
                                        <a href="/products/{$purchase->product->url}/"><img src="{$image->filename|resize:50:50}" alt="{$product->name|escape}"></a>
                                    {/if}
                                </td>

                                {* Название товара *}
                                <td class="name" width="40%">
                                    <a href="/products/{$purchase->product->url}/">{$purchase->product->name|escape}</a>
                                    {$purchase->variant->name|escape}<br>
                                    Арт. <span class="variant_sku">{$purchase->variant->sku}</span>
                                </td>

                                {* Цена за единицу *}
                                <td class="price" width="15%">
                                    {($purchase->variant->price)|convert} руб.
                                </td>
                                
                                {literal}
                                <style>                                
                                	tr, td{
                                		-moz-user-select: none !important;
										-khtml-user-select: none !important;
										user-select: none !important;
                                	}
                                
                                	.amount	.main_amount{
                                		margin: 0 auto;
                                		overflow: hidden;
                                		position: relative;
                                		
                                		width: 135px;
                                		min-width: 135px;
                                		max-width: 135px;
                                		
                                		-webkit-user-select: none;
                                		
                                		-moz-user-select: none !important;
										-khtml-user-select: none !important;
										user-select: none !important;
                                	}
                                
                                	.amount .minus_block,
                                	.amount .select_block,
                                	.amount .plus_block{
                                		float: left;
                                		cursor: pointer; 
                                		
                                		-webkit-user-select: none;
                                		  
                                		-moz-user-select: none !important;
										-khtml-user-select: none !important;
										user-select: none !important;                               	
                                	}
                                	
                                	.amount .minus_block{
                                		width: 30px;
                                		min-width: 30px;
                                		max-width: 30px;
                                		margin-right: 3px;
                                		display: block;
                                		min-height: 22.400px;
                                		max-height: 22.400px;
                                		height: 22.400px;
                                		background: #B1C645 ;
   										border-color: #B1C645;   
   										
   										-webkit-user-select: none;	
   										
   										-moz-user-select: none !important;
										-khtml-user-select: none !important;
										user-select: none !important;   															
                                	}
                                	
                                	.minus_block:HOVER,
                                	.plus_block:HOVER{
                                		background: #C0C0C0 !important;
                                		border-color: #C0C0C0 !important;  	
                                		-moz-user-select: none !important;
										-khtml-user-select: none !important;
										user-select: none !important;	
										
										-webkit-user-select: none;
                                	}
                                	                                	
                                	.amount .select_block{
                                		width: 60px;
                                		min-width: 60px;
                                		max-width: 60px;
                                		margin-right: 3px;
                                		display: block;
                                		height: 22.400px;
                                		
                                		-moz-user-select: none !important;
										-khtml-user-select: none !important;
										user-select: none !important;       
										
										-webkit-user-select: none;
                                	}
                                	                                	
                                	.amount .plus_block{
                                		width: 30px;
                                		min-width: 30px;
                                		max-width: 30px;
                                		display: block;
                                		min-height: 22.400px;
                                		max-height: 22.400px;   
                                		background: #B1C645;
   										border-color: #B1C645;                   		
                                		height: 22.400px;
                                		
                                		-moz-user-select: none !important;
										-khtml-user-select: none !important;
										user-select: none !important;
										
										-webkit-user-select: none;
                                	}
                                	
                                	.amount .plus_block  p,
                                	.amount .minus_block p{
                                		color:    white;
                                		display:  block;
                                		min-width:  2px;
                                		max-width:  2px;
                                		min-height: 2px;
                                		max-height: 2px;                                		
                                		padding:    0;
                                		margin:     0;          		
                                		margin:     0 auto;
                                		float:      none;
                                		clear:      both;
                                		
                                		-moz-user-select: none !important;
										-khtml-user-select: none !important;
										user-select: none !important;
										
										-webkit-user-select: none !important;
                                	}
                                	
                                	.amount .plus_block p{
                                		margin-left: 12px;
                                	}
                                	
                                	input.amount_number{
                                		width: 60px;
                                		min-width: 60px;
                                		max-width: 60px;
                                		text-align: center;                              		
                                		display: table-cell;
                                		vertical-align: middle;
                                		padding: 0px;
                                		height: 22.393px;
                                		min-height: 22.393px;
                                		max-height: 22.393px;
                                	}
                                	
                                	input.fake_amount_number{
                                		width: 60px;
                                		min-width: 60px;
                                		max-width: 60px;
                                		text-align: center;                              		
                                		display: table-cell;
                                		vertical-align: middle;
                                		padding: 0px;
                                		height: 22.393px;
                                		min-height: 22.393px;
                                		max-height: 22.393px;
                                	}
                                	
                                </style>
 								{/literal}
 								 								
                                {* Количество *}
                                <td class="amount" width="20%">
                                	<div class="main_amount">
	                                	<div id="minus_block" data-text="amounts[{$purchase->variant->id}]" data-num="{if $purchase->variant->multiplicity >= 1}{$purchase->variant->multiplicity}{else}1{/if}" class="minus_block"><p>-</p></div>
	                                    <div class="select_block">
	                                    
	                                    	<input class="quantity_cart" type="hidden" class="quantity_cart" name="amount"  value="{if $purchase->variant->multiplicity >= 1}{$purchase->variant->multiplicity}{else}1{/if}" />
	                                    	<input id="fake[{$purchase->variant->id}]" class="fake_amount_number" type="number" data-text="amounts[{$purchase->variant->id}]" data-num="{if $purchase->variant->multiplicity >= 1}{$purchase->variant->multiplicity}{else}1{/if}" value="{$purchase->amount}"  />
	                                    	
	                                    	<input data-text="amount_number[{$purchase->variant->id}]" class="amount_number" type="hidden" value="{$purchase->amount} шт." />                       	
		                                	<select hidden id="amounts[{$purchase->variant->id}]" class="amounts_select" name="amounts[{$purchase->variant->id}]" onchange="document.cart.submit();">
		                                        {section name=amounts start=1 loop=$purchase->variant->stock+1 step=1}
		                                            {if $smarty.section.amounts.index==201}{break}{/if}
													<option value="{$smarty.section.amounts.index}" {if $purchase->amount==$smarty.section.amounts.index}selected{/if}>{$smarty.section.amounts.index} {$settings->units}</option>
		                                        {/section}
		                                    </select>
	                                    </div>
	                                    <div id="plus_block" data-text="amounts[{$purchase->variant->id}]" data-num="{if $purchase->variant->multiplicity >= 1}{$purchase->variant->multiplicity}{else}1{/if}" class="plus_block"><p>+</p></div>
                                    </div>
                                    <div class="clear"></div>
                                </td>

                                {* Цена *}
                                <td class="price" width="10%">
                                    {($purchase->variant->price*$purchase->amount)|convert} руб.
                                </td>
                                
                                {* Удалить из корзины *}
                                <td class="remove" width="5%">
                                    <a href="/cart/remove/{$purchase->variant->id}" title="Удалить товар из списка покупок">
                                        <img src="/design/{$settings->theme|escape}/images/delete.png" alt="Удалить товар из списка покупок" title="Удалить товар из списка покупок">
                                    </a>
                                </td>
                            </tr>
                        {/foreach}
						
                        {if $user->discount}
                            <tr>
                                <th class="image"></th>
                                <th class="name">скидка</th>
                                <th class="price"></th>
                                <th class="amount"></th>
                                <th class="price">
                                    {$user->discount}&nbsp;%
                                </th>
                                <th class="remove"><img src="/design/{$settings->theme|escape}/images/delete.png" alt="Удалить из корзины" title="Удалить из корзины"></th>
                            </tr>
                        {/if}

                        <tr>
                            <th class="image"></th>
                            <th class="name"></th>
                            <th class="price total-price" colspan="4" style="padding-right: 15px; padding-bottom: 15px; font-family: 'Roboto Condensed', 'Roboto', Arial, sans-serif; ">                            	
                                <span id="cost_card_block">Скидка по дисконтной карте друга: <i><b><span id="cost_card">0</span></b> руб.</i><br><br></span>
                                <i></i>
                                <span style="display: block; padding-top: 12px !important;"><span style="color:#a5a179;">Стоимость товаров:</span> <i><b><span id="total_p">{$cart->total_price|convert}</span></b> руб.</i><br></span>
                                <span id="block_pickup_summ" style="display: none; padding-top: 12px !important;"><span style="color:#a5a179;">Стоимость самовывоза:</span> <i><b><span id="total_pickup_summ"></span></b> <span id="ruble">руб.</span></i><br></span>
                                <span id="block_total_price" style="display: none; padding-top: 12px !important;"><span style="color:#a5a179;">Итого стоимость:</span> <i><b><span id="total_summ"></span></b> руб.</i><br></span>

                                
								<input name="weight" id="weight_cart" type="hidden" value="{$cart->weight}" />
                                <input name="volume" id="volume" type="hidden" value="{$cart->volume}" />
                                <input name="total_price" id="total_price" type="hidden" value="{$cart->total_price}" />
                                <input name="cost" id="cost" type="hidden" value="0" />
                                <input name="day" id="day" type="hidden" value="0" />
                                <input name="dpd_coefficient" id="dpd_coefficient" type="hidden" value="{$cart->dpd_coefficient}" />
                            	<input name="dpd_tarif" id="dpd_tarif" type="hidden" value="" />
                            	<input name="pickup_summ" id="pickup_summ" type="hidden" value=""/>
                            	{if $drug_is}
                            		<input name="drug_is" id="drug_is" type="hidden" value="1" />
                            	{/if}
                            	                            	
                            </th>
                        </tr>                 
                    </table>
                    
                    {if $drug_is != true}
                    <div>
                    	<p id="dostavka">
                    		Мы доставляем заказы по всей России. Подробнее на странице <a href="/dostavka/" target="_blank">Доставка товара</a>.
						</p>
					</div>
                    {/if}
					
	{* RetailRocket рекомендательный виджет в корзине *}
	<div data-retailrocket-markup-block="579f5ff865bf190a30929f65"  data-product-id="{foreach from=$cart->purchases item=purchase name=foo}{$purchase->variant->id}{if NOT $smarty.foreach.foo.last},{/if}{/foreach}"></div>

	<div style="padding-bottom: 10px; margin-bottom: 15px; border-bottom: 1px solid #e4e4e4;"></div>
	
					<span id="aleu1">Бесплатная доставка по Санкт-Петербургу и Лен.области при заказе на сумму от 1000 рублей (от 700 рублей при наличии дисконтной карты).</span>
					 
                    <!--- <h2 id="ordering">Оформление заказа</h2> --->
					<h2 id="ordering2">Быстрый заказ</h2>

                    <div class="form cart_form">                  
                        {if $error}	
                            <div data-alert class="alert-box alert radius" style="color: white;">
                            	{if $error == 'phone'} <span style="color: white;">Пожалуйста, укажите Ваш адрес</span>{/if} 
                            	{if $error == 'empty_email'} <span style="color: white;">Пожалуйста, укажите Ваш Электронный адрес</span>{/if} 
                            	{if $error == 'empty_pickuppoint'} <span style="color: white;">Пожалуйста, выберите пункт самовывоза</span>{/if} 

                                <a href="#" class="close">&times;</a>
                            </div>
                        {/if}
                        {if $available_pickuppoints}
							{literal}
							<script>
								$(document).ready(function(){
										$('#type-delivery').attr('checked',true);
										$('#row_pickuppoint').hide();
										
										var tabs = $('#tabs');
										$('.tabs-content > div', tabs).each(function(i){
											if ( i != 0 ) $(this).hide(0);
										});
										
										tabs.on('click', '.tabs input', function(e){	
											
											var tabId = $(this).attr('value');									
											$('.tabs-content > div').hide(0);
											$('#' + tabId).show();
											if (tabId == "delivery"){
												$('#row_pickuppoint').hide();
												$('#block_total_price').hide();
												$('#block_pickup_summ').hide();
											}
											else {
												$('#block_total_price').show();
												$('#block_pickup_summ').show();
												$('#row_pickuppoint').show();
											}
											
										});
										
										var tabs_points = $('#tabs_points');
										$('.tabs-content > div', tabs_points).each(function(i){
											if ( i != 0 ) $(this).hide(0);
										});
										
										tabs_points.on('click', '.tabs_points a', function(e){
											e.preventDefault();
											
											var tabId = $(this).attr('href');
																						
											$('.tabs_points a',tabs_points).removeClass();
											$(this).addClass('active');

											$('#tabs_points .tabs-content > div').hide(0);
											$(tabId).show();
										});
										
									});
									
									function get_from_here(id){											
										//$('#phone').focus();	
										elem = document.getElementById('pickuppoint_address_'+id);
										$('#pickuppoint_selected').val(elem.innerHTML);
										delivery_summ = $('#pickuppoint_delivery_' + id).attr('value');
										calc_delivery_summ(delivery_summ);
										myMap.balloon.close();
									}
									
									function calc_delivery_summ(value){
										elem = document.getElementById('total_pickup_summ');
										elem_total = document.getElementById('total_summ');
										total_summ = $('#total_price').attr('value');
										
										$('#pickup_summ').attr('value', value);
										
										if (!elem){ return false;}
										if (!elem_total){return false;}
										if (delivery_summ == 0){								
											elem.innerHTML = 'Бесплатно';
											$('#ruble').hide();
											elem_total.innerHTML = total_summ;}
										else{
											elem.innerHTML = value;
											$('#ruble').show();
											elem_total.innerHTML = parseInt(total_summ) + parseInt(value);
										}
									}		
							</script>
							<style>
								#tabs li {list-style-type: none; width: 50%; float: left; text-align:center;}
								#tabs .tabs {margin-top: 35px; min-width: 625px; max-width: 625px; width: 625px; overflow: hidden}
								#tabs .tabs-content {padding: 20px; font-size: 16px; line-height: 21px;}
								#tabs .tabs li a {display: block; padding: 8px 16px; font-size: 18px; line-height: 21px; color: #999;}
								#tabs .tabs li a.active, #tabs .tabs li a:hover {color: #369;}	
								.scroll_table .header-row{background:#E1E1E1 !important;}
								.scroll_table .header-row th, .scroll_table td{text-align:center;}		
								#map {height:300px; width: 100%;}
							</style>
							{/literal}
							
							<script>
									ymaps.ready(init);
									var myMap;
									function init () {
										JSONData = JSON.stringify({$available_pickuppointsJSON});
										myMap = new ymaps.Map('map', {
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
							
							<div id="tabs" style="">
									<ul class="tabs">
										<li class="tab"><input id="type-delivery" type="radio" name="deliverytype" value="delivery" checked /><label for="type-delivery"><span></span>Доставка</label></li>
										<li class="tab"><input id="type-pickup" type="radio" name="deliverytype" value="pickup" /><label for="type-pickup"><span></span>Самовывоз</label></li>
									</ul>
									<div class="tabs-content">
										<div id=delivery></div>
										
										<div id=pickup class="available_pickuppoints">
											<div id="tabs_points" style="">
												<ul class="tabs_points">
													<li class="tab"><a class="active" href="#spisok">Списком</a></li>
													<li class="tab"><a href="#onmap">На карте</a></li>
												</ul>
												<div class="tabs-content">
													<div id=spisok>	
														<table class="scroll_table">
															<thead class="fixedHeader">
																<tr class="header-row">
																	<th></th>
																	<th>Метро</th>
																	<th>Адрес</th>
				
																	<th>График работы</th>
																	<th>Макс. вес заказа</th>
																	<th>Стоимость</th>
																</tr>
															</thead>
															<tbody class="scroll_table_content">								
															{foreach from=$available_pickuppoints item=available_pickuppoint}
																<tr>
																	<td><input type="radio" id ="pickuppoint_{$available_pickuppoint->id}" name="available_pickuppoint" value="{$available_pickuppoint->id}" onclick="get_from_here({{$available_pickuppoint->id}})"></input></td>
																	<td>{$available_pickuppoint->metro_station}</td>
																	<td><span id="pickuppoint_address_{$available_pickuppoint->id}">{$available_pickuppoint->address}</span>, тел: {$available_pickuppoint->phone}</td>													
																	<td>{$available_pickuppoint->worktime}</td>
																	<td>{$available_pickuppoint->weight_limit}</td>
																	<td><input type="hidden" id="pickuppoint_delivery_{$available_pickuppoint->id}" value="{$available_pickuppoint->pickup_price_value|convert}"/>{if $available_pickuppoint->pickup_price_value}{$available_pickuppoint->pickup_price_value|convert} руб.{else}Бесплатно{/if}</td>
				
																</tr>
															{/foreach}
															</tbody>
														</table>
													</div>
													<div id=onmap style="overflow: hidden; display: none;">
														<div id=map></div>
													</div>
												</div>
											</div>
										</div>
									</div>
							</div>
						{/if}
                        <script src="design/{$settings->theme}/js/js.jquery.cart.validator.js?ver=2"></script>
						<div class="row collapse">
                            <div class="large-4 columns">
                                <label for="phone"><span class="star">*</span> Телефон</label>
                            </div>
                            <div class="large-8 columns">
                                <input class="star" name="phone" id="phone" type="text" value="{if $phone}{$phone}{else}{$profile->phone|escape}{/if}" placeholder="Например, +7 812 000 00 00" />
                            </div>
                        </div>
						<div class="row collapse validation-block">
                            <div class="large-8 large-offset-4 columns">
                                <div class="validation-error error-empty-phone">
                                    <p>Заполните, пожалуйста, телефон, чтобы мы могли связаться с Вами</p>
                                </div>
                                <div class="validation-error error-mistyped-phone">
                                    <p>Проверьте, пожалуйста, номер телефона</p>
                                </div>
                            </div>
                        </div>

						
						<div class="row collapse">
                            <div class="large-4 columns">
                                <label for="email"><span class="star">*</span>  Электронный адрес</label>
                            </div>
                            <div class="large-8 columns">
                                <input class="star" name="email" type="text" id="email" value="{$email|escape}" placeholder="Например, ivan@kodosov.ru" />
                            </div>
                        </div>
                        <div class="row collapse validation-block">
                            <div class="large-8 large-offset-4 columns">
                                <div class="validation-error error-empty-email">
                                    <p>Заполните, пожалуйста, адрес электронной почты - на него придет сообщение о заказе</p>
                                </div>
                                <div class="validation-error error-mistyped-email">
                                    <p>Проверьте, пожалуйста, правильность адреса электронной почты</p>
                                </div>
                            </div>
                        </div> 
						 {if $available_pickuppoints}
						<div id="row_pickuppoint" class="row collapse">
							<div class="large-4 columns">
                                <label for="pickuppoint_selected"><span class=""></span>  Пункт самовывоза</label>
                            </div>
                            <div class="large-8 columns">
                                <input class="" name="pickuppoint_selected" type="text" id="pickuppoint_selected" value="" readonly/>
                            </div>		
						</div>
						{/if}
                        <div class="row collapse">
                            <div class="large-4 columns">
                                <label for="name"><span class=""></span> Имя, фамилия</label>
                            </div>
                            <div class="large-8 columns">
                                <input class="" name="name" type="text" id="name" value="{$name|escape}" placeholder="Например, Иван Кодосов" />
                            </div>
                        </div>						
                        <div class="row collapse validation-block">
                            <div class="large-8 large-offset-4 columns">
                                <div class="validation-error error-empty-name">
                                    <p>Заполните, пожалуйста, имя и фамилию, чтобы мы знали, как к Вам обращаться (Можно указать никнейм)</p>
                                </div>
                            </div>
                        </div>
                                              
                        
                       
                        {if $drug_is != true}
                        {if $my_destinations->location != null}
                        <div >
                        	                       
                        
	                        {if $my_destinations->location == "Москва"}
	                        
		                   	{/if}
	                   	</div>
	                   	
	                   	 <div style="clear: both;"></div>
	                   	
                        
	                    
                        {elseif $my_dpd_citys[0]['id']}
                        <div id="geo" class="row collapse" style="margin-bottom: 5px;">
                        	<div class="large-4 columns">
	                        	<a style="font-weight: bold; font-family: 'Roboto', 'Roboto Condensed', Arial, sans-serif; color: #4d4d4d; font-weight: bold;" class="change_city">Верно ли определен ваш город?</a>
	                        </div>
                            <div class="large-8 columns" >
                         		<div class="row collapse" >
                         			
                         			<div hidden="hidden">
		                        		<select id="region_dpd" class="region" name="region">
	                            			<option value="{$my_dpd_citys[0]['regioncode']}">{$my_dpd_citys[0]['regionname']}</option>
										</select>
										
										<select id="sity_div_new" class="sity" name="sity">
											<option value="{$my_dpd_citys[0]['cityid']}">{$my_dpd_citys[0]['cityname']}</option>
										</select>
									</div>
									
                            		<a  class="change_city"><b>{$my_dpd_citys[0]['cityname']}</b> <span style="color: #e73b3b; font-weight: bold;"> (Город/Населенный пункт с платной доставкой транспортной компанией DPD)</span></a>
                                	
                            		<p id="delivery_result">Пожалуйста, подождите... считаем...</p>
                                	
                            		<div class="delivery_block" itle="По техническим причинам, доставка возможна только до квартиры.">
		                    			<p id="delivery_result"></p>
		                    			<input  id="apartment" name="apartment" type="checkbox" value="checkbox" checked disabled>
		                    			<label  for="apartment">Доставка службой DPD до квартиры</label>
		                   			</div>
		                 		</div>
		                 	</div>
		                 	
	                     	<div class="row collapse" id="address_dpd">
	                            <div class="large-4 columns">
	                                <label for="address">Адрес доставки (платная доставка)</label>
	                            </div>
	                            <div class="large-8 columns">
	                            	<label for="streetAbbr_dpd">Тип улицы:</label>
	                            	<select name="streetAbbr_dpd" id="streetAbbr_dpd">
	                            		<option value="ул.">Улица</option>
	                            		<option value="пр-кт">Проспект</option>
	                                    <option value="бул.">Бульвар</option>
	                                    <option value="дор.">Дорога</option>
	                                    <option value="маг.">Магистраль</option>
	                                    <option value="наб.">Набережная</option>
	                                    <option value="пер.">Переулок</option>
	                                    <option value="дор.">Площадь</option>
	                                    <option value="пр-д">Проезд</option>
	                                    <option value="ряд">Ряд</option>
	                                    <option value="туп.">Тупик</option>
	                                    <option value="ш.">Шоссе</option>
	                                </select>
	                            	<label for="street_dpd">Название улицы:</label>
	                            	<input name="street_dpd" id="street_dpd" type="text" value="" />
	                            	
	                            	<label for="house_dpd">Номер дома:</label>
	                            	<input name="house_dpd" id="house_dpd" type="text" value="" />
	                            	
	                            	<label for="houseKorpus_dpd">Корпус дома (если есть)</label>
	                            	<input name="houseKorpus_dpd" id="houseKorpus_dpd" type="text" value="" />
	                            	
	                            	<label for="houseApartment_dpd">Номер квартиры:</label>
	                            	<input name="houseApartment_dpd" id="houseApartment_dpd" type="text" value="" />
	                            </div>
	                        </div>
	                    </div>
                        {else}
                                             
                        {/if}                       
                                                                                               
                        <div id="no_geo" style="display: none;">
	                        <div class="row collapse">
	                            <div class="large-4 columns">
	                                <label id="label_for_free_d" for="destination_id">Город/Населенный пункт с <b><span style="color: #CD683A;">бесплатной</span></b> доставкой</label>
	                            </div>
	                            <div class="large-8 columns">
	                                <select class="destination_select_city" name="destination_id" id="destination_id">
	                                    {foreach $destinations as $destination}
	                                    <option data-num="{$destination->price}" class="option_destination" value="{$destination->id}" {if $profile->destination_id}{if $profile->destination_id == $destination->id}selected{/if}{else}{if $destination->id == 3}selected{/if}{/if}>{$destination->location}</option>
	                                    {/foreach}
	                                </select>
	                                <p><input id="sity_no" name="sityno" type="checkbox"><label for="sity_no" style="width: 405px;">Выбор города для платной доставки транспортной компанией DPD по РФ</label></p>
	                            </div>
	                        </div>
	                        
	                         <div class="row collapse">
		                        <div class="in_mkad_block">	                       
				                    <div class="large-4 columns">
			                                <label for="address"><span class="star">*</span> Адрес доставки находится в пределах МКАД?</label>
			                        </div>
			                        <div class="large-8 columns">
				                        <select id="mkad_in">
				                        	<option value="in">В пределах МКАД</option>
				                            <option value="out">За МКАД</option>
				                        </select>
			                    	</div>
			                    </div>
	                   		</div>	                       
	                        
	                        <div id="sity_div" class="row collapse" style="display: none;">
	                        	<div class="large-4 columns">
	                                <label for="region">Город/Населенный пункт с <b><span style="color: #e73b3b;">платной</span></b> доставкой транспортной компанией DPD</label>
	                            </div>
	                            <div class="large-8 columns">
		                        	<div>
		                                <select id="region_1" class="region" name="region">
											<option>(Выберите свой регион тут)</option>
										</select>
		                            </div>
		                            
		                            <div>
		                                <select id="old_sity" class="sity" name="sity">
										</select>
		                            </div>
		                            
		                            <div class="delivery_block" title="По техническим причинам, доставка возможна только до квартиры.">
		                                <p id="delivery_result"></p>
		                                <input  id="apartment" name="apartment" type="checkbox" value="checkbox" checked disabled>
		                                <label  for="apartment">Доставка службой DPD до квартиры</label>
		                            </div>
		                        </div>
	                        	
	                        	<div class="row collapse" id="address_no" style="display: none;">
	                            	<div class="large-4 columns">
	                               		<label for="address">Адрес доставки (платная доставка)</label>
	                            	</div>
	                            	<div class="large-8 columns">
	                            	<label for="streetAbbr_dpd_no">Тип улицы:</label>
		                            	<select name="streetAbbr_dpd_no" id="streetAbbr_dpd_no">
		                            		<option value="ул.">Улица</option>
		                            		<option value="пр-кт">Проспект</option>
		                                    <option value="бул.">Бульвар</option>
		                                    <option value="дор.">Дорога</option>
		                                    <option value="маг.">Магистраль</option>
		                                    <option value="наб.">Набережная</option>
		                                    <option value="пер.">Переулок</option>
		                                    <option value="дор.">Площадь</option>
		                                    <option value="пр-д">Проезд</option>
		                                    <option value="ряд">Ряд</option>
		                                    <option value="туп.">Тупик</option>
		                                    <option value="ш.">Шоссе</option>
		                                </select>
		                            	
		                            	<label for="street_dpd_no">Название улицы:</label>
		                            	<input name="street_dpd_no" id="street_dpd_no" type="text" value="" />
		                            	
		                            	<label for="house_dpd_no">Номер дома:</label>
		                            	<input name="house_dpd_no" id="house_dpd_no" type="text" value="" /> 
		                            	                     	
		                            	<label for="houseKorpus_dpd_no">Корпус дома (если есть)</label>
		                            	<input name="houseKorpus_dpd_no" id="houseKorpus_dpd_no" type="text" value="" />
		                            	
		                            	<label for="houseApartment_dpd_no">Номер квартиры:</label>
		                            	<input name="houseApartment_dpd_no" id="houseApartment_dpd_no" type="text" value="" />
	                            	</div>
 								</div>
 							</div>
	                        <div class="row collapse" id="address_free" >
	                            <div class="large-4 columns">
	                                <label for="address"><span class=""></span> Адрес доставки</label>
	                            </div>
	                            <div class="large-8 columns">
	                                <input class="" name="address_new" id="address_new" type="text" value="{if $drug_is != true}{if $address}{$address}{else}{$profile->address|escape}{/if}{else}АНО «Помощь бездомным собакам» 192148, г. Санкт-Петербург, Большой Смоленский пр. д.7-9, литер А{/if}" placeholder="Например, СПб, ул. Ивана Кодосова, д. 2, кв. 16" />
	                            </div>
	                        </div>
                        </div>
                        {else}
                        					
	                    
	                     
                        {/if}

                        <div class="row collapse validation-block">
                            <div class="large-8 large-offset-4 columns">
                                <div class="validation-error error-empty-address">
                                    <p>Заполните, пожалуйста, адрес доставки</p>
                                </div>
                            </div>
                        </div>
                        
                        <div class="row collapse">
                            <div class="large-4 columns">
                                <label class="" for="order_comment">Комментарий к заказу</label>
                            </div>
                            <div class="large-8 columns">
                                <textarea name="comment" id="order_comment" placeholder="Например, адрес доставки, код скидочной карты или промокод">{if $drug_is != true}{$comment|escape}{else}В приют. Благотворительность.{/if}</textarea>
                            </div>
                        </div>                        
                        
                        
                        {literal}
                        <style>
                        	#gift_tab{
                        		width: 150px;
                        		max-width: 150px;
                        		height: 26px;
                        	}
                        	
                        	#gift_tab:HOVER{
                        		border-bottom: none;
                        	}
                        </style>
                        {/literal}
                                    
                                       
 						{if $drug_is != true}
                       	<div class="row collapse">
                       		<div class="large-12 columns">
                       			<input name="to_drug" id="to_drug" type="checkbox">
                       			<label for="to_drug">Я хочу отправить свой заказ в <a target="_blank" href="/?module=NurseryView">приют</a></label>
                       		</div>
                       	</div>                        
                        {/if}
                        <div class="row oferta" style="">
                        	<input id="oferta" type="checkbox" checked readonly disabled><label for="oferta">Совершая заказ, я даю свое согласие с <a target="_blank" href="/dogovor-oferta-internet-magazina-ivanko-dostavka/">договором публичной оферты</a></label>
                        </div>
						
						
                        {if $user}{else}
                        
                       	{/if}
                       	
                       	{if $user}{else}
                        
                        {/if}
                                                  
                        <div class="row collapse">
                            <div class="large-7 columns capbord" style="height:90px;" >
								<p style="padding: 10px 10px 10px 5px; color: #CD683A; font-size: 16px;">Наш оператор свяжется с Вами в ближайшее время для уточнения адреса, условий и стоимости доставки.</p>
								{if $user}{else}
                                
								{/if}
                            </div>
                            <div class="large-5 columns">	
								<div style="float: left; min-width: 165px; max-width: 165px; width: 165px;">
									
								{if $user}{else}
                                
                                
                                {if $error}
		                        	{if $error == 'captcha'}
			                        	
		                            {/if}
		                        {/if}
								{/if}
		                        </div>
								<div style="float: right; min-width: 275px; max-width: 275px; width: 275px;">
								<input style="font-size: 28px !important; height: 88px; margin-left: 15px; min-width: 270px; max-width: 270px; width: 270px;" id="btn_submit" type="submit" name="checkout" class="button" value="Оформить заказ">
								</div>
								<div style="clear: both;"></div>
                            </div>
                        	
                            <div class="large-12 columns">
								<div class="usldost">									
                            	{if $drug_is != true}
									<p id="alertdist" style="display: block; padding-top: 25px; padding-bottom: 10px; padding-left: 50px; font-size: 15px !important; color: white !important;">
										<b>Сумма минимального заказа для выбранного Вами населенного пункта составляет <span id="cost_selected">1000</span>  рубей</b>
										
										<span class="spb_inf" style="font-size: 15px !important; color: white !important; font-weight: bold;">
											{if $my_destinations->location == 'Санкт-Петербург'}
												(для участников <a href="/diskontnaya-programma/">дисконтной программы Иванко Доставка<a>, для остальных - 1000р)</a>
											{/if}
										</span>.
									</p>
                            	{/if}
								</div>
                            </div>
                        </div>
                        
                        <div style="margin-top: -14px; margin-bottom: -15px;">
                        	<!---<span class="star att1"></span>--->
							<span class="star">*</span>&nbsp;поля обязательные для заполнения</span>
                        </div>	                        
                    </div>
					
					<div id="aleu3">
					
						Наши заказы можно оплатить <a href="/oplata-online/" target="_blank">на сайте</a> или при получении. Подробнее на странице <a href="/oplata-i-vozvrat/" target="_blank">Оплата товара</a>.
					</div>
					
                    </form>
                {else}
                    <div class="row collapse">
                        <div class="large-12 columns" style="float: right; width: 530px; margin-top: 5px; padding: 15px;">
							Цель Вашей персональной корзины - запоминать нужные Вам товары, которые Вы можете купить на нашем сайте<br><br>
						</div>
							
						<div style="float:left; width: 130px;">
							<a href="/" class="button" style=" width: 130px; max-width: 130px;">Вернуться к покупкам</a>
                        </div>
						<div>
							<img src="/temp001/3-pustaya-korzina-ivanko-dostavka-zoo812-ru.jpg" width="665" alt="">
						</div>
                    </div>
                {/if}

            </div>
        </div>
    </div>
</div>

