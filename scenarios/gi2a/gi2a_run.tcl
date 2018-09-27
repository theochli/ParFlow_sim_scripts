# PRODUCTION RUN 6 MONTHS, from Mar 1 - Aug 31, 2015 (4416 hours)
# Initial condition is base case spinup (5m resolution)
# Mannings post calibration
# Porosity and Permeability for storage layer in GI based on 
# contributing area and facility average

set tcl_precision 17

set runname lbase
set verbose 1
#
# Import the ParFlow TCL package
#
lappend auto_path $env(PARFLOW_DIR)/bin 
package require parflow
namespace import Parflow::*

pfset FileVersion 4

pfset Process.Topology.P        		16
pfset Process.Topology.Q        		16
pfset Process.Topology.R        		1

#---------------------------------------------------------
# Computational Grid
#---------------------------------------------------------
# 'native' grid resolution
pfset ComputationalGrid.Lower.X			0.0
pfset ComputationalGrid.Lower.Y			0.0
pfset ComputationalGrid.Lower.Z			0.0

pfset ComputationalGrid.NX            		96
pfset ComputationalGrid.NY            	 	60
pfset ComputationalGrid.NZ            		12

pfset ComputationalGrid.DX	      		5
pfset ComputationalGrid.DY           		5
pfset ComputationalGrid.DZ			10 

#---------------------------------------------------------
# The Names of the GeomInputs
#---------------------------------------------------------
pfset GeomInput.Names     	     		"domaininput indinput"

pfset GeomInput.domaininput.GeomName  		domain
pfset GeomInput.domaininput.InputType  		Box 

pfset GeomInput.indinput.InputType		IndicatorField
pfset Geom.indinput.FileName			indicatorgi2a.pfb
pfset GeomInput.indinput.GeomNames		"b2 b1 tz sap2 sap1 \
						st nat22 nat21 \
						nat14 nat13 nat12 nat11 \
						ts pv girow gipriv "


pfset GeomInput.b2.Value			1115
pfset GeomInput.b1.Value			1114
pfset GeomInput.tz.Value			1113
pfset GeomInput.sap2.Value			1112
pfset GeomInput.sap1.Value			1111
pfset GeomInput.st.Value			123
pfset GeomInput.nat22.Value			116
pfset GeomInput.nat21.Value			115
pfset GeomInput.nat14.Value			114
pfset GeomInput.nat13.Value			113
pfset GeomInput.nat12.Value			112
pfset GeomInput.nat11.Value			111
pfset GeomInput.ts.Value			101
pfset GeomInput.pv.Value			102
pfset GeomInput.girow.Value			104
pfset GeomInput.gipriv.Value			105

#--------------------------------------------------
# Domain Geometry 
#--------------------------------------------------
# Set to the computational grid


pfset Geom.domain.Lower.X          		    0.0
pfset Geom.domain.Lower.Y             		0.0
pfset Geom.domain.Lower.Z            		0.0
 
pfset Geom.domain.Upper.X            		480
pfset Geom.domain.Upper.Y               	300
pfset Geom.domain.Upper.Z               	120

pfset Geom.domain.Patches  			"x-lower x-upper y-lower y-upper \
						z-lower z-upper"

#--------------------------------------------
# variable dz assignments
#--------------------------------------------
pfset Solver.Nonlinear.VariableDz       True
pfset dzScale.GeomNames            		domain
pfset dzScale.Type            			nzList
pfset dzScale.nzListNumber       		12

pfset Cell.0.dzScale.Value 		   	2.51	
pfset Cell.1.dzScale.Value 		   	1.0	
pfset Cell.2.dzScale.Value 		   	0.5	
pfset Cell.3.dzScale.Value 		   	0.5	
pfset Cell.4.dzScale.Value 			0.25
pfset Cell.5.dzScale.Value			0.075
pfset Cell.6.dzScale.Value 			0.05
pfset Cell.7.dzScale.Value 			0.05
pfset Cell.8.dzScale.Value 			0.05
pfset Cell.9.dzScale.Value			0.005
pfset Cell.10.dzScale.Value			0.005
pfset Cell.11.dzScale.Value			0.005

