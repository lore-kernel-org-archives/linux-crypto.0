From: syzbot <syzbot+1fafa9c4cf42df33f716@syzkaller.appspotmail.com>
Subject: KASAN: slab-out-of-bounds Read in crypto_morus640_decrypt_chunk
Date: Wed, 13 Jun 2018 04:12:02 -0700
Message-ID: <0000000000005abb37056e840d40@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
To: davem@davemloft.net, herbert@gondor.apana.org.au,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        syzkaller-bugs@googlegroups.com
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Hello,

syzbot found the following crash on:

HEAD commit:    f0dc7f9c6dd9 Merge git://git.kernel.org/pub/scm/linux/kern..
git tree:       net-next
console output: https://syzkaller.appspot.com/x/log.txt?x=17e6fb6f800000
kernel config:  https://syzkaller.appspot.com/x/.config?x=fa9c20c48788d1c1
dashboard link: https://syzkaller.appspot.com/bug?extid=1fafa9c4cf42df33f716
compiler:       gcc (GCC) 8.0.1 20180413 (experimental)

Unfortunately, I don't have any reproducer for this crash yet.

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+1fafa9c4cf42df33f716@syzkaller.appspotmail.com

==================================================================
BUG: KASAN: slab-out-of-bounds in crypto_morus640_load_a  
crypto/morus640.c:111 [inline]
BUG: KASAN: slab-out-of-bounds in crypto_morus640_decrypt_chunk+0xcf8/0xd20  
crypto/morus640.c:278
Read of size 4 at addr ffff8801d7611b08 by task syz-executor6/15764

CPU: 1 PID: 15764 Comm: syz-executor6 Not tainted 4.17.0+ #84
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS  
Google 01/01/2011
Call Trace:
  __dump_stack lib/dump_stack.c:77 [inline]
  dump_stack+0x1b9/0x294 lib/dump_stack.c:113
  print_address_description+0x6c/0x20b mm/kasan/report.c:256
  kasan_report_error mm/kasan/report.c:354 [inline]
  kasan_report.cold.7+0x242/0x2fe mm/kasan/report.c:412
  __asan_report_load4_noabort+0x14/0x20 mm/kasan/report.c:432
  crypto_morus640_load_a crypto/morus640.c:111 [inline]
  crypto_morus640_decrypt_chunk+0xcf8/0xd20 crypto/morus640.c:278
  crypto_morus640_process_crypt.isra.12+0x153/0x230 crypto/morus640.c:376
  crypto_morus640_crypt+0x42e/0x9f0 crypto/morus640.c:442
  crypto_morus640_decrypt+0x23e/0x3d0 crypto/morus640.c:485
  crypto_aead_decrypt include/crypto/aead.h:370 [inline]
  _aead_recvmsg crypto/algif_aead.c:315 [inline]
  aead_recvmsg+0x13cc/0x1ba0 crypto/algif_aead.c:334
  sock_recvmsg_nosec net/socket.c:818 [inline]
  sock_recvmsg+0xd0/0x110 net/socket.c:825
  ___sys_recvmsg+0x2b6/0x680 net/socket.c:2323
  __sys_recvmsg+0x112/0x260 net/socket.c:2372
  __do_sys_recvmsg net/socket.c:2382 [inline]
  __se_sys_recvmsg net/socket.c:2379 [inline]
  __x64_sys_recvmsg+0x78/0xb0 net/socket.c:2379
  do_syscall_64+0x1b1/0x800 arch/x86/entry/common.c:290
  entry_SYSCALL_64_after_hwframe+0x49/0xbe
IPVS: set_ctl: invalid protocol: 103 127.0.0.1:20001
RIP: 0033:0x455b29
Code: 1d ba fb ff c3 66 2e 0f 1f 84 00 00 00 00 00 66 90 48 89 f8 48 89 f7  
48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff  
ff 0f 83 eb b9 fb ff c3 66 2e 0f 1f 84 00 00 00 00
RSP: 002b:00007f3f80c2cc68 EFLAGS: 00000246 ORIG_RAX: 000000000000002f
RAX: ffffffffffffffda RBX: 00007f3f80c2d6d4 RCX: 0000000000455b29
RDX: 0000000000000000 RSI: 0000000020002840 RDI: 0000000000000014
RBP: 000000000072bea0 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 00000000ffffffff
R13: 00000000004c084a R14: 00000000004cffe8 R15: 0000000000000000

