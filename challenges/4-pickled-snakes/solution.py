import pickle

with open('flag.unknown', 'rb') as f:
    result = pickle.load(f)
    print(result)