#-----------------------------------------------------------------------------
# Perm
#-----------------------------------------------------------------------------

pfset Geom.Perm.Names                 		"domain"

pfset Geom.domain.Perm.Type             	PFBFile
#pfset Geom.domain.Perm.Type             	Constant
# in m/hr, based on K_sat for pervious
#pfset Geom.domain.Perm.Value 			2.93e-1

pfset Geom.domain.Perm.FileName         	permgi2a.pfb

pfset Perm.TensorType               		TensorByGeom

pfset Geom.Perm.TensorByGeom.Names  		"domain"

pfset Geom.domain.Perm.TensorValX  		1.0d0
pfset Geom.domain.Perm.TensorValY  		1.0d0
pfset Geom.domain.Perm.TensorValZ  		1.0d0

#-----------------------------------------------------------------------------
# Relative Permeability
#-----------------------------------------------------------------------------

pfset Phase.RelPerm.Type                	VanGenuchten
pfset Phase.RelPerm.GeomNames           	"domain"

pfset Geom.domain.RelPerm.Alpha         	3.5
pfset Geom.domain.RelPerm.N             	2.

pfset Geom.domain.RelPerm.NumSamplePoints 	20000
pfset Geom.domain.RelPerm.MinPressureHead 	-300

#---------------------------------------------------------
# Saturation
#---------------------------------------------------------

pfset Phase.Saturation.Type             	VanGenuchten
pfset Phase.Saturation.GeomNames        	"domain"

pfset Geom.domain.Saturation.Alpha      	3.5
pfset Geom.domain.Saturation.N          	2
pfset Geom.domain.Saturation.SRes       	0.2
pfset Geom.domain.Saturation.SSat       	1.0

#-----------------------------------------------------------------------------
# Specific Storage
#-----------------------------------------------------------------------------

pfset SpecificStorage.Type            		"Constant"
pfset SpecificStorage.GeomNames       		"domain"
pfset Geom.domain.SpecificStorage.Value 	1.0e-5

#-----------------------------------------------------------------------------
# Phases
#-----------------------------------------------------------------------------

pfset Phase.Names 				"water"

pfset Phase.water.Density.Type	        	Constant
pfset Phase.water.Density.Value	        	1.0

pfset Phase.water.Viscosity.Type		Constant
pfset Phase.water.Viscosity.Value		1.0

#-----------------------------------------------------------------------------
# Contaminants
#-----------------------------------------------------------------------------

pfset Contaminants.Names			""

#-----------------------------------------------------------------------------
# Retardation
#-----------------------------------------------------------------------------

pfset Geom.Retardation.GeomNames        	""

#-----------------------------------------------------------------------------
# Gravity
#-----------------------------------------------------------------------------

pfset Gravity					1.0

#-----------------------------------------------------------------------------
# Setup timing info
#-----------------------------------------------------------------------------
# run for six months at 0.1 hr timesteps. NOTE: PF code modified,
# so that if solver NONCONV, will cut to 0.001 h dt

set	start	0
set	end	4416

pfset TimingInfo.BaseUnit        		0.0001
pfset TimingInfo.StartCount      		$start
pfset TimingInfo.StartTime       	        $start
pfset TimingInfo.StopTime        		$end
pfset TimingInfo.DumpInterval    		0.1
pfset TimeStep.Type              		Constant
pfset TimeStep.Value             		0.1

#-----------------------------------------------------------------------------
# Time Cycles
#-----------------------------------------------------------------------------
# Match with TimingInfo.BaseUnit
#pfset Cycle.Names "constant rainrec"
pfset Cycle.Names 						"constant"
pfset Cycle.constant.Names              "alltime"
pfset Cycle.constant.alltime.Length      10000.0
pfset Cycle.constant.Repeat             -1

# rainfall and recession time periods are defined here
# rain for 24 hours, recession for 24 hours------not using this right now

#pfset Cycle.rainrec.Names                 "rain rec"
#pfset Cycle.rainrec.rain.Length           240.0
#pfset Cycle.rainrec.rec.Length            240.0
#pfset Cycle.rainrec.Repeat                -1


#-----------------------------------------------------------------------------
# Porosity
#-----------------------------------------------------------------------------

