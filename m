From: Dmitry Vyukov <dvyukov@google.com>
Subject: Re: crypto: NULL deref in sha512_mb_mgr_get_comp_job_avx2
Date: Thu, 2 Feb 2017 11:58:17 +0100
Message-ID: <CACT4Y+bwD4ktMKVEkcmvJ_EuW834jAZbJfANxfyDKpmGXFxr4Q@mail.gmail.com>
References: <CACT4Y+Z6_x2smshuSgQx0wA+g0H+5dJsF23UqYb9Z_WkDUvwcw@mail.gmail.com>
 <20170201184502.GA11649@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
        David Miller <davem@davemloft.net>,
        linux-crypto@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        megha.dey@linux.intel.com, fenghua.yu@intel.com,
        syzkaller <syzkaller@googlegroups.com>
To: tim.c.chen@linux.intel.com
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-ua0-f171.google.com ([209.85.217.171]:34645 "EHLO
        mail-ua0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751020AbdBBK6i (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 2 Feb 2017 05:58:38 -0500
Received: by mail-ua0-f171.google.com with SMTP id 35so8514754uak.1
        for <linux-crypto@vger.kernel.org>; Thu, 02 Feb 2017 02:58:38 -0800 (PST)
In-Reply-To: <20170201184502.GA11649@linux.intel.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, Feb 1, 2017 at 7:45 PM, Tim Chen <tim.c.chen@linux.intel.com> wrote:
> On Tue, Jan 31, 2017 at 02:16:31PM +0100, Dmitry Vyukov wrote:
>> Hello,
>>
>> I am getting the following reports with low frequency while running
>> syzkaller fuzzer. Unfortunately they are not reproducible and happen
>> in a background thread, so it is difficult to extract any context on
>> my side. I see only few such crashes per week, so most likely it is
>> some hard to trigger data race. The following reports are from mmotm
>> tree, commits 00e20cfc2bf04a0cbe1f5405f61c8426f43eee84 and
>> fff7e71eac7788904753136f09bcad7471f7799e. Any ideas as to how this can
>> happen?
>>
>> BUG: unable to handle kernel NULL pointer dereference at 0000000000000060
>> IP: [<ffffffff813fc09e>] sha512_mb_mgr_get_comp_job_avx2+0x6e/0xee
>> arch/x86/crypto/sha512-mb/sha512_mb_mgr_flush_avx2.S:251
>> PGD 1d2395067 [  220.874864] PUD 1d2860067
>> Oops: 0002 [#1] SMP KASAN
>> Dumping ftrace buffer:
>>    (ftrace buffer empty)
>> Modules linked in:
>> CPU: 0 PID: 516 Comm: kworker/0:1 Not tainted 4.9.0 #4
>> Hardware name: Google Google Compute Engine/Google Compute Engine,
>> BIOS Google 01/01/2011
>> Workqueue: crypto mcryptd_queue_worker
>> task: ffff8801d9f346c0 task.stack: ffff8801d9f08000
>> RIP: 0010:[<ffffffff813fc09e>]  [<ffffffff813fc09e>]
>> sha512_mb_mgr_get_comp_job_avx2+0x6e/0xee
>> arch/x86/crypto/sha512-mb/sha512_mb_mgr_flush_avx2.S:251
>> RSP: 0018:ffff8801d9f0eef8  EFLAGS: 00010202
>> RAX: 0000000000000000 RBX: ffff8801d7db1190 RCX: 0000000000000006
>> RDX: 0000000000000001 RSI: ffff8801d9f34ee8 RDI: ffff8801d7db1040
>> RBP: ffff8801d9f0f258 R08: 0000000100000000 R09: 0000000000000001
>> R10: 0000000000000002 R11: 0000000000000003 R12: ffff8801d9f0f230
>> R13: ffff8801c8bbc4e0 R14: ffff8801c8bbc530 R15: ffff8801d9f0ef70
>> FS:  0000000000000000(0000) GS:ffff8801dc000000(0000) knlGS:0000000000000000
>> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>> CR2: 0000000000000060 CR3: 00000001cc15a000 CR4: 00000000001406f0
>> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
>> DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
>> Stack:
>>  ffff8801d7db1040 ffffffff813fa207 dffffc0000000000 ffffe8ffffc0f238
>>  0000000000000002 1ffff1003b3e1dea ffffe8ffffc0f218 ffff8801d9f0f190
>>  0000000000000282 ffffe8ffffc0f140 ffffe8ffffc0f220 0000000041b58ab3
>> Call Trace:
>>  [<ffffffff813fb407>] sha512_mb_update+0x2f7/0x4e0
>> arch/x86/crypto/sha512-mb/sha512_mb.c:588
>>  [<ffffffff8219d4ad>] crypto_ahash_update include/crypto/hash.h:512 [inline]
>>  [<ffffffff8219d4ad>] ahash_mcryptd_update crypto/mcryptd.c:627 [inline]
>>  [<ffffffff8219d4ad>] mcryptd_hash_update+0xcd/0x1c0 crypto/mcryptd.c:373
>>  [<ffffffff8219c99f>] mcryptd_queue_worker+0xff/0x6a0 crypto/mcryptd.c:181
>>  [<ffffffff81492960>] process_one_work+0xbd0/0x1c10 kernel/workqueue.c:2096
>>  [<ffffffff81493bc3>] worker_thread+0x223/0x1990 kernel/workqueue.c:2230
>>  [<ffffffff814abb33>] kthread+0x323/0x3e0 kernel/kthread.c:209
>>  [<ffffffff8436fbaa>] ret_from_fork+0x2a/0x40 arch/x86/entry/entry_64.S:433
>> Code: 49 0f 42 d3 48 f7 c2 f0 ff ff ff 0f 85 9a 00 00 00 48 83 e2 0f
>> 48 6b da 08 48 8d 9c 1f 48 01 00 00 48 8b 03 48 c7 03 00 00 00 00 <c7>
>> 40 60 02 00 00 00 48 8b 9f 40 01 00 00 48 c1 e3 08 48 09 d3
>> RIP  [<ffffffff813fc09e>] sha512_mb_mgr_get_comp_job_avx2+0x6e/0xee
>> arch/x86/crypto/sha512-mb/sha512_mb_mgr_flush_avx2.S:251
>>  RSP <ffff8801d9f0eef8>
>> CR2: 0000000000000060
>> ---[ end trace 139fd4cda5dfe2c4 ]---
>>
>
> Dmitry,
>
> One theory that Mehga and I have is that perhaps the flusher
> and regular computaion updates are stepping on each other.
> Can you try this patch and see if it helps?


No, for this one I can't. Sorry.
It happens with very low frequency and only one fuzzer that tests
mmotm tree. If/when this is committed, I can keep an eye on these
reports and notify if I still see them.
If you have a hypothesis as to how it happens, perhaps you could write
a test that provokes the crash and maybe add some sleeps to kernel
code or alter timeouts to increase probability.



> --->8---
>
> From: Tim Chen <tim.c.chen@linux.intel.com>
> Subject: [PATCH] crypto/sha512-mb: Protect sha512 mb ctx mgr access
> To: Herbert Xu <herbert@gondor.apana.org.au>, Dmitry Vyukov <dvyukov@google.com>
> Cc: Tim Chen <tim.c.chen@linux.intel.com>, David Miller <davem@davemloft.net>, linux-crypto@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, megha.dey@linux.intel.com, fenghua.yu@intel.com
>
> The flusher and regular multi-buffer computation via mcryptd may race with another.
> Add here a lock and turn off interrupt to to access multi-buffer
> computation state cstate->mgr before a round of computation. This should
> prevent the flusher code jumping in.
>
> Signed-off-by: Tim Chen <tim.c.chen@linux.intel.com>
> ---
>  arch/x86/crypto/sha512-mb/sha512_mb.c | 64 +++++++++++++++++++++++------------
>  1 file changed, 42 insertions(+), 22 deletions(-)
>
> diff --git a/arch/x86/crypto/sha512-mb/sha512_mb.c b/arch/x86/crypto/sha512-mb/sha512_mb.c
> index d210174..f3c1c21 100644
> --- a/arch/x86/crypto/sha512-mb/sha512_mb.c
> +++ b/arch/x86/crypto/sha512-mb/sha512_mb.c
> @@ -221,7 +221,7 @@ static struct sha512_hash_ctx *sha512_ctx_mgr_resubmit
>  }
>
>  static struct sha512_hash_ctx
> -               *sha512_ctx_mgr_get_comp_ctx(struct sha512_ctx_mgr *mgr)
> +               *sha512_ctx_mgr_get_comp_ctx(struct mcryptd_alg_cstate *cstate)
>  {
>         /*
>          * If get_comp_job returns NULL, there are no jobs complete.
> @@ -233,11 +233,17 @@ static struct sha512_hash_ctx
>          * Otherwise, all jobs currently being managed by the hash_ctx_mgr
>          * still need processing.
>          */
> +       struct sha512_ctx_mgr *mgr;
>         struct sha512_hash_ctx *ctx;
> +       unsigned long flags;
>
> +       mgr = cstate->mgr;
> +       spin_lock_irqsave(&cstate->work_lock, flags);
>         ctx = (struct sha512_hash_ctx *)
>                                 sha512_job_mgr_get_comp_job(&mgr->mgr);
> -       return sha512_ctx_mgr_resubmit(mgr, ctx);
> +       ctx = sha512_ctx_mgr_resubmit(mgr, ctx);
> +       spin_unlock_irqrestore(&cstate->work_lock, flags);
> +       return ctx;
>  }
>
>  static void sha512_ctx_mgr_init(struct sha512_ctx_mgr *mgr)
> @@ -246,12 +252,17 @@ static void sha512_ctx_mgr_init(struct sha512_ctx_mgr *mgr)
>  }
>
>  static struct sha512_hash_ctx
> -                       *sha512_ctx_mgr_submit(struct sha512_ctx_mgr *mgr,
> +                       *sha512_ctx_mgr_submit(struct mcryptd_alg_cstate *cstate,
>                                           struct sha512_hash_ctx *ctx,
>                                           const void *buffer,
>                                           uint32_t len,
>                                           int flags)
>  {
> +       struct sha512_ctx_mgr *mgr;
> +       unsigned long irqflags;
> +
> +       mgr = cstate->mgr;
> +       spin_lock_irqsave(&cstate->work_lock, irqflags);
>         if (flags & (~HASH_ENTIRE)) {
>                 /*
>                  * User should not pass anything other than FIRST, UPDATE, or
> @@ -351,20 +362,26 @@ static struct sha512_hash_ctx
>                 }
>         }
>
> -       return sha512_ctx_mgr_resubmit(mgr, ctx);
> +       ctx = sha512_ctx_mgr_resubmit(mgr, ctx);
> +       spin_unlock_irqrestore(&cstate->work_lock, irqflags);
> +       return ctx;
>  }
>
> -static struct sha512_hash_ctx *sha512_ctx_mgr_flush(struct sha512_ctx_mgr *mgr)
> +static struct sha512_hash_ctx *sha512_ctx_mgr_flush(struct mcryptd_alg_cstate *cstate)
>  {
> +       struct sha512_ctx_mgr *mgr;
>         struct sha512_hash_ctx *ctx;
> +       unsigned long flags;
>
> +       mgr = cstate->mgr;
> +       spin_lock_irqsave(&cstate->work_lock, flags);
>         while (1) {
>                 ctx = (struct sha512_hash_ctx *)
>                                         sha512_job_mgr_flush(&mgr->mgr);
>
>                 /* If flush returned 0, there are no more jobs in flight. */
>                 if (!ctx)
> -                       return NULL;
> +                       break;
>
>                 /*
>                  * If flush returned a job, resubmit the job to finish
> @@ -378,8 +395,10 @@ static struct sha512_hash_ctx *sha512_ctx_mgr_flush(struct sha512_ctx_mgr *mgr)
>                  * the sha512_ctx_mgr still need processing. Loop.
>                  */
>                 if (ctx)
> -                       return ctx;
> +                       break;
>         }
> +       spin_unlock_irqrestore(&cstate->work_lock, flags);
> +       return ctx;
>  }
>
>  static int sha512_mb_init(struct ahash_request *areq)
> @@ -439,11 +458,11 @@ static int sha_finish_walk(struct mcryptd_hash_request_ctx **ret_rctx,
>                 sha_ctx = (struct sha512_hash_ctx *)
>                                                 ahash_request_ctx(&rctx->areq);
>                 kernel_fpu_begin();
> -               sha_ctx = sha512_ctx_mgr_submit(cstate->mgr, sha_ctx,
> +               sha_ctx = sha512_ctx_mgr_submit(cstate, sha_ctx,
>                                                 rctx->walk.data, nbytes, flag);
>                 if (!sha_ctx) {
>                         if (flush)
> -                               sha_ctx = sha512_ctx_mgr_flush(cstate->mgr);
> +                               sha_ctx = sha512_ctx_mgr_flush(cstate);
>                 }
>                 kernel_fpu_end();
>                 if (sha_ctx)
> @@ -471,11 +490,12 @@ static int sha_complete_job(struct mcryptd_hash_request_ctx *rctx,
>         struct sha512_hash_ctx *sha_ctx;
>         struct mcryptd_hash_request_ctx *req_ctx;
>         int ret;
> +       unsigned long flags;
>
>         /* remove from work list */
> -       spin_lock(&cstate->work_lock);
> +       spin_lock_irqsave(&cstate->work_lock, flags);
>         list_del(&rctx->waiter);
> -       spin_unlock(&cstate->work_lock);
> +       spin_unlock_irqrestore(&cstate->work_lock, flags);
>
>         if (irqs_disabled())
>                 rctx->complete(&req->base, err);
> @@ -486,14 +506,14 @@ static int sha_complete_job(struct mcryptd_hash_request_ctx *rctx,
>         }
>
>         /* check to see if there are other jobs that are done */
> -       sha_ctx = sha512_ctx_mgr_get_comp_ctx(cstate->mgr);
> +       sha_ctx = sha512_ctx_mgr_get_comp_ctx(cstate);
>         while (sha_ctx) {
>                 req_ctx = cast_hash_to_mcryptd_ctx(sha_ctx);
>                 ret = sha_finish_walk(&req_ctx, cstate, false);
>                 if (req_ctx) {
> -                       spin_lock(&cstate->work_lock);
> +                       spin_lock_irqsave(&cstate->work_lock, flags);
>                         list_del(&req_ctx->waiter);
> -                       spin_unlock(&cstate->work_lock);
> +                       spin_unlock_irqrestore(&cstate->work_lock, flags);
>
>                         req = cast_mcryptd_ctx_to_req(req_ctx);
>                         if (irqs_disabled())
> @@ -504,7 +524,7 @@ static int sha_complete_job(struct mcryptd_hash_request_ctx *rctx,
>                                 local_bh_enable();
>                         }
>                 }
> -               sha_ctx = sha512_ctx_mgr_get_comp_ctx(cstate->mgr);
> +               sha_ctx = sha512_ctx_mgr_get_comp_ctx(cstate);
>         }
>
>         return 0;
> @@ -515,6 +535,7 @@ static void sha512_mb_add_list(struct mcryptd_hash_request_ctx *rctx,
>  {
>         unsigned long next_flush;
>         unsigned long delay = usecs_to_jiffies(FLUSH_INTERVAL);
> +       unsigned long flags;
>
>         /* initialize tag */
>         rctx->tag.arrival = jiffies;    /* tag the arrival time */
> @@ -522,9 +543,9 @@ static void sha512_mb_add_list(struct mcryptd_hash_request_ctx *rctx,
>         next_flush = rctx->tag.arrival + delay;
>         rctx->tag.expire = next_flush;
>
> -       spin_lock(&cstate->work_lock);
> +       spin_lock_irqsave(&cstate->work_lock, flags);
>         list_add_tail(&rctx->waiter, &cstate->work_list);
> -       spin_unlock(&cstate->work_lock);
> +       spin_unlock_irqrestore(&cstate->work_lock, flags);
>
>         mcryptd_arm_flusher(cstate, delay);
>  }
> @@ -565,7 +586,7 @@ static int sha512_mb_update(struct ahash_request *areq)
>         sha_ctx = (struct sha512_hash_ctx *) ahash_request_ctx(areq);
>         sha512_mb_add_list(rctx, cstate);
>         kernel_fpu_begin();
> -       sha_ctx = sha512_ctx_mgr_submit(cstate->mgr, sha_ctx, rctx->walk.data,
> +       sha_ctx = sha512_ctx_mgr_submit(cstate, sha_ctx, rctx->walk.data,
>                                                         nbytes, HASH_UPDATE);
>         kernel_fpu_end();
>
> @@ -628,7 +649,7 @@ static int sha512_mb_finup(struct ahash_request *areq)
>         sha512_mb_add_list(rctx, cstate);
>
>         kernel_fpu_begin();
> -       sha_ctx = sha512_ctx_mgr_submit(cstate->mgr, sha_ctx, rctx->walk.data,
> +       sha_ctx = sha512_ctx_mgr_submit(cstate, sha_ctx, rctx->walk.data,
>                                                                 nbytes, flag);
>         kernel_fpu_end();
>
> @@ -677,8 +698,7 @@ static int sha512_mb_final(struct ahash_request *areq)
>         /* flag HASH_FINAL and 0 data size */
>         sha512_mb_add_list(rctx, cstate);
>         kernel_fpu_begin();
> -       sha_ctx = sha512_ctx_mgr_submit(cstate->mgr, sha_ctx, &data, 0,
> -                                                               HASH_LAST);
> +       sha_ctx = sha512_ctx_mgr_submit(cstate, sha_ctx, &data, 0, HASH_LAST);
>         kernel_fpu_end();
>
>         /* check if anything is returned */
> @@ -940,7 +960,7 @@ static unsigned long sha512_mb_flusher(struct mcryptd_alg_cstate *cstate)
>                         break;
>                 kernel_fpu_begin();
>                 sha_ctx = (struct sha512_hash_ctx *)
> -                                       sha512_ctx_mgr_flush(cstate->mgr);
> +                                       sha512_ctx_mgr_flush(cstate);
>                 kernel_fpu_end();
>                 if (!sha_ctx) {
>                         pr_err("sha512_mb error: nothing got flushed for"
> --
> 2.5.5
>
