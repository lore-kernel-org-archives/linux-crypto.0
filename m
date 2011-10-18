From: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
Subject: [PATCH 04/18] crypto: lrw: add interface for parallelized cipher
	implementions
Date: Tue, 18 Oct 2011 13:32:29 +0300
Message-ID: <20111018103229.3074.96263.stgit@localhost6.localdomain6>
References: <20111018103208.3074.11546.stgit@localhost6.localdomain6>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from sd-mail-sa-01.sanoma.fi ([158.127.18.161]:53800 "EHLO
	sd-mail-sa-01.sanoma.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754405Ab1JRKcc (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 18 Oct 2011 06:32:32 -0400
In-Reply-To: <20111018103208.3074.11546.stgit@localhost6.localdomain6>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Export gf128mul table initialization routines and add lrw_crypt() function
that can be used by cipher implementations that can benefit from parallelized
cipher operations.

Signed-off-by: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
---
 crypto/lrw.c         |  105 ++++++++++++++++++++++++++++++++++++++++----------
 include/crypto/lrw.h |   43 ++++++++++++++++++++
 2 files changed, 128 insertions(+), 20 deletions(-)
 create mode 100644 include/crypto/lrw.h

diff --git a/crypto/lrw.c b/crypto/lrw.c
index 91c17fa..66c4d22 100644
--- a/crypto/lrw.c
+++ b/crypto/lrw.c
@@ -3,7 +3,7 @@
  *
  * Copyright (c) 2006 Rik Snel <rsnel@cube.dyndns.org>
  *
- * Based om ecb.c
+ * Based on ecb.c
  * Copyright (c) 2006 Herbert Xu <herbert@gondor.apana.org.au>
  *
  * This program is free software; you can redistribute it and/or modify it
@@ -16,6 +16,7 @@
  * http://www.mail-archive.com/stds-p1619@listserv.ieee.org/msg00173.html
  *
  * The test vectors are included in the testing module tcrypt.[ch] */
+
 #include <crypto/algapi.h>
 #include <linux/err.h>
 #include <linux/init.h>
@@ -26,23 +27,7 @@
 
 #include <crypto/b128ops.h>
 #include <crypto/gf128mul.h>
-
-#define LRW_BLOCK_SIZE 16
-
-struct lrw_table_ctx {
-	/* optimizes multiplying a random (non incrementing, as at the
-	 * start of a new sector) value with key2, we could also have
-	 * used 4k optimization tables or no optimization at all. In the
-	 * latter case we would have to store key2 here */
-	struct gf128mul_64k *table;
-	/* stores:
-	 *  key2*{ 0,0,...0,0,0,0,1 }, key2*{ 0,0,...0,0,0,1,1 },
-	 *  key2*{ 0,0,...0,0,1,1,1 }, key2*{ 0,0,...0,1,1,1,1 }
-	 *  key2*{ 0,0,...1,1,1,1,1 }, etc
-	 * needed for optimized multiplication of incrementing values
-	 * with key2 */
-	be128 mulinc[128];
-};
+#include <crypto/lrw.h>
 
 struct priv {
 	struct crypto_cipher *child;
@@ -60,7 +45,7 @@ static inline void setbit128_bbe(void *b, int bit)
 			), b);
 }
 
-static int lrw_init_table(struct lrw_table_ctx *ctx, const u8 *tweak)
+int lrw_init_table(struct lrw_table_ctx *ctx, const u8 *tweak)
 {
 	be128 tmp = { 0 };
 	int i;
@@ -82,12 +67,14 @@ static int lrw_init_table(struct lrw_table_ctx *ctx, const u8 *tweak)
 
 	return 0;
 }
+EXPORT_SYMBOL_GPL(lrw_init_table);
 
-static void lrw_free_table(struct lrw_table_ctx *ctx)
+void lrw_free_table(struct lrw_table_ctx *ctx)
 {
 	if (ctx->table)
 		gf128mul_free_64k(ctx->table);
 }
+EXPORT_SYMBOL_GPL(lrw_free_table);
 
 static int setkey(struct crypto_tfm *parent, const u8 *key,
 		  unsigned int keylen)
@@ -227,6 +214,84 @@ static int decrypt(struct blkcipher_desc *desc, struct scatterlist *dst,
 		     crypto_cipher_alg(ctx->child)->cia_decrypt);
 }
 
