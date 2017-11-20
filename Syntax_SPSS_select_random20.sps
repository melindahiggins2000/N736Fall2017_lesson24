* Encoding: UTF-8.
* select 20 cases at random.

DATASET ACTIVATE DataSet1.
DATASET COPY  random_sample_data20.
DATASET ACTIVATE  random_sample_data20.
FILTER OFF.
USE ALL.
SAMPLE  20 from 453.
EXECUTE.
DATASET ACTIVATE  DataSet1.
