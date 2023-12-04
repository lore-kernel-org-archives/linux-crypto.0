Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB838224CF
	for <linux-crypto@vger.kernel.org>; Tue, 13 Feb 2024 09:16:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707815800; cv=none; b=gWRrqUDzz5cAxN/z7Nu2QwxLoXVh4SXMZM+ubft10qyFrLyBi0dYgVvIrzoD+xGKBMjUzBh9gtTXCkRK+Xbc0uV1Z5j3ETuvsLFALi3srIOFbuz3KYd5zxeB/fNGUJdz03GMna7vrEqIRHPsq0DB0DTDJ48vWBMooOrkKifORh4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707815800; c=relaxed/simple;
	bh=CFE3vzyqA+2nSYze5EwB6WSmQEqfNJPCsyKPfg0t3G4=;
	h=Message-Id:In-Reply-To:References:From:Date:Subject:To; b=ue9KmOKu/wT7yp+GxMkaEuKrS7t91qd0hzFjAnOLB1bSR3T2kehaPZUkWxjFfCpFDHaC05WCGQoo3tXMD5Gf6bdYLImKUiygBnSimKjTZwjI6OR0yoHqD8xnmyyqqkUbvdmR0oyxS56DrPU0FeOJxFSIM9yqeRktF437lILuJh4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
	id 1rZou0-00D1pp-DN; Tue, 13 Feb 2024 17:16:33 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Tue, 13 Feb 2024 17:16:46 +0800
Message-Id: <9c064202ca7369c7e7ebfa2e5b3386f8cd85d3c0.1707815065.git.herbert@gondor.apana.org.au>
In-Reply-To: <cover.1707815065.git.herbert@gondor.apana.org.au>
References: <cover.1707815065.git.herbert@gondor.apana.org.au>
From: Herbert Xu <herbert@gondor.apana.org.au>
Date: Mon, 4 Dec 2023 18:24:23 +0800
Subject: [PATCH 04/15] crypto: xts - Convert from skcipher to lskcipher
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>

Replace skcipher implementation with lskcipher.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---
 crypto/xts.c         | 572 +++++++++++++++++--------------------------
 include/crypto/xts.h |  24 +-
 2 files changed, 244 insertions(+), 352 deletions(-)

diff --git a/crypto/xts.c b/crypto/xts.c
index 672e1a3f0b0c..4a7b1c75bd14 100644
--- a/crypto/xts.c
+++ b/crypto/xts.c
@@ -7,23 +7,21 @@
  * Based on ecb.c
  * Copyright (c) 2006 Herbert Xu <herbert@gondor.apana.org.au>
  */
-#include <crypto/internal/cipher.h>
+
+#include <crypto/b128ops.h>
+#include <crypto/gf128mul.h>
 #include <crypto/internal/skcipher.h>
-#include <crypto/scatterwalk.h>
+#include <crypto/xts.h>
 #include <linux/err.h>
 #include <linux/init.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
-#include <linux/scatterlist.h>
 #include <linux/slab.h>
