# SMART Analysis Stack

SMART Analysis Stack is a collection of MATLAB functions and scripts used by the SMART Senior Design team at [LeTourneau University](http://www.letu.edu).

## About

The treatment of neuromuscular dysfunctions in children through physical therapy is a lengthy process. [Amtryke tricycles](www.amtrykestore.com) are used by physical therapists as a low-cost, but high-volume form of pediatric therapy for many neuromuscular disabilities. The SMART team performed research on the effectiveness of the Amtryke tricycles using kinematic (mocap) data gathered from volunteers.

This collection is comprised of two main scripts: one used to calculate the independent variable for trial data, [`handlebar_angles.m`](/handlebar_angles.m), and another to analyze the finished data, [`test_gui.m`](/test_gui.m).

## Main Scripts

### handlebar_angles

The handlebar_angles.m script uses handlebar marker data to calculate the angle of the handlebars, where top dead center (TDC) of the left handlebar is 0 deg. and pedaling forward is associated with positive change in angle. Two major--from a conceptual standpoint--computations occur in this script: PCA calculation, inverse tangent calculations for the angle.

Prior to using inverse tangent to calculate the angles, the principle components must be calculated to ensure that the 'x' and 'y' variables accurately represent the circle the markers travel through. Once the principle components have been calculated, the marker data is projected onto them (the components). The projected data is now used in 4-quadrant inverse tangent calculations to compute the angle of the handlebars.

#### Instructions

Using the handlebar_angle script is simple. Running the script opens a "Pick file" dialog. Choose the trial you want (should be a .trc file), the script will run for a indeterminate amount of time (due to the probabilistic PCA implementation) and then save automatically save the handlebar angles under a new Excel file with the filename of "[Input filename] handlebars.xlsx"

### test_gui

The GUI allows the fully processed data to be browsed by choosing any of the joint angles desired for graphing, using any of the four major graph types. This is important in the time-constrained environment of Senior Design to allow the data to be quickly browsed for relevant angle-analysis pairs.

#### Instructions

![Picture of the GUI](/media/gui_picture.png?raw=true)

The use of the GUI should be fairly obvious, however, here are in-depth instructions just in case.

First, the first and second trials need to be loaded using the "Pick First File" and "Pick Second File" buttons, respectively. For the program to work properly, the handlebar angle files must be in the same directory as the trial (.mot) files and be named properly (ie don't change the default name of the angle file generated by the handlebar_angles script).

Once the trials have been loaded, any angle can be selected from the angle list and graphed.

![Selecting Angles](/media/gui_pick_angles.gif?raw=true)

Multiple angles can be selected at once for convenience. If either of the first two graph types are selected, either "Single Shaded Std" or "Compare Shaded Std", a new figure containing the selected graph type will appear for each selected angle (eg 'pelvis_tilt', 'pelvis_list', and 'hip_flexion_r' have been selected; the graph type is "Single Shaded Std"; 3 figures will be generated of graph type "Single Shaded Std", one new figure for each angle). However certain conditions apply to multiple angle selection for both of the last two graph types, "Symmetry - Ccnorm" or "Symmetry - NSI". The symmetry based graphs require two and only two symmetric angles (any joint that has right and left angles) to be select: any selection that does not meet that criteria--either an incorrect number of angles have been selected or the pair is not a symmetric type joint angle--the program will complain and will not generate any figures until the selected angles have been adjusted or the graph type has been changed.

![Graph Types](/media/gui_graph_types.gif?raw=true)

There are 4 graph types:

1. [Single Shaded Std](/plotStd.m)
  - This graph plots the old and the new data on the left and right, respectively. The average joint angle versus handlebar angle is shown in a solid blue line, while a red dashed line depicts the standard deviation of the joint angle versus handlebar angle.
2. [Compare Shaded Std](/plotStdComp.m)
  - This graph plots the exact same *data* as the first graph type, except the old and the new trials are superimposed on top of each other in order to visually compare the improvement in joint angle variation across hanldebar angle. The standard deviation of the first trial is depicted as a gray shaded area, while the second trial uses a red dashed line to show the standard deviation.
3. [Symmetry - Ccnorm](/plotCcnorm.m)
  - This graph visually compares the symmetry of the pair of joint angles by superimposing the mean joint angles and shifting right side by 180 deg to align the curves. Cross-correlation norm is a score of the symmetry of the right and left joint angles between 0 and 1, where higher indicates a higher symmetry. The reference for the equations used in calculating the  cross-correlation can be found in the function file [`Ccnorm.m`](/Ccnorm.m)
4. [Symmetry - NSI](/plotNSI.m)
  - This graph calculates the normalized symmetry index (NSI) for each good revolution in the data and then takes the average and standard deviation of the NSI of all the revolutions. As always, the average is shown as a solid blue line, and the standard deviation is shown as a red dashed line. The vertical axis is in units of percent; closer to zero indicates higher symmetry. The reference for the equations used in calculating the NSI can be found in the function file [`nsi.m`](/nsi.m)

![Bin Width](/media/gui_bin_width.gif)

As a result of the mocap process and the handlebar angle calculations, the caluclated angles for the handlebars are not round numbers, therefore some amount of "lumping" together of the angles is necessary. We have found that using an interval of 4 deg results in the least noisy graphs without unduly smoothing important features.

## Script Dependency Hierarchies

```
handlebar_angles.m
|_ robustPCA.m
|   |_ OcTree.m
|   |_ lms.m
|   |   |_ gendist.m
|   |_ barepca.m
|_ CalculateAngles.m

test_gui.m
|_ test_gui.fig
|_ plotStd.m
|_ plotStdComp.m
|_ plotCcnorm.m
|   |_ Ccnorm.m
|_ plotNSI.m
|   |_nsi.m
|_ segmentAngles.m
```

## External Dependencies

> [octree - partitioning 3d points into spatial subvolumes](https://www.mathworks.com/matlabcentral/fileexchange/40732-octree-partitioning-3d-points-into-spatial-subvolumes) by [@Sven](https://www.mathworks.com/matlabcentral/profile/authors/1672378-sven), used in the RobustPCA algorithm.

License:

```
Copyright (c) 2013, Sven
All rights reserved.

Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions are
met:

    * Redistributions of source code must retain the above copyright
      notice, this list of conditions and the following disclaimer.
    * Redistributions in binary form must reproduce the above copyright
      notice, this list of conditions and the following disclaimer in
      the documentation and/or other materials provided with the distribution

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE
LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
POSSIBILITY OF SUCH DAMAGE.
```

> [Random Numbers from a Discrete Distribution](https://www.mathworks.com/matlabcentral/fileexchange/34101-random-numbers-from-a-discrete-distribution/content/gendist.m) by [@Tristan Ursell](https://www.mathworks.com/matlabcentral/profile/authors/998756-tristan-ursell), used in the lms algorithm.

License:
```
Copyright (c) 2011, Tristan Ursell
All rights reserved.

Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions are
met:

    * Redistributions of source code must retain the above copyright
      notice, this list of conditions and the following disclaimer.
    * Redistributions in binary form must reproduce the above copyright
      notice, this list of conditions and the following disclaimer in
      the documentation and/or other materials provided with the distribution

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE
LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
POSSIBILITY OF SUCH DAMAGE.
```

# License

The SMART Analysis Stack is licenced under the [GPLv3](https://github.com/halleysfifthinc/smart-analysis-stack/blob/master/LICENSE.txt)
