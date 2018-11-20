MATCHDIR = .

IDIR =.
SDKDIR = sdks
CXX=g++-7
CXXFLAGS=-g -Wall -MMD -std=c++17 -I$(IDIR) -I$(SDKDIR) -Werror
CXXFLAGS += -Wno-exceptions -Wfatal-errors -Wno-deprecated-declarations
LDLIBS=-lm -pthread -lssl -lcrypto -lstdc++fs

$(MATCHDIR)/%.o: %.c
	$(CXX) -c -o $@ $< $(CXXFLAGS)

_MATCHOBJ = $(patsubst %.cpp,%.o,$(wildcard $(MATCHDIR)/*.cpp))
MATCHOBJ = $(filter-out %_main.o, $(_MATCHOBJ))
MATCHMAIN = $(filter %_main.o, $(_MATCHOBJ))

all: me

release: CXXFLAGS += -O3
release: all

me: $(BASEOBJ) $(MATCHOBJ) $(MATCHMAIN)
	$(CXX) -o $(MATCHDIR)/$@ $^ $(CXXFLAGS) $(LDLIBS)

.PHONY: clean

clean:
	find . -name "*.d" | xargs rm -f
	find . -name "*.o" | xargs rm -f
	find . -executable -type f -not -name "*.s*" | xargs rm -f