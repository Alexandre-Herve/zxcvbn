#!/usr/bin/python
import os
import codecs
import json
import sys

from build_frequency_lists import parse_frequency_lists, filter_frequency_lists

def to_json():
    if len(sys.argv) != 3:
        print usage()
        sys.exit(0)
    data_dir, output_file = sys.argv[1:]
    unfiltered_freq_lists = parse_frequency_lists(data_dir)
    freq_lists = filter_frequency_lists(unfiltered_freq_lists)
    with codecs.open(output_file, 'w', 'utf8') as f:
        script_name = os.path.split(sys.argv[0])[1]
        f.write(json.dumps(freq_lists))

if __name__ == '__main__':
    to_json()
