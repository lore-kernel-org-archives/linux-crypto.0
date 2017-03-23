From: Dmitry Vyukov <dvyukov@google.com>
Subject: crypto: out-of-bounds write in pre_crypt
Date: Thu, 23 Mar 2017 11:51:30 +0100
Message-ID: <CACT4Y+ZnQq9x7gXTpaRxnMSh_2Uk461J9CWnoq3i5KQBY-nLGw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: syzkaller <syzkaller@googlegroups.com>
To: Herbert Xu <herbert@gondor.apana.org.au>,
        David Miller <davem@davemloft.net>,
        linux-crypto@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-vk0-f51.google.com ([209.85.213.51]:36126 "EHLO
        mail-vk0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751511AbdCWKwC (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 23 Mar 2017 06:52:02 -0400
Received: by mail-vk0-f51.google.com with SMTP id j64so130022524vkg.3
        for <linux-crypto@vger.kernel.org>; Thu, 23 Mar 2017 03:51:51 -0700 (PDT)
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hello,

I've got the following report while running syzkaller fuzzer.
init_crypt ignores kmalloc failure, which later leads to out-of-bounds
writes in ptr_crypt. On commit
093b995e3b55a0ae0670226ddfcb05bfbf0099ae.

FAULT_INJECTION: forcing a failure.
name failslab, interval 1, probability 0, space 0, times 0
CPU: 3 PID: 10711 Comm: syz-executor0 Not tainted 4.11.0-rc3+ #364
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS Bochs 01/01/2011
Call Trace:
 __dump_stack lib/dump_stack.c:16 [inline]
 dump_stack+0x1b8/0x28d lib/dump_stack.c:52
 fail_dump lib/fault-inject.c:45 [inline]
 should_fail+0x78a/0x870 lib/fault-inject.c:154
 should_failslab+0xec/0x120 mm/failslab.c:31
 slab_pre_alloc_hook mm/slab.h:434 [inline]
 slab_alloc mm/slab.c:3394 [inline]
 __do_kmalloc mm/slab.c:3734 [inline]
 __kmalloc+0x220/0x730 mm/slab.c:3745
 kmalloc include/linux/slab.h:495 [inline]
 init_crypt+0x1c1/0x4f0 crypto/lrw.c:290
 encrypt+0x1c/0x30 crypto/xts.c:298
 crypto_skcipher_encrypt include/crypto/skcipher.h:445 [inline]
 skcipher_recvmsg_sync crypto/algif_skcipher.c:687 [inline]
 skcipher_recvmsg+0x669/0x1ea0 crypto/algif_skcipher.c:717
 skcipher_recvmsg_nokey+0x60/0x80 crypto/algif_skcipher.c:834
 sock_recvmsg_nosec net/socket.c:740 [inline]
 sock_recvmsg+0xc9/0x110 net/socket.c:747
 sock_read_iter+0x35b/0x560 net/socket.c:824
 call_read_iter include/linux/fs.h:1727 [inline]
 do_iter_readv_writev fs/read_write.c:694 [inline]
 __do_readv_writev+0x6c8/0xf40 fs/read_write.c:862
 do_readv_writev+0x10f/0x1a0 fs/read_write.c:894
 vfs_readv+0x84/0xc0 fs/read_write.c:908
 do_readv+0xfc/0x2a0 fs/read_write.c:934
 SYSC_readv fs/read_write.c:1021 [inline]
 SyS_readv+0x27/0x30 fs/read_write.c:1018
 entry_SYSCALL_64_fastpath+0x1f/0xc2
RIP: 0033:0x445b79
RSP: 002b:00007f20d831e858 EFLAGS: 00000296 ORIG_RAX: 0000000000000013
RAX: ffffffffffffffda RBX: 0000000000708000 RCX: 0000000000445b79
RDX: 0000000000000003 RSI: 0000000020e86000 RDI: 0000000000000019
RBP: 0000000000000086 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000296 R12: 00000000004a7e31
R13: 0000000000000000 R14: 00007f20d831e618 R15: 00007f20d831e788
==================================================================
BUG: KASAN: slab-out-of-bounds in pre_crypt+0x1078/0x1100
crypto/lrw.c:235 at addr ffff88005f17aee0
Write of size 16 by task syz-executor0/10711
CPU: 3 PID: 10711 Comm: syz-executor0 Not tainted 4.11.0-rc3+ #364
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS Bochs 01/01/2011
Call Trace:
 __dump_stack lib/dump_stack.c:16 [inline]
 dump_stack+0x1b8/0x28d lib/dump_stack.c:52
 kasan_object_err+0x1c/0x70 mm/kasan/report.c:166
 print_address_description mm/kasan/report.c:210 [inline]
 kasan_report_error mm/kasan/report.c:294 [inline]
 kasan_report.part.2+0x1be/0x480 mm/kasan/report.c:316
 kasan_report mm/kasan/report.c:343 [inline]
 __asan_report_store16_noabort+0x2c/0x30 mm/kasan/report.c:343
 pre_crypt+0x1078/0x1100 crypto/lrw.c:235
 do_encrypt+0xd2/0x260 crypto/xts.c:265
 encrypt+0x26/0x30 crypto/xts.c:298
 crypto_skcipher_encrypt include/crypto/skcipher.h:445 [inline]
 skcipher_recvmsg_sync crypto/algif_skcipher.c:687 [inline]
 skcipher_recvmsg+0x669/0x1ea0 crypto/algif_skcipher.c:717
 skcipher_recvmsg_nokey+0x60/0x80 crypto/algif_skcipher.c:834
 sock_recvmsg_nosec net/socket.c:740 [inline]
 sock_recvmsg+0xc9/0x110 net/socket.c:747
 sock_read_iter+0x35b/0x560 net/socket.c:824
 call_read_iter include/linux/fs.h:1727 [inline]
 do_iter_readv_writev fs/read_write.c:694 [inline]
 __do_readv_writev+0x6c8/0xf40 fs/read_write.c:862
 do_readv_writev+0x10f/0x1a0 fs/read_write.c:894
 vfs_readv+0x84/0xc0 fs/read_write.c:908
 do_readv+0xfc/0x2a0 fs/read_write.c:934
 SYSC_readv fs/read_write.c:1021 [inline]
 SyS_readv+0x27/0x30 fs/read_write.c:1018
 entry_SYSCALL_64_fastpath+0x1f/0xc2
RIP: 0033:0x445b79
RSP: 002b:00007f20d831e858 EFLAGS: 00000296 ORIG_RAX: 0000000000000013
RAX: ffffffffffffffda RBX: 0000000000708000 RCX: 0000000000445b79
RDX: 0000000000000003 RSI: 0000000020e86000 RDI: 0000000000000019
RBP: 0000000000000086 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000296 R12: 00000000004a7e31
R13: 0000000000000000 R14: 00007f20d831e618 R15: 00007f20d831e788
Object at ffff88005f17a940, in cache kmalloc-2048 size: 2048
Allocated:
PID = 10711
 save_stack_trace+0x16/0x20 arch/x86/kernel/stacktrace.c:59
 save_stack+0x43/0xd0 mm/kasan/kasan.c:517
 set_track mm/kasan/kasan.c:529 [inline]
 kasan_kmalloc+0xbc/0xf0 mm/kasan/kasan.c:620
 __do_kmalloc mm/slab.c:3736 [inline]
 __kmalloc+0x13c/0x730 mm/slab.c:3745
 kmalloc include/linux/slab.h:495 [inline]
 sock_kmalloc+0x118/0x180 net/core/sock.c:1793
 skcipher_accept_parent_nokey+0xd8/0x670 crypto/algif_skcipher.c:931
 af_alg_accept+0x47a/0x7e0 crypto/af_alg.c:297
 alg_accept+0x46/0x60 crypto/af_alg.c:329
 SYSC_accept4+0x37e/0x850 net/socket.c:1509
 SyS_accept4 net/socket.c:1459 [inline]
 SYSC_accept net/socket.c:1543 [inline]
 SyS_accept+0x26/0x30 net/socket.c:1540
 entry_SYSCALL_64_fastpath+0x1f/0xc2
Freed:
PID = 4482
 save_stack_trace+0x16/0x20 arch/x86/kernel/stacktrace.c:59
 save_stack+0x43/0xd0 mm/kasan/kasan.c:517
 set_track mm/kasan/kasan.c:529 [inline]
 kasan_slab_free+0x81/0xc0 mm/kasan/kasan.c:593
 __cache_free mm/slab.c:3514 [inline]
 kfree+0xd7/0x250 mm/slab.c:3831
 free_tty_struct+0x8e/0xb0 drivers/tty/tty_io.c:174
 release_one_tty+0x36f/0x520 drivers/tty/tty_io.c:1647
 process_one_work+0xb20/0x1b40 kernel/workqueue.c:2097
 worker_thread+0x1b4/0x1340 kernel/workqueue.c:2231
 kthread+0x359/0x420 kernel/kthread.c:229
 ret_from_fork+0x31/0x40 arch/x86/entry/entry_64.S:430
Memory state around the buggy address:
 ffff88005f17ad80: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
 ffff88005f17ae00: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
>ffff88005f17ae80: 00 00 00 00 00 00 00 00 00 00 00 00 00 fc fc fc
                                                          ^
 ffff88005f17af00: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
 ffff88005f17af80: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
==================================================================
