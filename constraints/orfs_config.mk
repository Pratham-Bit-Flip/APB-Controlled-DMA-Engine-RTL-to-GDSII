export DESIGN_NAME = dma_top
export PLATFORM = sky130hd

export VERILOG_FILES = \
  $(DESIGN_HOME)/src/apb_dma/apb_master.v \
  $(DESIGN_HOME)/src/apb_dma/apb_reg.v \
  $(DESIGN_HOME)/src/apb_dma/dma_controller.v \
  $(DESIGN_HOME)/src/apb_dma/dma_datapath.v \
  $(DESIGN_HOME)/src/apb_dma/mem_interface.v \
  $(DESIGN_HOME)/src/apb_dma/dma_top.v

export SDC_FILE = $(DESIGN_HOME)/sky130hd/apb_dma/constraint.sdc

export CORE_UTILIZATION = 35
export TNS_END_PERCENT = 100
