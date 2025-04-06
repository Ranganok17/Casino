// index.js
const AWS = require('aws-sdk');
const xray = require('aws-xray-sdk');

// Capture all outgoing HTTP calls with X-Ray
xray.captureHTTPsGlobal(require('http'));

// Create a DynamoDB client (for simulation purposes)
const dynamodb = new AWS.DynamoDB.DocumentClient();

exports.handler = async (event) => {
  console.log("Lambda function invoked.");
  console.log("Event received:", JSON.stringify(event));

  // Check if triggered by SQS and log message bodies
  if (event.Records) {
    event.Records.forEach(record => {
      console.log("SQS Message:", record.body);
    });
  }

  // Simulate writing data to DynamoDB (actual write code would go here)
  console.log("Simulating write to DynamoDB...");

  // CloudWatch logs are automatically published. For custom metrics,
  // you could use CloudWatch SDK calls here (not implemented in this placeholder).

  // Return a success response
  return {
    statusCode: 200,
    body: JSON.stringify('Function executed successfully!')
  };
};
