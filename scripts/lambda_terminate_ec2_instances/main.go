package main

import (
	"context"
	"errors"
	"github.com/aws/aws-lambda-go/lambda"
	"github.com/aws/aws-sdk-go-v2/aws"
	"github.com/aws/aws-sdk-go-v2/config"
	"github.com/aws/aws-sdk-go-v2/service/ec2"
	"github.com/aws/aws-sdk-go-v2/service/ec2/types"
	"log"
)

var instancesIDs []string

func EC2SSMConfig(region string) *ec2.Client {
	cfg, err := config.LoadDefaultConfig(context.Background(),
		config.WithRegion(region),
	)

	if err != nil {
		log.Fatal(err)
	}

	return ec2.NewFromConfig(cfg)
}

func GetInstanceResponse(client *ec2.Client) []types.Reservation {
	runningFilter := types.Filter{
		Name:   aws.String("instance-state-name"),
		Values: []string{"running"},
	}

	tagFilter := types.Filter{
		Name:   aws.String("tag:AutoOff"),
		Values: []string{"True"},
	}

	filters := []types.Filter{runningFilter, tagFilter}

	awsInput := &ec2.DescribeInstancesInput{
		Filters:    filters,
		MaxResults: aws.Int32(1000),
	}

	paginator := ec2.NewDescribeInstancesPaginator(client, awsInput, func(o *ec2.DescribeInstancesPaginatorOptions) {
		o.Limit = 1000
	})

	var instancesResponse []types.Reservation
	for paginator.HasMorePages() {
		output, err := paginator.NextPage(context.TODO())
		if err != nil {
			errors.New(err.Error())
		}
		instancesResponse = append(instancesResponse, output.Reservations...)
	}
	return instancesResponse
}

func AppendInstanceIDS(instanceResponse []types.Reservation) {
	for _, instances := range instanceResponse {
		for _, instance := range instances.Instances {
			instancesIDs = append(instancesIDs, *instance.InstanceId)
		}
	}
}

func TerminateInstances(instances []string, client *ec2.Client) {
	terminateInput := &ec2.TerminateInstancesInput{
		InstanceIds: instances,
	}

	log.Println("Terminating instances...", instances)
	_, err := client.TerminateInstances(context.TODO(), terminateInput)
	if err != nil {
		log.Fatal(err)
	}
}

func StartProcess() {
	// Initiate AWS SSM config
	ec2client := EC2SSMConfig("eu-west-1")

	// Get Instance Response if we have running instances with the specific tag
	instanceResponse := GetInstanceResponse(ec2client)

	// Stop instance(s)
	if len(instanceResponse) > 0 {
		AppendInstanceIDS(instanceResponse)
		TerminateInstances(instancesIDs, ec2client)
	}
}

func main() {
	log.Println("Starting lambda")

	lambda.Start(StartProcess)

	log.Println("Bye!")
}
