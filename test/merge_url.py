import argparse
import sys
def main():
    parser = argparse.ArgumentParser(description='this is a test')

    #parser.add_argument('-i', '--input',help='the input path', required='True')
    parser.add_argument('-o', '--output',help='the output path', required='True')
    parser.add_argument('-l', '--length', action='store_true', help='whether display length')
    
    # Parse the command-line arguments
    args = parser.parse_args()
    process_input()

    #read_input_file(args.input)

    display_length = args.length
    output_file = args.output
    process_output(display_length, output_file)
    
 
url_dict = {}

def process_input():

    for line in sys.stdin:
        #print(f"{line.strip()}")
        url, number_str = line.strip().rsplit('[', 1)
        number = int(number_str[:-1])

        if number not in url_dict:
            url_dict[number] = url
def process_output(display, out_file):

    with open(f'{out_file}.txt', 'w') as output_file:
        for number, url in url_dict.items():
            
            if display:
                print(f'{url} [{number}]')
                output_file.write(f'{url} [{number}]\n')
            else:
                print(f'{url}')
                output_file.write(f'{url}\n')
            
if __name__ == '__main__':
    main()