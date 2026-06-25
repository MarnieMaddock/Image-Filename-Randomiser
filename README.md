# Image Filename Randomiser

An ImageJ/Fiji macro for blinded image analysis by randomising image filenames while preserving image content.

The macro opens supported image files, assigns randomized filenames, and saves randomized copies as TIFF images. A CSV lookup table linking original and randomized filenames is generated automatically. This allows image analysis to be performed without knowledge of experimental groups or sample identities.

## Features

* Randomises image filenames within a selected folder
* Creates a separate `_Randomized` output folder
* Generates a CSV lookup table containing original and randomized filenames
* Supports multiple image formats:

  * `.tif`
  * `.tiff`
  * `.jpeg`
  * `.jpg`
  * `.png`

* Optional preservation or removal of identifying image metadata and slice labels
* Compatible with Fiji/ImageJ
* Original files are not modified

## Workflow

1. Select the folder containing images.
2. Choose which file extensions should be processed.
3. Choose whether identifying metadata and slice labels should be retained. 
4. The macro creates randomized TIFF copies of all selected images.
5. A CSV lookup table is saved to the output directory.

### Metadata and Blinding

Many microscopy image formats contain embedded metadata and slice labels that may include the original filename or acquisition information.

When the **Retain original image information** option is enabled, this information is preserved and can be viewed in Fiji using:

```text
Image → Show Info...
```

This means the randomized images are **not completely blinded**, as the original filename or other identifying information may still be accessible within the image metadata.

When this option is disabled (default), the macro attempts to remove identifying metadata and slice labels before saving the randomized TIFF copy. However, users should verify that no identifying information remains in the output files before conducting blinded analyses.

## Output Structure

Example:

```text
Experiment_Images/
│
├── image1.tif
├── image2.tif
├── image3.tif
│
└── Experiment_Images_Randomized/
    ├── 00000001_1.tif
    ├── 00000003_2.tif
    ├── 00000002_3.tif
    └── Experiment_Images_Obfuscated_List.csv
```

## Lookup Table

The generated CSV contains:

| Column | Description |
|----------|-------------|
| # | Image number |
| Original Title | Original filename |
| Randomized Title | Randomized filename |
| Original Directory | Source directory |
| New Directory | Output directory |
| Header Info Saved | Whether identifying metadata was retained |

## Installation

1. Download the macro file:
   - `Randomiser Macro Blind Images.ijm`
2. Open Fiji/ImageJ.
3. Run:

   ```text
   Plugins → Macros → Run...
   ```

4. Select the macro file.

Alternatively, place the macro in the Fiji `macros` folder for permanent installation.

## Acknowledgements

This macro is based and adapted from on the original Filename Randomizer macro by Tiago Ferreira (EMBL). Original source:
[Filename Randomizer (ImageJ Macro)](https://imagej.net/ij/macros/Filename_Randomizer.txt)
