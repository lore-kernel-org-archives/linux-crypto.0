From: Eric Biggers <ebiggers3@gmail.com>
Subject: Re: KASAN: slab-out-of-bounds Write in sha3_update (2)
Date: Fri, 22 Dec 2017 11:22:38 -0600
Message-ID: <20171222172238.GB588@zzz.localdomain>
References: <94eb2c0d010ad4a7f40560efd650@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: davem@davemloft.net, herbert@gondor.apana.org.au,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        keyrings@vger.kernel.org, syzkaller-bugs@googlegroups.com
To: syzbot
        <bot+80f661b525da04e7baaef60ee883f18be36f3942@syzkaller.appspotmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-it0-f67.google.com ([209.85.214.67]:38886 "EHLO
        mail-it0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756079AbdLVRWm (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 22 Dec 2017 12:22:42 -0500
Content-Disposition: inline
In-Reply-To: <94eb2c0d010ad4a7f40560efd650@google.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

[+Cc keyrings@vger.kernel.org]

On Fri, Dec 22, 2017 at 07:55:01AM -0800, syzbot wrote:
> Hello,
> 
> syzkaller hit the following crash on
> 9035a8961b504d0997369509ab8c6b1f0a4ee33d
> git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/master
> compiler: gcc (GCC) 7.1.1 20170620
> .config is attached
> Raw console output is attached.
> C reproducer is attached
> syzkaller reproducer is attached. See https://goo.gl/kgGztJ
> for information about syzkaller reproducers
> 
> 
> audit: type=1400 audit(1513919078.260:7): avc:  denied  { map } for
> pid=3152 comm="syzkaller717822" path="/root/syzkaller717822551" dev="sda1"
> ino=16481 scontext=unconfined_u:system_r:insmod_t:s0-s0:c0.c1023
> tcontext=unconfined_u:object_r:user_home_t:s0 tclass=file permissive=1
> ==================================================================
> BUG: KASAN: slab-out-of-bounds in memcpy include/linux/string.h:344 [inline]
> BUG: KASAN: slab-out-of-bounds in sha3_update+0xdf/0x2e0
> crypto/sha3_generic.c:161
> Write of size 192 at addr ffff8801cf0e3b3c by task syzkaller717822/3152
> 
> CPU: 0 PID: 3152 Comm: syzkaller717822 Not tainted 4.15.0-rc4+ #232
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS
> Google 01/01/2011
> Call Trace:
>  __dump_stack lib/dump_stack.c:17 [inline]
>  dump_stack+0x194/0x257 lib/dump_stack.c:53
>  print_address_description+0x73/0x250 mm/kasan/report.c:252
>  kasan_report_error mm/kasan/report.c:351 [inline]
>  kasan_report+0x25b/0x340 mm/kasan/report.c:409
>  check_memory_region_inline mm/kasan/kasan.c:260 [inline]
>  check_memory_region+0x137/0x190 mm/kasan/kasan.c:267
>  memcpy+0x37/0x50 mm/kasan/kasan.c:303
>  memcpy include/linux/string.h:344 [inline]
>  sha3_update+0xdf/0x2e0 crypto/sha3_generic.c:161
>  crypto_shash_update+0xda/0x240 crypto/shash.c:110
>  hmac_update+0x7e/0xa0 crypto/hmac.c:122
>  crypto_shash_update+0xda/0x240 crypto/shash.c:110
>  kdf_ctr security/keys/dh.c:181 [inline]
>  keyctl_dh_compute_kdf security/keys/dh.c:226 [inline]
>  __keyctl_dh_compute+0x160f/0x1990 security/keys/dh.c:398
>  keyctl_dh_compute+0xac/0xf3 security/keys/dh.c:434
>  SYSC_keyctl security/keys/keyctl.c:1741 [inline]
>  SyS_keyctl+0x72/0x2c0 security/keys/keyctl.c:1637
>  entry_SYSCALL_64_fastpath+0x1f/0x96
> RIP: 0033:0x43feb9
> RSP: 002b:00007ffd3aef51a8 EFLAGS: 00000217 ORIG_RAX: 00000000000000fa
> RAX: ffffffffffffffda RBX: 00000000004002c8 RCX: 000000000043feb9
> RDX: 0000000020c2cfff RSI: 00000000204c8ff4 RDI: 0000000000000017
> RBP: 00000000006ca018 R08: 00000000208e6fd4 R09: 0000000000000000
> R10: 0000000000000001 R11: 0000000000000217 R12: 0000000000401820
> R13: 00000000004018b0 R14: 0000000000000000 R15: 0000000000000000
> 
> Allocated by task 3152:
>  save_stack+0x43/0xd0 mm/kasan/kasan.c:447
>  set_track mm/kasan/kasan.c:459 [inline]
>  kasan_kmalloc+0xad/0xe0 mm/kasan/kasan.c:551
>  __do_kmalloc mm/slab.c:3708 [inline]
>  __kmalloc+0x162/0x760 mm/slab.c:3717
>  kmalloc include/linux/slab.h:504 [inline]
>  kdf_alloc security/keys/dh.c:111 [inline]
>  __keyctl_dh_compute+0x2b0/0x1990 security/keys/dh.c:288
>  keyctl_dh_compute+0xac/0xf3 security/keys/dh.c:434
>  SYSC_keyctl security/keys/keyctl.c:1741 [inline]
>  SyS_keyctl+0x72/0x2c0 security/keys/keyctl.c:1637
>  entry_SYSCALL_64_fastpath+0x1f/0x96
> 
> Freed by task 1637:
>  save_stack+0x43/0xd0 mm/kasan/kasan.c:447
>  set_track mm/kasan/kasan.c:459 [inline]
>  kasan_slab_free+0x71/0xc0 mm/kasan/kasan.c:524
>  __cache_free mm/slab.c:3488 [inline]
>  kfree+0xd6/0x260 mm/slab.c:3803
>  kernfs_fop_release+0x13f/0x180 fs/kernfs/file.c:783
>  __fput+0x327/0x7e0 fs/file_table.c:210
>  ____fput+0x15/0x20 fs/file_table.c:244
>  task_work_run+0x199/0x270 kernel/task_work.c:113
>  tracehook_notify_resume include/linux/tracehook.h:191 [inline]
>  exit_to_usermode_loop+0x296/0x310 arch/x86/entry/common.c:162
>  prepare_exit_to_usermode arch/x86/entry/common.c:195 [inline]
>  syscall_return_slowpath+0x490/0x550 arch/x86/entry/common.c:264
>  entry_SYSCALL_64_fastpath+0x94/0x96
> 

The problem is that KEYCTL_DH_COMPUTE allows the user to request and use any
hash algorithm as an unkeyed hash without checking whether it is in fact
unkeyed.

We could fix this by checking for !crypto_shash_alg_has_setkey() after
allocating the hash, but now I'd really like to solve this for all users by
having crypto_[as]hash_init() and crypto_[as]hash_digest() automatically return
-ENOKEY if a key is needed and one hasn't been set.  That would also have solved
the bug I fixed specifically for HMAC by "crypto: hmac - require that the
underlying hash algorithm is unkeyed".

Eric
