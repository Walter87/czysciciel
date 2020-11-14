# czysciciel
Usually is hard to remove emails from gmail account with its user interface. This tool removes selected emails by api with the usage of gmail filters. You don't have to worry about that someone will get access to your email account because you will set up the API on your personal account.
Take into account: **Emails removed with this app don't go to trash. You won't recover them.**

## Installation
  1. Pull this repo.
  2. Go to [this link](https://developers.google.com/gmail/api/quickstart/ruby?authuser=2), and click "Enable the Gmail API" button. Use whatever name you want and proceed.
  3. DOWNLOAD CLIENT CONFIGURATION and save the file credentials.json to project directory.
  4. Make sure you have ruby or jruby installed and inside project run app with:
     ```ruby czysciciel.rb```
  5. At first usage you're gonna see link and instructions for authorizing czysciciel to access your gmail account. You won't need to do it again unless you will delete token.yml file from the local repository.
  6. You will be ask to type in google mail filter. Test it first in google gmail client. After that you will have to wait for selected email ids. Time depends on number of emails returned by the filter. It can be couple of minutes for 
hundreds of thousands of emails. App will exit if your filter will be less than 5 chars for safety purposes.
  7. After getting all ids you will see how many emails will be removed, and will have to accept it by clicking 'y' and enter.
  8. That's it.
