From: Stephan Mueller <smueller@chronox.de>
Subject: Re: getrandom waits for a long time when /dev/random is insufficiently read from
Date: Fri, 29 Jul 2016 19:03:51 +0200
Message-ID: <2790164.RXkTBNoHIv@tauon.atsec.com>
References: <20160728180732.12d38880@alex-desktop> <2622345.NpnZjxROFX@tauon.atsec.com> <20160729101407.03123327.alex_y_xu@yahoo.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
	virtualization@lists.linux-foundation.org
To: Alex Xu <alex_y_xu@yahoo.ca>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:33874 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751695AbcG2RDz (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Fri, 29 Jul 2016 13:03:55 -0400
In-Reply-To: <20160729101407.03123327.alex_y_xu@yahoo.ca>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Freitag, 29. Juli 2016, 10:14:07 CEST schrieb Alex Xu:

Hi Alex,

> On Fri, 29 Jul 2016 15:12:30 +0200
> 
> Stephan Mueller <smueller@chronox.de> wrote as excerpted:
> > Am Freitag, 29. Juli 2016, 09:03:45 CEST schrieb Alex Xu:
> > > In my opinion, assuming I am not doing something terribly wrong,
> > > this constitutes a bug in the kernel's handling of getrandom calls
> > > at boot, possibly only when the primary source of entropy is
> > > virtio.
> > 
> > Nope, I do not think that this is true:
> > 
> > - /dev/random returns one byte for one byte of entropy received, but
> > it has a lower limit of 64 bits
> > 
> > - getrandom behaves like /dev/urandom (i.e. nonblocking) except
> > during boot where it waits until the RNG has collected 128 bits
> > before operating like a DRNG that is seeded once in a while when
> > entropy comes in.
> > 
> > 
> > Ciao
> > Stephan
> 
> I don't follow. Assuming you are correct and this is the issue, then
> reading 128 bits (16 bytes) from /dev/random should "exhaust the
> supply" and then both reads from /dev/random and calling getrandom
> should block.

You assume that getrandom works like /dev/random. This is not the case. It is 
a full deterministic RNG like /dev/urandom (which is seeded during its 
operation as entropy is available).

getrandom *only* differs from /dev/*u*random in that it waits initially such 
that the system collected 128 bits of entropy.

But you point to a real issue: when /dev/random is pulled before getrandom 
(and yet insufficient entropy is present), then the getrandom call will be 
woken up when the input_pool received 128 bits. But those 128 bits are fed 
from the input_pool to the blocking_pool based on the caller at the /dev/
random device. This implies that the reader for getrandom will NOT be able to 
obtain data from the input_pool and the nonblocking_pool because the transfer 
operation will not succeed. This implies that the nonblocking_pool remains 
unseeded and yet getrandom returns data to the caller.
> 
> That, however, is not the behavior I observed, which is that reading
> any amount from /dev/random will never block (since it is fed
> from /dev/urandom on the host side) whereas calling getrandom will
> always block unless /dev/random is read from first.

That is a different issue that I did not read from your initial explanation.

I need to look into it a bit deeper.
> 
> Moreover, as long as virtio-rng is available (and fed
> from /dev/urandom), /proc/sys/kernel/random/entropy_avail is always 961
> immediately after booting, which is more than enough to satisfy a
> one-byte read. After reading 1 byte, the estimate decreases to 896 or
> 897, but after reading 29 more bytes it increases to 1106.
> 
> Again, these observations are consistent with the conjecture that the
> issue arises since virtio-rng is a "pull" source of entropy whereas
> most other methods (e.g. interrupt timing) are "push" sources. I
> suspect that a similar issue occurs if RDRAND is the only source of
> entropy.
> 
> I also tried running rngd in the guest which resolved the issue but
> seems entirely stupid to me, even moreso since
> http://rhelblog.redhat.com/2015/03/09/red-hat-enterprise-linux-virtual-machi
> nes-access-to-random-numbers-made-easy/ says that "The use of rngd is now
> not required and the guest kernel itself fetches entropy from the host when
> the available entropy falls below a specific threshold.".

right -- the kernel has now an in-kernel link that makes rngd superflowous in 
this case.



Ciao
Stephan
