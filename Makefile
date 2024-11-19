CC=gcc
CFLAGS= -g  
LIBDIR=-L/usr/local/lib
LIBS=
INCLUDE=-I.  -I/usr/local/include 
DEPS = 
OBJS = 

BIN=./bin
SRC=./src
BUILDDIR=./build

TARGET1=read_dpmu_log_w_address
TARGET2=read_dpmu_log_wo_address
TARGET3=read_dpmu_log_functional_tests

.c.o:
	$(CC) -c  $(CFLAGS) $(INCLUDE) $(LIBDIR) $(LIBS) $<

all: $(TARGET1) $(TARGET2) $(TARGET3)
 

$(TARGET1): $(OBJS)
	$(CC) -o $(BIN)/$@ $(SRC)/$@.c $(CFLAGS) $(INCLUDE) $(LIBDIR) $(LIBS)

$(TARGET2): $(OBJS)
	$(CC) -o $(BIN)/$@ $(SRC)/$@.c $(CFLAGS) $(INCLUDE) $(LIBDIR) $(LIBS)

$(TARGET3): $(OBJS)
	$(CC) -o $(BIN)/$@ $(SRC)/$@.c $(CFLAGS) $(INCLUDE) $(LIBDIR) $(LIBS)


clean:
	rm -rf $(BUILDDIR)/*.o