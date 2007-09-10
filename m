From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: blkcipher_get_spot() handling of buffer at end of page
Date: Mon, 10 Sep 2007 15:58:29 +0800
Message-ID: <20070910075829.GA25851@gondor.apana.org.au>
References: <5562608.649291189210157514.JavaMail.root@tahiti.vyatta.com> <20070908041423.GA8961@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-kernel@vger.kernel.org,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
To: Bob Gilligan <gilligan@vyatta.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:3681 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755370AbXIJH6e (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 10 Sep 2007 03:58:34 -0400
Content-Disposition: inline
In-Reply-To: <20070908041423.GA8961@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Sat, Sep 08, 2007 at 12:14:23PM +0800, Herbert Xu wrote:
> 
> [CRYPTO] blkcipher: Fix handling of kmalloc page straddling

As Bob correctly noted, I had the boolean test inverted.
Here is the correction:

[CRYPTO] blkcipher: Fix inverted test in blkcipher_get_spot

The previous patch had the conditional inverted.  This patch fixes it
so that we return the original position if it does not straddle a page.

Thanks to Bob Gilligan for spotting this.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
--
diff --git a/crypto/blkcipher.c b/crypto/blkcipher.c
--- a/crypto/blkcipher.c
+++ b/crypto/blkcipher.c
@@ -65,7 +65,7 @@ static inline void blkcipher_unmap_dst(s
 static inline u8 *blkcipher_get_spot(u8 *start, unsigned int len)
 {
 	u8 *end_page = (u8 *)(((unsigned long)(start + len - 1)) & PAGE_MASK);
-	return start < end_page ? start : end_page;
+	return start > end_page ? start : end_page;
 }
 
 static inline unsigned int blkcipher_done_slow(struct crypto_blkcipher *tfm,