pfset Geom.Porosity.GeomNames			"b2 b1 tz sap2 sap1 \
						st nat22 nat21 \
						nat14 nat13 nat12 nat11 \
						ts pv girow gipriv"



pfset Geom.b2.Porosity.Type		Constant
pfset Geom.b2.Porosity.Value		0.02

pfset Geom.b1.Porosity.Type		Constant
pfset Geom.b1.Porosity.Value		0.05

pfset Geom.tz.Porosity.Type		Constant
pfset Geom.tz.Porosity.Value		0.47

pfset Geom.sap2.Porosity.Type		Constant
pfset Geom.sap2.Porosity.Value		0.47

pfset Geom.sap1.Porosity.Type		Constant
pfset Geom.sap1.Porosity.Value		0.47

pfset Geom.st.Porosity.Type		Constant
pfset Geom.st.Porosity.Value		0.07

pfset Geom.nat22.Porosity.Type		Constant
pfset Geom.nat22.Porosity.Value		0.47

pfset Geom.nat21.Porosity.Type		Constant
pfset Geom.nat21.Porosity.Value		0.47

pfset Geom.nat14.Porosity.Type		Constant
pfset Geom.nat14.Porosity.Value		0.45

pfset Geom.nat13.Porosity.Type		Constant
pfset Geom.nat13.Porosity.Value		0.45

pfset Geom.nat12.Porosity.Type		Constant
pfset Geom.nat12.Porosity.Value		0.40

pfset Geom.nat11.Porosity.Type		Constant
pfset Geom.nat11.Porosity.Value		0.40

pfset Geom.pv.Porosity.Type		Constant
pfset Geom.pv.Porosity.Value		0.001

pfset Geom.ts.Porosity.Type		Constant
pfset Geom.ts.Porosity.Value		0.46

pfset Geom.girow.Porosity.Type		Constant
pfset Geom.girow.Porosity.Value		0.01

pfset Geom.gipriv.Porosity.Type		Constant
pfset Geom.gipriv.Porosity.Value	0.0427


#-----------------------------------------------------------------------------
# Domain
#-----------------------------------------------------------------------------

pfset Domain.GeomName 				domain
#-----------------------------------------------------------------------------
# Wells
#-----------------------------------------------------------------------------
pfset Wells.Names                       	""

#-----------------------------------------------------------------------------
# Boundary Conditions: Pressure
#-----------------------------------------------------------------------------
pfset BCPressure.PatchNames     		"z-upper z-lower x-lower x-upper \
                                      		y-lower y-upper"
              
pfset Patch.y-upper.BCPressure.Type             FluxConst
pfset Patch.y-upper.BCPressure.Cycle            "constant"
pfset Patch.y-upper.BCPressure.alltime.Value	0

pfset Patch.y-lower.BCPressure.Type             FluxConst 
pfset Patch.y-lower.BCPressure.Cycle          	"constant"
pfset Patch.y-lower.BCPressure.alltime.Value    0

pfset Patch.x-upper.BCPressure.Type             DirEquilRefPatch 
pfset Patch.x-upper.BCPressure.Cycle          	"constant"
pfset Patch.x-upper.BCPressure.RefGeom		domain
pfset Patch.x-upper.BCPressure.RefPatch	        z-upper
pfset Patch.x-upper.BCPressure.alltime.Value    -5.5

pfset Patch.x-lower.BCPressure.Type		DirEquilRefPatch
pfset Patch.x-lower.BCPressure.Cycle		"constant"
pfset Patch.x-lower.BCPressure.RefGeom		domain
pfset Patch.x-lower.BCPressure.RefPatch		z-upper
pfset Patch.x-lower.BCPressure.alltime.Value    -20.0

pfset Patch.z-lower.BCPressure.Type		FluxConst
pfset Patch.z-lower.BCPressure.Cycle		"constant"
pfset Patch.z-lower.BCPressure.alltime.Value	0.0

## overland flow boundary condition with with constant recharge
pfset Patch.z-upper.BCPressure.Type          	OverlandFlow
pfset Patch.z-upper.BCPressure.Cycle            "constant"
#pfset Patch.z-upper.BCPressure.alltime.Value    -3.47945e-5
pfset Patch.z-upper.BCPressure.alltime.Value     0.0


