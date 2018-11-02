import torch
import torch.nn as nn
import torch.nn.functional as F


# Define the network
# You just have to define the forward function, and the backward function is automatically defined for you using autograd

class Net(nn.Module):
    def __init__(self):
        super(Net, self).__init__()
        self.conv1 = nn.Conv2d(1, 6, 5)
        self.conv2 = nn.Conv2d(6, 16, 5)

        self.fc1 = nn.Linear(16 * 5 * 5, 120)
        self.fc2 = nn.Linear(120, 84)
        self.fc3 = nn.Linear(84, 10)

    def forward(self, x):
        x = F.max_pool2d(F.relu(self.conv1(x)), (2, 2))
        x = F.max_pool2d(F.relu(self.conv2(x)), (2, 2))
        x = x.view(-1, self.num_flat_features(x))
        x = F.relu(self.fc1(x))
        x = F.relu(self.fc2(x))
        x = self.f3(x)
        return x

    def num_flat_features(self, x):
        size = x.size()[1:]
        num_features = 1
        for s in size:
            num_features *= s
        return num_features


net = Net()

# Processing input

input = torch.randn(1, 1, 32, 32)
out = net(input)

# Calling backward
out.backward(torch.randn(1, 10))

# Calculate loss function
target = torch.randn(10)
target = target.view(1, -1)
criterion = nn.MSELoss()

loss = criterion(out, target)

# Backprop
net.zero_grad()
loss.backward()

# Update the weights, weight = weight - learning_rate * gradient

learning_rate = 0.01
for f in net.parameters():
    f.data.sub_(f.grad.data * learning_rate)

# Fi you want to use various different update rules such as SGD ...
import torch.optim as optim

optimizer = optim.SGD(net.parameters(), lr=0.01)
optimizer.zero_grad()
optimizer.step()
