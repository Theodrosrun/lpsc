BUILD := build

calc_set: $(BUILD)/calc_set.o $(BUILD)/mandelbrot.o
	$(CC) -o $(BUILD)/$@ $^ -lm

$(BUILD)/%.o: %.c | $(BUILD)
	$(CC) -c $< -o $@

$(BUILD):
	mkdir -p $(BUILD)

clean:
	rm -rf $(BUILD)

.PHONY: clean