## overland flow boundary condition very heavy rainfall then recession
#pfset Patch.z-upper.BCPressure.Cycle          	"rainrec"
#pfset Patch.z-upper.BCPressure.rain.Value	    -0.005
#pfset Patch.z-upper.BCPressure.rec.Value	     0.00





#---------------------------------------------------------
# Topo slopes in x-direction
#---------------------------------------------------------

pfset TopoSlopesX.Type 				"PFBFile"
pfset TopoSlopesX.GeomNames 			"domain"
pfset TopoSlopesX.FileName 			slopex.pfb


#pfset TopoSlopesX.GeomNames				"domain"
#pfset TopoSlopesX.Type 				"Constant"
#pfset TopoSlopesX.Geom.domain.Value   0.001

#---------------------------------------------------------
# Topo slopes in y-direction
#---------------------------------------------------------

pfset TopoSlopesY.Type 				"PFBFile"
pfset TopoSlopesY.GeomNames 			"domain"
pfset TopoSlopesY.FileName 			slopey.pfb

#pfset TopoSlopesY.GeomNames				"domain"
#pfset TopoSlopesY.Type 				"Constant"
#pfset TopoSlopesY.Geom.domain.Value   0.001



#---------------------------------------------------------
# Mannings coefficient 
#---------------------------------------------------------

#pfset Mannings.Type 				"Constant"
pfset Mannings.Type				"PFBFile"
pfset Mannings.GeomNames 			"domain"
pfset Mannings.FileName				manningsgi2a.pfb
#pfset Mannings.Geom.domain.Value   5.00e-5
#pfset Mannings.Geom.domain.Value 0.035
#pfset Mannings.domain.Value          0.00005 this doesn't work! but above does.

#-----------------------------------------------------------------------------
# Phase sources:-------------------------------------------------- 
#-----------------------------------------------------------------------------
pfset PhaseSources.Type                   	Constant
pfset PhaseSources.GeomNames                    domain
pfset PhaseSources.Geom.domain.Value            0.0

pfset PhaseSources.water.Type                  	Constant
pfset PhaseSources.water.GeomNames             	domain
pfset PhaseSources.water.Geom.domain.Value    	0.0

#-----------------------------------------------------------------------------
# Exact solution specification for error calculations
#-----------------------------------------------------------------------------

pfset KnownSolution                       	NoKnownSolution

#-----------------------------------------------------------------------------
# Set solver parameters
#-----------------------------------------------------------------------------


pfset Solver                                	Richards
pfset Solver.MaxIter                         	2500000

pfset Solver.TerrainFollowingGrid             	True
pfset Solver.Nonlinear.MaxIter               	1000

pfset Solver.Nonlinear.ResidualTol       	 1e-4


pfset Solver.PrintSubsurf			False
pfset Solver.Drop                          	1E-20
pfset Solver.AbsTol                       	1E-10


pfset Solver.Nonlinear.EtaChoice           	EtaConstant
pfset Solver.Nonlinear.EtaValue             	0.001
pfset Solver.Nonlinear.UseJacobian          	True 
pfset Solver.Nonlinear.DerivativeEpsilon       	1e-14
pfset Solver.Nonlinear.StepTol			        1e-25
pfset Solver.Nonlinear.Globalization          	LineSearch
pfset Solver.Linear.KrylovDimension      	30
pfset Solver.Linear.MaxRestarts          	2
pfset Solver.MaxConvergenceFailures		2

pfset Solver.Nonlinear.UseJacobian              True
pfset Solver.Linear.Preconditioner           	PFMG
pfset Solver.Linear.Preconditioner.PCMatrixType	FullJacobian

#pfset Solver.Linear.Preconditioner                       MGSemi
#pfset Solver.Linear.Preconditioner.MGSemi.MaxIter        1
#pfset Solver.Linear.Preconditioner.MGSemi.MaxLevels      10

pfset Solver.LSM                            	CLM
pfset Solver.WriteSiloCLM                   	False
pfset Solver.CLM.MetForcing                	1D
pfset Solver.CLM.MetFileName               	lafa.gage.nldas2015run.txt
pfset Solver.CLM.MetFilePath                 	./

