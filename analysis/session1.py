from sklearn.datasets import make_blobs
from sklearn import svm
import numpy as np
import pandas as pd
from sklearn import preprocessing

blobs = make_blobs(n_samples=1000, n_features=2, centers=1, cluster_std=1.5, shuffle=True, random_state=5)
normolized_data = preprocessing.StandardScaler().fit_transform(blobs[0])

out_fraction = 0.02
nu_estimate = 0.95 * out_fraction + 0.05
mechine_learning = svm.OneClassSVM(kernel="rbf", degree=3, gamma=1.0 / len(normolized_data), nu=nu_estimate)
mechine_learning.fit(normolized_data)
detection = mechine_learning.predict(normolized_data)
outliers = np.where(detection == -1)
regular = np.where(detection == 1)
from matplotlib import pyplot as plt

a = plt.plot(normolized_data[regular, 0], normolized_data[regular, 1], 'x', markersize=2, color="green", alpha=0.6)
b = plt.plot(normolized_data[outliers, 0], normolized_data[outliers, 1], 'o', color='red', markersize=6)

plt.show()
