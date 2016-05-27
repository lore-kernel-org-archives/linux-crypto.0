From: Stephan Mueller <smueller@chronox.de>
Subject: Re: AES-NI: slower than aes-generic?
Date: Fri, 27 May 2016 09:08:42 +0200
Message-ID: <1800384.6sapC0WXE4@tauon.atsec.com>
References: <1567400.ZMFoPuCv2K@tauon.atsec.com> <4972668.UQ1QRNriDb@positron.chronox.de> <20160527021429.GA21331@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: Sandy Harris <sandyinchina@gmail.com>, linux-crypto@vger.kernel.org
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:34896 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754757AbcE0HIp (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Fri, 27 May 2016 03:08:45 -0400
In-Reply-To: <20160527021429.GA21331@thunk.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Donnerstag, 26. Mai 2016, 22:14:29 schrieb Theodore Ts'o:

Hi Theodore,

> On Thu, May 26, 2016 at 08:49:39PM +0200, Stephan Mueller wrote:
> > Using the kernel crypto API one can relieve the CPU of the crypto work, if
> > a hardware or assembler implementation is available. This may be of
> > particular interest for smaller systems. So, for smaller systems (where
> > kernel bloat is bad, but where now these days more and more hardware
> > crypto support is added), we must weigh the kernel bloat (of 3 or 4
> > additional C files for the basic kernel crypto API logic) against
> > relieving the CPU of work.
> 
> There are a number of caveats with using hardware acceleration; one is
> that many hardware accelerators are optimized for bulk data
> encryption, and so key scheduling, or switching between key schedules,
> can have a higher overhead that a pure software implementation.

Squeezing the last drop of speed out of the ciphers for the LRNG is not my 
priority given that the speed is limited by the reseeding. The LRNG should 
allow the CPU to offload the crypto work. For small systems, crypto is intense 
work that could be spend elsewhere.
> 
> There have also been situations where the hardware crypto engine is
> actually slower than a highly optimized software implementation.  This
> has been the case for certain ARM SOC's, for example.

And I would be fine with that. Besides, if a user wants to use software 
implementations with the LRNG and still offer HW support for all else, all 
they need to do is to statically compile the software implementation and 
compile the hardware support as a module. As the LRNG initializes before 
kernel modules can be loaded, it can only use what it finds in the static 
kernel.
> 
> This is not that big of deal, if you are developing a cryptographic
> application (such as file system level encryption, for example) for a
> specific hardware platform (such as a specific Nexus device).  But if
> you are trying to develop a generic service that has to work on a wide
> variety of CPU architectures, and specific CPU/SOC implementations,
> life is a lot more complicated.  I've worked on both problems, let me
> assure you the second is way tricker than the first.
> 
> > Then, the use of the DRBG offers users to choose between a Hash/HMAC and
> > CTR implementation to suit their needs. The DRBG code is agnostic of the
> > underlying cipher. So, you could even use Blowfish instead of AES or
> > whirlpool instead of SHA -- these changes are just one entry in
> > drbg_cores[] away without any code change.
> 
> I really question how much this matters in practice.  Unless you are a
> US Government Agency, where you might be laboring under a Federal
> mandate to use DUAL-EC DRBG (for example), most users really don't

I am not sure such references help the discussion.

> care about the details of the algorithm used in their random number
> generator.  Giving users choice (or lots of knobs) isn't necessarily
> always a feature, as the many TLS downgrade attacks have demonstrated.

The options are at compile time, not at runtime.
> 
> This is why from my perspectve it's more important to implement an
> interface which is always there, and which by default is secure, to
> minimize the chances that random JV-team kernel developers working for
> a Linux distribution or some consumer electronics manufacturer won't
> actually make things worse.  As the Debian's attempt to "improve" the
> security of OpenSSL demonstrates, it doesn't always end well.  :-)

Rest assured, the current implementation of /dev/random gives many people many 
headaches. And I can tell you that I have seen "random JV-team kernel 
developers" doing things you do not want to know just to make the behavior 
better.

And even if they do not change anything, I am yet under the impression that 
the current implementation has shortcommings in typical deployment scenarios 
(mainly VMs and headless server systems).

Hence I want to give a framework where people can safely alter a few things to 
suit their needs. But the things they can change should not affect the overall 
security.
> 
> If we implement something which happens to result in a 2 minute stall
> in boot times, the danger is that a clueless engineer at Sony, or LGE,
> or Motorola, or BMW, or Toyota, etc, will "fix" the problem without
> telling anyone about what they did, and we might not notice right away
> that the fix was in fact catastrophically bad.

Such "fixes" are employed these days already! And they are not employed 
because of the used crypto (which was the topic this thread started), but due 
to the handling and accounting of the initial entropy.

So, I think that the used crypto for the DRNG side is just the icing (hence I 
said I can live with SP800-90A, your Chacha20, even X9.31 given that the LRNG 
ensures proper seeding and reseeding). The real issues are in the entropy 
accounting and maintenance and the reseeding of the DRNGs.

Ciao
Stephan
