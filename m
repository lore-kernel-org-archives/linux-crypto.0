From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 5/5] camellia: de-unrolling, 64bit-ization
Date: Tue, 6 Nov 2007 22:23:14 +0800
Message-ID: <20071106142314.GE24423@gondor.apana.org.au>
References: <200710251243.58701.vda.linux@googlemail.com> <200710251248.29746.vda.linux@googlemail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org
To: Denys Vlasenko <vda.linux@googlemail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:3294 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751000AbXKFOXw (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 6 Nov 2007 09:23:52 -0500
Content-Disposition: inline
In-Reply-To: <200710251248.29746.vda.linux@googlemail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Thu, Oct 25, 2007 at 12:48:29PM +0100, Denys Vlasenko wrote:
> On Thursday 25 October 2007 12:43, Denys Vlasenko wrote:
> > Hi Hervert,
> > 
> > Please review and maybe propagate upstream following patches.
> > 
> > camellia5.diff
> >     Use alternative key setup implementation with mostly 64-bit ops
> >     if BITS_PER_LONG >= 64. Both much smaller and much faster.
> > 
> >     Unify camellia_en/decrypt128/256 into camellia_do_en/decrypt.
> >     Code was similar, with just one additional if() we can use came code.
> > 
> >     If CONFIG_CC_OPTIMIZE_FOR_SIZE is defined,
> >     use loop in camellia_do_en/decrypt instead of unrolled code.
> >     ~5% encrypt/decrypt slowdown.

Having two versions of the cdoe is unmaintainable.  So please
either decide that 5% is worth it or isn't.

The rest of this patch looks fine.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
