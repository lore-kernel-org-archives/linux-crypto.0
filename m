Return-Path: <SRS0=7iXC=W6=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F34C6C3A5A5
	for <linux-crypto@archiver.kernel.org>; Tue,  3 Sep 2019 07:09:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D1A21206B8
	for <linux-crypto@archiver.kernel.org>; Tue,  3 Sep 2019 07:09:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726200AbfICHJY (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 3 Sep 2019 03:09:24 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:60020 "EHLO fornost.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726053AbfICHJY (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 3 Sep 2019 03:09:24 -0400
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.0.7])
        by fornost.hmeau.com with smtp (Exim 4.89 #2 (Debian))
        id 1i52wK-0002sR-4v; Tue, 03 Sep 2019 17:09:21 +1000
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Tue, 03 Sep 2019 17:09:19 +1000
Date:   Tue, 3 Sep 2019 17:09:19 +1000
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc:     "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" 
        <linux-crypto@vger.kernel.org>, Eric Biggers <ebiggers@kernel.org>
Subject: crypto: blkcipher - Unmap pages after an external error
Message-ID: <20190903070919.GA10892@gondor.apana.org.au>
References: <20190821143253.30209-1-ard.biesheuvel@linaro.org>
 <20190821143253.30209-9-ard.biesheuvel@linaro.org>
 <20190830080347.GA6677@gondor.apana.org.au>
 <CAKv+Gu-4QBvPcE7YUqgWbT31gdLM8vcHTPbdOCN+UnUMXreuPg@mail.gmail.com>
 <20190903065438.GA9372@gondor.apana.org.au>
 <20190903070501.GA9978@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190903070501.GA9978@gondor.apana.org.au>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

blkcipher_walk_done may be called with an error by internal or
external callers.  For those internal callers we shouldn't unmap
pages but for external callers we must unmap any pages that are
in use.

This patch adds a new function blkcipher_walk_unwind so that we
can eliminate the internal callers.

Reported-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Fixes: 0868def3e410 ("crypto: blkcipher - fix crash flushing...")
Cc: <stable@vger.kernel.org>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

diff --git a/crypto/blkcipher.c b/crypto/blkcipher.c
index 48a33817de11..eafed44cafdd 100644
--- a/crypto/blkcipher.c
+++ b/crypto/blkcipher.c
@@ -31,6 +31,8 @@ enum {
 	BLKCIPHER_WALK_DIFF = 1 << 3,
 };
 
+static int blkcipher_walk_unwind(struct blkcipher_desc *desc,
+				 struct blkcipher_walk *walk, int err);
 static int blkcipher_walk_next(struct blkcipher_desc *desc,
 			       struct blkcipher_walk *walk);
 static int blkcipher_walk_first(struct blkcipher_desc *desc,
@@ -65,18 +67,19 @@ static inline u8 *blkcipher_get_spot(u8 *start, unsigned int len)
 	return max(start, end_page);
 }
 
-static inline void blkcipher_done_slow(struct blkcipher_walk *walk,
-				       unsigned int bsize)
+static inline unsigned int blkcipher_done_slow(struct blkcipher_walk *walk,
+					       unsigned int bsize)
 {
 	u8 *addr;
 
 	addr = (u8 *)ALIGN((unsigned long)walk->buffer, walk->alignmask + 1);
 	addr = blkcipher_get_spot(addr, bsize);
 	scatterwalk_copychunks(addr, &walk->out, bsize, 1);
+	return bsize;
 }
 
-static inline void blkcipher_done_fast(struct blkcipher_walk *walk,
-				       unsigned int n)
+static inline unsigned int blkcipher_done_fast(struct blkcipher_walk *walk,
+					       unsigned int n)
 {
 	if (walk->flags & BLKCIPHER_WALK_COPY) {
 		blkcipher_map_dst(walk);
@@ -90,51 +93,60 @@ static inline void blkcipher_done_fast(struct blkcipher_walk *walk,
 
 	scatterwalk_advance(&walk->in, n);
 	scatterwalk_advance(&walk->out, n);
+
+	return n;
 }
 
 int blkcipher_walk_done(struct blkcipher_desc *desc,
 			struct blkcipher_walk *walk, int err)
 {
-	unsigned int n; /* bytes processed */
-	bool more;
-
-	if (unlikely(err < 0))
-		goto finish;
+	unsigned int nbytes = 0;
 
-	n = walk->nbytes - err;
-	walk->total -= n;
-	more = (walk->total != 0);
+	if (likely(err >= 0)) {
+		unsigned int n = walk->nbytes - err;
 
-	if (likely(!(walk->flags & BLKCIPHER_WALK_SLOW))) {
-		blkcipher_done_fast(walk, n);
-	} else {
-		if (WARN_ON(err)) {
-			/* unexpected case; didn't process all bytes */
+		if (likely(!(walk->flags & BLKCIPHER_WALK_SLOW)))
+			n = blkcipher_done_fast(walk, n);
+		else if (WARN_ON(err)) {
 			err = -EINVAL;
-			goto finish;
-		}
-		blkcipher_done_slow(walk, n);
+			goto err;
+		} else
+			n = blkcipher_done_slow(walk, n);
+
+		nbytes = walk->total - n;
+		err = 0;
 	}
 
-	scatterwalk_done(&walk->in, 0, more);
-	scatterwalk_done(&walk->out, 1, more);
+	scatterwalk_done(&walk->in, 0, nbytes);
+	scatterwalk_done(&walk->out, 1, nbytes);
 
-	if (more) {
+err:
+	walk->total = nbytes;
+	walk->nbytes = nbytes;
+
+	if (nbytes) {
 		crypto_yield(desc->flags);
 		return blkcipher_walk_next(desc, walk);
 	}
-	err = 0;
-finish:
+
+	return blkcipher_walk_unwind(desc, walk, err);
+}
+EXPORT_SYMBOL_GPL(blkcipher_walk_done);
+
+static int blkcipher_walk_unwind(struct blkcipher_desc *desc,
+				 struct blkcipher_walk *walk, int err)
+{
 	walk->nbytes = 0;
+
 	if (walk->iv != desc->info)
 		memcpy(desc->info, walk->iv, walk->ivsize);
 	if (walk->buffer != walk->page)
 		kfree(walk->buffer);
 	if (walk->page)
 		free_page((unsigned long)walk->page);
+
 	return err;
 }
-EXPORT_SYMBOL_GPL(blkcipher_walk_done);
 
 static inline int blkcipher_next_slow(struct blkcipher_desc *desc,
 				      struct blkcipher_walk *walk,
@@ -155,7 +167,7 @@ static inline int blkcipher_next_slow(struct blkcipher_desc *desc,
 	    (alignmask & ~(crypto_tfm_ctx_alignment() - 1));
 	walk->buffer = kmalloc(n, GFP_ATOMIC);
 	if (!walk->buffer)
-		return blkcipher_walk_done(desc, walk, -ENOMEM);
+		return blkcipher_walk_unwind(desc, walk, -ENOMEM);
 
 ok:
 	walk->dst.virt.addr = (u8 *)ALIGN((unsigned long)walk->buffer,
@@ -223,7 +235,7 @@ static int blkcipher_walk_next(struct blkcipher_desc *desc,
 	n = walk->total;
 	if (unlikely(n < walk->cipher_blocksize)) {
 		desc->flags |= CRYPTO_TFM_RES_BAD_BLOCK_LEN;
-		return blkcipher_walk_done(desc, walk, -EINVAL);
+		return blkcipher_walk_unwind(desc, walk, -EINVAL);
 	}
 
 	bsize = min(walk->walk_blocksize, n);
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
