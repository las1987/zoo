<?php

require_once('api/Simpla.php');
// @FIXME перенести  /files/dpd в /simpla/dpd
require_once('files/dpd/DPD_class.php');

############################################
# Class Product - edit the static section
############################################
class OrderAdmin extends Simpla{
	
	public function fetch(){
		
		if($this->request->method('post')){
			
			$order->id = $this->request->post('id', 'integer');
			$order->name = $this->request->post('name');
			$order->email = $this->request->post('email');
			$order->phone = $this->request->post('phone');
			$order->address = $this->request->post('address');
			$order->comment = $this->request->post('comment');
            $order->card = $this->request->post('card');
			$order->note = $this->request->post('note');
			$order->discount = $this->request->post('discount', 'floatr');
			$order->coupon_discount = $this->request->post('coupon_discount', 'floatr');
			$order->delivery_id = $this->request->post('delivery_id', 'integer');
            $order->destination_id = $this->request->post('destination_id', 'integer');
			$order->delivery_price = $this->request->post('delivery_price', 'float');
			$order->payment_method_id = $this->request->post('payment_method_id', 'integer');
			$order->paid = $this->request->post('paid', 'integer');
			$order->user_id = $this->request->post('user_id', 'integer');
			$order->separate_delivery = $this->request->post('separate_delivery', 'integer');
			$order->weight = $this->request->post('weight', 'weight');
			$order->volume = $this->request->post('volume', 'volume');
			$order->cost_price = $this->request->post('cost_price', 'integer');
			
			if ($this->request->post('drug')){
				$order->drug = 1;
				$order->address = 'АНО «Помощь бездомным собакам» 192148, г. Санкт-Петербург, Большой Смоленский пр. д.7-9, литер А';
			}
			else{
				$order->drug = 0;
				if ($order->address == 'АНО «Помощь бездомным собакам» 192148, г. Санкт-Петербург, Большой Смоленский пр. д.7-9, литер А'){
					$order->address = 'Измените адрес на адрес клиента';
				}
			}
					
			$my_order = $this->orders->get_order($order->id);
			$my_drug = $my_order->drug;		
			
			if ($my_drug == 1){
			
				$order_pay = $this->request->post('pay');
							
				if ($order_pay == '1'){
					$order->pay = 1;
					$drug_is = true;
					$this->design->assign('drug_is', $drug_is);
				}
				else{
					$order->pay = 0;
					$drug_is = true;
					$this->design->assign('drug_is', $drug_is);
				}
			}	
			
			$new_cost         = $this->request->post('new_cost');
			$new_day          = $this->request->post('new_day');
			$dpd_tarif        = $this->request->post('dpd_tarif');
			$new_city         = $this->request->post('new_city');
			$new_to_apartment = $this->request->post('new_to_apartment');
			
			if (($new_cost != null)and($new_cost != 0)){
				$order->cost_price = $new_cost;
			}
			
			if (($new_day != null)and($new_day != 0)){
				$order->day_to_dpd = $new_day;
			}
			
			if (($dpd_tarif != null)and($dpd_tarif != 0)){
				$order->dpd_tarif = $dpd_tarif;
			}
			
			if (($new_city != null)and($new_city != 0)){
				$order->city_id_dpd = $new_city;
			}
			
			if (($new_to_apartment != null)and($new_to_apartment != 0)){
				$order->to_apartment = $new_to_apartment;
			}

			$order->streetAbbr_dpd          = $this->request->post('streetAbbr_dpd');
			$order->street_dpd              = $this->request->post('street_dpd');
			$order->house_dpd               = $this->request->post('house_dpd');
			$order->houseKorpus_dpd         = $this->request->post('houseKorpus_dpd');
			$order->houseApartment_dpd      = $this->request->post('houseApartment_dpd');
			
			$str_city = $this->request->post('sity');
			 
			$simpla_tmp = new Simpla();
			$db_server = $simpla_tmp->config->db_server;
			$db_user = $simpla_tmp->config->db_user;
			$db_password = $simpla_tmp->config->db_password;
			$db_name = $simpla_tmp->config->db_name;
			 
			$mysqli = new mysqli($db_server, $db_user, $db_password, $db_name);
			 
			$mysqli->set_charset("utf8");
			
			if ($result = $mysqli->query("SELECT * FROM `s_city` WHERE `cityid`='$str_city' LIMIT 1")){
				while($r=$result->fetch_assoc()){
					$str_city_name = $r['cityname'];
				}
			}
			 
			$result->close();
			
			if (($order->street_dpd != null) and ($order->street_dpd != "") and ($order->street_dpd  != " ")){
				if ($order->houseKorpus_dpd != NULL){
					$order->address = "г. $str_city_name $order->streetAbbr_dpd $order->street_dpd дом $order->house_dpd корпус $order->houseKorpus_dpd кв. $order->houseApartment_dpd";
				}
				else{				
					$order->address = "г. $str_city_name $order->streetAbbr_dpd $order->street_dpd дом $order->house_dpd $order->houseKorpus_dpd кв. $order->houseApartment_dpd";
				}
			}
			
			$time_now = date('d-m-Y H:i:s');
			$admin_name = $_SERVER['PHP_AUTH_USER'];			
			$admin_log  = $this->request->post('admin_log');
			$admin_log = trim($admin_log);
			
			//лол
			$admin_log = $admin_log;		
			$info = $time_now.' '.$admin_name;
			$admin_log = "$info $admin_log";
			
			$order->admin_log = $admin_log;			

	 		if(!$order_labels = $this->request->post('order_labels'))
	 			$order_labels = array();

			if(empty($order->id))
			{
  				$order->id = $this->orders->add_order($order);
				$this->design->assign('message_success', 'added');
  			}
    		else
    		{
    			$this->orders->update_order($order->id, $order);
				$this->design->assign('message_success', 'updated');
    		}	

	    	$this->orders->update_order_labels($order->id, $order_labels);
			
			if($order->id)
			{
				
				
				if ($order->drug == 1){
					$drug_is = true;
					$this->design->assign('drug_is', $drug_is);						
				}

				// Покупки
				$purchases = array();
				if($this->request->post('purchases')){
					foreach($this->request->post('purchases') as $n=>$va) foreach($va as $i=>$v)
						$purchases[$i]->$n = $v;
				}		
				$posted_purchases_ids = array();
				foreach($purchases as $purchase)
				{
					$variant = $this->variants->get_variant($purchase->variant_id);

					if(!empty($purchase->id))
						if(!empty($variant))
							$this->orders->update_purchase($purchase->id, array('variant_id'=>$purchase->variant_id, 'variant_name'=>$variant->name, 'price'=>$purchase->price, 'amount'=>$purchase->amount));
						else
							$this->orders->update_purchase($purchase->id, array('price'=>$purchase->price, 'amount'=>$purchase->amount));
					else
						$purchase->id = $this->orders->add_purchase(array('order_id'=>$order->id, 'variant_id'=>$purchase->variant_id, 'variant_name'=>$variant->name, 'price'=>$purchase->price, 'amount'=>$purchase->amount));
						
					$posted_purchases_ids[] = $purchase->id;
				}
				
				// Удалить непереданные товары
				foreach($this->orders->get_purchases(array('order_id'=>$order->id)) as $p)
					if(!in_array($p->id, $posted_purchases_ids))
						$this->orders->delete_purchase($p->id);
					
				// Принять?
				if($this->request->post('status_new'))
					$new_status = 0;
				elseif($this->request->post('status_accept'))
					$new_status = 1;
				elseif($this->request->post('status_done'))
					$new_status = 2;
				elseif($this->request->post('status_deleted'))
					$new_status = 3;
				else
					$new_status = $this->request->post('status', 'string');
	
				if($new_status == 0)					
				{
					if(!$this->orders->open(intval($order->id)))
						$this->design->assign('message_error', 'error_open');
					else
						$this->orders->update_order($order->id, array('status'=>0));
				}
				elseif($new_status == 1)					
				{
					if(!$this->orders->close(intval($order->id)))
						$this->design->assign('message_error', 'error_closing');
					else
						$this->orders->update_order($order->id, array('status'=>1));
				}
				elseif($new_status == 2)					
				{
					if(!$this->orders->close(intval($order->id)))
						$this->design->assign('message_error', 'error_closing');
					else
						$this->orders->update_order($order->id, array('status'=>2));
				}
				elseif($new_status == 3)					
				{
					if(!$this->orders->open(intval($order->id)))
						$this->design->assign('message_error', 'error_open');
					else
						$this->orders->update_order($order->id, array('status'=>3));
					header('Location: '.$this->request->get('return'));
				}
				$order = $this->orders->get_order($order->id);
	
				// Отправляем письмо пользователю
				if($this->request->post('notify_user'))
					$this->notify->email_order_user($order->id);
			}

		}
		else
		{
			//@FIXME отрефакторить - тут внезапно появился объект
            if ( !isset($order) || !is_object( $order ) ) {
                $order = new stdClass();
            }
		    $order->id = $this->request->get('id', 'integer');
			$order = $this->orders->get_order(intval($order->id));
			if ($order->drug == 1){
				$drug_is = true;
				$this->design->assign('drug_is', $drug_is);
			}
			// Метки заказа
			$order_labels = array();
			if(isset($order->id))
			foreach($this->orders->get_order_labels($order->id) as $ol)
				$order_labels[] = $ol->id;			
		}


		$subtotal = 0;
		$purchases_count = 0;
		if($order && $purchases = $this->orders->get_purchases(array('order_id'=>$order->id)))
		{
			// Покупки
			$products_ids = array();
			$variants_ids = array();
			foreach($purchases as $purchase)
			{
				$products_ids[] = $purchase->product_id;
				$variants_ids[] = $purchase->variant_id;
			}
			
			$products = array();
			foreach($this->products->get_products(array('id'=>$products_ids)) as $p)
				$products[$p->id] = $p;
	
			$images = $this->products->get_images(array('product_id'=>$products_ids));		
			foreach($images as $image)
				$products[$image->product_id]->images[] = $image;
			
			$variants = array();
			foreach($this->variants->get_variants(array('product_id'=>$products_ids)) as $v)
				$variants[$v->id] = $v;
			
			foreach($variants as $variant)
				if(!empty($products[$variant->product_id]))
					$products[$variant->product_id]->variants[] = $variant;
	
			foreach($purchases as &$purchase)
			{
				if(!empty($products[$purchase->product_id]))
					$purchase->product = $products[$purchase->product_id];
				
				if(!empty($variants[$purchase->variant_id]))
					$purchase->variant = $variants[$purchase->variant_id];
				
				$subtotal += $purchase->price*$purchase->amount;
				$purchases_count += $purchase->amount;
			}			
		}
		else
		{
			$purchases = array();
		}
		
		// Если новый заказ и передали get параметры
		if(empty($order->id))
		{
			if(empty($order->phone))
				$order->phone = $this->request->get('phone', 'string');
			if(empty($order->name))
				$order->name = $this->request->get('name', 'string');
			if(empty($order->address))
				$order->address = $this->request->get('address', 'string');
			if(empty($order->email))
				$order->email = $this->request->get('email', 'string');
		}
		
		/*
		$this->design->assign('serviceCode', $serviceCode);
		$this->design->assign('serviceName', $serviceName);
		$this->design->assign('cost', $cost);
		$this->design->assign('days', $days);*/
		
		$data_now = date('Y-m-d');
		
		$this->design->assign('data_now', $data_now);
		$this->design->assign('purchases', $purchases);
		$this->design->assign('purchases_count', $purchases_count);
		$this->design->assign('subtotal', $subtotal);
		$this->design->assign('order', $order);

		if(!empty($order->id)){			
			// Способ доставки
			$delivery = $this->delivery->get_delivery($order->delivery_id);
			$this->design->assign('delivery', $delivery);
	
			// Способ оплаты
			$payment_method = $this->payment->get_payment_method($order->payment_method_id);
			
			if(!empty($payment_method)){
				$this->design->assign('payment_method', $payment_method);
		
				// Валюта оплаты
				$payment_currency = $this->money->get_currency(intval($payment_method->currency_id));
				$this->design->assign('payment_currency', $payment_currency);
			}
			
			// Пользователь
			if($order->user_id)
				$this->design->assign('user', $this->users->get_user(intval($order->user_id)));
	
			// Соседние заказы
			$this->design->assign('next_order', $this->orders->get_next_order($order->id, $this->request->get('status', 'string')));
			$this->design->assign('prev_order', $this->orders->get_prev_order($order->id, $this->request->get('status', 'string')));
		}
		
		if ($order->city_id_dpd != NULL){
			$simpla_new = new Simpla();
			$db_host = $simpla_new->config->db_server;
			$db_user = $simpla_new->config->db_user;
			$db_pass = $simpla_new->config->db_password;
			$db_database = $simpla_new->config->db_name;
			
			$connection = new mysqli($db_host, $db_user, $db_pass, $db_database);
			$connection->set_charset("utf8");
			
			$cityname = $regioncode = $regionname = '';
			
			$city_id = $order->city_id_dpd;
			
			if ($result_city = mysqli_query($connection, "SELECT * FROM `s_city` WHERE `cityid`='$city_id' LIMIT 1")){
				while($city=$result_city->fetch_assoc()){
					$cityname = $city['cityname'];
					$regioncode = $city['regioncode'];
					$regionname = $city['regionname'];
				}
			}
			
			$result_city->close();
			
			$order->cityname = $cityname;
			$order->regioncode = $regioncode;
			$order->regionname = $regionname;

			mysqli_close($connection);
		}

		// Все способы доставки
		$deliveries = $this->delivery->get_deliveries();
		$this->design->assign('deliveries', $deliveries);
		
        // Cities
        $destinations = $this->destinations->get_destinations();
        $this->design->assign('destinations', $destinations);
		
		// Все способы оплаты
		$payment_methods = $this->payment->get_payment_methods();
		$this->design->assign('payment_methods', $payment_methods);
		
		// Метки заказов
	  	$labels = $this->orders->get_labels();
	 	$this->design->assign('labels', $labels);
	  	
	 	$this->design->assign('order_labels', $order_labels);
	 	
	 	//echo "<pre>";
	 	//print_r($purchases);
	 	//echo "</pre>";

		if($this->request->get('view') == 'print'){
			
			$my_purchases_array = null;
			$my_purchases_array = array();
			
			foreach($purchases as $pu){
			
				$purchase_variant_id = $pu->variant_id;
				$action_status = false;
				
				$simpla_action = new Simpla();
				$db_server = $simpla_action->config->db_server;
				$db_user = $simpla_action->config->db_user;
				$db_password = $simpla_action->config->db_password;
				$db_name = $simpla_action->config->db_name;
				
				$mysqli_action = new mysqli($db_server, $db_user, $db_password, $db_name);
				
				$mysqli_action->set_charset("utf8");
								
				if ($result_action = $mysqli_action->query("SELECT * FROM `s_promo_variants` WHERE `variant_id`='$purchase_variant_id'")){
					while($purchase_action = $result_action->fetch_assoc()){
						if 	(($purchase_action['promo_id'] != '')and($purchase_action['promo_id'] != null)){
							
							$go = true;
							
							foreach ($my_purchases_array as $old_array){
								if ($old_array['variant_id'] ==  $pu->variant_id) $go = false;
							}
														
							if ($go){
								$my_purchases_array[]= array(
									'id' => $pu->id,
									'variant_id' => $purchase_action['variant_id'],
									'promo_id' => $purchase_action['promo_id'],
									 'action_status' => '1'
								);
								
								$old_array[$purchase_action['variant_id']] = $purchase_action['variant_id'];
							}									
						}
					}
				}
				
				$mysqli_action->close();
			}
			
			//echo "<pre>";
			//print_r($my_purchases_array);
			//echo "</pre>";
						
			$this->design->assign('my_purchases_array', $my_purchases_array);

			
			
 		  	return $this->design->fetch('order_print.tpl');
		}
		elseif($this->request->get('view') == 'mass_print'){
			return $this->design->fetch('order_mass_print.tpl');
		}
 	  	else
	 	  	return $this->design->fetch('order.tpl');
	}
}