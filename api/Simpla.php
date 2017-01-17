<?php

/**
 * Основной класс Simpla для доступа к API Simpla
 *
 * @copyright 	2011 Denis Pikusov
 * @link 		http://simplacms.ru
 * @author 		Denis Pikusov
 *
 * @property Attention $attention
 * @property Adverts $adverts
 * @property Articles $articles
 * @property Banners $banners
 * @property Blog $blog
 * @property Brands $brands
 * @property Call_orders $call_orders
 * @property Cart $cart
 * @property Categories $categories
 * @property Comments $comments
 * @property Config $config
 * @property Coupons $coupons
 * @property Database $db
 * @property Delivery $delivery
 * @property Design $design
 * @property Destinations $destinations
 * @property Discussions $discussions
 * @property Events $events
 * @property Features $features
 * @property Feedbacks $feedbacks
 * @property Gaze $gaze
 * @property Image $image
 * @property Managers $managers
 * @property Money $money
 * @property News $news
 * @property Notify $notify
 * @property Orders $orders
 * @property Pages $pages
 * @property Parser $parser
 * @property Payment $payment
 * @property Pets $pets
 * @property PrettyUrl $pretty_url
 * @property Products $products
 * @property Profiles $profiles
 * @property Promos $promos
 * @property Request $request
 * @property Reviews $reviews
 * @property Routines $routines
 * @property Seo $seo
 * @property Settings $settings
 * @property Subscriptions $subscriptions
 * @property Synonym $synonym
 * @property Users $users
 * @property Variants $variants
 */

class Simpla
{
	// Свойства - Классы API
	private $classes = array(
        'attention'       => 'Attention',
        'adverts'       => 'Adverts',
        'articles'      => 'Articles',
        'banners'       => 'Banners',
        'blog'          => 'Blog',
        'brands'        => 'Brands',
        'call_orders'   => 'Call_orders',
        'cart'          => 'Cart',
        'categories'    => 'Categories',
        'comments'      => 'Comments',
        'config'        => 'Config',
        'coupons'       => 'Coupons',
        'db'            => 'Database',
        'delivery'      => 'Delivery',
        'design'        => 'Design',
        'destinations'  => 'Destinations',
        'discussions'   => 'Discussions',
        'events'        => 'Events',
        'features'      => 'Features',
        'feedbacks'     => 'Feedbacks',
        'gaze'       => 'Gaze',
        'image'         => 'Image',
        'managers'      => 'Managers',
        'money'         => 'Money',
        'news'          => 'News',
        'notify'        => 'Notify',
        'orders'        => 'Orders',
        'pages'         => 'Pages',
        'parser'        => 'Parser',
        'payment'       => 'Payment',
        'pets'          => 'Pets',
        'pretty_url'     => 'PrettyUrl',
        'products'      => 'Products',
        'profiles'      => 'Profiles',
        'promos'        => 'Promos',
        'request'       => 'Request',
        'reviews'       => 'Reviews',
        'routines'      => 'Routines',
        'seo'           => 'Seo',
        'settings'      => 'Settings',
        'subscriptions' => 'Subscriptions',
        'synonym'        => 'Synonym',
        'users'         => 'Users',
        'variants'      => 'Variants',
		'pickuppoints'	=> 'PickupPoints',
    );
	
	// Созданные объекты
	private static $objects = array();
	
	/**
	 * Конструктор оставим пустым, но определим его на случай обращения parent::__construct() в классах API
	 */
	public function __construct()
	{
		//error_reporting(E_ALL & !E_STRICT);
	}

	/**
	 * Магический метод, создает нужный объект API
	 */
	public function __get($name)
	{
		// Если такой объект уже существует, возвращаем его
		if(isset(self::$objects[$name]))
		{
			return(self::$objects[$name]);
		}
		
		// Если запрошенного API не существует - ошибка
		if(!array_key_exists($name, $this->classes))
		{
			return null;
		}
		
		// Определяем имя нужного класса
		$class = $this->classes[$name];
		
		// Подключаем его
		include_once('api/'.$class.'.php');
		
		// Сохраняем для будущих обращений к нему
		self::$objects[$name] = new $class();
		
		// Возвращаем созданный объект
		return self::$objects[$name];
	}
}