import numpy as np
import control
import matplotlib.pyplot as plt

# Define the numerator and denominator coefficients
# For (s+4)(s+5) = s^2 + 9s + 20 <---(1)*s^2 + (9)*s + 20*s^0
num = [1, 9, 20]
# For (s+1+3j)(s+1-3j) = s^2 + 2s + 10
den = [1, 2, 10]
# Create the transfer function
sys = control.TransferFunction(num, den)

# Create the root locus plot
plt.figure(figsize=(10, 8))
control.root_locus(sys, grid=True)

# Adjust the plot layout
plt.grid(True)
plt.axis('equal')
ax = plt.gca()
ax.set_xlim([-6,1])    # nicer axis limits for graph readability
ax.set_ylim([-3.5,3.5])
# Show the plot
plt.show()

# Print system information
print("\nTransfer Function:")
print(sys)
# Calculate and print poles and zeros
poles = control.poles(sys)
zeros = control.zeros(sys)
print("\nPoles:", poles)
print("Zeros:", zeros)
