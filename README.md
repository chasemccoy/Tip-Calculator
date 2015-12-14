# Pre-work - Tipster

Tipster is a tip calculator application for iOS.

Submitted by: Chase McCoy

Time spent: 4 hours spent in total

## User Stories

The following **required** functionality is complete:

* [x] User can enter a bill amount, choose a tip percentage, and see the tip and total values.
* [x] Settings page to change the default tip percentage.

The following **optional** features are implemented:
* [x] Extensive UI animations
* [x] Remembering the bill amount across app restarts (if <10mins)
* [x] Using locale-specific currency and currency thousands separators.
* [x] Making sure the keyboard is always visible and the bill amount is always the first responder. This way the user doesn't have to tap anywhere to use this app. Just launch the app and start typing.

The following **additional** features are implemented:

* [x] Day and night color schemes in settings.
* [x] App shows the total amount for splitting the bill between 2, 3, 4, or 5 people.
* [x] Unique app icon
* [x] Custom, popup settings page
* [x] Keyboard changes to only allow one period in the bill field
* [x] The bill field is limited to a certain number of characters (8)

## Video Walkthrough 

Here's a walkthrough of implemented user stories:

<img src='http://i.imgur.com/arpqkrz.gif' title='Video Walkthrough' width='' alt='Video Walkthrough' />

GIF created with [LiceCap](http://www.cockos.com/licecap/).

## Notes

My biggest challenge when developing this app was learning the details of the Swift language (I primarily use Objective-C), and also understanding the constraints system of Auto Layout.

The most useful thing I learned while making this app is that Auto Layout constraints can have outlets associated with them. This allowed me to animate the changing of a constraint within my app. I also learned a great deal about using UIScrollView with Auto Layout. 

I also used a third-party Swift library called Spring in order to simplify the code for my animations.

## License

    Copyright 2015 Chase McCoy

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

        http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.