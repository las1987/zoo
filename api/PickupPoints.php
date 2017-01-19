<?php
 
/**
 * Simpla CMS
 * @modulename 	Пункты самовывоза товаров
 * @copyright  	2017 Alex Lubomirov
 * @author     	Alex Lubomirov
 * @contact 	las_home@mail.ru
 * @special made for zoo812.ru
 *
 */

require_once('Simpla.php');

class PickupPoints extends Simpla
{
	/*
	*
	* Получаем список пунктов самовывоза удовлетворяющих фильтру
	* @param $filter
	*
	*/
    public function get_pickuppoints($filter = array())
   {
		//Значения по умолчанию
		$limit 	= 0;
		$page 	= 1;
		$keyword_filter = '';
		
		if(isset($filter['limit']))
         $limit = max(1, intval($filter['limit']));
		
		if(isset($filter['page']))
         $page = max(1, intval($filter['page']));
		
		$sql_limit = $this->db->placehold(' LIMIT ?, ? ', ($page-1)*$limit, $limit);
		
		if(!empty($filter['keyword']))
		{
			$keywords = explode(' ', $filter['keyword']);
			foreach($keywords as $keyword)
				$keyword_filter .= $this->db->placehold('AND p.address LIKE "%'.mysql_real_escape_string(trim($keyword)).'%"');
		}
		
		$query = $this->db->placehold("SELECT p.id, p.name, p.metro_station, p.address, p.latitude, p.longitude, p.photo, p.url, p.worktime, p.phone, p.enabled, p.summ_limit, p.weight_limit, p.dimensions_limit FROM __pickuppoints p WHERE 1 $keyword_filter ORDER BY p.id $sql_limit");
		$this->db->query($query);
		return $this->db->results();
   }
	
