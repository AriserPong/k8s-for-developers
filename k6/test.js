import http from "k6/http";
import { check, sleep } from "k6";

// Load test configuration (Change these values)
const config = {
  ip: "35.240.146.194", // Change this when needed
  vus: 100, // Number of Virtual Users (VUs)
  duration: "60s", // Duration of the test
};

// Construct the full URL
const URL = `http://${config.ip}/cpu-load`;

export let options = {
  // vus: config.vus, // Number of concurrent users
  // duration: config.duration, // Duration of the test
  scenarios: {
    test: {
      executor: "ramping-vus",
      startVUs: 0,
      stages: [
        { duration: "20s", target: 10 },
        { duration: "20s", target: 20 },
        { duration: "1m", target: 50 },
        { duration: "20s", target: 20 },
        { duration: "20s", target: 0 },
      ],
      gracefulRampDown: "0s",
    },
  },
};

export default function () {
  let res = http.get(URL);

  // Check if response status is 200 (OK)
  check(res, {
    "status is 200": (r) => r.status === 200,
  });

  // sleep(1); // Simulate user wait time before next request
}
