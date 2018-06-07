From: syzbot <syzbot+d04e58bd384f1fe0b112@syzkaller.appspotmail.com>
Subject: Re: KASAN: slab-out-of-bounds Write in rmd160_final
Date: Thu, 07 Jun 2018 08:35:02 -0700
Message-ID: <000000000000e24ad8056e0f063e@google.com>
References: <00000000000075cc63056e0d0707@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
To: davem@davemloft.net, herbert@gondor.apana.org.au,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        syzkaller-bugs@googlegroups.com
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <00000000000075cc63056e0d0707@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

syzbot has found a reproducer for the following crash on:

HEAD commit:    1c8c5a9d38f6 Merge git://git.kernel.org/pub/scm/linux/kern..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=1189a3d7800000
kernel config:  https://syzkaller.appspot.com/x/.config?x=4f1acdf888c9d4e9
dashboard link: https://syzkaller.appspot.com/bug?extid=d04e58bd384f1fe0b112
compiler:       gcc (GCC) 8.0.1 20180413 (experimental)
userspace arch: i386
syzkaller repro:https://syzkaller.appspot.com/x/repro.syz?x=14dde79f800000

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+d04e58bd384f1fe0b112@syzkaller.appspotmail.com

IPv6: ADDRCONF(NETDEV_UP): veth0: link is not ready
IPv6: ADDRCONF(NETDEV_CHANGE): veth0: link becomes ready
IPv6: ADDRCONF(NETDEV_CHANGE): bond0: link becomes ready
8021q: adding VLAN 0 to HW filter on device team0
==================================================================
BUG: KASAN: slab-out-of-bounds in rmd160_final+0x201/0x240  
crypto/rmd160.c:334
Write of size 4 at addr ffff8801d0fae518 by task syz-executor0/4822

CPU: 0 PID: 4822 Comm: syz-executor0 Not tainted 4.17.0+ #114
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS  
Google 01/01/2011
Call Trace:
  __dump_stack lib/dump_stack.c:77 [inline]
  dump_stack+0x1b9/0x294 lib/dump_stack.c:113
  print_address_description+0x6c/0x20b mm/kasan/report.c:256
  kasan_report_error mm/kasan/report.c:354 [inline]
  kasan_report.cold.7+0x242/0x2fe mm/kasan/report.c:412
  __asan_report_store4_noabort+0x17/0x20 mm/kasan/report.c:437
  rmd160_final+0x201/0x240 crypto/rmd160.c:334
  crypto_shash_final+0x104/0x260 crypto/shash.c:152
  kdf_ctr security/keys/dh.c:186 [inline]
  keyctl_dh_compute_kdf security/keys/dh.c:217 [inline]
  __keyctl_dh_compute+0x1184/0x1bc0 security/keys/dh.c:389
  compat_keyctl_dh_compute+0x2c8/0x3e0 security/keys/compat_dh.c:39
  __do_compat_sys_keyctl security/keys/compat.c:136 [inline]
  __se_compat_sys_keyctl security/keys/compat.c:59 [inline]
  __ia32_compat_sys_keyctl+0x137/0x3b0 security/keys/compat.c:59
  do_syscall_32_irqs_on arch/x86/entry/common.c:323 [inline]
  do_fast_syscall_32+0x345/0xf9b arch/x86/entry/common.c:394
  entry_SYSENTER_compat+0x70/0x7f arch/x86/entry/entry_64_compat.S:139
RIP: 0023:0xf7faacb9
Code: 55 08 8b 88 64 cd ff ff 8b 98 68 cd ff ff 89 c8 85 d2 74 02 89 0a 5b  
5d c3 8b 04 24 c3 8b 1c 24 c3 51 52 55 89 e5 0f 34 cd 80 <5d> 5a 59 c3 90  
90 90 90 eb 0d 90 90 90 90 90 90 90 90 90 90 90 90
RSP: 002b:00000000ffab4bcc EFLAGS: 00000282 ORIG_RAX: 0000000000000120
RAX: ffffffffffffffda RBX: 0000000000000017 RCX: 0000000020000100
RDX: 0000000020a53ffb RSI: 0000000000000005 RDI: 0000000020c61fc8
RBP: 0000000000000000 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000296 R12: 0000000000000000
R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000