	/*
	*
	* Получаем количество пунктов самовывоза удовлетворяющих фильтру
	* @param $filter
	*
	*/
	public function count_pickuppoints($filter = array())
   {
      $keyword_filter = '';
 
      if(!empty($filter['keyword']))
      {
         $keywords = explode(' ', $filter['keyword']);
         foreach($keywords as $keyword)
            $keyword_filter .= $this->db->placehold('AND p.address LIKE "%'.mysql_real_escape_string(trim($keyword)).'%"');
      }
 
      $query = $this->db->placehold("SELECT count(distinct p.id) as count
                              FROM __pickuppoints p WHERE 1 $keyword_filter");
 
      $this->db->query($query);
      return $this->db->result('count');
   }
 
   /*
	*
	* Получаем данные пункта самовывоза по
	* @params $id - ИД пункта самовывоза либо его url
	*/
    public function get_pickuppoint($id)
   {
		if(is_int($id))
			$filter = $this->db->placehold('p.id = ?', $id);
		else
			$filter = $this->db->placehold('p.url = ?', $id);
	  
		$query = $this->db->placehold("SELECT p.id, p.name, p.metro_station, p.sides_limit, p. size_limit, p.address, p.latitude, p.longitude, p.photo, p.url, p.worktime, p.phone, p.weight_limit, p.summ_limit, p.dimensions_limit ,p.enabled, p.body FROM __pickuppoints p WHERE $filter LIMIT 1", $filter);

		if($this->db->query($query))
			return $this->db->result();
		else
			return false;
   }	

   /*
	*
	* Добавляем новый пункт самовывоза 
	*
	*/	
   public function add_pickuppoint($pickuppoint){
		$query = $this->db->placehold("INSERT INTO __pickuppoints SET ?%", $pickuppoint);
		if(!$this->db->query($query))
        {
			return false;
        }
		$id = $this->db->insert_id();
		return $id;
   }
   
   /*
   *
   * Обновление пункта самовывоза
   * @params $id - ИД пункта самовывоза, $pickuppoint - массив с данными
   *   
   */
   	public function update_pickuppoint($id, $pickuppoint)
	{
		$query = $this->db->placehold("UPDATE __pickuppoints SET ?% WHERE id=? LIMIT 1", $pickuppoint, intval($id));
		$this->db->query($query);
		return $id;
	}
   
   /*
   *
   * Удаление пункта самовывоза
   * @params $id - ИД пункта самовывоза
   *   
   */   
   	public function delete_pickuppoint($id){
		if(!empty($id))
		{
			/*Удаление параметров самовывоза (стоимость доставки в пункт самовывоза)*/
			$this->delete_pickuppoint_options($id);		
			
			/*Удаление данных о пункте самовывоза*/
			$query = $this->db->placehold("DELETE FROM __pickuppoints WHERE id=?", $id);
			$this->db->query($query);	
		}	
	}
 
  /*
   *
   * Удаление параметров самовывоза (стоимость доставки в пункт самовывоза)
   * @params $id - ИД пункта самовывоза
   *   
   */   
   	public function delete_pickuppoint_options($id){
		if(!empty($id))
		{
			$query = $this->db->placehold("DELETE FROM __pickuppoints_options WHERE pickuppoint_id=?", $id);
			$this->db->query($query);		
		}	
	}   

	/*
	*
	*	Обновление стоимости самовывоза
	*	
	*
	*/
   	public function add_pickuppoint_option($id, $pickuppoint_option, $option_id){
		$query = $this->db->placehold("INSERT IGNORE INTO __pickuppoints_options SET id=?, pickuppoint_id=?, summ_min_value=?, summ_max_value = ?, pickup_price_value=?", intval($option_id) + 1, intval($id), intval($pickuppoint_option->summ_min_value), intval($pickuppoint_option->summ_max_value), intval($pickuppoint_option->pickup_price_value));

		if(!$this->db->query($query))
        {
			return false;
        }
		$id = $this->db->insert_id();
		return $id;
	}   
	
	public function get_pickuppoint_options($pickuppoint_id){
	  $query = $this->db->placehold("SELECT po.id, po.pickuppoint_id, po.summ_min_value, po.summ_max_value, po.pickup_price_value FROM __pickuppoints_options po WHERE po.pickuppoint_id=? ORDER BY po.summ_min_value", intval($pickuppoint_id));
		
      if($this->db->query($query))
         return $this->db->results();
      else
         return false;
	}
	/*
	*
	*	Получаем список доступных пунктов самовывоза по параметрам
	*	@param weight - вес, summ - сумма, volume - объем заказа, max_height - максимальная высота товара в корзине,
	*		   $max_width = максимальная ширина товара в корзине, $max_length - максимальная длина товара в корзине
	*/
	public function get_pickuppoins_to_delivery($weight, $summ, $volume, $max_height, $max_width, $max_length){
		$filterWeight	= empty($weight) ? 0 : $weight;
		$filterSumm   	= empty($summ) ? 0 : $summ;
		$filterVolume 	= empty($volume) ? 0 : $volume;
		$filterHeight	= empty($max_height) ? 0 : $max_height;
		$filterWidth	= empty($max_width) ? 0 : $max_width;
		$filterLength	= empty($max_length) ? 0 : $max_length;
		
								
		$query = $this->db->placehold("
			SELECT 
			p.id,
			p.name,
			p.metro_station,
			p.sides_limit,
			p.size_limit,
			p.address,
			p.latitude,
			p.longitude,
			p.photo,
			p.url,
			p.worktime,
			p.phone,
			p.weight_limit,
			p.summ_limit,
			p.dimensions_limit,
			p.enabled,
			po.pickup_price_value
			
			FROM __pickuppoints p
			LEFT JOIN __pickuppoints_options po on p.id=po.pickuppoint_id AND ? BETWEEN po.summ_min_value AND po.summ_max_value  
			WHERE (p.summ_limit >= ? OR p.summ_limit = 0)
			AND (p.weight_limit + 2 >= ? OR p.weight_limit = 0)
			AND (p.dimensions_limit >= ? OR p.dimensions_limit=0)
			AND ((p.size_limit >= ? AND p.size_limit >= ? AND p.size_limit >= ?) OR p.size_limit = 0)
			AND p.enabled = 1
		",$filterSumm, $filterSumm, $filterWeight, $filterVolume, $filterHeight, $filterWidth, $filterLength);
		if($this->db->query($query))
			return $this->db->results();
		else
			return false;
	}
	/*
	* Получаем JSON с координатами пунктов выдачи
	* @params $pickuppoints Object
	*/
	public function get_pickuppoints_JSON($pickuppoints, $cart=false){
		if (empty($pickuppoints)) return false;
		
		$PickupPointArray = Array();
		$i=0;
		foreach($pickuppoints as $pickuppoint){
			$result = array("type" => "Feature",
							"id" => $pickuppoint->id,
							"geometry" => array("type" => "Point",
												
												"coordinates" => [$pickuppoint->latitude, $pickuppoint->longitude]), 
												"properties" => array(
												
																"balloonContentBody"=> '<address><strong><a href="/pickuppoints/'.$pickuppoint->url .'">' .$pickuppoint->name ."</a></strong><br>".$pickuppoint->address."<br>тел.:".$pickuppoint->phone."</address>" . ($cart ? '<br><button onclick="get_from_here(' .$pickuppoint->id .', this);return false;">Заберу отсюда</button>' : ""),
																"clusterCaption" => $pickuppoint->name,
																"hintContent" => $pickuppoint->name 
																)
												
			);
			$PickupPointArray[] = $result; 
			$i++;
		}
		$PickupPointsArray = Array("type"=> "FeatureCollection",
								   "features" => $PickupPointArray);
		$result = json_encode($PickupPointsArray, JSON_UNESCAPED_UNICODE);
		return $result;						
	}
	
	
	
}
