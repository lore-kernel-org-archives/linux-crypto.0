From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH v6 1/5] random: Blocking API for accessing
 nonblocking_pool
Date: Fri, 5 Jun 2015 13:28:06 +0800
Message-ID: <20150605052805.GA2298@gondor.apana.org.au>
References: <1921857.OvxEu6y28S@tachyon.chronox.de>
 <6511355.kQJsTdtLzf@tachyon.chronox.de>
 <20150519072227.GA28837@gondor.apana.org.au>
 <2404915.vbuKFfjVR8@tachyon.chronox.de>
 <20150519075155.GA29242@gondor.apana.org.au>
 <20150519135028.GC20421@thunk.org>
 <20150519141805.GA32663@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Theodore Ts'o <tytso@mit.edu>,
	Stephan Mueller <smueller@chronox.de>, pebolle@tiscali.nl,
	andreas.steffen@strongswan.org, sandyinchina@gmail.com,
	linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20150519141805.GA32663@gondor.apana.org.au>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Tue, May 19, 2015 at 10:18:05PM +0800, Herbert Xu wrote:
> On Tue, May 19, 2015 at 09:50:28AM -0400, Theodore Ts'o wrote:
> >
> > Finally, this is only going to block *once*, when the system is
> > initially botting up.  Why is it so important that we get the
> > asynchronous nature of this right, and why can't we solve it simply by
> > just simply doing the work in a workqueue, with a completion barrier
> > getting triggered once /dev/random initializes itself, and just simply
> > blocking the module unload until /dev/random is initialized?
> 
> I guess I'm still thinking of the old work queue code before
> Tejun's cmwq work.  Yes blocking in a work queue should be fine
> as there is usually just one DRBG instance.

It looks like waiting for it in a workqueue isn't good enough
after all.  I just got this in a KVM machine:

INFO: task kworker/0:1:121 blocked for more than 120 seconds.
      Tainted: G           O    4.1.0-rc1+ #34
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
kworker/0:1     D ffff88001eb47d18     0   121      2 0x00000000
Workqueue: events drbg_async_seed [drbg]
 ffff88001eb47d18 ffff88001e1bcec0 ffff88001eb84010 0000000000000246
 ffff88001eb48000 0000000000000020 ffff88001d54ea50 0000000000000000
 ffff88001f613080 ffff88001eb47d38 ffffffff813fe692 0000000000000020
Call Trace:
 [<ffffffff813fe692>] schedule+0x32/0x80
 [<ffffffff812c1415>] get_blocking_random_bytes+0x65/0xa0
 [<ffffffff810825e0>] ? add_wait_queue+0x60/0x60
 [<ffffffffa03dd14c>] drbg_async_seed+0x2c/0xc0 [drbg]
 [<ffffffff81063369>] process_one_work+0x129/0x310
 [<ffffffff810636a9>] worker_thread+0x119/0x430
 [<ffffffff813fe51b>] ? __schedule+0x7fb/0x85e
 [<ffffffff81063590>] ? process_scheduled_works+0x40/0x40
 [<ffffffff81068ed4>] kthread+0xc4/0xe0
 [<ffffffff81060000>] ? proc_cap_handler+0x180/0x1b0
 [<ffffffff81068e10>] ? kthread_freezable_should_stop+0x60/0x60
 [<ffffffff81401ee2>] ret_from_fork+0x42/0x70
 [<ffffffff81068e10>] ? kthread_freezable_should_stop+0x60/0x60

Steffen, I think we need to revisit the idea of having a list
of callbacks.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
