# Envoy’s Mobile Take-Home Project: Showing Coffee Shops Near Envoy HQ

## About
- This mobile app, called "CoffeeShops," allows users to find the top coffee shops near Envoy HQ using the Yelp API.
- Note:
    - Make sure to update the apiKey in the CoffeeShopsDataManager class with a valid Yelp API key for the app to work.
    - The number of results per load is limited to 10 for iPhones and 20 for iPads. This is because I used a collection view to display the results and it facilitates the implementation of infinite scrolling on iPads..

## Thank You Note to the Review Team:
### Thank you for taking the time to review my take-home assignment. I am really looking forward to receiving your feedback.

## Build tools & versions used
- Xcode 14.2
- iOS 13.0 (min) - this choice was made to support older versions and based on the current App Store information for the Envoy app, 
- Swift 5

## Steps to run the app
- Download or clone the project to your Mac.
- Open the project in Xcode 14.2 or above.
- Run the app on a simulator or a physical device, select it as the destination in the Xcode toolbar and click the "Run" button. Xcode will build and launch the app on the selected destination.

## Focus Areas
- Architecture:
    - I followed MVVM architecture and built the whole UI programmatically.
    
- UI & UX:
    - The app is universal and will work on iPhones and iPad on either orientation.
    - It also supports dark mode, dynamic type and localized text.
    - I created a custom app icon as well and used latest Xcode 14 feature of single size app icon.
    - I also created a custom ui experience for empty state. 

- Caching:
    - Images are cached in files.

- Overall, I focused on creating a great UI/UX experience for the user, including in different orientations, dark mode, custom app icon, dynamic type, localization, and default state.

## Trade-offs I made? What would I have done differently with more time?
- Unit Testing:
    - If I had more time I would have added the unit test coverage for the app.

## Weakest parts in the project according to me?
- Lack of test coverage for code.

## Any Third Party dependencies?
- Nope!

## Other information I would like the review team to know?
- It has been a while since I built a project from scratch.
- I included the new optional unwrapping syntax in Swift 5.7.
- I do not have the opportunity to perform unit testing on a daily basis at my current job due to the prioritization of product development and the rapid pace of shipping and AB testing various feature options.
