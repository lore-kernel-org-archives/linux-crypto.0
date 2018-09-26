From: syzbot <syzbot+6d3612ba5e254e387153@syzkaller.appspotmail.com>
Subject: KASAN: use-after-free Read in generic_gcmaes_encrypt
Date: Wed, 26 Sep 2018 13:24:02 -0700
Message-ID: <000000000000d014010576cc00f4@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
To: davem@davemloft.net, herbert@gondor.apana.org.au, hpa@zytor.com,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        mingo@redhat.com, syzkaller-bugs@googlegroups.com,
        tglx@linutronix.de, x86@kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Hello,

syzbot found the following crash on:

HEAD commit:    739d0def85ca Merge branch 'hv_netvsc-Support-LRO-RSC-in-th..
git tree:       net-next
console output: https://syzkaller.appspot.com/x/log.txt?x=1146ffae400000
kernel config:  https://syzkaller.appspot.com/x/.config?x=e79b9299baeb2298
dashboard link: https://syzkaller.appspot.com/bug?extid=6d3612ba5e254e387153
compiler:       gcc (GCC) 8.0.1 20180413 (experimental)
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=16200b9e400000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=102311c6400000

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+6d3612ba5e254e387153@syzkaller.appspotmail.com

random: sshd: uninitialized urandom read (32 bytes read)
==================================================================
BUG: KASAN: use-after-free in memcpy include/linux/string.h:345 [inline]
BUG: KASAN: use-after-free in generic_gcmaes_encrypt+0xc6/0x186  
arch/x86/crypto/aesni-intel_glue.c:1291
Read of size 12 at addr ffff8801d7ad0900 by task kworker/0:1/14

CPU: 0 PID: 14 Comm: kworker/0:1 Not tainted 4.19.0-rc4+ #228
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS  
Google 01/01/2011
Workqueue: pencrypt padata_parallel_worker
Call Trace:
  __dump_stack lib/dump_stack.c:77 [inline]
  dump_stack+0x1c4/0x2b4 lib/dump_stack.c:113
  print_address_description.cold.8+0x9/0x1ff mm/kasan/report.c:256
  kasan_report_error mm/kasan/report.c:354 [inline]
  kasan_report.cold.9+0x242/0x309 mm/kasan/report.c:412
  check_memory_region_inline mm/kasan/kasan.c:260 [inline]
  check_memory_region+0x13e/0x1b0 mm/kasan/kasan.c:267
  memcpy+0x23/0x50 mm/kasan/kasan.c:302
  memcpy include/linux/string.h:345 [inline]
  generic_gcmaes_encrypt+0xc6/0x186 arch/x86/crypto/aesni-intel_glue.c:1291
  crypto_aead_encrypt include/crypto/aead.h:335 [inline]
  gcmaes_wrapper_encrypt+0x162/0x200 arch/x86/crypto/aesni-intel_glue.c:1127
  crypto_aead_encrypt include/crypto/aead.h:335 [inline]
  pcrypt_aead_enc+0xcb/0x190 crypto/pcrypt.c:143
  padata_parallel_worker+0x49d/0x760 kernel/padata.c:86
  process_one_work+0xc90/0x1b90 kernel/workqueue.c:2153
  worker_thread+0x17f/0x1390 kernel/workqueue.c:2296
  kthread+0x35a/0x420 kernel/kthread.c:246
  ret_from_fork+0x3a/0x50 arch/x86/entry/entry_64.S:413