Allocated by task 15764:
  save_stack+0x43/0xd0 mm/kasan/kasan.c:448
  set_track mm/kasan/kasan.c:460 [inline]
  kasan_kmalloc+0xc4/0xe0 mm/kasan/kasan.c:553
  __do_kmalloc mm/slab.c:3718 [inline]
  __kmalloc+0x14e/0x760 mm/slab.c:3727
  kmalloc include/linux/slab.h:518 [inline]
  kzalloc include/linux/slab.h:706 [inline]
  skcipher_next_slow crypto/skcipher.c:253 [inline]
  skcipher_walk_next+0x750/0x1850 crypto/skcipher.c:357
  skcipher_walk_first+0x151/0x410 crypto/skcipher.c:442
  skcipher_walk_aead_common+0x7f8/0xbc0 crypto/skcipher.c:539
  skcipher_walk_aead_decrypt+0xc7/0x100 crypto/skcipher.c:572
  crypto_morus640_process_crypt.isra.12+0x9c/0x230 crypto/morus640.c:370
  crypto_morus640_crypt+0x42e/0x9f0 crypto/morus640.c:442
  crypto_morus640_decrypt+0x23e/0x3d0 crypto/morus640.c:485
  crypto_aead_decrypt include/crypto/aead.h:370 [inline]
  _aead_recvmsg crypto/algif_aead.c:315 [inline]
  aead_recvmsg+0x13cc/0x1ba0 crypto/algif_aead.c:334
  sock_recvmsg_nosec net/socket.c:818 [inline]
  sock_recvmsg+0xd0/0x110 net/socket.c:825
  ___sys_recvmsg+0x2b6/0x680 net/socket.c:2323
  __sys_recvmsg+0x112/0x260 net/socket.c:2372
  __do_sys_recvmsg net/socket.c:2382 [inline]
  __se_sys_recvmsg net/socket.c:2379 [inline]
  __x64_sys_recvmsg+0x78/0xb0 net/socket.c:2379
  do_syscall_64+0x1b1/0x800 arch/x86/entry/common.c:290
  entry_SYSCALL_64_after_hwframe+0x49/0xbe

Freed by task 4575:
  save_stack+0x43/0xd0 mm/kasan/kasan.c:448
  set_track mm/kasan/kasan.c:460 [inline]
  __kasan_slab_free+0x11a/0x170 mm/kasan/kasan.c:521
  kasan_slab_free+0xe/0x10 mm/kasan/kasan.c:528
  __cache_free mm/slab.c:3498 [inline]
  kfree+0xd9/0x260 mm/slab.c:3813
  kvfree+0x61/0x70 mm/util.c:442
  __vunmap+0x326/0x460 mm/vmalloc.c:1529
  vfree+0x68/0x100 mm/vmalloc.c:1593
  copy_entries_to_user net/ipv6/netfilter/ip6_tables.c:885 [inline]
  get_entries net/ipv6/netfilter/ip6_tables.c:1043 [inline]
  do_ip6t_get_ctl+0xa52/0xc30 net/ipv6/netfilter/ip6_tables.c:1711
  nf_sockopt net/netfilter/nf_sockopt.c:104 [inline]
  nf_getsockopt+0x80/0xe0 net/netfilter/nf_sockopt.c:122
  ipv6_getsockopt+0x1d9/0x300 net/ipv6/ipv6_sockglue.c:1370
  tcp_getsockopt+0x93/0xe0 net/ipv4/tcp.c:3534
  sock_common_getsockopt+0x9a/0xe0 net/core/sock.c:3012
  __sys_getsockopt+0x1a5/0x370 net/socket.c:1984
  __do_sys_getsockopt net/socket.c:1995 [inline]
  __se_sys_getsockopt net/socket.c:1992 [inline]
  __x64_sys_getsockopt+0xbe/0x150 net/socket.c:1992
  do_syscall_64+0x1b1/0x800 arch/x86/entry/common.c:290
  entry_SYSCALL_64_after_hwframe+0x49/0xbe

The buggy address belongs to the object at ffff8801d7611b00
  which belongs to the cache kmalloc-32 of size 32
The buggy address is located 8 bytes inside of
  32-byte region [ffff8801d7611b00, ffff8801d7611b20)
The buggy address belongs to the page:
page:ffffea00075d8440 count:1 mapcount:0 mapping:ffff8801da8001c0  
index:0xffff8801d7611fc1
flags: 0x2fffc0000000100(slab)
raw: 02fffc0000000100 ffffea00075c94c8 ffffea00075d82c8 ffff8801da8001c0
raw: ffff8801d7611fc1 ffff8801d7611000 000000010000000b 0000000000000000
page dumped because: kasan: bad access detected

Memory state around the buggy address:
  ffff8801d7611a00: fb fb fb fb fc fc fc fc 00 02 fc fc fc fc fc fc
  ffff8801d7611a80: 00 02 fc fc fc fc fc fc 00 02 fc fc fc fc fc fc
> ffff8801d7611b00: 00 fc fc fc fc fc fc fc fb fb fb fb fc fc fc fc
                       ^
  ffff8801d7611b80: fb fb fb fb fc fc fc fc fb fb fb fb fc fc fc fc
  ffff8801d7611c00: fb fb fb fb fc fc fc fc fb fb fb fb fc fc fc fc
==================================================================


---
This bug is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this bug report. See:
https://goo.gl/tpsmEJ#bug-status-tracking for how to communicate with  
syzbot.
