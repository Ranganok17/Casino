const AWS = require('aws-sdk');

// Initialize the DynamoDB Document Client
const dynamoDb = new AWS.DynamoDB.DocumentClient();

exports.handler = async (event) => {
    // Parse the SQS message body
    const messageBody = JSON.parse(event.Records[0].body);

    // Define the parameters for the DynamoDB put operation
    const params = {
        TableName: 'users', // Replace with your DynamoDB table name
        Item: {
            id: messageBody.id,       // Replace with the actual attribute from your message
            userId: messageBody.userId, // Replace with the actual attribute from your message
            // Add other attributes as needed
        },
    };

    try {
        // Perform the put operation
        await dynamoDb.put(params).promise();
        console.log(`Successfully wrote item with id ${messageBody.id} to DynamoDB.`);
    } catch (error) {
        console.error(`Error writing to DynamoDB: ${error}`);
    }
};
