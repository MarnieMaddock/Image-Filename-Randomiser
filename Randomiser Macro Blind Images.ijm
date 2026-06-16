// Filename Randomizer
// Creates randomized TIFF copies and saves a CSV lookup table.
// Optional: save original/randomized information in image header.
// Code Modified/Derived from Randomiser Macro Tiago Ferreira - ferreira at embl dot it


var extensions = newArray(".tif",".tiff",".stk",".jpeg",".jpg",".png",".zip",".lif",".gif");
var myDir, currentFldr, csvPath;
var saveHeaderInfo = true;

macro "Filename Randomizer [F6]" {

    requires("1.42j");
    setBatchMode(true);

    extensions = settings(extensions);

    chosenDir = getDirectory("Choose a Directory ");

    start = getTime();

    makeNewDir(chosenDir);
    makeTable();
    processFiles(chosenDir);

    stop = getTime();

    showStatus("Finished... (" + ((stop-start)/1000) + " seconds)");
	setBatchMode(false);
	exit("Done");
}

// ------------------------------------------------------------------
// Settings
// ------------------------------------------------------------------

function settings(extlist) {

    msg1 = "Choose extension of images to randomize.\n\n" +
           "The chosen images will be copied to a '*_Randomized' folder.\n\n" +
           "A CSV lookup table will always be saved.\n\n" +
           "You can choose whether original/randomized file information\n" +
           "is also saved inside the image header metadata.";

    Array.sort(extlist);

    lgth = extlist.length;
    gridSide = sqrt(lgth);
    rows = round(gridSide)-1;
    cols = round(gridSide)+2;

    defaults = newArray(lgth);
    defaults = Array.fill(defaults, 1);

    Dialog.create("Settings");
    Dialog.addMessage(msg1);
    Dialog.addCheckboxGroup(rows, cols, extlist, defaults);
    Dialog.addCheckbox("Save original/randomized information in image header", false);
    Dialog.show();

    count = 0;
    chosenExt = newArray(lgth);

    for (i=0; i<lgth; i++) {
        chosenExt[i] = Dialog.getCheckbox();
        if (chosenExt[i] == 1) count++;
    }

    saveHeaderInfo = Dialog.getCheckbox();

    finalExt = newArray(count);
    h = 0;

    for (i=0; i<lgth; i++) {
        if (chosenExt[i] == 1) {
            finalExt[h] = extlist[i];
            h++;
        }
    }

    return finalExt;
}

// ------------------------------------------------------------------
// Create output directory
// ------------------------------------------------------------------

function makeNewDir(dir) {

    upDir = File.getParent(dir);

    endCFName = lengthOf(chosenDir)-1;
    startCFName = lengthOf(upDir)+1;

    currentFldr = substring(chosenDir, startCFName, endCFName);

    myDir = upDir + File.separator + currentFldr + "_Randomized" + File.separator;

    if (File.exists(myDir)) {
        showMessageWithCancel(
            "A folder named:\n" + myDir +
            "\nAlready exists.\n\nContinue and overwrite/add files?"
        );
    }

    File.makeDirectory(myDir);
}

// ------------------------------------------------------------------
// Create CSV lookup table
// ------------------------------------------------------------------

function makeTable() {

    csvPath = myDir + currentFldr + "_Obfuscated_List.csv";

    header = "#,Original Title,Randomized Title,Original Directory,New Directory,Header Info Saved\n";

    File.saveString(header, csvPath);
}

// ------------------------------------------------------------------
// Process all files
// ------------------------------------------------------------------

function processFiles(dir) {

    list = getFileList(dir);

    list3 = newArray(list.length);
    randomize(list3);

    for (i=0; i<list.length; i++) {

        if (!endsWith(list[i], "/")) {

            oldname = list[i];
            newname = list3[i];

            if (lastIndexOf(oldname, ".") != -1) {

ext = toLowerCase(substring(oldname, lastIndexOf(oldname, "."), lengthOf(oldname)));

                processFile(dir, myDir, oldname, newname, ext, i+1);
            }
        }
    }
}

// ------------------------------------------------------------------
// Process one file
// ------------------------------------------------------------------

function processFile(oldDir, newDir, oldname, newname, xt, fileNumber) {

    for (h=0; h<extensions.length; h++) {

        if (endsWith(xt, extensions[h])) {

            randomizedName = newname + ".tif";
			print("Saving: " + oldname + " as " + randomizedName);
            msg =
            "Original Path: " + oldDir + oldname +
            "\nAssigned Path: " + newDir + randomizedName;

			open(oldDir + oldname);
			
			if (saveHeaderInfo == false) {
			    clearSliceLabels();
			    setMetadata("Info", "");
			    headerStatus = "No";
			} else {
			    setMetadata("Info", msg);
			    headerStatus = "Yes";
			}
			
			saveAs("Tiff", newDir + randomizedName);

			row =
			"" + fileNumber + "," +
			"\"" + oldname + "\"," +
			"\"" + randomizedName + "\"," +
			"\"" + oldDir + "\"," +
			"\"" + newDir + "\"," +
			"\"" + headerStatus + "\"\n";
			
			File.append(row, csvPath);

            close();
        }
    }
}

// ------------------------------------------------------------------
// Generate randomized filenames
// ------------------------------------------------------------------

function randomize(array) {

    for (i=0; i<array.length; i++) {

        n = round(array.length * random);

        m = toString(n) + "_" + toString(i+1);

        while (lengthOf(m) < 10)
            m = "0" + m;

        array[i] = m;
    }

    return array;
}

// clear slice labels
function clearSliceLabels() {

    totalSlices = nSlices();

    for (s=1; s<=totalSlices; s++) {
        setSlice(s);
        setMetadata("Label", "");
    }
}