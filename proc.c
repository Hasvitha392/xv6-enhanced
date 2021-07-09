#include "types.h"
#include "defs.h"
#include "param.h"
#include "memlayout.h"
#include "mmu.h"
#include "x86.h"
#include "proc.h"
#include "spinlock.h"

int clockperiod[5] = {1, 2, 4, 8, 16};

struct proc *queue0[64]; //1 clock tick
struct proc *queue1[64]; //2 clock ticks
struct proc *queue2[64]; //4 clock ticks
struct proc *queue3[64]; //8 clock ticks
struct proc *queue4[64]; //16 clock ticks

int c0 = -1;
int c1 = -1;
int c2 = -1;
int c3 = -1;
int c4 = -1;


struct
{
  struct spinlock lock;
  struct proc proc[NPROC];
} ptable;

static struct proc *initproc;

int nextpid = 1;
extern void forkret(void);
extern void trapret(void);

static void wakeup1(void *chan);

void pinit(void)
{
  initlock(&ptable.lock, "ptable");
}

// Must be called with interrupts disabled
int cpuid()
{
  return mycpu() - cpus;
}

// Must be called with interrupts disabled to avoid the caller being
// rescheduled between reading lapicid and running through the loop.
struct cpu *
mycpu(void)
{
  int apicid, i;

  if (readeflags() & FL_IF)
    panic("mycpu called with interrupts enabled\n");

  apicid = lapicid();
  // APIC IDs are not guaranteed to be contiguous. Maybe we should have
  // a reverse map, or reserve a register to store &cpus[i].
  for (i = 0; i < ncpu; ++i)
  {
    if (cpus[i].apicid == apicid)
      return &cpus[i];
  }
  panic("unknown apicid\n");
}

// Disable interrupts so that we are not rescheduled
// while reading proc from the cpu structure
struct proc *
myproc(void)
{
  struct cpu *c;
  struct proc *p;
  pushcli();
  c = mycpu();
  p = c->proc;
  popcli();
  return p;
}

//PAGEBREAK: 32
// Look in the process table for an UNUSED proc.
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.
static struct proc *
allocproc(void)
{
  struct proc *p;
  char *sp;

  acquire(&ptable.lock);

  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
    if (p->state == UNUSED)
      goto found;

  release(&ptable.lock);
  return 0;

found:
  p->state = EMBRYO;
  p->pid = nextpid++;
  p->current_queue = 0;
  p->ticks[0] = 0;
  p->ticks[1] = 0;
  p->ticks[2] = 0;
  p->ticks[3] = 0;
  p->ticks[4] = 0;
  // p->start = ticks;
  p->waittime = 5;

  c0++;
  queue0[c0] = p;
  release(&ptable.lock);

  // Allocate kernel stack.
  if ((p->kstack = kalloc()) == 0)
  {
    p->state = UNUSED;
    return 0;
  }
  sp = p->kstack + KSTACKSIZE;

  // Leave room for trap frame.
  sp -= sizeof *p->tf;
  p->tf = (struct trapframe *)sp;

  // Set up new context to start executing at forkret,
  // which returns to trapret.
  sp -= 4;
  *(uint *)sp = (uint)trapret;

  sp -= sizeof *p->context;
  p->context = (struct context *)sp;
  memset(p->context, 0, sizeof *p->context);
  p->context->eip = (uint)forkret;

  acquire(&ptable.lock);
  p->ctime = ticks; // TODO Might need to protect the read of ticks with a lock
  p->etime = 0;
  p->rtime = 0;
  p->iotime = 0;
  p->num_r = 0;
  release(&ptable.lock);

  if (p->pid == 1 || p->pid == 2)
    p->priority = 1;
  else
    p->priority = 60;
  return p;
}

