From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH/RFC 0/4] Partial decompression API (was: Re: [patch
	1/3] crypto: Add a zlib crypto module)
Date: Tue, 25 Nov 2008 23:00:00 +0800
Message-ID: <20081125150000.GA28748@gondor.apana.org.au>
References: <20080829134158.108976037@vixen.sonytel.be> <20080829134418.874948211@vixen.sonytel.be> <20080830062315.GA18441@gondor.apana.org.au> <Pine.LNX.4.64.0811241700100.9844@vixen.sonytel.be>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org
To: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:34995 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751287AbYKYPAE (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 25 Nov 2008 10:00:04 -0500
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0811241700100.9844@vixen.sonytel.be>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Thanks for the patches!

On Mon, Nov 24, 2008 at 05:11:42PM +0100, Geert Uytterhoeven wrote:
>
> As pointed out in patch [1/4], some underlying (de)compression implementations
> do not support partial (de)compression.  This is the case for e.g. LZO, which
> is already supported by a crypto module. While one-shot (de)compression can
> easily be implemented on top of a partial (de)compression API, the inverse is
> not true.

But that's just because lib/lzo didn't implement partial operations,
which means that we can improve it to perform partial compression and
decompression, right?

> Hence there should be a way to ask for a "one-shot" vs. "partial" decompression
> module at crypto_alloc_comp() time.

If we do find such an algorithm (which I'm sceptical), then we can
easily add such a flag which can be used at alloc time to choose
the right type.

In fact, even if such algorithm did exist (i.e., one that requires
all the input to determine the first byte of the output), we can
always handle it by only ever writing output in the final function.

> Do you have any suggestions how to handle this?
> Perhaps by using "oneshot(%s)" and "partial(%s)", cfr. what is done in other
> parts of the CRYPTO API where orthogonal features are combined?

The standard way is to add a CRYPTO_ALG_FOO flag and use it at
alloc time.

But I really can't imagine how such an algorithm could possibly
work beyond a fixed size input.

Also, I'm not saying that you need to convert lzo yourself since
you can always add a new compress type alongside the existing
crypto_comp type.  When someone does finally convert lzo we can
then kill the old type.  See the shash/digest code for an example 
of such a cohabitation.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
