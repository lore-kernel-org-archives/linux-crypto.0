From: Eric Biggers <ebiggers3@gmail.com>
Subject: Re: KASAN: slab-out-of-bounds Write in sha256_finup
Date: Thu, 7 Jun 2018 12:17:04 -0700
Message-ID: <20180607191704.GA29665@gmail.com>
References: <0000000000009913f4056e0cf508@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: davem@davemloft.net, herbert@gondor.apana.org.au, hpa@zytor.com,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        mingo@redhat.com, syzkaller-bugs@googlegroups.com,
        tglx@linutronix.de, x86@kernel.org
To: syzbot <syzbot+29d17b7898b41ee120a5@syzkaller.appspotmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <0000000000009913f4056e0cf508@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Thu, Jun 07, 2018 at 06:07:02AM -0700, syzbot wrote:
> Hello,
> 
> syzbot found the following crash on:
> 
> HEAD commit:    1c8c5a9d38f6 Merge git://git.kernel.org/pub/scm/linux/kern..
> git tree:       upstream
> console output: https://syzkaller.appspot.com/x/log.txt?x=11289b9f800000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=2e1a31e8576e013a
> dashboard link: https://syzkaller.appspot.com/bug?extid=29d17b7898b41ee120a5
> compiler:       gcc (GCC) 8.0.1 20180413 (experimental)
> syzkaller repro:https://syzkaller.appspot.com/x/repro.syz?x=146fbb9f800000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=119de79f800000
> 
> IMPORTANT: if you fix the bug, please add the following tag to the commit:
> Reported-by: syzbot+29d17b7898b41ee120a5@syzkaller.appspotmail.com
> 
> random: sshd: uninitialized urandom read (32 bytes read)
> random: sshd: uninitialized urandom read (32 bytes read)
> random: sshd: uninitialized urandom read (32 bytes read)
> random: sshd: uninitialized urandom read (32 bytes read)
> ==================================================================
> BUG: KASAN: slab-out-of-bounds in put_unaligned_be32
> include/linux/unaligned/access_ok.h:60 [inline]
> BUG: KASAN: slab-out-of-bounds in sha256_base_finish
> include/crypto/sha256_base.h:124 [inline]
> BUG: KASAN: slab-out-of-bounds in sha256_finup+0x4bf/0x540
> arch/x86/crypto/sha256_ssse3_glue.c:80
> Write of size 4 at addr ffff8801b39b2ca0 by task syz-executor364/4468
> 
> CPU: 0 PID: 4468 Comm: syz-executor364 Not tainted 4.17.0+ #88
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS
> Google 01/01/2011
> Call Trace:
>  __dump_stack lib/dump_stack.c:77 [inline]
>  dump_stack+0x1b9/0x294 lib/dump_stack.c:113
>  print_address_description+0x6c/0x20b mm/kasan/report.c:256
>  kasan_report_error mm/kasan/report.c:354 [inline]
>  kasan_report.cold.7+0x242/0x2fe mm/kasan/report.c:412
>  __asan_report_store4_noabort+0x17/0x20 mm/kasan/report.c:437
>  put_unaligned_be32 include/linux/unaligned/access_ok.h:60 [inline]
>  sha256_base_finish include/crypto/sha256_base.h:124 [inline]
>  sha256_finup+0x4bf/0x540 arch/x86/crypto/sha256_ssse3_glue.c:80
>  sha256_avx_finup arch/x86/crypto/sha256_ssse3_glue.c:161 [inline]
>  sha256_avx_final+0x28/0x30 arch/x86/crypto/sha256_ssse3_glue.c:166
>  crypto_shash_final+0x104/0x260 crypto/shash.c:152
>  kdf_ctr security/keys/dh.c:186 [inline]
>  keyctl_dh_compute_kdf security/keys/dh.c:217 [inline]
>  __keyctl_dh_compute+0x1184/0x1bc0 security/keys/dh.c:389
>  keyctl_dh_compute+0xb9/0x100 security/keys/dh.c:425
>  __do_sys_keyctl security/keys/keyctl.c:1741 [inline]
>  __se_sys_keyctl security/keys/keyctl.c:1637 [inline]
>  __x64_sys_keyctl+0x12a/0x3b0 security/keys/keyctl.c:1637
>  do_syscall_64+0x1b1/0x800 arch/x86/entry/common.c:287
>  entry_SYSCALL_64_after_hwframe+0x49/0xbe
> RIP: 0033:0x440019
> Code: 18 89 d0 c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 00 48 89 f8 48 89 f7
> 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff
> 0f 83 6b 45 00 00 c3 66 2e 0f 1f 84 00 00 00 00
> RSP: 002b:00007ffcb5a0db48 EFLAGS: 00000217 ORIG_RAX: 00000000000000fa
> RAX: ffffffffffffffda RBX: 00000000004002c8 RCX: 0000000000440019
> RDX: 0000000020a53ffb RSI: 0000000020000100 RDI: 0000000000000017
> RBP: 00000000006ca018 R08: 0000000020c61fc8 R09: 00000000004002c8
> R10: 0000000000000005 R11: 0000000000000217 R12: 0000000000401940
> R13: 00000000004019d0 R14: 0000000000000000 R15: 0000000000000000
> 
> Allocated by task 4468:
>  save_stack+0x43/0xd0 mm/kasan/kasan.c:448
>  set_track mm/kasan/kasan.c:460 [inline]
>  kasan_kmalloc+0xc4/0xe0 mm/kasan/kasan.c:553
>  __do_kmalloc mm/slab.c:3718 [inline]
>  __kmalloc+0x14e/0x760 mm/slab.c:3727
>  kmalloc include/linux/slab.h:518 [inline]
>  keyctl_dh_compute_kdf security/keys/dh.c:211 [inline]
>  __keyctl_dh_compute+0xfe9/0x1bc0 security/keys/dh.c:389
>  keyctl_dh_compute+0xb9/0x100 security/keys/dh.c:425
>  __do_sys_keyctl security/keys/keyctl.c:1741 [inline]
>  __se_sys_keyctl security/keys/keyctl.c:1637 [inline]
>  __x64_sys_keyctl+0x12a/0x3b0 security/keys/keyctl.c:1637
>  do_syscall_64+0x1b1/0x800 arch/x86/entry/common.c:287
>  entry_SYSCALL_64_after_hwframe+0x49/0xbe
> 
> Freed by task 2842:
>  save_stack+0x43/0xd0 mm/kasan/kasan.c:448
>  set_track mm/kasan/kasan.c:460 [inline]
>  __kasan_slab_free+0x11a/0x170 mm/kasan/kasan.c:521
>  kasan_slab_free+0xe/0x10 mm/kasan/kasan.c:528
>  __cache_free mm/slab.c:3498 [inline]
>  kfree+0xd9/0x260 mm/slab.c:3813
>  single_release+0x8f/0xb0 fs/seq_file.c:609
>  __fput+0x353/0x890 fs/file_table.c:209
>  ____fput+0x15/0x20 fs/file_table.c:243
>  task_work_run+0x1e4/0x290 kernel/task_work.c:113
>  tracehook_notify_resume include/linux/tracehook.h:192 [inline]
>  exit_to_usermode_loop+0x2bd/0x310 arch/x86/entry/common.c:166
>  prepare_exit_to_usermode arch/x86/entry/common.c:196 [inline]
>  syscall_return_slowpath arch/x86/entry/common.c:265 [inline]
>  do_syscall_64+0x6ac/0x800 arch/x86/entry/common.c:290
>  entry_SYSCALL_64_after_hwframe+0x49/0xbe
> 
> The buggy address belongs to the object at ffff8801b39b2c80
>  which belongs to the cache kmalloc-32 of size 32
> The buggy address is located 0 bytes to the right of
>  32-byte region [ffff8801b39b2c80, ffff8801b39b2ca0)
> The buggy address belongs to the page:
> page:ffffea0006ce6c80 count:1 mapcount:0 mapping:ffff8801b39b2000
> index:0xffff8801b39b2fc1
> flags: 0x2fffc0000000100(slab)
> raw: 02fffc0000000100 ffff8801b39b2000 ffff8801b39b2fc1 0000000100000039
> raw: ffffea00075c03a0 ffffea000764c620 ffff8801da8001c0 0000000000000000
> page dumped because: kasan: bad access detected
> 
> Memory state around the buggy address:
>  ffff8801b39b2b80: fb fb fb fb fc fc fc fc fb fb fb fb fc fc fc fc
>  ffff8801b39b2c00: fb fb fb fb fc fc fc fc fb fb fb fb fc fc fc fc
> > ffff8801b39b2c80: 00 00 00 00 fc fc fc fc fb fb fb fb fc fc fc fc
>                                ^
>  ffff8801b39b2d00: fb fb fb fb fc fc fc fc fb fb fb fb fc fc fc fc
>  ffff8801b39b2d80: fb fb fb fb fc fc fc fc fb fb fb fb fc fc fc fc
> ==================================================================
> 
> 
> ---
> This bug is generated by a bot. It may contain errors.
> See https://goo.gl/tpsmEJ for more information about syzbot.
> syzbot engineers can be reached at syzkaller@googlegroups.com.
> 
> syzbot will keep track of this bug report. See:
> https://goo.gl/tpsmEJ#bug-status-tracking for how to communicate with
> syzbot.
> syzbot can test patches for this bug, for details see:
> https://goo.gl/tpsmEJ#testing-patches
> 
> -- 
> You received this message because you are subscribed to the Google Groups "syzkaller-bugs" group.
> To unsubscribe from this group and stop receiving emails from it, send an email to syzkaller-bugs+unsubscribe@googlegroups.com.
> To view this discussion on the web visit https://groups.google.com/d/msgid/syzkaller-bugs/0000000000009913f4056e0cf508%40google.com.
> For more options, visit https://groups.google.com/d/optout.

Duplicate:

#syz dup: KASAN: slab-out-of-bounds Write in sha1_finup

Tentative fix is "[PATCH] dh key: fix rounding up KDF output length".
