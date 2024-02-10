

from dotenv import load_dotenv
import os

env = False

def load_env():
    global env
    if env:
        return
    env = True
    load_dotenv()

def make_folder(*args):
    import os
    folder = os.path.join(*args)
    try:
        os.mkdir(folder)
    except:
        pass
    return folder

def is_num(n):
    try:
        int(n)
        return True
    except:
        return False


