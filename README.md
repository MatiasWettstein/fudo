# API Rack en Ruby

## Instalación
```sh
bundle install
```

## Ejecución

```sh
rackup -s webrick
```

## Tests

```sh
rspec spec
```

## Uso

- Autenticación: `POST /auth` con `{ "username": "admin", "password": "password123" }`
- Logout: `POST /logout`, Header: `Authorization: Bearer <<Token>>`
- Crear producto: `POST /products`, Body: `{"name": "Producto" }`, Header: `Authorization: Bearer <<Token>>`
- Listar productos: `GET /products`, Header: `Authorization: Bearer <<Token>>`
- Buscar por ID: `GET /products/:id`, Header: `Authorization: Bearer <<Token>>`
- Authors: `GET /AUTHORS`
- Openapi: `GET /openapi`

## Opcional

- Header: `Accept-Encoding: gzip` para comprimir la respuesta

## Usando docker compose

- Para levantar el proyecto utiliza `docker compose up -d`
- En caso de necesitar volver a hacer la build ejecutar `docker compose up -d --build`
- El puerto por defecto es el :9292