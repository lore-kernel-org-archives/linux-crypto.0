Return-Path: <SRS0=7iXC=W6=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 76B21C3A5A5
	for <linux-crypto@archiver.kernel.org>; Tue,  3 Sep 2019 06:54:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 550CE217D7
	for <linux-crypto@archiver.kernel.org>; Tue,  3 Sep 2019 06:54:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726062AbfICGyo (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 3 Sep 2019 02:54:44 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:60002 "EHLO fornost.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726053AbfICGyo (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 3 Sep 2019 02:54:44 -0400
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.0.7])
        by fornost.hmeau.com with smtp (Exim 4.89 #2 (Debian))
        id 1i52i8-0002Xb-5G; Tue, 03 Sep 2019 16:54:41 +1000
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Tue, 03 Sep 2019 16:54:38 +1000
Date:   Tue, 3 Sep 2019 16:54:38 +1000
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc:     "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" 
        <linux-crypto@vger.kernel.org>, Eric Biggers <ebiggers@kernel.org>
Subject: crypto: skcipher - Unmap pages after an external error
Message-ID: <20190903065438.GA9372@gondor.apana.org.au>
References: <20190821143253.30209-1-ard.biesheuvel@linaro.org>
 <20190821143253.30209-9-ard.biesheuvel@linaro.org>
 <20190830080347.GA6677@gondor.apana.org.au>
 <CAKv+Gu-4QBvPcE7YUqgWbT31gdLM8vcHTPbdOCN+UnUMXreuPg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKv+Gu-4QBvPcE7YUqgWbT31gdLM8vcHTPbdOCN+UnUMXreuPg@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Sat, Aug 31, 2019 at 09:01:33PM +0300, Ard Biesheuvel wrote:
>
> This might be a problem with the implementation of
> skcipher_walk_done() in general rather than a limitation in this
> particular case, but when calling skcipher_walk_done() with a negative
> err value, we never kunmap the src and dst pages. So should I propose
> a fix for that instead? Or are the internal callers dealing with this
> correctly? (and is it forbidden for external callers to pass negative
> values?)

Thanks for pointing this out.  This is in fact a bug introduced
by the bug fix:

commit 8088d3dd4d7c6933a65aa169393b5d88d8065672
Author: Eric Biggers <ebiggers@google.com>
Date:   Mon Jul 23 10:54:56 2018 -0700

    crypto: skcipher - fix crash flushing dcache in error path

In particular it fails to distinguish between errors arising from
internal callers where we shouldn't unmap vs. external callers
where unmapping is absolutely required.

So I'm going to revert that patch and fix it like this:

---8<---
skcipher_walk_done may be called with an error by internal or
external callers.  For those internal callers we shouldn't unmap
pages but for external callers we must unmap any pages that are
in use.

This patch adds a new function skcipher_walk_unwind so that we
can eliminate the internal callers.

Reported-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Fixes: 8088d3dd4d7c ("crypto: skcipher - fix crash flushing...")
Cc: <stable@vger.kernel.org>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

diff --git a/crypto/skcipher.c b/crypto/skcipher.c
index 5d836fc3df3e..eb3eb38a28b2 100644
--- a/crypto/skcipher.c
+++ b/crypto/skcipher.c
@@ -39,6 +39,7 @@ struct skcipher_walk_buffer {
 	u8 buffer[];
 };
 
+static int skcipher_walk_unwind(struct skcipher_walk *walk, int err);
 static int skcipher_walk_next(struct skcipher_walk *walk);
 
 static inline void skcipher_unmap(struct scatter_walk *walk, void *vaddr)
@@ -90,7 +91,7 @@ static inline u8 *skcipher_get_spot(u8 *start, unsigned int len)
 	return max(start, end_page);
 }
 
