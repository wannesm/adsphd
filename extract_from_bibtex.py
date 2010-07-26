#!/usr/bin/env python

# vim: expandtab tw=75

from optparse import OptionParser
import sys
import re

def process_ref_ids(ref_ids, bibfile):
    f = file(bibfile)
    try:
        for l in f:
            m = re.match('@.*{(.*),', l)
            while m is None or len(m.groups())==0:
                if re.match('@STRING.*', l) is not None:
                    print l,
                l = f.next()
                m = re.match('@.*{(.*),', l)
            ref_id = re.match('@.*{(.*),', l).group(1)

            #print 'Found ref_id:', ref_id
            if ref_id in ref_ids:
                print '\n', l,
                l = f.next()
                while l.strip() != '}':
                    print l,
                    l = f.next()
                print l,

    except StopIteration, e:
        pass

if __name__=='__main__':
    parser = OptionParser()
    parser.add_option('--bibfile', dest='bibfile', default='/home/yves/research/papers/allpapers.bib')
    parser.add_option('--stdin', dest='reflist_from_stdin',\
            default=False, action='store_true')

    cloptions, args = parser.parse_args(sys.argv[1:])

    assert cloptions.bibfile is not None

    if cloptions.reflist_from_stdin:
        args.append(sys.stdin)

    assert len(args)==1

    for infile in args:
        if type(infile) == type('eenstring'):
            infile = file(infile)
        ref_ids = [ i.strip() for i in infile if i.strip() != '' ]
        process_ref_ids(ref_ids, cloptions.bibfile)
