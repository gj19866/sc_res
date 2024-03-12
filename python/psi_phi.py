import netCDF4 as nc
import matplotlib.pyplot as plt
import numpy as np

# Path to your Exodus file
# exodus_file_path = "/home/lstein/projects/sc_res/Results_Exo/MagArg_Time5_out_SCS_1.e"
# exodus_file_path = "/home/lstein/projects/sc_res/week1/MagArg_Time2_periodic_out.e"
exodus_file_path = '/home/lstein/projects/sc_res/Demo/NormalBC_VarryingProperties_out.e'

# Open the Exodus file
dataset = nc.Dataset(exodus_file_path)

skip = 5

nodal_var_names = [name.tobytes().decode('ascii').strip() for name in dataset.variables['name_nod_var']]

print("Nodal variable names found:")
for var_name in nodal_var_names:
    print(var_name)

# print(nodal_var_names[])

# Extract time steps
time_steps = dataset.variables['time_whole'][:]

current_steps = 0.001*time_steps

# Define the target points
point2 = (2, 5)
point1 = (38, 5)

# Extract node coordinates
x_coords = dataset.variables['coordx'][:]
y_coords = dataset.variables['coordy'][:]

# Function to find the index of the closest node to a given point
def find_closest_node(x_target, y_target):
    distances = np.sqrt((x_coords - x_target)**2 + (y_coords - y_target)**2)
    return np.argmin(distances)

# Find the indexes of the closest nodes to the points
closest_node_index_1 = find_closest_node(*point1)
closest_node_index_2 = find_closest_node(*point2)

# Extract 'Psi_Im' values for the closest nodes across all time steps
psi_im_values_1 = dataset.variables['vals_nod_var3'][:, closest_node_index_1]
psi_im_values_2 = dataset.variables['vals_nod_var3'][:, closest_node_index_2]

# Compute the difference in 'Psi_Im' values between the two points over time
psi_im_difference = psi_im_values_1 - psi_im_values_2

psi_mag = dataset.variables['vals_nod_var5'][:, :].mean(axis=1)

# Plotting the difference in 'Psi_Im' values over time
# plt.figure(figsize=(10, 6))
# plt.plot(current_steps[skip:], psi_im_difference[skip:] ) #, marker='o', linestyle='-')
# plt.plot(current_steps[skip:], psi_mag[skip:] ) #, marker='o', linestyle='-')
# plt.title('Potential across the sample against Current Density')
# plt.xlabel('Current Density')
# plt.ylabel('Potential Difference')
# plt.grid(True)
# plt.show()

fig, ax1 = plt.subplots(figsize=(10, 6))

# Plotting on the first y-axis (ax1)
color1 = 'tab:blue'
ax1.set_xlabel(r'Current Density ($j_b$)')
ax1.set_ylabel('Potential Difference (V)')  # , color=color1)
line1, = ax1.plot(current_steps[skip:], psi_im_difference[skip:], color=color1, label='Voltage')
ax1.tick_params(axis='y')  # , labelcolor=color1)
ax1.grid(True)

# Creating a twin Axes for the second y-axis (ax2)
ax2 = ax1.twinx()

# Plotting on the second y-axis (ax2)
color2 = 'tab:red'
ax2.set_ylabel(r'Mean $|\psi|$ across the sample')  # , color=color2)
line2, = ax2.plot(current_steps[skip:], psi_mag[skip:], color=color2, label=r'Mean $|\psi|$')
ax2.tick_params(axis='y')  # , labelcolor=color2)

# Adding legend
lines = [line1, line2]
labels = [line.get_label() for line in lines]
ax1.legend(lines, labels, loc='upper right')

# plt.title(r'Potential Difference and Mean $|\psi|$ against Current Density for a samp')
plt.show()