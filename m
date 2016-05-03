From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: crypto: hash - Fix page length clamping in hash walk
Date: Tue, 3 May 2016 17:55:31 +0800
Message-ID: <20160503095531.GA18007@gondor.apana.org.au>
References: <20160421071451.GE3347@gauss.secunet.com>
 <20160425100527.GA9521@gondor.apana.org.au>
 <20160428082743.GO3347@gauss.secunet.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Sowmini Varadhan <sowmini.varadhan@oracle.com>,
	linux-crypto@vger.kernel.org
To: Steffen Klassert <steffen.klassert@secunet.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:56959 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755699AbcECJzn (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 3 May 2016 05:55:43 -0400
Content-Disposition: inline
In-Reply-To: <20160428082743.GO3347@gauss.secunet.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, Apr 28, 2016 at 10:27:43AM +0200, Steffen Klassert wrote:
>
> The problem was that if offset (in a superpage) equals
> PAGE_SIZE in hash_walk_next(), nbytes becomes zero. So
> we map the page, but we don't hash and unmap because we
> exit the loop in shash_ahash_update() in this case.

I see.  Does this patch help?

---8<---
The length clamping in the crypto hash walk code is broken if
supplied with an offset greater than or equal to PAGE_SIZE.  This
patch fixes it by borrowing the code from scatterwalk.

Cc: <stable@vger.kernel.org>
Reported-by: Steffen Klassert <steffen.klassert@secunet.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

diff --git a/crypto/ahash.c b/crypto/ahash.c
index 5fc1f17..2d6c4f1 100644
--- a/crypto/ahash.c
+++ b/crypto/ahash.c
@@ -44,8 +44,8 @@ static int hash_walk_next(struct crypto_hash_walk *walk)
 {
 	unsigned int alignmask = walk->alignmask;
 	unsigned int offset = walk->offset;
-	unsigned int nbytes = min(walk->entrylen,
-				  ((unsigned int)(PAGE_SIZE)) - offset);
+	unsigned int nbytes = min_t(unsigned int, walk->entrylen,
+				    offset_in_page(~offset) + 1);
 
 	if (walk->flags & CRYPTO_ALG_ASYNC)
 		walk->data = kmap(walk->pg);
@@ -91,8 +91,8 @@ int crypto_hash_walk_done(struct crypto_hash_walk *walk, int err)
 		walk->offset = ALIGN(walk->offset, alignmask + 1);
 		walk->data += walk->offset;
 
-		nbytes = min(nbytes,
-			     ((unsigned int)(PAGE_SIZE)) - walk->offset);
+		nbytes = min_t(unsigned int, nbytes,
+			       offset_in_page(~walk->offset) + 1);
 		walk->entrylen -= nbytes;
 
 		return nbytes;
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
