<?PHP 

require_once('api/Simpla.php');

########################################
class PickupPointsAdmin extends Simpla
{


  function fetch()
  {
  
    // Поиск
  	$keyword = $this->request->get('keyword', 'string');
  	if(!empty($keyword))
  	{
	  	$filter['keyword'] = $keyword;
 		$this->design->assign('keyword', $keyword);
	}

  
  	// Обработка действий 	
  	if($this->request->method('post'))
  	{
		// Действия с выбранными
		$ids = $this->request->post('check');
		if(!empty($ids))
		switch($this->request->post('action'))
		{
			case 'enable':
		    {
				foreach($ids as $id)
					$this->pickuppoints->update_pickuppoint($id, array('enabled'=>1));   
		        break;
		    }
			case 'disable':
		    {
				foreach($ids as $id)
					$this->pickuppoints->update_pickuppoint($id, array('enabled'=>0));   
		        break;
		    }
		    case 'delete':
		    {
				foreach($ids as $id)
					$this->pickuppoints->delete_pickuppoint($id);
		        break;
		    }
		}		
		
 	}

  	// Отображение
	$filter = array();
	$filter['page'] = max(1, $this->request->get('page', 'integer')); 		
	$filter['limit'] = 40;

	// Поиск
	$keyword = $this->request->get('keyword', 'string');
	if(!empty($keyword))
	{
		$filter['keyword'] = $keyword;
		$this->design->assign('keyword', $keyword);
	}		

  	$pickuppoints_count = $this->pickuppoints->count_pickuppoints($filter);
	// Показать все страницы сразу
	if($this->request->get('page') == 'all')
		$filter['limit'] = $pickuppoints_count;
  	
  	$pickuppoints = $this->pickuppoints->get_pickuppoints($filter);

 	$this->design->assign('pages_count', ceil($pickuppoints_count/$filter['limit']));
 	$this->design->assign('current_page', $filter['page']);

 	$this->design->assign('pickuppoints', $pickuppoints);
 	$this->design->assign('pickuppoints_count', $pickuppoints_count);

	return $this->design->fetch('pickuppoints.tpl');
  }
}


?>