#pfset Solver.WriteSiloEvapTrans                         True
pfset Solver.WriteSiloEvapTransSum                      True
#pfset Solver.WriteSiloOverlandBCFlux                    True
pfset Solver.WriteSiloOverlandSum                       True
pfset Solver.PrintCLM                                   False
pfset Solver.CLM.ReuseCount			10
pfset Solver.CLM.BinaryOutDir			False
pfset Solver.WriteCLMBinary                 	False
pfset Solver.CLM.WriteLogs			False
pfset Solver.CLM.WriteLastRST			True
pfset Solver.CLM.DailyRST			False
pfset Solver.CLM.SingleFile			True
pfset Solver.CLM.IstepStart                     1	
#
pfset Solver.PrintSubsurf                               True
pfset Solver.PrintSubsurfData                           True
pfset Solver.WriteSiloSubsurfData 		True
pfset Solver.WriteSiloSlopes 			True
pfset Solver.WriteSiloMask 		True
pfset Solver.WriteSiloMannings          True
pfset Solver.WriteSiloSpecificStorage   True


#pfset Solver.CLM.Print1dOut			False
#pfset Solver.BinaryOutDir			False
#pfset Solver.CLM.CLMDumpInterval		500
#pfset Solver.PrintSubsurf                    	False
#pfset Solver.CLM.PrintIdOut                  	False
#pfset Solver.WriteSiloPressure	 		True
#pfset Solver.WriteSiloSaturation 		True
#pfset Solver.WriteSiloConcentration 		True
#pfset Solver.WriteSiloSlopes                            True
#pfset Solver.WriteSiloMask                              True
#pfset Solver.WriteSiloMannings                          True
#pfset Solver.WriteSiloSpecificStorage                   True
#pfset Solver.Nonlinear.PrintFlag			NoVerbosity
#---------------------------------------------------------
# Initial conditions: water pressure
#---------------------------------------------------------

# set water table to be at the bottom of the domain, the top layer is initially dry
#pfset ICPressure.Type                        	HydroStaticPatch
#pfset ICPressure.GeomNames                 	domain
#pfset Geom.domain.ICPressure.Value         	-20.0
#pfset Geom.domain.ICPressure.RefGeom         	domain
#pfset Geom.domain.ICPressure.RefPatch       	z-upper

pfset ICPressure.Type                           PFBFile
pfset ICPressure.GeomNames                      domain
pfset Geom.domain.ICPressure.FileName	        spin1.out.press.03285.pfb
pfdist 						spin1.out.press.03285.pfb

#set num_processors [expr{ [pfget Process.Topology.P] * [pfget Process.Topology.Q] * [pfget Process.Topology.R]}]

#for {set i 0} { $i <= $num_processors } {incr i} {
#        file delete drv_clmin.dat.$i
#        file copy drv_clmin.dat drv_clmin.dat.$i
#        }

#spinup key (See LW_var_dz_spinup.tcl and http://parflow.blogspot.com/2015/08/spinning-up-watershed-model.html)
# True=skim pressures, False = regular (default)
#pfset Solver.Spinup           True
#pfset Solver.Spinup           False 


#pfset OverlandFlowSpinUp			1
#pfset OverlandSpinupDampP1			1.0
#pfset OverlandSpinupDampP2			0.001

#---------------------------------------------------------
##  Distribute slopes and mannings
#---------------------------------------------------------
pfset ComputationalGrid.NZ                      1

pfdist slopey.pfb
pfdist slopex.pfb
pfdist manningsgi2a.pfb

pfset ComputationalGrid.NZ                      12


#-----------------------------------------------------------------------------
# Run ParFlow
#-----------------------------------------------------------------------------

pfdist permgi2a.pfb
pfdist indicatorgi2a.pfb

pfwritedb $runname

#-----------------------------------------------------------------------------
# Undistribute output files
#-----------------------------------------------------------------------------
#pfundist $runname
#pfundist slopex.pfb
#pfundist slopey.pfb
#pfundist mannings.pfb
#pfundist permeability-spinup.pfb
#pfundist indicator.pfb

puts "ParFlow run files written"


# The below is modifed from parflow/test/water_balance_x.tcl

