From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: IV copy strategy
Date: Mon, 19 Nov 2007 19:56:55 +0800
Message-ID: <20071119115655.GA5033@gondor.apana.org.au>
References: <20071113231132.GA10680@Chamillionaire.breakpoint.cc> <20071114142253.GA15201@gondor.apana.org.au> <20071115211005.GA21159@Chamillionaire.breakpoint.cc> <20071116020851.GC32509@gondor.apana.org.au> <20071116111110.GB31765@2ka.mipt.ru> <20071118065237.GA26456@gondor.apana.org.au> <20071119103840.GC2048@2ka.mipt.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org,
	Sebastian Siewior <linux-crypto@ml.breakpoint.cc>
To: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:1909 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751638AbXKSL45 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 19 Nov 2007 06:56:57 -0500
Content-Disposition: inline
In-Reply-To: <20071119103840.GC2048@2ka.mipt.ru>
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Mon, Nov 19, 2007 at 01:38:41PM +0300, Evgeniy Polyakov wrote:
>
> > Users requiring chaining would then do
> > 
> > 	crypto_alloc_blkcipher("foo", 0, CRYPTO_ALG_CIPHER_NOCHAIN)
> 
> Hmm, users who want chaining will set flag _NOCHAIN :)
> I would call it something more informative...

Yes I know, I'm just trying to save a few keystrokes since most
existing algorithms will set NOCHAIN to 0 :)

In any case, we can create a wrapper for it, something like
crypto_alloc_chaining_cipher.

> I'm not sure what user will do, when it request chaining, but driver
> will set CRYPTO_ALG_CIPHER_NOCHAIN itself and return wrong/old in
> req->info?
> For IPsec it is not an issue though, but I can not say that for all.

Drivers that set CRYPTO_ALG_CIPHER_NOCHAIN won't be returned
if the user requests for a chaining cipher.  This is the same
as when you request for a cipher with no fallback that the
system won't return one needing a fallback.

If you're worried about users doing chaining we could even
create a new frontend type for it.  So the user would need
to allocate an object of type crypto_chncipher and use that
for operations that chain.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
