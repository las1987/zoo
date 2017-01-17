{* Главное меню *}
<div id="main-menu">
    <ul>
        {foreach from=$pages item=p name=menu}
            {* Выводим только страницы из первого меню *}
            {if $p->menu_id == 1}
                <li
                        {if $page && $page->id == $p->id}class="selected"{/if}>
                    <a data-page="{$p->id}" href="/{$p->url}/" {if $smarty.foreach.menu.last}class="last"{/if} >
                        {if $p->id == 3}
                            <img src="/design/{$settings->theme|escape}/images/icons/dostavka.png" title="Доставка" alt="Доставка">
                        {/if}
                        {if $p->id == 49}
                            <img src="/design/{$settings->theme|escape}/images/icons/samovyvoz.png" title="Самовывоз" alt="Самовывоз">
                        {/if}
                        {if $p->id == 12}
                            <img src="/design/{$settings->theme|escape}/images/icons/paw.png" title="Питомникам" alt="Питомникам">
                        {/if}
                        {if $p->id == 2}
                            <img src="/design/{$settings->theme|escape}/images/icons/cards.png" title="Оплата" alt="Оплата">
                        {/if}
                        {if $p->id == 8}
                            <img src="/design/{$settings->theme|escape}/images/icons/sale.png" title="Акции" alt="Акции">
                        {/if}
                        <span class="hide-on-mobile">{$p->name|escape}</span></a>
                </li>
            {/if}
        {/foreach}
    </ul>
</div>
