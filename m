Return-Path: <SRS0=7iXC=W6=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 401BFC3A5A5
	for <linux-crypto@archiver.kernel.org>; Tue,  3 Sep 2019 07:05:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2042B2339D
	for <linux-crypto@archiver.kernel.org>; Tue,  3 Sep 2019 07:05:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726473AbfICHFF (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 3 Sep 2019 03:05:05 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:60012 "EHLO fornost.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726062AbfICHFF (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 3 Sep 2019 03:05:05 -0400
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.0.7])
        by fornost.hmeau.com with smtp (Exim 4.89 #2 (Debian))
        id 1i52sA-0002p4-1b; Tue, 03 Sep 2019 17:05:03 +1000
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Tue, 03 Sep 2019 17:05:01 +1000
Date:   Tue, 3 Sep 2019 17:05:01 +1000
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc:     "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" 
        <linux-crypto@vger.kernel.org>, Eric Biggers <ebiggers@kernel.org>
Subject: crypto: ablkcipher - Unmap pages after an external error
Message-ID: <20190903070501.GA9978@gondor.apana.org.au>
References: <20190821143253.30209-1-ard.biesheuvel@linaro.org>
 <20190821143253.30209-9-ard.biesheuvel@linaro.org>
 <20190830080347.GA6677@gondor.apana.org.au>
 <CAKv+Gu-4QBvPcE7YUqgWbT31gdLM8vcHTPbdOCN+UnUMXreuPg@mail.gmail.com>
 <20190903065438.GA9372@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190903065438.GA9372@gondor.apana.org.au>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

ablkcipher_walk_done may be called with an error by internal or
external callers.  For those internal callers we shouldn't unmap
pages but for external callers we must unmap any pages that are
in use.

This patch adds a new function ablkcipher_walk_unwind so that we
can eliminate the internal callers.

Reported-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Fixes: 318abdfbe708 ("crypto: ablkcipher - fix crash flushing...")
Cc: <stable@vger.kernel.org>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

diff --git a/crypto/ablkcipher.c b/crypto/ablkcipher.c
index 072b5646a0a3..a61d13fabe3c 100644
--- a/crypto/ablkcipher.c
+++ b/crypto/ablkcipher.c
@@ -66,9 +66,11 @@ static inline u8 *ablkcipher_get_spot(u8 *start, unsigned int len)
 	return max(start, end_page);
 }
 
-static inline void ablkcipher_done_slow(struct ablkcipher_walk *walk,
-					unsigned int n)
+static inline unsigned int ablkcipher_done_slow(struct ablkcipher_walk *walk,
+						unsigned int bsize)
 {
+	unsigned int n = bsize;
+
 	for (;;) {
 		unsigned int len_this_page = scatterwalk_pagelen(&walk->out);
 
@@ -80,59 +82,73 @@ static inline void ablkcipher_done_slow(struct ablkcipher_walk *walk,
 		n -= len_this_page;
 		scatterwalk_start(&walk->out, sg_next(walk->out.sg));
 	}
+
+	return bsize;
 }
 
-static inline void ablkcipher_done_fast(struct ablkcipher_walk *walk,
-					unsigned int n)
+static inline unsigned int ablkcipher_done_fast(struct ablkcipher_walk *walk,
+						unsigned int n)
 {
 	scatterwalk_advance(&walk->in, n);
 	scatterwalk_advance(&walk->out, n);
+
+	return n;
 }
 
+static int ablkcipher_walk_unwind(struct ablkcipher_request *req,
+				  struct ablkcipher_walk *walk, int err);
 static int ablkcipher_walk_next(struct ablkcipher_request *req,
 				struct ablkcipher_walk *walk);
 
 int ablkcipher_walk_done(struct ablkcipher_request *req,
 			 struct ablkcipher_walk *walk, int err)
 {
-	struct crypto_tfm *tfm = req->base.tfm;
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
 
-	if (likely(!(walk->flags & ABLKCIPHER_WALK_SLOW))) {
-		ablkcipher_done_fast(walk, n);
-	} else {
-		if (WARN_ON(err)) {
-			/* unexpected case; didn't process all bytes */
+		if (likely(!(walk->flags & ABLKCIPHER_WALK_SLOW)))
+			n = ablkcipher_done_fast(walk, n);
+		else if (WARN_ON(err)) {
 			err = -EINVAL;
-			goto finish;
-		}
-		ablkcipher_done_slow(walk, n);
+			goto err;
+		} else
+			n = ablkcipher_done_slow(walk, n);
+
+		nbytes = walk->total - n;
+		err = 0;
 	}
 
-	scatterwalk_done(&walk->in, 0, more);
-	scatterwalk_done(&walk->out, 1, more);
+	scatterwalk_done(&walk->in, 0, nbytes);
+	scatterwalk_done(&walk->out, 1, nbytes);
+
+err:
+	walk->total = nbytes;
+	walk->nbytes = nbytes;
 
-	if (more) {
+	if (nbytes) {
 		crypto_yield(req->base.flags);
 		return ablkcipher_walk_next(req, walk);
 	}
-	err = 0;
-finish:
+
+	return ablkcipher_walk_unwind(req, walk, err);
+}
+EXPORT_SYMBOL_GPL(ablkcipher_walk_done);
+
+static int ablkcipher_walk_unwind(struct ablkcipher_request *req,
+				  struct ablkcipher_walk *walk, int err)
+{
+	struct crypto_tfm *tfm = req->base.tfm;
+
 	walk->nbytes = 0;
+
 	if (walk->iv != req->info)
 		memcpy(req->info, walk->iv, tfm->crt_ablkcipher.ivsize);
 	kfree(walk->iv_buffer);
+
 	return err;
 }
-EXPORT_SYMBOL_GPL(ablkcipher_walk_done);
 
 static inline int ablkcipher_next_slow(struct ablkcipher_request *req,
 				       struct ablkcipher_walk *walk,
@@ -151,7 +167,7 @@ static inline int ablkcipher_next_slow(struct ablkcipher_request *req,
 
 	p = kmalloc(n, GFP_ATOMIC);
 	if (!p)
-		return ablkcipher_walk_done(req, walk, -ENOMEM);
+		return ablkcipher_walk_unwind(req, walk, -ENOMEM);
 
 	base = p + 1;
 
@@ -222,7 +238,7 @@ static int ablkcipher_walk_next(struct ablkcipher_request *req,
 	n = walk->total;
 	if (unlikely(n < crypto_tfm_alg_blocksize(tfm))) {
 		req->base.flags |= CRYPTO_TFM_RES_BAD_BLOCK_LEN;
-		return ablkcipher_walk_done(req, walk, -EINVAL);
+		return ablkcipher_walk_unwind(req, walk, -EINVAL);
 	}
 
 	walk->flags &= ~ABLKCIPHER_WALK_SLOW;
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
