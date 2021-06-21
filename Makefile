CC=gcc
FUNC_DIR = func
LD_PATH=lib
BUILD_DIR=output

%.o: %.c
	$(CC) -I$(FUNC_DIR) -c $< -o $(BUILD_DIR)/$@ 

$(BUILD_DIR)/func.o: $(FUNC_DIR)/func.c $(FUNC_DIR)/func.h
	$(CC) $(CFLAGS) -c $< -o $@

libfunc.a: $(BUILD_DIR)/func.o
	ar crsv $(LD_PATH)/libfunc.a $<

libfunc.so: $(BUILD_DIR)/func.o
	$(CC) $< -fPIC -shared -o $(LD_PATH)/libfunc.so


# directly use the library
# app_a: main.o libfunc.a
# 	@echo "compile app with static lib" 
# 	$(CC) main.o libfunc.a -o app_a

app_so: main.o libfunc.so
	@echo "compile app with dynamic lib" 
	$(CC) $(BUILD_DIR)/main.o $(LD_PATH)/libfunc.so -o app_so

app_a: main.o libfunc.a
	@echo "compile app with static lib" 
	$(CC) $(BUILD_DIR)/$< $(LD_PATH)/libfunc.a -o app_a
	# $(CC) -static -LLIB_PATH -lfunc $(BUILD_DIR)/$< -o app_a

# app_so: main.o libfunc.so
# 	@echo "compile app with dynamic lib" 
# 	#$(CC) $(BUILD_DIR)/main.o $(LD_PATH)/libfunc.so -o app_so
# 	$(CC) -L$(LD_PATH)/ -lfunc $(BUILD_DIR)/$< -o $@
	

.PHONY: clean
clean:
	@echo "clean trash"
	@rm -rf $(LD_PATH) $(BUILD_DIR) *.exe *.so *.a

.PHONY: build_dir
build_dir:
	@echo "creat directories for building the program"
	@mkdir $(LD_PATH) $(BUILD_DIR)

.PHONY: run
run: app_a app_so
	@echo "app with static lib"
	@./app_a.exe
	@echo "app with dynamic lib"
	@./app_so.exe

.PHONY: all
all: clean build_dir run
	@echo "clean, recomplie and run"	 