-
-#include <crypto/xts.h>
-#include <crypto/b128ops.h>
-#include <crypto/gf128mul.h>
+#include <linux/string.h>
 
 struct xts_tfm_ctx {
-	struct crypto_skcipher *child;
-	struct crypto_cipher *tweak;
+	struct crypto_lskcipher *child;
+	struct crypto_lskcipher *tweak;
 };
 
 struct xts_instance_ctx {
@@ -31,26 +29,21 @@ struct xts_instance_ctx {
 	struct crypto_cipher_spawn tweak_spawn;
 };
 
-struct xts_request_ctx {
-	le128 t;
-	struct scatterlist *tail;
-	struct scatterlist sg[2];
-	struct skcipher_request subreq;
-};
-
-static int xts_setkey(struct crypto_skcipher *parent, const u8 *key,
+static int xts_setkey(struct crypto_lskcipher *parent, const u8 *key,
 		      unsigned int keylen)
 {
-	struct xts_tfm_ctx *ctx = crypto_skcipher_ctx(parent);
-	struct crypto_skcipher *child;
-	struct crypto_cipher *tweak;
+	struct xts_tfm_ctx *ctx = crypto_lskcipher_ctx(parent);
+	struct crypto_lskcipher *child;
+	struct crypto_lskcipher *tweak;
+	unsigned flags;
 	int err;
 
-	err = xts_verify_key(parent, key, keylen);
+	err = xts_verify_key_lskcipher(parent, key, keylen);
 	if (err)
 		return err;
 
 	keylen /= 2;
+	flags = crypto_lskcipher_get_flags(parent) & CRYPTO_TFM_REQ_MASK;
 
 	/* we need two cipher instances: one to compute the initial 'tweak'
 	 * by encrypting the IV (usually the 'plain' iv) and the other
@@ -58,19 +51,17 @@ static int xts_setkey(struct crypto_skcipher *parent, const u8 *key,
 
 	/* tweak cipher, uses Key2 i.e. the second half of *key */
 	tweak = ctx->tweak;
-	crypto_cipher_clear_flags(tweak, CRYPTO_TFM_REQ_MASK);
-	crypto_cipher_set_flags(tweak, crypto_skcipher_get_flags(parent) &
-				       CRYPTO_TFM_REQ_MASK);
-	err = crypto_cipher_setkey(tweak, key + keylen, keylen);
+	crypto_lskcipher_clear_flags(tweak, CRYPTO_TFM_REQ_MASK);
+	crypto_lskcipher_set_flags(tweak, flags);
+	err = crypto_lskcipher_setkey(tweak, key + keylen, keylen);
 	if (err)
 		return err;
 
 	/* data cipher, uses Key1 i.e. the first half of *key */
 	child = ctx->child;
-	crypto_skcipher_clear_flags(child, CRYPTO_TFM_REQ_MASK);
-	crypto_skcipher_set_flags(child, crypto_skcipher_get_flags(parent) &
-					 CRYPTO_TFM_REQ_MASK);
-	return crypto_skcipher_setkey(child, key, keylen);
+	crypto_lskcipher_clear_flags(child, CRYPTO_TFM_REQ_MASK);
+	crypto_lskcipher_set_flags(child, flags);
+	return crypto_lskcipher_setkey(child, key, keylen);
 }
 
 /*
@@ -79,359 +70,247 @@ static int xts_setkey(struct crypto_skcipher *parent, const u8 *key,
  * mutliple calls to the 'ecb(..)' instance, which usually would be slower than
  * just doing the gf128mul_x_ble() calls again.
  */
-static int xts_xor_tweak(struct skcipher_request *req, bool second_pass,
-			 bool enc)
+static int xts_xor_tweak(struct crypto_lskcipher *tfm,
+			 const u8 *src, u8 *dst, unsigned len,
+			 le128 *t0, u32 flags, bool second_pass, bool enc)
 {
-	struct xts_request_ctx *rctx = skcipher_request_ctx(req);
-	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
-	const bool cts = (req->cryptlen % XTS_BLOCK_SIZE);
+	const bool cts = (flags & CRYPTO_LSKCIPHER_FLAG_FINAL) &&
+			 len % XTS_BLOCK_SIZE;
 	const int bs = XTS_BLOCK_SIZE;
-	struct skcipher_walk w;
-	le128 t = rctx->t;
+	unsigned int avail = len;
+	const le128 *wsrc;
+	le128 t = *t0;
+	le128 *wdst;
+
+	wsrc = (const le128 *)src;
+	wdst = (le128 *)dst;
+
+	do {
+		if (unlikely(cts) && avail < 2 * XTS_BLOCK_SIZE) {
+			if (!enc) {
+				if (second_pass)
+					*t0 = t;
+				gf128mul_x_ble(&t, &t);
+			}
+			le128_xor(wdst, &t, wsrc);
+			if (enc && second_pass)
+				gf128mul_x_ble(t0, &t);
+			return 0;
+		}
+
+		le128_xor(wdst++, &t, wsrc++);
+		gf128mul_x_ble(&t, &t);
+	} while ((avail -= bs) >= bs);
+
+	if (second_pass && !(flags & CRYPTO_LSKCIPHER_FLAG_FINAL))
+		*t0 = t;
+
+	return 0;
+}
+
+static int xts_xor_tweak_pre(struct crypto_lskcipher *tfm,
+			     const u8 *src, u8 *dst, unsigned len,
+			     le128 *t, u32 flags, bool enc)
+{
+	return xts_xor_tweak(tfm, src, dst, len, t, flags, false, enc);
+}
+
+static int xts_xor_tweak_post(struct crypto_lskcipher *tfm,
+			      const u8 *src, u8 *dst, unsigned len,
+			      le128 *t, u32 flags, bool enc)
+{
+	return xts_xor_tweak(tfm, src, dst, len, t, flags, true, enc);
+}
+
+static int xts_cts_pre(struct crypto_lskcipher *tfm, const u8 *src, u8 *dst,
+		       unsigned len, le128 *t0)
+{
+	int offset = (len & ~(XTS_BLOCK_SIZE - 1)) - XTS_BLOCK_SIZE;
+	int tail = len % XTS_BLOCK_SIZE;
+	le128 b[2];
+
+	b[0] = *(le128 *)(dst + offset);
+	b[1] = b[0];
+	memcpy(b, src + offset + XTS_BLOCK_SIZE, tail);
+
+	le128_xor(b, t0, b);
+
+	memcpy(dst + offset, b, XTS_BLOCK_SIZE + tail);
+
+	return 0;
+}
+
+static int xts_cts_post(struct crypto_lskcipher *tfm, u8 *dst,
+			unsigned len, le128 *t0)
+{
+	int offset = (len & ~(XTS_BLOCK_SIZE - 1)) - XTS_BLOCK_SIZE;
+	le128 *b = (le128 *)(dst + offset);
+
+	le128_xor(b, t0, b);
+
+	return 0;
+}
+
+static int xts_init_crypt(struct crypto_lskcipher *tfm, unsigned len, u8 *iv,
+			  u32 flags)
+{
+	const struct xts_tfm_ctx *ctx = crypto_lskcipher_ctx(tfm);
+
+	if (!len)
+		return -EINVAL;
+
+	if ((flags & CRYPTO_LSKCIPHER_FLAG_CONT))
+		return 0;
+
+	if (len < XTS_BLOCK_SIZE)
+		return -EINVAL;
+
+	/* calculate first value of T */
+	return crypto_lskcipher_encrypt(ctx->tweak, iv, iv,
+					XTS_BLOCK_SIZE, NULL);
+}
+
+static int xts_encrypt(struct crypto_lskcipher *tfm, const u8 *src, u8 *dst,
+		       unsigned len, u8 *iv, u32 flags)
+{
+	struct xts_tfm_ctx *ctx = crypto_lskcipher_ctx(tfm);
+	union {
+		le128 t128;
+		u8 t8[16];
+	} t = {
+		.t128 = *(le128 *)iv,
+	};
 	int err;
 
-	if (second_pass) {
-		req = &rctx->subreq;
-		/* set to our TFM to enforce correct alignment: */
-		skcipher_request_set_tfm(req, tfm);
+	err = xts_init_crypt(tfm, len, t.t8, flags) ?:
+	      xts_xor_tweak_pre(tfm, src, dst, len, &t.t128, flags, true) ?:
+	      crypto_lskcipher_encrypt(ctx->child, dst, dst,
+				       len & ~(XTS_BLOCK_SIZE - 1), NULL) ?:
+	      xts_xor_tweak_post(tfm, dst, dst, len, &t.t128, flags, true);
+
+	if (!err && unlikely(len % XTS_BLOCK_SIZE)) {
+		if ((flags & CRYPTO_LSKCIPHER_FLAG_FINAL)) {
+			int offset = (len & ~(XTS_BLOCK_SIZE - 1)) -
+				     XTS_BLOCK_SIZE;
+
+			err = xts_cts_pre(tfm, src, dst, len, &t.t128) ?:
+			      crypto_lskcipher_encrypt(ctx->child,
+						       dst + offset,
+						       dst + offset,
+						       XTS_BLOCK_SIZE,
+						       NULL) ?:
+			      xts_cts_post(tfm, dst, len, &t.t128);
+		} else
+			err = len % XTS_BLOCK_SIZE;
 	}
-	err = skcipher_walk_virt(&w, req, false);
 
-	while (w.nbytes) {
-		unsigned int avail = w.nbytes;
-		le128 *wsrc;
-		le128 *wdst;
-
-		wsrc = w.src.virt.addr;
-		wdst = w.dst.virt.addr;
-
-		do {
-			if (unlikely(cts) &&
-			    w.total - w.nbytes + avail < 2 * XTS_BLOCK_SIZE) {
-				if (!enc) {
-					if (second_pass)
-						rctx->t = t;
-					gf128mul_x_ble(&t, &t);
-				}
-				le128_xor(wdst, &t, wsrc);
-				if (enc && second_pass)
-					gf128mul_x_ble(&rctx->t, &t);
-				skcipher_walk_done(&w, avail - bs);
-				return 0;
-			}
-
-			le128_xor(wdst++, &t, wsrc++);
-			gf128mul_x_ble(&t, &t);
-		} while ((avail -= bs) >= bs);
-
-		err = skcipher_walk_done(&w, avail);
-	}
+	if (err < 0 || (flags & CRYPTO_LSKCIPHER_FLAG_FINAL))
+		memzero_explicit(&t, sizeof(t));
+	*(le128 *)iv = t.t128;
 
 	return err;
 }
 
-static int xts_xor_tweak_pre(struct skcipher_request *req, bool enc)
+static int xts_decrypt(struct crypto_lskcipher *tfm, const u8 *src, u8 *dst,
+		       unsigned len, u8 *iv, u32 flags)
 {
-	return xts_xor_tweak(req, false, enc);
-}
-
-static int xts_xor_tweak_post(struct skcipher_request *req, bool enc)
-{
-	return xts_xor_tweak(req, true, enc);
-}
-
-static void xts_cts_done(void *data, int err)
-{
-	struct skcipher_request *req = data;
-	le128 b;
-
-	if (!err) {
-		struct xts_request_ctx *rctx = skcipher_request_ctx(req);
-
-		scatterwalk_map_and_copy(&b, rctx->tail, 0, XTS_BLOCK_SIZE, 0);
-		le128_xor(&b, &rctx->t, &b);
-		scatterwalk_map_and_copy(&b, rctx->tail, 0, XTS_BLOCK_SIZE, 1);
-	}
-
-	skcipher_request_complete(req, err);
-}
-
-static int xts_cts_final(struct skcipher_request *req,
-			 int (*crypt)(struct skcipher_request *req))
-{
-	const struct xts_tfm_ctx *ctx =
-		crypto_skcipher_ctx(crypto_skcipher_reqtfm(req));
-	int offset = req->cryptlen & ~(XTS_BLOCK_SIZE - 1);
-	struct xts_request_ctx *rctx = skcipher_request_ctx(req);
-	struct skcipher_request *subreq = &rctx->subreq;
-	int tail = req->cryptlen % XTS_BLOCK_SIZE;
-	le128 b[2];
+	struct xts_tfm_ctx *ctx = crypto_lskcipher_ctx(tfm);
+	union {
+		le128 t128;
+		u8 t8[16];
+	} t = {
+		.t128 = *(le128 *)iv,
+	};
 	int err;
 
-	rctx->tail = scatterwalk_ffwd(rctx->sg, req->dst,
-				      offset - XTS_BLOCK_SIZE);
+	err = xts_init_crypt(tfm, len, t.t8, flags) ?:
+	      xts_xor_tweak_pre(tfm, src, dst, len, &t.t128, flags, false) ?:
+	      crypto_lskcipher_decrypt(ctx->child, dst, dst,
+				       len & ~(XTS_BLOCK_SIZE - 1), NULL) ?:
+	      xts_xor_tweak_post(tfm, dst, dst, len, &t.t128, flags, false);
 
-	scatterwalk_map_and_copy(b, rctx->tail, 0, XTS_BLOCK_SIZE, 0);
-	b[1] = b[0];
-	scatterwalk_map_and_copy(b, req->src, offset, tail, 0);
+	if (!err && unlikely(len % XTS_BLOCK_SIZE)) {
+		if ((flags & CRYPTO_LSKCIPHER_FLAG_FINAL)) {
+			int offset = (len & ~(XTS_BLOCK_SIZE - 1)) -
+				     XTS_BLOCK_SIZE;
 
-	le128_xor(b, &rctx->t, b);
+			err = xts_cts_pre(tfm, src, dst, len, &t.t128) ?:
+			      crypto_lskcipher_decrypt(ctx->child,
+						       dst + offset,
+						       dst + offset,
+						       XTS_BLOCK_SIZE,
+						       NULL) ?:
+			      xts_cts_post(tfm, dst, len, &t.t128);
+		} else
+			err = len % XTS_BLOCK_SIZE;
+	}
 
-	scatterwalk_map_and_copy(b, rctx->tail, 0, XTS_BLOCK_SIZE + tail, 1);
+	if (err < 0 || (flags & CRYPTO_LSKCIPHER_FLAG_FINAL))
+		memzero_explicit(&t, sizeof(t));
+	*(le128 *)iv = t.t128;
 
-	skcipher_request_set_tfm(subreq, ctx->child);
-	skcipher_request_set_callback(subreq, req->base.flags, xts_cts_done,
-				      req);
-	skcipher_request_set_crypt(subreq, rctx->tail, rctx->tail,
-				   XTS_BLOCK_SIZE, NULL);
+	return err;
+}
 
-	err = crypt(subreq);
-	if (err)
-		return err;
+static int xts_init_tfm(struct crypto_lskcipher *tfm)
+{
+	struct lskcipher_instance *inst = lskcipher_alg_instance(tfm);
+	struct xts_tfm_ctx *ctx = crypto_lskcipher_ctx(tfm);
+	struct crypto_lskcipher_spawn *spawn;
+	struct crypto_lskcipher *cipher;
 
-	scatterwalk_map_and_copy(b, rctx->tail, 0, XTS_BLOCK_SIZE, 0);
-	le128_xor(b, &rctx->t, b);
-	scatterwalk_map_and_copy(b, rctx->tail, 0, XTS_BLOCK_SIZE, 1);
+	spawn = lskcipher_instance_ctx(inst);
+	cipher = crypto_spawn_lskcipher(spawn);
+	if (IS_ERR(cipher))
+		return PTR_ERR(cipher);
+
+	ctx->child = cipher;
+
+	cipher = crypto_spawn_lskcipher(spawn);
+	if (IS_ERR(cipher)) {
+		crypto_free_lskcipher(ctx->child);
+		return PTR_ERR(cipher);
+	}
+
+	ctx->tweak = cipher;
 
 	return 0;
 }
 
-static void xts_encrypt_done(void *data, int err)
+static void xts_exit_tfm(struct crypto_lskcipher *tfm)
 {
-	struct skcipher_request *req = data;
+	struct xts_tfm_ctx *ctx = crypto_lskcipher_ctx(tfm);
 
-	if (!err) {
-		struct xts_request_ctx *rctx = skcipher_request_ctx(req);
-
-		rctx->subreq.base.flags &= CRYPTO_TFM_REQ_MAY_BACKLOG;
-		err = xts_xor_tweak_post(req, true);
-
-		if (!err && unlikely(req->cryptlen % XTS_BLOCK_SIZE)) {
-			err = xts_cts_final(req, crypto_skcipher_encrypt);
-			if (err == -EINPROGRESS || err == -EBUSY)
-				return;
-		}
-	}
-
-	skcipher_request_complete(req, err);
-}
-
-static void xts_decrypt_done(void *data, int err)
-{
-	struct skcipher_request *req = data;
-
-	if (!err) {
-		struct xts_request_ctx *rctx = skcipher_request_ctx(req);
-
-		rctx->subreq.base.flags &= CRYPTO_TFM_REQ_MAY_BACKLOG;
-		err = xts_xor_tweak_post(req, false);
-
-		if (!err && unlikely(req->cryptlen % XTS_BLOCK_SIZE)) {
-			err = xts_cts_final(req, crypto_skcipher_decrypt);
-			if (err == -EINPROGRESS || err == -EBUSY)
-				return;
-		}
-	}
-
-	skcipher_request_complete(req, err);
-}
-
-static int xts_init_crypt(struct skcipher_request *req,
-			  crypto_completion_t compl)
-{
-	const struct xts_tfm_ctx *ctx =
-		crypto_skcipher_ctx(crypto_skcipher_reqtfm(req));
-	struct xts_request_ctx *rctx = skcipher_request_ctx(req);
-	struct skcipher_request *subreq = &rctx->subreq;
-
-	if (req->cryptlen < XTS_BLOCK_SIZE)
-		return -EINVAL;
-
-	skcipher_request_set_tfm(subreq, ctx->child);
-	skcipher_request_set_callback(subreq, req->base.flags, compl, req);
-	skcipher_request_set_crypt(subreq, req->dst, req->dst,
-				   req->cryptlen & ~(XTS_BLOCK_SIZE - 1), NULL);
-
-	/* calculate first value of T */
-	crypto_cipher_encrypt_one(ctx->tweak, (u8 *)&rctx->t, req->iv);
-
-	return 0;
-}
-
-static int xts_encrypt(struct skcipher_request *req)
-{
-	struct xts_request_ctx *rctx = skcipher_request_ctx(req);
-	struct skcipher_request *subreq = &rctx->subreq;
-	int err;
-
-	err = xts_init_crypt(req, xts_encrypt_done) ?:
-	      xts_xor_tweak_pre(req, true) ?:
-	      crypto_skcipher_encrypt(subreq) ?:
-	      xts_xor_tweak_post(req, true);
-
-	if (err || likely((req->cryptlen % XTS_BLOCK_SIZE) == 0))
-		return err;
-
-	return xts_cts_final(req, crypto_skcipher_encrypt);
-}
-
-static int xts_decrypt(struct skcipher_request *req)
-{
-	struct xts_request_ctx *rctx = skcipher_request_ctx(req);
-	struct skcipher_request *subreq = &rctx->subreq;
-	int err;
-
-	err = xts_init_crypt(req, xts_decrypt_done) ?:
-	      xts_xor_tweak_pre(req, false) ?:
-	      crypto_skcipher_decrypt(subreq) ?:
-	      xts_xor_tweak_post(req, false);
-
-	if (err || likely((req->cryptlen % XTS_BLOCK_SIZE) == 0))
-		return err;
-
-	return xts_cts_final(req, crypto_skcipher_decrypt);
-}
-
-static int xts_init_tfm(struct crypto_skcipher *tfm)
-{
-	struct skcipher_instance *inst = skcipher_alg_instance(tfm);
-	struct xts_instance_ctx *ictx = skcipher_instance_ctx(inst);
-	struct xts_tfm_ctx *ctx = crypto_skcipher_ctx(tfm);
-	struct crypto_skcipher *child;
-	struct crypto_cipher *tweak;
-
-	child = crypto_spawn_skcipher(&ictx->spawn);
-	if (IS_ERR(child))
-		return PTR_ERR(child);
-
-	ctx->child = child;
-
-	tweak = crypto_spawn_cipher(&ictx->tweak_spawn);
-	if (IS_ERR(tweak)) {
-		crypto_free_skcipher(ctx->child);
-		return PTR_ERR(tweak);
-	}
-
-	ctx->tweak = tweak;
-
-	crypto_skcipher_set_reqsize(tfm, crypto_skcipher_reqsize(child) +
-					 sizeof(struct xts_request_ctx));
-
-	return 0;
-}
-
-static void xts_exit_tfm(struct crypto_skcipher *tfm)
-{
-	struct xts_tfm_ctx *ctx = crypto_skcipher_ctx(tfm);
-
-	crypto_free_skcipher(ctx->child);
-	crypto_free_cipher(ctx->tweak);
-}
-
-static void xts_free_instance(struct skcipher_instance *inst)
-{
-	struct xts_instance_ctx *ictx = skcipher_instance_ctx(inst);
-
-	crypto_drop_skcipher(&ictx->spawn);
-	crypto_drop_cipher(&ictx->tweak_spawn);
-	kfree(inst);
+	crypto_free_lskcipher(ctx->tweak);
+	crypto_free_lskcipher(ctx->child);
 }
 
 static int xts_create(struct crypto_template *tmpl, struct rtattr **tb)
 {
-	struct skcipher_alg_common *alg;
-	char name[CRYPTO_MAX_ALG_NAME];
-	struct skcipher_instance *inst;
-	struct xts_instance_ctx *ctx;
-	const char *cipher_name;
-	u32 mask;
+	struct lskcipher_instance *inst;
 	int err;
 
-	err = crypto_check_attr_type(tb, CRYPTO_ALG_TYPE_SKCIPHER, &mask);
-	if (err)
-		return err;
-
-	cipher_name = crypto_attr_alg_name(tb[1]);
-	if (IS_ERR(cipher_name))
-		return PTR_ERR(cipher_name);
-
-	inst = kzalloc(sizeof(*inst) + sizeof(*ctx), GFP_KERNEL);
-	if (!inst)
-		return -ENOMEM;
-
-	ctx = skcipher_instance_ctx(inst);
-
-	err = crypto_grab_skcipher(&ctx->spawn, skcipher_crypto_instance(inst),
-				   cipher_name, 0, mask);
-	if (err == -ENOENT) {
-		err = -ENAMETOOLONG;
-		if (snprintf(name, CRYPTO_MAX_ALG_NAME, "ecb(%s)",
-			     cipher_name) >= CRYPTO_MAX_ALG_NAME)
-			goto err_free_inst;
-
-		err = crypto_grab_skcipher(&ctx->spawn,
-					   skcipher_crypto_instance(inst),
-					   name, 0, mask);
-	}
-
-	if (err)
-		goto err_free_inst;
-
-	alg = crypto_spawn_skcipher_alg_common(&ctx->spawn);
+	inst = lskcipher_alloc_instance_simple(tmpl, tb);
+	if (IS_ERR(inst))
+		return PTR_ERR(inst);
 
 	err = -EINVAL;
-	if (alg->base.cra_blocksize != XTS_BLOCK_SIZE)
+	if (inst->alg.co.base.cra_blocksize != XTS_BLOCK_SIZE)
 		goto err_free_inst;
 
-	if (alg->ivsize)
+	if (inst->alg.co.ivsize)
 		goto err_free_inst;
 
-	err = crypto_inst_setname(skcipher_crypto_instance(inst), "xts",
-				  &alg->base);
-	if (err)
-		goto err_free_inst;
+	inst->alg.co.base.cra_blocksize = 1;
+	inst->alg.co.base.cra_alignmask |= (__alignof__(le128) - 1);
 
-	err = -EINVAL;
-	cipher_name = alg->base.cra_name;
+	inst->alg.co.ivsize = XTS_BLOCK_SIZE;
+	inst->alg.co.chunksize = XTS_BLOCK_SIZE;
+	inst->alg.co.tailsize = XTS_BLOCK_SIZE * 2;
+	inst->alg.co.min_keysize *= 2;
+	inst->alg.co.max_keysize *= 2;
 
-	/* Alas we screwed up the naming so we have to mangle the
-	 * cipher name.
-	 */
-	if (!strncmp(cipher_name, "ecb(", 4)) {
-		int len;
-
-		len = strscpy(name, cipher_name + 4, sizeof(name));
-		if (len < 2)
-			goto err_free_inst;
-
-		if (name[len - 1] != ')')
-			goto err_free_inst;
-
-		name[len - 1] = 0;
-
-		if (snprintf(inst->alg.base.cra_name, CRYPTO_MAX_ALG_NAME,
-			     "xts(%s)", name) >= CRYPTO_MAX_ALG_NAME) {
-			err = -ENAMETOOLONG;
-			goto err_free_inst;
-		}
-	} else
-		goto err_free_inst;
-
-	err = crypto_grab_cipher(&ctx->tweak_spawn,
-				 skcipher_crypto_instance(inst), name, 0, mask);
-	if (err)
-		goto err_free_inst;
-
-	inst->alg.base.cra_priority = alg->base.cra_priority;
-	inst->alg.base.cra_blocksize = XTS_BLOCK_SIZE;
-	inst->alg.base.cra_alignmask = alg->base.cra_alignmask |
-				       (__alignof__(u64) - 1);
-
-	inst->alg.ivsize = XTS_BLOCK_SIZE;
-	inst->alg.min_keysize = alg->min_keysize * 2;
-	inst->alg.max_keysize = alg->max_keysize * 2;
-
-	inst->alg.base.cra_ctxsize = sizeof(struct xts_tfm_ctx);
+	inst->alg.co.base.cra_ctxsize = sizeof(struct xts_tfm_ctx);
 
 	inst->alg.init = xts_init_tfm;
 	inst->alg.exit = xts_exit_tfm;
@@ -440,12 +319,10 @@ static int xts_create(struct crypto_template *tmpl, struct rtattr **tb)
 	inst->alg.encrypt = xts_encrypt;
 	inst->alg.decrypt = xts_decrypt;
 
-	inst->free = xts_free_instance;
-
-	err = skcipher_register_instance(tmpl, inst);
+	err = lskcipher_register_instance(tmpl, inst);
 	if (err) {
 err_free_inst:
-		xts_free_instance(inst);
+		inst->free(inst);
 	}
 	return err;
 }
@@ -472,5 +349,4 @@ module_exit(xts_module_exit);
 MODULE_LICENSE("GPL");
 MODULE_DESCRIPTION("XTS block cipher mode");
 MODULE_ALIAS_CRYPTO("xts");
-MODULE_IMPORT_NS(CRYPTO_INTERNAL);
 MODULE_SOFTDEP("pre: ecb");
diff --git a/include/crypto/xts.h b/include/crypto/xts.h
index 15b16c4853d8..0287540e2ced 100644
--- a/include/crypto/xts.h
+++ b/include/crypto/xts.h
@@ -5,11 +5,12 @@
 #include <crypto/b128ops.h>
 #include <crypto/internal/skcipher.h>
 #include <linux/fips.h>
+#include <linux/types.h>
 
 #define XTS_BLOCK_SIZE 16
 
-static inline int xts_verify_key(struct crypto_skcipher *tfm,
-				 const u8 *key, unsigned int keylen)
+static inline int xts_verify_key_common(bool forbid_weak_keys,
+					const u8 *key, unsigned int keylen)
 {
 	/*
 	 * key consists of keys of equal size concatenated, therefore
@@ -29,12 +30,27 @@ static inline int xts_verify_key(struct crypto_skcipher *tfm,
 	 * Ensure that the AES and tweak key are not identical when
 	 * in FIPS mode or the FORBID_WEAK_KEYS flag is set.
 	 */
-	if ((fips_enabled || (crypto_skcipher_get_flags(tfm) &
-			      CRYPTO_TFM_REQ_FORBID_WEAK_KEYS)) &&
+	if ((fips_enabled || forbid_weak_keys) &&
 	    !crypto_memneq(key, key + (keylen / 2), keylen / 2))
 		return -EINVAL;
 
 	return 0;
 }
 
+static inline int xts_verify_key(struct crypto_skcipher *tfm,
+				 const u8 *key, unsigned int keylen)
+{
+	return xts_verify_key_common(crypto_skcipher_get_flags(tfm) &
+				     CRYPTO_TFM_REQ_FORBID_WEAK_KEYS,
+				     key, keylen);
+}
+
+static inline int xts_verify_key_lskcipher(struct crypto_lskcipher *tfm,
+					   const u8 *key, unsigned int keylen)
+{
+	return xts_verify_key_common(crypto_lskcipher_get_flags(tfm) &
+				     CRYPTO_TFM_REQ_FORBID_WEAK_KEYS,
+				     key, keylen);
+}
+
 #endif  /* _CRYPTO_XTS_H */
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

