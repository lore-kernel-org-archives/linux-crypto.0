From: Megha Dey <megha.dey@intel.com>
Subject: Re: sha1_mb broken
Date: Wed, 28 Sep 2016 11:25:47 -0700
Message-ID: <1475087147.2490.6.camel@megha-Z97X-UD7-TH>
References: <1939675.7gNnqUbNs6@positron.chronox.de>
         <3264980.mGNQ3Qi0fl@positron.chronox.de>
         <1475085499.2490.1.camel@megha-Z97X-UD7-TH>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: linux-crypto@vger.kernel.org, tim.c.chen@linux.intel.com
To: Stephan Mueller <smueller@chronox.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga03.intel.com ([134.134.136.65]:37687 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750768AbcI1SST (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 28 Sep 2016 14:18:19 -0400
In-Reply-To: <1475085499.2490.1.camel@megha-Z97X-UD7-TH>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Stephan,

There was a bug fix: Commit ID : 0851561d (introduced in 4.6-rc5).

Assuming that you are using an older kernel than this one, maybe we are
issuing the complete with the wrong pointer, so the original issuer of
the request never gets the complete back.

If you are using an older kernel, can you please use the lastest and let
me know if you still see this issue?

Also can you give more info on the test case? Does it issue single
request or multiple requests?

Thanks,
Megha

On Wed, 2016-09-28 at 10:58 -0700, Megha Dey wrote:
> Hi Stephan,
> 
> Could you give me more info on how I could reproduce this issue on my
> end?
> 
> Also was this issue there all along? Which is the first kernel version
> where you see this?
> 
> Thanks,
> Megha
> 
> On Mon, 2016-09-26 at 19:32 +0200, Stephan Mueller wrote:
> > Am Freitag, 26. August 2016, 03:15:06 CEST schrieb Stephan Mueller:
> > 
> > Hi Megha,
> > 
> > > Hi,
> > > 
> > > I tried to execute tests with sha1_mb.
> > 
> > Have you had a chance to look into this one?
> > > 
> > > The execution simply stalls when invoking a digest operation -- i.e. the
> > > digest operation does not finish. After some time after invoking the hashing
> > > operation, the following log appears (note, the kccavs_* functions are my
> > > test code; that test code works perfectly well with all other hash
> > > implementations):
> > > 
> > > [  140.426026] INFO: rcu_sched detected stalls on CPUs/tasks:
> > > [  140.426719] 	2-...: (1 GPs behind) idle=9c3/140000000000000/0
> > > softirq=2680/2707 fqs=14762
> > > [  140.427024] 	(detected by 0, t=60002 jiffies, g=655, c=654, q=35)
> > > [  140.427024] Task dump for CPU 2:
> > > [  140.427024] cavs_driver     R  running task        0   945    862
> > > 0x00000008
> > > [  140.427024]  ffffffff9b78d965 ffffa527b8bfa640 ffffa527bb505940
> > > ffffa52775c20c50
> > > [  140.427024]  ffffa527bc300000 ffffa527b93d2a80 ffffa527bb857e00
> > > ffffa527bc2ffd78
> > > [  140.427024]  ffffa527b93d2ac8 ffffa527bc2ffcc0 ffffffff9b78dfc8
> > > ffffa527bc2ffd70
> > > [  140.427024] Call Trace:
> > > [  140.427024]  [<ffffffff9b78d965>] ? __schedule+0x245/0x690
> > > [  140.427024]  [<ffffffff9b78dfc8>] ? preempt_schedule_common+0x18/0x30
> > > [  140.427024]  [<ffffffff9b791a68>] ? _raw_spin_lock_irq+0x28/0x30
> > > [  140.427024]  [<ffffffff9b78ed98>] ? wait_for_completion_interruptible
> > > +0x28/0x180
> > > [  140.427024]  [<ffffffffc028541c>] ? sha1_mb_async_digest+0x6c/0x70
> > > [sha1_mb]
> > > [  140.427024]  [<ffffffff9b3b1129>] ? crypto_ahash_op+0x29/0x70
> > > [  140.427024]  [<ffffffffc0270148>] ? kccavs_test_ahash+0x198/0x2b0
> > > [kcapi_cavs]
> > > [  140.427024]  [<ffffffffc026e20a>] ? kccavs_data_read+0xda/0x160
> > > [kcapi_cavs]
> > > [  140.427024]  [<ffffffff9b370964>] ? full_proxy_read+0x54/0x90
> > > [  140.427024]  [<ffffffff9b208088>] ? __vfs_read+0x28/0x110
> > > [  140.427024]  [<ffffffff9b38a2c0>] ? security_file_permission+0xa0/0xc0
> > > [  140.427024]  [<ffffffff9b20850e>] ? rw_verify_area+0x4e/0xb0
> > > [  140.427024]  [<ffffffff9b208606>] ? vfs_read+0x96/0x130
> > > [  140.427024]  [<ffffffff9b2099f6>] ? SyS_read+0x46/0xa0
> > > [  140.427024]  [<ffffffff9b791cb6>] ? entry_SYSCALL_64_fastpath+0x1e/0xa8
> > > 
> > > 
> > > 
> > > Ciao
> > > Stephan
> > > --
> > > To unsubscribe from this list: send the line "unsubscribe linux-crypto" in
> > > the body of a message to majordomo@vger.kernel.org
> > > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > 
> > 
> > Ciao
> > Stephan
> 
