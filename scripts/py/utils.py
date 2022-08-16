
env = None

def load_env():
    from dotenv import dotenv_values
    global env

    if not env:
        env = dotenv_values("scripts/.env")

    return env

def make_folder(*args):
    import os
    folder = os.path.join(*args)
    try:
        os.mkdir(folder)
    except:
        pass
    return folder


