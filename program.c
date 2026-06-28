#include <stdio.h>
#include <stdlib.h>

// == Global data =============================================================

#define W  * 4
#define KB * 1024
#define MB KB KB

#define DATA_SZ   1 MB
#define HEAP_SZ   1 MB
#define STACK_SZ  1 MB

#define MEM_SZ ((DATA_SZ) + (HEAP_SZ) + (STACK_SZ))

union {
  long mem[0];
  struct {
    long m_foo;
    long a_0001;
    long a_0002;
  } named;
  struct {
    long z_data[DATA_SZ];
    long z_heap[HEAP_SZ];
    long z_stack[STACK_SZ];
  } zone;
} global;

#define M      global.mem
#define DATA   global.zone.z_data
#define HEAP   global.zone.z_heap
#define STACK  global.zone.z_stack

long SP = MEM_SZ;
long FP = 0;
long SR;
void *PC;				// (unused)

// -- Names for global variables ----------------------------------------------

#define GV_foo ((long *) &global.named.m_foo - (long *) &global.named)

// == Program =================================================================

int main (int argc, char *argv[])
{
  long i;

// -- Initialization ----------------------------------------------------------
  global.named.m_foo = 10;
  global.named.a_0001 = 20;
  global.named.a_0002 = 30;

// -- Library -----------------------------------------------------------------

	goto lib_init;			// skip library code!

print_int:				// print_int (int) -> ()
	printf ("%ld\n", M[SP+1]);
	goto * ((void *) M[SP++]);

print_char:				// print_char (int) -> ()
	putchar (M[SP+1]);
	goto * ((void *) M[SP++]);

read_int:				// read_int () -> int
	scanf ("%ld", &M[SP+1]);
	goto * ((void *) M[SP++]);

read_char:				// read_char () -> int
	M[SP+1] = getchar ();
	goto * ((void *) M[SP++]);

halt:					// halt () -> ()
	return 0;

dump_regs:				// dump_regs () -> ()
	{
	  printf ("-- Register dump --\n");
	  printf ("SP = 0x%lx (%ld)\n", (long) SP, (long) SP);
	  printf ("FP = 0x%lx (%ld)\n", (long) FP, (long) FP);
	  printf ("SR = 0x%lx (%ld)\n", (long) SR, (long) SR);
	  printf ("PC = (unused)\n");
	}
	goto * ((void *) M[SP++]);

dump_stack:				// dump_stack () -> ()
	{
	  printf ("-- Stack dump --\n");
	}
	goto * ((void *) M[SP++]);

stack_trace:				// stack_trace () -> ()
	{
	  printf ("-- Stack trace --\n");
	}
	goto * ((void *) M[SP++]);

lib_init:
	{
	  // (declarations for function ) (print_int);
	  // (declarations for function ) (print_char);
	  // (declarations for function ) (read_int);
	  // (declarations for function ) (read_char);
	  // (declarations for function ) (halt);
	  // (declarations for function ) (dump_regs);
	  // (declarations for function ) (dump_stack);
	  // (declarations for function ) (stack_trace);
	}

// -- Start execution ---------------------------------------------------------
  M[--SP] = (long) &&L_exit_program; // Save return address for main program
  goto program;			// start kicking...
L_exit_program:			// Return here, and...
  exit (0);			// quit.
  

// -- Instructions ------------------------------------------------------------
program: 
	M[--SP] = 3;	// PUSH 3
	M[--SP] = 0;	// PUSH 0
	M[M[SP]] = M[SP+1]; SP += 2;	// STORE 
	M[--SP] = 0;	// PUSH 0
	M[SP] = M[M[SP]];		// LOAD 
	M[--SP] = 6;	// PUSH 6
	M[SP+1] = M[SP+1] + M[SP+0]; ++SP; // ADD
	M[--SP] = (long) &&print_int;	// PUSH print_int
	{ void *C = (void *) M[SP]; M[SP]=(long)&&P_10; goto *C; } // CALL
P_10:	++SP;				// POP
	goto * ((void *) M[SP++]);		// JUMP

}