+int lrw_crypt(struct blkcipher_desc *desc, struct scatterlist *sdst,
+	      struct scatterlist *ssrc, unsigned int nbytes,
+	      struct lrw_crypt_req *req)
+{
+	const unsigned int bsize = LRW_BLOCK_SIZE;
+	const unsigned int max_blks = req->tbuflen / bsize;
+	struct lrw_table_ctx *ctx = req->table_ctx;
+	struct blkcipher_walk walk;
+	unsigned int nblocks;
+	be128 *iv, *src, *dst, *t;
+	be128 *t_buf = req->tbuf;
+	int err, i;
+
+	BUG_ON(max_blks < 1);
+
+	blkcipher_walk_init(&walk, sdst, ssrc, nbytes);
+
+	err = blkcipher_walk_virt(desc, &walk);
+	nbytes = walk.nbytes;
+	if (!nbytes)
+		return err;
+
+	nblocks = min(walk.nbytes / bsize, max_blks);
+	src = (be128 *)walk.src.virt.addr;
+	dst = (be128 *)walk.dst.virt.addr;
+
+	/* calculate first value of T */
+	iv = (be128 *)walk.iv;
+	t_buf[0] = *iv;
+
+	/* T <- I*Key2 */
+	gf128mul_64k_bbe(&t_buf[0], ctx->table);
+
+	i = 0;
+	goto first;
+
+	for (;;) {
+		do {
+			for (i = 0; i < nblocks; i++) {
+				/* T <- I*Key2, using the optimization
+				 * discussed in the specification */
+				be128_xor(&t_buf[i], t,
+						&ctx->mulinc[get_index128(iv)]);
+				inc(iv);
+first:
+				t = &t_buf[i];
+
+				/* PP <- T xor P */
+				be128_xor(dst + i, t, src + i);
+			}
+
+			/* CC <- E(Key2,PP) */
+			req->crypt_fn(req->crypt_ctx, (u8 *)dst,
+				      nblocks * bsize);
+
+			/* C <- T xor CC */
+			for (i = 0; i < nblocks; i++)
+				be128_xor(dst + i, dst + i, &t_buf[i]);
+
+			src += nblocks;
+			dst += nblocks;
+			nbytes -= nblocks * bsize;
+			nblocks = min(nbytes / bsize, max_blks);
+		} while (nblocks > 0);
+
+		err = blkcipher_walk_done(desc, &walk, nbytes);
+		nbytes = walk.nbytes;
+		if (!nbytes)
+			break;
+
+		src = (be128 *)walk.src.virt.addr;
+		dst = (be128 *)walk.dst.virt.addr;
+	}
+
+	return err;
+}
+EXPORT_SYMBOL_GPL(lrw_crypt);
+
 static int init_tfm(struct crypto_tfm *tfm)
 {
 	struct crypto_cipher *cipher;
diff --git a/include/crypto/lrw.h b/include/crypto/lrw.h
new file mode 100644
index 0000000..25a2c87
--- /dev/null
+++ b/include/crypto/lrw.h
@@ -0,0 +1,43 @@
+#ifndef _CRYPTO_LRW_H
+#define _CRYPTO_LRW_H
+
+#include <crypto/b128ops.h>
+
+struct scatterlist;
+struct gf128mul_64k;
+struct blkcipher_desc;
+
+#define LRW_BLOCK_SIZE 16
+
+struct lrw_table_ctx {
+	/* optimizes multiplying a random (non incrementing, as at the
+	 * start of a new sector) value with key2, we could also have
+	 * used 4k optimization tables or no optimization at all. In the
+	 * latter case we would have to store key2 here */
+	struct gf128mul_64k *table;
+	/* stores:
+	 *  key2*{ 0,0,...0,0,0,0,1 }, key2*{ 0,0,...0,0,0,1,1 },
+	 *  key2*{ 0,0,...0,0,1,1,1 }, key2*{ 0,0,...0,1,1,1,1 }
+	 *  key2*{ 0,0,...1,1,1,1,1 }, etc
+	 * needed for optimized multiplication of incrementing values
+	 * with key2 */
+	be128 mulinc[128];
+};
+
+int lrw_init_table(struct lrw_table_ctx *ctx, const u8 *tweak);
+void lrw_free_table(struct lrw_table_ctx *ctx);
+
+struct lrw_crypt_req {
+	be128 *tbuf;
+	unsigned int tbuflen;
+
+	struct lrw_table_ctx *table_ctx;
+	void *crypt_ctx;
+	void (*crypt_fn)(void *ctx, u8 *blks, unsigned int nbytes);
+};
+
+int lrw_crypt(struct blkcipher_desc *desc, struct scatterlist *dst,
+	      struct scatterlist *src, unsigned int nbytes,
+	      struct lrw_crypt_req *req);
+
+#endif  /* _CRYPTO_LRW_H */
