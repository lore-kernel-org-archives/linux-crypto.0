Return-Path: <SRS0=Ue/q=WF=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 58CD0C31E40
	for <linux-crypto@archiver.kernel.org>; Fri,  9 Aug 2019 17:15:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2140120820
	for <linux-crypto@archiver.kernel.org>; Fri,  9 Aug 2019 17:15:07 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="XcW2Jzal"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437246AbfHIRPG (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 9 Aug 2019 13:15:06 -0400
Received: from mail-wr1-f41.google.com ([209.85.221.41]:39343 "EHLO
        mail-wr1-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2437053AbfHIRPG (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 9 Aug 2019 13:15:06 -0400
Received: by mail-wr1-f41.google.com with SMTP id t16so8790420wra.6
        for <linux-crypto@vger.kernel.org>; Fri, 09 Aug 2019 10:15:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id;
        bh=T2KYQvEBWfQ92a7ZjFEnHaEMAZabfEsZfWg+6/+Zzio=;
        b=XcW2Jzalj65mYTxnIVI4FlGeTR/b914NWFbEqg5JhpnIikYIlHn0Xu1Umi2iYVFfcE
         9c3voIBnyS7Npfl7TUPbt+TEihrxf52IcWZjbexPTh60yYhNf9mPe7M5sceFPcGrSMhv
         dJOPnXh1FGf0j80KgqaxU5N9hWEweb7usRu1N9XgSfQpcqarvTXLxtxLbzBXqBCB7jya
         o7ILIzOCzFaoMLw4mDK0T9NO8/zjAXilzB6hlJkkhrahGe7g2Z4HFnni8IrrQZ+7l6Ij
         Ph84ZMvj5/r3gbKb07oTgDkvO7eKlEXuByMULh20TfGN/NnuNfq/Fw8bBNzx7PlX6nok
         nl5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=T2KYQvEBWfQ92a7ZjFEnHaEMAZabfEsZfWg+6/+Zzio=;
        b=IvN5snyQcjCwyeiMPKmPArwGVQonn+evQryrQDh9jQbXzjNhKvOZmQTE8z25/Ry2XA
         MVLnE+z60/goTa9MGFzTeLCrcob+N1QyRaEPVlETRDScvHhSET+rfqE7t4b97jPyLbag
         1jPqyOLJsPNqZev2wiW+PPC5RvtDEQSrSifRoLYOp5qiifW1KJJ25ADodZlDoiKu8zGr
         0QlPwo/SIlhDhsLOwpWR+PFqbkcsNdKGsXADTS9hvSOKw1EwEjuBGKTeWJbCzXKmRuK0
         NR7vP+ohm6iy7y8GBMvvDzkenB5NIPdlHeQtp9GAP1+5pba5i5PMBpwl8kAswhm+fV6d
         H1kw==
X-Gm-Message-State: APjAAAUT+fqmCyIujfQ8wAE4zDxxmaV4VQDYRJImm5H5B31X48oYxT2q
        3MlNlAEOVaBYEs43g5m8n5zTPNnxSQiwiw==
X-Google-Smtp-Source: APXvYqxP+OcHnN1Gzww67vs3cg2AYGbVQAvgqGKTlWnmdQFNnajiIXLcQ4lGpEYVvZ+yh3FcW9BZhQ==
X-Received: by 2002:a5d:63c8:: with SMTP id c8mr26651849wrw.21.1565370904529;
        Fri, 09 Aug 2019 10:15:04 -0700 (PDT)
Received: from localhost.localdomain ([2a02:587:a407:da00:582f:8334:9cd9:7241])
        by smtp.gmail.com with ESMTPSA id 18sm4196410wmg.43.2019.08.09.10.15.02
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 09 Aug 2019 10:15:03 -0700 (PDT)
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
To:     linux-crypto@vger.kernel.org
Cc:     herbert@gondor.apana.org.au, ebiggers@kernel.org,
        gmazyland@gmail.com, Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Pascal van Leeuwen <pvanleeuwen@verimatrix.com>,
        Ondrej Mosnacek <omosnace@redhat.com>
Subject: [PATCH v2] crypto: xts - add support for ciphertext stealing
Date:   Fri,  9 Aug 2019 20:14:57 +0300
Message-Id: <20190809171457.12400-1-ard.biesheuvel@linaro.org>
X-Mailer: git-send-email 2.17.1
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Add support for the missing ciphertext stealing part of the XTS-AES
specification, which permits inputs of any size >= the block size.

Cc: Pascal van Leeuwen <pvanleeuwen@verimatrix.com>
Cc: Ondrej Mosnacek <omosnace@redhat.com>
Tested-by: Milan Broz <gmazyland@gmail.com>
Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
v2: fix scatterlist issue in async handling
    remove stale comment

 crypto/xts.c | 152 +++++++++++++++++---
 1 file changed, 132 insertions(+), 20 deletions(-)

diff --git a/crypto/xts.c b/crypto/xts.c
index 11211003db7e..78c19e4dde7d 100644
--- a/crypto/xts.c
+++ b/crypto/xts.c
@@ -1,8 +1,6 @@
 // SPDX-License-Identifier: GPL-2.0-or-later
 /* XTS: as defined in IEEE1619/D16
  *	http://grouper.ieee.org/groups/1619/email/pdf00086.pdf
- *	(sector sizes which are not a multiple of 16 bytes are,
- *	however currently unsupported)
  *
  * Copyright (c) 2007 Rik Snel <rsnel@cube.dyndns.org>
  *
@@ -34,6 +32,8 @@ struct xts_instance_ctx {
 
 struct rctx {
 	le128 t;
+	struct scatterlist *tail;
+	struct scatterlist sg[2];
 	struct skcipher_request subreq;
 };
 
@@ -84,10 +84,11 @@ static int setkey(struct crypto_skcipher *parent, const u8 *key,
  * mutliple calls to the 'ecb(..)' instance, which usually would be slower than
  * just doing the gf128mul_x_ble() calls again.
  */
-static int xor_tweak(struct skcipher_request *req, bool second_pass)
+static int xor_tweak(struct skcipher_request *req, bool second_pass, bool enc)
 {
 	struct rctx *rctx = skcipher_request_ctx(req);
 	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
+	const bool cts = (req->cryptlen % XTS_BLOCK_SIZE);
 	const int bs = XTS_BLOCK_SIZE;
 	struct skcipher_walk w;
 	le128 t = rctx->t;
@@ -109,6 +110,20 @@ static int xor_tweak(struct skcipher_request *req, bool second_pass)
 		wdst = w.dst.virt.addr;
 
 		do {
+			if (unlikely(cts) &&
+			    w.total - w.nbytes + avail < 2 * XTS_BLOCK_SIZE) {
+				if (!enc) {
+					if (second_pass)
+						rctx->t = t;
+					gf128mul_x_ble(&t, &t);
+				}
+				le128_xor(wdst, &t, wsrc);
+				if (enc && second_pass)
+					gf128mul_x_ble(&rctx->t, &t);
+				skcipher_walk_done(&w, avail - bs);
+				return 0;
+			}
+
 			le128_xor(wdst++, &t, wsrc++);
 			gf128mul_x_ble(&t, &t);
 		} while ((avail -= bs) >= bs);
@@ -119,17 +134,71 @@ static int xor_tweak(struct skcipher_request *req, bool second_pass)
 	return err;
 }
 
-static int xor_tweak_pre(struct skcipher_request *req)
+static int xor_tweak_pre(struct skcipher_request *req, bool enc)
 {
-	return xor_tweak(req, false);
+	return xor_tweak(req, false, enc);
 }
 
-static int xor_tweak_post(struct skcipher_request *req)
+static int xor_tweak_post(struct skcipher_request *req, bool enc)
 {
-	return xor_tweak(req, true);
+	return xor_tweak(req, true, enc);
 }
 
-static void crypt_done(struct crypto_async_request *areq, int err)
+static void cts_done(struct crypto_async_request *areq, int err)
+{
+	struct skcipher_request *req = areq->data;
+	le128 b;
+
+	if (!err) {
+		struct rctx *rctx = skcipher_request_ctx(req);
+
+		scatterwalk_map_and_copy(&b, rctx->tail, 0, XTS_BLOCK_SIZE, 0);
+		le128_xor(&b, &rctx->t, &b);
+		scatterwalk_map_and_copy(&b, rctx->tail, 0, XTS_BLOCK_SIZE, 1);
+	}
+
+	skcipher_request_complete(req, err);
+}
+
+static int cts_final(struct skcipher_request *req,
+		     int (*crypt)(struct skcipher_request *req))
+{
+	struct priv *ctx = crypto_skcipher_ctx(crypto_skcipher_reqtfm(req));
+	int offset = req->cryptlen & ~(XTS_BLOCK_SIZE - 1);
+	struct rctx *rctx = skcipher_request_ctx(req);
+	struct skcipher_request *subreq = &rctx->subreq;
+	int tail = req->cryptlen % XTS_BLOCK_SIZE;
+	le128 b[2];
+	int err;
+
+	rctx->tail = scatterwalk_ffwd(rctx->sg, req->dst,
+				      offset - XTS_BLOCK_SIZE);
+
+	scatterwalk_map_and_copy(b, rctx->tail, 0, XTS_BLOCK_SIZE, 0);
+	memcpy(b + 1, b, tail);
+	scatterwalk_map_and_copy(b, req->src, offset, tail, 0);
+
+	le128_xor(b, &rctx->t, b);
+
+	scatterwalk_map_and_copy(b, rctx->tail, 0, XTS_BLOCK_SIZE + tail, 1);
+
+	skcipher_request_set_tfm(subreq, ctx->child);
+	skcipher_request_set_callback(subreq, req->base.flags, cts_done, req);
+	skcipher_request_set_crypt(subreq, rctx->tail, rctx->tail,
+				   XTS_BLOCK_SIZE, NULL);
+
+	err = crypt(subreq);
+	if (err)
+		return err;
+
+	scatterwalk_map_and_copy(b, rctx->tail, 0, XTS_BLOCK_SIZE, 0);
+	le128_xor(b, &rctx->t, b);
+	scatterwalk_map_and_copy(b, rctx->tail, 0, XTS_BLOCK_SIZE, 1);
+
+	return 0;
+}
+
+static void encrypt_done(struct crypto_async_request *areq, int err)
 {
 	struct skcipher_request *req = areq->data;
 
@@ -137,47 +206,90 @@ static void crypt_done(struct crypto_async_request *areq, int err)
 		struct rctx *rctx = skcipher_request_ctx(req);
 
 		rctx->subreq.base.flags &= ~CRYPTO_TFM_REQ_MAY_SLEEP;
-		err = xor_tweak_post(req);
+		err = xor_tweak_post(req, true);
+
+		if (!err && unlikely(req->cryptlen % XTS_BLOCK_SIZE)) {
+			err = cts_final(req, crypto_skcipher_encrypt);
+			if (err == -EINPROGRESS)
+				return;
+		}
 	}
 
 	skcipher_request_complete(req, err);
 }
 
-static void init_crypt(struct skcipher_request *req)
+static void decrypt_done(struct crypto_async_request *areq, int err)
+{
+	struct skcipher_request *req = areq->data;
+
+	if (!err) {
+		struct rctx *rctx = skcipher_request_ctx(req);
+
+		rctx->subreq.base.flags &= ~CRYPTO_TFM_REQ_MAY_SLEEP;
+		err = xor_tweak_post(req, false);
+
+		if (!err && unlikely(req->cryptlen % XTS_BLOCK_SIZE)) {
+			err = cts_final(req, crypto_skcipher_decrypt);
+			if (err == -EINPROGRESS)
+				return;
+		}
+	}
+
+	skcipher_request_complete(req, err);
+}
+
+static int init_crypt(struct skcipher_request *req, crypto_completion_t compl)
 {
 	struct priv *ctx = crypto_skcipher_ctx(crypto_skcipher_reqtfm(req));
 	struct rctx *rctx = skcipher_request_ctx(req);
 	struct skcipher_request *subreq = &rctx->subreq;
 
+	if (req->cryptlen < XTS_BLOCK_SIZE)
+		return -EINVAL;
+
 	skcipher_request_set_tfm(subreq, ctx->child);
-	skcipher_request_set_callback(subreq, req->base.flags, crypt_done, req);
+	skcipher_request_set_callback(subreq, req->base.flags, compl, req);
 	skcipher_request_set_crypt(subreq, req->dst, req->dst,
-				   req->cryptlen, NULL);
+				   req->cryptlen & ~(XTS_BLOCK_SIZE - 1), NULL);
 
 	/* calculate first value of T */
 	crypto_cipher_encrypt_one(ctx->tweak, (u8 *)&rctx->t, req->iv);
+
+	return 0;
 }
 
 static int encrypt(struct skcipher_request *req)
 {
 	struct rctx *rctx = skcipher_request_ctx(req);
 	struct skcipher_request *subreq = &rctx->subreq;
+	int err;
 
-	init_crypt(req);
-	return xor_tweak_pre(req) ?:
-		crypto_skcipher_encrypt(subreq) ?:
-		xor_tweak_post(req);
+	err = init_crypt(req, encrypt_done) ?:
+	      xor_tweak_pre(req, true) ?:
+	      crypto_skcipher_encrypt(subreq) ?:
+	      xor_tweak_post(req, true);
+
+	if (err || likely((req->cryptlen % XTS_BLOCK_SIZE) == 0))
+		return err;
+
+	return cts_final(req, crypto_skcipher_encrypt);
 }
 
 static int decrypt(struct skcipher_request *req)
 {
 	struct rctx *rctx = skcipher_request_ctx(req);
 	struct skcipher_request *subreq = &rctx->subreq;
+	int err;
+
+	err = init_crypt(req, decrypt_done) ?:
+	      xor_tweak_pre(req, false) ?:
+	      crypto_skcipher_decrypt(subreq) ?:
+	      xor_tweak_post(req, false);
+
+	if (err || likely((req->cryptlen % XTS_BLOCK_SIZE) == 0))
+		return err;
 
-	init_crypt(req);
-	return xor_tweak_pre(req) ?:
-		crypto_skcipher_decrypt(subreq) ?:
-		xor_tweak_post(req);
+	return cts_final(req, crypto_skcipher_decrypt);
 }
 
 static int init_tfm(struct crypto_skcipher *tfm)
-- 
2.17.1

