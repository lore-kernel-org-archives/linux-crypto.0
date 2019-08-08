Return-Path: <SRS0=IdBJ=WE=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2E465C433FF
	for <linux-crypto@archiver.kernel.org>; Thu,  8 Aug 2019 07:20:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D6003217D7
	for <linux-crypto@archiver.kernel.org>; Thu,  8 Aug 2019 07:20:46 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="i6wqE1sI"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728167AbfHHHUp (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 8 Aug 2019 03:20:45 -0400
Received: from mail-ed1-f42.google.com ([209.85.208.42]:45497 "EHLO
        mail-ed1-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725817AbfHHHUp (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 8 Aug 2019 03:20:45 -0400
Received: by mail-ed1-f42.google.com with SMTP id x19so83576780eda.12
        for <linux-crypto@vger.kernel.org>; Thu, 08 Aug 2019 00:20:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=I8ONBSl4QLi+RtZjGlA2AlB65RC549eTFooZXBn593k=;
        b=i6wqE1sI5PyU22+SdJdk/OOVqRNf2v+9O6VOTZv8Wy8jP8ag9PdqoX9o3HbHBNso6g
         GoIe2X/tjb6Y2r4yI56FzOKe8HI1c5qQV+wxH+JVIP6S5vk0ZY4t2JZ9kLZFt7lWd7/Y
         z/gnBBfE5osLt4vhzS8sYTd7+hO8qT6bzVHizWyVbgOhegp9NIGi9w4lJgWTTrLqCwQy
         BS08SbEz+OTf5mHeMgLhwqx762qpzzEGYuDH9kGHAyYq1sclvP513b7SAnkHBuHTCAyM
         jzUjGFNSzKMmC4yE7f9yxmWhMHgWsA/SatDYQhEfIazEXTQnN6eESdF8h6Sjitx4yG9T
         WGqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=I8ONBSl4QLi+RtZjGlA2AlB65RC549eTFooZXBn593k=;
        b=YZnb8zr6uhZLJPcJ5v/MfVkoM/G6mX7hxxVy/7+7sxIv4Pgg5C/G6XspExwPPhjcC3
         ZOsTfd6aWKr7rqMYHlipsnClOrfTDSNoHnde1ks1ut6K3T1ZhQPXacwZXMmbr7BIwaFb
         NHRvG2NwdTD7hOzZYlIesLSWFm2pthDCBiuy4Ln5T80fwttekUGRsUwxqzK4dJT9Qewq
         kfG/0aOsT5BsIY2TSICYYh6P2byTFGLcJmoFHjfR+Ru59EgtT2oAUR3UhtUN/ItOtBKy
         3VHOLIte1BPCkgj9Z3XDYnDzePXmgF9LqTWa9GXY4q8RkCUHnfzsAfdqcnDcGGJMq3jz
         H/ow==
X-Gm-Message-State: APjAAAVX/f3iSpfKKyrUGzM/mD0YcitS6dYudJdBd0N8pvUjOkJ97RaK
        wCaUpjlVmCJC9jXb3xzjKdt9GPlf
X-Google-Smtp-Source: APXvYqyZpvbRAXuqNX4OCR5hFnVDnWIpwxe/vkhGUfrmY0cMlcrbKcXNV+5U3QxXWqRFqTCr0lrbvw==
X-Received: by 2002:a50:86bb:: with SMTP id r56mr3391490eda.217.1565248842689;
        Thu, 08 Aug 2019 00:20:42 -0700 (PDT)
Received: from localhost.localdomain.com ([188.204.2.113])
        by smtp.gmail.com with ESMTPSA id b5sm15284408ejq.8.2019.08.08.00.20.41
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 08 Aug 2019 00:20:42 -0700 (PDT)
From:   Pascal van Leeuwen <pascalvanl@gmail.com>
X-Google-Original-From: Pascal van Leeuwen <pvanleeuwen@verimatrix.com>
To:     linux-crypto@vger.kernel.org
Cc:     herbert@gondor.apana.org.au, davem@davemloft.net,
        Pascal van Leeuwen <pvanleeuwen@verimatrix.com>
Subject: [PATCHv2] crypto: xts - Add support for Cipher Text Stealing
Date:   Thu,  8 Aug 2019 08:18:14 +0200
Message-Id: <1565245094-8584-1-git-send-email-pvanleeuwen@verimatrix.com>
X-Mailer: git-send-email 1.8.3.1
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

This adds support for Cipher Text Stealing for data blocks that are not an
integer multiple of the cipher block size in size, bringing it fully in
line with the IEEE P1619/D16 standard.

This has been tested with the AES-XTS test vectors from the IEEE P1619/D16
specification as well as some additional test vectors supplied to the
linux_crypto mailing list previously. It has also been fuzzed against
Inside Secure AES-XTS hardware which has been actively used in the field
for more than a decade already.

changes since v1:
- Fixed buffer overflow issue due to subreq not being the last entry in
  rctx, this turns out to be a crypto API requirement. Thanks to Milan
  Broz <gmazyland@gmail.com> for finding this and providing the solution.
- Removed some redundant error returning code from the _finish_cts()
  functions that currently cannot fail, therefore would always return 0.
- removed rem_bytes computation behind init_crypt() in the encrypt() and
  decrypt() functions, no need to compute for lengths < 16
- Fixed comment style for single line comments

Signed-off-by: Pascal van Leeuwen <pvanleeuwen@verimatrix.com>
---
 crypto/xts.c | 229 +++++++++++++++++++++++++++++++++++++++++++++++++++++------
 1 file changed, 209 insertions(+), 20 deletions(-)

diff --git a/crypto/xts.c b/crypto/xts.c
index 33cf726..17b551d 100644
--- a/crypto/xts.c
+++ b/crypto/xts.c
@@ -1,7 +1,5 @@
 /* XTS: as defined in IEEE1619/D16
  *	http://grouper.ieee.org/groups/1619/email/pdf00086.pdf
- *	(sector sizes which are not a multiple of 16 bytes are,
- *	however currently unsupported)
  *
  * Copyright (c) 2007 Rik Snel <rsnel@cube.dyndns.org>
  *
@@ -28,6 +26,7 @@

 struct priv {
 	struct crypto_skcipher *child;
+	struct crypto_cipher *base;
 	struct crypto_cipher *tweak;
 };

@@ -37,7 +36,9 @@ struct xts_instance_ctx {
 };

 struct rctx {
-	le128 t;
+	le128 t, tcur;
+	int rem_bytes, is_encrypt;
+	/* must be the last, expanded beyond end of struct! */
 	struct skcipher_request subreq;
 };

@@ -47,6 +48,7 @@ static int setkey(struct crypto_skcipher *parent, const u8 *key,
 	struct priv *ctx = crypto_skcipher_ctx(parent);
 	struct crypto_skcipher *child;
 	struct crypto_cipher *tweak;
+	struct crypto_cipher *base;
 	int err;

 	err = xts_verify_key(parent, key, keylen);
@@ -55,9 +57,11 @@ static int setkey(struct crypto_skcipher *parent, const u8 *key,

 	keylen /= 2;

-	/* we need two cipher instances: one to compute the initial 'tweak'
-	 * by encrypting the IV (usually the 'plain' iv) and the other
-	 * one to encrypt and decrypt the data */
+	/* we need three cipher instances: one to compute the initial 'tweak'
+	 * by encrypting the IV (usually the 'plain' iv), one to encrypt and
+	 * decrypt the data and finally one to encrypt the last block(s) for
+	 * cipher text stealing
+	 */

 	/* tweak cipher, uses Key2 i.e. the second half of *key */
 	tweak = ctx->tweak;
@@ -79,6 +83,13 @@ static int setkey(struct crypto_skcipher *parent, const u8 *key,
 	crypto_skcipher_set_flags(parent, crypto_skcipher_get_flags(child) &
 					  CRYPTO_TFM_RES_MASK);

+	/* Also data cipher, using Key1, for applying CTS */
+	base = ctx->base;
+	crypto_cipher_clear_flags(base, CRYPTO_TFM_REQ_MASK);
+	crypto_cipher_set_flags(base, crypto_skcipher_get_flags(parent) &
+				      CRYPTO_TFM_REQ_MASK);
+	err = crypto_cipher_setkey(base, key, keylen);
+
 	return err;
 }

@@ -88,13 +99,12 @@ static int setkey(struct crypto_skcipher *parent, const u8 *key,
  * mutliple calls to the 'ecb(..)' instance, which usually would be slower than
  * just doing the gf128mul_x_ble() calls again.
  */
-static int xor_tweak(struct skcipher_request *req, bool second_pass)
+static int xor_tweak(struct skcipher_request *req, bool second_pass, le128 *t)
 {
 	struct rctx *rctx = skcipher_request_ctx(req);
 	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
 	const int bs = XTS_BLOCK_SIZE;
 	struct skcipher_walk w;
-	le128 t = rctx->t;
 	int err;

 	if (second_pass) {
@@ -104,6 +114,7 @@ static int xor_tweak(struct skcipher_request *req, bool second_pass)
 	}
 	err = skcipher_walk_virt(&w, req, false);

+	*t = rctx->t;
 	while (w.nbytes) {
 		unsigned int avail = w.nbytes;
 		le128 *wsrc;
@@ -113,8 +124,8 @@ static int xor_tweak(struct skcipher_request *req, bool second_pass)
 		wdst = w.dst.virt.addr;

 		do {
-			le128_xor(wdst++, &t, wsrc++);
-			gf128mul_x_ble(&t, &t);
+			le128_xor(wdst++, t, wsrc++);
+			gf128mul_x_ble(t, t);
 		} while ((avail -= bs) >= bs);

 		err = skcipher_walk_done(&w, avail);
@@ -123,14 +134,97 @@ static int xor_tweak(struct skcipher_request *req, bool second_pass)
 	return err;
 }

-static int xor_tweak_pre(struct skcipher_request *req)
+static int xor_tweak_pre(struct skcipher_request *req, le128 *t)
+{
+	return xor_tweak(req, false, t);
+}
+
+static int xor_tweak_post(struct skcipher_request *req, le128 *t)
 {
-	return xor_tweak(req, false);
+	return xor_tweak(req, true, t);
+}
+
+static void encrypt_finish_cts(struct skcipher_request *req)
+{
+	struct rctx *rctx = skcipher_request_ctx(req);
+	/* Not a multiple of cipher blocksize, need CTS applied */
+	struct priv *ctx = crypto_skcipher_ctx(crypto_skcipher_reqtfm(req));
+	le128 lastblock, lastptext;
+
+	/* Handle last partial block - apply Cipher Text Stealing */
+
+	/* Copy last ciphertext block just processed to buffer  */
+	sg_pcopy_to_buffer(req->dst, sg_nents(req->dst), &lastblock,
+			   XTS_BLOCK_SIZE,
+			   req->cryptlen - XTS_BLOCK_SIZE);
+	/* Save last plaintext bytes, next step may overwrite!! */
+	sg_pcopy_to_buffer(req->src, sg_nents(req->src), &lastptext,
+			   rctx->rem_bytes, req->cryptlen);
+	/* Copy first rem_bytes of ciphertext behind last full block */
+	sg_pcopy_from_buffer(req->dst, sg_nents(req->dst), &lastblock,
+			     rctx->rem_bytes, req->cryptlen);
+	/*
+	 * Copy last remaining bytes of plaintext to combine buffer,
+	 * replacing part of the ciphertext
+	 */
+	memcpy(&lastblock, &lastptext, rctx->rem_bytes);
+	/* XTS encrypt the combined block */
+	le128_xor(&lastblock, &rctx->tcur, &lastblock);
+	crypto_cipher_encrypt_one(ctx->base, (u8 *)&lastblock,
+				  (u8 *)&lastblock);
+	le128_xor(&lastblock, &rctx->tcur, &lastblock);
+	/* Write combined block to dst as 2nd last cipherblock */
+	sg_pcopy_from_buffer(req->dst, sg_nents(req->dst), &lastblock,
+			     XTS_BLOCK_SIZE,
+			     req->cryptlen - XTS_BLOCK_SIZE);
+
+	/* Fix up original request length */
+	req->cryptlen += rctx->rem_bytes;
+	return;
 }

-static int xor_tweak_post(struct skcipher_request *req)
+static void decrypt_finish_cts(struct skcipher_request *req)
 {
-	return xor_tweak(req, true);
+	struct rctx *rctx = skcipher_request_ctx(req);
+	/* Not a multiple of cipher blocksize, need CTS applied */
+	struct priv *ctx = crypto_skcipher_ctx(crypto_skcipher_reqtfm(req));
+	le128 tnext, lastblock, lastctext;
+
+	/* Handle last 2 (partial) blocks - apply Cipher Text Stealing */
+
+	/* Copy last full ciphertext block to buffer  */
+	sg_pcopy_to_buffer(req->src, sg_nents(req->src), &lastblock,
+			   XTS_BLOCK_SIZE, req->cryptlen);
+	/* Decrypt last full block using *next* tweak */
+	gf128mul_x_ble(&tnext, &rctx->tcur);
+	le128_xor(&lastblock, &tnext, &lastblock);
+	crypto_cipher_decrypt_one(ctx->base, (u8 *)&lastblock,
+				  (u8 *)&lastblock);
+	le128_xor(&lastblock, &tnext, &lastblock);
+	/* Save last ciphertext bytes, next step may overwrite!! */
+	sg_pcopy_to_buffer(req->src, sg_nents(req->src), &lastctext,
+			   rctx->rem_bytes, req->cryptlen + XTS_BLOCK_SIZE);
+	/* Copy first rem_bytes of this ptext as last partial block */
+	sg_pcopy_from_buffer(req->dst, sg_nents(req->dst), &lastblock,
+			     rctx->rem_bytes,
+			     req->cryptlen + XTS_BLOCK_SIZE);
+	/*
+	 * Copy last remaining bytes of "plaintext" to combine buffer,
+	 * replacing part of the ciphertext
+	 */
+	memcpy(&lastblock, &lastctext, rctx->rem_bytes);
+	/* XTS decrypt the combined block */
+	le128_xor(&lastblock, &rctx->tcur, &lastblock);
+	crypto_cipher_decrypt_one(ctx->base, (u8 *)&lastblock,
+				  (u8 *)&lastblock);
+	le128_xor(&lastblock, &rctx->tcur, &lastblock);
+	/* Write combined block to dst as 2nd last plaintext block */
+	sg_pcopy_from_buffer(req->dst, sg_nents(req->dst), &lastblock,
+			     XTS_BLOCK_SIZE, req->cryptlen);
+
+	/* Fix up original request length */
+	req->cryptlen += rctx->rem_bytes + XTS_BLOCK_SIZE;
+	return;
 }

 static void crypt_done(struct crypto_async_request *areq, int err)
@@ -139,9 +233,16 @@ static void crypt_done(struct crypto_async_request *areq, int err)

 	if (!err) {
 		struct rctx *rctx = skcipher_request_ctx(req);
+		le128 t;

 		rctx->subreq.base.flags &= ~CRYPTO_TFM_REQ_MAY_SLEEP;
-		err = xor_tweak_post(req);
+		err = xor_tweak_post(req, &t);
+
+		if (unlikely(!err && rctx->rem_bytes)) {
+			rctx->is_encrypt ?
+			  encrypt_finish_cts(req) :
+			  decrypt_finish_cts(req);
+		}
 	}

 	skcipher_request_complete(req, err);
@@ -167,10 +268,45 @@ static int encrypt(struct skcipher_request *req)
 	struct rctx *rctx = skcipher_request_ctx(req);
 	struct skcipher_request *subreq = &rctx->subreq;

+	/* IEEE P1619 does not allow less data than block cipher blocksize */
+	if (unlikely(req->cryptlen < XTS_BLOCK_SIZE))
+		return -EINVAL;
+
 	init_crypt(req);
-	return xor_tweak_pre(req) ?:
+
+	/* valid bytes in last crypto block */
+	rctx->rem_bytes = req->cryptlen & (XTS_BLOCK_SIZE - 1);
+	if (unlikely(rctx->rem_bytes)) {
+		/* Not a multiple of cipher blocksize, need CTS applied */
+		int err = 0;
+
+		/* First process all *full* cipher blocks */
+		req->cryptlen -= rctx->rem_bytes;
+		subreq->cryptlen -= rctx->rem_bytes;
+		err = xor_tweak_pre(req, &rctx->tcur);
+		if (err)
+			goto encrypt_exit;
+		rctx->is_encrypt = 1;
+		err = crypto_skcipher_encrypt(subreq);
+		if (err)
+			goto encrypt_exit;
+		err = xor_tweak_post(req, &rctx->tcur);
+		if (err)
+			goto encrypt_exit;
+
+		encrypt_finish_cts(req);
+		return 0;
+
+encrypt_exit:
+		/* Fix up original request length */
+		req->cryptlen += rctx->rem_bytes;
+		return err;
+	}
+
+	/* Multiple of cipher blocksize, no CTS required */
+	return xor_tweak_pre(req, &rctx->tcur) ?:
 		crypto_skcipher_encrypt(subreq) ?:
-		xor_tweak_post(req);
+		xor_tweak_post(req, &rctx->tcur);
 }

 static int decrypt(struct skcipher_request *req)
@@ -178,10 +314,50 @@ static int decrypt(struct skcipher_request *req)
 	struct rctx *rctx = skcipher_request_ctx(req);
 	struct skcipher_request *subreq = &rctx->subreq;

+	/* IEEE P1619 does not allow less data than block cipher blocksize */
+	if (unlikely(req->cryptlen < XTS_BLOCK_SIZE))
+		return -EINVAL;
+
 	init_crypt(req);
-	return xor_tweak_pre(req) ?:
+
+	/* valid bytes in last crypto block */
+	rctx->rem_bytes = req->cryptlen & (XTS_BLOCK_SIZE - 1);
+	if (unlikely(rctx->rem_bytes)) {
+		int err = 0;
+
+		/* First process all but the last(!) full cipher blocks */
+		req->cryptlen -= rctx->rem_bytes + XTS_BLOCK_SIZE;
+		subreq->cryptlen -= rctx->rem_bytes + XTS_BLOCK_SIZE;
+		/* May not have any full blocks to process here */
+		if (req->cryptlen) {
+			err = xor_tweak_pre(req, &rctx->tcur);
+			if (err)
+				goto decrypt_exit;
+			rctx->is_encrypt = 0;
+			err = crypto_skcipher_decrypt(subreq);
+			if (err)
+				goto decrypt_exit;
+			err = xor_tweak_post(req, &rctx->tcur);
+			if (err)
+				goto decrypt_exit;
+		} else {
+			/* Start from initial tweak */
+			rctx->tcur = rctx->t;
+		}
+
+		decrypt_finish_cts(req);
+		return 0;
+
+decrypt_exit:
+		/* Fix up original request length */
+		req->cryptlen += rctx->rem_bytes + XTS_BLOCK_SIZE;
+		return err;
+	}
+
+	/* Multiple of cipher blocksize, no CTS required */
+	return xor_tweak_pre(req, &rctx->tcur) ?:
 		crypto_skcipher_decrypt(subreq) ?:
-		xor_tweak_post(req);
+		xor_tweak_post(req, &rctx->tcur);
 }

 static int init_tfm(struct crypto_skcipher *tfm)
@@ -191,6 +367,7 @@ static int init_tfm(struct crypto_skcipher *tfm)
 	struct priv *ctx = crypto_skcipher_ctx(tfm);
 	struct crypto_skcipher *child;
 	struct crypto_cipher *tweak;
+	struct crypto_cipher *base;

 	child = crypto_spawn_skcipher(&ictx->spawn);
 	if (IS_ERR(child))
@@ -206,6 +383,16 @@ static int init_tfm(struct crypto_skcipher *tfm)

 	ctx->tweak = tweak;

+	base = crypto_alloc_cipher(ictx->name, 0, 0);
+	if (IS_ERR(base)) {
+		crypto_free_skcipher(ctx->child);
+		crypto_free_cipher(ctx->tweak);
+		return PTR_ERR(base);
+	}
+
+	ctx->base = base;
+
+	/* struct rctx expanded by sub cipher request size! */
 	crypto_skcipher_set_reqsize(tfm, crypto_skcipher_reqsize(child) +
 					 sizeof(struct rctx));

@@ -218,6 +405,7 @@ static void exit_tfm(struct crypto_skcipher *tfm)

 	crypto_free_skcipher(ctx->child);
 	crypto_free_cipher(ctx->tweak);
+	crypto_free_cipher(ctx->base);
 }

 static void free(struct skcipher_instance *inst)
@@ -314,11 +502,12 @@ static int create(struct crypto_template *tmpl, struct rtattr **tb)

 	inst->alg.base.cra_flags = alg->base.cra_flags & CRYPTO_ALG_ASYNC;
 	inst->alg.base.cra_priority = alg->base.cra_priority;
-	inst->alg.base.cra_blocksize = XTS_BLOCK_SIZE;
+	inst->alg.base.cra_blocksize = 1;
 	inst->alg.base.cra_alignmask = alg->base.cra_alignmask |
 				       (__alignof__(u64) - 1);

 	inst->alg.ivsize = XTS_BLOCK_SIZE;
+	inst->alg.chunksize = XTS_BLOCK_SIZE;
 	inst->alg.min_keysize = crypto_skcipher_alg_min_keysize(alg) * 2;
 	inst->alg.max_keysize = crypto_skcipher_alg_max_keysize(alg) * 2;

--
1.8.3.1
