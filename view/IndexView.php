<?PHP

/**
 * Simpla CMS
 *
 * @copyright 	2011 Denis Pikusov
 * @link 		http://simp.la
 * @author 		Denis Pikusov
 *
 * Этот класс использует шаблон index.tpl,
 * который содержит всю страницу кроме центрального блока
 * По get-параметру module мы определяем что сожержится в центральном блоке
 *
 */

require_once('View.php');

class IndexView extends View
{	
	public $modules_dir = 'view/';

	public function __construct(){		
		parent::__construct();
	}
		
	/**
	 *
	 * Отображение
	 *
	 */
	function fetch(){
		
		$this->orders->update_order_status();

        $attention_slave = $this->attention->get('slave' ,true);

        /**
         * Maus: какой-то глючный код.
         * как мне кажется, логика задумывалась такой:
         * main-плашка - постоянная, slave - временная (показывается в какой-то период времени
         * 1) показывается slave-плашка, если соблюдены условия
         * 2) иначе показывается main-плашка, если она доступна
         * переписываю под эту логику
         */
		$plashka = '';
        $color_background = null;
        if ( count( $attention_slave ) ) {
            $d = getdate();
            $day_now = sprintf(
                '%04u-%02u-%02u %02u:%02u:%02u',
                $d['year'],
                $d['mon'],
                $d['mday'],
                $d['hours'],
                $d['minutes'],
                $d['seconds']
            );

            if (($attention_slave['time_start'] <= $day_now) && ($attention_slave['time_finish'] >= $day_now)) {
                $color_background = $attention_slave['color_background'];
                $plashka = "<a style='color:{$attention_slave['color_text']};' href='{$attention_slave['url']}'>{$attention_slave['value']}</a>";
            }
        }
        if ( $plashka === '' ) {
            $attention_main = $this->attention->get('main', true);
            if ( count($attention_main) ) {
                $color_background = $attention_main['color_background'];
                $plashka = "<a style='color:{$attention_main['color_text']};' href='{$attention_main['url']}'>{$attention_main['value']}</a>";
            }
        }

        if ( $plashka !== '' ) {
            $this->design->assign('plashka', $plashka);
            $this->design->assign('color_background', $color_background);
        }

		// Содержимое корзины
		$this->design->assign('cart',		$this->cart->get_cart());
	
        // Категории товаров
		$this->design->assign('categories', $this->categories->get_categories_tree());
		
		// Страницы
		$pages = $this->pages->get_pages(array('visible'=>1));
		$this->design->assign('pages', $pages);

        // Текущий модуль (для отображения центрального блока)
        $module = $this->request->get('module', 'string');
        $module = preg_replace("/[^A-Za-z0-9]+/", "", $module);
		if( $module === '' ) {
		    // забыли вызвать applyRoutes ?
            return false;
        }
        // Если не задан - берем из настроек
        //$module = $this->settings->main_module;

		// Создаем соответствующий класс
		if (is_file($this->modules_dir."$module.php"))
		{
				include_once($this->modules_dir."$module.php");
				if (class_exists($module))
				{
					$this->main = new $module($this);
				} else return false;
		} else return false;

		// Создаем основной блок страницы
		if (!$content = $this->main->fetch())
		{
			return false;
		}		
		
		if ($this->user){
			$uid = $this->user->id;
			$email = $this->user->email;
			$securedUserID = hash_hmac('sha256', $uid, "8ddf75df03a4d953a76874cec529133c");
			 
			$this->design->assign("uid", $uid);
			$this->design->assign("email", $email);
			$this->design->assign("securedUserID", $securedUserID);
			
			$orders = $this->orders->get_orders(array('user_id'=>$this->user->id));
			$this->design->assign('orders', $orders);
		}

		// Передаем основной блок в шаблон
		$this->design->assign('content', $content);		
		
		// Передаем название модуля в шаблон, это может пригодиться
		$this->design->assign('module', $module);

        // @FIXME свои метатеги тут
        /*
        $this->design->assign('meta_title', "Для щенков и кормящих собак");
        $this->design->assign('meta_keywords', "ключевые слова!");
        $this->design->assign('meta_description', "vtnf-jgbcfybt");
        */
				
		// Создаем текущую обертку сайта (обычно index.tpl)
		$wrapper = $this->design->smarty->getTemplateVars('wrapper');
		if(is_null($wrapper))
			$wrapper = 'index.tpl';

		if(!empty($wrapper))
			return $this->body = $this->design->fetch($wrapper);
		else
			return $this->body = $content;
	}

	private function getRoutes()
    {
        $routes = include $_SERVER['DOCUMENT_ROOT'].'/config/routes.php';
        if ( !is_array($routes) ) {
            throw new RuntimeException("no routes defined");
        }

        return $routes;
    }

    /**
     * @param bool $checkPrettyUrl
     * @return bool
     */
    public function applyRoutes( $checkPrettyUrl = true )
    {
        $urlParts = parse_url($_SERVER['REQUEST_URI']);

        // чпу
        if ( $checkPrettyUrl && $this->pretty_url->initUrl( $urlParts['path'] ) )
        {
            $path = $_SERVER['REQUEST_URI'];
        } else {
            $path = $urlParts['path'];
        }
    
        if ( $path === '/index.php' ) {
            $path = '/';
        }

        // маршруты
        if ( $path !== '' && substr($path, -1) != '/' ) {
            $slashedPath = $path.'/';
        } else {
            $slashedPath = '';
        }
        // @FIXME сделать полноценный редирект c GET-параметров на роуты
        if ( $_SERVER['REQUEST_METHOD']== 'GET' && $path === '/' && isset( $_GET['module'] ) ) {
            if ( $_GET['module']==='FeedbackView' ) {
                $path = '/contact/';
                unset( $_GET['module'] );
                if ( count($_GET) ) {
                    $path .= '?'.http_build_query( $_GET );
                }
                header("HTTP/1.1 301 Moved Permanently");
                header("Location: http://{$_SERVER['HTTP_HOST']}".$path, true. 301 );
                exit;
            }
        }

        $matches = array();
        $module = '';
        foreach ($this->getRoutes() as $map) {
            if (preg_match($map['pattern'], $path, $matches)) {
                if (isset($map['aliases']) && count($map['aliases'])) {
                    /*
                     * передавать в globals не хочется, а ничего другого подходящего нет
                     */
                    $this->design->assign('exclude_get_params', $map['aliases']);
                    array_shift($matches);
                    foreach ($matches as $index => $value) {
                        $_GET[ $map['aliases'][$index] ] = $value;
                    }
                }
                $module = (string)$map['class'];
                break;
            } elseif ( $slashedPath !=='' && preg_match($map['pattern'], $slashedPath) ) {
                if ( isset($urlParts['query']) && strlen($urlParts['query']) ) {
                    $slashedPath .= '?'.$urlParts['query'];
                }
                header("HTTP/1.1 301 Moved Permanently");
                header("Location: http://{$_SERVER['HTTP_HOST']}".$slashedPath, true. 301 );
                exit;
            }
        }

        if ( $module === '' ) {
            return false;

        } else {
            // @FIXME костыль для не-ЧПУ адресации
            if ( $module === 'MainView' && isset( $_GET['module'] ) && strlen( $_GET['module'] ) ) {
                // do nothing
            } else {
                $_GET['module'] = $module;
            }

            return true;
        }
    }
}