Allocated by task 5474:
  save_stack+0x43/0xd0 mm/kasan/kasan.c:448
  set_track mm/kasan/kasan.c:460 [inline]
  kasan_kmalloc+0xc7/0xe0 mm/kasan/kasan.c:553
  kmem_cache_alloc_trace+0x152/0x750 mm/slab.c:3620
  kmalloc include/linux/slab.h:513 [inline]
  tls_set_sw_offload+0xcc4/0x14b0 net/tls/tls_sw.c:1741
  do_tls_setsockopt_conf net/tls/tls_main.c:467 [inline]
  do_tls_setsockopt net/tls/tls_main.c:514 [inline]
  tls_setsockopt+0x689/0x770 net/tls/tls_main.c:533
  sock_common_setsockopt+0x9a/0xe0 net/core/sock.c:3038
  __sys_setsockopt+0x1ba/0x3c0 net/socket.c:1902
  __do_sys_setsockopt net/socket.c:1913 [inline]
  __se_sys_setsockopt net/socket.c:1910 [inline]
  __x64_sys_setsockopt+0xbe/0x150 net/socket.c:1910
  do_syscall_64+0x1b9/0x820 arch/x86/entry/common.c:290
  entry_SYSCALL_64_after_hwframe+0x49/0xbe

Freed by task 5472:
  save_stack+0x43/0xd0 mm/kasan/kasan.c:448
  set_track mm/kasan/kasan.c:460 [inline]
  __kasan_slab_free+0x102/0x150 mm/kasan/kasan.c:521
  kasan_slab_free+0xe/0x10 mm/kasan/kasan.c:528
  __cache_free mm/slab.c:3498 [inline]
  kfree+0xcf/0x230 mm/slab.c:3813
  tls_sk_proto_close+0x5fd/0x750 net/tls/tls_main.c:277
  inet_release+0x104/0x1f0 net/ipv4/af_inet.c:428
  inet6_release+0x50/0x70 net/ipv6/af_inet6.c:458
  __sock_release+0xd7/0x250 net/socket.c:579
  sock_close+0x19/0x20 net/socket.c:1141
  __fput+0x385/0xa30 fs/file_table.c:278
  ____fput+0x15/0x20 fs/file_table.c:309
  task_work_run+0x1e8/0x2a0 kernel/task_work.c:113
  tracehook_notify_resume include/linux/tracehook.h:193 [inline]
  exit_to_usermode_loop+0x318/0x380 arch/x86/entry/common.c:166
  prepare_exit_to_usermode arch/x86/entry/common.c:197 [inline]
  syscall_return_slowpath arch/x86/entry/common.c:268 [inline]
  do_syscall_64+0x6be/0x820 arch/x86/entry/common.c:293
  entry_SYSCALL_64_after_hwframe+0x49/0xbe

The buggy address belongs to the object at ffff8801d7ad0900
  which belongs to the cache kmalloc-32 of size 32
The buggy address is located 0 bytes inside of
  32-byte region [ffff8801d7ad0900, ffff8801d7ad0920)
The buggy address belongs to the page:
page:ffffea00075eb400 count:1 mapcount:0 mapping:ffff8801da8001c0  
index:0xffff8801d7ad0fc1
flags: 0x2fffc0000000100(slab)
raw: 02fffc0000000100 ffffea00075eb948 ffffea00075ff688 ffff8801da8001c0
raw: ffff8801d7ad0fc1 ffff8801d7ad0000 000000010000003f 0000000000000000
page dumped because: kasan: bad access detected

Memory state around the buggy address:
  ffff8801d7ad0800: fb fb fb fb fc fc fc fc 00 00 fc fc fc fc fc fc
  ffff8801d7ad0880: fb fb fb fb fc fc fc fc fb fb fb fb fc fc fc fc
> ffff8801d7ad0900: fb fb fb fb fc fc fc fc fb fb fb fb fc fc fc fc
                    ^
  ffff8801d7ad0980: fb fb fb fb fc fc fc fc 00 00 fc fc fc fc fc fc
  ffff8801d7ad0a00: 00 00 00 00 fc fc fc fc 00 00 00 00 fc fc fc fc
==================================================================


---
This bug is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this bug report. See:
https://goo.gl/tpsmEJ#bug-status-tracking for how to communicate with  
syzbot.
syzbot can test patches for this bug, for details see:
https://goo.gl/tpsmEJ#testing-patches
