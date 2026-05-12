#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <fcntl.h>
#include <termios.h>

#define MAX_STR 64

int main() {
    int master_fd;
    char slave_name[128];
    struct termios options;
    

    // 1. Create PTY
    master_fd = open("/dev/ptmx", O_RDWR | O_NOCTTY);
    if (master_fd < 0) { perror("open /dev/ptmx"); exit(1); }

    if (grantpt(master_fd) < 0) { perror("grantpt"); exit(1); }
    if (unlockpt(master_fd) < 0) { perror("unlockpt"); exit(1); }
    if (ptsname_r(master_fd, slave_name, sizeof(slave_name)) != 0) {
        perror("ptsname_r"); exit(1);
    }

    printf("\n===============================================\n");
    printf("  Use this argument for QEMU:\n\n");
    printf("      -serial %s\n", slave_name);
    printf("===============================================\n\n");

    printf("Start QEMU with that serial argument, THEN press Enter here.\n");
    getchar(); getchar();
    
    
    // 2. Set raw mode on PTY
    if (tcgetattr(master_fd, &options) < 0) {
        perror("tcgetattr"); exit(1);
    }

    cfmakeraw(&options);
    options.c_oflag &= ~OPOST;
    options.c_iflag &= ~(ICRNL | INLCR);
    options.c_lflag &= ~ECHO;

    if (tcsetattr(master_fd, TCSANOW, &options) < 0) {
        perror("tcsetattr"); exit(1);
    }
    
     // ======================================================
    char dummy_buffer[128];
    int bytes_read;
    int flags = fcntl(master_fd, F_GETFL, 0);
    usleep(500000); //
    

    fcntl(master_fd, F_SETFL, flags | O_NONBLOCK); // Non-Blocking mode
    while ((bytes_read = read(master_fd, dummy_buffer, sizeof(dummy_buffer))) > 0) {
        printf("(Ignored %d bytes of startup logs)\n", bytes_read);
    }
    fcntl(master_fd, F_SETFL, flags); //Blocking mode
    printf("PTY buffer cleared. Ready for communication.\n\n");




    // 3. Communication loop
    while (1) {
        char input[MAX_STR+1];
        char reply[128];

        printf("Please give a string to send to host: ");
        fflush(stdout);

        if (!fgets(input, MAX_STR, stdin))
            break;

        
        input[strcspn(input, "\n")] = '\0';

        // exit
        if (!strcmp(input, "q") || !strcmp(input, "Q"))
            break;

        //ignore empty line
        if (input[0] == '\0') {
            printf("(empty line ignored)\n\n");
            continue;
        }

        // SEND TO GUEST
        write(master_fd, input, strlen(input));
        write(master_fd, "\n", 1);
        

        // WAIT & READ REPLY 
        memset(reply, 0, sizeof(reply));
        int idx = 0;

        while (idx < (int)sizeof(reply) - 1) {
            int n = read(master_fd, &reply[idx], 1);
            if (n <= 0) continue;

            if (reply[idx] == '\n') {
                reply[idx] = '\0';   // replace newline
                break;
            }
            // 
            if (reply[idx] == '\r') {
                continue; 
            }

            idx++;
        }

        // DEBUG 
        
        printf("RAW reply bytes: ");
        for (int i = 0; reply[i] != '\0'; ++i)
            printf("%02X ", (unsigned char)reply[i]);
        printf("\n");
        
        
        // PRINT RESULT
        char c = reply[0];
        int count = 0;
        if (reply[2] != '\0')
            count = atoi(&reply[2]);

        if (c == '\0')
            printf("The most frequent character is <none>\n");
        else
            printf("The most frequent character is \"%c\"\n", c);

        printf("and it appeared %d times.\n\n", count);
    }

    printf("Exiting communication.\n");
    close(master_fd);
    return 0;
}

