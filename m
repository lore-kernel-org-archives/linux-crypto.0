Return-Path: <SRS0=y31I=WC=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A7A2EC433FF
	for <linux-crypto@archiver.kernel.org>; Tue,  6 Aug 2019 07:58:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 66C212070C
	for <linux-crypto@archiver.kernel.org>; Tue,  6 Aug 2019 07:58:02 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="LXubnSdM"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728991AbfHFH6B (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 6 Aug 2019 03:58:01 -0400
Received: from mail-ed1-f50.google.com ([209.85.208.50]:39530 "EHLO
        mail-ed1-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728975AbfHFH6B (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 6 Aug 2019 03:58:01 -0400
Received: by mail-ed1-f50.google.com with SMTP id m10so81434247edv.6
        for <linux-crypto@vger.kernel.org>; Tue, 06 Aug 2019 00:57:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=xyFrj9NBv3QXbhTRv+SKv7OJLe6BC8nbNH1veGirroY=;
        b=LXubnSdMDs2peNh7pAnD+hiS1gm3jb6J0WWAhceFp5oPBSAdcvp/mmNTH5eM9NDeCc
         AWX1mTketqpXJm6dAz1k70gqfPGVmD+iN4K3s6GtCAhaKBFZWdDUoehr9EXEQHE8ziJg
         Z7mNf9QUDwcFTb5OrljQknILRXEvdehAeAMGFXSFjVUmFYVw2a9cQCXRGj4tEyznHP5b
         +uz6OuTW+HSB2qKh9IXhyjlc4oRMHm1K8scxCpBqlRArj5h6QDg69atSIpxvYgAqx2u6
         1U2KQxEgsfHRlQ/yByD6Mh7LkN6iI52cU0pZ9JfI7VYKomxCcT7EXd+UHhGoy9R4Tem2
         cBeQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=xyFrj9NBv3QXbhTRv+SKv7OJLe6BC8nbNH1veGirroY=;
        b=ad71wsdBzaYsR/yM7JIw+Rjw7KzZ+Xy6HRVR0vwsYdIOkNqx8ONC4jtFMdKyV1cAdu
         XOVdlO9umOWWZvez5/L195tLHR8Pwz/iXjgCAFmigW0GF1CfwiTUGHtX+lcgugIKOTkV
         QIlN9At8AbQmzoIOhL5zg0HO9PcRoV+LtVojbmHHBQkyPg9IUSHkbg+PyNP8t3VyZ6Ra
         wqIR3VmDIgSxqAiXiaw6gbzM5q6PDa+WqJNfDyJwOFXwVHmwZ4hoix+fAMSLP62mljXH
         YmnTLzdPWA6Kwo5S+fvj5J7G9PgOUQd1QfbeJUBFb7Tq3LQa06iyaZl9SvbITSIDl1Yi
         JgUg==
X-Gm-Message-State: APjAAAUHbl5FLo07kaPxucaWQn+NSI5NH7gpLsaCIJd5LFydcX7NkhTg
        FaAHMV+uq9dS8lnfwV13WO25WZOg
X-Google-Smtp-Source: APXvYqywIS54E6HkKAa6HHsDx7B853bDb69jhBUL0bdazTrvlD/UgBko1Nok3ComYhluA5gNX5MuoA==
X-Received: by 2002:aa7:d0cc:: with SMTP id u12mr2450984edo.212.1565078278492;
        Tue, 06 Aug 2019 00:57:58 -0700 (PDT)
Received: from localhost.localdomain.com ([188.204.2.113])
        by smtp.gmail.com with ESMTPSA id u7sm14635402ejm.48.2019.08.06.00.57.57
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 06 Aug 2019 00:57:57 -0700 (PDT)
From:   Pascal van Leeuwen <pascalvanl@gmail.com>
X-Google-Original-From: Pascal van Leeuwen <pvanleeuwen@verimatrix.com>
To:     linux-crypto@vger.kernel.org
Cc:     rsnel@cube.dyndns.org, herbert@gondor.apana.org.au,
        davem@davemloft.net,
        Pascal van Leeuwen <pvanleeuwen@verimatrix.com>
Subject: [PATCH] crypto: xts - Add support for Cipher Text Stealing
Date:   Tue,  6 Aug 2019 08:55:10 +0200
Message-Id: <1565074510-8480-1-git-send-email-pvanleeuwen@verimatrix.com>
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

Signed-off-by: Pascal van Leeuwen <pvanleeuwen@verimatrix.com>
---
 crypto/xts.c | 230 +++++++++++++++++++++++++++++++++++++++++++++++++++++------
 1 file changed, 210 insertions(+), 20 deletions(-)

diff --git a/crypto/xts.c b/crypto/xts.c
index 33cf726..9e48876 100644
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
 
@@ -37,8 +36,9 @@ struct xts_instance_ctx {
 };
 
 struct rctx {
-	le128 t;
+	le128 t, tcur;
 	struct skcipher_request subreq;
+	int rem_bytes, is_encrypt;
 };
 
 static int setkey(struct crypto_skcipher *parent, const u8 *key,
@@ -47,6 +47,7 @@ static int setkey(struct crypto_skcipher *parent, const u8 *key,
 	struct priv *ctx = crypto_skcipher_ctx(parent);
 	struct crypto_skcipher *child;
 	struct crypto_cipher *tweak;
+	struct crypto_cipher *base;
 	int err;
 
 	err = xts_verify_key(parent, key, keylen);
@@ -55,9 +56,11 @@ static int setkey(struct crypto_skcipher *parent, const u8 *key,
 
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
@@ -79,6 +82,13 @@ static int setkey(struct crypto_skcipher *parent, const u8 *key,
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
 
@@ -88,13 +98,12 @@ static int setkey(struct crypto_skcipher *parent, const u8 *key,
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
@@ -104,6 +113,7 @@ static int xor_tweak(struct skcipher_request *req, bool second_pass)
 	}
 	err = skcipher_walk_virt(&w, req, false);
 
+	*t = rctx->t;
 	while (w.nbytes) {
 		unsigned int avail = w.nbytes;
 		le128 *wsrc;
@@ -113,8 +123,8 @@ static int xor_tweak(struct skcipher_request *req, bool second_pass)
 		wdst = w.dst.virt.addr;
 
 		do {
-			le128_xor(wdst++, &t, wsrc++);
-			gf128mul_x_ble(&t, &t);
+			le128_xor(wdst++, t, wsrc++);
+			gf128mul_x_ble(t, t);
 		} while ((avail -= bs) >= bs);
 
 		err = skcipher_walk_done(&w, avail);
@@ -123,14 +133,102 @@ static int xor_tweak(struct skcipher_request *req, bool second_pass)
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
 }
 
-static int xor_tweak_post(struct skcipher_request *req)
+static int encrypt_finish_cts(struct skcipher_request *req)
 {
-	return xor_tweak(req, true);
+	struct rctx *rctx = skcipher_request_ctx(req);
+	/* Not a multiple of cipher blocksize, need CTS applied */
+	struct priv *ctx = crypto_skcipher_ctx(crypto_skcipher_reqtfm(req));
+	le128 lastblock, lastptext;
+	int err = 0;
+
+	/*
+	 * Handle last partial block - apply Cipher Text Stealing
+	 */
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
+	return err;
+}
+
+static int decrypt_finish_cts(struct skcipher_request *req)
+{
+	struct rctx *rctx = skcipher_request_ctx(req);
+	/* Not a multiple of cipher blocksize, need CTS applied */
+	struct priv *ctx = crypto_skcipher_ctx(crypto_skcipher_reqtfm(req));
+	le128 tnext, lastblock, lastctext;
+	int err = 0;
+
+	/*
+	 * Handle last 2 (partial) blocks - apply Cipher Text Stealing
+	 */
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
+	return err;
 }
 
 static void crypt_done(struct crypto_async_request *areq, int err)
@@ -139,9 +237,16 @@ static void crypt_done(struct crypto_async_request *areq, int err)
 
 	if (!err) {
 		struct rctx *rctx = skcipher_request_ctx(req);
+		le128 t;
 
 		rctx->subreq.base.flags &= ~CRYPTO_TFM_REQ_MAY_SLEEP;
-		err = xor_tweak_post(req);
+		err = xor_tweak_post(req, &t);
+
+		if (unlikely(!err && rctx->rem_bytes)) {
+			err = rctx->is_encrypt ?
+				encrypt_finish_cts(req) :
+				decrypt_finish_cts(req);
+		}
 	}
 
 	skcipher_request_complete(req, err);
@@ -167,10 +272,44 @@ static int encrypt(struct skcipher_request *req)
 	struct rctx *rctx = skcipher_request_ctx(req);
 	struct skcipher_request *subreq = &rctx->subreq;
 
+	/* valid bytes in last crypto block */
+	rctx->rem_bytes = req->cryptlen & (XTS_BLOCK_SIZE - 1);
+
+	/* IEEE P1619 does not allow less data than block cipher blocksize */
+	if (unlikely(req->cryptlen < XTS_BLOCK_SIZE))
+		return -EINVAL;
+
 	init_crypt(req);
-	return xor_tweak_pre(req) ?:
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
+		return encrypt_finish_cts(req);
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
@@ -178,10 +317,49 @@ static int decrypt(struct skcipher_request *req)
 	struct rctx *rctx = skcipher_request_ctx(req);
 	struct skcipher_request *subreq = &rctx->subreq;
 
+	/* valid bytes in last crypto block */
+	rctx->rem_bytes = req->cryptlen & (XTS_BLOCK_SIZE - 1);
+
+	/* IEEE P1619 does not allow less data than block cipher blocksize */
+	if (unlikely(req->cryptlen < XTS_BLOCK_SIZE))
+		return -EINVAL;
+
 	init_crypt(req);
-	return xor_tweak_pre(req) ?:
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
+		return decrypt_finish_cts(req);
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
@@ -191,6 +369,7 @@ static int init_tfm(struct crypto_skcipher *tfm)
 	struct priv *ctx = crypto_skcipher_ctx(tfm);
 	struct crypto_skcipher *child;
 	struct crypto_cipher *tweak;
+	struct crypto_cipher *base;
 
 	child = crypto_spawn_skcipher(&ictx->spawn);
 	if (IS_ERR(child))
@@ -206,6 +385,15 @@ static int init_tfm(struct crypto_skcipher *tfm)
 
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
 	crypto_skcipher_set_reqsize(tfm, crypto_skcipher_reqsize(child) +
 					 sizeof(struct rctx));
 
@@ -218,6 +406,7 @@ static void exit_tfm(struct crypto_skcipher *tfm)
 
 	crypto_free_skcipher(ctx->child);
 	crypto_free_cipher(ctx->tweak);
+	crypto_free_cipher(ctx->base);
 }
 
 static void free(struct skcipher_instance *inst)
@@ -314,11 +503,12 @@ static int create(struct crypto_template *tmpl, struct rtattr **tb)
 
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

