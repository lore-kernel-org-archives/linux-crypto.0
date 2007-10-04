From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [CRYPTO] blkcipher: Add IV generation
Date: Thu, 4 Oct 2007 15:28:54 +0800
Message-ID: <20071004072854.GA23264@gondor.apana.org.au>
References: <20070929133450.GB3619@gondor.apana.org.au> <20070929133648.GA3828@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:1363 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752362AbXJDH3A (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 4 Oct 2007 03:29:00 -0400
Received: from gondolin.me.apana.org.au ([192.168.0.6] ident=mail)
	by arnor.apana.org.au with esmtp (Exim 4.50 #1 (Debian))
	id 1IdL8h-00022R-DZ
	for <linux-crypto@vger.kernel.org>; Thu, 04 Oct 2007 17:28:55 +1000
Received: from herbert by gondolin.me.apana.org.au with local (Exim 3.36 #1 (Debian))
	id 1IdL8h-00063X-00
	for <linux-crypto@vger.kernel.org>; Thu, 04 Oct 2007 15:28:55 +0800
Content-Disposition: inline
In-Reply-To: <20070929133648.GA3828@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Sat, Sep 29, 2007 at 09:36:48PM +0800, Herbert Xu wrote:
> 
> [CRYPTO] blkcipher: Remove alignment restriction on block size
> 
> Previously we assumed for convenience that the block size is a multiple of
> the algorithm's required alignment.  With the pending addition of CTR this
> will no longer be the case as the block size will be 1 due to it being a
> stream cipher.  However, the alignment requirement will be that of the
> underlying implementation which will most likely be greater than 1.
> 
> Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

That patch missed one spot.  Here's a fix on top of it.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
--
319f8a1dff903a7f8b9853bd229abbc13e7fad71
diff --git a/crypto/blkcipher.c b/crypto/blkcipher.c
index ea9e240..1b2a14a 100644
--- a/crypto/blkcipher.c
+++ b/crypto/blkcipher.c
@@ -158,7 +158,7 @@ static inline int blkcipher_next_slow(struct blkcipher_desc *desc,
 	if (walk->buffer)
 		goto ok;
 
-	n = bsize * 3 - (alignmask + 1) +
+	n = aligned_bsize * 3 - (alignmask + 1) +
 	    (alignmask & ~(crypto_tfm_ctx_alignment() - 1));
 	walk->buffer = kmalloc(n, GFP_ATOMIC);
 	if (!walk->buffer)
