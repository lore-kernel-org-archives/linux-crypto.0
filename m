From: Tim Chen <tim.c.chen@linux.intel.com>
Subject: Re: crypto: NULL deref in sha512_mb_mgr_get_comp_job_avx2
Date: Tue, 31 Jan 2017 10:51:29 -0800
Message-ID: <1485888689.2833.44.camel@linux.intel.com>
References: <CACT4Y+Z6_x2smshuSgQx0wA+g0H+5dJsF23UqYb9Z_WkDUvwcw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Cc: syzkaller <syzkaller@googlegroups.com>
To: Dmitry Vyukov <dvyukov@google.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        David Miller <davem@davemloft.net>,
        linux-crypto@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        megha.dey@linux.intel.com, fenghua.yu@intel.com
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:2261 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751787AbdAaSve (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 31 Jan 2017 13:51:34 -0500
In-Reply-To: <CACT4Y+Z6_x2smshuSgQx0wA+g0H+5dJsF23UqYb9Z_WkDUvwcw@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, 2017-01-31 at 14:16 +0100, Dmitry Vyukov wrote:
> Hello,
> 
> I am getting the following reports with low frequency while running
> syzkaller fuzzer. Unfortunately they are not reproducible and happen
> in a background thread, so it is difficult to extract any context on
> my side. I see only few such crashes per week, so most likely it is
> some hard to trigger data race. The following reports are from mmotm
> tree, commits 00e20cfc2bf04a0cbe1f5405f61c8426f43eee84 and
> fff7e71eac7788904753136f09bcad7471f7799e. Any ideas as to how this can
> happen?

Wonder if there is a race between the flusher thread that flush out
existing jobs if we don't have incoming jobs for a while and computation
via mcryptd.  Maybe the flusher fires at the same time when there is
a new job arriving.

Let Megha and I think a bit about it to come up with a patch to see
if that's the case.

Tim

> 
> BUG: unable to handle kernel NULL pointer dereference at 0000000000000060
> IP: [<ffffffff813fc09e>] sha512_mb_mgr_get_comp_job_avx2+0x6e/0xee
> arch/x86/crypto/sha512-mb/sha512_mb_mgr_flush_avx2.S:251
> PGD 1d2395067 [  220.874864] PUD 1d2860067
> Oops: 0002 [#1] SMP KASAN
> Dumping ftrace buffer:
>    (ftrace buffer empty)
> Modules linked in:
> CPU: 0 PID: 516 Comm: kworker/0:1 Not tainted 4.9.0 #4
> Hardware name: Google Google Compute Engine/Google Compute Engine,
> BIOS Google 01/01/2011
> Workqueue: crypto mcryptd_queue_worker
> task: ffff8801d9f346c0 task.stack: ffff8801d9f08000
> RIP: 0010:[<ffffffff813fc09e>]  [<ffffffff813fc09e>]
> sha512_mb_mgr_get_comp_job_avx2+0x6e/0xee
> arch/x86/crypto/sha512-mb/sha512_mb_mgr_flush_avx2.S:251
> RSP: 0018:ffff8801d9f0eef8  EFLAGS: 00010202
> RAX: 0000000000000000 RBX: ffff8801d7db1190 RCX: 0000000000000006
> RDX: 0000000000000001 RSI: ffff8801d9f34ee8 RDI: ffff8801d7db1040
> RBP: ffff8801d9f0f258 R08: 0000000100000000 R09: 0000000000000001
> R10: 0000000000000002 R11: 0000000000000003 R12: ffff8801d9f0f230
> R13: ffff8801c8bbc4e0 R14: ffff8801c8bbc530 R15: ffff8801d9f0ef70
> FS:  0000000000000000(0000) GS:ffff8801dc000000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 0000000000000060 CR3: 00000001cc15a000 CR4: 00000000001406f0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> Stack:
>  ffff8801d7db1040 ffffffff813fa207 dffffc0000000000 ffffe8ffffc0f238
>  0000000000000002 1ffff1003b3e1dea ffffe8ffffc0f218 ffff8801d9f0f190
>  0000000000000282 ffffe8ffffc0f140 ffffe8ffffc0f220 0000000041b58ab3
> Call Trace:
>  [<ffffffff813fb407>] sha512_mb_update+0x2f7/0x4e0
> arch/x86/crypto/sha512-mb/sha512_mb.c:588
>  [<ffffffff8219d4ad>] crypto_ahash_update include/crypto/hash.h:512 [inline]
>  [<ffffffff8219d4ad>] ahash_mcryptd_update crypto/mcryptd.c:627 [inline]
>  [<ffffffff8219d4ad>] mcryptd_hash_update+0xcd/0x1c0 crypto/mcryptd.c:373
>  [<ffffffff8219c99f>] mcryptd_queue_worker+0xff/0x6a0 crypto/mcryptd.c:181
>  [<ffffffff81492960>] process_one_work+0xbd0/0x1c10 kernel/workqueue.c:2096
>  [<ffffffff81493bc3>] worker_thread+0x223/0x1990 kernel/workqueue.c:2230
>  [<ffffffff814abb33>] kthread+0x323/0x3e0 kernel/kthread.c:209
>  [<ffffffff8436fbaa>] ret_from_fork+0x2a/0x40 arch/x86/entry/entry_64.S:433
> Code: 49 0f 42 d3 48 f7 c2 f0 ff ff ff 0f 85 9a 00 00 00 48 83 e2 0f
> 48 6b da 08 48 8d 9c 1f 48 01 00 00 48 8b 03 48 c7 03 00 00 00 00 <c7>
> 40 60 02 00 00 00 48 8b 9f 40 01 00 00 48 c1 e3 08 48 09 d3
> RIP  [<ffffffff813fc09e>] sha512_mb_mgr_get_comp_job_avx2+0x6e/0xee
> arch/x86/crypto/sha512-mb/sha512_mb_mgr_flush_avx2.S:251
>  RSP <ffff8801d9f0eef8>
> CR2: 0000000000000060
> ---[ end trace 139fd4cda5dfe2c4 ]---
> 
> BUG: unable to handle kernel NULL pointer dereference at 0000000000000060
> IP: [<ffffffff813fc09e>] sha512_mb_mgr_get_comp_job_avx2+0x6e/0xee
> arch/x86/crypto/sha512-mb/sha512_mb_mgr_flush_avx2.S:251
> PGD 1c68ad067 [  624.973638] PUD 1d485a067
> Oops: 0002 [#1] SMP KASAN
> Dumping ftrace buffer:
>    (ftrace buffer empty)
> Modules linked in:
> CPU: 0 PID: 517 Comm: kworker/0:1 Not tainted 4.9.0 #3
> Hardware name: Google Google Compute Engine/Google Compute Engine,
> BIOS Google 01/01/2011
> Workqueue: crypto mcryptd_queue_worker
> task: ffff8801d9e64700 task.stack: ffff8801d9838000
> RIP: 0010:[<ffffffff813fc09e>]  [<ffffffff813fc09e>]
> sha512_mb_mgr_get_comp_job_avx2+0x6e/0xee
> arch/x86/crypto/sha512-mb/sha512_mb_mgr_flush_avx2.S:251
> RSP: 0018:ffff8801d983eef8  EFLAGS: 00010202
> RAX: 0000000000000000 RBX: ffff8801d7d96950 RCX: 0000000000000006
> RDX: 0000000000000001 RSI: ffff8801d9e64f28 RDI: ffff8801d7d96800
> RBP: ffff8801d983f258 R08: 0000000100000000 R09: 0000000000000001
> R10: 0000000000000002 R11: 0000000000000003 R12: ffff8801d983f230
> R13: ffff8801b67f5720 R14: ffff8801b67f5770 R15: ffff8801d983ef70
> FS:  0000000000000000(0000) GS:ffff8801dc000000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 0000000000000060 CR3: 00000001cee58000 CR4: 00000000001406f0
> Stack:
>  ffff8801d7d96800 ffffffff813fa207 dffffc0000000000 ffffe8ffffc0f238
>  0000000000000002 1ffff1003b307dea ffffe8ffffc0f218 ffff8801d983f190
>  0000000000000282 ffffe8ffffc0f140 ffffe8ffffc0f220 0000000041b58ab3
> Call Trace:
>  [<ffffffff813fb407>] sha512_mb_update+0x2f7/0x4e0
> arch/x86/crypto/sha512-mb/sha512_mb.c:588
>  [<ffffffff8219cdad>] crypto_ahash_update include/crypto/hash.h:512 [inline]
>  [<ffffffff8219cdad>] ahash_mcryptd_update crypto/mcryptd.c:627 [inline]
>  [<ffffffff8219cdad>] mcryptd_hash_update+0xcd/0x1c0 crypto/mcryptd.c:373
>  [<ffffffff8219c29f>] mcryptd_queue_worker+0xff/0x6a0 crypto/mcryptd.c:181
>  [<ffffffff81492960>] process_one_work+0xbd0/0x1c10 kernel/workqueue.c:2096
>  [<ffffffff81493bc3>] worker_thread+0x223/0x1990 kernel/workqueue.c:2230
>  [<ffffffff814abb33>] kthread+0x323/0x3e0 kernel/kthread.c:209
>  [<ffffffff8436fbea>] ret_from_fork+0x2a/0x40 arch/x86/entry/entry_64.S:433
> Code: 49 0f 42 d3 48 f7 c2 f0 ff ff ff 0f 85 9a 00 00 00 48 83 e2 0f
> 48 6b da 08 48 8d 9c 1f 48 01 00 00 48 8b 03 48 c7 03 00 00 00 00 <c7>
> 40 60 02 00 00 00 48 8b 9f 40 01 00 00 48 c1 e3 08 48 09 d3
> RIP  [<ffffffff813fc09e>] sha512_mb_mgr_get_comp_job_avx2+0x6e/0xee
> arch/x86/crypto/sha512-mb/sha512_mb_mgr_flush_avx2.S:251
>  RSP <ffff8801d983eef8>
> CR2: 0000000000000060
> ---[ end trace 76403e033556dcb7 ]---
> 
> BUG: unable to handle kernel NULL pointer dereference at 0000000000000060
> IP: [<ffffffff813fc09e>] sha512_mb_mgr_get_comp_job_avx2+0x6e/0xee
> arch/x86/crypto/sha512-mb/sha512_mb_mgr_flush_avx2.S:251
> PGD 1d6242067 [  226.248182] PUD 1d2093067
> Oops: 0002 [#1] SMP KASAN
> Dumping ftrace buffer:
>    (ftrace buffer empty)
> Modules linked in:
> CPU: 1 PID: 1788 Comm: kworker/1:2 Not tainted 4.9.0 #3
> Hardware name: Google Google Compute Engine/Google Compute Engine,
> BIOS Google 01/01/2011
> Workqueue: crypto mcryptd_queue_worker
> task: ffff8801cc3ee100 task.stack: ffff8801cd068000
> RIP: 0010:[<ffffffff813fc09e>]  [<ffffffff813fc09e>]
> sha512_mb_mgr_get_comp_job_avx2+0x6e/0xee
> arch/x86/crypto/sha512-mb/sha512_mb_mgr_flush_avx2.S:251
> RSP: 0018:ffff8801cd06eef8  EFLAGS: 00010202
> RAX: 0000000000000000 RBX: ffff8801d7dc3c10 RCX: 0000000000000006
> RDX: 0000000000000001 RSI: ffff8801cc3ee928 RDI: ffff8801d7dc3ac0
> RBP: ffff8801cd06f258 R08: 0000000100000000 R09: 0000000000000001
> R10: 0000000000000002 R11: 0000000000000003 R12: ffff8801cd06f230
> R13: ffff8801c6eb9aa0 R14: ffff8801c6eb9af0 R15: ffff8801cd06ef70
> FS:  0000000000000000(0000) GS:ffff8801dc100000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 0000000000000060 CR3: 00000001d6201000 CR4: 00000000001406e0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> Stack:
>  ffff8801d7dc3ac0 ffffffff813fa207 dffffc0000000000 ffffe8ffffd0f238
>  0000000000000002 1ffff10039a0ddea ffffe8ffffd0f218 ffff8801cd06f190
>  0000000000000282 ffffe8ffffd0f140 ffffe8ffffd0f220 0000000041b58ab3
> Call Trace:
>  [<ffffffff813fb407>] sha512_mb_update+0x2f7/0x4e0
> arch/x86/crypto/sha512-mb/sha512_mb.c:588
>  [<ffffffff8219cdad>] crypto_ahash_update include/crypto/hash.h:512 [inline]
>  [<ffffffff8219cdad>] ahash_mcryptd_update crypto/mcryptd.c:627 [inline]
>  [<ffffffff8219cdad>] mcryptd_hash_update+0xcd/0x1c0 crypto/mcryptd.c:373
>  [<ffffffff8219c29f>] mcryptd_queue_worker+0xff/0x6a0 crypto/mcryptd.c:181
>  [<ffffffff81492960>] process_one_work+0xbd0/0x1c10 kernel/workqueue.c:2096
>  [<ffffffff81493bc3>] worker_thread+0x223/0x1990 kernel/workqueue.c:2230
>  [<ffffffff814abb33>] kthread+0x323/0x3e0 kernel/kthread.c:209
>  [<ffffffff8436fbea>] ret_from_fork+0x2a/0x40 arch/x86/entry/entry_64.S:433
> Code: 49 0f 42 d3 48 f7 c2 f0 ff ff ff 0f 85 9a 00 00 00 48 83 e2 0f
> 48 6b da 08 48 8d 9c 1f 48 01 00 00 48 8b 03 48 c7 03 00 00 00 00 <c7>
> 40 60 02 00 00 00 48 8b 9f 40 01 00 00 48 c1 e3 08 48 09 d3
> RIP  [<ffffffff813fc09e>] sha512_mb_mgr_get_comp_job_avx2+0x6e/0xee
> arch/x86/crypto/sha512-mb/sha512_mb_mgr_flush_avx2.S:251
>  RSP <ffff8801cd06eef8>
> CR2: 0000000000000060
> ---[ end trace 47d3302a6c62cfbc ]---
> 
> BUG: unable to handle kernel NULL pointer dereference at 0000000000000060
> IP: [<ffffffff813fc09e>] sha512_mb_mgr_get_comp_job_avx2+0x6e/0xee
> arch/x86/crypto/sha512-mb/sha512_mb_mgr_flush_avx2.S:251
> PGD 1ccad4067 [   32.785777] PUD 1cb96c067
> Oops: 0002 [#1] SMP KASAN
> Dumping ftrace buffer:
>    (ftrace buffer empty)
> Modules linked in:
> CPU: 1 PID: 3231 Comm: kworker/1:2 Not tainted 4.9.0 #3
> Hardware name: Google Google Compute Engine/Google Compute Engine,
> BIOS Google 01/01/2011
> Workqueue: crypto mcryptd_queue_worker
> task: ffff8801cf472700 task.stack: ffff8801ce848000
> RIP: 0010:[<ffffffff813fc09e>]  [<ffffffff813fc09e>]
> sha512_mb_mgr_get_comp_job_avx2+0x6e/0xee
> arch/x86/crypto/sha512-mb/sha512_mb_mgr_flush_avx2.S:251
> RSP: 0018:ffff8801ce84eef8  EFLAGS: 00010202
> RAX: 0000000000000000 RBX: ffff8801d7c82950 RCX: 0000000000000006
> RDX: 0000000000000001 RSI: ffff8801cf472f28 RDI: ffff8801d7c82800
> RBP: ffff8801ce84f258 R08: 0000000100000000 R09: 0000000000000001
> R10: 0000000000000002 R11: 0000000000000003 R12: ffff8801ce84f230
> R13: ffff8801c970e760 R14: ffff8801c970e7b0 R15: ffff8801ce84ef70
> FS:  0000000000000000(0000) GS:ffff8801dc100000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 0000000000000060 CR3: 00000001ca654000 CR4: 00000000001406e0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> Stack:
>  ffff8801d7c82800 ffffffff813fa207 dffffc0000000000 ffffe8ffffd0f238
>  0000000000000002 1ffff10039d09dea ffffe8ffffd0f218 ffff8801ce84f190
>  0000000000000282 ffffe8ffffd0f140 ffffe8ffffd0f220 0000000041b58ab3
> Call Trace:
>  [<ffffffff813fb407>] sha512_mb_update+0x2f7/0x4e0
> arch/x86/crypto/sha512-mb/sha512_mb.c:588
>  [<ffffffff8219cdad>] crypto_ahash_update include/crypto/hash.h:512 [inline]
>  [<ffffffff8219cdad>] ahash_mcryptd_update crypto/mcryptd.c:627 [inline]
>  [<ffffffff8219cdad>] mcryptd_hash_update+0xcd/0x1c0 crypto/mcryptd.c:373
>  [<ffffffff8219c29f>] mcryptd_queue_worker+0xff/0x6a0 crypto/mcryptd.c:181
>  [<ffffffff81492960>] process_one_work+0xbd0/0x1c10 kernel/workqueue.c:2096
>  [<ffffffff81493bc3>] worker_thread+0x223/0x1990 kernel/workqueue.c:2230
>  [<ffffffff814abb33>] kthread+0x323/0x3e0 kernel/kthread.c:209
>  [<ffffffff8436fbea>] ret_from_fork+0x2a/0x40 arch/x86/entry/entry_64.S:433
> Code: 49 0f 42 d3 48 f7 c2 f0 ff ff ff 0f 85 9a 00 00 00 48 83 e2 0f
> 48 6b da 08 48 8d 9c 1f 48 01 00 00 48 8b 03 48 c7 03 00 00 00 00 <c7>
> 40 60 02 00 00 00 48 8b 9f 40 01 00 00 48 c1 e3 08 48 09 d3
> RIP  [<ffffffff813fc09e>] sha512_mb_mgr_get_comp_job_avx2+0x6e/0xee
> arch/x86/crypto/sha512-mb/sha512_mb_mgr_flush_avx2.S:251
>  RSP <ffff8801ce84eef8>
> CR2: 0000000000000060
> ---[ end trace 3af8184eabd21203 ]---
