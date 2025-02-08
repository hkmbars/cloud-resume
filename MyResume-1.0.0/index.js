const counter = document.querySelector(".views-counter"); //creating a variable to select a document from index.html file
async function updateCounter () {                         //create a function which is doing a fetch request to the URL
    let response = await fetch("https://nda6dsqlrrgxctmfv6wugtdkkm0fykzc.lambda-url.ap-southeast-1.on.aws/"); //aws lambda function url
    let data = await response.json();                     //similar to curl request storing the result as a variable called data
    counter.innerHTML = `    Views: <span class="views">  ${data}  </span>`; // updates the views-counter

}

updateCounter();