void rem_process(int pid, int curq)
{
  if(curq==0)
  {
    for(int i=0; i<=c0; i++)
    {
      if(queue0[i]->pid==pid)
      {
        c0--;
        for (int j = i; j <= c0 ; j++)
            queue0[j] = queue0[j + 1];
       // c0--;
      }
    }
  }
  else if(curq==1)
  {
    for(int i=0; i<=c1; i++)
    {
      if(queue1[i]->pid==pid)
      {
        c1--;
        for (int j = i; j <= c1 ; j++)
            queue1[j] = queue1[j + 1];
       // c1--;
      }
    }
  }
  else if(curq==2)
  {
    for(int i=0; i<=c2; i++)
    {
      if(queue2[i]->pid==pid)
      {
        c2--;
        for (int j = i; j <= c2 ; j++)
            queue2[j] = queue2[j + 1];
       // c2--;
      }
    }
  }
  else if(curq==3)
  {
    for(int i=0; i<=c3; i++)
    {
      if(queue3[i]->pid==pid)
      {
        c3--;
        for (int j = i; j <= c3 ; j++)
            queue3[j] = queue3[j + 1];
       // c3--;
      }
    }
  }
  else if(curq==4)
  {
    for(int i=0; i<=c4; i++)
    {
      if(queue4[i]->pid==pid)
      {
        // cprintf(" %d pid=%d\n", i, pid);
        c4--;
        for (int j = i; j <= c4 ; j++)
            queue4[j] = queue4[j + 1];
        //c4--;
      }
    }
  }
}



//PAGEBREAK: 32
// Set up first user process.
void userinit(void)
{
  struct proc *p;
  extern char _binary_initcode_start[], _binary_initcode_size[];

  p = allocproc();

  initproc = p;
  if ((p->pgdir = setupkvm()) == 0)
    panic("userinit: out of memory?");
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
  p->sz = PGSIZE;
  memset(p->tf, 0, sizeof(*p->tf));
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
  p->tf->es = p->tf->ds;
  p->tf->ss = p->tf->ds;
  p->tf->eflags = FL_IF;
  p->tf->esp = PGSIZE;
  p->tf->eip = 0; // beginning of initcode.S

  safestrcpy(p->name, "initcode", sizeof(p->name));
  p->cwd = namei("/");

  // this assignment to p->state lets other cores
  // run this process. the acquire forces the above
  // writes to be visible, and the lock is also needed
  // because the assignment might not be atomic.
  acquire(&ptable.lock);

  p->state = RUNNABLE;
  p->start=ticks;

  release(&ptable.lock);
}

// Grow current process's memory by n bytes.
// Return 0 on success, -1 on failure.
int growproc(int n)
{
  uint sz;
  struct proc *curproc = myproc();

  sz = curproc->sz;
  if (n > 0)
  {
    if ((sz = allocuvm(curproc->pgdir, sz, sz + n)) == 0)
      return -1;
  }
  else if (n < 0)
  {
    if ((sz = deallocuvm(curproc->pgdir, sz, sz + n)) == 0)
      return -1;
  }
  curproc->sz = sz;
  switchuvm(curproc);
  return 0;
}

// Create a new process copying p as the parent.
// Sets up stack to return as if from system call.
// Caller must set state of returned proc to RUNNABLE.
int fork(void)
{
  int i, pid;
  struct proc *np;
  struct proc *curproc = myproc();

  // Allocate process.
  if ((np = allocproc()) == 0)
  {
    return -1;
  }

  // Copy process state from proc.
  if ((np->pgdir = copyuvm(curproc->pgdir, curproc->sz)) == 0)
  {
    kfree(np->kstack);
    np->kstack = 0;
    np->state = UNUSED;
    return -1;
  }
  np->sz = curproc->sz;
  np->parent = curproc;
  *np->tf = *curproc->tf;

  // Clear %eax so that fork returns 0 in the child.
  np->tf->eax = 0;

  for (i = 0; i < NOFILE; i++)
    if (curproc->ofile[i])
      np->ofile[i] = filedup(curproc->ofile[i]);
  np->cwd = idup(curproc->cwd);

  safestrcpy(np->name, curproc->name, sizeof(curproc->name));

  pid = np->pid;

  acquire(&ptable.lock);
  np->state = RUNNABLE;
  np->start=ticks;
  release(&ptable.lock);

  return pid;
}

