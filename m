From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH v4 0/6] Seeding DRBG with more entropy
Date: Mon, 4 May 2015 19:12:25 -0400
Message-ID: <20150504231225.GA15568@thunk.org>
References: <1626703.0h1HzJAx4d@tachyon.chronox.de>
 <20150503205834.GJ10014@thunk.org>
 <9802019.GiEn27gNxE@tauon>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: herbert@gondor.apana.org.au, Paul Bolle <pebolle@tiscali.it>,
	Andreas Steffen <andreas.steffen@strongswan.org>,
	Sandy Harris <sandyinchina@gmail.com>,
	linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org
To: Stephan Mueller <smueller@chronox.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:44311 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751232AbbEDXMb (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Mon, 4 May 2015 19:12:31 -0400
Content-Disposition: inline
In-Reply-To: <9802019.GiEn27gNxE@tauon>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, May 04, 2015 at 07:40:12AM +0200, Stephan Mueller wrote:
> >I'd drop the 3rd pool, and just simply block until the non-blocking
> 
> So, you have no concern to use the same pool that is also used by user land?

Nope, not really....  if you want to give me a specific articulable
concern, please be explicit what _your_ concern is.

> I am not sure that this approach is helpful, because the suggested approach 
> implies using a seeded DRNG and the used get_random_bytes already operates as 
> a (not always seeded) DRNG. If we have a blocking interface in the kernel, I 
> would recommend to make it identical to /dev/random. With the suggested 
> seeding approach for DRBG, we definitely have seed data available to start 
> with. Therefore, re-seeding it from another seeded DRNG (i.e. the nonblocking 
> pool after it is initialized) may not give us too much extra.
> 
> Therefore, may I propose to link the in-kernel blocking API to the blocking 
> pool and have it behave exactly like /dev/random?

Why do you think we need an in-kernel block API *at* *all*?  The only
excuse I can think of is one where the in-kernel users want to wait
for the the pool to be initialized.  Why do you think it needs to
behave "exactly like /dev/random"?  What in-kernel user needs this?

> Just as an FYI: the word "very" does not apply in all cases. I am about to 
> draft an email about that subject in the near future. But the problem is that 
> on SSD systems or virtual machines, the disk is no source of randomness any 
> more starting with 3.18 where all non-rotational block devices are not used as 
> a seed source any more. We only have interrupts which initialize the 
> nonblocking pool much later (in my Haswell systems around the time index of 
> 20). There are other problems that I would like to report separately.

The /dev/random is using the interrupt timing using versus the
timestamp counter (if the architecture has such a beast).  So even if
the SSD or the virtual machines don't give you much entropy, we get
entropy from the behavior of the caches, etc. --- which is exactly the
same argument you make about the why you think jitter-randomness is
sound.  The other thing I'll note is that if you don't trust the
timing of virtual disks on a virtual machines, I suspect the argument
for why you believe these things are deterministic are very similar to
the ones that could be made about the behavior of the internal CPU
caches being deterministic.  Furthermore, on most major cloud
providers, the virtual disks are located on some kind of remote
networked block device or cluster file system, which will have a fair
amount of uncertainty that wouldn't be visible to an external
attacker, say one sitting at NSA or BND headquarters.  So it may not
be as bad as you think.

Cheers,

						- Ted
