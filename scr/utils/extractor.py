from config.conf import AppSettings

#from geopy.geocoders import Nominatim
from pyspark.sql import SparkSession, functions as fx
import requests
import asyncio
import httpx
import os


def data_extractor(url: str, filebasename, **kwargs):
    settings = AppSettings()
    response = requests.get(url, **kwargs)
    if response.status_code != 200:
        response.raise_for_status()
        
    data = response.content
    file_path = os.path.join(settings.project_path, 'data/ext', filebasename)
    os.makedirs(os.path.join(settings.project_path, 'data/ext'), exist_ok=True)

    with open(file_path, 'wb') as f:
        f.write(data)
        
    return file_path

# def get_data_locations(base_url: str, file_path: str, list_params_var, **list_params_fj):
#     os.makedirs(file_path, exist_ok=True)
#     downloads_files = os.listdir(file_path)

#     async def get_data(params_temp: dict):
#         async with httpx.AsyncClient() as client:
#             tasks = {key: asyncio.create_task(client.get(base_url, params=values | list_params_fj)) for key, values in params_temp.items()}
#             return await asyncio.gather(*tasks.values(), return_exceptions=True), tasks.keys()
    
#     while True:
#         ids = {key: values for key, values in list_params_var.items() if key not in downloads_files}
#         if not ids:
#             return file_path
#         send_ids_temp = dict(list(ids.items())[:20])
#         responses, ids_keys = asyncio.run(get_data(send_ids_temp))
#         for id_result, response in zip(ids_keys, responses):
#             if isinstance(response, Exception):
#                 continue
#             status = response.status_code
#             if 200 <= status <= 299:
#                 with open(os.path.join(file_path, id_result), 'w') as f:
#                     print("Write ", id_result)
#                     f.write(response.text)
#                     downloads_files.append(id_result)