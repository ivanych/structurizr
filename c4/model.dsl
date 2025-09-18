customer = person "Пользователь" "Покупает товары"

group "Магазин" {
    1c = softwareSystem "1C" "Бэк-офис" "External"

    store = softwareSystem "Интернет-магазин" "Продаёт товары" {
        !docs docs
        !adrs adrs

        # UI
        ui = front "UI" "Веб-интерфейс магазина"

        # Каталог
        group "Каталог" {
            catalog_db = db "База каталога" "Хранит товары"
            catalog_app = app_py "API Каталога" "Предоставляет доступ к товарам" {
                -> store.catalog_db "Читает данные из базы"
                #!docs docs/catalog
            }

        }

        # Корзина
        group "Корзина" {
            cart_hs = hs "База корзины" "Хранит корзины"
            cart_app = app_py "API Корзины" "Предоставляет доступ к корзинам" {
                #!docs docs/cart
                -> store.cart_hs "Читает данные из хотстораджа"
            }
        }

        # Заказы
        group "Заказы" {
            orders_db = db "База заказов" "Хранит заказы"
            orders_app = app_py "API Заказов" "Принимает и обрабатывает заказы" {
                -> store.orders_db "Читает данные из базы"
                -> 1c "Передаёт сведения о заказах"
                !docs docs/orders
                !adrs adrs/orders
            }

        }
    }



}

paymentSystem = softwareSystem "Платежный сервис" "Принимает платежи" "External"

# Связи
customer --https-> store "Покупает товары"
customer --https-> store.ui "Использует веб-интерфейс"
customer --https-> paymentSystem "Оплачивает заказы"

store.ui --https-> store.catalog_app "Просматривает товары" {
    tags "balanced"
}
store.ui --https-> store.cart_app "Добавляет товары в корзину" {
    tags "balanced"
}
store.ui --https-> store.orders_app "Создаёт заказы" {
    tags "balanced"
}

paymentSystem -> store.orders_app "Передаёт сведения об оплатах"
