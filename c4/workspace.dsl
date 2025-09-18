workspace "Name" "Description" {

    !identifiers hierarchical

    model {
        !include archetypes.dsl

        # Модель
        !include model.dsl

        # Окружения
        !include deployments.dsl
    }

    views {
        systemLandscape magaz "Магазин и внешние системы" {
            include *
            autolayout tb
        }
        systemContext store store {
            include *
            exclude 1c
            autolayout tb
        }
        container store Diagram2 {
            include *
            autolayout tb
        }
        deployment * development {
            include *
            autoLayout tb
        }
        deployment * production {
            include *
            exclude relationship.tag==balanced
            autoLayout tb
        }
        theme default

        # Диниамические диаграммы
        dynamic store create_order {
            title "Создание заказа"
            store.ui -> store.catalog_app "Запросить товары из каталога"
            store.catalog_app -> store.ui "Получить товары (идентификаторы товаров)"
            store.ui -> store.cart_app "Добавить товар (идентификатор товара) в корзину"
            store.ui -> store.cart_app "Запросить товары из корзины"
            store.cart_app -> store.ui "Получить товары (идентификаторы товаров)"
            store.ui -> store.orders_app "Cоздать заказ (идентификатор товара, цена etc)"
            store.orders_app -> store.orders_db "Сохранить заказ в базу"
            autolayout lr
        }

        styles {
            element "Database" {
                shape cylinder
            }
            element "Hotstorage" {
                shape Ellipse
            }
            element "Frontend" {
                shape WebBrowser
            }
            element "External" {
                background #999999
                color #ffffff
            }
        }
    }
}
