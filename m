From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: AES-NI: slower than aes-generic?
Date: Thu, 26 May 2016 22:14:29 -0400
Message-ID: <20160527021429.GA21331@thunk.org>
References: <1567400.ZMFoPuCv2K@tauon.atsec.com>
 <CACXcFmnFn_BDv_xLra-gfSTsOP-diTwtvU4_TndLAv+WuXG4DQ@mail.gmail.com>
 <4972668.UQ1QRNriDb@positron.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Sandy Harris <sandyinchina@gmail.com>,
	Stephan Mueller <stephan.mueller@atsec.com>,
	linux-crypto@vger.kernel.org
To: Stephan Mueller <smueller@chronox.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:38516 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932104AbcE0COh (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Thu, 26 May 2016 22:14:37 -0400
Content-Disposition: inline
In-Reply-To: <4972668.UQ1QRNriDb@positron.chronox.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, May 26, 2016 at 08:49:39PM +0200, Stephan Mueller wrote:
> 
> Using the kernel crypto API one can relieve the CPU of the crypto work, if a 
> hardware or assembler implementation is available. This may be of particular 
> interest for smaller systems. So, for smaller systems (where kernel bloat is 
> bad, but where now these days more and more hardware crypto support is added), 
> we must weigh the kernel bloat (of 3 or 4 additional C files for the basic 
> kernel crypto API logic) against relieving the CPU of work.

There are a number of caveats with using hardware acceleration; one is
that many hardware accelerators are optimized for bulk data
encryption, and so key scheduling, or switching between key schedules,
can have a higher overhead that a pure software implementation.

There have also been situations where the hardware crypto engine is
actually slower than a highly optimized software implementation.  This
has been the case for certain ARM SOC's, for example.

This is not that big of deal, if you are developing a cryptographic
application (such as file system level encryption, for example) for a
specific hardware platform (such as a specific Nexus device).  But if
you are trying to develop a generic service that has to work on a wide
variety of CPU architectures, and specific CPU/SOC implementations,
life is a lot more complicated.  I've worked on both problems, let me
assure you the second is way tricker than the first.

> Then, the use of the DRBG offers users to choose between a Hash/HMAC and CTR 
> implementation to suit their needs. The DRBG code is agnostic of the 
> underlying cipher. So, you could even use Blowfish instead of AES or whirlpool 
> instead of SHA -- these changes are just one entry in drbg_cores[] away 
> without any code change.

I really question how much this matters in practice.  Unless you are a
US Government Agency, where you might be laboring under a Federal
mandate to use DUAL-EC DRBG (for example), most users really don't
care about the details of the algorithm used in their random number
generator.  Giving users choice (or lots of knobs) isn't necessarily
always a feature, as the many TLS downgrade attacks have demonstrated.

This is why from my perspectve it's more important to implement an
interface which is always there, and which by default is secure, to
minimize the chances that random JV-team kernel developers working for
a Linux distribution or some consumer electronics manufacturer won't
actually make things worse.  As the Debian's attempt to "improve" the
security of OpenSSL demonstrates, it doesn't always end well.  :-)

If we implement something which happens to result in a 2 minute stall
in boot times, the danger is that a clueless engineer at Sony, or LGE,
or Motorola, or BMW, or Toyota, etc, will "fix" the problem without
telling anyone about what they did, and we might not notice right away
that the fix was in fact catastrophically bad.

These aren't the standard things which academics tend to worry about,
which tend to assume that attackers will be able to read arbitrary
kernel memory, and recovering such an exposure of the entropy pool is
_the_ most important thing to worry about (as opposed to say, the
contents of the user's private keys in the ssh-agent process).  But
this will perhaps explain why worrying about accomodating users who
care about whether Blowfish or AES should be used in their random
number generator isn't near the top of my personal priority list.

Cheers,

						- Ted
