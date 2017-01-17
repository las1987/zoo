<?PHP

/**
 * Simpla CMS
 *
 * @copyright    2009 Denis Pikusov
 * @link        http://simp.la
 *
 * @author        Denis Pikusov
 *
 * Корзина покупок
 * Этот класс использует шаблон cart.tpl
 *
 */

require_once('View.php');

class CartView extends View
{
    //////////////////////////////////////////
    // Изменения товаров в корзине
    //////////////////////////////////////////
    public function __construct()
    {

        $my_destinations = null;
        $my_dpd_citys = null;

        // @FIXME паеренести это в /simpla
        require_once($_SERVER['DOCUMENT_ROOT'] . '/files/geo/geo.php');

        $geo = new Geo();
        $data = $geo->get_value();

        $city_geo =  isset($data['city']) ? $data['city'] : '';
        $region_geo = isset($data['region']) ? $data['region'] : '';
        $district_geo = isset($data['district']) ? $data['district'] : '';

        $destinations = $this->destinations->get_destinations();

        foreach ($destinations as $city) {
            if ($city->location == $city_geo) {
                $my_destinations = $city;
            }
        }

        require_once($_SERVER['DOCUMENT_ROOT'] . '/api/Simpla.php');
        ////////// Коннектимся к БД //////////////////////////////////////////////
        $simpla_new2 = new Simpla();
        $db_host = $simpla_new2->config->db_server;
        $db_user = $simpla_new2->config->db_user;
        $db_pass = $simpla_new2->config->db_password;
        $db_database = $simpla_new2->config->db_name;

        $mysqli_dpd_city = new mysqli($db_host, $db_user, $db_pass, $db_database);
        $mysqli_dpd_city->set_charset("utf8");

        if ($result_dpd_city = $mysqli_dpd_city->query("SELECT * FROM `s_city`")) {
            while ($my_dpd_city = $result_dpd_city->fetch_assoc()) {
                if ($my_dpd_city['cityname'] == $city_geo) $my_dpd_citys[] = $my_dpd_city;
            }
        }

        $mysqli_dpd_city->close();

        $this->design->assign('my_destinations', $my_destinations);
        $this->design->assign('my_dpd_citys', $my_dpd_citys);

        //	echo "<pre>";
        // 	print_r($my_dpd_citys);
        //	echo "</pre>";

        parent::__construct();

        // Если передан id варианта, добавим его в корзину
        if ($variant_id = $this->request->get('variant', 'integer')) {

            $amount = null;
            $amount = $this->request->get('amount');
            if (($amount == null) or ($amount == 0)) $amount = $this->request->post('amount');
            $this->cart->add_item($variant_id, $amount);

            header('location: ' . $this->config->root_url . '/cart/');
        }

        global $month_now, $year_now, $day_now, $time_now;

        // Удаление товара из корзины
        if ($delete_variant_id = intval($this->request->get('delete_variant'))) {
            $this->cart->delete_item($delete_variant_id);
            if (!isset($_POST['submit_order']) || $_POST['submit_order'] != 1)
                header('location: ' . $this->config->root_url . '/cart/');
        }

        // Если нажали оформить заказ
        if (isset($_POST['checkout'])) {
            $order->address = $_REQUEST['address'];

            //echo $order->address;

            $email = $this->request->post('email');

            /*
            if (($email == 'andrew.petrov@yandex.ru')or($email == 'qzarf@bk.ru')or($email == 'grebansk@rambler.ru')
                or($email == 'pavel.nikolaev@mailfrospam.com')or($email == 'adwan@mailfrospam.com')or($email == 'maxxxxx@mailforspam.com')
                ){
                exit('Вам отказано в совершении заказа, дотестились!');
            }

            $ip_user = $_SERVER["REMOTE_ADDR"];

            if (($ip_user == '94.19.241.176')or($ip_user == '178.162.38.103')or($ip_user == '128.75.225.202')
                or($ip_user == '94.23.159.155')or($ip_user == '217.23.5.70')
            ){
                exit('Вам отказано в совершении заказа, дотестились!');
            }

            */

            $order->payment_method_id = $this->request->post('payment_method_id', 'integer');

            if (isset($_REQUEST['sityno'])) {
                if ($_REQUEST['sityno'] == 'on') {
                    $order->destination_id = 666;
                } else {
                    $order->destination_id = $this->request->post('destination_id');
                }
            } else {
                $order->destination_id = $this->request->post('destination_id');
            }

            if ($this->request->post('drug_is')) {
                $drug_is = $this->request->post('drug_is');
                if ($drug_is == 1) {
                    $order->drug = 1;
                } else {
                    $order->drug = 0;
                }
            } else {
                $order->drug = 0;
            }

            if ($this->request->post('drug_is')) {
                $to_drug = $this->request->post('drug_is');
                if ($to_drug == '1') {
                    $order->drug = 1;
                    if ($order->drug == 1) {
                        $order->promokod = null;
                        $order->delivery_id = null;
                        $order->cost_price = null;
                        $order->city_id_dpd = 0;
                        $order->delivery_price = 0;
                        $order->discount = 0;
                        $order->destination_id = 3;
                        $order->address = 'АНО «Помощь бездомным собакам» 192148, г. Санкт-Петербург, Большой Смоленский пр. д.7-9, литер А';
                    }
                }
            }

            global $id_new;
            $gen = 0;

            while ($gen == 0) {

                $id_new = rand(100000, 999999);

                $mysqli = new mysqli($db_host, $db_user, $db_pass, $db_database);
                $mysqli->set_charset("utf8");

                $gen = 1;

                if ($result_id = $mysqli->query("SELECT * FROM `s_orders` WHERE `id_new`='$id_new' LIMIT 1")) {
                    while ($my_id = $result_id->fetch_assoc()) {
                        if ($my_id['id_new'] == $id_new)
                            $gen = 0;
                    }
                }

                $mysqli->close();
            }

            $order->id_new = $id_new;
            $order->delivery_id = $this->request->post('delivery_id', 'integer');
            $order->name = $this->request->post('name');
            $order->email = $this->request->post('email');

            $a = $b = null;

            $a = $_REQUEST['address'];
            $b = $_REQUEST['address_new'];

            if ($a != null) {
                $order->address = $a;
            } elseif ($b != null) {
                $order->address = $b;
            }

            if (($a == null) and ($b == null)) {
                $order->address = '';
            }

            $order->phone = $this->request->post('phone');

            $order->dpd_tarif = $this->request->post('dpd_tarif');
            $order->streetAbbr_dpd = $this->request->post('streetAbbr_dpd');
            if (($order->streetAbbr_dpd == null) || ($order->streetAbbr_dpd == "")) {
                $order->streetAbbr_dpd = $this->request->post('streetAbbr_dpd_no');
            }

            $order->street_dpd = $this->request->post('street_dpd');

            if (($order->street_dpd == null) || ($order->street_dpd == "")) {
                $order->street_dpd = $this->request->post('street_dpd_no');
            }

            $d_year =
            $d_mon =
            $d_mday =
            $d_hours =
            $d_minutes =
            $d_seconds = '';

            $d = getdate();
            $day_now_for_main_action = "";
            $d_year = $d[year];
            $d_mon = $d[mon];
            $d_mday = $d[mday];
            $d_hours = $d[hours];
            $d_minutes = $d[minutes];
            $d_seconds = $d[seconds];

            if ($d_seconds == '1') $d_seconds = "01";
            if ($d_seconds == '2') $d_seconds = "02";
            if ($d_seconds == '3') $d_seconds = "03";
            if ($d_seconds == '4') $d_seconds = "04";
            if ($d_seconds == '5') $d_seconds = "05";
            if ($d_seconds == '6') $d_seconds = "06";
            if ($d_seconds == '7') $d_seconds = "07";
            if ($d_seconds == '8') $d_seconds = "08";
            if ($d_seconds == '9') $d_seconds = "09";

            if ($d_mon == '1') $d_mon = "01";
            if ($d_mon == '2') $d_mon = "02";
            if ($d_mon == '3') $d_mon = "03";
            if ($d_mon == '4') $d_mon = "04";
            if ($d_mon == '5') $d_mon = "05";
            if ($d_mon == '6') $d_mon = "06";
            if ($d_mon == '7') $d_mon = "07";
            if ($d_mon == '8') $d_mon = "08";
            if ($d_mon == '9') $d_mon = "09";

            if ($d_mday == '1') $d_mday = "01";
            if ($d_mday == '2') $d_mday = "02";
            if ($d_mday == '3') $d_mday = "03";
            if ($d_mday == '4') $d_mday = "04";
            if ($d_mday == '5') $d_mday = "05";
            if ($d_mday == '6') $d_mday = "06";
            if ($d_mday == '7') $d_mday = "07";
            if ($d_mday == '8') $d_mday = "08";
            if ($d_mday == '9') $d_mday = "09";

            if ($d_hours == '1') $d_hours = "01";
            if ($d_hours == '2') $d_hours = "02";
            if ($d_hours == '3') $d_hours = "03";
            if ($d_hours == '4') $d_hours = "04";
            if ($d_hours == '5') $d_hours = "05";
            if ($d_hours == '6') $d_hours = "06";
            if ($d_hours == '7') $d_hours = "07";
            if ($d_hours == '8') $d_hours = "08";
            if ($d_hours == '9') $d_hours = "09";

            if ($d_minutes == '1') $d_hours = "01";
            if ($d_minutes == '2') $d_hours = "02";
            if ($d_minutes == '3') $d_hours = "03";
            if ($d_minutes == '4') $d_hours = "04";
            if ($d_minutes == '5') $d_hours = "05";
            if ($d_minutes == '6') $d_hours = "06";
            if ($d_minutes == '7') $d_hours = "07";
            if ($d_minutes == '8') $d_hours = "08";
            if ($d_minutes == '9') $d_hours = "09";

            $day_now = $d_year . "-" . $d_mon . "-" . $d_mday . ' ' . $d_hours . ":" . $d_minutes . ":" . $d_seconds;

            if (isset($_REQUEST['sityno'])) {
                if ($_REQUEST['sityno'] == 'on') {
                    $order->house_dpd = $this->request->post('house_dpd');

                    if (($order->house_dpd == "") || ($order->house_dpd == null))
                        $order->house_dpd = $this->request->post('house_dpd_no');
                } else {
                    $order->house_dpd = null;
                }
            } else {
                $order->house_dpd = null;
            }

            if (($order->house_dpd == "") || ($order->house_dpd == null))
                $order->house_dpd = $this->request->post('house_dpd_no');

            $order->houseKorpus_dpd = $this->request->post('houseKorpus_dpd');

            if (($order->houseKorpus_dpd == null) || ($order->houseKorpus_dpd == "")) {
                $order->houseKorpus_dpd = $this->request->post('houseKorpus_dpd_no');
            }

            $order->houseApartment_dpd = $this->request->post('houseApartment_dpd');

            if (($order->houseApartment_dpd == null) || ($order->houseApartment_dpd == "")) {
                $order->houseApartment_dpd = $this->request->post('houseApartment_dpd_no');
            }

            $order->promokod = $this->request->post('promokod');

            if ($order->drug != 1) {
                $promocode = $order->promokod;
                $promocode = trim($promocode);
            }

            $order->to_apartment = $this->request->post('apartment');

            if ($order->to_apartment == 'checkbox') {
                $order->to_apartment = 1;
            } else {
                $order->to_apartment = 0;
            }

            $order->to_apartment = 1;

            $order->day_to_dpd = $this->request->post('day');

            if ($this->request->post('sity') == NULL) {
                $order->comment = $this->request->post('comment');
            } else {
                $str_city = $this->request->post('sity');

                $simpla_tmp = new Simpla();
                $db_server = $simpla_tmp->config->db_server;
                $db_user = $simpla_tmp->config->db_user;
                $db_password = $simpla_tmp->config->db_password;
                $db_name = $simpla_tmp->config->db_name;

                $mysqli = new mysqli($db_server, $db_user, $db_password, $db_name);

                $mysqli->set_charset("utf8");

                if ($result = $mysqli->query("SELECT * FROM `s_city` WHERE `cityid`='$str_city' LIMIT 1")) {
                    while ($r = $result->fetch_assoc()) {
                        $str_city_name = $r['cityname'];
                    }
                }

                $result->close();

                $str_tmp = $this->request->post('comment');

                if (isset($_REQUEST['sityno'])) {
                    if ($_REQUEST['sityno'] == 'on') {
                        $order->house_dpd = $this->request->post('house_dpd');

                        if (($order->house_dpd == "") || ($order->house_dpd == null)) {
                            $order->house_dpd = $this->request->post('house_dpd_no');
                        }

                        $order->discount = 0;

                        // $str_tmp = "DPD в город $str_city_name ($str_city) | $str_tmp";
                        // $order->comment = $str_tmp;
                    }
                }

                $order->house_dpd = $this->request->post('house_dpd');

                if (($order->house_dpd == "") || ($order->house_dpd == null)) {
                    $order->house_dpd = $this->request->post('house_dpd_no');
                    $order->discount = 0;
                }
            }

            if (($order->street_dpd != null) || ($order->street_dpd != '')) {
                if ($order->houseKorpus_dpd != NULL) {
                    $order->address = "г. $str_city_name $order->streetAbbr_dpd $order->street_dpd дом $order->house_dpd корпус $order->houseKorpus_dpd кв. $order->houseApartment_dpd";
                } else {
                    $order->address = "г. $str_city_name $order->streetAbbr_dpd $order->street_dpd дом $order->house_dpd $order->houseKorpus_dpd кв. $order->houseApartment_dpd";
                }
            }

            $order->card = $this->request->post('card');
            $order->ip = $_SERVER['REMOTE_ADDR'];

            $order->pay = 0;

            if (isset($_REQUEST['sityno'])) {
                if ($_REQUEST['sityno'] == 'on') {
                    $order->city_id_dpd = $this->request->post('sity');
                    $order->cost_price = $this->request->post('cost');
                    $order->discount = 0;
                } else {
                    $order->city_id_dpd = 0;
                    $order->cost_price = $this->request->post('cost');
                }
            } else {
                $order->city_id_dpd = 0;
                $order->cost_price = $this->request->post('cost');
            }

            $order->city_id_dpd = $this->request->post('sity');

            if ($order->city_id_dpd == null) $order->city_id_dpd = 0;

            if ($this->user) {
                $profile = new stdClass();
                $profile->uid = $this->user->id;
                $profile->phone = $this->request->post('phone');
                $profile->address = $this->request->post('address');
                $profile->destination_id = $this->request->post('destination_id');
                $profile->card = $this->request->post('card');
                if ($this->profiles->get_profile($profile->uid)) {
                    $this->profiles->update_profile($profile->uid, $profile);
                } else {
                    $this->profiles->add_profile($profile);
                }
            }

            $this->design->assign('delivery_id', $order->delivery_id);
            $this->design->assign('name', $order->name);
            $this->design->assign('email', $order->email);
            $this->design->assign('phone', $order->phone);
            $this->design->assign('address', $order->address);
            $this->design->assign('card', $order->card);
            $this->design->assign('comment', $order->comment);

            $captcha_code = $this->request->post('captcha_code', 'string');

            // Скидка
            $cart = $this->cart->get_cart();
            $order->discount = $cart->discount;

            if ($cart->coupon) {
                $order->coupon_discount = $cart->coupon_discount;
                $order->coupon_code = $cart->coupon->code;
            }

            if ($this->request->post('to_drug')) {
                $to_drug = $this->request->post('to_drug');
                if ($to_drug == 'on') {
                    $order->drug = 1;
                    if ($order->drug == 1) {
                        $order->promokod = null;
                        $order->delivery_id = null;
                        $order->cost_price = 0;
                        $order->city_id_dpd = 0;
                        $order->delivery_price = 0;
                        $order->destination_id = 3;
                        $order->discount = 0;
                        $order->address = 'АНО «Помощь бездомным собакам» 192148, г. Санкт-Петербург, Большой Смоленский пр. д.7-9, литер А';

                    }

                }
            }

            if (!empty($this->user->id))
                $order->user_id = $this->user->id;

            //if (empty($order->address)){
            //	$this->design->assign('error', 'address');
            //}
            //elseif(empty($order->name))
            //{
            //	$this->design->assign('error', 'empty_name');
            //}
            //elseif(empty($order->email))
            //{
            //	$this->design->assign('error', 'empty_email');
            //}
            //elseif((!isset($this->user)) && ($_SESSION['captcha_code'] != $captcha_code || empty($captcha_code)))
            //{
            //	$this->design->assign('error', 'captcha');
            //}
            if (empty($order->phone)) {
                $this->design->assign('error', 'phone');
            } elseif (empty($order->email)) {
                $this->design->assign('error', 'empty_email');
            } else {
                require_once($_SERVER['DOCUMENT_ROOT'] . '/api/Simpla.php');

                ////////// Коннектимся к БД ///////////////////////////////////////////////////////////////////////
                $simpla_new1 = new Simpla();
                $db_host = $simpla_new1->config->db_server;
                $db_user = $simpla_new1->config->db_user;
                $db_pass = $simpla_new1->config->db_password;
                $db_database = $simpla_new1->config->db_name;

                // Добавляем заказ в базу
                $order_id = $this->orders->add_order($order);
                $_SESSION['order_id'] = $order_id;

                // Если использовали купон, увеличим количество его использований
                if ($cart->coupon)
                    $this->coupons->update_coupon($cart->coupon->id, array('usages' => $cart->coupon->usages + 1));

                // Посчитаем кол-во sku попавших в акцию "X из списка" ( 2 из списка, 3 из списка, 4 из списка. Ищим Х = $a_variant_cunt)
                global $a_variant_cunt, $variant_sku, $variant_price_arr, $variant_price;
                $a_variant_cunt = 0;
                $variant_price_arr = array();

                global $all_discount, $sku_g;
                $all_discount = 0;

                $variant_in_promo_true = false;
                $card_of_friend = 0;
                $my_great_discount = 0;

                $card_user = $order->card;
                $email = $order->email;

                $simpla_new = new Simpla();
                $db_host = $simpla_new->config->db_server;
                $db_user = $simpla_new->config->db_user;
                $db_pass = $simpla_new->config->db_password;
                $db_database = $simpla_new->config->db_name;

                $mysqli = new mysqli($db_host, $db_user, $db_pass, $db_database);
                $mysqli->set_charset("utf8");

                $is_true = false;

                if (($card_user != null) && ($card_user != '')) {
                    if ($result_card = $mysqli->query("SELECT * FROM `s_discount_card` WHERE ((`card`='$card_user') AND (`email`='$email') AND (`enabled`='1'))")) {
                        while ($my_card = $result_card->fetch_assoc()) {
                            if ($my_card['id'] != null) {
                                $card_of_friend = 1;
                            }
                        }
                    }
                }

                $mysqli->close();

                $my_great_discount = 0;

                // Добавляем товары к заказу
                foreach ($this->request->post('amounts') as $variant_id => $amount) {

                    $day_x = "2016-02-20 15:38:46";
                    $day_x1 = "2016-02-24 1:00:00";

                    $my_total_price = $this->request->post('total_price');
                    $sum_with_card = 666;
                    $prm = $this->promos->sku_in_promo_no_url($variant_id);

                    $my_variant = $this->variants->get_variant($variant_id);
                    $my_price = $my_variant->price;
                    $my_price = round($my_price);

                    if (($prm != false) && (!empty($prm))) {

                        $type = $prm[0]['type'];
                        $discount_tmp_var = $prm[0]['discount'];

                        if ($type == 1) {
                            $variant_in_promo_true = true;
                            $sum_with_card = $prm[0]['sum_with_card'];

                            $price = $v->price;
                            $my_price = $my_price - $my_price * $discount_tmp_var / 100;
                        }
                    }

                    if ($card_of_friend == 1) {
                        $my_tmp_discount = $my_price - $my_price * 0.9;

                        $my_tmp_discount = $my_tmp_discount * $amount;

                        //echo "$my_tmp_discount<br>";

                        $my_great_discount = $my_great_discount + $my_tmp_discount;

                        if ($sum_with_card != 666) {
                            if ($sum_with_card != 1) {
                                $my_great_discount = $my_great_discount - $my_tmp_discount;
                            }
                        }
                    }

                    if ((($promocode == '2302ZO') || ($promocode == '2302Z0') || ($promocode == '23о2Z0') || ($promocode == '23о2ZO')) && ($my_total_price >= 2000)) {
                        if (($day_x <= $day_now) && ($day_x1 >= $day_now)) {

                            //
                            //
                            //

                        }
                    }


                    // Milton Babbitt – Ensembles For Synthesizer

                    $this->orders->add_purchase(array('order_id' => $order_id, 'variant_id' => intval($variant_id), 'amount' => intval($amount)), $card_of_friend);

                    $mysqli_a_variant = new mysqli($db_host, $db_user, $db_pass, $db_database);
                    $mysqli_a_variant->set_charset("utf8");

                    $variant_sku = '';
                    $variant_price = 0;

                    if ($result_variant_sku = $mysqli_a_variant->query("SELECT * FROM `s_variants` WHERE `id`='$variant_id' LIMIT 1")) {
                        while ($a_variant_sku = $result_variant_sku->fetch_assoc()) {
                            $variant_sku = $a_variant_sku['sku'];
                            $variant_price = $a_variant_sku['price'];
                        }
                    }

                    $mysqli_a_variant->close();

                    $mysqli_a_variant = new mysqli($db_host, $db_user, $db_pass, $db_database);
                    $mysqli_a_variant->set_charset("utf8");
                    $x = intval($amount);

                    if ($result_a_variant = $mysqli_a_variant->query("SELECT * FROM `a_variant` WHERE `sku`='$variant_sku' LIMIT 1")) {
                        while ($a_variant = $result_a_variant->fetch_assoc()) {
                            if ($a_variant['sku'] == $variant_sku) {
                                for ($i = 1; $i <= $x; $i++) {
                                    $variant_price_arr[] = $variant_price;
                                    $a_variant_cunt++;
                                }
                            }
                        }
                    }

                    $mysqli_a_variant->close();
                }

                //echo $my_great_discount; exit();

                $order = $this->orders->get_order($order_id);
                $this->orders->update_order($order->id, array('discount_price_promo' => round($all_discount)));
                $order = $this->orders->get_order($order_id);

                //echo $my_great_discount;
                //exit();

                // Стоимость доставки
                $delivery = $this->delivery->get_delivery($order->delivery_id);
                if (!empty($delivery) && $delivery->free_from > $order->total_price) {
                    $this->orders->update_order($order->id, array('delivery_price' => $delivery->price, 'separate_delivery' => $delivery->separate_payment));
                }
                ////////////////////////////////////////////////////////////////////

                $user_id = $order->user_id;

                $day_x = "2016-01-22 22:00:00";
                $day_x1 = "2016-01-25 23:59:59";

                $day_finish_main_action = "28122015"; //ДАТА ОКОНЧАНИЯ АКЦИИ

                $day_now_for_main_action = "";
                $day_now_for_main_action = $d[mday] . $d[mon] . $d[year];

                // скидка выходного деня
                if (($day_x <= $day_now) && ($day_x1 >= $day_now)) {
                    $total_price = $order->total_price;

                    $discount = $total_price * 10 / 100;
                    $this->orders->update_order($order->id, array('discount_price_promo' => round($discount)));
                } elseif (($promocode != null) && ($variant_in_promo_true == false)) {
                    $main_promocode_active = false;

                    if ($day_now_for_main_action < $day_finish_main_action) {

                        if (($promocode == 'promo1000') || ($promocode == 'PROMO1000') || ($promocode == 'Promo1000') || ($promocode == 'promo1ooo') || ($promocode == 'Promo1ooo')) {

                            $total_price = $order->total_price;

                            if ($total_price >= 10000) {

                                $discount = 1000;
                                $this->orders->update_order($order->id, array('discount_price_promo' => round($discount)));

                                $main_promocode_active = true;
                            }
                        }
                    }

                    if (!($main_promocode_active)) {

                        if (isset($_REQUEST['sityno'])) {
                            if ($_REQUEST['sityno'] == 'on') {
                                if ($order->drug != 1) {
                                    $order->city_id_dpd = $this->request->post('sity');
                                }

                                $order->cost_price = $this->request->post('cost');
                            } else {
                                $order->city_id_dpd = 0;
                                $order->cost_price = 0;
                            }
                        } else {
                            $order->city_id_dpd = 0;
                            $order->cost_price = 0;
                        }

                        if ($order->drug == 1) $order->cost_price = 0;

                        $cost_price = $order->cost_price;

                        if ($cost_price > 0) $order->city_id_dpd = $this->request->post('sity');

                        //echo $order->city_id_dpd;

                        $total_price = $order->total_price;

                        $clear_price = $total_price - $cost_price;

                        $mysqli = new mysqli($db_host, $db_user, $db_pass, $db_database);
                        $mysqli->set_charset("utf8");

                        $cunt_promo = 0;

                        if ($result = $mysqli->query("SELECT * FROM `s_orders` WHERE `id`='$order_id' LIMIT 1")) {
                            while ($my_order = $result->fetch_assoc()) {

                                $activity_promo = $email_promo = null;

                                $result_promocode = $mysqli->query("SELECT * FROM `s_promocode` WHERE `promocode`='$promocode' LIMIT 1");
                                while ($r = $result_promocode->fetch_assoc()) {

                                    $activity = $r['activity'];
                                    $email_promo = $r['email'];

                                    if ($activity == 1) {
                                        $discount = $clear_price * 5 / 100;

                                        $this->orders->update_order($order->id, array('discount_price_promo' => round($discount)));

                                        if ($promocode != 'zD0015-pr01') {
                                            $query = "UPDATE `s_promocode` SET `activity`='0' WHERE `promocode`='$promocode'";
                                            $result_promocode_update = $mysqli->query($query);
                                        }
                                    }
                                }
                            }
                        }

                        // http://www.catsdogs.ru
                        if (($promocode == 'zoo812') || ($promocode == 'ZOO812')) {
                            $day_promo_x_catanddogs = "2016-02-07 23:59:59";

                            if ($day_promo_x_catanddogs >= $day_now) {
                                if ($clear_price >= 3000) {
                                    $discount = $clear_price * 10 / 100;
                                    $this->orders->update_order($order->id, array('discount_price_promo' => round($discount)));
                                }
                            }
                        }

                        if (($promocode == 'NY2016') || ($promocode == 'ny2016')) {

                            $day_promo_x = "2015-12-18 22:00:00";
                            $day_promo_x1 = "2015-12-27 23:59:59";

                            if (($day_promo_x <= $day_now) && ($day_promo_x1 >= $day_now)) {

                                if ($clear_price >= 3500) {
                                    $discount = 300;
                                    $this->orders->update_order($order->id, array('discount_price_promo' => round($discount)));
                                }
                            }
                        }

                        // функция расчета разницы между двемя датами в днях
                        function get_duration($date_from, $date_till)
                        {
                            $date_from = explode('-', $date_from);
                            $date_till = explode('-', $date_till);

                            $time_from = mktime(0, 0, 0, $date_from[1], $date_from[2], $date_from[0]);
                            $time_till = mktime(0, 0, 0, $date_till[1], $date_till[2], $date_till[0]);

                            $diff = ($time_till - $time_from) / 60 / 60 / 24;
                            //$diff = date('d', $diff); - как делал))

                            return $diff;
                        }

                        // ========= ПРОМОКОДЫ *_ OLD _ * ============
                        // Брошенная корзина [брошенная корзина 4%]
                        if ($promocode == 'ASC4$abShcaR4') {
                            $discount = $clear_price * 4 / 100;

                            $this->orders->update_order($order->id, array('discount_price_promo' => round($discount)));
                        }

                        // Купленная корзина [купленная корзина 3%]
                        if ($promocode == 'BC3$caBoU3') {
                            $discount = $clear_price * 3 / 100;

                            $this->orders->update_order($order->id, array('discount_price_promo' => round($discount)));
                        }

                        // Отказ от заказа [уход с сайта 5%]
                        if ($promocode == 'RTO5$caReS5') {
                            $discount = $clear_price * 5 / 100;

                            $this->orders->update_order($order->id, array('discount_price_promo' => round($discount)));
                        }

                        // Приветственное письмо [приветственное 5%]
                        if ($promocode == 'PL5$welDiS5') {
                            $discount = $clear_price * 5 / 100;

                            $this->orders->update_order($order->id, array('discount_price_promo' => round($discount)));
                        }

                        // ========= ПРОМОКОДЫ *_ ТУЦ _ * ============
                        // Брошенная корзина [брошенная корзина 4%]
                        if ($promocode == 'ASC4$s45Gff') {
                            $discount = $clear_price * 4 / 100;

                            $this->orders->update_order($order->id, array('discount_price_promo' => round($discount)));
                        }

                        // Купленная корзина [купленная корзина 3%]
                        if ($promocode == 'BC3$2dGdgf') {
                            $discount = $clear_price * 3 / 100;

                            $this->orders->update_order($order->id, array('discount_price_promo' => round($discount)));
                        }

                        // Отказ от заказа [уход с сайта 5%]
                        if ($promocode == 'RTO5$sD3dgx') {
                            $discount = $clear_price * 5 / 100;

                            $this->orders->update_order($order->id, array('discount_price_promo' => round($discount)));
                        }

                        // Приветственное письмо [приветственное 5%]
                        if ($promocode == 'PL5$ds4dFx') {
                            $discount = $clear_price * 5 / 100;

                            $this->orders->update_order($order->id, array('discount_price_promo' => round($discount)));
                        }

                        mysqli_close($connection);
                    }
                } //

                if ($order->drug == 1) $order->cost_price = 0;

                $card_user = $order->card;
                $email = $order->email;

                $simpla_new = new Simpla();
                $db_host = $simpla_new->config->db_server;
                $db_user = $simpla_new->config->db_user;
                $db_pass = $simpla_new->config->db_password;
                $db_database = $simpla_new->config->db_name;

                $mysqli = new mysqli($db_host, $db_user, $db_pass, $db_database);
                $mysqli->set_charset("utf8");

                $is_true = false;

                if (($card_user != null) && ($card_user != '')) {
                    if ($result_card = $mysqli->query("SELECT * FROM `s_discount_card` WHERE ((`card`='$card_user') AND (`email`='$email') AND (`enabled`='1'))")) {
                        while ($my_card = $result_card->fetch_assoc()) {
                            if ($my_card['id'] != null) {
                                $is_true = true;
                            }
                        }
                    }
                }

                $mysqli->close();

                if ($is_true == true) {

                    if (($order->destination_id != '666') && ($order->city_id_dpd == '0')) {
                        $cost_price = $order->cost_price;
                        $total_price = $order->total_price;
                        $clear_price = $total_price - $cost_price;

                        //$discount = $total_price*0.9;

                        $discount = $my_great_discount;

                        $this->orders->update_order($order->id, array('discount_price_promo' => round($discount)));
                    }
                }

                /*
                global $discount_variant;

                if ($a_variant_cunt >= 2){
                    foreach ($variant_price_arr as $value){
                        $price_tmp = intval($value);
                        $discount_variant_tmp = 0;
                        $discount_variant_tmp = ($price_tmp * 15) / 100;

                        $discount_variant_tmp_i = intval($discount_variant_tmp);

                        $discount_variant = $discount_variant + $discount_variant_tmp_i;
                    }
                }

                if ($a_variant_cunt >= 2){
                    $this->orders->update_order($order->id, array('discount_price_promo'=>$discount_variant));
                }
                */
                ///////////////////////////////////////////

                // Отправляем письмо пользователю
                $this->notify->email_order_user($order->id);

                // Отправляем письмо администратору
                $this->notify->email_order_admin($order->id);

                // Очищаем корзину (сессию)
                $this->cart->empty_cart();

                // регистрация пользоватя

                $register = 'on';

                if ($register == 'on') {

                    $default_status = 0; // Активен ли пользователь сразу после регистрации (0 или 1)

                    $name = $order->name;
                    $surname = '';
                    $fathersname = '';
                    $birthdate = '';
                    $sex = '';
                    $email = $order->email;

                    $rp = array(
                        '1', '2', '3', '4', '5', '6', '7', '8', '9', '0', '-',
                        'a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i', 'j', 'k', 'l', 'm', 'n',
                        'o', 'p', 'q', 'r', 's', 't', 'u', 'v', 'w', 'x', 'y', 'z',
                        'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M', 'N',
                        'O', 'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z'
                    );

                    shuffle($rp);

                    $dlpsw = 12;
                    $dlrp = sizeof($rp) - 1; // запоминаем длину массива
                    $psw = '';
                    for ($i = 0; $i < $dlpsw; $i++) {
                        $psw = $psw . ($rp[rand(0, $dlrp)]);
                    }

                    $password = $psw;
                    $this->design->assign('name', $name);
                    $this->design->assign('email', $email);

                    $this->db->query('SELECT count(*) as count FROM __users WHERE email=?', $email);
                    $user_exists = $this->db->result('count');

                    function random_string($length, $chartypes)
                    {
                        $chartypes_array = explode(",", $chartypes);
                        // задаем строки символов.
                        //Здесь вы можете редактировать наборы символов при необходимости
                        $lower = 'abcdefghijklmnopqrstuvwxyz'; // lowercase
                        $upper = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ'; // uppercase
                        $numbers = '1234567890'; // numbers
                        $special = '^@*+-+%()!?'; //special characters
                        $chars = "";
                        // определяем на основе полученных параметров,
                        //из чего будет сгенерирована наша строка.
                        if (in_array('all', $chartypes_array)) {
                            $chars = $lower . $upper . $numbers . $special;
                        } else {
                            if (in_array('lower', $chartypes_array))
                                $chars = $lower;
                            if (in_array('upper', $chartypes_array))
                                $chars .= $upper;
                            if (in_array('numbers', $chartypes_array))
                                $chars .= $numbers;
                            if (in_array('special', $chartypes_array))
                                $chars .= $special;
                        }
                        // длина строки с символами
                        $chars_length = strlen($chars) - 1;
                        // создаем нашу строку,
                        //извлекаем из строки $chars символ со случайным
                        //номером от 0 до длины самой строки
                        $string = $chars{rand(0, $chars_length)};
                        // генерируем нашу строку
                        for ($i = 1; $i < $length; $i = strlen($string)) {
                            // выбираем случайный элемент из строки с допустимыми символами
                            $random = $chars{rand(0, $chars_length)};
                            // убеждаемся в том, что два символа не будут идти подряд
                            if ($random != $string{$i - 1}) $string .= $random;
                        }
                        // возвращаем результат
                        return $string;
                    }

                    global $string_code;
                    $string_code = '';
                    $code_for_reg = false;

                    while ($code_for_reg == false) {
                        $length_code = 30;
                        $chartypes_code = "lower,numbers";
                        $string_code = random_string($length_code, $chartypes_code);

                        $code_for_reg = true;

                        ////////// Коннектимся к БД //////////////////////////////////////////////
                        $mysqli_code = new mysqli($db_host, $db_user, $db_pass, $db_database);
                        $mysqli_code->set_charset("utf8");

                        if ($result_code = $mysqli_code->query("SELECT * FROM `s_users` WHERE `code`='$string_cod' LIMIT 1")) {
                            while ($my_code = $result_code->fetch_assoc()) {
                                if ($my_code['code'] == $string_code)
                                    $code_for_reg = false;
                            }
                        }

                        $mysqli_code->close();
                    }

                    if ($user_exists)
                        $this->design->assign('error', 'user_exists');

                    elseif ($user_id = $this->users->add_user(array('code' => $string_code, 'name' => $name, 'surname' => $surname, 'fathersname' => $fathersname, 'birthdate' => $birthdate, 'sex' => $sex, 'email' => $email, 'password' => $password, 'enabled' => $default_status, 'last_ip' => $_SERVER['REMOTE_ADDR']))) {
                        if ($this->request->post('ml-email')) {
                            $this->subscriptions->subscribe_email($user_id);
                        }

                        if ($this->request->post('ml-sms')) {
                            $this->subscriptions->subscribe_sms($user_id);
                        }

                        if ($this->request->post('ml-phone')) {
                            $this->subscriptions->subscribe_phone($user_id);
                        }

                        $profile = new stdClass();
                        $profile->uid = $user_id;
                        $profile->address = $this->request->post('address');
                        $profile->phone = $this->request->post('phone');
                        $profile->home_phone = $this->request->post('home_phone');
                        $profile->card = $this->request->post('card');

                        $this->profiles->add_profile($profile);

                        $phone_user = $this->request->post('phone');
                        $address_user = $this->request->post('address');

                        if ($address_user == 'АНО «Помощь бездомным собакам» 192148, г. Санкт-Петербург, Большой Смоленский пр. д.7-9, литер А') {
                            $address_user = '(Пожалуйста, заполните это поле в своем личном кабинете)';
                        }

                        $home_phone_user = $this->request->post('home_phone');
                        $card_user = $this->request->post('card');

                        // Отправка письма пользователю
                        $to = $email;
                        $from_user = 'zoo812.ru';
                        $from_email = 'noreply@zoo812.ru';
                        $subject = 'Спасибо за регистрацию';
                        $message = "Спасибо за регистрацию, $name $surname!<br><br>
						
						
						
						
						Ваш логин от сайта zoo812.ru: <b>$email</b><br>
						Ваш пароль: <b>$password</b><br><br>
						Вы можете изменить свои данные в личном кабинете на сайте<br>
						
						Иванко Доставка - интернет зоомагазин товаров для животных,
						кормов для кошек и собак, наполнителей для туалета, домиков,
						когтеточек. Мы осуществляем бесплатную доставку при заказе от 700 рублей.";

                        $headers = "From: $from_user <$from_email>\r\n" .
                            "MIME-Version: 1.0" . "\r\n" .
                            "Content-type: text/html; charset=UTF-8" . "\r\n";

                        //mail($to, $subject, $message, $headers);
                        // Конец отправки письма пользователю

                        $root_url = $this->config->root_url;

                        $url_for_e = $root_url . '/index.php?module=UserView&code=' . $string_code;

                        // Письмо мне
                        $message = "<div id=':1m3' class='ii gt m14e1f96b7c54b3f8 adP adO'>
<div id=':1lz' class='a3s' style='overflow: hidden;'>
<div class='adM'>
</div>


<div bgcolor='#FFFFFF' marginheight='0' marginwidth='0' style='margin:0;padding:0;font-family:&quot;Helvetica Neue&quot;,&quot;Helvetica&quot;,Helvetica,Arial,sans-serif;min-height:100%;width:100%!important'>


<table bgcolor='#E2E2E2' style='margin:0;padding:0;font-family:&quot;Helvetica Neue&quot;,&quot;Helvetica&quot;,Helvetica,Arial,sans-serif;width:100%'>
    <tbody><tr style='margin:0;padding:0;font-family:&quot;Helvetica Neue&quot;,&quot;Helvetica&quot;,Helvetica,Arial,sans-serif'>
        <td style='margin:0;padding:0;font-family:&quot;Helvetica Neue&quot;,&quot;Helvetica&quot;,Helvetica,Arial,sans-serif'></td>
        <td align='' style='margin:0 auto!important;padding:0;font-family:&quot;Helvetica Neue&quot;,&quot;Helvetica&quot;,Helvetica,Arial,sans-serif;display:block!important;max-width:600px!important;clear:both!important'>

            
            <div style='margin:0 auto;padding:10px;font-family:&quot;Helvetica Neue&quot;,&quot;Helvetica&quot;,Helvetica,Arial,sans-serif;max-width:600px;display:block'>
                <table style='margin:0;padding:0;font-family:&quot;Helvetica Neue&quot;,&quot;Helvetica&quot;,Helvetica,Arial,sans-serif;width:100%'>
                    <tbody><tr style='margin:0;padding:0;font-family:&quot;Helvetica Neue&quot;,&quot;Helvetica&quot;,Helvetica,Arial,sans-serif'>
                        <td style='margin:0;padding:0;font-family:&quot;Helvetica Neue&quot;,&quot;Helvetica&quot;,Helvetica,Arial,sans-serif'><img src='https://ci4.googleusercontent.com/proxy/zkJKIwGr5WN0zukTnuWUidVd-8gJTJs3a37rosY9QBGAY7D_prHdgs8_YqdsEkgWign7wXmGlOmSFQ3SPwCi7sxSc90_JgfiwFQ=s0-d-e1-ft#http://zoo812.ru/design/zoo812/images/email_logo.png' alt='Иванко Доставка' title='Иванко Доставка' style='margin:0;padding:0;font-family:&quot;Helvetica Neue&quot;,&quot;Helvetica&quot;,Helvetica,Arial,sans-serif;max-width:100%' class='CToWUd'></td>
                        <td align='right' style='margin:0;padding:0;font-family:&quot;Helvetica Neue&quot;,&quot;Helvetica&quot;,Helvetica,Arial,sans-serif'><h6 style='margin:0!important;padding:0;font-family:&quot;HelveticaNeue-Light&quot;,&quot;Helvetica Neue Light&quot;,&quot;Helvetica Neue&quot;,Helvetica,Arial,&quot;Lucida Grande&quot;,sans-serif;line-height:1.1;margin-bottom:5px;color:#666;font-weight:900;font-size:14px'>Ваши питомцы будут довольны!</h6></td>
                    </tr>
                </tbody></table>
            </div>

        </td>
        <td style='margin:0;padding:0;font-family:&quot;Helvetica Neue&quot;,&quot;Helvetica&quot;,Helvetica,Arial,sans-serif'></td>
    </tr>
</tbody></table>


<table bgcolor='' style='margin:0;padding:0;font-family:&quot;Helvetica Neue&quot;,&quot;Helvetica&quot;,Helvetica,Arial,sans-serif;width:100%'>
    <tbody><tr style='margin:0;padding:0;font-family:&quot;Helvetica Neue&quot;,&quot;Helvetica&quot;,Helvetica,Arial,sans-serif'>
        <td style='margin:0;padding:0;font-family:&quot;Helvetica Neue&quot;,&quot;Helvetica&quot;,Helvetica,Arial,sans-serif'></td>
        <td align='' bgcolor='#FFFFFF' style='margin:0 auto!important;padding:0;font-family:&quot;Helvetica Neue&quot;,&quot;Helvetica&quot;,Helvetica,Arial,sans-serif;display:block!important;max-width:600px!important;clear:both!important'>

            
            <div style='margin:0 auto;padding:10px;font-family:&quot;Helvetica Neue&quot;,&quot;Helvetica&quot;,Helvetica,Arial,sans-serif;max-width:600px;display:block'>
                <table style='margin:0;padding:0;font-family:&quot;Helvetica Neue&quot;,&quot;Helvetica&quot;,Helvetica,Arial,sans-serif;width:100%'>
                    <tbody><tr style='margin:0;padding:0;font-family:&quot;Helvetica Neue&quot;,&quot;Helvetica&quot;,Helvetica,Arial,sans-serif'>
                        <td style='margin:0;padding:0;font-family:&quot;Helvetica Neue&quot;,&quot;Helvetica&quot;,Helvetica,Arial,sans-serif'>
                        
                        	
                        	
                        	

                            <h1 style='margin:0;padding:0;font-family:&quot;HelveticaNeue-Light&quot;,&quot;Helvetica Neue Light&quot;,&quot;Helvetica Neue&quot;,Helvetica,Arial,&quot;Lucida Grande&quot;,sans-serif;line-height:1.1;margin-bottom:15px;color:#ad536c;font-weight:900;font-size:22px;margin-top:10px'>Спасибо за регистрацию!</h1>
                            
                            <div style='margin-bottom: 15px;'>Для завершения регистрации на сайте интернет-магазина Иванко Доставка (www.zoo812.ru) подтвердите, пожалуйста, адрес Вашей электронной почты. Для этого перейдите по ссылке: <a href=\"$url_for_e\">$url_for_e</a></div>
                            
                            <p style='margin:0;padding:0;font-family:&quot;Helvetica Neue&quot;,&quot;Helvetica&quot;,Helvetica,Arial,sans-serif;margin-bottom:10px;font-weight:normal;font-size:13px;color:#414141;line-height:1.6'>Спасибо за регистрацию на сайте zoo812.ru
<br><br>
Зарегистрированные пользователи могут:<br>
- просматривать историю заказов<br>
- получать персональные бонусы и скидки<br>
</p>
           
                        </td>
                    </tr>
                </tbody></table>
            </div>
            

            <div style='margin:0 auto;padding:10px;font-family:&quot;Helvetica Neue&quot;,&quot;Helvetica&quot;,Helvetica,Arial,sans-serif;max-width:600px;display:block'>
                <table style='margin:0;padding:0;font-family:&quot;Helvetica Neue&quot;,&quot;Helvetica&quot;,Helvetica,Arial,sans-serif;width:100%'>
                    <tbody><tr style='margin:0;padding:0;font-family:&quot;Helvetica Neue&quot;,&quot;Helvetica&quot;,Helvetica,Arial,sans-serif'>
                        <td style='margin:0;padding:0;font-family:&quot;Helvetica Neue&quot;,&quot;Helvetica&quot;,Helvetica,Arial,sans-serif'>

                            <h2 style='margin:0;padding:0;font-family:&quot;HelveticaNeue-Light&quot;,&quot;Helvetica Neue Light&quot;,&quot;Helvetica Neue&quot;,Helvetica,Arial,&quot;Lucida Grande&quot;,sans-serif;line-height:1.1;margin-bottom:15px;color:#ad536c;font-weight:900;font-size:18px;margin-top:10px'>Ваши регистрационные данные:</h2>
                            <p style='margin:0;padding:0;font-family:&quot;Helvetica Neue&quot;,&quot;Helvetica&quot;,Helvetica,Arial,sans-serif;margin-bottom:10px;font-weight:normal;font-size:13px;color:#414141;line-height:1.6'>Логин: <strong>$email</strong></p>
                            <p style='margin:0;padding:0;font-family:&quot;Helvetica Neue&quot;,&quot;Helvetica&quot;,Helvetica,Arial,sans-serif;margin-bottom:10px;font-weight:normal;font-size:13px;color:#414141;line-height:1.6'>Пароль: <strong>$password</strong></p>
                            <p style='margin:0;padding:0;font-family:&quot;Helvetica Neue&quot;,&quot;Helvetica&quot;,Helvetica,Arial,sans-serif;margin-bottom:10px;font-weight:normal;font-size:13px;color:#414141;line-height:1.6'>Вы можете изменить свой пароль в личном кабниете, пройдя <a href='/user/'>по ссылке</a></strong></p>
                            <p style='margin:0;padding:0;font-family:&quot;Helvetica Neue&quot;,&quot;Helvetica&quot;,Helvetica,Arial,sans-serif;margin-bottom:10px;font-weight:normal;font-size:13px;color:#414141;line-height:1.6'><strong>Желаем вам приятных <a href='http://www.zoo812.ru'>покупок</a>!</strong></p>
                            
                        </td>
                    </tr>
                </tbody></table>
            </div>
            
            <div style='margin:0 auto;padding:10px;font-family:&quot;Helvetica Neue&quot;,&quot;Helvetica&quot;,Helvetica,Arial,sans-serif;max-width:600px;display:block'>
                <table bgcolor='' style='margin:0;padding:0;font-family:&quot;Helvetica Neue&quot;,&quot;Helvetica&quot;,Helvetica,Arial,sans-serif;width:100%'>
                    <tbody><tr style='margin:0;padding:0;font-family:&quot;Helvetica Neue&quot;,&quot;Helvetica&quot;,Helvetica,Arial,sans-serif'>
                        <td style='margin:0;padding:0;font-family:&quot;Helvetica Neue&quot;,&quot;Helvetica&quot;,Helvetica,Arial,sans-serif'>

                            
                            <table bgcolor='' width='100%' style='margin:0;padding:0;font-family:&quot;Helvetica Neue&quot;,&quot;Helvetica&quot;,Helvetica,Arial,sans-serif;background-color:#ebebeb;width:100%'>
                                <tbody><tr style='margin:0;padding:0;font-family:&quot;Helvetica Neue&quot;,&quot;Helvetica&quot;,Helvetica,Arial,sans-serif'>
                                    <td style='margin:0;padding:0;font-family:&quot;Helvetica Neue&quot;,&quot;Helvetica&quot;,Helvetica,Arial,sans-serif'>

                                        <div style='margin:0;padding:0;font-family:&quot;Helvetica Neue&quot;,&quot;Helvetica&quot;,Helvetica,Arial,sans-serif;width:280px;float:left;min-width:279px'>
                                            <table bgcolor='' cellpadding='' align='left' style='margin:0;padding:0;font-family:&quot;Helvetica Neue&quot;,&quot;Helvetica&quot;,Helvetica,Arial,sans-serif;width:100%'>
                                                <tbody><tr style='margin:0;padding:0;font-family:&quot;Helvetica Neue&quot;,&quot;Helvetica&quot;,Helvetica,Arial,sans-serif'>
                                                    <td style='margin:0;padding:15px;font-family:&quot;Helvetica Neue&quot;,&quot;Helvetica&quot;,Helvetica,Arial,sans-serif'>

                                                        <h5 style='margin:0;padding:0;font-family:&quot;HelveticaNeue-Light&quot;,&quot;Helvetica Neue Light&quot;,&quot;Helvetica Neue&quot;,Helvetica,Arial,&quot;Lucida Grande&quot;,sans-serif;line-height:1.1;margin-bottom:15px;color:#3d3d3d;font-weight:700;font-size:13px'>Вступайте в наши группы:</h5>
                                                        <p style='margin:0;padding:0;font-family:&quot;Helvetica Neue&quot;,&quot;Helvetica&quot;,Helvetica,Arial,sans-serif;margin-bottom:10px;font-weight:normal;font-size:13px;color:#414141;line-height:1.6'><a href='http://vk.com/zoo812' style='margin:0;padding:3px 7px;font-family:&quot;Helvetica Neue&quot;,&quot;Helvetica&quot;,Helvetica,Arial,sans-serif;color:#fff;font-size:12px;margin-bottom:10px;text-decoration:none;font-weight:bold;display:block;text-align:center;background-color:#4e729a!important' target='_blank'>Вконтакте</a>
                                                        <a href='https://twitter.com/ivanko_dostavka' style='margin:0;padding:3px 7px;font-family:&quot;Helvetica Neue&quot;,&quot;Helvetica&quot;,Helvetica,Arial,sans-serif;color:#fff;font-size:12px;margin-bottom:10px;text-decoration:none;font-weight:bold;display:block;text-align:center;background-color:#4e729a!important' target='_blank'>Twitter</a> 
                                                        
                                                        </p>


                                                    </td>
                                                </tr>
                                            </tbody></table>
                                        </div>

                                        <div style='margin:0;padding:0;font-family:&quot;Helvetica Neue&quot;,&quot;Helvetica&quot;,Helvetica,Arial,sans-serif;width:280px;float:left;min-width:279px'>
                                            <table bgcolor='' cellpadding='' align='left' style='margin:0;padding:0;font-family:&quot;Helvetica Neue&quot;,&quot;Helvetica&quot;,Helvetica,Arial,sans-serif;width:100%'>
                                                <tbody><tr style='margin:0;padding:0;font-family:&quot;Helvetica Neue&quot;,&quot;Helvetica&quot;,Helvetica,Arial,sans-serif'>
                                                    <td style='margin:0;padding:15px;font-family:&quot;Helvetica Neue&quot;,&quot;Helvetica&quot;,Helvetica,Arial,sans-serif'>

                                                        <h5 style='margin:0;padding:0;font-family:&quot;HelveticaNeue-Light&quot;,&quot;Helvetica Neue Light&quot;,&quot;Helvetica Neue&quot;,Helvetica,Arial,&quot;Lucida Grande&quot;,sans-serif;line-height:1.1;margin-bottom:15px;color:#3d3d3d;font-weight:700;font-size:13px'>Контактная информация:</h5>
                                                        <p style='margin:0;padding:0;font-family:&quot;Helvetica Neue&quot;,&quot;Helvetica&quot;,Helvetica,Arial,sans-serif;margin-bottom:10px;font-weight:normal;font-size:13px;color:#414141;line-height:1.6'>Телефоны:<br> <strong style='margin:0;padding:0;font-family:&quot;Helvetica Neue&quot;,&quot;Helvetica&quot;,Helvetica,Arial,sans-serif'>
                                                        	8 (812) 777-04-40<br>
                                                        	8 (800) 555-16-64 </strong><br>(бесплатный звонок по России) </strong><br style='margin:0;padding:0;font-family:&quot;Helvetica Neue&quot;,&quot;Helvetica&quot;,Helvetica,Arial,sans-serif'>
                                                        	с 9:00 до 21:00 без выходных<br style='margin:0;padding:0;font-family:&quot;Helvetica Neue&quot;,&quot;Helvetica&quot;,Helvetica,Arial,sans-serif'>
                                                            Наша почта: <strong style='margin:0;padding:0;font-family:&quot;Helvetica Neue&quot;,&quot;Helvetica&quot;,Helvetica,Arial,sans-serif'><a href='mailto:dostavka@ivanki.ru' style='margin:0;padding:0;font-family:&quot;Helvetica Neue&quot;,&quot;Helvetica&quot;,Helvetica,Arial,sans-serif;color:#535353' target='_blank'>dostavka@ivanki.ru</a></strong>
                                                            </p><br style='margin:0;padding:0;font-family:&quot;Helvetica Neue&quot;,&quot;Helvetica&quot;,Helvetica,Arial,sans-serif'>

                                                    </td>
                                                </tr>
                                            </tbody></table>
                                        </div>

                                        <div style='margin:0;padding:0;font-family:&quot;Helvetica Neue&quot;,&quot;Helvetica&quot;,Helvetica,Arial,sans-serif;display:block;clear:both'></div>

                                    </td>
                                </tr>
                            </tbody></table>

                        </td>
                    </tr>
                </tbody></table>
            </div>


        </td>
        <td style='margin:0;padding:0;font-family:&quot;Helvetica Neue&quot;,&quot;Helvetica&quot;,Helvetica,Arial,sans-serif'></td>
    </tr>
</tbody></table>


<table style='margin:0;padding:0;font-family:&quot;Helvetica Neue&quot;,&quot;Helvetica&quot;,Helvetica,Arial,sans-serif;width:100%;clear:both!important'>
    <tbody><tr style='margin:0;padding:0;font-family:&quot;Helvetica Neue&quot;,&quot;Helvetica&quot;,Helvetica,Arial,sans-serif'>
        <td style='margin:0;padding:0;font-family:&quot;Helvetica Neue&quot;,&quot;Helvetica&quot;,Helvetica,Arial,sans-serif'></td>
        <td style='margin:0 auto!important;padding:0;font-family:&quot;Helvetica Neue&quot;,&quot;Helvetica&quot;,Helvetica,Arial,sans-serif;display:block!important;max-width:600px!important;clear:both!important'>

            
            <div style='margin:0 auto;padding:10px;font-family:&quot;Helvetica Neue&quot;,&quot;Helvetica&quot;,Helvetica,Arial,sans-serif;max-width:600px;display:block'>
                <table style='margin:0;padding:0;font-family:&quot;Helvetica Neue&quot;,&quot;Helvetica&quot;,Helvetica,Arial,sans-serif;width:100%'>
                    <tbody><tr style='margin:0;padding:0;font-family:&quot;Helvetica Neue&quot;,&quot;Helvetica&quot;,Helvetica,Arial,sans-serif'>
                        <td align='center' style='margin:0;padding:0;font-family:&quot;Helvetica Neue&quot;,&quot;Helvetica&quot;,Helvetica,Arial,sans-serif'>
                            <p style='margin:0;padding:0;font-family:&quot;Helvetica Neue&quot;,&quot;Helvetica&quot;,Helvetica,Arial,sans-serif;margin-bottom:10px;font-weight:normal;font-size:13px;color:#414141;line-height:1.6'>
                                <a href='/o-nas' style='margin:0;padding:0;font-family:&quot;Helvetica Neue&quot;,&quot;Helvetica&quot;,Helvetica,Arial,sans-serif;color:#535353' target='_blank'>О нас</a> |
                                <a href='/dostavka' style='margin:0;padding:0;font-family:&quot;Helvetica Neue&quot;,&quot;Helvetica&quot;,Helvetica,Arial,sans-serif;color:#535353' target='_blank'>Условия доставки</a> |
                                <a href='/contact' style='margin:0;padding:0;font-family:&quot;Helvetica Neue&quot;,&quot;Helvetica&quot;,Helvetica,Arial,sans-serif;color:#535353' target='_blank'>Контакты</a>
                            </p>
                            <p>
                            <div class='baner_ym' style='margin: 0 auto; width: 418px; max-width: 418px;'>
            					<img src='/files/uploads/al-zoo812-13x20.png' border='0' width='418' height='40' alt='Читайте отзывы покупателей и оценивайте качество магазина на Яндекс.Маркете' /></a>
	         				</div>
                            </p>
                        </td>
                    </tr>
                </tbody></table>
            </div>

        </td>
        <td style='margin:0;padding:0;font-family:&quot;Helvetica Neue&quot;,&quot;Helvetica&quot;,Helvetica,Arial,sans-serif'></td>
    </tr>
</tbody></table><div class='yj6qo'></div><div class='adL'>

</div></div><div class='adL'>




</div></div></div>";
                        $to = $email;
                        $from_user = 'zoo812.ru';
                        $from_email = 'noreply@zoo812.ru';
                        $subject = 'Спасибо за регистрацию';
                        $headers = "From: $from_user <$from_email>\r\n" .
                            "MIME-Version: 1.0" . "\r\n" .
                            "Content-type: text/html; charset=UTF-8" . "\r\n";
                        mail($to, $subject, $message, $headers);

                        // Письмо нам
                        $to = 'dostavka@ivanki.ru';
                        $from_user = 'zoo812.ru';
                        $from_email = 'noreply@zoo812.ru';
                        $subject = 'Зарегестрирован новый пользователь';
                        $message = "На сайте zoo812.ru зарегестрирован новый пользователь: $name $surname $fathersname.<br><br>
						E-mail: <b>$email</b><br>
						Телефон: <b>$phone_user</b><br>
                		Домашний телефон: <b>$home_phone_user</b><br>
				        Адрес: <b>$address_user</b><br>
						Карта: <b>$card_user</b><br>";

                        $headers = "From: $from_user <$from_email>\r\n" .
                            "MIME-Version: 1.0" . "\r\n" .
                            "Content-type: text/html; charset=UTF-8" . "\r\n";

                        mail($to, $subject, $message, $headers);
                        // Конец письма для нас

                    }
                }

                $ml_email = $this->request->post('ml-email');


                if ($ml_email == 'on') {

                    if ($curl = curl_init()) {
                        curl_setopt($curl, CURLOPT_URL, 'https://login.inboxer.pro/subscribe.php');
                        curl_setopt($curl, CURLOPT_RETURNTRANSFER, true);
                        curl_setopt($curl, CURLOPT_POST, true);
                        curl_setopt($curl, CURLOPT_POSTFIELDS, "FormValue_ListID=326&FormValue_Command=Subscriber.Add&FormValue_Fields[EmailAddress]=$email");
                        $out = curl_exec($curl);
                        curl_close($curl);
                    }
                }
                // Перенаправляем на страницу заказа
                header('Location: ' . $this->config->root_url . '/order/' . $order->url);
            }
        } else {

            // Если нам запостили amounts, обновляем их
            if ($amounts = $this->request->post('amounts')) {
                foreach ($amounts as $variant_id => $amount) {
                    $this->cart->update_item($variant_id, $amount);
                }

                $coupon_code = trim($this->request->post('coupon_code', 'string'));
                if (empty($coupon_code)) {
                    $this->cart->apply_coupon('');
                    header('location: ' . $this->config->root_url . '/cart/');
                } else {
                    $coupon = $this->coupons->get_coupon((string)$coupon_code);

                    if (empty($coupon) || !$coupon->valid) {
                        $this->cart->apply_coupon($coupon_code);
                        $this->design->assign('coupon_error', 'invalid');
                    } else {
                        $this->cart->apply_coupon($coupon_code);
                        header('location: ' . $this->config->root_url . '/cart/');
                    }
                }
            }
        }

    }

