# Modular Stiffness Modulation in 3D-Printed Soft Actuators for Adaptive Trajectory Control
Experimental data and analysis supporting “Modular Stiffness Modulation in 3D-Printed Soft Actuators for Adaptive Trajectory Control.” Includes raw and processed results, scripts, and visualizations for evaluating modular SLL effects on soft pneumatic actuator performance and applications.

This repository contains the experimental data and analysis supporting the paper "Modular Stiffness Modulation in 3D-Printed Soft Actuators for Adaptive Trajectory Control" by P.D.S.H. Gunawardane et al. The data provided here includes raw and processed results from experiments evaluating the performance of soft pneumatic actuators (SPAs) equipped with modular, press-fittable strain-limiting layers (SLLs). These experiments demonstrate how different SLL configurations affect actuator stiffness, motion trajectories, and practical applications such as robotic gripping and endoscopic imaging. The repository also includes scripts and analysis files used to process and visualize the results, enabling researchers to reproduce the findings and further explore adaptive trajectory control in soft robotics. This resource is intended to facilitate transparency, reproducibility, and further research in the field.
🧪 Description
The primary script, MainCode.m, processes experimental displacement data collected from soft pneumatic actuators made from:

Dragon Skin Only

Dragon Skin + Ecoflex

The analysis includes:

Trajectory classification based on Y-displacement.

Curvature computation for each trajectory.

Root Mean Square Deviation (RMSD) calculation relative to reference trajectories.

Visual comparisons of deformation patterns.

Statistical significance tests (t-tests) on RMSD values.

📁 Files
File Name	Description
MainCode.m	Main analysis script.
OverLapMat.mat	Data file containing the trajectory info for all configurations.
compute_curvature	Internal function for curvature estimation.
get_side_rmsd	Internal function for RMSD computation within side groups.

▶️ How to Run
Open MATLAB and ensure the current folder includes:

MainCode.m

OverLapMat.mat

Run the script:

matlab
Copy
Edit
MainCode
The script will:

Load and process trajectory data.

Display figures showing:

Raw trajectories colored by material.

RMSD values per configuration.

Curvature distribution comparison.

Print statistical results of t-tests in the command window.

📊 Outputs
Figure 1: Trajectories colored by material type.

Figure 2: RMSD bar plot categorized by side and material.

Figure 3: Histogram of curvature distributions.

Console Output: T-test results comparing RMSD by material and Y-axis side.

📌 Requirements
MATLAB R2020a or newer (older versions may also work)

No additional toolboxes required

📫 Contact
For questions or further collaboration, please contact:
P.D.S.H. Gunawardane
Email shehanhg@gmail.com
