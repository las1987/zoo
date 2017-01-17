<?PHP

/**
 * Simpla CMS
 *
 * @copyright 	2017 Alex Lubomirov
 * @link 		las_home@mail.ru
 * @author 		Alex Lubomirov
 *
 * Этот класс использует шаблон pickuppoint.tpl
 *
 */
require_once('View.php');

class PickupPointView extends View{
	function fetch(){

		$pickuppoint_url = $this->request->get('pickuppoint_url', 'string');
		
		if(empty($pickuppoint_url)) return false;
		
		$pickuppoint = $this->pickuppoints->get_pickuppoint($pickuppoint_url);
		
		if (empty($pickuppoint)) return false;
		
		
		$this->design->assign('pickuppoint', $pickuppoint);
			
		return $this->design->fetch('pickuppoint.tpl');
	}
}