    //////////////////////////////////////////
    // Основная функция
    //////////////////////////////////////////
    function fetch()
    {

        $card = null;

        // Способы доставки
        $deliveries = $this->delivery->get_deliveries(array('enabled' => 1));
        $this->design->assign('deliveries', $deliveries);

        // Cities
        $destinations = $this->destinations->get_destinations();
        $this->design->assign('destinations', $destinations);

        // Данные пользователя
        if ($this->user) {
            $profile = $this->profiles->get_profile($this->user->id);

            if ($profile) {
                $this->design->assign('profile', $profile);
            }

            $email_tmp = $this->user->email;

            $this->design->assign('name', $this->user->name);
            $this->design->assign('email', $this->user->email);

            $simpla_new2 = new Simpla();
            $db_host = $simpla_new2->config->db_server;
            $db_user = $simpla_new2->config->db_user;
            $db_pass = $simpla_new2->config->db_password;
            $db_database = $simpla_new2->config->db_name;

            $mysqli_card = new mysqli($db_host, $db_user, $db_pass, $db_database);
            $mysqli_card->set_charset("utf8");
            $card = '';

            if ($result_card = $mysqli_card->query("SELECT * FROM `s_discount_card` WHERE (`email`='$email_tmp')AND(`enabled`='1')")) {
                while ($my_card = $result_card->fetch_assoc()) {
                    $card = $my_card['card'];
                }
            }

            $mysqli_card->close();
        }

        $this->design->assign('card', $card);

        // Если существуют валидные купоны, нужно вывести инпут для купона
        if ($this->coupons->count_coupons(array('valid' => 1)) > 0)
            $this->design->assign('coupon_request', true);

        $cart = $this->cart->get_cart();

        $purchases = $cart->purchases;

        $drug_is = false;

        foreach ($purchases as $p) {
            if ($p->product->drug == 1) {
                $drug_is = true;
            }
        }

        if ($drug_is) {
            $this->design->assign('drug_is', $drug_is);
        }

        // Выводим корзину
        return $this->design->fetch('cart.tpl');
    }
}