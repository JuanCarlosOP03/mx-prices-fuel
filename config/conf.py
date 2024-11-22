import os
import configparser

class AppSettings(object):
    def __init__(self) -> None:
        self.__path_loc = os.path.dirname(os.path.abspath(__file__))
        self.__config = configparser.ConfigParser()
        self.__config.read(os.path.join(self.__path_loc, 'conf.cfg'))

    @property
    def project_path(self):
        return self.__config.get('core', 'project_path')

    @property
    def base_url(self):
        return self.__config.get('urls', 'base_url')
    
    @property
    def url_place_details(self):
        return self.__config.get('urls', 'url_places_detail')
    
    