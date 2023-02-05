package gapi

import (
	"fmt"

	db "github.com/saransh-khobragade/golang-postgres-kubernetes-gRPC/db/sqlc"
	"github.com/saransh-khobragade/golang-postgres-kubernetes-gRPC/db/util"
	"github.com/saransh-khobragade/golang-postgres-kubernetes-gRPC/pb"
	"github.com/saransh-khobragade/golang-postgres-kubernetes-gRPC/token"
)

type Server struct {
	pb.UnimplementedSimpleBankServer
	config     util.Config
	store      db.Store
	tokenMaker token.Maker
}

func NewServer(config util.Config, store db.Store) (*Server, error) {
	tokenMaker, err := token.NewPasetoMaker(config.TokenSymmetricKey)
	if err != nil {
		return nil, fmt.Errorf("cannot create token maker: %w", err)
	}
	server := &Server{
		config:     config,
		store:      store,
		tokenMaker: tokenMaker,
	}

	return server, nil
}
