From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: random(4) changes
Date: Mon, 25 Apr 2016 23:07:35 -0400
Message-ID: <20160426030735.GD28496@thunk.org>
References: <CACXcFm=PmD1_MqH5j-oY=X=mXD20jLMTuaPe9_GVY7JxN99MpA@mail.gmail.com>
 <20160424020323.GD20980@thunk.org>
 <5435493.2Hi9JfvD3o@positron.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Sandy Harris <sandyinchina@gmail.com>,
	LKML <linux-kernel@vger.kernel.org>,
	linux-crypto@vger.kernel.org, Jason Cooper <jason@lakedaemon.net>,
	John Denker <jsd@av8n.com>, "H. Peter Anvin" <hpa@zytor.com>,
	Andi Kleen <andi@firstfloor.org>
To: Stephan Mueller <smueller@chronox.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:39676 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751073AbcDZDHp (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Mon, 25 Apr 2016 23:07:45 -0400
Content-Disposition: inline
In-Reply-To: <5435493.2Hi9JfvD3o@positron.chronox.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Sun, Apr 24, 2016 at 10:03:45AM +0200, Stephan Mueller wrote:
> 
> I agree here. The only challenge with the current implementation is the time 
> the fast_pool is to be mixed into an entropy pool. This requires a lock and 
> quite some code afterwards.

This only happens no more than once every 64 interrupts, and we don't
actually block waiting for the lock (we use a spin_trylock, and we
skip mixing to the next interrupt if it is locked).  I've done a lot
of careful benchmarking of the cycles used.

> When dropping the add_disk_randomness function in the legacy /dev/random, I 
> would assume that without changes to add_input_randomness and 
> add_interrupt_randomness, we become even more entropy-starved.

Sure, but your system isn't doing anything magical here.  The main
difference is that you assume you can get almost a full bit of entropy
out of each interrupt timing, where I'm much more conservative and
assume we can only get 1/64th of a bit out of each interrupt timing.
(e.g., that each interrupt event may have some complex correlation
that is more sophisticated than what a "stuck bit" detector might be
able to detect.)

Part of the reason why I've been very conservative here is because not
all ARM CPU's provide access to a high speed counter.  Using the IP
and other CPU registers as a stop-gap is not great, but it is better
than just using jiffies (which you seem to assume the /dev/random
driver is doing; this is not true, and this is one of the ways in
which the current system is better than your proposed LRNG, and why
I'm not really fond of major "rip and replace" patches --- it's likely
such a approach will end up making things worse for some systems, and
I don't true the ARM SOC or embedded/mobile vendors to chose the
kernel configuration sanely in terms of "should I use random number
generator 'A' or 'B' for my system?).


The other big difference is you aren't allowing anyone to extract from
the primary entropy pool (/dev/random) until it is has a chance to
fully initialize the /dev/urandom pool, which is a good thing to do,
and something that's not hard to do without doing a complete rip and
replace of the RNG.  So I'll look at adding that to the /dev/random driver.

Yet another difference which I've noticed as I've been going over the
patches is that that since it relies on CRYPTO_DRBG, it drags in a
fairly large portion of the crypto subsystem, and requires it to be
compiled into the kernel (instead of being loaded as needed as a
module).  So the people who are worrying about keeping the kernel on a
diet aren't going to be particularly happy about this.

I've thought about using a CRNG for the secondary pool, which would be
a lot smaller and faster as far as random number extraction.  But the
concern I have is that I don't want to drag in the whole generalized
crypto subsystem just for /dev/random.  If we make it too heavyweight,
then there will be pressure to make /dev/random optional, which would
mean that application programs can't depend on it and some device
manufacturers might be tempted to make it disappear for their kernels.

So my preference if we want to go down this path is to use a CRNG
based on something like Twofish, which is modern, still unbroken, and
is designed to be implemented efficiently in software in a small
amount (both in terms of text and data segments).  This would then
make it realtively efficient to use per-CPU CRNG's, in order to to
satisfy Andi Kleen's concern about making /dev/urandom efficient for
crazy programs that are trying to extract a huge amounts of data out
of /dev/urandom on a big multi-socket system.  And I would do this
with a hard-wired system that avoids dragging in the crypto system to
to keep the Linux tinification folks happy.

Cheers,

					- Ted
