from dotenv import dotenv_values

env = None

def load_env():
    global env

    if not env:
        env = dotenv_values("scripts/.env")

    return env



