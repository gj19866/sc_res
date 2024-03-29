import netCDF4 as nc
import matplotlib.pyplot as plt

# Path to your Exodus file
exodus_file_path = "/home/lstein/projects/sc_res/Demo/NormalBC_out.e"

# Open the Exodus file
dataset = nc.Dataset(exodus_file_path)

# Extract time steps
time_steps = dataset.variables['time_whole'][:]

# Directly use the index to access 'Psi_Im' data
# Since 'Psi_Im' is at index 2 in nodal_var_names, we access 'vals_nod_var3'
psi_im_values = dataset.variables['vals_nod_var3'][:, :].mean(axis=1)

# Plotting
plt.figure(figsize=(10, 6))
plt.plot(time_steps, psi_im_values, marker='o', linestyle='-')
plt.title('Average Psi_Im Over Time')
plt.xlabel('Time')
plt.ylabel('Average Psi_Im Value')
plt.grid(True)
plt.show()
