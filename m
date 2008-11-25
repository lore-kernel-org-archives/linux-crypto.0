From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH/RFC 1/4] crypto: Add partial decompression support to
	the CRYPTO API
Date: Tue, 25 Nov 2008 23:05:55 +0800
Message-ID: <20081125150555.GA28932@gondor.apana.org.au>
References: <20080829134158.108976037@vixen.sonytel.be> <20080829134418.874948211@vixen.sonytel.be> <20080830062315.GA18441@gondor.apana.org.au> <Pine.LNX.4.64.0811241700100.9844@vixen.sonytel.be> <Pine.LNX.4.64.0811241711510.9844@vixen.sonytel.be>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org
To: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:53382 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752026AbYKYPVy (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 25 Nov 2008 10:21:54 -0500
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0811241711510.9844@vixen.sonytel.be>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, Nov 24, 2008 at 05:12:37PM +0100, Geert Uytterhoeven wrote:
> To solve this, add the following operations that support partial
> (de)compression:
>   - crypto_compress_{init,update,final}() for compression,
>   - crypto_decompress_{init,update,final}() for decompression.

Probably best to put this in a new type instead of crypto_comp.
That way you can still get a bisectable tree without having to
lump everything into one patch.

Doing that also means that you don't have to convert all the algorithms
at once (but please do convert them eventually so I don't have to :)

To make the conversion happen gradually you'd make all algorithms
of the new type available through the existing type (crypto_comp).
See how crypto_shash handles this with regards to the existing
crypto_hash type.

Once all algorithms are converted then you can convert the existing
users (new users can begin using the new type immediately).  Finally
you'd kill the crypto_comp type.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
