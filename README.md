get dossy wit it <br />
# make rules:
`make (no rule)` - default, which is `make test` <br />
`make test` - build os, build programs, run in emulator <br />
`make run` - run in emulator <br />
`make all` - build os <br />
`make clean` - clean all build files <br />
`make getprograms` - you shouldn't need to run this, but this puts the list of all the valid programs you can run in [programs.txt](programs.txt)

to specify program to run (options are in the `programs` folder, and also [programs.txt](programs.txt)), use `PROGRAM=program` (do not include file extensions) <br />