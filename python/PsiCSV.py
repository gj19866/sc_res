import random
import math
import csv

def run():
    x = random.uniform(-1, 1)
    y = random.uniform(-1, 1)
    mag = math.sqrt(x**2 + y**2)
    xx = x / mag
    yy = y / mag
    mag = xx**2 + yy**2
    return xx, yy, mag

# print(run())
list1 = []
for i in range(4000):
    list1.append(run())

csv_file = r"\Users\lloyd\Documents\AAA UNI\4th year\Project\Psi_IC.csv"

# Open the CSV file in write mode
with open(csv_file, mode='w', newline='') as file:
    # Create a CSV writer object
    writer = csv.writer(file)


    # Write the data to the CSV file
    for row in list1:
        writer.writerow(row)

print(f"Data has been written to {csv_file}")