From: Neil Horman <nhorman@tuxdriver.com>
Subject: Re: Is ansi_cprng.c supposed to be an implmentation of X9.31?
Date: Sat, 29 Nov 2014 20:16:12 -0500
Message-ID: <20141130011611.GB19479@localhost.localdomain>
References: <20141129175856.GB15743@localhost.localdomain>
 <20141129193205.28874.qmail@ns.horizon.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: herbert@gondor.apana.org.au, jarod@redhat.com,
	linux-crypto@vger.kernel.org, stephan.mueller@atsec.com
To: George Spelvin <linux@horizon.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:51223 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751807AbaK3BQY (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sat, 29 Nov 2014 20:16:24 -0500
Content-Disposition: inline
In-Reply-To: <20141129193205.28874.qmail@ns.horizon.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Sat, Nov 29, 2014 at 02:32:05PM -0500, George Spelvin wrote:
> >> Other than enough implementation stupidities to make me scream
> >> (particularly the "rand_data_valid" variable name which is actually a
> 
> > Its actually a counter of the number of valid random data bytes in the buffer
> > being returned to a caller, as well as an index into the internal buffer from
> > which to draw fresh random data.  Sorry if you don't get that, but it seems
> > pretty clear.
> 
> As you can see, I ended up choosing less abrasive wording in the version I
> *thought* was public; this got launched into the void while in draft form.
> Sorry about that.
> 
> Oh, its use as an index into the read_data array is clear enough;
> it's just that the fact that the number of valid bytes in that
> array is DEFAULT_BLOCK_SZ - ctx->rand_data_valid seems "obviously
> backward" to me.
> 
> You'd think "ctx->rand_data_valid = 0" would mean "no data is valid;
> force update cycle next access", but nope...
> 
> > is that this is definitely NOT conformant with the X9.17/X9.31 spec.
>  
> > This is the document it was based of off:
> > http://csrc.nist.gov/groups/STM/cavp/documents/rng/931rngext.pdf
> 
> Ah, I actually read that, but I didn't remember that the "Based on"
> wording is a direct quote.
> 
> If you go to the original ANSI specs (which I've read in the past,
> but din't have a web-accessible copy to link to), they're a bit
> more explicit on the point.
> 
> > Please read more closely, the header clearly states this is a PRNG
> > implementation, and a quick google search of the terms in the header bring up
> > the document referenced above, with which this cprng is in compliance with.
> 
> Yes, it was quite clear that a strict reading of the comments said that
> it was a PRNG, but I lost track of the fact that "Random Number Generator
> Based on ANSI X9.31 Appendix A.2.4" was NIST's wording that was being
> quoted, and was left with the impression that compliance to the ANSI spec
> (which *does* call for a high resolution timestamp) was being implied.
> 
> I either wanted to provide the implied compliance or clarify the
> absence of it.
> 
> > Sure, knock yourself out.  I don't consider it more or less valid to do so,
> > but patches are welcome.
> 
> Coming right up!
> 
> > Definately keep the ability to support external setting of DT, as you
> > can't pass any validation tests without it.
> 
> Yes, I've already figured that out when studying the impact of such a
> change.  Since there's already special-case handling of with/without
> a DT vector, that seemed the obvious thing to hook into.
> 
> The two changes that affected callers, which I didn't feel very confident
> about my understanding of, were:
> 1. Changing the recommended seed size, and
Well, you only need to worry about the users of the API in the kernel, for which
I think there is only one currently, so I would say change the seed size if you
want, and make sure the one caller matches it appropriately.  Not saying I agree
with the change (or disagree with it), but I think you don't really need to
worry about it.

> 2. Using actual random seed material.
> 
Thats really a call for the allocator of a cprng to make.  When you allocate a
cprng instance, you have to reset it before you use it, so you have to provide a
new IV, DT and KEY value anyway.  If the caller wants to provide real random
material, they are prefectly able to.  If you want you can default to using
random data when no seed is provided, but I wouldn't recommend it, since the
random pool can block, and we might be resetting the cprng in a non-blocking
context.  I would say just leave this to the caller.

> The other one, which I have to think *very* hard about, is whether
> using the same seed material as /dev/random in this much weaker
> cryptographic construction will introduce a flaw in *it*.
> 
