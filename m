From: Alex Xu <alex_y_xu@yahoo.ca>
Subject: Re: getrandom waits for a long time when /dev/random is
 insufficiently read from
Date: Fri, 29 Jul 2016 10:14:07 -0400
Message-ID: <20160729101407.03123327.alex_y_xu@yahoo.ca>
References: <20160728180732.12d38880@alex-desktop>
	<CAJU7zaL8G28chcwEEYAquApm2ncPaBjKky4UPaWVy=6B+-rsCA@mail.gmail.com>
	<20160729090345.798c3e6f.alex_y_xu@yahoo.ca>
	<2622345.NpnZjxROFX@tauon.atsec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
	virtualization@lists.linux-foundation.org
To: Stephan Mueller <smueller@chronox.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from nm29-vm1.bullet.mail.bf1.yahoo.com ([98.139.213.144]:59696 "EHLO
	nm29-vm1.bullet.mail.bf1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753000AbcG2OOM (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 29 Jul 2016 10:14:12 -0400
In-Reply-To: <2622345.NpnZjxROFX@tauon.atsec.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, 29 Jul 2016 15:12:30 +0200
Stephan Mueller <smueller@chronox.de> wrote as excerpted:
> Am Freitag, 29. Juli 2016, 09:03:45 CEST schrieb Alex Xu:
> > In my opinion, assuming I am not doing something terribly wrong,
> > this constitutes a bug in the kernel's handling of getrandom calls
> > at boot, possibly only when the primary source of entropy is
> > virtio.  
> 
> Nope, I do not think that this is true:
> 
> - /dev/random returns one byte for one byte of entropy received, but
> it has a lower limit of 64 bits
> 
> - getrandom behaves like /dev/urandom (i.e. nonblocking) except
> during boot where it waits until the RNG has collected 128 bits
> before operating like a DRNG that is seeded once in a while when
> entropy comes in.
> 
> 
> Ciao
> Stephan

I don't follow. Assuming you are correct and this is the issue, then
reading 128 bits (16 bytes) from /dev/random should "exhaust the
supply" and then both reads from /dev/random and calling getrandom
should block.

That, however, is not the behavior I observed, which is that reading
any amount from /dev/random will never block (since it is fed
from /dev/urandom on the host side) whereas calling getrandom will
always block unless /dev/random is read from first.

Moreover, as long as virtio-rng is available (and fed
from /dev/urandom), /proc/sys/kernel/random/entropy_avail is always 961
immediately after booting, which is more than enough to satisfy a
one-byte read. After reading 1 byte, the estimate decreases to 896 or
897, but after reading 29 more bytes it increases to 1106.

Again, these observations are consistent with the conjecture that the
issue arises since virtio-rng is a "pull" source of entropy whereas
most other methods (e.g. interrupt timing) are "push" sources. I
suspect that a similar issue occurs if RDRAND is the only source of
entropy.

I also tried running rngd in the guest which resolved the issue but
seems entirely stupid to me, even moreso since
http://rhelblog.redhat.com/2015/03/09/red-hat-enterprise-linux-virtual-machines-access-to-random-numbers-made-easy/
says that "The use of rngd is now not required and the guest kernel
itself fetches entropy from the host when the available entropy falls
below a specific threshold.".
