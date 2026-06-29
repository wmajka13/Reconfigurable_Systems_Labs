def find_command(line):
    for i, letter in enumerate(line):
        if letter == " ":
            break
    return line[0:i]

def parse_line(line):
    commnad = find_command(line)
    
    match commnad:
        # nop -> 0x0000_0000
        case "nop":
            code = "0x00000000"
            
        # mov Rd, Rx -> 0x001{rx}_6{rd}00
        case "mov":
            code = "0x001" + line[7] + "6" + line[4] + "00"
        
        # movi Rd, imm -> 0x0016_8{rd}{imm}
        case "movi":
            code = "0x00168" + line[5] + line[-3:-1]
        
       # jump Rx -> 0x0130_{rx}600        
        case "jump":
            code = "0x0130" + line[5] + "600"
        
        # jumpi imm -> 0x01300_86{imm}
        case "jumpi":
            code = "0x013086" + line[-3:-1]
        
        # jz Rx, imm -> 0x023{rx}_86{imm}
        case "jz":
            code = "0x023" + line[3] + "86" + line[-3:-1]
        
        # jnz Rx, imm -> 0x033{rx}_86{imm}
        case "jnz":
            code = "0x033" + line[4] + "86" + line[-3:-1]
        
        # add Rd, Rx, Ry -> 0x001{rx}_{ry}{rd}00
        case "add":
            code = "0x001" + line[7] + line[10] + line[4] + "00"

        # addi Rd, Rx, imm -> 0x001{rx}_8{rd}{imm}
        case "addi":
            code = "0x001" + line[8] + "8" + line[5] + line[-3:-1]
            
        # and Rd, Rx, Ry -> 0x000{rx}_{ry}{rd}00
        case "and":
            code = "0x000" + line[7] + line[10] + line[4] + "00"

        # andi Rd, Rx, imm -> 0x000{rx}_8{rd}{imm}
        case "andi":
            code = "0x000" + line[8] + "8" + line[5] + line[-3:-1]

        # load Rd, Rx -> 0x0030_{rx}{1,rd}00        
        case "load":
            # Rd_op + D_op            
            rd_part = str(hex(8 + int(line[5])))[2:]   # TUTAJ MUSIMY zamienić {1,rd} (binarnie) na jedną cyfrę w hexie
            code = "0x0030" + line[8] + rd_part + "00"

        # loadi Rd, imm -> 0x0030_8{1,rd}{imm}         
        case "loadi":
            rd_part = str(hex(8 + int(line[6])))[2:]   # TUTAJ MUSIMY zamienić {1,rd} (binarnie) na jedną cyfrę w hexie
            code = "0x00308" + rd_part + line[-3:-1]
            
        case _:
            print("ERROR")
            return -1
    
    print(commnad)
    return code


def read_file_and_parse(file_asm, parsed_file):
    
    parsed_lines = []
    
    with open(file_asm, "r") as plik_asm:
        lines = plik_asm.readlines()

    for line in lines:
        parsed_lines.append( (parse_line(line)) + "\n" ) 

    with open(parsed_file, "w") as plik_parsed:
        plik_parsed.writelines(parsed_lines)

    return 1


def main():
    
    # SET CORRECT PATH
    path = "/home/wiktor-majka/Documents/Vivado_projects/SR_procesor_GPIO/SR_procesor_GPIO.srcs/sources_1/new/"
    
    read_file_and_parse(path + "program14_2.asm", path + "program14_2.mc")    
    
main()

