imageDir = getDirectory("Choose a directory containing fish images to mask");
fluorSubtsr = getString("Enter a substring to match the fluorescence files", "_CH2");
brfldSubstr = "_CH4";

dirFiles = getFileList(imageDir);

for (i = dirFiles.length - 1; i >= 0; i--) {
    if (dirFiles[i].contains(fluorSubtsr)) {
        fluorImg = dirFiles[i];
        brfldImg = dirFiles[i].replace(fluorSubtsr, brfldSubstr);
        open(imageDir + "/" + fluorImg);
        run("Split Channels");
        fluorChannelImg = closeChannelsExcept(
            substr2RGBchannel(fluorSubtsr), fluorImg);
        open(imageDir + "/" + brfldImg);
        run("Merge Channels...", "c1=" + fluorChannelImg + " c2=" + brfldImg + " create");
        setMetadata("dirPath", imageDir);
        rename(brfldImg);
    }
}

function closeChannelsExcept(keepChannel, baseImg) {
    keepImg = "";
    if (keepChannel != 1) {
        selectWindow("C1-" + baseImg);
        close();
    }
    else {
        keepImg = "C1-" + baseImg;
    }

    if (keepChannel != 2) {
        selectWindow("C2-" + baseImg);
        close();
    }
    else {
        keepImg = "C2-" + baseImg;
    }

    if (keepChannel != 3) {
        selectWindow("C3-" + baseImg);
        close();
    }
    else {
        keepImg = "C3-" + baseImg;
    }

    return keepImg;
}

ch3RGBchannel = 0;

function substr2RGBchannel(substr) {
    if (substr == "_CH1") {// channel 1 is green, so 2
        return 2;
    }
    if (substr == "_CH2") {// channel 2 is red, so 1
        return 1;
    }
    if (substr == "_CH3") {// not sure what channel 3 is :/
        if (ch3RGBchannel < 1) {
            ch3RGBchannel = getNumber(
                "Unknown color for channel 3: enter 1 for red, 2 for green, 3 for blue", 1);
        }

        return ch3RGBchannel;
    }
}
