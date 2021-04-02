project_conference_app
======================
## About
Currently an incompleted Flutter app that works like Telegram Channels.

## Screens


<img src="https://user-images.githubusercontent.com/69195180/113423246-c60da700-93d6-11eb-9b34-e94b805732da.jpeg" width = 200>

Sign in screen. User can request a password reset or toggle the "Remember Me" button to enter the app without signing in. If user enters an incorrect password 
or the email doesn't belong to an authorised user the user will be notified with a flushbar and if the user's email has not been verified yet the user will be taken
to verify email screen instead of the main screen.

<img src="https://user-images.githubusercontent.com/69195180/113423249-c6a63d80-93d6-11eb-8883-85e3733d1651.jpeg" width = 200>

Sign up screen. Users' and messages' data are stored at Google's Firebase platform.

<img src="https://user-images.githubusercontent.com/69195180/113423250-c73ed400-93d6-11eb-90d9-0324bebbc0af.jpeg" width = 200>

Main screen from Admin's view.

<img src="https://user-images.githubusercontent.com/69195180/113423251-c73ed400-93d6-11eb-9767-4af7255328f6.jpeg" width = 200>

Main screen from user's view. Doesn't have a textbar. Tapping a message directs the user to details screen for that message. Users can tap "Scroll to top" widget to
return to the latest messages also they can log out from the top-left menu bar.

## Credits
* Design https://dribbble.com/shots/5871600-Login-screen-UI-Design/attachments/5871600-Login-screen-UI-Design?mode=media

## License
MIT License

Copyright (c) 2021 Berat Ekmen

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
