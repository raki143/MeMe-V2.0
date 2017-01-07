# MeMe-V2.0
This app enables a user to take a picture, and add text at the top and bottom to form a meme. The user will be able to share the photo on Facebook and Twitter and also by SMS or email.This app also alows user to select text color , font and size.

### Implementation

- __EditMemeViewController__: This view controller consists of image viewer and two text fields. User can take a picture either cliking the camera button or choose a picture from existing album.  

- Selected image will be appeared on image viewer, where user is allowed to edit the text fields. The Meme can be saved and shared in social media such as facebook, twitter, etc.

- __SwiftColorPickerViewController__:
A special thanks goes to: "Christian Zimmermann" who wrote the code for the SwiftColorPicker. You can view his GitHub page here: https://github.com/Christian1313/iOS_Swift_ColorPicker.

- __fontViewController__: This view controller is used to select different fonts and change font sizes.
- __MemeTableViewController__: This view controller shows saved memes in table view.
- __MemeCollectionViewController__: This view controller shows saved memes in collection view.
