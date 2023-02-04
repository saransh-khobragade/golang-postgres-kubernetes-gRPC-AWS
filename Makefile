dockernetwork:
	docker network create bank-network && docker network connect bank-network postgres15.1

buildGolangImage:
	docker build -t simplebank:latest .

runGolangImage:
	docker run --name simplebank --network bank-network -p 8080:8080 -e GIN_MODE=release simplebank:latest

buildPostgresAndRun:
	docker run --name postgres15.1 --network bank-network -p 5432:5432 -e POSTGRES_USER=root -e POSTGRES_PASSWORD=secret -d postgres:15.1-alpine

removepostgres:
	docker rm -f postgres15.1

createdb:
	docker exec -it postgres15.1 createdb --username=root --owner=root simple_bank

dropdb:
	docker exec -it postgres15.1 dropdb simple_bank

migrateup:
	migrate -path db/migration -database "postgresql://root:secret@localhost:5432/simple_bank?sslmode=disable" -verbose up

migratedown:
	migrate -path db/migration -database "postgresql://root:secret@localhost:5432/simple_bank?sslmode=disable" -verbose down

migrateup1:
	migrate -path db/migration -database "postgresql://root:secret@localhost:5432/simple_bank?sslmode=disable" -verbose up 1

migratedown1:
	migrate -path db/migration -database "postgresql://root:secret@localhost:5432/simple_bank?sslmode=disable" -verbose down 1

sqlc: 
	sqlc generate

test:
	go test -v -cover ./...

cleantestcache:
	go clean -testcache

server:
	go run main.go

mock:
	mockgen -package mockdb -destination db/mock/store.go github.com/saransh-khobragade/golang-postgres-kubernetes-gRPC/db/sqlc Store



.PHONY: postgres createdb dropdb migrateup migratedown migrateup1 migratedown1 sqlc test server mock