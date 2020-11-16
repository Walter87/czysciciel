# czysciciel
Usually is hard to remove emails from gmail account with its user interface. This tool removes selected emails by api with the usage of gmail filters. You don't have to worry about that someone will get access to your email account unless you will be owner of the API. You can use any of your google accounts for enabling gmail API, and you will be able to auhtorize there any other gmail account for managing purposes. If you are not owner of the account with API enabled bare in mind that during the authorization described in point number 5 you will be giving full access to your selected mailbox.
Please note: **Emails removed with this app don't go to trash. You won't be able to recover them afterall.**

## Installation
  1. Pull this repo.
  2. Go to [this link](https://developers.google.com/gmail/api/quickstart/ruby?authuser=2), and click "Enable the Gmail API" button. Use whatever name you want and proceed.
  3. DOWNLOAD CLIENT CONFIGURATION and save the file credentials.json to project directory.
  4. Make sure you have ruby or jruby installed and inside project run app with:
     ```ruby czysciciel.rb```
  5. At first usage you're gonna see link and instructions for authorizing czysciciel to access your gmail account. You won't need to do it again unless you will delete token.yml file from the local repository.
  6. You will be ask to type in google mail filter. [Here](https://support.google.com/mail/answer/7190) you can find some help on it. Test it first in google gmail client. After that you will have to wait for selected email ids. Time depends on number of emails returned by the filter. It can be couple of minutes for 
hundreds of thousands of emails. App will exit if your filter will be less than 5 chars for safety purposes.
  7. After getting all ids you will see how many emails will be removed, and will have to accept it by clicking 'y' and enter. If you use any other key you will exit the program.
  8. That's it.


If you won't need this app in the nearest future you can remove API from your google account [here](https://console.developers.google.com/cloud-resource-manager?organizationId=0&authuser=1)
