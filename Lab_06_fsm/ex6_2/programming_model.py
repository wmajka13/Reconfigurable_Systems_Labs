
INPUT_PATH = "/home/wiktor-majka/Documents/SR_project1/training_data/16byte_data_to_send_python.txt"
OUTPUT_PATH = "/home/wiktor-majka/Documents/SR_project1/training_data/16byte_data_save_python.txt"

with open(INPUT_PATH, 'r') as file_in, open(OUTPUT_PATH, 'w') as file_out:
    
    text = file_in.read()
    
    for char in text:
        
        ascii_val = ord(char)
        bin_str = format(ascii_val, '08b')
        reversed_bin =  bin_str[::-1]
        frame = "00" + "1" + reversed_bin + "0"
        file_out.write(frame)

