From: syzbot <syzbot+352126a5be7ccb25754e@syzkaller.appspotmail.com>
Subject: KASAN: use-after-free Read in crypto_destroy_tfm
Date: Sat, 26 May 2018 10:40:01 -0700
Message-ID: <000000000000c791b2056d1f5f7e@google.com>
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

HEAD commit:    0644f186fc9d Merge tag 'for_linus' of git://git.kernel.org..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=102bc257800000
kernel config:  https://syzkaller.appspot.com/x/.config?x=61c12b53c2a25ec4
dashboard link: https://syzkaller.appspot.com/bug?extid=352126a5be7ccb25754e
compiler:       gcc (GCC) 8.0.1 20180413 (experimental)

Unfortunately, I don't have any reproducer for this crash yet.

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+352126a5be7ccb25754e@syzkaller.appspotmail.com

==================================================================
BUG: KASAN: use-after-free in crypto_destroy_tfm+0x2a3/0x300  
crypto/api.c:573
Read of size 8 at addr ffff8801d9023238 by task syz-executor6/10078

CPU: 1 PID: 10078 Comm: syz-executor6 Not tainted 4.17.0-rc2+ #19
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS  
Google 01/01/2011
Call Trace:
  __dump_stack lib/dump_stack.c:77 [inline]
  dump_stack+0x1b9/0x294 lib/dump_stack.c:113
  print_address_description+0x6c/0x20b mm/kasan/report.c:256
  kasan_report_error mm/kasan/report.c:354 [inline]
  kasan_report.cold.7+0x242/0x2fe mm/kasan/report.c:412
  __asan_report_load8_noabort+0x14/0x20 mm/kasan/report.c:433
  crypto_destroy_tfm+0x2a3/0x300 crypto/api.c:573
  crypto_free_rng include/crypto/rng.h:122 [inline]
  rng_release+0x18/0x20 crypto/algif_rng.c:124
  alg_do_release crypto/af_alg.c:119 [inline]
  alg_sock_destruct+0x92/0xe0 crypto/af_alg.c:362
  __sk_destruct+0xff/0xa40 net/core/sock.c:1566
  sk_destruct+0x78/0x90 net/core/sock.c:1601
  __sk_free+0x22e/0x340 net/core/sock.c:1612
  sk_free+0x42/0x50 net/core/sock.c:1623
  sock_put include/net/sock.h:1664 [inline]
  af_alg_release+0x6e/0x90 crypto/af_alg.c:126
  sock_release+0x96/0x1b0 net/socket.c:594
  sock_close+0x16/0x20 net/socket.c:1149
  __fput+0x34d/0x890 fs/file_table.c:209
  ____fput+0x15/0x20 fs/file_table.c:243
  task_work_run+0x1e4/0x290 kernel/task_work.c:113
  exit_task_work include/linux/task_work.h:22 [inline]
  do_exit+0x1aee/0x2730 kernel/exit.c:865
  do_group_exit+0x16f/0x430 kernel/exit.c:968
  get_signal+0x886/0x1960 kernel/signal.c:2469
  do_signal+0x98/0x2040 arch/x86/kernel/signal.c:810
  exit_to_usermode_loop+0x28a/0x310 arch/x86/entry/common.c:162
  prepare_exit_to_usermode arch/x86/entry/common.c:196 [inline]
  syscall_return_slowpath arch/x86/entry/common.c:265 [inline]
  do_syscall_64+0x6ac/0x800 arch/x86/entry/common.c:290
  entry_SYSCALL_64_after_hwframe+0x49/0xbe
RIP: 0033:0x455979
RSP: 002b:00007f4f4bbc2c68 EFLAGS: 00000246 ORIG_RAX: 0000000000000036
RAX: 0000000000000000 RBX: 00007f4f4bbc36d4 RCX: 0000000000455979
RDX: 0000000000000001 RSI: 0000000000000117 RDI: 0000000000000014
RBP: 000000000072bf50 R08: 0000000000000000 R09: 0000000000000000
R10: 00000000204f7000 R11: 0000000000000246 R12: 00000000ffffffff
R13: 0000000000000519 R14: 00000000006faaf8 R15: 0000000000000001

