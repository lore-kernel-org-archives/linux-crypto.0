Return-Path: <SRS0=Ue/q=WF=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C3C5CC31E40
	for <linux-crypto@archiver.kernel.org>; Fri,  9 Aug 2019 06:31:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8B1282089E
	for <linux-crypto@archiver.kernel.org>; Fri,  9 Aug 2019 06:31:20 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="zJPMZLCi"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405646AbfHIGbT (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 9 Aug 2019 02:31:19 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:36811 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2405592AbfHIGbS (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 9 Aug 2019 02:31:18 -0400
Received: by mail-wm1-f68.google.com with SMTP id g67so4551595wme.1
        for <linux-crypto@vger.kernel.org>; Thu, 08 Aug 2019 23:31:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id;
        bh=NOAEKiGjAYtEe06wvKtXeopdPVoeTZOboIwFi7pflPo=;
        b=zJPMZLCilJktkTEVJ9oYs6liR/5yOpWd+sbFGniecN69e3QgBTrSicp04yvhbfbr+g
         jzPy1dlfOdBzCW2t2gDreLEN35u5a/4jR8+CwLLbHmNa5jXNpan1XBBgS0Xni7DGD5WO
         yJs00OkOXV3mhnQ8AHceBQPIxUx0sw8H/Tt0mKrns74hQkq2lyRTqh3tswfwcQjv4mAg
         vzuiVztrsoebxsqEgkc3xNnEdauovn8prsOFJtcEs6fM+vQusekin8chupmpAIhX1jsj
         MH0NnqFEd5gvD/u6FXIEbNj0OXHrUZ+B68le+vgGG3la3dnb5iKK2QW7LI5K+0qVRRhs
         MLNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=NOAEKiGjAYtEe06wvKtXeopdPVoeTZOboIwFi7pflPo=;
        b=crz9vc3QdRZpfLZ1YCN6C9vHMkxwA4LW8JVrNSHZKZNYzyWRuJ3e81t8Fxohu5MP8S
         VUYazpAiPuVbaEmJsKgBv6oWhWZ2huGvM8dJ2o1IrYVF313ujVeqeKgav1MZ4NmROBFq
         JpPaReuPYNXe7i4qmoHAxfwha+J/Nj2xoARyTq+S6NFJiOeBH6nAqF5A8Vyt0RvfouET
         eP3wr/15QkB+cVysqhMSEbjsl1FCi6i3t9P0Fi1dZ9vT09oktaIBYno7Y2Jsf1Tqcaj9
         QHS2y7seD4DSLbVSctmkL+Pf8RefbYWjKTi+z/iXuJK8WeWPNGrP2G9b7jinqce+HGPC
         hXiQ==
X-Gm-Message-State: APjAAAWx+vWfaGx6/rilwyi613+7SDCjcmD72D7EUI8Wcv3ySkREEBhz
        cpnSDNF9Bcg+rpWyIboF/BZHj6L6PF3DIQ==
X-Google-Smtp-Source: APXvYqxUhyR48pTPKbsZmMj+jLWlRN66i6ji5StAhTLyLfej8l6WA483S+xNJCYpeuFL20GL3rgM/A==
X-Received: by 2002:a1c:751a:: with SMTP id o26mr8562577wmc.13.1565332275620;
        Thu, 08 Aug 2019 23:31:15 -0700 (PDT)
Received: from localhost.localdomain ([2a02:587:a407:da00:582f:8334:9cd9:7241])
        by smtp.gmail.com with ESMTPSA id s64sm3645404wmf.16.2019.08.08.23.31.13
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 08 Aug 2019 23:31:14 -0700 (PDT)
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
To:     linux-crypto@vger.kernel.org
Cc:     herbert@gondor.apana.org.au, ebiggers@kernel.org,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Pascal van Leeuwen <pvanleeuwen@verimatrix.com>,
        Ondrej Mosnacek <omosnace@redhat.com>,
        Milan Broz <gmazyland@gmail.com>
Subject: [PATCH] crypto: xts - add support for ciphertext stealing
Date:   Fri,  9 Aug 2019 09:31:06 +0300
Message-Id: <20190809063106.316-1-ard.biesheuvel@linaro.org>
X-Mailer: git-send-email 2.17.1
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Add support for the missing ciphertext stealing part of the XTS-AES
specification, which permits inputs of any size >= the block size.

Cc: Pascal van Leeuwen <pvanleeuwen@verimatrix.com>
Cc: Ondrej Mosnacek <omosnace@redhat.com>
Cc: Milan Broz <gmazyland@gmail.com>
Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
This is an alternative approach to Pascal's [0]: instead of instantiating
a separate cipher to deal with the tail, invoke the same ECB skcipher used
for the bulk of the data.

[0] https://lore.kernel.org/linux-crypto/1565245094-8584-1-git-send-email-pvanleeuwen@verimatrix.com/

 crypto/xts.c | 148 +++++++++++++++++---
 1 file changed, 130 insertions(+), 18 deletions(-)

diff --git a/crypto/xts.c b/crypto/xts.c
index 11211003db7e..fc9edc6eb11e 100644
--- a/crypto/xts.c
+++ b/crypto/xts.c
@@ -34,6 +34,7 @@ struct xts_instance_ctx {
 
 struct rctx {
 	le128 t;
+	struct scatterlist sg[2];
 	struct skcipher_request subreq;
 };
 
@@ -84,10 +85,11 @@ static int setkey(struct crypto_skcipher *parent, const u8 *key,
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
@@ -109,6 +111,20 @@ static int xor_tweak(struct skcipher_request *req, bool second_pass)
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
@@ -119,17 +135,70 @@ static int xor_tweak(struct skcipher_request *req, bool second_pass)
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
+		scatterwalk_map_and_copy(&b, rctx->sg, 0, XTS_BLOCK_SIZE, 0);
+		le128_xor(&b, &rctx->t, &b);
+		scatterwalk_map_and_copy(&b, rctx->sg, 0, XTS_BLOCK_SIZE, 1);
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
+	struct scatterlist *sg;
+	le128 b[2];
+	int err;
+
+	sg = scatterwalk_ffwd(rctx->sg, req->dst, offset - XTS_BLOCK_SIZE);
+
+	scatterwalk_map_and_copy(b, sg, 0, XTS_BLOCK_SIZE, 0);
+	memcpy(b + 1, b, tail);
+	scatterwalk_map_and_copy(b, req->src, offset, tail, 0);
+
+	le128_xor(b, &rctx->t, b);
+
+	scatterwalk_map_and_copy(b, sg, 0, XTS_BLOCK_SIZE + tail, 1);
+
+	skcipher_request_set_tfm(subreq, ctx->child);
+	skcipher_request_set_callback(subreq, req->base.flags, cts_done, req);
+	skcipher_request_set_crypt(subreq, sg, sg, XTS_BLOCK_SIZE, NULL);
+
+	err = crypt(subreq);
+	if (err)
+		return err;
+
+	scatterwalk_map_and_copy(b, sg, 0, XTS_BLOCK_SIZE, 0);
+	le128_xor(b, &rctx->t, b);
+	scatterwalk_map_and_copy(b, sg, 0, XTS_BLOCK_SIZE, 1);
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

