import netCDF4 as nc
import matplotlib.pyplot as plt
import numpy as np

# Path to your Exodus file
# exodus_file_path = "/home/lstein/projects/sc_res/Results_Exo/MagArg_Time5_out_SCS_1.e"
# exodus_file_path = '/home/lstein/projects/sc_res/Results_Exo/MagArg_ratchet3_right.e'
# exodus_file_path = '/home/lstein/projects/sc_res/Results_Exo/MagArg_ratchet3_left.e'
exodus_file_path = '/home/lstein/projects/sc_res/Demo/NormalBC_out.e'

# Open the Exodus file
dataset = nc.Dataset(exodus_file_path)



element_var_names = [name.tobytes().decode('ascii').strip() for name in dataset.variables['name_elem_var']]

print("Element variable names found:")
for var_name in element_var_names:
    print(var_name)

# print(nodal_var_names[])

# Extract time steps
time_steps = dataset.variables['time_whole'][:]

# Define the target points
# point2 = (92, 50) #Point on one side of sample
# point1 = (308, 50) #Point on the other side of sample

point1 = (2,5)
point2 = (38,5)

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



# Finding the node index is a pain in te ass here
# closest_element_index_1 = 24822
closest_element_index_1 = 1755


# Extract 'Psi_Im' values for the closest nodes across all time steps
psi_im_values_1 = dataset.variables['vals_nod_var3'][:, closest_node_index_1]
psi_im_values_2 = dataset.variables['vals_nod_var3'][:, closest_node_index_2]

j_x_values = dataset.variables['vals_elem_var1eb1'][:, closest_element_index_1]
j_y_values = dataset.variables['vals_elem_var2eb1'][:, closest_element_index_1]



# total_j = [np.sqrt(j_x_values[i]**2 + j_y_values[i]**2) for i in range(len(j_x_values))]
total_j = np.sqrt(j_x_values**2 + j_y_values**2) 



# Compute the difference in 'Psi_Im' values between the two points over time
psi_im_difference = psi_im_values_1 - psi_im_values_2

breaker = -1
# for i in range(len(j_y_values)):
#     if total_j[i+1] == 0:
#         breaker = i
#         break




# Plotting the difference in 'Psi_Im' values over time
plt.figure(figsize=(10, 6))
plt.plot(time_steps[15:breaker], psi_im_difference[15:breaker] ) #, marker='o', linestyle='-')
plt.title('Potential across the sample against time')
plt.xlabel('Time')
plt.ylabel('Potential Difference')
plt.grid(True)
plt.show()

plt.figure(figsize=(10, 6))
plt.plot(time_steps[15:breaker], total_j[15:breaker] ) #, marker='o', linestyle='-')
plt.title('Current across the sample against time')
plt.xlabel('Time')
plt.ylabel('Current Density')
plt.grid(True)
plt.show()

plt.figure(figsize=(10, 6))
plt.plot(total_j[15:breaker], psi_im_difference[15:breaker] ) #, marker='o', linestyle='-')
plt.title('V-I Graph')
plt.xlabel('Current Density')
plt.ylabel('Voltage')
plt.grid(True)
plt.show()