-static void skcipher_done_slow(struct skcipher_walk *walk, unsigned int bsize)
+static int skcipher_done_slow(struct skcipher_walk *walk, unsigned int bsize)
 {
 	u8 *addr;
 
@@ -98,24 +99,23 @@ static void skcipher_done_slow(struct skcipher_walk *walk, unsigned int bsize)
 	addr = skcipher_get_spot(addr, bsize);
 	scatterwalk_copychunks(addr, &walk->out, bsize,
 			       (walk->flags & SKCIPHER_WALK_PHYS) ? 2 : 1);
+	return 0;
 }
 
 int skcipher_walk_done(struct skcipher_walk *walk, int err)
 {
-	unsigned int n; /* bytes processed */
-	bool more;
-
-	if (unlikely(err < 0))
-		goto finish;
+	unsigned int n = walk->nbytes - err;
+	unsigned int nbytes;
 
-	n = walk->nbytes - err;
-	walk->total -= n;
-	more = (walk->total != 0);
+	nbytes = walk->total - n;
 
-	if (likely(!(walk->flags & (SKCIPHER_WALK_PHYS |
-				    SKCIPHER_WALK_SLOW |
-				    SKCIPHER_WALK_COPY |
-				    SKCIPHER_WALK_DIFF)))) {
+	if (unlikely(err < 0)) {
+		nbytes = 0;
+		n = 0;
+	} else if (likely(!(walk->flags & (SKCIPHER_WALK_PHYS |
+					   SKCIPHER_WALK_SLOW |
+					   SKCIPHER_WALK_COPY |
+					   SKCIPHER_WALK_DIFF)))) {
 unmap_src:
 		skcipher_unmap_src(walk);
 	} else if (walk->flags & SKCIPHER_WALK_DIFF) {
@@ -134,25 +134,34 @@ int skcipher_walk_done(struct skcipher_walk *walk, int err)
 			 * the algorithm requires it.
 			 */
 			err = -EINVAL;
-			goto finish;
-		}
-		skcipher_done_slow(walk, n);
-		goto already_advanced;
+			nbytes = 0;
+		} else
+			n = skcipher_done_slow(walk, n);
 	}
 
+	if (err > 0)
+		err = 0;
+
+	walk->total = nbytes;
+	walk->nbytes = nbytes;
+
 	scatterwalk_advance(&walk->in, n);
 	scatterwalk_advance(&walk->out, n);
-already_advanced:
-	scatterwalk_done(&walk->in, 0, more);
-	scatterwalk_done(&walk->out, 1, more);
+	scatterwalk_done(&walk->in, 0, nbytes);
+	scatterwalk_done(&walk->out, 1, nbytes);
 
-	if (more) {
+	if (nbytes) {
 		crypto_yield(walk->flags & SKCIPHER_WALK_SLEEP ?
 			     CRYPTO_TFM_REQ_MAY_SLEEP : 0);
 		return skcipher_walk_next(walk);
 	}
-	err = 0;
-finish:
+
+	return skcipher_walk_unwind(walk, err);
+}
+EXPORT_SYMBOL_GPL(skcipher_walk_done);
+
+static int skcipher_walk_unwind(struct skcipher_walk *walk, int err)
+{
 	walk->nbytes = 0;
 
 	/* Short-circuit for the common/fast path. */
@@ -172,7 +181,6 @@ int skcipher_walk_done(struct skcipher_walk *walk, int err)
 out:
 	return err;
 }
-EXPORT_SYMBOL_GPL(skcipher_walk_done);
 
 void skcipher_walk_complete(struct skcipher_walk *walk, int err)
 {
@@ -253,7 +261,7 @@ static int skcipher_next_slow(struct skcipher_walk *walk, unsigned int bsize)
 
 	v = kzalloc(n, skcipher_walk_gfp(walk));
 	if (!v)
-		return skcipher_walk_done(walk, -ENOMEM);
+		return skcipher_walk_unwind(walk, -ENOMEM);
 
 	if (phys) {
 		p = v;
@@ -352,7 +360,7 @@ static int skcipher_walk_next(struct skcipher_walk *walk)
 
 	if (unlikely(n < bsize)) {
 		if (unlikely(walk->total < walk->blocksize))
-			return skcipher_walk_done(walk, -EINVAL);
+			return skcipher_walk_unwind(walk, -EINVAL);
 
 slow_path:
 		err = skcipher_next_slow(walk, bsize);
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
