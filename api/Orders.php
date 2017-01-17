<?php

/**
 * Simpla CMS
 *
 * @copyright	2011 Denis Pikusov
 * @link		http://simplacms.ru
 * @author		Denis Pikusov
 *
 * статусы заказов:
 * 0 - новый
 * 1 - в обработке
 * 2 - выполнен
 * 3 - аннулирован
 *
 */

require_once('Simpla.php');

class Orders extends Simpla{

    /**
     * возвращает разницу между датами в днях
     *
     * @param string $date_from
     * @param string $date_till
     * @return float|int
     */
    public function get_duration($date_from, $date_till){
		$date_from = explode('-', $date_from);
		$date_till = explode('-', $date_till);
		
		$time_from = mktime(0, 0, 0, $date_from[1], $date_from[2], $date_from[0]);
		$time_till = mktime(0, 0, 0, $date_till[1], $date_till[2], $date_till[0]);
		
		$diff = ($time_till - $time_from)/86400; // 60*60*24 - сутки
		//$diff = date('d', $diff); - как делал))
		
		return $diff;
	}
	
	public function update_order_status(){
		static $flag = true;

        // Maus: я считаю ,что повторные запуски этого метода не нужны
        if ( $flag ) {
            $flag = false;

            $d = getdate();
            //$day_now_for_main_action = "";

            $day_now_g = sprintf('%04u-%02u-%02u', $d['year'], $d['mon'], $d['mday']);
            //$day_now = $day_now_g.sprintf(' %02u:%02u:%02u', $d['hours'], $d['minutes'], $d['seconds'] );

            $simpla_new1 = new Simpla();
            $db_host = $simpla_new1->config->db_server;
            $db_user = $simpla_new1->config->db_user;
            $db_pass = $simpla_new1->config->db_password;
            $db_database = $simpla_new1->config->db_name;

            $mysqli = new mysqli($db_host, $db_user, $db_pass, $db_database);
            $mysqli->set_charset("utf8");

            /*
             * все заказы "в обработке", которые не изменялись более 5 дней, автоматом переводятся в статус "завершено"
             * @FIXME это всё можно переписать в 1 UPDATE-запрос
             */
            if ($result_orders   = $mysqli->query("SELECT `id`,`modified` FROM `s_orders` WHERE `status`=1")){
                while($my_order = $result_orders->fetch_assoc()){

                    $modified = $my_order['modified'];
                    $modified_g = substr($modified, 0, 10);

                    $diff_d = $this->get_duration($modified_g, $day_now_g);

                    if ($diff_d > 5){
                        $id = $my_order['id'];
                        $this->update_order($id, array('status'=>2));
                    }

                }
            }

            $mysqli->close();
        }
	}
	
	 

