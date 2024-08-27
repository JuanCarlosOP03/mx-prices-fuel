from config.conf import AppSettings
import requests
import os


def data_extractor(url: str, filebasename):
    settings = AppSettings()
    response = requests.get(url)
    if response.status_code != 200:
        response.raise_for_status()
        
    data = response.content
    file_path = os.path.join(settings.project_path, 'data/ext', filebasename)
    os.makedirs(os.path.join(settings.project_path, 'data/ext'), exist_ok=True)

    with open(file_path, 'wb') as f:
        f.write(data)
        
    return file_path