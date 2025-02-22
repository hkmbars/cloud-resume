//creates a variable to select an element from index.html file which is views-counter
const counter = document.querySelector(".views-counter"); 

// Defines an asynchronous function to fetch and update the counter
async function updateCounter () {        

     // Sends a request to the AWS Lambda function URL and waits for the response. The URL is the aws lambda function url
    let response = await fetch("https://nda6dsqlrrgxctmfv6wugtdkkm0fykzc.lambda-url.ap-southeast-1.on.aws/"); 

    // Converts the response into a JavaScript object and stores it in the "data" variable
    let data = await response.json();      

    // Updates the HTML content of the selected element with the retrieved view count     
    counter.innerHTML = `    Views: <span class="views">  ${data}  </span>`; 
}

// Calls the function to execute when the script runs
updateCounter();