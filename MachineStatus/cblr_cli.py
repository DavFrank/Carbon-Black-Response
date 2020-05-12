#!/usr/bin/env python

from cbapi.example_helpers import build_cli_parser, get_cb_response_object, CblrCli
from cbapi.response import Sensor, CbEnterpriseResponseAPI
import logging
import sys

log = logging.getLogger(__name__)


def connect_callback(cb, line):
    try:
        sensor_id = int(line)
    except ValueError:
        sensor_id = None

    cb = CbEnterpriseResponseAPI()

    if not sensor_id:
        q = cb.select(Sensor).where("hostname:{0}".format(line))
        sensor = q.first()
    else:
        sensor = cb.select(Sensor, sensor_id)

    return sensor


def main():
    parser = build_cli_parser("Cb Response Live Response CLI")
    parser.add_argument("--log", help="Log activity to a file", default='')
    parser.add_argument("--i", action="store", default=None, dest="s_id", help="CB Sensor ID")        
    args = parser.parse_args()
    cb = get_cb_response_object(args)


    if args.log:
        file_handler = logging.FileHandler(args.log)
        file_handler.setLevel(logging.DEBUG)
        log.addHandler(file_handler)

    cli = CblrCli(cb, connect_callback)

    print ("Sensor ID: " + args.s_id)
    cli.do_connect("" + args.s_id)
	
    cli.cmdloop()


if __name__ == "__main__":
    sys.exit(main())

