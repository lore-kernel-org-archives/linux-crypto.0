From: Alex Xu <alex_y_xu@yahoo.ca>
Subject: Re: getrandom waits for a long time when /dev/random is
 insufficiently read from
Date: Fri, 29 Jul 2016 13:31:14 -0400
Message-ID: <20160729133114.37ff14ef.alex_y_xu@yahoo.ca>
References: <20160728180732.12d38880@alex-desktop>
	<2622345.NpnZjxROFX@tauon.atsec.com>
	<20160729101407.03123327.alex_y_xu@yahoo.ca>
	<2790164.RXkTBNoHIv@tauon.atsec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
To: Stephan Mueller <smueller@chronox.de>,
	virtualization@lists.linux-foundation.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from nm2-vm1.bullet.mail.bf1.yahoo.com ([98.139.213.158]:39733 "EHLO
	nm2-vm1.bullet.mail.bf1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752283AbcG2RbS (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 29 Jul 2016 13:31:18 -0400
In-Reply-To: <2790164.RXkTBNoHIv@tauon.atsec.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, 29 Jul 2016 19:03:51 +0200
Stephan Mueller <smueller@chronox.de> wrote as excerpted:
> Am Freitag, 29. Juli 2016, 10:14:07 CEST schrieb Alex Xu:
> > I don't follow. Assuming you are correct and this is the issue, then
> > reading 128 bits (16 bytes) from /dev/random should "exhaust the
> > supply" and then both reads from /dev/random and calling getrandom
> > should block.  
> 
> You assume that getrandom works like /dev/random. This is not the
> case. It is a full deterministic RNG like /dev/urandom (which is
> seeded during its operation as entropy is available).

My understanding was that all three methods of obtaining entropy from
userspace all receive data from the CSPRNG in the kernel, and that the
only difference is that /dev/random and getrandom may block depending
on the kernel's estimate of the currently available entropy.

> getrandom *only* differs from /dev/*u*random in that it waits
> initially such that the system collected 128 bits of entropy.

I agree, this is the documented behavior of getrandom.

> But you point to a real issue: when /dev/random is pulled before
> getrandom (and yet insufficient entropy is present), then the
> getrandom call will be woken up when the input_pool received 128
> bits. But those 128 bits are fed from the input_pool to the
> blocking_pool based on the caller at the /dev/ random device. This
> implies that the reader for getrandom will NOT be able to obtain data
> from the input_pool and the nonblocking_pool because the transfer
> operation will not succeed. This implies that the nonblocking_pool
> remains unseeded and yet getrandom returns data to the caller.

I don't understand what this means. For my use case, hwrng is fed from
the host's urandom, so none of /dev/random, /dev/hwrng, /dev/urandom,
or getrandom with any flags in the guest should ever block except
possibly for very large amounts requested (megabytes at least).

> > That, however, is not the behavior I observed, which is that reading
> > any amount from /dev/random will never block (since it is fed
> > from /dev/urandom on the host side) whereas calling getrandom will
> > always block unless /dev/random is read from first.  
> 
> That is a different issue that I did not read from your initial
> explanation.
> 
> I need to look into it a bit deeper.

I have been trying to explain the same problem the entire time. Let me
be clear what the problem is as I see it:

When qemu is started with -object rng-random,filename=/dev/urandom, and
immediately (i.e. with no initrd and as the first thing in init):

1. the guest runs dd if=/dev/random, there is no blocking and tons of
data goes to the screen. the data appears to be random.

2. the guest runs getrandom with any requested amount (tested 1 byte
and 16 bytes) and no flags, it blocks for 90-110 seconds while the
"non-blocking pool is initialized". the returned data appears to be
random.

3. the guest runs getrandom with GRND_RANDOM with any requested amount,
it returns the desired amount or possibly less, but in my experience at
least 10 bytes. the returned data appears to be random.

I believe that the difference between cases 1 and 2 is a bug, since
based on my previous statement, in this scenario, getrandom should
never block.
