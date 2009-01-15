From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: compress - Add pcomp interface
Date: Thu, 15 Jan 2009 14:05:26 +1100
Message-ID: <20090115030526.GA27726@gondor.apana.org.au>
References: <1231862386-11128-1-git-send-email-Geert.Uytterhoeven@sonycom.com> <1231862386-11128-2-git-send-email-Geert.Uytterhoeven@sonycom.com> <20090114031613.GA7429@gondor.apana.org.au> <Pine.LNX.4.64.0901141528010.31703@vixen.sonytel.be>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:48759 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752722AbZAODFb (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 14 Jan 2009 22:05:31 -0500
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0901141528010.31703@vixen.sonytel.be>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, Jan 14, 2009 at 04:01:34PM +0100, Geert Uytterhoeven wrote:
>
> It's used by the pr_*() macros in <linux/kernel.h>.
> 
> Since commit d091c2f58ba32029495a933b721e8e02fbd12caa ("Add 'pr_fmt()' format
> modifier to pr_xyz macros."), this is the new way to have a common prefix in
> all printed output.

But you don't actually print anything out in the module :)

> For compatibility with crypto_comp, we also need an alloc function for both
> compress and decompress, so that makes 3 alloc functions.

Couldn't crypto_comp just call both alloc functions? I don't see
why we need a third function.

> > 1) We know what the user wants to do without every algorithm
> > reinventing their own signalling for it;
> 
> I guess you want to use the flags to indicate compress/decompress/both?
> Unfortunately I'm still struggling to fully understand the type/mask handling,
> so I would appreciate it if you could give me a hint how to handle that.

No, I mean that whether you want compression or decompression
is signified by the which function you're calling.  If you want
to do both then you call both.

> I assume "length" is the size of the passed params, so the algorithms can
> return -EINVAL if they're passed the wrong size?

Well with the netlink parameters these can have variable lengths
depending on how many parameters the user supplies.

> > > +static inline struct crypto_pcomp *crypto_alloc_pcomp(const char *alg_name,
> > > +						      u32 type, u32 mask)
> > > +{
> > > +	type &= ~CRYPTO_ALG_TYPE_MASK;
> > > +	type |= CRYPTO_ALG_TYPE_PCOMPRESS;
> > > +	mask |= CRYPTO_ALG_TYPE_MASK;
> > > +
> > > +	return __crypto_pcomp_cast(crypto_alloc_base(alg_name, type, mask));
> > > +}
> > 
> > That's the old way to allocate tfm's which won't work since pcomp
> > is using the new type API.  You should do it the way that shash
> > does it.
> 
> I tried to do this, but stumbled across a dependency problem: as
> crypto_alloc_tfm() needs a pointer to crypto_pcomp_type(), crypto_alloc_pcomp()
> can no longer be static inline, and must be moved to crypto/pcompress.c.

Ah yes because crypto_comp is one of the original types that's
still built-in.  Because there are so few compression users and
algorithms (exactly 3 if you include null compression), I think
we can dispense with the compatibility stuff altogether since
we'll likely rip out fairly soon anyway.

So just create the new type, readd deflate using the new type
alongside the existing deflate algorithm.  The system is capable
of supporting two algorithms of the same name with different types.

Then once the other algorithm (lzo) is taken care of and all the
users are converted I'll just kill the old type and algorithms.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
