From: Eric Biggers <ebiggers3@gmail.com>
Subject: Re: BUG: unable to handle kernel NULL pointer dereference in
 sha512_mb_mgr_get_comp_job_avx2
Date: Mon, 12 Feb 2018 10:21:05 -0800
Message-ID: <20180212182105.GA193902@gmail.com>
References: <001a113ec900d65ea5055f70560f@google.com>
 <001a113fae28e4fe39055f757ab5@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: syzkaller-bugs@googlegroups.com, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org
To: syzbot
        <bot+5ac9d43b97a33f321ed58e24960e30defaef843f@syzkaller.appspotmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-io0-f194.google.com ([209.85.223.194]:46213 "EHLO
        mail-io0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751176AbeBLSVJ (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 12 Feb 2018 13:21:09 -0500
Content-Disposition: inline
In-Reply-To: <001a113fae28e4fe39055f757ab5@google.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Sun, Dec 03, 2017 at 12:31:01PM -0800, syzbot wrote:
> syzkaller has found reproducer for the following crash on
> 4131d5166185d0d75b5f1d4bf362a9e0bac05598
> git://git.cmpxchg.org/linux-mmots.git/master
> compiler: gcc (GCC) 7.1.1 20170620
> .config is attached
> Raw console output is attached.
> 
> syzkaller reproducer is attached. See https://goo.gl/kgGztJ
> for information about syzkaller reproducers
> 
> 
> BUG: unable to handle kernel NULL pointer dereference at 00000000c58b0b19
> IP: sha512_mb_mgr_get_comp_job_avx2+0x6e/0xee
> arch/x86/crypto/sha512-mb/sha512_mb_mgr_flush_avx2.S:251
> PGD 1cb562067 P4D 1cb562067 PUD 1cb563067 PMD 0
> Oops: 0002 [#1] SMP KASAN
> Dumping ftrace buffer:
>    (ftrace buffer empty)
> Modules linked in:
> CPU: 1 PID: 24 Comm: kworker/1:1 Not tainted 4.15.0-rc1-mm1+ #29
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS
> Google 01/01/2011
> Workqueue: crypto mcryptd_queue_worker
> task: 0000000018ff7174 task.stack: 000000004c6e7fb4
> RIP: 0010:sha512_mb_mgr_get_comp_job_avx2+0x6e/0xee
> arch/x86/crypto/sha512-mb/sha512_mb_mgr_flush_avx2.S:251
> RSP: 0018:ffff8801d9d171b8 EFLAGS: 00010002
> RAX: 0000000000000000 RBX: ffff8801d5aa38d0 RCX: 0000000000000000
> RDX: 0000000000000001 RSI: 0000000000000000 RDI: ffff8801d5aa3780
> RBP: ffff8801d9d171e0 R08: 0000000100000000 R09: 0000000000000001
> R10: 0000000000000002 R11: 0000000000000003 R12: ffff8801d5aa3780
> R13: 0000000000000282 R14: ffff8801cc115760 R15: ffffe8ffffd10630
> FS:  0000000000000000(0000) GS:ffff8801db500000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 0000000000000060 CR3: 00000001cb55f000 CR4: 00000000001406e0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> Call Trace:
>  sha_complete_job+0x276/0x830 arch/x86/crypto/sha512-mb/sha512_mb.c:510
>  sha512_mb_update+0x2f6/0x530 arch/x86/crypto/sha512-mb/sha512_mb.c:610
>  crypto_ahash_update include/crypto/hash.h:522 [inline]
>  ahash_mcryptd_update crypto/mcryptd.c:628 [inline]
>  mcryptd_hash_update+0xcd/0x1c0 crypto/mcryptd.c:374
>  mcryptd_queue_worker+0xfe/0x660 crypto/mcryptd.c:182
>  process_one_work+0xbfd/0x1bc0 kernel/workqueue.c:2113
>  worker_thread+0x223/0x1990 kernel/workqueue.c:2247
>  kthread+0x37a/0x440 kernel/kthread.c:238
>  ret_from_fork+0x24/0x30 arch/x86/entry/entry_64.S:517
> Code: 49 0f 42 d3 48 f7 c2 f0 ff ff ff 0f 85 9a 00 00 00 48 83 e2 0f 48 6b
> da 08 48 8d 9c 1f 48 01 00 00 48 8b 03 48 c7 03 00 00 00 00 <c7> 40 60 02 00
> 00 00 48 8b 9f 40 01 00 00 48 c1 e3 08 48 09 d3
> RIP: sha512_mb_mgr_get_comp_job_avx2+0x6e/0xee
> arch/x86/crypto/sha512-mb/sha512_mb_mgr_flush_avx2.S:251 RSP:
> ffff8801d9d171b8
> CR2: 0000000000000060
> ---[ end trace 2003a6fbb2bb168e ]---
> Kernel panic - not syncing: Fatal exception
> Dumping ftrace buffer:
>    (ftrace buffer empty)
> Kernel Offset: disabled
> Rebooting in 86400 seconds..

Fixed by commit eff84b379089cd, so marking it fixed for syzbot:

#syz fix: crypto: sha512-mb - initialize pending lengths correctly

- Eric
