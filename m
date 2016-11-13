From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [v2 PATCH 15/16] crypto: cbc - Export CBC implementation
Date: Sun, 13 Nov 2016 19:45:47 +0800
Message-ID: <E1c5tEJ-0002CQ-Mr@gondolin.me.apana.org.au>
References: <20161113114354.GA8169@gondor.apana.org.au>
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:48641 "EHLO
        helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933813AbcKMLpy (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 13 Nov 2016 06:45:54 -0500
Received: from gondolin.me.apana.org.au ([192.168.0.6])
        by norbury.hengli.com.au with esmtp (Exim 4.80 #3 (Debian))
        id 1c5tEJ-0007CR-Sd
        for <linux-crypto@vger.kernel.org>; Sun, 13 Nov 2016 22:45:47 +1100
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

This patch moves the core CBC implementation into a header file
so that it can be reused by drivers implementing CBC.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---

 crypto/cbc.c         |  129 ---------------------------------------------
 include/crypto/cbc.h |  146 +++++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 148 insertions(+), 127 deletions(-)

diff --git a/crypto/cbc.c b/crypto/cbc.c
index 6539b38..68f751a 100644
--- a/crypto/cbc.c
+++ b/crypto/cbc.c
@@ -1,7 +1,7 @@
 /*
  * CBC: Cipher Block Chaining mode
  *
- * Copyright (c) 2006 Herbert Xu <herbert@gondor.apana.org.au>
+ * Copyright (c) 2006-2016 Herbert Xu <herbert@gondor.apana.org.au>
  *
  * This program is free software; you can redistribute it and/or modify it
  * under the terms of the GNU General Public License as published by the Free
@@ -10,6 +10,7 @@
  *
  */
 
+#include <crypto/cbc.h>
 #include <crypto/internal/skcipher.h>
 #include <linux/err.h>
 #include <linux/init.h>
@@ -38,71 +39,6 @@ static int crypto_cbc_setkey(struct crypto_skcipher *parent, const u8 *key,
 	return err;
 }
 
-static inline int crypto_cbc_encrypt_segment(
-	struct skcipher_walk *walk, struct crypto_skcipher *tfm,
-	void (*fn)(struct crypto_skcipher *, const u8 *, u8 *))
-{
-	unsigned int bsize = crypto_skcipher_blocksize(tfm);
-	unsigned int nbytes = walk->nbytes;
-	u8 *src = walk->src.virt.addr;
-	u8 *dst = walk->dst.virt.addr;
-	u8 *iv = walk->iv;
-
-	do {
-		crypto_xor(iv, src, bsize);
-		fn(tfm, iv, dst);
-		memcpy(iv, dst, bsize);
-
-		src += bsize;
-		dst += bsize;
-	} while ((nbytes -= bsize) >= bsize);
-
-	return nbytes;
-}
-
-static inline int crypto_cbc_encrypt_inplace(
-	struct skcipher_walk *walk, struct crypto_skcipher *tfm,
-	void (*fn)(struct crypto_skcipher *, const u8 *, u8 *))
-{
-	unsigned int bsize = crypto_skcipher_blocksize(tfm);
-	unsigned int nbytes = walk->nbytes;
-	u8 *src = walk->src.virt.addr;
-	u8 *iv = walk->iv;
-
-	do {
-		crypto_xor(src, iv, bsize);
-		fn(tfm, src, src);
-		iv = src;
-
-		src += bsize;
-	} while ((nbytes -= bsize) >= bsize);
-
-	memcpy(walk->iv, iv, bsize);
-
-	return nbytes;
-}
-
-static inline int crypto_cbc_encrypt_walk(struct skcipher_request *req,
-					  void (*fn)(struct crypto_skcipher *,
-						     const u8 *, u8 *))
-{
-	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
-	struct skcipher_walk walk;
-	int err;
-
-	err = skcipher_walk_virt(&walk, req, false);
-
-	while (walk.nbytes) {
-		if (walk.src.virt.addr == walk.dst.virt.addr)
-			err = crypto_cbc_encrypt_inplace(&walk, tfm, fn);
-		else
-			err = crypto_cbc_encrypt_segment(&walk, tfm, fn);
-		err = skcipher_walk_done(&walk, err);
-	}
-
-	return err;
-}
-
 static inline void crypto_cbc_encrypt_one(struct crypto_skcipher *tfm,
 					  const u8 *src, u8 *dst)
 {
@@ -116,67 +52,6 @@ static int crypto_cbc_encrypt(struct skcipher_request *req)
 	return crypto_cbc_encrypt_walk(req, crypto_cbc_encrypt_one);
 }
 
-static inline int crypto_cbc_decrypt_segment(
-	struct skcipher_walk *walk, struct crypto_skcipher *tfm,
-	void (*fn)(struct crypto_skcipher *, const u8 *, u8 *))
-{
-	unsigned int bsize = crypto_skcipher_blocksize(tfm);
-	unsigned int nbytes = walk->nbytes;
-	u8 *src = walk->src.virt.addr;
-	u8 *dst = walk->dst.virt.addr;
-	u8 *iv = walk->iv;
-
-	do {
-		fn(tfm, src, dst);
-		crypto_xor(dst, iv, bsize);
-		iv = src;
-
-		src += bsize;
-		dst += bsize;
-	} while ((nbytes -= bsize) >= bsize);
-
-	memcpy(walk->iv, iv, bsize);
-
-	return nbytes;
-}
-
-static inline int crypto_cbc_decrypt_inplace(
-	struct skcipher_walk *walk, struct crypto_skcipher *tfm,
-	void (*fn)(struct crypto_skcipher *, const u8 *, u8 *))
-{
-	unsigned int bsize = crypto_skcipher_blocksize(tfm);
-	unsigned int nbytes = walk->nbytes;
-	u8 *src = walk->src.virt.addr;
-	u8 last_iv[bsize];
-
-	/* Start of the last block. */
-	src += nbytes - (nbytes & (bsize - 1)) - bsize;
-	memcpy(last_iv, src, bsize);
-
-	for (;;) {
-		fn(tfm, src, src);
-		if ((nbytes -= bsize) < bsize)
-			break;
-		crypto_xor(src, src - bsize, bsize);
-		src -= bsize;
-	}
-
-	crypto_xor(src, walk->iv, bsize);
-	memcpy(walk->iv, last_iv, bsize);
-
-	return nbytes;
-}
-
-static inline int crypto_cbc_decrypt_blocks(
-	struct skcipher_walk *walk, struct crypto_skcipher *tfm,
-	void (*fn)(struct crypto_skcipher *, const u8 *, u8 *))
-{
-	if (walk->src.virt.addr == walk->dst.virt.addr)
-		return crypto_cbc_decrypt_inplace(walk, tfm, fn);
-	else
-		return crypto_cbc_decrypt_segment(walk, tfm, fn);
-}
-
 static inline void crypto_cbc_decrypt_one(struct crypto_skcipher *tfm,
 					  const u8 *src, u8 *dst)
 {
diff --git a/include/crypto/cbc.h b/include/crypto/cbc.h
new file mode 100644
index 0000000..f5b8bfc
--- /dev/null
+++ b/include/crypto/cbc.h
@@ -0,0 +1,146 @@
+/*
+ * CBC: Cipher Block Chaining mode
+ *
+ * Copyright (c) 2016 Herbert Xu <herbert@gondor.apana.org.au>
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License as published by the Free
+ * Software Foundation; either version 2 of the License, or (at your option)
+ * any later version.
+ *
+ */
+
+#ifndef _CRYPTO_CBC_H
+#define _CRYPTO_CBC_H
+
+#include <crypto/internal/skcipher.h>
+#include <linux/string.h>
+#include <linux/types.h>
+
+static inline int crypto_cbc_encrypt_segment(
+	struct skcipher_walk *walk, struct crypto_skcipher *tfm,
+	void (*fn)(struct crypto_skcipher *, const u8 *, u8 *))
+{
+	unsigned int bsize = crypto_skcipher_blocksize(tfm);
+	unsigned int nbytes = walk->nbytes;
+	u8 *src = walk->src.virt.addr;
+	u8 *dst = walk->dst.virt.addr;
+	u8 *iv = walk->iv;
+
+	do {
+		crypto_xor(iv, src, bsize);
+		fn(tfm, iv, dst);
+		memcpy(iv, dst, bsize);
+
+		src += bsize;
+		dst += bsize;
+	} while ((nbytes -= bsize) >= bsize);
+
+	return nbytes;
+}
+
+static inline int crypto_cbc_encrypt_inplace(
+	struct skcipher_walk *walk, struct crypto_skcipher *tfm,
+	void (*fn)(struct crypto_skcipher *, const u8 *, u8 *))
+{
+	unsigned int bsize = crypto_skcipher_blocksize(tfm);
+	unsigned int nbytes = walk->nbytes;
+	u8 *src = walk->src.virt.addr;
+	u8 *iv = walk->iv;
+
+	do {
+		crypto_xor(src, iv, bsize);
+		fn(tfm, src, src);
+		iv = src;
+
+		src += bsize;
+	} while ((nbytes -= bsize) >= bsize);
+
+	memcpy(walk->iv, iv, bsize);
+
+	return nbytes;
+}
+
+static inline int crypto_cbc_encrypt_walk(struct skcipher_request *req,
+					  void (*fn)(struct crypto_skcipher *,
+						     const u8 *, u8 *))
+{
+	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
+	struct skcipher_walk walk;
+	int err;
+
+	err = skcipher_walk_virt(&walk, req, false);
+
+	while (walk.nbytes) {
+		if (walk.src.virt.addr == walk.dst.virt.addr)
+			err = crypto_cbc_encrypt_inplace(&walk, tfm, fn);
+		else
+			err = crypto_cbc_encrypt_segment(&walk, tfm, fn);
+		err = skcipher_walk_done(&walk, err);
+	}
+
+	return err;
+}
+
+static inline int crypto_cbc_decrypt_segment(
+	struct skcipher_walk *walk, struct crypto_skcipher *tfm,
+	void (*fn)(struct crypto_skcipher *, const u8 *, u8 *))
+{
+	unsigned int bsize = crypto_skcipher_blocksize(tfm);
+	unsigned int nbytes = walk->nbytes;
+	u8 *src = walk->src.virt.addr;
+	u8 *dst = walk->dst.virt.addr;
+	u8 *iv = walk->iv;
+
+	do {
+		fn(tfm, src, dst);
+		crypto_xor(dst, iv, bsize);
+		iv = src;
+
+		src += bsize;
+		dst += bsize;
+	} while ((nbytes -= bsize) >= bsize);
+
+	memcpy(walk->iv, iv, bsize);
+
+	return nbytes;
+}
+
+static inline int crypto_cbc_decrypt_inplace(
+	struct skcipher_walk *walk, struct crypto_skcipher *tfm,
+	void (*fn)(struct crypto_skcipher *, const u8 *, u8 *))
+{
+	unsigned int bsize = crypto_skcipher_blocksize(tfm);
+	unsigned int nbytes = walk->nbytes;
+	u8 *src = walk->src.virt.addr;
+	u8 last_iv[bsize];
+
+	/* Start of the last block. */
+	src += nbytes - (nbytes & (bsize - 1)) - bsize;
+	memcpy(last_iv, src, bsize);
+
+	for (;;) {
+		fn(tfm, src, src);
+		if ((nbytes -= bsize) < bsize)
+			break;
+		crypto_xor(src, src - bsize, bsize);
+		src -= bsize;
+	}
+
+	crypto_xor(src, walk->iv, bsize);
+	memcpy(walk->iv, last_iv, bsize);
+
+	return nbytes;
+}
+
+static inline int crypto_cbc_decrypt_blocks(
+	struct skcipher_walk *walk, struct crypto_skcipher *tfm,
+	void (*fn)(struct crypto_skcipher *, const u8 *, u8 *))
+{
+	if (walk->src.virt.addr == walk->dst.virt.addr)
+		return crypto_cbc_decrypt_inplace(walk, tfm, fn);
+	else
+		return crypto_cbc_decrypt_segment(walk, tfm, fn);
+}
+
+#endif	/* _CRYPTO_CBC_H */
