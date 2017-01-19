<?php

/**
 * Работа с вариантами товаров
 *
 * @copyright 	2011 Denis Pikusov
 * @link 		http://simplacms.ru
 * @author 		Denis Pikusov
 *
 */

require_once('Simpla.php');

class Variants extends Simpla{
	
	/**
	* Функция возвращает варианты товара
	* @param $filter
	* @retval array
	*/
	
	public function get_variants($filter = array()){
		$product_id_filter = '';
		$variant_id_filter = '';
		$min_price_filter = '';
		$max_price_filter = '';
        $promo_variants_filter = '';
		
		if(!empty($filter['product_id'])){
			$product_id_filter = $this->db->placehold('AND v.product_id in(?@)', (array)$filter['product_id']);
        }
		
		if(!empty($filter['id']))
			$variant_id_filter = $this->db->placehold('AND v.id in(?@)', (array)$filter['id']);

		if(!empty($filter['in_stock']) && $filter['in_stock'])
			$variant_id_filter = $this->db->placehold('AND ((v.stockday > 1)OR((v.stockday = 1)AND(((v.price < 200)AND(v.stock > 49))OR((v.price > 199)AND(v.stock > 5)))))');

		if(!$product_id_filter && !$variant_id_filter)
			return array();
		
		if(!empty($filter['min_price']))
			$min_price_filter = $this->db->placehold('AND v.price >= ?', $filter['min_price']);
		
		if(!empty($filter['max_price']))
			$max_price_filter = $this->db->placehold('AND v.price <= ?', $filter['max_price']);
		
        if (!empty($filter['promo_variants']))
            $promo_variants_filter = $this->db->placehold('RIGHT JOIN __promo_variants pv ON pv.variant_id = v.id');
		
		$query = $this->db->placehold("SELECT v.id, v.id_1c, v.product_id , v.price, v.compare_price_status, v.percent, NULLIF(v.compare_price, 0) as compare_price, v.sku, IFNULL(v.stock, ?) as stock, (v.stock IS NULL) as infinity, v.stockday, v.stockbuhta, v.name, v.attachment, v.position, v.yml, v.avito, v.sale, v.weight, v.width, v.length, v.height, v.multiplicity, v.main_position, v.in_top, v.pickup_ban,  pm.name as action_name, pm.url as action_url, pm.sum_with_card as sum_with_card
					FROM __variants AS v $promo_variants_filter 
					LEFT JOIN __promo_variants pva on pva.variant_id = v.id 
					LEFT JOIN __promos pm on pm.id = pva.promo_id 
					WHERE 
					1 
					$product_id_filter 
					$variant_id_filter 
                    $min_price_filter 
                    $max_price_filter 
					ORDER BY  pm.priority DESC, v.position
					", $this->settings->max_order_amount);
		
		$this->db->query($query);
		$variants = $this->db->results();

		foreach($variants as $v){		
			$variant_id = $v->id;
			$promo_url = $v->action_url;
			$prm = $this->promos->sku_in_promo_no_url($variant_id);
			
			if (($prm != false)&&(!empty($prm))){
				$type = $prm[0]['type'];
				$discount = $prm[0]['discount'];
				
				if ($type == 1){
					$price = $v->price;
					$price_new = $price - $price * $discount / 100;
					
					$v->compare_price = (int) $price; 
					$v->price = $price_new;
				}
			}
						
			$pr=null;
		}
		
		//echo "<pre>";
		//print_r($variants);
		//echo "</pre>";
		
		return $variants;
		
	}
	
	public function get_variant($id){
		
		if(empty($id))
			return false;
		
		$query = $this->db->placehold("SELECT v.id, v.id_1c, v.product_id , v.price, v.compare_price_status, v.percent, NULLIF(v.compare_price, 0) as compare_price, v.sku, IFNULL(v.stock, ?) as stock, (v.stock IS NULL) as infinity, v.stockday, v.stockbuhta, v.name, v.attachment, v.yml, v.avito, v.sale,  v.weight, v.width, v.length, v.height, v.multiplicity, v.main_position, v.in_top
					FROM __variants v WHERE id=?
					LIMIT 1", $this->settings->max_order_amount, $id);
		
		$this->db->query($query);
		$variant = $this->db->result();
		return $variant;
	}
	
	public function update_variant($id, $variant){
		
        /*if (($old_variant = $this->get_variant($id)) && (isset($variant->price)))
        {
            $variant->compare_price = $old_variant->price;
        }*/
		
		$query = $this->db->placehold("UPDATE __variants SET ?% WHERE id=? LIMIT 1", $variant, intval($id));
		$this->db->query($query);
		return $id;
	}
	
	public function add_variant($variant){
		$query = $this->db->placehold("INSERT INTO __variants SET ?%", $variant);
		$this->db->query($query);
		return $this->db->insert_id();
	}
	
	public function delete_variant($id){
		if(!empty($id)){
			$this->delete_attachment($id);
			$query = $this->db->placehold("DELETE FROM __variants WHERE id = ? LIMIT 1", intval($id));
			$this->db->query($query);
			$this->db->query('UPDATE __purchases SET variant_id=NULL WHERE variant_id=?', intval($id));
		}
	}
	
	public function delete_attachment($id){
		$query = $this->db->placehold("SELECT attachment FROM __variants WHERE id=?", $id);
		$this->db->query($query);
		$filename = $this->db->result('attachment');
		$query = $this->db->placehold("SELECT 1 FROM __variants WHERE attachment=? AND id!=?", $filename, $id);
		$this->db->query($query);
		$exists = $this->db->num_rows();
		if(!empty($filename) && $exists == 0)
			@unlink($this->config->root_dir.'/'.$this->config->downloads_dir.$filename);
		$this->update_variant($id, array('attachment'=>null));
	}
	
	/* public function get_total_min_price($category_id){
		$query = $this->db->placehold("SELECT id FROM __categories WHERE url in (?)", $url);
		$this->db->query($query);
		return $this->db->results('id');		
	}

	public function get_total_max_price($category_id) {
		$query = $this->db->placehold("SELECT price FROM __variants WHERE url in (?)", $url);
		$this->db->query($query);
		return $this->db->results('id');
	}*/

    public function getByProductId( $productId )
    {
        $query = $this->db->placehold("SELECT `stockday`,`stock` FROM `__variants` WHERE `product_id`=? LIMIT 1", $productId);
        $this->db->query($query);
        return $this->db->result();
	}
	
}