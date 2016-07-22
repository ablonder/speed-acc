## Speed-Acc HDDM Test
## Aviva Blonder

import pandas as pd
import matplotlib.pyplot as plt
import numpy as np
import hddm

## Loading and arranging data for analysis
data = hddm.load_csv("data/3_final_merged_data/speed-acc-ss-df.csv")
data = data.dropna(subset = ['RT'])
data['stimuli'] = np.where(data['stimuli'] == "V1", "ASL", data['stimuli'])
data['stimuli'] = np.where(data['stimuli'] == "V2", "ASL", data['stimuli'])
data['stimuli'] = np.where(data['stimuli'] == "Trio", "Object", data['stimuli'])
data['stimuli'] = np.where(data['stimuli'] == "Bull", "Bullseye", data['stimuli'])
data['rt'] = data['RT_sec']
data['response'] = data['correct']
# print(data.head(10))

#%%
## Mixture model - no parameters vary by condition
model = hddm.HDDM(data, include = ('p_outlier'))
model.find_starting_values()
model.sample(2000, burn = 20)
model.print_stats()
model.plot_posteriors()
model.plot_posterior_predictive(figsize = (14, 10))

#%%
## Drift and boundary separation can vary by condition
var_model = hddm.HDDM(data, include = ('p_outlier'), depends_on = {'v': 'stimuli', 'a' : 'stimuli'})
var_model.find_starting_values()
var_model.sample(2000, burn = 20)
var_model.print_stats()
var_model.plot_posteriors()
var_model.plot_posterior_predictive(figsize = (14, 10))

## Plot of drift by condition
drift_ASL, drift_Face, drift_Obj, drift_Bull = var_model.nodes_db.node[['v(ASL)', 'v(Face)', 'v(Object)', 'v(Bullseye)']]
hddm.analyze.plot_posterior_nodes([drift_ASL, drift_Face, drift_Obj, drift_Bull])
plt.xlabel('drift-rate')
plt.ylabel('Posterior probability')
plt.title('Posterior of drift-rate group means')

## Plot of boundary separation by condition
sep_ASL, sep_Face, sep_Obj, sep_Bull = var_model.nodes_db.node[['a(ASL)', 'a(Face)', 'a(Object)', 'a(Bullseye)']]
hddm.analyze.plot_posterior_nodes([sep_ASL, sep_Face, sep_Obj, sep_Bull])
plt.xlabel('boundary separation')
plt.ylabel('Posterior probability')
plt.title('Posterior of boundary separation group means')