// Exit the current process.  Does not return.
// An exited process remains in the zombie state
// until its parent calls wait() to find out it exited.
void exit(void)
{
  struct proc *curproc = myproc();
  struct proc *p;
  int fd;

  if (curproc == initproc)
    panic("init exiting");

  // Close all open files.
  for (fd = 0; fd < NOFILE; fd++)
  {
    if (curproc->ofile[fd])
    {
      fileclose(curproc->ofile[fd]);
      curproc->ofile[fd] = 0;
    }
  }

  begin_op();
  iput(curproc->cwd);
  end_op();
  curproc->cwd = 0;

  acquire(&ptable.lock);

  // Parent might be sleeping in wait().
  wakeup1(curproc->parent);

  // Pass abandoned children to init.
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
  {
    if (p->parent == curproc)
    {
      p->parent = initproc;
      if (p->state == ZOMBIE)
        wakeup1(initproc);
    }
  }

  // Jump into the scheduler, never to return.
  curproc->state = ZOMBIE;
  curproc->etime = ticks; // TODO Might need to protect the read of ticks with a lock
  cprintf("Total Time: %d\n", curproc->etime - curproc->ctime);
  sched();

  panic("zombie exit");
}

// Wait for a child process to exit and return its pid.
// Return -1 if this process has no children.
int wait(void)
{
  struct proc *p;
  int havekids, pid;
  struct proc *curproc = myproc();

  acquire(&ptable.lock);
  for (;;)
  {
    // Scan through table looking for exited children.
    havekids = 0;
    for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
    {
      if (p->parent != curproc)
        continue;
      havekids = 1;
      if (p->state == ZOMBIE)
      {
        // Found one.
        pid = p->pid;
        kfree(p->kstack);
        p->kstack = 0;
        freevm(p->pgdir);
        #ifdef MLFQ
        rem_process(p->pid,p->current_queue); //Removing zombie processses from the queue
        #endif
        p->pid = 0;
        p->parent = 0;
        p->name[0] = 0;
        p->killed = 0;
        p->state = UNUSED;
        release(&ptable.lock);
        return pid;
      }
    }

    // No point waiting if we don't have any children.
    if (!havekids || curproc->killed)
    {
      release(&ptable.lock);
      return -1;
    }

    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    sleep(curproc, &ptable.lock); //DOC: wait-sleep
  }
}


void ageing(void)
{
  int i=0;
  //checking queue1
  for(i=0; i<c1+1; i++)
  {
    if(queue1[i]->state!=RUNNABLE)
      continue;
    //if waittime exceeded
    if(ticks-queue1[i]->start <= queue1[i]->waittime)
    {
      continue;
    }

    //cprintf("\033[1;32m %d switching to queue 0  since waittime %ds exceeded\n\033[0m", queue1[i]->pid, queue1[i]->waittime);
    queue1[0]->waittime=0;
    queue1[i]->current_queue--;
    queue1[i]->ticks[queue1[i]->current_queue]=0;
    c0 = c0 + 1;
    queue1[i]->start=ticks;
    queue0[c0] = queue1[i];
    rem_process(queue1[i]->pid, queue1[i]->current_queue);

  }
  //checking queue2
  for(i=0; i<c2+1; i++)
  {
    if(queue2[i]->state!=RUNNABLE)
      continue;
    //if waittime exceeded
    if(ticks-queue2[i]->start <= queue2[i]->waittime)
    {
      continue;
    }

    //cprintf("\033[1;32m %d switching to queue 1  since waittime %ds exceeded\n\033[0m", queue2[i]->pid, queue2[i]->waittime);
    queue1[i]->waittime=0;
    queue2[i]->current_queue--;
    queue2[i]->ticks[queue2[i]->current_queue]=0;
    c1 = c1 + 1;
    queue2[i]->start=ticks;
    queue1[c1] = queue2[i];
    rem_process(queue2[i]->pid, queue2[i]->current_queue);

  }
  //checking queue3
  for(i=0; i<c3+1; i++)
  {
    if(queue3[i]->state!=RUNNABLE)
      continue;
    //if waittime exceeded
    if(ticks-queue3[i]->start <= queue3[i]->waittime)
    {
      continue;
    }

    //cprintf("\033[1;32m %d switching to queue 2  since waittime %ds exceeded\n\033[0m", queue3[i]->pid, queue3[i]->waittime);
    queue2[i]->waittime=0;
    queue3[i]->current_queue--;
    queue3[i]->ticks[queue3[i]->current_queue]=0;
    c2 = c2 + 1;
    queue3[i]->start=ticks;
    queue2[c2] = queue3[i];
    rem_process(queue3[i]->pid, queue3[i]->current_queue);

  }
  //checking queue4
  for(i=0; i<c4+1; i++)
  {
    if(queue4[i]->state!=RUNNABLE)
      continue;
    //if waittime exceeded
    if(ticks-queue4[i]->start <= queue4[i]->waittime)
    {
      continue;
    }

   // cprintf("\033[1;32m %d switching to queue 3  since waittime %ds exceeded\n\033[0m", queue4[i]->pid, queue4[i]->waittime);
    queue3[i]->waittime=0;
    queue4[i]->current_queue--;
    queue4[i]->ticks[queue4[i]->current_queue]=0;
    c3 = c3 + 1;
    queue4[i]->start=ticks;
    queue3[c3] = queue4[i];
    rem_process(queue4[i]->pid, queue4[i]->current_queue);

  }
}



