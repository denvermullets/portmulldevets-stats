# Denvermullets Analytics

This is a simplified, self hostable, version of Google Analytics meets Mixpanel.

## Screenshots

<img width="1972" alt="image" src="https://github.com/denvermullets/portmulldevets-stats/assets/47340962/5df987d7-21b1-494d-8675-ef47d3a081c8">
<img width="1956" alt="image" src="https://github.com/denvermullets/portmulldevets-stats/assets/47340962/be5debf2-6894-4532-b3d4-1bbbb8c6d144">



## Usage/Examples

Currently I've only been using this in my React projects, but you get the idea. All fields are optional, except for IP which is found in the Rails service.

```javascript
import axios from "axios";
import config from "../config";
import { UAParser } from "ua-parser-js";

export const logVisit = async (name: string, tag: string, target: string) => {
  if (!config.API_URL) {
    console.error("missing configs");
    return;
  }

  const userAgent = navigator.userAgent;
  const screenWidth = window.screen.width;
  const screenHeight = window.screen.height;
  const referrer = document.referrer;
  const parser = new UAParser(userAgent);
  const uaResult = parser.getResult();
  const browser = `${uaResult.browser.name} - v${uaResult.browser.version}`;
  const os = `${uaResult.os.name} - v${uaResult.os.version}`;
  const deviceType = `${uaResult.device.vendor || ""} ${uaResult.device.model || ""} ${
    uaResult.device.type || "Desktop"
  }`.trim();

  await axios.post(`${config.API_URL}/api/v1/events`, {
    event: {
      target,
      tag,
      name,
      browser,
      operating_system: os,
      screen_size: `${screenWidth}w x ${screenHeight}h`,
      referrer,
      device_type: deviceType,
    },
  });
};

```


## Environment Variables

`IPINFO_TOKEN`

`LOCAL_IP`

To run this project, you will need to add the following environment variables to your .env file. The `LOCAL_IP` is optional if you want to run successful IP lookups locally. You will need to create an account with IP Info (free account is like 50k lookups a month), but feel free to replace this lookup service in `Services > AddressInfo > locate.rb`.

## Run Locally

Install dependencies

```bash
  bundle install
```

Start the server

```bash
  bin/dev
```

