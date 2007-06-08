From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: Where has CRYPTO_TFM_MODE_nnn gone?
Date: Sat, 9 Jun 2007 08:25:32 +1000
Message-ID: <20070608222532.GA30451@gondor.apana.org.au>
References: <4669AA4D.5040708@pmc-sierra.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org,
	Shane McDonald <Shane_McDonald@pmc-sierra.com>
To: Marc St-Jean <Marc_St-Jean@pmc-sierra.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:2827 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S935571AbXFHWZf (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 8 Jun 2007 18:25:35 -0400
Content-Disposition: inline
In-Reply-To: <4669AA4D.5040708@pmc-sierra.com>
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Fri, Jun 08, 2007 at 12:13:17PM -0700, Marc St-Jean wrote:
> 
> In CBC mode we had a line of code copying cipher_desc.info to get the
> initialization vector. Such as:
> 		/* Copy in IV */
> 		memcpy((u8*)(sa->crypt_iv), desc->info,
> 			crypto_tfm_alg_ivsize(tfm));
> 
> Now the only reference to the function I can find is in an IPsec comment
> from include/net/esp.h. Any tips on getting the size?

We now have two types of ciphers, simple ciphers and block ciphers.  The
former only ever ecnrypts one block at a time, and therefore needs no IV.
Only block ciphers have IVs.

The other change is that instead of having everything as crypto_tfm they
all have their own types now.  So ciphers are crypto_cipher while block
ciphers are crypto_blkcipher.

In your case your tfm should be of type crypto_blkcipher.  Then you simply
call crypto_blkcipher_ivsize(tfm) to get the size.
 
> Thanks, I have been looking at that code but unfortunately it supports
> fewer cryptos/hashes so does not answer all my questions.

The same concept still applies regardless of the actual number of modes.

Oh and yes you do register it multiple times, once for each combination
of the blocking mode and the cipher.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
