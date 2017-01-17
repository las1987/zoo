<?PHP 

require_once('api/Simpla.php');

########################################
class PickupPointAdmin extends Simpla
{
  function fetch()
  {
		$pickuppoint = new stdClass();
		$pickuppoint_options = array();
		if($this->request->method('post'))
		{
			$pickuppoint->name				= $this->request->post('name');
			$pickuppoint->id               	= $this->request->post('id', 'integer');
			$pickuppoint->address          	= $this->request->post('address');
	 		$pickuppoint->latitude      	= $this->request->post('latitude');
	 		$pickuppoint->longitude			= $this->request->post('longitude');
			$pickuppoint->photo				= $this->request->post('photo');
			$pickuppoint->metro_station		= $this->request->post('metro_station');			
			$pickuppoint->url				= $this->request->post('url');		
	 		$pickuppoint->worktime      	= $this->request->post('worktime');
	 		$pickuppoint->phone           	= $this->request->post('phone');
	 		$pickuppoint->summ_limit       	= $this->request->post('summ_limit');
	 		$pickuppoint->size_limit 		= $this->request->post('size_limit');			
	 		$pickuppoint->weight_limit     	= $this->request->post('weight_limit');
	 		$pickuppoint->sides_limit 		= $this->request->post('sides_limit');
	 		$pickuppoint->enabled          	= $this->request->post('enabled', 'boolean');
			
			//Расчитываем объем, который может принять пункт выдачи
			$one_side = $this->request->post('sides_limit') / 3;
			$capacity = pow($one_side, 3) / 1000000;
						
			$pickuppoint->dimensions_limit  = $capacity;
			
			if(empty($pickuppoint->id))
			{
  				$pickuppoint->id = $this->pickuppoints->add_pickuppoint($pickuppoint);
  				$this->design->assign('message_success', 'added');
	    	}
	    	else
	    	{
	    		$this->pickuppoints->update_pickuppoint($pickuppoint->id, $pickuppoint);
  				$this->design->assign('message_success', 'updated');
	    	}
			
			$optionsData = $this->request->post('pickuppoint_options');
			if(is_array($optionsData) )
            {
                foreach($optionsData as $fieldName=>$od)
                {
					foreach($od as $i=>$o)
                    {
						if ( !array_key_exists( $i, $pickuppoint_options ) ) {
                            $pickuppoint_options[$i] = new stdClass();
                        }
                        $tmp = $pickuppoint_options[$i];
                        $tmp->$fieldName = $o;
                    }
                }
            	
			/*	if(!empty($pickuppoint->id)){
					$this->pickuppoints->delete_pickuppoint_options($pickuppoint->id);
				}
				foreach($optionsData as $index=> $option){
					var_dump($option);
					$this->pickuppoints->add_pickuppoint_option($pickuppoint->id, $option);
					
				}*/			
			}
		    unset($optionsData, $tmp);
			
			var_dump($pickuppoint_options);
		}
		else
		{
			$pickuppoint->id = $this->request->get('id', 'integer');
			if(!empty($pickuppoint->id))
			{
				$pickuppoint = $this->pickuppoints->get_pickuppoint($pickuppoint->id);
				$pickuppoint_options = $this->pickuppoints->get_pickuppoint_options($pickuppoint->id);
				
			}
		}
		$this->design->assign('pickuppoint_options', $pickuppoint_options);		
		$this->design->assign('pickuppoint', $pickuppoint);
		return $this->design->fetch('pickuppoint.tpl');
  }
}
