function [angles, anglesStd] = getAngles(handles, selectedAngle)

% Get the correct angle data according to the angle column indices
switch selectedAngle
  case 'hip_flexion_r'
    angles_raw = handles.data.data(:,handles.hip_flexion_r_ind);
  case 'hip_adduction_r'
    angles_raw = handles.data.data(:,handles.hip_adduction_r_ind);
  case 'hip_rotation_r'
    angles_raw = handles.data.data(:,handles.hip_rotation_r_ind);
  case 'knee_angle_r'
    angles_raw = handles.data.data(:,handles.knee_angle_r_ind);
  case 'ankle_angle_r'
    angles_raw = handles.data.data(:,handles.ankle_angle_r_ind);
  case 'subtalar_angle_r'
    angles_raw = handles.data.data(:,handles.subtalar_angle_r_ind);
  case 'mtp_angle_r'
    angles_raw = handles.data.data(:,handles.mtp_angle_r_ind);
  case 'hip_flexion_l'
    angles_raw = handles.data.data(:,handles.hip_flexion_l_ind);
  case 'hip_adduction_l'
    angles_raw = handles.data.data(:,handles.hip_adduction_l_ind);
  case 'hip_rotation_l'
    angles_raw = handles.data.data(:,handles.hip_rotation_l_ind);
  case 'knee_angle_l'
    angles_raw = handles.data.data(:,handles.knee_angle_l_ind);
  case 'ankle_angle_l'
    angles_raw = handles.data.data(:,handles.ankle_angle_l_ind);
  case 'subtalar_angle_l'
    angles_raw = handles.data.data(:,handles.subtalar_angle_l_ind);
  case 'mtp_angle_l'
    angles_raw = handles.data.data(:,handles.subtalar_angle_l_ind);
  case 'arm_flex_r'
    angles_raw = handles.data.data(:,handles.arm_flex_r_ind);
  case 'arm_add_r'
    angles_raw = handles.data.data(:,handles.arm_add_r_ind);
  case 'arm_rot_r'
    angles_raw = handles.data.data(:,handles.arm_rot_r_ind);
  case 'elbow_flex_r'
    angles_raw = handles.data.data(:,handles.elbow_flex_r_ind);
  case 'pro_sup_r'
    angles_raw = handles.data.data(:,handles.pro_sup_r_ind);
  case 'wrist_flex_r'
    angles_raw = handles.data.data(:,handles.wrist_flex_r_ind);
  case 'wrist_dev_r'
    angles_raw = handles.data.data(:,handles.wrist_dev_r_ind);
  case 'arm_flex_l'
    angles_raw = handles.data.data(:,handles.arm_flex_l_ind);
  case 'arm_add_l'
    angles_raw = handles.data.data(:,handles.arm_add_l_ind);
  case 'arm_rot_l'
    angles_raw = handles.data.data(:,handles.arm_rot_l_ind);
  case 'elbow_flex_l'
    angles_raw = handles.data.data(:,handles.elbow_flex_l_ind);
  case 'pro_sup_l'
    angles_raw = handles.data.data(:,handles.pro_sup_l_ind);
  case 'wrist_flex_l'
    angles_raw = handles.data.data(:,handles.wrist_flex_l_ind);
  case 'wrist_dev_l'
    angles_raw = handles.data.data(:,handles.wrist_dev_l_ind);
end

[angles,anglesStd,~] = segmentAngles(angles_raw,handles.firstBinAngleIndices);

clear angles_raw
