From: Ondrej Mosnacek <omosnacek@gmail.com>
Subject: [PATCH v5 2/4] crypto: gf128mul - switch gf128mul_x_ble to le128
Date: Sun,  2 Apr 2017 21:19:14 +0200
Message-ID: <20170402191916.9309-3-omosnacek@gmail.com>
References: <20170402191916.9309-1-omosnacek@gmail.com>
Cc: Ondrej Mosnacek <omosnacek@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org, Eric Biggers <ebiggers@google.com>,
        Milan Broz <gmazyland@gmail.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wr0-f193.google.com ([209.85.128.193]:33671 "EHLO
        mail-wr0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751608AbdDBTUe (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 2 Apr 2017 15:20:34 -0400
Received: by mail-wr0-f193.google.com with SMTP id u18so28216289wrc.0
        for <linux-crypto@vger.kernel.org>; Sun, 02 Apr 2017 12:20:33 -0700 (PDT)
In-Reply-To: <20170402191916.9309-1-omosnacek@gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Currently, gf128mul_x_ble works with pointers to be128, even though it
actually interprets the words as little-endian. Consequently, it uses
cpu_to_le64/le64_to_cpu on fields of type __be64, which is incorrect.

This patch fixes that by changing the function to accept pointers to
le128 and updating all users accordingly.

Signed-off-by: Ondrej Mosnacek <omosnacek@gmail.com>
---
 arch/x86/crypto/camellia_glue.c     |  4 ++--
 arch/x86/crypto/serpent_sse2_glue.c |  4 ++--
 arch/x86/crypto/twofish_glue_3way.c |  4 ++--
 crypto/xts.c                        | 38 ++++++++++++++++++-------------------
 include/crypto/gf128mul.h           |  8 ++++----
 include/crypto/xts.h                |  2 +-
 6 files changed, 30 insertions(+), 30 deletions(-)

diff --git a/arch/x86/crypto/camellia_glue.c b/arch/x86/crypto/camellia_glue.c
index aa76cad..af4840a 100644
--- a/arch/x86/crypto/camellia_glue.c
+++ b/arch/x86/crypto/camellia_glue.c
@@ -1522,7 +1522,7 @@ static int xts_encrypt(struct blkcipher_desc *desc, struct scatterlist *dst,
 		       struct scatterlist *src, unsigned int nbytes)
 {
 	struct camellia_xts_ctx *ctx = crypto_blkcipher_ctx(desc->tfm);
-	be128 buf[2 * 4];
+	le128 buf[2 * 4];
 	struct xts_crypt_req req = {
 		.tbuf = buf,
 		.tbuflen = sizeof(buf),
@@ -1540,7 +1540,7 @@ static int xts_decrypt(struct blkcipher_desc *desc, struct scatterlist *dst,
 		       struct scatterlist *src, unsigned int nbytes)
 {
 	struct camellia_xts_ctx *ctx = crypto_blkcipher_ctx(desc->tfm);
-	be128 buf[2 * 4];
+	le128 buf[2 * 4];
 	struct xts_crypt_req req = {
 		.tbuf = buf,
 		.tbuflen = sizeof(buf),
diff --git a/arch/x86/crypto/serpent_sse2_glue.c b/arch/x86/crypto/serpent_sse2_glue.c
index 644f97a..ac0e831 100644
--- a/arch/x86/crypto/serpent_sse2_glue.c
+++ b/arch/x86/crypto/serpent_sse2_glue.c
@@ -328,7 +328,7 @@ static int xts_encrypt(struct blkcipher_desc *desc, struct scatterlist *dst,
 		       struct scatterlist *src, unsigned int nbytes)
 {
 	struct serpent_xts_ctx *ctx = crypto_blkcipher_ctx(desc->tfm);
-	be128 buf[SERPENT_PARALLEL_BLOCKS];
+	le128 buf[SERPENT_PARALLEL_BLOCKS];
 	struct crypt_priv crypt_ctx = {
 		.ctx = &ctx->crypt_ctx,
 		.fpu_enabled = false,
@@ -355,7 +355,7 @@ static int xts_decrypt(struct blkcipher_desc *desc, struct scatterlist *dst,
 		       struct scatterlist *src, unsigned int nbytes)
 {
 	struct serpent_xts_ctx *ctx = crypto_blkcipher_ctx(desc->tfm);
-	be128 buf[SERPENT_PARALLEL_BLOCKS];
+	le128 buf[SERPENT_PARALLEL_BLOCKS];
 	struct crypt_priv crypt_ctx = {
 		.ctx = &ctx->crypt_ctx,
 		.fpu_enabled = false,
diff --git a/arch/x86/crypto/twofish_glue_3way.c b/arch/x86/crypto/twofish_glue_3way.c
index 2ebb5e9..243e90a 100644
--- a/arch/x86/crypto/twofish_glue_3way.c
+++ b/arch/x86/crypto/twofish_glue_3way.c
@@ -296,7 +296,7 @@ static int xts_encrypt(struct blkcipher_desc *desc, struct scatterlist *dst,
 		       struct scatterlist *src, unsigned int nbytes)
 {
 	struct twofish_xts_ctx *ctx = crypto_blkcipher_ctx(desc->tfm);
-	be128 buf[3];
+	le128 buf[3];
 	struct xts_crypt_req req = {
 		.tbuf = buf,
 		.tbuflen = sizeof(buf),
@@ -314,7 +314,7 @@ static int xts_decrypt(struct blkcipher_desc *desc, struct scatterlist *dst,
 		       struct scatterlist *src, unsigned int nbytes)
 {
 	struct twofish_xts_ctx *ctx = crypto_blkcipher_ctx(desc->tfm);
-	be128 buf[3];
+	le128 buf[3];
 	struct xts_crypt_req req = {
 		.tbuf = buf,
 		.tbuflen = sizeof(buf),
diff --git a/crypto/xts.c b/crypto/xts.c
index baeb34d..bd5065c 100644
--- a/crypto/xts.c
+++ b/crypto/xts.c
@@ -39,11 +39,11 @@ struct xts_instance_ctx {
 };
 
 struct rctx {
-	be128 buf[XTS_BUFFER_SIZE / sizeof(be128)];
+	le128 buf[XTS_BUFFER_SIZE / sizeof(le128)];
 
-	be128 t;
+	le128 t;
 
-	be128 *ext;
+	le128 *ext;
 
 	struct scatterlist srcbuf[2];
 	struct scatterlist dstbuf[2];
@@ -99,7 +99,7 @@ static int setkey(struct crypto_skcipher *parent, const u8 *key,
 static int post_crypt(struct skcipher_request *req)
 {
 	struct rctx *rctx = skcipher_request_ctx(req);
-	be128 *buf = rctx->ext ?: rctx->buf;
+	le128 *buf = rctx->ext ?: rctx->buf;
 	struct skcipher_request *subreq;
 	const int bs = XTS_BLOCK_SIZE;
 	struct skcipher_walk w;
@@ -112,12 +112,12 @@ static int post_crypt(struct skcipher_request *req)
 
 	while (w.nbytes) {
 		unsigned int avail = w.nbytes;
-		be128 *wdst;
+		le128 *wdst;
 
 		wdst = w.dst.virt.addr;
 
 		do {
-			be128_xor(wdst, buf++, wdst);
+			le128_xor(wdst, buf++, wdst);
 			wdst++;
 		} while ((avail -= bs) >= bs);
 
@@ -150,7 +150,7 @@ static int post_crypt(struct skcipher_request *req)
 static int pre_crypt(struct skcipher_request *req)
 {
 	struct rctx *rctx = skcipher_request_ctx(req);
-	be128 *buf = rctx->ext ?: rctx->buf;
+	le128 *buf = rctx->ext ?: rctx->buf;
 	struct skcipher_request *subreq;
 	const int bs = XTS_BLOCK_SIZE;
 	struct skcipher_walk w;
@@ -174,15 +174,15 @@ static int pre_crypt(struct skcipher_request *req)
 
 	while (w.nbytes) {
 		unsigned int avail = w.nbytes;
-		be128 *wsrc;
-		be128 *wdst;
+		le128 *wsrc;
+		le128 *wdst;
 
 		wsrc = w.src.virt.addr;
 		wdst = w.dst.virt.addr;
 
 		do {
 			*buf++ = rctx->t;
-			be128_xor(wdst++, &rctx->t, wsrc++);
+			le128_xor(wdst++, &rctx->t, wsrc++);
 			gf128mul_x_ble(&rctx->t, &rctx->t);
 		} while ((avail -= bs) >= bs);
 
@@ -350,8 +350,8 @@ int xts_crypt(struct blkcipher_desc *desc, struct scatterlist *sdst,
 	const unsigned int max_blks = req->tbuflen / bsize;
 	struct blkcipher_walk walk;
 	unsigned int nblocks;
-	be128 *src, *dst, *t;
-	be128 *t_buf = req->tbuf;
+	le128 *src, *dst, *t;
+	le128 *t_buf = req->tbuf;
 	int err, i;
 
 	BUG_ON(max_blks < 1);
@@ -364,8 +364,8 @@ int xts_crypt(struct blkcipher_desc *desc, struct scatterlist *sdst,
 		return err;
 
 	nblocks = min(nbytes / bsize, max_blks);
-	src = (be128 *)walk.src.virt.addr;
-	dst = (be128 *)walk.dst.virt.addr;
+	src = (le128 *)walk.src.virt.addr;
+	dst = (le128 *)walk.dst.virt.addr;
 
 	/* calculate first value of T */
 	req->tweak_fn(req->tweak_ctx, (u8 *)&t_buf[0], walk.iv);
@@ -381,7 +381,7 @@ int xts_crypt(struct blkcipher_desc *desc, struct scatterlist *sdst,
 				t = &t_buf[i];
 
 				/* PP <- T xor P */
-				be128_xor(dst + i, t, src + i);
+				le128_xor(dst + i, t, src + i);
 			}
 
 			/* CC <- E(Key2,PP) */
@@ -390,7 +390,7 @@ int xts_crypt(struct blkcipher_desc *desc, struct scatterlist *sdst,
 
 			/* C <- T xor CC */
 			for (i = 0; i < nblocks; i++)
-				be128_xor(dst + i, dst + i, &t_buf[i]);
+				le128_xor(dst + i, dst + i, &t_buf[i]);
 
 			src += nblocks;
 			dst += nblocks;
@@ -398,7 +398,7 @@ int xts_crypt(struct blkcipher_desc *desc, struct scatterlist *sdst,
 			nblocks = min(nbytes / bsize, max_blks);
 		} while (nblocks > 0);
 
-		*(be128 *)walk.iv = *t;
+		*(le128 *)walk.iv = *t;
 
 		err = blkcipher_walk_done(desc, &walk, nbytes);
 		nbytes = walk.nbytes;
@@ -406,8 +406,8 @@ int xts_crypt(struct blkcipher_desc *desc, struct scatterlist *sdst,
 			break;
 
 		nblocks = min(nbytes / bsize, max_blks);
-		src = (be128 *)walk.src.virt.addr;
-		dst = (be128 *)walk.dst.virt.addr;
+		src = (le128 *)walk.src.virt.addr;
+		dst = (le128 *)walk.dst.virt.addr;
 	}
 
 	return err;
diff --git a/include/crypto/gf128mul.h b/include/crypto/gf128mul.h
index 35ced9d..0977fb1 100644
--- a/include/crypto/gf128mul.h
+++ b/include/crypto/gf128mul.h
@@ -205,16 +205,16 @@ static inline void gf128mul_x_bbe(be128 *r, const be128 *x)
 }
 
 /* needed by XTS */
-static inline void gf128mul_x_ble(be128 *r, const be128 *x)
+static inline void gf128mul_x_ble(le128 *r, const le128 *x)
 {
 	u64 a = le64_to_cpu(x->a);
 	u64 b = le64_to_cpu(x->b);
 
 	/* equivalent to gf128mul_table_be[b >> 63] (see crypto/gf128mul.c): */
-	u64 _tt = gf128mul_mask_from_bit(b, 63) & 0x87;
+	u64 _tt = gf128mul_mask_from_bit(a, 63) & 0x87;
 
-	r->a = cpu_to_le64((a << 1) ^ _tt);
-	r->b = cpu_to_le64((b << 1) | (a >> 63));
+	r->a = cpu_to_le64((a << 1) | (b >> 63));
+	r->b = cpu_to_le64((b << 1) ^ _tt);
 }
 
 /* 4k table optimization */
diff --git a/include/crypto/xts.h b/include/crypto/xts.h
index 77b6306..c0bde30 100644
--- a/include/crypto/xts.h
+++ b/include/crypto/xts.h
@@ -11,7 +11,7 @@ struct blkcipher_desc;
 #define XTS_BLOCK_SIZE 16
 
 struct xts_crypt_req {
-	be128 *tbuf;
+	le128 *tbuf;
 	unsigned int tbuflen;
 
 	void *tweak_ctx;
-- 
2.9.3
