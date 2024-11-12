
#include <stdio.h>
#include <string.h>
#include <signal.h>
#include <stdlib.h>
#include <stdint.h>
#include <stdbool.h>
#include <sys/mman.h>  // for map
#include <fcntl.h> // for file open flags
#include <unistd.h> // for getting the page size

bool terminateFlag = false;

void usage()
{
    fprintf(stderr, "input arguments: -h, -v, -f <filename>, -p <time-value pairs> \n");
    fprintf(stderr, "Cannot have both -f and -p values toggled.\n");
    fprintf(stderr, "for help: -h.\n\n");
}

void terminate_handler(){
    //code for turing off hps_control mode
    printf("\nTerminating program and de-asserting hps_control mode\n");
    terminateFlag = true;
}

int main(int argc, char **argv)
{

 signal(SIGINT, terminate_handler);
 // This is the size of a page of memory in the system. Typically 4096 bytes.
 int numPatterns = 0;
 char patterns[100][50];
 int times[100];
 int count = 0;
 char fileName[60];
 bool pFlag = false;
 bool fFlag = false;
 bool vFlag = false;
 bool hFlag = false;

 const size_t PAGE_SIZE = sysconf(_SC_PAGE_SIZE);

 if (argc == 1)
 {
 // No arguments were given, so print the usage text and exit;
 // NOTE: The first argument is actually the program name, so argv[0]
 // is the program name, argv[1] is the first *real* argument, etc.
  usage();
  return 1;
 }
// If the VALUE argument was given, we'll perform a write operation.
 //bool is_write = (argc == 3) ? true : false;

 //const uint32_t ADDRESS = strtoul(argv[1], NULL, 0);
 //printf("%s\n", argv[1]);

 //create an array to hold the arguemnts
  
 for (int  i = 1; i < argc; i++){
    if(strcmp(argv[i], "-h") == 0){
        hFlag = true;
    }
    else if(strcmp(argv[i], "-v") == 0){
        vFlag = true;
    }
    else if(strcmp(argv[i], "-p") == 0){
        pFlag = true;
        for (int o = i + 1; o < argc; ++o){
            numPatterns++;
        }
    }
    else if(strcmp(argv[i], "-f") == 0){
        fFlag = true;
        strcpy(fileName, argv[i + 1]);

    }
 }

 if (fFlag == true && pFlag == true){
    printf("ERROR\nCannot have f and p flags triggered at the same time.\n");
    usage();
    return EXIT_FAILURE;
 }

 if (hFlag == true){
    usage();
 }

//  if (hFlag == false && pFlag == false && vFlag == false && hFlag == false){
//     usage();
//     exit(0);
//  }

//Declare and copy over the pattern values outside of the inital for
 char **patternsValues = malloc(numPatterns * sizeof(char *));
 int counter = 0;
 int t = 0;
 for (int i = 1; i < argc; ++i){
     
    if(strcmp(argv[i], "-p") == 0){
         
        for (int o = 0; o < numPatterns; ++o){
            patternsValues[o] = malloc(100 * sizeof(char));
        }
        counter = 0;

        for (int o = i + 1; o < argc; ++o){
            strcpy(patternsValues[counter], argv[o]);
            ++counter;
           
        }

    }
 }

if (fFlag == true){
    FILE *file = fopen(fileName, "r");
    if(file == NULL){
        perror("Error opening file");
        return EXIT_FAILURE;
    }

    while(fscanf(file, "%s %d", patterns[count], &times[count]) == 2){
        ++count;

        if (count >= 100){
            fprintf(stderr, "Reached maximum number of patterns (100). \n");
            break;
        }
    }

    fclose(file);

    //printf("fFlag:%d, pFlag:%d", fFlag, pFlag);

    // for (int i = 0; i < count; ++i){
    //     printf("Pattern: %s, Time: %d\n", patterns[i], times[i]);
    // }
}

if (vFlag == true && pFlag == true){
    for (int i = 0; i < numPatterns; ++i) {

        if (i == 0 || i % 2 == 0){
            int hexValue = (int)strtol(patternsValues[i], NULL, 16);
            printf("LED pattern = ");
            for(int o = 7; o >= 0; --o){
                printf("%d", (hexValue >> o)&1);
            }
        }
        else{
            printf(" Display time = %s msec\n", patternsValues[i]);
        }
    }
}
else if(vFlag == true && fFlag == true){
    for (int i = 0; i < count; ++ i){
        int hexValue = (int)strtol(patterns[i], NULL, 16);
        printf("LED pattern = ");
        for(int o = 7; o >= 0; --o){
            printf("%d", (hexValue >> o)&1);
        }
        printf(" Display time = %d msec\n", times[i]);

    }
}
 //Read from the given file

    // for (int i = 0; i < numPatterns;++i){
    //     printf("\npatternsValues[%d] = %s\n", i, patternsValues[i]);
    // }

 const uint32_t hps_controll = 0XFF200000;
 const uint32_t ADDRESS = 0XFF200008;
 //printf("%x\n", ADDRESS);

 //address for the led register (register 2) is 0XFF200008
 //address for the hps_control register (register 0) is 0XFF200000


 // Open the /dev/mem file, which is an image of the main system memory.
 // We use synchronous write operations (O_SYNC) to ensure that the value
 // is fully written to the underlying hardware before the write call returns.
 int fd = open("/dev/mem", O_RDWR | O_SYNC);
 if (fd == -1)
 {
    fprintf(stderr, "failed to open /dev/mem.\n");
    return 1;
 }
 // mmap needs to map memory at page boundaries; that is, the address we are
 // mapping needs to be page-aligned. The ~(PAGE_SIZE - 1) bitmask returns
 // the closest page-aligned address that contains ADDRESS in the page.
 // For a page size of 4096 bytes, (PAGE_SIZE - 1) = 0xFFF; extending this
 // to 32-bits and flipping the bits results in a mask of 0xFFFF_F000.
 // AND'ing with this bitmask forces the last 3 nibbles of ADDRESS to be 0,
 // which ensures that the returned address is a multiple of the page size
 // (4096 = 0x1000, so indeed, any address that is a multiple of 4096 will
 // have the last 3 nibbles equal to 0).
 uint32_t hps_control_paa = hps_controll & ~(PAGE_SIZE - 1);
 uint32_t page_aligned_addr = ADDRESS & ~(PAGE_SIZE - 1);
//  printf("memory addresses:\n");
//  printf("-------------------------------------------------------------------\n");
//  printf("page aligned address = 0x%x\n", page_aligned_addr);
//  printf("page aligned address = 0x%x\n", hps_control_paa);

 // Map a page of physical memory into virtual memory. See the mmap man page
 // for more info: https://www.man7.org/linux/man-pages/man2/mmap.2.html.
  uint32_t *page_virtual_addr_hps = (uint32_t *)mmap(NULL, PAGE_SIZE,
 PROT_READ | PROT_WRITE, MAP_SHARED, fd, hps_control_paa);
  if (page_virtual_addr_hps == MAP_FAILED)
 {
//  fprintf(stderr, "failed to map hps memory.\n");
 return 1;
 }
//  printf("page_virtual_addr_hps = %p\n", page_virtual_addr_hps);
 uint32_t *page_virtual_addr = (uint32_t *)mmap(NULL, PAGE_SIZE,
 PROT_READ | PROT_WRITE, MAP_SHARED, fd, page_aligned_addr);
 if (page_virtual_addr == MAP_FAILED)
 {
//  fprintf(stderr, "failed to map memory.\n");
 return 1;
 }
//  printf("page_virtual_addr = %p\n", page_virtual_addr);

 // The address we want to access might not be page-aligned. Since we mapped
 // a page-aligned address, we need our target address' offset from the
 // page boundary. Using this offset, we can compute the virtual address
 // corresponding to our physical target address (ADDRESS).
 uint32_t offset_in_page_hps = hps_controll & (PAGE_SIZE - 1);
 uint32_t offset_in_page = ADDRESS & (PAGE_SIZE - 1);
//  printf("offset in page = 0x%x\n", offset_in_page);
 // Compute the virtual address corresponding to ADDRESS. Because
 // page_virtual_addr and target_virtual_addr are both uint32_t pointers,
 // pointer addition multiplies the pointer address by the number of bytes
 // needed to store a uint32_t (4 bytes); e.g., 0x10 + 4 = 0x20, not 0x14.
 // Consequently, we need to divide offset_in_page by 4 bytes to make the
 // pointer addition return our desired address (0x14 in the example).
 // We use volatile because the value at target_virtual_addr could change
 // outside of our program; the address refers to memory-mapped I/O
 // that could be changed by hardware. volatile tells the compiler to
 // not optimize accesses to this memory address.
 volatile uint32_t *target_virtual_addr_hps = page_virtual_addr_hps + offset_in_page_hps/sizeof(uint32_t*);
//  printf("target_virtual_addr_hps = %p\n", target_virtual_addr_hps);
//  printf("-------------------------------------------------------------------\n");
 volatile uint32_t *target_virtual_addr = page_virtual_addr + offset_in_page/sizeof(uint32_t*);
//  printf("target_virtual_addr = %p\n", target_virtual_addr);
//  printf("-------------------------------------------------------------------\n");

 if (pFlag == true || fFlag == true){
    uint32_t value = strtoul("0x01", NULL, 0);
    *target_virtual_addr_hps = value;
    // const uint32_t LED_VALUE =  strtoul("0x0F", NULL, 0);
    // *target_virtual_addr = LED_VALUE;

    while(terminateFlag == false){
        if(pFlag == true){
            for (int i = 0; i < numPatterns; ++i) {

                if (i == 0 || i % 2 == 0){
                    uint32_t led_value = strtoul(patternsValues[i], NULL, 16);
                    *target_virtual_addr = led_value;
                }
                else{
                    usleep(atoi(patternsValues[i]) * 1000);
                    uint32_t led_value = strtoul("0x0", NULL, 16);
                    *target_virtual_addr = led_value;
                    usleep(atoi(patternsValues[i]) * 1000);
                }

                if(i == numPatterns){
                    i = 0;
                }
            }
        }
        else if(fFlag == true){
            for (int i = 0; i < count; ++ i){
                    uint32_t led_value = strtoul(patterns[i], NULL, 16);
                    *target_virtual_addr = led_value;

                    usleep(times[i] * 1000);

                    led_value = strtoul("0x0", NULL, 16);
                    *target_virtual_addr = led_value;

                    usleep(times[i] * 1000);
            }
        }
    }
    value = strtoul("0x0", NULL, 0);
    *target_virtual_addr_hps = value;
    exit(0);
 }
 else{
    printf("\nvalue at 0x%x = 0x%x\n", hps_controll, *target_virtual_addr_hps);
 }

//   printf("target_virtual_addr = %p\n", target_virtual_addr);
//  printf("-------------------------------------------------------------------\n");


//Memory management stuff here:
 for (int i = 0; i < numPatterns; ++i){
    free((void *)patternsValues[i]);
 }
 free(patternsValues);

 return 0;
 }