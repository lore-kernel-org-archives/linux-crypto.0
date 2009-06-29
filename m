From: Neil Horman <nhorman@tuxdriver.com>
Subject: Re: Bug when modprobing tcrypt
Date: Mon, 29 Jun 2009 11:20:28 -0400
Message-ID: <20090629152027.GA5022@hmsreliant.think-freely.org>
References: <1246281425.3688.13.camel@queen> <20090629140704.GA25939@Chamillionaire.breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: herbert@gondor.apana.org.au, linux-crypto@vger.kernel.org,
	davem@davemloft.net, Eric Sesterhenn <eric.sesterhenn@lsexperts.de>
To: Sebastian Andrzej Siewior <linux-crypto@ml.breakpoint.cc>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:35873 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755246AbZF2PUl (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 29 Jun 2009 11:20:41 -0400
Content-Disposition: inline
In-Reply-To: <20090629140704.GA25939@Chamillionaire.breakpoint.cc>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, Jun 29, 2009 at 04:07:04PM +0200, Sebastian Andrzej Siewior wrote:
> * Eric Sesterhenn | 2009-06-29 15:17:05 [+0200]:
> 
> >[  122.967099] BUG: sleeping function called from invalid context at
> >kernel/rwsem.c:21
> >[  122.967398] in_atomic(): 1, irqs_disabled(): 0, pid: 4926, name:
> >modprobe
> >[  122.967643] INFO: lockdep is turned off.
> >[  122.967858] Pid: 4926, comm: modprobe Tainted: G   M
> >2.6.31-rc1-22297-g5298976 #24
> >[  122.968176] Call Trace:
> >[  122.968411]  [<c011dd93>] __might_sleep+0xf9/0x101
> >[  122.968677]  [<c0777aa0>] down_read+0x16/0x68
> >[  122.968928]  [<c048bf04>] crypto_alg_lookup+0x16/0x34
> >[  122.969479]  [<c048bf52>] crypto_larval_lookup+0x30/0xf9
> >[  122.969722]  [<c048c038>] crypto_alg_mod_lookup+0x1d/0x62
> >[  122.969977]  [<c048c13e>] crypto_alloc_base+0x1e/0x64
> >[  122.970271]  [<c04bf991>] reset_prng_context+0xab/0x13f
> >[  122.970523]  [<c04e5cfc>] ? __spin_lock_init+0x27/0x51
> >[  122.970777]  [<c04bfce1>] cprng_init+0x2a/0x42
> >[  122.971012]  [<c048bb4c>] __crypto_alloc_tfm+0xfa/0x128
> >[  122.971304]  [<c048c153>] crypto_alloc_base+0x33/0x64
> >[  122.971556]  [<c04933c9>] alg_test_cprng+0x30/0x1f4
> >[  122.971809]  [<c0493329>] alg_test+0x12f/0x19f
> >[  122.972103]  [<c0177f1f>] ? __alloc_pages_nodemask+0x14d/0x481
> >[  122.972356]  [<d09219e2>] do_test+0xf9d/0x163f [tcrypt]
> >[  122.972613]  [<d0920de6>] do_test+0x3a1/0x163f [tcrypt]
> >[  122.972855]  [<d0926035>] tcrypt_mod_init+0x35/0x7c [tcrypt]
> >[  122.973488]  [<c010113c>] _stext+0x54/0x12c
> >[  122.974575]  [<d0926000>] ? tcrypt_mod_init+0x0/0x7c [tcrypt]
> >[  122.974836]  [<c01398a3>] ? up_read+0x16/0x2b
> >[  122.975126]  [<c0139fc4>] ? __blocking_notifier_call_chain+0x40/0x4c
> >[  122.975376]  [<c014ee8d>] sys_init_module+0xa9/0x1bf
> >[  122.975635]  [<c010292b>] sysenter_do_call+0x12/0x32
> 
> reset_prng_context() grabs a spinlock. That prng_lock spinlock is taken
> with irqsave and sometimes without what does not look good on the first
> look.
> 
> Neil: It is legal for crypto_alloc_cipher() because it might load
> another module. Are you fine with the replacement of the spinlock with a
> mutex? rngapi_reset() in crypto/rng.c does kmalloc() with GFP_KERNEL so
> it looks like it is okay to sleep there.
> 
I'm a bit concerned about making prng_lock a mutex, since that seems like it
would prevent the use of the cprng in interrupt context.  I agree that the mixed
use of spin_lock and spin_lock_irqsave with prng_lock is prone to deadlock, but
I think that means we should probably convert all uses of prng_lock to be
irqsave/restore variants to prevent the single cpu deadlock case.  As for the
BUG above, I think we can work around that by reorganizing reset_prng_context a
bit, as we really only need the lock around ctx modifications, and the
PRNG_NEED_RESET flag guards against concurrent use while the lock isn't held.

I'd be happy to write a patch if you like, or you can propose one.  Just let me
know.

Alternatively, if you can think of a way that mutexes here would still allow for
interrupt context use, I'd certainly be ok with that, I just don't see how to
make that happen at the moment.

Regards
Neil

> Sebastian
> 
