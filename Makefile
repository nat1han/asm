HEADERS			=		defs.h
OUT				=		task
OBJECTS			=		$(patsubst %.s, %.o, $(wildcard *.s))
ASFLAGS			= --gdwarf-2
LDFLAGS			= -static



task: task.o defs.h
	$(LD) $(LDFLAGS) -o task task.o

all: $(OBJECTS)
	$(LD) $(LDFLAGS) -o $(OUT) $(OBJECTS)

clean: 
	@rm -f *.o $(OUT)

.PHONY: clean all task
