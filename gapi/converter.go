package gapi

import (
	db "github.com/saransh-khobragade/golang-postgres-kubernetes-gRPC/db/sqlc"
	"github.com/saransh-khobragade/golang-postgres-kubernetes-gRPC/pb"
	"google.golang.org/protobuf/types/known/timestamppb"
)

func convertUser(user db.User) *pb.User {
	return &pb.User{
		Username:          user.Username,
		FullName:          user.FullName,
		Email:             user.Email,
		PasswordChangedAt: timestamppb.New(user.PasswordChangedAt),
		CreatedAt:         timestamppb.New(user.CreatedAt),
	}
}
