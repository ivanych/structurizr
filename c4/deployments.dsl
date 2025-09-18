development = deploymentEnvironment "Development" {
    deploymentNode "Developer Comp" {
        deploymentNode "Browser" {
            containerInstance store.ui
        }

        containerInstance store.catalog_app
        containerInstance store.cart_app
        containerInstance store.orders_app

        deploymentNode "Postgres" {
            containerInstance store.catalog_db
            containerInstance store.orders_db
        }
        deploymentNode "Tarantool" {
            containerInstance store.cart_hs
        }
    }
    deploymentNode "Yandex DC" {
        softwareSystemInstance paymentSystem
    }
    deploymentNode "Store DC" {
        softwareSystemInstance 1c
    }
}

production = deploymentEnvironment "Production" {
    n_user_comp = deploymentNode "User Comp" {
        n_browser = deploymentNode "Browser" {
            i_ui = containerInstance store.ui
        }
    }

    n_store_dc = deploymentNode "Store DC" {

        n_docker = deploymentNode "Docker" {
            i_catalog_app = containerInstance store.catalog_app
            containerInstance store.cart_app
            containerInstance store.orders_app
        }

        deploymentNode "Postgres" {
            containerInstance store.catalog_db
            containerInstance store.orders_db
        }

        deploymentNode "Tarantool" {
            instances 3
            containerInstance store.cart_hs
        }

        softwareSystemInstance 1c

        nginx = infrastructureNode "Nginx" {
            -> n_docker.i_catalog_app
        }
    }

    deploymentNode "Yandex DC" {
        softwareSystemInstance paymentSystem
    }

    n_user_comp.n_browser.i_ui -> n_store_dc.nginx

}
