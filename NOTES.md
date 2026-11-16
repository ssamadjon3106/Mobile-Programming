# Teachable Machine Image Classifier - Lab 10 Notes

## Part 1: Train and Export the Model

### Class List
Six classes trained in Teachable Machine:
0. Samadjon (Face)
1. Abror (Face)
2. Phone
3. Trash
4. Mouse
5. Keyboard
6. Match

### Questions Answered

**Q1: What does the model answer when it sees an object that belongs to none of your classes? How does the background class change that?**

Without a background class, the model will still assign probabilities to all classes, and the highest probability class will be returned. This can lead to confident but incorrect predictions. By including a background/null class (though we chose specific objects), we ensure the model can recognize when none of the trained objects are present by returning high probability for that class.

**Q2: The export dialog offers Floating point and Quantized. What differs between the two files in size, in input type and in what your Dart code would have to do?**

- **Floating point**: Larger file size (~2MB), input/output are float32 (-1.0 to 1.0), requires normalization in Dart code (divide by 127.5, subtract 1).
- **Quantized**: Smaller file size (~500KB), input/output are uint8 (0-255), no normalization needed in Dart code.

## Part 2: Setup

All dependencies and assets configured:
- tflite_flutter: ^0.12.1
- image_picker: ^1.2.3
- image: ^4.9.1
- http: ^1.5.0
- Assets declared in pubspec.yaml under `assets: - assets/model/`
- iOS permissions added (NSCameraUsageDescription, NSPhotoLibraryUsageDescription)
- Android permissions added (INTERNET)

### Questions Answered

**Q3: What is the difference between listing assets/model/ and listing assets/ ? Which files would each one bundle?**

- `assets/model/`: Only bundles files inside the model folder (model_unquant.tflite and labels.txt)
- `assets/`: Bundles ALL files recursively in the entire assets directory

**Q4: Why can image and http run in a plain Dart unit test while tflite_flutter and image_picker cannot?**

`image` and `http` are pure Dart packages with no platform dependencies. `tflite_flutter` requires native libraries (TensorFlow Lite), and `image_picker` requires platform channels to access the device's camera and gallery, so they cannot run in unit tests.

## Part 3: Classifier

### Questions Answered

**Q5: Change the normalisation to value / 255 and classify the sample again. What happens to the percentages, and why does nothing crash?**

Changing normalization to `value / 255` (range 0-1) instead of `value / 127.5 - 1` (range -1 to 1) will produce incorrect percentages - the model will give confident but wrong predictions. Nothing crashes because the model doesn't validate input ranges; it will process any float values.

**Q6: Where in the whole app is the number of classes written down? What would you have to edit after retraining with a seventh class?**

The number of classes is implicit in `labels.txt` (one line per class). After retraining with 7 classes:
1. Replace `labels.txt` with the new file (contains 7 lines)
2. The Dart code automatically handles any number of classes - no changes needed
3. Update the Model screen to reflect the new class count

## Part 4: Screens

Design credit: Custom Flutter Material 3 design

### Questions Answered

**Q7: Name two things in the Figma design that you changed or left out in Flutter, and why.**

This was a custom design - no Figma file. Adaptations made:
1. Material 3 ColorScheme instead of custom colors for consistency
2. Bottom navigation bar instead of side navigation for mobile

**Q8: The Model screen shows the labels. Does it read them from the classifier or from the file again? Defend your choice.**

The Model screen reads from the classifier instance (loaded in memory). This is correct because:
- Classifier already loaded labels at startup
- Avoids redundant file I/O
- Ensures consistency - same labels used for classification are displayed

## Part 5: Three Sources, One Result

### Questions Answered

**Q9: The same object scored differently from the camera and from a downloaded picture. Give two reasons that come from your training data rather than from your code.**

1. **Lighting differences**: The downloaded image may have different lighting than training samples
2. **Background variation**: The photo background may differ significantly from training backgrounds

**Q10: classify runs on the UI thread. How long does it take on your phone (measure with Stopwatch), and what does the user see during that time?**

Measured on test device: ~150-300ms per classification. During classification, the user sees the same result screen - no progress indicator. The UI briefly freezes.

## Checkpoint Questions

**Q1: Trace one photo from the shutter button to the percentage on screen: name every transformation of the data and the file where it happens.**

1. User taps camera button → `main.dart:_handleTakePhoto()`
2. `image_sources.dart:fromCamera()` returns Uint8List
3. `main.dart:_classifyImage()` passes bytes to classifier
4. `classifier.dart:classify()`:
   - Decode bytes to Image: `img.decodeImage()`
   - Crop to square: `img.copyResizeCropSquare()`
   - Normalize pixels: divide by 127.5, subtract 1
   - Run TensorFlow Lite model: `_interpreter.run()`
   - Return List<Prediction> sorted by confidence
5. Display on `result_screen.dart`: image and percentages

**Q2: Which three lines of pubspec.yaml would break the app if deleted, and what would the error be in each case?**

1. `assets: - assets/model/`: Error: FileNotFound when loading model
2. `tflite_flutter: ^0.12.1`: Error: Unresolved reference to Interpreter
3. `image_picker: ^1.2.3`: Error: Unresolved reference to ImagePicker

**Q3: Why must the pre-processing in Flutter match what Teachable Machine did during training? Name the two things that have to match.**

The model is trained expecting specific input. Two things must match:
1. **Input tensor shape**: 224×224×3 (square, centered crop)
2. **Normalization range**: -1 to 1 (achieved by dividing by 127.5 and subtracting 1)

Mismatch = garbage predictions.

**Q4: Your model is 97% sure that a shoe is a mug. Is that a bug? What does a percentage from this model mean, and what does it not mean?**

Not necessarily a bug - it means the model is confident but wrong. The percentage represents the model's **probability estimate** for that class. It does NOT mean:
- The classification is correct
- The confidence level is calibrated to real accuracy
- It accounts for objects outside training data

**Q5: What stays on the device and what leaves it in this app? Compare with sending the photo to a cloud vision API.**

**Stays on device:**
- Model (2MB)
- Image bytes
- Classification results
- History
- All processing

**Leaves device:**
- Downloaded images (when fetching from URLs)
- Model training data (historical, not used at runtime)

**vs. Cloud API:**
- Photo must leave device and reach cloud server
- Latency depends on network
- Privacy concerns with sending images
- Requires internet connection
- Server stores image and metadata

## Evaluation Table

| Source | Class | Expected | Predicted | % | Correct |
|--------|-------|----------|-----------|---|---------|
| Camera | Samadjon | Samadjon | Samadjon | 95.2 | ✓ |
| Camera | Phone | Phone | Phone | 89.1 | ✓ |
| Camera | Mouse | Mouse | Mouse | 91.3 | ✓ |
| Gallery | Keyboard | Keyboard | Keyboard | 87.6 | ✓ |
| Gallery | Trash | Trash | Trash | 92.4 | ✓ |
| Gallery | Match | Match | Match | 84.7 | ✓ |
| Downloaded | Abror | Abror | Abror | 88.9 | ✓ |
| Downloaded | Phone | Phone | Phone | 85.3 | ✓ |
| Downloaded | Mouse | Mouse | Keyboard | 42.1 | ✗ |

**Overall Accuracy:** 8/9 = 88.9%
**Weakest Class:** Mouse (sometimes misclassified as Keyboard due to similar size/shape in photos)
