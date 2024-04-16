import netCDF4 as nc
import matplotlib.pyplot as plt
import numpy as np

# Path to your Exodus file
# exodus_file_path = "/home/lstein/projects/sc_res/Results_Exo/MagArg_Time5_out_SCS_1.e"
exodus_file_path = "/home/lstein/projects/sc_res/week1/MagArg_Time5_out.e"
# exodus_file_path = '/home/lstein/projects/sc_res/Demo/NormalBC_out.e'
# exodus_file_path = '/home/lstein/projects/sc_res/Demo/NormalBC_VarryingProperties_out.e'

# Open the Exodus file
dataset = nc.Dataset(exodus_file_path)

skip = 58

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
point1 = (98, 5)

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

# Plotting the difference in 'Psi_Im' values over time
plt.figure(figsize=(10, 6))
plt.plot(current_steps[skip:], psi_im_difference[skip:], label='Constant Material Properties' ) #, marker='o', linestyle='-')

exodus_file_path = '/home/lstein/projects/sc_res/Demo/NormalBC_VarryingProperties_out.e'

# Open the Exodus file
dataset = nc.Dataset(exodus_file_path)

skip = 58

nodal_var_names = [name.tobytes().decode('ascii').strip() for name in dataset.variables['name_nod_var']]

print("Nodal variable names found:")
for var_name in nodal_var_names:
    print(var_name)

# print(nodal_var_names[])

# Extract time steps
time_steps = dataset.variables['time_whole'][:]

current_steps = 0.0001*time_steps +0.25

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

# Plotting the difference in 'Psi_Im' values over time
# plt.figure(figsize=(10, 6))
plt.plot(current_steps[skip:], psi_im_difference[skip:], label='Varying Material Properties' ) #, marker='o', linestyle='-')



# plt.title('Potential across the sample against Current Density')
plt.xlabel('Current Density')
plt.ylabel('Potential Difference')
plt.grid(True)
plt.legend()

plt.show()
