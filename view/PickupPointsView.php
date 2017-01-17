<?PHP

/**
 * Simpla CMS
 *
 * @copyright 	2017 Alex Lubomirov
 * @link 		las_home@mail.ru
 * @author 		Alex Lubomirov
 *
 * Этот класс использует шаблон pickuppoints.tpl
 *
 */
require_once('View.php');

class PickupPointsView extends View{
	function fetch(){
		$filter = array();
		$pickuppoints_count = $this->pickuppoints->count_pickuppoints($filter);
	// Показать все страницы сразу
//	if($this->request->get('page') == 'all')
		
	
		$filter['limit'] = $pickuppoints_count;
		
		$pickuppoints = $this->pickuppoints->get_pickuppoints($filter);
		
		//Формируем JSON с координатами пунктов
		
		$result = $this->pickuppoints->get_pickuppoints_JSON($pickuppoints);   
		
		$this->design->assign('pickuppoints', $pickuppoints);
		$this->design->assign('pickuppointsjson', $result);
		
		return $this->design->fetch('pickuppoints.tpl');
	}
}