	public function get_order($id){
		
		if(is_int($id))
			$where = $this->db->placehold(' WHERE o.id=? ', intval($id));
		else
			$where = $this->db->placehold(' WHERE o.url=? ', $id);
		
		$query = $this->db->placehold("SELECT o.id, o.id_new, o.delivery_id, o.city_id_dpd, o.delivery_price, o.separate_delivery,
										o.payment_method_id, o.paid, o.payment_date, o.closed, o.discount, o.coupon_code, o.coupon_discount,
										o.date, o.user_id, o.name, o.address, o.phone, o.email, o.comment, o.status,
										o.url, o.total_price, o.discount_price_promo, o.cost_price, o.dpd_tarif, o.note, o.card, o.destination_id, o.volume, o.weight, o.streetAbbr_dpd,
										o.street_dpd, o.house_dpd, o.houseKorpus_dpd, o.houseApartment_dpd, o.to_apartment, o.day_to_dpd, o.promokod, o.drug, o.pay, o.update_type, o.admin_log, d.location as location
										FROM __orders o LEFT JOIN __destinations d on o.destination_id = d.id  $where LIMIT 1");

		if($this->db->query($query))
			return $this->db->result();
		else
			return false;
	}
	
	function get_orders($filter = array()){
		
		// По умолчанию
		$limit = 100;
		$page = 1;
		$keyword_filter = '';
		$label_filter = '';	
		$status_filter = '';
		$user_filter = '';
		$modified_from_filter = '';
		$id_filter = '';
		
		if(isset($filter['limit']))
			$limit = max(1, intval($filter['limit']));

		if(isset($filter['page']))
			$page = max(1, intval($filter['page']));

		$sql_limit = $this->db->placehold(' LIMIT ?, ? ', ($page-1)*$limit, $limit);
		
		if(isset($filter['status']))
			$status_filter = $this->db->placehold('AND o.status = ?', intval($filter['status']));
		
		if(isset($filter['id']))
			$id_filter = $this->db->placehold('AND o.id in(?@)', (array)$filter['id']);
		
		if(isset($filter['user_id']))
			$user_filter = $this->db->placehold('AND o.user_id = ?', intval($filter['user_id']));
		
		if(isset($filter['modified_from']))
			$modified_from_filter = $this->db->placehold('AND o.modified > ?', $filter['modified_from']);
		
		if(isset($filter['label']))
			$label_filter = $this->db->placehold('AND ol.label_id = ?', $filter['label']);
		
		if(!empty($filter['keyword']))
		{
			$keywords = explode(' ', $filter['keyword']);
			foreach($keywords as $keyword)
				$keyword_filter .= $this->db->placehold('AND (o.name LIKE "%'.mysql_real_escape_string(trim($keyword)).'%" OR REPLACE(o.phone, "-", "")  LIKE "%'.mysql_real_escape_string(str_replace('-', '', trim($keyword))).'%" OR o.id LIKE "%'.mysql_real_escape_string(trim($keyword)).'%" OR o.id_new LIKE "%'.mysql_real_escape_string(trim($keyword)).'%" OR o.address LIKE "%'.mysql_real_escape_string(trim($keyword)).'%" )');
		}
		
		// Выбираем заказы
		$query = $this->db->placehold("SELECT o.id, o.id_new, o.delivery_id, o.city_id_dpd, o.delivery_price, o.separate_delivery,
										o.payment_method_id, o.paid, o.payment_date, o.closed, o.discount, o.coupon_code, o.coupon_discount,
										o.date, o.user_id, o.name, o.address, o.phone, o.email, o.comment, o.status,
										o.url, o.total_price, o.discount_price_promo, o.cost_price, o.dpd_tarif, o.note, o.card, o.weight, o.volume, o.update_type, 
										o.streetAbbr_dpd, o.street_dpd, o.house_dpd, o.houseKorpus_dpd, o.houseApartment_dpd, o.to_apartment, o.day_to_dpd, o.promokod, o.drug, o.pay, o.admin_log, d.location as location
									FROM __orders AS o 
									LEFT JOIN __orders_labels AS ol ON o.id=ol.order_id
									LEFT JOIN __destinations d on o.destination_id = d.id 
									WHERE 1
									$id_filter $status_filter $user_filter $keyword_filter $label_filter $modified_from_filter GROUP BY o.id ORDER BY status, id DESC $sql_limit", "%Y-%m-%d");
		$this->db->query($query);
		$orders = array();
		foreach($this->db->results() as $order)
			$orders[$order->id] = $order;
		return $orders;
	}

	function count_orders($filter = array())
	{
		$keyword_filter = '';
		$label_filter = '';
		$status_filter = '';
		$user_filter = '';
		
		if(isset($filter['status']))
			$status_filter = $this->db->placehold('AND o.status = ?', intval($filter['status']));
		
		if(isset($filter['user_id']))
			$user_filter = $this->db->placehold('AND o.user_id = ?', intval($filter['user_id']));

		if(isset($filter['label']))
			$label_filter = $this->db->placehold('AND ol.label_id = ?', $filter['label']);
		
		if(!empty($filter['keyword']))
		{
			$keywords = explode(' ', $filter['keyword']);
			foreach($keywords as $keyword)
				$keyword_filter .= $this->db->placehold('AND (o.name LIKE "%'.mysql_real_escape_string(trim($keyword)).'%" OR REPLACE(o.phone, "-", "")  LIKE "%'.mysql_real_escape_string(str_replace('-', '', trim($keyword))).'%" OR o.address LIKE "%'.mysql_real_escape_string(trim($keyword)).'%" )');
		}
		
		// Выбираем заказы
		$query = $this->db->placehold("SELECT COUNT(DISTINCT id) as count
									FROM __orders AS o 
									LEFT JOIN __orders_labels AS ol ON o.id=ol.order_id 
									WHERE 1
									$status_filter $user_filter $label_filter $keyword_filter");
		$this->db->query($query);
		return $this->db->result('count');
	}

	public function update_order($id, $order)
	{
		$query = $this->db->placehold("UPDATE __orders SET ?%, modified=now() WHERE id=? LIMIT 1", $order, intval($id));
		$this->db->query($query);
		$this->update_total_price(intval($id));
		return $id;
	}

	public function delete_order($id)
	{
		if(!empty($id))
		{
			$query = $this->db->placehold("DELETE FROM __purchases WHERE order_id=?", $id);
			$this->db->query($query);
			
			$query = $this->db->placehold("DELETE FROM __orders WHERE id=? LIMIT 1", $id);
			$this->db->query($query);
		}
	}
	
	public function add_order($order)
	{
		$order = (object)$order;
		$order->url = md5(uniqid($this->config->salt, true));
		$set_curr_date = '';
		if(empty($order->date))
			$set_curr_date = ', date=now()';
		$query = $this->db->placehold("INSERT INTO __orders SET ?%$set_curr_date", $order);
		$this->db->query($query);
		$id = $this->db->insert_id();		
		return $id;
	}

	public function get_label($id)
	{
		$query = $this->db->placehold("SELECT * FROM __labels WHERE id=? LIMIT 1", intval($id));
		$this->db->query($query);
		return $this->db->result();
	}

	public function get_labels()
	{
		$query = $this->db->placehold("SELECT * FROM __labels ORDER BY position");
		$this->db->query($query);
		return $this->db->results();
	}

	/*
	*
	* Создание метки заказов
	* @param $label
	*
	*/	
	public function add_label($label)
	{
		$query = $this->db->placehold('INSERT INTO __labels SET ?%', $label);
		if(!$this->db->query($query))
			return false;

		$id = $this->db->insert_id();
		$this->db->query("UPDATE __labels SET position=id WHERE id=?", $id);	
			return $id;
	}

	/*
	*
	* Обновить метку
	* @param $id, $label
	*
	*/	
	public function update_label($id, $label)
	{
		$query = $this->db->placehold("UPDATE __labels SET ?% WHERE id in(?@) LIMIT ?", $label, (array)$id, count((array)$id));
		$this->db->query($query);
		return $id;
	}

	/*
	*
	* Удалить метку
	* @param $id
	*
	*/	
	public function delete_label($id)
	{
		if(!empty($id))
		{
			$query = $this->db->placehold("DELETE FROM __orders_labels WHERE label_id=?", intval($id));
			if($this->db->query($query))
			{
				$query = $this->db->placehold("DELETE FROM __labels WHERE id=? LIMIT 1", intval($id));
				return $this->db->query($query);
			}
		}
        return false;
	}	
	
	function get_order_labels($order_id = array())
	{
		if(empty($order_id))
			return array();

		$label_id_filter = $this->db->placehold('AND order_id in(?@)', (array)$order_id);
				
		$query = $this->db->placehold("SELECT ol.order_id, l.id, l.name, l.color, l.position
					FROM __labels l LEFT JOIN __orders_labels ol ON ol.label_id = l.id
					WHERE 
					1
					$label_id_filter   
					ORDER BY position       
					");
		
		$this->db->query($query);
		return $this->db->results();
	}
	
	public function update_order_labels($id, $labels_ids)
	{
		$labels_ids = (array)$labels_ids;
		$query = $this->db->placehold("DELETE FROM __orders_labels WHERE order_id=?", intval($id));
		$this->db->query($query);
		if(is_array($labels_ids))
		foreach($labels_ids as $l_id)
			$this->db->query("INSERT INTO __orders_labels SET order_id=?, label_id=?", $id, $l_id);
	}

	public function add_order_labels($id, $labels_ids)
	{
		$labels_ids = (array)$labels_ids;
		if(is_array($labels_ids))
		foreach($labels_ids as $l_id)
		{
			$this->db->query("INSERT IGNORE INTO __orders_labels SET order_id=?, label_id=?", $id, $l_id);
		}
	}

	public function delete_order_labels($id, $labels_ids)
	{
		$labels_ids = (array)$labels_ids;
		if(is_array($labels_ids))
		foreach($labels_ids as $l_id)
			$this->db->query("DELETE FROM __orders_labels WHERE order_id=? AND label_id=?", $id, $l_id);
	}


	public function get_purchase($id)
	{
		$query = $this->db->placehold("SELECT * FROM __purchases WHERE id=? LIMIT 1", intval($id));
		$this->db->query($query);
		return $this->db->result();
	}

	public function get_purchases($filter = array())
	{
		$order_id_filter = '';
		if(!empty($filter['order_id']))
			$order_id_filter = $this->db->placehold('AND order_id in(?@)', (array)$filter['order_id']);

		$query = $this->db->placehold("SELECT * FROM __purchases WHERE 1 $order_id_filter ORDER BY id");
		$this->db->query($query);
		return $this->db->results();
	}
	
	public function update_purchase($id, $purchase)
	{	
		$purchase = (object)$purchase;
		$old_purchase = $this->get_purchase($id);
		if(!$old_purchase)
			return false;
			
		$order = $this->get_order(intval($old_purchase->order_id));
		if(!$order)
			return false;
			
		// Если заказ закрыт, нужно обновить склад при изменении покупки
		if($order->closed && !empty($purchase->amount))
		{
			if($old_purchase->variant_id != $purchase->variant_id)
			{
				if(!empty($old_purchase->variant_id))
				{
					$query = $this->db->placehold("UPDATE __variants SET stock=stock+? WHERE id=? AND stock IS NOT NULL LIMIT 1", $old_purchase->amount, $old_purchase->variant_id);
					$this->db->query($query);
				}
				if(!empty($purchase->variant_id))
				{
					$query = $this->db->placehold("UPDATE __variants SET stock=stock-? WHERE id=? AND stock IS NOT NULL LIMIT 1", $purchase->amount, $purchase->variant_id);
					$this->db->query($query);
				}
			}
			elseif(!empty($purchase->variant_id))
			{
				$query = $this->db->placehold("UPDATE __variants SET stock=stock+(?) WHERE id=? AND stock IS NOT NULL LIMIT 1", $old_purchase->amount - $purchase->amount, $purchase->variant_id);
				$this->db->query($query);
			}
		}
		
		$query = $this->db->placehold("UPDATE __purchases SET ?% WHERE id=? LIMIT 1", $purchase, intval($id));
		$this->db->query($query);
		$this->update_total_price($order->id);		
		return $id;
	}
	
	public function add_purchase($purchase, $card_of_friend = NULL){
		
		$purchase = (object)$purchase;
		if(!empty($purchase->variant_id)){
			$variant = $this->variants->get_variant($purchase->variant_id);
			if(empty($variant))
				return false;
			$product = $this->products->get_product(intval($variant->product_id));
			if(empty($product))
				return false;
		}			

		$order = $this->get_order(intval($purchase->order_id));
		if(empty($order))
			return false;
		
		if(!isset($purchase->product_id) && isset($variant))
			$purchase->product_id = $variant->product_id;
			
		if(!isset($purchase->product_name)  && !empty($product))
			$purchase->product_name = $product->new_name;
		
		if(!isset($purchase->sku) && !empty($variant))
			$purchase->sku = $variant->sku;
		
		if(!isset($purchase->weight) && !empty($variant))
			$purchase->weight = $variant->weight;
		
		if(!isset($purchase->width) && !empty($variant))
			$purchase->width = $variant->width;
		
		if(!isset($purchase->length) && !empty($variant))
			$purchase->length = $variant->length;
		
		if(!isset($purchase->height) && !empty($variant))
			$purchase->height = $variant->height;
		
		if(!isset($purchase->volume) && !empty($variant)){
		
			$width = $variant->width;
			$length = $variant->length;
			$height = $variant->height;
			
			if ( !is_numeric($width) ) $width = 0;
			if ( !is_numeric($length) ) $length = 0;
			if ( !is_numeric($height) ) $height = 0;
			
			$volume = $width*$height*$length;
			$volume = round($volume, 4);
			
			$purchase->volume = $volume;
		}
		
		if(!isset($purchase->variant_name) && !empty($variant))
			$purchase->variant_name = $variant->name;

		if(!isset($purchase->price) && !empty($variant)){
			
			$variant_id = $variant->id;
			$promo_url = $variant->action_url;
			
			$prm = $this->promos->sku_in_promo_no_url($variant_id);
			$price = $variant->price;
			
			if (($prm != false)&&(!empty($prm))){
			
				$type = $prm[0]['type'];
				$discount = $prm[0]['discount'];
				
				if ($type == 1){
					$price_new = $price - $price * $discount / 100;
					$price = $price_new;
				}
			}
						
			$purchase->price = $price;
		}
		
		if(!isset($purchase->amount))
			$purchase->amount = 1;
		
		// Если заказ закрыт, нужно обновить склад при добавлении покупки
		if($order->closed && !empty($purchase->amount) && !empty($variant->id)){
			$stock_diff = $purchase->amount;
			$query = $this->db->placehold("UPDATE __variants SET stock=stock-? WHERE id=? AND stock IS NOT NULL LIMIT 1", $stock_diff, $variant->id);
			$this->db->query($query);
		}
		
		// Добавляем категории categorie3_name + categorie1_name
		$simpla_new = new Simpla();
		$db_host = $simpla_new->config->db_server;
		$db_user = $simpla_new->config->db_user;
		$db_pass = $simpla_new->config->db_password;
		$db_database = $simpla_new->config->db_name;
				
		$category_id = 0;
		$product_id = 0;
			
		$categorie1_name = $categorie2_name = $categorie3_name = $categorie4_name = $cat_name = '';

		$mysqli4 = new mysqli($db_host, $db_user, $db_pass, $db_database);
		$mysqli4->set_charset("utf8");
		if ($result_product_categories = $mysqli4->query("SELECT * FROM `s_variants` WHERE `id`='$variant_id' LIMIT 1")){
			while($r_pc = $result_product_categories->fetch_assoc()){
				$product_id = $r_pc['product_id'];
			}
		}
		$mysqli4->close();
		
		$mysqli4 = new mysqli($db_host, $db_user, $db_pass, $db_database);
		$mysqli4->set_charset("utf8");
		if ($result_product_categories = $mysqli4->query("SELECT * FROM `s_products_categories` WHERE `product_id`='$product_id' LIMIT 1")){
			while($r_pc = $result_product_categories->fetch_assoc()){
				$category_id = $r_pc['category_id'];
			}
		}
		$mysqli4->close();
		
		$categorie1 = $categorie2 = $categorie3 = $categorie4 = $categorie5 = null;
		$categorie1_name = $categorie2_name = $categorie3_name = $categorie4_name = $categorie5_name = null;
		$parent1 = $parent2 = $parent3 = $parent4 = $parent5 = null;
		
		$categorie1 = $category_id;
		
		$mysqli4 = new mysqli($db_host, $db_user, $db_pass, $db_database);
		$mysqli4->set_charset("utf8");
		if ($result_product_categories = $mysqli4->query("SELECT * FROM `s_categories` WHERE `id`='$categorie1' LIMIT 1")){
			while($r_pc = $result_product_categories->fetch_assoc()){
				$parent1         = $r_pc['parent_id'];
				$categorie1_name = $r_pc['name'];
			}
		}
		$mysqli4->close();

		$categorie2 = $parent1;
		$mysqli4 = new mysqli($db_host, $db_user, $db_pass, $db_database);
		$mysqli4->set_charset("utf8");
		if ($result_product_categories = $mysqli4->query("SELECT * FROM `s_categories` WHERE `id`='$categorie2' LIMIT 1")){
			while($r_pc = $result_product_categories->fetch_assoc()){
				$parent2        = $r_pc['parent_id'];
				$categorie2_name = $r_pc['name'];
			}
		}
		$mysqli4->close();
		
		$categorie3 = $parent2;
		$mysqli4 = new mysqli($db_host, $db_user, $db_pass, $db_database);
		$mysqli4->set_charset("utf8");
		if ($result_product_categories = $mysqli4->query("SELECT * FROM `s_categories` WHERE `id`='$categorie3' LIMIT 1")){
			while($r_pc = $result_product_categories->fetch_assoc()){
				$parent3        = $r_pc['parent_id'];
				$categorie3_name = $r_pc['name'];
			}
		}
		$mysqli4->close();
		
		$categorie4 = $parent3;
		$mysqli4 = new mysqli($db_host, $db_user, $db_pass, $db_database);
		$mysqli4->set_charset("utf8");
		if ($result_product_categories = $mysqli4->query("SELECT * FROM `s_categories` WHERE `id`='$categorie4' LIMIT 1")){
			while($r_pc = $result_product_categories->fetch_assoc()){
				$parent4         = $r_pc['parent_id'];
				$categorie4_name = $r_pc['name'];
			}
		}
		$mysqli4->close();
		
		$categorie5 = $parent4;
		$mysqli4 = new mysqli($db_host, $db_user, $db_pass, $db_database);
		$mysqli4->set_charset("utf8");
		if ($result_product_categories = $mysqli4->query("SELECT * FROM `s_categories` WHERE `id`='$categorie5' LIMIT 1")){
			while($r_pc = $result_product_categories->fetch_assoc()){
				$parent5         = $r_pc['parent_id'];
				$categorie5_name = $r_pc['name'];
			}
		}
		
		$mysqli4->close();
		
		$cat_name = $categorie3_name.' | '.$categorie1_name;
		$purchase->category_name = $cat_name;
		
		///////////////////////////////////////////////////////////////////////////////////////////////////////

		$query = $this->db->placehold("INSERT INTO __purchases SET ?%", $purchase);
		$this->db->query($query);
		$purchase_id = $this->db->insert_id();
		
		$this->update_total_price($order->id);		
		return $purchase_id;
	}

	public function delete_purchase($id)
	{
		$purchase = $this->get_purchase($id);
		if(!$purchase)
			return false;
			
		$order = $this->get_order(intval($purchase->order_id));
		if(!$order)
			return false;

		// Если заказ закрыт, нужно обновить склад при изменении покупки
		if($order->closed && !empty($purchase->amount))
		{
			$stock_diff = $purchase->amount;
			$query = $this->db->placehold("UPDATE __variants SET stock=stock+? WHERE id=? AND stock IS NOT NULL LIMIT 1", $stock_diff, $purchase->variant_id);
			$this->db->query($query);
		}
		
		$query = $this->db->placehold("DELETE FROM __purchases WHERE id=? LIMIT 1", intval($id));
		$this->db->query($query);
		$this->update_total_price($order->id);				
		return true;
	}

	
	public function close($order_id)
	{
		$order = $this->get_order(intval($order_id));
		if(empty($order))
			return false;
		
		if(!$order->closed)
		{
			$variants_amounts = array();
			$purchases = $this->get_purchases(array('order_id'=>$order->id));
			foreach($purchases as $purchase)
			{
				if(isset($variants_amounts[$purchase->variant_id]))
					$variants_amounts[$purchase->variant_id] += $purchase->amount;
				else
					$variants_amounts[$purchase->variant_id] = $purchase->amount;
			}

			foreach($variants_amounts as $id=>$amount)
			{
				$variant = $this->variants->get_variant($id);
				if(empty($variant) || ($variant->stock<$amount))
					return false;
			}
			foreach($purchases as $purchase)
			{	
				$variant = $this->variants->get_variant($purchase->variant_id);
				if(!$variant->infinity)
				{
					$new_stock = $variant->stock-$purchase->amount;
					$this->variants->update_variant($variant->id, array('stock'=>$new_stock));
				}
			}				
			$query = $this->db->placehold("UPDATE __orders SET closed=1, modified=NOW() WHERE id=? LIMIT 1", $order->id);
			$this->db->query($query);
		}
		return $order->id;
	}

	public function open($order_id)
	{
		$order = $this->get_order(intval($order_id));
		if(empty($order))
			return false;
		
		if($order->closed)
		{
			$purchases = $this->get_purchases(array('order_id'=>$order->id));
			foreach($purchases as $purchase)
			{
				$variant = $this->variants->get_variant($purchase->variant_id);				
				if($variant && !$variant->infinity)
				{
					$new_stock = $variant->stock+$purchase->amount;
					$this->variants->update_variant($variant->id, array('stock'=>$new_stock));
				}
			}				
			$query = $this->db->placehold("UPDATE __orders SET closed=0, modified=NOW() WHERE id=? LIMIT 1", $order->id);
			$this->db->query($query);
		}
		return $order->id;
	}
	
	public function pay($order_id)
	{
		$order = $this->get_order(intval($order_id));
		if(empty($order))
			return false;
		
		if(!$this->close($order->id))
		{
			return false;
		}
		$query = $this->db->placehold("UPDATE __orders SET payment_status=1, payment_date=NOW(), modified=NOW() WHERE id=? LIMIT 1", $order->id);
		$this->db->query($query);
		return $order->id;
	}
	
	private function update_total_price($order_id){
		
		$order = $this->get_order(intval($order_id));
		if(empty($order))
			return false;
		
		$query = $this->db->placehold("UPDATE __orders o SET o.total_price=ROUND(IFNULL((SELECT SUM(p.price*p.amount)*(100-o.discount)/100 FROM __purchases p WHERE p.order_id=o.id), 0)+o.delivery_price*(1-o.separate_delivery)-o.coupon_discount+o.cost_price-o.discount_price_promo), modified=NOW() WHERE o.id=? LIMIT 1", $order->id);
		$this->db->query($query);
		
		$query = $this->db->placehold("UPDATE __orders o SET o.volume=FORMAT(IFNULL((SELECT SUM(p.volume*p.amount) FROM __purchases p WHERE p.order_id=o.id), 0), 4), modified=NOW() WHERE o.id=? LIMIT 1", $order->id);
		$this->db->query($query);
		
		$query = $this->db->placehold("UPDATE __orders o SET o.weight=FORMAT(IFNULL((SELECT SUM(p.weight*p.amount) FROM __purchases p WHERE p.order_id=o.id), 0), 2), modified=NOW() WHERE o.id=? LIMIT 1", $order->id);
		$this->db->query($query);
				
		return $order->id;
	}
	
	public function get_next_order($id, $status = null)
	{
		$f = '';
		if($status!==null)
			$f = $this->db->placehold('AND status=?', $status);
		$this->db->query("SELECT MIN(id) as id FROM __orders WHERE id>? $f LIMIT 1", $id);
		$next_id = $this->db->result('id');
		if($next_id)
			return $this->get_order(intval($next_id));
		else
			return false; 
	}
	
	public function get_prev_order($id, $status = null)
	{
		$f = '';
		if($status !== null)
			$f = $this->db->placehold('AND status=?', $status);
		$this->db->query("SELECT MAX(id) as id FROM __orders WHERE id<? $f LIMIT 1", $id);
		$prev_id = $this->db->result('id');
		if($prev_id)
			return $this->get_order(intval($prev_id));
		else
			return false; 
	}
}