//PAGEBREAK: 42
// Per-CPU process scheduler.
// Each CPU calls scheduler() after setting itself up.
// Scheduler never returns.  It loops, doing:
//  - choose a process to run
//  - swtch to start running that process
//  - eventually that process transfers control
//      via swtch back to the scheduler.

void scheduler(void)
{
  struct proc *p, *p2;

  struct cpu *c = mycpu();
  c->proc = 0;

  for (;;)
  {
    // Enable interrupts on this processor.
    sti();

#ifdef MLFQ
    
  //  cprintf("YES");
    acquire(&ptable.lock);
    ageing();
    struct proc *m_proc;
    int i, j;
    if (c0 != -1) // ENTERING QUEUE 0
    {
      //cprintf("YES\n");
      for (i = 0; i < c0+1; i++)
      {
        if (queue0[i]->state != RUNNABLE)
          continue;
        queue0[i]->start=ticks;
        m_proc = queue0[i];
        c->proc = m_proc;
        switchuvm(m_proc);
        m_proc->state = RUNNING;
        m_proc->num_r++;
        swtch((&c->scheduler), m_proc->context);
        switchkvm();
        c->proc = 0;

        //check if time slice expired or waittime exceeded
        if (m_proc->ticks[0] >= clockperiod[0] || m_proc->killed!=0)

        {
          //copy proc to lower priority queue
          if (m_proc->killed == 0)
          {
            c1++;
            m_proc->current_queue++;
            //cprintf("%d\n",m_proc->current_queue);
            queue1[c1] = m_proc;
          }
          //delete proc from queue0
          j=i;
          while(j<c0)
          {
            queue0[j] = queue0[j + 1];
            j++;
          }
          m_proc->ticks[0] = 0;
          c0--;
        }
      }
    }
    if (c1 != -1) //ENTERING QUEUE 1
    {
      // cprintf("entering queue1\n");
      for (i = 0; i < c1+1; i++)
      {
        if (queue1[i]->state != RUNNABLE)
          continue;
        queue1[i]->start=ticks;
        m_proc = queue1[i];
        c->proc = m_proc;
        switchuvm(m_proc);
        m_proc->state = RUNNING;
        m_proc->num_r++;
        swtch(&c->scheduler, m_proc->context);
        switchkvm();
        c->proc = 0;
        //TODO : update ticks in trap
        if (m_proc->ticks[1] >= clockperiod[1] || m_proc->killed!=0)
        {
          // copy proc to lower priority queue
          if (m_proc->killed == 0)
          {
            c2++;
            m_proc->current_queue++;
          //  cprintf("%d\n",m_proc->current_queue);
            queue2[c2] = m_proc;
          }
          //delete proc from queue1
          j=i;
          while(j<c1)
          {
            queue1[j] = queue1[j + 1];
            j++;
          }
          m_proc->ticks[1] = 0;
          c1--;
        }
      }
    }
    if (c2 != -1)
    {
      for (i = 0; i < c2+1; i++)
      {
        if (queue2[i]->state != RUNNABLE)
          continue;
        queue2[i]->start=ticks;
        m_proc = queue2[i];
        c->proc = m_proc;
        switchuvm(m_proc);
        m_proc->state = RUNNING;
        m_proc->num_r++;
        swtch(&c->scheduler, m_proc->context);
        switchkvm();
        c->proc = 0;
        //TODO : update ticks in trap
        if (m_proc->ticks[2] >= clockperiod[2]|| m_proc->killed!=0)
        {
          //  copy proc to lower priority queue
          if (m_proc->killed == 0)
          {
            c3++;
            m_proc->current_queue++;
           // cprintf("%d\n",m_proc->current_queue);
            queue3[c3] = m_proc;
          }
          //delete proc from queue2
          j=i;
          while(j<c2)
          {
            queue2[j] = queue2[j + 1];
            j++;
          }
          m_proc->ticks[2] = 0;
          c2--;
        }
      }
    }
    if (c3 != -1)
    {
      for (i = 0; i < c3+1; i++)
      {
        if (queue3[i]->state != RUNNABLE)
          continue;
        queue3[i]->start=ticks;
        m_proc = queue3[i];
        c->proc = m_proc;
        switchuvm(m_proc);
        m_proc->state = RUNNING;
        m_proc->num_r++;
        swtch(&c->scheduler, m_proc->context);
        switchkvm();
        c->proc = 0;
        //TODO : update ticks in trap
        if (m_proc->ticks[3] >= clockperiod[3] || m_proc->killed!=0)
        {

          // copy proc to lower priority queue
          if (m_proc->killed == 0)
          {
            c4++;
            m_proc->current_queue++;
            queue4[c4] = m_proc;
          }
          //delete proc from queue1
          j=i;
          while(j<c3)
          {
            queue3[j] = queue3[j + 1];
            j++;
          }
          m_proc->ticks[3] = 0;
          c3--;
        }
      }
    }
    if (c4 != -1)
    {
      for (i = 0; i < c4+1; i++)
      {
        if (queue4[i]->state != RUNNABLE)
          continue;
        queue4[i]->start=ticks;
        m_proc = queue4[i];
        c->proc = m_proc;
        switchuvm(m_proc);
        m_proc->state = RUNNING;
        m_proc->num_r++;
        swtch(&c->scheduler, m_proc->context);
        switchkvm();
        c->proc = 0;

        if(m_proc->killed!=0)
        {
          for (j = i; j <= c4 - 1; j++)
            queue4[j] = queue4[j + 1];
        }

        else if (m_proc->killed == 0)
        {
          //move process to end of its own queue 
          j=i;
          while(j<c4)
          {
            queue4[j] = queue4[j + 1];
            j++;
          }
          queue4[c4] = m_proc;
        }
      }
    }
    release(&ptable.lock);

#else
    //cprintf("YES\n");
    // Loop over process table looking for process to run.
    acquire(&ptable.lock);

    for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
    {

  #ifdef FCFS
      struct proc *min_process = p;

      if (p->state != RUNNABLE)
        continue;
      // cprintf("p->name %s p->pid %d  p->state = %d\n", p->name, p->pid, p->state);

      for (p2 = ptable.proc; p2 < &ptable.proc[NPROC]; p2++)
      {
        if (p2->pid <= 2)
          continue;
        if (p2->state != RUNNABLE)
          continue;
        if (p2->ctime < p->ctime)
          min_process = p2;
      }

      p = min_process;
  #else
  #ifdef DEFAULT
      if (p->state != RUNNABLE)
        continue;
  #else
  #ifdef PRIORITY

      struct proc *highest_priority = 0;
      struct proc *p1 = 0;

      // cprintf("p->name %s p->pid %d  p->state = %d\n", p->name, p->pid, p->state);

      if (p->state != RUNNABLE)
        continue;
      highest_priority = p;
      for (p1 = ptable.proc; p1 < &ptable.proc[NPROC]; p1++)
      {
        if ((p1->state == RUNNABLE) && (highest_priority->priority > p1->priority))
          highest_priority = p1;
      }

      p = highest_priority;



  #endif
  #endif
  #endif

      // Switch to chosen process.  It is the process's job
      // to release ptable.lock and then reacquire it
      // before jumping back to us.
      c->proc = p;
      switchuvm(p);
      p->state = RUNNING;
      p->num_r++;

      swtch(&(c->scheduler), p->context);
      switchkvm();

      // Process is done running for now.
      // It should have changed its p->state before coming back.
      c->proc = 0;
    }

    release(&ptable.lock);
#endif
  }
}