Allocated by task 4484:
  save_stack+0x43/0xd0 mm/kasan/kasan.c:448
  set_track mm/kasan/kasan.c:460 [inline]
  kasan_kmalloc+0xc4/0xe0 mm/kasan/kasan.c:553
  __do_kmalloc_node mm/slab.c:3682 [inline]
  __kmalloc_node_track_caller+0x47/0x70 mm/slab.c:3696
  __kmalloc_reserve.isra.38+0x3a/0xe0 net/core/skbuff.c:137
  __alloc_skb+0x14d/0x780 net/core/skbuff.c:205
  alloc_skb include/linux/skbuff.h:987 [inline]
  netlink_alloc_large_skb net/netlink/af_netlink.c:1182 [inline]
  netlink_sendmsg+0xb01/0xfa0 net/netlink/af_netlink.c:1876
  sock_sendmsg_nosec net/socket.c:629 [inline]
  sock_sendmsg+0xd5/0x120 net/socket.c:639
  ___sys_sendmsg+0x805/0x940 net/socket.c:2117
  __sys_sendmsg+0x115/0x270 net/socket.c:2155
  __do_sys_sendmsg net/socket.c:2164 [inline]
  __se_sys_sendmsg net/socket.c:2162 [inline]
  __x64_sys_sendmsg+0x78/0xb0 net/socket.c:2162
  do_syscall_64+0x1b1/0x800 arch/x86/entry/common.c:287
  entry_SYSCALL_64_after_hwframe+0x49/0xbe

Freed by task 4484:
  save_stack+0x43/0xd0 mm/kasan/kasan.c:448
  set_track mm/kasan/kasan.c:460 [inline]
  __kasan_slab_free+0x11a/0x170 mm/kasan/kasan.c:521
  kasan_slab_free+0xe/0x10 mm/kasan/kasan.c:528
  __cache_free mm/slab.c:3498 [inline]
  kfree+0xd9/0x260 mm/slab.c:3813
  skb_free_head+0x99/0xc0 net/core/skbuff.c:550
  skb_release_data+0x690/0x860 net/core/skbuff.c:570
  skb_release_all+0x4a/0x60 net/core/skbuff.c:627
  __kfree_skb net/core/skbuff.c:641 [inline]
  consume_skb+0x18b/0x550 net/core/skbuff.c:701
  netlink_unicast_kernel net/netlink/af_netlink.c:1311 [inline]
  netlink_unicast+0x593/0x740 net/netlink/af_netlink.c:1336
  netlink_sendmsg+0x9f0/0xfa0 net/netlink/af_netlink.c:1901
  sock_sendmsg_nosec net/socket.c:629 [inline]
  sock_sendmsg+0xd5/0x120 net/socket.c:639
  ___sys_sendmsg+0x805/0x940 net/socket.c:2117
  __sys_sendmsg+0x115/0x270 net/socket.c:2155
  __do_sys_sendmsg net/socket.c:2164 [inline]
  __se_sys_sendmsg net/socket.c:2162 [inline]
  __x64_sys_sendmsg+0x78/0xb0 net/socket.c:2162
  do_syscall_64+0x1b1/0x800 arch/x86/entry/common.c:287
  entry_SYSCALL_64_after_hwframe+0x49/0xbe

The buggy address belongs to the object at ffff8801d9023200
  which belongs to the cache kmalloc-1024 of size 1024
The buggy address is located 56 bytes inside of
  1024-byte region [ffff8801d9023200, ffff8801d9023600)
The buggy address belongs to the page:
page:ffffea0007640880 count:1 mapcount:0 mapping:ffff8801d9022000 index:0x0  
compound_mapcount: 0
flags: 0x2fffc0000008100(slab|head)
raw: 02fffc0000008100 ffff8801d9022000 0000000000000000 0000000100000007
raw: ffffea0006ea5e20 ffffea00073785a0 ffff8801da800ac0 0000000000000000
page dumped because: kasan: bad access detected

Memory state around the buggy address:
  ffff8801d9023100: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
  ffff8801d9023180: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
> ffff8801d9023200: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
                                         ^
  ffff8801d9023280: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
  ffff8801d9023300: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
==================================================================


---
This bug is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this bug report. See:
https://goo.gl/tpsmEJ#bug-status-tracking for how to communicate with  
syzbot.
