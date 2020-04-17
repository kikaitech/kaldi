import os
from shutil import copyfile

# As per README:
# All files of iteration 0-4 move to testing-spectrograms
# All files of iteration 5-49 move to training-spectrograms

def create(source):
    print(source)
    for filename in os.listdir(source):
        f.write("{0}\n".format(" ".join(filename[5:len(filename)-4])))
if __name__ == '__main__':
    f = open("corpus.txt","w")
    name = {'sp01'}
    create("../audio/train/sp01")
    create("../audio/test/sp01")
    #create("../test/theo")
    #create("../test/jackson")
    #create("../test/yweweler")