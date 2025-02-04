import http from "k6/http";
import { check, sleep } from "k6";

// Load test configuration (Change these values)
const config = {
  ip: "35.240.135.226", // Change this when needed
  vus: 100, // Number of Virtual Users (VUs)
  duration: "60s", // Duration of the test
};

// Construct the full URL
const URL = `http://${config.ip}/cpu-load`;

export let options = {
  vus: config.vus, // Number of concurrent users
  duration: config.duration, // Duration of the test
};

export default function () {
  let res = http.get(URL);

  // Check if response status is 200 (OK)
  check(res, {
    "status is 200": (r) => r.status === 200,
  });

  // sleep(1); // Simulate user wait time before next request
}
