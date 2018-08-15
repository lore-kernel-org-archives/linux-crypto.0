From: syzbot <syzbot+94ee41ce442afe333d2e@syzkaller.appspotmail.com>
Subject: KASAN: use-after-free Read in sha512_mb_flusher
Date: Wed, 15 Aug 2018 09:35:03 -0700
Message-ID: <00000000000091258805737be8b3@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
To: davem@davemloft.net, herbert@gondor.apana.org.au, hpa@zytor.com,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        megha.dey@linux.intel.com, mingo@redhat.com,
        syzkaller-bugs@googlegroups.com, tglx@linutronix.de,
        tim.c.chen@linux.intel.com, x86@kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Hello,

syzbot found the following crash on:

HEAD commit:    5ed5da74de9e Add linux-next specific files for 20180813
git tree:       linux-next
console output: https://syzkaller.appspot.com/x/log.txt?x=13fd82c4400000
kernel config:  https://syzkaller.appspot.com/x/.config?x=18edf0289d1b5ab
dashboard link: https://syzkaller.appspot.com/bug?extid=94ee41ce442afe333d2e
compiler:       gcc (GCC) 8.0.1 20180413 (experimental)

Unfortunately, I don't have any reproducer for this crash yet.

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+94ee41ce442afe333d2e@syzkaller.appspotmail.com

RDX: 00000000200002c0 RSI: 0000000000000005 RDI: 0000000000000004
RBP: 00000000009300a0 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000f6a R11: 0000000000000246 R12: 0000000000000006
R13: 00000000004d3840 R14: 00000000004c85ae R15: 0000000000000003
==================================================================
BUG: KASAN: use-after-free in sha512_mb_flusher+0x572/0x610  
arch/x86/crypto/sha512-mb/sha512_mb.c:940
Read of size 8 at addr ffff8801b35669d8 by task kworker/0:2/1879

CPU: 0 PID: 1879 Comm: kworker/0:2 Not tainted 4.18.0-next-20180813+ #37
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS  
Google 01/01/2011
Workqueue: crypto mcryptd_flusher
Call Trace:
  __dump_stack lib/dump_stack.c:77 [inline]
  dump_stack+0x1c9/0x2b4 lib/dump_stack.c:113
  print_address_description+0x6c/0x20b mm/kasan/report.c:256
  kasan_report_error mm/kasan/report.c:354 [inline]
  kasan_report.cold.7+0x242/0x30d mm/kasan/report.c:412
  __asan_report_load8_noabort+0x14/0x20 mm/kasan/report.c:433
  sha512_mb_flusher+0x572/0x610 arch/x86/crypto/sha512-mb/sha512_mb.c:940
  mcryptd_flusher+0x342/0x4b0 crypto/mcryptd.c:208
  process_one_work+0xc73/0x1aa0 kernel/workqueue.c:2153
  worker_thread+0x189/0x13c0 kernel/workqueue.c:2296
  kthread+0x35a/0x420 kernel/kthread.c:246
  ret_from_fork+0x3a/0x50 arch/x86/entry/entry_64.S:415

Allocated by task 18983:
  save_stack+0x43/0xd0 mm/kasan/kasan.c:448
  set_track mm/kasan/kasan.c:460 [inline]
  kasan_kmalloc+0xc4/0xe0 mm/kasan/kasan.c:553
  __do_kmalloc mm/slab.c:3718 [inline]
  __kmalloc+0x14e/0x720 mm/slab.c:3727
  kmalloc include/linux/slab.h:518 [inline]
  sock_kmalloc+0x156/0x1f0 net/core/sock.c:1983
  hash_accept_parent_nokey+0x58/0x2e0 crypto/algif_hash.c:438
  hash_accept_parent+0x5b/0x80 crypto/algif_hash.c:465
  af_alg_accept+0x127/0x7d0 crypto/af_alg.c:296
  alg_accept+0x46/0x60 crypto/af_alg.c:332
  __sys_accept4+0x3b2/0x8a0 net/socket.c:1589
  __do_sys_accept4 net/socket.c:1624 [inline]
  __se_sys_accept4 net/socket.c:1621 [inline]
  __x64_sys_accept4+0x97/0xf0 net/socket.c:1621
  do_syscall_64+0x1b9/0x820 arch/x86/entry/common.c:290
  entry_SYSCALL_64_after_hwframe+0x49/0xbe

Freed by task 18979:
  save_stack+0x43/0xd0 mm/kasan/kasan.c:448
  set_track mm/kasan/kasan.c:460 [inline]
  __kasan_slab_free+0x11a/0x170 mm/kasan/kasan.c:521
  kasan_slab_free+0xe/0x10 mm/kasan/kasan.c:528
  __cache_free mm/slab.c:3498 [inline]
  kfree+0xd9/0x210 mm/slab.c:3813
  __sock_kfree_s net/core/sock.c:2004 [inline]
  sock_kfree_s+0x29/0x60 net/core/sock.c:2010
  hash_sock_destruct+0x157/0x1c0 crypto/algif_hash.c:427
  __sk_destruct+0x107/0xa60 net/core/sock.c:1560
  sk_destruct+0x78/0x90 net/core/sock.c:1595
  __sk_free+0xcf/0x300 net/core/sock.c:1606
  sk_free+0x42/0x50 net/core/sock.c:1617
  sock_put include/net/sock.h:1691 [inline]
  af_alg_release+0x6e/0x90 crypto/af_alg.c:126
  __sock_release+0xd7/0x250 net/socket.c:580
  sock_close+0x19/0x20 net/socket.c:1140
  __fput+0x376/0x8a0 fs/file_table.c:279
  ____fput+0x15/0x20 fs/file_table.c:312
  task_work_run+0x1e8/0x2a0 kernel/task_work.c:113
  tracehook_notify_resume include/linux/tracehook.h:193 [inline]
  exit_to_usermode_loop+0x318/0x380 arch/x86/entry/common.c:166
  prepare_exit_to_usermode arch/x86/entry/common.c:197 [inline]
  syscall_return_slowpath arch/x86/entry/common.c:268 [inline]
  do_syscall_64+0x6be/0x820 arch/x86/entry/common.c:293
  entry_SYSCALL_64_after_hwframe+0x49/0xbe

The buggy address belongs to the object at ffff8801b3566600
  which belongs to the cache kmalloc-2048 of size 2048
The buggy address is located 984 bytes inside of
  2048-byte region [ffff8801b3566600, ffff8801b3566e00)
The buggy address belongs to the page:
page:ffffea0006cd5980 count:1 mapcount:0 mapping:ffff8801dac00c40 index:0x0  
compound_mapcount: 0
flags: 0x2fffc0000008100(slab|head)
raw: 02fffc0000008100 ffffea0006cf2c08 ffffea000764ef08 ffff8801dac00c40
raw: 0000000000000000 ffff8801b3566600 0000000100000003 0000000000000000
page dumped because: kasan: bad access detected

Memory state around the buggy address:
  ffff8801b3566880: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
  ffff8801b3566900: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
> ffff8801b3566980: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
                                                     ^
  ffff8801b3566a00: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
  ffff8801b3566a80: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
==================================================================


---
This bug is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this bug report. See:
https://goo.gl/tpsmEJ#bug-status-tracking for how to communicate with  
syzbot.
