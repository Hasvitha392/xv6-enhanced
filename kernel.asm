
kernel:     file format elf32-i386


Disassembly of section .text:

80100000 <multiboot_header>:
80100000:	02 b0 ad 1b 00 00    	add    0x1bad(%eax),%dh
80100006:	00 00                	add    %al,(%eax)
80100008:	fe 4f 52             	decb   0x52(%edi)
8010000b:	e4                   	.byte 0xe4

8010000c <entry>:

# Entering xv6 on boot processor, with paging off.
.globl entry
entry:
  # Turn on page size extension for 4Mbyte pages
  movl    %cr4, %eax
8010000c:	0f 20 e0             	mov    %cr4,%eax
  orl     $(CR4_PSE), %eax
8010000f:	83 c8 10             	or     $0x10,%eax
  movl    %eax, %cr4
80100012:	0f 22 e0             	mov    %eax,%cr4
  # Set page directory
  movl    $(V2P_WO(entrypgdir)), %eax
80100015:	b8 00 a0 10 00       	mov    $0x10a000,%eax
  movl    %eax, %cr3
8010001a:	0f 22 d8             	mov    %eax,%cr3
  # Turn on paging.
  movl    %cr0, %eax
8010001d:	0f 20 c0             	mov    %cr0,%eax
  orl     $(CR0_PG|CR0_WP), %eax
80100020:	0d 00 00 01 80       	or     $0x80010000,%eax
  movl    %eax, %cr0
80100025:	0f 22 c0             	mov    %eax,%cr0

  # Set up the stack pointer.
  movl $(stack + KSTACKSIZE), %esp
80100028:	bc e0 c5 10 80       	mov    $0x8010c5e0,%esp

  # Jump to main(), and switch to executing at
  # high addresses. The indirect call is needed because
  # the assembler produces a PC-relative instruction
  # for a direct jump.
  mov $main, %eax
8010002d:	b8 a0 2e 10 80       	mov    $0x80102ea0,%eax
  jmp *%eax
80100032:	ff e0                	jmp    *%eax
80100034:	66 90                	xchg   %ax,%ax
80100036:	66 90                	xchg   %ax,%ax
80100038:	66 90                	xchg   %ax,%ax
8010003a:	66 90                	xchg   %ax,%ax
8010003c:	66 90                	xchg   %ax,%ax
8010003e:	66 90                	xchg   %ax,%ax

80100040 <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
80100040:	55                   	push   %ebp
80100041:	89 e5                	mov    %esp,%ebp
80100043:	53                   	push   %ebx

//PAGEBREAK!
  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
  bcache.head.next = &bcache.head;
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
80100044:	bb 14 c6 10 80       	mov    $0x8010c614,%ebx
{
80100049:	83 ec 0c             	sub    $0xc,%esp
  initlock(&bcache.lock, "bcache");
8010004c:	68 00 80 10 80       	push   $0x80108000
80100051:	68 e0 c5 10 80       	push   $0x8010c5e0
80100056:	e8 65 51 00 00       	call   801051c0 <initlock>
  bcache.head.prev = &bcache.head;
8010005b:	c7 05 2c 0d 11 80 dc 	movl   $0x80110cdc,0x80110d2c
80100062:	0c 11 80 
  bcache.head.next = &bcache.head;
80100065:	c7 05 30 0d 11 80 dc 	movl   $0x80110cdc,0x80110d30
8010006c:	0c 11 80 
8010006f:	83 c4 10             	add    $0x10,%esp
80100072:	ba dc 0c 11 80       	mov    $0x80110cdc,%edx
80100077:	eb 09                	jmp    80100082 <binit+0x42>
80100079:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100080:	89 c3                	mov    %eax,%ebx
    b->next = bcache.head.next;
    b->prev = &bcache.head;
    initsleeplock(&b->lock, "buffer");
80100082:	8d 43 0c             	lea    0xc(%ebx),%eax
80100085:	83 ec 08             	sub    $0x8,%esp
    b->next = bcache.head.next;
80100088:	89 53 54             	mov    %edx,0x54(%ebx)
    b->prev = &bcache.head;
8010008b:	c7 43 50 dc 0c 11 80 	movl   $0x80110cdc,0x50(%ebx)
    initsleeplock(&b->lock, "buffer");
80100092:	68 07 80 10 80       	push   $0x80108007
80100097:	50                   	push   %eax
80100098:	e8 f3 4f 00 00       	call   80105090 <initsleeplock>
    bcache.head.next->prev = b;
8010009d:	a1 30 0d 11 80       	mov    0x80110d30,%eax
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000a2:	83 c4 10             	add    $0x10,%esp
801000a5:	89 da                	mov    %ebx,%edx
    bcache.head.next->prev = b;
801000a7:	89 58 50             	mov    %ebx,0x50(%eax)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000aa:	8d 83 5c 02 00 00    	lea    0x25c(%ebx),%eax
    bcache.head.next = b;
801000b0:	89 1d 30 0d 11 80    	mov    %ebx,0x80110d30
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000b6:	3d dc 0c 11 80       	cmp    $0x80110cdc,%eax
801000bb:	72 c3                	jb     80100080 <binit+0x40>
  }
}
801000bd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801000c0:	c9                   	leave  
801000c1:	c3                   	ret    
801000c2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801000c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801000d0 <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
801000d0:	55                   	push   %ebp
801000d1:	89 e5                	mov    %esp,%ebp
801000d3:	57                   	push   %edi
801000d4:	56                   	push   %esi
801000d5:	53                   	push   %ebx
801000d6:	83 ec 18             	sub    $0x18,%esp
801000d9:	8b 75 08             	mov    0x8(%ebp),%esi
801000dc:	8b 7d 0c             	mov    0xc(%ebp),%edi
  acquire(&bcache.lock);
801000df:	68 e0 c5 10 80       	push   $0x8010c5e0
801000e4:	e8 17 52 00 00       	call   80105300 <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
801000e9:	8b 1d 30 0d 11 80    	mov    0x80110d30,%ebx
801000ef:	83 c4 10             	add    $0x10,%esp
801000f2:	81 fb dc 0c 11 80    	cmp    $0x80110cdc,%ebx
801000f8:	75 11                	jne    8010010b <bread+0x3b>
801000fa:	eb 24                	jmp    80100120 <bread+0x50>
801000fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100100:	8b 5b 54             	mov    0x54(%ebx),%ebx
80100103:	81 fb dc 0c 11 80    	cmp    $0x80110cdc,%ebx
80100109:	74 15                	je     80100120 <bread+0x50>
    if(b->dev == dev && b->blockno == blockno){
8010010b:	3b 73 04             	cmp    0x4(%ebx),%esi
8010010e:	75 f0                	jne    80100100 <bread+0x30>
80100110:	3b 7b 08             	cmp    0x8(%ebx),%edi
80100113:	75 eb                	jne    80100100 <bread+0x30>
      b->refcnt++;
80100115:	83 43 4c 01          	addl   $0x1,0x4c(%ebx)
80100119:	eb 3f                	jmp    8010015a <bread+0x8a>
8010011b:	90                   	nop
8010011c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
80100120:	8b 1d 2c 0d 11 80    	mov    0x80110d2c,%ebx
80100126:	81 fb dc 0c 11 80    	cmp    $0x80110cdc,%ebx
8010012c:	75 0d                	jne    8010013b <bread+0x6b>
8010012e:	eb 60                	jmp    80100190 <bread+0xc0>
80100130:	8b 5b 50             	mov    0x50(%ebx),%ebx
80100133:	81 fb dc 0c 11 80    	cmp    $0x80110cdc,%ebx
80100139:	74 55                	je     80100190 <bread+0xc0>
    if(b->refcnt == 0 && (b->flags & B_DIRTY) == 0) {
8010013b:	8b 43 4c             	mov    0x4c(%ebx),%eax
8010013e:	85 c0                	test   %eax,%eax
80100140:	75 ee                	jne    80100130 <bread+0x60>
80100142:	f6 03 04             	testb  $0x4,(%ebx)
80100145:	75 e9                	jne    80100130 <bread+0x60>
      b->dev = dev;
80100147:	89 73 04             	mov    %esi,0x4(%ebx)
      b->blockno = blockno;
8010014a:	89 7b 08             	mov    %edi,0x8(%ebx)
      b->flags = 0;
8010014d:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
      b->refcnt = 1;
80100153:	c7 43 4c 01 00 00 00 	movl   $0x1,0x4c(%ebx)
      release(&bcache.lock);
8010015a:	83 ec 0c             	sub    $0xc,%esp
8010015d:	68 e0 c5 10 80       	push   $0x8010c5e0
80100162:	e8 59 52 00 00       	call   801053c0 <release>
      acquiresleep(&b->lock);
80100167:	8d 43 0c             	lea    0xc(%ebx),%eax
8010016a:	89 04 24             	mov    %eax,(%esp)
8010016d:	e8 5e 4f 00 00       	call   801050d0 <acquiresleep>
80100172:	83 c4 10             	add    $0x10,%esp
  struct buf *b;

  b = bget(dev, blockno);
  if((b->flags & B_VALID) == 0) {
80100175:	f6 03 02             	testb  $0x2,(%ebx)
80100178:	75 0c                	jne    80100186 <bread+0xb6>
    iderw(b);
8010017a:	83 ec 0c             	sub    $0xc,%esp
8010017d:	53                   	push   %ebx
8010017e:	e8 9d 1f 00 00       	call   80102120 <iderw>
80100183:	83 c4 10             	add    $0x10,%esp
  }
  return b;
}
80100186:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100189:	89 d8                	mov    %ebx,%eax
8010018b:	5b                   	pop    %ebx
8010018c:	5e                   	pop    %esi
8010018d:	5f                   	pop    %edi
8010018e:	5d                   	pop    %ebp
8010018f:	c3                   	ret    
  panic("bget: no buffers");
80100190:	83 ec 0c             	sub    $0xc,%esp
80100193:	68 0e 80 10 80       	push   $0x8010800e
80100198:	e8 f3 01 00 00       	call   80100390 <panic>
8010019d:	8d 76 00             	lea    0x0(%esi),%esi

801001a0 <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
801001a0:	55                   	push   %ebp
801001a1:	89 e5                	mov    %esp,%ebp
801001a3:	53                   	push   %ebx
801001a4:	83 ec 10             	sub    $0x10,%esp
801001a7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holdingsleep(&b->lock))
801001aa:	8d 43 0c             	lea    0xc(%ebx),%eax
801001ad:	50                   	push   %eax
801001ae:	e8 bd 4f 00 00       	call   80105170 <holdingsleep>
801001b3:	83 c4 10             	add    $0x10,%esp
801001b6:	85 c0                	test   %eax,%eax
801001b8:	74 0f                	je     801001c9 <bwrite+0x29>
    panic("bwrite");
  b->flags |= B_DIRTY;
801001ba:	83 0b 04             	orl    $0x4,(%ebx)
  iderw(b);
801001bd:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
801001c0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801001c3:	c9                   	leave  
  iderw(b);
801001c4:	e9 57 1f 00 00       	jmp    80102120 <iderw>
    panic("bwrite");
801001c9:	83 ec 0c             	sub    $0xc,%esp
801001cc:	68 1f 80 10 80       	push   $0x8010801f
801001d1:	e8 ba 01 00 00       	call   80100390 <panic>
801001d6:	8d 76 00             	lea    0x0(%esi),%esi
801001d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801001e0 <brelse>:

// Release a locked buffer.
// Move to the head of the MRU list.
void
brelse(struct buf *b)
{
801001e0:	55                   	push   %ebp
801001e1:	89 e5                	mov    %esp,%ebp
801001e3:	56                   	push   %esi
801001e4:	53                   	push   %ebx
801001e5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holdingsleep(&b->lock))
801001e8:	83 ec 0c             	sub    $0xc,%esp
801001eb:	8d 73 0c             	lea    0xc(%ebx),%esi
801001ee:	56                   	push   %esi
801001ef:	e8 7c 4f 00 00       	call   80105170 <holdingsleep>
801001f4:	83 c4 10             	add    $0x10,%esp
801001f7:	85 c0                	test   %eax,%eax
801001f9:	74 66                	je     80100261 <brelse+0x81>
    panic("brelse");

  releasesleep(&b->lock);
801001fb:	83 ec 0c             	sub    $0xc,%esp
801001fe:	56                   	push   %esi
801001ff:	e8 2c 4f 00 00       	call   80105130 <releasesleep>

  acquire(&bcache.lock);
80100204:	c7 04 24 e0 c5 10 80 	movl   $0x8010c5e0,(%esp)
8010020b:	e8 f0 50 00 00       	call   80105300 <acquire>
  b->refcnt--;
80100210:	8b 43 4c             	mov    0x4c(%ebx),%eax
  if (b->refcnt == 0) {
80100213:	83 c4 10             	add    $0x10,%esp
  b->refcnt--;
80100216:	83 e8 01             	sub    $0x1,%eax
  if (b->refcnt == 0) {
80100219:	85 c0                	test   %eax,%eax
  b->refcnt--;
8010021b:	89 43 4c             	mov    %eax,0x4c(%ebx)
  if (b->refcnt == 0) {
8010021e:	75 2f                	jne    8010024f <brelse+0x6f>
    // no one is waiting for it.
    b->next->prev = b->prev;
80100220:	8b 43 54             	mov    0x54(%ebx),%eax
80100223:	8b 53 50             	mov    0x50(%ebx),%edx
80100226:	89 50 50             	mov    %edx,0x50(%eax)
    b->prev->next = b->next;
80100229:	8b 43 50             	mov    0x50(%ebx),%eax
8010022c:	8b 53 54             	mov    0x54(%ebx),%edx
8010022f:	89 50 54             	mov    %edx,0x54(%eax)
    b->next = bcache.head.next;
80100232:	a1 30 0d 11 80       	mov    0x80110d30,%eax
    b->prev = &bcache.head;
80100237:	c7 43 50 dc 0c 11 80 	movl   $0x80110cdc,0x50(%ebx)
    b->next = bcache.head.next;
8010023e:	89 43 54             	mov    %eax,0x54(%ebx)
    bcache.head.next->prev = b;
80100241:	a1 30 0d 11 80       	mov    0x80110d30,%eax
80100246:	89 58 50             	mov    %ebx,0x50(%eax)
    bcache.head.next = b;
80100249:	89 1d 30 0d 11 80    	mov    %ebx,0x80110d30
  }
  
  release(&bcache.lock);
8010024f:	c7 45 08 e0 c5 10 80 	movl   $0x8010c5e0,0x8(%ebp)
}
80100256:	8d 65 f8             	lea    -0x8(%ebp),%esp
80100259:	5b                   	pop    %ebx
8010025a:	5e                   	pop    %esi
8010025b:	5d                   	pop    %ebp
  release(&bcache.lock);
8010025c:	e9 5f 51 00 00       	jmp    801053c0 <release>
    panic("brelse");
80100261:	83 ec 0c             	sub    $0xc,%esp
80100264:	68 26 80 10 80       	push   $0x80108026
80100269:	e8 22 01 00 00       	call   80100390 <panic>
8010026e:	66 90                	xchg   %ax,%ax

80100270 <consoleread>:
  }
}

int
consoleread(struct inode *ip, char *dst, int n)
{
80100270:	55                   	push   %ebp
80100271:	89 e5                	mov    %esp,%ebp
80100273:	57                   	push   %edi
80100274:	56                   	push   %esi
80100275:	53                   	push   %ebx
80100276:	83 ec 28             	sub    $0x28,%esp
80100279:	8b 7d 08             	mov    0x8(%ebp),%edi
8010027c:	8b 75 0c             	mov    0xc(%ebp),%esi
  uint target;
  int c;

  iunlock(ip);
8010027f:	57                   	push   %edi
80100280:	e8 db 14 00 00       	call   80101760 <iunlock>
  target = n;
  acquire(&cons.lock);
80100285:	c7 04 24 40 b5 10 80 	movl   $0x8010b540,(%esp)
8010028c:	e8 6f 50 00 00       	call   80105300 <acquire>
  while(n > 0){
80100291:	8b 5d 10             	mov    0x10(%ebp),%ebx
80100294:	83 c4 10             	add    $0x10,%esp
80100297:	31 c0                	xor    %eax,%eax
80100299:	85 db                	test   %ebx,%ebx
8010029b:	0f 8e a1 00 00 00    	jle    80100342 <consoleread+0xd2>
    while(input.r == input.w){
801002a1:	8b 15 e0 0f 11 80    	mov    0x80110fe0,%edx
801002a7:	39 15 e4 0f 11 80    	cmp    %edx,0x80110fe4
801002ad:	74 2c                	je     801002db <consoleread+0x6b>
801002af:	eb 5f                	jmp    80100310 <consoleread+0xa0>
801002b1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      if(myproc()->killed){
        release(&cons.lock);
        ilock(ip);
        return -1;
      }
      sleep(&input.r, &cons.lock);
801002b8:	83 ec 08             	sub    $0x8,%esp
801002bb:	68 40 b5 10 80       	push   $0x8010b540
801002c0:	68 e0 0f 11 80       	push   $0x80110fe0
801002c5:	e8 96 46 00 00       	call   80104960 <sleep>
    while(input.r == input.w){
801002ca:	8b 15 e0 0f 11 80    	mov    0x80110fe0,%edx
801002d0:	83 c4 10             	add    $0x10,%esp
801002d3:	3b 15 e4 0f 11 80    	cmp    0x80110fe4,%edx
801002d9:	75 35                	jne    80100310 <consoleread+0xa0>
      if(myproc()->killed){
801002db:	e8 c0 35 00 00       	call   801038a0 <myproc>
801002e0:	8b 40 24             	mov    0x24(%eax),%eax
801002e3:	85 c0                	test   %eax,%eax
801002e5:	74 d1                	je     801002b8 <consoleread+0x48>
        release(&cons.lock);
801002e7:	83 ec 0c             	sub    $0xc,%esp
801002ea:	68 40 b5 10 80       	push   $0x8010b540
801002ef:	e8 cc 50 00 00       	call   801053c0 <release>
        ilock(ip);
801002f4:	89 3c 24             	mov    %edi,(%esp)
801002f7:	e8 84 13 00 00       	call   80101680 <ilock>
        return -1;
801002fc:	83 c4 10             	add    $0x10,%esp
  }
  release(&cons.lock);
  ilock(ip);

  return target - n;
}
801002ff:	8d 65 f4             	lea    -0xc(%ebp),%esp
        return -1;
80100302:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80100307:	5b                   	pop    %ebx
80100308:	5e                   	pop    %esi
80100309:	5f                   	pop    %edi
8010030a:	5d                   	pop    %ebp
8010030b:	c3                   	ret    
8010030c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    c = input.buf[input.r++ % INPUT_BUF];
80100310:	8d 42 01             	lea    0x1(%edx),%eax
80100313:	a3 e0 0f 11 80       	mov    %eax,0x80110fe0
80100318:	89 d0                	mov    %edx,%eax
8010031a:	83 e0 7f             	and    $0x7f,%eax
8010031d:	0f be 80 60 0f 11 80 	movsbl -0x7feef0a0(%eax),%eax
    if(c == C('D')){  // EOF
80100324:	83 f8 04             	cmp    $0x4,%eax
80100327:	74 3f                	je     80100368 <consoleread+0xf8>
    *dst++ = c;
80100329:	83 c6 01             	add    $0x1,%esi
    --n;
8010032c:	83 eb 01             	sub    $0x1,%ebx
    if(c == '\n')
8010032f:	83 f8 0a             	cmp    $0xa,%eax
    *dst++ = c;
80100332:	88 46 ff             	mov    %al,-0x1(%esi)
    if(c == '\n')
80100335:	74 43                	je     8010037a <consoleread+0x10a>
  while(n > 0){
80100337:	85 db                	test   %ebx,%ebx
80100339:	0f 85 62 ff ff ff    	jne    801002a1 <consoleread+0x31>
8010033f:	8b 45 10             	mov    0x10(%ebp),%eax
  release(&cons.lock);
80100342:	83 ec 0c             	sub    $0xc,%esp
80100345:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80100348:	68 40 b5 10 80       	push   $0x8010b540
8010034d:	e8 6e 50 00 00       	call   801053c0 <release>
  ilock(ip);
80100352:	89 3c 24             	mov    %edi,(%esp)
80100355:	e8 26 13 00 00       	call   80101680 <ilock>
  return target - n;
8010035a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010035d:	83 c4 10             	add    $0x10,%esp
}
80100360:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100363:	5b                   	pop    %ebx
80100364:	5e                   	pop    %esi
80100365:	5f                   	pop    %edi
80100366:	5d                   	pop    %ebp
80100367:	c3                   	ret    
80100368:	8b 45 10             	mov    0x10(%ebp),%eax
8010036b:	29 d8                	sub    %ebx,%eax
      if(n < target){
8010036d:	3b 5d 10             	cmp    0x10(%ebp),%ebx
80100370:	73 d0                	jae    80100342 <consoleread+0xd2>
        input.r--;
80100372:	89 15 e0 0f 11 80    	mov    %edx,0x80110fe0
80100378:	eb c8                	jmp    80100342 <consoleread+0xd2>
8010037a:	8b 45 10             	mov    0x10(%ebp),%eax
8010037d:	29 d8                	sub    %ebx,%eax
8010037f:	eb c1                	jmp    80100342 <consoleread+0xd2>
80100381:	eb 0d                	jmp    80100390 <panic>
80100383:	90                   	nop
80100384:	90                   	nop
80100385:	90                   	nop
80100386:	90                   	nop
80100387:	90                   	nop
80100388:	90                   	nop
80100389:	90                   	nop
8010038a:	90                   	nop
8010038b:	90                   	nop
8010038c:	90                   	nop
8010038d:	90                   	nop
8010038e:	90                   	nop
8010038f:	90                   	nop

80100390 <panic>:
{
80100390:	55                   	push   %ebp
80100391:	89 e5                	mov    %esp,%ebp
80100393:	56                   	push   %esi
80100394:	53                   	push   %ebx
80100395:	83 ec 30             	sub    $0x30,%esp
}

static inline void
cli(void)
{
  asm volatile("cli");
80100398:	fa                   	cli    
  cons.locking = 0;
80100399:	c7 05 74 b5 10 80 00 	movl   $0x0,0x8010b574
801003a0:	00 00 00 
  getcallerpcs(&s, pcs);
801003a3:	8d 5d d0             	lea    -0x30(%ebp),%ebx
801003a6:	8d 75 f8             	lea    -0x8(%ebp),%esi
  cprintf("lapicid %d: panic: ", lapicid());
801003a9:	e8 82 23 00 00       	call   80102730 <lapicid>
801003ae:	83 ec 08             	sub    $0x8,%esp
801003b1:	50                   	push   %eax
801003b2:	68 2d 80 10 80       	push   $0x8010802d
801003b7:	e8 a4 02 00 00       	call   80100660 <cprintf>
  cprintf(s);
801003bc:	58                   	pop    %eax
801003bd:	ff 75 08             	pushl  0x8(%ebp)
801003c0:	e8 9b 02 00 00       	call   80100660 <cprintf>
  cprintf("\n");
801003c5:	c7 04 24 f7 8a 10 80 	movl   $0x80108af7,(%esp)
801003cc:	e8 8f 02 00 00       	call   80100660 <cprintf>
  getcallerpcs(&s, pcs);
801003d1:	5a                   	pop    %edx
801003d2:	8d 45 08             	lea    0x8(%ebp),%eax
801003d5:	59                   	pop    %ecx
801003d6:	53                   	push   %ebx
801003d7:	50                   	push   %eax
801003d8:	e8 03 4e 00 00       	call   801051e0 <getcallerpcs>
801003dd:	83 c4 10             	add    $0x10,%esp
    cprintf(" %p", pcs[i]);
801003e0:	83 ec 08             	sub    $0x8,%esp
801003e3:	ff 33                	pushl  (%ebx)
801003e5:	83 c3 04             	add    $0x4,%ebx
801003e8:	68 41 80 10 80       	push   $0x80108041
801003ed:	e8 6e 02 00 00       	call   80100660 <cprintf>
  for(i=0; i<10; i++)
801003f2:	83 c4 10             	add    $0x10,%esp
801003f5:	39 f3                	cmp    %esi,%ebx
801003f7:	75 e7                	jne    801003e0 <panic+0x50>
  panicked = 1; // freeze other CPU
801003f9:	c7 05 78 b5 10 80 01 	movl   $0x1,0x8010b578
80100400:	00 00 00 
80100403:	eb fe                	jmp    80100403 <panic+0x73>
80100405:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100409:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80100410 <consputc>:
  if(panicked){
80100410:	8b 0d 78 b5 10 80    	mov    0x8010b578,%ecx
80100416:	85 c9                	test   %ecx,%ecx
80100418:	74 06                	je     80100420 <consputc+0x10>
8010041a:	fa                   	cli    
8010041b:	eb fe                	jmp    8010041b <consputc+0xb>
8010041d:	8d 76 00             	lea    0x0(%esi),%esi
{
80100420:	55                   	push   %ebp
80100421:	89 e5                	mov    %esp,%ebp
80100423:	57                   	push   %edi
80100424:	56                   	push   %esi
80100425:	53                   	push   %ebx
80100426:	89 c6                	mov    %eax,%esi
80100428:	83 ec 0c             	sub    $0xc,%esp
  if(c == BACKSPACE){
8010042b:	3d 00 01 00 00       	cmp    $0x100,%eax
80100430:	0f 84 b1 00 00 00    	je     801004e7 <consputc+0xd7>
    uartputc(c);
80100436:	83 ec 0c             	sub    $0xc,%esp
80100439:	50                   	push   %eax
8010043a:	e8 d1 67 00 00       	call   80106c10 <uartputc>
8010043f:	83 c4 10             	add    $0x10,%esp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100442:	bb d4 03 00 00       	mov    $0x3d4,%ebx
80100447:	b8 0e 00 00 00       	mov    $0xe,%eax
8010044c:	89 da                	mov    %ebx,%edx
8010044e:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010044f:	b9 d5 03 00 00       	mov    $0x3d5,%ecx
80100454:	89 ca                	mov    %ecx,%edx
80100456:	ec                   	in     (%dx),%al
  pos = inb(CRTPORT+1) << 8;
80100457:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010045a:	89 da                	mov    %ebx,%edx
8010045c:	c1 e0 08             	shl    $0x8,%eax
8010045f:	89 c7                	mov    %eax,%edi
80100461:	b8 0f 00 00 00       	mov    $0xf,%eax
80100466:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80100467:	89 ca                	mov    %ecx,%edx
80100469:	ec                   	in     (%dx),%al
8010046a:	0f b6 d8             	movzbl %al,%ebx
  pos |= inb(CRTPORT+1);
8010046d:	09 fb                	or     %edi,%ebx
  if(c == '\n')
8010046f:	83 fe 0a             	cmp    $0xa,%esi
80100472:	0f 84 f3 00 00 00    	je     8010056b <consputc+0x15b>
  else if(c == BACKSPACE){
80100478:	81 fe 00 01 00 00    	cmp    $0x100,%esi
8010047e:	0f 84 d7 00 00 00    	je     8010055b <consputc+0x14b>
    crt[pos++] = (c&0xff) | 0x0700;  // black on white
80100484:	89 f0                	mov    %esi,%eax
80100486:	0f b6 c0             	movzbl %al,%eax
80100489:	80 cc 07             	or     $0x7,%ah
8010048c:	66 89 84 1b 00 80 0b 	mov    %ax,-0x7ff48000(%ebx,%ebx,1)
80100493:	80 
80100494:	83 c3 01             	add    $0x1,%ebx
  if(pos < 0 || pos > 25*80)
80100497:	81 fb d0 07 00 00    	cmp    $0x7d0,%ebx
8010049d:	0f 8f ab 00 00 00    	jg     8010054e <consputc+0x13e>
  if((pos/80) >= 24){  // Scroll up.
801004a3:	81 fb 7f 07 00 00    	cmp    $0x77f,%ebx
801004a9:	7f 66                	jg     80100511 <consputc+0x101>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801004ab:	be d4 03 00 00       	mov    $0x3d4,%esi
801004b0:	b8 0e 00 00 00       	mov    $0xe,%eax
801004b5:	89 f2                	mov    %esi,%edx
801004b7:	ee                   	out    %al,(%dx)
801004b8:	b9 d5 03 00 00       	mov    $0x3d5,%ecx
  outb(CRTPORT+1, pos>>8);
801004bd:	89 d8                	mov    %ebx,%eax
801004bf:	c1 f8 08             	sar    $0x8,%eax
801004c2:	89 ca                	mov    %ecx,%edx
801004c4:	ee                   	out    %al,(%dx)
801004c5:	b8 0f 00 00 00       	mov    $0xf,%eax
801004ca:	89 f2                	mov    %esi,%edx
801004cc:	ee                   	out    %al,(%dx)
801004cd:	89 d8                	mov    %ebx,%eax
801004cf:	89 ca                	mov    %ecx,%edx
801004d1:	ee                   	out    %al,(%dx)
  crt[pos] = ' ' | 0x0700;
801004d2:	b8 20 07 00 00       	mov    $0x720,%eax
801004d7:	66 89 84 1b 00 80 0b 	mov    %ax,-0x7ff48000(%ebx,%ebx,1)
801004de:	80 
}
801004df:	8d 65 f4             	lea    -0xc(%ebp),%esp
801004e2:	5b                   	pop    %ebx
801004e3:	5e                   	pop    %esi
801004e4:	5f                   	pop    %edi
801004e5:	5d                   	pop    %ebp
801004e6:	c3                   	ret    
    uartputc('\b'); uartputc(' '); uartputc('\b');
801004e7:	83 ec 0c             	sub    $0xc,%esp
801004ea:	6a 08                	push   $0x8
801004ec:	e8 1f 67 00 00       	call   80106c10 <uartputc>
801004f1:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
801004f8:	e8 13 67 00 00       	call   80106c10 <uartputc>
801004fd:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
80100504:	e8 07 67 00 00       	call   80106c10 <uartputc>
80100509:	83 c4 10             	add    $0x10,%esp
8010050c:	e9 31 ff ff ff       	jmp    80100442 <consputc+0x32>
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
80100511:	52                   	push   %edx
80100512:	68 60 0e 00 00       	push   $0xe60
    pos -= 80;
80100517:	83 eb 50             	sub    $0x50,%ebx
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
8010051a:	68 a0 80 0b 80       	push   $0x800b80a0
8010051f:	68 00 80 0b 80       	push   $0x800b8000
80100524:	e8 97 4f 00 00       	call   801054c0 <memmove>
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
80100529:	b8 80 07 00 00       	mov    $0x780,%eax
8010052e:	83 c4 0c             	add    $0xc,%esp
80100531:	29 d8                	sub    %ebx,%eax
80100533:	01 c0                	add    %eax,%eax
80100535:	50                   	push   %eax
80100536:	8d 04 1b             	lea    (%ebx,%ebx,1),%eax
80100539:	6a 00                	push   $0x0
8010053b:	2d 00 80 f4 7f       	sub    $0x7ff48000,%eax
80100540:	50                   	push   %eax
80100541:	e8 ca 4e 00 00       	call   80105410 <memset>
80100546:	83 c4 10             	add    $0x10,%esp
80100549:	e9 5d ff ff ff       	jmp    801004ab <consputc+0x9b>
    panic("pos under/overflow");
8010054e:	83 ec 0c             	sub    $0xc,%esp
80100551:	68 45 80 10 80       	push   $0x80108045
80100556:	e8 35 fe ff ff       	call   80100390 <panic>
    if(pos > 0) --pos;
8010055b:	85 db                	test   %ebx,%ebx
8010055d:	0f 84 48 ff ff ff    	je     801004ab <consputc+0x9b>
80100563:	83 eb 01             	sub    $0x1,%ebx
80100566:	e9 2c ff ff ff       	jmp    80100497 <consputc+0x87>
    pos += 80 - pos%80;
8010056b:	89 d8                	mov    %ebx,%eax
8010056d:	b9 50 00 00 00       	mov    $0x50,%ecx
80100572:	99                   	cltd   
80100573:	f7 f9                	idiv   %ecx
80100575:	29 d1                	sub    %edx,%ecx
80100577:	01 cb                	add    %ecx,%ebx
80100579:	e9 19 ff ff ff       	jmp    80100497 <consputc+0x87>
8010057e:	66 90                	xchg   %ax,%ax

80100580 <printint>:
{
80100580:	55                   	push   %ebp
80100581:	89 e5                	mov    %esp,%ebp
80100583:	57                   	push   %edi
80100584:	56                   	push   %esi
80100585:	53                   	push   %ebx
80100586:	89 d3                	mov    %edx,%ebx
80100588:	83 ec 2c             	sub    $0x2c,%esp
  if(sign && (sign = xx < 0))
8010058b:	85 c9                	test   %ecx,%ecx
{
8010058d:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  if(sign && (sign = xx < 0))
80100590:	74 04                	je     80100596 <printint+0x16>
80100592:	85 c0                	test   %eax,%eax
80100594:	78 5a                	js     801005f0 <printint+0x70>
    x = xx;
80100596:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
  i = 0;
8010059d:	31 c9                	xor    %ecx,%ecx
8010059f:	8d 75 d7             	lea    -0x29(%ebp),%esi
801005a2:	eb 06                	jmp    801005aa <printint+0x2a>
801005a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    buf[i++] = digits[x % base];
801005a8:	89 f9                	mov    %edi,%ecx
801005aa:	31 d2                	xor    %edx,%edx
801005ac:	8d 79 01             	lea    0x1(%ecx),%edi
801005af:	f7 f3                	div    %ebx
801005b1:	0f b6 92 70 80 10 80 	movzbl -0x7fef7f90(%edx),%edx
  }while((x /= base) != 0);
801005b8:	85 c0                	test   %eax,%eax
    buf[i++] = digits[x % base];
801005ba:	88 14 3e             	mov    %dl,(%esi,%edi,1)
  }while((x /= base) != 0);
801005bd:	75 e9                	jne    801005a8 <printint+0x28>
  if(sign)
801005bf:	8b 45 d4             	mov    -0x2c(%ebp),%eax
801005c2:	85 c0                	test   %eax,%eax
801005c4:	74 08                	je     801005ce <printint+0x4e>
    buf[i++] = '-';
801005c6:	c6 44 3d d8 2d       	movb   $0x2d,-0x28(%ebp,%edi,1)
801005cb:	8d 79 02             	lea    0x2(%ecx),%edi
801005ce:	8d 5c 3d d7          	lea    -0x29(%ebp,%edi,1),%ebx
801005d2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    consputc(buf[i]);
801005d8:	0f be 03             	movsbl (%ebx),%eax
801005db:	83 eb 01             	sub    $0x1,%ebx
801005de:	e8 2d fe ff ff       	call   80100410 <consputc>
  while(--i >= 0)
801005e3:	39 f3                	cmp    %esi,%ebx
801005e5:	75 f1                	jne    801005d8 <printint+0x58>
}
801005e7:	83 c4 2c             	add    $0x2c,%esp
801005ea:	5b                   	pop    %ebx
801005eb:	5e                   	pop    %esi
801005ec:	5f                   	pop    %edi
801005ed:	5d                   	pop    %ebp
801005ee:	c3                   	ret    
801005ef:	90                   	nop
    x = -xx;
801005f0:	f7 d8                	neg    %eax
801005f2:	eb a9                	jmp    8010059d <printint+0x1d>
801005f4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801005fa:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80100600 <consolewrite>:

int
consolewrite(struct inode *ip, char *buf, int n)
{
80100600:	55                   	push   %ebp
80100601:	89 e5                	mov    %esp,%ebp
80100603:	57                   	push   %edi
80100604:	56                   	push   %esi
80100605:	53                   	push   %ebx
80100606:	83 ec 18             	sub    $0x18,%esp
80100609:	8b 75 10             	mov    0x10(%ebp),%esi
  int i;

  iunlock(ip);
8010060c:	ff 75 08             	pushl  0x8(%ebp)
8010060f:	e8 4c 11 00 00       	call   80101760 <iunlock>
  acquire(&cons.lock);
80100614:	c7 04 24 40 b5 10 80 	movl   $0x8010b540,(%esp)
8010061b:	e8 e0 4c 00 00       	call   80105300 <acquire>
  for(i = 0; i < n; i++)
80100620:	83 c4 10             	add    $0x10,%esp
80100623:	85 f6                	test   %esi,%esi
80100625:	7e 18                	jle    8010063f <consolewrite+0x3f>
80100627:	8b 7d 0c             	mov    0xc(%ebp),%edi
8010062a:	8d 1c 37             	lea    (%edi,%esi,1),%ebx
8010062d:	8d 76 00             	lea    0x0(%esi),%esi
    consputc(buf[i] & 0xff);
80100630:	0f b6 07             	movzbl (%edi),%eax
80100633:	83 c7 01             	add    $0x1,%edi
80100636:	e8 d5 fd ff ff       	call   80100410 <consputc>
  for(i = 0; i < n; i++)
8010063b:	39 fb                	cmp    %edi,%ebx
8010063d:	75 f1                	jne    80100630 <consolewrite+0x30>
  release(&cons.lock);
8010063f:	83 ec 0c             	sub    $0xc,%esp
80100642:	68 40 b5 10 80       	push   $0x8010b540
80100647:	e8 74 4d 00 00       	call   801053c0 <release>
  ilock(ip);
8010064c:	58                   	pop    %eax
8010064d:	ff 75 08             	pushl  0x8(%ebp)
80100650:	e8 2b 10 00 00       	call   80101680 <ilock>

  return n;
}
80100655:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100658:	89 f0                	mov    %esi,%eax
8010065a:	5b                   	pop    %ebx
8010065b:	5e                   	pop    %esi
8010065c:	5f                   	pop    %edi
8010065d:	5d                   	pop    %ebp
8010065e:	c3                   	ret    
8010065f:	90                   	nop

80100660 <cprintf>:
{
80100660:	55                   	push   %ebp
80100661:	89 e5                	mov    %esp,%ebp
80100663:	57                   	push   %edi
80100664:	56                   	push   %esi
80100665:	53                   	push   %ebx
80100666:	83 ec 1c             	sub    $0x1c,%esp
  locking = cons.locking;
80100669:	a1 74 b5 10 80       	mov    0x8010b574,%eax
  if(locking)
8010066e:	85 c0                	test   %eax,%eax
  locking = cons.locking;
80100670:	89 45 dc             	mov    %eax,-0x24(%ebp)
  if(locking)
80100673:	0f 85 6f 01 00 00    	jne    801007e8 <cprintf+0x188>
  if (fmt == 0)
80100679:	8b 45 08             	mov    0x8(%ebp),%eax
8010067c:	85 c0                	test   %eax,%eax
8010067e:	89 c7                	mov    %eax,%edi
80100680:	0f 84 77 01 00 00    	je     801007fd <cprintf+0x19d>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
80100686:	0f b6 00             	movzbl (%eax),%eax
  argp = (uint*)(void*)(&fmt + 1);
80100689:	8d 4d 0c             	lea    0xc(%ebp),%ecx
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
8010068c:	31 db                	xor    %ebx,%ebx
  argp = (uint*)(void*)(&fmt + 1);
8010068e:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
80100691:	85 c0                	test   %eax,%eax
80100693:	75 56                	jne    801006eb <cprintf+0x8b>
80100695:	eb 79                	jmp    80100710 <cprintf+0xb0>
80100697:	89 f6                	mov    %esi,%esi
80100699:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    c = fmt[++i] & 0xff;
801006a0:	0f b6 16             	movzbl (%esi),%edx
    if(c == 0)
801006a3:	85 d2                	test   %edx,%edx
801006a5:	74 69                	je     80100710 <cprintf+0xb0>
801006a7:	83 c3 02             	add    $0x2,%ebx
    switch(c){
801006aa:	83 fa 70             	cmp    $0x70,%edx
801006ad:	8d 34 1f             	lea    (%edi,%ebx,1),%esi
801006b0:	0f 84 84 00 00 00    	je     8010073a <cprintf+0xda>
801006b6:	7f 78                	jg     80100730 <cprintf+0xd0>
801006b8:	83 fa 25             	cmp    $0x25,%edx
801006bb:	0f 84 ff 00 00 00    	je     801007c0 <cprintf+0x160>
801006c1:	83 fa 64             	cmp    $0x64,%edx
801006c4:	0f 85 8e 00 00 00    	jne    80100758 <cprintf+0xf8>
      printint(*argp++, 10, 1);
801006ca:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801006cd:	ba 0a 00 00 00       	mov    $0xa,%edx
801006d2:	8d 48 04             	lea    0x4(%eax),%ecx
801006d5:	8b 00                	mov    (%eax),%eax
801006d7:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
801006da:	b9 01 00 00 00       	mov    $0x1,%ecx
801006df:	e8 9c fe ff ff       	call   80100580 <printint>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801006e4:	0f b6 06             	movzbl (%esi),%eax
801006e7:	85 c0                	test   %eax,%eax
801006e9:	74 25                	je     80100710 <cprintf+0xb0>
801006eb:	8d 53 01             	lea    0x1(%ebx),%edx
    if(c != '%'){
801006ee:	83 f8 25             	cmp    $0x25,%eax
801006f1:	8d 34 17             	lea    (%edi,%edx,1),%esi
801006f4:	74 aa                	je     801006a0 <cprintf+0x40>
801006f6:	89 55 e0             	mov    %edx,-0x20(%ebp)
      consputc(c);
801006f9:	e8 12 fd ff ff       	call   80100410 <consputc>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801006fe:	0f b6 06             	movzbl (%esi),%eax
      continue;
80100701:	8b 55 e0             	mov    -0x20(%ebp),%edx
80100704:	89 d3                	mov    %edx,%ebx
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
80100706:	85 c0                	test   %eax,%eax
80100708:	75 e1                	jne    801006eb <cprintf+0x8b>
8010070a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  if(locking)
80100710:	8b 45 dc             	mov    -0x24(%ebp),%eax
80100713:	85 c0                	test   %eax,%eax
80100715:	74 10                	je     80100727 <cprintf+0xc7>
    release(&cons.lock);
80100717:	83 ec 0c             	sub    $0xc,%esp
8010071a:	68 40 b5 10 80       	push   $0x8010b540
8010071f:	e8 9c 4c 00 00       	call   801053c0 <release>
80100724:	83 c4 10             	add    $0x10,%esp
}
80100727:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010072a:	5b                   	pop    %ebx
8010072b:	5e                   	pop    %esi
8010072c:	5f                   	pop    %edi
8010072d:	5d                   	pop    %ebp
8010072e:	c3                   	ret    
8010072f:	90                   	nop
    switch(c){
80100730:	83 fa 73             	cmp    $0x73,%edx
80100733:	74 43                	je     80100778 <cprintf+0x118>
80100735:	83 fa 78             	cmp    $0x78,%edx
80100738:	75 1e                	jne    80100758 <cprintf+0xf8>
      printint(*argp++, 16, 0);
8010073a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010073d:	ba 10 00 00 00       	mov    $0x10,%edx
80100742:	8d 48 04             	lea    0x4(%eax),%ecx
80100745:	8b 00                	mov    (%eax),%eax
80100747:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
8010074a:	31 c9                	xor    %ecx,%ecx
8010074c:	e8 2f fe ff ff       	call   80100580 <printint>
      break;
80100751:	eb 91                	jmp    801006e4 <cprintf+0x84>
80100753:	90                   	nop
80100754:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      consputc('%');
80100758:	b8 25 00 00 00       	mov    $0x25,%eax
8010075d:	89 55 e0             	mov    %edx,-0x20(%ebp)
80100760:	e8 ab fc ff ff       	call   80100410 <consputc>
      consputc(c);
80100765:	8b 55 e0             	mov    -0x20(%ebp),%edx
80100768:	89 d0                	mov    %edx,%eax
8010076a:	e8 a1 fc ff ff       	call   80100410 <consputc>
      break;
8010076f:	e9 70 ff ff ff       	jmp    801006e4 <cprintf+0x84>
80100774:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      if((s = (char*)*argp++) == 0)
80100778:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010077b:	8b 10                	mov    (%eax),%edx
8010077d:	8d 48 04             	lea    0x4(%eax),%ecx
80100780:	89 4d e0             	mov    %ecx,-0x20(%ebp)
80100783:	85 d2                	test   %edx,%edx
80100785:	74 49                	je     801007d0 <cprintf+0x170>
      for(; *s; s++)
80100787:	0f be 02             	movsbl (%edx),%eax
      if((s = (char*)*argp++) == 0)
8010078a:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
      for(; *s; s++)
8010078d:	84 c0                	test   %al,%al
8010078f:	0f 84 4f ff ff ff    	je     801006e4 <cprintf+0x84>
80100795:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
80100798:	89 d3                	mov    %edx,%ebx
8010079a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801007a0:	83 c3 01             	add    $0x1,%ebx
        consputc(*s);
801007a3:	e8 68 fc ff ff       	call   80100410 <consputc>
      for(; *s; s++)
801007a8:	0f be 03             	movsbl (%ebx),%eax
801007ab:	84 c0                	test   %al,%al
801007ad:	75 f1                	jne    801007a0 <cprintf+0x140>
      if((s = (char*)*argp++) == 0)
801007af:	8b 45 e0             	mov    -0x20(%ebp),%eax
801007b2:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
801007b5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801007b8:	e9 27 ff ff ff       	jmp    801006e4 <cprintf+0x84>
801007bd:	8d 76 00             	lea    0x0(%esi),%esi
      consputc('%');
801007c0:	b8 25 00 00 00       	mov    $0x25,%eax
801007c5:	e8 46 fc ff ff       	call   80100410 <consputc>
      break;
801007ca:	e9 15 ff ff ff       	jmp    801006e4 <cprintf+0x84>
801007cf:	90                   	nop
        s = "(null)";
801007d0:	ba 58 80 10 80       	mov    $0x80108058,%edx
      for(; *s; s++)
801007d5:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
801007d8:	b8 28 00 00 00       	mov    $0x28,%eax
801007dd:	89 d3                	mov    %edx,%ebx
801007df:	eb bf                	jmp    801007a0 <cprintf+0x140>
801007e1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    acquire(&cons.lock);
801007e8:	83 ec 0c             	sub    $0xc,%esp
801007eb:	68 40 b5 10 80       	push   $0x8010b540
801007f0:	e8 0b 4b 00 00       	call   80105300 <acquire>
801007f5:	83 c4 10             	add    $0x10,%esp
801007f8:	e9 7c fe ff ff       	jmp    80100679 <cprintf+0x19>
    panic("null fmt");
801007fd:	83 ec 0c             	sub    $0xc,%esp
80100800:	68 5f 80 10 80       	push   $0x8010805f
80100805:	e8 86 fb ff ff       	call   80100390 <panic>
8010080a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80100810 <consoleintr>:
{
80100810:	55                   	push   %ebp
80100811:	89 e5                	mov    %esp,%ebp
80100813:	57                   	push   %edi
80100814:	56                   	push   %esi
80100815:	53                   	push   %ebx
  int c, doprocdump = 0;
80100816:	31 f6                	xor    %esi,%esi
{
80100818:	83 ec 18             	sub    $0x18,%esp
8010081b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&cons.lock);
8010081e:	68 40 b5 10 80       	push   $0x8010b540
80100823:	e8 d8 4a 00 00       	call   80105300 <acquire>
  while((c = getc()) >= 0){
80100828:	83 c4 10             	add    $0x10,%esp
8010082b:	90                   	nop
8010082c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100830:	ff d3                	call   *%ebx
80100832:	85 c0                	test   %eax,%eax
80100834:	89 c7                	mov    %eax,%edi
80100836:	78 48                	js     80100880 <consoleintr+0x70>
    switch(c){
80100838:	83 ff 10             	cmp    $0x10,%edi
8010083b:	0f 84 e7 00 00 00    	je     80100928 <consoleintr+0x118>
80100841:	7e 5d                	jle    801008a0 <consoleintr+0x90>
80100843:	83 ff 15             	cmp    $0x15,%edi
80100846:	0f 84 ec 00 00 00    	je     80100938 <consoleintr+0x128>
8010084c:	83 ff 7f             	cmp    $0x7f,%edi
8010084f:	75 54                	jne    801008a5 <consoleintr+0x95>
      if(input.e != input.w){
80100851:	a1 e8 0f 11 80       	mov    0x80110fe8,%eax
80100856:	3b 05 e4 0f 11 80    	cmp    0x80110fe4,%eax
8010085c:	74 d2                	je     80100830 <consoleintr+0x20>
        input.e--;
8010085e:	83 e8 01             	sub    $0x1,%eax
80100861:	a3 e8 0f 11 80       	mov    %eax,0x80110fe8
        consputc(BACKSPACE);
80100866:	b8 00 01 00 00       	mov    $0x100,%eax
8010086b:	e8 a0 fb ff ff       	call   80100410 <consputc>
  while((c = getc()) >= 0){
80100870:	ff d3                	call   *%ebx
80100872:	85 c0                	test   %eax,%eax
80100874:	89 c7                	mov    %eax,%edi
80100876:	79 c0                	jns    80100838 <consoleintr+0x28>
80100878:	90                   	nop
80100879:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  release(&cons.lock);
80100880:	83 ec 0c             	sub    $0xc,%esp
80100883:	68 40 b5 10 80       	push   $0x8010b540
80100888:	e8 33 4b 00 00       	call   801053c0 <release>
  if(doprocdump) {
8010088d:	83 c4 10             	add    $0x10,%esp
80100890:	85 f6                	test   %esi,%esi
80100892:	0f 85 f8 00 00 00    	jne    80100990 <consoleintr+0x180>
}
80100898:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010089b:	5b                   	pop    %ebx
8010089c:	5e                   	pop    %esi
8010089d:	5f                   	pop    %edi
8010089e:	5d                   	pop    %ebp
8010089f:	c3                   	ret    
    switch(c){
801008a0:	83 ff 08             	cmp    $0x8,%edi
801008a3:	74 ac                	je     80100851 <consoleintr+0x41>
      if(c != 0 && input.e-input.r < INPUT_BUF){
801008a5:	85 ff                	test   %edi,%edi
801008a7:	74 87                	je     80100830 <consoleintr+0x20>
801008a9:	a1 e8 0f 11 80       	mov    0x80110fe8,%eax
801008ae:	89 c2                	mov    %eax,%edx
801008b0:	2b 15 e0 0f 11 80    	sub    0x80110fe0,%edx
801008b6:	83 fa 7f             	cmp    $0x7f,%edx
801008b9:	0f 87 71 ff ff ff    	ja     80100830 <consoleintr+0x20>
801008bf:	8d 50 01             	lea    0x1(%eax),%edx
801008c2:	83 e0 7f             	and    $0x7f,%eax
        c = (c == '\r') ? '\n' : c;
801008c5:	83 ff 0d             	cmp    $0xd,%edi
        input.buf[input.e++ % INPUT_BUF] = c;
801008c8:	89 15 e8 0f 11 80    	mov    %edx,0x80110fe8
        c = (c == '\r') ? '\n' : c;
801008ce:	0f 84 cc 00 00 00    	je     801009a0 <consoleintr+0x190>
        input.buf[input.e++ % INPUT_BUF] = c;
801008d4:	89 f9                	mov    %edi,%ecx
801008d6:	88 88 60 0f 11 80    	mov    %cl,-0x7feef0a0(%eax)
        consputc(c);
801008dc:	89 f8                	mov    %edi,%eax
801008de:	e8 2d fb ff ff       	call   80100410 <consputc>
        if(c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF){
801008e3:	83 ff 0a             	cmp    $0xa,%edi
801008e6:	0f 84 c5 00 00 00    	je     801009b1 <consoleintr+0x1a1>
801008ec:	83 ff 04             	cmp    $0x4,%edi
801008ef:	0f 84 bc 00 00 00    	je     801009b1 <consoleintr+0x1a1>
801008f5:	a1 e0 0f 11 80       	mov    0x80110fe0,%eax
801008fa:	83 e8 80             	sub    $0xffffff80,%eax
801008fd:	39 05 e8 0f 11 80    	cmp    %eax,0x80110fe8
80100903:	0f 85 27 ff ff ff    	jne    80100830 <consoleintr+0x20>
          wakeup(&input.r);
80100909:	83 ec 0c             	sub    $0xc,%esp
          input.w = input.e;
8010090c:	a3 e4 0f 11 80       	mov    %eax,0x80110fe4
          wakeup(&input.r);
80100911:	68 e0 0f 11 80       	push   $0x80110fe0
80100916:	e8 15 42 00 00       	call   80104b30 <wakeup>
8010091b:	83 c4 10             	add    $0x10,%esp
8010091e:	e9 0d ff ff ff       	jmp    80100830 <consoleintr+0x20>
80100923:	90                   	nop
80100924:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      doprocdump = 1;
80100928:	be 01 00 00 00       	mov    $0x1,%esi
8010092d:	e9 fe fe ff ff       	jmp    80100830 <consoleintr+0x20>
80100932:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      while(input.e != input.w &&
80100938:	a1 e8 0f 11 80       	mov    0x80110fe8,%eax
8010093d:	39 05 e4 0f 11 80    	cmp    %eax,0x80110fe4
80100943:	75 2b                	jne    80100970 <consoleintr+0x160>
80100945:	e9 e6 fe ff ff       	jmp    80100830 <consoleintr+0x20>
8010094a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        input.e--;
80100950:	a3 e8 0f 11 80       	mov    %eax,0x80110fe8
        consputc(BACKSPACE);
80100955:	b8 00 01 00 00       	mov    $0x100,%eax
8010095a:	e8 b1 fa ff ff       	call   80100410 <consputc>
      while(input.e != input.w &&
8010095f:	a1 e8 0f 11 80       	mov    0x80110fe8,%eax
80100964:	3b 05 e4 0f 11 80    	cmp    0x80110fe4,%eax
8010096a:	0f 84 c0 fe ff ff    	je     80100830 <consoleintr+0x20>
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
80100970:	83 e8 01             	sub    $0x1,%eax
80100973:	89 c2                	mov    %eax,%edx
80100975:	83 e2 7f             	and    $0x7f,%edx
      while(input.e != input.w &&
80100978:	80 ba 60 0f 11 80 0a 	cmpb   $0xa,-0x7feef0a0(%edx)
8010097f:	75 cf                	jne    80100950 <consoleintr+0x140>
80100981:	e9 aa fe ff ff       	jmp    80100830 <consoleintr+0x20>
80100986:	8d 76 00             	lea    0x0(%esi),%esi
80100989:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
}
80100990:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100993:	5b                   	pop    %ebx
80100994:	5e                   	pop    %esi
80100995:	5f                   	pop    %edi
80100996:	5d                   	pop    %ebp
    procdump();  // now call procdump() wo. cons.lock held
80100997:	e9 94 42 00 00       	jmp    80104c30 <procdump>
8010099c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        input.buf[input.e++ % INPUT_BUF] = c;
801009a0:	c6 80 60 0f 11 80 0a 	movb   $0xa,-0x7feef0a0(%eax)
        consputc(c);
801009a7:	b8 0a 00 00 00       	mov    $0xa,%eax
801009ac:	e8 5f fa ff ff       	call   80100410 <consputc>
801009b1:	a1 e8 0f 11 80       	mov    0x80110fe8,%eax
801009b6:	e9 4e ff ff ff       	jmp    80100909 <consoleintr+0xf9>
801009bb:	90                   	nop
801009bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801009c0 <consoleinit>:

void
consoleinit(void)
{
801009c0:	55                   	push   %ebp
801009c1:	89 e5                	mov    %esp,%ebp
801009c3:	83 ec 10             	sub    $0x10,%esp
  initlock(&cons.lock, "console");
801009c6:	68 68 80 10 80       	push   $0x80108068
801009cb:	68 40 b5 10 80       	push   $0x8010b540
801009d0:	e8 eb 47 00 00       	call   801051c0 <initlock>

  devsw[CONSOLE].write = consolewrite;
  devsw[CONSOLE].read = consoleread;
  cons.locking = 1;

  ioapicenable(IRQ_KBD, 0);
801009d5:	58                   	pop    %eax
801009d6:	5a                   	pop    %edx
801009d7:	6a 00                	push   $0x0
801009d9:	6a 01                	push   $0x1
  devsw[CONSOLE].write = consolewrite;
801009db:	c7 05 cc 19 11 80 00 	movl   $0x80100600,0x801119cc
801009e2:	06 10 80 
  devsw[CONSOLE].read = consoleread;
801009e5:	c7 05 c8 19 11 80 70 	movl   $0x80100270,0x801119c8
801009ec:	02 10 80 
  cons.locking = 1;
801009ef:	c7 05 74 b5 10 80 01 	movl   $0x1,0x8010b574
801009f6:	00 00 00 
  ioapicenable(IRQ_KBD, 0);
801009f9:	e8 d2 18 00 00       	call   801022d0 <ioapicenable>
}
801009fe:	83 c4 10             	add    $0x10,%esp
80100a01:	c9                   	leave  
80100a02:	c3                   	ret    
80100a03:	66 90                	xchg   %ax,%ax
80100a05:	66 90                	xchg   %ax,%ax
80100a07:	66 90                	xchg   %ax,%ax
80100a09:	66 90                	xchg   %ax,%ax
80100a0b:	66 90                	xchg   %ax,%ax
80100a0d:	66 90                	xchg   %ax,%ax
80100a0f:	90                   	nop

80100a10 <exec>:
#include "x86.h"
#include "elf.h"

int
exec(char *path, char **argv)
{
80100a10:	55                   	push   %ebp
80100a11:	89 e5                	mov    %esp,%ebp
80100a13:	57                   	push   %edi
80100a14:	56                   	push   %esi
80100a15:	53                   	push   %ebx
80100a16:	81 ec 0c 01 00 00    	sub    $0x10c,%esp
  uint argc, sz, sp, ustack[3+MAXARG+1];
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pde_t *pgdir, *oldpgdir;
  struct proc *curproc = myproc();
80100a1c:	e8 7f 2e 00 00       	call   801038a0 <myproc>
80100a21:	89 85 f4 fe ff ff    	mov    %eax,-0x10c(%ebp)

  begin_op();
80100a27:	e8 74 21 00 00       	call   80102ba0 <begin_op>

  if((ip = namei(path)) == 0){
80100a2c:	83 ec 0c             	sub    $0xc,%esp
80100a2f:	ff 75 08             	pushl  0x8(%ebp)
80100a32:	e8 a9 14 00 00       	call   80101ee0 <namei>
80100a37:	83 c4 10             	add    $0x10,%esp
80100a3a:	85 c0                	test   %eax,%eax
80100a3c:	0f 84 91 01 00 00    	je     80100bd3 <exec+0x1c3>
    end_op();
    cprintf("exec: fail\n");
    return -1;
  }
  ilock(ip);
80100a42:	83 ec 0c             	sub    $0xc,%esp
80100a45:	89 c3                	mov    %eax,%ebx
80100a47:	50                   	push   %eax
80100a48:	e8 33 0c 00 00       	call   80101680 <ilock>
  pgdir = 0;

  // Check ELF header
  if(readi(ip, (char*)&elf, 0, sizeof(elf)) != sizeof(elf))
80100a4d:	8d 85 24 ff ff ff    	lea    -0xdc(%ebp),%eax
80100a53:	6a 34                	push   $0x34
80100a55:	6a 00                	push   $0x0
80100a57:	50                   	push   %eax
80100a58:	53                   	push   %ebx
80100a59:	e8 02 0f 00 00       	call   80101960 <readi>
80100a5e:	83 c4 20             	add    $0x20,%esp
80100a61:	83 f8 34             	cmp    $0x34,%eax
80100a64:	74 22                	je     80100a88 <exec+0x78>

 bad:
  if(pgdir)
    freevm(pgdir);
  if(ip){
    iunlockput(ip);
80100a66:	83 ec 0c             	sub    $0xc,%esp
80100a69:	53                   	push   %ebx
80100a6a:	e8 a1 0e 00 00       	call   80101910 <iunlockput>
    end_op();
80100a6f:	e8 9c 21 00 00       	call   80102c10 <end_op>
80100a74:	83 c4 10             	add    $0x10,%esp
  }
  return -1;
80100a77:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80100a7c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100a7f:	5b                   	pop    %ebx
80100a80:	5e                   	pop    %esi
80100a81:	5f                   	pop    %edi
80100a82:	5d                   	pop    %ebp
80100a83:	c3                   	ret    
80100a84:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if(elf.magic != ELF_MAGIC)
80100a88:	81 bd 24 ff ff ff 7f 	cmpl   $0x464c457f,-0xdc(%ebp)
80100a8f:	45 4c 46 
80100a92:	75 d2                	jne    80100a66 <exec+0x56>
  if((pgdir = setupkvm()) == 0)
80100a94:	e8 c7 72 00 00       	call   80107d60 <setupkvm>
80100a99:	85 c0                	test   %eax,%eax
80100a9b:	89 85 f0 fe ff ff    	mov    %eax,-0x110(%ebp)
80100aa1:	74 c3                	je     80100a66 <exec+0x56>
  sz = 0;
80100aa3:	31 ff                	xor    %edi,%edi
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100aa5:	66 83 bd 50 ff ff ff 	cmpw   $0x0,-0xb0(%ebp)
80100aac:	00 
80100aad:	8b 85 40 ff ff ff    	mov    -0xc0(%ebp),%eax
80100ab3:	89 85 ec fe ff ff    	mov    %eax,-0x114(%ebp)
80100ab9:	0f 84 8c 02 00 00    	je     80100d4b <exec+0x33b>
80100abf:	31 f6                	xor    %esi,%esi
80100ac1:	eb 7f                	jmp    80100b42 <exec+0x132>
80100ac3:	90                   	nop
80100ac4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(ph.type != ELF_PROG_LOAD)
80100ac8:	83 bd 04 ff ff ff 01 	cmpl   $0x1,-0xfc(%ebp)
80100acf:	75 63                	jne    80100b34 <exec+0x124>
    if(ph.memsz < ph.filesz)
80100ad1:	8b 85 18 ff ff ff    	mov    -0xe8(%ebp),%eax
80100ad7:	3b 85 14 ff ff ff    	cmp    -0xec(%ebp),%eax
80100add:	0f 82 86 00 00 00    	jb     80100b69 <exec+0x159>
80100ae3:	03 85 0c ff ff ff    	add    -0xf4(%ebp),%eax
80100ae9:	72 7e                	jb     80100b69 <exec+0x159>
    if((sz = allocuvm(pgdir, sz, ph.vaddr + ph.memsz)) == 0)
80100aeb:	83 ec 04             	sub    $0x4,%esp
80100aee:	50                   	push   %eax
80100aef:	57                   	push   %edi
80100af0:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
80100af6:	e8 85 70 00 00       	call   80107b80 <allocuvm>
80100afb:	83 c4 10             	add    $0x10,%esp
80100afe:	85 c0                	test   %eax,%eax
80100b00:	89 c7                	mov    %eax,%edi
80100b02:	74 65                	je     80100b69 <exec+0x159>
    if(ph.vaddr % PGSIZE != 0)
80100b04:	8b 85 0c ff ff ff    	mov    -0xf4(%ebp),%eax
80100b0a:	a9 ff 0f 00 00       	test   $0xfff,%eax
80100b0f:	75 58                	jne    80100b69 <exec+0x159>
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
80100b11:	83 ec 0c             	sub    $0xc,%esp
80100b14:	ff b5 14 ff ff ff    	pushl  -0xec(%ebp)
80100b1a:	ff b5 08 ff ff ff    	pushl  -0xf8(%ebp)
80100b20:	53                   	push   %ebx
80100b21:	50                   	push   %eax
80100b22:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
80100b28:	e8 93 6f 00 00       	call   80107ac0 <loaduvm>
80100b2d:	83 c4 20             	add    $0x20,%esp
80100b30:	85 c0                	test   %eax,%eax
80100b32:	78 35                	js     80100b69 <exec+0x159>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100b34:	0f b7 85 50 ff ff ff 	movzwl -0xb0(%ebp),%eax
80100b3b:	83 c6 01             	add    $0x1,%esi
80100b3e:	39 f0                	cmp    %esi,%eax
80100b40:	7e 3d                	jle    80100b7f <exec+0x16f>
    if(readi(ip, (char*)&ph, off, sizeof(ph)) != sizeof(ph))
80100b42:	89 f0                	mov    %esi,%eax
80100b44:	6a 20                	push   $0x20
80100b46:	c1 e0 05             	shl    $0x5,%eax
80100b49:	03 85 ec fe ff ff    	add    -0x114(%ebp),%eax
80100b4f:	50                   	push   %eax
80100b50:	8d 85 04 ff ff ff    	lea    -0xfc(%ebp),%eax
80100b56:	50                   	push   %eax
80100b57:	53                   	push   %ebx
80100b58:	e8 03 0e 00 00       	call   80101960 <readi>
80100b5d:	83 c4 10             	add    $0x10,%esp
80100b60:	83 f8 20             	cmp    $0x20,%eax
80100b63:	0f 84 5f ff ff ff    	je     80100ac8 <exec+0xb8>
    freevm(pgdir);
80100b69:	83 ec 0c             	sub    $0xc,%esp
80100b6c:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
80100b72:	e8 69 71 00 00       	call   80107ce0 <freevm>
80100b77:	83 c4 10             	add    $0x10,%esp
80100b7a:	e9 e7 fe ff ff       	jmp    80100a66 <exec+0x56>
80100b7f:	81 c7 ff 0f 00 00    	add    $0xfff,%edi
80100b85:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
80100b8b:	8d b7 00 20 00 00    	lea    0x2000(%edi),%esi
  iunlockput(ip);
80100b91:	83 ec 0c             	sub    $0xc,%esp
80100b94:	53                   	push   %ebx
80100b95:	e8 76 0d 00 00       	call   80101910 <iunlockput>
  end_op();
80100b9a:	e8 71 20 00 00       	call   80102c10 <end_op>
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
80100b9f:	83 c4 0c             	add    $0xc,%esp
80100ba2:	56                   	push   %esi
80100ba3:	57                   	push   %edi
80100ba4:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
80100baa:	e8 d1 6f 00 00       	call   80107b80 <allocuvm>
80100baf:	83 c4 10             	add    $0x10,%esp
80100bb2:	85 c0                	test   %eax,%eax
80100bb4:	89 c6                	mov    %eax,%esi
80100bb6:	75 3a                	jne    80100bf2 <exec+0x1e2>
    freevm(pgdir);
80100bb8:	83 ec 0c             	sub    $0xc,%esp
80100bbb:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
80100bc1:	e8 1a 71 00 00       	call   80107ce0 <freevm>
80100bc6:	83 c4 10             	add    $0x10,%esp
  return -1;
80100bc9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100bce:	e9 a9 fe ff ff       	jmp    80100a7c <exec+0x6c>
    end_op();
80100bd3:	e8 38 20 00 00       	call   80102c10 <end_op>
    cprintf("exec: fail\n");
80100bd8:	83 ec 0c             	sub    $0xc,%esp
80100bdb:	68 81 80 10 80       	push   $0x80108081
80100be0:	e8 7b fa ff ff       	call   80100660 <cprintf>
    return -1;
80100be5:	83 c4 10             	add    $0x10,%esp
80100be8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100bed:	e9 8a fe ff ff       	jmp    80100a7c <exec+0x6c>
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100bf2:	8d 80 00 e0 ff ff    	lea    -0x2000(%eax),%eax
80100bf8:	83 ec 08             	sub    $0x8,%esp
  for(argc = 0; argv[argc]; argc++) {
80100bfb:	31 ff                	xor    %edi,%edi
80100bfd:	89 f3                	mov    %esi,%ebx
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100bff:	50                   	push   %eax
80100c00:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
80100c06:	e8 f5 71 00 00       	call   80107e00 <clearpteu>
  for(argc = 0; argv[argc]; argc++) {
80100c0b:	8b 45 0c             	mov    0xc(%ebp),%eax
80100c0e:	83 c4 10             	add    $0x10,%esp
80100c11:	8d 95 58 ff ff ff    	lea    -0xa8(%ebp),%edx
80100c17:	8b 00                	mov    (%eax),%eax
80100c19:	85 c0                	test   %eax,%eax
80100c1b:	74 70                	je     80100c8d <exec+0x27d>
80100c1d:	89 b5 ec fe ff ff    	mov    %esi,-0x114(%ebp)
80100c23:	8b b5 f0 fe ff ff    	mov    -0x110(%ebp),%esi
80100c29:	eb 0a                	jmp    80100c35 <exec+0x225>
80100c2b:	90                   	nop
80100c2c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(argc >= MAXARG)
80100c30:	83 ff 20             	cmp    $0x20,%edi
80100c33:	74 83                	je     80100bb8 <exec+0x1a8>
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100c35:	83 ec 0c             	sub    $0xc,%esp
80100c38:	50                   	push   %eax
80100c39:	e8 f2 49 00 00       	call   80105630 <strlen>
80100c3e:	f7 d0                	not    %eax
80100c40:	01 c3                	add    %eax,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100c42:	8b 45 0c             	mov    0xc(%ebp),%eax
80100c45:	5a                   	pop    %edx
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100c46:	83 e3 fc             	and    $0xfffffffc,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100c49:	ff 34 b8             	pushl  (%eax,%edi,4)
80100c4c:	e8 df 49 00 00       	call   80105630 <strlen>
80100c51:	83 c0 01             	add    $0x1,%eax
80100c54:	50                   	push   %eax
80100c55:	8b 45 0c             	mov    0xc(%ebp),%eax
80100c58:	ff 34 b8             	pushl  (%eax,%edi,4)
80100c5b:	53                   	push   %ebx
80100c5c:	56                   	push   %esi
80100c5d:	e8 fe 72 00 00       	call   80107f60 <copyout>
80100c62:	83 c4 20             	add    $0x20,%esp
80100c65:	85 c0                	test   %eax,%eax
80100c67:	0f 88 4b ff ff ff    	js     80100bb8 <exec+0x1a8>
  for(argc = 0; argv[argc]; argc++) {
80100c6d:	8b 45 0c             	mov    0xc(%ebp),%eax
    ustack[3+argc] = sp;
80100c70:	89 9c bd 64 ff ff ff 	mov    %ebx,-0x9c(%ebp,%edi,4)
  for(argc = 0; argv[argc]; argc++) {
80100c77:	83 c7 01             	add    $0x1,%edi
    ustack[3+argc] = sp;
80100c7a:	8d 95 58 ff ff ff    	lea    -0xa8(%ebp),%edx
  for(argc = 0; argv[argc]; argc++) {
80100c80:	8b 04 b8             	mov    (%eax,%edi,4),%eax
80100c83:	85 c0                	test   %eax,%eax
80100c85:	75 a9                	jne    80100c30 <exec+0x220>
80100c87:	8b b5 ec fe ff ff    	mov    -0x114(%ebp),%esi
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100c8d:	8d 04 bd 04 00 00 00 	lea    0x4(,%edi,4),%eax
80100c94:	89 d9                	mov    %ebx,%ecx
  ustack[3+argc] = 0;
80100c96:	c7 84 bd 64 ff ff ff 	movl   $0x0,-0x9c(%ebp,%edi,4)
80100c9d:	00 00 00 00 
  ustack[0] = 0xffffffff;  // fake return PC
80100ca1:	c7 85 58 ff ff ff ff 	movl   $0xffffffff,-0xa8(%ebp)
80100ca8:	ff ff ff 
  ustack[1] = argc;
80100cab:	89 bd 5c ff ff ff    	mov    %edi,-0xa4(%ebp)
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100cb1:	29 c1                	sub    %eax,%ecx
  sp -= (3+argc+1) * 4;
80100cb3:	83 c0 0c             	add    $0xc,%eax
80100cb6:	29 c3                	sub    %eax,%ebx
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100cb8:	50                   	push   %eax
80100cb9:	52                   	push   %edx
80100cba:	53                   	push   %ebx
80100cbb:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100cc1:	89 8d 60 ff ff ff    	mov    %ecx,-0xa0(%ebp)
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100cc7:	e8 94 72 00 00       	call   80107f60 <copyout>
80100ccc:	83 c4 10             	add    $0x10,%esp
80100ccf:	85 c0                	test   %eax,%eax
80100cd1:	0f 88 e1 fe ff ff    	js     80100bb8 <exec+0x1a8>
  for(last=s=path; *s; s++)
80100cd7:	8b 45 08             	mov    0x8(%ebp),%eax
80100cda:	0f b6 00             	movzbl (%eax),%eax
80100cdd:	84 c0                	test   %al,%al
80100cdf:	74 17                	je     80100cf8 <exec+0x2e8>
80100ce1:	8b 55 08             	mov    0x8(%ebp),%edx
80100ce4:	89 d1                	mov    %edx,%ecx
80100ce6:	83 c1 01             	add    $0x1,%ecx
80100ce9:	3c 2f                	cmp    $0x2f,%al
80100ceb:	0f b6 01             	movzbl (%ecx),%eax
80100cee:	0f 44 d1             	cmove  %ecx,%edx
80100cf1:	84 c0                	test   %al,%al
80100cf3:	75 f1                	jne    80100ce6 <exec+0x2d6>
80100cf5:	89 55 08             	mov    %edx,0x8(%ebp)
  safestrcpy(curproc->name, last, sizeof(curproc->name));
80100cf8:	8b bd f4 fe ff ff    	mov    -0x10c(%ebp),%edi
80100cfe:	50                   	push   %eax
80100cff:	6a 10                	push   $0x10
80100d01:	ff 75 08             	pushl  0x8(%ebp)
80100d04:	89 f8                	mov    %edi,%eax
80100d06:	83 c0 6c             	add    $0x6c,%eax
80100d09:	50                   	push   %eax
80100d0a:	e8 e1 48 00 00       	call   801055f0 <safestrcpy>
  curproc->pgdir = pgdir;
80100d0f:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  oldpgdir = curproc->pgdir;
80100d15:	89 f9                	mov    %edi,%ecx
80100d17:	8b 7f 04             	mov    0x4(%edi),%edi
  curproc->tf->eip = elf.entry;  // main
80100d1a:	8b 41 18             	mov    0x18(%ecx),%eax
  curproc->sz = sz;
80100d1d:	89 31                	mov    %esi,(%ecx)
  curproc->pgdir = pgdir;
80100d1f:	89 51 04             	mov    %edx,0x4(%ecx)
  curproc->tf->eip = elf.entry;  // main
80100d22:	8b 95 3c ff ff ff    	mov    -0xc4(%ebp),%edx
80100d28:	89 50 38             	mov    %edx,0x38(%eax)
  curproc->tf->esp = sp;
80100d2b:	8b 41 18             	mov    0x18(%ecx),%eax
80100d2e:	89 58 44             	mov    %ebx,0x44(%eax)
  switchuvm(curproc);
80100d31:	89 0c 24             	mov    %ecx,(%esp)
80100d34:	e8 f7 6b 00 00       	call   80107930 <switchuvm>
  freevm(oldpgdir);
80100d39:	89 3c 24             	mov    %edi,(%esp)
80100d3c:	e8 9f 6f 00 00       	call   80107ce0 <freevm>
  return 0;
80100d41:	83 c4 10             	add    $0x10,%esp
80100d44:	31 c0                	xor    %eax,%eax
80100d46:	e9 31 fd ff ff       	jmp    80100a7c <exec+0x6c>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100d4b:	be 00 20 00 00       	mov    $0x2000,%esi
80100d50:	e9 3c fe ff ff       	jmp    80100b91 <exec+0x181>
80100d55:	66 90                	xchg   %ax,%ax
80100d57:	66 90                	xchg   %ax,%ax
80100d59:	66 90                	xchg   %ax,%ax
80100d5b:	66 90                	xchg   %ax,%ax
80100d5d:	66 90                	xchg   %ax,%ax
80100d5f:	90                   	nop

80100d60 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
80100d60:	55                   	push   %ebp
80100d61:	89 e5                	mov    %esp,%ebp
80100d63:	83 ec 10             	sub    $0x10,%esp
  initlock(&ftable.lock, "ftable");
80100d66:	68 8d 80 10 80       	push   $0x8010808d
80100d6b:	68 20 10 11 80       	push   $0x80111020
80100d70:	e8 4b 44 00 00       	call   801051c0 <initlock>
}
80100d75:	83 c4 10             	add    $0x10,%esp
80100d78:	c9                   	leave  
80100d79:	c3                   	ret    
80100d7a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80100d80 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
80100d80:	55                   	push   %ebp
80100d81:	89 e5                	mov    %esp,%ebp
80100d83:	53                   	push   %ebx
  struct file *f;

  acquire(&ftable.lock);
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100d84:	bb 54 10 11 80       	mov    $0x80111054,%ebx
{
80100d89:	83 ec 10             	sub    $0x10,%esp
  acquire(&ftable.lock);
80100d8c:	68 20 10 11 80       	push   $0x80111020
80100d91:	e8 6a 45 00 00       	call   80105300 <acquire>
80100d96:	83 c4 10             	add    $0x10,%esp
80100d99:	eb 10                	jmp    80100dab <filealloc+0x2b>
80100d9b:	90                   	nop
80100d9c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100da0:	83 c3 18             	add    $0x18,%ebx
80100da3:	81 fb b4 19 11 80    	cmp    $0x801119b4,%ebx
80100da9:	73 25                	jae    80100dd0 <filealloc+0x50>
    if(f->ref == 0){
80100dab:	8b 43 04             	mov    0x4(%ebx),%eax
80100dae:	85 c0                	test   %eax,%eax
80100db0:	75 ee                	jne    80100da0 <filealloc+0x20>
      f->ref = 1;
      release(&ftable.lock);
80100db2:	83 ec 0c             	sub    $0xc,%esp
      f->ref = 1;
80100db5:	c7 43 04 01 00 00 00 	movl   $0x1,0x4(%ebx)
      release(&ftable.lock);
80100dbc:	68 20 10 11 80       	push   $0x80111020
80100dc1:	e8 fa 45 00 00       	call   801053c0 <release>
      return f;
    }
  }
  release(&ftable.lock);
  return 0;
}
80100dc6:	89 d8                	mov    %ebx,%eax
      return f;
80100dc8:	83 c4 10             	add    $0x10,%esp
}
80100dcb:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100dce:	c9                   	leave  
80100dcf:	c3                   	ret    
  release(&ftable.lock);
80100dd0:	83 ec 0c             	sub    $0xc,%esp
  return 0;
80100dd3:	31 db                	xor    %ebx,%ebx
  release(&ftable.lock);
80100dd5:	68 20 10 11 80       	push   $0x80111020
80100dda:	e8 e1 45 00 00       	call   801053c0 <release>
}
80100ddf:	89 d8                	mov    %ebx,%eax
  return 0;
80100de1:	83 c4 10             	add    $0x10,%esp
}
80100de4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100de7:	c9                   	leave  
80100de8:	c3                   	ret    
80100de9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80100df0 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
80100df0:	55                   	push   %ebp
80100df1:	89 e5                	mov    %esp,%ebp
80100df3:	53                   	push   %ebx
80100df4:	83 ec 10             	sub    $0x10,%esp
80100df7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ftable.lock);
80100dfa:	68 20 10 11 80       	push   $0x80111020
80100dff:	e8 fc 44 00 00       	call   80105300 <acquire>
  if(f->ref < 1)
80100e04:	8b 43 04             	mov    0x4(%ebx),%eax
80100e07:	83 c4 10             	add    $0x10,%esp
80100e0a:	85 c0                	test   %eax,%eax
80100e0c:	7e 1a                	jle    80100e28 <filedup+0x38>
    panic("filedup");
  f->ref++;
80100e0e:	83 c0 01             	add    $0x1,%eax
  release(&ftable.lock);
80100e11:	83 ec 0c             	sub    $0xc,%esp
  f->ref++;
80100e14:	89 43 04             	mov    %eax,0x4(%ebx)
  release(&ftable.lock);
80100e17:	68 20 10 11 80       	push   $0x80111020
80100e1c:	e8 9f 45 00 00       	call   801053c0 <release>
  return f;
}
80100e21:	89 d8                	mov    %ebx,%eax
80100e23:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100e26:	c9                   	leave  
80100e27:	c3                   	ret    
    panic("filedup");
80100e28:	83 ec 0c             	sub    $0xc,%esp
80100e2b:	68 94 80 10 80       	push   $0x80108094
80100e30:	e8 5b f5 ff ff       	call   80100390 <panic>
80100e35:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100e39:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80100e40 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
80100e40:	55                   	push   %ebp
80100e41:	89 e5                	mov    %esp,%ebp
80100e43:	57                   	push   %edi
80100e44:	56                   	push   %esi
80100e45:	53                   	push   %ebx
80100e46:	83 ec 28             	sub    $0x28,%esp
80100e49:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct file ff;

  acquire(&ftable.lock);
80100e4c:	68 20 10 11 80       	push   $0x80111020
80100e51:	e8 aa 44 00 00       	call   80105300 <acquire>
  if(f->ref < 1)
80100e56:	8b 43 04             	mov    0x4(%ebx),%eax
80100e59:	83 c4 10             	add    $0x10,%esp
80100e5c:	85 c0                	test   %eax,%eax
80100e5e:	0f 8e 9b 00 00 00    	jle    80100eff <fileclose+0xbf>
    panic("fileclose");
  if(--f->ref > 0){
80100e64:	83 e8 01             	sub    $0x1,%eax
80100e67:	85 c0                	test   %eax,%eax
80100e69:	89 43 04             	mov    %eax,0x4(%ebx)
80100e6c:	74 1a                	je     80100e88 <fileclose+0x48>
    release(&ftable.lock);
80100e6e:	c7 45 08 20 10 11 80 	movl   $0x80111020,0x8(%ebp)
  else if(ff.type == FD_INODE){
    begin_op();
    iput(ff.ip);
    end_op();
  }
}
80100e75:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100e78:	5b                   	pop    %ebx
80100e79:	5e                   	pop    %esi
80100e7a:	5f                   	pop    %edi
80100e7b:	5d                   	pop    %ebp
    release(&ftable.lock);
80100e7c:	e9 3f 45 00 00       	jmp    801053c0 <release>
80100e81:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  ff = *f;
80100e88:	0f b6 43 09          	movzbl 0x9(%ebx),%eax
80100e8c:	8b 3b                	mov    (%ebx),%edi
  release(&ftable.lock);
80100e8e:	83 ec 0c             	sub    $0xc,%esp
  ff = *f;
80100e91:	8b 73 0c             	mov    0xc(%ebx),%esi
  f->type = FD_NONE;
80100e94:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  ff = *f;
80100e9a:	88 45 e7             	mov    %al,-0x19(%ebp)
80100e9d:	8b 43 10             	mov    0x10(%ebx),%eax
  release(&ftable.lock);
80100ea0:	68 20 10 11 80       	push   $0x80111020
  ff = *f;
80100ea5:	89 45 e0             	mov    %eax,-0x20(%ebp)
  release(&ftable.lock);
80100ea8:	e8 13 45 00 00       	call   801053c0 <release>
  if(ff.type == FD_PIPE)
80100ead:	83 c4 10             	add    $0x10,%esp
80100eb0:	83 ff 01             	cmp    $0x1,%edi
80100eb3:	74 13                	je     80100ec8 <fileclose+0x88>
  else if(ff.type == FD_INODE){
80100eb5:	83 ff 02             	cmp    $0x2,%edi
80100eb8:	74 26                	je     80100ee0 <fileclose+0xa0>
}
80100eba:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100ebd:	5b                   	pop    %ebx
80100ebe:	5e                   	pop    %esi
80100ebf:	5f                   	pop    %edi
80100ec0:	5d                   	pop    %ebp
80100ec1:	c3                   	ret    
80100ec2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    pipeclose(ff.pipe, ff.writable);
80100ec8:	0f be 5d e7          	movsbl -0x19(%ebp),%ebx
80100ecc:	83 ec 08             	sub    $0x8,%esp
80100ecf:	53                   	push   %ebx
80100ed0:	56                   	push   %esi
80100ed1:	e8 7a 24 00 00       	call   80103350 <pipeclose>
80100ed6:	83 c4 10             	add    $0x10,%esp
80100ed9:	eb df                	jmp    80100eba <fileclose+0x7a>
80100edb:	90                   	nop
80100edc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    begin_op();
80100ee0:	e8 bb 1c 00 00       	call   80102ba0 <begin_op>
    iput(ff.ip);
80100ee5:	83 ec 0c             	sub    $0xc,%esp
80100ee8:	ff 75 e0             	pushl  -0x20(%ebp)
80100eeb:	e8 c0 08 00 00       	call   801017b0 <iput>
    end_op();
80100ef0:	83 c4 10             	add    $0x10,%esp
}
80100ef3:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100ef6:	5b                   	pop    %ebx
80100ef7:	5e                   	pop    %esi
80100ef8:	5f                   	pop    %edi
80100ef9:	5d                   	pop    %ebp
    end_op();
80100efa:	e9 11 1d 00 00       	jmp    80102c10 <end_op>
    panic("fileclose");
80100eff:	83 ec 0c             	sub    $0xc,%esp
80100f02:	68 9c 80 10 80       	push   $0x8010809c
80100f07:	e8 84 f4 ff ff       	call   80100390 <panic>
80100f0c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80100f10 <filestat>:

// Get metadata about file f.
int
filestat(struct file *f, struct stat *st)
{
80100f10:	55                   	push   %ebp
80100f11:	89 e5                	mov    %esp,%ebp
80100f13:	53                   	push   %ebx
80100f14:	83 ec 04             	sub    $0x4,%esp
80100f17:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(f->type == FD_INODE){
80100f1a:	83 3b 02             	cmpl   $0x2,(%ebx)
80100f1d:	75 31                	jne    80100f50 <filestat+0x40>
    ilock(f->ip);
80100f1f:	83 ec 0c             	sub    $0xc,%esp
80100f22:	ff 73 10             	pushl  0x10(%ebx)
80100f25:	e8 56 07 00 00       	call   80101680 <ilock>
    stati(f->ip, st);
80100f2a:	58                   	pop    %eax
80100f2b:	5a                   	pop    %edx
80100f2c:	ff 75 0c             	pushl  0xc(%ebp)
80100f2f:	ff 73 10             	pushl  0x10(%ebx)
80100f32:	e8 f9 09 00 00       	call   80101930 <stati>
    iunlock(f->ip);
80100f37:	59                   	pop    %ecx
80100f38:	ff 73 10             	pushl  0x10(%ebx)
80100f3b:	e8 20 08 00 00       	call   80101760 <iunlock>
    return 0;
80100f40:	83 c4 10             	add    $0x10,%esp
80100f43:	31 c0                	xor    %eax,%eax
  }
  return -1;
}
80100f45:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100f48:	c9                   	leave  
80100f49:	c3                   	ret    
80100f4a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  return -1;
80100f50:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100f55:	eb ee                	jmp    80100f45 <filestat+0x35>
80100f57:	89 f6                	mov    %esi,%esi
80100f59:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80100f60 <fileread>:

// Read from file f.
int
fileread(struct file *f, char *addr, int n)
{
80100f60:	55                   	push   %ebp
80100f61:	89 e5                	mov    %esp,%ebp
80100f63:	57                   	push   %edi
80100f64:	56                   	push   %esi
80100f65:	53                   	push   %ebx
80100f66:	83 ec 0c             	sub    $0xc,%esp
80100f69:	8b 5d 08             	mov    0x8(%ebp),%ebx
80100f6c:	8b 75 0c             	mov    0xc(%ebp),%esi
80100f6f:	8b 7d 10             	mov    0x10(%ebp),%edi
  int r;

  if(f->readable == 0)
80100f72:	80 7b 08 00          	cmpb   $0x0,0x8(%ebx)
80100f76:	74 60                	je     80100fd8 <fileread+0x78>
    return -1;
  if(f->type == FD_PIPE)
80100f78:	8b 03                	mov    (%ebx),%eax
80100f7a:	83 f8 01             	cmp    $0x1,%eax
80100f7d:	74 41                	je     80100fc0 <fileread+0x60>
    return piperead(f->pipe, addr, n);
  if(f->type == FD_INODE){
80100f7f:	83 f8 02             	cmp    $0x2,%eax
80100f82:	75 5b                	jne    80100fdf <fileread+0x7f>
    ilock(f->ip);
80100f84:	83 ec 0c             	sub    $0xc,%esp
80100f87:	ff 73 10             	pushl  0x10(%ebx)
80100f8a:	e8 f1 06 00 00       	call   80101680 <ilock>
    if((r = readi(f->ip, addr, f->off, n)) > 0)
80100f8f:	57                   	push   %edi
80100f90:	ff 73 14             	pushl  0x14(%ebx)
80100f93:	56                   	push   %esi
80100f94:	ff 73 10             	pushl  0x10(%ebx)
80100f97:	e8 c4 09 00 00       	call   80101960 <readi>
80100f9c:	83 c4 20             	add    $0x20,%esp
80100f9f:	85 c0                	test   %eax,%eax
80100fa1:	89 c6                	mov    %eax,%esi
80100fa3:	7e 03                	jle    80100fa8 <fileread+0x48>
      f->off += r;
80100fa5:	01 43 14             	add    %eax,0x14(%ebx)
    iunlock(f->ip);
80100fa8:	83 ec 0c             	sub    $0xc,%esp
80100fab:	ff 73 10             	pushl  0x10(%ebx)
80100fae:	e8 ad 07 00 00       	call   80101760 <iunlock>
    return r;
80100fb3:	83 c4 10             	add    $0x10,%esp
  }
  panic("fileread");
}
80100fb6:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100fb9:	89 f0                	mov    %esi,%eax
80100fbb:	5b                   	pop    %ebx
80100fbc:	5e                   	pop    %esi
80100fbd:	5f                   	pop    %edi
80100fbe:	5d                   	pop    %ebp
80100fbf:	c3                   	ret    
    return piperead(f->pipe, addr, n);
80100fc0:	8b 43 0c             	mov    0xc(%ebx),%eax
80100fc3:	89 45 08             	mov    %eax,0x8(%ebp)
}
80100fc6:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100fc9:	5b                   	pop    %ebx
80100fca:	5e                   	pop    %esi
80100fcb:	5f                   	pop    %edi
80100fcc:	5d                   	pop    %ebp
    return piperead(f->pipe, addr, n);
80100fcd:	e9 2e 25 00 00       	jmp    80103500 <piperead>
80100fd2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
80100fd8:	be ff ff ff ff       	mov    $0xffffffff,%esi
80100fdd:	eb d7                	jmp    80100fb6 <fileread+0x56>
  panic("fileread");
80100fdf:	83 ec 0c             	sub    $0xc,%esp
80100fe2:	68 a6 80 10 80       	push   $0x801080a6
80100fe7:	e8 a4 f3 ff ff       	call   80100390 <panic>
80100fec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80100ff0 <filewrite>:

//PAGEBREAK!
// Write to file f.
int
filewrite(struct file *f, char *addr, int n)
{
80100ff0:	55                   	push   %ebp
80100ff1:	89 e5                	mov    %esp,%ebp
80100ff3:	57                   	push   %edi
80100ff4:	56                   	push   %esi
80100ff5:	53                   	push   %ebx
80100ff6:	83 ec 1c             	sub    $0x1c,%esp
80100ff9:	8b 75 08             	mov    0x8(%ebp),%esi
80100ffc:	8b 45 0c             	mov    0xc(%ebp),%eax
  int r;

  if(f->writable == 0)
80100fff:	80 7e 09 00          	cmpb   $0x0,0x9(%esi)
{
80101003:	89 45 dc             	mov    %eax,-0x24(%ebp)
80101006:	8b 45 10             	mov    0x10(%ebp),%eax
80101009:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(f->writable == 0)
8010100c:	0f 84 aa 00 00 00    	je     801010bc <filewrite+0xcc>
    return -1;
  if(f->type == FD_PIPE)
80101012:	8b 06                	mov    (%esi),%eax
80101014:	83 f8 01             	cmp    $0x1,%eax
80101017:	0f 84 c3 00 00 00    	je     801010e0 <filewrite+0xf0>
    return pipewrite(f->pipe, addr, n);
  if(f->type == FD_INODE){
8010101d:	83 f8 02             	cmp    $0x2,%eax
80101020:	0f 85 d9 00 00 00    	jne    801010ff <filewrite+0x10f>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * 512;
    int i = 0;
    while(i < n){
80101026:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    int i = 0;
80101029:	31 ff                	xor    %edi,%edi
    while(i < n){
8010102b:	85 c0                	test   %eax,%eax
8010102d:	7f 34                	jg     80101063 <filewrite+0x73>
8010102f:	e9 9c 00 00 00       	jmp    801010d0 <filewrite+0xe0>
80101034:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        n1 = max;

      begin_op();
      ilock(f->ip);
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
        f->off += r;
80101038:	01 46 14             	add    %eax,0x14(%esi)
      iunlock(f->ip);
8010103b:	83 ec 0c             	sub    $0xc,%esp
8010103e:	ff 76 10             	pushl  0x10(%esi)
        f->off += r;
80101041:	89 45 e0             	mov    %eax,-0x20(%ebp)
      iunlock(f->ip);
80101044:	e8 17 07 00 00       	call   80101760 <iunlock>
      end_op();
80101049:	e8 c2 1b 00 00       	call   80102c10 <end_op>
8010104e:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101051:	83 c4 10             	add    $0x10,%esp

      if(r < 0)
        break;
      if(r != n1)
80101054:	39 c3                	cmp    %eax,%ebx
80101056:	0f 85 96 00 00 00    	jne    801010f2 <filewrite+0x102>
        panic("short filewrite");
      i += r;
8010105c:	01 df                	add    %ebx,%edi
    while(i < n){
8010105e:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
80101061:	7e 6d                	jle    801010d0 <filewrite+0xe0>
      int n1 = n - i;
80101063:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80101066:	b8 00 06 00 00       	mov    $0x600,%eax
8010106b:	29 fb                	sub    %edi,%ebx
8010106d:	81 fb 00 06 00 00    	cmp    $0x600,%ebx
80101073:	0f 4f d8             	cmovg  %eax,%ebx
      begin_op();
80101076:	e8 25 1b 00 00       	call   80102ba0 <begin_op>
      ilock(f->ip);
8010107b:	83 ec 0c             	sub    $0xc,%esp
8010107e:	ff 76 10             	pushl  0x10(%esi)
80101081:	e8 fa 05 00 00       	call   80101680 <ilock>
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
80101086:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101089:	53                   	push   %ebx
8010108a:	ff 76 14             	pushl  0x14(%esi)
8010108d:	01 f8                	add    %edi,%eax
8010108f:	50                   	push   %eax
80101090:	ff 76 10             	pushl  0x10(%esi)
80101093:	e8 c8 09 00 00       	call   80101a60 <writei>
80101098:	83 c4 20             	add    $0x20,%esp
8010109b:	85 c0                	test   %eax,%eax
8010109d:	7f 99                	jg     80101038 <filewrite+0x48>
      iunlock(f->ip);
8010109f:	83 ec 0c             	sub    $0xc,%esp
801010a2:	ff 76 10             	pushl  0x10(%esi)
801010a5:	89 45 e0             	mov    %eax,-0x20(%ebp)
801010a8:	e8 b3 06 00 00       	call   80101760 <iunlock>
      end_op();
801010ad:	e8 5e 1b 00 00       	call   80102c10 <end_op>
      if(r < 0)
801010b2:	8b 45 e0             	mov    -0x20(%ebp),%eax
801010b5:	83 c4 10             	add    $0x10,%esp
801010b8:	85 c0                	test   %eax,%eax
801010ba:	74 98                	je     80101054 <filewrite+0x64>
    }
    return i == n ? n : -1;
  }
  panic("filewrite");
}
801010bc:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return -1;
801010bf:	bf ff ff ff ff       	mov    $0xffffffff,%edi
}
801010c4:	89 f8                	mov    %edi,%eax
801010c6:	5b                   	pop    %ebx
801010c7:	5e                   	pop    %esi
801010c8:	5f                   	pop    %edi
801010c9:	5d                   	pop    %ebp
801010ca:	c3                   	ret    
801010cb:	90                   	nop
801010cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return i == n ? n : -1;
801010d0:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
801010d3:	75 e7                	jne    801010bc <filewrite+0xcc>
}
801010d5:	8d 65 f4             	lea    -0xc(%ebp),%esp
801010d8:	89 f8                	mov    %edi,%eax
801010da:	5b                   	pop    %ebx
801010db:	5e                   	pop    %esi
801010dc:	5f                   	pop    %edi
801010dd:	5d                   	pop    %ebp
801010de:	c3                   	ret    
801010df:	90                   	nop
    return pipewrite(f->pipe, addr, n);
801010e0:	8b 46 0c             	mov    0xc(%esi),%eax
801010e3:	89 45 08             	mov    %eax,0x8(%ebp)
}
801010e6:	8d 65 f4             	lea    -0xc(%ebp),%esp
801010e9:	5b                   	pop    %ebx
801010ea:	5e                   	pop    %esi
801010eb:	5f                   	pop    %edi
801010ec:	5d                   	pop    %ebp
    return pipewrite(f->pipe, addr, n);
801010ed:	e9 fe 22 00 00       	jmp    801033f0 <pipewrite>
        panic("short filewrite");
801010f2:	83 ec 0c             	sub    $0xc,%esp
801010f5:	68 af 80 10 80       	push   $0x801080af
801010fa:	e8 91 f2 ff ff       	call   80100390 <panic>
  panic("filewrite");
801010ff:	83 ec 0c             	sub    $0xc,%esp
80101102:	68 b5 80 10 80       	push   $0x801080b5
80101107:	e8 84 f2 ff ff       	call   80100390 <panic>
8010110c:	66 90                	xchg   %ax,%ax
8010110e:	66 90                	xchg   %ax,%ax

80101110 <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
80101110:	55                   	push   %ebp
80101111:	89 e5                	mov    %esp,%ebp
80101113:	56                   	push   %esi
80101114:	53                   	push   %ebx
80101115:	89 d3                	mov    %edx,%ebx
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
80101117:	c1 ea 0c             	shr    $0xc,%edx
8010111a:	03 15 38 1a 11 80    	add    0x80111a38,%edx
80101120:	83 ec 08             	sub    $0x8,%esp
80101123:	52                   	push   %edx
80101124:	50                   	push   %eax
80101125:	e8 a6 ef ff ff       	call   801000d0 <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
8010112a:	89 d9                	mov    %ebx,%ecx
  if((bp->data[bi/8] & m) == 0)
8010112c:	c1 fb 03             	sar    $0x3,%ebx
  m = 1 << (bi % 8);
8010112f:	ba 01 00 00 00       	mov    $0x1,%edx
80101134:	83 e1 07             	and    $0x7,%ecx
  if((bp->data[bi/8] & m) == 0)
80101137:	81 e3 ff 01 00 00    	and    $0x1ff,%ebx
8010113d:	83 c4 10             	add    $0x10,%esp
  m = 1 << (bi % 8);
80101140:	d3 e2                	shl    %cl,%edx
  if((bp->data[bi/8] & m) == 0)
80101142:	0f b6 4c 18 5c       	movzbl 0x5c(%eax,%ebx,1),%ecx
80101147:	85 d1                	test   %edx,%ecx
80101149:	74 25                	je     80101170 <bfree+0x60>
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
8010114b:	f7 d2                	not    %edx
8010114d:	89 c6                	mov    %eax,%esi
  log_write(bp);
8010114f:	83 ec 0c             	sub    $0xc,%esp
  bp->data[bi/8] &= ~m;
80101152:	21 ca                	and    %ecx,%edx
80101154:	88 54 1e 5c          	mov    %dl,0x5c(%esi,%ebx,1)
  log_write(bp);
80101158:	56                   	push   %esi
80101159:	e8 12 1c 00 00       	call   80102d70 <log_write>
  brelse(bp);
8010115e:	89 34 24             	mov    %esi,(%esp)
80101161:	e8 7a f0 ff ff       	call   801001e0 <brelse>
}
80101166:	83 c4 10             	add    $0x10,%esp
80101169:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010116c:	5b                   	pop    %ebx
8010116d:	5e                   	pop    %esi
8010116e:	5d                   	pop    %ebp
8010116f:	c3                   	ret    
    panic("freeing free block");
80101170:	83 ec 0c             	sub    $0xc,%esp
80101173:	68 bf 80 10 80       	push   $0x801080bf
80101178:	e8 13 f2 ff ff       	call   80100390 <panic>
8010117d:	8d 76 00             	lea    0x0(%esi),%esi

80101180 <balloc>:
{
80101180:	55                   	push   %ebp
80101181:	89 e5                	mov    %esp,%ebp
80101183:	57                   	push   %edi
80101184:	56                   	push   %esi
80101185:	53                   	push   %ebx
80101186:	83 ec 1c             	sub    $0x1c,%esp
  for(b = 0; b < sb.size; b += BPB){
80101189:	8b 0d 20 1a 11 80    	mov    0x80111a20,%ecx
{
8010118f:	89 45 d8             	mov    %eax,-0x28(%ebp)
  for(b = 0; b < sb.size; b += BPB){
80101192:	85 c9                	test   %ecx,%ecx
80101194:	0f 84 87 00 00 00    	je     80101221 <balloc+0xa1>
8010119a:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
    bp = bread(dev, BBLOCK(b, sb));
801011a1:	8b 75 dc             	mov    -0x24(%ebp),%esi
801011a4:	83 ec 08             	sub    $0x8,%esp
801011a7:	89 f0                	mov    %esi,%eax
801011a9:	c1 f8 0c             	sar    $0xc,%eax
801011ac:	03 05 38 1a 11 80    	add    0x80111a38,%eax
801011b2:	50                   	push   %eax
801011b3:	ff 75 d8             	pushl  -0x28(%ebp)
801011b6:	e8 15 ef ff ff       	call   801000d0 <bread>
801011bb:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
801011be:	a1 20 1a 11 80       	mov    0x80111a20,%eax
801011c3:	83 c4 10             	add    $0x10,%esp
801011c6:	89 45 e0             	mov    %eax,-0x20(%ebp)
801011c9:	31 c0                	xor    %eax,%eax
801011cb:	eb 2f                	jmp    801011fc <balloc+0x7c>
801011cd:	8d 76 00             	lea    0x0(%esi),%esi
      m = 1 << (bi % 8);
801011d0:	89 c1                	mov    %eax,%ecx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
801011d2:	8b 55 e4             	mov    -0x1c(%ebp),%edx
      m = 1 << (bi % 8);
801011d5:	bb 01 00 00 00       	mov    $0x1,%ebx
801011da:	83 e1 07             	and    $0x7,%ecx
801011dd:	d3 e3                	shl    %cl,%ebx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
801011df:	89 c1                	mov    %eax,%ecx
801011e1:	c1 f9 03             	sar    $0x3,%ecx
801011e4:	0f b6 7c 0a 5c       	movzbl 0x5c(%edx,%ecx,1),%edi
801011e9:	85 df                	test   %ebx,%edi
801011eb:	89 fa                	mov    %edi,%edx
801011ed:	74 41                	je     80101230 <balloc+0xb0>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
801011ef:	83 c0 01             	add    $0x1,%eax
801011f2:	83 c6 01             	add    $0x1,%esi
801011f5:	3d 00 10 00 00       	cmp    $0x1000,%eax
801011fa:	74 05                	je     80101201 <balloc+0x81>
801011fc:	39 75 e0             	cmp    %esi,-0x20(%ebp)
801011ff:	77 cf                	ja     801011d0 <balloc+0x50>
    brelse(bp);
80101201:	83 ec 0c             	sub    $0xc,%esp
80101204:	ff 75 e4             	pushl  -0x1c(%ebp)
80101207:	e8 d4 ef ff ff       	call   801001e0 <brelse>
  for(b = 0; b < sb.size; b += BPB){
8010120c:	81 45 dc 00 10 00 00 	addl   $0x1000,-0x24(%ebp)
80101213:	83 c4 10             	add    $0x10,%esp
80101216:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101219:	39 05 20 1a 11 80    	cmp    %eax,0x80111a20
8010121f:	77 80                	ja     801011a1 <balloc+0x21>
  panic("balloc: out of blocks");
80101221:	83 ec 0c             	sub    $0xc,%esp
80101224:	68 d2 80 10 80       	push   $0x801080d2
80101229:	e8 62 f1 ff ff       	call   80100390 <panic>
8010122e:	66 90                	xchg   %ax,%ax
        bp->data[bi/8] |= m;  // Mark block in use.
80101230:	8b 7d e4             	mov    -0x1c(%ebp),%edi
        log_write(bp);
80101233:	83 ec 0c             	sub    $0xc,%esp
        bp->data[bi/8] |= m;  // Mark block in use.
80101236:	09 da                	or     %ebx,%edx
80101238:	88 54 0f 5c          	mov    %dl,0x5c(%edi,%ecx,1)
        log_write(bp);
8010123c:	57                   	push   %edi
8010123d:	e8 2e 1b 00 00       	call   80102d70 <log_write>
        brelse(bp);
80101242:	89 3c 24             	mov    %edi,(%esp)
80101245:	e8 96 ef ff ff       	call   801001e0 <brelse>
  bp = bread(dev, bno);
8010124a:	58                   	pop    %eax
8010124b:	5a                   	pop    %edx
8010124c:	56                   	push   %esi
8010124d:	ff 75 d8             	pushl  -0x28(%ebp)
80101250:	e8 7b ee ff ff       	call   801000d0 <bread>
80101255:	89 c3                	mov    %eax,%ebx
  memset(bp->data, 0, BSIZE);
80101257:	8d 40 5c             	lea    0x5c(%eax),%eax
8010125a:	83 c4 0c             	add    $0xc,%esp
8010125d:	68 00 02 00 00       	push   $0x200
80101262:	6a 00                	push   $0x0
80101264:	50                   	push   %eax
80101265:	e8 a6 41 00 00       	call   80105410 <memset>
  log_write(bp);
8010126a:	89 1c 24             	mov    %ebx,(%esp)
8010126d:	e8 fe 1a 00 00       	call   80102d70 <log_write>
  brelse(bp);
80101272:	89 1c 24             	mov    %ebx,(%esp)
80101275:	e8 66 ef ff ff       	call   801001e0 <brelse>
}
8010127a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010127d:	89 f0                	mov    %esi,%eax
8010127f:	5b                   	pop    %ebx
80101280:	5e                   	pop    %esi
80101281:	5f                   	pop    %edi
80101282:	5d                   	pop    %ebp
80101283:	c3                   	ret    
80101284:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010128a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80101290 <iget>:
// Find the inode with number inum on device dev
// and return the in-memory copy. Does not lock
// the inode and does not read it from disk.
static struct inode*
iget(uint dev, uint inum)
{
80101290:	55                   	push   %ebp
80101291:	89 e5                	mov    %esp,%ebp
80101293:	57                   	push   %edi
80101294:	56                   	push   %esi
80101295:	53                   	push   %ebx
80101296:	89 c7                	mov    %eax,%edi
  struct inode *ip, *empty;

  acquire(&icache.lock);

  // Is the inode already cached?
  empty = 0;
80101298:	31 f6                	xor    %esi,%esi
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
8010129a:	bb 74 1a 11 80       	mov    $0x80111a74,%ebx
{
8010129f:	83 ec 28             	sub    $0x28,%esp
801012a2:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  acquire(&icache.lock);
801012a5:	68 40 1a 11 80       	push   $0x80111a40
801012aa:	e8 51 40 00 00       	call   80105300 <acquire>
801012af:	83 c4 10             	add    $0x10,%esp
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
801012b2:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801012b5:	eb 17                	jmp    801012ce <iget+0x3e>
801012b7:	89 f6                	mov    %esi,%esi
801012b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
801012c0:	81 c3 90 00 00 00    	add    $0x90,%ebx
801012c6:	81 fb 94 36 11 80    	cmp    $0x80113694,%ebx
801012cc:	73 22                	jae    801012f0 <iget+0x60>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
801012ce:	8b 4b 08             	mov    0x8(%ebx),%ecx
801012d1:	85 c9                	test   %ecx,%ecx
801012d3:	7e 04                	jle    801012d9 <iget+0x49>
801012d5:	39 3b                	cmp    %edi,(%ebx)
801012d7:	74 4f                	je     80101328 <iget+0x98>
      ip->ref++;
      release(&icache.lock);
      return ip;
    }
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
801012d9:	85 f6                	test   %esi,%esi
801012db:	75 e3                	jne    801012c0 <iget+0x30>
801012dd:	85 c9                	test   %ecx,%ecx
801012df:	0f 44 f3             	cmove  %ebx,%esi
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
801012e2:	81 c3 90 00 00 00    	add    $0x90,%ebx
801012e8:	81 fb 94 36 11 80    	cmp    $0x80113694,%ebx
801012ee:	72 de                	jb     801012ce <iget+0x3e>
      empty = ip;
  }

  // Recycle an inode cache entry.
  if(empty == 0)
801012f0:	85 f6                	test   %esi,%esi
801012f2:	74 5b                	je     8010134f <iget+0xbf>
  ip = empty;
  ip->dev = dev;
  ip->inum = inum;
  ip->ref = 1;
  ip->valid = 0;
  release(&icache.lock);
801012f4:	83 ec 0c             	sub    $0xc,%esp
  ip->dev = dev;
801012f7:	89 3e                	mov    %edi,(%esi)
  ip->inum = inum;
801012f9:	89 56 04             	mov    %edx,0x4(%esi)
  ip->ref = 1;
801012fc:	c7 46 08 01 00 00 00 	movl   $0x1,0x8(%esi)
  ip->valid = 0;
80101303:	c7 46 4c 00 00 00 00 	movl   $0x0,0x4c(%esi)
  release(&icache.lock);
8010130a:	68 40 1a 11 80       	push   $0x80111a40
8010130f:	e8 ac 40 00 00       	call   801053c0 <release>

  return ip;
80101314:	83 c4 10             	add    $0x10,%esp
}
80101317:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010131a:	89 f0                	mov    %esi,%eax
8010131c:	5b                   	pop    %ebx
8010131d:	5e                   	pop    %esi
8010131e:	5f                   	pop    %edi
8010131f:	5d                   	pop    %ebp
80101320:	c3                   	ret    
80101321:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
80101328:	39 53 04             	cmp    %edx,0x4(%ebx)
8010132b:	75 ac                	jne    801012d9 <iget+0x49>
      release(&icache.lock);
8010132d:	83 ec 0c             	sub    $0xc,%esp
      ip->ref++;
80101330:	83 c1 01             	add    $0x1,%ecx
      return ip;
80101333:	89 de                	mov    %ebx,%esi
      release(&icache.lock);
80101335:	68 40 1a 11 80       	push   $0x80111a40
      ip->ref++;
8010133a:	89 4b 08             	mov    %ecx,0x8(%ebx)
      release(&icache.lock);
8010133d:	e8 7e 40 00 00       	call   801053c0 <release>
      return ip;
80101342:	83 c4 10             	add    $0x10,%esp
}
80101345:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101348:	89 f0                	mov    %esi,%eax
8010134a:	5b                   	pop    %ebx
8010134b:	5e                   	pop    %esi
8010134c:	5f                   	pop    %edi
8010134d:	5d                   	pop    %ebp
8010134e:	c3                   	ret    
    panic("iget: no inodes");
8010134f:	83 ec 0c             	sub    $0xc,%esp
80101352:	68 e8 80 10 80       	push   $0x801080e8
80101357:	e8 34 f0 ff ff       	call   80100390 <panic>
8010135c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101360 <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
80101360:	55                   	push   %ebp
80101361:	89 e5                	mov    %esp,%ebp
80101363:	57                   	push   %edi
80101364:	56                   	push   %esi
80101365:	53                   	push   %ebx
80101366:	89 c6                	mov    %eax,%esi
80101368:	83 ec 1c             	sub    $0x1c,%esp
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
8010136b:	83 fa 0b             	cmp    $0xb,%edx
8010136e:	77 18                	ja     80101388 <bmap+0x28>
80101370:	8d 3c 90             	lea    (%eax,%edx,4),%edi
    if((addr = ip->addrs[bn]) == 0)
80101373:	8b 5f 5c             	mov    0x5c(%edi),%ebx
80101376:	85 db                	test   %ebx,%ebx
80101378:	74 76                	je     801013f0 <bmap+0x90>
    brelse(bp);
    return addr;
  }

  panic("bmap: out of range");
}
8010137a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010137d:	89 d8                	mov    %ebx,%eax
8010137f:	5b                   	pop    %ebx
80101380:	5e                   	pop    %esi
80101381:	5f                   	pop    %edi
80101382:	5d                   	pop    %ebp
80101383:	c3                   	ret    
80101384:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  bn -= NDIRECT;
80101388:	8d 5a f4             	lea    -0xc(%edx),%ebx
  if(bn < NINDIRECT){
8010138b:	83 fb 7f             	cmp    $0x7f,%ebx
8010138e:	0f 87 90 00 00 00    	ja     80101424 <bmap+0xc4>
    if((addr = ip->addrs[NDIRECT]) == 0)
80101394:	8b 90 8c 00 00 00    	mov    0x8c(%eax),%edx
8010139a:	8b 00                	mov    (%eax),%eax
8010139c:	85 d2                	test   %edx,%edx
8010139e:	74 70                	je     80101410 <bmap+0xb0>
    bp = bread(ip->dev, addr);
801013a0:	83 ec 08             	sub    $0x8,%esp
801013a3:	52                   	push   %edx
801013a4:	50                   	push   %eax
801013a5:	e8 26 ed ff ff       	call   801000d0 <bread>
    if((addr = a[bn]) == 0){
801013aa:	8d 54 98 5c          	lea    0x5c(%eax,%ebx,4),%edx
801013ae:	83 c4 10             	add    $0x10,%esp
    bp = bread(ip->dev, addr);
801013b1:	89 c7                	mov    %eax,%edi
    if((addr = a[bn]) == 0){
801013b3:	8b 1a                	mov    (%edx),%ebx
801013b5:	85 db                	test   %ebx,%ebx
801013b7:	75 1d                	jne    801013d6 <bmap+0x76>
      a[bn] = addr = balloc(ip->dev);
801013b9:	8b 06                	mov    (%esi),%eax
801013bb:	89 55 e4             	mov    %edx,-0x1c(%ebp)
801013be:	e8 bd fd ff ff       	call   80101180 <balloc>
801013c3:	8b 55 e4             	mov    -0x1c(%ebp),%edx
      log_write(bp);
801013c6:	83 ec 0c             	sub    $0xc,%esp
      a[bn] = addr = balloc(ip->dev);
801013c9:	89 c3                	mov    %eax,%ebx
801013cb:	89 02                	mov    %eax,(%edx)
      log_write(bp);
801013cd:	57                   	push   %edi
801013ce:	e8 9d 19 00 00       	call   80102d70 <log_write>
801013d3:	83 c4 10             	add    $0x10,%esp
    brelse(bp);
801013d6:	83 ec 0c             	sub    $0xc,%esp
801013d9:	57                   	push   %edi
801013da:	e8 01 ee ff ff       	call   801001e0 <brelse>
801013df:	83 c4 10             	add    $0x10,%esp
}
801013e2:	8d 65 f4             	lea    -0xc(%ebp),%esp
801013e5:	89 d8                	mov    %ebx,%eax
801013e7:	5b                   	pop    %ebx
801013e8:	5e                   	pop    %esi
801013e9:	5f                   	pop    %edi
801013ea:	5d                   	pop    %ebp
801013eb:	c3                   	ret    
801013ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      ip->addrs[bn] = addr = balloc(ip->dev);
801013f0:	8b 00                	mov    (%eax),%eax
801013f2:	e8 89 fd ff ff       	call   80101180 <balloc>
801013f7:	89 47 5c             	mov    %eax,0x5c(%edi)
}
801013fa:	8d 65 f4             	lea    -0xc(%ebp),%esp
      ip->addrs[bn] = addr = balloc(ip->dev);
801013fd:	89 c3                	mov    %eax,%ebx
}
801013ff:	89 d8                	mov    %ebx,%eax
80101401:	5b                   	pop    %ebx
80101402:	5e                   	pop    %esi
80101403:	5f                   	pop    %edi
80101404:	5d                   	pop    %ebp
80101405:	c3                   	ret    
80101406:	8d 76 00             	lea    0x0(%esi),%esi
80101409:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
80101410:	e8 6b fd ff ff       	call   80101180 <balloc>
80101415:	89 c2                	mov    %eax,%edx
80101417:	89 86 8c 00 00 00    	mov    %eax,0x8c(%esi)
8010141d:	8b 06                	mov    (%esi),%eax
8010141f:	e9 7c ff ff ff       	jmp    801013a0 <bmap+0x40>
  panic("bmap: out of range");
80101424:	83 ec 0c             	sub    $0xc,%esp
80101427:	68 f8 80 10 80       	push   $0x801080f8
8010142c:	e8 5f ef ff ff       	call   80100390 <panic>
80101431:	eb 0d                	jmp    80101440 <readsb>
80101433:	90                   	nop
80101434:	90                   	nop
80101435:	90                   	nop
80101436:	90                   	nop
80101437:	90                   	nop
80101438:	90                   	nop
80101439:	90                   	nop
8010143a:	90                   	nop
8010143b:	90                   	nop
8010143c:	90                   	nop
8010143d:	90                   	nop
8010143e:	90                   	nop
8010143f:	90                   	nop

80101440 <readsb>:
{
80101440:	55                   	push   %ebp
80101441:	89 e5                	mov    %esp,%ebp
80101443:	56                   	push   %esi
80101444:	53                   	push   %ebx
80101445:	8b 75 0c             	mov    0xc(%ebp),%esi
  bp = bread(dev, 1);
80101448:	83 ec 08             	sub    $0x8,%esp
8010144b:	6a 01                	push   $0x1
8010144d:	ff 75 08             	pushl  0x8(%ebp)
80101450:	e8 7b ec ff ff       	call   801000d0 <bread>
80101455:	89 c3                	mov    %eax,%ebx
  memmove(sb, bp->data, sizeof(*sb));
80101457:	8d 40 5c             	lea    0x5c(%eax),%eax
8010145a:	83 c4 0c             	add    $0xc,%esp
8010145d:	6a 1c                	push   $0x1c
8010145f:	50                   	push   %eax
80101460:	56                   	push   %esi
80101461:	e8 5a 40 00 00       	call   801054c0 <memmove>
  brelse(bp);
80101466:	89 5d 08             	mov    %ebx,0x8(%ebp)
80101469:	83 c4 10             	add    $0x10,%esp
}
8010146c:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010146f:	5b                   	pop    %ebx
80101470:	5e                   	pop    %esi
80101471:	5d                   	pop    %ebp
  brelse(bp);
80101472:	e9 69 ed ff ff       	jmp    801001e0 <brelse>
80101477:	89 f6                	mov    %esi,%esi
80101479:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101480 <iinit>:
{
80101480:	55                   	push   %ebp
80101481:	89 e5                	mov    %esp,%ebp
80101483:	53                   	push   %ebx
80101484:	bb 80 1a 11 80       	mov    $0x80111a80,%ebx
80101489:	83 ec 0c             	sub    $0xc,%esp
  initlock(&icache.lock, "icache");
8010148c:	68 0b 81 10 80       	push   $0x8010810b
80101491:	68 40 1a 11 80       	push   $0x80111a40
80101496:	e8 25 3d 00 00       	call   801051c0 <initlock>
8010149b:	83 c4 10             	add    $0x10,%esp
8010149e:	66 90                	xchg   %ax,%ax
    initsleeplock(&icache.inode[i].lock, "inode");
801014a0:	83 ec 08             	sub    $0x8,%esp
801014a3:	68 12 81 10 80       	push   $0x80108112
801014a8:	53                   	push   %ebx
801014a9:	81 c3 90 00 00 00    	add    $0x90,%ebx
801014af:	e8 dc 3b 00 00       	call   80105090 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
801014b4:	83 c4 10             	add    $0x10,%esp
801014b7:	81 fb a0 36 11 80    	cmp    $0x801136a0,%ebx
801014bd:	75 e1                	jne    801014a0 <iinit+0x20>
  readsb(dev, &sb);
801014bf:	83 ec 08             	sub    $0x8,%esp
801014c2:	68 20 1a 11 80       	push   $0x80111a20
801014c7:	ff 75 08             	pushl  0x8(%ebp)
801014ca:	e8 71 ff ff ff       	call   80101440 <readsb>
  cprintf("sb: size %d nblocks %d ninodes %d nlog %d logstart %d\
801014cf:	ff 35 38 1a 11 80    	pushl  0x80111a38
801014d5:	ff 35 34 1a 11 80    	pushl  0x80111a34
801014db:	ff 35 30 1a 11 80    	pushl  0x80111a30
801014e1:	ff 35 2c 1a 11 80    	pushl  0x80111a2c
801014e7:	ff 35 28 1a 11 80    	pushl  0x80111a28
801014ed:	ff 35 24 1a 11 80    	pushl  0x80111a24
801014f3:	ff 35 20 1a 11 80    	pushl  0x80111a20
801014f9:	68 78 81 10 80       	push   $0x80108178
801014fe:	e8 5d f1 ff ff       	call   80100660 <cprintf>
}
80101503:	83 c4 30             	add    $0x30,%esp
80101506:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101509:	c9                   	leave  
8010150a:	c3                   	ret    
8010150b:	90                   	nop
8010150c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101510 <ialloc>:
{
80101510:	55                   	push   %ebp
80101511:	89 e5                	mov    %esp,%ebp
80101513:	57                   	push   %edi
80101514:	56                   	push   %esi
80101515:	53                   	push   %ebx
80101516:	83 ec 1c             	sub    $0x1c,%esp
  for(inum = 1; inum < sb.ninodes; inum++){
80101519:	83 3d 28 1a 11 80 01 	cmpl   $0x1,0x80111a28
{
80101520:	8b 45 0c             	mov    0xc(%ebp),%eax
80101523:	8b 75 08             	mov    0x8(%ebp),%esi
80101526:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  for(inum = 1; inum < sb.ninodes; inum++){
80101529:	0f 86 91 00 00 00    	jbe    801015c0 <ialloc+0xb0>
8010152f:	bb 01 00 00 00       	mov    $0x1,%ebx
80101534:	eb 21                	jmp    80101557 <ialloc+0x47>
80101536:	8d 76 00             	lea    0x0(%esi),%esi
80101539:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    brelse(bp);
80101540:	83 ec 0c             	sub    $0xc,%esp
  for(inum = 1; inum < sb.ninodes; inum++){
80101543:	83 c3 01             	add    $0x1,%ebx
    brelse(bp);
80101546:	57                   	push   %edi
80101547:	e8 94 ec ff ff       	call   801001e0 <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
8010154c:	83 c4 10             	add    $0x10,%esp
8010154f:	39 1d 28 1a 11 80    	cmp    %ebx,0x80111a28
80101555:	76 69                	jbe    801015c0 <ialloc+0xb0>
    bp = bread(dev, IBLOCK(inum, sb));
80101557:	89 d8                	mov    %ebx,%eax
80101559:	83 ec 08             	sub    $0x8,%esp
8010155c:	c1 e8 03             	shr    $0x3,%eax
8010155f:	03 05 34 1a 11 80    	add    0x80111a34,%eax
80101565:	50                   	push   %eax
80101566:	56                   	push   %esi
80101567:	e8 64 eb ff ff       	call   801000d0 <bread>
8010156c:	89 c7                	mov    %eax,%edi
    dip = (struct dinode*)bp->data + inum%IPB;
8010156e:	89 d8                	mov    %ebx,%eax
    if(dip->type == 0){  // a free inode
80101570:	83 c4 10             	add    $0x10,%esp
    dip = (struct dinode*)bp->data + inum%IPB;
80101573:	83 e0 07             	and    $0x7,%eax
80101576:	c1 e0 06             	shl    $0x6,%eax
80101579:	8d 4c 07 5c          	lea    0x5c(%edi,%eax,1),%ecx
    if(dip->type == 0){  // a free inode
8010157d:	66 83 39 00          	cmpw   $0x0,(%ecx)
80101581:	75 bd                	jne    80101540 <ialloc+0x30>
      memset(dip, 0, sizeof(*dip));
80101583:	83 ec 04             	sub    $0x4,%esp
80101586:	89 4d e0             	mov    %ecx,-0x20(%ebp)
80101589:	6a 40                	push   $0x40
8010158b:	6a 00                	push   $0x0
8010158d:	51                   	push   %ecx
8010158e:	e8 7d 3e 00 00       	call   80105410 <memset>
      dip->type = type;
80101593:	0f b7 45 e4          	movzwl -0x1c(%ebp),%eax
80101597:	8b 4d e0             	mov    -0x20(%ebp),%ecx
8010159a:	66 89 01             	mov    %ax,(%ecx)
      log_write(bp);   // mark it allocated on the disk
8010159d:	89 3c 24             	mov    %edi,(%esp)
801015a0:	e8 cb 17 00 00       	call   80102d70 <log_write>
      brelse(bp);
801015a5:	89 3c 24             	mov    %edi,(%esp)
801015a8:	e8 33 ec ff ff       	call   801001e0 <brelse>
      return iget(dev, inum);
801015ad:	83 c4 10             	add    $0x10,%esp
}
801015b0:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return iget(dev, inum);
801015b3:	89 da                	mov    %ebx,%edx
801015b5:	89 f0                	mov    %esi,%eax
}
801015b7:	5b                   	pop    %ebx
801015b8:	5e                   	pop    %esi
801015b9:	5f                   	pop    %edi
801015ba:	5d                   	pop    %ebp
      return iget(dev, inum);
801015bb:	e9 d0 fc ff ff       	jmp    80101290 <iget>
  panic("ialloc: no inodes");
801015c0:	83 ec 0c             	sub    $0xc,%esp
801015c3:	68 18 81 10 80       	push   $0x80108118
801015c8:	e8 c3 ed ff ff       	call   80100390 <panic>
801015cd:	8d 76 00             	lea    0x0(%esi),%esi

801015d0 <iupdate>:
{
801015d0:	55                   	push   %ebp
801015d1:	89 e5                	mov    %esp,%ebp
801015d3:	56                   	push   %esi
801015d4:	53                   	push   %ebx
801015d5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801015d8:	83 ec 08             	sub    $0x8,%esp
801015db:	8b 43 04             	mov    0x4(%ebx),%eax
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
801015de:	83 c3 5c             	add    $0x5c,%ebx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801015e1:	c1 e8 03             	shr    $0x3,%eax
801015e4:	03 05 34 1a 11 80    	add    0x80111a34,%eax
801015ea:	50                   	push   %eax
801015eb:	ff 73 a4             	pushl  -0x5c(%ebx)
801015ee:	e8 dd ea ff ff       	call   801000d0 <bread>
801015f3:	89 c6                	mov    %eax,%esi
  dip = (struct dinode*)bp->data + ip->inum%IPB;
801015f5:	8b 43 a8             	mov    -0x58(%ebx),%eax
  dip->type = ip->type;
801015f8:	0f b7 53 f4          	movzwl -0xc(%ebx),%edx
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
801015fc:	83 c4 0c             	add    $0xc,%esp
  dip = (struct dinode*)bp->data + ip->inum%IPB;
801015ff:	83 e0 07             	and    $0x7,%eax
80101602:	c1 e0 06             	shl    $0x6,%eax
80101605:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
  dip->type = ip->type;
80101609:	66 89 10             	mov    %dx,(%eax)
  dip->major = ip->major;
8010160c:	0f b7 53 f6          	movzwl -0xa(%ebx),%edx
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
80101610:	83 c0 0c             	add    $0xc,%eax
  dip->major = ip->major;
80101613:	66 89 50 f6          	mov    %dx,-0xa(%eax)
  dip->minor = ip->minor;
80101617:	0f b7 53 f8          	movzwl -0x8(%ebx),%edx
8010161b:	66 89 50 f8          	mov    %dx,-0x8(%eax)
  dip->nlink = ip->nlink;
8010161f:	0f b7 53 fa          	movzwl -0x6(%ebx),%edx
80101623:	66 89 50 fa          	mov    %dx,-0x6(%eax)
  dip->size = ip->size;
80101627:	8b 53 fc             	mov    -0x4(%ebx),%edx
8010162a:	89 50 fc             	mov    %edx,-0x4(%eax)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
8010162d:	6a 34                	push   $0x34
8010162f:	53                   	push   %ebx
80101630:	50                   	push   %eax
80101631:	e8 8a 3e 00 00       	call   801054c0 <memmove>
  log_write(bp);
80101636:	89 34 24             	mov    %esi,(%esp)
80101639:	e8 32 17 00 00       	call   80102d70 <log_write>
  brelse(bp);
8010163e:	89 75 08             	mov    %esi,0x8(%ebp)
80101641:	83 c4 10             	add    $0x10,%esp
}
80101644:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101647:	5b                   	pop    %ebx
80101648:	5e                   	pop    %esi
80101649:	5d                   	pop    %ebp
  brelse(bp);
8010164a:	e9 91 eb ff ff       	jmp    801001e0 <brelse>
8010164f:	90                   	nop

80101650 <idup>:
{
80101650:	55                   	push   %ebp
80101651:	89 e5                	mov    %esp,%ebp
80101653:	53                   	push   %ebx
80101654:	83 ec 10             	sub    $0x10,%esp
80101657:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&icache.lock);
8010165a:	68 40 1a 11 80       	push   $0x80111a40
8010165f:	e8 9c 3c 00 00       	call   80105300 <acquire>
  ip->ref++;
80101664:	83 43 08 01          	addl   $0x1,0x8(%ebx)
  release(&icache.lock);
80101668:	c7 04 24 40 1a 11 80 	movl   $0x80111a40,(%esp)
8010166f:	e8 4c 3d 00 00       	call   801053c0 <release>
}
80101674:	89 d8                	mov    %ebx,%eax
80101676:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101679:	c9                   	leave  
8010167a:	c3                   	ret    
8010167b:	90                   	nop
8010167c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101680 <ilock>:
{
80101680:	55                   	push   %ebp
80101681:	89 e5                	mov    %esp,%ebp
80101683:	56                   	push   %esi
80101684:	53                   	push   %ebx
80101685:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || ip->ref < 1)
80101688:	85 db                	test   %ebx,%ebx
8010168a:	0f 84 b7 00 00 00    	je     80101747 <ilock+0xc7>
80101690:	8b 53 08             	mov    0x8(%ebx),%edx
80101693:	85 d2                	test   %edx,%edx
80101695:	0f 8e ac 00 00 00    	jle    80101747 <ilock+0xc7>
  acquiresleep(&ip->lock);
8010169b:	8d 43 0c             	lea    0xc(%ebx),%eax
8010169e:	83 ec 0c             	sub    $0xc,%esp
801016a1:	50                   	push   %eax
801016a2:	e8 29 3a 00 00       	call   801050d0 <acquiresleep>
  if(ip->valid == 0){
801016a7:	8b 43 4c             	mov    0x4c(%ebx),%eax
801016aa:	83 c4 10             	add    $0x10,%esp
801016ad:	85 c0                	test   %eax,%eax
801016af:	74 0f                	je     801016c0 <ilock+0x40>
}
801016b1:	8d 65 f8             	lea    -0x8(%ebp),%esp
801016b4:	5b                   	pop    %ebx
801016b5:	5e                   	pop    %esi
801016b6:	5d                   	pop    %ebp
801016b7:	c3                   	ret    
801016b8:	90                   	nop
801016b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801016c0:	8b 43 04             	mov    0x4(%ebx),%eax
801016c3:	83 ec 08             	sub    $0x8,%esp
801016c6:	c1 e8 03             	shr    $0x3,%eax
801016c9:	03 05 34 1a 11 80    	add    0x80111a34,%eax
801016cf:	50                   	push   %eax
801016d0:	ff 33                	pushl  (%ebx)
801016d2:	e8 f9 e9 ff ff       	call   801000d0 <bread>
801016d7:	89 c6                	mov    %eax,%esi
    dip = (struct dinode*)bp->data + ip->inum%IPB;
801016d9:	8b 43 04             	mov    0x4(%ebx),%eax
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
801016dc:	83 c4 0c             	add    $0xc,%esp
    dip = (struct dinode*)bp->data + ip->inum%IPB;
801016df:	83 e0 07             	and    $0x7,%eax
801016e2:	c1 e0 06             	shl    $0x6,%eax
801016e5:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
    ip->type = dip->type;
801016e9:	0f b7 10             	movzwl (%eax),%edx
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
801016ec:	83 c0 0c             	add    $0xc,%eax
    ip->type = dip->type;
801016ef:	66 89 53 50          	mov    %dx,0x50(%ebx)
    ip->major = dip->major;
801016f3:	0f b7 50 f6          	movzwl -0xa(%eax),%edx
801016f7:	66 89 53 52          	mov    %dx,0x52(%ebx)
    ip->minor = dip->minor;
801016fb:	0f b7 50 f8          	movzwl -0x8(%eax),%edx
801016ff:	66 89 53 54          	mov    %dx,0x54(%ebx)
    ip->nlink = dip->nlink;
80101703:	0f b7 50 fa          	movzwl -0x6(%eax),%edx
80101707:	66 89 53 56          	mov    %dx,0x56(%ebx)
    ip->size = dip->size;
8010170b:	8b 50 fc             	mov    -0x4(%eax),%edx
8010170e:	89 53 58             	mov    %edx,0x58(%ebx)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
80101711:	6a 34                	push   $0x34
80101713:	50                   	push   %eax
80101714:	8d 43 5c             	lea    0x5c(%ebx),%eax
80101717:	50                   	push   %eax
80101718:	e8 a3 3d 00 00       	call   801054c0 <memmove>
    brelse(bp);
8010171d:	89 34 24             	mov    %esi,(%esp)
80101720:	e8 bb ea ff ff       	call   801001e0 <brelse>
    if(ip->type == 0)
80101725:	83 c4 10             	add    $0x10,%esp
80101728:	66 83 7b 50 00       	cmpw   $0x0,0x50(%ebx)
    ip->valid = 1;
8010172d:	c7 43 4c 01 00 00 00 	movl   $0x1,0x4c(%ebx)
    if(ip->type == 0)
80101734:	0f 85 77 ff ff ff    	jne    801016b1 <ilock+0x31>
      panic("ilock: no type");
8010173a:	83 ec 0c             	sub    $0xc,%esp
8010173d:	68 30 81 10 80       	push   $0x80108130
80101742:	e8 49 ec ff ff       	call   80100390 <panic>
    panic("ilock");
80101747:	83 ec 0c             	sub    $0xc,%esp
8010174a:	68 2a 81 10 80       	push   $0x8010812a
8010174f:	e8 3c ec ff ff       	call   80100390 <panic>
80101754:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010175a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80101760 <iunlock>:
{
80101760:	55                   	push   %ebp
80101761:	89 e5                	mov    %esp,%ebp
80101763:	56                   	push   %esi
80101764:	53                   	push   %ebx
80101765:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101768:	85 db                	test   %ebx,%ebx
8010176a:	74 28                	je     80101794 <iunlock+0x34>
8010176c:	8d 73 0c             	lea    0xc(%ebx),%esi
8010176f:	83 ec 0c             	sub    $0xc,%esp
80101772:	56                   	push   %esi
80101773:	e8 f8 39 00 00       	call   80105170 <holdingsleep>
80101778:	83 c4 10             	add    $0x10,%esp
8010177b:	85 c0                	test   %eax,%eax
8010177d:	74 15                	je     80101794 <iunlock+0x34>
8010177f:	8b 43 08             	mov    0x8(%ebx),%eax
80101782:	85 c0                	test   %eax,%eax
80101784:	7e 0e                	jle    80101794 <iunlock+0x34>
  releasesleep(&ip->lock);
80101786:	89 75 08             	mov    %esi,0x8(%ebp)
}
80101789:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010178c:	5b                   	pop    %ebx
8010178d:	5e                   	pop    %esi
8010178e:	5d                   	pop    %ebp
  releasesleep(&ip->lock);
8010178f:	e9 9c 39 00 00       	jmp    80105130 <releasesleep>
    panic("iunlock");
80101794:	83 ec 0c             	sub    $0xc,%esp
80101797:	68 3f 81 10 80       	push   $0x8010813f
8010179c:	e8 ef eb ff ff       	call   80100390 <panic>
801017a1:	eb 0d                	jmp    801017b0 <iput>
801017a3:	90                   	nop
801017a4:	90                   	nop
801017a5:	90                   	nop
801017a6:	90                   	nop
801017a7:	90                   	nop
801017a8:	90                   	nop
801017a9:	90                   	nop
801017aa:	90                   	nop
801017ab:	90                   	nop
801017ac:	90                   	nop
801017ad:	90                   	nop
801017ae:	90                   	nop
801017af:	90                   	nop

801017b0 <iput>:
{
801017b0:	55                   	push   %ebp
801017b1:	89 e5                	mov    %esp,%ebp
801017b3:	57                   	push   %edi
801017b4:	56                   	push   %esi
801017b5:	53                   	push   %ebx
801017b6:	83 ec 28             	sub    $0x28,%esp
801017b9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquiresleep(&ip->lock);
801017bc:	8d 7b 0c             	lea    0xc(%ebx),%edi
801017bf:	57                   	push   %edi
801017c0:	e8 0b 39 00 00       	call   801050d0 <acquiresleep>
  if(ip->valid && ip->nlink == 0){
801017c5:	8b 53 4c             	mov    0x4c(%ebx),%edx
801017c8:	83 c4 10             	add    $0x10,%esp
801017cb:	85 d2                	test   %edx,%edx
801017cd:	74 07                	je     801017d6 <iput+0x26>
801017cf:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
801017d4:	74 32                	je     80101808 <iput+0x58>
  releasesleep(&ip->lock);
801017d6:	83 ec 0c             	sub    $0xc,%esp
801017d9:	57                   	push   %edi
801017da:	e8 51 39 00 00       	call   80105130 <releasesleep>
  acquire(&icache.lock);
801017df:	c7 04 24 40 1a 11 80 	movl   $0x80111a40,(%esp)
801017e6:	e8 15 3b 00 00       	call   80105300 <acquire>
  ip->ref--;
801017eb:	83 6b 08 01          	subl   $0x1,0x8(%ebx)
  release(&icache.lock);
801017ef:	83 c4 10             	add    $0x10,%esp
801017f2:	c7 45 08 40 1a 11 80 	movl   $0x80111a40,0x8(%ebp)
}
801017f9:	8d 65 f4             	lea    -0xc(%ebp),%esp
801017fc:	5b                   	pop    %ebx
801017fd:	5e                   	pop    %esi
801017fe:	5f                   	pop    %edi
801017ff:	5d                   	pop    %ebp
  release(&icache.lock);
80101800:	e9 bb 3b 00 00       	jmp    801053c0 <release>
80101805:	8d 76 00             	lea    0x0(%esi),%esi
    acquire(&icache.lock);
80101808:	83 ec 0c             	sub    $0xc,%esp
8010180b:	68 40 1a 11 80       	push   $0x80111a40
80101810:	e8 eb 3a 00 00       	call   80105300 <acquire>
    int r = ip->ref;
80101815:	8b 73 08             	mov    0x8(%ebx),%esi
    release(&icache.lock);
80101818:	c7 04 24 40 1a 11 80 	movl   $0x80111a40,(%esp)
8010181f:	e8 9c 3b 00 00       	call   801053c0 <release>
    if(r == 1){
80101824:	83 c4 10             	add    $0x10,%esp
80101827:	83 fe 01             	cmp    $0x1,%esi
8010182a:	75 aa                	jne    801017d6 <iput+0x26>
8010182c:	8d 8b 8c 00 00 00    	lea    0x8c(%ebx),%ecx
80101832:	89 7d e4             	mov    %edi,-0x1c(%ebp)
80101835:	8d 73 5c             	lea    0x5c(%ebx),%esi
80101838:	89 cf                	mov    %ecx,%edi
8010183a:	eb 0b                	jmp    80101847 <iput+0x97>
8010183c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101840:	83 c6 04             	add    $0x4,%esi
{
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
80101843:	39 fe                	cmp    %edi,%esi
80101845:	74 19                	je     80101860 <iput+0xb0>
    if(ip->addrs[i]){
80101847:	8b 16                	mov    (%esi),%edx
80101849:	85 d2                	test   %edx,%edx
8010184b:	74 f3                	je     80101840 <iput+0x90>
      bfree(ip->dev, ip->addrs[i]);
8010184d:	8b 03                	mov    (%ebx),%eax
8010184f:	e8 bc f8 ff ff       	call   80101110 <bfree>
      ip->addrs[i] = 0;
80101854:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
8010185a:	eb e4                	jmp    80101840 <iput+0x90>
8010185c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    }
  }

  if(ip->addrs[NDIRECT]){
80101860:	8b 83 8c 00 00 00    	mov    0x8c(%ebx),%eax
80101866:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80101869:	85 c0                	test   %eax,%eax
8010186b:	75 33                	jne    801018a0 <iput+0xf0>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
  iupdate(ip);
8010186d:	83 ec 0c             	sub    $0xc,%esp
  ip->size = 0;
80101870:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  iupdate(ip);
80101877:	53                   	push   %ebx
80101878:	e8 53 fd ff ff       	call   801015d0 <iupdate>
      ip->type = 0;
8010187d:	31 c0                	xor    %eax,%eax
8010187f:	66 89 43 50          	mov    %ax,0x50(%ebx)
      iupdate(ip);
80101883:	89 1c 24             	mov    %ebx,(%esp)
80101886:	e8 45 fd ff ff       	call   801015d0 <iupdate>
      ip->valid = 0;
8010188b:	c7 43 4c 00 00 00 00 	movl   $0x0,0x4c(%ebx)
80101892:	83 c4 10             	add    $0x10,%esp
80101895:	e9 3c ff ff ff       	jmp    801017d6 <iput+0x26>
8010189a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
801018a0:	83 ec 08             	sub    $0x8,%esp
801018a3:	50                   	push   %eax
801018a4:	ff 33                	pushl  (%ebx)
801018a6:	e8 25 e8 ff ff       	call   801000d0 <bread>
801018ab:	8d 88 5c 02 00 00    	lea    0x25c(%eax),%ecx
801018b1:	89 7d e0             	mov    %edi,-0x20(%ebp)
801018b4:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    a = (uint*)bp->data;
801018b7:	8d 70 5c             	lea    0x5c(%eax),%esi
801018ba:	83 c4 10             	add    $0x10,%esp
801018bd:	89 cf                	mov    %ecx,%edi
801018bf:	eb 0e                	jmp    801018cf <iput+0x11f>
801018c1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801018c8:	83 c6 04             	add    $0x4,%esi
    for(j = 0; j < NINDIRECT; j++){
801018cb:	39 fe                	cmp    %edi,%esi
801018cd:	74 0f                	je     801018de <iput+0x12e>
      if(a[j])
801018cf:	8b 16                	mov    (%esi),%edx
801018d1:	85 d2                	test   %edx,%edx
801018d3:	74 f3                	je     801018c8 <iput+0x118>
        bfree(ip->dev, a[j]);
801018d5:	8b 03                	mov    (%ebx),%eax
801018d7:	e8 34 f8 ff ff       	call   80101110 <bfree>
801018dc:	eb ea                	jmp    801018c8 <iput+0x118>
    brelse(bp);
801018de:	83 ec 0c             	sub    $0xc,%esp
801018e1:	ff 75 e4             	pushl  -0x1c(%ebp)
801018e4:	8b 7d e0             	mov    -0x20(%ebp),%edi
801018e7:	e8 f4 e8 ff ff       	call   801001e0 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
801018ec:	8b 93 8c 00 00 00    	mov    0x8c(%ebx),%edx
801018f2:	8b 03                	mov    (%ebx),%eax
801018f4:	e8 17 f8 ff ff       	call   80101110 <bfree>
    ip->addrs[NDIRECT] = 0;
801018f9:	c7 83 8c 00 00 00 00 	movl   $0x0,0x8c(%ebx)
80101900:	00 00 00 
80101903:	83 c4 10             	add    $0x10,%esp
80101906:	e9 62 ff ff ff       	jmp    8010186d <iput+0xbd>
8010190b:	90                   	nop
8010190c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101910 <iunlockput>:
{
80101910:	55                   	push   %ebp
80101911:	89 e5                	mov    %esp,%ebp
80101913:	53                   	push   %ebx
80101914:	83 ec 10             	sub    $0x10,%esp
80101917:	8b 5d 08             	mov    0x8(%ebp),%ebx
  iunlock(ip);
8010191a:	53                   	push   %ebx
8010191b:	e8 40 fe ff ff       	call   80101760 <iunlock>
  iput(ip);
80101920:	89 5d 08             	mov    %ebx,0x8(%ebp)
80101923:	83 c4 10             	add    $0x10,%esp
}
80101926:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101929:	c9                   	leave  
  iput(ip);
8010192a:	e9 81 fe ff ff       	jmp    801017b0 <iput>
8010192f:	90                   	nop

80101930 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
80101930:	55                   	push   %ebp
80101931:	89 e5                	mov    %esp,%ebp
80101933:	8b 55 08             	mov    0x8(%ebp),%edx
80101936:	8b 45 0c             	mov    0xc(%ebp),%eax
  st->dev = ip->dev;
80101939:	8b 0a                	mov    (%edx),%ecx
8010193b:	89 48 04             	mov    %ecx,0x4(%eax)
  st->ino = ip->inum;
8010193e:	8b 4a 04             	mov    0x4(%edx),%ecx
80101941:	89 48 08             	mov    %ecx,0x8(%eax)
  st->type = ip->type;
80101944:	0f b7 4a 50          	movzwl 0x50(%edx),%ecx
80101948:	66 89 08             	mov    %cx,(%eax)
  st->nlink = ip->nlink;
8010194b:	0f b7 4a 56          	movzwl 0x56(%edx),%ecx
8010194f:	66 89 48 0c          	mov    %cx,0xc(%eax)
  st->size = ip->size;
80101953:	8b 52 58             	mov    0x58(%edx),%edx
80101956:	89 50 10             	mov    %edx,0x10(%eax)
}
80101959:	5d                   	pop    %ebp
8010195a:	c3                   	ret    
8010195b:	90                   	nop
8010195c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101960 <readi>:
//PAGEBREAK!
// Read data from inode.
// Caller must hold ip->lock.
int
readi(struct inode *ip, char *dst, uint off, uint n)
{
80101960:	55                   	push   %ebp
80101961:	89 e5                	mov    %esp,%ebp
80101963:	57                   	push   %edi
80101964:	56                   	push   %esi
80101965:	53                   	push   %ebx
80101966:	83 ec 1c             	sub    $0x1c,%esp
80101969:	8b 45 08             	mov    0x8(%ebp),%eax
8010196c:	8b 75 0c             	mov    0xc(%ebp),%esi
8010196f:	8b 7d 14             	mov    0x14(%ebp),%edi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101972:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
{
80101977:	89 75 e0             	mov    %esi,-0x20(%ebp)
8010197a:	89 45 d8             	mov    %eax,-0x28(%ebp)
8010197d:	8b 75 10             	mov    0x10(%ebp),%esi
80101980:	89 7d e4             	mov    %edi,-0x1c(%ebp)
  if(ip->type == T_DEV){
80101983:	0f 84 a7 00 00 00    	je     80101a30 <readi+0xd0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
      return -1;
    return devsw[ip->major].read(ip, dst, n);
  }

  if(off > ip->size || off + n < off)
80101989:	8b 45 d8             	mov    -0x28(%ebp),%eax
8010198c:	8b 40 58             	mov    0x58(%eax),%eax
8010198f:	39 c6                	cmp    %eax,%esi
80101991:	0f 87 ba 00 00 00    	ja     80101a51 <readi+0xf1>
80101997:	8b 7d e4             	mov    -0x1c(%ebp),%edi
8010199a:	89 f9                	mov    %edi,%ecx
8010199c:	01 f1                	add    %esi,%ecx
8010199e:	0f 82 ad 00 00 00    	jb     80101a51 <readi+0xf1>
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;
801019a4:	89 c2                	mov    %eax,%edx
801019a6:	29 f2                	sub    %esi,%edx
801019a8:	39 c8                	cmp    %ecx,%eax
801019aa:	0f 43 d7             	cmovae %edi,%edx

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
801019ad:	31 ff                	xor    %edi,%edi
801019af:	85 d2                	test   %edx,%edx
    n = ip->size - off;
801019b1:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
801019b4:	74 6c                	je     80101a22 <readi+0xc2>
801019b6:	8d 76 00             	lea    0x0(%esi),%esi
801019b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
801019c0:	8b 5d d8             	mov    -0x28(%ebp),%ebx
801019c3:	89 f2                	mov    %esi,%edx
801019c5:	c1 ea 09             	shr    $0x9,%edx
801019c8:	89 d8                	mov    %ebx,%eax
801019ca:	e8 91 f9 ff ff       	call   80101360 <bmap>
801019cf:	83 ec 08             	sub    $0x8,%esp
801019d2:	50                   	push   %eax
801019d3:	ff 33                	pushl  (%ebx)
801019d5:	e8 f6 e6 ff ff       	call   801000d0 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
801019da:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
801019dd:	89 c2                	mov    %eax,%edx
    m = min(n - tot, BSIZE - off%BSIZE);
801019df:	89 f0                	mov    %esi,%eax
801019e1:	25 ff 01 00 00       	and    $0x1ff,%eax
801019e6:	b9 00 02 00 00       	mov    $0x200,%ecx
801019eb:	83 c4 0c             	add    $0xc,%esp
801019ee:	29 c1                	sub    %eax,%ecx
    memmove(dst, bp->data + off%BSIZE, m);
801019f0:	8d 44 02 5c          	lea    0x5c(%edx,%eax,1),%eax
801019f4:	89 55 dc             	mov    %edx,-0x24(%ebp)
    m = min(n - tot, BSIZE - off%BSIZE);
801019f7:	29 fb                	sub    %edi,%ebx
801019f9:	39 d9                	cmp    %ebx,%ecx
801019fb:	0f 46 d9             	cmovbe %ecx,%ebx
    memmove(dst, bp->data + off%BSIZE, m);
801019fe:	53                   	push   %ebx
801019ff:	50                   	push   %eax
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101a00:	01 df                	add    %ebx,%edi
    memmove(dst, bp->data + off%BSIZE, m);
80101a02:	ff 75 e0             	pushl  -0x20(%ebp)
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101a05:	01 de                	add    %ebx,%esi
    memmove(dst, bp->data + off%BSIZE, m);
80101a07:	e8 b4 3a 00 00       	call   801054c0 <memmove>
    brelse(bp);
80101a0c:	8b 55 dc             	mov    -0x24(%ebp),%edx
80101a0f:	89 14 24             	mov    %edx,(%esp)
80101a12:	e8 c9 e7 ff ff       	call   801001e0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101a17:	01 5d e0             	add    %ebx,-0x20(%ebp)
80101a1a:	83 c4 10             	add    $0x10,%esp
80101a1d:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
80101a20:	77 9e                	ja     801019c0 <readi+0x60>
  }
  return n;
80101a22:	8b 45 e4             	mov    -0x1c(%ebp),%eax
}
80101a25:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101a28:	5b                   	pop    %ebx
80101a29:	5e                   	pop    %esi
80101a2a:	5f                   	pop    %edi
80101a2b:	5d                   	pop    %ebp
80101a2c:	c3                   	ret    
80101a2d:	8d 76 00             	lea    0x0(%esi),%esi
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
80101a30:	0f bf 40 52          	movswl 0x52(%eax),%eax
80101a34:	66 83 f8 09          	cmp    $0x9,%ax
80101a38:	77 17                	ja     80101a51 <readi+0xf1>
80101a3a:	8b 04 c5 c0 19 11 80 	mov    -0x7feee640(,%eax,8),%eax
80101a41:	85 c0                	test   %eax,%eax
80101a43:	74 0c                	je     80101a51 <readi+0xf1>
    return devsw[ip->major].read(ip, dst, n);
80101a45:	89 7d 10             	mov    %edi,0x10(%ebp)
}
80101a48:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101a4b:	5b                   	pop    %ebx
80101a4c:	5e                   	pop    %esi
80101a4d:	5f                   	pop    %edi
80101a4e:	5d                   	pop    %ebp
    return devsw[ip->major].read(ip, dst, n);
80101a4f:	ff e0                	jmp    *%eax
      return -1;
80101a51:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101a56:	eb cd                	jmp    80101a25 <readi+0xc5>
80101a58:	90                   	nop
80101a59:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80101a60 <writei>:
// PAGEBREAK!
// Write data to inode.
// Caller must hold ip->lock.
int
writei(struct inode *ip, char *src, uint off, uint n)
{
80101a60:	55                   	push   %ebp
80101a61:	89 e5                	mov    %esp,%ebp
80101a63:	57                   	push   %edi
80101a64:	56                   	push   %esi
80101a65:	53                   	push   %ebx
80101a66:	83 ec 1c             	sub    $0x1c,%esp
80101a69:	8b 45 08             	mov    0x8(%ebp),%eax
80101a6c:	8b 75 0c             	mov    0xc(%ebp),%esi
80101a6f:	8b 7d 14             	mov    0x14(%ebp),%edi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101a72:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
{
80101a77:	89 75 dc             	mov    %esi,-0x24(%ebp)
80101a7a:	89 45 d8             	mov    %eax,-0x28(%ebp)
80101a7d:	8b 75 10             	mov    0x10(%ebp),%esi
80101a80:	89 7d e0             	mov    %edi,-0x20(%ebp)
  if(ip->type == T_DEV){
80101a83:	0f 84 b7 00 00 00    	je     80101b40 <writei+0xe0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
      return -1;
    return devsw[ip->major].write(ip, src, n);
  }

  if(off > ip->size || off + n < off)
80101a89:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101a8c:	39 70 58             	cmp    %esi,0x58(%eax)
80101a8f:	0f 82 eb 00 00 00    	jb     80101b80 <writei+0x120>
80101a95:	8b 7d e0             	mov    -0x20(%ebp),%edi
80101a98:	31 d2                	xor    %edx,%edx
80101a9a:	89 f8                	mov    %edi,%eax
80101a9c:	01 f0                	add    %esi,%eax
80101a9e:	0f 92 c2             	setb   %dl
    return -1;
  if(off + n > MAXFILE*BSIZE)
80101aa1:	3d 00 18 01 00       	cmp    $0x11800,%eax
80101aa6:	0f 87 d4 00 00 00    	ja     80101b80 <writei+0x120>
80101aac:	85 d2                	test   %edx,%edx
80101aae:	0f 85 cc 00 00 00    	jne    80101b80 <writei+0x120>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101ab4:	85 ff                	test   %edi,%edi
80101ab6:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80101abd:	74 72                	je     80101b31 <writei+0xd1>
80101abf:	90                   	nop
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101ac0:	8b 7d d8             	mov    -0x28(%ebp),%edi
80101ac3:	89 f2                	mov    %esi,%edx
80101ac5:	c1 ea 09             	shr    $0x9,%edx
80101ac8:	89 f8                	mov    %edi,%eax
80101aca:	e8 91 f8 ff ff       	call   80101360 <bmap>
80101acf:	83 ec 08             	sub    $0x8,%esp
80101ad2:	50                   	push   %eax
80101ad3:	ff 37                	pushl  (%edi)
80101ad5:	e8 f6 e5 ff ff       	call   801000d0 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
80101ada:	8b 5d e0             	mov    -0x20(%ebp),%ebx
80101add:	2b 5d e4             	sub    -0x1c(%ebp),%ebx
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101ae0:	89 c7                	mov    %eax,%edi
    m = min(n - tot, BSIZE - off%BSIZE);
80101ae2:	89 f0                	mov    %esi,%eax
80101ae4:	b9 00 02 00 00       	mov    $0x200,%ecx
80101ae9:	83 c4 0c             	add    $0xc,%esp
80101aec:	25 ff 01 00 00       	and    $0x1ff,%eax
80101af1:	29 c1                	sub    %eax,%ecx
    memmove(bp->data + off%BSIZE, src, m);
80101af3:	8d 44 07 5c          	lea    0x5c(%edi,%eax,1),%eax
    m = min(n - tot, BSIZE - off%BSIZE);
80101af7:	39 d9                	cmp    %ebx,%ecx
80101af9:	0f 46 d9             	cmovbe %ecx,%ebx
    memmove(bp->data + off%BSIZE, src, m);
80101afc:	53                   	push   %ebx
80101afd:	ff 75 dc             	pushl  -0x24(%ebp)
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101b00:	01 de                	add    %ebx,%esi
    memmove(bp->data + off%BSIZE, src, m);
80101b02:	50                   	push   %eax
80101b03:	e8 b8 39 00 00       	call   801054c0 <memmove>
    log_write(bp);
80101b08:	89 3c 24             	mov    %edi,(%esp)
80101b0b:	e8 60 12 00 00       	call   80102d70 <log_write>
    brelse(bp);
80101b10:	89 3c 24             	mov    %edi,(%esp)
80101b13:	e8 c8 e6 ff ff       	call   801001e0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101b18:	01 5d e4             	add    %ebx,-0x1c(%ebp)
80101b1b:	01 5d dc             	add    %ebx,-0x24(%ebp)
80101b1e:	83 c4 10             	add    $0x10,%esp
80101b21:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101b24:	39 45 e0             	cmp    %eax,-0x20(%ebp)
80101b27:	77 97                	ja     80101ac0 <writei+0x60>
  }

  if(n > 0 && off > ip->size){
80101b29:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101b2c:	3b 70 58             	cmp    0x58(%eax),%esi
80101b2f:	77 37                	ja     80101b68 <writei+0x108>
    ip->size = off;
    iupdate(ip);
  }
  return n;
80101b31:	8b 45 e0             	mov    -0x20(%ebp),%eax
}
80101b34:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101b37:	5b                   	pop    %ebx
80101b38:	5e                   	pop    %esi
80101b39:	5f                   	pop    %edi
80101b3a:	5d                   	pop    %ebp
80101b3b:	c3                   	ret    
80101b3c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
80101b40:	0f bf 40 52          	movswl 0x52(%eax),%eax
80101b44:	66 83 f8 09          	cmp    $0x9,%ax
80101b48:	77 36                	ja     80101b80 <writei+0x120>
80101b4a:	8b 04 c5 c4 19 11 80 	mov    -0x7feee63c(,%eax,8),%eax
80101b51:	85 c0                	test   %eax,%eax
80101b53:	74 2b                	je     80101b80 <writei+0x120>
    return devsw[ip->major].write(ip, src, n);
80101b55:	89 7d 10             	mov    %edi,0x10(%ebp)
}
80101b58:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101b5b:	5b                   	pop    %ebx
80101b5c:	5e                   	pop    %esi
80101b5d:	5f                   	pop    %edi
80101b5e:	5d                   	pop    %ebp
    return devsw[ip->major].write(ip, src, n);
80101b5f:	ff e0                	jmp    *%eax
80101b61:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    ip->size = off;
80101b68:	8b 45 d8             	mov    -0x28(%ebp),%eax
    iupdate(ip);
80101b6b:	83 ec 0c             	sub    $0xc,%esp
    ip->size = off;
80101b6e:	89 70 58             	mov    %esi,0x58(%eax)
    iupdate(ip);
80101b71:	50                   	push   %eax
80101b72:	e8 59 fa ff ff       	call   801015d0 <iupdate>
80101b77:	83 c4 10             	add    $0x10,%esp
80101b7a:	eb b5                	jmp    80101b31 <writei+0xd1>
80101b7c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      return -1;
80101b80:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101b85:	eb ad                	jmp    80101b34 <writei+0xd4>
80101b87:	89 f6                	mov    %esi,%esi
80101b89:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101b90 <namecmp>:
//PAGEBREAK!
// Directories

int
namecmp(const char *s, const char *t)
{
80101b90:	55                   	push   %ebp
80101b91:	89 e5                	mov    %esp,%ebp
80101b93:	83 ec 0c             	sub    $0xc,%esp
  return strncmp(s, t, DIRSIZ);
80101b96:	6a 0e                	push   $0xe
80101b98:	ff 75 0c             	pushl  0xc(%ebp)
80101b9b:	ff 75 08             	pushl  0x8(%ebp)
80101b9e:	e8 8d 39 00 00       	call   80105530 <strncmp>
}
80101ba3:	c9                   	leave  
80101ba4:	c3                   	ret    
80101ba5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101ba9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101bb0 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
80101bb0:	55                   	push   %ebp
80101bb1:	89 e5                	mov    %esp,%ebp
80101bb3:	57                   	push   %edi
80101bb4:	56                   	push   %esi
80101bb5:	53                   	push   %ebx
80101bb6:	83 ec 1c             	sub    $0x1c,%esp
80101bb9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
80101bbc:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80101bc1:	0f 85 85 00 00 00    	jne    80101c4c <dirlookup+0x9c>
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
80101bc7:	8b 53 58             	mov    0x58(%ebx),%edx
80101bca:	31 ff                	xor    %edi,%edi
80101bcc:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101bcf:	85 d2                	test   %edx,%edx
80101bd1:	74 3e                	je     80101c11 <dirlookup+0x61>
80101bd3:	90                   	nop
80101bd4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101bd8:	6a 10                	push   $0x10
80101bda:	57                   	push   %edi
80101bdb:	56                   	push   %esi
80101bdc:	53                   	push   %ebx
80101bdd:	e8 7e fd ff ff       	call   80101960 <readi>
80101be2:	83 c4 10             	add    $0x10,%esp
80101be5:	83 f8 10             	cmp    $0x10,%eax
80101be8:	75 55                	jne    80101c3f <dirlookup+0x8f>
      panic("dirlookup read");
    if(de.inum == 0)
80101bea:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80101bef:	74 18                	je     80101c09 <dirlookup+0x59>
  return strncmp(s, t, DIRSIZ);
80101bf1:	8d 45 da             	lea    -0x26(%ebp),%eax
80101bf4:	83 ec 04             	sub    $0x4,%esp
80101bf7:	6a 0e                	push   $0xe
80101bf9:	50                   	push   %eax
80101bfa:	ff 75 0c             	pushl  0xc(%ebp)
80101bfd:	e8 2e 39 00 00       	call   80105530 <strncmp>
      continue;
    if(namecmp(name, de.name) == 0){
80101c02:	83 c4 10             	add    $0x10,%esp
80101c05:	85 c0                	test   %eax,%eax
80101c07:	74 17                	je     80101c20 <dirlookup+0x70>
  for(off = 0; off < dp->size; off += sizeof(de)){
80101c09:	83 c7 10             	add    $0x10,%edi
80101c0c:	3b 7b 58             	cmp    0x58(%ebx),%edi
80101c0f:	72 c7                	jb     80101bd8 <dirlookup+0x28>
      return iget(dp->dev, inum);
    }
  }

  return 0;
}
80101c11:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80101c14:	31 c0                	xor    %eax,%eax
}
80101c16:	5b                   	pop    %ebx
80101c17:	5e                   	pop    %esi
80101c18:	5f                   	pop    %edi
80101c19:	5d                   	pop    %ebp
80101c1a:	c3                   	ret    
80101c1b:	90                   	nop
80101c1c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      if(poff)
80101c20:	8b 45 10             	mov    0x10(%ebp),%eax
80101c23:	85 c0                	test   %eax,%eax
80101c25:	74 05                	je     80101c2c <dirlookup+0x7c>
        *poff = off;
80101c27:	8b 45 10             	mov    0x10(%ebp),%eax
80101c2a:	89 38                	mov    %edi,(%eax)
      inum = de.inum;
80101c2c:	0f b7 55 d8          	movzwl -0x28(%ebp),%edx
      return iget(dp->dev, inum);
80101c30:	8b 03                	mov    (%ebx),%eax
80101c32:	e8 59 f6 ff ff       	call   80101290 <iget>
}
80101c37:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101c3a:	5b                   	pop    %ebx
80101c3b:	5e                   	pop    %esi
80101c3c:	5f                   	pop    %edi
80101c3d:	5d                   	pop    %ebp
80101c3e:	c3                   	ret    
      panic("dirlookup read");
80101c3f:	83 ec 0c             	sub    $0xc,%esp
80101c42:	68 59 81 10 80       	push   $0x80108159
80101c47:	e8 44 e7 ff ff       	call   80100390 <panic>
    panic("dirlookup not DIR");
80101c4c:	83 ec 0c             	sub    $0xc,%esp
80101c4f:	68 47 81 10 80       	push   $0x80108147
80101c54:	e8 37 e7 ff ff       	call   80100390 <panic>
80101c59:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80101c60 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
80101c60:	55                   	push   %ebp
80101c61:	89 e5                	mov    %esp,%ebp
80101c63:	57                   	push   %edi
80101c64:	56                   	push   %esi
80101c65:	53                   	push   %ebx
80101c66:	89 cf                	mov    %ecx,%edi
80101c68:	89 c3                	mov    %eax,%ebx
80101c6a:	83 ec 1c             	sub    $0x1c,%esp
  struct inode *ip, *next;

  if(*path == '/')
80101c6d:	80 38 2f             	cmpb   $0x2f,(%eax)
{
80101c70:	89 55 e0             	mov    %edx,-0x20(%ebp)
  if(*path == '/')
80101c73:	0f 84 67 01 00 00    	je     80101de0 <namex+0x180>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
80101c79:	e8 22 1c 00 00       	call   801038a0 <myproc>
  acquire(&icache.lock);
80101c7e:	83 ec 0c             	sub    $0xc,%esp
    ip = idup(myproc()->cwd);
80101c81:	8b 70 68             	mov    0x68(%eax),%esi
  acquire(&icache.lock);
80101c84:	68 40 1a 11 80       	push   $0x80111a40
80101c89:	e8 72 36 00 00       	call   80105300 <acquire>
  ip->ref++;
80101c8e:	83 46 08 01          	addl   $0x1,0x8(%esi)
  release(&icache.lock);
80101c92:	c7 04 24 40 1a 11 80 	movl   $0x80111a40,(%esp)
80101c99:	e8 22 37 00 00       	call   801053c0 <release>
80101c9e:	83 c4 10             	add    $0x10,%esp
80101ca1:	eb 08                	jmp    80101cab <namex+0x4b>
80101ca3:	90                   	nop
80101ca4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    path++;
80101ca8:	83 c3 01             	add    $0x1,%ebx
  while(*path == '/')
80101cab:	0f b6 03             	movzbl (%ebx),%eax
80101cae:	3c 2f                	cmp    $0x2f,%al
80101cb0:	74 f6                	je     80101ca8 <namex+0x48>
  if(*path == 0)
80101cb2:	84 c0                	test   %al,%al
80101cb4:	0f 84 ee 00 00 00    	je     80101da8 <namex+0x148>
  while(*path != '/' && *path != 0)
80101cba:	0f b6 03             	movzbl (%ebx),%eax
80101cbd:	3c 2f                	cmp    $0x2f,%al
80101cbf:	0f 84 b3 00 00 00    	je     80101d78 <namex+0x118>
80101cc5:	84 c0                	test   %al,%al
80101cc7:	89 da                	mov    %ebx,%edx
80101cc9:	75 09                	jne    80101cd4 <namex+0x74>
80101ccb:	e9 a8 00 00 00       	jmp    80101d78 <namex+0x118>
80101cd0:	84 c0                	test   %al,%al
80101cd2:	74 0a                	je     80101cde <namex+0x7e>
    path++;
80101cd4:	83 c2 01             	add    $0x1,%edx
  while(*path != '/' && *path != 0)
80101cd7:	0f b6 02             	movzbl (%edx),%eax
80101cda:	3c 2f                	cmp    $0x2f,%al
80101cdc:	75 f2                	jne    80101cd0 <namex+0x70>
80101cde:	89 d1                	mov    %edx,%ecx
80101ce0:	29 d9                	sub    %ebx,%ecx
  if(len >= DIRSIZ)
80101ce2:	83 f9 0d             	cmp    $0xd,%ecx
80101ce5:	0f 8e 91 00 00 00    	jle    80101d7c <namex+0x11c>
    memmove(name, s, DIRSIZ);
80101ceb:	83 ec 04             	sub    $0x4,%esp
80101cee:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80101cf1:	6a 0e                	push   $0xe
80101cf3:	53                   	push   %ebx
80101cf4:	57                   	push   %edi
80101cf5:	e8 c6 37 00 00       	call   801054c0 <memmove>
    path++;
80101cfa:	8b 55 e4             	mov    -0x1c(%ebp),%edx
    memmove(name, s, DIRSIZ);
80101cfd:	83 c4 10             	add    $0x10,%esp
    path++;
80101d00:	89 d3                	mov    %edx,%ebx
  while(*path == '/')
80101d02:	80 3a 2f             	cmpb   $0x2f,(%edx)
80101d05:	75 11                	jne    80101d18 <namex+0xb8>
80101d07:	89 f6                	mov    %esi,%esi
80101d09:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    path++;
80101d10:	83 c3 01             	add    $0x1,%ebx
  while(*path == '/')
80101d13:	80 3b 2f             	cmpb   $0x2f,(%ebx)
80101d16:	74 f8                	je     80101d10 <namex+0xb0>

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
80101d18:	83 ec 0c             	sub    $0xc,%esp
80101d1b:	56                   	push   %esi
80101d1c:	e8 5f f9 ff ff       	call   80101680 <ilock>
    if(ip->type != T_DIR){
80101d21:	83 c4 10             	add    $0x10,%esp
80101d24:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80101d29:	0f 85 91 00 00 00    	jne    80101dc0 <namex+0x160>
      iunlockput(ip);
      return 0;
    }
    if(nameiparent && *path == '\0'){
80101d2f:	8b 55 e0             	mov    -0x20(%ebp),%edx
80101d32:	85 d2                	test   %edx,%edx
80101d34:	74 09                	je     80101d3f <namex+0xdf>
80101d36:	80 3b 00             	cmpb   $0x0,(%ebx)
80101d39:	0f 84 b7 00 00 00    	je     80101df6 <namex+0x196>
      // Stop one level early.
      iunlock(ip);
      return ip;
    }
    if((next = dirlookup(ip, name, 0)) == 0){
80101d3f:	83 ec 04             	sub    $0x4,%esp
80101d42:	6a 00                	push   $0x0
80101d44:	57                   	push   %edi
80101d45:	56                   	push   %esi
80101d46:	e8 65 fe ff ff       	call   80101bb0 <dirlookup>
80101d4b:	83 c4 10             	add    $0x10,%esp
80101d4e:	85 c0                	test   %eax,%eax
80101d50:	74 6e                	je     80101dc0 <namex+0x160>
  iunlock(ip);
80101d52:	83 ec 0c             	sub    $0xc,%esp
80101d55:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80101d58:	56                   	push   %esi
80101d59:	e8 02 fa ff ff       	call   80101760 <iunlock>
  iput(ip);
80101d5e:	89 34 24             	mov    %esi,(%esp)
80101d61:	e8 4a fa ff ff       	call   801017b0 <iput>
80101d66:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101d69:	83 c4 10             	add    $0x10,%esp
80101d6c:	89 c6                	mov    %eax,%esi
80101d6e:	e9 38 ff ff ff       	jmp    80101cab <namex+0x4b>
80101d73:	90                   	nop
80101d74:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  while(*path != '/' && *path != 0)
80101d78:	89 da                	mov    %ebx,%edx
80101d7a:	31 c9                	xor    %ecx,%ecx
    memmove(name, s, len);
80101d7c:	83 ec 04             	sub    $0x4,%esp
80101d7f:	89 55 dc             	mov    %edx,-0x24(%ebp)
80101d82:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
80101d85:	51                   	push   %ecx
80101d86:	53                   	push   %ebx
80101d87:	57                   	push   %edi
80101d88:	e8 33 37 00 00       	call   801054c0 <memmove>
    name[len] = 0;
80101d8d:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80101d90:	8b 55 dc             	mov    -0x24(%ebp),%edx
80101d93:	83 c4 10             	add    $0x10,%esp
80101d96:	c6 04 0f 00          	movb   $0x0,(%edi,%ecx,1)
80101d9a:	89 d3                	mov    %edx,%ebx
80101d9c:	e9 61 ff ff ff       	jmp    80101d02 <namex+0xa2>
80101da1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      return 0;
    }
    iunlockput(ip);
    ip = next;
  }
  if(nameiparent){
80101da8:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101dab:	85 c0                	test   %eax,%eax
80101dad:	75 5d                	jne    80101e0c <namex+0x1ac>
    iput(ip);
    return 0;
  }
  return ip;
}
80101daf:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101db2:	89 f0                	mov    %esi,%eax
80101db4:	5b                   	pop    %ebx
80101db5:	5e                   	pop    %esi
80101db6:	5f                   	pop    %edi
80101db7:	5d                   	pop    %ebp
80101db8:	c3                   	ret    
80101db9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  iunlock(ip);
80101dc0:	83 ec 0c             	sub    $0xc,%esp
80101dc3:	56                   	push   %esi
80101dc4:	e8 97 f9 ff ff       	call   80101760 <iunlock>
  iput(ip);
80101dc9:	89 34 24             	mov    %esi,(%esp)
      return 0;
80101dcc:	31 f6                	xor    %esi,%esi
  iput(ip);
80101dce:	e8 dd f9 ff ff       	call   801017b0 <iput>
      return 0;
80101dd3:	83 c4 10             	add    $0x10,%esp
}
80101dd6:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101dd9:	89 f0                	mov    %esi,%eax
80101ddb:	5b                   	pop    %ebx
80101ddc:	5e                   	pop    %esi
80101ddd:	5f                   	pop    %edi
80101dde:	5d                   	pop    %ebp
80101ddf:	c3                   	ret    
    ip = iget(ROOTDEV, ROOTINO);
80101de0:	ba 01 00 00 00       	mov    $0x1,%edx
80101de5:	b8 01 00 00 00       	mov    $0x1,%eax
80101dea:	e8 a1 f4 ff ff       	call   80101290 <iget>
80101def:	89 c6                	mov    %eax,%esi
80101df1:	e9 b5 fe ff ff       	jmp    80101cab <namex+0x4b>
      iunlock(ip);
80101df6:	83 ec 0c             	sub    $0xc,%esp
80101df9:	56                   	push   %esi
80101dfa:	e8 61 f9 ff ff       	call   80101760 <iunlock>
      return ip;
80101dff:	83 c4 10             	add    $0x10,%esp
}
80101e02:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101e05:	89 f0                	mov    %esi,%eax
80101e07:	5b                   	pop    %ebx
80101e08:	5e                   	pop    %esi
80101e09:	5f                   	pop    %edi
80101e0a:	5d                   	pop    %ebp
80101e0b:	c3                   	ret    
    iput(ip);
80101e0c:	83 ec 0c             	sub    $0xc,%esp
80101e0f:	56                   	push   %esi
    return 0;
80101e10:	31 f6                	xor    %esi,%esi
    iput(ip);
80101e12:	e8 99 f9 ff ff       	call   801017b0 <iput>
    return 0;
80101e17:	83 c4 10             	add    $0x10,%esp
80101e1a:	eb 93                	jmp    80101daf <namex+0x14f>
80101e1c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101e20 <dirlink>:
{
80101e20:	55                   	push   %ebp
80101e21:	89 e5                	mov    %esp,%ebp
80101e23:	57                   	push   %edi
80101e24:	56                   	push   %esi
80101e25:	53                   	push   %ebx
80101e26:	83 ec 20             	sub    $0x20,%esp
80101e29:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if((ip = dirlookup(dp, name, 0)) != 0){
80101e2c:	6a 00                	push   $0x0
80101e2e:	ff 75 0c             	pushl  0xc(%ebp)
80101e31:	53                   	push   %ebx
80101e32:	e8 79 fd ff ff       	call   80101bb0 <dirlookup>
80101e37:	83 c4 10             	add    $0x10,%esp
80101e3a:	85 c0                	test   %eax,%eax
80101e3c:	75 67                	jne    80101ea5 <dirlink+0x85>
  for(off = 0; off < dp->size; off += sizeof(de)){
80101e3e:	8b 7b 58             	mov    0x58(%ebx),%edi
80101e41:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101e44:	85 ff                	test   %edi,%edi
80101e46:	74 29                	je     80101e71 <dirlink+0x51>
80101e48:	31 ff                	xor    %edi,%edi
80101e4a:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101e4d:	eb 09                	jmp    80101e58 <dirlink+0x38>
80101e4f:	90                   	nop
80101e50:	83 c7 10             	add    $0x10,%edi
80101e53:	3b 7b 58             	cmp    0x58(%ebx),%edi
80101e56:	73 19                	jae    80101e71 <dirlink+0x51>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101e58:	6a 10                	push   $0x10
80101e5a:	57                   	push   %edi
80101e5b:	56                   	push   %esi
80101e5c:	53                   	push   %ebx
80101e5d:	e8 fe fa ff ff       	call   80101960 <readi>
80101e62:	83 c4 10             	add    $0x10,%esp
80101e65:	83 f8 10             	cmp    $0x10,%eax
80101e68:	75 4e                	jne    80101eb8 <dirlink+0x98>
    if(de.inum == 0)
80101e6a:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80101e6f:	75 df                	jne    80101e50 <dirlink+0x30>
  strncpy(de.name, name, DIRSIZ);
80101e71:	8d 45 da             	lea    -0x26(%ebp),%eax
80101e74:	83 ec 04             	sub    $0x4,%esp
80101e77:	6a 0e                	push   $0xe
80101e79:	ff 75 0c             	pushl  0xc(%ebp)
80101e7c:	50                   	push   %eax
80101e7d:	e8 0e 37 00 00       	call   80105590 <strncpy>
  de.inum = inum;
80101e82:	8b 45 10             	mov    0x10(%ebp),%eax
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101e85:	6a 10                	push   $0x10
80101e87:	57                   	push   %edi
80101e88:	56                   	push   %esi
80101e89:	53                   	push   %ebx
  de.inum = inum;
80101e8a:	66 89 45 d8          	mov    %ax,-0x28(%ebp)
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101e8e:	e8 cd fb ff ff       	call   80101a60 <writei>
80101e93:	83 c4 20             	add    $0x20,%esp
80101e96:	83 f8 10             	cmp    $0x10,%eax
80101e99:	75 2a                	jne    80101ec5 <dirlink+0xa5>
  return 0;
80101e9b:	31 c0                	xor    %eax,%eax
}
80101e9d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101ea0:	5b                   	pop    %ebx
80101ea1:	5e                   	pop    %esi
80101ea2:	5f                   	pop    %edi
80101ea3:	5d                   	pop    %ebp
80101ea4:	c3                   	ret    
    iput(ip);
80101ea5:	83 ec 0c             	sub    $0xc,%esp
80101ea8:	50                   	push   %eax
80101ea9:	e8 02 f9 ff ff       	call   801017b0 <iput>
    return -1;
80101eae:	83 c4 10             	add    $0x10,%esp
80101eb1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101eb6:	eb e5                	jmp    80101e9d <dirlink+0x7d>
      panic("dirlink read");
80101eb8:	83 ec 0c             	sub    $0xc,%esp
80101ebb:	68 68 81 10 80       	push   $0x80108168
80101ec0:	e8 cb e4 ff ff       	call   80100390 <panic>
    panic("dirlink");
80101ec5:	83 ec 0c             	sub    $0xc,%esp
80101ec8:	68 ce 88 10 80       	push   $0x801088ce
80101ecd:	e8 be e4 ff ff       	call   80100390 <panic>
80101ed2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101ed9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101ee0 <namei>:

struct inode*
namei(char *path)
{
80101ee0:	55                   	push   %ebp
  char name[DIRSIZ];
  return namex(path, 0, name);
80101ee1:	31 d2                	xor    %edx,%edx
{
80101ee3:	89 e5                	mov    %esp,%ebp
80101ee5:	83 ec 18             	sub    $0x18,%esp
  return namex(path, 0, name);
80101ee8:	8b 45 08             	mov    0x8(%ebp),%eax
80101eeb:	8d 4d ea             	lea    -0x16(%ebp),%ecx
80101eee:	e8 6d fd ff ff       	call   80101c60 <namex>
}
80101ef3:	c9                   	leave  
80101ef4:	c3                   	ret    
80101ef5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101ef9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101f00 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
80101f00:	55                   	push   %ebp
  return namex(path, 1, name);
80101f01:	ba 01 00 00 00       	mov    $0x1,%edx
{
80101f06:	89 e5                	mov    %esp,%ebp
  return namex(path, 1, name);
80101f08:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80101f0b:	8b 45 08             	mov    0x8(%ebp),%eax
}
80101f0e:	5d                   	pop    %ebp
  return namex(path, 1, name);
80101f0f:	e9 4c fd ff ff       	jmp    80101c60 <namex>
80101f14:	66 90                	xchg   %ax,%ax
80101f16:	66 90                	xchg   %ax,%ax
80101f18:	66 90                	xchg   %ax,%ax
80101f1a:	66 90                	xchg   %ax,%ax
80101f1c:	66 90                	xchg   %ax,%ax
80101f1e:	66 90                	xchg   %ax,%ax

80101f20 <idestart>:
}

// Start the request for b.  Caller must hold idelock.
static void
idestart(struct buf *b)
{
80101f20:	55                   	push   %ebp
80101f21:	89 e5                	mov    %esp,%ebp
80101f23:	57                   	push   %edi
80101f24:	56                   	push   %esi
80101f25:	53                   	push   %ebx
80101f26:	83 ec 0c             	sub    $0xc,%esp
  if(b == 0)
80101f29:	85 c0                	test   %eax,%eax
80101f2b:	0f 84 b4 00 00 00    	je     80101fe5 <idestart+0xc5>
    panic("idestart");
  if(b->blockno >= FSSIZE)
80101f31:	8b 58 08             	mov    0x8(%eax),%ebx
80101f34:	89 c6                	mov    %eax,%esi
80101f36:	81 fb e7 03 00 00    	cmp    $0x3e7,%ebx
80101f3c:	0f 87 96 00 00 00    	ja     80101fd8 <idestart+0xb8>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80101f42:	b9 f7 01 00 00       	mov    $0x1f7,%ecx
80101f47:	89 f6                	mov    %esi,%esi
80101f49:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80101f50:	89 ca                	mov    %ecx,%edx
80101f52:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80101f53:	83 e0 c0             	and    $0xffffffc0,%eax
80101f56:	3c 40                	cmp    $0x40,%al
80101f58:	75 f6                	jne    80101f50 <idestart+0x30>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80101f5a:	31 ff                	xor    %edi,%edi
80101f5c:	ba f6 03 00 00       	mov    $0x3f6,%edx
80101f61:	89 f8                	mov    %edi,%eax
80101f63:	ee                   	out    %al,(%dx)
80101f64:	b8 01 00 00 00       	mov    $0x1,%eax
80101f69:	ba f2 01 00 00       	mov    $0x1f2,%edx
80101f6e:	ee                   	out    %al,(%dx)
80101f6f:	ba f3 01 00 00       	mov    $0x1f3,%edx
80101f74:	89 d8                	mov    %ebx,%eax
80101f76:	ee                   	out    %al,(%dx)

  idewait(0);
  outb(0x3f6, 0);  // generate interrupt
  outb(0x1f2, sector_per_block);  // number of sectors
  outb(0x1f3, sector & 0xff);
  outb(0x1f4, (sector >> 8) & 0xff);
80101f77:	89 d8                	mov    %ebx,%eax
80101f79:	ba f4 01 00 00       	mov    $0x1f4,%edx
80101f7e:	c1 f8 08             	sar    $0x8,%eax
80101f81:	ee                   	out    %al,(%dx)
80101f82:	ba f5 01 00 00       	mov    $0x1f5,%edx
80101f87:	89 f8                	mov    %edi,%eax
80101f89:	ee                   	out    %al,(%dx)
  outb(0x1f5, (sector >> 16) & 0xff);
  outb(0x1f6, 0xe0 | ((b->dev&1)<<4) | ((sector>>24)&0x0f));
80101f8a:	0f b6 46 04          	movzbl 0x4(%esi),%eax
80101f8e:	ba f6 01 00 00       	mov    $0x1f6,%edx
80101f93:	c1 e0 04             	shl    $0x4,%eax
80101f96:	83 e0 10             	and    $0x10,%eax
80101f99:	83 c8 e0             	or     $0xffffffe0,%eax
80101f9c:	ee                   	out    %al,(%dx)
  if(b->flags & B_DIRTY){
80101f9d:	f6 06 04             	testb  $0x4,(%esi)
80101fa0:	75 16                	jne    80101fb8 <idestart+0x98>
80101fa2:	b8 20 00 00 00       	mov    $0x20,%eax
80101fa7:	89 ca                	mov    %ecx,%edx
80101fa9:	ee                   	out    %al,(%dx)
    outb(0x1f7, write_cmd);
    outsl(0x1f0, b->data, BSIZE/4);
  } else {
    outb(0x1f7, read_cmd);
  }
}
80101faa:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101fad:	5b                   	pop    %ebx
80101fae:	5e                   	pop    %esi
80101faf:	5f                   	pop    %edi
80101fb0:	5d                   	pop    %ebp
80101fb1:	c3                   	ret    
80101fb2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80101fb8:	b8 30 00 00 00       	mov    $0x30,%eax
80101fbd:	89 ca                	mov    %ecx,%edx
80101fbf:	ee                   	out    %al,(%dx)
  asm volatile("cld; rep outsl" :
80101fc0:	b9 80 00 00 00       	mov    $0x80,%ecx
    outsl(0x1f0, b->data, BSIZE/4);
80101fc5:	83 c6 5c             	add    $0x5c,%esi
80101fc8:	ba f0 01 00 00       	mov    $0x1f0,%edx
80101fcd:	fc                   	cld    
80101fce:	f3 6f                	rep outsl %ds:(%esi),(%dx)
}
80101fd0:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101fd3:	5b                   	pop    %ebx
80101fd4:	5e                   	pop    %esi
80101fd5:	5f                   	pop    %edi
80101fd6:	5d                   	pop    %ebp
80101fd7:	c3                   	ret    
    panic("incorrect blockno");
80101fd8:	83 ec 0c             	sub    $0xc,%esp
80101fdb:	68 d4 81 10 80       	push   $0x801081d4
80101fe0:	e8 ab e3 ff ff       	call   80100390 <panic>
    panic("idestart");
80101fe5:	83 ec 0c             	sub    $0xc,%esp
80101fe8:	68 cb 81 10 80       	push   $0x801081cb
80101fed:	e8 9e e3 ff ff       	call   80100390 <panic>
80101ff2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101ff9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102000 <ideinit>:
{
80102000:	55                   	push   %ebp
80102001:	89 e5                	mov    %esp,%ebp
80102003:	83 ec 10             	sub    $0x10,%esp
  initlock(&idelock, "ide");
80102006:	68 e6 81 10 80       	push   $0x801081e6
8010200b:	68 a0 b5 10 80       	push   $0x8010b5a0
80102010:	e8 ab 31 00 00       	call   801051c0 <initlock>
  ioapicenable(IRQ_IDE, ncpu - 1);
80102015:	58                   	pop    %eax
80102016:	a1 60 3d 11 80       	mov    0x80113d60,%eax
8010201b:	5a                   	pop    %edx
8010201c:	83 e8 01             	sub    $0x1,%eax
8010201f:	50                   	push   %eax
80102020:	6a 0e                	push   $0xe
80102022:	e8 a9 02 00 00       	call   801022d0 <ioapicenable>
80102027:	83 c4 10             	add    $0x10,%esp
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010202a:	ba f7 01 00 00       	mov    $0x1f7,%edx
8010202f:	90                   	nop
80102030:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80102031:	83 e0 c0             	and    $0xffffffc0,%eax
80102034:	3c 40                	cmp    $0x40,%al
80102036:	75 f8                	jne    80102030 <ideinit+0x30>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102038:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
8010203d:	ba f6 01 00 00       	mov    $0x1f6,%edx
80102042:	ee                   	out    %al,(%dx)
80102043:	b9 e8 03 00 00       	mov    $0x3e8,%ecx
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102048:	ba f7 01 00 00       	mov    $0x1f7,%edx
8010204d:	eb 06                	jmp    80102055 <ideinit+0x55>
8010204f:	90                   	nop
  for(i=0; i<1000; i++){
80102050:	83 e9 01             	sub    $0x1,%ecx
80102053:	74 0f                	je     80102064 <ideinit+0x64>
80102055:	ec                   	in     (%dx),%al
    if(inb(0x1f7) != 0){
80102056:	84 c0                	test   %al,%al
80102058:	74 f6                	je     80102050 <ideinit+0x50>
      havedisk1 = 1;
8010205a:	c7 05 80 b5 10 80 01 	movl   $0x1,0x8010b580
80102061:	00 00 00 
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102064:	b8 e0 ff ff ff       	mov    $0xffffffe0,%eax
80102069:	ba f6 01 00 00       	mov    $0x1f6,%edx
8010206e:	ee                   	out    %al,(%dx)
}
8010206f:	c9                   	leave  
80102070:	c3                   	ret    
80102071:	eb 0d                	jmp    80102080 <ideintr>
80102073:	90                   	nop
80102074:	90                   	nop
80102075:	90                   	nop
80102076:	90                   	nop
80102077:	90                   	nop
80102078:	90                   	nop
80102079:	90                   	nop
8010207a:	90                   	nop
8010207b:	90                   	nop
8010207c:	90                   	nop
8010207d:	90                   	nop
8010207e:	90                   	nop
8010207f:	90                   	nop

80102080 <ideintr>:

// Interrupt handler.
void
ideintr(void)
{
80102080:	55                   	push   %ebp
80102081:	89 e5                	mov    %esp,%ebp
80102083:	57                   	push   %edi
80102084:	56                   	push   %esi
80102085:	53                   	push   %ebx
80102086:	83 ec 18             	sub    $0x18,%esp
  struct buf *b;

  // First queued buffer is the active request.
  acquire(&idelock);
80102089:	68 a0 b5 10 80       	push   $0x8010b5a0
8010208e:	e8 6d 32 00 00       	call   80105300 <acquire>

  if((b = idequeue) == 0){
80102093:	8b 1d 84 b5 10 80    	mov    0x8010b584,%ebx
80102099:	83 c4 10             	add    $0x10,%esp
8010209c:	85 db                	test   %ebx,%ebx
8010209e:	74 67                	je     80102107 <ideintr+0x87>
    release(&idelock);
    return;
  }
  idequeue = b->qnext;
801020a0:	8b 43 58             	mov    0x58(%ebx),%eax
801020a3:	a3 84 b5 10 80       	mov    %eax,0x8010b584

  // Read data if needed.
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
801020a8:	8b 3b                	mov    (%ebx),%edi
801020aa:	f7 c7 04 00 00 00    	test   $0x4,%edi
801020b0:	75 31                	jne    801020e3 <ideintr+0x63>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801020b2:	ba f7 01 00 00       	mov    $0x1f7,%edx
801020b7:	89 f6                	mov    %esi,%esi
801020b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
801020c0:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
801020c1:	89 c6                	mov    %eax,%esi
801020c3:	83 e6 c0             	and    $0xffffffc0,%esi
801020c6:	89 f1                	mov    %esi,%ecx
801020c8:	80 f9 40             	cmp    $0x40,%cl
801020cb:	75 f3                	jne    801020c0 <ideintr+0x40>
  if(checkerr && (r & (IDE_DF|IDE_ERR)) != 0)
801020cd:	a8 21                	test   $0x21,%al
801020cf:	75 12                	jne    801020e3 <ideintr+0x63>
    insl(0x1f0, b->data, BSIZE/4);
801020d1:	8d 7b 5c             	lea    0x5c(%ebx),%edi
  asm volatile("cld; rep insl" :
801020d4:	b9 80 00 00 00       	mov    $0x80,%ecx
801020d9:	ba f0 01 00 00       	mov    $0x1f0,%edx
801020de:	fc                   	cld    
801020df:	f3 6d                	rep insl (%dx),%es:(%edi)
801020e1:	8b 3b                	mov    (%ebx),%edi

  // Wake process waiting for this buf.
  b->flags |= B_VALID;
  b->flags &= ~B_DIRTY;
801020e3:	83 e7 fb             	and    $0xfffffffb,%edi
  wakeup(b);
801020e6:	83 ec 0c             	sub    $0xc,%esp
  b->flags &= ~B_DIRTY;
801020e9:	89 f9                	mov    %edi,%ecx
801020eb:	83 c9 02             	or     $0x2,%ecx
801020ee:	89 0b                	mov    %ecx,(%ebx)
  wakeup(b);
801020f0:	53                   	push   %ebx
801020f1:	e8 3a 2a 00 00       	call   80104b30 <wakeup>

  // Start disk on next buf in queue.
  if(idequeue != 0)
801020f6:	a1 84 b5 10 80       	mov    0x8010b584,%eax
801020fb:	83 c4 10             	add    $0x10,%esp
801020fe:	85 c0                	test   %eax,%eax
80102100:	74 05                	je     80102107 <ideintr+0x87>
    idestart(idequeue);
80102102:	e8 19 fe ff ff       	call   80101f20 <idestart>
    release(&idelock);
80102107:	83 ec 0c             	sub    $0xc,%esp
8010210a:	68 a0 b5 10 80       	push   $0x8010b5a0
8010210f:	e8 ac 32 00 00       	call   801053c0 <release>

  release(&idelock);
}
80102114:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102117:	5b                   	pop    %ebx
80102118:	5e                   	pop    %esi
80102119:	5f                   	pop    %edi
8010211a:	5d                   	pop    %ebp
8010211b:	c3                   	ret    
8010211c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102120 <iderw>:
// Sync buf with disk.
// If B_DIRTY is set, write buf to disk, clear B_DIRTY, set B_VALID.
// Else if B_VALID is not set, read buf from disk, set B_VALID.
void
iderw(struct buf *b)
{
80102120:	55                   	push   %ebp
80102121:	89 e5                	mov    %esp,%ebp
80102123:	53                   	push   %ebx
80102124:	83 ec 10             	sub    $0x10,%esp
80102127:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct buf **pp;

  if(!holdingsleep(&b->lock))
8010212a:	8d 43 0c             	lea    0xc(%ebx),%eax
8010212d:	50                   	push   %eax
8010212e:	e8 3d 30 00 00       	call   80105170 <holdingsleep>
80102133:	83 c4 10             	add    $0x10,%esp
80102136:	85 c0                	test   %eax,%eax
80102138:	0f 84 c6 00 00 00    	je     80102204 <iderw+0xe4>
    panic("iderw: buf not locked");
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
8010213e:	8b 03                	mov    (%ebx),%eax
80102140:	83 e0 06             	and    $0x6,%eax
80102143:	83 f8 02             	cmp    $0x2,%eax
80102146:	0f 84 ab 00 00 00    	je     801021f7 <iderw+0xd7>
    panic("iderw: nothing to do");
  if(b->dev != 0 && !havedisk1)
8010214c:	8b 53 04             	mov    0x4(%ebx),%edx
8010214f:	85 d2                	test   %edx,%edx
80102151:	74 0d                	je     80102160 <iderw+0x40>
80102153:	a1 80 b5 10 80       	mov    0x8010b580,%eax
80102158:	85 c0                	test   %eax,%eax
8010215a:	0f 84 b1 00 00 00    	je     80102211 <iderw+0xf1>
    panic("iderw: ide disk 1 not present");

  acquire(&idelock);  //DOC:acquire-lock
80102160:	83 ec 0c             	sub    $0xc,%esp
80102163:	68 a0 b5 10 80       	push   $0x8010b5a0
80102168:	e8 93 31 00 00       	call   80105300 <acquire>

  // Append b to idequeue.
  b->qnext = 0;
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
8010216d:	8b 15 84 b5 10 80    	mov    0x8010b584,%edx
80102173:	83 c4 10             	add    $0x10,%esp
  b->qnext = 0;
80102176:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
8010217d:	85 d2                	test   %edx,%edx
8010217f:	75 09                	jne    8010218a <iderw+0x6a>
80102181:	eb 6d                	jmp    801021f0 <iderw+0xd0>
80102183:	90                   	nop
80102184:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102188:	89 c2                	mov    %eax,%edx
8010218a:	8b 42 58             	mov    0x58(%edx),%eax
8010218d:	85 c0                	test   %eax,%eax
8010218f:	75 f7                	jne    80102188 <iderw+0x68>
80102191:	83 c2 58             	add    $0x58,%edx
    ;
  *pp = b;
80102194:	89 1a                	mov    %ebx,(%edx)

  // Start disk if necessary.
  if(idequeue == b)
80102196:	39 1d 84 b5 10 80    	cmp    %ebx,0x8010b584
8010219c:	74 42                	je     801021e0 <iderw+0xc0>
    idestart(b);

  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
8010219e:	8b 03                	mov    (%ebx),%eax
801021a0:	83 e0 06             	and    $0x6,%eax
801021a3:	83 f8 02             	cmp    $0x2,%eax
801021a6:	74 23                	je     801021cb <iderw+0xab>
801021a8:	90                   	nop
801021a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    sleep(b, &idelock);
801021b0:	83 ec 08             	sub    $0x8,%esp
801021b3:	68 a0 b5 10 80       	push   $0x8010b5a0
801021b8:	53                   	push   %ebx
801021b9:	e8 a2 27 00 00       	call   80104960 <sleep>
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
801021be:	8b 03                	mov    (%ebx),%eax
801021c0:	83 c4 10             	add    $0x10,%esp
801021c3:	83 e0 06             	and    $0x6,%eax
801021c6:	83 f8 02             	cmp    $0x2,%eax
801021c9:	75 e5                	jne    801021b0 <iderw+0x90>
  }


  release(&idelock);
801021cb:	c7 45 08 a0 b5 10 80 	movl   $0x8010b5a0,0x8(%ebp)
}
801021d2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801021d5:	c9                   	leave  
  release(&idelock);
801021d6:	e9 e5 31 00 00       	jmp    801053c0 <release>
801021db:	90                   	nop
801021dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    idestart(b);
801021e0:	89 d8                	mov    %ebx,%eax
801021e2:	e8 39 fd ff ff       	call   80101f20 <idestart>
801021e7:	eb b5                	jmp    8010219e <iderw+0x7e>
801021e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
801021f0:	ba 84 b5 10 80       	mov    $0x8010b584,%edx
801021f5:	eb 9d                	jmp    80102194 <iderw+0x74>
    panic("iderw: nothing to do");
801021f7:	83 ec 0c             	sub    $0xc,%esp
801021fa:	68 00 82 10 80       	push   $0x80108200
801021ff:	e8 8c e1 ff ff       	call   80100390 <panic>
    panic("iderw: buf not locked");
80102204:	83 ec 0c             	sub    $0xc,%esp
80102207:	68 ea 81 10 80       	push   $0x801081ea
8010220c:	e8 7f e1 ff ff       	call   80100390 <panic>
    panic("iderw: ide disk 1 not present");
80102211:	83 ec 0c             	sub    $0xc,%esp
80102214:	68 15 82 10 80       	push   $0x80108215
80102219:	e8 72 e1 ff ff       	call   80100390 <panic>
8010221e:	66 90                	xchg   %ax,%ax

80102220 <ioapicinit>:
  ioapic->data = data;
}

void
ioapicinit(void)
{
80102220:	55                   	push   %ebp
  int i, id, maxintr;

  ioapic = (volatile struct ioapic*)IOAPIC;
80102221:	c7 05 94 36 11 80 00 	movl   $0xfec00000,0x80113694
80102228:	00 c0 fe 
{
8010222b:	89 e5                	mov    %esp,%ebp
8010222d:	56                   	push   %esi
8010222e:	53                   	push   %ebx
  ioapic->reg = reg;
8010222f:	c7 05 00 00 c0 fe 01 	movl   $0x1,0xfec00000
80102236:	00 00 00 
  return ioapic->data;
80102239:	a1 94 36 11 80       	mov    0x80113694,%eax
8010223e:	8b 58 10             	mov    0x10(%eax),%ebx
  ioapic->reg = reg;
80102241:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  return ioapic->data;
80102247:	8b 0d 94 36 11 80    	mov    0x80113694,%ecx
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
  id = ioapicread(REG_ID) >> 24;
  if(id != ioapicid)
8010224d:	0f b6 15 c0 37 11 80 	movzbl 0x801137c0,%edx
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
80102254:	c1 eb 10             	shr    $0x10,%ebx
  return ioapic->data;
80102257:	8b 41 10             	mov    0x10(%ecx),%eax
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
8010225a:	0f b6 db             	movzbl %bl,%ebx
  id = ioapicread(REG_ID) >> 24;
8010225d:	c1 e8 18             	shr    $0x18,%eax
  if(id != ioapicid)
80102260:	39 c2                	cmp    %eax,%edx
80102262:	74 16                	je     8010227a <ioapicinit+0x5a>
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");
80102264:	83 ec 0c             	sub    $0xc,%esp
80102267:	68 34 82 10 80       	push   $0x80108234
8010226c:	e8 ef e3 ff ff       	call   80100660 <cprintf>
80102271:	8b 0d 94 36 11 80    	mov    0x80113694,%ecx
80102277:	83 c4 10             	add    $0x10,%esp
8010227a:	83 c3 21             	add    $0x21,%ebx
{
8010227d:	ba 10 00 00 00       	mov    $0x10,%edx
80102282:	b8 20 00 00 00       	mov    $0x20,%eax
80102287:	89 f6                	mov    %esi,%esi
80102289:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  ioapic->reg = reg;
80102290:	89 11                	mov    %edx,(%ecx)
  ioapic->data = data;
80102292:	8b 0d 94 36 11 80    	mov    0x80113694,%ecx

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
80102298:	89 c6                	mov    %eax,%esi
8010229a:	81 ce 00 00 01 00    	or     $0x10000,%esi
801022a0:	83 c0 01             	add    $0x1,%eax
  ioapic->data = data;
801022a3:	89 71 10             	mov    %esi,0x10(%ecx)
801022a6:	8d 72 01             	lea    0x1(%edx),%esi
801022a9:	83 c2 02             	add    $0x2,%edx
  for(i = 0; i <= maxintr; i++){
801022ac:	39 d8                	cmp    %ebx,%eax
  ioapic->reg = reg;
801022ae:	89 31                	mov    %esi,(%ecx)
  ioapic->data = data;
801022b0:	8b 0d 94 36 11 80    	mov    0x80113694,%ecx
801022b6:	c7 41 10 00 00 00 00 	movl   $0x0,0x10(%ecx)
  for(i = 0; i <= maxintr; i++){
801022bd:	75 d1                	jne    80102290 <ioapicinit+0x70>
    ioapicwrite(REG_TABLE+2*i+1, 0);
  }
}
801022bf:	8d 65 f8             	lea    -0x8(%ebp),%esp
801022c2:	5b                   	pop    %ebx
801022c3:	5e                   	pop    %esi
801022c4:	5d                   	pop    %ebp
801022c5:	c3                   	ret    
801022c6:	8d 76 00             	lea    0x0(%esi),%esi
801022c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801022d0 <ioapicenable>:

void
ioapicenable(int irq, int cpunum)
{
801022d0:	55                   	push   %ebp
  ioapic->reg = reg;
801022d1:	8b 0d 94 36 11 80    	mov    0x80113694,%ecx
{
801022d7:	89 e5                	mov    %esp,%ebp
801022d9:	8b 45 08             	mov    0x8(%ebp),%eax
  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
801022dc:	8d 50 20             	lea    0x20(%eax),%edx
801022df:	8d 44 00 10          	lea    0x10(%eax,%eax,1),%eax
  ioapic->reg = reg;
801022e3:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
801022e5:	8b 0d 94 36 11 80    	mov    0x80113694,%ecx
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
801022eb:	83 c0 01             	add    $0x1,%eax
  ioapic->data = data;
801022ee:	89 51 10             	mov    %edx,0x10(%ecx)
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
801022f1:	8b 55 0c             	mov    0xc(%ebp),%edx
  ioapic->reg = reg;
801022f4:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
801022f6:	a1 94 36 11 80       	mov    0x80113694,%eax
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
801022fb:	c1 e2 18             	shl    $0x18,%edx
  ioapic->data = data;
801022fe:	89 50 10             	mov    %edx,0x10(%eax)
}
80102301:	5d                   	pop    %ebp
80102302:	c3                   	ret    
80102303:	66 90                	xchg   %ax,%ax
80102305:	66 90                	xchg   %ax,%ax
80102307:	66 90                	xchg   %ax,%ax
80102309:	66 90                	xchg   %ax,%ax
8010230b:	66 90                	xchg   %ax,%ax
8010230d:	66 90                	xchg   %ax,%ax
8010230f:	90                   	nop

80102310 <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(char *v)
{
80102310:	55                   	push   %ebp
80102311:	89 e5                	mov    %esp,%ebp
80102313:	53                   	push   %ebx
80102314:	83 ec 04             	sub    $0x4,%esp
80102317:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct run *r;

  if((uint)v % PGSIZE || v < end || V2P(v) >= PHYSTOP)
8010231a:	f7 c3 ff 0f 00 00    	test   $0xfff,%ebx
80102320:	75 70                	jne    80102392 <kfree+0x82>
80102322:	81 fb 08 86 11 80    	cmp    $0x80118608,%ebx
80102328:	72 68                	jb     80102392 <kfree+0x82>
8010232a:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80102330:	3d ff ff ff 0d       	cmp    $0xdffffff,%eax
80102335:	77 5b                	ja     80102392 <kfree+0x82>
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);
80102337:	83 ec 04             	sub    $0x4,%esp
8010233a:	68 00 10 00 00       	push   $0x1000
8010233f:	6a 01                	push   $0x1
80102341:	53                   	push   %ebx
80102342:	e8 c9 30 00 00       	call   80105410 <memset>

  if(kmem.use_lock)
80102347:	8b 15 d4 36 11 80    	mov    0x801136d4,%edx
8010234d:	83 c4 10             	add    $0x10,%esp
80102350:	85 d2                	test   %edx,%edx
80102352:	75 2c                	jne    80102380 <kfree+0x70>
    acquire(&kmem.lock);
  r = (struct run*)v;
  r->next = kmem.freelist;
80102354:	a1 d8 36 11 80       	mov    0x801136d8,%eax
80102359:	89 03                	mov    %eax,(%ebx)
  kmem.freelist = r;
  if(kmem.use_lock)
8010235b:	a1 d4 36 11 80       	mov    0x801136d4,%eax
  kmem.freelist = r;
80102360:	89 1d d8 36 11 80    	mov    %ebx,0x801136d8
  if(kmem.use_lock)
80102366:	85 c0                	test   %eax,%eax
80102368:	75 06                	jne    80102370 <kfree+0x60>
    release(&kmem.lock);
}
8010236a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010236d:	c9                   	leave  
8010236e:	c3                   	ret    
8010236f:	90                   	nop
    release(&kmem.lock);
80102370:	c7 45 08 a0 36 11 80 	movl   $0x801136a0,0x8(%ebp)
}
80102377:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010237a:	c9                   	leave  
    release(&kmem.lock);
8010237b:	e9 40 30 00 00       	jmp    801053c0 <release>
    acquire(&kmem.lock);
80102380:	83 ec 0c             	sub    $0xc,%esp
80102383:	68 a0 36 11 80       	push   $0x801136a0
80102388:	e8 73 2f 00 00       	call   80105300 <acquire>
8010238d:	83 c4 10             	add    $0x10,%esp
80102390:	eb c2                	jmp    80102354 <kfree+0x44>
    panic("kfree");
80102392:	83 ec 0c             	sub    $0xc,%esp
80102395:	68 66 82 10 80       	push   $0x80108266
8010239a:	e8 f1 df ff ff       	call   80100390 <panic>
8010239f:	90                   	nop

801023a0 <freerange>:
{
801023a0:	55                   	push   %ebp
801023a1:	89 e5                	mov    %esp,%ebp
801023a3:	56                   	push   %esi
801023a4:	53                   	push   %ebx
  p = (char*)PGROUNDUP((uint)vstart);
801023a5:	8b 45 08             	mov    0x8(%ebp),%eax
{
801023a8:	8b 75 0c             	mov    0xc(%ebp),%esi
  p = (char*)PGROUNDUP((uint)vstart);
801023ab:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
801023b1:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801023b7:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801023bd:	39 de                	cmp    %ebx,%esi
801023bf:	72 23                	jb     801023e4 <freerange+0x44>
801023c1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    kfree(p);
801023c8:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
801023ce:	83 ec 0c             	sub    $0xc,%esp
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801023d1:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
801023d7:	50                   	push   %eax
801023d8:	e8 33 ff ff ff       	call   80102310 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801023dd:	83 c4 10             	add    $0x10,%esp
801023e0:	39 f3                	cmp    %esi,%ebx
801023e2:	76 e4                	jbe    801023c8 <freerange+0x28>
}
801023e4:	8d 65 f8             	lea    -0x8(%ebp),%esp
801023e7:	5b                   	pop    %ebx
801023e8:	5e                   	pop    %esi
801023e9:	5d                   	pop    %ebp
801023ea:	c3                   	ret    
801023eb:	90                   	nop
801023ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801023f0 <kinit1>:
{
801023f0:	55                   	push   %ebp
801023f1:	89 e5                	mov    %esp,%ebp
801023f3:	56                   	push   %esi
801023f4:	53                   	push   %ebx
801023f5:	8b 75 0c             	mov    0xc(%ebp),%esi
  initlock(&kmem.lock, "kmem");
801023f8:	83 ec 08             	sub    $0x8,%esp
801023fb:	68 6c 82 10 80       	push   $0x8010826c
80102400:	68 a0 36 11 80       	push   $0x801136a0
80102405:	e8 b6 2d 00 00       	call   801051c0 <initlock>
  p = (char*)PGROUNDUP((uint)vstart);
8010240a:	8b 45 08             	mov    0x8(%ebp),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
8010240d:	83 c4 10             	add    $0x10,%esp
  kmem.use_lock = 0;
80102410:	c7 05 d4 36 11 80 00 	movl   $0x0,0x801136d4
80102417:	00 00 00 
  p = (char*)PGROUNDUP((uint)vstart);
8010241a:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102420:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102426:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010242c:	39 de                	cmp    %ebx,%esi
8010242e:	72 1c                	jb     8010244c <kinit1+0x5c>
    kfree(p);
80102430:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
80102436:	83 ec 0c             	sub    $0xc,%esp
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102439:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
8010243f:	50                   	push   %eax
80102440:	e8 cb fe ff ff       	call   80102310 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102445:	83 c4 10             	add    $0x10,%esp
80102448:	39 de                	cmp    %ebx,%esi
8010244a:	73 e4                	jae    80102430 <kinit1+0x40>
}
8010244c:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010244f:	5b                   	pop    %ebx
80102450:	5e                   	pop    %esi
80102451:	5d                   	pop    %ebp
80102452:	c3                   	ret    
80102453:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80102459:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102460 <kinit2>:
{
80102460:	55                   	push   %ebp
80102461:	89 e5                	mov    %esp,%ebp
80102463:	56                   	push   %esi
80102464:	53                   	push   %ebx
  p = (char*)PGROUNDUP((uint)vstart);
80102465:	8b 45 08             	mov    0x8(%ebp),%eax
{
80102468:	8b 75 0c             	mov    0xc(%ebp),%esi
  p = (char*)PGROUNDUP((uint)vstart);
8010246b:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102471:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102477:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010247d:	39 de                	cmp    %ebx,%esi
8010247f:	72 23                	jb     801024a4 <kinit2+0x44>
80102481:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    kfree(p);
80102488:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
8010248e:	83 ec 0c             	sub    $0xc,%esp
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102491:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
80102497:	50                   	push   %eax
80102498:	e8 73 fe ff ff       	call   80102310 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
8010249d:	83 c4 10             	add    $0x10,%esp
801024a0:	39 de                	cmp    %ebx,%esi
801024a2:	73 e4                	jae    80102488 <kinit2+0x28>
  kmem.use_lock = 1;
801024a4:	c7 05 d4 36 11 80 01 	movl   $0x1,0x801136d4
801024ab:	00 00 00 
}
801024ae:	8d 65 f8             	lea    -0x8(%ebp),%esp
801024b1:	5b                   	pop    %ebx
801024b2:	5e                   	pop    %esi
801024b3:	5d                   	pop    %ebp
801024b4:	c3                   	ret    
801024b5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801024b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801024c0 <kalloc>:
char*
kalloc(void)
{
  struct run *r;

  if(kmem.use_lock)
801024c0:	a1 d4 36 11 80       	mov    0x801136d4,%eax
801024c5:	85 c0                	test   %eax,%eax
801024c7:	75 1f                	jne    801024e8 <kalloc+0x28>
    acquire(&kmem.lock);
  r = kmem.freelist;
801024c9:	a1 d8 36 11 80       	mov    0x801136d8,%eax
  if(r)
801024ce:	85 c0                	test   %eax,%eax
801024d0:	74 0e                	je     801024e0 <kalloc+0x20>
    kmem.freelist = r->next;
801024d2:	8b 10                	mov    (%eax),%edx
801024d4:	89 15 d8 36 11 80    	mov    %edx,0x801136d8
801024da:	c3                   	ret    
801024db:	90                   	nop
801024dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if(kmem.use_lock)
    release(&kmem.lock);
  return (char*)r;
}
801024e0:	f3 c3                	repz ret 
801024e2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
{
801024e8:	55                   	push   %ebp
801024e9:	89 e5                	mov    %esp,%ebp
801024eb:	83 ec 24             	sub    $0x24,%esp
    acquire(&kmem.lock);
801024ee:	68 a0 36 11 80       	push   $0x801136a0
801024f3:	e8 08 2e 00 00       	call   80105300 <acquire>
  r = kmem.freelist;
801024f8:	a1 d8 36 11 80       	mov    0x801136d8,%eax
  if(r)
801024fd:	83 c4 10             	add    $0x10,%esp
80102500:	8b 15 d4 36 11 80    	mov    0x801136d4,%edx
80102506:	85 c0                	test   %eax,%eax
80102508:	74 08                	je     80102512 <kalloc+0x52>
    kmem.freelist = r->next;
8010250a:	8b 08                	mov    (%eax),%ecx
8010250c:	89 0d d8 36 11 80    	mov    %ecx,0x801136d8
  if(kmem.use_lock)
80102512:	85 d2                	test   %edx,%edx
80102514:	74 16                	je     8010252c <kalloc+0x6c>
    release(&kmem.lock);
80102516:	83 ec 0c             	sub    $0xc,%esp
80102519:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010251c:	68 a0 36 11 80       	push   $0x801136a0
80102521:	e8 9a 2e 00 00       	call   801053c0 <release>
  return (char*)r;
80102526:	8b 45 f4             	mov    -0xc(%ebp),%eax
    release(&kmem.lock);
80102529:	83 c4 10             	add    $0x10,%esp
}
8010252c:	c9                   	leave  
8010252d:	c3                   	ret    
8010252e:	66 90                	xchg   %ax,%ax

80102530 <kbdgetc>:
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102530:	ba 64 00 00 00       	mov    $0x64,%edx
80102535:	ec                   	in     (%dx),%al
    normalmap, shiftmap, ctlmap, ctlmap
  };
  uint st, data, c;

  st = inb(KBSTATP);
  if((st & KBS_DIB) == 0)
80102536:	a8 01                	test   $0x1,%al
80102538:	0f 84 c2 00 00 00    	je     80102600 <kbdgetc+0xd0>
8010253e:	ba 60 00 00 00       	mov    $0x60,%edx
80102543:	ec                   	in     (%dx),%al
    return -1;
  data = inb(KBDATAP);
80102544:	0f b6 d0             	movzbl %al,%edx
80102547:	8b 0d d4 b5 10 80    	mov    0x8010b5d4,%ecx

  if(data == 0xE0){
8010254d:	81 fa e0 00 00 00    	cmp    $0xe0,%edx
80102553:	0f 84 7f 00 00 00    	je     801025d8 <kbdgetc+0xa8>
{
80102559:	55                   	push   %ebp
8010255a:	89 e5                	mov    %esp,%ebp
8010255c:	53                   	push   %ebx
8010255d:	89 cb                	mov    %ecx,%ebx
8010255f:	83 e3 40             	and    $0x40,%ebx
    shift |= E0ESC;
    return 0;
  } else if(data & 0x80){
80102562:	84 c0                	test   %al,%al
80102564:	78 4a                	js     801025b0 <kbdgetc+0x80>
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
    shift &= ~(shiftcode[data] | E0ESC);
    return 0;
  } else if(shift & E0ESC){
80102566:	85 db                	test   %ebx,%ebx
80102568:	74 09                	je     80102573 <kbdgetc+0x43>
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
8010256a:	83 c8 80             	or     $0xffffff80,%eax
    shift &= ~E0ESC;
8010256d:	83 e1 bf             	and    $0xffffffbf,%ecx
    data |= 0x80;
80102570:	0f b6 d0             	movzbl %al,%edx
  }

  shift |= shiftcode[data];
80102573:	0f b6 82 a0 83 10 80 	movzbl -0x7fef7c60(%edx),%eax
8010257a:	09 c1                	or     %eax,%ecx
  shift ^= togglecode[data];
8010257c:	0f b6 82 a0 82 10 80 	movzbl -0x7fef7d60(%edx),%eax
80102583:	31 c1                	xor    %eax,%ecx
  c = charcode[shift & (CTL | SHIFT)][data];
80102585:	89 c8                	mov    %ecx,%eax
  shift ^= togglecode[data];
80102587:	89 0d d4 b5 10 80    	mov    %ecx,0x8010b5d4
  c = charcode[shift & (CTL | SHIFT)][data];
8010258d:	83 e0 03             	and    $0x3,%eax
  if(shift & CAPSLOCK){
80102590:	83 e1 08             	and    $0x8,%ecx
  c = charcode[shift & (CTL | SHIFT)][data];
80102593:	8b 04 85 80 82 10 80 	mov    -0x7fef7d80(,%eax,4),%eax
8010259a:	0f b6 04 10          	movzbl (%eax,%edx,1),%eax
  if(shift & CAPSLOCK){
8010259e:	74 31                	je     801025d1 <kbdgetc+0xa1>
    if('a' <= c && c <= 'z')
801025a0:	8d 50 9f             	lea    -0x61(%eax),%edx
801025a3:	83 fa 19             	cmp    $0x19,%edx
801025a6:	77 40                	ja     801025e8 <kbdgetc+0xb8>
      c += 'A' - 'a';
801025a8:	83 e8 20             	sub    $0x20,%eax
    else if('A' <= c && c <= 'Z')
      c += 'a' - 'A';
  }
  return c;
}
801025ab:	5b                   	pop    %ebx
801025ac:	5d                   	pop    %ebp
801025ad:	c3                   	ret    
801025ae:	66 90                	xchg   %ax,%ax
    data = (shift & E0ESC ? data : data & 0x7F);
801025b0:	83 e0 7f             	and    $0x7f,%eax
801025b3:	85 db                	test   %ebx,%ebx
801025b5:	0f 44 d0             	cmove  %eax,%edx
    shift &= ~(shiftcode[data] | E0ESC);
801025b8:	0f b6 82 a0 83 10 80 	movzbl -0x7fef7c60(%edx),%eax
801025bf:	83 c8 40             	or     $0x40,%eax
801025c2:	0f b6 c0             	movzbl %al,%eax
801025c5:	f7 d0                	not    %eax
801025c7:	21 c1                	and    %eax,%ecx
    return 0;
801025c9:	31 c0                	xor    %eax,%eax
    shift &= ~(shiftcode[data] | E0ESC);
801025cb:	89 0d d4 b5 10 80    	mov    %ecx,0x8010b5d4
}
801025d1:	5b                   	pop    %ebx
801025d2:	5d                   	pop    %ebp
801025d3:	c3                   	ret    
801025d4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    shift |= E0ESC;
801025d8:	83 c9 40             	or     $0x40,%ecx
    return 0;
801025db:	31 c0                	xor    %eax,%eax
    shift |= E0ESC;
801025dd:	89 0d d4 b5 10 80    	mov    %ecx,0x8010b5d4
    return 0;
801025e3:	c3                   	ret    
801025e4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    else if('A' <= c && c <= 'Z')
801025e8:	8d 48 bf             	lea    -0x41(%eax),%ecx
      c += 'a' - 'A';
801025eb:	8d 50 20             	lea    0x20(%eax),%edx
}
801025ee:	5b                   	pop    %ebx
      c += 'a' - 'A';
801025ef:	83 f9 1a             	cmp    $0x1a,%ecx
801025f2:	0f 42 c2             	cmovb  %edx,%eax
}
801025f5:	5d                   	pop    %ebp
801025f6:	c3                   	ret    
801025f7:	89 f6                	mov    %esi,%esi
801025f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    return -1;
80102600:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80102605:	c3                   	ret    
80102606:	8d 76 00             	lea    0x0(%esi),%esi
80102609:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102610 <kbdintr>:

void
kbdintr(void)
{
80102610:	55                   	push   %ebp
80102611:	89 e5                	mov    %esp,%ebp
80102613:	83 ec 14             	sub    $0x14,%esp
  consoleintr(kbdgetc);
80102616:	68 30 25 10 80       	push   $0x80102530
8010261b:	e8 f0 e1 ff ff       	call   80100810 <consoleintr>
}
80102620:	83 c4 10             	add    $0x10,%esp
80102623:	c9                   	leave  
80102624:	c3                   	ret    
80102625:	66 90                	xchg   %ax,%ax
80102627:	66 90                	xchg   %ax,%ax
80102629:	66 90                	xchg   %ax,%ax
8010262b:	66 90                	xchg   %ax,%ax
8010262d:	66 90                	xchg   %ax,%ax
8010262f:	90                   	nop

80102630 <lapicinit>:
}

void
lapicinit(void)
{
  if(!lapic)
80102630:	a1 dc 36 11 80       	mov    0x801136dc,%eax
{
80102635:	55                   	push   %ebp
80102636:	89 e5                	mov    %esp,%ebp
  if(!lapic)
80102638:	85 c0                	test   %eax,%eax
8010263a:	0f 84 c8 00 00 00    	je     80102708 <lapicinit+0xd8>
  lapic[index] = value;
80102640:	c7 80 f0 00 00 00 3f 	movl   $0x13f,0xf0(%eax)
80102647:	01 00 00 
  lapic[ID];  // wait for write to finish, by reading
8010264a:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
8010264d:	c7 80 e0 03 00 00 0b 	movl   $0xb,0x3e0(%eax)
80102654:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102657:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
8010265a:	c7 80 20 03 00 00 20 	movl   $0x20020,0x320(%eax)
80102661:	00 02 00 
  lapic[ID];  // wait for write to finish, by reading
80102664:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102667:	c7 80 80 03 00 00 80 	movl   $0x989680,0x380(%eax)
8010266e:	96 98 00 
  lapic[ID];  // wait for write to finish, by reading
80102671:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102674:	c7 80 50 03 00 00 00 	movl   $0x10000,0x350(%eax)
8010267b:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
8010267e:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102681:	c7 80 60 03 00 00 00 	movl   $0x10000,0x360(%eax)
80102688:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
8010268b:	8b 50 20             	mov    0x20(%eax),%edx
  lapicw(LINT0, MASKED);
  lapicw(LINT1, MASKED);

  // Disable performance counter overflow interrupts
  // on machines that provide that interrupt entry.
  if(((lapic[VER]>>16) & 0xFF) >= 4)
8010268e:	8b 50 30             	mov    0x30(%eax),%edx
80102691:	c1 ea 10             	shr    $0x10,%edx
80102694:	80 fa 03             	cmp    $0x3,%dl
80102697:	77 77                	ja     80102710 <lapicinit+0xe0>
  lapic[index] = value;
80102699:	c7 80 70 03 00 00 33 	movl   $0x33,0x370(%eax)
801026a0:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801026a3:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801026a6:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
801026ad:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801026b0:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801026b3:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
801026ba:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801026bd:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801026c0:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
801026c7:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801026ca:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801026cd:	c7 80 10 03 00 00 00 	movl   $0x0,0x310(%eax)
801026d4:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801026d7:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801026da:	c7 80 00 03 00 00 00 	movl   $0x88500,0x300(%eax)
801026e1:	85 08 00 
  lapic[ID];  // wait for write to finish, by reading
801026e4:	8b 50 20             	mov    0x20(%eax),%edx
801026e7:	89 f6                	mov    %esi,%esi
801026e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  lapicw(EOI, 0);

  // Send an Init Level De-Assert to synchronise arbitration ID's.
  lapicw(ICRHI, 0);
  lapicw(ICRLO, BCAST | INIT | LEVEL);
  while(lapic[ICRLO] & DELIVS)
801026f0:	8b 90 00 03 00 00    	mov    0x300(%eax),%edx
801026f6:	80 e6 10             	and    $0x10,%dh
801026f9:	75 f5                	jne    801026f0 <lapicinit+0xc0>
  lapic[index] = value;
801026fb:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%eax)
80102702:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102705:	8b 40 20             	mov    0x20(%eax),%eax
    ;

  // Enable interrupts on the APIC (but not on the processor).
  lapicw(TPR, 0);
}
80102708:	5d                   	pop    %ebp
80102709:	c3                   	ret    
8010270a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  lapic[index] = value;
80102710:	c7 80 40 03 00 00 00 	movl   $0x10000,0x340(%eax)
80102717:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
8010271a:	8b 50 20             	mov    0x20(%eax),%edx
8010271d:	e9 77 ff ff ff       	jmp    80102699 <lapicinit+0x69>
80102722:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102729:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102730 <lapicid>:

int
lapicid(void)
{
  if (!lapic)
80102730:	8b 15 dc 36 11 80    	mov    0x801136dc,%edx
{
80102736:	55                   	push   %ebp
80102737:	31 c0                	xor    %eax,%eax
80102739:	89 e5                	mov    %esp,%ebp
  if (!lapic)
8010273b:	85 d2                	test   %edx,%edx
8010273d:	74 06                	je     80102745 <lapicid+0x15>
    return 0;
  return lapic[ID] >> 24;
8010273f:	8b 42 20             	mov    0x20(%edx),%eax
80102742:	c1 e8 18             	shr    $0x18,%eax
}
80102745:	5d                   	pop    %ebp
80102746:	c3                   	ret    
80102747:	89 f6                	mov    %esi,%esi
80102749:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102750 <lapiceoi>:

// Acknowledge interrupt.
void
lapiceoi(void)
{
  if(lapic)
80102750:	a1 dc 36 11 80       	mov    0x801136dc,%eax
{
80102755:	55                   	push   %ebp
80102756:	89 e5                	mov    %esp,%ebp
  if(lapic)
80102758:	85 c0                	test   %eax,%eax
8010275a:	74 0d                	je     80102769 <lapiceoi+0x19>
  lapic[index] = value;
8010275c:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
80102763:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102766:	8b 40 20             	mov    0x20(%eax),%eax
    lapicw(EOI, 0);
}
80102769:	5d                   	pop    %ebp
8010276a:	c3                   	ret    
8010276b:	90                   	nop
8010276c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102770 <microdelay>:

// Spin for a given number of microseconds.
// On real hardware would want to tune this dynamically.
void
microdelay(int us)
{
80102770:	55                   	push   %ebp
80102771:	89 e5                	mov    %esp,%ebp
}
80102773:	5d                   	pop    %ebp
80102774:	c3                   	ret    
80102775:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102779:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102780 <lapicstartap>:

// Start additional processor running entry code at addr.
// See Appendix B of MultiProcessor Specification.
void
lapicstartap(uchar apicid, uint addr)
{
80102780:	55                   	push   %ebp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102781:	b8 0f 00 00 00       	mov    $0xf,%eax
80102786:	ba 70 00 00 00       	mov    $0x70,%edx
8010278b:	89 e5                	mov    %esp,%ebp
8010278d:	53                   	push   %ebx
8010278e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80102791:	8b 5d 08             	mov    0x8(%ebp),%ebx
80102794:	ee                   	out    %al,(%dx)
80102795:	b8 0a 00 00 00       	mov    $0xa,%eax
8010279a:	ba 71 00 00 00       	mov    $0x71,%edx
8010279f:	ee                   	out    %al,(%dx)
  // and the warm reset vector (DWORD based at 40:67) to point at
  // the AP startup code prior to the [universal startup algorithm]."
  outb(CMOS_PORT, 0xF);  // offset 0xF is shutdown code
  outb(CMOS_PORT+1, 0x0A);
  wrv = (ushort*)P2V((0x40<<4 | 0x67));  // Warm reset vector
  wrv[0] = 0;
801027a0:	31 c0                	xor    %eax,%eax
  wrv[1] = addr >> 4;

  // "Universal startup algorithm."
  // Send INIT (level-triggered) interrupt to reset other CPU.
  lapicw(ICRHI, apicid<<24);
801027a2:	c1 e3 18             	shl    $0x18,%ebx
  wrv[0] = 0;
801027a5:	66 a3 67 04 00 80    	mov    %ax,0x80000467
  wrv[1] = addr >> 4;
801027ab:	89 c8                	mov    %ecx,%eax
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
    lapicw(ICRHI, apicid<<24);
    lapicw(ICRLO, STARTUP | (addr>>12));
801027ad:	c1 e9 0c             	shr    $0xc,%ecx
  wrv[1] = addr >> 4;
801027b0:	c1 e8 04             	shr    $0x4,%eax
  lapicw(ICRHI, apicid<<24);
801027b3:	89 da                	mov    %ebx,%edx
    lapicw(ICRLO, STARTUP | (addr>>12));
801027b5:	80 cd 06             	or     $0x6,%ch
  wrv[1] = addr >> 4;
801027b8:	66 a3 69 04 00 80    	mov    %ax,0x80000469
  lapic[index] = value;
801027be:	a1 dc 36 11 80       	mov    0x801136dc,%eax
801027c3:	89 98 10 03 00 00    	mov    %ebx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
801027c9:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
801027cc:	c7 80 00 03 00 00 00 	movl   $0xc500,0x300(%eax)
801027d3:	c5 00 00 
  lapic[ID];  // wait for write to finish, by reading
801027d6:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
801027d9:	c7 80 00 03 00 00 00 	movl   $0x8500,0x300(%eax)
801027e0:	85 00 00 
  lapic[ID];  // wait for write to finish, by reading
801027e3:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
801027e6:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
801027ec:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
801027ef:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
801027f5:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
801027f8:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
801027fe:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102801:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102807:	8b 40 20             	mov    0x20(%eax),%eax
    microdelay(200);
  }
}
8010280a:	5b                   	pop    %ebx
8010280b:	5d                   	pop    %ebp
8010280c:	c3                   	ret    
8010280d:	8d 76 00             	lea    0x0(%esi),%esi

80102810 <cmostime>:
}

// qemu seems to use 24-hour GWT and the values are BCD encoded
void
cmostime(struct rtcdate *r)
{
80102810:	55                   	push   %ebp
80102811:	b8 0b 00 00 00       	mov    $0xb,%eax
80102816:	ba 70 00 00 00       	mov    $0x70,%edx
8010281b:	89 e5                	mov    %esp,%ebp
8010281d:	57                   	push   %edi
8010281e:	56                   	push   %esi
8010281f:	53                   	push   %ebx
80102820:	83 ec 4c             	sub    $0x4c,%esp
80102823:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102824:	ba 71 00 00 00       	mov    $0x71,%edx
80102829:	ec                   	in     (%dx),%al
8010282a:	83 e0 04             	and    $0x4,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010282d:	bb 70 00 00 00       	mov    $0x70,%ebx
80102832:	88 45 b3             	mov    %al,-0x4d(%ebp)
80102835:	8d 76 00             	lea    0x0(%esi),%esi
80102838:	31 c0                	xor    %eax,%eax
8010283a:	89 da                	mov    %ebx,%edx
8010283c:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010283d:	b9 71 00 00 00       	mov    $0x71,%ecx
80102842:	89 ca                	mov    %ecx,%edx
80102844:	ec                   	in     (%dx),%al
80102845:	88 45 b7             	mov    %al,-0x49(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102848:	89 da                	mov    %ebx,%edx
8010284a:	b8 02 00 00 00       	mov    $0x2,%eax
8010284f:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102850:	89 ca                	mov    %ecx,%edx
80102852:	ec                   	in     (%dx),%al
80102853:	88 45 b6             	mov    %al,-0x4a(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102856:	89 da                	mov    %ebx,%edx
80102858:	b8 04 00 00 00       	mov    $0x4,%eax
8010285d:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010285e:	89 ca                	mov    %ecx,%edx
80102860:	ec                   	in     (%dx),%al
80102861:	88 45 b5             	mov    %al,-0x4b(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102864:	89 da                	mov    %ebx,%edx
80102866:	b8 07 00 00 00       	mov    $0x7,%eax
8010286b:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010286c:	89 ca                	mov    %ecx,%edx
8010286e:	ec                   	in     (%dx),%al
8010286f:	88 45 b4             	mov    %al,-0x4c(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102872:	89 da                	mov    %ebx,%edx
80102874:	b8 08 00 00 00       	mov    $0x8,%eax
80102879:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010287a:	89 ca                	mov    %ecx,%edx
8010287c:	ec                   	in     (%dx),%al
8010287d:	89 c7                	mov    %eax,%edi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010287f:	89 da                	mov    %ebx,%edx
80102881:	b8 09 00 00 00       	mov    $0x9,%eax
80102886:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102887:	89 ca                	mov    %ecx,%edx
80102889:	ec                   	in     (%dx),%al
8010288a:	89 c6                	mov    %eax,%esi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010288c:	89 da                	mov    %ebx,%edx
8010288e:	b8 0a 00 00 00       	mov    $0xa,%eax
80102893:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102894:	89 ca                	mov    %ecx,%edx
80102896:	ec                   	in     (%dx),%al
  bcd = (sb & (1 << 2)) == 0;

  // make sure CMOS doesn't modify time while we read it
  for(;;) {
    fill_rtcdate(&t1);
    if(cmos_read(CMOS_STATA) & CMOS_UIP)
80102897:	84 c0                	test   %al,%al
80102899:	78 9d                	js     80102838 <cmostime+0x28>
  return inb(CMOS_RETURN);
8010289b:	0f b6 45 b7          	movzbl -0x49(%ebp),%eax
8010289f:	89 fa                	mov    %edi,%edx
801028a1:	0f b6 fa             	movzbl %dl,%edi
801028a4:	89 f2                	mov    %esi,%edx
801028a6:	0f b6 f2             	movzbl %dl,%esi
801028a9:	89 7d c8             	mov    %edi,-0x38(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801028ac:	89 da                	mov    %ebx,%edx
801028ae:	89 75 cc             	mov    %esi,-0x34(%ebp)
801028b1:	89 45 b8             	mov    %eax,-0x48(%ebp)
801028b4:	0f b6 45 b6          	movzbl -0x4a(%ebp),%eax
801028b8:	89 45 bc             	mov    %eax,-0x44(%ebp)
801028bb:	0f b6 45 b5          	movzbl -0x4b(%ebp),%eax
801028bf:	89 45 c0             	mov    %eax,-0x40(%ebp)
801028c2:	0f b6 45 b4          	movzbl -0x4c(%ebp),%eax
801028c6:	89 45 c4             	mov    %eax,-0x3c(%ebp)
801028c9:	31 c0                	xor    %eax,%eax
801028cb:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801028cc:	89 ca                	mov    %ecx,%edx
801028ce:	ec                   	in     (%dx),%al
801028cf:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801028d2:	89 da                	mov    %ebx,%edx
801028d4:	89 45 d0             	mov    %eax,-0x30(%ebp)
801028d7:	b8 02 00 00 00       	mov    $0x2,%eax
801028dc:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801028dd:	89 ca                	mov    %ecx,%edx
801028df:	ec                   	in     (%dx),%al
801028e0:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801028e3:	89 da                	mov    %ebx,%edx
801028e5:	89 45 d4             	mov    %eax,-0x2c(%ebp)
801028e8:	b8 04 00 00 00       	mov    $0x4,%eax
801028ed:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801028ee:	89 ca                	mov    %ecx,%edx
801028f0:	ec                   	in     (%dx),%al
801028f1:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801028f4:	89 da                	mov    %ebx,%edx
801028f6:	89 45 d8             	mov    %eax,-0x28(%ebp)
801028f9:	b8 07 00 00 00       	mov    $0x7,%eax
801028fe:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801028ff:	89 ca                	mov    %ecx,%edx
80102901:	ec                   	in     (%dx),%al
80102902:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102905:	89 da                	mov    %ebx,%edx
80102907:	89 45 dc             	mov    %eax,-0x24(%ebp)
8010290a:	b8 08 00 00 00       	mov    $0x8,%eax
8010290f:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102910:	89 ca                	mov    %ecx,%edx
80102912:	ec                   	in     (%dx),%al
80102913:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102916:	89 da                	mov    %ebx,%edx
80102918:	89 45 e0             	mov    %eax,-0x20(%ebp)
8010291b:	b8 09 00 00 00       	mov    $0x9,%eax
80102920:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102921:	89 ca                	mov    %ecx,%edx
80102923:	ec                   	in     (%dx),%al
80102924:	0f b6 c0             	movzbl %al,%eax
        continue;
    fill_rtcdate(&t2);
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
80102927:	83 ec 04             	sub    $0x4,%esp
  return inb(CMOS_RETURN);
8010292a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
8010292d:	8d 45 d0             	lea    -0x30(%ebp),%eax
80102930:	6a 18                	push   $0x18
80102932:	50                   	push   %eax
80102933:	8d 45 b8             	lea    -0x48(%ebp),%eax
80102936:	50                   	push   %eax
80102937:	e8 24 2b 00 00       	call   80105460 <memcmp>
8010293c:	83 c4 10             	add    $0x10,%esp
8010293f:	85 c0                	test   %eax,%eax
80102941:	0f 85 f1 fe ff ff    	jne    80102838 <cmostime+0x28>
      break;
  }

  // convert
  if(bcd) {
80102947:	80 7d b3 00          	cmpb   $0x0,-0x4d(%ebp)
8010294b:	75 78                	jne    801029c5 <cmostime+0x1b5>
#define    CONV(x)     (t1.x = ((t1.x >> 4) * 10) + (t1.x & 0xf))
    CONV(second);
8010294d:	8b 45 b8             	mov    -0x48(%ebp),%eax
80102950:	89 c2                	mov    %eax,%edx
80102952:	83 e0 0f             	and    $0xf,%eax
80102955:	c1 ea 04             	shr    $0x4,%edx
80102958:	8d 14 92             	lea    (%edx,%edx,4),%edx
8010295b:	8d 04 50             	lea    (%eax,%edx,2),%eax
8010295e:	89 45 b8             	mov    %eax,-0x48(%ebp)
    CONV(minute);
80102961:	8b 45 bc             	mov    -0x44(%ebp),%eax
80102964:	89 c2                	mov    %eax,%edx
80102966:	83 e0 0f             	and    $0xf,%eax
80102969:	c1 ea 04             	shr    $0x4,%edx
8010296c:	8d 14 92             	lea    (%edx,%edx,4),%edx
8010296f:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102972:	89 45 bc             	mov    %eax,-0x44(%ebp)
    CONV(hour  );
80102975:	8b 45 c0             	mov    -0x40(%ebp),%eax
80102978:	89 c2                	mov    %eax,%edx
8010297a:	83 e0 0f             	and    $0xf,%eax
8010297d:	c1 ea 04             	shr    $0x4,%edx
80102980:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102983:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102986:	89 45 c0             	mov    %eax,-0x40(%ebp)
    CONV(day   );
80102989:	8b 45 c4             	mov    -0x3c(%ebp),%eax
8010298c:	89 c2                	mov    %eax,%edx
8010298e:	83 e0 0f             	and    $0xf,%eax
80102991:	c1 ea 04             	shr    $0x4,%edx
80102994:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102997:	8d 04 50             	lea    (%eax,%edx,2),%eax
8010299a:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    CONV(month );
8010299d:	8b 45 c8             	mov    -0x38(%ebp),%eax
801029a0:	89 c2                	mov    %eax,%edx
801029a2:	83 e0 0f             	and    $0xf,%eax
801029a5:	c1 ea 04             	shr    $0x4,%edx
801029a8:	8d 14 92             	lea    (%edx,%edx,4),%edx
801029ab:	8d 04 50             	lea    (%eax,%edx,2),%eax
801029ae:	89 45 c8             	mov    %eax,-0x38(%ebp)
    CONV(year  );
801029b1:	8b 45 cc             	mov    -0x34(%ebp),%eax
801029b4:	89 c2                	mov    %eax,%edx
801029b6:	83 e0 0f             	and    $0xf,%eax
801029b9:	c1 ea 04             	shr    $0x4,%edx
801029bc:	8d 14 92             	lea    (%edx,%edx,4),%edx
801029bf:	8d 04 50             	lea    (%eax,%edx,2),%eax
801029c2:	89 45 cc             	mov    %eax,-0x34(%ebp)
#undef     CONV
  }

  *r = t1;
801029c5:	8b 75 08             	mov    0x8(%ebp),%esi
801029c8:	8b 45 b8             	mov    -0x48(%ebp),%eax
801029cb:	89 06                	mov    %eax,(%esi)
801029cd:	8b 45 bc             	mov    -0x44(%ebp),%eax
801029d0:	89 46 04             	mov    %eax,0x4(%esi)
801029d3:	8b 45 c0             	mov    -0x40(%ebp),%eax
801029d6:	89 46 08             	mov    %eax,0x8(%esi)
801029d9:	8b 45 c4             	mov    -0x3c(%ebp),%eax
801029dc:	89 46 0c             	mov    %eax,0xc(%esi)
801029df:	8b 45 c8             	mov    -0x38(%ebp),%eax
801029e2:	89 46 10             	mov    %eax,0x10(%esi)
801029e5:	8b 45 cc             	mov    -0x34(%ebp),%eax
801029e8:	89 46 14             	mov    %eax,0x14(%esi)
  r->year += 2000;
801029eb:	81 46 14 d0 07 00 00 	addl   $0x7d0,0x14(%esi)
}
801029f2:	8d 65 f4             	lea    -0xc(%ebp),%esp
801029f5:	5b                   	pop    %ebx
801029f6:	5e                   	pop    %esi
801029f7:	5f                   	pop    %edi
801029f8:	5d                   	pop    %ebp
801029f9:	c3                   	ret    
801029fa:	66 90                	xchg   %ax,%ax
801029fc:	66 90                	xchg   %ax,%ax
801029fe:	66 90                	xchg   %ax,%ax

80102a00 <install_trans>:
static void
install_trans(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80102a00:	8b 0d 28 37 11 80    	mov    0x80113728,%ecx
80102a06:	85 c9                	test   %ecx,%ecx
80102a08:	0f 8e 8a 00 00 00    	jle    80102a98 <install_trans+0x98>
{
80102a0e:	55                   	push   %ebp
80102a0f:	89 e5                	mov    %esp,%ebp
80102a11:	57                   	push   %edi
80102a12:	56                   	push   %esi
80102a13:	53                   	push   %ebx
  for (tail = 0; tail < log.lh.n; tail++) {
80102a14:	31 db                	xor    %ebx,%ebx
{
80102a16:	83 ec 0c             	sub    $0xc,%esp
80102a19:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
80102a20:	a1 14 37 11 80       	mov    0x80113714,%eax
80102a25:	83 ec 08             	sub    $0x8,%esp
80102a28:	01 d8                	add    %ebx,%eax
80102a2a:	83 c0 01             	add    $0x1,%eax
80102a2d:	50                   	push   %eax
80102a2e:	ff 35 24 37 11 80    	pushl  0x80113724
80102a34:	e8 97 d6 ff ff       	call   801000d0 <bread>
80102a39:	89 c7                	mov    %eax,%edi
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102a3b:	58                   	pop    %eax
80102a3c:	5a                   	pop    %edx
80102a3d:	ff 34 9d 2c 37 11 80 	pushl  -0x7feec8d4(,%ebx,4)
80102a44:	ff 35 24 37 11 80    	pushl  0x80113724
  for (tail = 0; tail < log.lh.n; tail++) {
80102a4a:	83 c3 01             	add    $0x1,%ebx
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102a4d:	e8 7e d6 ff ff       	call   801000d0 <bread>
80102a52:	89 c6                	mov    %eax,%esi
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
80102a54:	8d 47 5c             	lea    0x5c(%edi),%eax
80102a57:	83 c4 0c             	add    $0xc,%esp
80102a5a:	68 00 02 00 00       	push   $0x200
80102a5f:	50                   	push   %eax
80102a60:	8d 46 5c             	lea    0x5c(%esi),%eax
80102a63:	50                   	push   %eax
80102a64:	e8 57 2a 00 00       	call   801054c0 <memmove>
    bwrite(dbuf);  // write dst to disk
80102a69:	89 34 24             	mov    %esi,(%esp)
80102a6c:	e8 2f d7 ff ff       	call   801001a0 <bwrite>
    brelse(lbuf);
80102a71:	89 3c 24             	mov    %edi,(%esp)
80102a74:	e8 67 d7 ff ff       	call   801001e0 <brelse>
    brelse(dbuf);
80102a79:	89 34 24             	mov    %esi,(%esp)
80102a7c:	e8 5f d7 ff ff       	call   801001e0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
80102a81:	83 c4 10             	add    $0x10,%esp
80102a84:	39 1d 28 37 11 80    	cmp    %ebx,0x80113728
80102a8a:	7f 94                	jg     80102a20 <install_trans+0x20>
  }
}
80102a8c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102a8f:	5b                   	pop    %ebx
80102a90:	5e                   	pop    %esi
80102a91:	5f                   	pop    %edi
80102a92:	5d                   	pop    %ebp
80102a93:	c3                   	ret    
80102a94:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102a98:	f3 c3                	repz ret 
80102a9a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80102aa0 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
80102aa0:	55                   	push   %ebp
80102aa1:	89 e5                	mov    %esp,%ebp
80102aa3:	56                   	push   %esi
80102aa4:	53                   	push   %ebx
  struct buf *buf = bread(log.dev, log.start);
80102aa5:	83 ec 08             	sub    $0x8,%esp
80102aa8:	ff 35 14 37 11 80    	pushl  0x80113714
80102aae:	ff 35 24 37 11 80    	pushl  0x80113724
80102ab4:	e8 17 d6 ff ff       	call   801000d0 <bread>
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
80102ab9:	8b 1d 28 37 11 80    	mov    0x80113728,%ebx
  for (i = 0; i < log.lh.n; i++) {
80102abf:	83 c4 10             	add    $0x10,%esp
  struct buf *buf = bread(log.dev, log.start);
80102ac2:	89 c6                	mov    %eax,%esi
  for (i = 0; i < log.lh.n; i++) {
80102ac4:	85 db                	test   %ebx,%ebx
  hb->n = log.lh.n;
80102ac6:	89 58 5c             	mov    %ebx,0x5c(%eax)
  for (i = 0; i < log.lh.n; i++) {
80102ac9:	7e 16                	jle    80102ae1 <write_head+0x41>
80102acb:	c1 e3 02             	shl    $0x2,%ebx
80102ace:	31 d2                	xor    %edx,%edx
    hb->block[i] = log.lh.block[i];
80102ad0:	8b 8a 2c 37 11 80    	mov    -0x7feec8d4(%edx),%ecx
80102ad6:	89 4c 16 60          	mov    %ecx,0x60(%esi,%edx,1)
80102ada:	83 c2 04             	add    $0x4,%edx
  for (i = 0; i < log.lh.n; i++) {
80102add:	39 da                	cmp    %ebx,%edx
80102adf:	75 ef                	jne    80102ad0 <write_head+0x30>
  }
  bwrite(buf);
80102ae1:	83 ec 0c             	sub    $0xc,%esp
80102ae4:	56                   	push   %esi
80102ae5:	e8 b6 d6 ff ff       	call   801001a0 <bwrite>
  brelse(buf);
80102aea:	89 34 24             	mov    %esi,(%esp)
80102aed:	e8 ee d6 ff ff       	call   801001e0 <brelse>
}
80102af2:	83 c4 10             	add    $0x10,%esp
80102af5:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102af8:	5b                   	pop    %ebx
80102af9:	5e                   	pop    %esi
80102afa:	5d                   	pop    %ebp
80102afb:	c3                   	ret    
80102afc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102b00 <initlog>:
{
80102b00:	55                   	push   %ebp
80102b01:	89 e5                	mov    %esp,%ebp
80102b03:	53                   	push   %ebx
80102b04:	83 ec 2c             	sub    $0x2c,%esp
80102b07:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&log.lock, "log");
80102b0a:	68 a0 84 10 80       	push   $0x801084a0
80102b0f:	68 e0 36 11 80       	push   $0x801136e0
80102b14:	e8 a7 26 00 00       	call   801051c0 <initlock>
  readsb(dev, &sb);
80102b19:	58                   	pop    %eax
80102b1a:	8d 45 dc             	lea    -0x24(%ebp),%eax
80102b1d:	5a                   	pop    %edx
80102b1e:	50                   	push   %eax
80102b1f:	53                   	push   %ebx
80102b20:	e8 1b e9 ff ff       	call   80101440 <readsb>
  log.size = sb.nlog;
80102b25:	8b 55 e8             	mov    -0x18(%ebp),%edx
  log.start = sb.logstart;
80102b28:	8b 45 ec             	mov    -0x14(%ebp),%eax
  struct buf *buf = bread(log.dev, log.start);
80102b2b:	59                   	pop    %ecx
  log.dev = dev;
80102b2c:	89 1d 24 37 11 80    	mov    %ebx,0x80113724
  log.size = sb.nlog;
80102b32:	89 15 18 37 11 80    	mov    %edx,0x80113718
  log.start = sb.logstart;
80102b38:	a3 14 37 11 80       	mov    %eax,0x80113714
  struct buf *buf = bread(log.dev, log.start);
80102b3d:	5a                   	pop    %edx
80102b3e:	50                   	push   %eax
80102b3f:	53                   	push   %ebx
80102b40:	e8 8b d5 ff ff       	call   801000d0 <bread>
  log.lh.n = lh->n;
80102b45:	8b 58 5c             	mov    0x5c(%eax),%ebx
  for (i = 0; i < log.lh.n; i++) {
80102b48:	83 c4 10             	add    $0x10,%esp
80102b4b:	85 db                	test   %ebx,%ebx
  log.lh.n = lh->n;
80102b4d:	89 1d 28 37 11 80    	mov    %ebx,0x80113728
  for (i = 0; i < log.lh.n; i++) {
80102b53:	7e 1c                	jle    80102b71 <initlog+0x71>
80102b55:	c1 e3 02             	shl    $0x2,%ebx
80102b58:	31 d2                	xor    %edx,%edx
80102b5a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    log.lh.block[i] = lh->block[i];
80102b60:	8b 4c 10 60          	mov    0x60(%eax,%edx,1),%ecx
80102b64:	83 c2 04             	add    $0x4,%edx
80102b67:	89 8a 28 37 11 80    	mov    %ecx,-0x7feec8d8(%edx)
  for (i = 0; i < log.lh.n; i++) {
80102b6d:	39 d3                	cmp    %edx,%ebx
80102b6f:	75 ef                	jne    80102b60 <initlog+0x60>
  brelse(buf);
80102b71:	83 ec 0c             	sub    $0xc,%esp
80102b74:	50                   	push   %eax
80102b75:	e8 66 d6 ff ff       	call   801001e0 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(); // if committed, copy from log to disk
80102b7a:	e8 81 fe ff ff       	call   80102a00 <install_trans>
  log.lh.n = 0;
80102b7f:	c7 05 28 37 11 80 00 	movl   $0x0,0x80113728
80102b86:	00 00 00 
  write_head(); // clear the log
80102b89:	e8 12 ff ff ff       	call   80102aa0 <write_head>
}
80102b8e:	83 c4 10             	add    $0x10,%esp
80102b91:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102b94:	c9                   	leave  
80102b95:	c3                   	ret    
80102b96:	8d 76 00             	lea    0x0(%esi),%esi
80102b99:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102ba0 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
80102ba0:	55                   	push   %ebp
80102ba1:	89 e5                	mov    %esp,%ebp
80102ba3:	83 ec 14             	sub    $0x14,%esp
  acquire(&log.lock);
80102ba6:	68 e0 36 11 80       	push   $0x801136e0
80102bab:	e8 50 27 00 00       	call   80105300 <acquire>
80102bb0:	83 c4 10             	add    $0x10,%esp
80102bb3:	eb 18                	jmp    80102bcd <begin_op+0x2d>
80102bb5:	8d 76 00             	lea    0x0(%esi),%esi
  while(1){
    if(log.committing){
      sleep(&log, &log.lock);
80102bb8:	83 ec 08             	sub    $0x8,%esp
80102bbb:	68 e0 36 11 80       	push   $0x801136e0
80102bc0:	68 e0 36 11 80       	push   $0x801136e0
80102bc5:	e8 96 1d 00 00       	call   80104960 <sleep>
80102bca:	83 c4 10             	add    $0x10,%esp
    if(log.committing){
80102bcd:	a1 20 37 11 80       	mov    0x80113720,%eax
80102bd2:	85 c0                	test   %eax,%eax
80102bd4:	75 e2                	jne    80102bb8 <begin_op+0x18>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
80102bd6:	a1 1c 37 11 80       	mov    0x8011371c,%eax
80102bdb:	8b 15 28 37 11 80    	mov    0x80113728,%edx
80102be1:	83 c0 01             	add    $0x1,%eax
80102be4:	8d 0c 80             	lea    (%eax,%eax,4),%ecx
80102be7:	8d 14 4a             	lea    (%edx,%ecx,2),%edx
80102bea:	83 fa 1e             	cmp    $0x1e,%edx
80102bed:	7f c9                	jg     80102bb8 <begin_op+0x18>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    } else {
      log.outstanding += 1;
      release(&log.lock);
80102bef:	83 ec 0c             	sub    $0xc,%esp
      log.outstanding += 1;
80102bf2:	a3 1c 37 11 80       	mov    %eax,0x8011371c
      release(&log.lock);
80102bf7:	68 e0 36 11 80       	push   $0x801136e0
80102bfc:	e8 bf 27 00 00       	call   801053c0 <release>
      break;
    }
  }
}
80102c01:	83 c4 10             	add    $0x10,%esp
80102c04:	c9                   	leave  
80102c05:	c3                   	ret    
80102c06:	8d 76 00             	lea    0x0(%esi),%esi
80102c09:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102c10 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
80102c10:	55                   	push   %ebp
80102c11:	89 e5                	mov    %esp,%ebp
80102c13:	57                   	push   %edi
80102c14:	56                   	push   %esi
80102c15:	53                   	push   %ebx
80102c16:	83 ec 18             	sub    $0x18,%esp
  int do_commit = 0;

  acquire(&log.lock);
80102c19:	68 e0 36 11 80       	push   $0x801136e0
80102c1e:	e8 dd 26 00 00       	call   80105300 <acquire>
  log.outstanding -= 1;
80102c23:	a1 1c 37 11 80       	mov    0x8011371c,%eax
  if(log.committing)
80102c28:	8b 35 20 37 11 80    	mov    0x80113720,%esi
80102c2e:	83 c4 10             	add    $0x10,%esp
  log.outstanding -= 1;
80102c31:	8d 58 ff             	lea    -0x1(%eax),%ebx
  if(log.committing)
80102c34:	85 f6                	test   %esi,%esi
  log.outstanding -= 1;
80102c36:	89 1d 1c 37 11 80    	mov    %ebx,0x8011371c
  if(log.committing)
80102c3c:	0f 85 1a 01 00 00    	jne    80102d5c <end_op+0x14c>
    panic("log.committing");
  if(log.outstanding == 0){
80102c42:	85 db                	test   %ebx,%ebx
80102c44:	0f 85 ee 00 00 00    	jne    80102d38 <end_op+0x128>
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
80102c4a:	83 ec 0c             	sub    $0xc,%esp
    log.committing = 1;
80102c4d:	c7 05 20 37 11 80 01 	movl   $0x1,0x80113720
80102c54:	00 00 00 
  release(&log.lock);
80102c57:	68 e0 36 11 80       	push   $0x801136e0
80102c5c:	e8 5f 27 00 00       	call   801053c0 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
80102c61:	8b 0d 28 37 11 80    	mov    0x80113728,%ecx
80102c67:	83 c4 10             	add    $0x10,%esp
80102c6a:	85 c9                	test   %ecx,%ecx
80102c6c:	0f 8e 85 00 00 00    	jle    80102cf7 <end_op+0xe7>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
80102c72:	a1 14 37 11 80       	mov    0x80113714,%eax
80102c77:	83 ec 08             	sub    $0x8,%esp
80102c7a:	01 d8                	add    %ebx,%eax
80102c7c:	83 c0 01             	add    $0x1,%eax
80102c7f:	50                   	push   %eax
80102c80:	ff 35 24 37 11 80    	pushl  0x80113724
80102c86:	e8 45 d4 ff ff       	call   801000d0 <bread>
80102c8b:	89 c6                	mov    %eax,%esi
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102c8d:	58                   	pop    %eax
80102c8e:	5a                   	pop    %edx
80102c8f:	ff 34 9d 2c 37 11 80 	pushl  -0x7feec8d4(,%ebx,4)
80102c96:	ff 35 24 37 11 80    	pushl  0x80113724
  for (tail = 0; tail < log.lh.n; tail++) {
80102c9c:	83 c3 01             	add    $0x1,%ebx
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102c9f:	e8 2c d4 ff ff       	call   801000d0 <bread>
80102ca4:	89 c7                	mov    %eax,%edi
    memmove(to->data, from->data, BSIZE);
80102ca6:	8d 40 5c             	lea    0x5c(%eax),%eax
80102ca9:	83 c4 0c             	add    $0xc,%esp
80102cac:	68 00 02 00 00       	push   $0x200
80102cb1:	50                   	push   %eax
80102cb2:	8d 46 5c             	lea    0x5c(%esi),%eax
80102cb5:	50                   	push   %eax
80102cb6:	e8 05 28 00 00       	call   801054c0 <memmove>
    bwrite(to);  // write the log
80102cbb:	89 34 24             	mov    %esi,(%esp)
80102cbe:	e8 dd d4 ff ff       	call   801001a0 <bwrite>
    brelse(from);
80102cc3:	89 3c 24             	mov    %edi,(%esp)
80102cc6:	e8 15 d5 ff ff       	call   801001e0 <brelse>
    brelse(to);
80102ccb:	89 34 24             	mov    %esi,(%esp)
80102cce:	e8 0d d5 ff ff       	call   801001e0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
80102cd3:	83 c4 10             	add    $0x10,%esp
80102cd6:	3b 1d 28 37 11 80    	cmp    0x80113728,%ebx
80102cdc:	7c 94                	jl     80102c72 <end_op+0x62>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
80102cde:	e8 bd fd ff ff       	call   80102aa0 <write_head>
    install_trans(); // Now install writes to home locations
80102ce3:	e8 18 fd ff ff       	call   80102a00 <install_trans>
    log.lh.n = 0;
80102ce8:	c7 05 28 37 11 80 00 	movl   $0x0,0x80113728
80102cef:	00 00 00 
    write_head();    // Erase the transaction from the log
80102cf2:	e8 a9 fd ff ff       	call   80102aa0 <write_head>
    acquire(&log.lock);
80102cf7:	83 ec 0c             	sub    $0xc,%esp
80102cfa:	68 e0 36 11 80       	push   $0x801136e0
80102cff:	e8 fc 25 00 00       	call   80105300 <acquire>
    wakeup(&log);
80102d04:	c7 04 24 e0 36 11 80 	movl   $0x801136e0,(%esp)
    log.committing = 0;
80102d0b:	c7 05 20 37 11 80 00 	movl   $0x0,0x80113720
80102d12:	00 00 00 
    wakeup(&log);
80102d15:	e8 16 1e 00 00       	call   80104b30 <wakeup>
    release(&log.lock);
80102d1a:	c7 04 24 e0 36 11 80 	movl   $0x801136e0,(%esp)
80102d21:	e8 9a 26 00 00       	call   801053c0 <release>
80102d26:	83 c4 10             	add    $0x10,%esp
}
80102d29:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102d2c:	5b                   	pop    %ebx
80102d2d:	5e                   	pop    %esi
80102d2e:	5f                   	pop    %edi
80102d2f:	5d                   	pop    %ebp
80102d30:	c3                   	ret    
80102d31:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    wakeup(&log);
80102d38:	83 ec 0c             	sub    $0xc,%esp
80102d3b:	68 e0 36 11 80       	push   $0x801136e0
80102d40:	e8 eb 1d 00 00       	call   80104b30 <wakeup>
  release(&log.lock);
80102d45:	c7 04 24 e0 36 11 80 	movl   $0x801136e0,(%esp)
80102d4c:	e8 6f 26 00 00       	call   801053c0 <release>
80102d51:	83 c4 10             	add    $0x10,%esp
}
80102d54:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102d57:	5b                   	pop    %ebx
80102d58:	5e                   	pop    %esi
80102d59:	5f                   	pop    %edi
80102d5a:	5d                   	pop    %ebp
80102d5b:	c3                   	ret    
    panic("log.committing");
80102d5c:	83 ec 0c             	sub    $0xc,%esp
80102d5f:	68 a4 84 10 80       	push   $0x801084a4
80102d64:	e8 27 d6 ff ff       	call   80100390 <panic>
80102d69:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102d70 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
80102d70:	55                   	push   %ebp
80102d71:	89 e5                	mov    %esp,%ebp
80102d73:	53                   	push   %ebx
80102d74:	83 ec 04             	sub    $0x4,%esp
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80102d77:	8b 15 28 37 11 80    	mov    0x80113728,%edx
{
80102d7d:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80102d80:	83 fa 1d             	cmp    $0x1d,%edx
80102d83:	0f 8f 9d 00 00 00    	jg     80102e26 <log_write+0xb6>
80102d89:	a1 18 37 11 80       	mov    0x80113718,%eax
80102d8e:	83 e8 01             	sub    $0x1,%eax
80102d91:	39 c2                	cmp    %eax,%edx
80102d93:	0f 8d 8d 00 00 00    	jge    80102e26 <log_write+0xb6>
    panic("too big a transaction");
  if (log.outstanding < 1)
80102d99:	a1 1c 37 11 80       	mov    0x8011371c,%eax
80102d9e:	85 c0                	test   %eax,%eax
80102da0:	0f 8e 8d 00 00 00    	jle    80102e33 <log_write+0xc3>
    panic("log_write outside of trans");

  acquire(&log.lock);
80102da6:	83 ec 0c             	sub    $0xc,%esp
80102da9:	68 e0 36 11 80       	push   $0x801136e0
80102dae:	e8 4d 25 00 00       	call   80105300 <acquire>
  for (i = 0; i < log.lh.n; i++) {
80102db3:	8b 0d 28 37 11 80    	mov    0x80113728,%ecx
80102db9:	83 c4 10             	add    $0x10,%esp
80102dbc:	83 f9 00             	cmp    $0x0,%ecx
80102dbf:	7e 57                	jle    80102e18 <log_write+0xa8>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80102dc1:	8b 53 08             	mov    0x8(%ebx),%edx
  for (i = 0; i < log.lh.n; i++) {
80102dc4:	31 c0                	xor    %eax,%eax
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80102dc6:	3b 15 2c 37 11 80    	cmp    0x8011372c,%edx
80102dcc:	75 0b                	jne    80102dd9 <log_write+0x69>
80102dce:	eb 38                	jmp    80102e08 <log_write+0x98>
80102dd0:	39 14 85 2c 37 11 80 	cmp    %edx,-0x7feec8d4(,%eax,4)
80102dd7:	74 2f                	je     80102e08 <log_write+0x98>
  for (i = 0; i < log.lh.n; i++) {
80102dd9:	83 c0 01             	add    $0x1,%eax
80102ddc:	39 c1                	cmp    %eax,%ecx
80102dde:	75 f0                	jne    80102dd0 <log_write+0x60>
      break;
  }
  log.lh.block[i] = b->blockno;
80102de0:	89 14 85 2c 37 11 80 	mov    %edx,-0x7feec8d4(,%eax,4)
  if (i == log.lh.n)
    log.lh.n++;
80102de7:	83 c0 01             	add    $0x1,%eax
80102dea:	a3 28 37 11 80       	mov    %eax,0x80113728
  b->flags |= B_DIRTY; // prevent eviction
80102def:	83 0b 04             	orl    $0x4,(%ebx)
  release(&log.lock);
80102df2:	c7 45 08 e0 36 11 80 	movl   $0x801136e0,0x8(%ebp)
}
80102df9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102dfc:	c9                   	leave  
  release(&log.lock);
80102dfd:	e9 be 25 00 00       	jmp    801053c0 <release>
80102e02:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  log.lh.block[i] = b->blockno;
80102e08:	89 14 85 2c 37 11 80 	mov    %edx,-0x7feec8d4(,%eax,4)
80102e0f:	eb de                	jmp    80102def <log_write+0x7f>
80102e11:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102e18:	8b 43 08             	mov    0x8(%ebx),%eax
80102e1b:	a3 2c 37 11 80       	mov    %eax,0x8011372c
  if (i == log.lh.n)
80102e20:	75 cd                	jne    80102def <log_write+0x7f>
80102e22:	31 c0                	xor    %eax,%eax
80102e24:	eb c1                	jmp    80102de7 <log_write+0x77>
    panic("too big a transaction");
80102e26:	83 ec 0c             	sub    $0xc,%esp
80102e29:	68 b3 84 10 80       	push   $0x801084b3
80102e2e:	e8 5d d5 ff ff       	call   80100390 <panic>
    panic("log_write outside of trans");
80102e33:	83 ec 0c             	sub    $0xc,%esp
80102e36:	68 c9 84 10 80       	push   $0x801084c9
80102e3b:	e8 50 d5 ff ff       	call   80100390 <panic>

80102e40 <mpmain>:
}

// Common CPU setup code.
static void
mpmain(void)
{
80102e40:	55                   	push   %ebp
80102e41:	89 e5                	mov    %esp,%ebp
80102e43:	53                   	push   %ebx
80102e44:	83 ec 04             	sub    $0x4,%esp
  cprintf("cpu%d: starting %d\n", cpuid(), cpuid());
80102e47:	e8 34 0a 00 00       	call   80103880 <cpuid>
80102e4c:	89 c3                	mov    %eax,%ebx
80102e4e:	e8 2d 0a 00 00       	call   80103880 <cpuid>
80102e53:	83 ec 04             	sub    $0x4,%esp
80102e56:	53                   	push   %ebx
80102e57:	50                   	push   %eax
80102e58:	68 e4 84 10 80       	push   $0x801084e4
80102e5d:	e8 fe d7 ff ff       	call   80100660 <cprintf>
  idtinit();       // load idt register
80102e62:	e8 29 39 00 00       	call   80106790 <idtinit>
  xchg(&(mycpu()->started), 1); // tell startothers() we're up
80102e67:	e8 94 09 00 00       	call   80103800 <mycpu>
80102e6c:	89 c2                	mov    %eax,%edx
xchg(volatile uint *addr, uint newval)
{
  uint result;

  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
80102e6e:	b8 01 00 00 00       	mov    $0x1,%eax
80102e73:	f0 87 82 a0 00 00 00 	lock xchg %eax,0xa0(%edx)
  scheduler();     // start running processes
80102e7a:	e8 61 12 00 00       	call   801040e0 <scheduler>
80102e7f:	90                   	nop

80102e80 <mpenter>:
{
80102e80:	55                   	push   %ebp
80102e81:	89 e5                	mov    %esp,%ebp
80102e83:	83 ec 08             	sub    $0x8,%esp
  switchkvm();
80102e86:	e8 85 4a 00 00       	call   80107910 <switchkvm>
  seginit();
80102e8b:	e8 f0 49 00 00       	call   80107880 <seginit>
  lapicinit();
80102e90:	e8 9b f7 ff ff       	call   80102630 <lapicinit>
  mpmain();
80102e95:	e8 a6 ff ff ff       	call   80102e40 <mpmain>
80102e9a:	66 90                	xchg   %ax,%ax
80102e9c:	66 90                	xchg   %ax,%ax
80102e9e:	66 90                	xchg   %ax,%ax

80102ea0 <main>:
{
80102ea0:	8d 4c 24 04          	lea    0x4(%esp),%ecx
80102ea4:	83 e4 f0             	and    $0xfffffff0,%esp
80102ea7:	ff 71 fc             	pushl  -0x4(%ecx)
80102eaa:	55                   	push   %ebp
80102eab:	89 e5                	mov    %esp,%ebp
80102ead:	53                   	push   %ebx
80102eae:	51                   	push   %ecx
  kinit1(end, P2V(4*1024*1024)); // phys page allocator
80102eaf:	83 ec 08             	sub    $0x8,%esp
80102eb2:	68 00 00 40 80       	push   $0x80400000
80102eb7:	68 08 86 11 80       	push   $0x80118608
80102ebc:	e8 2f f5 ff ff       	call   801023f0 <kinit1>
  kvmalloc();      // kernel page table
80102ec1:	e8 1a 4f 00 00       	call   80107de0 <kvmalloc>
  mpinit();        // detect other processors
80102ec6:	e8 75 01 00 00       	call   80103040 <mpinit>
  lapicinit();     // interrupt controller
80102ecb:	e8 60 f7 ff ff       	call   80102630 <lapicinit>
  seginit();       // segment descriptors
80102ed0:	e8 ab 49 00 00       	call   80107880 <seginit>
  picinit();       // disable pic
80102ed5:	e8 46 03 00 00       	call   80103220 <picinit>
  ioapicinit();    // another interrupt controller
80102eda:	e8 41 f3 ff ff       	call   80102220 <ioapicinit>
  consoleinit();   // console hardware
80102edf:	e8 dc da ff ff       	call   801009c0 <consoleinit>
  uartinit();      // serial port
80102ee4:	e8 67 3c 00 00       	call   80106b50 <uartinit>
  pinit();         // process table
80102ee9:	e8 f2 08 00 00       	call   801037e0 <pinit>
  tvinit();        // trap vectors
80102eee:	e8 1d 38 00 00       	call   80106710 <tvinit>
  binit();         // buffer cache
80102ef3:	e8 48 d1 ff ff       	call   80100040 <binit>
  fileinit();      // file table
80102ef8:	e8 63 de ff ff       	call   80100d60 <fileinit>
  ideinit();       // disk 
80102efd:	e8 fe f0 ff ff       	call   80102000 <ideinit>

  // Write entry code to unused memory at 0x7000.
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = P2V(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);
80102f02:	83 c4 0c             	add    $0xc,%esp
80102f05:	68 8a 00 00 00       	push   $0x8a
80102f0a:	68 ac b4 10 80       	push   $0x8010b4ac
80102f0f:	68 00 70 00 80       	push   $0x80007000
80102f14:	e8 a7 25 00 00       	call   801054c0 <memmove>

  for(c = cpus; c < cpus+ncpu; c++){
80102f19:	69 05 60 3d 11 80 b0 	imul   $0xb0,0x80113d60,%eax
80102f20:	00 00 00 
80102f23:	83 c4 10             	add    $0x10,%esp
80102f26:	05 e0 37 11 80       	add    $0x801137e0,%eax
80102f2b:	3d e0 37 11 80       	cmp    $0x801137e0,%eax
80102f30:	76 71                	jbe    80102fa3 <main+0x103>
80102f32:	bb e0 37 11 80       	mov    $0x801137e0,%ebx
80102f37:	89 f6                	mov    %esi,%esi
80102f39:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    if(c == mycpu())  // We've started already.
80102f40:	e8 bb 08 00 00       	call   80103800 <mycpu>
80102f45:	39 d8                	cmp    %ebx,%eax
80102f47:	74 41                	je     80102f8a <main+0xea>
      continue;

    // Tell entryother.S what stack to use, where to enter, and what
    // pgdir to use. We cannot use kpgdir yet, because the AP processor
    // is running in low  memory, so we use entrypgdir for the APs too.
    stack = kalloc();
80102f49:	e8 72 f5 ff ff       	call   801024c0 <kalloc>
    *(void**)(code-4) = stack + KSTACKSIZE;
80102f4e:	05 00 10 00 00       	add    $0x1000,%eax
    *(void(**)(void))(code-8) = mpenter;
80102f53:	c7 05 f8 6f 00 80 80 	movl   $0x80102e80,0x80006ff8
80102f5a:	2e 10 80 
    *(int**)(code-12) = (void *) V2P(entrypgdir);
80102f5d:	c7 05 f4 6f 00 80 00 	movl   $0x10a000,0x80006ff4
80102f64:	a0 10 00 
    *(void**)(code-4) = stack + KSTACKSIZE;
80102f67:	a3 fc 6f 00 80       	mov    %eax,0x80006ffc

    lapicstartap(c->apicid, V2P(code));
80102f6c:	0f b6 03             	movzbl (%ebx),%eax
80102f6f:	83 ec 08             	sub    $0x8,%esp
80102f72:	68 00 70 00 00       	push   $0x7000
80102f77:	50                   	push   %eax
80102f78:	e8 03 f8 ff ff       	call   80102780 <lapicstartap>
80102f7d:	83 c4 10             	add    $0x10,%esp

    // wait for cpu to finish mpmain()
    while(c->started == 0)
80102f80:	8b 83 a0 00 00 00    	mov    0xa0(%ebx),%eax
80102f86:	85 c0                	test   %eax,%eax
80102f88:	74 f6                	je     80102f80 <main+0xe0>
  for(c = cpus; c < cpus+ncpu; c++){
80102f8a:	69 05 60 3d 11 80 b0 	imul   $0xb0,0x80113d60,%eax
80102f91:	00 00 00 
80102f94:	81 c3 b0 00 00 00    	add    $0xb0,%ebx
80102f9a:	05 e0 37 11 80       	add    $0x801137e0,%eax
80102f9f:	39 c3                	cmp    %eax,%ebx
80102fa1:	72 9d                	jb     80102f40 <main+0xa0>
  kinit2(P2V(4*1024*1024), P2V(PHYSTOP)); // must come after startothers()
80102fa3:	83 ec 08             	sub    $0x8,%esp
80102fa6:	68 00 00 00 8e       	push   $0x8e000000
80102fab:	68 00 00 40 80       	push   $0x80400000
80102fb0:	e8 ab f4 ff ff       	call   80102460 <kinit2>
  userinit();      // first user process
80102fb5:	e8 96 0b 00 00       	call   80103b50 <userinit>
  mpmain();        // finish this processor's setup
80102fba:	e8 81 fe ff ff       	call   80102e40 <mpmain>
80102fbf:	90                   	nop

80102fc0 <mpsearch1>:
}

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
80102fc0:	55                   	push   %ebp
80102fc1:	89 e5                	mov    %esp,%ebp
80102fc3:	57                   	push   %edi
80102fc4:	56                   	push   %esi
  uchar *e, *p, *addr;

  addr = P2V(a);
80102fc5:	8d b0 00 00 00 80    	lea    -0x80000000(%eax),%esi
{
80102fcb:	53                   	push   %ebx
  e = addr+len;
80102fcc:	8d 1c 16             	lea    (%esi,%edx,1),%ebx
{
80102fcf:	83 ec 0c             	sub    $0xc,%esp
  for(p = addr; p < e; p += sizeof(struct mp))
80102fd2:	39 de                	cmp    %ebx,%esi
80102fd4:	72 10                	jb     80102fe6 <mpsearch1+0x26>
80102fd6:	eb 50                	jmp    80103028 <mpsearch1+0x68>
80102fd8:	90                   	nop
80102fd9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102fe0:	39 fb                	cmp    %edi,%ebx
80102fe2:	89 fe                	mov    %edi,%esi
80102fe4:	76 42                	jbe    80103028 <mpsearch1+0x68>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80102fe6:	83 ec 04             	sub    $0x4,%esp
80102fe9:	8d 7e 10             	lea    0x10(%esi),%edi
80102fec:	6a 04                	push   $0x4
80102fee:	68 f8 84 10 80       	push   $0x801084f8
80102ff3:	56                   	push   %esi
80102ff4:	e8 67 24 00 00       	call   80105460 <memcmp>
80102ff9:	83 c4 10             	add    $0x10,%esp
80102ffc:	85 c0                	test   %eax,%eax
80102ffe:	75 e0                	jne    80102fe0 <mpsearch1+0x20>
80103000:	89 f1                	mov    %esi,%ecx
80103002:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    sum += addr[i];
80103008:	0f b6 11             	movzbl (%ecx),%edx
8010300b:	83 c1 01             	add    $0x1,%ecx
8010300e:	01 d0                	add    %edx,%eax
  for(i=0; i<len; i++)
80103010:	39 f9                	cmp    %edi,%ecx
80103012:	75 f4                	jne    80103008 <mpsearch1+0x48>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80103014:	84 c0                	test   %al,%al
80103016:	75 c8                	jne    80102fe0 <mpsearch1+0x20>
      return (struct mp*)p;
  return 0;
}
80103018:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010301b:	89 f0                	mov    %esi,%eax
8010301d:	5b                   	pop    %ebx
8010301e:	5e                   	pop    %esi
8010301f:	5f                   	pop    %edi
80103020:	5d                   	pop    %ebp
80103021:	c3                   	ret    
80103022:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80103028:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
8010302b:	31 f6                	xor    %esi,%esi
}
8010302d:	89 f0                	mov    %esi,%eax
8010302f:	5b                   	pop    %ebx
80103030:	5e                   	pop    %esi
80103031:	5f                   	pop    %edi
80103032:	5d                   	pop    %ebp
80103033:	c3                   	ret    
80103034:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010303a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80103040 <mpinit>:
  return conf;
}

void
mpinit(void)
{
80103040:	55                   	push   %ebp
80103041:	89 e5                	mov    %esp,%ebp
80103043:	57                   	push   %edi
80103044:	56                   	push   %esi
80103045:	53                   	push   %ebx
80103046:	83 ec 1c             	sub    $0x1c,%esp
  if((p = ((bda[0x0F]<<8)| bda[0x0E]) << 4)){
80103049:	0f b6 05 0f 04 00 80 	movzbl 0x8000040f,%eax
80103050:	0f b6 15 0e 04 00 80 	movzbl 0x8000040e,%edx
80103057:	c1 e0 08             	shl    $0x8,%eax
8010305a:	09 d0                	or     %edx,%eax
8010305c:	c1 e0 04             	shl    $0x4,%eax
8010305f:	85 c0                	test   %eax,%eax
80103061:	75 1b                	jne    8010307e <mpinit+0x3e>
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
80103063:	0f b6 05 14 04 00 80 	movzbl 0x80000414,%eax
8010306a:	0f b6 15 13 04 00 80 	movzbl 0x80000413,%edx
80103071:	c1 e0 08             	shl    $0x8,%eax
80103074:	09 d0                	or     %edx,%eax
80103076:	c1 e0 0a             	shl    $0xa,%eax
    if((mp = mpsearch1(p-1024, 1024)))
80103079:	2d 00 04 00 00       	sub    $0x400,%eax
    if((mp = mpsearch1(p, 1024)))
8010307e:	ba 00 04 00 00       	mov    $0x400,%edx
80103083:	e8 38 ff ff ff       	call   80102fc0 <mpsearch1>
80103088:	85 c0                	test   %eax,%eax
8010308a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
8010308d:	0f 84 3d 01 00 00    	je     801031d0 <mpinit+0x190>
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
80103093:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80103096:	8b 58 04             	mov    0x4(%eax),%ebx
80103099:	85 db                	test   %ebx,%ebx
8010309b:	0f 84 4f 01 00 00    	je     801031f0 <mpinit+0x1b0>
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
801030a1:	8d b3 00 00 00 80    	lea    -0x80000000(%ebx),%esi
  if(memcmp(conf, "PCMP", 4) != 0)
801030a7:	83 ec 04             	sub    $0x4,%esp
801030aa:	6a 04                	push   $0x4
801030ac:	68 15 85 10 80       	push   $0x80108515
801030b1:	56                   	push   %esi
801030b2:	e8 a9 23 00 00       	call   80105460 <memcmp>
801030b7:	83 c4 10             	add    $0x10,%esp
801030ba:	85 c0                	test   %eax,%eax
801030bc:	0f 85 2e 01 00 00    	jne    801031f0 <mpinit+0x1b0>
  if(conf->version != 1 && conf->version != 4)
801030c2:	0f b6 83 06 00 00 80 	movzbl -0x7ffffffa(%ebx),%eax
801030c9:	3c 01                	cmp    $0x1,%al
801030cb:	0f 95 c2             	setne  %dl
801030ce:	3c 04                	cmp    $0x4,%al
801030d0:	0f 95 c0             	setne  %al
801030d3:	20 c2                	and    %al,%dl
801030d5:	0f 85 15 01 00 00    	jne    801031f0 <mpinit+0x1b0>
  if(sum((uchar*)conf, conf->length) != 0)
801030db:	0f b7 bb 04 00 00 80 	movzwl -0x7ffffffc(%ebx),%edi
  for(i=0; i<len; i++)
801030e2:	66 85 ff             	test   %di,%di
801030e5:	74 1a                	je     80103101 <mpinit+0xc1>
801030e7:	89 f0                	mov    %esi,%eax
801030e9:	01 f7                	add    %esi,%edi
  sum = 0;
801030eb:	31 d2                	xor    %edx,%edx
801030ed:	8d 76 00             	lea    0x0(%esi),%esi
    sum += addr[i];
801030f0:	0f b6 08             	movzbl (%eax),%ecx
801030f3:	83 c0 01             	add    $0x1,%eax
801030f6:	01 ca                	add    %ecx,%edx
  for(i=0; i<len; i++)
801030f8:	39 c7                	cmp    %eax,%edi
801030fa:	75 f4                	jne    801030f0 <mpinit+0xb0>
801030fc:	84 d2                	test   %dl,%dl
801030fe:	0f 95 c2             	setne  %dl
  struct mp *mp;
  struct mpconf *conf;
  struct mpproc *proc;
  struct mpioapic *ioapic;

  if((conf = mpconfig(&mp)) == 0)
80103101:	85 f6                	test   %esi,%esi
80103103:	0f 84 e7 00 00 00    	je     801031f0 <mpinit+0x1b0>
80103109:	84 d2                	test   %dl,%dl
8010310b:	0f 85 df 00 00 00    	jne    801031f0 <mpinit+0x1b0>
    panic("Expect to run on an SMP");
  ismp = 1;
  lapic = (uint*)conf->lapicaddr;
80103111:	8b 83 24 00 00 80    	mov    -0x7fffffdc(%ebx),%eax
80103117:	a3 dc 36 11 80       	mov    %eax,0x801136dc
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
8010311c:	0f b7 93 04 00 00 80 	movzwl -0x7ffffffc(%ebx),%edx
80103123:	8d 83 2c 00 00 80    	lea    -0x7fffffd4(%ebx),%eax
  ismp = 1;
80103129:	bb 01 00 00 00       	mov    $0x1,%ebx
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
8010312e:	01 d6                	add    %edx,%esi
80103130:	39 c6                	cmp    %eax,%esi
80103132:	76 23                	jbe    80103157 <mpinit+0x117>
    switch(*p){
80103134:	0f b6 10             	movzbl (%eax),%edx
80103137:	80 fa 04             	cmp    $0x4,%dl
8010313a:	0f 87 ca 00 00 00    	ja     8010320a <mpinit+0x1ca>
80103140:	ff 24 95 3c 85 10 80 	jmp    *-0x7fef7ac4(,%edx,4)
80103147:	89 f6                	mov    %esi,%esi
80103149:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
      p += sizeof(struct mpioapic);
      continue;
    case MPBUS:
    case MPIOINTR:
    case MPLINTR:
      p += 8;
80103150:	83 c0 08             	add    $0x8,%eax
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80103153:	39 c6                	cmp    %eax,%esi
80103155:	77 dd                	ja     80103134 <mpinit+0xf4>
    default:
      ismp = 0;
      break;
    }
  }
  if(!ismp)
80103157:	85 db                	test   %ebx,%ebx
80103159:	0f 84 9e 00 00 00    	je     801031fd <mpinit+0x1bd>
    panic("Didn't find a suitable machine");

  if(mp->imcrp){
8010315f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80103162:	80 78 0c 00          	cmpb   $0x0,0xc(%eax)
80103166:	74 15                	je     8010317d <mpinit+0x13d>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103168:	b8 70 00 00 00       	mov    $0x70,%eax
8010316d:	ba 22 00 00 00       	mov    $0x22,%edx
80103172:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103173:	ba 23 00 00 00       	mov    $0x23,%edx
80103178:	ec                   	in     (%dx),%al
    // Bochs doesn't support IMCR, so this doesn't run on Bochs.
    // But it would on real hardware.
    outb(0x22, 0x70);   // Select IMCR
    outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
80103179:	83 c8 01             	or     $0x1,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010317c:	ee                   	out    %al,(%dx)
  }
}
8010317d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103180:	5b                   	pop    %ebx
80103181:	5e                   	pop    %esi
80103182:	5f                   	pop    %edi
80103183:	5d                   	pop    %ebp
80103184:	c3                   	ret    
80103185:	8d 76 00             	lea    0x0(%esi),%esi
      if(ncpu < NCPU) {
80103188:	8b 0d 60 3d 11 80    	mov    0x80113d60,%ecx
8010318e:	83 f9 07             	cmp    $0x7,%ecx
80103191:	7f 19                	jg     801031ac <mpinit+0x16c>
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
80103193:	0f b6 50 01          	movzbl 0x1(%eax),%edx
80103197:	69 f9 b0 00 00 00    	imul   $0xb0,%ecx,%edi
        ncpu++;
8010319d:	83 c1 01             	add    $0x1,%ecx
801031a0:	89 0d 60 3d 11 80    	mov    %ecx,0x80113d60
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
801031a6:	88 97 e0 37 11 80    	mov    %dl,-0x7feec820(%edi)
      p += sizeof(struct mpproc);
801031ac:	83 c0 14             	add    $0x14,%eax
      continue;
801031af:	e9 7c ff ff ff       	jmp    80103130 <mpinit+0xf0>
801031b4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      ioapicid = ioapic->apicno;
801031b8:	0f b6 50 01          	movzbl 0x1(%eax),%edx
      p += sizeof(struct mpioapic);
801031bc:	83 c0 08             	add    $0x8,%eax
      ioapicid = ioapic->apicno;
801031bf:	88 15 c0 37 11 80    	mov    %dl,0x801137c0
      continue;
801031c5:	e9 66 ff ff ff       	jmp    80103130 <mpinit+0xf0>
801031ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  return mpsearch1(0xF0000, 0x10000);
801031d0:	ba 00 00 01 00       	mov    $0x10000,%edx
801031d5:	b8 00 00 0f 00       	mov    $0xf0000,%eax
801031da:	e8 e1 fd ff ff       	call   80102fc0 <mpsearch1>
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
801031df:	85 c0                	test   %eax,%eax
  return mpsearch1(0xF0000, 0x10000);
801031e1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
801031e4:	0f 85 a9 fe ff ff    	jne    80103093 <mpinit+0x53>
801031ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    panic("Expect to run on an SMP");
801031f0:	83 ec 0c             	sub    $0xc,%esp
801031f3:	68 fd 84 10 80       	push   $0x801084fd
801031f8:	e8 93 d1 ff ff       	call   80100390 <panic>
    panic("Didn't find a suitable machine");
801031fd:	83 ec 0c             	sub    $0xc,%esp
80103200:	68 1c 85 10 80       	push   $0x8010851c
80103205:	e8 86 d1 ff ff       	call   80100390 <panic>
      ismp = 0;
8010320a:	31 db                	xor    %ebx,%ebx
8010320c:	e9 26 ff ff ff       	jmp    80103137 <mpinit+0xf7>
80103211:	66 90                	xchg   %ax,%ax
80103213:	66 90                	xchg   %ax,%ax
80103215:	66 90                	xchg   %ax,%ax
80103217:	66 90                	xchg   %ax,%ax
80103219:	66 90                	xchg   %ax,%ax
8010321b:	66 90                	xchg   %ax,%ax
8010321d:	66 90                	xchg   %ax,%ax
8010321f:	90                   	nop

80103220 <picinit>:
#define IO_PIC2         0xA0    // Slave (IRQs 8-15)

// Don't use the 8259A interrupt controllers.  Xv6 assumes SMP hardware.
void
picinit(void)
{
80103220:	55                   	push   %ebp
80103221:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103226:	ba 21 00 00 00       	mov    $0x21,%edx
8010322b:	89 e5                	mov    %esp,%ebp
8010322d:	ee                   	out    %al,(%dx)
8010322e:	ba a1 00 00 00       	mov    $0xa1,%edx
80103233:	ee                   	out    %al,(%dx)
  // mask all interrupts
  outb(IO_PIC1+1, 0xFF);
  outb(IO_PIC2+1, 0xFF);
}
80103234:	5d                   	pop    %ebp
80103235:	c3                   	ret    
80103236:	66 90                	xchg   %ax,%ax
80103238:	66 90                	xchg   %ax,%ax
8010323a:	66 90                	xchg   %ax,%ax
8010323c:	66 90                	xchg   %ax,%ax
8010323e:	66 90                	xchg   %ax,%ax

80103240 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
80103240:	55                   	push   %ebp
80103241:	89 e5                	mov    %esp,%ebp
80103243:	57                   	push   %edi
80103244:	56                   	push   %esi
80103245:	53                   	push   %ebx
80103246:	83 ec 0c             	sub    $0xc,%esp
80103249:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010324c:	8b 75 0c             	mov    0xc(%ebp),%esi
  struct pipe *p;

  p = 0;
  *f0 = *f1 = 0;
8010324f:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
80103255:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
8010325b:	e8 20 db ff ff       	call   80100d80 <filealloc>
80103260:	85 c0                	test   %eax,%eax
80103262:	89 03                	mov    %eax,(%ebx)
80103264:	74 22                	je     80103288 <pipealloc+0x48>
80103266:	e8 15 db ff ff       	call   80100d80 <filealloc>
8010326b:	85 c0                	test   %eax,%eax
8010326d:	89 06                	mov    %eax,(%esi)
8010326f:	74 3f                	je     801032b0 <pipealloc+0x70>
    goto bad;
  if((p = (struct pipe*)kalloc()) == 0)
80103271:	e8 4a f2 ff ff       	call   801024c0 <kalloc>
80103276:	85 c0                	test   %eax,%eax
80103278:	89 c7                	mov    %eax,%edi
8010327a:	75 54                	jne    801032d0 <pipealloc+0x90>

//PAGEBREAK: 20
 bad:
  if(p)
    kfree((char*)p);
  if(*f0)
8010327c:	8b 03                	mov    (%ebx),%eax
8010327e:	85 c0                	test   %eax,%eax
80103280:	75 34                	jne    801032b6 <pipealloc+0x76>
80103282:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    fileclose(*f0);
  if(*f1)
80103288:	8b 06                	mov    (%esi),%eax
8010328a:	85 c0                	test   %eax,%eax
8010328c:	74 0c                	je     8010329a <pipealloc+0x5a>
    fileclose(*f1);
8010328e:	83 ec 0c             	sub    $0xc,%esp
80103291:	50                   	push   %eax
80103292:	e8 a9 db ff ff       	call   80100e40 <fileclose>
80103297:	83 c4 10             	add    $0x10,%esp
  return -1;
}
8010329a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return -1;
8010329d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801032a2:	5b                   	pop    %ebx
801032a3:	5e                   	pop    %esi
801032a4:	5f                   	pop    %edi
801032a5:	5d                   	pop    %ebp
801032a6:	c3                   	ret    
801032a7:	89 f6                	mov    %esi,%esi
801032a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  if(*f0)
801032b0:	8b 03                	mov    (%ebx),%eax
801032b2:	85 c0                	test   %eax,%eax
801032b4:	74 e4                	je     8010329a <pipealloc+0x5a>
    fileclose(*f0);
801032b6:	83 ec 0c             	sub    $0xc,%esp
801032b9:	50                   	push   %eax
801032ba:	e8 81 db ff ff       	call   80100e40 <fileclose>
  if(*f1)
801032bf:	8b 06                	mov    (%esi),%eax
    fileclose(*f0);
801032c1:	83 c4 10             	add    $0x10,%esp
  if(*f1)
801032c4:	85 c0                	test   %eax,%eax
801032c6:	75 c6                	jne    8010328e <pipealloc+0x4e>
801032c8:	eb d0                	jmp    8010329a <pipealloc+0x5a>
801032ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  initlock(&p->lock, "pipe");
801032d0:	83 ec 08             	sub    $0x8,%esp
  p->readopen = 1;
801032d3:	c7 80 3c 02 00 00 01 	movl   $0x1,0x23c(%eax)
801032da:	00 00 00 
  p->writeopen = 1;
801032dd:	c7 80 40 02 00 00 01 	movl   $0x1,0x240(%eax)
801032e4:	00 00 00 
  p->nwrite = 0;
801032e7:	c7 80 38 02 00 00 00 	movl   $0x0,0x238(%eax)
801032ee:	00 00 00 
  p->nread = 0;
801032f1:	c7 80 34 02 00 00 00 	movl   $0x0,0x234(%eax)
801032f8:	00 00 00 
  initlock(&p->lock, "pipe");
801032fb:	68 50 85 10 80       	push   $0x80108550
80103300:	50                   	push   %eax
80103301:	e8 ba 1e 00 00       	call   801051c0 <initlock>
  (*f0)->type = FD_PIPE;
80103306:	8b 03                	mov    (%ebx),%eax
  return 0;
80103308:	83 c4 10             	add    $0x10,%esp
  (*f0)->type = FD_PIPE;
8010330b:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f0)->readable = 1;
80103311:	8b 03                	mov    (%ebx),%eax
80103313:	c6 40 08 01          	movb   $0x1,0x8(%eax)
  (*f0)->writable = 0;
80103317:	8b 03                	mov    (%ebx),%eax
80103319:	c6 40 09 00          	movb   $0x0,0x9(%eax)
  (*f0)->pipe = p;
8010331d:	8b 03                	mov    (%ebx),%eax
8010331f:	89 78 0c             	mov    %edi,0xc(%eax)
  (*f1)->type = FD_PIPE;
80103322:	8b 06                	mov    (%esi),%eax
80103324:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f1)->readable = 0;
8010332a:	8b 06                	mov    (%esi),%eax
8010332c:	c6 40 08 00          	movb   $0x0,0x8(%eax)
  (*f1)->writable = 1;
80103330:	8b 06                	mov    (%esi),%eax
80103332:	c6 40 09 01          	movb   $0x1,0x9(%eax)
  (*f1)->pipe = p;
80103336:	8b 06                	mov    (%esi),%eax
80103338:	89 78 0c             	mov    %edi,0xc(%eax)
}
8010333b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
8010333e:	31 c0                	xor    %eax,%eax
}
80103340:	5b                   	pop    %ebx
80103341:	5e                   	pop    %esi
80103342:	5f                   	pop    %edi
80103343:	5d                   	pop    %ebp
80103344:	c3                   	ret    
80103345:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103349:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103350 <pipeclose>:

void
pipeclose(struct pipe *p, int writable)
{
80103350:	55                   	push   %ebp
80103351:	89 e5                	mov    %esp,%ebp
80103353:	56                   	push   %esi
80103354:	53                   	push   %ebx
80103355:	8b 5d 08             	mov    0x8(%ebp),%ebx
80103358:	8b 75 0c             	mov    0xc(%ebp),%esi
  acquire(&p->lock);
8010335b:	83 ec 0c             	sub    $0xc,%esp
8010335e:	53                   	push   %ebx
8010335f:	e8 9c 1f 00 00       	call   80105300 <acquire>
  if(writable){
80103364:	83 c4 10             	add    $0x10,%esp
80103367:	85 f6                	test   %esi,%esi
80103369:	74 45                	je     801033b0 <pipeclose+0x60>
    p->writeopen = 0;
    wakeup(&p->nread);
8010336b:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
80103371:	83 ec 0c             	sub    $0xc,%esp
    p->writeopen = 0;
80103374:	c7 83 40 02 00 00 00 	movl   $0x0,0x240(%ebx)
8010337b:	00 00 00 
    wakeup(&p->nread);
8010337e:	50                   	push   %eax
8010337f:	e8 ac 17 00 00       	call   80104b30 <wakeup>
80103384:	83 c4 10             	add    $0x10,%esp
  } else {
    p->readopen = 0;
    wakeup(&p->nwrite);
  }
  if(p->readopen == 0 && p->writeopen == 0){
80103387:	8b 93 3c 02 00 00    	mov    0x23c(%ebx),%edx
8010338d:	85 d2                	test   %edx,%edx
8010338f:	75 0a                	jne    8010339b <pipeclose+0x4b>
80103391:	8b 83 40 02 00 00    	mov    0x240(%ebx),%eax
80103397:	85 c0                	test   %eax,%eax
80103399:	74 35                	je     801033d0 <pipeclose+0x80>
    release(&p->lock);
    kfree((char*)p);
  } else
    release(&p->lock);
8010339b:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
8010339e:	8d 65 f8             	lea    -0x8(%ebp),%esp
801033a1:	5b                   	pop    %ebx
801033a2:	5e                   	pop    %esi
801033a3:	5d                   	pop    %ebp
    release(&p->lock);
801033a4:	e9 17 20 00 00       	jmp    801053c0 <release>
801033a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    wakeup(&p->nwrite);
801033b0:	8d 83 38 02 00 00    	lea    0x238(%ebx),%eax
801033b6:	83 ec 0c             	sub    $0xc,%esp
    p->readopen = 0;
801033b9:	c7 83 3c 02 00 00 00 	movl   $0x0,0x23c(%ebx)
801033c0:	00 00 00 
    wakeup(&p->nwrite);
801033c3:	50                   	push   %eax
801033c4:	e8 67 17 00 00       	call   80104b30 <wakeup>
801033c9:	83 c4 10             	add    $0x10,%esp
801033cc:	eb b9                	jmp    80103387 <pipeclose+0x37>
801033ce:	66 90                	xchg   %ax,%ax
    release(&p->lock);
801033d0:	83 ec 0c             	sub    $0xc,%esp
801033d3:	53                   	push   %ebx
801033d4:	e8 e7 1f 00 00       	call   801053c0 <release>
    kfree((char*)p);
801033d9:	89 5d 08             	mov    %ebx,0x8(%ebp)
801033dc:	83 c4 10             	add    $0x10,%esp
}
801033df:	8d 65 f8             	lea    -0x8(%ebp),%esp
801033e2:	5b                   	pop    %ebx
801033e3:	5e                   	pop    %esi
801033e4:	5d                   	pop    %ebp
    kfree((char*)p);
801033e5:	e9 26 ef ff ff       	jmp    80102310 <kfree>
801033ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801033f0 <pipewrite>:

//PAGEBREAK: 40
int
pipewrite(struct pipe *p, char *addr, int n)
{
801033f0:	55                   	push   %ebp
801033f1:	89 e5                	mov    %esp,%ebp
801033f3:	57                   	push   %edi
801033f4:	56                   	push   %esi
801033f5:	53                   	push   %ebx
801033f6:	83 ec 28             	sub    $0x28,%esp
801033f9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int i;

  acquire(&p->lock);
801033fc:	53                   	push   %ebx
801033fd:	e8 fe 1e 00 00       	call   80105300 <acquire>
  for(i = 0; i < n; i++){
80103402:	8b 45 10             	mov    0x10(%ebp),%eax
80103405:	83 c4 10             	add    $0x10,%esp
80103408:	85 c0                	test   %eax,%eax
8010340a:	0f 8e c9 00 00 00    	jle    801034d9 <pipewrite+0xe9>
80103410:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80103413:	8b 83 38 02 00 00    	mov    0x238(%ebx),%eax
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
      if(p->readopen == 0 || myproc()->killed){
        release(&p->lock);
        return -1;
      }
      wakeup(&p->nread);
80103419:	8d bb 34 02 00 00    	lea    0x234(%ebx),%edi
8010341f:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
80103422:	03 4d 10             	add    0x10(%ebp),%ecx
80103425:	89 4d e0             	mov    %ecx,-0x20(%ebp)
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103428:	8b 8b 34 02 00 00    	mov    0x234(%ebx),%ecx
8010342e:	8d 91 00 02 00 00    	lea    0x200(%ecx),%edx
80103434:	39 d0                	cmp    %edx,%eax
80103436:	75 71                	jne    801034a9 <pipewrite+0xb9>
      if(p->readopen == 0 || myproc()->killed){
80103438:	8b 83 3c 02 00 00    	mov    0x23c(%ebx),%eax
8010343e:	85 c0                	test   %eax,%eax
80103440:	74 4e                	je     80103490 <pipewrite+0xa0>
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
80103442:	8d b3 38 02 00 00    	lea    0x238(%ebx),%esi
80103448:	eb 3a                	jmp    80103484 <pipewrite+0x94>
8010344a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      wakeup(&p->nread);
80103450:	83 ec 0c             	sub    $0xc,%esp
80103453:	57                   	push   %edi
80103454:	e8 d7 16 00 00       	call   80104b30 <wakeup>
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
80103459:	5a                   	pop    %edx
8010345a:	59                   	pop    %ecx
8010345b:	53                   	push   %ebx
8010345c:	56                   	push   %esi
8010345d:	e8 fe 14 00 00       	call   80104960 <sleep>
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103462:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
80103468:	8b 93 38 02 00 00    	mov    0x238(%ebx),%edx
8010346e:	83 c4 10             	add    $0x10,%esp
80103471:	05 00 02 00 00       	add    $0x200,%eax
80103476:	39 c2                	cmp    %eax,%edx
80103478:	75 36                	jne    801034b0 <pipewrite+0xc0>
      if(p->readopen == 0 || myproc()->killed){
8010347a:	8b 83 3c 02 00 00    	mov    0x23c(%ebx),%eax
80103480:	85 c0                	test   %eax,%eax
80103482:	74 0c                	je     80103490 <pipewrite+0xa0>
80103484:	e8 17 04 00 00       	call   801038a0 <myproc>
80103489:	8b 40 24             	mov    0x24(%eax),%eax
8010348c:	85 c0                	test   %eax,%eax
8010348e:	74 c0                	je     80103450 <pipewrite+0x60>
        release(&p->lock);
80103490:	83 ec 0c             	sub    $0xc,%esp
80103493:	53                   	push   %ebx
80103494:	e8 27 1f 00 00       	call   801053c0 <release>
        return -1;
80103499:	83 c4 10             	add    $0x10,%esp
8010349c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
  }
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
  release(&p->lock);
  return n;
}
801034a1:	8d 65 f4             	lea    -0xc(%ebp),%esp
801034a4:	5b                   	pop    %ebx
801034a5:	5e                   	pop    %esi
801034a6:	5f                   	pop    %edi
801034a7:	5d                   	pop    %ebp
801034a8:	c3                   	ret    
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
801034a9:	89 c2                	mov    %eax,%edx
801034ab:	90                   	nop
801034ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
801034b0:	8b 75 e4             	mov    -0x1c(%ebp),%esi
801034b3:	8d 42 01             	lea    0x1(%edx),%eax
801034b6:	81 e2 ff 01 00 00    	and    $0x1ff,%edx
801034bc:	89 83 38 02 00 00    	mov    %eax,0x238(%ebx)
801034c2:	83 c6 01             	add    $0x1,%esi
801034c5:	0f b6 4e ff          	movzbl -0x1(%esi),%ecx
  for(i = 0; i < n; i++){
801034c9:	3b 75 e0             	cmp    -0x20(%ebp),%esi
801034cc:	89 75 e4             	mov    %esi,-0x1c(%ebp)
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
801034cf:	88 4c 13 34          	mov    %cl,0x34(%ebx,%edx,1)
  for(i = 0; i < n; i++){
801034d3:	0f 85 4f ff ff ff    	jne    80103428 <pipewrite+0x38>
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
801034d9:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
801034df:	83 ec 0c             	sub    $0xc,%esp
801034e2:	50                   	push   %eax
801034e3:	e8 48 16 00 00       	call   80104b30 <wakeup>
  release(&p->lock);
801034e8:	89 1c 24             	mov    %ebx,(%esp)
801034eb:	e8 d0 1e 00 00       	call   801053c0 <release>
  return n;
801034f0:	83 c4 10             	add    $0x10,%esp
801034f3:	8b 45 10             	mov    0x10(%ebp),%eax
801034f6:	eb a9                	jmp    801034a1 <pipewrite+0xb1>
801034f8:	90                   	nop
801034f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103500 <piperead>:

int
piperead(struct pipe *p, char *addr, int n)
{
80103500:	55                   	push   %ebp
80103501:	89 e5                	mov    %esp,%ebp
80103503:	57                   	push   %edi
80103504:	56                   	push   %esi
80103505:	53                   	push   %ebx
80103506:	83 ec 18             	sub    $0x18,%esp
80103509:	8b 75 08             	mov    0x8(%ebp),%esi
8010350c:	8b 7d 0c             	mov    0xc(%ebp),%edi
  int i;

  acquire(&p->lock);
8010350f:	56                   	push   %esi
80103510:	e8 eb 1d 00 00       	call   80105300 <acquire>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
80103515:	83 c4 10             	add    $0x10,%esp
80103518:	8b 8e 34 02 00 00    	mov    0x234(%esi),%ecx
8010351e:	3b 8e 38 02 00 00    	cmp    0x238(%esi),%ecx
80103524:	75 6a                	jne    80103590 <piperead+0x90>
80103526:	8b 9e 40 02 00 00    	mov    0x240(%esi),%ebx
8010352c:	85 db                	test   %ebx,%ebx
8010352e:	0f 84 c4 00 00 00    	je     801035f8 <piperead+0xf8>
    if(myproc()->killed){
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
80103534:	8d 9e 34 02 00 00    	lea    0x234(%esi),%ebx
8010353a:	eb 2d                	jmp    80103569 <piperead+0x69>
8010353c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103540:	83 ec 08             	sub    $0x8,%esp
80103543:	56                   	push   %esi
80103544:	53                   	push   %ebx
80103545:	e8 16 14 00 00       	call   80104960 <sleep>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
8010354a:	83 c4 10             	add    $0x10,%esp
8010354d:	8b 8e 34 02 00 00    	mov    0x234(%esi),%ecx
80103553:	3b 8e 38 02 00 00    	cmp    0x238(%esi),%ecx
80103559:	75 35                	jne    80103590 <piperead+0x90>
8010355b:	8b 96 40 02 00 00    	mov    0x240(%esi),%edx
80103561:	85 d2                	test   %edx,%edx
80103563:	0f 84 8f 00 00 00    	je     801035f8 <piperead+0xf8>
    if(myproc()->killed){
80103569:	e8 32 03 00 00       	call   801038a0 <myproc>
8010356e:	8b 48 24             	mov    0x24(%eax),%ecx
80103571:	85 c9                	test   %ecx,%ecx
80103573:	74 cb                	je     80103540 <piperead+0x40>
      release(&p->lock);
80103575:	83 ec 0c             	sub    $0xc,%esp
      return -1;
80103578:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
      release(&p->lock);
8010357d:	56                   	push   %esi
8010357e:	e8 3d 1e 00 00       	call   801053c0 <release>
      return -1;
80103583:	83 c4 10             	add    $0x10,%esp
    addr[i] = p->data[p->nread++ % PIPESIZE];
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
  release(&p->lock);
  return i;
}
80103586:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103589:	89 d8                	mov    %ebx,%eax
8010358b:	5b                   	pop    %ebx
8010358c:	5e                   	pop    %esi
8010358d:	5f                   	pop    %edi
8010358e:	5d                   	pop    %ebp
8010358f:	c3                   	ret    
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103590:	8b 45 10             	mov    0x10(%ebp),%eax
80103593:	85 c0                	test   %eax,%eax
80103595:	7e 61                	jle    801035f8 <piperead+0xf8>
    if(p->nread == p->nwrite)
80103597:	31 db                	xor    %ebx,%ebx
80103599:	eb 13                	jmp    801035ae <piperead+0xae>
8010359b:	90                   	nop
8010359c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801035a0:	8b 8e 34 02 00 00    	mov    0x234(%esi),%ecx
801035a6:	3b 8e 38 02 00 00    	cmp    0x238(%esi),%ecx
801035ac:	74 1f                	je     801035cd <piperead+0xcd>
    addr[i] = p->data[p->nread++ % PIPESIZE];
801035ae:	8d 41 01             	lea    0x1(%ecx),%eax
801035b1:	81 e1 ff 01 00 00    	and    $0x1ff,%ecx
801035b7:	89 86 34 02 00 00    	mov    %eax,0x234(%esi)
801035bd:	0f b6 44 0e 34       	movzbl 0x34(%esi,%ecx,1),%eax
801035c2:	88 04 1f             	mov    %al,(%edi,%ebx,1)
  for(i = 0; i < n; i++){  //DOC: piperead-copy
801035c5:	83 c3 01             	add    $0x1,%ebx
801035c8:	39 5d 10             	cmp    %ebx,0x10(%ebp)
801035cb:	75 d3                	jne    801035a0 <piperead+0xa0>
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
801035cd:	8d 86 38 02 00 00    	lea    0x238(%esi),%eax
801035d3:	83 ec 0c             	sub    $0xc,%esp
801035d6:	50                   	push   %eax
801035d7:	e8 54 15 00 00       	call   80104b30 <wakeup>
  release(&p->lock);
801035dc:	89 34 24             	mov    %esi,(%esp)
801035df:	e8 dc 1d 00 00       	call   801053c0 <release>
  return i;
801035e4:	83 c4 10             	add    $0x10,%esp
}
801035e7:	8d 65 f4             	lea    -0xc(%ebp),%esp
801035ea:	89 d8                	mov    %ebx,%eax
801035ec:	5b                   	pop    %ebx
801035ed:	5e                   	pop    %esi
801035ee:	5f                   	pop    %edi
801035ef:	5d                   	pop    %ebp
801035f0:	c3                   	ret    
801035f1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801035f8:	31 db                	xor    %ebx,%ebx
801035fa:	eb d1                	jmp    801035cd <piperead+0xcd>
801035fc:	66 90                	xchg   %ax,%ax
801035fe:	66 90                	xchg   %ax,%ax

80103600 <allocproc>:
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.
static struct proc *
allocproc(void)
{
80103600:	55                   	push   %ebp
80103601:	89 e5                	mov    %esp,%ebp
80103603:	53                   	push   %ebx
  struct proc *p;
  char *sp;

  acquire(&ptable.lock);

  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103604:	bb b4 41 11 80       	mov    $0x801141b4,%ebx
{
80103609:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock);
8010360c:	68 80 41 11 80       	push   $0x80114180
80103611:	e8 ea 1c 00 00       	call   80105300 <acquire>
80103616:	83 c4 10             	add    $0x10,%esp
80103619:	eb 17                	jmp    80103632 <allocproc+0x32>
8010361b:	90                   	nop
8010361c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103620:	81 c3 ec 00 00 00    	add    $0xec,%ebx
80103626:	81 fb b4 7c 11 80    	cmp    $0x80117cb4,%ebx
8010362c:	0f 83 36 01 00 00    	jae    80103768 <allocproc+0x168>
    if (p->state == UNUSED)
80103632:	8b 43 0c             	mov    0xc(%ebx),%eax
80103635:	85 c0                	test   %eax,%eax
80103637:	75 e7                	jne    80103620 <allocproc+0x20>
  release(&ptable.lock);
  return 0;

found:
  p->state = EMBRYO;
  p->pid = nextpid++;
80103639:	a1 04 b0 10 80       	mov    0x8010b004,%eax
  // p->start = ticks;
  p->waittime = 5;

  c0++;
  queue0[c0] = p;
  release(&ptable.lock);
8010363e:	83 ec 0c             	sub    $0xc,%esp
  p->state = EMBRYO;
80103641:	c7 43 0c 01 00 00 00 	movl   $0x1,0xc(%ebx)
  p->current_queue = 0;
80103648:	c7 83 a4 00 00 00 00 	movl   $0x0,0xa4(%ebx)
8010364f:	00 00 00 
  p->ticks[0] = 0;
80103652:	c7 83 d4 00 00 00 00 	movl   $0x0,0xd4(%ebx)
80103659:	00 00 00 
  p->ticks[1] = 0;
8010365c:	c7 83 d8 00 00 00 00 	movl   $0x0,0xd8(%ebx)
80103663:	00 00 00 
  p->ticks[2] = 0;
80103666:	c7 83 dc 00 00 00 00 	movl   $0x0,0xdc(%ebx)
8010366d:	00 00 00 
  p->pid = nextpid++;
80103670:	8d 50 01             	lea    0x1(%eax),%edx
80103673:	89 43 10             	mov    %eax,0x10(%ebx)
  c0++;
80103676:	a1 18 b0 10 80       	mov    0x8010b018,%eax
  p->ticks[3] = 0;
8010367b:	c7 83 e0 00 00 00 00 	movl   $0x0,0xe0(%ebx)
80103682:	00 00 00 
  p->ticks[4] = 0;
80103685:	c7 83 e4 00 00 00 00 	movl   $0x0,0xe4(%ebx)
8010368c:	00 00 00 
  p->waittime = 5;
8010368f:	c7 83 a0 00 00 00 05 	movl   $0x5,0xa0(%ebx)
80103696:	00 00 00 
  release(&ptable.lock);
80103699:	68 80 41 11 80       	push   $0x80114180
  c0++;
8010369e:	83 c0 01             	add    $0x1,%eax
  p->pid = nextpid++;
801036a1:	89 15 04 b0 10 80    	mov    %edx,0x8010b004
  c0++;
801036a7:	a3 18 b0 10 80       	mov    %eax,0x8010b018
  queue0[c0] = p;
801036ac:	89 1c 85 c0 7c 11 80 	mov    %ebx,-0x7fee8340(,%eax,4)
  release(&ptable.lock);
801036b3:	e8 08 1d 00 00       	call   801053c0 <release>

  // Allocate kernel stack.
  if ((p->kstack = kalloc()) == 0)
801036b8:	e8 03 ee ff ff       	call   801024c0 <kalloc>
801036bd:	83 c4 10             	add    $0x10,%esp
801036c0:	85 c0                	test   %eax,%eax
801036c2:	89 43 08             	mov    %eax,0x8(%ebx)
801036c5:	0f 84 b6 00 00 00    	je     80103781 <allocproc+0x181>
    return 0;
  }
  sp = p->kstack + KSTACKSIZE;

  // Leave room for trap frame.
  sp -= sizeof *p->tf;
801036cb:	8d 90 b4 0f 00 00    	lea    0xfb4(%eax),%edx
  sp -= 4;
  *(uint *)sp = (uint)trapret;

  sp -= sizeof *p->context;
  p->context = (struct context *)sp;
  memset(p->context, 0, sizeof *p->context);
801036d1:	83 ec 04             	sub    $0x4,%esp
  sp -= sizeof *p->context;
801036d4:	05 9c 0f 00 00       	add    $0xf9c,%eax
  sp -= sizeof *p->tf;
801036d9:	89 53 18             	mov    %edx,0x18(%ebx)
  *(uint *)sp = (uint)trapret;
801036dc:	c7 40 14 ff 66 10 80 	movl   $0x801066ff,0x14(%eax)
  p->context = (struct context *)sp;
801036e3:	89 43 1c             	mov    %eax,0x1c(%ebx)
  memset(p->context, 0, sizeof *p->context);
801036e6:	6a 14                	push   $0x14
801036e8:	6a 00                	push   $0x0
801036ea:	50                   	push   %eax
801036eb:	e8 20 1d 00 00       	call   80105410 <memset>
  p->context->eip = (uint)forkret;
801036f0:	8b 43 1c             	mov    0x1c(%ebx),%eax
801036f3:	c7 40 10 90 37 10 80 	movl   $0x80103790,0x10(%eax)

  acquire(&ptable.lock);
801036fa:	c7 04 24 80 41 11 80 	movl   $0x80114180,(%esp)
80103701:	e8 fa 1b 00 00       	call   80105300 <acquire>
  p->ctime = ticks; // TODO Might need to protect the read of ticks with a lock
80103706:	a1 00 86 11 80       	mov    0x80118600,%eax
  p->etime = 0;
8010370b:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
80103712:	00 00 00 
  p->rtime = 0;
80103715:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
8010371c:	00 00 00 
  p->iotime = 0;
8010371f:	c7 83 88 00 00 00 00 	movl   $0x0,0x88(%ebx)
80103726:	00 00 00 
  p->num_r = 0;
80103729:	c7 83 8c 00 00 00 00 	movl   $0x0,0x8c(%ebx)
80103730:	00 00 00 
  p->ctime = ticks; // TODO Might need to protect the read of ticks with a lock
80103733:	89 43 7c             	mov    %eax,0x7c(%ebx)
  release(&ptable.lock);
80103736:	c7 04 24 80 41 11 80 	movl   $0x80114180,(%esp)
8010373d:	e8 7e 1c 00 00       	call   801053c0 <release>

  if (p->pid == 1 || p->pid == 2)
80103742:	8b 43 10             	mov    0x10(%ebx),%eax
80103745:	83 c4 10             	add    $0x10,%esp
80103748:	83 e8 01             	sub    $0x1,%eax
    p->priority = 1;
8010374b:	83 f8 02             	cmp    $0x2,%eax
8010374e:	19 c0                	sbb    %eax,%eax
80103750:	83 e0 c5             	and    $0xffffffc5,%eax
80103753:	83 c0 3c             	add    $0x3c,%eax
80103756:	89 83 90 00 00 00    	mov    %eax,0x90(%ebx)
  else
    p->priority = 60;
  return p;
}
8010375c:	89 d8                	mov    %ebx,%eax
8010375e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103761:	c9                   	leave  
80103762:	c3                   	ret    
80103763:	90                   	nop
80103764:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  release(&ptable.lock);
80103768:	83 ec 0c             	sub    $0xc,%esp
  return 0;
8010376b:	31 db                	xor    %ebx,%ebx
  release(&ptable.lock);
8010376d:	68 80 41 11 80       	push   $0x80114180
80103772:	e8 49 1c 00 00       	call   801053c0 <release>
}
80103777:	89 d8                	mov    %ebx,%eax
  return 0;
80103779:	83 c4 10             	add    $0x10,%esp
}
8010377c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010377f:	c9                   	leave  
80103780:	c3                   	ret    
    p->state = UNUSED;
80103781:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    return 0;
80103788:	31 db                	xor    %ebx,%ebx
8010378a:	eb d0                	jmp    8010375c <allocproc+0x15c>
8010378c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80103790 <forkret>:
}

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void forkret(void)
{
80103790:	55                   	push   %ebp
80103791:	89 e5                	mov    %esp,%ebp
80103793:	83 ec 14             	sub    $0x14,%esp
  static int first = 1;
  // Still holding ptable.lock from scheduler.
  release(&ptable.lock);
80103796:	68 80 41 11 80       	push   $0x80114180
8010379b:	e8 20 1c 00 00       	call   801053c0 <release>

  if (first)
801037a0:	a1 00 b0 10 80       	mov    0x8010b000,%eax
801037a5:	83 c4 10             	add    $0x10,%esp
801037a8:	85 c0                	test   %eax,%eax
801037aa:	75 04                	jne    801037b0 <forkret+0x20>
    iinit(ROOTDEV);
    initlog(ROOTDEV);
  }

  // Return to "caller", actually trapret (see allocproc).
}
801037ac:	c9                   	leave  
801037ad:	c3                   	ret    
801037ae:	66 90                	xchg   %ax,%ax
    iinit(ROOTDEV);
801037b0:	83 ec 0c             	sub    $0xc,%esp
    first = 0;
801037b3:	c7 05 00 b0 10 80 00 	movl   $0x0,0x8010b000
801037ba:	00 00 00 
    iinit(ROOTDEV);
801037bd:	6a 01                	push   $0x1
801037bf:	e8 bc dc ff ff       	call   80101480 <iinit>
    initlog(ROOTDEV);
801037c4:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
801037cb:	e8 30 f3 ff ff       	call   80102b00 <initlog>
801037d0:	83 c4 10             	add    $0x10,%esp
}
801037d3:	c9                   	leave  
801037d4:	c3                   	ret    
801037d5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801037d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801037e0 <pinit>:
{
801037e0:	55                   	push   %ebp
801037e1:	89 e5                	mov    %esp,%ebp
801037e3:	83 ec 10             	sub    $0x10,%esp
  initlock(&ptable.lock, "ptable");
801037e6:	68 55 85 10 80       	push   $0x80108555
801037eb:	68 80 41 11 80       	push   $0x80114180
801037f0:	e8 cb 19 00 00       	call   801051c0 <initlock>
}
801037f5:	83 c4 10             	add    $0x10,%esp
801037f8:	c9                   	leave  
801037f9:	c3                   	ret    
801037fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80103800 <mycpu>:
{
80103800:	55                   	push   %ebp
80103801:	89 e5                	mov    %esp,%ebp
80103803:	56                   	push   %esi
80103804:	53                   	push   %ebx
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80103805:	9c                   	pushf  
80103806:	58                   	pop    %eax
  if (readeflags() & FL_IF)
80103807:	f6 c4 02             	test   $0x2,%ah
8010380a:	75 5e                	jne    8010386a <mycpu+0x6a>
  apicid = lapicid();
8010380c:	e8 1f ef ff ff       	call   80102730 <lapicid>
  for (i = 0; i < ncpu; ++i)
80103811:	8b 35 60 3d 11 80    	mov    0x80113d60,%esi
80103817:	85 f6                	test   %esi,%esi
80103819:	7e 42                	jle    8010385d <mycpu+0x5d>
    if (cpus[i].apicid == apicid)
8010381b:	0f b6 15 e0 37 11 80 	movzbl 0x801137e0,%edx
80103822:	39 d0                	cmp    %edx,%eax
80103824:	74 30                	je     80103856 <mycpu+0x56>
80103826:	b9 90 38 11 80       	mov    $0x80113890,%ecx
  for (i = 0; i < ncpu; ++i)
8010382b:	31 d2                	xor    %edx,%edx
8010382d:	8d 76 00             	lea    0x0(%esi),%esi
80103830:	83 c2 01             	add    $0x1,%edx
80103833:	39 f2                	cmp    %esi,%edx
80103835:	74 26                	je     8010385d <mycpu+0x5d>
    if (cpus[i].apicid == apicid)
80103837:	0f b6 19             	movzbl (%ecx),%ebx
8010383a:	81 c1 b0 00 00 00    	add    $0xb0,%ecx
80103840:	39 c3                	cmp    %eax,%ebx
80103842:	75 ec                	jne    80103830 <mycpu+0x30>
80103844:	69 c2 b0 00 00 00    	imul   $0xb0,%edx,%eax
8010384a:	05 e0 37 11 80       	add    $0x801137e0,%eax
}
8010384f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103852:	5b                   	pop    %ebx
80103853:	5e                   	pop    %esi
80103854:	5d                   	pop    %ebp
80103855:	c3                   	ret    
    if (cpus[i].apicid == apicid)
80103856:	b8 e0 37 11 80       	mov    $0x801137e0,%eax
      return &cpus[i];
8010385b:	eb f2                	jmp    8010384f <mycpu+0x4f>
  panic("unknown apicid\n");
8010385d:	83 ec 0c             	sub    $0xc,%esp
80103860:	68 5c 85 10 80       	push   $0x8010855c
80103865:	e8 26 cb ff ff       	call   80100390 <panic>
    panic("mycpu called with interrupts enabled\n");
8010386a:	83 ec 0c             	sub    $0xc,%esp
8010386d:	68 48 86 10 80       	push   $0x80108648
80103872:	e8 19 cb ff ff       	call   80100390 <panic>
80103877:	89 f6                	mov    %esi,%esi
80103879:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103880 <cpuid>:
{
80103880:	55                   	push   %ebp
80103881:	89 e5                	mov    %esp,%ebp
80103883:	83 ec 08             	sub    $0x8,%esp
  return mycpu() - cpus;
80103886:	e8 75 ff ff ff       	call   80103800 <mycpu>
8010388b:	2d e0 37 11 80       	sub    $0x801137e0,%eax
}
80103890:	c9                   	leave  
  return mycpu() - cpus;
80103891:	c1 f8 04             	sar    $0x4,%eax
80103894:	69 c0 a3 8b 2e ba    	imul   $0xba2e8ba3,%eax,%eax
}
8010389a:	c3                   	ret    
8010389b:	90                   	nop
8010389c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801038a0 <myproc>:
{
801038a0:	55                   	push   %ebp
801038a1:	89 e5                	mov    %esp,%ebp
801038a3:	53                   	push   %ebx
801038a4:	83 ec 04             	sub    $0x4,%esp
  pushcli();
801038a7:	e8 84 19 00 00       	call   80105230 <pushcli>
  c = mycpu();
801038ac:	e8 4f ff ff ff       	call   80103800 <mycpu>
  p = c->proc;
801038b1:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
801038b7:	e8 b4 19 00 00       	call   80105270 <popcli>
}
801038bc:	83 c4 04             	add    $0x4,%esp
801038bf:	89 d8                	mov    %ebx,%eax
801038c1:	5b                   	pop    %ebx
801038c2:	5d                   	pop    %ebp
801038c3:	c3                   	ret    
801038c4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801038ca:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

801038d0 <rem_process>:
{
801038d0:	55                   	push   %ebp
801038d1:	89 e5                	mov    %esp,%ebp
801038d3:	57                   	push   %edi
801038d4:	56                   	push   %esi
801038d5:	8b 55 0c             	mov    0xc(%ebp),%edx
801038d8:	53                   	push   %ebx
801038d9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(curq==0)
801038dc:	85 d2                	test   %edx,%edx
801038de:	75 70                	jne    80103950 <rem_process+0x80>
    for(int i=0; i<=c0; i++)
801038e0:	8b 0d 18 b0 10 80    	mov    0x8010b018,%ecx
801038e6:	31 c0                	xor    %eax,%eax
801038e8:	85 c9                	test   %ecx,%ecx
801038ea:	79 44                	jns    80103930 <rem_process+0x60>
}
801038ec:	5b                   	pop    %ebx
801038ed:	5e                   	pop    %esi
801038ee:	5f                   	pop    %edi
801038ef:	5d                   	pop    %ebp
801038f0:	c3                   	ret    
801038f1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        c0--;
801038f8:	8d 71 ff             	lea    -0x1(%ecx),%esi
        for (int j = i; j <= c0 ; j++)
801038fb:	39 d6                	cmp    %edx,%esi
801038fd:	7c 1e                	jl     8010391d <rem_process+0x4d>
801038ff:	8d 04 95 c0 7c 11 80 	lea    -0x7fee8340(,%edx,4),%eax
80103906:	8d 3c 8d c0 7c 11 80 	lea    -0x7fee8340(,%ecx,4),%edi
8010390d:	8d 76 00             	lea    0x0(%esi),%esi
            queue0[j] = queue0[j + 1];
80103910:	8b 48 04             	mov    0x4(%eax),%ecx
80103913:	83 c0 04             	add    $0x4,%eax
80103916:	89 48 fc             	mov    %ecx,-0x4(%eax)
        for (int j = i; j <= c0 ; j++)
80103919:	39 f8                	cmp    %edi,%eax
8010391b:	75 f3                	jne    80103910 <rem_process+0x40>
8010391d:	89 f1                	mov    %esi,%ecx
    for(int i=0; i<=c0; i++)
8010391f:	83 c2 01             	add    $0x1,%edx
        for (int j = i; j <= c0 ; j++)
80103922:	b8 01 00 00 00       	mov    $0x1,%eax
    for(int i=0; i<=c0; i++)
80103927:	39 ca                	cmp    %ecx,%edx
80103929:	7f 18                	jg     80103943 <rem_process+0x73>
8010392b:	90                   	nop
8010392c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      if(queue0[i]->pid==pid)
80103930:	8b 34 95 c0 7c 11 80 	mov    -0x7fee8340(,%edx,4),%esi
80103937:	39 5e 10             	cmp    %ebx,0x10(%esi)
8010393a:	74 bc                	je     801038f8 <rem_process+0x28>
    for(int i=0; i<=c0; i++)
8010393c:	83 c2 01             	add    $0x1,%edx
8010393f:	39 ca                	cmp    %ecx,%edx
80103941:	7e ed                	jle    80103930 <rem_process+0x60>
80103943:	84 c0                	test   %al,%al
80103945:	74 a5                	je     801038ec <rem_process+0x1c>
80103947:	89 0d 18 b0 10 80    	mov    %ecx,0x8010b018
}
8010394d:	eb 9d                	jmp    801038ec <rem_process+0x1c>
8010394f:	90                   	nop
  else if(curq==1)
80103950:	83 fa 01             	cmp    $0x1,%edx
80103953:	74 7b                	je     801039d0 <rem_process+0x100>
  else if(curq==2)
80103955:	83 fa 02             	cmp    $0x2,%edx
80103958:	0f 84 42 01 00 00    	je     80103aa0 <rem_process+0x1d0>
  else if(curq==3)
8010395e:	83 fa 03             	cmp    $0x3,%edx
80103961:	0f 84 d9 00 00 00    	je     80103a40 <rem_process+0x170>
  else if(curq==4)
80103967:	83 fa 04             	cmp    $0x4,%edx
8010396a:	75 80                	jne    801038ec <rem_process+0x1c>
    for(int i=0; i<=c4; i++)
8010396c:	8b 0d 08 b0 10 80    	mov    0x8010b008,%ecx
80103972:	85 c9                	test   %ecx,%ecx
80103974:	0f 88 72 ff ff ff    	js     801038ec <rem_process+0x1c>
8010397a:	31 c0                	xor    %eax,%eax
8010397c:	31 d2                	xor    %edx,%edx
8010397e:	eb 0b                	jmp    8010398b <rem_process+0xbb>
80103980:	83 c2 01             	add    $0x1,%edx
80103983:	39 d1                	cmp    %edx,%ecx
80103985:	0f 8c a5 01 00 00    	jl     80103b30 <rem_process+0x260>
      if(queue4[i]->pid==pid)
8010398b:	8b 34 95 80 3f 11 80 	mov    -0x7feec080(,%edx,4),%esi
80103992:	3b 5e 10             	cmp    0x10(%esi),%ebx
80103995:	75 e9                	jne    80103980 <rem_process+0xb0>
        c4--;
80103997:	8d 71 ff             	lea    -0x1(%ecx),%esi
        for (int j = i; j <= c4 ; j++)
8010399a:	39 d6                	cmp    %edx,%esi
8010399c:	7c 1f                	jl     801039bd <rem_process+0xed>
8010399e:	8d 04 95 80 3f 11 80 	lea    -0x7feec080(,%edx,4),%eax
801039a5:	8d 3c 8d 80 3f 11 80 	lea    -0x7feec080(,%ecx,4),%edi
801039ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
            queue4[j] = queue4[j + 1];
801039b0:	8b 48 04             	mov    0x4(%eax),%ecx
801039b3:	83 c0 04             	add    $0x4,%eax
801039b6:	89 48 fc             	mov    %ecx,-0x4(%eax)
        for (int j = i; j <= c4 ; j++)
801039b9:	39 f8                	cmp    %edi,%eax
801039bb:	75 f3                	jne    801039b0 <rem_process+0xe0>
801039bd:	89 f1                	mov    %esi,%ecx
801039bf:	b8 01 00 00 00       	mov    $0x1,%eax
801039c4:	eb ba                	jmp    80103980 <rem_process+0xb0>
801039c6:	8d 76 00             	lea    0x0(%esi),%esi
801039c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    for(int i=0; i<=c1; i++)
801039d0:	8b 0d 14 b0 10 80    	mov    0x8010b014,%ecx
801039d6:	85 c9                	test   %ecx,%ecx
801039d8:	0f 88 0e ff ff ff    	js     801038ec <rem_process+0x1c>
801039de:	31 c0                	xor    %eax,%eax
801039e0:	31 d2                	xor    %edx,%edx
801039e2:	eb 0b                	jmp    801039ef <rem_process+0x11f>
801039e4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801039e8:	83 c2 01             	add    $0x1,%edx
801039eb:	39 ca                	cmp    %ecx,%edx
801039ed:	7f 3c                	jg     80103a2b <rem_process+0x15b>
      if(queue1[i]->pid==pid)
801039ef:	8b 34 95 80 40 11 80 	mov    -0x7feebf80(,%edx,4),%esi
801039f6:	39 5e 10             	cmp    %ebx,0x10(%esi)
801039f9:	75 ed                	jne    801039e8 <rem_process+0x118>
        c1--;
801039fb:	8d 71 ff             	lea    -0x1(%ecx),%esi
        for (int j = i; j <= c1 ; j++)
801039fe:	39 d6                	cmp    %edx,%esi
80103a00:	7c 1b                	jl     80103a1d <rem_process+0x14d>
80103a02:	8d 04 95 80 40 11 80 	lea    -0x7feebf80(,%edx,4),%eax
80103a09:	8d 3c 8d 80 40 11 80 	lea    -0x7feebf80(,%ecx,4),%edi
            queue1[j] = queue1[j + 1];
80103a10:	8b 48 04             	mov    0x4(%eax),%ecx
80103a13:	83 c0 04             	add    $0x4,%eax
80103a16:	89 48 fc             	mov    %ecx,-0x4(%eax)
        for (int j = i; j <= c1 ; j++)
80103a19:	39 c7                	cmp    %eax,%edi
80103a1b:	75 f3                	jne    80103a10 <rem_process+0x140>
80103a1d:	89 f1                	mov    %esi,%ecx
    for(int i=0; i<=c1; i++)
80103a1f:	83 c2 01             	add    $0x1,%edx
        for (int j = i; j <= c1 ; j++)
80103a22:	b8 01 00 00 00       	mov    $0x1,%eax
    for(int i=0; i<=c1; i++)
80103a27:	39 ca                	cmp    %ecx,%edx
80103a29:	7e c4                	jle    801039ef <rem_process+0x11f>
80103a2b:	84 c0                	test   %al,%al
80103a2d:	0f 84 b9 fe ff ff    	je     801038ec <rem_process+0x1c>
80103a33:	89 0d 14 b0 10 80    	mov    %ecx,0x8010b014
80103a39:	e9 ae fe ff ff       	jmp    801038ec <rem_process+0x1c>
80103a3e:	66 90                	xchg   %ax,%ax
    for(int i=0; i<=c3; i++)
80103a40:	8b 0d 0c b0 10 80    	mov    0x8010b00c,%ecx
80103a46:	85 c9                	test   %ecx,%ecx
80103a48:	0f 88 9e fe ff ff    	js     801038ec <rem_process+0x1c>
80103a4e:	31 c0                	xor    %eax,%eax
80103a50:	31 d2                	xor    %edx,%edx
80103a52:	eb 0f                	jmp    80103a63 <rem_process+0x193>
80103a54:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103a58:	83 c2 01             	add    $0x1,%edx
80103a5b:	39 ca                	cmp    %ecx,%edx
80103a5d:	0f 8f b5 00 00 00    	jg     80103b18 <rem_process+0x248>
      if(queue3[i]->pid==pid)
80103a63:	8b 34 95 80 3d 11 80 	mov    -0x7feec280(,%edx,4),%esi
80103a6a:	3b 5e 10             	cmp    0x10(%esi),%ebx
80103a6d:	75 e9                	jne    80103a58 <rem_process+0x188>
        c3--;
80103a6f:	8d 71 ff             	lea    -0x1(%ecx),%esi
        for (int j = i; j <= c3 ; j++)
80103a72:	39 d6                	cmp    %edx,%esi
80103a74:	7c 1f                	jl     80103a95 <rem_process+0x1c5>
80103a76:	8d 04 95 80 3d 11 80 	lea    -0x7feec280(,%edx,4),%eax
80103a7d:	8d 3c 8d 80 3d 11 80 	lea    -0x7feec280(,%ecx,4),%edi
80103a84:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
            queue3[j] = queue3[j + 1];
80103a88:	8b 48 04             	mov    0x4(%eax),%ecx
80103a8b:	83 c0 04             	add    $0x4,%eax
80103a8e:	89 48 fc             	mov    %ecx,-0x4(%eax)
        for (int j = i; j <= c3 ; j++)
80103a91:	39 f8                	cmp    %edi,%eax
80103a93:	75 f3                	jne    80103a88 <rem_process+0x1b8>
80103a95:	89 f1                	mov    %esi,%ecx
80103a97:	b8 01 00 00 00       	mov    $0x1,%eax
80103a9c:	eb ba                	jmp    80103a58 <rem_process+0x188>
80103a9e:	66 90                	xchg   %ax,%ax
    for(int i=0; i<=c2; i++)
80103aa0:	8b 0d 10 b0 10 80    	mov    0x8010b010,%ecx
80103aa6:	85 c9                	test   %ecx,%ecx
80103aa8:	0f 88 3e fe ff ff    	js     801038ec <rem_process+0x1c>
80103aae:	31 c0                	xor    %eax,%eax
80103ab0:	31 d2                	xor    %edx,%edx
80103ab2:	eb 0b                	jmp    80103abf <rem_process+0x1ef>
80103ab4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103ab8:	83 c2 01             	add    $0x1,%edx
80103abb:	39 ca                	cmp    %ecx,%edx
80103abd:	7f 41                	jg     80103b00 <rem_process+0x230>
      if(queue2[i]->pid==pid)
80103abf:	8b 34 95 80 3e 11 80 	mov    -0x7feec180(,%edx,4),%esi
80103ac6:	3b 5e 10             	cmp    0x10(%esi),%ebx
80103ac9:	75 ed                	jne    80103ab8 <rem_process+0x1e8>
        c2--;
80103acb:	8d 71 ff             	lea    -0x1(%ecx),%esi
        for (int j = i; j <= c2 ; j++)
80103ace:	39 d6                	cmp    %edx,%esi
80103ad0:	7c 1b                	jl     80103aed <rem_process+0x21d>
80103ad2:	8d 04 95 80 3e 11 80 	lea    -0x7feec180(,%edx,4),%eax
80103ad9:	8d 3c 8d 80 3e 11 80 	lea    -0x7feec180(,%ecx,4),%edi
            queue2[j] = queue2[j + 1];
80103ae0:	8b 48 04             	mov    0x4(%eax),%ecx
80103ae3:	83 c0 04             	add    $0x4,%eax
80103ae6:	89 48 fc             	mov    %ecx,-0x4(%eax)
        for (int j = i; j <= c2 ; j++)
80103ae9:	39 f8                	cmp    %edi,%eax
80103aeb:	75 f3                	jne    80103ae0 <rem_process+0x210>
80103aed:	89 f1                	mov    %esi,%ecx
80103aef:	b8 01 00 00 00       	mov    $0x1,%eax
80103af4:	eb c2                	jmp    80103ab8 <rem_process+0x1e8>
80103af6:	8d 76 00             	lea    0x0(%esi),%esi
80103af9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80103b00:	84 c0                	test   %al,%al
80103b02:	0f 84 e4 fd ff ff    	je     801038ec <rem_process+0x1c>
80103b08:	89 0d 10 b0 10 80    	mov    %ecx,0x8010b010
80103b0e:	e9 d9 fd ff ff       	jmp    801038ec <rem_process+0x1c>
80103b13:	90                   	nop
80103b14:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103b18:	84 c0                	test   %al,%al
80103b1a:	0f 84 cc fd ff ff    	je     801038ec <rem_process+0x1c>
80103b20:	89 0d 0c b0 10 80    	mov    %ecx,0x8010b00c
80103b26:	e9 c1 fd ff ff       	jmp    801038ec <rem_process+0x1c>
80103b2b:	90                   	nop
80103b2c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103b30:	84 c0                	test   %al,%al
80103b32:	0f 84 b4 fd ff ff    	je     801038ec <rem_process+0x1c>
80103b38:	89 0d 08 b0 10 80    	mov    %ecx,0x8010b008
80103b3e:	e9 a9 fd ff ff       	jmp    801038ec <rem_process+0x1c>
80103b43:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80103b49:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103b50 <userinit>:
{
80103b50:	55                   	push   %ebp
80103b51:	89 e5                	mov    %esp,%ebp
80103b53:	53                   	push   %ebx
80103b54:	83 ec 04             	sub    $0x4,%esp
  p = allocproc();
80103b57:	e8 a4 fa ff ff       	call   80103600 <allocproc>
80103b5c:	89 c3                	mov    %eax,%ebx
  initproc = p;
80103b5e:	a3 d8 b5 10 80       	mov    %eax,0x8010b5d8
  if ((p->pgdir = setupkvm()) == 0)
80103b63:	e8 f8 41 00 00       	call   80107d60 <setupkvm>
80103b68:	85 c0                	test   %eax,%eax
80103b6a:	89 43 04             	mov    %eax,0x4(%ebx)
80103b6d:	0f 84 c8 00 00 00    	je     80103c3b <userinit+0xeb>
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
80103b73:	83 ec 04             	sub    $0x4,%esp
80103b76:	68 2c 00 00 00       	push   $0x2c
80103b7b:	68 80 b4 10 80       	push   $0x8010b480
80103b80:	50                   	push   %eax
80103b81:	e8 ba 3e 00 00       	call   80107a40 <inituvm>
  memset(p->tf, 0, sizeof(*p->tf));
80103b86:	83 c4 0c             	add    $0xc,%esp
  p->sz = PGSIZE;
80103b89:	c7 03 00 10 00 00    	movl   $0x1000,(%ebx)
  memset(p->tf, 0, sizeof(*p->tf));
80103b8f:	6a 4c                	push   $0x4c
80103b91:	6a 00                	push   $0x0
80103b93:	ff 73 18             	pushl  0x18(%ebx)
80103b96:	e8 75 18 00 00       	call   80105410 <memset>
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
80103b9b:	8b 43 18             	mov    0x18(%ebx),%eax
80103b9e:	ba 1b 00 00 00       	mov    $0x1b,%edx
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80103ba3:	b9 23 00 00 00       	mov    $0x23,%ecx
  safestrcpy(p->name, "initcode", sizeof(p->name));
80103ba8:	83 c4 0c             	add    $0xc,%esp
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
80103bab:	66 89 50 3c          	mov    %dx,0x3c(%eax)
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80103baf:	8b 43 18             	mov    0x18(%ebx),%eax
80103bb2:	66 89 48 2c          	mov    %cx,0x2c(%eax)
  p->tf->es = p->tf->ds;
80103bb6:	8b 43 18             	mov    0x18(%ebx),%eax
80103bb9:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
80103bbd:	66 89 50 28          	mov    %dx,0x28(%eax)
  p->tf->ss = p->tf->ds;
80103bc1:	8b 43 18             	mov    0x18(%ebx),%eax
80103bc4:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
80103bc8:	66 89 50 48          	mov    %dx,0x48(%eax)
  p->tf->eflags = FL_IF;
80103bcc:	8b 43 18             	mov    0x18(%ebx),%eax
80103bcf:	c7 40 40 00 02 00 00 	movl   $0x200,0x40(%eax)
  p->tf->esp = PGSIZE;
80103bd6:	8b 43 18             	mov    0x18(%ebx),%eax
80103bd9:	c7 40 44 00 10 00 00 	movl   $0x1000,0x44(%eax)
  p->tf->eip = 0; // beginning of initcode.S
80103be0:	8b 43 18             	mov    0x18(%ebx),%eax
80103be3:	c7 40 38 00 00 00 00 	movl   $0x0,0x38(%eax)
  safestrcpy(p->name, "initcode", sizeof(p->name));
80103bea:	8d 43 6c             	lea    0x6c(%ebx),%eax
80103bed:	6a 10                	push   $0x10
80103bef:	68 85 85 10 80       	push   $0x80108585
80103bf4:	50                   	push   %eax
80103bf5:	e8 f6 19 00 00       	call   801055f0 <safestrcpy>
  p->cwd = namei("/");
80103bfa:	c7 04 24 8e 85 10 80 	movl   $0x8010858e,(%esp)
80103c01:	e8 da e2 ff ff       	call   80101ee0 <namei>
80103c06:	89 43 68             	mov    %eax,0x68(%ebx)
  acquire(&ptable.lock);
80103c09:	c7 04 24 80 41 11 80 	movl   $0x80114180,(%esp)
80103c10:	e8 eb 16 00 00       	call   80105300 <acquire>
  p->start=ticks;
80103c15:	a1 00 86 11 80       	mov    0x80118600,%eax
  p->state = RUNNABLE;
80103c1a:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  p->start=ticks;
80103c21:	89 83 9c 00 00 00    	mov    %eax,0x9c(%ebx)
  release(&ptable.lock);
80103c27:	c7 04 24 80 41 11 80 	movl   $0x80114180,(%esp)
80103c2e:	e8 8d 17 00 00       	call   801053c0 <release>
}
80103c33:	83 c4 10             	add    $0x10,%esp
80103c36:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103c39:	c9                   	leave  
80103c3a:	c3                   	ret    
    panic("userinit: out of memory?");
80103c3b:	83 ec 0c             	sub    $0xc,%esp
80103c3e:	68 6c 85 10 80       	push   $0x8010856c
80103c43:	e8 48 c7 ff ff       	call   80100390 <panic>
80103c48:	90                   	nop
80103c49:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103c50 <growproc>:
{
80103c50:	55                   	push   %ebp
80103c51:	89 e5                	mov    %esp,%ebp
80103c53:	56                   	push   %esi
80103c54:	53                   	push   %ebx
80103c55:	8b 75 08             	mov    0x8(%ebp),%esi
  pushcli();
80103c58:	e8 d3 15 00 00       	call   80105230 <pushcli>
  c = mycpu();
80103c5d:	e8 9e fb ff ff       	call   80103800 <mycpu>
  p = c->proc;
80103c62:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103c68:	e8 03 16 00 00       	call   80105270 <popcli>
  if (n > 0)
80103c6d:	83 fe 00             	cmp    $0x0,%esi
  sz = curproc->sz;
80103c70:	8b 03                	mov    (%ebx),%eax
  if (n > 0)
80103c72:	7f 1c                	jg     80103c90 <growproc+0x40>
  else if (n < 0)
80103c74:	75 3a                	jne    80103cb0 <growproc+0x60>
  switchuvm(curproc);
80103c76:	83 ec 0c             	sub    $0xc,%esp
  curproc->sz = sz;
80103c79:	89 03                	mov    %eax,(%ebx)
  switchuvm(curproc);
80103c7b:	53                   	push   %ebx
80103c7c:	e8 af 3c 00 00       	call   80107930 <switchuvm>
  return 0;
80103c81:	83 c4 10             	add    $0x10,%esp
80103c84:	31 c0                	xor    %eax,%eax
}
80103c86:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103c89:	5b                   	pop    %ebx
80103c8a:	5e                   	pop    %esi
80103c8b:	5d                   	pop    %ebp
80103c8c:	c3                   	ret    
80103c8d:	8d 76 00             	lea    0x0(%esi),%esi
    if ((sz = allocuvm(curproc->pgdir, sz, sz + n)) == 0)
80103c90:	83 ec 04             	sub    $0x4,%esp
80103c93:	01 c6                	add    %eax,%esi
80103c95:	56                   	push   %esi
80103c96:	50                   	push   %eax
80103c97:	ff 73 04             	pushl  0x4(%ebx)
80103c9a:	e8 e1 3e 00 00       	call   80107b80 <allocuvm>
80103c9f:	83 c4 10             	add    $0x10,%esp
80103ca2:	85 c0                	test   %eax,%eax
80103ca4:	75 d0                	jne    80103c76 <growproc+0x26>
      return -1;
80103ca6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103cab:	eb d9                	jmp    80103c86 <growproc+0x36>
80103cad:	8d 76 00             	lea    0x0(%esi),%esi
    if ((sz = deallocuvm(curproc->pgdir, sz, sz + n)) == 0)
80103cb0:	83 ec 04             	sub    $0x4,%esp
80103cb3:	01 c6                	add    %eax,%esi
80103cb5:	56                   	push   %esi
80103cb6:	50                   	push   %eax
80103cb7:	ff 73 04             	pushl  0x4(%ebx)
80103cba:	e8 f1 3f 00 00       	call   80107cb0 <deallocuvm>
80103cbf:	83 c4 10             	add    $0x10,%esp
80103cc2:	85 c0                	test   %eax,%eax
80103cc4:	75 b0                	jne    80103c76 <growproc+0x26>
80103cc6:	eb de                	jmp    80103ca6 <growproc+0x56>
80103cc8:	90                   	nop
80103cc9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103cd0 <fork>:
{
80103cd0:	55                   	push   %ebp
80103cd1:	89 e5                	mov    %esp,%ebp
80103cd3:	57                   	push   %edi
80103cd4:	56                   	push   %esi
80103cd5:	53                   	push   %ebx
80103cd6:	83 ec 1c             	sub    $0x1c,%esp
  pushcli();
80103cd9:	e8 52 15 00 00       	call   80105230 <pushcli>
  c = mycpu();
80103cde:	e8 1d fb ff ff       	call   80103800 <mycpu>
  p = c->proc;
80103ce3:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103ce9:	e8 82 15 00 00       	call   80105270 <popcli>
  if ((np = allocproc()) == 0)
80103cee:	e8 0d f9 ff ff       	call   80103600 <allocproc>
80103cf3:	85 c0                	test   %eax,%eax
80103cf5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80103cf8:	0f 84 c2 00 00 00    	je     80103dc0 <fork+0xf0>
  if ((np->pgdir = copyuvm(curproc->pgdir, curproc->sz)) == 0)
80103cfe:	83 ec 08             	sub    $0x8,%esp
80103d01:	ff 33                	pushl  (%ebx)
80103d03:	ff 73 04             	pushl  0x4(%ebx)
80103d06:	89 c7                	mov    %eax,%edi
80103d08:	e8 23 41 00 00       	call   80107e30 <copyuvm>
80103d0d:	83 c4 10             	add    $0x10,%esp
80103d10:	85 c0                	test   %eax,%eax
80103d12:	89 47 04             	mov    %eax,0x4(%edi)
80103d15:	0f 84 ac 00 00 00    	je     80103dc7 <fork+0xf7>
  np->sz = curproc->sz;
80103d1b:	8b 03                	mov    (%ebx),%eax
80103d1d:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80103d20:	89 01                	mov    %eax,(%ecx)
  np->parent = curproc;
80103d22:	89 59 14             	mov    %ebx,0x14(%ecx)
80103d25:	89 c8                	mov    %ecx,%eax
  *np->tf = *curproc->tf;
80103d27:	8b 79 18             	mov    0x18(%ecx),%edi
80103d2a:	8b 73 18             	mov    0x18(%ebx),%esi
80103d2d:	b9 13 00 00 00       	mov    $0x13,%ecx
80103d32:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  for (i = 0; i < NOFILE; i++)
80103d34:	31 f6                	xor    %esi,%esi
  np->tf->eax = 0;
80103d36:	8b 40 18             	mov    0x18(%eax),%eax
80103d39:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
    if (curproc->ofile[i])
80103d40:	8b 44 b3 28          	mov    0x28(%ebx,%esi,4),%eax
80103d44:	85 c0                	test   %eax,%eax
80103d46:	74 13                	je     80103d5b <fork+0x8b>
      np->ofile[i] = filedup(curproc->ofile[i]);
80103d48:	83 ec 0c             	sub    $0xc,%esp
80103d4b:	50                   	push   %eax
80103d4c:	e8 9f d0 ff ff       	call   80100df0 <filedup>
80103d51:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80103d54:	83 c4 10             	add    $0x10,%esp
80103d57:	89 44 b2 28          	mov    %eax,0x28(%edx,%esi,4)
  for (i = 0; i < NOFILE; i++)
80103d5b:	83 c6 01             	add    $0x1,%esi
80103d5e:	83 fe 10             	cmp    $0x10,%esi
80103d61:	75 dd                	jne    80103d40 <fork+0x70>
  np->cwd = idup(curproc->cwd);
80103d63:	83 ec 0c             	sub    $0xc,%esp
80103d66:	ff 73 68             	pushl  0x68(%ebx)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103d69:	83 c3 6c             	add    $0x6c,%ebx
  np->cwd = idup(curproc->cwd);
80103d6c:	e8 df d8 ff ff       	call   80101650 <idup>
80103d71:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103d74:	83 c4 0c             	add    $0xc,%esp
  np->cwd = idup(curproc->cwd);
80103d77:	89 47 68             	mov    %eax,0x68(%edi)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103d7a:	8d 47 6c             	lea    0x6c(%edi),%eax
80103d7d:	6a 10                	push   $0x10
80103d7f:	53                   	push   %ebx
80103d80:	50                   	push   %eax
80103d81:	e8 6a 18 00 00       	call   801055f0 <safestrcpy>
  pid = np->pid;
80103d86:	8b 5f 10             	mov    0x10(%edi),%ebx
  acquire(&ptable.lock);
80103d89:	c7 04 24 80 41 11 80 	movl   $0x80114180,(%esp)
80103d90:	e8 6b 15 00 00       	call   80105300 <acquire>
  np->start=ticks;
80103d95:	a1 00 86 11 80       	mov    0x80118600,%eax
  np->state = RUNNABLE;
80103d9a:	c7 47 0c 03 00 00 00 	movl   $0x3,0xc(%edi)
  np->start=ticks;
80103da1:	89 87 9c 00 00 00    	mov    %eax,0x9c(%edi)
  release(&ptable.lock);
80103da7:	c7 04 24 80 41 11 80 	movl   $0x80114180,(%esp)
80103dae:	e8 0d 16 00 00       	call   801053c0 <release>
  return pid;
80103db3:	83 c4 10             	add    $0x10,%esp
}
80103db6:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103db9:	89 d8                	mov    %ebx,%eax
80103dbb:	5b                   	pop    %ebx
80103dbc:	5e                   	pop    %esi
80103dbd:	5f                   	pop    %edi
80103dbe:	5d                   	pop    %ebp
80103dbf:	c3                   	ret    
    return -1;
80103dc0:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80103dc5:	eb ef                	jmp    80103db6 <fork+0xe6>
    kfree(np->kstack);
80103dc7:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80103dca:	83 ec 0c             	sub    $0xc,%esp
    return -1;
80103dcd:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
    kfree(np->kstack);
80103dd2:	ff 77 08             	pushl  0x8(%edi)
80103dd5:	e8 36 e5 ff ff       	call   80102310 <kfree>
    np->kstack = 0;
80103dda:	c7 47 08 00 00 00 00 	movl   $0x0,0x8(%edi)
    np->state = UNUSED;
80103de1:	c7 47 0c 00 00 00 00 	movl   $0x0,0xc(%edi)
    return -1;
80103de8:	83 c4 10             	add    $0x10,%esp
80103deb:	eb c9                	jmp    80103db6 <fork+0xe6>
80103ded:	8d 76 00             	lea    0x0(%esi),%esi

80103df0 <ageing>:
  for(i=0; i<c1+1; i++)
80103df0:	8b 0d 14 b0 10 80    	mov    0x8010b014,%ecx
{
80103df6:	55                   	push   %ebp
80103df7:	89 e5                	mov    %esp,%ebp
80103df9:	53                   	push   %ebx
  for(i=0; i<c1+1; i++)
80103dfa:	85 c9                	test   %ecx,%ecx
80103dfc:	0f 88 a9 00 00 00    	js     80103eab <ageing+0xbb>
80103e02:	31 db                	xor    %ebx,%ebx
80103e04:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(queue1[i]->state!=RUNNABLE)
80103e08:	8b 04 9d 80 40 11 80 	mov    -0x7feebf80(,%ebx,4),%eax
80103e0f:	83 78 0c 03          	cmpl   $0x3,0xc(%eax)
80103e13:	0f 85 83 00 00 00    	jne    80103e9c <ageing+0xac>
    if(ticks-queue1[i]->start <= queue1[i]->waittime)
80103e19:	8b 15 00 86 11 80    	mov    0x80118600,%edx
80103e1f:	89 d1                	mov    %edx,%ecx
80103e21:	2b 88 9c 00 00 00    	sub    0x9c(%eax),%ecx
80103e27:	3b 88 a0 00 00 00    	cmp    0xa0(%eax),%ecx
80103e2d:	76 6d                	jbe    80103e9c <ageing+0xac>
    queue1[0]->waittime=0;
80103e2f:	a1 80 40 11 80       	mov    0x80114080,%eax
80103e34:	c7 80 a0 00 00 00 00 	movl   $0x0,0xa0(%eax)
80103e3b:	00 00 00 
    queue1[i]->current_queue--;
80103e3e:	8b 04 9d 80 40 11 80 	mov    -0x7feebf80(,%ebx,4),%eax
80103e45:	83 a8 a4 00 00 00 01 	subl   $0x1,0xa4(%eax)
    queue1[i]->ticks[queue1[i]->current_queue]=0;
80103e4c:	8b 04 9d 80 40 11 80 	mov    -0x7feebf80(,%ebx,4),%eax
80103e53:	8b 88 a4 00 00 00    	mov    0xa4(%eax),%ecx
80103e59:	c7 84 88 d4 00 00 00 	movl   $0x0,0xd4(%eax,%ecx,4)
80103e60:	00 00 00 00 
    queue1[i]->start=ticks;
80103e64:	8b 0c 9d 80 40 11 80 	mov    -0x7feebf80(,%ebx,4),%ecx
    c0 = c0 + 1;
80103e6b:	a1 18 b0 10 80       	mov    0x8010b018,%eax
    queue1[i]->start=ticks;
80103e70:	89 91 9c 00 00 00    	mov    %edx,0x9c(%ecx)
    queue0[c0] = queue1[i];
80103e76:	8b 14 9d 80 40 11 80 	mov    -0x7feebf80(,%ebx,4),%edx
    c0 = c0 + 1;
80103e7d:	83 c0 01             	add    $0x1,%eax
80103e80:	a3 18 b0 10 80       	mov    %eax,0x8010b018
    queue0[c0] = queue1[i];
80103e85:	89 14 85 c0 7c 11 80 	mov    %edx,-0x7fee8340(,%eax,4)
    rem_process(queue1[i]->pid, queue1[i]->current_queue);
80103e8c:	ff b2 a4 00 00 00    	pushl  0xa4(%edx)
80103e92:	ff 72 10             	pushl  0x10(%edx)
80103e95:	e8 36 fa ff ff       	call   801038d0 <rem_process>
80103e9a:	58                   	pop    %eax
80103e9b:	5a                   	pop    %edx
  for(i=0; i<c1+1; i++)
80103e9c:	83 c3 01             	add    $0x1,%ebx
80103e9f:	39 1d 14 b0 10 80    	cmp    %ebx,0x8010b014
80103ea5:	0f 8d 5d ff ff ff    	jge    80103e08 <ageing+0x18>
  for(i=0; i<c2+1; i++)
80103eab:	8b 0d 10 b0 10 80    	mov    0x8010b010,%ecx
80103eb1:	85 c9                	test   %ecx,%ecx
80103eb3:	0f 88 ac 00 00 00    	js     80103f65 <ageing+0x175>
80103eb9:	31 db                	xor    %ebx,%ebx
80103ebb:	90                   	nop
80103ebc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(queue2[i]->state!=RUNNABLE)
80103ec0:	8b 04 9d 80 3e 11 80 	mov    -0x7feec180(,%ebx,4),%eax
80103ec7:	83 78 0c 03          	cmpl   $0x3,0xc(%eax)
80103ecb:	0f 85 85 00 00 00    	jne    80103f56 <ageing+0x166>
    if(ticks-queue2[i]->start <= queue2[i]->waittime)
80103ed1:	8b 15 00 86 11 80    	mov    0x80118600,%edx
80103ed7:	89 d1                	mov    %edx,%ecx
80103ed9:	2b 88 9c 00 00 00    	sub    0x9c(%eax),%ecx
80103edf:	3b 88 a0 00 00 00    	cmp    0xa0(%eax),%ecx
80103ee5:	76 6f                	jbe    80103f56 <ageing+0x166>
    queue1[i]->waittime=0;
80103ee7:	8b 04 9d 80 40 11 80 	mov    -0x7feebf80(,%ebx,4),%eax
80103eee:	c7 80 a0 00 00 00 00 	movl   $0x0,0xa0(%eax)
80103ef5:	00 00 00 
    queue2[i]->current_queue--;
80103ef8:	8b 04 9d 80 3e 11 80 	mov    -0x7feec180(,%ebx,4),%eax
80103eff:	83 a8 a4 00 00 00 01 	subl   $0x1,0xa4(%eax)
    queue2[i]->ticks[queue2[i]->current_queue]=0;
80103f06:	8b 04 9d 80 3e 11 80 	mov    -0x7feec180(,%ebx,4),%eax
80103f0d:	8b 88 a4 00 00 00    	mov    0xa4(%eax),%ecx
80103f13:	c7 84 88 d4 00 00 00 	movl   $0x0,0xd4(%eax,%ecx,4)
80103f1a:	00 00 00 00 
    queue2[i]->start=ticks;
80103f1e:	8b 0c 9d 80 3e 11 80 	mov    -0x7feec180(,%ebx,4),%ecx
    c1 = c1 + 1;
80103f25:	a1 14 b0 10 80       	mov    0x8010b014,%eax
    queue2[i]->start=ticks;
80103f2a:	89 91 9c 00 00 00    	mov    %edx,0x9c(%ecx)
    queue1[c1] = queue2[i];
80103f30:	8b 14 9d 80 3e 11 80 	mov    -0x7feec180(,%ebx,4),%edx
    c1 = c1 + 1;
80103f37:	83 c0 01             	add    $0x1,%eax
80103f3a:	a3 14 b0 10 80       	mov    %eax,0x8010b014
    queue1[c1] = queue2[i];
80103f3f:	89 14 85 80 40 11 80 	mov    %edx,-0x7feebf80(,%eax,4)
    rem_process(queue2[i]->pid, queue2[i]->current_queue);
80103f46:	ff b2 a4 00 00 00    	pushl  0xa4(%edx)
80103f4c:	ff 72 10             	pushl  0x10(%edx)
80103f4f:	e8 7c f9 ff ff       	call   801038d0 <rem_process>
80103f54:	58                   	pop    %eax
80103f55:	5a                   	pop    %edx
  for(i=0; i<c2+1; i++)
80103f56:	83 c3 01             	add    $0x1,%ebx
80103f59:	39 1d 10 b0 10 80    	cmp    %ebx,0x8010b010
80103f5f:	0f 8d 5b ff ff ff    	jge    80103ec0 <ageing+0xd0>
  for(i=0; i<c3+1; i++)
80103f65:	8b 0d 0c b0 10 80    	mov    0x8010b00c,%ecx
80103f6b:	85 c9                	test   %ecx,%ecx
80103f6d:	0f 88 aa 00 00 00    	js     8010401d <ageing+0x22d>
80103f73:	31 db                	xor    %ebx,%ebx
80103f75:	8d 76 00             	lea    0x0(%esi),%esi
    if(queue3[i]->state!=RUNNABLE)
80103f78:	8b 04 9d 80 3d 11 80 	mov    -0x7feec280(,%ebx,4),%eax
80103f7f:	83 78 0c 03          	cmpl   $0x3,0xc(%eax)
80103f83:	0f 85 85 00 00 00    	jne    8010400e <ageing+0x21e>
    if(ticks-queue3[i]->start <= queue3[i]->waittime)
80103f89:	8b 15 00 86 11 80    	mov    0x80118600,%edx
80103f8f:	89 d1                	mov    %edx,%ecx
80103f91:	2b 88 9c 00 00 00    	sub    0x9c(%eax),%ecx
80103f97:	3b 88 a0 00 00 00    	cmp    0xa0(%eax),%ecx
80103f9d:	76 6f                	jbe    8010400e <ageing+0x21e>
    queue2[i]->waittime=0;
80103f9f:	8b 04 9d 80 3e 11 80 	mov    -0x7feec180(,%ebx,4),%eax
80103fa6:	c7 80 a0 00 00 00 00 	movl   $0x0,0xa0(%eax)
80103fad:	00 00 00 
    queue3[i]->current_queue--;
80103fb0:	8b 04 9d 80 3d 11 80 	mov    -0x7feec280(,%ebx,4),%eax
80103fb7:	83 a8 a4 00 00 00 01 	subl   $0x1,0xa4(%eax)
    queue3[i]->ticks[queue3[i]->current_queue]=0;
80103fbe:	8b 04 9d 80 3d 11 80 	mov    -0x7feec280(,%ebx,4),%eax
80103fc5:	8b 88 a4 00 00 00    	mov    0xa4(%eax),%ecx
80103fcb:	c7 84 88 d4 00 00 00 	movl   $0x0,0xd4(%eax,%ecx,4)
80103fd2:	00 00 00 00 
    queue3[i]->start=ticks;
80103fd6:	8b 0c 9d 80 3d 11 80 	mov    -0x7feec280(,%ebx,4),%ecx
    c2 = c2 + 1;
80103fdd:	a1 10 b0 10 80       	mov    0x8010b010,%eax
    queue3[i]->start=ticks;
80103fe2:	89 91 9c 00 00 00    	mov    %edx,0x9c(%ecx)
    queue2[c2] = queue3[i];
80103fe8:	8b 14 9d 80 3d 11 80 	mov    -0x7feec280(,%ebx,4),%edx
    c2 = c2 + 1;
80103fef:	83 c0 01             	add    $0x1,%eax
80103ff2:	a3 10 b0 10 80       	mov    %eax,0x8010b010
    queue2[c2] = queue3[i];
80103ff7:	89 14 85 80 3e 11 80 	mov    %edx,-0x7feec180(,%eax,4)
    rem_process(queue3[i]->pid, queue3[i]->current_queue);
80103ffe:	ff b2 a4 00 00 00    	pushl  0xa4(%edx)
80104004:	ff 72 10             	pushl  0x10(%edx)
80104007:	e8 c4 f8 ff ff       	call   801038d0 <rem_process>
8010400c:	58                   	pop    %eax
8010400d:	5a                   	pop    %edx
  for(i=0; i<c3+1; i++)
8010400e:	83 c3 01             	add    $0x1,%ebx
80104011:	39 1d 0c b0 10 80    	cmp    %ebx,0x8010b00c
80104017:	0f 8d 5b ff ff ff    	jge    80103f78 <ageing+0x188>
  for(i=0; i<c4+1; i++)
8010401d:	8b 0d 08 b0 10 80    	mov    0x8010b008,%ecx
80104023:	85 c9                	test   %ecx,%ecx
80104025:	0f 88 aa 00 00 00    	js     801040d5 <ageing+0x2e5>
8010402b:	31 db                	xor    %ebx,%ebx
8010402d:	8d 76 00             	lea    0x0(%esi),%esi
    if(queue4[i]->state!=RUNNABLE)
80104030:	8b 04 9d 80 3f 11 80 	mov    -0x7feec080(,%ebx,4),%eax
80104037:	83 78 0c 03          	cmpl   $0x3,0xc(%eax)
8010403b:	0f 85 85 00 00 00    	jne    801040c6 <ageing+0x2d6>
    if(ticks-queue4[i]->start <= queue4[i]->waittime)
80104041:	8b 15 00 86 11 80    	mov    0x80118600,%edx
80104047:	89 d1                	mov    %edx,%ecx
80104049:	2b 88 9c 00 00 00    	sub    0x9c(%eax),%ecx
8010404f:	3b 88 a0 00 00 00    	cmp    0xa0(%eax),%ecx
80104055:	76 6f                	jbe    801040c6 <ageing+0x2d6>
    queue3[i]->waittime=0;
80104057:	8b 04 9d 80 3d 11 80 	mov    -0x7feec280(,%ebx,4),%eax
8010405e:	c7 80 a0 00 00 00 00 	movl   $0x0,0xa0(%eax)
80104065:	00 00 00 
    queue4[i]->current_queue--;
80104068:	8b 04 9d 80 3f 11 80 	mov    -0x7feec080(,%ebx,4),%eax
8010406f:	83 a8 a4 00 00 00 01 	subl   $0x1,0xa4(%eax)
    queue4[i]->ticks[queue4[i]->current_queue]=0;
80104076:	8b 04 9d 80 3f 11 80 	mov    -0x7feec080(,%ebx,4),%eax
8010407d:	8b 88 a4 00 00 00    	mov    0xa4(%eax),%ecx
80104083:	c7 84 88 d4 00 00 00 	movl   $0x0,0xd4(%eax,%ecx,4)
8010408a:	00 00 00 00 
    queue4[i]->start=ticks;
8010408e:	8b 0c 9d 80 3f 11 80 	mov    -0x7feec080(,%ebx,4),%ecx
    c3 = c3 + 1;
80104095:	a1 0c b0 10 80       	mov    0x8010b00c,%eax
    queue4[i]->start=ticks;
8010409a:	89 91 9c 00 00 00    	mov    %edx,0x9c(%ecx)
    queue3[c3] = queue4[i];
801040a0:	8b 14 9d 80 3f 11 80 	mov    -0x7feec080(,%ebx,4),%edx
    c3 = c3 + 1;
801040a7:	83 c0 01             	add    $0x1,%eax
801040aa:	a3 0c b0 10 80       	mov    %eax,0x8010b00c
    queue3[c3] = queue4[i];
801040af:	89 14 85 80 3d 11 80 	mov    %edx,-0x7feec280(,%eax,4)
    rem_process(queue4[i]->pid, queue4[i]->current_queue);
801040b6:	ff b2 a4 00 00 00    	pushl  0xa4(%edx)
801040bc:	ff 72 10             	pushl  0x10(%edx)
801040bf:	e8 0c f8 ff ff       	call   801038d0 <rem_process>
801040c4:	58                   	pop    %eax
801040c5:	5a                   	pop    %edx
  for(i=0; i<c4+1; i++)
801040c6:	83 c3 01             	add    $0x1,%ebx
801040c9:	39 1d 08 b0 10 80    	cmp    %ebx,0x8010b008
801040cf:	0f 8d 5b ff ff ff    	jge    80104030 <ageing+0x240>
}
801040d5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801040d8:	c9                   	leave  
801040d9:	c3                   	ret    
801040da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801040e0 <scheduler>:
{
801040e0:	55                   	push   %ebp
801040e1:	89 e5                	mov    %esp,%ebp
801040e3:	57                   	push   %edi
801040e4:	56                   	push   %esi
801040e5:	53                   	push   %ebx
801040e6:	83 ec 1c             	sub    $0x1c,%esp
  struct cpu *c = mycpu();
801040e9:	e8 12 f7 ff ff       	call   80103800 <mycpu>
  c->proc = 0;
801040ee:	c7 80 ac 00 00 00 00 	movl   $0x0,0xac(%eax)
801040f5:	00 00 00 
  struct cpu *c = mycpu();
801040f8:	89 c3                	mov    %eax,%ebx
801040fa:	8d 40 04             	lea    0x4(%eax),%eax
801040fd:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  asm volatile("sti");
80104100:	fb                   	sti    
    acquire(&ptable.lock);
80104101:	83 ec 0c             	sub    $0xc,%esp
80104104:	68 80 41 11 80       	push   $0x80114180
80104109:	e8 f2 11 00 00       	call   80105300 <acquire>
    ageing();
8010410e:	e8 dd fc ff ff       	call   80103df0 <ageing>
    if (c0 != -1) // ENTERING QUEUE 0
80104113:	8b 0d 18 b0 10 80    	mov    0x8010b018,%ecx
80104119:	83 c4 10             	add    $0x10,%esp
8010411c:	85 c9                	test   %ecx,%ecx
8010411e:	0f 88 ec 00 00 00    	js     80104210 <scheduler+0x130>
      for (i = 0; i < c0+1; i++)
80104124:	31 f6                	xor    %esi,%esi
80104126:	eb 13                	jmp    8010413b <scheduler+0x5b>
80104128:	90                   	nop
80104129:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104130:	83 c6 01             	add    $0x1,%esi
80104133:	39 f2                	cmp    %esi,%edx
80104135:	0f 8c d5 00 00 00    	jl     80104210 <scheduler+0x130>
        if (queue0[i]->state != RUNNABLE)
8010413b:	8b 04 b5 c0 7c 11 80 	mov    -0x7fee8340(,%esi,4),%eax
80104142:	8b 15 18 b0 10 80    	mov    0x8010b018,%edx
80104148:	83 78 0c 03          	cmpl   $0x3,0xc(%eax)
8010414c:	75 e2                	jne    80104130 <scheduler+0x50>
        queue0[i]->start=ticks;
8010414e:	8b 15 00 86 11 80    	mov    0x80118600,%edx
        switchuvm(m_proc);
80104154:	83 ec 0c             	sub    $0xc,%esp
        queue0[i]->start=ticks;
80104157:	89 90 9c 00 00 00    	mov    %edx,0x9c(%eax)
        m_proc = queue0[i];
8010415d:	8b 3c b5 c0 7c 11 80 	mov    -0x7fee8340(,%esi,4),%edi
        c->proc = m_proc;
80104164:	89 bb ac 00 00 00    	mov    %edi,0xac(%ebx)
        switchuvm(m_proc);
8010416a:	57                   	push   %edi
8010416b:	e8 c0 37 00 00       	call   80107930 <switchuvm>
        m_proc->num_r++;
80104170:	83 87 8c 00 00 00 01 	addl   $0x1,0x8c(%edi)
        m_proc->state = RUNNING;
80104177:	c7 47 0c 04 00 00 00 	movl   $0x4,0xc(%edi)
        swtch((&c->scheduler), m_proc->context);
8010417e:	58                   	pop    %eax
8010417f:	5a                   	pop    %edx
80104180:	ff 77 1c             	pushl  0x1c(%edi)
80104183:	ff 75 e4             	pushl  -0x1c(%ebp)
80104186:	e8 c0 14 00 00       	call   8010564b <swtch>
        switchkvm();
8010418b:	e8 80 37 00 00       	call   80107910 <switchkvm>
        c->proc = 0;
80104190:	c7 83 ac 00 00 00 00 	movl   $0x0,0xac(%ebx)
80104197:	00 00 00 
        if (m_proc->ticks[0] >= clockperiod[0] || m_proc->killed!=0)
8010419a:	83 c4 10             	add    $0x10,%esp
8010419d:	a1 1c b0 10 80       	mov    0x8010b01c,%eax
801041a2:	39 87 d4 00 00 00    	cmp    %eax,0xd4(%edi)
801041a8:	8b 15 18 b0 10 80    	mov    0x8010b018,%edx
801041ae:	0f 8d e4 04 00 00    	jge    80104698 <scheduler+0x5b8>
801041b4:	8b 47 24             	mov    0x24(%edi),%eax
801041b7:	85 c0                	test   %eax,%eax
801041b9:	0f 84 71 ff ff ff    	je     80104130 <scheduler+0x50>
          while(j<c0)
801041bf:	39 f2                	cmp    %esi,%edx
801041c1:	7e 25                	jle    801041e8 <scheduler+0x108>
801041c3:	8d 04 b5 c0 7c 11 80 	lea    -0x7fee8340(,%esi,4),%eax
801041ca:	8d 0c 95 c0 7c 11 80 	lea    -0x7fee8340(,%edx,4),%ecx
801041d1:	89 55 e0             	mov    %edx,-0x20(%ebp)
801041d4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
            queue0[j] = queue0[j + 1];
801041d8:	8b 50 04             	mov    0x4(%eax),%edx
801041db:	83 c0 04             	add    $0x4,%eax
801041de:	89 50 fc             	mov    %edx,-0x4(%eax)
          while(j<c0)
801041e1:	39 c8                	cmp    %ecx,%eax
801041e3:	75 f3                	jne    801041d8 <scheduler+0xf8>
801041e5:	8b 55 e0             	mov    -0x20(%ebp),%edx
          c0--;
801041e8:	83 ea 01             	sub    $0x1,%edx
      for (i = 0; i < c0+1; i++)
801041eb:	83 c6 01             	add    $0x1,%esi
          m_proc->ticks[0] = 0;
801041ee:	c7 87 d4 00 00 00 00 	movl   $0x0,0xd4(%edi)
801041f5:	00 00 00 
      for (i = 0; i < c0+1; i++)
801041f8:	39 f2                	cmp    %esi,%edx
          c0--;
801041fa:	89 15 18 b0 10 80    	mov    %edx,0x8010b018
      for (i = 0; i < c0+1; i++)
80104200:	0f 8d 35 ff ff ff    	jge    8010413b <scheduler+0x5b>
80104206:	8d 76 00             	lea    0x0(%esi),%esi
80104209:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    if (c1 != -1) //ENTERING QUEUE 1
80104210:	8b 0d 14 b0 10 80    	mov    0x8010b014,%ecx
80104216:	85 c9                	test   %ecx,%ecx
80104218:	0f 88 e2 00 00 00    	js     80104300 <scheduler+0x220>
      for (i = 0; i < c1+1; i++)
8010421e:	31 f6                	xor    %esi,%esi
80104220:	eb 11                	jmp    80104233 <scheduler+0x153>
80104222:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104228:	83 c6 01             	add    $0x1,%esi
8010422b:	39 f2                	cmp    %esi,%edx
8010422d:	0f 8c cd 00 00 00    	jl     80104300 <scheduler+0x220>
        if (queue1[i]->state != RUNNABLE)
80104233:	8b 04 b5 80 40 11 80 	mov    -0x7feebf80(,%esi,4),%eax
8010423a:	8b 15 14 b0 10 80    	mov    0x8010b014,%edx
80104240:	83 78 0c 03          	cmpl   $0x3,0xc(%eax)
80104244:	75 e2                	jne    80104228 <scheduler+0x148>
        queue1[i]->start=ticks;
80104246:	8b 15 00 86 11 80    	mov    0x80118600,%edx
        switchuvm(m_proc);
8010424c:	83 ec 0c             	sub    $0xc,%esp
        queue1[i]->start=ticks;
8010424f:	89 90 9c 00 00 00    	mov    %edx,0x9c(%eax)
        m_proc = queue1[i];
80104255:	8b 3c b5 80 40 11 80 	mov    -0x7feebf80(,%esi,4),%edi
        c->proc = m_proc;
8010425c:	89 bb ac 00 00 00    	mov    %edi,0xac(%ebx)
        switchuvm(m_proc);
80104262:	57                   	push   %edi
80104263:	e8 c8 36 00 00       	call   80107930 <switchuvm>
        m_proc->num_r++;
80104268:	83 87 8c 00 00 00 01 	addl   $0x1,0x8c(%edi)
        m_proc->state = RUNNING;
8010426f:	c7 47 0c 04 00 00 00 	movl   $0x4,0xc(%edi)
        swtch(&c->scheduler, m_proc->context);
80104276:	58                   	pop    %eax
80104277:	5a                   	pop    %edx
80104278:	ff 77 1c             	pushl  0x1c(%edi)
8010427b:	ff 75 e4             	pushl  -0x1c(%ebp)
8010427e:	e8 c8 13 00 00       	call   8010564b <swtch>
        switchkvm();
80104283:	e8 88 36 00 00       	call   80107910 <switchkvm>
        c->proc = 0;
80104288:	c7 83 ac 00 00 00 00 	movl   $0x0,0xac(%ebx)
8010428f:	00 00 00 
        if (m_proc->ticks[1] >= clockperiod[1] || m_proc->killed!=0)
80104292:	83 c4 10             	add    $0x10,%esp
80104295:	a1 20 b0 10 80       	mov    0x8010b020,%eax
8010429a:	39 87 d8 00 00 00    	cmp    %eax,0xd8(%edi)
801042a0:	8b 15 14 b0 10 80    	mov    0x8010b014,%edx
801042a6:	0f 8d bc 03 00 00    	jge    80104668 <scheduler+0x588>
801042ac:	8b 47 24             	mov    0x24(%edi),%eax
801042af:	85 c0                	test   %eax,%eax
801042b1:	0f 84 71 ff ff ff    	je     80104228 <scheduler+0x148>
          while(j<c1)
801042b7:	39 f2                	cmp    %esi,%edx
801042b9:	7e 25                	jle    801042e0 <scheduler+0x200>
801042bb:	8d 04 b5 80 40 11 80 	lea    -0x7feebf80(,%esi,4),%eax
801042c2:	8d 0c 95 80 40 11 80 	lea    -0x7feebf80(,%edx,4),%ecx
801042c9:	89 55 e0             	mov    %edx,-0x20(%ebp)
801042cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
            queue1[j] = queue1[j + 1];
801042d0:	8b 50 04             	mov    0x4(%eax),%edx
801042d3:	83 c0 04             	add    $0x4,%eax
801042d6:	89 50 fc             	mov    %edx,-0x4(%eax)
          while(j<c1)
801042d9:	39 c8                	cmp    %ecx,%eax
801042db:	75 f3                	jne    801042d0 <scheduler+0x1f0>
801042dd:	8b 55 e0             	mov    -0x20(%ebp),%edx
          c1--;
801042e0:	83 ea 01             	sub    $0x1,%edx
      for (i = 0; i < c1+1; i++)
801042e3:	83 c6 01             	add    $0x1,%esi
          m_proc->ticks[1] = 0;
801042e6:	c7 87 d8 00 00 00 00 	movl   $0x0,0xd8(%edi)
801042ed:	00 00 00 
      for (i = 0; i < c1+1; i++)
801042f0:	39 f2                	cmp    %esi,%edx
          c1--;
801042f2:	89 15 14 b0 10 80    	mov    %edx,0x8010b014
      for (i = 0; i < c1+1; i++)
801042f8:	0f 8d 35 ff ff ff    	jge    80104233 <scheduler+0x153>
801042fe:	66 90                	xchg   %ax,%ax
    if (c2 != -1)
80104300:	8b 0d 10 b0 10 80    	mov    0x8010b010,%ecx
80104306:	85 c9                	test   %ecx,%ecx
80104308:	0f 88 e2 00 00 00    	js     801043f0 <scheduler+0x310>
      for (i = 0; i < c2+1; i++)
8010430e:	31 f6                	xor    %esi,%esi
80104310:	eb 11                	jmp    80104323 <scheduler+0x243>
80104312:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104318:	83 c6 01             	add    $0x1,%esi
8010431b:	39 d6                	cmp    %edx,%esi
8010431d:	0f 8f cd 00 00 00    	jg     801043f0 <scheduler+0x310>
        if (queue2[i]->state != RUNNABLE)
80104323:	8b 04 b5 80 3e 11 80 	mov    -0x7feec180(,%esi,4),%eax
8010432a:	8b 15 10 b0 10 80    	mov    0x8010b010,%edx
80104330:	83 78 0c 03          	cmpl   $0x3,0xc(%eax)
80104334:	75 e2                	jne    80104318 <scheduler+0x238>
        queue2[i]->start=ticks;
80104336:	8b 15 00 86 11 80    	mov    0x80118600,%edx
        switchuvm(m_proc);
8010433c:	83 ec 0c             	sub    $0xc,%esp
        queue2[i]->start=ticks;
8010433f:	89 90 9c 00 00 00    	mov    %edx,0x9c(%eax)
        m_proc = queue2[i];
80104345:	8b 3c b5 80 3e 11 80 	mov    -0x7feec180(,%esi,4),%edi
        c->proc = m_proc;
8010434c:	89 bb ac 00 00 00    	mov    %edi,0xac(%ebx)
        switchuvm(m_proc);
80104352:	57                   	push   %edi
80104353:	e8 d8 35 00 00       	call   80107930 <switchuvm>
        m_proc->num_r++;
80104358:	83 87 8c 00 00 00 01 	addl   $0x1,0x8c(%edi)
        m_proc->state = RUNNING;
8010435f:	c7 47 0c 04 00 00 00 	movl   $0x4,0xc(%edi)
        swtch(&c->scheduler, m_proc->context);
80104366:	58                   	pop    %eax
80104367:	5a                   	pop    %edx
80104368:	ff 77 1c             	pushl  0x1c(%edi)
8010436b:	ff 75 e4             	pushl  -0x1c(%ebp)
8010436e:	e8 d8 12 00 00       	call   8010564b <swtch>
        switchkvm();
80104373:	e8 98 35 00 00       	call   80107910 <switchkvm>
        c->proc = 0;
80104378:	c7 83 ac 00 00 00 00 	movl   $0x0,0xac(%ebx)
8010437f:	00 00 00 
        if (m_proc->ticks[2] >= clockperiod[2]|| m_proc->killed!=0)
80104382:	83 c4 10             	add    $0x10,%esp
80104385:	a1 24 b0 10 80       	mov    0x8010b024,%eax
8010438a:	39 87 dc 00 00 00    	cmp    %eax,0xdc(%edi)
80104390:	8b 15 10 b0 10 80    	mov    0x8010b010,%edx
80104396:	0f 8d 9c 02 00 00    	jge    80104638 <scheduler+0x558>
8010439c:	8b 47 24             	mov    0x24(%edi),%eax
8010439f:	85 c0                	test   %eax,%eax
801043a1:	0f 84 71 ff ff ff    	je     80104318 <scheduler+0x238>
          while(j<c2)
801043a7:	39 f2                	cmp    %esi,%edx
801043a9:	7e 25                	jle    801043d0 <scheduler+0x2f0>
801043ab:	8d 04 b5 80 3e 11 80 	lea    -0x7feec180(,%esi,4),%eax
801043b2:	8d 0c 95 80 3e 11 80 	lea    -0x7feec180(,%edx,4),%ecx
801043b9:	89 55 e0             	mov    %edx,-0x20(%ebp)
801043bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
            queue2[j] = queue2[j + 1];
801043c0:	8b 50 04             	mov    0x4(%eax),%edx
801043c3:	83 c0 04             	add    $0x4,%eax
801043c6:	89 50 fc             	mov    %edx,-0x4(%eax)
          while(j<c2)
801043c9:	39 c8                	cmp    %ecx,%eax
801043cb:	75 f3                	jne    801043c0 <scheduler+0x2e0>
801043cd:	8b 55 e0             	mov    -0x20(%ebp),%edx
          c2--;
801043d0:	83 ea 01             	sub    $0x1,%edx
      for (i = 0; i < c2+1; i++)
801043d3:	83 c6 01             	add    $0x1,%esi
          m_proc->ticks[2] = 0;
801043d6:	c7 87 dc 00 00 00 00 	movl   $0x0,0xdc(%edi)
801043dd:	00 00 00 
      for (i = 0; i < c2+1; i++)
801043e0:	39 d6                	cmp    %edx,%esi
          c2--;
801043e2:	89 15 10 b0 10 80    	mov    %edx,0x8010b010
      for (i = 0; i < c2+1; i++)
801043e8:	0f 8e 35 ff ff ff    	jle    80104323 <scheduler+0x243>
801043ee:	66 90                	xchg   %ax,%ax
    if (c3 != -1)
801043f0:	8b 0d 0c b0 10 80    	mov    0x8010b00c,%ecx
801043f6:	85 c9                	test   %ecx,%ecx
801043f8:	0f 88 e2 00 00 00    	js     801044e0 <scheduler+0x400>
      for (i = 0; i < c3+1; i++)
801043fe:	31 f6                	xor    %esi,%esi
80104400:	eb 11                	jmp    80104413 <scheduler+0x333>
80104402:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104408:	83 c6 01             	add    $0x1,%esi
8010440b:	39 f2                	cmp    %esi,%edx
8010440d:	0f 8c cd 00 00 00    	jl     801044e0 <scheduler+0x400>
        if (queue3[i]->state != RUNNABLE)
80104413:	8b 04 b5 80 3d 11 80 	mov    -0x7feec280(,%esi,4),%eax
8010441a:	8b 15 0c b0 10 80    	mov    0x8010b00c,%edx
80104420:	83 78 0c 03          	cmpl   $0x3,0xc(%eax)
80104424:	75 e2                	jne    80104408 <scheduler+0x328>
        queue3[i]->start=ticks;
80104426:	8b 15 00 86 11 80    	mov    0x80118600,%edx
        switchuvm(m_proc);
8010442c:	83 ec 0c             	sub    $0xc,%esp
        queue3[i]->start=ticks;
8010442f:	89 90 9c 00 00 00    	mov    %edx,0x9c(%eax)
        m_proc = queue3[i];
80104435:	8b 3c b5 80 3d 11 80 	mov    -0x7feec280(,%esi,4),%edi
        c->proc = m_proc;
8010443c:	89 bb ac 00 00 00    	mov    %edi,0xac(%ebx)
        switchuvm(m_proc);
80104442:	57                   	push   %edi
80104443:	e8 e8 34 00 00       	call   80107930 <switchuvm>
        m_proc->num_r++;
80104448:	83 87 8c 00 00 00 01 	addl   $0x1,0x8c(%edi)
        m_proc->state = RUNNING;
8010444f:	c7 47 0c 04 00 00 00 	movl   $0x4,0xc(%edi)
        swtch(&c->scheduler, m_proc->context);
80104456:	58                   	pop    %eax
80104457:	5a                   	pop    %edx
80104458:	ff 77 1c             	pushl  0x1c(%edi)
8010445b:	ff 75 e4             	pushl  -0x1c(%ebp)
8010445e:	e8 e8 11 00 00       	call   8010564b <swtch>
        switchkvm();
80104463:	e8 a8 34 00 00       	call   80107910 <switchkvm>
        c->proc = 0;
80104468:	c7 83 ac 00 00 00 00 	movl   $0x0,0xac(%ebx)
8010446f:	00 00 00 
        if (m_proc->ticks[3] >= clockperiod[3] || m_proc->killed!=0)
80104472:	83 c4 10             	add    $0x10,%esp
80104475:	a1 28 b0 10 80       	mov    0x8010b028,%eax
8010447a:	39 87 e0 00 00 00    	cmp    %eax,0xe0(%edi)
80104480:	8b 15 0c b0 10 80    	mov    0x8010b00c,%edx
80104486:	0f 8d 7c 01 00 00    	jge    80104608 <scheduler+0x528>
8010448c:	8b 47 24             	mov    0x24(%edi),%eax
8010448f:	85 c0                	test   %eax,%eax
80104491:	0f 84 71 ff ff ff    	je     80104408 <scheduler+0x328>
          while(j<c3)
80104497:	39 f2                	cmp    %esi,%edx
80104499:	7e 25                	jle    801044c0 <scheduler+0x3e0>
8010449b:	8d 04 b5 80 3d 11 80 	lea    -0x7feec280(,%esi,4),%eax
801044a2:	8d 0c 95 80 3d 11 80 	lea    -0x7feec280(,%edx,4),%ecx
801044a9:	89 55 e0             	mov    %edx,-0x20(%ebp)
801044ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
            queue3[j] = queue3[j + 1];
801044b0:	8b 50 04             	mov    0x4(%eax),%edx
801044b3:	83 c0 04             	add    $0x4,%eax
801044b6:	89 50 fc             	mov    %edx,-0x4(%eax)
          while(j<c3)
801044b9:	39 c8                	cmp    %ecx,%eax
801044bb:	75 f3                	jne    801044b0 <scheduler+0x3d0>
801044bd:	8b 55 e0             	mov    -0x20(%ebp),%edx
          c3--;
801044c0:	83 ea 01             	sub    $0x1,%edx
      for (i = 0; i < c3+1; i++)
801044c3:	83 c6 01             	add    $0x1,%esi
          m_proc->ticks[3] = 0;
801044c6:	c7 87 e0 00 00 00 00 	movl   $0x0,0xe0(%edi)
801044cd:	00 00 00 
      for (i = 0; i < c3+1; i++)
801044d0:	39 f2                	cmp    %esi,%edx
          c3--;
801044d2:	89 15 0c b0 10 80    	mov    %edx,0x8010b00c
      for (i = 0; i < c3+1; i++)
801044d8:	0f 8d 35 ff ff ff    	jge    80104413 <scheduler+0x333>
801044de:	66 90                	xchg   %ax,%ax
    if (c4 != -1)
801044e0:	8b 35 08 b0 10 80    	mov    0x8010b008,%esi
801044e6:	85 f6                	test   %esi,%esi
801044e8:	0f 88 ca 00 00 00    	js     801045b8 <scheduler+0x4d8>
      for (i = 0; i < c4+1; i++)
801044ee:	31 f6                	xor    %esi,%esi
801044f0:	eb 11                	jmp    80104503 <scheduler+0x423>
801044f2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801044f8:	83 c6 01             	add    $0x1,%esi
801044fb:	39 f2                	cmp    %esi,%edx
801044fd:	0f 8c b5 00 00 00    	jl     801045b8 <scheduler+0x4d8>
        if (queue4[i]->state != RUNNABLE)
80104503:	8b 04 b5 80 3f 11 80 	mov    -0x7feec080(,%esi,4),%eax
8010450a:	8b 15 08 b0 10 80    	mov    0x8010b008,%edx
80104510:	83 78 0c 03          	cmpl   $0x3,0xc(%eax)
80104514:	75 e2                	jne    801044f8 <scheduler+0x418>
        queue4[i]->start=ticks;
80104516:	8b 15 00 86 11 80    	mov    0x80118600,%edx
        switchuvm(m_proc);
8010451c:	83 ec 0c             	sub    $0xc,%esp
        queue4[i]->start=ticks;
8010451f:	89 90 9c 00 00 00    	mov    %edx,0x9c(%eax)
        m_proc = queue4[i];
80104525:	8b 3c b5 80 3f 11 80 	mov    -0x7feec080(,%esi,4),%edi
        c->proc = m_proc;
8010452c:	89 bb ac 00 00 00    	mov    %edi,0xac(%ebx)
        switchuvm(m_proc);
80104532:	57                   	push   %edi
80104533:	e8 f8 33 00 00       	call   80107930 <switchuvm>
        m_proc->num_r++;
80104538:	83 87 8c 00 00 00 01 	addl   $0x1,0x8c(%edi)
        m_proc->state = RUNNING;
8010453f:	c7 47 0c 04 00 00 00 	movl   $0x4,0xc(%edi)
        swtch(&c->scheduler, m_proc->context);
80104546:	58                   	pop    %eax
80104547:	5a                   	pop    %edx
80104548:	ff 77 1c             	pushl  0x1c(%edi)
8010454b:	ff 75 e4             	pushl  -0x1c(%ebp)
8010454e:	e8 f8 10 00 00       	call   8010564b <swtch>
        switchkvm();
80104553:	e8 b8 33 00 00       	call   80107910 <switchkvm>
        c->proc = 0;
80104558:	c7 83 ac 00 00 00 00 	movl   $0x0,0xac(%ebx)
8010455f:	00 00 00 
        if(m_proc->killed!=0)
80104562:	8b 4f 24             	mov    0x24(%edi),%ecx
80104565:	83 c4 10             	add    $0x10,%esp
          for (j = i; j <= c4 - 1; j++)
80104568:	8b 15 08 b0 10 80    	mov    0x8010b008,%edx
        if(m_proc->killed!=0)
8010456e:	85 c9                	test   %ecx,%ecx
80104570:	75 5e                	jne    801045d0 <scheduler+0x4f0>
          while(j<c4)
80104572:	39 f2                	cmp    %esi,%edx
80104574:	7e 2a                	jle    801045a0 <scheduler+0x4c0>
80104576:	8d 04 b5 80 3f 11 80 	lea    -0x7feec080(,%esi,4),%eax
8010457d:	8d 0c 95 80 3f 11 80 	lea    -0x7feec080(,%edx,4),%ecx
80104584:	89 55 e0             	mov    %edx,-0x20(%ebp)
80104587:	89 f6                	mov    %esi,%esi
80104589:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
            queue4[j] = queue4[j + 1];
80104590:	8b 50 04             	mov    0x4(%eax),%edx
80104593:	83 c0 04             	add    $0x4,%eax
80104596:	89 50 fc             	mov    %edx,-0x4(%eax)
          while(j<c4)
80104599:	39 c1                	cmp    %eax,%ecx
8010459b:	75 f3                	jne    80104590 <scheduler+0x4b0>
8010459d:	8b 55 e0             	mov    -0x20(%ebp),%edx
      for (i = 0; i < c4+1; i++)
801045a0:	83 c6 01             	add    $0x1,%esi
          queue4[c4] = m_proc;
801045a3:	89 3c 95 80 3f 11 80 	mov    %edi,-0x7feec080(,%edx,4)
      for (i = 0; i < c4+1; i++)
801045aa:	39 f2                	cmp    %esi,%edx
801045ac:	0f 8d 51 ff ff ff    	jge    80104503 <scheduler+0x423>
801045b2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    release(&ptable.lock);
801045b8:	83 ec 0c             	sub    $0xc,%esp
801045bb:	68 80 41 11 80       	push   $0x80114180
801045c0:	e8 fb 0d 00 00       	call   801053c0 <release>
  {
801045c5:	83 c4 10             	add    $0x10,%esp
801045c8:	e9 33 fb ff ff       	jmp    80104100 <scheduler+0x20>
801045cd:	8d 76 00             	lea    0x0(%esi),%esi
          for (j = i; j <= c4 - 1; j++)
801045d0:	39 f2                	cmp    %esi,%edx
801045d2:	0f 8e 20 ff ff ff    	jle    801044f8 <scheduler+0x418>
801045d8:	8d 04 b5 80 3f 11 80 	lea    -0x7feec080(,%esi,4),%eax
801045df:	8d 3c 95 80 3f 11 80 	lea    -0x7feec080(,%edx,4),%edi
801045e6:	8d 76 00             	lea    0x0(%esi),%esi
801045e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
            queue4[j] = queue4[j + 1];
801045f0:	8b 48 04             	mov    0x4(%eax),%ecx
801045f3:	83 c0 04             	add    $0x4,%eax
801045f6:	89 48 fc             	mov    %ecx,-0x4(%eax)
          for (j = i; j <= c4 - 1; j++)
801045f9:	39 f8                	cmp    %edi,%eax
801045fb:	75 f3                	jne    801045f0 <scheduler+0x510>
801045fd:	e9 f6 fe ff ff       	jmp    801044f8 <scheduler+0x418>
80104602:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
          if (m_proc->killed == 0)
80104608:	8b 47 24             	mov    0x24(%edi),%eax
8010460b:	85 c0                	test   %eax,%eax
8010460d:	0f 85 84 fe ff ff    	jne    80104497 <scheduler+0x3b7>
            c4++;
80104613:	a1 08 b0 10 80       	mov    0x8010b008,%eax
            m_proc->current_queue++;
80104618:	83 87 a4 00 00 00 01 	addl   $0x1,0xa4(%edi)
            c4++;
8010461f:	83 c0 01             	add    $0x1,%eax
80104622:	a3 08 b0 10 80       	mov    %eax,0x8010b008
            queue4[c4] = m_proc;
80104627:	89 3c 85 80 3f 11 80 	mov    %edi,-0x7feec080(,%eax,4)
8010462e:	e9 64 fe ff ff       	jmp    80104497 <scheduler+0x3b7>
80104633:	90                   	nop
80104634:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
          if (m_proc->killed == 0)
80104638:	8b 47 24             	mov    0x24(%edi),%eax
8010463b:	85 c0                	test   %eax,%eax
8010463d:	0f 85 64 fd ff ff    	jne    801043a7 <scheduler+0x2c7>
            c3++;
80104643:	a1 0c b0 10 80       	mov    0x8010b00c,%eax
            m_proc->current_queue++;
80104648:	83 87 a4 00 00 00 01 	addl   $0x1,0xa4(%edi)
            c3++;
8010464f:	83 c0 01             	add    $0x1,%eax
80104652:	a3 0c b0 10 80       	mov    %eax,0x8010b00c
            queue3[c3] = m_proc;
80104657:	89 3c 85 80 3d 11 80 	mov    %edi,-0x7feec280(,%eax,4)
8010465e:	e9 44 fd ff ff       	jmp    801043a7 <scheduler+0x2c7>
80104663:	90                   	nop
80104664:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
          if (m_proc->killed == 0)
80104668:	8b 47 24             	mov    0x24(%edi),%eax
8010466b:	85 c0                	test   %eax,%eax
8010466d:	0f 85 44 fc ff ff    	jne    801042b7 <scheduler+0x1d7>
            c2++;
80104673:	a1 10 b0 10 80       	mov    0x8010b010,%eax
            m_proc->current_queue++;
80104678:	83 87 a4 00 00 00 01 	addl   $0x1,0xa4(%edi)
            c2++;
8010467f:	83 c0 01             	add    $0x1,%eax
80104682:	a3 10 b0 10 80       	mov    %eax,0x8010b010
            queue2[c2] = m_proc;
80104687:	89 3c 85 80 3e 11 80 	mov    %edi,-0x7feec180(,%eax,4)
8010468e:	e9 24 fc ff ff       	jmp    801042b7 <scheduler+0x1d7>
80104693:	90                   	nop
80104694:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
          if (m_proc->killed == 0)
80104698:	8b 47 24             	mov    0x24(%edi),%eax
8010469b:	85 c0                	test   %eax,%eax
8010469d:	0f 85 1c fb ff ff    	jne    801041bf <scheduler+0xdf>
            c1++;
801046a3:	a1 14 b0 10 80       	mov    0x8010b014,%eax
            m_proc->current_queue++;
801046a8:	83 87 a4 00 00 00 01 	addl   $0x1,0xa4(%edi)
            c1++;
801046af:	83 c0 01             	add    $0x1,%eax
801046b2:	a3 14 b0 10 80       	mov    %eax,0x8010b014
            queue1[c1] = m_proc;
801046b7:	89 3c 85 80 40 11 80 	mov    %edi,-0x7feebf80(,%eax,4)
801046be:	e9 fc fa ff ff       	jmp    801041bf <scheduler+0xdf>
801046c3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801046c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801046d0 <sched>:
{
801046d0:	55                   	push   %ebp
801046d1:	89 e5                	mov    %esp,%ebp
801046d3:	56                   	push   %esi
801046d4:	53                   	push   %ebx
  pushcli();
801046d5:	e8 56 0b 00 00       	call   80105230 <pushcli>
  c = mycpu();
801046da:	e8 21 f1 ff ff       	call   80103800 <mycpu>
  p = c->proc;
801046df:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
801046e5:	e8 86 0b 00 00       	call   80105270 <popcli>
  if (!holding(&ptable.lock))
801046ea:	83 ec 0c             	sub    $0xc,%esp
801046ed:	68 80 41 11 80       	push   $0x80114180
801046f2:	e8 d9 0b 00 00       	call   801052d0 <holding>
801046f7:	83 c4 10             	add    $0x10,%esp
801046fa:	85 c0                	test   %eax,%eax
801046fc:	74 4f                	je     8010474d <sched+0x7d>
  if (mycpu()->ncli != 1)
801046fe:	e8 fd f0 ff ff       	call   80103800 <mycpu>
80104703:	83 b8 a4 00 00 00 01 	cmpl   $0x1,0xa4(%eax)
8010470a:	75 68                	jne    80104774 <sched+0xa4>
  if (p->state == RUNNING)
8010470c:	83 7b 0c 04          	cmpl   $0x4,0xc(%ebx)
80104710:	74 55                	je     80104767 <sched+0x97>
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80104712:	9c                   	pushf  
80104713:	58                   	pop    %eax
  if (readeflags() & FL_IF)
80104714:	f6 c4 02             	test   $0x2,%ah
80104717:	75 41                	jne    8010475a <sched+0x8a>
  intena = mycpu()->intena;
80104719:	e8 e2 f0 ff ff       	call   80103800 <mycpu>
  swtch(&p->context, mycpu()->scheduler);
8010471e:	83 c3 1c             	add    $0x1c,%ebx
  intena = mycpu()->intena;
80104721:	8b b0 a8 00 00 00    	mov    0xa8(%eax),%esi
  swtch(&p->context, mycpu()->scheduler);
80104727:	e8 d4 f0 ff ff       	call   80103800 <mycpu>
8010472c:	83 ec 08             	sub    $0x8,%esp
8010472f:	ff 70 04             	pushl  0x4(%eax)
80104732:	53                   	push   %ebx
80104733:	e8 13 0f 00 00       	call   8010564b <swtch>
  mycpu()->intena = intena;
80104738:	e8 c3 f0 ff ff       	call   80103800 <mycpu>
}
8010473d:	83 c4 10             	add    $0x10,%esp
  mycpu()->intena = intena;
80104740:	89 b0 a8 00 00 00    	mov    %esi,0xa8(%eax)
}
80104746:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104749:	5b                   	pop    %ebx
8010474a:	5e                   	pop    %esi
8010474b:	5d                   	pop    %ebp
8010474c:	c3                   	ret    
    panic("sched ptable.lock");
8010474d:	83 ec 0c             	sub    $0xc,%esp
80104750:	68 90 85 10 80       	push   $0x80108590
80104755:	e8 36 bc ff ff       	call   80100390 <panic>
    panic("sched interruptible");
8010475a:	83 ec 0c             	sub    $0xc,%esp
8010475d:	68 bc 85 10 80       	push   $0x801085bc
80104762:	e8 29 bc ff ff       	call   80100390 <panic>
    panic("sched running");
80104767:	83 ec 0c             	sub    $0xc,%esp
8010476a:	68 ae 85 10 80       	push   $0x801085ae
8010476f:	e8 1c bc ff ff       	call   80100390 <panic>
    panic("sched locks");
80104774:	83 ec 0c             	sub    $0xc,%esp
80104777:	68 a2 85 10 80       	push   $0x801085a2
8010477c:	e8 0f bc ff ff       	call   80100390 <panic>
80104781:	eb 0d                	jmp    80104790 <exit>
80104783:	90                   	nop
80104784:	90                   	nop
80104785:	90                   	nop
80104786:	90                   	nop
80104787:	90                   	nop
80104788:	90                   	nop
80104789:	90                   	nop
8010478a:	90                   	nop
8010478b:	90                   	nop
8010478c:	90                   	nop
8010478d:	90                   	nop
8010478e:	90                   	nop
8010478f:	90                   	nop

80104790 <exit>:
{
80104790:	55                   	push   %ebp
80104791:	89 e5                	mov    %esp,%ebp
80104793:	57                   	push   %edi
80104794:	56                   	push   %esi
80104795:	53                   	push   %ebx
80104796:	83 ec 0c             	sub    $0xc,%esp
  pushcli();
80104799:	e8 92 0a 00 00       	call   80105230 <pushcli>
  c = mycpu();
8010479e:	e8 5d f0 ff ff       	call   80103800 <mycpu>
  p = c->proc;
801047a3:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
801047a9:	e8 c2 0a 00 00       	call   80105270 <popcli>
  if (curproc == initproc)
801047ae:	39 35 d8 b5 10 80    	cmp    %esi,0x8010b5d8
801047b4:	8d 5e 28             	lea    0x28(%esi),%ebx
801047b7:	8d 7e 68             	lea    0x68(%esi),%edi
801047ba:	0f 84 1d 01 00 00    	je     801048dd <exit+0x14d>
    if (curproc->ofile[fd])
801047c0:	8b 03                	mov    (%ebx),%eax
801047c2:	85 c0                	test   %eax,%eax
801047c4:	74 12                	je     801047d8 <exit+0x48>
      fileclose(curproc->ofile[fd]);
801047c6:	83 ec 0c             	sub    $0xc,%esp
801047c9:	50                   	push   %eax
801047ca:	e8 71 c6 ff ff       	call   80100e40 <fileclose>
      curproc->ofile[fd] = 0;
801047cf:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
801047d5:	83 c4 10             	add    $0x10,%esp
801047d8:	83 c3 04             	add    $0x4,%ebx
  for (fd = 0; fd < NOFILE; fd++)
801047db:	39 df                	cmp    %ebx,%edi
801047dd:	75 e1                	jne    801047c0 <exit+0x30>
  begin_op();
801047df:	e8 bc e3 ff ff       	call   80102ba0 <begin_op>
  iput(curproc->cwd);
801047e4:	83 ec 0c             	sub    $0xc,%esp
801047e7:	ff 76 68             	pushl  0x68(%esi)
801047ea:	e8 c1 cf ff ff       	call   801017b0 <iput>
  end_op();
801047ef:	e8 1c e4 ff ff       	call   80102c10 <end_op>
  curproc->cwd = 0;
801047f4:	c7 46 68 00 00 00 00 	movl   $0x0,0x68(%esi)
  acquire(&ptable.lock);
801047fb:	c7 04 24 80 41 11 80 	movl   $0x80114180,(%esp)
80104802:	e8 f9 0a 00 00       	call   80105300 <acquire>
  wakeup1(curproc->parent);
80104807:	8b 56 14             	mov    0x14(%esi),%edx

  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
    if (p->state == SLEEPING && p->chan == chan)
    {
      p->state = RUNNABLE;
      p->start=ticks;
8010480a:	8b 1d 00 86 11 80    	mov    0x80118600,%ebx
80104810:	83 c4 10             	add    $0x10,%esp
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104813:	b8 b4 41 11 80       	mov    $0x801141b4,%eax
80104818:	eb 12                	jmp    8010482c <exit+0x9c>
8010481a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104820:	05 ec 00 00 00       	add    $0xec,%eax
80104825:	3d b4 7c 11 80       	cmp    $0x80117cb4,%eax
8010482a:	73 24                	jae    80104850 <exit+0xc0>
    if (p->state == SLEEPING && p->chan == chan)
8010482c:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80104830:	75 ee                	jne    80104820 <exit+0x90>
80104832:	3b 50 20             	cmp    0x20(%eax),%edx
80104835:	75 e9                	jne    80104820 <exit+0x90>
      p->state = RUNNABLE;
80104837:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
      p->start=ticks;
8010483e:	89 98 9c 00 00 00    	mov    %ebx,0x9c(%eax)
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104844:	05 ec 00 00 00       	add    $0xec,%eax
80104849:	3d b4 7c 11 80       	cmp    $0x80117cb4,%eax
8010484e:	72 dc                	jb     8010482c <exit+0x9c>
      p->parent = initproc;
80104850:	8b 0d d8 b5 10 80    	mov    0x8010b5d8,%ecx
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104856:	ba b4 41 11 80       	mov    $0x801141b4,%edx
8010485b:	eb 11                	jmp    8010486e <exit+0xde>
8010485d:	8d 76 00             	lea    0x0(%esi),%esi
80104860:	81 c2 ec 00 00 00    	add    $0xec,%edx
80104866:	81 fa b4 7c 11 80    	cmp    $0x80117cb4,%edx
8010486c:	73 40                	jae    801048ae <exit+0x11e>
    if (p->parent == curproc)
8010486e:	39 72 14             	cmp    %esi,0x14(%edx)
80104871:	75 ed                	jne    80104860 <exit+0xd0>
      if (p->state == ZOMBIE)
80104873:	83 7a 0c 05          	cmpl   $0x5,0xc(%edx)
      p->parent = initproc;
80104877:	89 4a 14             	mov    %ecx,0x14(%edx)
      if (p->state == ZOMBIE)
8010487a:	75 e4                	jne    80104860 <exit+0xd0>
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
8010487c:	b8 b4 41 11 80       	mov    $0x801141b4,%eax
80104881:	eb 11                	jmp    80104894 <exit+0x104>
80104883:	90                   	nop
80104884:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104888:	05 ec 00 00 00       	add    $0xec,%eax
8010488d:	3d b4 7c 11 80       	cmp    $0x80117cb4,%eax
80104892:	73 cc                	jae    80104860 <exit+0xd0>
    if (p->state == SLEEPING && p->chan == chan)
80104894:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80104898:	75 ee                	jne    80104888 <exit+0xf8>
8010489a:	3b 48 20             	cmp    0x20(%eax),%ecx
8010489d:	75 e9                	jne    80104888 <exit+0xf8>
      p->state = RUNNABLE;
8010489f:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
      p->start=ticks;
801048a6:	89 98 9c 00 00 00    	mov    %ebx,0x9c(%eax)
801048ac:	eb da                	jmp    80104888 <exit+0xf8>
  curproc->etime = ticks; // TODO Might need to protect the read of ticks with a lock
801048ae:	89 9e 80 00 00 00    	mov    %ebx,0x80(%esi)
  cprintf("Total Time: %d\n", curproc->etime - curproc->ctime);
801048b4:	2b 5e 7c             	sub    0x7c(%esi),%ebx
801048b7:	83 ec 08             	sub    $0x8,%esp
  curproc->state = ZOMBIE;
801048ba:	c7 46 0c 05 00 00 00 	movl   $0x5,0xc(%esi)
  cprintf("Total Time: %d\n", curproc->etime - curproc->ctime);
801048c1:	53                   	push   %ebx
801048c2:	68 dd 85 10 80       	push   $0x801085dd
801048c7:	e8 94 bd ff ff       	call   80100660 <cprintf>
  sched();
801048cc:	e8 ff fd ff ff       	call   801046d0 <sched>
  panic("zombie exit");
801048d1:	c7 04 24 ed 85 10 80 	movl   $0x801085ed,(%esp)
801048d8:	e8 b3 ba ff ff       	call   80100390 <panic>
    panic("init exiting");
801048dd:	83 ec 0c             	sub    $0xc,%esp
801048e0:	68 d0 85 10 80       	push   $0x801085d0
801048e5:	e8 a6 ba ff ff       	call   80100390 <panic>
801048ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801048f0 <yield>:
{
801048f0:	55                   	push   %ebp
801048f1:	89 e5                	mov    %esp,%ebp
801048f3:	56                   	push   %esi
801048f4:	53                   	push   %ebx
  acquire(&ptable.lock); //DOC: yieldlock
801048f5:	83 ec 0c             	sub    $0xc,%esp
801048f8:	68 80 41 11 80       	push   $0x80114180
801048fd:	e8 fe 09 00 00       	call   80105300 <acquire>
  pushcli();
80104902:	e8 29 09 00 00       	call   80105230 <pushcli>
  c = mycpu();
80104907:	e8 f4 ee ff ff       	call   80103800 <mycpu>
  p = c->proc;
8010490c:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80104912:	e8 59 09 00 00       	call   80105270 <popcli>
  myproc()->start=ticks;
80104917:	8b 35 00 86 11 80    	mov    0x80118600,%esi
  myproc()->state = RUNNABLE;
8010491d:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  pushcli();
80104924:	e8 07 09 00 00       	call   80105230 <pushcli>
  c = mycpu();
80104929:	e8 d2 ee ff ff       	call   80103800 <mycpu>
  p = c->proc;
8010492e:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80104934:	e8 37 09 00 00       	call   80105270 <popcli>
  myproc()->start=ticks;
80104939:	89 b3 9c 00 00 00    	mov    %esi,0x9c(%ebx)
  sched();
8010493f:	e8 8c fd ff ff       	call   801046d0 <sched>
  release(&ptable.lock);
80104944:	c7 04 24 80 41 11 80 	movl   $0x80114180,(%esp)
8010494b:	e8 70 0a 00 00       	call   801053c0 <release>
}
80104950:	83 c4 10             	add    $0x10,%esp
80104953:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104956:	5b                   	pop    %ebx
80104957:	5e                   	pop    %esi
80104958:	5d                   	pop    %ebp
80104959:	c3                   	ret    
8010495a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104960 <sleep>:
{
80104960:	55                   	push   %ebp
80104961:	89 e5                	mov    %esp,%ebp
80104963:	57                   	push   %edi
80104964:	56                   	push   %esi
80104965:	53                   	push   %ebx
80104966:	83 ec 0c             	sub    $0xc,%esp
80104969:	8b 7d 08             	mov    0x8(%ebp),%edi
8010496c:	8b 75 0c             	mov    0xc(%ebp),%esi
  pushcli();
8010496f:	e8 bc 08 00 00       	call   80105230 <pushcli>
  c = mycpu();
80104974:	e8 87 ee ff ff       	call   80103800 <mycpu>
  p = c->proc;
80104979:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
8010497f:	e8 ec 08 00 00       	call   80105270 <popcli>
  if (p == 0)
80104984:	85 db                	test   %ebx,%ebx
80104986:	0f 84 87 00 00 00    	je     80104a13 <sleep+0xb3>
  if (lk == 0)
8010498c:	85 f6                	test   %esi,%esi
8010498e:	74 76                	je     80104a06 <sleep+0xa6>
  if (lk != &ptable.lock)
80104990:	81 fe 80 41 11 80    	cmp    $0x80114180,%esi
80104996:	74 50                	je     801049e8 <sleep+0x88>
    acquire(&ptable.lock); //DOC: sleeplock1
80104998:	83 ec 0c             	sub    $0xc,%esp
8010499b:	68 80 41 11 80       	push   $0x80114180
801049a0:	e8 5b 09 00 00       	call   80105300 <acquire>
    release(lk);
801049a5:	89 34 24             	mov    %esi,(%esp)
801049a8:	e8 13 0a 00 00       	call   801053c0 <release>
  p->chan = chan;
801049ad:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
801049b0:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
801049b7:	e8 14 fd ff ff       	call   801046d0 <sched>
  p->chan = 0;
801049bc:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
    release(&ptable.lock);
801049c3:	c7 04 24 80 41 11 80 	movl   $0x80114180,(%esp)
801049ca:	e8 f1 09 00 00       	call   801053c0 <release>
    acquire(lk);
801049cf:	89 75 08             	mov    %esi,0x8(%ebp)
801049d2:	83 c4 10             	add    $0x10,%esp
}
801049d5:	8d 65 f4             	lea    -0xc(%ebp),%esp
801049d8:	5b                   	pop    %ebx
801049d9:	5e                   	pop    %esi
801049da:	5f                   	pop    %edi
801049db:	5d                   	pop    %ebp
    acquire(lk);
801049dc:	e9 1f 09 00 00       	jmp    80105300 <acquire>
801049e1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  p->chan = chan;
801049e8:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
801049eb:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
801049f2:	e8 d9 fc ff ff       	call   801046d0 <sched>
  p->chan = 0;
801049f7:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
}
801049fe:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104a01:	5b                   	pop    %ebx
80104a02:	5e                   	pop    %esi
80104a03:	5f                   	pop    %edi
80104a04:	5d                   	pop    %ebp
80104a05:	c3                   	ret    
    panic("sleep without lk");
80104a06:	83 ec 0c             	sub    $0xc,%esp
80104a09:	68 ff 85 10 80       	push   $0x801085ff
80104a0e:	e8 7d b9 ff ff       	call   80100390 <panic>
    panic("sleep");
80104a13:	83 ec 0c             	sub    $0xc,%esp
80104a16:	68 f9 85 10 80       	push   $0x801085f9
80104a1b:	e8 70 b9 ff ff       	call   80100390 <panic>

80104a20 <wait>:
{
80104a20:	55                   	push   %ebp
80104a21:	89 e5                	mov    %esp,%ebp
80104a23:	56                   	push   %esi
80104a24:	53                   	push   %ebx
  pushcli();
80104a25:	e8 06 08 00 00       	call   80105230 <pushcli>
  c = mycpu();
80104a2a:	e8 d1 ed ff ff       	call   80103800 <mycpu>
  p = c->proc;
80104a2f:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
80104a35:	e8 36 08 00 00       	call   80105270 <popcli>
  acquire(&ptable.lock);
80104a3a:	83 ec 0c             	sub    $0xc,%esp
80104a3d:	68 80 41 11 80       	push   $0x80114180
80104a42:	e8 b9 08 00 00       	call   80105300 <acquire>
80104a47:	83 c4 10             	add    $0x10,%esp
    havekids = 0;
80104a4a:	31 c0                	xor    %eax,%eax
    for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104a4c:	bb b4 41 11 80       	mov    $0x801141b4,%ebx
80104a51:	eb 13                	jmp    80104a66 <wait+0x46>
80104a53:	90                   	nop
80104a54:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104a58:	81 c3 ec 00 00 00    	add    $0xec,%ebx
80104a5e:	81 fb b4 7c 11 80    	cmp    $0x80117cb4,%ebx
80104a64:	73 1e                	jae    80104a84 <wait+0x64>
      if (p->parent != curproc)
80104a66:	39 73 14             	cmp    %esi,0x14(%ebx)
80104a69:	75 ed                	jne    80104a58 <wait+0x38>
      if (p->state == ZOMBIE)
80104a6b:	83 7b 0c 05          	cmpl   $0x5,0xc(%ebx)
80104a6f:	74 3f                	je     80104ab0 <wait+0x90>
    for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104a71:	81 c3 ec 00 00 00    	add    $0xec,%ebx
      havekids = 1;
80104a77:	b8 01 00 00 00       	mov    $0x1,%eax
    for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104a7c:	81 fb b4 7c 11 80    	cmp    $0x80117cb4,%ebx
80104a82:	72 e2                	jb     80104a66 <wait+0x46>
    if (!havekids || curproc->killed)
80104a84:	85 c0                	test   %eax,%eax
80104a86:	0f 84 8a 00 00 00    	je     80104b16 <wait+0xf6>
80104a8c:	8b 46 24             	mov    0x24(%esi),%eax
80104a8f:	85 c0                	test   %eax,%eax
80104a91:	0f 85 7f 00 00 00    	jne    80104b16 <wait+0xf6>
    sleep(curproc, &ptable.lock); //DOC: wait-sleep
80104a97:	83 ec 08             	sub    $0x8,%esp
80104a9a:	68 80 41 11 80       	push   $0x80114180
80104a9f:	56                   	push   %esi
80104aa0:	e8 bb fe ff ff       	call   80104960 <sleep>
    havekids = 0;
80104aa5:	83 c4 10             	add    $0x10,%esp
80104aa8:	eb a0                	jmp    80104a4a <wait+0x2a>
80104aaa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        kfree(p->kstack);
80104ab0:	83 ec 0c             	sub    $0xc,%esp
80104ab3:	ff 73 08             	pushl  0x8(%ebx)
        pid = p->pid;
80104ab6:	8b 73 10             	mov    0x10(%ebx),%esi
        kfree(p->kstack);
80104ab9:	e8 52 d8 ff ff       	call   80102310 <kfree>
        freevm(p->pgdir);
80104abe:	5a                   	pop    %edx
80104abf:	ff 73 04             	pushl  0x4(%ebx)
        p->kstack = 0;
80104ac2:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
        freevm(p->pgdir);
80104ac9:	e8 12 32 00 00       	call   80107ce0 <freevm>
        rem_process(p->pid,p->current_queue); //Removing zombie processses from the queue
80104ace:	59                   	pop    %ecx
80104acf:	58                   	pop    %eax
80104ad0:	ff b3 a4 00 00 00    	pushl  0xa4(%ebx)
80104ad6:	ff 73 10             	pushl  0x10(%ebx)
80104ad9:	e8 f2 ed ff ff       	call   801038d0 <rem_process>
        release(&ptable.lock);
80104ade:	c7 04 24 80 41 11 80 	movl   $0x80114180,(%esp)
        p->pid = 0;
80104ae5:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
        p->parent = 0;
80104aec:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
        p->name[0] = 0;
80104af3:	c6 43 6c 00          	movb   $0x0,0x6c(%ebx)
        p->killed = 0;
80104af7:	c7 43 24 00 00 00 00 	movl   $0x0,0x24(%ebx)
        p->state = UNUSED;
80104afe:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
        release(&ptable.lock);
80104b05:	e8 b6 08 00 00       	call   801053c0 <release>
        return pid;
80104b0a:	83 c4 10             	add    $0x10,%esp
}
80104b0d:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104b10:	89 f0                	mov    %esi,%eax
80104b12:	5b                   	pop    %ebx
80104b13:	5e                   	pop    %esi
80104b14:	5d                   	pop    %ebp
80104b15:	c3                   	ret    
      release(&ptable.lock);
80104b16:	83 ec 0c             	sub    $0xc,%esp
      return -1;
80104b19:	be ff ff ff ff       	mov    $0xffffffff,%esi
      release(&ptable.lock);
80104b1e:	68 80 41 11 80       	push   $0x80114180
80104b23:	e8 98 08 00 00       	call   801053c0 <release>
      return -1;
80104b28:	83 c4 10             	add    $0x10,%esp
80104b2b:	eb e0                	jmp    80104b0d <wait+0xed>
80104b2d:	8d 76 00             	lea    0x0(%esi),%esi

80104b30 <wakeup>:
    }
}

// Wake up all processes sleeping on chan.
void wakeup(void *chan)
{
80104b30:	55                   	push   %ebp
80104b31:	89 e5                	mov    %esp,%ebp
80104b33:	53                   	push   %ebx
80104b34:	83 ec 10             	sub    $0x10,%esp
80104b37:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ptable.lock);
80104b3a:	68 80 41 11 80       	push   $0x80114180
80104b3f:	e8 bc 07 00 00       	call   80105300 <acquire>
      p->start=ticks;
80104b44:	8b 15 00 86 11 80    	mov    0x80118600,%edx
80104b4a:	83 c4 10             	add    $0x10,%esp
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104b4d:	b8 b4 41 11 80       	mov    $0x801141b4,%eax
80104b52:	eb 10                	jmp    80104b64 <wakeup+0x34>
80104b54:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104b58:	05 ec 00 00 00       	add    $0xec,%eax
80104b5d:	3d b4 7c 11 80       	cmp    $0x80117cb4,%eax
80104b62:	73 24                	jae    80104b88 <wakeup+0x58>
    if (p->state == SLEEPING && p->chan == chan)
80104b64:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80104b68:	75 ee                	jne    80104b58 <wakeup+0x28>
80104b6a:	3b 58 20             	cmp    0x20(%eax),%ebx
80104b6d:	75 e9                	jne    80104b58 <wakeup+0x28>
      p->state = RUNNABLE;
80104b6f:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
      p->start=ticks;
80104b76:	89 90 9c 00 00 00    	mov    %edx,0x9c(%eax)
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104b7c:	05 ec 00 00 00       	add    $0xec,%eax
80104b81:	3d b4 7c 11 80       	cmp    $0x80117cb4,%eax
80104b86:	72 dc                	jb     80104b64 <wakeup+0x34>
  wakeup1(chan);
  release(&ptable.lock);
80104b88:	c7 45 08 80 41 11 80 	movl   $0x80114180,0x8(%ebp)
}
80104b8f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104b92:	c9                   	leave  
  release(&ptable.lock);
80104b93:	e9 28 08 00 00       	jmp    801053c0 <release>
80104b98:	90                   	nop
80104b99:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104ba0 <kill>:

// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int kill(int pid)
{
80104ba0:	55                   	push   %ebp
80104ba1:	89 e5                	mov    %esp,%ebp
80104ba3:	53                   	push   %ebx
80104ba4:	83 ec 10             	sub    $0x10,%esp
80104ba7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *p;

  acquire(&ptable.lock);
80104baa:	68 80 41 11 80       	push   $0x80114180
80104baf:	e8 4c 07 00 00       	call   80105300 <acquire>
80104bb4:	83 c4 10             	add    $0x10,%esp
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104bb7:	b8 b4 41 11 80       	mov    $0x801141b4,%eax
80104bbc:	eb 0e                	jmp    80104bcc <kill+0x2c>
80104bbe:	66 90                	xchg   %ax,%ax
80104bc0:	05 ec 00 00 00       	add    $0xec,%eax
80104bc5:	3d b4 7c 11 80       	cmp    $0x80117cb4,%eax
80104bca:	73 44                	jae    80104c10 <kill+0x70>
  {
    if (p->pid == pid)
80104bcc:	39 58 10             	cmp    %ebx,0x10(%eax)
80104bcf:	75 ef                	jne    80104bc0 <kill+0x20>
    {
      p->killed = 1;
      // Wake process from sleep if necessary.
      if (p->state == SLEEPING)
80104bd1:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
      p->killed = 1;
80104bd5:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
      if (p->state == SLEEPING)
80104bdc:	75 13                	jne    80104bf1 <kill+0x51>
      {
        p->start=ticks;
80104bde:	8b 15 00 86 11 80    	mov    0x80118600,%edx
        p->state = RUNNABLE;
80104be4:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
        p->start=ticks;
80104beb:	89 90 9c 00 00 00    	mov    %edx,0x9c(%eax)
      }
      release(&ptable.lock);
80104bf1:	83 ec 0c             	sub    $0xc,%esp
80104bf4:	68 80 41 11 80       	push   $0x80114180
80104bf9:	e8 c2 07 00 00       	call   801053c0 <release>
      return 0;
80104bfe:	83 c4 10             	add    $0x10,%esp
80104c01:	31 c0                	xor    %eax,%eax
    }
  }
  release(&ptable.lock);
  return -1;
}
80104c03:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104c06:	c9                   	leave  
80104c07:	c3                   	ret    
80104c08:	90                   	nop
80104c09:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  release(&ptable.lock);
80104c10:	83 ec 0c             	sub    $0xc,%esp
80104c13:	68 80 41 11 80       	push   $0x80114180
80104c18:	e8 a3 07 00 00       	call   801053c0 <release>
  return -1;
80104c1d:	83 c4 10             	add    $0x10,%esp
80104c20:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104c25:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104c28:	c9                   	leave  
80104c29:	c3                   	ret    
80104c2a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104c30 <procdump>:
//PAGEBREAK: 36
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void procdump(void)
{
80104c30:	55                   	push   %ebp
80104c31:	89 e5                	mov    %esp,%ebp
80104c33:	57                   	push   %edi
80104c34:	56                   	push   %esi
80104c35:	53                   	push   %ebx
80104c36:	8d 75 e8             	lea    -0x18(%ebp),%esi
  int i;
  struct proc *p;
  char *state;
  uint pc[10];

  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104c39:	bb b4 41 11 80       	mov    $0x801141b4,%ebx
{
80104c3e:	83 ec 3c             	sub    $0x3c,%esp
80104c41:	eb 27                	jmp    80104c6a <procdump+0x3a>
80104c43:	90                   	nop
80104c44:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    {
      getcallerpcs((uint *)p->context->ebp + 2, pc);
      for (i = 0; i < 10 && pc[i] != 0; i++)
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
80104c48:	83 ec 0c             	sub    $0xc,%esp
80104c4b:	68 f7 8a 10 80       	push   $0x80108af7
80104c50:	e8 0b ba ff ff       	call   80100660 <cprintf>
80104c55:	83 c4 10             	add    $0x10,%esp
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104c58:	81 c3 ec 00 00 00    	add    $0xec,%ebx
80104c5e:	81 fb b4 7c 11 80    	cmp    $0x80117cb4,%ebx
80104c64:	0f 83 86 00 00 00    	jae    80104cf0 <procdump+0xc0>
    if (p->state == UNUSED)
80104c6a:	8b 43 0c             	mov    0xc(%ebx),%eax
80104c6d:	85 c0                	test   %eax,%eax
80104c6f:	74 e7                	je     80104c58 <procdump+0x28>
    if (p->state >= 0 && p->state < NELEM(states) && states[p->state])
80104c71:	83 f8 05             	cmp    $0x5,%eax
      state = "???";
80104c74:	ba 10 86 10 80       	mov    $0x80108610,%edx
    if (p->state >= 0 && p->state < NELEM(states) && states[p->state])
80104c79:	77 11                	ja     80104c8c <procdump+0x5c>
80104c7b:	8b 14 85 c8 87 10 80 	mov    -0x7fef7838(,%eax,4),%edx
      state = "???";
80104c82:	b8 10 86 10 80       	mov    $0x80108610,%eax
80104c87:	85 d2                	test   %edx,%edx
80104c89:	0f 44 d0             	cmove  %eax,%edx
    cprintf("%d %s %s", p->pid, state, p->name);
80104c8c:	8d 43 6c             	lea    0x6c(%ebx),%eax
80104c8f:	50                   	push   %eax
80104c90:	52                   	push   %edx
80104c91:	ff 73 10             	pushl  0x10(%ebx)
80104c94:	68 14 86 10 80       	push   $0x80108614
80104c99:	e8 c2 b9 ff ff       	call   80100660 <cprintf>
    if (p->state == SLEEPING)
80104c9e:	83 c4 10             	add    $0x10,%esp
80104ca1:	83 7b 0c 02          	cmpl   $0x2,0xc(%ebx)
80104ca5:	75 a1                	jne    80104c48 <procdump+0x18>
      getcallerpcs((uint *)p->context->ebp + 2, pc);
80104ca7:	8d 45 c0             	lea    -0x40(%ebp),%eax
80104caa:	83 ec 08             	sub    $0x8,%esp
80104cad:	8d 7d c0             	lea    -0x40(%ebp),%edi
80104cb0:	50                   	push   %eax
80104cb1:	8b 43 1c             	mov    0x1c(%ebx),%eax
80104cb4:	8b 40 0c             	mov    0xc(%eax),%eax
80104cb7:	83 c0 08             	add    $0x8,%eax
80104cba:	50                   	push   %eax
80104cbb:	e8 20 05 00 00       	call   801051e0 <getcallerpcs>
80104cc0:	83 c4 10             	add    $0x10,%esp
80104cc3:	90                   	nop
80104cc4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      for (i = 0; i < 10 && pc[i] != 0; i++)
80104cc8:	8b 17                	mov    (%edi),%edx
80104cca:	85 d2                	test   %edx,%edx
80104ccc:	0f 84 76 ff ff ff    	je     80104c48 <procdump+0x18>
        cprintf(" %p", pc[i]);
80104cd2:	83 ec 08             	sub    $0x8,%esp
80104cd5:	83 c7 04             	add    $0x4,%edi
80104cd8:	52                   	push   %edx
80104cd9:	68 41 80 10 80       	push   $0x80108041
80104cde:	e8 7d b9 ff ff       	call   80100660 <cprintf>
      for (i = 0; i < 10 && pc[i] != 0; i++)
80104ce3:	83 c4 10             	add    $0x10,%esp
80104ce6:	39 fe                	cmp    %edi,%esi
80104ce8:	75 de                	jne    80104cc8 <procdump+0x98>
80104cea:	e9 59 ff ff ff       	jmp    80104c48 <procdump+0x18>
80104cef:	90                   	nop
  }
}
80104cf0:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104cf3:	5b                   	pop    %ebx
80104cf4:	5e                   	pop    %esi
80104cf5:	5f                   	pop    %edi
80104cf6:	5d                   	pop    %ebp
80104cf7:	c3                   	ret    
80104cf8:	90                   	nop
80104cf9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104d00 <waitx>:


int waitx(int *wtime, int *rtime)
{
80104d00:	55                   	push   %ebp
80104d01:	89 e5                	mov    %esp,%ebp
80104d03:	56                   	push   %esi
80104d04:	53                   	push   %ebx
  pushcli();
80104d05:	e8 26 05 00 00       	call   80105230 <pushcli>
  c = mycpu();
80104d0a:	e8 f1 ea ff ff       	call   80103800 <mycpu>
  p = c->proc;
80104d0f:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
80104d15:	e8 56 05 00 00       	call   80105270 <popcli>
  int havekids;
  struct proc *p;
  int pid;
  struct proc *curproc = myproc();

  acquire(&ptable.lock);
80104d1a:	83 ec 0c             	sub    $0xc,%esp
80104d1d:	68 80 41 11 80       	push   $0x80114180
80104d22:	e8 d9 05 00 00       	call   80105300 <acquire>
80104d27:	83 c4 10             	add    $0x10,%esp
  havekids = 0;
  for (;;)
  {
    // Scan through table looking for zombie children.
    havekids = 0;
    for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104d2a:	bb b4 41 11 80       	mov    $0x801141b4,%ebx
    havekids = 0;
80104d2f:	31 c0                	xor    %eax,%eax
80104d31:	eb 13                	jmp    80104d46 <waitx+0x46>
80104d33:	90                   	nop
80104d34:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104d38:	81 c3 ec 00 00 00    	add    $0xec,%ebx
80104d3e:	81 fb b4 7c 11 80    	cmp    $0x80117cb4,%ebx
80104d44:	73 1e                	jae    80104d64 <waitx+0x64>
    {
      if (p->parent != curproc)
80104d46:	39 73 14             	cmp    %esi,0x14(%ebx)
80104d49:	75 ed                	jne    80104d38 <waitx+0x38>
        continue;
      if(p->parent == curproc)
      {
        havekids = 1;
        if (p->state == ZOMBIE)
80104d4b:	83 7b 0c 05          	cmpl   $0x5,0xc(%ebx)
80104d4f:	74 3f                	je     80104d90 <waitx+0x90>
    for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104d51:	81 c3 ec 00 00 00    	add    $0xec,%ebx
        havekids = 1;
80104d57:	b8 01 00 00 00       	mov    $0x1,%eax
    for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104d5c:	81 fb b4 7c 11 80    	cmp    $0x80117cb4,%ebx
80104d62:	72 e2                	jb     80104d46 <waitx+0x46>
          return pid;
        }
      }
    }

    if (!(!havekids || curproc->killed))
80104d64:	85 c0                	test   %eax,%eax
80104d66:	0f 84 c1 00 00 00    	je     80104e2d <waitx+0x12d>
80104d6c:	8b 46 24             	mov    0x24(%esi),%eax
80104d6f:	85 c0                	test   %eax,%eax
80104d71:	0f 85 b6 00 00 00    	jne    80104e2d <waitx+0x12d>
    {
      sleep(curproc, &ptable.lock); //DOC: wait-sleep
80104d77:	83 ec 08             	sub    $0x8,%esp
80104d7a:	68 80 41 11 80       	push   $0x80114180
80104d7f:	56                   	push   %esi
80104d80:	e8 db fb ff ff       	call   80104960 <sleep>
    havekids = 0;
80104d85:	83 c4 10             	add    $0x10,%esp
80104d88:	eb a0                	jmp    80104d2a <waitx+0x2a>
80104d8a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
          *wtime = p->etime - p->ctime - p->rtime - p->iotime;
80104d90:	8b 83 80 00 00 00    	mov    0x80(%ebx),%eax
80104d96:	2b 43 7c             	sub    0x7c(%ebx),%eax
          cprintf("\netime %d  ctime %d    rtime %d    iotime %d \n", p->etime, p->ctime, p->rtime, p->iotime);
80104d99:	83 ec 0c             	sub    $0xc,%esp
          *wtime = p->etime - p->ctime - p->rtime - p->iotime;
80104d9c:	2b 83 84 00 00 00    	sub    0x84(%ebx),%eax
80104da2:	8b 55 08             	mov    0x8(%ebp),%edx
80104da5:	2b 83 88 00 00 00    	sub    0x88(%ebx),%eax
80104dab:	89 02                	mov    %eax,(%edx)
          cprintf("\netime %d  ctime %d    rtime %d    iotime %d \n", p->etime, p->ctime, p->rtime, p->iotime);
80104dad:	ff b3 88 00 00 00    	pushl  0x88(%ebx)
80104db3:	ff b3 84 00 00 00    	pushl  0x84(%ebx)
80104db9:	ff 73 7c             	pushl  0x7c(%ebx)
80104dbc:	ff b3 80 00 00 00    	pushl  0x80(%ebx)
80104dc2:	68 70 86 10 80       	push   $0x80108670
80104dc7:	e8 94 b8 ff ff       	call   80100660 <cprintf>
          *rtime = p->rtime;
80104dcc:	8b 45 0c             	mov    0xc(%ebp),%eax
80104dcf:	8b 93 84 00 00 00    	mov    0x84(%ebx),%edx
          kfree(p->kstack);
80104dd5:	83 c4 14             	add    $0x14,%esp
          *rtime = p->rtime;
80104dd8:	89 10                	mov    %edx,(%eax)
          kfree(p->kstack);
80104dda:	ff 73 08             	pushl  0x8(%ebx)
          pid = p->pid;
80104ddd:	8b 73 10             	mov    0x10(%ebx),%esi
          kfree(p->kstack);
80104de0:	e8 2b d5 ff ff       	call   80102310 <kfree>
          freevm(p->pgdir);
80104de5:	5a                   	pop    %edx
80104de6:	ff 73 04             	pushl  0x4(%ebx)
          p->kstack = 0;
80104de9:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
          freevm(p->pgdir);
80104df0:	e8 eb 2e 00 00       	call   80107ce0 <freevm>
          release(&ptable.lock);
80104df5:	c7 04 24 80 41 11 80 	movl   $0x80114180,(%esp)
          p->state = UNUSED;
80104dfc:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
          p->pid = 0;
80104e03:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
          p->parent = 0;
80104e0a:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
          p->name[0] = 0;
80104e11:	c6 43 6c 00          	movb   $0x0,0x6c(%ebx)
          p->killed = 0;
80104e15:	c7 43 24 00 00 00 00 	movl   $0x0,0x24(%ebx)
          release(&ptable.lock);
80104e1c:	e8 9f 05 00 00       	call   801053c0 <release>
          return pid;
80104e21:	83 c4 10             	add    $0x10,%esp
    // No point waiting if we don't have any children.
    release(&ptable.lock);
    return -1;

  }
}
80104e24:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104e27:	89 f0                	mov    %esi,%eax
80104e29:	5b                   	pop    %ebx
80104e2a:	5e                   	pop    %esi
80104e2b:	5d                   	pop    %ebp
80104e2c:	c3                   	ret    
    release(&ptable.lock);
80104e2d:	83 ec 0c             	sub    $0xc,%esp
    return -1;
80104e30:	be ff ff ff ff       	mov    $0xffffffff,%esi
    release(&ptable.lock);
80104e35:	68 80 41 11 80       	push   $0x80114180
80104e3a:	e8 81 05 00 00       	call   801053c0 <release>
    return -1;
80104e3f:	83 c4 10             	add    $0x10,%esp
80104e42:	eb e0                	jmp    80104e24 <waitx+0x124>
80104e44:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104e4a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80104e50 <cps>:

int cps()
{
80104e50:	55                   	push   %ebp
80104e51:	89 e5                	mov    %esp,%ebp
80104e53:	53                   	push   %ebx
80104e54:	83 ec 10             	sub    $0x10,%esp
  asm volatile("sti");
80104e57:	fb                   	sti    
  struct proc *p;
  sti();
  #ifdef MLFQ
  cprintf("PID Priority   State   rtime wtime n_run curr_q q0 q1 q2 q3 q4 \n");
80104e58:	68 a0 86 10 80       	push   $0x801086a0
  #else
  cprintf("PID Priority   State   rtime wtime \n");
  #endif
  acquire(&ptable.lock);
  for(p=ptable.proc;p<&ptable.proc[NPROC]; p++){
80104e5d:	bb b4 41 11 80       	mov    $0x801141b4,%ebx
  cprintf("PID Priority   State   rtime wtime n_run curr_q q0 q1 q2 q3 q4 \n");
80104e62:	e8 f9 b7 ff ff       	call   80100660 <cprintf>
  acquire(&ptable.lock);
80104e67:	c7 04 24 80 41 11 80 	movl   $0x80114180,(%esp)
80104e6e:	e8 8d 04 00 00       	call   80105300 <acquire>
80104e73:	83 c4 10             	add    $0x10,%esp
80104e76:	eb 24                	jmp    80104e9c <cps+0x4c>
80104e78:	90                   	nop
80104e79:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(p->state == 3)
    {
      cprintf("%d   %d        RUNNABLE    %d     %d     %d     %d    %d  %d  %d  %d  %d\n",p->pid,p->priority,p->rtime,p->waittime,p->num_r,p->current_queue, p->ticks[0],p->ticks[1],p->ticks[2],p->ticks[3],p->ticks[4]);
      continue;
    }
    else if(p->state == 2)
80104e80:	83 f8 02             	cmp    $0x2,%eax
80104e83:	74 7b                	je     80104f00 <cps+0xb0>
    {
      cprintf("%d   %d        SLEEPING   %d     %d     %d     %d    %d  %d  %d  %d  %d\n",p->pid,p->priority,p->rtime,p->waittime,p->num_r,p->current_queue,p->ticks[0],p->ticks[1],p->ticks[2],p->ticks[3],p->ticks[4] );
      continue;
    }
    else if(p->state == 4)
80104e85:	83 f8 04             	cmp    $0x4,%eax
80104e88:	0f 84 ca 00 00 00    	je     80104f58 <cps+0x108>
  for(p=ptable.proc;p<&ptable.proc[NPROC]; p++){
80104e8e:	81 c3 ec 00 00 00    	add    $0xec,%ebx
80104e94:	81 fb b4 7c 11 80    	cmp    $0x80117cb4,%ebx
80104e9a:	73 4d                	jae    80104ee9 <cps+0x99>
    if(p->state == 3)
80104e9c:	8b 43 0c             	mov    0xc(%ebx),%eax
80104e9f:	83 f8 03             	cmp    $0x3,%eax
80104ea2:	75 dc                	jne    80104e80 <cps+0x30>
      cprintf("%d   %d        RUNNABLE    %d     %d     %d     %d    %d  %d  %d  %d  %d\n",p->pid,p->priority,p->rtime,p->waittime,p->num_r,p->current_queue, p->ticks[0],p->ticks[1],p->ticks[2],p->ticks[3],p->ticks[4]);
80104ea4:	ff b3 e4 00 00 00    	pushl  0xe4(%ebx)
80104eaa:	ff b3 e0 00 00 00    	pushl  0xe0(%ebx)
  for(p=ptable.proc;p<&ptable.proc[NPROC]; p++){
80104eb0:	81 c3 ec 00 00 00    	add    $0xec,%ebx
      cprintf("%d   %d        RUNNABLE    %d     %d     %d     %d    %d  %d  %d  %d  %d\n",p->pid,p->priority,p->rtime,p->waittime,p->num_r,p->current_queue, p->ticks[0],p->ticks[1],p->ticks[2],p->ticks[3],p->ticks[4]);
80104eb6:	ff 73 f0             	pushl  -0x10(%ebx)
80104eb9:	ff 73 ec             	pushl  -0x14(%ebx)
80104ebc:	ff 73 e8             	pushl  -0x18(%ebx)
80104ebf:	ff 73 b8             	pushl  -0x48(%ebx)
80104ec2:	ff 73 a0             	pushl  -0x60(%ebx)
80104ec5:	ff 73 b4             	pushl  -0x4c(%ebx)
80104ec8:	ff 73 98             	pushl  -0x68(%ebx)
80104ecb:	ff 73 a4             	pushl  -0x5c(%ebx)
80104ece:	ff b3 24 ff ff ff    	pushl  -0xdc(%ebx)
80104ed4:	68 e4 86 10 80       	push   $0x801086e4
80104ed9:	e8 82 b7 ff ff       	call   80100660 <cprintf>
      continue;
80104ede:	83 c4 30             	add    $0x30,%esp
  for(p=ptable.proc;p<&ptable.proc[NPROC]; p++){
80104ee1:	81 fb b4 7c 11 80    	cmp    $0x80117cb4,%ebx
80104ee7:	72 b3                	jb     80104e9c <cps+0x4c>
      cprintf("%d             EMBRYO\n",p->pid);
    }

    #endif
  }
  release(&ptable.lock);
80104ee9:	83 ec 0c             	sub    $0xc,%esp
80104eec:	68 80 41 11 80       	push   $0x80114180
80104ef1:	e8 ca 04 00 00       	call   801053c0 <release>
  return 22;

}
80104ef6:	b8 16 00 00 00       	mov    $0x16,%eax
80104efb:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104efe:	c9                   	leave  
80104eff:	c3                   	ret    
      cprintf("%d   %d        SLEEPING   %d     %d     %d     %d    %d  %d  %d  %d  %d\n",p->pid,p->priority,p->rtime,p->waittime,p->num_r,p->current_queue,p->ticks[0],p->ticks[1],p->ticks[2],p->ticks[3],p->ticks[4] );
80104f00:	ff b3 e4 00 00 00    	pushl  0xe4(%ebx)
80104f06:	ff b3 e0 00 00 00    	pushl  0xe0(%ebx)
80104f0c:	ff b3 dc 00 00 00    	pushl  0xdc(%ebx)
80104f12:	ff b3 d8 00 00 00    	pushl  0xd8(%ebx)
80104f18:	ff b3 d4 00 00 00    	pushl  0xd4(%ebx)
80104f1e:	ff b3 a4 00 00 00    	pushl  0xa4(%ebx)
80104f24:	ff b3 8c 00 00 00    	pushl  0x8c(%ebx)
80104f2a:	ff b3 a0 00 00 00    	pushl  0xa0(%ebx)
80104f30:	ff b3 84 00 00 00    	pushl  0x84(%ebx)
80104f36:	ff b3 90 00 00 00    	pushl  0x90(%ebx)
80104f3c:	ff 73 10             	pushl  0x10(%ebx)
80104f3f:	68 30 87 10 80       	push   $0x80108730
80104f44:	e8 17 b7 ff ff       	call   80100660 <cprintf>
      continue;
80104f49:	83 c4 30             	add    $0x30,%esp
80104f4c:	e9 3d ff ff ff       	jmp    80104e8e <cps+0x3e>
80104f51:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      cprintf("%d   %d        RUNNING   %d     %d      %d     %d    %d  %d  %d  %d  %d\n",p->pid,p->priority,p->rtime,p->waittime,p->num_r,p->current_queue, p->ticks[0],p->ticks[1],p->ticks[2],p->ticks[3],p->ticks[4]);
80104f58:	ff b3 e4 00 00 00    	pushl  0xe4(%ebx)
80104f5e:	ff b3 e0 00 00 00    	pushl  0xe0(%ebx)
80104f64:	ff b3 dc 00 00 00    	pushl  0xdc(%ebx)
80104f6a:	ff b3 d8 00 00 00    	pushl  0xd8(%ebx)
80104f70:	ff b3 d4 00 00 00    	pushl  0xd4(%ebx)
80104f76:	ff b3 a4 00 00 00    	pushl  0xa4(%ebx)
80104f7c:	ff b3 8c 00 00 00    	pushl  0x8c(%ebx)
80104f82:	ff b3 a0 00 00 00    	pushl  0xa0(%ebx)
80104f88:	ff b3 84 00 00 00    	pushl  0x84(%ebx)
80104f8e:	ff b3 90 00 00 00    	pushl  0x90(%ebx)
80104f94:	ff 73 10             	pushl  0x10(%ebx)
80104f97:	68 7c 87 10 80       	push   $0x8010877c
80104f9c:	e8 bf b6 ff ff       	call   80100660 <cprintf>
      continue;
80104fa1:	83 c4 30             	add    $0x30,%esp
80104fa4:	e9 e5 fe ff ff       	jmp    80104e8e <cps+0x3e>
80104fa9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104fb0 <chpr>:

int chpr(int pid, int priority)
{
80104fb0:	55                   	push   %ebp
80104fb1:	89 e5                	mov    %esp,%ebp
80104fb3:	53                   	push   %ebx
80104fb4:	83 ec 10             	sub    $0x10,%esp
80104fb7:	8b 5d 08             	mov    0x8(%ebp),%ebx
	struct proc *p;
	acquire(&ptable.lock);
80104fba:	68 80 41 11 80       	push   $0x80114180
80104fbf:	e8 3c 03 00 00       	call   80105300 <acquire>
80104fc4:	83 c4 10             	add    $0x10,%esp
	for(p=ptable.proc;p<&ptable.proc[NPROC];p++){
80104fc7:	ba b4 41 11 80       	mov    $0x801141b4,%edx
80104fcc:	eb 10                	jmp    80104fde <chpr+0x2e>
80104fce:	66 90                	xchg   %ax,%ax
80104fd0:	81 c2 ec 00 00 00    	add    $0xec,%edx
80104fd6:	81 fa b4 7c 11 80    	cmp    $0x80117cb4,%edx
80104fdc:	73 0e                	jae    80104fec <chpr+0x3c>
		if(p->pid == pid){
80104fde:	39 5a 10             	cmp    %ebx,0x10(%edx)
80104fe1:	75 ed                	jne    80104fd0 <chpr+0x20>
			p->priority=priority;
80104fe3:	8b 45 0c             	mov    0xc(%ebp),%eax
80104fe6:	89 82 90 00 00 00    	mov    %eax,0x90(%edx)
			break;
		}
	}
	release(&ptable.lock);
80104fec:	83 ec 0c             	sub    $0xc,%esp
80104fef:	68 80 41 11 80       	push   $0x80114180
80104ff4:	e8 c7 03 00 00       	call   801053c0 <release>
	return pid;
}
80104ff9:	89 d8                	mov    %ebx,%eax
80104ffb:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104ffe:	c9                   	leave  
80104fff:	c3                   	ret    

80105000 <setPriority>:

int setPriority(int priority, int pid)
{
80105000:	55                   	push   %ebp
80105001:	89 e5                	mov    %esp,%ebp
80105003:	56                   	push   %esi
80105004:	53                   	push   %ebx
80105005:	8b 75 08             	mov    0x8(%ebp),%esi
80105008:	8b 5d 0c             	mov    0xc(%ebp),%ebx
8010500b:	fb                   	sti    
  sti();

  //looping over all processes
  int new_priority=priority;
  int flag = 0;
  if(new_priority<0 || new_priority >100)
8010500c:	83 fe 64             	cmp    $0x64,%esi
8010500f:	77 73                	ja     80105084 <setPriority+0x84>
    return -2;
  acquire(&ptable.lock);
80105011:	83 ec 0c             	sub    $0xc,%esp
80105014:	68 80 41 11 80       	push   $0x80114180
80105019:	e8 e2 02 00 00       	call   80105300 <acquire>
8010501e:	83 c4 10             	add    $0x10,%esp
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80105021:	b8 b4 41 11 80       	mov    $0x801141b4,%eax
80105026:	eb 14                	jmp    8010503c <setPriority+0x3c>
80105028:	90                   	nop
80105029:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105030:	05 ec 00 00 00       	add    $0xec,%eax
80105035:	3d b4 7c 11 80       	cmp    $0x80117cb4,%eax
8010503a:	73 2c                	jae    80105068 <setPriority+0x68>
  {
    if (p->pid == pid)
8010503c:	39 58 10             	cmp    %ebx,0x10(%eax)
8010503f:	75 ef                	jne    80105030 <setPriority+0x30>
      p->priority = new_priority;
      flag = 1;
      break;
    }
  }
  release(&ptable.lock);
80105041:	83 ec 0c             	sub    $0xc,%esp
      p->priority = new_priority;
80105044:	89 b0 90 00 00 00    	mov    %esi,0x90(%eax)
  release(&ptable.lock);
8010504a:	68 80 41 11 80       	push   $0x80114180
8010504f:	e8 6c 03 00 00       	call   801053c0 <release>
80105054:	83 c4 10             	add    $0x10,%esp

  if (flag != 0)
    return 24;
80105057:	b8 18 00 00 00       	mov    $0x18,%eax
  else
    return -1;
}
8010505c:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010505f:	5b                   	pop    %ebx
80105060:	5e                   	pop    %esi
80105061:	5d                   	pop    %ebp
80105062:	c3                   	ret    
80105063:	90                   	nop
80105064:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  release(&ptable.lock);
80105068:	83 ec 0c             	sub    $0xc,%esp
8010506b:	68 80 41 11 80       	push   $0x80114180
80105070:	e8 4b 03 00 00       	call   801053c0 <release>
    return -1;
80105075:	83 c4 10             	add    $0x10,%esp
}
80105078:	8d 65 f8             	lea    -0x8(%ebp),%esp
    return -1;
8010507b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105080:	5b                   	pop    %ebx
80105081:	5e                   	pop    %esi
80105082:	5d                   	pop    %ebp
80105083:	c3                   	ret    
    return -2;
80105084:	b8 fe ff ff ff       	mov    $0xfffffffe,%eax
80105089:	eb d1                	jmp    8010505c <setPriority+0x5c>
8010508b:	66 90                	xchg   %ax,%ax
8010508d:	66 90                	xchg   %ax,%ax
8010508f:	90                   	nop

80105090 <initsleeplock>:
#include "spinlock.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
80105090:	55                   	push   %ebp
80105091:	89 e5                	mov    %esp,%ebp
80105093:	53                   	push   %ebx
80105094:	83 ec 0c             	sub    $0xc,%esp
80105097:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&lk->lk, "sleep lock");
8010509a:	68 e0 87 10 80       	push   $0x801087e0
8010509f:	8d 43 04             	lea    0x4(%ebx),%eax
801050a2:	50                   	push   %eax
801050a3:	e8 18 01 00 00       	call   801051c0 <initlock>
  lk->name = name;
801050a8:	8b 45 0c             	mov    0xc(%ebp),%eax
  lk->locked = 0;
801050ab:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
}
801050b1:	83 c4 10             	add    $0x10,%esp
  lk->pid = 0;
801050b4:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  lk->name = name;
801050bb:	89 43 38             	mov    %eax,0x38(%ebx)
}
801050be:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801050c1:	c9                   	leave  
801050c2:	c3                   	ret    
801050c3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801050c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801050d0 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
801050d0:	55                   	push   %ebp
801050d1:	89 e5                	mov    %esp,%ebp
801050d3:	56                   	push   %esi
801050d4:	53                   	push   %ebx
801050d5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
801050d8:	83 ec 0c             	sub    $0xc,%esp
801050db:	8d 73 04             	lea    0x4(%ebx),%esi
801050de:	56                   	push   %esi
801050df:	e8 1c 02 00 00       	call   80105300 <acquire>
  while (lk->locked) {
801050e4:	8b 13                	mov    (%ebx),%edx
801050e6:	83 c4 10             	add    $0x10,%esp
801050e9:	85 d2                	test   %edx,%edx
801050eb:	74 16                	je     80105103 <acquiresleep+0x33>
801050ed:	8d 76 00             	lea    0x0(%esi),%esi
    sleep(lk, &lk->lk);
801050f0:	83 ec 08             	sub    $0x8,%esp
801050f3:	56                   	push   %esi
801050f4:	53                   	push   %ebx
801050f5:	e8 66 f8 ff ff       	call   80104960 <sleep>
  while (lk->locked) {
801050fa:	8b 03                	mov    (%ebx),%eax
801050fc:	83 c4 10             	add    $0x10,%esp
801050ff:	85 c0                	test   %eax,%eax
80105101:	75 ed                	jne    801050f0 <acquiresleep+0x20>
  }
  lk->locked = 1;
80105103:	c7 03 01 00 00 00    	movl   $0x1,(%ebx)
  lk->pid = myproc()->pid;
80105109:	e8 92 e7 ff ff       	call   801038a0 <myproc>
8010510e:	8b 40 10             	mov    0x10(%eax),%eax
80105111:	89 43 3c             	mov    %eax,0x3c(%ebx)
  release(&lk->lk);
80105114:	89 75 08             	mov    %esi,0x8(%ebp)
}
80105117:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010511a:	5b                   	pop    %ebx
8010511b:	5e                   	pop    %esi
8010511c:	5d                   	pop    %ebp
  release(&lk->lk);
8010511d:	e9 9e 02 00 00       	jmp    801053c0 <release>
80105122:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105129:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105130 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
80105130:	55                   	push   %ebp
80105131:	89 e5                	mov    %esp,%ebp
80105133:	56                   	push   %esi
80105134:	53                   	push   %ebx
80105135:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
80105138:	83 ec 0c             	sub    $0xc,%esp
8010513b:	8d 73 04             	lea    0x4(%ebx),%esi
8010513e:	56                   	push   %esi
8010513f:	e8 bc 01 00 00       	call   80105300 <acquire>
  lk->locked = 0;
80105144:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
8010514a:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  wakeup(lk);
80105151:	89 1c 24             	mov    %ebx,(%esp)
80105154:	e8 d7 f9 ff ff       	call   80104b30 <wakeup>
  release(&lk->lk);
80105159:	89 75 08             	mov    %esi,0x8(%ebp)
8010515c:	83 c4 10             	add    $0x10,%esp
}
8010515f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105162:	5b                   	pop    %ebx
80105163:	5e                   	pop    %esi
80105164:	5d                   	pop    %ebp
  release(&lk->lk);
80105165:	e9 56 02 00 00       	jmp    801053c0 <release>
8010516a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80105170 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
80105170:	55                   	push   %ebp
80105171:	89 e5                	mov    %esp,%ebp
80105173:	57                   	push   %edi
80105174:	56                   	push   %esi
80105175:	53                   	push   %ebx
80105176:	31 ff                	xor    %edi,%edi
80105178:	83 ec 18             	sub    $0x18,%esp
8010517b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int r;
  
  acquire(&lk->lk);
8010517e:	8d 73 04             	lea    0x4(%ebx),%esi
80105181:	56                   	push   %esi
80105182:	e8 79 01 00 00       	call   80105300 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
80105187:	8b 03                	mov    (%ebx),%eax
80105189:	83 c4 10             	add    $0x10,%esp
8010518c:	85 c0                	test   %eax,%eax
8010518e:	74 13                	je     801051a3 <holdingsleep+0x33>
80105190:	8b 5b 3c             	mov    0x3c(%ebx),%ebx
80105193:	e8 08 e7 ff ff       	call   801038a0 <myproc>
80105198:	39 58 10             	cmp    %ebx,0x10(%eax)
8010519b:	0f 94 c0             	sete   %al
8010519e:	0f b6 c0             	movzbl %al,%eax
801051a1:	89 c7                	mov    %eax,%edi
  release(&lk->lk);
801051a3:	83 ec 0c             	sub    $0xc,%esp
801051a6:	56                   	push   %esi
801051a7:	e8 14 02 00 00       	call   801053c0 <release>
  return r;
}
801051ac:	8d 65 f4             	lea    -0xc(%ebp),%esp
801051af:	89 f8                	mov    %edi,%eax
801051b1:	5b                   	pop    %ebx
801051b2:	5e                   	pop    %esi
801051b3:	5f                   	pop    %edi
801051b4:	5d                   	pop    %ebp
801051b5:	c3                   	ret    
801051b6:	66 90                	xchg   %ax,%ax
801051b8:	66 90                	xchg   %ax,%ax
801051ba:	66 90                	xchg   %ax,%ax
801051bc:	66 90                	xchg   %ax,%ax
801051be:	66 90                	xchg   %ax,%ax

801051c0 <initlock>:
#include "proc.h"
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
801051c0:	55                   	push   %ebp
801051c1:	89 e5                	mov    %esp,%ebp
801051c3:	8b 45 08             	mov    0x8(%ebp),%eax
  lk->name = name;
801051c6:	8b 55 0c             	mov    0xc(%ebp),%edx
  lk->locked = 0;
801051c9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  lk->name = name;
801051cf:	89 50 04             	mov    %edx,0x4(%eax)
  lk->cpu = 0;
801051d2:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
801051d9:	5d                   	pop    %ebp
801051da:	c3                   	ret    
801051db:	90                   	nop
801051dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801051e0 <getcallerpcs>:
}

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
801051e0:	55                   	push   %ebp
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
801051e1:	31 d2                	xor    %edx,%edx
{
801051e3:	89 e5                	mov    %esp,%ebp
801051e5:	53                   	push   %ebx
  ebp = (uint*)v - 2;
801051e6:	8b 45 08             	mov    0x8(%ebp),%eax
{
801051e9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  ebp = (uint*)v - 2;
801051ec:	83 e8 08             	sub    $0x8,%eax
801051ef:	90                   	nop
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
801051f0:	8d 98 00 00 00 80    	lea    -0x80000000(%eax),%ebx
801051f6:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
801051fc:	77 1a                	ja     80105218 <getcallerpcs+0x38>
      break;
    pcs[i] = ebp[1];     // saved %eip
801051fe:	8b 58 04             	mov    0x4(%eax),%ebx
80105201:	89 1c 91             	mov    %ebx,(%ecx,%edx,4)
  for(i = 0; i < 10; i++){
80105204:	83 c2 01             	add    $0x1,%edx
    ebp = (uint*)ebp[0]; // saved %ebp
80105207:	8b 00                	mov    (%eax),%eax
  for(i = 0; i < 10; i++){
80105209:	83 fa 0a             	cmp    $0xa,%edx
8010520c:	75 e2                	jne    801051f0 <getcallerpcs+0x10>
  }
  for(; i < 10; i++)
    pcs[i] = 0;
}
8010520e:	5b                   	pop    %ebx
8010520f:	5d                   	pop    %ebp
80105210:	c3                   	ret    
80105211:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105218:	8d 04 91             	lea    (%ecx,%edx,4),%eax
8010521b:	83 c1 28             	add    $0x28,%ecx
8010521e:	66 90                	xchg   %ax,%ax
    pcs[i] = 0;
80105220:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
80105226:	83 c0 04             	add    $0x4,%eax
  for(; i < 10; i++)
80105229:	39 c1                	cmp    %eax,%ecx
8010522b:	75 f3                	jne    80105220 <getcallerpcs+0x40>
}
8010522d:	5b                   	pop    %ebx
8010522e:	5d                   	pop    %ebp
8010522f:	c3                   	ret    

80105230 <pushcli>:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
pushcli(void)
{
80105230:	55                   	push   %ebp
80105231:	89 e5                	mov    %esp,%ebp
80105233:	53                   	push   %ebx
80105234:	83 ec 04             	sub    $0x4,%esp
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80105237:	9c                   	pushf  
80105238:	5b                   	pop    %ebx
  asm volatile("cli");
80105239:	fa                   	cli    
  int eflags;

  eflags = readeflags();
  cli();
  if(mycpu()->ncli == 0)
8010523a:	e8 c1 e5 ff ff       	call   80103800 <mycpu>
8010523f:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
80105245:	85 c0                	test   %eax,%eax
80105247:	75 11                	jne    8010525a <pushcli+0x2a>
    mycpu()->intena = eflags & FL_IF;
80105249:	81 e3 00 02 00 00    	and    $0x200,%ebx
8010524f:	e8 ac e5 ff ff       	call   80103800 <mycpu>
80105254:	89 98 a8 00 00 00    	mov    %ebx,0xa8(%eax)
  mycpu()->ncli += 1;
8010525a:	e8 a1 e5 ff ff       	call   80103800 <mycpu>
8010525f:	83 80 a4 00 00 00 01 	addl   $0x1,0xa4(%eax)
}
80105266:	83 c4 04             	add    $0x4,%esp
80105269:	5b                   	pop    %ebx
8010526a:	5d                   	pop    %ebp
8010526b:	c3                   	ret    
8010526c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105270 <popcli>:

void
popcli(void)
{
80105270:	55                   	push   %ebp
80105271:	89 e5                	mov    %esp,%ebp
80105273:	83 ec 08             	sub    $0x8,%esp
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80105276:	9c                   	pushf  
80105277:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80105278:	f6 c4 02             	test   $0x2,%ah
8010527b:	75 35                	jne    801052b2 <popcli+0x42>
    panic("popcli - interruptible");
  if(--mycpu()->ncli < 0)
8010527d:	e8 7e e5 ff ff       	call   80103800 <mycpu>
80105282:	83 a8 a4 00 00 00 01 	subl   $0x1,0xa4(%eax)
80105289:	78 34                	js     801052bf <popcli+0x4f>
    panic("popcli");
  if(mycpu()->ncli == 0 && mycpu()->intena)
8010528b:	e8 70 e5 ff ff       	call   80103800 <mycpu>
80105290:	8b 90 a4 00 00 00    	mov    0xa4(%eax),%edx
80105296:	85 d2                	test   %edx,%edx
80105298:	74 06                	je     801052a0 <popcli+0x30>
    sti();
}
8010529a:	c9                   	leave  
8010529b:	c3                   	ret    
8010529c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if(mycpu()->ncli == 0 && mycpu()->intena)
801052a0:	e8 5b e5 ff ff       	call   80103800 <mycpu>
801052a5:	8b 80 a8 00 00 00    	mov    0xa8(%eax),%eax
801052ab:	85 c0                	test   %eax,%eax
801052ad:	74 eb                	je     8010529a <popcli+0x2a>
  asm volatile("sti");
801052af:	fb                   	sti    
}
801052b0:	c9                   	leave  
801052b1:	c3                   	ret    
    panic("popcli - interruptible");
801052b2:	83 ec 0c             	sub    $0xc,%esp
801052b5:	68 eb 87 10 80       	push   $0x801087eb
801052ba:	e8 d1 b0 ff ff       	call   80100390 <panic>
    panic("popcli");
801052bf:	83 ec 0c             	sub    $0xc,%esp
801052c2:	68 02 88 10 80       	push   $0x80108802
801052c7:	e8 c4 b0 ff ff       	call   80100390 <panic>
801052cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801052d0 <holding>:
{
801052d0:	55                   	push   %ebp
801052d1:	89 e5                	mov    %esp,%ebp
801052d3:	56                   	push   %esi
801052d4:	53                   	push   %ebx
801052d5:	8b 75 08             	mov    0x8(%ebp),%esi
801052d8:	31 db                	xor    %ebx,%ebx
  pushcli();
801052da:	e8 51 ff ff ff       	call   80105230 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
801052df:	8b 06                	mov    (%esi),%eax
801052e1:	85 c0                	test   %eax,%eax
801052e3:	74 10                	je     801052f5 <holding+0x25>
801052e5:	8b 5e 08             	mov    0x8(%esi),%ebx
801052e8:	e8 13 e5 ff ff       	call   80103800 <mycpu>
801052ed:	39 c3                	cmp    %eax,%ebx
801052ef:	0f 94 c3             	sete   %bl
801052f2:	0f b6 db             	movzbl %bl,%ebx
  popcli();
801052f5:	e8 76 ff ff ff       	call   80105270 <popcli>
}
801052fa:	89 d8                	mov    %ebx,%eax
801052fc:	5b                   	pop    %ebx
801052fd:	5e                   	pop    %esi
801052fe:	5d                   	pop    %ebp
801052ff:	c3                   	ret    

80105300 <acquire>:
{
80105300:	55                   	push   %ebp
80105301:	89 e5                	mov    %esp,%ebp
80105303:	56                   	push   %esi
80105304:	53                   	push   %ebx
  pushcli(); // disable interrupts to avoid deadlock.
80105305:	e8 26 ff ff ff       	call   80105230 <pushcli>
  if(holding(lk))
8010530a:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010530d:	83 ec 0c             	sub    $0xc,%esp
80105310:	53                   	push   %ebx
80105311:	e8 ba ff ff ff       	call   801052d0 <holding>
80105316:	83 c4 10             	add    $0x10,%esp
80105319:	85 c0                	test   %eax,%eax
8010531b:	0f 85 83 00 00 00    	jne    801053a4 <acquire+0xa4>
80105321:	89 c6                	mov    %eax,%esi
  asm volatile("lock; xchgl %0, %1" :
80105323:	ba 01 00 00 00       	mov    $0x1,%edx
80105328:	eb 09                	jmp    80105333 <acquire+0x33>
8010532a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80105330:	8b 5d 08             	mov    0x8(%ebp),%ebx
80105333:	89 d0                	mov    %edx,%eax
80105335:	f0 87 03             	lock xchg %eax,(%ebx)
  while(xchg(&lk->locked, 1) != 0)
80105338:	85 c0                	test   %eax,%eax
8010533a:	75 f4                	jne    80105330 <acquire+0x30>
  __sync_synchronize();
8010533c:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  lk->cpu = mycpu();
80105341:	8b 5d 08             	mov    0x8(%ebp),%ebx
80105344:	e8 b7 e4 ff ff       	call   80103800 <mycpu>
  getcallerpcs(&lk, lk->pcs);
80105349:	8d 53 0c             	lea    0xc(%ebx),%edx
  lk->cpu = mycpu();
8010534c:	89 43 08             	mov    %eax,0x8(%ebx)
  ebp = (uint*)v - 2;
8010534f:	89 e8                	mov    %ebp,%eax
80105351:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80105358:	8d 88 00 00 00 80    	lea    -0x80000000(%eax),%ecx
8010535e:	81 f9 fe ff ff 7f    	cmp    $0x7ffffffe,%ecx
80105364:	77 1a                	ja     80105380 <acquire+0x80>
    pcs[i] = ebp[1];     // saved %eip
80105366:	8b 48 04             	mov    0x4(%eax),%ecx
80105369:	89 0c b2             	mov    %ecx,(%edx,%esi,4)
  for(i = 0; i < 10; i++){
8010536c:	83 c6 01             	add    $0x1,%esi
    ebp = (uint*)ebp[0]; // saved %ebp
8010536f:	8b 00                	mov    (%eax),%eax
  for(i = 0; i < 10; i++){
80105371:	83 fe 0a             	cmp    $0xa,%esi
80105374:	75 e2                	jne    80105358 <acquire+0x58>
}
80105376:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105379:	5b                   	pop    %ebx
8010537a:	5e                   	pop    %esi
8010537b:	5d                   	pop    %ebp
8010537c:	c3                   	ret    
8010537d:	8d 76 00             	lea    0x0(%esi),%esi
80105380:	8d 04 b2             	lea    (%edx,%esi,4),%eax
80105383:	83 c2 28             	add    $0x28,%edx
80105386:	8d 76 00             	lea    0x0(%esi),%esi
80105389:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    pcs[i] = 0;
80105390:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
80105396:	83 c0 04             	add    $0x4,%eax
  for(; i < 10; i++)
80105399:	39 d0                	cmp    %edx,%eax
8010539b:	75 f3                	jne    80105390 <acquire+0x90>
}
8010539d:	8d 65 f8             	lea    -0x8(%ebp),%esp
801053a0:	5b                   	pop    %ebx
801053a1:	5e                   	pop    %esi
801053a2:	5d                   	pop    %ebp
801053a3:	c3                   	ret    
    panic("acquire");
801053a4:	83 ec 0c             	sub    $0xc,%esp
801053a7:	68 09 88 10 80       	push   $0x80108809
801053ac:	e8 df af ff ff       	call   80100390 <panic>
801053b1:	eb 0d                	jmp    801053c0 <release>
801053b3:	90                   	nop
801053b4:	90                   	nop
801053b5:	90                   	nop
801053b6:	90                   	nop
801053b7:	90                   	nop
801053b8:	90                   	nop
801053b9:	90                   	nop
801053ba:	90                   	nop
801053bb:	90                   	nop
801053bc:	90                   	nop
801053bd:	90                   	nop
801053be:	90                   	nop
801053bf:	90                   	nop

801053c0 <release>:
{
801053c0:	55                   	push   %ebp
801053c1:	89 e5                	mov    %esp,%ebp
801053c3:	53                   	push   %ebx
801053c4:	83 ec 10             	sub    $0x10,%esp
801053c7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holding(lk))
801053ca:	53                   	push   %ebx
801053cb:	e8 00 ff ff ff       	call   801052d0 <holding>
801053d0:	83 c4 10             	add    $0x10,%esp
801053d3:	85 c0                	test   %eax,%eax
801053d5:	74 22                	je     801053f9 <release+0x39>
  lk->pcs[0] = 0;
801053d7:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
  lk->cpu = 0;
801053de:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
  __sync_synchronize();
801053e5:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  asm volatile("movl $0, %0" : "+m" (lk->locked) : );
801053ea:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
}
801053f0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801053f3:	c9                   	leave  
  popcli();
801053f4:	e9 77 fe ff ff       	jmp    80105270 <popcli>
    panic("release");
801053f9:	83 ec 0c             	sub    $0xc,%esp
801053fc:	68 11 88 10 80       	push   $0x80108811
80105401:	e8 8a af ff ff       	call   80100390 <panic>
80105406:	66 90                	xchg   %ax,%ax
80105408:	66 90                	xchg   %ax,%ax
8010540a:	66 90                	xchg   %ax,%ax
8010540c:	66 90                	xchg   %ax,%ax
8010540e:	66 90                	xchg   %ax,%ax

80105410 <memset>:
#include "types.h"
#include "x86.h"

void*
memset(void *dst, int c, uint n)
{
80105410:	55                   	push   %ebp
80105411:	89 e5                	mov    %esp,%ebp
80105413:	57                   	push   %edi
80105414:	53                   	push   %ebx
80105415:	8b 55 08             	mov    0x8(%ebp),%edx
80105418:	8b 4d 10             	mov    0x10(%ebp),%ecx
  if ((int)dst%4 == 0 && n%4 == 0){
8010541b:	f6 c2 03             	test   $0x3,%dl
8010541e:	75 05                	jne    80105425 <memset+0x15>
80105420:	f6 c1 03             	test   $0x3,%cl
80105423:	74 13                	je     80105438 <memset+0x28>
  asm volatile("cld; rep stosb" :
80105425:	89 d7                	mov    %edx,%edi
80105427:	8b 45 0c             	mov    0xc(%ebp),%eax
8010542a:	fc                   	cld    
8010542b:	f3 aa                	rep stos %al,%es:(%edi)
    c &= 0xFF;
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
  } else
    stosb(dst, c, n);
  return dst;
}
8010542d:	5b                   	pop    %ebx
8010542e:	89 d0                	mov    %edx,%eax
80105430:	5f                   	pop    %edi
80105431:	5d                   	pop    %ebp
80105432:	c3                   	ret    
80105433:	90                   	nop
80105434:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    c &= 0xFF;
80105438:	0f b6 7d 0c          	movzbl 0xc(%ebp),%edi
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
8010543c:	c1 e9 02             	shr    $0x2,%ecx
8010543f:	89 f8                	mov    %edi,%eax
80105441:	89 fb                	mov    %edi,%ebx
80105443:	c1 e0 18             	shl    $0x18,%eax
80105446:	c1 e3 10             	shl    $0x10,%ebx
80105449:	09 d8                	or     %ebx,%eax
8010544b:	09 f8                	or     %edi,%eax
8010544d:	c1 e7 08             	shl    $0x8,%edi
80105450:	09 f8                	or     %edi,%eax
  asm volatile("cld; rep stosl" :
80105452:	89 d7                	mov    %edx,%edi
80105454:	fc                   	cld    
80105455:	f3 ab                	rep stos %eax,%es:(%edi)
}
80105457:	5b                   	pop    %ebx
80105458:	89 d0                	mov    %edx,%eax
8010545a:	5f                   	pop    %edi
8010545b:	5d                   	pop    %ebp
8010545c:	c3                   	ret    
8010545d:	8d 76 00             	lea    0x0(%esi),%esi

80105460 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
80105460:	55                   	push   %ebp
80105461:	89 e5                	mov    %esp,%ebp
80105463:	57                   	push   %edi
80105464:	56                   	push   %esi
80105465:	53                   	push   %ebx
80105466:	8b 5d 10             	mov    0x10(%ebp),%ebx
80105469:	8b 75 08             	mov    0x8(%ebp),%esi
8010546c:	8b 7d 0c             	mov    0xc(%ebp),%edi
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
8010546f:	85 db                	test   %ebx,%ebx
80105471:	74 29                	je     8010549c <memcmp+0x3c>
    if(*s1 != *s2)
80105473:	0f b6 16             	movzbl (%esi),%edx
80105476:	0f b6 0f             	movzbl (%edi),%ecx
80105479:	38 d1                	cmp    %dl,%cl
8010547b:	75 2b                	jne    801054a8 <memcmp+0x48>
8010547d:	b8 01 00 00 00       	mov    $0x1,%eax
80105482:	eb 14                	jmp    80105498 <memcmp+0x38>
80105484:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105488:	0f b6 14 06          	movzbl (%esi,%eax,1),%edx
8010548c:	83 c0 01             	add    $0x1,%eax
8010548f:	0f b6 4c 07 ff       	movzbl -0x1(%edi,%eax,1),%ecx
80105494:	38 ca                	cmp    %cl,%dl
80105496:	75 10                	jne    801054a8 <memcmp+0x48>
  while(n-- > 0){
80105498:	39 d8                	cmp    %ebx,%eax
8010549a:	75 ec                	jne    80105488 <memcmp+0x28>
      return *s1 - *s2;
    s1++, s2++;
  }

  return 0;
}
8010549c:	5b                   	pop    %ebx
  return 0;
8010549d:	31 c0                	xor    %eax,%eax
}
8010549f:	5e                   	pop    %esi
801054a0:	5f                   	pop    %edi
801054a1:	5d                   	pop    %ebp
801054a2:	c3                   	ret    
801054a3:	90                   	nop
801054a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      return *s1 - *s2;
801054a8:	0f b6 c2             	movzbl %dl,%eax
}
801054ab:	5b                   	pop    %ebx
      return *s1 - *s2;
801054ac:	29 c8                	sub    %ecx,%eax
}
801054ae:	5e                   	pop    %esi
801054af:	5f                   	pop    %edi
801054b0:	5d                   	pop    %ebp
801054b1:	c3                   	ret    
801054b2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801054b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801054c0 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
801054c0:	55                   	push   %ebp
801054c1:	89 e5                	mov    %esp,%ebp
801054c3:	56                   	push   %esi
801054c4:	53                   	push   %ebx
801054c5:	8b 45 08             	mov    0x8(%ebp),%eax
801054c8:	8b 5d 0c             	mov    0xc(%ebp),%ebx
801054cb:	8b 75 10             	mov    0x10(%ebp),%esi
  const char *s;
  char *d;

  s = src;
  d = dst;
  if(s < d && s + n > d){
801054ce:	39 c3                	cmp    %eax,%ebx
801054d0:	73 26                	jae    801054f8 <memmove+0x38>
801054d2:	8d 0c 33             	lea    (%ebx,%esi,1),%ecx
801054d5:	39 c8                	cmp    %ecx,%eax
801054d7:	73 1f                	jae    801054f8 <memmove+0x38>
    s += n;
    d += n;
    while(n-- > 0)
801054d9:	85 f6                	test   %esi,%esi
801054db:	8d 56 ff             	lea    -0x1(%esi),%edx
801054de:	74 0f                	je     801054ef <memmove+0x2f>
      *--d = *--s;
801054e0:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
801054e4:	88 0c 10             	mov    %cl,(%eax,%edx,1)
    while(n-- > 0)
801054e7:	83 ea 01             	sub    $0x1,%edx
801054ea:	83 fa ff             	cmp    $0xffffffff,%edx
801054ed:	75 f1                	jne    801054e0 <memmove+0x20>
  } else
    while(n-- > 0)
      *d++ = *s++;

  return dst;
}
801054ef:	5b                   	pop    %ebx
801054f0:	5e                   	pop    %esi
801054f1:	5d                   	pop    %ebp
801054f2:	c3                   	ret    
801054f3:	90                   	nop
801054f4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    while(n-- > 0)
801054f8:	31 d2                	xor    %edx,%edx
801054fa:	85 f6                	test   %esi,%esi
801054fc:	74 f1                	je     801054ef <memmove+0x2f>
801054fe:	66 90                	xchg   %ax,%ax
      *d++ = *s++;
80105500:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
80105504:	88 0c 10             	mov    %cl,(%eax,%edx,1)
80105507:	83 c2 01             	add    $0x1,%edx
    while(n-- > 0)
8010550a:	39 d6                	cmp    %edx,%esi
8010550c:	75 f2                	jne    80105500 <memmove+0x40>
}
8010550e:	5b                   	pop    %ebx
8010550f:	5e                   	pop    %esi
80105510:	5d                   	pop    %ebp
80105511:	c3                   	ret    
80105512:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105519:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105520 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
80105520:	55                   	push   %ebp
80105521:	89 e5                	mov    %esp,%ebp
  return memmove(dst, src, n);
}
80105523:	5d                   	pop    %ebp
  return memmove(dst, src, n);
80105524:	eb 9a                	jmp    801054c0 <memmove>
80105526:	8d 76 00             	lea    0x0(%esi),%esi
80105529:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105530 <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
80105530:	55                   	push   %ebp
80105531:	89 e5                	mov    %esp,%ebp
80105533:	57                   	push   %edi
80105534:	56                   	push   %esi
80105535:	8b 7d 10             	mov    0x10(%ebp),%edi
80105538:	53                   	push   %ebx
80105539:	8b 4d 08             	mov    0x8(%ebp),%ecx
8010553c:	8b 75 0c             	mov    0xc(%ebp),%esi
  while(n > 0 && *p && *p == *q)
8010553f:	85 ff                	test   %edi,%edi
80105541:	74 2f                	je     80105572 <strncmp+0x42>
80105543:	0f b6 01             	movzbl (%ecx),%eax
80105546:	0f b6 1e             	movzbl (%esi),%ebx
80105549:	84 c0                	test   %al,%al
8010554b:	74 37                	je     80105584 <strncmp+0x54>
8010554d:	38 c3                	cmp    %al,%bl
8010554f:	75 33                	jne    80105584 <strncmp+0x54>
80105551:	01 f7                	add    %esi,%edi
80105553:	eb 13                	jmp    80105568 <strncmp+0x38>
80105555:	8d 76 00             	lea    0x0(%esi),%esi
80105558:	0f b6 01             	movzbl (%ecx),%eax
8010555b:	84 c0                	test   %al,%al
8010555d:	74 21                	je     80105580 <strncmp+0x50>
8010555f:	0f b6 1a             	movzbl (%edx),%ebx
80105562:	89 d6                	mov    %edx,%esi
80105564:	38 d8                	cmp    %bl,%al
80105566:	75 1c                	jne    80105584 <strncmp+0x54>
    n--, p++, q++;
80105568:	8d 56 01             	lea    0x1(%esi),%edx
8010556b:	83 c1 01             	add    $0x1,%ecx
  while(n > 0 && *p && *p == *q)
8010556e:	39 fa                	cmp    %edi,%edx
80105570:	75 e6                	jne    80105558 <strncmp+0x28>
  if(n == 0)
    return 0;
  return (uchar)*p - (uchar)*q;
}
80105572:	5b                   	pop    %ebx
    return 0;
80105573:	31 c0                	xor    %eax,%eax
}
80105575:	5e                   	pop    %esi
80105576:	5f                   	pop    %edi
80105577:	5d                   	pop    %ebp
80105578:	c3                   	ret    
80105579:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105580:	0f b6 5e 01          	movzbl 0x1(%esi),%ebx
  return (uchar)*p - (uchar)*q;
80105584:	29 d8                	sub    %ebx,%eax
}
80105586:	5b                   	pop    %ebx
80105587:	5e                   	pop    %esi
80105588:	5f                   	pop    %edi
80105589:	5d                   	pop    %ebp
8010558a:	c3                   	ret    
8010558b:	90                   	nop
8010558c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105590 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
80105590:	55                   	push   %ebp
80105591:	89 e5                	mov    %esp,%ebp
80105593:	56                   	push   %esi
80105594:	53                   	push   %ebx
80105595:	8b 45 08             	mov    0x8(%ebp),%eax
80105598:	8b 5d 0c             	mov    0xc(%ebp),%ebx
8010559b:	8b 4d 10             	mov    0x10(%ebp),%ecx
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
8010559e:	89 c2                	mov    %eax,%edx
801055a0:	eb 19                	jmp    801055bb <strncpy+0x2b>
801055a2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801055a8:	83 c3 01             	add    $0x1,%ebx
801055ab:	0f b6 4b ff          	movzbl -0x1(%ebx),%ecx
801055af:	83 c2 01             	add    $0x1,%edx
801055b2:	84 c9                	test   %cl,%cl
801055b4:	88 4a ff             	mov    %cl,-0x1(%edx)
801055b7:	74 09                	je     801055c2 <strncpy+0x32>
801055b9:	89 f1                	mov    %esi,%ecx
801055bb:	85 c9                	test   %ecx,%ecx
801055bd:	8d 71 ff             	lea    -0x1(%ecx),%esi
801055c0:	7f e6                	jg     801055a8 <strncpy+0x18>
    ;
  while(n-- > 0)
801055c2:	31 c9                	xor    %ecx,%ecx
801055c4:	85 f6                	test   %esi,%esi
801055c6:	7e 17                	jle    801055df <strncpy+0x4f>
801055c8:	90                   	nop
801055c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    *s++ = 0;
801055d0:	c6 04 0a 00          	movb   $0x0,(%edx,%ecx,1)
801055d4:	89 f3                	mov    %esi,%ebx
801055d6:	83 c1 01             	add    $0x1,%ecx
801055d9:	29 cb                	sub    %ecx,%ebx
  while(n-- > 0)
801055db:	85 db                	test   %ebx,%ebx
801055dd:	7f f1                	jg     801055d0 <strncpy+0x40>
  return os;
}
801055df:	5b                   	pop    %ebx
801055e0:	5e                   	pop    %esi
801055e1:	5d                   	pop    %ebp
801055e2:	c3                   	ret    
801055e3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801055e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801055f0 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
801055f0:	55                   	push   %ebp
801055f1:	89 e5                	mov    %esp,%ebp
801055f3:	56                   	push   %esi
801055f4:	53                   	push   %ebx
801055f5:	8b 4d 10             	mov    0x10(%ebp),%ecx
801055f8:	8b 45 08             	mov    0x8(%ebp),%eax
801055fb:	8b 55 0c             	mov    0xc(%ebp),%edx
  char *os;

  os = s;
  if(n <= 0)
801055fe:	85 c9                	test   %ecx,%ecx
80105600:	7e 26                	jle    80105628 <safestrcpy+0x38>
80105602:	8d 74 0a ff          	lea    -0x1(%edx,%ecx,1),%esi
80105606:	89 c1                	mov    %eax,%ecx
80105608:	eb 17                	jmp    80105621 <safestrcpy+0x31>
8010560a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
80105610:	83 c2 01             	add    $0x1,%edx
80105613:	0f b6 5a ff          	movzbl -0x1(%edx),%ebx
80105617:	83 c1 01             	add    $0x1,%ecx
8010561a:	84 db                	test   %bl,%bl
8010561c:	88 59 ff             	mov    %bl,-0x1(%ecx)
8010561f:	74 04                	je     80105625 <safestrcpy+0x35>
80105621:	39 f2                	cmp    %esi,%edx
80105623:	75 eb                	jne    80105610 <safestrcpy+0x20>
    ;
  *s = 0;
80105625:	c6 01 00             	movb   $0x0,(%ecx)
  return os;
}
80105628:	5b                   	pop    %ebx
80105629:	5e                   	pop    %esi
8010562a:	5d                   	pop    %ebp
8010562b:	c3                   	ret    
8010562c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105630 <strlen>:

int
strlen(const char *s)
{
80105630:	55                   	push   %ebp
  int n;

  for(n = 0; s[n]; n++)
80105631:	31 c0                	xor    %eax,%eax
{
80105633:	89 e5                	mov    %esp,%ebp
80105635:	8b 55 08             	mov    0x8(%ebp),%edx
  for(n = 0; s[n]; n++)
80105638:	80 3a 00             	cmpb   $0x0,(%edx)
8010563b:	74 0c                	je     80105649 <strlen+0x19>
8010563d:	8d 76 00             	lea    0x0(%esi),%esi
80105640:	83 c0 01             	add    $0x1,%eax
80105643:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
80105647:	75 f7                	jne    80105640 <strlen+0x10>
    ;
  return n;
}
80105649:	5d                   	pop    %ebp
8010564a:	c3                   	ret    

8010564b <swtch>:
# a struct context, and save its address in *old.
# Switch stacks to new and pop previously-saved registers.

.globl swtch
swtch:
  movl 4(%esp), %eax
8010564b:	8b 44 24 04          	mov    0x4(%esp),%eax
  movl 8(%esp), %edx
8010564f:	8b 54 24 08          	mov    0x8(%esp),%edx

  # Save old callee-saved registers
  pushl %ebp
80105653:	55                   	push   %ebp
  pushl %ebx
80105654:	53                   	push   %ebx
  pushl %esi
80105655:	56                   	push   %esi
  pushl %edi
80105656:	57                   	push   %edi

  # Switch stacks
  movl %esp, (%eax)
80105657:	89 20                	mov    %esp,(%eax)
  movl %edx, %esp
80105659:	89 d4                	mov    %edx,%esp

  # Load new callee-saved registers
  popl %edi
8010565b:	5f                   	pop    %edi
  popl %esi
8010565c:	5e                   	pop    %esi
  popl %ebx
8010565d:	5b                   	pop    %ebx
  popl %ebp
8010565e:	5d                   	pop    %ebp
  ret
8010565f:	c3                   	ret    

80105660 <fetchint>:
// to a saved program counter, and then the first argument.

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
80105660:	55                   	push   %ebp
80105661:	89 e5                	mov    %esp,%ebp
80105663:	53                   	push   %ebx
80105664:	83 ec 04             	sub    $0x4,%esp
80105667:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *curproc = myproc();
8010566a:	e8 31 e2 ff ff       	call   801038a0 <myproc>

  if(addr >= curproc->sz || addr+4 > curproc->sz)
8010566f:	8b 00                	mov    (%eax),%eax
80105671:	39 d8                	cmp    %ebx,%eax
80105673:	76 1b                	jbe    80105690 <fetchint+0x30>
80105675:	8d 53 04             	lea    0x4(%ebx),%edx
80105678:	39 d0                	cmp    %edx,%eax
8010567a:	72 14                	jb     80105690 <fetchint+0x30>
    return -1;
  *ip = *(int*)(addr);
8010567c:	8b 45 0c             	mov    0xc(%ebp),%eax
8010567f:	8b 13                	mov    (%ebx),%edx
80105681:	89 10                	mov    %edx,(%eax)
  return 0;
80105683:	31 c0                	xor    %eax,%eax
}
80105685:	83 c4 04             	add    $0x4,%esp
80105688:	5b                   	pop    %ebx
80105689:	5d                   	pop    %ebp
8010568a:	c3                   	ret    
8010568b:	90                   	nop
8010568c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80105690:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105695:	eb ee                	jmp    80105685 <fetchint+0x25>
80105697:	89 f6                	mov    %esi,%esi
80105699:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801056a0 <fetchstr>:
// Fetch the nul-terminated string at addr from the current process.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(uint addr, char **pp)
{
801056a0:	55                   	push   %ebp
801056a1:	89 e5                	mov    %esp,%ebp
801056a3:	53                   	push   %ebx
801056a4:	83 ec 04             	sub    $0x4,%esp
801056a7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  char *s, *ep;
  struct proc *curproc = myproc();
801056aa:	e8 f1 e1 ff ff       	call   801038a0 <myproc>

  if(addr >= curproc->sz)
801056af:	39 18                	cmp    %ebx,(%eax)
801056b1:	76 29                	jbe    801056dc <fetchstr+0x3c>
    return -1;
  *pp = (char*)addr;
801056b3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
801056b6:	89 da                	mov    %ebx,%edx
801056b8:	89 19                	mov    %ebx,(%ecx)
  ep = (char*)curproc->sz;
801056ba:	8b 00                	mov    (%eax),%eax
  for(s = *pp; s < ep; s++){
801056bc:	39 c3                	cmp    %eax,%ebx
801056be:	73 1c                	jae    801056dc <fetchstr+0x3c>
    if(*s == 0)
801056c0:	80 3b 00             	cmpb   $0x0,(%ebx)
801056c3:	75 10                	jne    801056d5 <fetchstr+0x35>
801056c5:	eb 39                	jmp    80105700 <fetchstr+0x60>
801056c7:	89 f6                	mov    %esi,%esi
801056c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
801056d0:	80 3a 00             	cmpb   $0x0,(%edx)
801056d3:	74 1b                	je     801056f0 <fetchstr+0x50>
  for(s = *pp; s < ep; s++){
801056d5:	83 c2 01             	add    $0x1,%edx
801056d8:	39 d0                	cmp    %edx,%eax
801056da:	77 f4                	ja     801056d0 <fetchstr+0x30>
    return -1;
801056dc:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
      return s - *pp;
  }
  return -1;
}
801056e1:	83 c4 04             	add    $0x4,%esp
801056e4:	5b                   	pop    %ebx
801056e5:	5d                   	pop    %ebp
801056e6:	c3                   	ret    
801056e7:	89 f6                	mov    %esi,%esi
801056e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
801056f0:	83 c4 04             	add    $0x4,%esp
801056f3:	89 d0                	mov    %edx,%eax
801056f5:	29 d8                	sub    %ebx,%eax
801056f7:	5b                   	pop    %ebx
801056f8:	5d                   	pop    %ebp
801056f9:	c3                   	ret    
801056fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(*s == 0)
80105700:	31 c0                	xor    %eax,%eax
      return s - *pp;
80105702:	eb dd                	jmp    801056e1 <fetchstr+0x41>
80105704:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010570a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80105710 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
80105710:	55                   	push   %ebp
80105711:	89 e5                	mov    %esp,%ebp
80105713:	56                   	push   %esi
80105714:	53                   	push   %ebx
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80105715:	e8 86 e1 ff ff       	call   801038a0 <myproc>
8010571a:	8b 40 18             	mov    0x18(%eax),%eax
8010571d:	8b 55 08             	mov    0x8(%ebp),%edx
80105720:	8b 40 44             	mov    0x44(%eax),%eax
80105723:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
  struct proc *curproc = myproc();
80105726:	e8 75 e1 ff ff       	call   801038a0 <myproc>
  if(addr >= curproc->sz || addr+4 > curproc->sz)
8010572b:	8b 00                	mov    (%eax),%eax
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
8010572d:	8d 73 04             	lea    0x4(%ebx),%esi
  if(addr >= curproc->sz || addr+4 > curproc->sz)
80105730:	39 c6                	cmp    %eax,%esi
80105732:	73 1c                	jae    80105750 <argint+0x40>
80105734:	8d 53 08             	lea    0x8(%ebx),%edx
80105737:	39 d0                	cmp    %edx,%eax
80105739:	72 15                	jb     80105750 <argint+0x40>
  *ip = *(int*)(addr);
8010573b:	8b 45 0c             	mov    0xc(%ebp),%eax
8010573e:	8b 53 04             	mov    0x4(%ebx),%edx
80105741:	89 10                	mov    %edx,(%eax)
  return 0;
80105743:	31 c0                	xor    %eax,%eax
}
80105745:	5b                   	pop    %ebx
80105746:	5e                   	pop    %esi
80105747:	5d                   	pop    %ebp
80105748:	c3                   	ret    
80105749:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80105750:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80105755:	eb ee                	jmp    80105745 <argint+0x35>
80105757:	89 f6                	mov    %esi,%esi
80105759:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105760 <argptr>:
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size)
{
80105760:	55                   	push   %ebp
80105761:	89 e5                	mov    %esp,%ebp
80105763:	56                   	push   %esi
80105764:	53                   	push   %ebx
80105765:	83 ec 10             	sub    $0x10,%esp
80105768:	8b 5d 10             	mov    0x10(%ebp),%ebx
  int i;
  struct proc *curproc = myproc();
8010576b:	e8 30 e1 ff ff       	call   801038a0 <myproc>
80105770:	89 c6                	mov    %eax,%esi
 
  if(argint(n, &i) < 0)
80105772:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105775:	83 ec 08             	sub    $0x8,%esp
80105778:	50                   	push   %eax
80105779:	ff 75 08             	pushl  0x8(%ebp)
8010577c:	e8 8f ff ff ff       	call   80105710 <argint>
    return -1;
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
80105781:	83 c4 10             	add    $0x10,%esp
80105784:	85 c0                	test   %eax,%eax
80105786:	78 28                	js     801057b0 <argptr+0x50>
80105788:	85 db                	test   %ebx,%ebx
8010578a:	78 24                	js     801057b0 <argptr+0x50>
8010578c:	8b 16                	mov    (%esi),%edx
8010578e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105791:	39 c2                	cmp    %eax,%edx
80105793:	76 1b                	jbe    801057b0 <argptr+0x50>
80105795:	01 c3                	add    %eax,%ebx
80105797:	39 da                	cmp    %ebx,%edx
80105799:	72 15                	jb     801057b0 <argptr+0x50>
    return -1;
  *pp = (char*)i;
8010579b:	8b 55 0c             	mov    0xc(%ebp),%edx
8010579e:	89 02                	mov    %eax,(%edx)
  return 0;
801057a0:	31 c0                	xor    %eax,%eax
}
801057a2:	8d 65 f8             	lea    -0x8(%ebp),%esp
801057a5:	5b                   	pop    %ebx
801057a6:	5e                   	pop    %esi
801057a7:	5d                   	pop    %ebp
801057a8:	c3                   	ret    
801057a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
801057b0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801057b5:	eb eb                	jmp    801057a2 <argptr+0x42>
801057b7:	89 f6                	mov    %esi,%esi
801057b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801057c0 <argstr>:
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
801057c0:	55                   	push   %ebp
801057c1:	89 e5                	mov    %esp,%ebp
801057c3:	83 ec 20             	sub    $0x20,%esp
  int addr;
  if(argint(n, &addr) < 0)
801057c6:	8d 45 f4             	lea    -0xc(%ebp),%eax
801057c9:	50                   	push   %eax
801057ca:	ff 75 08             	pushl  0x8(%ebp)
801057cd:	e8 3e ff ff ff       	call   80105710 <argint>
801057d2:	83 c4 10             	add    $0x10,%esp
801057d5:	85 c0                	test   %eax,%eax
801057d7:	78 17                	js     801057f0 <argstr+0x30>
    return -1;
  return fetchstr(addr, pp);
801057d9:	83 ec 08             	sub    $0x8,%esp
801057dc:	ff 75 0c             	pushl  0xc(%ebp)
801057df:	ff 75 f4             	pushl  -0xc(%ebp)
801057e2:	e8 b9 fe ff ff       	call   801056a0 <fetchstr>
801057e7:	83 c4 10             	add    $0x10,%esp
}
801057ea:	c9                   	leave  
801057eb:	c3                   	ret    
801057ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return -1;
801057f0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801057f5:	c9                   	leave  
801057f6:	c3                   	ret    
801057f7:	89 f6                	mov    %esi,%esi
801057f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105800 <syscall>:

};

void
syscall(void)
{
80105800:	55                   	push   %ebp
80105801:	89 e5                	mov    %esp,%ebp
80105803:	53                   	push   %ebx
80105804:	83 ec 04             	sub    $0x4,%esp
  int num;
  struct proc *curproc = myproc();
80105807:	e8 94 e0 ff ff       	call   801038a0 <myproc>
8010580c:	89 c3                	mov    %eax,%ebx

  num = curproc->tf->eax;
8010580e:	8b 40 18             	mov    0x18(%eax),%eax
80105811:	8b 40 1c             	mov    0x1c(%eax),%eax
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
80105814:	8d 50 ff             	lea    -0x1(%eax),%edx
80105817:	83 fa 18             	cmp    $0x18,%edx
8010581a:	77 1c                	ja     80105838 <syscall+0x38>
8010581c:	8b 14 85 40 88 10 80 	mov    -0x7fef77c0(,%eax,4),%edx
80105823:	85 d2                	test   %edx,%edx
80105825:	74 11                	je     80105838 <syscall+0x38>
    curproc->tf->eax = syscalls[num]();
80105827:	ff d2                	call   *%edx
80105829:	8b 53 18             	mov    0x18(%ebx),%edx
8010582c:	89 42 1c             	mov    %eax,0x1c(%edx)
  } else {
    cprintf("%d %s: unknown sys call %d\n",
            curproc->pid, curproc->name, num);
    curproc->tf->eax = -1;
  }
}
8010582f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105832:	c9                   	leave  
80105833:	c3                   	ret    
80105834:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    cprintf("%d %s: unknown sys call %d\n",
80105838:	50                   	push   %eax
            curproc->pid, curproc->name, num);
80105839:	8d 43 6c             	lea    0x6c(%ebx),%eax
    cprintf("%d %s: unknown sys call %d\n",
8010583c:	50                   	push   %eax
8010583d:	ff 73 10             	pushl  0x10(%ebx)
80105840:	68 19 88 10 80       	push   $0x80108819
80105845:	e8 16 ae ff ff       	call   80100660 <cprintf>
    curproc->tf->eax = -1;
8010584a:	8b 43 18             	mov    0x18(%ebx),%eax
8010584d:	83 c4 10             	add    $0x10,%esp
80105850:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
}
80105857:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010585a:	c9                   	leave  
8010585b:	c3                   	ret    
8010585c:	66 90                	xchg   %ax,%ax
8010585e:	66 90                	xchg   %ax,%ax

80105860 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
80105860:	55                   	push   %ebp
80105861:	89 e5                	mov    %esp,%ebp
80105863:	57                   	push   %edi
80105864:	56                   	push   %esi
80105865:	53                   	push   %ebx
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
80105866:	8d 75 da             	lea    -0x26(%ebp),%esi
{
80105869:	83 ec 34             	sub    $0x34,%esp
8010586c:	89 4d d0             	mov    %ecx,-0x30(%ebp)
8010586f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  if((dp = nameiparent(path, name)) == 0)
80105872:	56                   	push   %esi
80105873:	50                   	push   %eax
{
80105874:	89 55 d4             	mov    %edx,-0x2c(%ebp)
80105877:	89 4d cc             	mov    %ecx,-0x34(%ebp)
  if((dp = nameiparent(path, name)) == 0)
8010587a:	e8 81 c6 ff ff       	call   80101f00 <nameiparent>
8010587f:	83 c4 10             	add    $0x10,%esp
80105882:	85 c0                	test   %eax,%eax
80105884:	0f 84 46 01 00 00    	je     801059d0 <create+0x170>
    return 0;
  ilock(dp);
8010588a:	83 ec 0c             	sub    $0xc,%esp
8010588d:	89 c3                	mov    %eax,%ebx
8010588f:	50                   	push   %eax
80105890:	e8 eb bd ff ff       	call   80101680 <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
80105895:	83 c4 0c             	add    $0xc,%esp
80105898:	6a 00                	push   $0x0
8010589a:	56                   	push   %esi
8010589b:	53                   	push   %ebx
8010589c:	e8 0f c3 ff ff       	call   80101bb0 <dirlookup>
801058a1:	83 c4 10             	add    $0x10,%esp
801058a4:	85 c0                	test   %eax,%eax
801058a6:	89 c7                	mov    %eax,%edi
801058a8:	74 36                	je     801058e0 <create+0x80>
    iunlockput(dp);
801058aa:	83 ec 0c             	sub    $0xc,%esp
801058ad:	53                   	push   %ebx
801058ae:	e8 5d c0 ff ff       	call   80101910 <iunlockput>
    ilock(ip);
801058b3:	89 3c 24             	mov    %edi,(%esp)
801058b6:	e8 c5 bd ff ff       	call   80101680 <ilock>
    if(type == T_FILE && ip->type == T_FILE)
801058bb:	83 c4 10             	add    $0x10,%esp
801058be:	66 83 7d d4 02       	cmpw   $0x2,-0x2c(%ebp)
801058c3:	0f 85 97 00 00 00    	jne    80105960 <create+0x100>
801058c9:	66 83 7f 50 02       	cmpw   $0x2,0x50(%edi)
801058ce:	0f 85 8c 00 00 00    	jne    80105960 <create+0x100>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
801058d4:	8d 65 f4             	lea    -0xc(%ebp),%esp
801058d7:	89 f8                	mov    %edi,%eax
801058d9:	5b                   	pop    %ebx
801058da:	5e                   	pop    %esi
801058db:	5f                   	pop    %edi
801058dc:	5d                   	pop    %ebp
801058dd:	c3                   	ret    
801058de:	66 90                	xchg   %ax,%ax
  if((ip = ialloc(dp->dev, type)) == 0)
801058e0:	0f bf 45 d4          	movswl -0x2c(%ebp),%eax
801058e4:	83 ec 08             	sub    $0x8,%esp
801058e7:	50                   	push   %eax
801058e8:	ff 33                	pushl  (%ebx)
801058ea:	e8 21 bc ff ff       	call   80101510 <ialloc>
801058ef:	83 c4 10             	add    $0x10,%esp
801058f2:	85 c0                	test   %eax,%eax
801058f4:	89 c7                	mov    %eax,%edi
801058f6:	0f 84 e8 00 00 00    	je     801059e4 <create+0x184>
  ilock(ip);
801058fc:	83 ec 0c             	sub    $0xc,%esp
801058ff:	50                   	push   %eax
80105900:	e8 7b bd ff ff       	call   80101680 <ilock>
  ip->major = major;
80105905:	0f b7 45 d0          	movzwl -0x30(%ebp),%eax
80105909:	66 89 47 52          	mov    %ax,0x52(%edi)
  ip->minor = minor;
8010590d:	0f b7 45 cc          	movzwl -0x34(%ebp),%eax
80105911:	66 89 47 54          	mov    %ax,0x54(%edi)
  ip->nlink = 1;
80105915:	b8 01 00 00 00       	mov    $0x1,%eax
8010591a:	66 89 47 56          	mov    %ax,0x56(%edi)
  iupdate(ip);
8010591e:	89 3c 24             	mov    %edi,(%esp)
80105921:	e8 aa bc ff ff       	call   801015d0 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
80105926:	83 c4 10             	add    $0x10,%esp
80105929:	66 83 7d d4 01       	cmpw   $0x1,-0x2c(%ebp)
8010592e:	74 50                	je     80105980 <create+0x120>
  if(dirlink(dp, name, ip->inum) < 0)
80105930:	83 ec 04             	sub    $0x4,%esp
80105933:	ff 77 04             	pushl  0x4(%edi)
80105936:	56                   	push   %esi
80105937:	53                   	push   %ebx
80105938:	e8 e3 c4 ff ff       	call   80101e20 <dirlink>
8010593d:	83 c4 10             	add    $0x10,%esp
80105940:	85 c0                	test   %eax,%eax
80105942:	0f 88 8f 00 00 00    	js     801059d7 <create+0x177>
  iunlockput(dp);
80105948:	83 ec 0c             	sub    $0xc,%esp
8010594b:	53                   	push   %ebx
8010594c:	e8 bf bf ff ff       	call   80101910 <iunlockput>
  return ip;
80105951:	83 c4 10             	add    $0x10,%esp
}
80105954:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105957:	89 f8                	mov    %edi,%eax
80105959:	5b                   	pop    %ebx
8010595a:	5e                   	pop    %esi
8010595b:	5f                   	pop    %edi
8010595c:	5d                   	pop    %ebp
8010595d:	c3                   	ret    
8010595e:	66 90                	xchg   %ax,%ax
    iunlockput(ip);
80105960:	83 ec 0c             	sub    $0xc,%esp
80105963:	57                   	push   %edi
    return 0;
80105964:	31 ff                	xor    %edi,%edi
    iunlockput(ip);
80105966:	e8 a5 bf ff ff       	call   80101910 <iunlockput>
    return 0;
8010596b:	83 c4 10             	add    $0x10,%esp
}
8010596e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105971:	89 f8                	mov    %edi,%eax
80105973:	5b                   	pop    %ebx
80105974:	5e                   	pop    %esi
80105975:	5f                   	pop    %edi
80105976:	5d                   	pop    %ebp
80105977:	c3                   	ret    
80105978:	90                   	nop
80105979:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    dp->nlink++;  // for ".."
80105980:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
    iupdate(dp);
80105985:	83 ec 0c             	sub    $0xc,%esp
80105988:	53                   	push   %ebx
80105989:	e8 42 bc ff ff       	call   801015d0 <iupdate>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
8010598e:	83 c4 0c             	add    $0xc,%esp
80105991:	ff 77 04             	pushl  0x4(%edi)
80105994:	68 c4 88 10 80       	push   $0x801088c4
80105999:	57                   	push   %edi
8010599a:	e8 81 c4 ff ff       	call   80101e20 <dirlink>
8010599f:	83 c4 10             	add    $0x10,%esp
801059a2:	85 c0                	test   %eax,%eax
801059a4:	78 1c                	js     801059c2 <create+0x162>
801059a6:	83 ec 04             	sub    $0x4,%esp
801059a9:	ff 73 04             	pushl  0x4(%ebx)
801059ac:	68 c3 88 10 80       	push   $0x801088c3
801059b1:	57                   	push   %edi
801059b2:	e8 69 c4 ff ff       	call   80101e20 <dirlink>
801059b7:	83 c4 10             	add    $0x10,%esp
801059ba:	85 c0                	test   %eax,%eax
801059bc:	0f 89 6e ff ff ff    	jns    80105930 <create+0xd0>
      panic("create dots");
801059c2:	83 ec 0c             	sub    $0xc,%esp
801059c5:	68 b7 88 10 80       	push   $0x801088b7
801059ca:	e8 c1 a9 ff ff       	call   80100390 <panic>
801059cf:	90                   	nop
    return 0;
801059d0:	31 ff                	xor    %edi,%edi
801059d2:	e9 fd fe ff ff       	jmp    801058d4 <create+0x74>
    panic("create: dirlink");
801059d7:	83 ec 0c             	sub    $0xc,%esp
801059da:	68 c6 88 10 80       	push   $0x801088c6
801059df:	e8 ac a9 ff ff       	call   80100390 <panic>
    panic("create: ialloc");
801059e4:	83 ec 0c             	sub    $0xc,%esp
801059e7:	68 a8 88 10 80       	push   $0x801088a8
801059ec:	e8 9f a9 ff ff       	call   80100390 <panic>
801059f1:	eb 0d                	jmp    80105a00 <argfd.constprop.0>
801059f3:	90                   	nop
801059f4:	90                   	nop
801059f5:	90                   	nop
801059f6:	90                   	nop
801059f7:	90                   	nop
801059f8:	90                   	nop
801059f9:	90                   	nop
801059fa:	90                   	nop
801059fb:	90                   	nop
801059fc:	90                   	nop
801059fd:	90                   	nop
801059fe:	90                   	nop
801059ff:	90                   	nop

80105a00 <argfd.constprop.0>:
argfd(int n, int *pfd, struct file **pf)
80105a00:	55                   	push   %ebp
80105a01:	89 e5                	mov    %esp,%ebp
80105a03:	56                   	push   %esi
80105a04:	53                   	push   %ebx
80105a05:	89 c3                	mov    %eax,%ebx
  if(argint(n, &fd) < 0)
80105a07:	8d 45 f4             	lea    -0xc(%ebp),%eax
argfd(int n, int *pfd, struct file **pf)
80105a0a:	89 d6                	mov    %edx,%esi
80105a0c:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
80105a0f:	50                   	push   %eax
80105a10:	6a 00                	push   $0x0
80105a12:	e8 f9 fc ff ff       	call   80105710 <argint>
80105a17:	83 c4 10             	add    $0x10,%esp
80105a1a:	85 c0                	test   %eax,%eax
80105a1c:	78 2a                	js     80105a48 <argfd.constprop.0+0x48>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
80105a1e:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
80105a22:	77 24                	ja     80105a48 <argfd.constprop.0+0x48>
80105a24:	e8 77 de ff ff       	call   801038a0 <myproc>
80105a29:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105a2c:	8b 44 90 28          	mov    0x28(%eax,%edx,4),%eax
80105a30:	85 c0                	test   %eax,%eax
80105a32:	74 14                	je     80105a48 <argfd.constprop.0+0x48>
  if(pfd)
80105a34:	85 db                	test   %ebx,%ebx
80105a36:	74 02                	je     80105a3a <argfd.constprop.0+0x3a>
    *pfd = fd;
80105a38:	89 13                	mov    %edx,(%ebx)
    *pf = f;
80105a3a:	89 06                	mov    %eax,(%esi)
  return 0;
80105a3c:	31 c0                	xor    %eax,%eax
}
80105a3e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105a41:	5b                   	pop    %ebx
80105a42:	5e                   	pop    %esi
80105a43:	5d                   	pop    %ebp
80105a44:	c3                   	ret    
80105a45:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80105a48:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105a4d:	eb ef                	jmp    80105a3e <argfd.constprop.0+0x3e>
80105a4f:	90                   	nop

80105a50 <sys_dup>:
{
80105a50:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0)
80105a51:	31 c0                	xor    %eax,%eax
{
80105a53:	89 e5                	mov    %esp,%ebp
80105a55:	56                   	push   %esi
80105a56:	53                   	push   %ebx
  if(argfd(0, 0, &f) < 0)
80105a57:	8d 55 f4             	lea    -0xc(%ebp),%edx
{
80105a5a:	83 ec 10             	sub    $0x10,%esp
  if(argfd(0, 0, &f) < 0)
80105a5d:	e8 9e ff ff ff       	call   80105a00 <argfd.constprop.0>
80105a62:	85 c0                	test   %eax,%eax
80105a64:	78 42                	js     80105aa8 <sys_dup+0x58>
  if((fd=fdalloc(f)) < 0)
80105a66:	8b 75 f4             	mov    -0xc(%ebp),%esi
  for(fd = 0; fd < NOFILE; fd++){
80105a69:	31 db                	xor    %ebx,%ebx
  struct proc *curproc = myproc();
80105a6b:	e8 30 de ff ff       	call   801038a0 <myproc>
80105a70:	eb 0e                	jmp    80105a80 <sys_dup+0x30>
80105a72:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  for(fd = 0; fd < NOFILE; fd++){
80105a78:	83 c3 01             	add    $0x1,%ebx
80105a7b:	83 fb 10             	cmp    $0x10,%ebx
80105a7e:	74 28                	je     80105aa8 <sys_dup+0x58>
    if(curproc->ofile[fd] == 0){
80105a80:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
80105a84:	85 d2                	test   %edx,%edx
80105a86:	75 f0                	jne    80105a78 <sys_dup+0x28>
      curproc->ofile[fd] = f;
80105a88:	89 74 98 28          	mov    %esi,0x28(%eax,%ebx,4)
  filedup(f);
80105a8c:	83 ec 0c             	sub    $0xc,%esp
80105a8f:	ff 75 f4             	pushl  -0xc(%ebp)
80105a92:	e8 59 b3 ff ff       	call   80100df0 <filedup>
  return fd;
80105a97:	83 c4 10             	add    $0x10,%esp
}
80105a9a:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105a9d:	89 d8                	mov    %ebx,%eax
80105a9f:	5b                   	pop    %ebx
80105aa0:	5e                   	pop    %esi
80105aa1:	5d                   	pop    %ebp
80105aa2:	c3                   	ret    
80105aa3:	90                   	nop
80105aa4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105aa8:	8d 65 f8             	lea    -0x8(%ebp),%esp
    return -1;
80105aab:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
}
80105ab0:	89 d8                	mov    %ebx,%eax
80105ab2:	5b                   	pop    %ebx
80105ab3:	5e                   	pop    %esi
80105ab4:	5d                   	pop    %ebp
80105ab5:	c3                   	ret    
80105ab6:	8d 76 00             	lea    0x0(%esi),%esi
80105ab9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105ac0 <sys_read>:
{
80105ac0:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105ac1:	31 c0                	xor    %eax,%eax
{
80105ac3:	89 e5                	mov    %esp,%ebp
80105ac5:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105ac8:	8d 55 ec             	lea    -0x14(%ebp),%edx
80105acb:	e8 30 ff ff ff       	call   80105a00 <argfd.constprop.0>
80105ad0:	85 c0                	test   %eax,%eax
80105ad2:	78 4c                	js     80105b20 <sys_read+0x60>
80105ad4:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105ad7:	83 ec 08             	sub    $0x8,%esp
80105ada:	50                   	push   %eax
80105adb:	6a 02                	push   $0x2
80105add:	e8 2e fc ff ff       	call   80105710 <argint>
80105ae2:	83 c4 10             	add    $0x10,%esp
80105ae5:	85 c0                	test   %eax,%eax
80105ae7:	78 37                	js     80105b20 <sys_read+0x60>
80105ae9:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105aec:	83 ec 04             	sub    $0x4,%esp
80105aef:	ff 75 f0             	pushl  -0x10(%ebp)
80105af2:	50                   	push   %eax
80105af3:	6a 01                	push   $0x1
80105af5:	e8 66 fc ff ff       	call   80105760 <argptr>
80105afa:	83 c4 10             	add    $0x10,%esp
80105afd:	85 c0                	test   %eax,%eax
80105aff:	78 1f                	js     80105b20 <sys_read+0x60>
  return fileread(f, p, n);
80105b01:	83 ec 04             	sub    $0x4,%esp
80105b04:	ff 75 f0             	pushl  -0x10(%ebp)
80105b07:	ff 75 f4             	pushl  -0xc(%ebp)
80105b0a:	ff 75 ec             	pushl  -0x14(%ebp)
80105b0d:	e8 4e b4 ff ff       	call   80100f60 <fileread>
80105b12:	83 c4 10             	add    $0x10,%esp
}
80105b15:	c9                   	leave  
80105b16:	c3                   	ret    
80105b17:	89 f6                	mov    %esi,%esi
80105b19:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    return -1;
80105b20:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105b25:	c9                   	leave  
80105b26:	c3                   	ret    
80105b27:	89 f6                	mov    %esi,%esi
80105b29:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105b30 <sys_write>:
{
80105b30:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105b31:	31 c0                	xor    %eax,%eax
{
80105b33:	89 e5                	mov    %esp,%ebp
80105b35:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105b38:	8d 55 ec             	lea    -0x14(%ebp),%edx
80105b3b:	e8 c0 fe ff ff       	call   80105a00 <argfd.constprop.0>
80105b40:	85 c0                	test   %eax,%eax
80105b42:	78 4c                	js     80105b90 <sys_write+0x60>
80105b44:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105b47:	83 ec 08             	sub    $0x8,%esp
80105b4a:	50                   	push   %eax
80105b4b:	6a 02                	push   $0x2
80105b4d:	e8 be fb ff ff       	call   80105710 <argint>
80105b52:	83 c4 10             	add    $0x10,%esp
80105b55:	85 c0                	test   %eax,%eax
80105b57:	78 37                	js     80105b90 <sys_write+0x60>
80105b59:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105b5c:	83 ec 04             	sub    $0x4,%esp
80105b5f:	ff 75 f0             	pushl  -0x10(%ebp)
80105b62:	50                   	push   %eax
80105b63:	6a 01                	push   $0x1
80105b65:	e8 f6 fb ff ff       	call   80105760 <argptr>
80105b6a:	83 c4 10             	add    $0x10,%esp
80105b6d:	85 c0                	test   %eax,%eax
80105b6f:	78 1f                	js     80105b90 <sys_write+0x60>
  return filewrite(f, p, n);
80105b71:	83 ec 04             	sub    $0x4,%esp
80105b74:	ff 75 f0             	pushl  -0x10(%ebp)
80105b77:	ff 75 f4             	pushl  -0xc(%ebp)
80105b7a:	ff 75 ec             	pushl  -0x14(%ebp)
80105b7d:	e8 6e b4 ff ff       	call   80100ff0 <filewrite>
80105b82:	83 c4 10             	add    $0x10,%esp
}
80105b85:	c9                   	leave  
80105b86:	c3                   	ret    
80105b87:	89 f6                	mov    %esi,%esi
80105b89:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    return -1;
80105b90:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105b95:	c9                   	leave  
80105b96:	c3                   	ret    
80105b97:	89 f6                	mov    %esi,%esi
80105b99:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105ba0 <sys_close>:
{
80105ba0:	55                   	push   %ebp
80105ba1:	89 e5                	mov    %esp,%ebp
80105ba3:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, &fd, &f) < 0)
80105ba6:	8d 55 f4             	lea    -0xc(%ebp),%edx
80105ba9:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105bac:	e8 4f fe ff ff       	call   80105a00 <argfd.constprop.0>
80105bb1:	85 c0                	test   %eax,%eax
80105bb3:	78 2b                	js     80105be0 <sys_close+0x40>
  myproc()->ofile[fd] = 0;
80105bb5:	e8 e6 dc ff ff       	call   801038a0 <myproc>
80105bba:	8b 55 f0             	mov    -0x10(%ebp),%edx
  fileclose(f);
80105bbd:	83 ec 0c             	sub    $0xc,%esp
  myproc()->ofile[fd] = 0;
80105bc0:	c7 44 90 28 00 00 00 	movl   $0x0,0x28(%eax,%edx,4)
80105bc7:	00 
  fileclose(f);
80105bc8:	ff 75 f4             	pushl  -0xc(%ebp)
80105bcb:	e8 70 b2 ff ff       	call   80100e40 <fileclose>
  return 0;
80105bd0:	83 c4 10             	add    $0x10,%esp
80105bd3:	31 c0                	xor    %eax,%eax
}
80105bd5:	c9                   	leave  
80105bd6:	c3                   	ret    
80105bd7:	89 f6                	mov    %esi,%esi
80105bd9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    return -1;
80105be0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105be5:	c9                   	leave  
80105be6:	c3                   	ret    
80105be7:	89 f6                	mov    %esi,%esi
80105be9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105bf0 <sys_fstat>:
{
80105bf0:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
80105bf1:	31 c0                	xor    %eax,%eax
{
80105bf3:	89 e5                	mov    %esp,%ebp
80105bf5:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
80105bf8:	8d 55 f0             	lea    -0x10(%ebp),%edx
80105bfb:	e8 00 fe ff ff       	call   80105a00 <argfd.constprop.0>
80105c00:	85 c0                	test   %eax,%eax
80105c02:	78 2c                	js     80105c30 <sys_fstat+0x40>
80105c04:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105c07:	83 ec 04             	sub    $0x4,%esp
80105c0a:	6a 14                	push   $0x14
80105c0c:	50                   	push   %eax
80105c0d:	6a 01                	push   $0x1
80105c0f:	e8 4c fb ff ff       	call   80105760 <argptr>
80105c14:	83 c4 10             	add    $0x10,%esp
80105c17:	85 c0                	test   %eax,%eax
80105c19:	78 15                	js     80105c30 <sys_fstat+0x40>
  return filestat(f, st);
80105c1b:	83 ec 08             	sub    $0x8,%esp
80105c1e:	ff 75 f4             	pushl  -0xc(%ebp)
80105c21:	ff 75 f0             	pushl  -0x10(%ebp)
80105c24:	e8 e7 b2 ff ff       	call   80100f10 <filestat>
80105c29:	83 c4 10             	add    $0x10,%esp
}
80105c2c:	c9                   	leave  
80105c2d:	c3                   	ret    
80105c2e:	66 90                	xchg   %ax,%ax
    return -1;
80105c30:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105c35:	c9                   	leave  
80105c36:	c3                   	ret    
80105c37:	89 f6                	mov    %esi,%esi
80105c39:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105c40 <sys_link>:
{
80105c40:	55                   	push   %ebp
80105c41:	89 e5                	mov    %esp,%ebp
80105c43:	57                   	push   %edi
80105c44:	56                   	push   %esi
80105c45:	53                   	push   %ebx
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
80105c46:	8d 45 d4             	lea    -0x2c(%ebp),%eax
{
80105c49:	83 ec 34             	sub    $0x34,%esp
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
80105c4c:	50                   	push   %eax
80105c4d:	6a 00                	push   $0x0
80105c4f:	e8 6c fb ff ff       	call   801057c0 <argstr>
80105c54:	83 c4 10             	add    $0x10,%esp
80105c57:	85 c0                	test   %eax,%eax
80105c59:	0f 88 fb 00 00 00    	js     80105d5a <sys_link+0x11a>
80105c5f:	8d 45 d0             	lea    -0x30(%ebp),%eax
80105c62:	83 ec 08             	sub    $0x8,%esp
80105c65:	50                   	push   %eax
80105c66:	6a 01                	push   $0x1
80105c68:	e8 53 fb ff ff       	call   801057c0 <argstr>
80105c6d:	83 c4 10             	add    $0x10,%esp
80105c70:	85 c0                	test   %eax,%eax
80105c72:	0f 88 e2 00 00 00    	js     80105d5a <sys_link+0x11a>
  begin_op();
80105c78:	e8 23 cf ff ff       	call   80102ba0 <begin_op>
  if((ip = namei(old)) == 0){
80105c7d:	83 ec 0c             	sub    $0xc,%esp
80105c80:	ff 75 d4             	pushl  -0x2c(%ebp)
80105c83:	e8 58 c2 ff ff       	call   80101ee0 <namei>
80105c88:	83 c4 10             	add    $0x10,%esp
80105c8b:	85 c0                	test   %eax,%eax
80105c8d:	89 c3                	mov    %eax,%ebx
80105c8f:	0f 84 ea 00 00 00    	je     80105d7f <sys_link+0x13f>
  ilock(ip);
80105c95:	83 ec 0c             	sub    $0xc,%esp
80105c98:	50                   	push   %eax
80105c99:	e8 e2 b9 ff ff       	call   80101680 <ilock>
  if(ip->type == T_DIR){
80105c9e:	83 c4 10             	add    $0x10,%esp
80105ca1:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105ca6:	0f 84 bb 00 00 00    	je     80105d67 <sys_link+0x127>
  ip->nlink++;
80105cac:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
  iupdate(ip);
80105cb1:	83 ec 0c             	sub    $0xc,%esp
  if((dp = nameiparent(new, name)) == 0)
80105cb4:	8d 7d da             	lea    -0x26(%ebp),%edi
  iupdate(ip);
80105cb7:	53                   	push   %ebx
80105cb8:	e8 13 b9 ff ff       	call   801015d0 <iupdate>
  iunlock(ip);
80105cbd:	89 1c 24             	mov    %ebx,(%esp)
80105cc0:	e8 9b ba ff ff       	call   80101760 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
80105cc5:	58                   	pop    %eax
80105cc6:	5a                   	pop    %edx
80105cc7:	57                   	push   %edi
80105cc8:	ff 75 d0             	pushl  -0x30(%ebp)
80105ccb:	e8 30 c2 ff ff       	call   80101f00 <nameiparent>
80105cd0:	83 c4 10             	add    $0x10,%esp
80105cd3:	85 c0                	test   %eax,%eax
80105cd5:	89 c6                	mov    %eax,%esi
80105cd7:	74 5b                	je     80105d34 <sys_link+0xf4>
  ilock(dp);
80105cd9:	83 ec 0c             	sub    $0xc,%esp
80105cdc:	50                   	push   %eax
80105cdd:	e8 9e b9 ff ff       	call   80101680 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
80105ce2:	83 c4 10             	add    $0x10,%esp
80105ce5:	8b 03                	mov    (%ebx),%eax
80105ce7:	39 06                	cmp    %eax,(%esi)
80105ce9:	75 3d                	jne    80105d28 <sys_link+0xe8>
80105ceb:	83 ec 04             	sub    $0x4,%esp
80105cee:	ff 73 04             	pushl  0x4(%ebx)
80105cf1:	57                   	push   %edi
80105cf2:	56                   	push   %esi
80105cf3:	e8 28 c1 ff ff       	call   80101e20 <dirlink>
80105cf8:	83 c4 10             	add    $0x10,%esp
80105cfb:	85 c0                	test   %eax,%eax
80105cfd:	78 29                	js     80105d28 <sys_link+0xe8>
  iunlockput(dp);
80105cff:	83 ec 0c             	sub    $0xc,%esp
80105d02:	56                   	push   %esi
80105d03:	e8 08 bc ff ff       	call   80101910 <iunlockput>
  iput(ip);
80105d08:	89 1c 24             	mov    %ebx,(%esp)
80105d0b:	e8 a0 ba ff ff       	call   801017b0 <iput>
  end_op();
80105d10:	e8 fb ce ff ff       	call   80102c10 <end_op>
  return 0;
80105d15:	83 c4 10             	add    $0x10,%esp
80105d18:	31 c0                	xor    %eax,%eax
}
80105d1a:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105d1d:	5b                   	pop    %ebx
80105d1e:	5e                   	pop    %esi
80105d1f:	5f                   	pop    %edi
80105d20:	5d                   	pop    %ebp
80105d21:	c3                   	ret    
80105d22:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    iunlockput(dp);
80105d28:	83 ec 0c             	sub    $0xc,%esp
80105d2b:	56                   	push   %esi
80105d2c:	e8 df bb ff ff       	call   80101910 <iunlockput>
    goto bad;
80105d31:	83 c4 10             	add    $0x10,%esp
  ilock(ip);
80105d34:	83 ec 0c             	sub    $0xc,%esp
80105d37:	53                   	push   %ebx
80105d38:	e8 43 b9 ff ff       	call   80101680 <ilock>
  ip->nlink--;
80105d3d:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
80105d42:	89 1c 24             	mov    %ebx,(%esp)
80105d45:	e8 86 b8 ff ff       	call   801015d0 <iupdate>
  iunlockput(ip);
80105d4a:	89 1c 24             	mov    %ebx,(%esp)
80105d4d:	e8 be bb ff ff       	call   80101910 <iunlockput>
  end_op();
80105d52:	e8 b9 ce ff ff       	call   80102c10 <end_op>
  return -1;
80105d57:	83 c4 10             	add    $0x10,%esp
}
80105d5a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return -1;
80105d5d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105d62:	5b                   	pop    %ebx
80105d63:	5e                   	pop    %esi
80105d64:	5f                   	pop    %edi
80105d65:	5d                   	pop    %ebp
80105d66:	c3                   	ret    
    iunlockput(ip);
80105d67:	83 ec 0c             	sub    $0xc,%esp
80105d6a:	53                   	push   %ebx
80105d6b:	e8 a0 bb ff ff       	call   80101910 <iunlockput>
    end_op();
80105d70:	e8 9b ce ff ff       	call   80102c10 <end_op>
    return -1;
80105d75:	83 c4 10             	add    $0x10,%esp
80105d78:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105d7d:	eb 9b                	jmp    80105d1a <sys_link+0xda>
    end_op();
80105d7f:	e8 8c ce ff ff       	call   80102c10 <end_op>
    return -1;
80105d84:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105d89:	eb 8f                	jmp    80105d1a <sys_link+0xda>
80105d8b:	90                   	nop
80105d8c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105d90 <sys_unlink>:
{
80105d90:	55                   	push   %ebp
80105d91:	89 e5                	mov    %esp,%ebp
80105d93:	57                   	push   %edi
80105d94:	56                   	push   %esi
80105d95:	53                   	push   %ebx
  if(argstr(0, &path) < 0)
80105d96:	8d 45 c0             	lea    -0x40(%ebp),%eax
{
80105d99:	83 ec 44             	sub    $0x44,%esp
  if(argstr(0, &path) < 0)
80105d9c:	50                   	push   %eax
80105d9d:	6a 00                	push   $0x0
80105d9f:	e8 1c fa ff ff       	call   801057c0 <argstr>
80105da4:	83 c4 10             	add    $0x10,%esp
80105da7:	85 c0                	test   %eax,%eax
80105da9:	0f 88 77 01 00 00    	js     80105f26 <sys_unlink+0x196>
  if((dp = nameiparent(path, name)) == 0){
80105daf:	8d 5d ca             	lea    -0x36(%ebp),%ebx
  begin_op();
80105db2:	e8 e9 cd ff ff       	call   80102ba0 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
80105db7:	83 ec 08             	sub    $0x8,%esp
80105dba:	53                   	push   %ebx
80105dbb:	ff 75 c0             	pushl  -0x40(%ebp)
80105dbe:	e8 3d c1 ff ff       	call   80101f00 <nameiparent>
80105dc3:	83 c4 10             	add    $0x10,%esp
80105dc6:	85 c0                	test   %eax,%eax
80105dc8:	89 c6                	mov    %eax,%esi
80105dca:	0f 84 60 01 00 00    	je     80105f30 <sys_unlink+0x1a0>
  ilock(dp);
80105dd0:	83 ec 0c             	sub    $0xc,%esp
80105dd3:	50                   	push   %eax
80105dd4:	e8 a7 b8 ff ff       	call   80101680 <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
80105dd9:	58                   	pop    %eax
80105dda:	5a                   	pop    %edx
80105ddb:	68 c4 88 10 80       	push   $0x801088c4
80105de0:	53                   	push   %ebx
80105de1:	e8 aa bd ff ff       	call   80101b90 <namecmp>
80105de6:	83 c4 10             	add    $0x10,%esp
80105de9:	85 c0                	test   %eax,%eax
80105deb:	0f 84 03 01 00 00    	je     80105ef4 <sys_unlink+0x164>
80105df1:	83 ec 08             	sub    $0x8,%esp
80105df4:	68 c3 88 10 80       	push   $0x801088c3
80105df9:	53                   	push   %ebx
80105dfa:	e8 91 bd ff ff       	call   80101b90 <namecmp>
80105dff:	83 c4 10             	add    $0x10,%esp
80105e02:	85 c0                	test   %eax,%eax
80105e04:	0f 84 ea 00 00 00    	je     80105ef4 <sys_unlink+0x164>
  if((ip = dirlookup(dp, name, &off)) == 0)
80105e0a:	8d 45 c4             	lea    -0x3c(%ebp),%eax
80105e0d:	83 ec 04             	sub    $0x4,%esp
80105e10:	50                   	push   %eax
80105e11:	53                   	push   %ebx
80105e12:	56                   	push   %esi
80105e13:	e8 98 bd ff ff       	call   80101bb0 <dirlookup>
80105e18:	83 c4 10             	add    $0x10,%esp
80105e1b:	85 c0                	test   %eax,%eax
80105e1d:	89 c3                	mov    %eax,%ebx
80105e1f:	0f 84 cf 00 00 00    	je     80105ef4 <sys_unlink+0x164>
  ilock(ip);
80105e25:	83 ec 0c             	sub    $0xc,%esp
80105e28:	50                   	push   %eax
80105e29:	e8 52 b8 ff ff       	call   80101680 <ilock>
  if(ip->nlink < 1)
80105e2e:	83 c4 10             	add    $0x10,%esp
80105e31:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
80105e36:	0f 8e 10 01 00 00    	jle    80105f4c <sys_unlink+0x1bc>
  if(ip->type == T_DIR && !isdirempty(ip)){
80105e3c:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105e41:	74 6d                	je     80105eb0 <sys_unlink+0x120>
  memset(&de, 0, sizeof(de));
80105e43:	8d 45 d8             	lea    -0x28(%ebp),%eax
80105e46:	83 ec 04             	sub    $0x4,%esp
80105e49:	6a 10                	push   $0x10
80105e4b:	6a 00                	push   $0x0
80105e4d:	50                   	push   %eax
80105e4e:	e8 bd f5 ff ff       	call   80105410 <memset>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80105e53:	8d 45 d8             	lea    -0x28(%ebp),%eax
80105e56:	6a 10                	push   $0x10
80105e58:	ff 75 c4             	pushl  -0x3c(%ebp)
80105e5b:	50                   	push   %eax
80105e5c:	56                   	push   %esi
80105e5d:	e8 fe bb ff ff       	call   80101a60 <writei>
80105e62:	83 c4 20             	add    $0x20,%esp
80105e65:	83 f8 10             	cmp    $0x10,%eax
80105e68:	0f 85 eb 00 00 00    	jne    80105f59 <sys_unlink+0x1c9>
  if(ip->type == T_DIR){
80105e6e:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105e73:	0f 84 97 00 00 00    	je     80105f10 <sys_unlink+0x180>
  iunlockput(dp);
80105e79:	83 ec 0c             	sub    $0xc,%esp
80105e7c:	56                   	push   %esi
80105e7d:	e8 8e ba ff ff       	call   80101910 <iunlockput>
  ip->nlink--;
80105e82:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
80105e87:	89 1c 24             	mov    %ebx,(%esp)
80105e8a:	e8 41 b7 ff ff       	call   801015d0 <iupdate>
  iunlockput(ip);
80105e8f:	89 1c 24             	mov    %ebx,(%esp)
80105e92:	e8 79 ba ff ff       	call   80101910 <iunlockput>
  end_op();
80105e97:	e8 74 cd ff ff       	call   80102c10 <end_op>
  return 0;
80105e9c:	83 c4 10             	add    $0x10,%esp
80105e9f:	31 c0                	xor    %eax,%eax
}
80105ea1:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105ea4:	5b                   	pop    %ebx
80105ea5:	5e                   	pop    %esi
80105ea6:	5f                   	pop    %edi
80105ea7:	5d                   	pop    %ebp
80105ea8:	c3                   	ret    
80105ea9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
80105eb0:	83 7b 58 20          	cmpl   $0x20,0x58(%ebx)
80105eb4:	76 8d                	jbe    80105e43 <sys_unlink+0xb3>
80105eb6:	bf 20 00 00 00       	mov    $0x20,%edi
80105ebb:	eb 0f                	jmp    80105ecc <sys_unlink+0x13c>
80105ebd:	8d 76 00             	lea    0x0(%esi),%esi
80105ec0:	83 c7 10             	add    $0x10,%edi
80105ec3:	3b 7b 58             	cmp    0x58(%ebx),%edi
80105ec6:	0f 83 77 ff ff ff    	jae    80105e43 <sys_unlink+0xb3>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80105ecc:	8d 45 d8             	lea    -0x28(%ebp),%eax
80105ecf:	6a 10                	push   $0x10
80105ed1:	57                   	push   %edi
80105ed2:	50                   	push   %eax
80105ed3:	53                   	push   %ebx
80105ed4:	e8 87 ba ff ff       	call   80101960 <readi>
80105ed9:	83 c4 10             	add    $0x10,%esp
80105edc:	83 f8 10             	cmp    $0x10,%eax
80105edf:	75 5e                	jne    80105f3f <sys_unlink+0x1af>
    if(de.inum != 0)
80105ee1:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80105ee6:	74 d8                	je     80105ec0 <sys_unlink+0x130>
    iunlockput(ip);
80105ee8:	83 ec 0c             	sub    $0xc,%esp
80105eeb:	53                   	push   %ebx
80105eec:	e8 1f ba ff ff       	call   80101910 <iunlockput>
    goto bad;
80105ef1:	83 c4 10             	add    $0x10,%esp
  iunlockput(dp);
80105ef4:	83 ec 0c             	sub    $0xc,%esp
80105ef7:	56                   	push   %esi
80105ef8:	e8 13 ba ff ff       	call   80101910 <iunlockput>
  end_op();
80105efd:	e8 0e cd ff ff       	call   80102c10 <end_op>
  return -1;
80105f02:	83 c4 10             	add    $0x10,%esp
80105f05:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105f0a:	eb 95                	jmp    80105ea1 <sys_unlink+0x111>
80105f0c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    dp->nlink--;
80105f10:	66 83 6e 56 01       	subw   $0x1,0x56(%esi)
    iupdate(dp);
80105f15:	83 ec 0c             	sub    $0xc,%esp
80105f18:	56                   	push   %esi
80105f19:	e8 b2 b6 ff ff       	call   801015d0 <iupdate>
80105f1e:	83 c4 10             	add    $0x10,%esp
80105f21:	e9 53 ff ff ff       	jmp    80105e79 <sys_unlink+0xe9>
    return -1;
80105f26:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105f2b:	e9 71 ff ff ff       	jmp    80105ea1 <sys_unlink+0x111>
    end_op();
80105f30:	e8 db cc ff ff       	call   80102c10 <end_op>
    return -1;
80105f35:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105f3a:	e9 62 ff ff ff       	jmp    80105ea1 <sys_unlink+0x111>
      panic("isdirempty: readi");
80105f3f:	83 ec 0c             	sub    $0xc,%esp
80105f42:	68 e8 88 10 80       	push   $0x801088e8
80105f47:	e8 44 a4 ff ff       	call   80100390 <panic>
    panic("unlink: nlink < 1");
80105f4c:	83 ec 0c             	sub    $0xc,%esp
80105f4f:	68 d6 88 10 80       	push   $0x801088d6
80105f54:	e8 37 a4 ff ff       	call   80100390 <panic>
    panic("unlink: writei");
80105f59:	83 ec 0c             	sub    $0xc,%esp
80105f5c:	68 fa 88 10 80       	push   $0x801088fa
80105f61:	e8 2a a4 ff ff       	call   80100390 <panic>
80105f66:	8d 76 00             	lea    0x0(%esi),%esi
80105f69:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105f70 <sys_open>:

int
sys_open(void)
{
80105f70:	55                   	push   %ebp
80105f71:	89 e5                	mov    %esp,%ebp
80105f73:	57                   	push   %edi
80105f74:	56                   	push   %esi
80105f75:	53                   	push   %ebx
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
80105f76:	8d 45 e0             	lea    -0x20(%ebp),%eax
{
80105f79:	83 ec 24             	sub    $0x24,%esp
  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
80105f7c:	50                   	push   %eax
80105f7d:	6a 00                	push   $0x0
80105f7f:	e8 3c f8 ff ff       	call   801057c0 <argstr>
80105f84:	83 c4 10             	add    $0x10,%esp
80105f87:	85 c0                	test   %eax,%eax
80105f89:	0f 88 1d 01 00 00    	js     801060ac <sys_open+0x13c>
80105f8f:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105f92:	83 ec 08             	sub    $0x8,%esp
80105f95:	50                   	push   %eax
80105f96:	6a 01                	push   $0x1
80105f98:	e8 73 f7 ff ff       	call   80105710 <argint>
80105f9d:	83 c4 10             	add    $0x10,%esp
80105fa0:	85 c0                	test   %eax,%eax
80105fa2:	0f 88 04 01 00 00    	js     801060ac <sys_open+0x13c>
    return -1;

  begin_op();
80105fa8:	e8 f3 cb ff ff       	call   80102ba0 <begin_op>

  if(omode & O_CREATE){
80105fad:	f6 45 e5 02          	testb  $0x2,-0x1b(%ebp)
80105fb1:	0f 85 a9 00 00 00    	jne    80106060 <sys_open+0xf0>
    if(ip == 0){
      end_op();
      return -1;
    }
  } else {
    if((ip = namei(path)) == 0){
80105fb7:	83 ec 0c             	sub    $0xc,%esp
80105fba:	ff 75 e0             	pushl  -0x20(%ebp)
80105fbd:	e8 1e bf ff ff       	call   80101ee0 <namei>
80105fc2:	83 c4 10             	add    $0x10,%esp
80105fc5:	85 c0                	test   %eax,%eax
80105fc7:	89 c6                	mov    %eax,%esi
80105fc9:	0f 84 b2 00 00 00    	je     80106081 <sys_open+0x111>
      end_op();
      return -1;
    }
    ilock(ip);
80105fcf:	83 ec 0c             	sub    $0xc,%esp
80105fd2:	50                   	push   %eax
80105fd3:	e8 a8 b6 ff ff       	call   80101680 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
80105fd8:	83 c4 10             	add    $0x10,%esp
80105fdb:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80105fe0:	0f 84 aa 00 00 00    	je     80106090 <sys_open+0x120>
      end_op();
      return -1;
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
80105fe6:	e8 95 ad ff ff       	call   80100d80 <filealloc>
80105feb:	85 c0                	test   %eax,%eax
80105fed:	89 c7                	mov    %eax,%edi
80105fef:	0f 84 a6 00 00 00    	je     8010609b <sys_open+0x12b>
  struct proc *curproc = myproc();
80105ff5:	e8 a6 d8 ff ff       	call   801038a0 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
80105ffa:	31 db                	xor    %ebx,%ebx
80105ffc:	eb 0e                	jmp    8010600c <sys_open+0x9c>
80105ffe:	66 90                	xchg   %ax,%ax
80106000:	83 c3 01             	add    $0x1,%ebx
80106003:	83 fb 10             	cmp    $0x10,%ebx
80106006:	0f 84 ac 00 00 00    	je     801060b8 <sys_open+0x148>
    if(curproc->ofile[fd] == 0){
8010600c:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
80106010:	85 d2                	test   %edx,%edx
80106012:	75 ec                	jne    80106000 <sys_open+0x90>
      fileclose(f);
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
80106014:	83 ec 0c             	sub    $0xc,%esp
      curproc->ofile[fd] = f;
80106017:	89 7c 98 28          	mov    %edi,0x28(%eax,%ebx,4)
  iunlock(ip);
8010601b:	56                   	push   %esi
8010601c:	e8 3f b7 ff ff       	call   80101760 <iunlock>
  end_op();
80106021:	e8 ea cb ff ff       	call   80102c10 <end_op>

  f->type = FD_INODE;
80106026:	c7 07 02 00 00 00    	movl   $0x2,(%edi)
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
8010602c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
8010602f:	83 c4 10             	add    $0x10,%esp
  f->ip = ip;
80106032:	89 77 10             	mov    %esi,0x10(%edi)
  f->off = 0;
80106035:	c7 47 14 00 00 00 00 	movl   $0x0,0x14(%edi)
  f->readable = !(omode & O_WRONLY);
8010603c:	89 d0                	mov    %edx,%eax
8010603e:	f7 d0                	not    %eax
80106040:	83 e0 01             	and    $0x1,%eax
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80106043:	83 e2 03             	and    $0x3,%edx
  f->readable = !(omode & O_WRONLY);
80106046:	88 47 08             	mov    %al,0x8(%edi)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80106049:	0f 95 47 09          	setne  0x9(%edi)
  return fd;
}
8010604d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106050:	89 d8                	mov    %ebx,%eax
80106052:	5b                   	pop    %ebx
80106053:	5e                   	pop    %esi
80106054:	5f                   	pop    %edi
80106055:	5d                   	pop    %ebp
80106056:	c3                   	ret    
80106057:	89 f6                	mov    %esi,%esi
80106059:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    ip = create(path, T_FILE, 0, 0);
80106060:	83 ec 0c             	sub    $0xc,%esp
80106063:	8b 45 e0             	mov    -0x20(%ebp),%eax
80106066:	31 c9                	xor    %ecx,%ecx
80106068:	6a 00                	push   $0x0
8010606a:	ba 02 00 00 00       	mov    $0x2,%edx
8010606f:	e8 ec f7 ff ff       	call   80105860 <create>
    if(ip == 0){
80106074:	83 c4 10             	add    $0x10,%esp
80106077:	85 c0                	test   %eax,%eax
    ip = create(path, T_FILE, 0, 0);
80106079:	89 c6                	mov    %eax,%esi
    if(ip == 0){
8010607b:	0f 85 65 ff ff ff    	jne    80105fe6 <sys_open+0x76>
      end_op();
80106081:	e8 8a cb ff ff       	call   80102c10 <end_op>
      return -1;
80106086:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
8010608b:	eb c0                	jmp    8010604d <sys_open+0xdd>
8010608d:	8d 76 00             	lea    0x0(%esi),%esi
    if(ip->type == T_DIR && omode != O_RDONLY){
80106090:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80106093:	85 c9                	test   %ecx,%ecx
80106095:	0f 84 4b ff ff ff    	je     80105fe6 <sys_open+0x76>
    iunlockput(ip);
8010609b:	83 ec 0c             	sub    $0xc,%esp
8010609e:	56                   	push   %esi
8010609f:	e8 6c b8 ff ff       	call   80101910 <iunlockput>
    end_op();
801060a4:	e8 67 cb ff ff       	call   80102c10 <end_op>
    return -1;
801060a9:	83 c4 10             	add    $0x10,%esp
801060ac:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
801060b1:	eb 9a                	jmp    8010604d <sys_open+0xdd>
801060b3:	90                   	nop
801060b4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      fileclose(f);
801060b8:	83 ec 0c             	sub    $0xc,%esp
801060bb:	57                   	push   %edi
801060bc:	e8 7f ad ff ff       	call   80100e40 <fileclose>
801060c1:	83 c4 10             	add    $0x10,%esp
801060c4:	eb d5                	jmp    8010609b <sys_open+0x12b>
801060c6:	8d 76 00             	lea    0x0(%esi),%esi
801060c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801060d0 <sys_mkdir>:

int
sys_mkdir(void)
{
801060d0:	55                   	push   %ebp
801060d1:	89 e5                	mov    %esp,%ebp
801060d3:	83 ec 18             	sub    $0x18,%esp
  char *path;
  struct inode *ip;

  begin_op();
801060d6:	e8 c5 ca ff ff       	call   80102ba0 <begin_op>
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
801060db:	8d 45 f4             	lea    -0xc(%ebp),%eax
801060de:	83 ec 08             	sub    $0x8,%esp
801060e1:	50                   	push   %eax
801060e2:	6a 00                	push   $0x0
801060e4:	e8 d7 f6 ff ff       	call   801057c0 <argstr>
801060e9:	83 c4 10             	add    $0x10,%esp
801060ec:	85 c0                	test   %eax,%eax
801060ee:	78 30                	js     80106120 <sys_mkdir+0x50>
801060f0:	83 ec 0c             	sub    $0xc,%esp
801060f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801060f6:	31 c9                	xor    %ecx,%ecx
801060f8:	6a 00                	push   $0x0
801060fa:	ba 01 00 00 00       	mov    $0x1,%edx
801060ff:	e8 5c f7 ff ff       	call   80105860 <create>
80106104:	83 c4 10             	add    $0x10,%esp
80106107:	85 c0                	test   %eax,%eax
80106109:	74 15                	je     80106120 <sys_mkdir+0x50>
    end_op();
    return -1;
  }
  iunlockput(ip);
8010610b:	83 ec 0c             	sub    $0xc,%esp
8010610e:	50                   	push   %eax
8010610f:	e8 fc b7 ff ff       	call   80101910 <iunlockput>
  end_op();
80106114:	e8 f7 ca ff ff       	call   80102c10 <end_op>
  return 0;
80106119:	83 c4 10             	add    $0x10,%esp
8010611c:	31 c0                	xor    %eax,%eax
}
8010611e:	c9                   	leave  
8010611f:	c3                   	ret    
    end_op();
80106120:	e8 eb ca ff ff       	call   80102c10 <end_op>
    return -1;
80106125:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010612a:	c9                   	leave  
8010612b:	c3                   	ret    
8010612c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80106130 <sys_mknod>:

int
sys_mknod(void)
{
80106130:	55                   	push   %ebp
80106131:	89 e5                	mov    %esp,%ebp
80106133:	83 ec 18             	sub    $0x18,%esp
  struct inode *ip;
  char *path;
  int major, minor;

  begin_op();
80106136:	e8 65 ca ff ff       	call   80102ba0 <begin_op>
  if((argstr(0, &path)) < 0 ||
8010613b:	8d 45 ec             	lea    -0x14(%ebp),%eax
8010613e:	83 ec 08             	sub    $0x8,%esp
80106141:	50                   	push   %eax
80106142:	6a 00                	push   $0x0
80106144:	e8 77 f6 ff ff       	call   801057c0 <argstr>
80106149:	83 c4 10             	add    $0x10,%esp
8010614c:	85 c0                	test   %eax,%eax
8010614e:	78 60                	js     801061b0 <sys_mknod+0x80>
     argint(1, &major) < 0 ||
80106150:	8d 45 f0             	lea    -0x10(%ebp),%eax
80106153:	83 ec 08             	sub    $0x8,%esp
80106156:	50                   	push   %eax
80106157:	6a 01                	push   $0x1
80106159:	e8 b2 f5 ff ff       	call   80105710 <argint>
  if((argstr(0, &path)) < 0 ||
8010615e:	83 c4 10             	add    $0x10,%esp
80106161:	85 c0                	test   %eax,%eax
80106163:	78 4b                	js     801061b0 <sys_mknod+0x80>
     argint(2, &minor) < 0 ||
80106165:	8d 45 f4             	lea    -0xc(%ebp),%eax
80106168:	83 ec 08             	sub    $0x8,%esp
8010616b:	50                   	push   %eax
8010616c:	6a 02                	push   $0x2
8010616e:	e8 9d f5 ff ff       	call   80105710 <argint>
     argint(1, &major) < 0 ||
80106173:	83 c4 10             	add    $0x10,%esp
80106176:	85 c0                	test   %eax,%eax
80106178:	78 36                	js     801061b0 <sys_mknod+0x80>
     (ip = create(path, T_DEV, major, minor)) == 0){
8010617a:	0f bf 45 f4          	movswl -0xc(%ebp),%eax
     argint(2, &minor) < 0 ||
8010617e:	83 ec 0c             	sub    $0xc,%esp
     (ip = create(path, T_DEV, major, minor)) == 0){
80106181:	0f bf 4d f0          	movswl -0x10(%ebp),%ecx
     argint(2, &minor) < 0 ||
80106185:	ba 03 00 00 00       	mov    $0x3,%edx
8010618a:	50                   	push   %eax
8010618b:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010618e:	e8 cd f6 ff ff       	call   80105860 <create>
80106193:	83 c4 10             	add    $0x10,%esp
80106196:	85 c0                	test   %eax,%eax
80106198:	74 16                	je     801061b0 <sys_mknod+0x80>
    end_op();
    return -1;
  }
  iunlockput(ip);
8010619a:	83 ec 0c             	sub    $0xc,%esp
8010619d:	50                   	push   %eax
8010619e:	e8 6d b7 ff ff       	call   80101910 <iunlockput>
  end_op();
801061a3:	e8 68 ca ff ff       	call   80102c10 <end_op>
  return 0;
801061a8:	83 c4 10             	add    $0x10,%esp
801061ab:	31 c0                	xor    %eax,%eax
}
801061ad:	c9                   	leave  
801061ae:	c3                   	ret    
801061af:	90                   	nop
    end_op();
801061b0:	e8 5b ca ff ff       	call   80102c10 <end_op>
    return -1;
801061b5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801061ba:	c9                   	leave  
801061bb:	c3                   	ret    
801061bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801061c0 <sys_chdir>:

int
sys_chdir(void)
{
801061c0:	55                   	push   %ebp
801061c1:	89 e5                	mov    %esp,%ebp
801061c3:	56                   	push   %esi
801061c4:	53                   	push   %ebx
801061c5:	83 ec 10             	sub    $0x10,%esp
  char *path;
  struct inode *ip;
  struct proc *curproc = myproc();
801061c8:	e8 d3 d6 ff ff       	call   801038a0 <myproc>
801061cd:	89 c6                	mov    %eax,%esi
  
  begin_op();
801061cf:	e8 cc c9 ff ff       	call   80102ba0 <begin_op>
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
801061d4:	8d 45 f4             	lea    -0xc(%ebp),%eax
801061d7:	83 ec 08             	sub    $0x8,%esp
801061da:	50                   	push   %eax
801061db:	6a 00                	push   $0x0
801061dd:	e8 de f5 ff ff       	call   801057c0 <argstr>
801061e2:	83 c4 10             	add    $0x10,%esp
801061e5:	85 c0                	test   %eax,%eax
801061e7:	78 77                	js     80106260 <sys_chdir+0xa0>
801061e9:	83 ec 0c             	sub    $0xc,%esp
801061ec:	ff 75 f4             	pushl  -0xc(%ebp)
801061ef:	e8 ec bc ff ff       	call   80101ee0 <namei>
801061f4:	83 c4 10             	add    $0x10,%esp
801061f7:	85 c0                	test   %eax,%eax
801061f9:	89 c3                	mov    %eax,%ebx
801061fb:	74 63                	je     80106260 <sys_chdir+0xa0>
    end_op();
    return -1;
  }
  ilock(ip);
801061fd:	83 ec 0c             	sub    $0xc,%esp
80106200:	50                   	push   %eax
80106201:	e8 7a b4 ff ff       	call   80101680 <ilock>
  if(ip->type != T_DIR){
80106206:	83 c4 10             	add    $0x10,%esp
80106209:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
8010620e:	75 30                	jne    80106240 <sys_chdir+0x80>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
80106210:	83 ec 0c             	sub    $0xc,%esp
80106213:	53                   	push   %ebx
80106214:	e8 47 b5 ff ff       	call   80101760 <iunlock>
  iput(curproc->cwd);
80106219:	58                   	pop    %eax
8010621a:	ff 76 68             	pushl  0x68(%esi)
8010621d:	e8 8e b5 ff ff       	call   801017b0 <iput>
  end_op();
80106222:	e8 e9 c9 ff ff       	call   80102c10 <end_op>
  curproc->cwd = ip;
80106227:	89 5e 68             	mov    %ebx,0x68(%esi)
  return 0;
8010622a:	83 c4 10             	add    $0x10,%esp
8010622d:	31 c0                	xor    %eax,%eax
}
8010622f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80106232:	5b                   	pop    %ebx
80106233:	5e                   	pop    %esi
80106234:	5d                   	pop    %ebp
80106235:	c3                   	ret    
80106236:	8d 76 00             	lea    0x0(%esi),%esi
80106239:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    iunlockput(ip);
80106240:	83 ec 0c             	sub    $0xc,%esp
80106243:	53                   	push   %ebx
80106244:	e8 c7 b6 ff ff       	call   80101910 <iunlockput>
    end_op();
80106249:	e8 c2 c9 ff ff       	call   80102c10 <end_op>
    return -1;
8010624e:	83 c4 10             	add    $0x10,%esp
80106251:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106256:	eb d7                	jmp    8010622f <sys_chdir+0x6f>
80106258:	90                   	nop
80106259:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    end_op();
80106260:	e8 ab c9 ff ff       	call   80102c10 <end_op>
    return -1;
80106265:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010626a:	eb c3                	jmp    8010622f <sys_chdir+0x6f>
8010626c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80106270 <sys_exec>:

int
sys_exec(void)
{
80106270:	55                   	push   %ebp
80106271:	89 e5                	mov    %esp,%ebp
80106273:	57                   	push   %edi
80106274:	56                   	push   %esi
80106275:	53                   	push   %ebx
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80106276:	8d 85 5c ff ff ff    	lea    -0xa4(%ebp),%eax
{
8010627c:	81 ec a4 00 00 00    	sub    $0xa4,%esp
  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80106282:	50                   	push   %eax
80106283:	6a 00                	push   $0x0
80106285:	e8 36 f5 ff ff       	call   801057c0 <argstr>
8010628a:	83 c4 10             	add    $0x10,%esp
8010628d:	85 c0                	test   %eax,%eax
8010628f:	0f 88 87 00 00 00    	js     8010631c <sys_exec+0xac>
80106295:	8d 85 60 ff ff ff    	lea    -0xa0(%ebp),%eax
8010629b:	83 ec 08             	sub    $0x8,%esp
8010629e:	50                   	push   %eax
8010629f:	6a 01                	push   $0x1
801062a1:	e8 6a f4 ff ff       	call   80105710 <argint>
801062a6:	83 c4 10             	add    $0x10,%esp
801062a9:	85 c0                	test   %eax,%eax
801062ab:	78 6f                	js     8010631c <sys_exec+0xac>
    return -1;
  }
  memset(argv, 0, sizeof(argv));
801062ad:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
801062b3:	83 ec 04             	sub    $0x4,%esp
  for(i=0;; i++){
801062b6:	31 db                	xor    %ebx,%ebx
  memset(argv, 0, sizeof(argv));
801062b8:	68 80 00 00 00       	push   $0x80
801062bd:	6a 00                	push   $0x0
801062bf:	8d bd 64 ff ff ff    	lea    -0x9c(%ebp),%edi
801062c5:	50                   	push   %eax
801062c6:	e8 45 f1 ff ff       	call   80105410 <memset>
801062cb:	83 c4 10             	add    $0x10,%esp
801062ce:	eb 2c                	jmp    801062fc <sys_exec+0x8c>
    if(i >= NELEM(argv))
      return -1;
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
      return -1;
    if(uarg == 0){
801062d0:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
801062d6:	85 c0                	test   %eax,%eax
801062d8:	74 56                	je     80106330 <sys_exec+0xc0>
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
801062da:	8d 8d 68 ff ff ff    	lea    -0x98(%ebp),%ecx
801062e0:	83 ec 08             	sub    $0x8,%esp
801062e3:	8d 14 31             	lea    (%ecx,%esi,1),%edx
801062e6:	52                   	push   %edx
801062e7:	50                   	push   %eax
801062e8:	e8 b3 f3 ff ff       	call   801056a0 <fetchstr>
801062ed:	83 c4 10             	add    $0x10,%esp
801062f0:	85 c0                	test   %eax,%eax
801062f2:	78 28                	js     8010631c <sys_exec+0xac>
  for(i=0;; i++){
801062f4:	83 c3 01             	add    $0x1,%ebx
    if(i >= NELEM(argv))
801062f7:	83 fb 20             	cmp    $0x20,%ebx
801062fa:	74 20                	je     8010631c <sys_exec+0xac>
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
801062fc:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
80106302:	8d 34 9d 00 00 00 00 	lea    0x0(,%ebx,4),%esi
80106309:	83 ec 08             	sub    $0x8,%esp
8010630c:	57                   	push   %edi
8010630d:	01 f0                	add    %esi,%eax
8010630f:	50                   	push   %eax
80106310:	e8 4b f3 ff ff       	call   80105660 <fetchint>
80106315:	83 c4 10             	add    $0x10,%esp
80106318:	85 c0                	test   %eax,%eax
8010631a:	79 b4                	jns    801062d0 <sys_exec+0x60>
      return -1;
  }
  return exec(path, argv);
}
8010631c:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return -1;
8010631f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106324:	5b                   	pop    %ebx
80106325:	5e                   	pop    %esi
80106326:	5f                   	pop    %edi
80106327:	5d                   	pop    %ebp
80106328:	c3                   	ret    
80106329:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  return exec(path, argv);
80106330:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
80106336:	83 ec 08             	sub    $0x8,%esp
      argv[i] = 0;
80106339:	c7 84 9d 68 ff ff ff 	movl   $0x0,-0x98(%ebp,%ebx,4)
80106340:	00 00 00 00 
  return exec(path, argv);
80106344:	50                   	push   %eax
80106345:	ff b5 5c ff ff ff    	pushl  -0xa4(%ebp)
8010634b:	e8 c0 a6 ff ff       	call   80100a10 <exec>
80106350:	83 c4 10             	add    $0x10,%esp
}
80106353:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106356:	5b                   	pop    %ebx
80106357:	5e                   	pop    %esi
80106358:	5f                   	pop    %edi
80106359:	5d                   	pop    %ebp
8010635a:	c3                   	ret    
8010635b:	90                   	nop
8010635c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80106360 <sys_pipe>:

int
sys_pipe(void)
{
80106360:	55                   	push   %ebp
80106361:	89 e5                	mov    %esp,%ebp
80106363:	57                   	push   %edi
80106364:	56                   	push   %esi
80106365:	53                   	push   %ebx
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
80106366:	8d 45 dc             	lea    -0x24(%ebp),%eax
{
80106369:	83 ec 20             	sub    $0x20,%esp
  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
8010636c:	6a 08                	push   $0x8
8010636e:	50                   	push   %eax
8010636f:	6a 00                	push   $0x0
80106371:	e8 ea f3 ff ff       	call   80105760 <argptr>
80106376:	83 c4 10             	add    $0x10,%esp
80106379:	85 c0                	test   %eax,%eax
8010637b:	0f 88 ae 00 00 00    	js     8010642f <sys_pipe+0xcf>
    return -1;
  if(pipealloc(&rf, &wf) < 0)
80106381:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80106384:	83 ec 08             	sub    $0x8,%esp
80106387:	50                   	push   %eax
80106388:	8d 45 e0             	lea    -0x20(%ebp),%eax
8010638b:	50                   	push   %eax
8010638c:	e8 af ce ff ff       	call   80103240 <pipealloc>
80106391:	83 c4 10             	add    $0x10,%esp
80106394:	85 c0                	test   %eax,%eax
80106396:	0f 88 93 00 00 00    	js     8010642f <sys_pipe+0xcf>
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
8010639c:	8b 7d e0             	mov    -0x20(%ebp),%edi
  for(fd = 0; fd < NOFILE; fd++){
8010639f:	31 db                	xor    %ebx,%ebx
  struct proc *curproc = myproc();
801063a1:	e8 fa d4 ff ff       	call   801038a0 <myproc>
801063a6:	eb 10                	jmp    801063b8 <sys_pipe+0x58>
801063a8:	90                   	nop
801063a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(fd = 0; fd < NOFILE; fd++){
801063b0:	83 c3 01             	add    $0x1,%ebx
801063b3:	83 fb 10             	cmp    $0x10,%ebx
801063b6:	74 60                	je     80106418 <sys_pipe+0xb8>
    if(curproc->ofile[fd] == 0){
801063b8:	8b 74 98 28          	mov    0x28(%eax,%ebx,4),%esi
801063bc:	85 f6                	test   %esi,%esi
801063be:	75 f0                	jne    801063b0 <sys_pipe+0x50>
      curproc->ofile[fd] = f;
801063c0:	8d 73 08             	lea    0x8(%ebx),%esi
801063c3:	89 7c b0 08          	mov    %edi,0x8(%eax,%esi,4)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
801063c7:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  struct proc *curproc = myproc();
801063ca:	e8 d1 d4 ff ff       	call   801038a0 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
801063cf:	31 d2                	xor    %edx,%edx
801063d1:	eb 0d                	jmp    801063e0 <sys_pipe+0x80>
801063d3:	90                   	nop
801063d4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801063d8:	83 c2 01             	add    $0x1,%edx
801063db:	83 fa 10             	cmp    $0x10,%edx
801063de:	74 28                	je     80106408 <sys_pipe+0xa8>
    if(curproc->ofile[fd] == 0){
801063e0:	8b 4c 90 28          	mov    0x28(%eax,%edx,4),%ecx
801063e4:	85 c9                	test   %ecx,%ecx
801063e6:	75 f0                	jne    801063d8 <sys_pipe+0x78>
      curproc->ofile[fd] = f;
801063e8:	89 7c 90 28          	mov    %edi,0x28(%eax,%edx,4)
      myproc()->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  fd[0] = fd0;
801063ec:	8b 45 dc             	mov    -0x24(%ebp),%eax
801063ef:	89 18                	mov    %ebx,(%eax)
  fd[1] = fd1;
801063f1:	8b 45 dc             	mov    -0x24(%ebp),%eax
801063f4:	89 50 04             	mov    %edx,0x4(%eax)
  return 0;
801063f7:	31 c0                	xor    %eax,%eax
}
801063f9:	8d 65 f4             	lea    -0xc(%ebp),%esp
801063fc:	5b                   	pop    %ebx
801063fd:	5e                   	pop    %esi
801063fe:	5f                   	pop    %edi
801063ff:	5d                   	pop    %ebp
80106400:	c3                   	ret    
80106401:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      myproc()->ofile[fd0] = 0;
80106408:	e8 93 d4 ff ff       	call   801038a0 <myproc>
8010640d:	c7 44 b0 08 00 00 00 	movl   $0x0,0x8(%eax,%esi,4)
80106414:	00 
80106415:	8d 76 00             	lea    0x0(%esi),%esi
    fileclose(rf);
80106418:	83 ec 0c             	sub    $0xc,%esp
8010641b:	ff 75 e0             	pushl  -0x20(%ebp)
8010641e:	e8 1d aa ff ff       	call   80100e40 <fileclose>
    fileclose(wf);
80106423:	58                   	pop    %eax
80106424:	ff 75 e4             	pushl  -0x1c(%ebp)
80106427:	e8 14 aa ff ff       	call   80100e40 <fileclose>
    return -1;
8010642c:	83 c4 10             	add    $0x10,%esp
8010642f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106434:	eb c3                	jmp    801063f9 <sys_pipe+0x99>
80106436:	66 90                	xchg   %ax,%ax
80106438:	66 90                	xchg   %ax,%ax
8010643a:	66 90                	xchg   %ax,%ax
8010643c:	66 90                	xchg   %ax,%ax
8010643e:	66 90                	xchg   %ax,%ax

80106440 <sys_fork>:
#include "mmu.h"
#include "proc.h"

int
sys_fork(void)
{
80106440:	55                   	push   %ebp
80106441:	89 e5                	mov    %esp,%ebp
  return fork();
}
80106443:	5d                   	pop    %ebp
  return fork();
80106444:	e9 87 d8 ff ff       	jmp    80103cd0 <fork>
80106449:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106450 <sys_exit>:

int
sys_exit(void)
{
80106450:	55                   	push   %ebp
80106451:	89 e5                	mov    %esp,%ebp
80106453:	83 ec 08             	sub    $0x8,%esp
  exit();
80106456:	e8 35 e3 ff ff       	call   80104790 <exit>
  return 0;  // not reached
}
8010645b:	31 c0                	xor    %eax,%eax
8010645d:	c9                   	leave  
8010645e:	c3                   	ret    
8010645f:	90                   	nop

80106460 <sys_wait>:

int
sys_wait(void)
{
80106460:	55                   	push   %ebp
80106461:	89 e5                	mov    %esp,%ebp
  return wait();
}
80106463:	5d                   	pop    %ebp
  return wait();
80106464:	e9 b7 e5 ff ff       	jmp    80104a20 <wait>
80106469:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106470 <sys_kill>:

int
sys_kill(void)
{
80106470:	55                   	push   %ebp
80106471:	89 e5                	mov    %esp,%ebp
80106473:	83 ec 20             	sub    $0x20,%esp
  int pid;

  if(argint(0, &pid) < 0)
80106476:	8d 45 f4             	lea    -0xc(%ebp),%eax
80106479:	50                   	push   %eax
8010647a:	6a 00                	push   $0x0
8010647c:	e8 8f f2 ff ff       	call   80105710 <argint>
80106481:	83 c4 10             	add    $0x10,%esp
80106484:	85 c0                	test   %eax,%eax
80106486:	78 18                	js     801064a0 <sys_kill+0x30>
    return -1;
  return kill(pid);
80106488:	83 ec 0c             	sub    $0xc,%esp
8010648b:	ff 75 f4             	pushl  -0xc(%ebp)
8010648e:	e8 0d e7 ff ff       	call   80104ba0 <kill>
80106493:	83 c4 10             	add    $0x10,%esp
}
80106496:	c9                   	leave  
80106497:	c3                   	ret    
80106498:	90                   	nop
80106499:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
801064a0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801064a5:	c9                   	leave  
801064a6:	c3                   	ret    
801064a7:	89 f6                	mov    %esi,%esi
801064a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801064b0 <sys_getpid>:

int
sys_getpid(void)
{
801064b0:	55                   	push   %ebp
801064b1:	89 e5                	mov    %esp,%ebp
801064b3:	83 ec 08             	sub    $0x8,%esp
  return myproc()->pid;
801064b6:	e8 e5 d3 ff ff       	call   801038a0 <myproc>
801064bb:	8b 40 10             	mov    0x10(%eax),%eax
}
801064be:	c9                   	leave  
801064bf:	c3                   	ret    

801064c0 <sys_sbrk>:

int
sys_sbrk(void)
{
801064c0:	55                   	push   %ebp
801064c1:	89 e5                	mov    %esp,%ebp
801064c3:	53                   	push   %ebx
  int addr;
  int n;

  if(argint(0, &n) < 0)
801064c4:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
801064c7:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &n) < 0)
801064ca:	50                   	push   %eax
801064cb:	6a 00                	push   $0x0
801064cd:	e8 3e f2 ff ff       	call   80105710 <argint>
801064d2:	83 c4 10             	add    $0x10,%esp
801064d5:	85 c0                	test   %eax,%eax
801064d7:	78 27                	js     80106500 <sys_sbrk+0x40>
    return -1;
  addr = myproc()->sz;
801064d9:	e8 c2 d3 ff ff       	call   801038a0 <myproc>
  if(growproc(n) < 0)
801064de:	83 ec 0c             	sub    $0xc,%esp
  addr = myproc()->sz;
801064e1:	8b 18                	mov    (%eax),%ebx
  if(growproc(n) < 0)
801064e3:	ff 75 f4             	pushl  -0xc(%ebp)
801064e6:	e8 65 d7 ff ff       	call   80103c50 <growproc>
801064eb:	83 c4 10             	add    $0x10,%esp
801064ee:	85 c0                	test   %eax,%eax
801064f0:	78 0e                	js     80106500 <sys_sbrk+0x40>
    return -1;
  return addr;
}
801064f2:	89 d8                	mov    %ebx,%eax
801064f4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801064f7:	c9                   	leave  
801064f8:	c3                   	ret    
801064f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80106500:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80106505:	eb eb                	jmp    801064f2 <sys_sbrk+0x32>
80106507:	89 f6                	mov    %esi,%esi
80106509:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106510 <sys_sleep>:

int
sys_sleep(void)
{
80106510:	55                   	push   %ebp
80106511:	89 e5                	mov    %esp,%ebp
80106513:	53                   	push   %ebx
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
80106514:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80106517:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &n) < 0)
8010651a:	50                   	push   %eax
8010651b:	6a 00                	push   $0x0
8010651d:	e8 ee f1 ff ff       	call   80105710 <argint>
80106522:	83 c4 10             	add    $0x10,%esp
80106525:	85 c0                	test   %eax,%eax
80106527:	0f 88 8a 00 00 00    	js     801065b7 <sys_sleep+0xa7>
    return -1;
  acquire(&tickslock);
8010652d:	83 ec 0c             	sub    $0xc,%esp
80106530:	68 c0 7d 11 80       	push   $0x80117dc0
80106535:	e8 c6 ed ff ff       	call   80105300 <acquire>
  ticks0 = ticks;
  while(ticks - ticks0 < n){
8010653a:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010653d:	83 c4 10             	add    $0x10,%esp
  ticks0 = ticks;
80106540:	8b 1d 00 86 11 80    	mov    0x80118600,%ebx
  while(ticks - ticks0 < n){
80106546:	85 d2                	test   %edx,%edx
80106548:	75 27                	jne    80106571 <sys_sleep+0x61>
8010654a:	eb 54                	jmp    801065a0 <sys_sleep+0x90>
8010654c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
80106550:	83 ec 08             	sub    $0x8,%esp
80106553:	68 c0 7d 11 80       	push   $0x80117dc0
80106558:	68 00 86 11 80       	push   $0x80118600
8010655d:	e8 fe e3 ff ff       	call   80104960 <sleep>
  while(ticks - ticks0 < n){
80106562:	a1 00 86 11 80       	mov    0x80118600,%eax
80106567:	83 c4 10             	add    $0x10,%esp
8010656a:	29 d8                	sub    %ebx,%eax
8010656c:	3b 45 f4             	cmp    -0xc(%ebp),%eax
8010656f:	73 2f                	jae    801065a0 <sys_sleep+0x90>
    if(myproc()->killed){
80106571:	e8 2a d3 ff ff       	call   801038a0 <myproc>
80106576:	8b 40 24             	mov    0x24(%eax),%eax
80106579:	85 c0                	test   %eax,%eax
8010657b:	74 d3                	je     80106550 <sys_sleep+0x40>
      release(&tickslock);
8010657d:	83 ec 0c             	sub    $0xc,%esp
80106580:	68 c0 7d 11 80       	push   $0x80117dc0
80106585:	e8 36 ee ff ff       	call   801053c0 <release>
      return -1;
8010658a:	83 c4 10             	add    $0x10,%esp
8010658d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  release(&tickslock);
  return 0;
}
80106592:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80106595:	c9                   	leave  
80106596:	c3                   	ret    
80106597:	89 f6                	mov    %esi,%esi
80106599:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  release(&tickslock);
801065a0:	83 ec 0c             	sub    $0xc,%esp
801065a3:	68 c0 7d 11 80       	push   $0x80117dc0
801065a8:	e8 13 ee ff ff       	call   801053c0 <release>
  return 0;
801065ad:	83 c4 10             	add    $0x10,%esp
801065b0:	31 c0                	xor    %eax,%eax
}
801065b2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801065b5:	c9                   	leave  
801065b6:	c3                   	ret    
    return -1;
801065b7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801065bc:	eb f4                	jmp    801065b2 <sys_sleep+0xa2>
801065be:	66 90                	xchg   %ax,%ax

801065c0 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
801065c0:	55                   	push   %ebp
801065c1:	89 e5                	mov    %esp,%ebp
801065c3:	53                   	push   %ebx
801065c4:	83 ec 10             	sub    $0x10,%esp
  uint xticks;

  acquire(&tickslock);
801065c7:	68 c0 7d 11 80       	push   $0x80117dc0
801065cc:	e8 2f ed ff ff       	call   80105300 <acquire>
  xticks = ticks;
801065d1:	8b 1d 00 86 11 80    	mov    0x80118600,%ebx
  release(&tickslock);
801065d7:	c7 04 24 c0 7d 11 80 	movl   $0x80117dc0,(%esp)
801065de:	e8 dd ed ff ff       	call   801053c0 <release>
  return xticks;
}
801065e3:	89 d8                	mov    %ebx,%eax
801065e5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801065e8:	c9                   	leave  
801065e9:	c3                   	ret    
801065ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801065f0 <sys_cps>:

int sys_cps( void )
{
801065f0:	55                   	push   %ebp
801065f1:	89 e5                	mov    %esp,%ebp
	return cps();
}
801065f3:	5d                   	pop    %ebp
	return cps();
801065f4:	e9 57 e8 ff ff       	jmp    80104e50 <cps>
801065f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106600 <sys_chpr>:

int sys_chpr(void)
{
80106600:	55                   	push   %ebp
80106601:	89 e5                	mov    %esp,%ebp
80106603:	83 ec 20             	sub    $0x20,%esp
	int pid,pr;
	if(argint(0, &pid)<0)
80106606:	8d 45 f0             	lea    -0x10(%ebp),%eax
80106609:	50                   	push   %eax
8010660a:	6a 00                	push   $0x0
8010660c:	e8 ff f0 ff ff       	call   80105710 <argint>
80106611:	83 c4 10             	add    $0x10,%esp
80106614:	85 c0                	test   %eax,%eax
80106616:	78 28                	js     80106640 <sys_chpr+0x40>
		return -1;
	if(argint(1,&pr)<0)
80106618:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010661b:	83 ec 08             	sub    $0x8,%esp
8010661e:	50                   	push   %eax
8010661f:	6a 01                	push   $0x1
80106621:	e8 ea f0 ff ff       	call   80105710 <argint>
80106626:	83 c4 10             	add    $0x10,%esp
80106629:	85 c0                	test   %eax,%eax
8010662b:	78 13                	js     80106640 <sys_chpr+0x40>
		return -1;
	return chpr(pid,pr);
8010662d:	83 ec 08             	sub    $0x8,%esp
80106630:	ff 75 f4             	pushl  -0xc(%ebp)
80106633:	ff 75 f0             	pushl  -0x10(%ebp)
80106636:	e8 75 e9 ff ff       	call   80104fb0 <chpr>
8010663b:	83 c4 10             	add    $0x10,%esp
}
8010663e:	c9                   	leave  
8010663f:	c3                   	ret    
		return -1;
80106640:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106645:	c9                   	leave  
80106646:	c3                   	ret    
80106647:	89 f6                	mov    %esi,%esi
80106649:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106650 <sys_waitx>:

int sys_waitx(void)
{
80106650:	55                   	push   %ebp
80106651:	89 e5                	mov    %esp,%ebp
80106653:	83 ec 1c             	sub    $0x1c,%esp
  int *wtime;
  int *rtime;

  if (argptr(0, (char **)&wtime, sizeof(int)) < 0)
80106656:	8d 45 f0             	lea    -0x10(%ebp),%eax
80106659:	6a 04                	push   $0x4
8010665b:	50                   	push   %eax
8010665c:	6a 00                	push   $0x0
8010665e:	e8 fd f0 ff ff       	call   80105760 <argptr>
80106663:	83 c4 10             	add    $0x10,%esp
80106666:	85 c0                	test   %eax,%eax
80106668:	78 2e                	js     80106698 <sys_waitx+0x48>
    return -1;

  if (argptr(1, (char **)&rtime, sizeof(int)) < 0)
8010666a:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010666d:	83 ec 04             	sub    $0x4,%esp
80106670:	6a 04                	push   $0x4
80106672:	50                   	push   %eax
80106673:	6a 01                	push   $0x1
80106675:	e8 e6 f0 ff ff       	call   80105760 <argptr>
8010667a:	83 c4 10             	add    $0x10,%esp
8010667d:	85 c0                	test   %eax,%eax
8010667f:	78 17                	js     80106698 <sys_waitx+0x48>
    return -1;

  return waitx(wtime, rtime);
80106681:	83 ec 08             	sub    $0x8,%esp
80106684:	ff 75 f4             	pushl  -0xc(%ebp)
80106687:	ff 75 f0             	pushl  -0x10(%ebp)
8010668a:	e8 71 e6 ff ff       	call   80104d00 <waitx>
8010668f:	83 c4 10             	add    $0x10,%esp
}
80106692:	c9                   	leave  
80106693:	c3                   	ret    
80106694:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80106698:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010669d:	c9                   	leave  
8010669e:	c3                   	ret    
8010669f:	90                   	nop

801066a0 <sys_setPriority>:

int sys_setPriority(void)
{
801066a0:	55                   	push   %ebp
801066a1:	89 e5                	mov    %esp,%ebp
801066a3:	83 ec 20             	sub    $0x20,%esp
  int pid, priority;
  if(argint(0,&pid)<0)
801066a6:	8d 45 f0             	lea    -0x10(%ebp),%eax
801066a9:	50                   	push   %eax
801066aa:	6a 00                	push   $0x0
801066ac:	e8 5f f0 ff ff       	call   80105710 <argint>
801066b1:	83 c4 10             	add    $0x10,%esp
801066b4:	85 c0                	test   %eax,%eax
801066b6:	78 28                	js     801066e0 <sys_setPriority+0x40>
    return -1;
  if(argint(1,&priority)<0)
801066b8:	8d 45 f4             	lea    -0xc(%ebp),%eax
801066bb:	83 ec 08             	sub    $0x8,%esp
801066be:	50                   	push   %eax
801066bf:	6a 01                	push   $0x1
801066c1:	e8 4a f0 ff ff       	call   80105710 <argint>
801066c6:	83 c4 10             	add    $0x10,%esp
801066c9:	85 c0                	test   %eax,%eax
801066cb:	78 13                	js     801066e0 <sys_setPriority+0x40>
    return -1;
  return setPriority(priority,pid);
801066cd:	83 ec 08             	sub    $0x8,%esp
801066d0:	ff 75 f0             	pushl  -0x10(%ebp)
801066d3:	ff 75 f4             	pushl  -0xc(%ebp)
801066d6:	e8 25 e9 ff ff       	call   80105000 <setPriority>
801066db:	83 c4 10             	add    $0x10,%esp
801066de:	c9                   	leave  
801066df:	c3                   	ret    
    return -1;
801066e0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801066e5:	c9                   	leave  
801066e6:	c3                   	ret    

801066e7 <alltraps>:

  # vectors.S sends all traps here.
.globl alltraps
alltraps:
  # Build trap frame.
  pushl %ds
801066e7:	1e                   	push   %ds
  pushl %es
801066e8:	06                   	push   %es
  pushl %fs
801066e9:	0f a0                	push   %fs
  pushl %gs
801066eb:	0f a8                	push   %gs
  pushal
801066ed:	60                   	pusha  
  
  # Set up data segments.
  movw $(SEG_KDATA<<3), %ax
801066ee:	66 b8 10 00          	mov    $0x10,%ax
  movw %ax, %ds
801066f2:	8e d8                	mov    %eax,%ds
  movw %ax, %es
801066f4:	8e c0                	mov    %eax,%es

  # Call trap(tf), where tf=%esp
  pushl %esp
801066f6:	54                   	push   %esp
  call trap
801066f7:	e8 c4 00 00 00       	call   801067c0 <trap>
  addl $4, %esp
801066fc:	83 c4 04             	add    $0x4,%esp

801066ff <trapret>:

  # Return falls through to trapret...
.globl trapret
trapret:
  popal
801066ff:	61                   	popa   
  popl %gs
80106700:	0f a9                	pop    %gs
  popl %fs
80106702:	0f a1                	pop    %fs
  popl %es
80106704:	07                   	pop    %es
  popl %ds
80106705:	1f                   	pop    %ds
  addl $0x8, %esp  # trapno and errcode
80106706:	83 c4 08             	add    $0x8,%esp
  iret
80106709:	cf                   	iret   
8010670a:	66 90                	xchg   %ax,%ax
8010670c:	66 90                	xchg   %ax,%ax
8010670e:	66 90                	xchg   %ax,%ax

80106710 <tvinit>:
extern uint vectors[]; // in vectors.S: array of 256 entry pointers
struct spinlock tickslock;
uint ticks;

void tvinit(void)
{
80106710:	55                   	push   %ebp
  int i;

  for (i = 0; i < 256; i++)
80106711:	31 c0                	xor    %eax,%eax
{
80106713:	89 e5                	mov    %esp,%ebp
80106715:	83 ec 08             	sub    $0x8,%esp
80106718:	90                   	nop
80106719:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    SETGATE(idt[i], 0, SEG_KCODE << 3, vectors[i], 0);
80106720:	8b 14 85 30 b0 10 80 	mov    -0x7fef4fd0(,%eax,4),%edx
80106727:	c7 04 c5 02 7e 11 80 	movl   $0x8e000008,-0x7fee81fe(,%eax,8)
8010672e:	08 00 00 8e 
80106732:	66 89 14 c5 00 7e 11 	mov    %dx,-0x7fee8200(,%eax,8)
80106739:	80 
8010673a:	c1 ea 10             	shr    $0x10,%edx
8010673d:	66 89 14 c5 06 7e 11 	mov    %dx,-0x7fee81fa(,%eax,8)
80106744:	80 
  for (i = 0; i < 256; i++)
80106745:	83 c0 01             	add    $0x1,%eax
80106748:	3d 00 01 00 00       	cmp    $0x100,%eax
8010674d:	75 d1                	jne    80106720 <tvinit+0x10>
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE << 3, vectors[T_SYSCALL], DPL_USER);
8010674f:	a1 30 b1 10 80       	mov    0x8010b130,%eax

  initlock(&tickslock, "time");
80106754:	83 ec 08             	sub    $0x8,%esp
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE << 3, vectors[T_SYSCALL], DPL_USER);
80106757:	c7 05 02 80 11 80 08 	movl   $0xef000008,0x80118002
8010675e:	00 00 ef 
  initlock(&tickslock, "time");
80106761:	68 09 89 10 80       	push   $0x80108909
80106766:	68 c0 7d 11 80       	push   $0x80117dc0
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE << 3, vectors[T_SYSCALL], DPL_USER);
8010676b:	66 a3 00 80 11 80    	mov    %ax,0x80118000
80106771:	c1 e8 10             	shr    $0x10,%eax
80106774:	66 a3 06 80 11 80    	mov    %ax,0x80118006
  initlock(&tickslock, "time");
8010677a:	e8 41 ea ff ff       	call   801051c0 <initlock>
}
8010677f:	83 c4 10             	add    $0x10,%esp
80106782:	c9                   	leave  
80106783:	c3                   	ret    
80106784:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010678a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80106790 <idtinit>:

void idtinit(void)
{
80106790:	55                   	push   %ebp
  pd[0] = size-1;
80106791:	b8 ff 07 00 00       	mov    $0x7ff,%eax
80106796:	89 e5                	mov    %esp,%ebp
80106798:	83 ec 10             	sub    $0x10,%esp
8010679b:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
8010679f:	b8 00 7e 11 80       	mov    $0x80117e00,%eax
801067a4:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
801067a8:	c1 e8 10             	shr    $0x10,%eax
801067ab:	66 89 45 fe          	mov    %ax,-0x2(%ebp)
  asm volatile("lidt (%0)" : : "r" (pd));
801067af:	8d 45 fa             	lea    -0x6(%ebp),%eax
801067b2:	0f 01 18             	lidtl  (%eax)
  lidt(idt, sizeof(idt));
}
801067b5:	c9                   	leave  
801067b6:	c3                   	ret    
801067b7:	89 f6                	mov    %esi,%esi
801067b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801067c0 <trap>:

//PAGEBREAK: 41
void trap(struct trapframe *tf)
{
801067c0:	55                   	push   %ebp
801067c1:	89 e5                	mov    %esp,%ebp
801067c3:	57                   	push   %edi
801067c4:	56                   	push   %esi
801067c5:	53                   	push   %ebx
801067c6:	83 ec 1c             	sub    $0x1c,%esp
801067c9:	8b 7d 08             	mov    0x8(%ebp),%edi
  struct proc *proc = myproc();
801067cc:	e8 cf d0 ff ff       	call   801038a0 <myproc>
801067d1:	89 c3                	mov    %eax,%ebx
  if (tf->trapno == T_SYSCALL)
801067d3:	8b 47 30             	mov    0x30(%edi),%eax
801067d6:	83 f8 40             	cmp    $0x40,%eax
801067d9:	0f 84 e9 00 00 00    	je     801068c8 <trap+0x108>
    if (myproc()->killed)
      exit();
    return;
  }

  switch (tf->trapno)
801067df:	83 e8 20             	sub    $0x20,%eax
801067e2:	83 f8 1f             	cmp    $0x1f,%eax
801067e5:	77 09                	ja     801067f0 <trap+0x30>
801067e7:	ff 24 85 c0 89 10 80 	jmp    *-0x7fef7640(,%eax,4)
801067ee:	66 90                	xchg   %ax,%ax
    lapiceoi();
    break;

  //PAGEBREAK: 13
  default:
    if (myproc() == 0 || (tf->cs & 3) == 0)
801067f0:	e8 ab d0 ff ff       	call   801038a0 <myproc>
801067f5:	85 c0                	test   %eax,%eax
801067f7:	0f 84 79 02 00 00    	je     80106a76 <trap+0x2b6>
801067fd:	f6 47 3c 03          	testb  $0x3,0x3c(%edi)
80106801:	0f 84 6f 02 00 00    	je     80106a76 <trap+0x2b6>

static inline uint
rcr2(void)
{
  uint val;
  asm volatile("movl %%cr2,%0" : "=r" (val));
80106807:	0f 20 d1             	mov    %cr2,%ecx
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpuid(), tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
8010680a:	8b 57 38             	mov    0x38(%edi),%edx
8010680d:	89 4d d8             	mov    %ecx,-0x28(%ebp)
80106810:	89 55 dc             	mov    %edx,-0x24(%ebp)
80106813:	e8 68 d0 ff ff       	call   80103880 <cpuid>
80106818:	8b 77 34             	mov    0x34(%edi),%esi
8010681b:	8b 5f 30             	mov    0x30(%edi),%ebx
8010681e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            "eip 0x%x addr 0x%x--kill proc\n",
            myproc()->pid, myproc()->name, tf->trapno,
80106821:	e8 7a d0 ff ff       	call   801038a0 <myproc>
80106826:	89 45 e0             	mov    %eax,-0x20(%ebp)
80106829:	e8 72 d0 ff ff       	call   801038a0 <myproc>
    cprintf("pid %d %s: trap %d err %d on cpu %d "
8010682e:	8b 4d d8             	mov    -0x28(%ebp),%ecx
80106831:	8b 55 dc             	mov    -0x24(%ebp),%edx
80106834:	51                   	push   %ecx
80106835:	52                   	push   %edx
            myproc()->pid, myproc()->name, tf->trapno,
80106836:	8b 55 e0             	mov    -0x20(%ebp),%edx
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80106839:	ff 75 e4             	pushl  -0x1c(%ebp)
8010683c:	56                   	push   %esi
8010683d:	53                   	push   %ebx
            myproc()->pid, myproc()->name, tf->trapno,
8010683e:	83 c2 6c             	add    $0x6c,%edx
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80106841:	52                   	push   %edx
80106842:	ff 70 10             	pushl  0x10(%eax)
80106845:	68 7c 89 10 80       	push   $0x8010897c
8010684a:	e8 11 9e ff ff       	call   80100660 <cprintf>
            tf->err, cpuid(), tf->eip, rcr2());
    myproc()->killed = 1;
8010684f:	83 c4 20             	add    $0x20,%esp
80106852:	e8 49 d0 ff ff       	call   801038a0 <myproc>
80106857:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running
  // until it gets to the regular system call return.)
  if (myproc() && myproc()->killed && (tf->cs & 3) == DPL_USER)
8010685e:	e8 3d d0 ff ff       	call   801038a0 <myproc>
80106863:	85 c0                	test   %eax,%eax
80106865:	74 1d                	je     80106884 <trap+0xc4>
80106867:	e8 34 d0 ff ff       	call   801038a0 <myproc>
8010686c:	8b 50 24             	mov    0x24(%eax),%edx
8010686f:	85 d2                	test   %edx,%edx
80106871:	74 11                	je     80106884 <trap+0xc4>
80106873:	0f b7 47 3c          	movzwl 0x3c(%edi),%eax
80106877:	83 e0 03             	and    $0x3,%eax
8010687a:	66 83 f8 03          	cmp    $0x3,%ax
8010687e:	0f 84 4c 01 00 00    	je     801069d0 <trap+0x210>
    exit();

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if (myproc() && myproc()->state == RUNNING && tf->trapno == T_IRQ0 + IRQ_TIMER)
80106884:	e8 17 d0 ff ff       	call   801038a0 <myproc>
80106889:	85 c0                	test   %eax,%eax
8010688b:	74 0b                	je     80106898 <trap+0xd8>
8010688d:	e8 0e d0 ff ff       	call   801038a0 <myproc>
80106892:	83 78 0c 04          	cmpl   $0x4,0xc(%eax)
80106896:	74 68                	je     80106900 <trap+0x140>
    #endif
    #endif
    #endif
  }
  // Check if the process has been killed since we yielded
  if (myproc() && myproc()->killed && (tf->cs & 3) == DPL_USER)
80106898:	e8 03 d0 ff ff       	call   801038a0 <myproc>
8010689d:	85 c0                	test   %eax,%eax
8010689f:	74 19                	je     801068ba <trap+0xfa>
801068a1:	e8 fa cf ff ff       	call   801038a0 <myproc>
801068a6:	8b 40 24             	mov    0x24(%eax),%eax
801068a9:	85 c0                	test   %eax,%eax
801068ab:	74 0d                	je     801068ba <trap+0xfa>
801068ad:	0f b7 47 3c          	movzwl 0x3c(%edi),%eax
801068b1:	83 e0 03             	and    $0x3,%eax
801068b4:	66 83 f8 03          	cmp    $0x3,%ax
801068b8:	74 37                	je     801068f1 <trap+0x131>
    exit();
801068ba:	8d 65 f4             	lea    -0xc(%ebp),%esp
801068bd:	5b                   	pop    %ebx
801068be:	5e                   	pop    %esi
801068bf:	5f                   	pop    %edi
801068c0:	5d                   	pop    %ebp
801068c1:	c3                   	ret    
801068c2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if (myproc()->killed)
801068c8:	e8 d3 cf ff ff       	call   801038a0 <myproc>
801068cd:	8b 58 24             	mov    0x24(%eax),%ebx
801068d0:	85 db                	test   %ebx,%ebx
801068d2:	0f 85 e8 00 00 00    	jne    801069c0 <trap+0x200>
    myproc()->tf = tf;
801068d8:	e8 c3 cf ff ff       	call   801038a0 <myproc>
801068dd:	89 78 18             	mov    %edi,0x18(%eax)
    syscall();
801068e0:	e8 1b ef ff ff       	call   80105800 <syscall>
    if (myproc()->killed)
801068e5:	e8 b6 cf ff ff       	call   801038a0 <myproc>
801068ea:	8b 48 24             	mov    0x24(%eax),%ecx
801068ed:	85 c9                	test   %ecx,%ecx
801068ef:	74 c9                	je     801068ba <trap+0xfa>
801068f1:	8d 65 f4             	lea    -0xc(%ebp),%esp
801068f4:	5b                   	pop    %ebx
801068f5:	5e                   	pop    %esi
801068f6:	5f                   	pop    %edi
801068f7:	5d                   	pop    %ebp
      exit();
801068f8:	e9 93 de ff ff       	jmp    80104790 <exit>
801068fd:	8d 76 00             	lea    0x0(%esi),%esi
  if (myproc() && myproc()->state == RUNNING && tf->trapno == T_IRQ0 + IRQ_TIMER)
80106900:	83 7f 30 20          	cmpl   $0x20,0x30(%edi)
80106904:	75 92                	jne    80106898 <trap+0xd8>
        yield();
80106906:	e8 e5 df ff ff       	call   801048f0 <yield>
8010690b:	eb 8b                	jmp    80106898 <trap+0xd8>
8010690d:	8d 76 00             	lea    0x0(%esi),%esi
    if (cpuid() == 0)
80106910:	e8 6b cf ff ff       	call   80103880 <cpuid>
80106915:	85 c0                	test   %eax,%eax
80106917:	0f 84 c3 00 00 00    	je     801069e0 <trap+0x220>
    lapiceoi();
8010691d:	e8 2e be ff ff       	call   80102750 <lapiceoi>
  if (myproc() && myproc()->killed && (tf->cs & 3) == DPL_USER)
80106922:	e8 79 cf ff ff       	call   801038a0 <myproc>
80106927:	85 c0                	test   %eax,%eax
80106929:	0f 85 38 ff ff ff    	jne    80106867 <trap+0xa7>
8010692f:	e9 50 ff ff ff       	jmp    80106884 <trap+0xc4>
80106934:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    kbdintr();
80106938:	e8 d3 bc ff ff       	call   80102610 <kbdintr>
    lapiceoi();
8010693d:	e8 0e be ff ff       	call   80102750 <lapiceoi>
  if (myproc() && myproc()->killed && (tf->cs & 3) == DPL_USER)
80106942:	e8 59 cf ff ff       	call   801038a0 <myproc>
80106947:	85 c0                	test   %eax,%eax
80106949:	0f 85 18 ff ff ff    	jne    80106867 <trap+0xa7>
8010694f:	e9 30 ff ff ff       	jmp    80106884 <trap+0xc4>
80106954:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    uartintr();
80106958:	e8 e3 02 00 00       	call   80106c40 <uartintr>
    lapiceoi();
8010695d:	e8 ee bd ff ff       	call   80102750 <lapiceoi>
  if (myproc() && myproc()->killed && (tf->cs & 3) == DPL_USER)
80106962:	e8 39 cf ff ff       	call   801038a0 <myproc>
80106967:	85 c0                	test   %eax,%eax
80106969:	0f 85 f8 fe ff ff    	jne    80106867 <trap+0xa7>
8010696f:	e9 10 ff ff ff       	jmp    80106884 <trap+0xc4>
80106974:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
80106978:	0f b7 5f 3c          	movzwl 0x3c(%edi),%ebx
8010697c:	8b 77 38             	mov    0x38(%edi),%esi
8010697f:	e8 fc ce ff ff       	call   80103880 <cpuid>
80106984:	56                   	push   %esi
80106985:	53                   	push   %ebx
80106986:	50                   	push   %eax
80106987:	68 24 89 10 80       	push   $0x80108924
8010698c:	e8 cf 9c ff ff       	call   80100660 <cprintf>
    lapiceoi();
80106991:	e8 ba bd ff ff       	call   80102750 <lapiceoi>
    break;
80106996:	83 c4 10             	add    $0x10,%esp
  if (myproc() && myproc()->killed && (tf->cs & 3) == DPL_USER)
80106999:	e8 02 cf ff ff       	call   801038a0 <myproc>
8010699e:	85 c0                	test   %eax,%eax
801069a0:	0f 85 c1 fe ff ff    	jne    80106867 <trap+0xa7>
801069a6:	e9 d9 fe ff ff       	jmp    80106884 <trap+0xc4>
801069ab:	90                   	nop
801069ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    ideintr();
801069b0:	e8 cb b6 ff ff       	call   80102080 <ideintr>
801069b5:	e9 63 ff ff ff       	jmp    8010691d <trap+0x15d>
801069ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      exit();
801069c0:	e8 cb dd ff ff       	call   80104790 <exit>
801069c5:	e9 0e ff ff ff       	jmp    801068d8 <trap+0x118>
801069ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    exit();
801069d0:	e8 bb dd ff ff       	call   80104790 <exit>
801069d5:	e9 aa fe ff ff       	jmp    80106884 <trap+0xc4>
801069da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      acquire(&tickslock);
801069e0:	83 ec 0c             	sub    $0xc,%esp
801069e3:	68 c0 7d 11 80       	push   $0x80117dc0
801069e8:	e8 13 e9 ff ff       	call   80105300 <acquire>
      wakeup(&ticks);
801069ed:	c7 04 24 00 86 11 80 	movl   $0x80118600,(%esp)
      ticks++;
801069f4:	83 05 00 86 11 80 01 	addl   $0x1,0x80118600
      wakeup(&ticks);
801069fb:	e8 30 e1 ff ff       	call   80104b30 <wakeup>
      release(&tickslock);
80106a00:	c7 04 24 c0 7d 11 80 	movl   $0x80117dc0,(%esp)
80106a07:	e8 b4 e9 ff ff       	call   801053c0 <release>
      if (proc)
80106a0c:	83 c4 10             	add    $0x10,%esp
80106a0f:	85 db                	test   %ebx,%ebx
80106a11:	0f 84 06 ff ff ff    	je     8010691d <trap+0x15d>
        if (proc->state == SLEEPING)
80106a17:	83 7b 0c 02          	cmpl   $0x2,0xc(%ebx)
80106a1b:	75 13                	jne    80106a30 <trap+0x270>
          proc->iotime+=1;
80106a1d:	83 83 88 00 00 00 01 	addl   $0x1,0x88(%ebx)
80106a24:	e9 f4 fe ff ff       	jmp    8010691d <trap+0x15d>
80106a29:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  else if (myproc()->state == RUNNING)
80106a30:	e8 6b ce ff ff       	call   801038a0 <myproc>
80106a35:	83 78 0c 04          	cmpl   $0x4,0xc(%eax)
80106a39:	0f 85 de fe ff ff    	jne    8010691d <trap+0x15d>
          myproc()->rtime++;
80106a3f:	e8 5c ce ff ff       	call   801038a0 <myproc>
80106a44:	83 80 84 00 00 00 01 	addl   $0x1,0x84(%eax)
          myproc()->ticks[proc->current_queue]+=1;
80106a4b:	e8 50 ce ff ff       	call   801038a0 <myproc>
80106a50:	8b 93 a4 00 00 00    	mov    0xa4(%ebx),%edx
80106a56:	83 84 90 d4 00 00 00 	addl   $0x1,0xd4(%eax,%edx,4)
80106a5d:	01 
          myproc()->total_ticks[proc->current_queue]+=1;
80106a5e:	e8 3d ce ff ff       	call   801038a0 <myproc>
80106a63:	8b 93 a4 00 00 00    	mov    0xa4(%ebx),%edx
80106a69:	83 84 90 a8 00 00 00 	addl   $0x1,0xa8(%eax,%edx,4)
80106a70:	01 
80106a71:	e9 a7 fe ff ff       	jmp    8010691d <trap+0x15d>
      if(myproc()==0)
80106a76:	e8 25 ce ff ff       	call   801038a0 <myproc>
80106a7b:	85 c0                	test   %eax,%eax
80106a7d:	74 3b                	je     80106aba <trap+0x2fa>
        cprintf("lala\n");
80106a7f:	83 ec 0c             	sub    $0xc,%esp
80106a82:	68 16 89 10 80       	push   $0x80108916
80106a87:	e8 d4 9b ff ff       	call   80100660 <cprintf>
80106a8c:	83 c4 10             	add    $0x10,%esp
80106a8f:	0f 20 d6             	mov    %cr2,%esi
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
80106a92:	8b 5f 38             	mov    0x38(%edi),%ebx
80106a95:	e8 e6 cd ff ff       	call   80103880 <cpuid>
80106a9a:	83 ec 0c             	sub    $0xc,%esp
80106a9d:	56                   	push   %esi
80106a9e:	53                   	push   %ebx
80106a9f:	50                   	push   %eax
80106aa0:	ff 77 30             	pushl  0x30(%edi)
80106aa3:	68 48 89 10 80       	push   $0x80108948
80106aa8:	e8 b3 9b ff ff       	call   80100660 <cprintf>
      panic("trap");
80106aad:	83 c4 14             	add    $0x14,%esp
80106ab0:	68 1c 89 10 80       	push   $0x8010891c
80106ab5:	e8 d6 98 ff ff       	call   80100390 <panic>
        cprintf("myproc\n");
80106aba:	83 ec 0c             	sub    $0xc,%esp
80106abd:	68 0e 89 10 80       	push   $0x8010890e
80106ac2:	e8 99 9b ff ff       	call   80100660 <cprintf>
80106ac7:	83 c4 10             	add    $0x10,%esp
80106aca:	eb c3                	jmp    80106a8f <trap+0x2cf>
80106acc:	66 90                	xchg   %ax,%ax
80106ace:	66 90                	xchg   %ax,%ax

80106ad0 <uartgetc>:
}

static int
uartgetc(void)
{
  if(!uart)
80106ad0:	a1 dc b5 10 80       	mov    0x8010b5dc,%eax
{
80106ad5:	55                   	push   %ebp
80106ad6:	89 e5                	mov    %esp,%ebp
  if(!uart)
80106ad8:	85 c0                	test   %eax,%eax
80106ada:	74 1c                	je     80106af8 <uartgetc+0x28>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80106adc:	ba fd 03 00 00       	mov    $0x3fd,%edx
80106ae1:	ec                   	in     (%dx),%al
    return -1;
  if(!(inb(COM1+5) & 0x01))
80106ae2:	a8 01                	test   $0x1,%al
80106ae4:	74 12                	je     80106af8 <uartgetc+0x28>
80106ae6:	ba f8 03 00 00       	mov    $0x3f8,%edx
80106aeb:	ec                   	in     (%dx),%al
    return -1;
  return inb(COM1+0);
80106aec:	0f b6 c0             	movzbl %al,%eax
}
80106aef:	5d                   	pop    %ebp
80106af0:	c3                   	ret    
80106af1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80106af8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106afd:	5d                   	pop    %ebp
80106afe:	c3                   	ret    
80106aff:	90                   	nop

80106b00 <uartputc.part.0>:
uartputc(int c)
80106b00:	55                   	push   %ebp
80106b01:	89 e5                	mov    %esp,%ebp
80106b03:	57                   	push   %edi
80106b04:	56                   	push   %esi
80106b05:	53                   	push   %ebx
80106b06:	89 c7                	mov    %eax,%edi
80106b08:	bb 80 00 00 00       	mov    $0x80,%ebx
80106b0d:	be fd 03 00 00       	mov    $0x3fd,%esi
80106b12:	83 ec 0c             	sub    $0xc,%esp
80106b15:	eb 1b                	jmp    80106b32 <uartputc.part.0+0x32>
80106b17:	89 f6                	mov    %esi,%esi
80106b19:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    microdelay(10);
80106b20:	83 ec 0c             	sub    $0xc,%esp
80106b23:	6a 0a                	push   $0xa
80106b25:	e8 46 bc ff ff       	call   80102770 <microdelay>
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
80106b2a:	83 c4 10             	add    $0x10,%esp
80106b2d:	83 eb 01             	sub    $0x1,%ebx
80106b30:	74 07                	je     80106b39 <uartputc.part.0+0x39>
80106b32:	89 f2                	mov    %esi,%edx
80106b34:	ec                   	in     (%dx),%al
80106b35:	a8 20                	test   $0x20,%al
80106b37:	74 e7                	je     80106b20 <uartputc.part.0+0x20>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80106b39:	ba f8 03 00 00       	mov    $0x3f8,%edx
80106b3e:	89 f8                	mov    %edi,%eax
80106b40:	ee                   	out    %al,(%dx)
}
80106b41:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106b44:	5b                   	pop    %ebx
80106b45:	5e                   	pop    %esi
80106b46:	5f                   	pop    %edi
80106b47:	5d                   	pop    %ebp
80106b48:	c3                   	ret    
80106b49:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106b50 <uartinit>:
{
80106b50:	55                   	push   %ebp
80106b51:	31 c9                	xor    %ecx,%ecx
80106b53:	89 c8                	mov    %ecx,%eax
80106b55:	89 e5                	mov    %esp,%ebp
80106b57:	57                   	push   %edi
80106b58:	56                   	push   %esi
80106b59:	53                   	push   %ebx
80106b5a:	bb fa 03 00 00       	mov    $0x3fa,%ebx
80106b5f:	89 da                	mov    %ebx,%edx
80106b61:	83 ec 0c             	sub    $0xc,%esp
80106b64:	ee                   	out    %al,(%dx)
80106b65:	bf fb 03 00 00       	mov    $0x3fb,%edi
80106b6a:	b8 80 ff ff ff       	mov    $0xffffff80,%eax
80106b6f:	89 fa                	mov    %edi,%edx
80106b71:	ee                   	out    %al,(%dx)
80106b72:	b8 0c 00 00 00       	mov    $0xc,%eax
80106b77:	ba f8 03 00 00       	mov    $0x3f8,%edx
80106b7c:	ee                   	out    %al,(%dx)
80106b7d:	be f9 03 00 00       	mov    $0x3f9,%esi
80106b82:	89 c8                	mov    %ecx,%eax
80106b84:	89 f2                	mov    %esi,%edx
80106b86:	ee                   	out    %al,(%dx)
80106b87:	b8 03 00 00 00       	mov    $0x3,%eax
80106b8c:	89 fa                	mov    %edi,%edx
80106b8e:	ee                   	out    %al,(%dx)
80106b8f:	ba fc 03 00 00       	mov    $0x3fc,%edx
80106b94:	89 c8                	mov    %ecx,%eax
80106b96:	ee                   	out    %al,(%dx)
80106b97:	b8 01 00 00 00       	mov    $0x1,%eax
80106b9c:	89 f2                	mov    %esi,%edx
80106b9e:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80106b9f:	ba fd 03 00 00       	mov    $0x3fd,%edx
80106ba4:	ec                   	in     (%dx),%al
  if(inb(COM1+5) == 0xFF)
80106ba5:	3c ff                	cmp    $0xff,%al
80106ba7:	74 5a                	je     80106c03 <uartinit+0xb3>
  uart = 1;
80106ba9:	c7 05 dc b5 10 80 01 	movl   $0x1,0x8010b5dc
80106bb0:	00 00 00 
80106bb3:	89 da                	mov    %ebx,%edx
80106bb5:	ec                   	in     (%dx),%al
80106bb6:	ba f8 03 00 00       	mov    $0x3f8,%edx
80106bbb:	ec                   	in     (%dx),%al
  ioapicenable(IRQ_COM1, 0);
80106bbc:	83 ec 08             	sub    $0x8,%esp
  for(p="xv6...\n"; *p; p++)
80106bbf:	bb 40 8a 10 80       	mov    $0x80108a40,%ebx
  ioapicenable(IRQ_COM1, 0);
80106bc4:	6a 00                	push   $0x0
80106bc6:	6a 04                	push   $0x4
80106bc8:	e8 03 b7 ff ff       	call   801022d0 <ioapicenable>
80106bcd:	83 c4 10             	add    $0x10,%esp
  for(p="xv6...\n"; *p; p++)
80106bd0:	b8 78 00 00 00       	mov    $0x78,%eax
80106bd5:	eb 13                	jmp    80106bea <uartinit+0x9a>
80106bd7:	89 f6                	mov    %esi,%esi
80106bd9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80106be0:	83 c3 01             	add    $0x1,%ebx
80106be3:	0f be 03             	movsbl (%ebx),%eax
80106be6:	84 c0                	test   %al,%al
80106be8:	74 19                	je     80106c03 <uartinit+0xb3>
  if(!uart)
80106bea:	8b 15 dc b5 10 80    	mov    0x8010b5dc,%edx
80106bf0:	85 d2                	test   %edx,%edx
80106bf2:	74 ec                	je     80106be0 <uartinit+0x90>
  for(p="xv6...\n"; *p; p++)
80106bf4:	83 c3 01             	add    $0x1,%ebx
80106bf7:	e8 04 ff ff ff       	call   80106b00 <uartputc.part.0>
80106bfc:	0f be 03             	movsbl (%ebx),%eax
80106bff:	84 c0                	test   %al,%al
80106c01:	75 e7                	jne    80106bea <uartinit+0x9a>
}
80106c03:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106c06:	5b                   	pop    %ebx
80106c07:	5e                   	pop    %esi
80106c08:	5f                   	pop    %edi
80106c09:	5d                   	pop    %ebp
80106c0a:	c3                   	ret    
80106c0b:	90                   	nop
80106c0c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80106c10 <uartputc>:
  if(!uart)
80106c10:	8b 15 dc b5 10 80    	mov    0x8010b5dc,%edx
{
80106c16:	55                   	push   %ebp
80106c17:	89 e5                	mov    %esp,%ebp
  if(!uart)
80106c19:	85 d2                	test   %edx,%edx
{
80106c1b:	8b 45 08             	mov    0x8(%ebp),%eax
  if(!uart)
80106c1e:	74 10                	je     80106c30 <uartputc+0x20>
}
80106c20:	5d                   	pop    %ebp
80106c21:	e9 da fe ff ff       	jmp    80106b00 <uartputc.part.0>
80106c26:	8d 76 00             	lea    0x0(%esi),%esi
80106c29:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80106c30:	5d                   	pop    %ebp
80106c31:	c3                   	ret    
80106c32:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106c39:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106c40 <uartintr>:

void
uartintr(void)
{
80106c40:	55                   	push   %ebp
80106c41:	89 e5                	mov    %esp,%ebp
80106c43:	83 ec 14             	sub    $0x14,%esp
  consoleintr(uartgetc);
80106c46:	68 d0 6a 10 80       	push   $0x80106ad0
80106c4b:	e8 c0 9b ff ff       	call   80100810 <consoleintr>
}
80106c50:	83 c4 10             	add    $0x10,%esp
80106c53:	c9                   	leave  
80106c54:	c3                   	ret    

80106c55 <vector0>:
# generated by vectors.pl - do not edit
# handlers
.globl alltraps
.globl vector0
vector0:
  pushl $0
80106c55:	6a 00                	push   $0x0
  pushl $0
80106c57:	6a 00                	push   $0x0
  jmp alltraps
80106c59:	e9 89 fa ff ff       	jmp    801066e7 <alltraps>

80106c5e <vector1>:
.globl vector1
vector1:
  pushl $0
80106c5e:	6a 00                	push   $0x0
  pushl $1
80106c60:	6a 01                	push   $0x1
  jmp alltraps
80106c62:	e9 80 fa ff ff       	jmp    801066e7 <alltraps>

80106c67 <vector2>:
.globl vector2
vector2:
  pushl $0
80106c67:	6a 00                	push   $0x0
  pushl $2
80106c69:	6a 02                	push   $0x2
  jmp alltraps
80106c6b:	e9 77 fa ff ff       	jmp    801066e7 <alltraps>

80106c70 <vector3>:
.globl vector3
vector3:
  pushl $0
80106c70:	6a 00                	push   $0x0
  pushl $3
80106c72:	6a 03                	push   $0x3
  jmp alltraps
80106c74:	e9 6e fa ff ff       	jmp    801066e7 <alltraps>

80106c79 <vector4>:
.globl vector4
vector4:
  pushl $0
80106c79:	6a 00                	push   $0x0
  pushl $4
80106c7b:	6a 04                	push   $0x4
  jmp alltraps
80106c7d:	e9 65 fa ff ff       	jmp    801066e7 <alltraps>

80106c82 <vector5>:
.globl vector5
vector5:
  pushl $0
80106c82:	6a 00                	push   $0x0
  pushl $5
80106c84:	6a 05                	push   $0x5
  jmp alltraps
80106c86:	e9 5c fa ff ff       	jmp    801066e7 <alltraps>

80106c8b <vector6>:
.globl vector6
vector6:
  pushl $0
80106c8b:	6a 00                	push   $0x0
  pushl $6
80106c8d:	6a 06                	push   $0x6
  jmp alltraps
80106c8f:	e9 53 fa ff ff       	jmp    801066e7 <alltraps>

80106c94 <vector7>:
.globl vector7
vector7:
  pushl $0
80106c94:	6a 00                	push   $0x0
  pushl $7
80106c96:	6a 07                	push   $0x7
  jmp alltraps
80106c98:	e9 4a fa ff ff       	jmp    801066e7 <alltraps>

80106c9d <vector8>:
.globl vector8
vector8:
  pushl $8
80106c9d:	6a 08                	push   $0x8
  jmp alltraps
80106c9f:	e9 43 fa ff ff       	jmp    801066e7 <alltraps>

80106ca4 <vector9>:
.globl vector9
vector9:
  pushl $0
80106ca4:	6a 00                	push   $0x0
  pushl $9
80106ca6:	6a 09                	push   $0x9
  jmp alltraps
80106ca8:	e9 3a fa ff ff       	jmp    801066e7 <alltraps>

80106cad <vector10>:
.globl vector10
vector10:
  pushl $10
80106cad:	6a 0a                	push   $0xa
  jmp alltraps
80106caf:	e9 33 fa ff ff       	jmp    801066e7 <alltraps>

80106cb4 <vector11>:
.globl vector11
vector11:
  pushl $11
80106cb4:	6a 0b                	push   $0xb
  jmp alltraps
80106cb6:	e9 2c fa ff ff       	jmp    801066e7 <alltraps>

80106cbb <vector12>:
.globl vector12
vector12:
  pushl $12
80106cbb:	6a 0c                	push   $0xc
  jmp alltraps
80106cbd:	e9 25 fa ff ff       	jmp    801066e7 <alltraps>

80106cc2 <vector13>:
.globl vector13
vector13:
  pushl $13
80106cc2:	6a 0d                	push   $0xd
  jmp alltraps
80106cc4:	e9 1e fa ff ff       	jmp    801066e7 <alltraps>

80106cc9 <vector14>:
.globl vector14
vector14:
  pushl $14
80106cc9:	6a 0e                	push   $0xe
  jmp alltraps
80106ccb:	e9 17 fa ff ff       	jmp    801066e7 <alltraps>

80106cd0 <vector15>:
.globl vector15
vector15:
  pushl $0
80106cd0:	6a 00                	push   $0x0
  pushl $15
80106cd2:	6a 0f                	push   $0xf
  jmp alltraps
80106cd4:	e9 0e fa ff ff       	jmp    801066e7 <alltraps>

80106cd9 <vector16>:
.globl vector16
vector16:
  pushl $0
80106cd9:	6a 00                	push   $0x0
  pushl $16
80106cdb:	6a 10                	push   $0x10
  jmp alltraps
80106cdd:	e9 05 fa ff ff       	jmp    801066e7 <alltraps>

80106ce2 <vector17>:
.globl vector17
vector17:
  pushl $17
80106ce2:	6a 11                	push   $0x11
  jmp alltraps
80106ce4:	e9 fe f9 ff ff       	jmp    801066e7 <alltraps>

80106ce9 <vector18>:
.globl vector18
vector18:
  pushl $0
80106ce9:	6a 00                	push   $0x0
  pushl $18
80106ceb:	6a 12                	push   $0x12
  jmp alltraps
80106ced:	e9 f5 f9 ff ff       	jmp    801066e7 <alltraps>

80106cf2 <vector19>:
.globl vector19
vector19:
  pushl $0
80106cf2:	6a 00                	push   $0x0
  pushl $19
80106cf4:	6a 13                	push   $0x13
  jmp alltraps
80106cf6:	e9 ec f9 ff ff       	jmp    801066e7 <alltraps>

80106cfb <vector20>:
.globl vector20
vector20:
  pushl $0
80106cfb:	6a 00                	push   $0x0
  pushl $20
80106cfd:	6a 14                	push   $0x14
  jmp alltraps
80106cff:	e9 e3 f9 ff ff       	jmp    801066e7 <alltraps>

80106d04 <vector21>:
.globl vector21
vector21:
  pushl $0
80106d04:	6a 00                	push   $0x0
  pushl $21
80106d06:	6a 15                	push   $0x15
  jmp alltraps
80106d08:	e9 da f9 ff ff       	jmp    801066e7 <alltraps>

80106d0d <vector22>:
.globl vector22
vector22:
  pushl $0
80106d0d:	6a 00                	push   $0x0
  pushl $22
80106d0f:	6a 16                	push   $0x16
  jmp alltraps
80106d11:	e9 d1 f9 ff ff       	jmp    801066e7 <alltraps>

80106d16 <vector23>:
.globl vector23
vector23:
  pushl $0
80106d16:	6a 00                	push   $0x0
  pushl $23
80106d18:	6a 17                	push   $0x17
  jmp alltraps
80106d1a:	e9 c8 f9 ff ff       	jmp    801066e7 <alltraps>

80106d1f <vector24>:
.globl vector24
vector24:
  pushl $0
80106d1f:	6a 00                	push   $0x0
  pushl $24
80106d21:	6a 18                	push   $0x18
  jmp alltraps
80106d23:	e9 bf f9 ff ff       	jmp    801066e7 <alltraps>

80106d28 <vector25>:
.globl vector25
vector25:
  pushl $0
80106d28:	6a 00                	push   $0x0
  pushl $25
80106d2a:	6a 19                	push   $0x19
  jmp alltraps
80106d2c:	e9 b6 f9 ff ff       	jmp    801066e7 <alltraps>

80106d31 <vector26>:
.globl vector26
vector26:
  pushl $0
80106d31:	6a 00                	push   $0x0
  pushl $26
80106d33:	6a 1a                	push   $0x1a
  jmp alltraps
80106d35:	e9 ad f9 ff ff       	jmp    801066e7 <alltraps>

80106d3a <vector27>:
.globl vector27
vector27:
  pushl $0
80106d3a:	6a 00                	push   $0x0
  pushl $27
80106d3c:	6a 1b                	push   $0x1b
  jmp alltraps
80106d3e:	e9 a4 f9 ff ff       	jmp    801066e7 <alltraps>

80106d43 <vector28>:
.globl vector28
vector28:
  pushl $0
80106d43:	6a 00                	push   $0x0
  pushl $28
80106d45:	6a 1c                	push   $0x1c
  jmp alltraps
80106d47:	e9 9b f9 ff ff       	jmp    801066e7 <alltraps>

80106d4c <vector29>:
.globl vector29
vector29:
  pushl $0
80106d4c:	6a 00                	push   $0x0
  pushl $29
80106d4e:	6a 1d                	push   $0x1d
  jmp alltraps
80106d50:	e9 92 f9 ff ff       	jmp    801066e7 <alltraps>

80106d55 <vector30>:
.globl vector30
vector30:
  pushl $0
80106d55:	6a 00                	push   $0x0
  pushl $30
80106d57:	6a 1e                	push   $0x1e
  jmp alltraps
80106d59:	e9 89 f9 ff ff       	jmp    801066e7 <alltraps>

80106d5e <vector31>:
.globl vector31
vector31:
  pushl $0
80106d5e:	6a 00                	push   $0x0
  pushl $31
80106d60:	6a 1f                	push   $0x1f
  jmp alltraps
80106d62:	e9 80 f9 ff ff       	jmp    801066e7 <alltraps>

80106d67 <vector32>:
.globl vector32
vector32:
  pushl $0
80106d67:	6a 00                	push   $0x0
  pushl $32
80106d69:	6a 20                	push   $0x20
  jmp alltraps
80106d6b:	e9 77 f9 ff ff       	jmp    801066e7 <alltraps>

80106d70 <vector33>:
.globl vector33
vector33:
  pushl $0
80106d70:	6a 00                	push   $0x0
  pushl $33
80106d72:	6a 21                	push   $0x21
  jmp alltraps
80106d74:	e9 6e f9 ff ff       	jmp    801066e7 <alltraps>

80106d79 <vector34>:
.globl vector34
vector34:
  pushl $0
80106d79:	6a 00                	push   $0x0
  pushl $34
80106d7b:	6a 22                	push   $0x22
  jmp alltraps
80106d7d:	e9 65 f9 ff ff       	jmp    801066e7 <alltraps>

80106d82 <vector35>:
.globl vector35
vector35:
  pushl $0
80106d82:	6a 00                	push   $0x0
  pushl $35
80106d84:	6a 23                	push   $0x23
  jmp alltraps
80106d86:	e9 5c f9 ff ff       	jmp    801066e7 <alltraps>

80106d8b <vector36>:
.globl vector36
vector36:
  pushl $0
80106d8b:	6a 00                	push   $0x0
  pushl $36
80106d8d:	6a 24                	push   $0x24
  jmp alltraps
80106d8f:	e9 53 f9 ff ff       	jmp    801066e7 <alltraps>

80106d94 <vector37>:
.globl vector37
vector37:
  pushl $0
80106d94:	6a 00                	push   $0x0
  pushl $37
80106d96:	6a 25                	push   $0x25
  jmp alltraps
80106d98:	e9 4a f9 ff ff       	jmp    801066e7 <alltraps>

80106d9d <vector38>:
.globl vector38
vector38:
  pushl $0
80106d9d:	6a 00                	push   $0x0
  pushl $38
80106d9f:	6a 26                	push   $0x26
  jmp alltraps
80106da1:	e9 41 f9 ff ff       	jmp    801066e7 <alltraps>

80106da6 <vector39>:
.globl vector39
vector39:
  pushl $0
80106da6:	6a 00                	push   $0x0
  pushl $39
80106da8:	6a 27                	push   $0x27
  jmp alltraps
80106daa:	e9 38 f9 ff ff       	jmp    801066e7 <alltraps>

80106daf <vector40>:
.globl vector40
vector40:
  pushl $0
80106daf:	6a 00                	push   $0x0
  pushl $40
80106db1:	6a 28                	push   $0x28
  jmp alltraps
80106db3:	e9 2f f9 ff ff       	jmp    801066e7 <alltraps>

80106db8 <vector41>:
.globl vector41
vector41:
  pushl $0
80106db8:	6a 00                	push   $0x0
  pushl $41
80106dba:	6a 29                	push   $0x29
  jmp alltraps
80106dbc:	e9 26 f9 ff ff       	jmp    801066e7 <alltraps>

80106dc1 <vector42>:
.globl vector42
vector42:
  pushl $0
80106dc1:	6a 00                	push   $0x0
  pushl $42
80106dc3:	6a 2a                	push   $0x2a
  jmp alltraps
80106dc5:	e9 1d f9 ff ff       	jmp    801066e7 <alltraps>

80106dca <vector43>:
.globl vector43
vector43:
  pushl $0
80106dca:	6a 00                	push   $0x0
  pushl $43
80106dcc:	6a 2b                	push   $0x2b
  jmp alltraps
80106dce:	e9 14 f9 ff ff       	jmp    801066e7 <alltraps>

80106dd3 <vector44>:
.globl vector44
vector44:
  pushl $0
80106dd3:	6a 00                	push   $0x0
  pushl $44
80106dd5:	6a 2c                	push   $0x2c
  jmp alltraps
80106dd7:	e9 0b f9 ff ff       	jmp    801066e7 <alltraps>

80106ddc <vector45>:
.globl vector45
vector45:
  pushl $0
80106ddc:	6a 00                	push   $0x0
  pushl $45
80106dde:	6a 2d                	push   $0x2d
  jmp alltraps
80106de0:	e9 02 f9 ff ff       	jmp    801066e7 <alltraps>

80106de5 <vector46>:
.globl vector46
vector46:
  pushl $0
80106de5:	6a 00                	push   $0x0
  pushl $46
80106de7:	6a 2e                	push   $0x2e
  jmp alltraps
80106de9:	e9 f9 f8 ff ff       	jmp    801066e7 <alltraps>

80106dee <vector47>:
.globl vector47
vector47:
  pushl $0
80106dee:	6a 00                	push   $0x0
  pushl $47
80106df0:	6a 2f                	push   $0x2f
  jmp alltraps
80106df2:	e9 f0 f8 ff ff       	jmp    801066e7 <alltraps>

80106df7 <vector48>:
.globl vector48
vector48:
  pushl $0
80106df7:	6a 00                	push   $0x0
  pushl $48
80106df9:	6a 30                	push   $0x30
  jmp alltraps
80106dfb:	e9 e7 f8 ff ff       	jmp    801066e7 <alltraps>

80106e00 <vector49>:
.globl vector49
vector49:
  pushl $0
80106e00:	6a 00                	push   $0x0
  pushl $49
80106e02:	6a 31                	push   $0x31
  jmp alltraps
80106e04:	e9 de f8 ff ff       	jmp    801066e7 <alltraps>

80106e09 <vector50>:
.globl vector50
vector50:
  pushl $0
80106e09:	6a 00                	push   $0x0
  pushl $50
80106e0b:	6a 32                	push   $0x32
  jmp alltraps
80106e0d:	e9 d5 f8 ff ff       	jmp    801066e7 <alltraps>

80106e12 <vector51>:
.globl vector51
vector51:
  pushl $0
80106e12:	6a 00                	push   $0x0
  pushl $51
80106e14:	6a 33                	push   $0x33
  jmp alltraps
80106e16:	e9 cc f8 ff ff       	jmp    801066e7 <alltraps>

80106e1b <vector52>:
.globl vector52
vector52:
  pushl $0
80106e1b:	6a 00                	push   $0x0
  pushl $52
80106e1d:	6a 34                	push   $0x34
  jmp alltraps
80106e1f:	e9 c3 f8 ff ff       	jmp    801066e7 <alltraps>

80106e24 <vector53>:
.globl vector53
vector53:
  pushl $0
80106e24:	6a 00                	push   $0x0
  pushl $53
80106e26:	6a 35                	push   $0x35
  jmp alltraps
80106e28:	e9 ba f8 ff ff       	jmp    801066e7 <alltraps>

80106e2d <vector54>:
.globl vector54
vector54:
  pushl $0
80106e2d:	6a 00                	push   $0x0
  pushl $54
80106e2f:	6a 36                	push   $0x36
  jmp alltraps
80106e31:	e9 b1 f8 ff ff       	jmp    801066e7 <alltraps>

80106e36 <vector55>:
.globl vector55
vector55:
  pushl $0
80106e36:	6a 00                	push   $0x0
  pushl $55
80106e38:	6a 37                	push   $0x37
  jmp alltraps
80106e3a:	e9 a8 f8 ff ff       	jmp    801066e7 <alltraps>

80106e3f <vector56>:
.globl vector56
vector56:
  pushl $0
80106e3f:	6a 00                	push   $0x0
  pushl $56
80106e41:	6a 38                	push   $0x38
  jmp alltraps
80106e43:	e9 9f f8 ff ff       	jmp    801066e7 <alltraps>

80106e48 <vector57>:
.globl vector57
vector57:
  pushl $0
80106e48:	6a 00                	push   $0x0
  pushl $57
80106e4a:	6a 39                	push   $0x39
  jmp alltraps
80106e4c:	e9 96 f8 ff ff       	jmp    801066e7 <alltraps>

80106e51 <vector58>:
.globl vector58
vector58:
  pushl $0
80106e51:	6a 00                	push   $0x0
  pushl $58
80106e53:	6a 3a                	push   $0x3a
  jmp alltraps
80106e55:	e9 8d f8 ff ff       	jmp    801066e7 <alltraps>

80106e5a <vector59>:
.globl vector59
vector59:
  pushl $0
80106e5a:	6a 00                	push   $0x0
  pushl $59
80106e5c:	6a 3b                	push   $0x3b
  jmp alltraps
80106e5e:	e9 84 f8 ff ff       	jmp    801066e7 <alltraps>

80106e63 <vector60>:
.globl vector60
vector60:
  pushl $0
80106e63:	6a 00                	push   $0x0
  pushl $60
80106e65:	6a 3c                	push   $0x3c
  jmp alltraps
80106e67:	e9 7b f8 ff ff       	jmp    801066e7 <alltraps>

80106e6c <vector61>:
.globl vector61
vector61:
  pushl $0
80106e6c:	6a 00                	push   $0x0
  pushl $61
80106e6e:	6a 3d                	push   $0x3d
  jmp alltraps
80106e70:	e9 72 f8 ff ff       	jmp    801066e7 <alltraps>

80106e75 <vector62>:
.globl vector62
vector62:
  pushl $0
80106e75:	6a 00                	push   $0x0
  pushl $62
80106e77:	6a 3e                	push   $0x3e
  jmp alltraps
80106e79:	e9 69 f8 ff ff       	jmp    801066e7 <alltraps>

80106e7e <vector63>:
.globl vector63
vector63:
  pushl $0
80106e7e:	6a 00                	push   $0x0
  pushl $63
80106e80:	6a 3f                	push   $0x3f
  jmp alltraps
80106e82:	e9 60 f8 ff ff       	jmp    801066e7 <alltraps>

80106e87 <vector64>:
.globl vector64
vector64:
  pushl $0
80106e87:	6a 00                	push   $0x0
  pushl $64
80106e89:	6a 40                	push   $0x40
  jmp alltraps
80106e8b:	e9 57 f8 ff ff       	jmp    801066e7 <alltraps>

80106e90 <vector65>:
.globl vector65
vector65:
  pushl $0
80106e90:	6a 00                	push   $0x0
  pushl $65
80106e92:	6a 41                	push   $0x41
  jmp alltraps
80106e94:	e9 4e f8 ff ff       	jmp    801066e7 <alltraps>

80106e99 <vector66>:
.globl vector66
vector66:
  pushl $0
80106e99:	6a 00                	push   $0x0
  pushl $66
80106e9b:	6a 42                	push   $0x42
  jmp alltraps
80106e9d:	e9 45 f8 ff ff       	jmp    801066e7 <alltraps>

80106ea2 <vector67>:
.globl vector67
vector67:
  pushl $0
80106ea2:	6a 00                	push   $0x0
  pushl $67
80106ea4:	6a 43                	push   $0x43
  jmp alltraps
80106ea6:	e9 3c f8 ff ff       	jmp    801066e7 <alltraps>

80106eab <vector68>:
.globl vector68
vector68:
  pushl $0
80106eab:	6a 00                	push   $0x0
  pushl $68
80106ead:	6a 44                	push   $0x44
  jmp alltraps
80106eaf:	e9 33 f8 ff ff       	jmp    801066e7 <alltraps>

80106eb4 <vector69>:
.globl vector69
vector69:
  pushl $0
80106eb4:	6a 00                	push   $0x0
  pushl $69
80106eb6:	6a 45                	push   $0x45
  jmp alltraps
80106eb8:	e9 2a f8 ff ff       	jmp    801066e7 <alltraps>

80106ebd <vector70>:
.globl vector70
vector70:
  pushl $0
80106ebd:	6a 00                	push   $0x0
  pushl $70
80106ebf:	6a 46                	push   $0x46
  jmp alltraps
80106ec1:	e9 21 f8 ff ff       	jmp    801066e7 <alltraps>

80106ec6 <vector71>:
.globl vector71
vector71:
  pushl $0
80106ec6:	6a 00                	push   $0x0
  pushl $71
80106ec8:	6a 47                	push   $0x47
  jmp alltraps
80106eca:	e9 18 f8 ff ff       	jmp    801066e7 <alltraps>

80106ecf <vector72>:
.globl vector72
vector72:
  pushl $0
80106ecf:	6a 00                	push   $0x0
  pushl $72
80106ed1:	6a 48                	push   $0x48
  jmp alltraps
80106ed3:	e9 0f f8 ff ff       	jmp    801066e7 <alltraps>

80106ed8 <vector73>:
.globl vector73
vector73:
  pushl $0
80106ed8:	6a 00                	push   $0x0
  pushl $73
80106eda:	6a 49                	push   $0x49
  jmp alltraps
80106edc:	e9 06 f8 ff ff       	jmp    801066e7 <alltraps>

80106ee1 <vector74>:
.globl vector74
vector74:
  pushl $0
80106ee1:	6a 00                	push   $0x0
  pushl $74
80106ee3:	6a 4a                	push   $0x4a
  jmp alltraps
80106ee5:	e9 fd f7 ff ff       	jmp    801066e7 <alltraps>

80106eea <vector75>:
.globl vector75
vector75:
  pushl $0
80106eea:	6a 00                	push   $0x0
  pushl $75
80106eec:	6a 4b                	push   $0x4b
  jmp alltraps
80106eee:	e9 f4 f7 ff ff       	jmp    801066e7 <alltraps>

80106ef3 <vector76>:
.globl vector76
vector76:
  pushl $0
80106ef3:	6a 00                	push   $0x0
  pushl $76
80106ef5:	6a 4c                	push   $0x4c
  jmp alltraps
80106ef7:	e9 eb f7 ff ff       	jmp    801066e7 <alltraps>

80106efc <vector77>:
.globl vector77
vector77:
  pushl $0
80106efc:	6a 00                	push   $0x0
  pushl $77
80106efe:	6a 4d                	push   $0x4d
  jmp alltraps
80106f00:	e9 e2 f7 ff ff       	jmp    801066e7 <alltraps>

80106f05 <vector78>:
.globl vector78
vector78:
  pushl $0
80106f05:	6a 00                	push   $0x0
  pushl $78
80106f07:	6a 4e                	push   $0x4e
  jmp alltraps
80106f09:	e9 d9 f7 ff ff       	jmp    801066e7 <alltraps>

80106f0e <vector79>:
.globl vector79
vector79:
  pushl $0
80106f0e:	6a 00                	push   $0x0
  pushl $79
80106f10:	6a 4f                	push   $0x4f
  jmp alltraps
80106f12:	e9 d0 f7 ff ff       	jmp    801066e7 <alltraps>

80106f17 <vector80>:
.globl vector80
vector80:
  pushl $0
80106f17:	6a 00                	push   $0x0
  pushl $80
80106f19:	6a 50                	push   $0x50
  jmp alltraps
80106f1b:	e9 c7 f7 ff ff       	jmp    801066e7 <alltraps>

80106f20 <vector81>:
.globl vector81
vector81:
  pushl $0
80106f20:	6a 00                	push   $0x0
  pushl $81
80106f22:	6a 51                	push   $0x51
  jmp alltraps
80106f24:	e9 be f7 ff ff       	jmp    801066e7 <alltraps>

80106f29 <vector82>:
.globl vector82
vector82:
  pushl $0
80106f29:	6a 00                	push   $0x0
  pushl $82
80106f2b:	6a 52                	push   $0x52
  jmp alltraps
80106f2d:	e9 b5 f7 ff ff       	jmp    801066e7 <alltraps>

80106f32 <vector83>:
.globl vector83
vector83:
  pushl $0
80106f32:	6a 00                	push   $0x0
  pushl $83
80106f34:	6a 53                	push   $0x53
  jmp alltraps
80106f36:	e9 ac f7 ff ff       	jmp    801066e7 <alltraps>

80106f3b <vector84>:
.globl vector84
vector84:
  pushl $0
80106f3b:	6a 00                	push   $0x0
  pushl $84
80106f3d:	6a 54                	push   $0x54
  jmp alltraps
80106f3f:	e9 a3 f7 ff ff       	jmp    801066e7 <alltraps>

80106f44 <vector85>:
.globl vector85
vector85:
  pushl $0
80106f44:	6a 00                	push   $0x0
  pushl $85
80106f46:	6a 55                	push   $0x55
  jmp alltraps
80106f48:	e9 9a f7 ff ff       	jmp    801066e7 <alltraps>

80106f4d <vector86>:
.globl vector86
vector86:
  pushl $0
80106f4d:	6a 00                	push   $0x0
  pushl $86
80106f4f:	6a 56                	push   $0x56
  jmp alltraps
80106f51:	e9 91 f7 ff ff       	jmp    801066e7 <alltraps>

80106f56 <vector87>:
.globl vector87
vector87:
  pushl $0
80106f56:	6a 00                	push   $0x0
  pushl $87
80106f58:	6a 57                	push   $0x57
  jmp alltraps
80106f5a:	e9 88 f7 ff ff       	jmp    801066e7 <alltraps>

80106f5f <vector88>:
.globl vector88
vector88:
  pushl $0
80106f5f:	6a 00                	push   $0x0
  pushl $88
80106f61:	6a 58                	push   $0x58
  jmp alltraps
80106f63:	e9 7f f7 ff ff       	jmp    801066e7 <alltraps>

80106f68 <vector89>:
.globl vector89
vector89:
  pushl $0
80106f68:	6a 00                	push   $0x0
  pushl $89
80106f6a:	6a 59                	push   $0x59
  jmp alltraps
80106f6c:	e9 76 f7 ff ff       	jmp    801066e7 <alltraps>

80106f71 <vector90>:
.globl vector90
vector90:
  pushl $0
80106f71:	6a 00                	push   $0x0
  pushl $90
80106f73:	6a 5a                	push   $0x5a
  jmp alltraps
80106f75:	e9 6d f7 ff ff       	jmp    801066e7 <alltraps>

80106f7a <vector91>:
.globl vector91
vector91:
  pushl $0
80106f7a:	6a 00                	push   $0x0
  pushl $91
80106f7c:	6a 5b                	push   $0x5b
  jmp alltraps
80106f7e:	e9 64 f7 ff ff       	jmp    801066e7 <alltraps>

80106f83 <vector92>:
.globl vector92
vector92:
  pushl $0
80106f83:	6a 00                	push   $0x0
  pushl $92
80106f85:	6a 5c                	push   $0x5c
  jmp alltraps
80106f87:	e9 5b f7 ff ff       	jmp    801066e7 <alltraps>

80106f8c <vector93>:
.globl vector93
vector93:
  pushl $0
80106f8c:	6a 00                	push   $0x0
  pushl $93
80106f8e:	6a 5d                	push   $0x5d
  jmp alltraps
80106f90:	e9 52 f7 ff ff       	jmp    801066e7 <alltraps>

80106f95 <vector94>:
.globl vector94
vector94:
  pushl $0
80106f95:	6a 00                	push   $0x0
  pushl $94
80106f97:	6a 5e                	push   $0x5e
  jmp alltraps
80106f99:	e9 49 f7 ff ff       	jmp    801066e7 <alltraps>

80106f9e <vector95>:
.globl vector95
vector95:
  pushl $0
80106f9e:	6a 00                	push   $0x0
  pushl $95
80106fa0:	6a 5f                	push   $0x5f
  jmp alltraps
80106fa2:	e9 40 f7 ff ff       	jmp    801066e7 <alltraps>

80106fa7 <vector96>:
.globl vector96
vector96:
  pushl $0
80106fa7:	6a 00                	push   $0x0
  pushl $96
80106fa9:	6a 60                	push   $0x60
  jmp alltraps
80106fab:	e9 37 f7 ff ff       	jmp    801066e7 <alltraps>

80106fb0 <vector97>:
.globl vector97
vector97:
  pushl $0
80106fb0:	6a 00                	push   $0x0
  pushl $97
80106fb2:	6a 61                	push   $0x61
  jmp alltraps
80106fb4:	e9 2e f7 ff ff       	jmp    801066e7 <alltraps>

80106fb9 <vector98>:
.globl vector98
vector98:
  pushl $0
80106fb9:	6a 00                	push   $0x0
  pushl $98
80106fbb:	6a 62                	push   $0x62
  jmp alltraps
80106fbd:	e9 25 f7 ff ff       	jmp    801066e7 <alltraps>

80106fc2 <vector99>:
.globl vector99
vector99:
  pushl $0
80106fc2:	6a 00                	push   $0x0
  pushl $99
80106fc4:	6a 63                	push   $0x63
  jmp alltraps
80106fc6:	e9 1c f7 ff ff       	jmp    801066e7 <alltraps>

80106fcb <vector100>:
.globl vector100
vector100:
  pushl $0
80106fcb:	6a 00                	push   $0x0
  pushl $100
80106fcd:	6a 64                	push   $0x64
  jmp alltraps
80106fcf:	e9 13 f7 ff ff       	jmp    801066e7 <alltraps>

80106fd4 <vector101>:
.globl vector101
vector101:
  pushl $0
80106fd4:	6a 00                	push   $0x0
  pushl $101
80106fd6:	6a 65                	push   $0x65
  jmp alltraps
80106fd8:	e9 0a f7 ff ff       	jmp    801066e7 <alltraps>

80106fdd <vector102>:
.globl vector102
vector102:
  pushl $0
80106fdd:	6a 00                	push   $0x0
  pushl $102
80106fdf:	6a 66                	push   $0x66
  jmp alltraps
80106fe1:	e9 01 f7 ff ff       	jmp    801066e7 <alltraps>

80106fe6 <vector103>:
.globl vector103
vector103:
  pushl $0
80106fe6:	6a 00                	push   $0x0
  pushl $103
80106fe8:	6a 67                	push   $0x67
  jmp alltraps
80106fea:	e9 f8 f6 ff ff       	jmp    801066e7 <alltraps>

80106fef <vector104>:
.globl vector104
vector104:
  pushl $0
80106fef:	6a 00                	push   $0x0
  pushl $104
80106ff1:	6a 68                	push   $0x68
  jmp alltraps
80106ff3:	e9 ef f6 ff ff       	jmp    801066e7 <alltraps>

80106ff8 <vector105>:
.globl vector105
vector105:
  pushl $0
80106ff8:	6a 00                	push   $0x0
  pushl $105
80106ffa:	6a 69                	push   $0x69
  jmp alltraps
80106ffc:	e9 e6 f6 ff ff       	jmp    801066e7 <alltraps>

80107001 <vector106>:
.globl vector106
vector106:
  pushl $0
80107001:	6a 00                	push   $0x0
  pushl $106
80107003:	6a 6a                	push   $0x6a
  jmp alltraps
80107005:	e9 dd f6 ff ff       	jmp    801066e7 <alltraps>

8010700a <vector107>:
.globl vector107
vector107:
  pushl $0
8010700a:	6a 00                	push   $0x0
  pushl $107
8010700c:	6a 6b                	push   $0x6b
  jmp alltraps
8010700e:	e9 d4 f6 ff ff       	jmp    801066e7 <alltraps>

80107013 <vector108>:
.globl vector108
vector108:
  pushl $0
80107013:	6a 00                	push   $0x0
  pushl $108
80107015:	6a 6c                	push   $0x6c
  jmp alltraps
80107017:	e9 cb f6 ff ff       	jmp    801066e7 <alltraps>

8010701c <vector109>:
.globl vector109
vector109:
  pushl $0
8010701c:	6a 00                	push   $0x0
  pushl $109
8010701e:	6a 6d                	push   $0x6d
  jmp alltraps
80107020:	e9 c2 f6 ff ff       	jmp    801066e7 <alltraps>

80107025 <vector110>:
.globl vector110
vector110:
  pushl $0
80107025:	6a 00                	push   $0x0
  pushl $110
80107027:	6a 6e                	push   $0x6e
  jmp alltraps
80107029:	e9 b9 f6 ff ff       	jmp    801066e7 <alltraps>

8010702e <vector111>:
.globl vector111
vector111:
  pushl $0
8010702e:	6a 00                	push   $0x0
  pushl $111
80107030:	6a 6f                	push   $0x6f
  jmp alltraps
80107032:	e9 b0 f6 ff ff       	jmp    801066e7 <alltraps>

80107037 <vector112>:
.globl vector112
vector112:
  pushl $0
80107037:	6a 00                	push   $0x0
  pushl $112
80107039:	6a 70                	push   $0x70
  jmp alltraps
8010703b:	e9 a7 f6 ff ff       	jmp    801066e7 <alltraps>

80107040 <vector113>:
.globl vector113
vector113:
  pushl $0
80107040:	6a 00                	push   $0x0
  pushl $113
80107042:	6a 71                	push   $0x71
  jmp alltraps
80107044:	e9 9e f6 ff ff       	jmp    801066e7 <alltraps>

80107049 <vector114>:
.globl vector114
vector114:
  pushl $0
80107049:	6a 00                	push   $0x0
  pushl $114
8010704b:	6a 72                	push   $0x72
  jmp alltraps
8010704d:	e9 95 f6 ff ff       	jmp    801066e7 <alltraps>

80107052 <vector115>:
.globl vector115
vector115:
  pushl $0
80107052:	6a 00                	push   $0x0
  pushl $115
80107054:	6a 73                	push   $0x73
  jmp alltraps
80107056:	e9 8c f6 ff ff       	jmp    801066e7 <alltraps>

8010705b <vector116>:
.globl vector116
vector116:
  pushl $0
8010705b:	6a 00                	push   $0x0
  pushl $116
8010705d:	6a 74                	push   $0x74
  jmp alltraps
8010705f:	e9 83 f6 ff ff       	jmp    801066e7 <alltraps>

80107064 <vector117>:
.globl vector117
vector117:
  pushl $0
80107064:	6a 00                	push   $0x0
  pushl $117
80107066:	6a 75                	push   $0x75
  jmp alltraps
80107068:	e9 7a f6 ff ff       	jmp    801066e7 <alltraps>

8010706d <vector118>:
.globl vector118
vector118:
  pushl $0
8010706d:	6a 00                	push   $0x0
  pushl $118
8010706f:	6a 76                	push   $0x76
  jmp alltraps
80107071:	e9 71 f6 ff ff       	jmp    801066e7 <alltraps>

80107076 <vector119>:
.globl vector119
vector119:
  pushl $0
80107076:	6a 00                	push   $0x0
  pushl $119
80107078:	6a 77                	push   $0x77
  jmp alltraps
8010707a:	e9 68 f6 ff ff       	jmp    801066e7 <alltraps>

8010707f <vector120>:
.globl vector120
vector120:
  pushl $0
8010707f:	6a 00                	push   $0x0
  pushl $120
80107081:	6a 78                	push   $0x78
  jmp alltraps
80107083:	e9 5f f6 ff ff       	jmp    801066e7 <alltraps>

80107088 <vector121>:
.globl vector121
vector121:
  pushl $0
80107088:	6a 00                	push   $0x0
  pushl $121
8010708a:	6a 79                	push   $0x79
  jmp alltraps
8010708c:	e9 56 f6 ff ff       	jmp    801066e7 <alltraps>

80107091 <vector122>:
.globl vector122
vector122:
  pushl $0
80107091:	6a 00                	push   $0x0
  pushl $122
80107093:	6a 7a                	push   $0x7a
  jmp alltraps
80107095:	e9 4d f6 ff ff       	jmp    801066e7 <alltraps>

8010709a <vector123>:
.globl vector123
vector123:
  pushl $0
8010709a:	6a 00                	push   $0x0
  pushl $123
8010709c:	6a 7b                	push   $0x7b
  jmp alltraps
8010709e:	e9 44 f6 ff ff       	jmp    801066e7 <alltraps>

801070a3 <vector124>:
.globl vector124
vector124:
  pushl $0
801070a3:	6a 00                	push   $0x0
  pushl $124
801070a5:	6a 7c                	push   $0x7c
  jmp alltraps
801070a7:	e9 3b f6 ff ff       	jmp    801066e7 <alltraps>

801070ac <vector125>:
.globl vector125
vector125:
  pushl $0
801070ac:	6a 00                	push   $0x0
  pushl $125
801070ae:	6a 7d                	push   $0x7d
  jmp alltraps
801070b0:	e9 32 f6 ff ff       	jmp    801066e7 <alltraps>

801070b5 <vector126>:
.globl vector126
vector126:
  pushl $0
801070b5:	6a 00                	push   $0x0
  pushl $126
801070b7:	6a 7e                	push   $0x7e
  jmp alltraps
801070b9:	e9 29 f6 ff ff       	jmp    801066e7 <alltraps>

801070be <vector127>:
.globl vector127
vector127:
  pushl $0
801070be:	6a 00                	push   $0x0
  pushl $127
801070c0:	6a 7f                	push   $0x7f
  jmp alltraps
801070c2:	e9 20 f6 ff ff       	jmp    801066e7 <alltraps>

801070c7 <vector128>:
.globl vector128
vector128:
  pushl $0
801070c7:	6a 00                	push   $0x0
  pushl $128
801070c9:	68 80 00 00 00       	push   $0x80
  jmp alltraps
801070ce:	e9 14 f6 ff ff       	jmp    801066e7 <alltraps>

801070d3 <vector129>:
.globl vector129
vector129:
  pushl $0
801070d3:	6a 00                	push   $0x0
  pushl $129
801070d5:	68 81 00 00 00       	push   $0x81
  jmp alltraps
801070da:	e9 08 f6 ff ff       	jmp    801066e7 <alltraps>

801070df <vector130>:
.globl vector130
vector130:
  pushl $0
801070df:	6a 00                	push   $0x0
  pushl $130
801070e1:	68 82 00 00 00       	push   $0x82
  jmp alltraps
801070e6:	e9 fc f5 ff ff       	jmp    801066e7 <alltraps>

801070eb <vector131>:
.globl vector131
vector131:
  pushl $0
801070eb:	6a 00                	push   $0x0
  pushl $131
801070ed:	68 83 00 00 00       	push   $0x83
  jmp alltraps
801070f2:	e9 f0 f5 ff ff       	jmp    801066e7 <alltraps>

801070f7 <vector132>:
.globl vector132
vector132:
  pushl $0
801070f7:	6a 00                	push   $0x0
  pushl $132
801070f9:	68 84 00 00 00       	push   $0x84
  jmp alltraps
801070fe:	e9 e4 f5 ff ff       	jmp    801066e7 <alltraps>

80107103 <vector133>:
.globl vector133
vector133:
  pushl $0
80107103:	6a 00                	push   $0x0
  pushl $133
80107105:	68 85 00 00 00       	push   $0x85
  jmp alltraps
8010710a:	e9 d8 f5 ff ff       	jmp    801066e7 <alltraps>

8010710f <vector134>:
.globl vector134
vector134:
  pushl $0
8010710f:	6a 00                	push   $0x0
  pushl $134
80107111:	68 86 00 00 00       	push   $0x86
  jmp alltraps
80107116:	e9 cc f5 ff ff       	jmp    801066e7 <alltraps>

8010711b <vector135>:
.globl vector135
vector135:
  pushl $0
8010711b:	6a 00                	push   $0x0
  pushl $135
8010711d:	68 87 00 00 00       	push   $0x87
  jmp alltraps
80107122:	e9 c0 f5 ff ff       	jmp    801066e7 <alltraps>

80107127 <vector136>:
.globl vector136
vector136:
  pushl $0
80107127:	6a 00                	push   $0x0
  pushl $136
80107129:	68 88 00 00 00       	push   $0x88
  jmp alltraps
8010712e:	e9 b4 f5 ff ff       	jmp    801066e7 <alltraps>

80107133 <vector137>:
.globl vector137
vector137:
  pushl $0
80107133:	6a 00                	push   $0x0
  pushl $137
80107135:	68 89 00 00 00       	push   $0x89
  jmp alltraps
8010713a:	e9 a8 f5 ff ff       	jmp    801066e7 <alltraps>

8010713f <vector138>:
.globl vector138
vector138:
  pushl $0
8010713f:	6a 00                	push   $0x0
  pushl $138
80107141:	68 8a 00 00 00       	push   $0x8a
  jmp alltraps
80107146:	e9 9c f5 ff ff       	jmp    801066e7 <alltraps>

8010714b <vector139>:
.globl vector139
vector139:
  pushl $0
8010714b:	6a 00                	push   $0x0
  pushl $139
8010714d:	68 8b 00 00 00       	push   $0x8b
  jmp alltraps
80107152:	e9 90 f5 ff ff       	jmp    801066e7 <alltraps>

80107157 <vector140>:
.globl vector140
vector140:
  pushl $0
80107157:	6a 00                	push   $0x0
  pushl $140
80107159:	68 8c 00 00 00       	push   $0x8c
  jmp alltraps
8010715e:	e9 84 f5 ff ff       	jmp    801066e7 <alltraps>

80107163 <vector141>:
.globl vector141
vector141:
  pushl $0
80107163:	6a 00                	push   $0x0
  pushl $141
80107165:	68 8d 00 00 00       	push   $0x8d
  jmp alltraps
8010716a:	e9 78 f5 ff ff       	jmp    801066e7 <alltraps>

8010716f <vector142>:
.globl vector142
vector142:
  pushl $0
8010716f:	6a 00                	push   $0x0
  pushl $142
80107171:	68 8e 00 00 00       	push   $0x8e
  jmp alltraps
80107176:	e9 6c f5 ff ff       	jmp    801066e7 <alltraps>

8010717b <vector143>:
.globl vector143
vector143:
  pushl $0
8010717b:	6a 00                	push   $0x0
  pushl $143
8010717d:	68 8f 00 00 00       	push   $0x8f
  jmp alltraps
80107182:	e9 60 f5 ff ff       	jmp    801066e7 <alltraps>

80107187 <vector144>:
.globl vector144
vector144:
  pushl $0
80107187:	6a 00                	push   $0x0
  pushl $144
80107189:	68 90 00 00 00       	push   $0x90
  jmp alltraps
8010718e:	e9 54 f5 ff ff       	jmp    801066e7 <alltraps>

80107193 <vector145>:
.globl vector145
vector145:
  pushl $0
80107193:	6a 00                	push   $0x0
  pushl $145
80107195:	68 91 00 00 00       	push   $0x91
  jmp alltraps
8010719a:	e9 48 f5 ff ff       	jmp    801066e7 <alltraps>

8010719f <vector146>:
.globl vector146
vector146:
  pushl $0
8010719f:	6a 00                	push   $0x0
  pushl $146
801071a1:	68 92 00 00 00       	push   $0x92
  jmp alltraps
801071a6:	e9 3c f5 ff ff       	jmp    801066e7 <alltraps>

801071ab <vector147>:
.globl vector147
vector147:
  pushl $0
801071ab:	6a 00                	push   $0x0
  pushl $147
801071ad:	68 93 00 00 00       	push   $0x93
  jmp alltraps
801071b2:	e9 30 f5 ff ff       	jmp    801066e7 <alltraps>

801071b7 <vector148>:
.globl vector148
vector148:
  pushl $0
801071b7:	6a 00                	push   $0x0
  pushl $148
801071b9:	68 94 00 00 00       	push   $0x94
  jmp alltraps
801071be:	e9 24 f5 ff ff       	jmp    801066e7 <alltraps>

801071c3 <vector149>:
.globl vector149
vector149:
  pushl $0
801071c3:	6a 00                	push   $0x0
  pushl $149
801071c5:	68 95 00 00 00       	push   $0x95
  jmp alltraps
801071ca:	e9 18 f5 ff ff       	jmp    801066e7 <alltraps>

801071cf <vector150>:
.globl vector150
vector150:
  pushl $0
801071cf:	6a 00                	push   $0x0
  pushl $150
801071d1:	68 96 00 00 00       	push   $0x96
  jmp alltraps
801071d6:	e9 0c f5 ff ff       	jmp    801066e7 <alltraps>

801071db <vector151>:
.globl vector151
vector151:
  pushl $0
801071db:	6a 00                	push   $0x0
  pushl $151
801071dd:	68 97 00 00 00       	push   $0x97
  jmp alltraps
801071e2:	e9 00 f5 ff ff       	jmp    801066e7 <alltraps>

801071e7 <vector152>:
.globl vector152
vector152:
  pushl $0
801071e7:	6a 00                	push   $0x0
  pushl $152
801071e9:	68 98 00 00 00       	push   $0x98
  jmp alltraps
801071ee:	e9 f4 f4 ff ff       	jmp    801066e7 <alltraps>

801071f3 <vector153>:
.globl vector153
vector153:
  pushl $0
801071f3:	6a 00                	push   $0x0
  pushl $153
801071f5:	68 99 00 00 00       	push   $0x99
  jmp alltraps
801071fa:	e9 e8 f4 ff ff       	jmp    801066e7 <alltraps>

801071ff <vector154>:
.globl vector154
vector154:
  pushl $0
801071ff:	6a 00                	push   $0x0
  pushl $154
80107201:	68 9a 00 00 00       	push   $0x9a
  jmp alltraps
80107206:	e9 dc f4 ff ff       	jmp    801066e7 <alltraps>

8010720b <vector155>:
.globl vector155
vector155:
  pushl $0
8010720b:	6a 00                	push   $0x0
  pushl $155
8010720d:	68 9b 00 00 00       	push   $0x9b
  jmp alltraps
80107212:	e9 d0 f4 ff ff       	jmp    801066e7 <alltraps>

80107217 <vector156>:
.globl vector156
vector156:
  pushl $0
80107217:	6a 00                	push   $0x0
  pushl $156
80107219:	68 9c 00 00 00       	push   $0x9c
  jmp alltraps
8010721e:	e9 c4 f4 ff ff       	jmp    801066e7 <alltraps>

80107223 <vector157>:
.globl vector157
vector157:
  pushl $0
80107223:	6a 00                	push   $0x0
  pushl $157
80107225:	68 9d 00 00 00       	push   $0x9d
  jmp alltraps
8010722a:	e9 b8 f4 ff ff       	jmp    801066e7 <alltraps>

8010722f <vector158>:
.globl vector158
vector158:
  pushl $0
8010722f:	6a 00                	push   $0x0
  pushl $158
80107231:	68 9e 00 00 00       	push   $0x9e
  jmp alltraps
80107236:	e9 ac f4 ff ff       	jmp    801066e7 <alltraps>

8010723b <vector159>:
.globl vector159
vector159:
  pushl $0
8010723b:	6a 00                	push   $0x0
  pushl $159
8010723d:	68 9f 00 00 00       	push   $0x9f
  jmp alltraps
80107242:	e9 a0 f4 ff ff       	jmp    801066e7 <alltraps>

80107247 <vector160>:
.globl vector160
vector160:
  pushl $0
80107247:	6a 00                	push   $0x0
  pushl $160
80107249:	68 a0 00 00 00       	push   $0xa0
  jmp alltraps
8010724e:	e9 94 f4 ff ff       	jmp    801066e7 <alltraps>

80107253 <vector161>:
.globl vector161
vector161:
  pushl $0
80107253:	6a 00                	push   $0x0
  pushl $161
80107255:	68 a1 00 00 00       	push   $0xa1
  jmp alltraps
8010725a:	e9 88 f4 ff ff       	jmp    801066e7 <alltraps>

8010725f <vector162>:
.globl vector162
vector162:
  pushl $0
8010725f:	6a 00                	push   $0x0
  pushl $162
80107261:	68 a2 00 00 00       	push   $0xa2
  jmp alltraps
80107266:	e9 7c f4 ff ff       	jmp    801066e7 <alltraps>

8010726b <vector163>:
.globl vector163
vector163:
  pushl $0
8010726b:	6a 00                	push   $0x0
  pushl $163
8010726d:	68 a3 00 00 00       	push   $0xa3
  jmp alltraps
80107272:	e9 70 f4 ff ff       	jmp    801066e7 <alltraps>

80107277 <vector164>:
.globl vector164
vector164:
  pushl $0
80107277:	6a 00                	push   $0x0
  pushl $164
80107279:	68 a4 00 00 00       	push   $0xa4
  jmp alltraps
8010727e:	e9 64 f4 ff ff       	jmp    801066e7 <alltraps>

80107283 <vector165>:
.globl vector165
vector165:
  pushl $0
80107283:	6a 00                	push   $0x0
  pushl $165
80107285:	68 a5 00 00 00       	push   $0xa5
  jmp alltraps
8010728a:	e9 58 f4 ff ff       	jmp    801066e7 <alltraps>

8010728f <vector166>:
.globl vector166
vector166:
  pushl $0
8010728f:	6a 00                	push   $0x0
  pushl $166
80107291:	68 a6 00 00 00       	push   $0xa6
  jmp alltraps
80107296:	e9 4c f4 ff ff       	jmp    801066e7 <alltraps>

8010729b <vector167>:
.globl vector167
vector167:
  pushl $0
8010729b:	6a 00                	push   $0x0
  pushl $167
8010729d:	68 a7 00 00 00       	push   $0xa7
  jmp alltraps
801072a2:	e9 40 f4 ff ff       	jmp    801066e7 <alltraps>

801072a7 <vector168>:
.globl vector168
vector168:
  pushl $0
801072a7:	6a 00                	push   $0x0
  pushl $168
801072a9:	68 a8 00 00 00       	push   $0xa8
  jmp alltraps
801072ae:	e9 34 f4 ff ff       	jmp    801066e7 <alltraps>

801072b3 <vector169>:
.globl vector169
vector169:
  pushl $0
801072b3:	6a 00                	push   $0x0
  pushl $169
801072b5:	68 a9 00 00 00       	push   $0xa9
  jmp alltraps
801072ba:	e9 28 f4 ff ff       	jmp    801066e7 <alltraps>

801072bf <vector170>:
.globl vector170
vector170:
  pushl $0
801072bf:	6a 00                	push   $0x0
  pushl $170
801072c1:	68 aa 00 00 00       	push   $0xaa
  jmp alltraps
801072c6:	e9 1c f4 ff ff       	jmp    801066e7 <alltraps>

801072cb <vector171>:
.globl vector171
vector171:
  pushl $0
801072cb:	6a 00                	push   $0x0
  pushl $171
801072cd:	68 ab 00 00 00       	push   $0xab
  jmp alltraps
801072d2:	e9 10 f4 ff ff       	jmp    801066e7 <alltraps>

801072d7 <vector172>:
.globl vector172
vector172:
  pushl $0
801072d7:	6a 00                	push   $0x0
  pushl $172
801072d9:	68 ac 00 00 00       	push   $0xac
  jmp alltraps
801072de:	e9 04 f4 ff ff       	jmp    801066e7 <alltraps>

801072e3 <vector173>:
.globl vector173
vector173:
  pushl $0
801072e3:	6a 00                	push   $0x0
  pushl $173
801072e5:	68 ad 00 00 00       	push   $0xad
  jmp alltraps
801072ea:	e9 f8 f3 ff ff       	jmp    801066e7 <alltraps>

801072ef <vector174>:
.globl vector174
vector174:
  pushl $0
801072ef:	6a 00                	push   $0x0
  pushl $174
801072f1:	68 ae 00 00 00       	push   $0xae
  jmp alltraps
801072f6:	e9 ec f3 ff ff       	jmp    801066e7 <alltraps>

801072fb <vector175>:
.globl vector175
vector175:
  pushl $0
801072fb:	6a 00                	push   $0x0
  pushl $175
801072fd:	68 af 00 00 00       	push   $0xaf
  jmp alltraps
80107302:	e9 e0 f3 ff ff       	jmp    801066e7 <alltraps>

80107307 <vector176>:
.globl vector176
vector176:
  pushl $0
80107307:	6a 00                	push   $0x0
  pushl $176
80107309:	68 b0 00 00 00       	push   $0xb0
  jmp alltraps
8010730e:	e9 d4 f3 ff ff       	jmp    801066e7 <alltraps>

80107313 <vector177>:
.globl vector177
vector177:
  pushl $0
80107313:	6a 00                	push   $0x0
  pushl $177
80107315:	68 b1 00 00 00       	push   $0xb1
  jmp alltraps
8010731a:	e9 c8 f3 ff ff       	jmp    801066e7 <alltraps>

8010731f <vector178>:
.globl vector178
vector178:
  pushl $0
8010731f:	6a 00                	push   $0x0
  pushl $178
80107321:	68 b2 00 00 00       	push   $0xb2
  jmp alltraps
80107326:	e9 bc f3 ff ff       	jmp    801066e7 <alltraps>

8010732b <vector179>:
.globl vector179
vector179:
  pushl $0
8010732b:	6a 00                	push   $0x0
  pushl $179
8010732d:	68 b3 00 00 00       	push   $0xb3
  jmp alltraps
80107332:	e9 b0 f3 ff ff       	jmp    801066e7 <alltraps>

80107337 <vector180>:
.globl vector180
vector180:
  pushl $0
80107337:	6a 00                	push   $0x0
  pushl $180
80107339:	68 b4 00 00 00       	push   $0xb4
  jmp alltraps
8010733e:	e9 a4 f3 ff ff       	jmp    801066e7 <alltraps>

80107343 <vector181>:
.globl vector181
vector181:
  pushl $0
80107343:	6a 00                	push   $0x0
  pushl $181
80107345:	68 b5 00 00 00       	push   $0xb5
  jmp alltraps
8010734a:	e9 98 f3 ff ff       	jmp    801066e7 <alltraps>

8010734f <vector182>:
.globl vector182
vector182:
  pushl $0
8010734f:	6a 00                	push   $0x0
  pushl $182
80107351:	68 b6 00 00 00       	push   $0xb6
  jmp alltraps
80107356:	e9 8c f3 ff ff       	jmp    801066e7 <alltraps>

8010735b <vector183>:
.globl vector183
vector183:
  pushl $0
8010735b:	6a 00                	push   $0x0
  pushl $183
8010735d:	68 b7 00 00 00       	push   $0xb7
  jmp alltraps
80107362:	e9 80 f3 ff ff       	jmp    801066e7 <alltraps>

80107367 <vector184>:
.globl vector184
vector184:
  pushl $0
80107367:	6a 00                	push   $0x0
  pushl $184
80107369:	68 b8 00 00 00       	push   $0xb8
  jmp alltraps
8010736e:	e9 74 f3 ff ff       	jmp    801066e7 <alltraps>

80107373 <vector185>:
.globl vector185
vector185:
  pushl $0
80107373:	6a 00                	push   $0x0
  pushl $185
80107375:	68 b9 00 00 00       	push   $0xb9
  jmp alltraps
8010737a:	e9 68 f3 ff ff       	jmp    801066e7 <alltraps>

8010737f <vector186>:
.globl vector186
vector186:
  pushl $0
8010737f:	6a 00                	push   $0x0
  pushl $186
80107381:	68 ba 00 00 00       	push   $0xba
  jmp alltraps
80107386:	e9 5c f3 ff ff       	jmp    801066e7 <alltraps>

8010738b <vector187>:
.globl vector187
vector187:
  pushl $0
8010738b:	6a 00                	push   $0x0
  pushl $187
8010738d:	68 bb 00 00 00       	push   $0xbb
  jmp alltraps
80107392:	e9 50 f3 ff ff       	jmp    801066e7 <alltraps>

80107397 <vector188>:
.globl vector188
vector188:
  pushl $0
80107397:	6a 00                	push   $0x0
  pushl $188
80107399:	68 bc 00 00 00       	push   $0xbc
  jmp alltraps
8010739e:	e9 44 f3 ff ff       	jmp    801066e7 <alltraps>

801073a3 <vector189>:
.globl vector189
vector189:
  pushl $0
801073a3:	6a 00                	push   $0x0
  pushl $189
801073a5:	68 bd 00 00 00       	push   $0xbd
  jmp alltraps
801073aa:	e9 38 f3 ff ff       	jmp    801066e7 <alltraps>

801073af <vector190>:
.globl vector190
vector190:
  pushl $0
801073af:	6a 00                	push   $0x0
  pushl $190
801073b1:	68 be 00 00 00       	push   $0xbe
  jmp alltraps
801073b6:	e9 2c f3 ff ff       	jmp    801066e7 <alltraps>

801073bb <vector191>:
.globl vector191
vector191:
  pushl $0
801073bb:	6a 00                	push   $0x0
  pushl $191
801073bd:	68 bf 00 00 00       	push   $0xbf
  jmp alltraps
801073c2:	e9 20 f3 ff ff       	jmp    801066e7 <alltraps>

801073c7 <vector192>:
.globl vector192
vector192:
  pushl $0
801073c7:	6a 00                	push   $0x0
  pushl $192
801073c9:	68 c0 00 00 00       	push   $0xc0
  jmp alltraps
801073ce:	e9 14 f3 ff ff       	jmp    801066e7 <alltraps>

801073d3 <vector193>:
.globl vector193
vector193:
  pushl $0
801073d3:	6a 00                	push   $0x0
  pushl $193
801073d5:	68 c1 00 00 00       	push   $0xc1
  jmp alltraps
801073da:	e9 08 f3 ff ff       	jmp    801066e7 <alltraps>

801073df <vector194>:
.globl vector194
vector194:
  pushl $0
801073df:	6a 00                	push   $0x0
  pushl $194
801073e1:	68 c2 00 00 00       	push   $0xc2
  jmp alltraps
801073e6:	e9 fc f2 ff ff       	jmp    801066e7 <alltraps>

801073eb <vector195>:
.globl vector195
vector195:
  pushl $0
801073eb:	6a 00                	push   $0x0
  pushl $195
801073ed:	68 c3 00 00 00       	push   $0xc3
  jmp alltraps
801073f2:	e9 f0 f2 ff ff       	jmp    801066e7 <alltraps>

801073f7 <vector196>:
.globl vector196
vector196:
  pushl $0
801073f7:	6a 00                	push   $0x0
  pushl $196
801073f9:	68 c4 00 00 00       	push   $0xc4
  jmp alltraps
801073fe:	e9 e4 f2 ff ff       	jmp    801066e7 <alltraps>

80107403 <vector197>:
.globl vector197
vector197:
  pushl $0
80107403:	6a 00                	push   $0x0
  pushl $197
80107405:	68 c5 00 00 00       	push   $0xc5
  jmp alltraps
8010740a:	e9 d8 f2 ff ff       	jmp    801066e7 <alltraps>

8010740f <vector198>:
.globl vector198
vector198:
  pushl $0
8010740f:	6a 00                	push   $0x0
  pushl $198
80107411:	68 c6 00 00 00       	push   $0xc6
  jmp alltraps
80107416:	e9 cc f2 ff ff       	jmp    801066e7 <alltraps>

8010741b <vector199>:
.globl vector199
vector199:
  pushl $0
8010741b:	6a 00                	push   $0x0
  pushl $199
8010741d:	68 c7 00 00 00       	push   $0xc7
  jmp alltraps
80107422:	e9 c0 f2 ff ff       	jmp    801066e7 <alltraps>

80107427 <vector200>:
.globl vector200
vector200:
  pushl $0
80107427:	6a 00                	push   $0x0
  pushl $200
80107429:	68 c8 00 00 00       	push   $0xc8
  jmp alltraps
8010742e:	e9 b4 f2 ff ff       	jmp    801066e7 <alltraps>

80107433 <vector201>:
.globl vector201
vector201:
  pushl $0
80107433:	6a 00                	push   $0x0
  pushl $201
80107435:	68 c9 00 00 00       	push   $0xc9
  jmp alltraps
8010743a:	e9 a8 f2 ff ff       	jmp    801066e7 <alltraps>

8010743f <vector202>:
.globl vector202
vector202:
  pushl $0
8010743f:	6a 00                	push   $0x0
  pushl $202
80107441:	68 ca 00 00 00       	push   $0xca
  jmp alltraps
80107446:	e9 9c f2 ff ff       	jmp    801066e7 <alltraps>

8010744b <vector203>:
.globl vector203
vector203:
  pushl $0
8010744b:	6a 00                	push   $0x0
  pushl $203
8010744d:	68 cb 00 00 00       	push   $0xcb
  jmp alltraps
80107452:	e9 90 f2 ff ff       	jmp    801066e7 <alltraps>

80107457 <vector204>:
.globl vector204
vector204:
  pushl $0
80107457:	6a 00                	push   $0x0
  pushl $204
80107459:	68 cc 00 00 00       	push   $0xcc
  jmp alltraps
8010745e:	e9 84 f2 ff ff       	jmp    801066e7 <alltraps>

80107463 <vector205>:
.globl vector205
vector205:
  pushl $0
80107463:	6a 00                	push   $0x0
  pushl $205
80107465:	68 cd 00 00 00       	push   $0xcd
  jmp alltraps
8010746a:	e9 78 f2 ff ff       	jmp    801066e7 <alltraps>

8010746f <vector206>:
.globl vector206
vector206:
  pushl $0
8010746f:	6a 00                	push   $0x0
  pushl $206
80107471:	68 ce 00 00 00       	push   $0xce
  jmp alltraps
80107476:	e9 6c f2 ff ff       	jmp    801066e7 <alltraps>

8010747b <vector207>:
.globl vector207
vector207:
  pushl $0
8010747b:	6a 00                	push   $0x0
  pushl $207
8010747d:	68 cf 00 00 00       	push   $0xcf
  jmp alltraps
80107482:	e9 60 f2 ff ff       	jmp    801066e7 <alltraps>

80107487 <vector208>:
.globl vector208
vector208:
  pushl $0
80107487:	6a 00                	push   $0x0
  pushl $208
80107489:	68 d0 00 00 00       	push   $0xd0
  jmp alltraps
8010748e:	e9 54 f2 ff ff       	jmp    801066e7 <alltraps>

80107493 <vector209>:
.globl vector209
vector209:
  pushl $0
80107493:	6a 00                	push   $0x0
  pushl $209
80107495:	68 d1 00 00 00       	push   $0xd1
  jmp alltraps
8010749a:	e9 48 f2 ff ff       	jmp    801066e7 <alltraps>

8010749f <vector210>:
.globl vector210
vector210:
  pushl $0
8010749f:	6a 00                	push   $0x0
  pushl $210
801074a1:	68 d2 00 00 00       	push   $0xd2
  jmp alltraps
801074a6:	e9 3c f2 ff ff       	jmp    801066e7 <alltraps>

801074ab <vector211>:
.globl vector211
vector211:
  pushl $0
801074ab:	6a 00                	push   $0x0
  pushl $211
801074ad:	68 d3 00 00 00       	push   $0xd3
  jmp alltraps
801074b2:	e9 30 f2 ff ff       	jmp    801066e7 <alltraps>

801074b7 <vector212>:
.globl vector212
vector212:
  pushl $0
801074b7:	6a 00                	push   $0x0
  pushl $212
801074b9:	68 d4 00 00 00       	push   $0xd4
  jmp alltraps
801074be:	e9 24 f2 ff ff       	jmp    801066e7 <alltraps>

801074c3 <vector213>:
.globl vector213
vector213:
  pushl $0
801074c3:	6a 00                	push   $0x0
  pushl $213
801074c5:	68 d5 00 00 00       	push   $0xd5
  jmp alltraps
801074ca:	e9 18 f2 ff ff       	jmp    801066e7 <alltraps>

801074cf <vector214>:
.globl vector214
vector214:
  pushl $0
801074cf:	6a 00                	push   $0x0
  pushl $214
801074d1:	68 d6 00 00 00       	push   $0xd6
  jmp alltraps
801074d6:	e9 0c f2 ff ff       	jmp    801066e7 <alltraps>

801074db <vector215>:
.globl vector215
vector215:
  pushl $0
801074db:	6a 00                	push   $0x0
  pushl $215
801074dd:	68 d7 00 00 00       	push   $0xd7
  jmp alltraps
801074e2:	e9 00 f2 ff ff       	jmp    801066e7 <alltraps>

801074e7 <vector216>:
.globl vector216
vector216:
  pushl $0
801074e7:	6a 00                	push   $0x0
  pushl $216
801074e9:	68 d8 00 00 00       	push   $0xd8
  jmp alltraps
801074ee:	e9 f4 f1 ff ff       	jmp    801066e7 <alltraps>

801074f3 <vector217>:
.globl vector217
vector217:
  pushl $0
801074f3:	6a 00                	push   $0x0
  pushl $217
801074f5:	68 d9 00 00 00       	push   $0xd9
  jmp alltraps
801074fa:	e9 e8 f1 ff ff       	jmp    801066e7 <alltraps>

801074ff <vector218>:
.globl vector218
vector218:
  pushl $0
801074ff:	6a 00                	push   $0x0
  pushl $218
80107501:	68 da 00 00 00       	push   $0xda
  jmp alltraps
80107506:	e9 dc f1 ff ff       	jmp    801066e7 <alltraps>

8010750b <vector219>:
.globl vector219
vector219:
  pushl $0
8010750b:	6a 00                	push   $0x0
  pushl $219
8010750d:	68 db 00 00 00       	push   $0xdb
  jmp alltraps
80107512:	e9 d0 f1 ff ff       	jmp    801066e7 <alltraps>

80107517 <vector220>:
.globl vector220
vector220:
  pushl $0
80107517:	6a 00                	push   $0x0
  pushl $220
80107519:	68 dc 00 00 00       	push   $0xdc
  jmp alltraps
8010751e:	e9 c4 f1 ff ff       	jmp    801066e7 <alltraps>

80107523 <vector221>:
.globl vector221
vector221:
  pushl $0
80107523:	6a 00                	push   $0x0
  pushl $221
80107525:	68 dd 00 00 00       	push   $0xdd
  jmp alltraps
8010752a:	e9 b8 f1 ff ff       	jmp    801066e7 <alltraps>

8010752f <vector222>:
.globl vector222
vector222:
  pushl $0
8010752f:	6a 00                	push   $0x0
  pushl $222
80107531:	68 de 00 00 00       	push   $0xde
  jmp alltraps
80107536:	e9 ac f1 ff ff       	jmp    801066e7 <alltraps>

8010753b <vector223>:
.globl vector223
vector223:
  pushl $0
8010753b:	6a 00                	push   $0x0
  pushl $223
8010753d:	68 df 00 00 00       	push   $0xdf
  jmp alltraps
80107542:	e9 a0 f1 ff ff       	jmp    801066e7 <alltraps>

80107547 <vector224>:
.globl vector224
vector224:
  pushl $0
80107547:	6a 00                	push   $0x0
  pushl $224
80107549:	68 e0 00 00 00       	push   $0xe0
  jmp alltraps
8010754e:	e9 94 f1 ff ff       	jmp    801066e7 <alltraps>

80107553 <vector225>:
.globl vector225
vector225:
  pushl $0
80107553:	6a 00                	push   $0x0
  pushl $225
80107555:	68 e1 00 00 00       	push   $0xe1
  jmp alltraps
8010755a:	e9 88 f1 ff ff       	jmp    801066e7 <alltraps>

8010755f <vector226>:
.globl vector226
vector226:
  pushl $0
8010755f:	6a 00                	push   $0x0
  pushl $226
80107561:	68 e2 00 00 00       	push   $0xe2
  jmp alltraps
80107566:	e9 7c f1 ff ff       	jmp    801066e7 <alltraps>

8010756b <vector227>:
.globl vector227
vector227:
  pushl $0
8010756b:	6a 00                	push   $0x0
  pushl $227
8010756d:	68 e3 00 00 00       	push   $0xe3
  jmp alltraps
80107572:	e9 70 f1 ff ff       	jmp    801066e7 <alltraps>

80107577 <vector228>:
.globl vector228
vector228:
  pushl $0
80107577:	6a 00                	push   $0x0
  pushl $228
80107579:	68 e4 00 00 00       	push   $0xe4
  jmp alltraps
8010757e:	e9 64 f1 ff ff       	jmp    801066e7 <alltraps>

80107583 <vector229>:
.globl vector229
vector229:
  pushl $0
80107583:	6a 00                	push   $0x0
  pushl $229
80107585:	68 e5 00 00 00       	push   $0xe5
  jmp alltraps
8010758a:	e9 58 f1 ff ff       	jmp    801066e7 <alltraps>

8010758f <vector230>:
.globl vector230
vector230:
  pushl $0
8010758f:	6a 00                	push   $0x0
  pushl $230
80107591:	68 e6 00 00 00       	push   $0xe6
  jmp alltraps
80107596:	e9 4c f1 ff ff       	jmp    801066e7 <alltraps>

8010759b <vector231>:
.globl vector231
vector231:
  pushl $0
8010759b:	6a 00                	push   $0x0
  pushl $231
8010759d:	68 e7 00 00 00       	push   $0xe7
  jmp alltraps
801075a2:	e9 40 f1 ff ff       	jmp    801066e7 <alltraps>

801075a7 <vector232>:
.globl vector232
vector232:
  pushl $0
801075a7:	6a 00                	push   $0x0
  pushl $232
801075a9:	68 e8 00 00 00       	push   $0xe8
  jmp alltraps
801075ae:	e9 34 f1 ff ff       	jmp    801066e7 <alltraps>

801075b3 <vector233>:
.globl vector233
vector233:
  pushl $0
801075b3:	6a 00                	push   $0x0
  pushl $233
801075b5:	68 e9 00 00 00       	push   $0xe9
  jmp alltraps
801075ba:	e9 28 f1 ff ff       	jmp    801066e7 <alltraps>

801075bf <vector234>:
.globl vector234
vector234:
  pushl $0
801075bf:	6a 00                	push   $0x0
  pushl $234
801075c1:	68 ea 00 00 00       	push   $0xea
  jmp alltraps
801075c6:	e9 1c f1 ff ff       	jmp    801066e7 <alltraps>

801075cb <vector235>:
.globl vector235
vector235:
  pushl $0
801075cb:	6a 00                	push   $0x0
  pushl $235
801075cd:	68 eb 00 00 00       	push   $0xeb
  jmp alltraps
801075d2:	e9 10 f1 ff ff       	jmp    801066e7 <alltraps>

801075d7 <vector236>:
.globl vector236
vector236:
  pushl $0
801075d7:	6a 00                	push   $0x0
  pushl $236
801075d9:	68 ec 00 00 00       	push   $0xec
  jmp alltraps
801075de:	e9 04 f1 ff ff       	jmp    801066e7 <alltraps>

801075e3 <vector237>:
.globl vector237
vector237:
  pushl $0
801075e3:	6a 00                	push   $0x0
  pushl $237
801075e5:	68 ed 00 00 00       	push   $0xed
  jmp alltraps
801075ea:	e9 f8 f0 ff ff       	jmp    801066e7 <alltraps>

801075ef <vector238>:
.globl vector238
vector238:
  pushl $0
801075ef:	6a 00                	push   $0x0
  pushl $238
801075f1:	68 ee 00 00 00       	push   $0xee
  jmp alltraps
801075f6:	e9 ec f0 ff ff       	jmp    801066e7 <alltraps>

801075fb <vector239>:
.globl vector239
vector239:
  pushl $0
801075fb:	6a 00                	push   $0x0
  pushl $239
801075fd:	68 ef 00 00 00       	push   $0xef
  jmp alltraps
80107602:	e9 e0 f0 ff ff       	jmp    801066e7 <alltraps>

80107607 <vector240>:
.globl vector240
vector240:
  pushl $0
80107607:	6a 00                	push   $0x0
  pushl $240
80107609:	68 f0 00 00 00       	push   $0xf0
  jmp alltraps
8010760e:	e9 d4 f0 ff ff       	jmp    801066e7 <alltraps>

80107613 <vector241>:
.globl vector241
vector241:
  pushl $0
80107613:	6a 00                	push   $0x0
  pushl $241
80107615:	68 f1 00 00 00       	push   $0xf1
  jmp alltraps
8010761a:	e9 c8 f0 ff ff       	jmp    801066e7 <alltraps>

8010761f <vector242>:
.globl vector242
vector242:
  pushl $0
8010761f:	6a 00                	push   $0x0
  pushl $242
80107621:	68 f2 00 00 00       	push   $0xf2
  jmp alltraps
80107626:	e9 bc f0 ff ff       	jmp    801066e7 <alltraps>

8010762b <vector243>:
.globl vector243
vector243:
  pushl $0
8010762b:	6a 00                	push   $0x0
  pushl $243
8010762d:	68 f3 00 00 00       	push   $0xf3
  jmp alltraps
80107632:	e9 b0 f0 ff ff       	jmp    801066e7 <alltraps>

80107637 <vector244>:
.globl vector244
vector244:
  pushl $0
80107637:	6a 00                	push   $0x0
  pushl $244
80107639:	68 f4 00 00 00       	push   $0xf4
  jmp alltraps
8010763e:	e9 a4 f0 ff ff       	jmp    801066e7 <alltraps>

80107643 <vector245>:
.globl vector245
vector245:
  pushl $0
80107643:	6a 00                	push   $0x0
  pushl $245
80107645:	68 f5 00 00 00       	push   $0xf5
  jmp alltraps
8010764a:	e9 98 f0 ff ff       	jmp    801066e7 <alltraps>

8010764f <vector246>:
.globl vector246
vector246:
  pushl $0
8010764f:	6a 00                	push   $0x0
  pushl $246
80107651:	68 f6 00 00 00       	push   $0xf6
  jmp alltraps
80107656:	e9 8c f0 ff ff       	jmp    801066e7 <alltraps>

8010765b <vector247>:
.globl vector247
vector247:
  pushl $0
8010765b:	6a 00                	push   $0x0
  pushl $247
8010765d:	68 f7 00 00 00       	push   $0xf7
  jmp alltraps
80107662:	e9 80 f0 ff ff       	jmp    801066e7 <alltraps>

80107667 <vector248>:
.globl vector248
vector248:
  pushl $0
80107667:	6a 00                	push   $0x0
  pushl $248
80107669:	68 f8 00 00 00       	push   $0xf8
  jmp alltraps
8010766e:	e9 74 f0 ff ff       	jmp    801066e7 <alltraps>

80107673 <vector249>:
.globl vector249
vector249:
  pushl $0
80107673:	6a 00                	push   $0x0
  pushl $249
80107675:	68 f9 00 00 00       	push   $0xf9
  jmp alltraps
8010767a:	e9 68 f0 ff ff       	jmp    801066e7 <alltraps>

8010767f <vector250>:
.globl vector250
vector250:
  pushl $0
8010767f:	6a 00                	push   $0x0
  pushl $250
80107681:	68 fa 00 00 00       	push   $0xfa
  jmp alltraps
80107686:	e9 5c f0 ff ff       	jmp    801066e7 <alltraps>

8010768b <vector251>:
.globl vector251
vector251:
  pushl $0
8010768b:	6a 00                	push   $0x0
  pushl $251
8010768d:	68 fb 00 00 00       	push   $0xfb
  jmp alltraps
80107692:	e9 50 f0 ff ff       	jmp    801066e7 <alltraps>

80107697 <vector252>:
.globl vector252
vector252:
  pushl $0
80107697:	6a 00                	push   $0x0
  pushl $252
80107699:	68 fc 00 00 00       	push   $0xfc
  jmp alltraps
8010769e:	e9 44 f0 ff ff       	jmp    801066e7 <alltraps>

801076a3 <vector253>:
.globl vector253
vector253:
  pushl $0
801076a3:	6a 00                	push   $0x0
  pushl $253
801076a5:	68 fd 00 00 00       	push   $0xfd
  jmp alltraps
801076aa:	e9 38 f0 ff ff       	jmp    801066e7 <alltraps>

801076af <vector254>:
.globl vector254
vector254:
  pushl $0
801076af:	6a 00                	push   $0x0
  pushl $254
801076b1:	68 fe 00 00 00       	push   $0xfe
  jmp alltraps
801076b6:	e9 2c f0 ff ff       	jmp    801066e7 <alltraps>

801076bb <vector255>:
.globl vector255
vector255:
  pushl $0
801076bb:	6a 00                	push   $0x0
  pushl $255
801076bd:	68 ff 00 00 00       	push   $0xff
  jmp alltraps
801076c2:	e9 20 f0 ff ff       	jmp    801066e7 <alltraps>
801076c7:	66 90                	xchg   %ax,%ax
801076c9:	66 90                	xchg   %ax,%ax
801076cb:	66 90                	xchg   %ax,%ax
801076cd:	66 90                	xchg   %ax,%ax
801076cf:	90                   	nop

801076d0 <walkpgdir>:
// Return the address of the PTE in page table pgdir
// that corresponds to virtual address va.  If alloc!=0,
// create any required page table pages.
static pte_t *
walkpgdir(pde_t *pgdir, const void *va, int alloc)
{
801076d0:	55                   	push   %ebp
801076d1:	89 e5                	mov    %esp,%ebp
801076d3:	57                   	push   %edi
801076d4:	56                   	push   %esi
801076d5:	53                   	push   %ebx
  pde_t *pde;
  pte_t *pgtab;

  pde = &pgdir[PDX(va)];
801076d6:	89 d3                	mov    %edx,%ebx
{
801076d8:	89 d7                	mov    %edx,%edi
  pde = &pgdir[PDX(va)];
801076da:	c1 eb 16             	shr    $0x16,%ebx
801076dd:	8d 34 98             	lea    (%eax,%ebx,4),%esi
{
801076e0:	83 ec 0c             	sub    $0xc,%esp
  if(*pde & PTE_P){
801076e3:	8b 06                	mov    (%esi),%eax
801076e5:	a8 01                	test   $0x1,%al
801076e7:	74 27                	je     80107710 <walkpgdir+0x40>
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
801076e9:	25 00 f0 ff ff       	and    $0xfffff000,%eax
801076ee:	8d 98 00 00 00 80    	lea    -0x80000000(%eax),%ebx
    // The permissions here are overly generous, but they can
    // be further restricted by the permissions in the page table
    // entries, if necessary.
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
  }
  return &pgtab[PTX(va)];
801076f4:	c1 ef 0a             	shr    $0xa,%edi
}
801076f7:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return &pgtab[PTX(va)];
801076fa:	89 fa                	mov    %edi,%edx
801076fc:	81 e2 fc 0f 00 00    	and    $0xffc,%edx
80107702:	8d 04 13             	lea    (%ebx,%edx,1),%eax
}
80107705:	5b                   	pop    %ebx
80107706:	5e                   	pop    %esi
80107707:	5f                   	pop    %edi
80107708:	5d                   	pop    %ebp
80107709:	c3                   	ret    
8010770a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
80107710:	85 c9                	test   %ecx,%ecx
80107712:	74 2c                	je     80107740 <walkpgdir+0x70>
80107714:	e8 a7 ad ff ff       	call   801024c0 <kalloc>
80107719:	85 c0                	test   %eax,%eax
8010771b:	89 c3                	mov    %eax,%ebx
8010771d:	74 21                	je     80107740 <walkpgdir+0x70>
    memset(pgtab, 0, PGSIZE);
8010771f:	83 ec 04             	sub    $0x4,%esp
80107722:	68 00 10 00 00       	push   $0x1000
80107727:	6a 00                	push   $0x0
80107729:	50                   	push   %eax
8010772a:	e8 e1 dc ff ff       	call   80105410 <memset>
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
8010772f:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80107735:	83 c4 10             	add    $0x10,%esp
80107738:	83 c8 07             	or     $0x7,%eax
8010773b:	89 06                	mov    %eax,(%esi)
8010773d:	eb b5                	jmp    801076f4 <walkpgdir+0x24>
8010773f:	90                   	nop
}
80107740:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return 0;
80107743:	31 c0                	xor    %eax,%eax
}
80107745:	5b                   	pop    %ebx
80107746:	5e                   	pop    %esi
80107747:	5f                   	pop    %edi
80107748:	5d                   	pop    %ebp
80107749:	c3                   	ret    
8010774a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80107750 <mappages>:
// Create PTEs for virtual addresses starting at va that refer to
// physical addresses starting at pa. va and size might not
// be page-aligned.
static int
mappages(pde_t *pgdir, void *va, uint size, uint pa, int perm)
{
80107750:	55                   	push   %ebp
80107751:	89 e5                	mov    %esp,%ebp
80107753:	57                   	push   %edi
80107754:	56                   	push   %esi
80107755:	53                   	push   %ebx
  char *a, *last;
  pte_t *pte;

  a = (char*)PGROUNDDOWN((uint)va);
80107756:	89 d3                	mov    %edx,%ebx
80107758:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
{
8010775e:	83 ec 1c             	sub    $0x1c,%esp
80107761:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
80107764:	8d 44 0a ff          	lea    -0x1(%edx,%ecx,1),%eax
80107768:	8b 7d 08             	mov    0x8(%ebp),%edi
8010776b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80107770:	89 45 e0             	mov    %eax,-0x20(%ebp)
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
      return -1;
    if(*pte & PTE_P)
      panic("remap");
    *pte = pa | perm | PTE_P;
80107773:	8b 45 0c             	mov    0xc(%ebp),%eax
80107776:	29 df                	sub    %ebx,%edi
80107778:	83 c8 01             	or     $0x1,%eax
8010777b:	89 45 dc             	mov    %eax,-0x24(%ebp)
8010777e:	eb 15                	jmp    80107795 <mappages+0x45>
    if(*pte & PTE_P)
80107780:	f6 00 01             	testb  $0x1,(%eax)
80107783:	75 45                	jne    801077ca <mappages+0x7a>
    *pte = pa | perm | PTE_P;
80107785:	0b 75 dc             	or     -0x24(%ebp),%esi
    if(a == last)
80107788:	3b 5d e0             	cmp    -0x20(%ebp),%ebx
    *pte = pa | perm | PTE_P;
8010778b:	89 30                	mov    %esi,(%eax)
    if(a == last)
8010778d:	74 31                	je     801077c0 <mappages+0x70>
      break;
    a += PGSIZE;
8010778f:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
80107795:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107798:	b9 01 00 00 00       	mov    $0x1,%ecx
8010779d:	89 da                	mov    %ebx,%edx
8010779f:	8d 34 3b             	lea    (%ebx,%edi,1),%esi
801077a2:	e8 29 ff ff ff       	call   801076d0 <walkpgdir>
801077a7:	85 c0                	test   %eax,%eax
801077a9:	75 d5                	jne    80107780 <mappages+0x30>
    pa += PGSIZE;
  }
  return 0;
}
801077ab:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
801077ae:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801077b3:	5b                   	pop    %ebx
801077b4:	5e                   	pop    %esi
801077b5:	5f                   	pop    %edi
801077b6:	5d                   	pop    %ebp
801077b7:	c3                   	ret    
801077b8:	90                   	nop
801077b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801077c0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
801077c3:	31 c0                	xor    %eax,%eax
}
801077c5:	5b                   	pop    %ebx
801077c6:	5e                   	pop    %esi
801077c7:	5f                   	pop    %edi
801077c8:	5d                   	pop    %ebp
801077c9:	c3                   	ret    
      panic("remap");
801077ca:	83 ec 0c             	sub    $0xc,%esp
801077cd:	68 48 8a 10 80       	push   $0x80108a48
801077d2:	e8 b9 8b ff ff       	call   80100390 <panic>
801077d7:	89 f6                	mov    %esi,%esi
801077d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801077e0 <deallocuvm.part.0>:
// Deallocate user pages to bring the process size from oldsz to
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
801077e0:	55                   	push   %ebp
801077e1:	89 e5                	mov    %esp,%ebp
801077e3:	57                   	push   %edi
801077e4:	56                   	push   %esi
801077e5:	53                   	push   %ebx
  uint a, pa;

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
801077e6:	8d 99 ff 0f 00 00    	lea    0xfff(%ecx),%ebx
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
801077ec:	89 c7                	mov    %eax,%edi
  a = PGROUNDUP(newsz);
801077ee:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
801077f4:	83 ec 1c             	sub    $0x1c,%esp
801077f7:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  for(; a  < oldsz; a += PGSIZE){
801077fa:	39 d3                	cmp    %edx,%ebx
801077fc:	73 66                	jae    80107864 <deallocuvm.part.0+0x84>
801077fe:	89 d6                	mov    %edx,%esi
80107800:	eb 3d                	jmp    8010783f <deallocuvm.part.0+0x5f>
80107802:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    pte = walkpgdir(pgdir, (char*)a, 0);
    if(!pte)
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
    else if((*pte & PTE_P) != 0){
80107808:	8b 10                	mov    (%eax),%edx
8010780a:	f6 c2 01             	test   $0x1,%dl
8010780d:	74 26                	je     80107835 <deallocuvm.part.0+0x55>
      pa = PTE_ADDR(*pte);
      if(pa == 0)
8010780f:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
80107815:	74 58                	je     8010786f <deallocuvm.part.0+0x8f>
        panic("kfree");
      char *v = P2V(pa);
      kfree(v);
80107817:	83 ec 0c             	sub    $0xc,%esp
      char *v = P2V(pa);
8010781a:	81 c2 00 00 00 80    	add    $0x80000000,%edx
80107820:	89 45 e4             	mov    %eax,-0x1c(%ebp)
      kfree(v);
80107823:	52                   	push   %edx
80107824:	e8 e7 aa ff ff       	call   80102310 <kfree>
      *pte = 0;
80107829:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010782c:	83 c4 10             	add    $0x10,%esp
8010782f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; a  < oldsz; a += PGSIZE){
80107835:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010783b:	39 f3                	cmp    %esi,%ebx
8010783d:	73 25                	jae    80107864 <deallocuvm.part.0+0x84>
    pte = walkpgdir(pgdir, (char*)a, 0);
8010783f:	31 c9                	xor    %ecx,%ecx
80107841:	89 da                	mov    %ebx,%edx
80107843:	89 f8                	mov    %edi,%eax
80107845:	e8 86 fe ff ff       	call   801076d0 <walkpgdir>
    if(!pte)
8010784a:	85 c0                	test   %eax,%eax
8010784c:	75 ba                	jne    80107808 <deallocuvm.part.0+0x28>
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
8010784e:	81 e3 00 00 c0 ff    	and    $0xffc00000,%ebx
80107854:	81 c3 00 f0 3f 00    	add    $0x3ff000,%ebx
  for(; a  < oldsz; a += PGSIZE){
8010785a:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80107860:	39 f3                	cmp    %esi,%ebx
80107862:	72 db                	jb     8010783f <deallocuvm.part.0+0x5f>
    }
  }
  return newsz;
}
80107864:	8b 45 e0             	mov    -0x20(%ebp),%eax
80107867:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010786a:	5b                   	pop    %ebx
8010786b:	5e                   	pop    %esi
8010786c:	5f                   	pop    %edi
8010786d:	5d                   	pop    %ebp
8010786e:	c3                   	ret    
        panic("kfree");
8010786f:	83 ec 0c             	sub    $0xc,%esp
80107872:	68 66 82 10 80       	push   $0x80108266
80107877:	e8 14 8b ff ff       	call   80100390 <panic>
8010787c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80107880 <seginit>:
{
80107880:	55                   	push   %ebp
80107881:	89 e5                	mov    %esp,%ebp
80107883:	83 ec 18             	sub    $0x18,%esp
  c = &cpus[cpuid()];
80107886:	e8 f5 bf ff ff       	call   80103880 <cpuid>
8010788b:	69 c0 b0 00 00 00    	imul   $0xb0,%eax,%eax
  pd[0] = size-1;
80107891:	ba 2f 00 00 00       	mov    $0x2f,%edx
80107896:	66 89 55 f2          	mov    %dx,-0xe(%ebp)
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
8010789a:	c7 80 58 38 11 80 ff 	movl   $0xffff,-0x7feec7a8(%eax)
801078a1:	ff 00 00 
801078a4:	c7 80 5c 38 11 80 00 	movl   $0xcf9a00,-0x7feec7a4(%eax)
801078ab:	9a cf 00 
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
801078ae:	c7 80 60 38 11 80 ff 	movl   $0xffff,-0x7feec7a0(%eax)
801078b5:	ff 00 00 
801078b8:	c7 80 64 38 11 80 00 	movl   $0xcf9200,-0x7feec79c(%eax)
801078bf:	92 cf 00 
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
801078c2:	c7 80 68 38 11 80 ff 	movl   $0xffff,-0x7feec798(%eax)
801078c9:	ff 00 00 
801078cc:	c7 80 6c 38 11 80 00 	movl   $0xcffa00,-0x7feec794(%eax)
801078d3:	fa cf 00 
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
801078d6:	c7 80 70 38 11 80 ff 	movl   $0xffff,-0x7feec790(%eax)
801078dd:	ff 00 00 
801078e0:	c7 80 74 38 11 80 00 	movl   $0xcff200,-0x7feec78c(%eax)
801078e7:	f2 cf 00 
  lgdt(c->gdt, sizeof(c->gdt));
801078ea:	05 50 38 11 80       	add    $0x80113850,%eax
  pd[1] = (uint)p;
801078ef:	66 89 45 f4          	mov    %ax,-0xc(%ebp)
  pd[2] = (uint)p >> 16;
801078f3:	c1 e8 10             	shr    $0x10,%eax
801078f6:	66 89 45 f6          	mov    %ax,-0xa(%ebp)
  asm volatile("lgdt (%0)" : : "r" (pd));
801078fa:	8d 45 f2             	lea    -0xe(%ebp),%eax
801078fd:	0f 01 10             	lgdtl  (%eax)
}
80107900:	c9                   	leave  
80107901:	c3                   	ret    
80107902:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107909:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80107910 <switchkvm>:
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80107910:	a1 04 86 11 80       	mov    0x80118604,%eax
{
80107915:	55                   	push   %ebp
80107916:	89 e5                	mov    %esp,%ebp
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80107918:	05 00 00 00 80       	add    $0x80000000,%eax
}

static inline void
lcr3(uint val)
{
  asm volatile("movl %0,%%cr3" : : "r" (val));
8010791d:	0f 22 d8             	mov    %eax,%cr3
}
80107920:	5d                   	pop    %ebp
80107921:	c3                   	ret    
80107922:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107929:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80107930 <switchuvm>:
{
80107930:	55                   	push   %ebp
80107931:	89 e5                	mov    %esp,%ebp
80107933:	57                   	push   %edi
80107934:	56                   	push   %esi
80107935:	53                   	push   %ebx
80107936:	83 ec 1c             	sub    $0x1c,%esp
80107939:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(p == 0)
8010793c:	85 db                	test   %ebx,%ebx
8010793e:	0f 84 cb 00 00 00    	je     80107a0f <switchuvm+0xdf>
  if(p->kstack == 0)
80107944:	8b 43 08             	mov    0x8(%ebx),%eax
80107947:	85 c0                	test   %eax,%eax
80107949:	0f 84 da 00 00 00    	je     80107a29 <switchuvm+0xf9>
  if(p->pgdir == 0)
8010794f:	8b 43 04             	mov    0x4(%ebx),%eax
80107952:	85 c0                	test   %eax,%eax
80107954:	0f 84 c2 00 00 00    	je     80107a1c <switchuvm+0xec>
  pushcli();
8010795a:	e8 d1 d8 ff ff       	call   80105230 <pushcli>
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
8010795f:	e8 9c be ff ff       	call   80103800 <mycpu>
80107964:	89 c6                	mov    %eax,%esi
80107966:	e8 95 be ff ff       	call   80103800 <mycpu>
8010796b:	89 c7                	mov    %eax,%edi
8010796d:	e8 8e be ff ff       	call   80103800 <mycpu>
80107972:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80107975:	83 c7 08             	add    $0x8,%edi
80107978:	e8 83 be ff ff       	call   80103800 <mycpu>
8010797d:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80107980:	83 c0 08             	add    $0x8,%eax
80107983:	ba 67 00 00 00       	mov    $0x67,%edx
80107988:	c1 e8 18             	shr    $0x18,%eax
8010798b:	66 89 96 98 00 00 00 	mov    %dx,0x98(%esi)
80107992:	66 89 be 9a 00 00 00 	mov    %di,0x9a(%esi)
80107999:	88 86 9f 00 00 00    	mov    %al,0x9f(%esi)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
8010799f:	bf ff ff ff ff       	mov    $0xffffffff,%edi
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
801079a4:	83 c1 08             	add    $0x8,%ecx
801079a7:	c1 e9 10             	shr    $0x10,%ecx
801079aa:	88 8e 9c 00 00 00    	mov    %cl,0x9c(%esi)
801079b0:	b9 99 40 00 00       	mov    $0x4099,%ecx
801079b5:	66 89 8e 9d 00 00 00 	mov    %cx,0x9d(%esi)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
801079bc:	be 10 00 00 00       	mov    $0x10,%esi
  mycpu()->gdt[SEG_TSS].s = 0;
801079c1:	e8 3a be ff ff       	call   80103800 <mycpu>
801079c6:	80 a0 9d 00 00 00 ef 	andb   $0xef,0x9d(%eax)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
801079cd:	e8 2e be ff ff       	call   80103800 <mycpu>
801079d2:	66 89 70 10          	mov    %si,0x10(%eax)
  mycpu()->ts.esp0 = (uint)p->kstack + KSTACKSIZE;
801079d6:	8b 73 08             	mov    0x8(%ebx),%esi
801079d9:	e8 22 be ff ff       	call   80103800 <mycpu>
801079de:	81 c6 00 10 00 00    	add    $0x1000,%esi
801079e4:	89 70 0c             	mov    %esi,0xc(%eax)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
801079e7:	e8 14 be ff ff       	call   80103800 <mycpu>
801079ec:	66 89 78 6e          	mov    %di,0x6e(%eax)
  asm volatile("ltr %0" : : "r" (sel));
801079f0:	b8 28 00 00 00       	mov    $0x28,%eax
801079f5:	0f 00 d8             	ltr    %ax
  lcr3(V2P(p->pgdir));  // switch to process's address space
801079f8:	8b 43 04             	mov    0x4(%ebx),%eax
801079fb:	05 00 00 00 80       	add    $0x80000000,%eax
  asm volatile("movl %0,%%cr3" : : "r" (val));
80107a00:	0f 22 d8             	mov    %eax,%cr3
}
80107a03:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107a06:	5b                   	pop    %ebx
80107a07:	5e                   	pop    %esi
80107a08:	5f                   	pop    %edi
80107a09:	5d                   	pop    %ebp
  popcli();
80107a0a:	e9 61 d8 ff ff       	jmp    80105270 <popcli>
    panic("switchuvm: no process");
80107a0f:	83 ec 0c             	sub    $0xc,%esp
80107a12:	68 4e 8a 10 80       	push   $0x80108a4e
80107a17:	e8 74 89 ff ff       	call   80100390 <panic>
    panic("switchuvm: no pgdir");
80107a1c:	83 ec 0c             	sub    $0xc,%esp
80107a1f:	68 79 8a 10 80       	push   $0x80108a79
80107a24:	e8 67 89 ff ff       	call   80100390 <panic>
    panic("switchuvm: no kstack");
80107a29:	83 ec 0c             	sub    $0xc,%esp
80107a2c:	68 64 8a 10 80       	push   $0x80108a64
80107a31:	e8 5a 89 ff ff       	call   80100390 <panic>
80107a36:	8d 76 00             	lea    0x0(%esi),%esi
80107a39:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80107a40 <inituvm>:
{
80107a40:	55                   	push   %ebp
80107a41:	89 e5                	mov    %esp,%ebp
80107a43:	57                   	push   %edi
80107a44:	56                   	push   %esi
80107a45:	53                   	push   %ebx
80107a46:	83 ec 1c             	sub    $0x1c,%esp
80107a49:	8b 75 10             	mov    0x10(%ebp),%esi
80107a4c:	8b 45 08             	mov    0x8(%ebp),%eax
80107a4f:	8b 7d 0c             	mov    0xc(%ebp),%edi
  if(sz >= PGSIZE)
80107a52:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
{
80107a58:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(sz >= PGSIZE)
80107a5b:	77 49                	ja     80107aa6 <inituvm+0x66>
  mem = kalloc();
80107a5d:	e8 5e aa ff ff       	call   801024c0 <kalloc>
  memset(mem, 0, PGSIZE);
80107a62:	83 ec 04             	sub    $0x4,%esp
  mem = kalloc();
80107a65:	89 c3                	mov    %eax,%ebx
  memset(mem, 0, PGSIZE);
80107a67:	68 00 10 00 00       	push   $0x1000
80107a6c:	6a 00                	push   $0x0
80107a6e:	50                   	push   %eax
80107a6f:	e8 9c d9 ff ff       	call   80105410 <memset>
  mappages(pgdir, 0, PGSIZE, V2P(mem), PTE_W|PTE_U);
80107a74:	58                   	pop    %eax
80107a75:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80107a7b:	b9 00 10 00 00       	mov    $0x1000,%ecx
80107a80:	5a                   	pop    %edx
80107a81:	6a 06                	push   $0x6
80107a83:	50                   	push   %eax
80107a84:	31 d2                	xor    %edx,%edx
80107a86:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107a89:	e8 c2 fc ff ff       	call   80107750 <mappages>
  memmove(mem, init, sz);
80107a8e:	89 75 10             	mov    %esi,0x10(%ebp)
80107a91:	89 7d 0c             	mov    %edi,0xc(%ebp)
80107a94:	83 c4 10             	add    $0x10,%esp
80107a97:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
80107a9a:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107a9d:	5b                   	pop    %ebx
80107a9e:	5e                   	pop    %esi
80107a9f:	5f                   	pop    %edi
80107aa0:	5d                   	pop    %ebp
  memmove(mem, init, sz);
80107aa1:	e9 1a da ff ff       	jmp    801054c0 <memmove>
    panic("inituvm: more than a page");
80107aa6:	83 ec 0c             	sub    $0xc,%esp
80107aa9:	68 8d 8a 10 80       	push   $0x80108a8d
80107aae:	e8 dd 88 ff ff       	call   80100390 <panic>
80107ab3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80107ab9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80107ac0 <loaduvm>:
{
80107ac0:	55                   	push   %ebp
80107ac1:	89 e5                	mov    %esp,%ebp
80107ac3:	57                   	push   %edi
80107ac4:	56                   	push   %esi
80107ac5:	53                   	push   %ebx
80107ac6:	83 ec 0c             	sub    $0xc,%esp
  if((uint) addr % PGSIZE != 0)
80107ac9:	f7 45 0c ff 0f 00 00 	testl  $0xfff,0xc(%ebp)
80107ad0:	0f 85 91 00 00 00    	jne    80107b67 <loaduvm+0xa7>
  for(i = 0; i < sz; i += PGSIZE){
80107ad6:	8b 75 18             	mov    0x18(%ebp),%esi
80107ad9:	31 db                	xor    %ebx,%ebx
80107adb:	85 f6                	test   %esi,%esi
80107add:	75 1a                	jne    80107af9 <loaduvm+0x39>
80107adf:	eb 6f                	jmp    80107b50 <loaduvm+0x90>
80107ae1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107ae8:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80107aee:	81 ee 00 10 00 00    	sub    $0x1000,%esi
80107af4:	39 5d 18             	cmp    %ebx,0x18(%ebp)
80107af7:	76 57                	jbe    80107b50 <loaduvm+0x90>
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
80107af9:	8b 55 0c             	mov    0xc(%ebp),%edx
80107afc:	8b 45 08             	mov    0x8(%ebp),%eax
80107aff:	31 c9                	xor    %ecx,%ecx
80107b01:	01 da                	add    %ebx,%edx
80107b03:	e8 c8 fb ff ff       	call   801076d0 <walkpgdir>
80107b08:	85 c0                	test   %eax,%eax
80107b0a:	74 4e                	je     80107b5a <loaduvm+0x9a>
    pa = PTE_ADDR(*pte);
80107b0c:	8b 00                	mov    (%eax),%eax
    if(readi(ip, P2V(pa), offset+i, n) != n)
80107b0e:	8b 4d 14             	mov    0x14(%ebp),%ecx
    if(sz - i < PGSIZE)
80107b11:	bf 00 10 00 00       	mov    $0x1000,%edi
    pa = PTE_ADDR(*pte);
80107b16:	25 00 f0 ff ff       	and    $0xfffff000,%eax
    if(sz - i < PGSIZE)
80107b1b:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
80107b21:	0f 46 fe             	cmovbe %esi,%edi
    if(readi(ip, P2V(pa), offset+i, n) != n)
80107b24:	01 d9                	add    %ebx,%ecx
80107b26:	05 00 00 00 80       	add    $0x80000000,%eax
80107b2b:	57                   	push   %edi
80107b2c:	51                   	push   %ecx
80107b2d:	50                   	push   %eax
80107b2e:	ff 75 10             	pushl  0x10(%ebp)
80107b31:	e8 2a 9e ff ff       	call   80101960 <readi>
80107b36:	83 c4 10             	add    $0x10,%esp
80107b39:	39 f8                	cmp    %edi,%eax
80107b3b:	74 ab                	je     80107ae8 <loaduvm+0x28>
}
80107b3d:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
80107b40:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80107b45:	5b                   	pop    %ebx
80107b46:	5e                   	pop    %esi
80107b47:	5f                   	pop    %edi
80107b48:	5d                   	pop    %ebp
80107b49:	c3                   	ret    
80107b4a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80107b50:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80107b53:	31 c0                	xor    %eax,%eax
}
80107b55:	5b                   	pop    %ebx
80107b56:	5e                   	pop    %esi
80107b57:	5f                   	pop    %edi
80107b58:	5d                   	pop    %ebp
80107b59:	c3                   	ret    
      panic("loaduvm: address should exist");
80107b5a:	83 ec 0c             	sub    $0xc,%esp
80107b5d:	68 a7 8a 10 80       	push   $0x80108aa7
80107b62:	e8 29 88 ff ff       	call   80100390 <panic>
    panic("loaduvm: addr must be page aligned");
80107b67:	83 ec 0c             	sub    $0xc,%esp
80107b6a:	68 48 8b 10 80       	push   $0x80108b48
80107b6f:	e8 1c 88 ff ff       	call   80100390 <panic>
80107b74:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80107b7a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80107b80 <allocuvm>:
{
80107b80:	55                   	push   %ebp
80107b81:	89 e5                	mov    %esp,%ebp
80107b83:	57                   	push   %edi
80107b84:	56                   	push   %esi
80107b85:	53                   	push   %ebx
80107b86:	83 ec 1c             	sub    $0x1c,%esp
  if(newsz >= KERNBASE)
80107b89:	8b 7d 10             	mov    0x10(%ebp),%edi
80107b8c:	85 ff                	test   %edi,%edi
80107b8e:	0f 88 8e 00 00 00    	js     80107c22 <allocuvm+0xa2>
  if(newsz < oldsz)
80107b94:	3b 7d 0c             	cmp    0xc(%ebp),%edi
80107b97:	0f 82 93 00 00 00    	jb     80107c30 <allocuvm+0xb0>
  a = PGROUNDUP(oldsz);
80107b9d:	8b 45 0c             	mov    0xc(%ebp),%eax
80107ba0:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80107ba6:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; a < newsz; a += PGSIZE){
80107bac:	39 5d 10             	cmp    %ebx,0x10(%ebp)
80107baf:	0f 86 7e 00 00 00    	jbe    80107c33 <allocuvm+0xb3>
80107bb5:	89 7d e4             	mov    %edi,-0x1c(%ebp)
80107bb8:	8b 7d 08             	mov    0x8(%ebp),%edi
80107bbb:	eb 42                	jmp    80107bff <allocuvm+0x7f>
80107bbd:	8d 76 00             	lea    0x0(%esi),%esi
    memset(mem, 0, PGSIZE);
80107bc0:	83 ec 04             	sub    $0x4,%esp
80107bc3:	68 00 10 00 00       	push   $0x1000
80107bc8:	6a 00                	push   $0x0
80107bca:	50                   	push   %eax
80107bcb:	e8 40 d8 ff ff       	call   80105410 <memset>
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
80107bd0:	58                   	pop    %eax
80107bd1:	8d 86 00 00 00 80    	lea    -0x80000000(%esi),%eax
80107bd7:	b9 00 10 00 00       	mov    $0x1000,%ecx
80107bdc:	5a                   	pop    %edx
80107bdd:	6a 06                	push   $0x6
80107bdf:	50                   	push   %eax
80107be0:	89 da                	mov    %ebx,%edx
80107be2:	89 f8                	mov    %edi,%eax
80107be4:	e8 67 fb ff ff       	call   80107750 <mappages>
80107be9:	83 c4 10             	add    $0x10,%esp
80107bec:	85 c0                	test   %eax,%eax
80107bee:	78 50                	js     80107c40 <allocuvm+0xc0>
  for(; a < newsz; a += PGSIZE){
80107bf0:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80107bf6:	39 5d 10             	cmp    %ebx,0x10(%ebp)
80107bf9:	0f 86 81 00 00 00    	jbe    80107c80 <allocuvm+0x100>
    mem = kalloc();
80107bff:	e8 bc a8 ff ff       	call   801024c0 <kalloc>
    if(mem == 0){
80107c04:	85 c0                	test   %eax,%eax
    mem = kalloc();
80107c06:	89 c6                	mov    %eax,%esi
    if(mem == 0){
80107c08:	75 b6                	jne    80107bc0 <allocuvm+0x40>
      cprintf("allocuvm out of memory\n");
80107c0a:	83 ec 0c             	sub    $0xc,%esp
80107c0d:	68 c5 8a 10 80       	push   $0x80108ac5
80107c12:	e8 49 8a ff ff       	call   80100660 <cprintf>
  if(newsz >= oldsz)
80107c17:	83 c4 10             	add    $0x10,%esp
80107c1a:	8b 45 0c             	mov    0xc(%ebp),%eax
80107c1d:	39 45 10             	cmp    %eax,0x10(%ebp)
80107c20:	77 6e                	ja     80107c90 <allocuvm+0x110>
}
80107c22:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return 0;
80107c25:	31 ff                	xor    %edi,%edi
}
80107c27:	89 f8                	mov    %edi,%eax
80107c29:	5b                   	pop    %ebx
80107c2a:	5e                   	pop    %esi
80107c2b:	5f                   	pop    %edi
80107c2c:	5d                   	pop    %ebp
80107c2d:	c3                   	ret    
80107c2e:	66 90                	xchg   %ax,%ax
    return oldsz;
80107c30:	8b 7d 0c             	mov    0xc(%ebp),%edi
}
80107c33:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107c36:	89 f8                	mov    %edi,%eax
80107c38:	5b                   	pop    %ebx
80107c39:	5e                   	pop    %esi
80107c3a:	5f                   	pop    %edi
80107c3b:	5d                   	pop    %ebp
80107c3c:	c3                   	ret    
80107c3d:	8d 76 00             	lea    0x0(%esi),%esi
      cprintf("allocuvm out of memory (2)\n");
80107c40:	83 ec 0c             	sub    $0xc,%esp
80107c43:	68 dd 8a 10 80       	push   $0x80108add
80107c48:	e8 13 8a ff ff       	call   80100660 <cprintf>
  if(newsz >= oldsz)
80107c4d:	83 c4 10             	add    $0x10,%esp
80107c50:	8b 45 0c             	mov    0xc(%ebp),%eax
80107c53:	39 45 10             	cmp    %eax,0x10(%ebp)
80107c56:	76 0d                	jbe    80107c65 <allocuvm+0xe5>
80107c58:	89 c1                	mov    %eax,%ecx
80107c5a:	8b 55 10             	mov    0x10(%ebp),%edx
80107c5d:	8b 45 08             	mov    0x8(%ebp),%eax
80107c60:	e8 7b fb ff ff       	call   801077e0 <deallocuvm.part.0>
      kfree(mem);
80107c65:	83 ec 0c             	sub    $0xc,%esp
      return 0;
80107c68:	31 ff                	xor    %edi,%edi
      kfree(mem);
80107c6a:	56                   	push   %esi
80107c6b:	e8 a0 a6 ff ff       	call   80102310 <kfree>
      return 0;
80107c70:	83 c4 10             	add    $0x10,%esp
}
80107c73:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107c76:	89 f8                	mov    %edi,%eax
80107c78:	5b                   	pop    %ebx
80107c79:	5e                   	pop    %esi
80107c7a:	5f                   	pop    %edi
80107c7b:	5d                   	pop    %ebp
80107c7c:	c3                   	ret    
80107c7d:	8d 76 00             	lea    0x0(%esi),%esi
80107c80:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80107c83:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107c86:	5b                   	pop    %ebx
80107c87:	89 f8                	mov    %edi,%eax
80107c89:	5e                   	pop    %esi
80107c8a:	5f                   	pop    %edi
80107c8b:	5d                   	pop    %ebp
80107c8c:	c3                   	ret    
80107c8d:	8d 76 00             	lea    0x0(%esi),%esi
80107c90:	89 c1                	mov    %eax,%ecx
80107c92:	8b 55 10             	mov    0x10(%ebp),%edx
80107c95:	8b 45 08             	mov    0x8(%ebp),%eax
      return 0;
80107c98:	31 ff                	xor    %edi,%edi
80107c9a:	e8 41 fb ff ff       	call   801077e0 <deallocuvm.part.0>
80107c9f:	eb 92                	jmp    80107c33 <allocuvm+0xb3>
80107ca1:	eb 0d                	jmp    80107cb0 <deallocuvm>
80107ca3:	90                   	nop
80107ca4:	90                   	nop
80107ca5:	90                   	nop
80107ca6:	90                   	nop
80107ca7:	90                   	nop
80107ca8:	90                   	nop
80107ca9:	90                   	nop
80107caa:	90                   	nop
80107cab:	90                   	nop
80107cac:	90                   	nop
80107cad:	90                   	nop
80107cae:	90                   	nop
80107caf:	90                   	nop

80107cb0 <deallocuvm>:
{
80107cb0:	55                   	push   %ebp
80107cb1:	89 e5                	mov    %esp,%ebp
80107cb3:	8b 55 0c             	mov    0xc(%ebp),%edx
80107cb6:	8b 4d 10             	mov    0x10(%ebp),%ecx
80107cb9:	8b 45 08             	mov    0x8(%ebp),%eax
  if(newsz >= oldsz)
80107cbc:	39 d1                	cmp    %edx,%ecx
80107cbe:	73 10                	jae    80107cd0 <deallocuvm+0x20>
}
80107cc0:	5d                   	pop    %ebp
80107cc1:	e9 1a fb ff ff       	jmp    801077e0 <deallocuvm.part.0>
80107cc6:	8d 76 00             	lea    0x0(%esi),%esi
80107cc9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80107cd0:	89 d0                	mov    %edx,%eax
80107cd2:	5d                   	pop    %ebp
80107cd3:	c3                   	ret    
80107cd4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80107cda:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80107ce0 <freevm>:

// Free a page table and all the physical memory pages
// in the user part.
void
freevm(pde_t *pgdir)
{
80107ce0:	55                   	push   %ebp
80107ce1:	89 e5                	mov    %esp,%ebp
80107ce3:	57                   	push   %edi
80107ce4:	56                   	push   %esi
80107ce5:	53                   	push   %ebx
80107ce6:	83 ec 0c             	sub    $0xc,%esp
80107ce9:	8b 75 08             	mov    0x8(%ebp),%esi
  uint i;

  if(pgdir == 0)
80107cec:	85 f6                	test   %esi,%esi
80107cee:	74 59                	je     80107d49 <freevm+0x69>
80107cf0:	31 c9                	xor    %ecx,%ecx
80107cf2:	ba 00 00 00 80       	mov    $0x80000000,%edx
80107cf7:	89 f0                	mov    %esi,%eax
80107cf9:	e8 e2 fa ff ff       	call   801077e0 <deallocuvm.part.0>
80107cfe:	89 f3                	mov    %esi,%ebx
80107d00:	8d be 00 10 00 00    	lea    0x1000(%esi),%edi
80107d06:	eb 0f                	jmp    80107d17 <freevm+0x37>
80107d08:	90                   	nop
80107d09:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107d10:	83 c3 04             	add    $0x4,%ebx
    panic("freevm: no pgdir");
  deallocuvm(pgdir, KERNBASE, 0);
  for(i = 0; i < NPDENTRIES; i++){
80107d13:	39 fb                	cmp    %edi,%ebx
80107d15:	74 23                	je     80107d3a <freevm+0x5a>
    if(pgdir[i] & PTE_P){
80107d17:	8b 03                	mov    (%ebx),%eax
80107d19:	a8 01                	test   $0x1,%al
80107d1b:	74 f3                	je     80107d10 <freevm+0x30>
      char * v = P2V(PTE_ADDR(pgdir[i]));
80107d1d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
      kfree(v);
80107d22:	83 ec 0c             	sub    $0xc,%esp
80107d25:	83 c3 04             	add    $0x4,%ebx
      char * v = P2V(PTE_ADDR(pgdir[i]));
80107d28:	05 00 00 00 80       	add    $0x80000000,%eax
      kfree(v);
80107d2d:	50                   	push   %eax
80107d2e:	e8 dd a5 ff ff       	call   80102310 <kfree>
80107d33:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < NPDENTRIES; i++){
80107d36:	39 fb                	cmp    %edi,%ebx
80107d38:	75 dd                	jne    80107d17 <freevm+0x37>
    }
  }
  kfree((char*)pgdir);
80107d3a:	89 75 08             	mov    %esi,0x8(%ebp)
}
80107d3d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107d40:	5b                   	pop    %ebx
80107d41:	5e                   	pop    %esi
80107d42:	5f                   	pop    %edi
80107d43:	5d                   	pop    %ebp
  kfree((char*)pgdir);
80107d44:	e9 c7 a5 ff ff       	jmp    80102310 <kfree>
    panic("freevm: no pgdir");
80107d49:	83 ec 0c             	sub    $0xc,%esp
80107d4c:	68 f9 8a 10 80       	push   $0x80108af9
80107d51:	e8 3a 86 ff ff       	call   80100390 <panic>
80107d56:	8d 76 00             	lea    0x0(%esi),%esi
80107d59:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80107d60 <setupkvm>:
{
80107d60:	55                   	push   %ebp
80107d61:	89 e5                	mov    %esp,%ebp
80107d63:	56                   	push   %esi
80107d64:	53                   	push   %ebx
  if((pgdir = (pde_t*)kalloc()) == 0)
80107d65:	e8 56 a7 ff ff       	call   801024c0 <kalloc>
80107d6a:	85 c0                	test   %eax,%eax
80107d6c:	89 c6                	mov    %eax,%esi
80107d6e:	74 42                	je     80107db2 <setupkvm+0x52>
  memset(pgdir, 0, PGSIZE);
80107d70:	83 ec 04             	sub    $0x4,%esp
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80107d73:	bb 40 b4 10 80       	mov    $0x8010b440,%ebx
  memset(pgdir, 0, PGSIZE);
80107d78:	68 00 10 00 00       	push   $0x1000
80107d7d:	6a 00                	push   $0x0
80107d7f:	50                   	push   %eax
80107d80:	e8 8b d6 ff ff       	call   80105410 <memset>
80107d85:	83 c4 10             	add    $0x10,%esp
                (uint)k->phys_start, k->perm) < 0) {
80107d88:	8b 43 04             	mov    0x4(%ebx),%eax
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
80107d8b:	8b 4b 08             	mov    0x8(%ebx),%ecx
80107d8e:	83 ec 08             	sub    $0x8,%esp
80107d91:	8b 13                	mov    (%ebx),%edx
80107d93:	ff 73 0c             	pushl  0xc(%ebx)
80107d96:	50                   	push   %eax
80107d97:	29 c1                	sub    %eax,%ecx
80107d99:	89 f0                	mov    %esi,%eax
80107d9b:	e8 b0 f9 ff ff       	call   80107750 <mappages>
80107da0:	83 c4 10             	add    $0x10,%esp
80107da3:	85 c0                	test   %eax,%eax
80107da5:	78 19                	js     80107dc0 <setupkvm+0x60>
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80107da7:	83 c3 10             	add    $0x10,%ebx
80107daa:	81 fb 80 b4 10 80    	cmp    $0x8010b480,%ebx
80107db0:	75 d6                	jne    80107d88 <setupkvm+0x28>
}
80107db2:	8d 65 f8             	lea    -0x8(%ebp),%esp
80107db5:	89 f0                	mov    %esi,%eax
80107db7:	5b                   	pop    %ebx
80107db8:	5e                   	pop    %esi
80107db9:	5d                   	pop    %ebp
80107dba:	c3                   	ret    
80107dbb:	90                   	nop
80107dbc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      freevm(pgdir);
80107dc0:	83 ec 0c             	sub    $0xc,%esp
80107dc3:	56                   	push   %esi
      return 0;
80107dc4:	31 f6                	xor    %esi,%esi
      freevm(pgdir);
80107dc6:	e8 15 ff ff ff       	call   80107ce0 <freevm>
      return 0;
80107dcb:	83 c4 10             	add    $0x10,%esp
}
80107dce:	8d 65 f8             	lea    -0x8(%ebp),%esp
80107dd1:	89 f0                	mov    %esi,%eax
80107dd3:	5b                   	pop    %ebx
80107dd4:	5e                   	pop    %esi
80107dd5:	5d                   	pop    %ebp
80107dd6:	c3                   	ret    
80107dd7:	89 f6                	mov    %esi,%esi
80107dd9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80107de0 <kvmalloc>:
{
80107de0:	55                   	push   %ebp
80107de1:	89 e5                	mov    %esp,%ebp
80107de3:	83 ec 08             	sub    $0x8,%esp
  kpgdir = setupkvm();
80107de6:	e8 75 ff ff ff       	call   80107d60 <setupkvm>
80107deb:	a3 04 86 11 80       	mov    %eax,0x80118604
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80107df0:	05 00 00 00 80       	add    $0x80000000,%eax
80107df5:	0f 22 d8             	mov    %eax,%cr3
}
80107df8:	c9                   	leave  
80107df9:	c3                   	ret    
80107dfa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80107e00 <clearpteu>:

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
80107e00:	55                   	push   %ebp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80107e01:	31 c9                	xor    %ecx,%ecx
{
80107e03:	89 e5                	mov    %esp,%ebp
80107e05:	83 ec 08             	sub    $0x8,%esp
  pte = walkpgdir(pgdir, uva, 0);
80107e08:	8b 55 0c             	mov    0xc(%ebp),%edx
80107e0b:	8b 45 08             	mov    0x8(%ebp),%eax
80107e0e:	e8 bd f8 ff ff       	call   801076d0 <walkpgdir>
  if(pte == 0)
80107e13:	85 c0                	test   %eax,%eax
80107e15:	74 05                	je     80107e1c <clearpteu+0x1c>
    panic("clearpteu");
  *pte &= ~PTE_U;
80107e17:	83 20 fb             	andl   $0xfffffffb,(%eax)
}
80107e1a:	c9                   	leave  
80107e1b:	c3                   	ret    
    panic("clearpteu");
80107e1c:	83 ec 0c             	sub    $0xc,%esp
80107e1f:	68 0a 8b 10 80       	push   $0x80108b0a
80107e24:	e8 67 85 ff ff       	call   80100390 <panic>
80107e29:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80107e30 <copyuvm>:

// Given a parent process's page table, create a copy
// of it for a child.
pde_t*
copyuvm(pde_t *pgdir, uint sz)
{
80107e30:	55                   	push   %ebp
80107e31:	89 e5                	mov    %esp,%ebp
80107e33:	57                   	push   %edi
80107e34:	56                   	push   %esi
80107e35:	53                   	push   %ebx
80107e36:	83 ec 1c             	sub    $0x1c,%esp
  pde_t *d;
  pte_t *pte;
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
80107e39:	e8 22 ff ff ff       	call   80107d60 <setupkvm>
80107e3e:	85 c0                	test   %eax,%eax
80107e40:	89 45 e0             	mov    %eax,-0x20(%ebp)
80107e43:	0f 84 9f 00 00 00    	je     80107ee8 <copyuvm+0xb8>
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
80107e49:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80107e4c:	85 c9                	test   %ecx,%ecx
80107e4e:	0f 84 94 00 00 00    	je     80107ee8 <copyuvm+0xb8>
80107e54:	31 ff                	xor    %edi,%edi
80107e56:	eb 4a                	jmp    80107ea2 <copyuvm+0x72>
80107e58:	90                   	nop
80107e59:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      panic("copyuvm: page not present");
    pa = PTE_ADDR(*pte);
    flags = PTE_FLAGS(*pte);
    if((mem = kalloc()) == 0)
      goto bad;
    memmove(mem, (char*)P2V(pa), PGSIZE);
80107e60:	83 ec 04             	sub    $0x4,%esp
80107e63:	81 c3 00 00 00 80    	add    $0x80000000,%ebx
80107e69:	68 00 10 00 00       	push   $0x1000
80107e6e:	53                   	push   %ebx
80107e6f:	50                   	push   %eax
80107e70:	e8 4b d6 ff ff       	call   801054c0 <memmove>
    if(mappages(d, (void*)i, PGSIZE, V2P(mem), flags) < 0) {
80107e75:	58                   	pop    %eax
80107e76:	8d 86 00 00 00 80    	lea    -0x80000000(%esi),%eax
80107e7c:	b9 00 10 00 00       	mov    $0x1000,%ecx
80107e81:	5a                   	pop    %edx
80107e82:	ff 75 e4             	pushl  -0x1c(%ebp)
80107e85:	50                   	push   %eax
80107e86:	89 fa                	mov    %edi,%edx
80107e88:	8b 45 e0             	mov    -0x20(%ebp),%eax
80107e8b:	e8 c0 f8 ff ff       	call   80107750 <mappages>
80107e90:	83 c4 10             	add    $0x10,%esp
80107e93:	85 c0                	test   %eax,%eax
80107e95:	78 61                	js     80107ef8 <copyuvm+0xc8>
  for(i = 0; i < sz; i += PGSIZE){
80107e97:	81 c7 00 10 00 00    	add    $0x1000,%edi
80107e9d:	39 7d 0c             	cmp    %edi,0xc(%ebp)
80107ea0:	76 46                	jbe    80107ee8 <copyuvm+0xb8>
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
80107ea2:	8b 45 08             	mov    0x8(%ebp),%eax
80107ea5:	31 c9                	xor    %ecx,%ecx
80107ea7:	89 fa                	mov    %edi,%edx
80107ea9:	e8 22 f8 ff ff       	call   801076d0 <walkpgdir>
80107eae:	85 c0                	test   %eax,%eax
80107eb0:	74 61                	je     80107f13 <copyuvm+0xe3>
    if(!(*pte & PTE_P))
80107eb2:	8b 00                	mov    (%eax),%eax
80107eb4:	a8 01                	test   $0x1,%al
80107eb6:	74 4e                	je     80107f06 <copyuvm+0xd6>
    pa = PTE_ADDR(*pte);
80107eb8:	89 c3                	mov    %eax,%ebx
    flags = PTE_FLAGS(*pte);
80107eba:	25 ff 0f 00 00       	and    $0xfff,%eax
    pa = PTE_ADDR(*pte);
80107ebf:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
    flags = PTE_FLAGS(*pte);
80107ec5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if((mem = kalloc()) == 0)
80107ec8:	e8 f3 a5 ff ff       	call   801024c0 <kalloc>
80107ecd:	85 c0                	test   %eax,%eax
80107ecf:	89 c6                	mov    %eax,%esi
80107ed1:	75 8d                	jne    80107e60 <copyuvm+0x30>
    }
  }
  return d;

bad:
  freevm(d);
80107ed3:	83 ec 0c             	sub    $0xc,%esp
80107ed6:	ff 75 e0             	pushl  -0x20(%ebp)
80107ed9:	e8 02 fe ff ff       	call   80107ce0 <freevm>
  return 0;
80107ede:	83 c4 10             	add    $0x10,%esp
80107ee1:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
}
80107ee8:	8b 45 e0             	mov    -0x20(%ebp),%eax
80107eeb:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107eee:	5b                   	pop    %ebx
80107eef:	5e                   	pop    %esi
80107ef0:	5f                   	pop    %edi
80107ef1:	5d                   	pop    %ebp
80107ef2:	c3                   	ret    
80107ef3:	90                   	nop
80107ef4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      kfree(mem);
80107ef8:	83 ec 0c             	sub    $0xc,%esp
80107efb:	56                   	push   %esi
80107efc:	e8 0f a4 ff ff       	call   80102310 <kfree>
      goto bad;
80107f01:	83 c4 10             	add    $0x10,%esp
80107f04:	eb cd                	jmp    80107ed3 <copyuvm+0xa3>
      panic("copyuvm: page not present");
80107f06:	83 ec 0c             	sub    $0xc,%esp
80107f09:	68 2e 8b 10 80       	push   $0x80108b2e
80107f0e:	e8 7d 84 ff ff       	call   80100390 <panic>
      panic("copyuvm: pte should exist");
80107f13:	83 ec 0c             	sub    $0xc,%esp
80107f16:	68 14 8b 10 80       	push   $0x80108b14
80107f1b:	e8 70 84 ff ff       	call   80100390 <panic>

80107f20 <uva2ka>:

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
80107f20:	55                   	push   %ebp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80107f21:	31 c9                	xor    %ecx,%ecx
{
80107f23:	89 e5                	mov    %esp,%ebp
80107f25:	83 ec 08             	sub    $0x8,%esp
  pte = walkpgdir(pgdir, uva, 0);
80107f28:	8b 55 0c             	mov    0xc(%ebp),%edx
80107f2b:	8b 45 08             	mov    0x8(%ebp),%eax
80107f2e:	e8 9d f7 ff ff       	call   801076d0 <walkpgdir>
  if((*pte & PTE_P) == 0)
80107f33:	8b 00                	mov    (%eax),%eax
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  return (char*)P2V(PTE_ADDR(*pte));
}
80107f35:	c9                   	leave  
  if((*pte & PTE_U) == 0)
80107f36:	89 c2                	mov    %eax,%edx
  return (char*)P2V(PTE_ADDR(*pte));
80107f38:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  if((*pte & PTE_U) == 0)
80107f3d:	83 e2 05             	and    $0x5,%edx
  return (char*)P2V(PTE_ADDR(*pte));
80107f40:	05 00 00 00 80       	add    $0x80000000,%eax
80107f45:	83 fa 05             	cmp    $0x5,%edx
80107f48:	ba 00 00 00 00       	mov    $0x0,%edx
80107f4d:	0f 45 c2             	cmovne %edx,%eax
}
80107f50:	c3                   	ret    
80107f51:	eb 0d                	jmp    80107f60 <copyout>
80107f53:	90                   	nop
80107f54:	90                   	nop
80107f55:	90                   	nop
80107f56:	90                   	nop
80107f57:	90                   	nop
80107f58:	90                   	nop
80107f59:	90                   	nop
80107f5a:	90                   	nop
80107f5b:	90                   	nop
80107f5c:	90                   	nop
80107f5d:	90                   	nop
80107f5e:	90                   	nop
80107f5f:	90                   	nop

80107f60 <copyout>:
// Copy len bytes from p to user address va in page table pgdir.
// Most useful when pgdir is not the current page table.
// uva2ka ensures this only works for PTE_U pages.
int
copyout(pde_t *pgdir, uint va, void *p, uint len)
{
80107f60:	55                   	push   %ebp
80107f61:	89 e5                	mov    %esp,%ebp
80107f63:	57                   	push   %edi
80107f64:	56                   	push   %esi
80107f65:	53                   	push   %ebx
80107f66:	83 ec 1c             	sub    $0x1c,%esp
80107f69:	8b 5d 14             	mov    0x14(%ebp),%ebx
80107f6c:	8b 55 0c             	mov    0xc(%ebp),%edx
80107f6f:	8b 7d 10             	mov    0x10(%ebp),%edi
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
80107f72:	85 db                	test   %ebx,%ebx
80107f74:	75 40                	jne    80107fb6 <copyout+0x56>
80107f76:	eb 70                	jmp    80107fe8 <copyout+0x88>
80107f78:	90                   	nop
80107f79:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    va0 = (uint)PGROUNDDOWN(va);
    pa0 = uva2ka(pgdir, (char*)va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (va - va0);
80107f80:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80107f83:	89 f1                	mov    %esi,%ecx
80107f85:	29 d1                	sub    %edx,%ecx
80107f87:	81 c1 00 10 00 00    	add    $0x1000,%ecx
80107f8d:	39 d9                	cmp    %ebx,%ecx
80107f8f:	0f 47 cb             	cmova  %ebx,%ecx
    if(n > len)
      n = len;
    memmove(pa0 + (va - va0), buf, n);
80107f92:	29 f2                	sub    %esi,%edx
80107f94:	83 ec 04             	sub    $0x4,%esp
80107f97:	01 d0                	add    %edx,%eax
80107f99:	51                   	push   %ecx
80107f9a:	57                   	push   %edi
80107f9b:	50                   	push   %eax
80107f9c:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
80107f9f:	e8 1c d5 ff ff       	call   801054c0 <memmove>
    len -= n;
    buf += n;
80107fa4:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  while(len > 0){
80107fa7:	83 c4 10             	add    $0x10,%esp
    va = va0 + PGSIZE;
80107faa:	8d 96 00 10 00 00    	lea    0x1000(%esi),%edx
    buf += n;
80107fb0:	01 cf                	add    %ecx,%edi
  while(len > 0){
80107fb2:	29 cb                	sub    %ecx,%ebx
80107fb4:	74 32                	je     80107fe8 <copyout+0x88>
    va0 = (uint)PGROUNDDOWN(va);
80107fb6:	89 d6                	mov    %edx,%esi
    pa0 = uva2ka(pgdir, (char*)va0);
80107fb8:	83 ec 08             	sub    $0x8,%esp
    va0 = (uint)PGROUNDDOWN(va);
80107fbb:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80107fbe:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
    pa0 = uva2ka(pgdir, (char*)va0);
80107fc4:	56                   	push   %esi
80107fc5:	ff 75 08             	pushl  0x8(%ebp)
80107fc8:	e8 53 ff ff ff       	call   80107f20 <uva2ka>
    if(pa0 == 0)
80107fcd:	83 c4 10             	add    $0x10,%esp
80107fd0:	85 c0                	test   %eax,%eax
80107fd2:	75 ac                	jne    80107f80 <copyout+0x20>
  }
  return 0;
}
80107fd4:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
80107fd7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80107fdc:	5b                   	pop    %ebx
80107fdd:	5e                   	pop    %esi
80107fde:	5f                   	pop    %edi
80107fdf:	5d                   	pop    %ebp
80107fe0:	c3                   	ret    
80107fe1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107fe8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80107feb:	31 c0                	xor    %eax,%eax
}
80107fed:	5b                   	pop    %ebx
80107fee:	5e                   	pop    %esi
80107fef:	5f                   	pop    %edi
80107ff0:	5d                   	pop    %ebp
80107ff1:	c3                   	ret    
