From: Stephan Mueller <smueller@chronox.de>
Subject: Re: random(4) changes
Date: Tue, 26 Apr 2016 20:24:12 +0200
Message-ID: <3222056.xDVEr44tJI@positron.chronox.de>
References: <CACXcFm=PmD1_MqH5j-oY=X=mXD20jLMTuaPe9_GVY7JxN99MpA@mail.gmail.com> <5435493.2Hi9JfvD3o@positron.chronox.de> <20160426030735.GD28496@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: Sandy Harris <sandyinchina@gmail.com>,
	LKML <linux-kernel@vger.kernel.org>,
	linux-crypto@vger.kernel.org, Jason Cooper <jason@lakedaemon.net>,
	John Denker <jsd@av8n.com>, "H. Peter Anvin" <hpa@zytor.com>,
	Andi Kleen <andi@firstfloor.org>
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20160426030735.GD28496@thunk.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Am Montag, 25. April 2016, 23:07:35 schrieb Theodore Ts'o:

Hi Theodore,
> 
> > When dropping the add_disk_randomness function in the legacy /dev/random,
> > I
> > would assume that without changes to add_input_randomness and
> > add_interrupt_randomness, we become even more entropy-starved.
> 
> Sure, but your system isn't doing anything magical here.  The main
> difference is that you assume you can get almost a full bit of entropy
> out of each interrupt timing, where I'm much more conservative and
> assume we can only get 1/64th of a bit out of each interrupt timing.
> (e.g., that each interrupt event may have some complex correlation
> that is more sophisticated than what a "stuck bit" detector might be
> able to detect.)

The stuck test is only for identifying small patterns.

With the measurements I have done on a number of different systems trying to 
find a worst case attack and applying it, I still found that the timing of 
interrupt events show variations of 11 bits and more. It is good to be 
conservative for entropy estimations. But being too conservative is like 
killing yourself just because you are afraid of dying.

I tried to find an entropy estimate that is reasonable. And by moving from 11 
bits to 0.9 bits, I thought I am good here.

However, if a more conservative approach is requested, the LRNG only requires 
the change of LRNG_IRQ_ENTROPY_BYTES.

> 
> Part of the reason why I've been very conservative here is because not
> all ARM CPU's provide access to a high speed counter.  Using the IP
> and other CPU registers as a stop-gap is not great, but it is better
> than just using jiffies (which you seem to assume the /dev/random
> driver is doing; this is not true, and this is one of the ways in
> which the current system is better than your proposed LRNG, and why

I have neither said that the legacy /dev/random rests only on jiffies in 
absence of a high-res timer nor did I try to imply that. What I am saying is 
that even the combination of Jiffies and registers is not great either as they 
seem to be predictable with a reasonable degree of precision by an external 
entity.

In fact, Pavel's comments made me add exactly this kind of logic to cover 
systems without high-res timers. I will release the new code shortly. But they 
are only invoked if a high-res timer is not available.

> I'm not really fond of major "rip and replace" patches --- it's likely
> such a approach will end up making things worse for some systems, and
> I don't true the ARM SOC or embedded/mobile vendors to chose the
> kernel configuration sanely in terms of "should I use random number
> generator 'A' or 'B' for my system?).

I am sorry, but I cannot understand this statement: I am neither ripping 
things out, nor do I favor an outright replacement. I am offering a new option 
which may even be marked experimental for the time being.

I am asking to consider a new approach to collect entropy. And I am offering a 
patch that currently is intended for research and evaluation. It is a full API 
and ABI compatible version of the legacy /dev/random which allows such 
research and evaluation.

I do not see any way to use small steps in changing the legacy /dev/random 
with the challenges it faces. Besides, even small changes to the legacy 
/dev/random are rarely accepted, let alone the big items covering its 
challenges.

[..]
> 
> Yet another difference which I've noticed as I've been going over the
> patches is that that since it relies on CRYPTO_DRBG, it drags in a
> fairly large portion of the crypto subsystem, and requires it to be
> compiled into the kernel (instead of being loaded as needed as a
> module).  So the people who are worrying about keeping the kernel on a
> diet aren't going to be particularly happy about this.

If this is really a concern to people, I think there is no blocker to us here: 
I deliberately implemented the DRBG in the kernel crypto API such that it acts 
as a mere "block chaining mode" which is independent from the API it is called 
with and independent from the API of the underlying cipher suites. For a proof 
of this claim, you may want to compare the code from the crypto/drbg.c with 
the random/random-drbg.c code in upstream libgcrypt -- they are identical when 
it comes to the DRBG logic (I implemented the DRBG code on libgcrypt at the 
beginning with the goal to provide such cryptolib-agnostic implementation so 
that I can easily apply it to the kernel crypto API).

The LRNG uses only the DRBG core without using the kernel crypto API itself. 
Thus, it is not too hard to extract the DRBG core into a library code like 
lib/sha1.c and combine both if one does not want to compile the kernel crypto 
API.

> 
> I've thought about using a CRNG for the secondary pool, which would be
> a lot smaller and faster as far as random number extraction.  But the
> concern I have is that I don't want to drag in the whole generalized
> crypto subsystem just for /dev/random.  If we make it too heavyweight,
> then there will be pressure to make /dev/random optional, which would
> mean that application programs can't depend on it and some device
> manufacturers might be tempted to make it disappear for their kernels.
> 
> So my preference if we want to go down this path is to use a CRNG
> based on something like Twofish, which is modern, still unbroken, and
> is designed to be implemented efficiently in software in a small
> amount (both in terms of text and data segments).  This would then
> make it realtively efficient to use per-CPU CRNG's, in order to to
> satisfy Andi Kleen's concern about making /dev/urandom efficient for
> crazy programs that are trying to extract a huge amounts of data out
> of /dev/urandom on a big multi-socket system.  And I would do this
> with a hard-wired system that avoids dragging in the crypto system to
> to keep the Linux tinification folks happy.

I think with my answer above it is clear that the LRNG does not rely on having 
the kernel crypto API -- it is merely a convenience as of now. But we should 
not block ourselves from using it when it is there. It provides huge 
advantages.

Ciao
Stephan
