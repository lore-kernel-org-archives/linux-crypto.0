From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: blkcipher_get_spot() handling of buffer at end of page
Date: Sat, 8 Sep 2007 12:14:23 +0800
Message-ID: <20070908041423.GA8961@gondor.apana.org.au>
References: <5562608.649291189210157514.JavaMail.root@tahiti.vyatta.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-kernel@vger.kernel.org,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
To: Bob Gilligan <gilligan@vyatta.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:1510 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750713AbXIHEOb (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sat, 8 Sep 2007 00:14:31 -0400
Content-Disposition: inline
In-Reply-To: <5562608.649291189210157514.JavaMail.root@tahiti.vyatta.com>
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Fri, Sep 07, 2007 at 05:09:17PM -0700, Bob Gilligan wrote:
>
> Proposed patch is below.  We found the problem and tested this fix in
> 2.6.20, but it looks like the relevant code in blkcipher.c is the same
> in the latest tree.

Good catch!

I've fixed this slightly differently.  Also, the kmalloc size
in the case where it does straddle a page isn't enough either.

[CRYPTO] blkcipher: Fix handling of kmalloc page straddling

The function blkcipher_get_spot tries to return a buffer of
the specified length that does not straddle a page.  It has
an off-by-one bug so it may advance a page unnecessarily.

What's worse, one of its callers doesn't provide a buffer
that's sufficiently long for this operation.

This patch fixes both problems.  Thanks to Bob Gilligan for
diagnosing this problem and providing a fix.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
--
diff --git a/crypto/blkcipher.c b/crypto/blkcipher.c
index 7755834..469cb7f 100644
--- a/crypto/blkcipher.c
+++ b/crypto/blkcipher.c
@@ -59,11 +59,13 @@ static inline void blkcipher_unmap_dst(struct blkcipher_walk *walk)
 	scatterwalk_unmap(walk->dst.virt.addr, 1);
 }
 
+/* Get a spot of the specified length that does not straddle a page.
+ * The caller needs to ensure that there is enough space for this operation.
+ */
 static inline u8 *blkcipher_get_spot(u8 *start, unsigned int len)
 {
-	if (offset_in_page(start + len) < len)
-		return (u8 *)((unsigned long)(start + len) & PAGE_MASK);
-	return start;
+	u8 *end_page = (u8 *)(((unsigned long)(start + len - 1)) & PAGE_MASK);
+	return start < end_page ? start : end_page;
 }
 
 static inline unsigned int blkcipher_done_slow(struct crypto_blkcipher *tfm,
@@ -155,7 +157,8 @@ static inline int blkcipher_next_slow(struct blkcipher_desc *desc,
 	if (walk->buffer)
 		goto ok;
 
-	n = bsize * 2 + (alignmask & ~(crypto_tfm_ctx_alignment() - 1));
+	n = bsize * 3 - (alignmask + 1) +
+	    (alignmask & ~(crypto_tfm_ctx_alignment() - 1));
 	walk->buffer = kmalloc(n, GFP_ATOMIC);
 	if (!walk->buffer)
 		return blkcipher_walk_done(desc, walk, -ENOMEM);
