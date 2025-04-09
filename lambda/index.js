// Updated code example
const AWS = require('aws-sdk');
const dynamoDb = new AWS.DynamoDB.DocumentClient();

exports.handler = async (event) => {
  const messageBody = JSON.parse(event.Records[0].body);

  // Read the table name from the environment variable DYNAMODB_TABLE
  const tableName = process.env.DYNAMODB_TABLE;
  if (!tableName) {
    console.error("DYNAMODB_TABLE is not set");
    throw new Error("DYNAMODB_TABLE environment variable is required");
  }

  const params = {
    TableName: tableName,
    Item: {
      id: messageBody.id,
      userId: messageBody.userId,
      // ... other attributes
    },
  };

  try {
    await dynamoDb.put(params).promise();
    console.log(`Successfully wrote item with id ${messageBody.id} to ${tableName}`);
  } catch (error) {
    console.error('Error writing to DynamoDB: ', error);
    throw error;
  }
};
