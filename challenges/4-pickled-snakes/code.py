import pickle

def main():
    with open('flag.txt') as f:
        flag = f.readline().strip()

    result = [
        "this file is fully encrypted using the pickled snakes method we talked about!!!",
        list(enumerate(flag))
    ]

    with open('flag.unknown', 'wb') as f:
        pickle.dump(result, f)

if __name__ == "__main__":
    main()
