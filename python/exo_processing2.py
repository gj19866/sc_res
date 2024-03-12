import netCDF4 as nc
import matplotlib.pyplot as plt
import numpy as np

# Path to your Exodus file
exodus_file_path = "/home/lstein/projects/sc_res/Demo/NormalBC_out.e"

# Open the Exodus file
dataset = nc.Dataset(exodus_file_path)

# Extract time steps
time_steps = dataset.variables['time_whole'][:]

# Specify the target point in space you're interested in
x_target, y_target = 1.0, 2.0  # Adjust these to your target coordinates

# Extract node coordinates
x_coords = dataset.variables['coordx'][:]
y_coords = dataset.variables['coordy'][:]

# Calculate distances from each node to the target point
distances = np.sqrt((x_coords - x_target)**2 + (y_coords - y_target)**2)

# Find the index of the closest node
closest_node_index = np.argmin(distances)

# Extract 'Psi_Im' values for the closest node across all time steps
psi_im_closest_node = dataset.variables['vals_nod_var3'][:, closest_node_index]

# Plotting 'Psi_Im' for the closest node over time
plt.figure(figsize=(10, 6))
plt.plot(time_steps, psi_im_closest_node, marker='o', linestyle='-')
plt.title(f'Psi_Im Over Time at Closest Node to ({x_target}, {y_target})')
plt.xlabel('Time')
plt.ylabel('Psi_Im Value')
plt.grid(True)
plt.show()
