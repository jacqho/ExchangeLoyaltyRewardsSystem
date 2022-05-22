/*
SPDX-License-Identifier: Apache-2.0
*/

package main

import (
	"encoding/json"
	"fmt"
	"github.com/hyperledger/fabric-contract-api-go/contractapi"
	"github.com/pkg/errors"
	"strconv"
)

type SmartContract struct {
	contractapi.Contract
}

type Reward struct {
	ID			string `json:"ID"`
	Point		string `json:"point"`
}

func (s *SmartContract) GenerateReward(ctx contractapi.TransactionContextInterface, userId string, point string) error {
	iPoint, err := strconv.Atoi(point)
    if err != nil {
        fmt.Println(err)
		return err
    }
	if iPoint <= 0 {
		return errors.New("point cannot less than or equal to 0")
	}

	var iCurrentPoint = 0
	var reward Reward
	rewardJSON, err :=ctx.GetStub().GetState(userId)
	if err != nil {
		return err
	}

	if len(rewardJSON) != 0 {
		json.Unmarshal(rewardJSON,&reward)
		iCurrentPoint, err = strconv.Atoi(reward.Point)
		if err != nil {
			fmt.Println(err)
			return err
		}
	}

	var newPoint = iCurrentPoint + iPoint

	updateReward := Reward{
		ID: userId,
		Point: strconv.Itoa(newPoint),
	}
	updateRewardJSON, err :=json.Marshal(updateReward)

	if err != nil {
		return err
	}
	return ctx.GetStub().PutState(userId,updateRewardJSON)
}

func (s *SmartContract) ViewReward(ctx contractapi.TransactionContextInterface, userId string) (*Reward, error) {
	rewardJSON, err :=ctx.GetStub().GetState(userId)
	if err != nil{
		return nil, err
	}
	var reward Reward
	json.Unmarshal(rewardJSON,&reward)
	return &reward, nil
}

func (s *SmartContract) TransferReward(ctx contractapi.TransactionContextInterface, userId string, transaferTo string, point string) error {
	iPoint, err := strconv.Atoi(point)
    if err != nil {
        fmt.Println(err)
		return err
    }
	if iPoint <= 0 {
		return errors.New("point cannot less than or equal to 0")
	}

	senderRewardJSON, err :=ctx.GetStub().GetState(userId)
	if err != nil{
		return err
	}

	if len(senderRewardJSON) == 0 {
		return errors.New("user: " + userId + "not found")
	}

	var senderReward Reward
	json.Unmarshal(senderRewardJSON,&senderReward)

	iSenderRewardPoint, err := strconv.Atoi(senderReward.Point)
	if err != nil {
        fmt.Println(err)
		return err
    }

	if iPoint > iSenderRewardPoint {
		return errors.New("point cannot bigger than you have")
	}

	receiverRewardJSON, err :=ctx.GetStub().GetState(transaferTo)
	if err != nil{
		return err
	}

	if len(receiverRewardJSON) == 0 {
		return errors.New("user: " + transaferTo + "not found")
	}

	var receiverReward Reward
	json.Unmarshal(receiverRewardJSON,&receiverReward)

	iReceiverRewardPoint, err := strconv.Atoi(receiverReward.Point)
	if err != nil {
        fmt.Println(err)
		return err
    }

	var receiverNewPoint = iReceiverRewardPoint + iPoint
	var senderNewPoint = iSenderRewardPoint - iPoint

	updateSenderReward := Reward{
		ID: userId,
		Point: strconv.Itoa(senderNewPoint),
	}
	updateReciverReward := Reward{
		ID: transaferTo,
		Point:  strconv.Itoa(receiverNewPoint),
	}
	
	updateSenderRewardJSON, err :=json.Marshal(updateSenderReward)
	updateReciverRewardJSON, err :=json.Marshal(updateReciverReward)

	err = ctx.GetStub().PutState(userId,updateSenderRewardJSON)
	if err != nil{
		return ctx.GetStub().PutState(userId, senderRewardJSON)
	}

	err = ctx.GetStub().PutState(transaferTo,updateReciverRewardJSON)
	if err != nil{
		ctx.GetStub().PutState(userId, senderRewardJSON)
		return ctx.GetStub().PutState(userId, receiverRewardJSON)
	}

	return err
}

func main() {

	chaincode, err := contractapi.NewChaincode(new(SmartContract))

	if err != nil {
		fmt.Printf("Error create reward chaincode: %s", err.Error())
		return
	}

	if err := chaincode.Start(); err != nil {
		fmt.Printf("Error starting reward chaincode: %s", err.Error())
	}
}
