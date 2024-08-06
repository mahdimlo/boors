import logging
import os

logs_dir = "/var/log/app"

os.makedirs(logs_dir, exist_ok=True)

error_logger = logging.getLogger("error_logger")
error_logger.setLevel(logging.ERROR)

error_log_path = os.path.join(logs_dir, "error.log")
error_h = logging.FileHandler(error_log_path, encoding="utf-8")
error_f = logging.Formatter('%(asctime)s - %(levelname)s - %(message)s')
error_h.setFormatter(error_f)

error_logger.addHandler(error_h)

info_logger = logging.getLogger("info_logger")
info_logger.setLevel(logging.INFO)

info_log_path = os.path.join(logs_dir, "info.log")
info_h = logging.FileHandler(info_log_path, encoding="utf-8")
info_f = logging.Formatter('%(asctime)s - %(levelname)s - %(message)s')
info_h.setFormatter(info_f)

info_logger.addHandler(info_h)