// Enter scheduler.  Must hold only ptable.lock
// and have changed proc->state. Saves and restores
// intena because intena is a property of this
// kernel thread, not this CPU. It should
// be proc->intena and proc->ncli, but that would
// break in the few places where a lock is held but
// there's no process.
void sched(void)
{
  int intena;
  struct proc *p = myproc();

  if (!holding(&ptable.lock))
    panic("sched ptable.lock");
  if (mycpu()->ncli != 1)
    panic("sched locks");
  if (p->state == RUNNING)
    panic("sched running");
  if (readeflags() & FL_IF)
    panic("sched interruptible");
  intena = mycpu()->intena;
  swtch(&p->context, mycpu()->scheduler);
  mycpu()->intena = intena;
}

// Give up the CPU for one scheduling round.
void yield(void)
{
  acquire(&ptable.lock); //DOC: yieldlock
  myproc()->state = RUNNABLE;
  myproc()->start=ticks;
  sched();
  release(&ptable.lock);
}

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void forkret(void)
{
  static int first = 1;
  // Still holding ptable.lock from scheduler.
  release(&ptable.lock);

  if (first)
  {
    // Some initialization functions must be run in the context
    // of a regular process (e.g., they call sleep), and thus cannot
    // be run from main().
    first = 0;
    iinit(ROOTDEV);
    initlog(ROOTDEV);
  }

  // Return to "caller", actually trapret (see allocproc).
}

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void sleep(void *chan, struct spinlock *lk)
{
  struct proc *p = myproc();

  if (p == 0)
    panic("sleep");

  if (lk == 0)
    panic("sleep without lk");

  // Must acquire ptable.lock in order to
  // change p->state and then call sched.
  // Once we hold ptable.lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup runs with ptable.lock locked),
  // so it's okay to release lk.
  if (lk != &ptable.lock)
  {                        //DOC: sleeplock0
    acquire(&ptable.lock); //DOC: sleeplock1
    release(lk);
  }
  // Go to sleep.
  p->chan = chan;
  p->state = SLEEPING;

  sched();

  // Tidy up.
  p->chan = 0;

  // Reacquire original lock.
  if (lk != &ptable.lock)
  { //DOC: sleeplock2
    release(&ptable.lock);
    acquire(lk);
  }
}

