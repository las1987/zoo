<?php
/**
 * Created by PhpStorm.
 * User: maus
 * Date: 15.08.16
 * Time: 18:43
 */
return array(
    array(
        'pattern' => '~^/december2016promo/$~',
        'class' => 'BlackFridayView',
    ),
    # Каталог товаров
    array(
        'pattern' => '~^/catalog/([^/]+)/$~',
        'class' => 'ProductsView',
        'aliases' => array('category'),
    ),
    array(
        'pattern' => '~^/catalog/([^/]+)/([^/]+)/$~',
        'class' => 'ProductsView',
        'aliases' => array('category', 'brand'),
    ),
    array(
        'pattern' => '~^/products/([^/]+)/$~',
        'class' => 'ProductView',
        'aliases' => array('product_url'),
    ),
    array(
        'pattern' => '~^/products/$~',
        'class' => 'ProductsView',
    ),
    array(
        'pattern' => '~^/brands/$~',
        'class' => 'BrandsView',
    ),
    array(
        'pattern' => '~^/brands/([^/]+)/$~',
        'class' => 'ProductsView',
        'aliases' => array('brand'),
    ),
    array(
        'pattern' => '~^/brands/([^/]+)/page_([^/]+)/$~',
        'class' => 'ProductsView',
        'aliases' => array('brand', 'page'),
    ),
    array(
        'pattern' => '~^/proizvoditeli/$~',
        'class' => 'BrandsView',
    ),
    array(
        'pattern' => '~^/proizvoditeli/([^/]+)/$~',
        'class' => 'ProductsView',
        'aliases' => array('brand'),
    ),
    array(
        'pattern' => '~^/proizvoditeli/page_([^/]+)/$~',
        'class' => 'BrandsView',
        'aliases' => array('page'),
    ),
    array(
        'pattern' => '~^/promos/$~',
        'class' => 'PromosView',
    ),
    array(
        'pattern' => '~^/promos/([^/]+)/$~',
        'class' => 'PromoView',
        'aliases' => array('url'),
    ),
    array(
        'pattern' => '~^/landings/$~',
        'class' => 'LandingsView',
    ),
    array(
        'pattern' => '~^/landings/([^/]+)/$~',
        'class' => 'LandingView',
        'aliases' => array('url'),
    ),
    array(
        'pattern' => '~^/articles/$~',
        'class' => 'ArticlesView',
    ),
    array(
        'pattern' => '~^/articles/([^/]+)/$~',
        'class' => 'ArticleView',
        'aliases' => array('url'),
    ),
    array(
        'pattern' => '~^/special_promo/$~',
        'class' => 'SpecialView',
    ),

    # Поиск товаров
    array(
        'pattern' => '~^/search/([^/]+)/$~',
        'class' => 'ProductsView',
        'aliases' => array('keyword'),
    ),
    array(
        'pattern' => '~^/search/$~',
        'class' => 'ProductsView',
    ),
    # Блог
    array(
        'pattern' => '~^/blog/([^/]+)/$~',
        'class' => 'BlogView',
        'aliases' => array('url'),
    ),
    array(
        'pattern' => '~^/blog/$~',
        'class' => 'BlogView',
    ),
    # Корзина и заказы
    array(
        'pattern' => '~^/cart/$~',
        'class' => 'CartView',
    ),
    array(
        'pattern' => '~^/cart/([^/]+)/?$~',
        'class' => 'CartView',
        'aliases' => array('add_variant'),
    ),
    array(
        'pattern' => '~^/cart/remove/([^/]+)/?$~',
        'class' => 'CartView',
        'aliases' => array('delete_variant'),
    ),
    array(
        'pattern' => '~^/order/([^/]+)/([^/]+)/?$~',
        'class' => 'OrderView',
        'aliases' => array('url', 'file'),
    ),
    array(
        'pattern' => '~^/order/([^/]+)/?$~',
        'class' => 'OrderView',
    ),
    array(
        'pattern' => '~^/order/?$~',
        'class' => 'OrderView',
    ),
    # Для пользователей
    array(
        'pattern' => '~^/user/login/?$~',
        'class' => 'LoginView',
    ),
    array(
        'pattern' => '~^/user/register/?$~',
        'class' => 'RegisterView',
    ),
    array(
        'pattern' => '~^/user/(logout|password_remind)/?$~',
        'class' => 'LoginView',
        'aliases' => array('action'),
    ),
    array(
        'pattern' => '~^/user/(password_remind)/([0-9a-z]+)/?$~',
        'class' => 'LoginView',
        'aliases' => array('action', 'code'),
    ),
    array(
        'pattern' => '~^/user/?$~',
        'class' => 'UserView',
    ),
    # Feedback
    array(
        'pattern' => '~^/contact/$~',
        'class' => 'FeedbackView',
    ),
	
	# Самовывоз
	array(
		'pattern' => '~^/pickuppoints/$~',
		'class' => 'PickuppointsView',
	),
	 array(
        'pattern' => '~^/pickuppoints/([^/]+)/$~',
        'class' => 'PickuppointView',
        'aliases' => array('pickuppoint_url'),
    ),

    // главная страница
    array(
        'pattern' => '~^/index\.php$~',
        'class' => 'MainView',
    ),
    array(
        'pattern' => '~^/?$~',
        'class' => 'MainView',
    ),
    // прочие страницы
    array(
        'pattern' => '~^/([^/]*)/$~',
        'class' => 'PageView',
        'aliases' => array('page_url'),
    ),
);