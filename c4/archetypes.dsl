archetypes {
    app = container {
        tags "Application"
    }
    app_py = app {
        technology "Python"
    }

    db = container {
        technology "PostgreSQL"
        tags "Database"
    }

    hs = container {
        technology "Tarantool"
        tags "Hotstorage"
    }

    front = container {
        tags "Frontend"
        technology "Node"
    }

    # Связи
    sync = -> {
        tags "Synchronous"
    }
    https = --sync-> {
        technology "HTTPS"
    }
}
