import netCDF4 as nc
import matplotlib.pyplot as plt
import numpy as np

exodus_file_path = '/home/lstein/projects/sc_res/Demo/NormalBC_VarryingProperties_out.e'

# Open the Exodus file
dataset = nc.Dataset(exodus_file_path)

# Extract time steps
time_steps = dataset.variables['time_whole'][:]

# Extract 'Diffuse' values (assuming it is 'vals_nod_var1')
diffuse_values = dataset.variables['vals_nod_var1'][:, :]

# Grid dimensions
grid_shape_x = 101  # X dimension
grid_shape_y = 11   # Y dimension

# Ensure the total size matches the expected reshaped size
assert diffuse_values.shape[1] == grid_shape_x * grid_shape_y, "Data size does not match grid dimensions"

# Reshape diffuse_values to a 3D array: time steps x grid_shape_x x grid_shape_y
diffuse_values_reshaped = diffuse_values.reshape(len(time_steps), grid_shape_x, grid_shape_y)

# Calculate the mean of 'Diffuse' values in the y direction for each x position
mean_diffuse_y = np.mean(diffuse_values_reshaped, axis=2)

# For demonstration, let's plot these mean values for a specific time step, say the last one
mean_diffuse_y_at_last_time_step = mean_diffuse_y[-1, :]


y_half = [(0.5*mean_diffuse_y_at_last_time_step[i] + 0.5*mean_diffuse_y_at_last_time_step[-i])*i for i in range(int(len(mean_diffuse_y_at_last_time_step)/2))]


# Plotting the mean values directly
plt.figure(figsize=(10, 6))

plt.plot(y_half)
# plt.plot(range(grid_shape_x), mean_diffuse_y_at_last_time_step)
plt.title('Mean "Diffuse" Values in the Y Direction for Each X Position')
plt.xlabel('X Position')
plt.ylabel('Mean "Diffuse" Values in Y')
plt.grid(True)
plt.show()