//PAGEBREAK!
// Wake up all processes sleeping on chan.
// The ptable lock must be held.
static void
wakeup1(void *chan)
{
  struct proc *p;

  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
    if (p->state == SLEEPING && p->chan == chan)
    {
      p->state = RUNNABLE;
      p->start=ticks;
    }
}

// Wake up all processes sleeping on chan.
void wakeup(void *chan)
{
  acquire(&ptable.lock);
  wakeup1(chan);
  release(&ptable.lock);
}

// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int kill(int pid)
{
  struct proc *p;

  acquire(&ptable.lock);
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
  {
    if (p->pid == pid)
    {
      p->killed = 1;
      // Wake process from sleep if necessary.
      if (p->state == SLEEPING)
      {
        p->start=ticks;
        p->state = RUNNABLE;
      }
      release(&ptable.lock);
      return 0;
    }
  }
  release(&ptable.lock);
  return -1;
}

//PAGEBREAK: 36
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void procdump(void)
{
  static char *states[] = {
      [UNUSED] "unused",
      [EMBRYO] "embryo",
      [SLEEPING] "sleep ",
      [RUNNABLE] "runble",
      [RUNNING] "run   ",
      [ZOMBIE] "zombie"};
  int i;
  struct proc *p;
  char *state;
  uint pc[10];

  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
  {
    if (p->state == UNUSED)
      continue;
    if (p->state >= 0 && p->state < NELEM(states) && states[p->state])
      state = states[p->state];
    else
      state = "???";
    cprintf("%d %s %s", p->pid, state, p->name);
    if (p->state == SLEEPING)
    {
      getcallerpcs((uint *)p->context->ebp + 2, pc);
      for (i = 0; i < 10 && pc[i] != 0; i++)
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
  }
}


int waitx(int *wtime, int *rtime)
{
  int havekids;
  struct proc *p;
  int pid;
  struct proc *curproc = myproc();

  acquire(&ptable.lock);
  havekids = 0;
  for (;;)
  {
    // Scan through table looking for zombie children.
    havekids = 0;
    for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
    {
      if (p->parent != curproc)
        continue;
      if(p->parent == curproc)
      {
        havekids = 1;
        if (p->state == ZOMBIE)
        {
          // Found one.

          // Added time field update, else same from wait system call
          *wtime = p->etime - p->ctime - p->rtime - p->iotime;
          cprintf("\netime %d  ctime %d    rtime %d    iotime %d \n", p->etime, p->ctime, p->rtime, p->iotime);
          *rtime = p->rtime;

          pid = p->pid;
          kfree(p->kstack);
          p->kstack = 0;
          freevm(p->pgdir);
          // rem_process(p->pid,p->current_queue);
          p->state = UNUSED;
          p->pid = 0;
          p->parent = 0;
          p->name[0] = 0;
          p->killed = 0;
          release(&ptable.lock);
          return pid;
        }
      }
    }

    if (!(!havekids || curproc->killed))
    {
      sleep(curproc, &ptable.lock); //DOC: wait-sleep
      continue;
    }
    // No point waiting if we don't have any children.
    release(&ptable.lock);
    return -1;

  }
}

int cps()
{
  struct proc *p;
  sti();
  #ifdef MLFQ
  cprintf("PID Priority   State   rtime wtime n_run curr_q q0 q1 q2 q3 q4 \n");
  #else
  cprintf("PID Priority   State   rtime wtime \n");
  #endif
  acquire(&ptable.lock);
  for(p=ptable.proc;p<&ptable.proc[NPROC]; p++){
  //  p->waittime = p->rtime - p->etime;
    #ifdef MLFQ
    if(p->state == 3)
    {
      cprintf("%d   %d        RUNNABLE    %d     %d     %d     %d    %d  %d  %d  %d  %d\n",p->pid,p->priority,p->rtime,p->waittime,p->num_r,p->current_queue, p->ticks[0],p->ticks[1],p->ticks[2],p->ticks[3],p->ticks[4]);
      continue;
    }
    else if(p->state == 2)
    {
      cprintf("%d   %d        SLEEPING   %d     %d     %d     %d    %d  %d  %d  %d  %d\n",p->pid,p->priority,p->rtime,p->waittime,p->num_r,p->current_queue,p->ticks[0],p->ticks[1],p->ticks[2],p->ticks[3],p->ticks[4] );
      continue;
    }
    else if(p->state == 4)
    {
      cprintf("%d   %d        RUNNING   %d     %d      %d     %d    %d  %d  %d  %d  %d\n",p->pid,p->priority,p->rtime,p->waittime,p->num_r,p->current_queue, p->ticks[0],p->ticks[1],p->ticks[2],p->ticks[3],p->ticks[4]);
      continue;
    }
    #else
    if(p->state == 4)
    {
      cprintf("%d   %d        RUNNING    %d   %d\n",p->pid,p->priority,p->rtime,p->waittime);
      continue;
    }
    if(p->state == 2)
    {
      cprintf("%d   %d        SLEEPING    %d   %d\n",p->pid,p->priority,p->rtime,p->waittime);
      continue;
    }
    if(p->state == ZOMBIE)
    {
      cprintf("%d   %d        ZOMBIE    %d     %d\n",p->pid,p->priority,p->rtime,p->waittime);
      continue;
    }
    if(p->state == EMBRYO)
    {
      cprintf("%d             EMBRYO\n",p->pid);
    }

    #endif
  }
  release(&ptable.lock);
  return 22;

}

int chpr(int pid, int priority)
{
	struct proc *p;
	acquire(&ptable.lock);
	for(p=ptable.proc;p<&ptable.proc[NPROC];p++){
		if(p->pid == pid){
			p->priority=priority;
			break;
		}
	}
	release(&ptable.lock);
	return pid;
}

int setPriority(int priority, int pid)
{
  struct proc *p;

  //interrupt enabler
  sti();

  //looping over all processes
  int new_priority=priority;
  int flag = 0;
  if(new_priority<0 || new_priority >100)
    return -2;
  acquire(&ptable.lock);
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
  {
    if (p->pid == pid)
    {
      p->priority = new_priority;
      flag = 1;
      break;
    }
  }
  release(&ptable.lock);

  if (flag != 0)
    return 24;
  else
    return -1;
}
