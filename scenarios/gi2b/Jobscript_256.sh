#!/bin/bash
#SBATCH -J gi2b_run # job name
#SBATCH -o jobout.o%j # output and error file name (%j expands to jobID)
#SBATCH -n 256             # total number of mpi tasks requested
#SBATCH -p normal    # queue (partition) -- normal, development, etc.
#SBATCH -t 48:00:00        # run time (hh:mm:ss) - 1.0 hours
#SBATCH --mail-user=tlim@design.upenn.edu
#SBATCH --mail-type=begin  # email me when the job starts
#SBATCH --mail-type=end    # email me when the job finishes

ibrun /home1/03979/tg832785/ParF/parflow/bin/parflow lbase