Allocated by task 4822:
  save_stack+0x43/0xd0 mm/kasan/kasan.c:448
  set_track mm/kasan/kasan.c:460 [inline]
  kasan_kmalloc+0xc4/0xe0 mm/kasan/kasan.c:553
  __do_kmalloc mm/slab.c:3718 [inline]
  __kmalloc+0x14e/0x760 mm/slab.c:3727
  kmalloc include/linux/slab.h:518 [inline]
  keyctl_dh_compute_kdf security/keys/dh.c:211 [inline]
  __keyctl_dh_compute+0xfe9/0x1bc0 security/keys/dh.c:389
  compat_keyctl_dh_compute+0x2c8/0x3e0 security/keys/compat_dh.c:39
  __do_compat_sys_keyctl security/keys/compat.c:136 [inline]
  __se_compat_sys_keyctl security/keys/compat.c:59 [inline]
  __ia32_compat_sys_keyctl+0x137/0x3b0 security/keys/compat.c:59
  do_syscall_32_irqs_on arch/x86/entry/common.c:323 [inline]
  do_fast_syscall_32+0x345/0xf9b arch/x86/entry/common.c:394
  entry_SYSENTER_compat+0x70/0x7f arch/x86/entry/entry_64_compat.S:139

Freed by task 3199:
  save_stack+0x43/0xd0 mm/kasan/kasan.c:448
  set_track mm/kasan/kasan.c:460 [inline]
  __kasan_slab_free+0x11a/0x170 mm/kasan/kasan.c:521
  kasan_slab_free+0xe/0x10 mm/kasan/kasan.c:528
  __cache_free mm/slab.c:3498 [inline]
  kfree+0xd9/0x260 mm/slab.c:3813
  load_elf_binary+0x463e/0x5610 fs/binfmt_elf.c:1108
  search_binary_handler+0x17d/0x570 fs/exec.c:1653
  exec_binprm fs/exec.c:1695 [inline]
  __do_execve_file.isra.34+0x16fe/0x2610 fs/exec.c:1819
  do_execveat_common fs/exec.c:1865 [inline]
  do_execve fs/exec.c:1882 [inline]
  __do_sys_execve fs/exec.c:1963 [inline]
  __se_sys_execve fs/exec.c:1958 [inline]
  __x64_sys_execve+0x8f/0xc0 fs/exec.c:1958
  do_syscall_64+0x1b1/0x800 arch/x86/entry/common.c:287
  entry_SYSCALL_64_after_hwframe+0x49/0xbe

The buggy address belongs to the object at ffff8801d0fae500
  which belongs to the cache kmalloc-32 of size 32
The buggy address is located 24 bytes inside of
  32-byte region [ffff8801d0fae500, ffff8801d0fae520)
The buggy address belongs to the page:
page:ffffea000743eb80 count:1 mapcount:0 mapping:ffff8801d0fae000  
index:0xffff8801d0faefc1
flags: 0x2fffc0000000100(slab)
raw: 02fffc0000000100 ffff8801d0fae000 ffff8801d0faefc1 0000000100000023
raw: ffffea00074171a0 ffffea000749e220 ffff8801da8001c0 0000000000000000
page dumped because: kasan: bad access detected

Memory state around the buggy address:
  ffff8801d0fae400: fb fb fb fb fc fc fc fc fb fb fb fb fc fc fc fc
  ffff8801d0fae480: fb fb fb fb fc fc fc fc fb fb fb fb fc fc fc fc
> ffff8801d0fae500: 00 00 00 fc fc fc fc fc fb fb fb fb fc fc fc fc
                             ^
  ffff8801d0fae580: 00 fc fc fc fc fc fc fc fb fb fb fb fc fc fc fc
  ffff8801d0fae600: fb fb fb fb fc fc fc fc fb fb fb fb fc fc fc fc
==================================================================
