Return-Path: <SRS0=waMk=NM=vger.kernel.org=linux-crypto-owner@kernel.org>
Received: from mail-io1-f72.google.com ([209.85.166.72]:47796 "EHLO
        mail-io1-f72.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728790AbeKAXgQ (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 1 Nov 2018 19:36:16 -0400
Received: by mail-io1-f72.google.com with SMTP id y8-v6so17800970ioc.14
        for <linux-crypto@vger.kernel.org>; Thu, 01 Nov 2018 07:33:03 -0700 (PDT)
MIME-Version: 1.0
Date: Thu, 01 Nov 2018 07:33:02 -0700
Message-ID: <000000000000d8053d05799b4b86@google.com>
Subject: KASAN: use-after-free Read in skcipher_recvmsg
From: syzbot <syzbot+6939a606a5305e9e9799@syzkaller.appspotmail.com>
To: davem@davemloft.net, herbert@gondor.apana.org.au,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hello,

syzbot found the following crash on:

HEAD commit:    59fc453b21f7 Merge branch 'akpm' (patches from Andrew)
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=14bc682b400000
kernel config:  https://syzkaller.appspot.com/x/.config?x=ea045471e4c756e8
dashboard link: https://syzkaller.appspot.com/bug?extid=6939a606a5305e9e9799
compiler:       gcc (GCC) 8.0.1 20180413 (experimental)

Unfortunately, I don't have any reproducer for this crash yet.

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+6939a606a5305e9e9799@syzkaller.appspotmail.com

==================================================================
BUG: KASAN: use-after-free in crypto_stat_skcipher_decrypt  
include/crypto/skcipher.h:510 [inline]
BUG: KASAN: use-after-free in crypto_skcipher_decrypt  
include/crypto/skcipher.h:559 [inline]
BUG: KASAN: use-after-free in _skcipher_recvmsg crypto/algif_skcipher.c:131  
[inline]
BUG: KASAN: use-after-free in skcipher_recvmsg+0x160f/0x1780  
crypto/algif_skcipher.c:165
Read of size 4 at addr ffff8801b69239c0 by task syz-executor3/23539

CPU: 0 PID: 23539 Comm: syz-executor3 Not tainted 4.19.0+ #313
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS  
Google 01/01/2011
Call Trace:
  __dump_stack lib/dump_stack.c:77 [inline]
  dump_stack+0x244/0x39d lib/dump_stack.c:113
  print_address_description.cold.7+0x9/0x1ff mm/kasan/report.c:256
  kasan_report_error mm/kasan/report.c:354 [inline]
  kasan_report.cold.8+0x242/0x309 mm/kasan/report.c:412
  __asan_report_load4_noabort+0x14/0x20 mm/kasan/report.c:432
  crypto_stat_skcipher_decrypt include/crypto/skcipher.h:510 [inline]
  crypto_skcipher_decrypt include/crypto/skcipher.h:559 [inline]
  _skcipher_recvmsg crypto/algif_skcipher.c:131 [inline]
  skcipher_recvmsg+0x160f/0x1780 crypto/algif_skcipher.c:165
  sock_recvmsg_nosec net/socket.c:794 [inline]
  sock_recvmsg+0xd0/0x110 net/socket.c:801
  sock_read_iter+0x39b/0x570 net/socket.c:878
kvm [23531]: vcpu0, guest rIP: 0xfff0 unimplemented HWCR wrmsr: 0x80000280
  call_read_iter include/linux/fs.h:1833 [inline]
  aio_read+0x297/0x490 fs/aio.c:1516
  io_submit_one+0xac2/0xf80 fs/aio.c:1832
  __do_sys_io_submit fs/aio.c:1916 [inline]
  __se_sys_io_submit fs/aio.c:1887 [inline]
  __x64_sys_io_submit+0x1b7/0x580 fs/aio.c:1887
  do_syscall_64+0x1b9/0x820 arch/x86/entry/common.c:290
  entry_SYSCALL_64_after_hwframe+0x49/0xbe
binder: 23534:23545 ioctl c018620b 20000340 returned -14
RIP: 0033:0x457569
Code: fd b3 fb ff c3 66 2e 0f 1f 84 00 00 00 00 00 66 90 48 89 f8 48 89 f7  
48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff  
ff 0f 83 cb b3 fb ff c3 66 2e 0f 1f 84 00 00 00 00
RSP: 002b:00007f351c0cdc78 EFLAGS: 00000246 ORIG_RAX: 00000000000000d1
RAX: ffffffffffffffda RBX: 0000000000000003 RCX: 0000000000457569
RDX: 0000000020bd9fe0 RSI: 0000000000000001 RDI: 00007f351c0ad000
RBP: 000000000072bf00 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 00007f351c0ce6d4
R13: 00000000004be72d R14: 00000000004ce600 R15: 00000000ffffffff

Allocated by task 23539:
  save_stack+0x43/0xd0 mm/kasan/kasan.c:448
  set_track mm/kasan/kasan.c:460 [inline]
  kasan_kmalloc+0xc7/0xe0 mm/kasan/kasan.c:553
  __do_kmalloc mm/slab.c:3722 [inline]
  __kmalloc+0x15b/0x760 mm/slab.c:3731
  kmalloc include/linux/slab.h:551 [inline]
  sock_kmalloc+0x15a/0x1f0 net/core/sock.c:1984
  af_alg_alloc_areq+0x83/0x280 crypto/af_alg.c:1097
  _skcipher_recvmsg crypto/algif_skcipher.c:75 [inline]
  skcipher_recvmsg+0x354/0x1780 crypto/algif_skcipher.c:165
  sock_recvmsg_nosec net/socket.c:794 [inline]
  sock_recvmsg+0xd0/0x110 net/socket.c:801
  sock_read_iter+0x39b/0x570 net/socket.c:878
  call_read_iter include/linux/fs.h:1833 [inline]
  aio_read+0x297/0x490 fs/aio.c:1516
  io_submit_one+0xac2/0xf80 fs/aio.c:1832
  __do_sys_io_submit fs/aio.c:1916 [inline]
  __se_sys_io_submit fs/aio.c:1887 [inline]
  __x64_sys_io_submit+0x1b7/0x580 fs/aio.c:1887
  do_syscall_64+0x1b9/0x820 arch/x86/entry/common.c:290
  entry_SYSCALL_64_after_hwframe+0x49/0xbe

Freed by task 19019:
  save_stack+0x43/0xd0 mm/kasan/kasan.c:448
  set_track mm/kasan/kasan.c:460 [inline]
  __kasan_slab_free+0x102/0x150 mm/kasan/kasan.c:521
  kasan_slab_free+0xe/0x10 mm/kasan/kasan.c:528
  __cache_free mm/slab.c:3498 [inline]
  kfree+0xcf/0x230 mm/slab.c:3817
  __sock_kfree_s net/core/sock.c:2005 [inline]
  sock_kfree_s+0x29/0x60 net/core/sock.c:2011
  af_alg_free_resources+0x6b/0x80 crypto/af_alg.c:1033
  af_alg_async_cb+0xbc/0x180 crypto/af_alg.c:1056
  cryptd_skcipher_complete+0x14c/0x250 crypto/cryptd.c:474
  cryptd_skcipher_decrypt+0x4e2/0x750 crypto/cryptd.c:534
  cryptd_queue_worker+0x12d/0x200 crypto/cryptd.c:193
  process_one_work+0xc90/0x1c40 kernel/workqueue.c:2153
  worker_thread+0x17f/0x1390 kernel/workqueue.c:2296
  kthread+0x35a/0x440 kernel/kthread.c:246
  ret_from_fork+0x3a/0x50 arch/x86/entry/entry_64.S:350

The buggy address belongs to the object at ffff8801b69236c0
  which belongs to the cache kmalloc-1k of size 1024
The buggy address is located 768 bytes inside of
  1024-byte region [ffff8801b69236c0, ffff8801b6923ac0)
The buggy address belongs to the page:
page:ffffea0006da4880 count:1 mapcount:0 mapping:ffff8801da800ac0  
index:0xffff8801b6922940 compound_mapcount: 0
flags: 0x2fffc0000010200(slab|head)
raw: 02fffc0000010200 ffffea00070a7b08 ffffea00063a1608 ffff8801da800ac0
kvm [23547]: vcpu0, guest rIP: 0xfff0 unimplemented HWCR wrmsr: 0x80000280
raw: ffff8801b6922940 ffff8801b6922040 0000000100000006 0000000000000000
page dumped because: kasan: bad access detected

Memory state around the buggy address:
  ffff8801b6923880: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
  ffff8801b6923900: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
> ffff8801b6923980: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
                                            ^
  ffff8801b6923a00: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
  ffff8801b6923a80: fb fb fb fb fb fb fb fb fc fc fc fc fc fc fc fc
==================================================================


---
This bug is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this bug report. See:
https://goo.gl/tpsmEJ#bug-status-tracking for how to communicate with  
syzbot.
