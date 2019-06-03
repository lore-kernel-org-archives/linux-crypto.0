Return-Path: <SRS0=YB2u=UC=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,T_DKIMWL_WL_HIGH,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5D2E9C04AB6
	for <linux-crypto@archiver.kernel.org>; Mon,  3 Jun 2019 05:47:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3087C2773E
	for <linux-crypto@archiver.kernel.org>; Mon,  3 Jun 2019 05:47:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1559540821;
	bh=w1b7Q/clVm3Mnv42v204TjGW1otIpxlAoDLbHQWVRR8=;
	h=From:To:Cc:Subject:Date:List-ID:From;
	b=HoHjkmWQPyMY2lRR8NJr5+uXo9qsy+qMdS4Unj2IIe+v+ugpMl80HIXHtkBNqhWj+
	 lAZYcTFdry45uQoObA0zH3Vg1QoUe/lYmfRa2PxgP/X+XsmpuL95rKCYWeMW9PS2V6
	 JHzdIcaOh7FY/6wfzR/IRy16iefNf4DqpDExScNo=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726520AbfFCFrA (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 3 Jun 2019 01:47:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:58854 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726314AbfFCFrA (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 3 Jun 2019 01:47:00 -0400
Received: from sol.localdomain (c-24-5-143-220.hsd1.ca.comcast.net [24.5.143.220])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 11D1127739;
        Mon,  3 Jun 2019 05:46:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559540819;
        bh=w1b7Q/clVm3Mnv42v204TjGW1otIpxlAoDLbHQWVRR8=;
        h=From:To:Cc:Subject:Date:From;
        b=Cp41e3zKaqfHrtHo1TwQdAEw9JGhx7OIxaodin/IqmPATmOFglyJ70uUSVDXI3Ua4
         rgfUnXCyJRGpT8UJkBMg59GgHVy4riPTi+gXWUs38syjbJJ4rWHoXAg7404QZvKoAY
         Km/Kj2NGQYzaHhSwTpV291wPcDq3Y+E1kBNnM3N0=
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-crypto@vger.kernel.org
Cc:     Martin Willi <martin@strongswan.org>
Subject: [PATCH] crypto: chacha20poly1305 - a few cleanups
Date:   Sun,  2 Jun 2019 22:46:34 -0700
Message-Id: <20190603054634.6363-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

- Use sg_init_one() instead of sg_init_table() then sg_set_buf().

- Remove unneeded calls to sg_init_table() prior to scatterwalk_ffwd().

- Simplify initializing the poly tail block.

- Simplify computing padlen.

This doesn't change any actual behavior.

Cc: Martin Willi <martin@strongswan.org>
Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 crypto/chacha20poly1305.c | 43 ++++++++++++---------------------------
 1 file changed, 13 insertions(+), 30 deletions(-)

diff --git a/crypto/chacha20poly1305.c b/crypto/chacha20poly1305.c
index acbbf010222e3..76c13dab217d9 100644
--- a/crypto/chacha20poly1305.c
+++ b/crypto/chacha20poly1305.c
@@ -139,14 +139,10 @@ static int chacha_decrypt(struct aead_request *req)
 
 	chacha_iv(creq->iv, req, 1);
 
-	sg_init_table(rctx->src, 2);
 	src = scatterwalk_ffwd(rctx->src, req->src, req->assoclen);
 	dst = src;
-
-	if (req->src != req->dst) {
-		sg_init_table(rctx->dst, 2);
+	if (req->src != req->dst)
 		dst = scatterwalk_ffwd(rctx->dst, req->dst, req->assoclen);
-	}
 
 	skcipher_request_set_callback(&creq->req, rctx->flags,
 				      chacha_decrypt_done, req);
@@ -182,15 +178,11 @@ static int poly_tail(struct aead_request *req)
 	struct chachapoly_ctx *ctx = crypto_aead_ctx(tfm);
 	struct chachapoly_req_ctx *rctx = aead_request_ctx(req);
 	struct poly_req *preq = &rctx->u.poly;
-	__le64 len;
 	int err;
 
-	sg_init_table(preq->src, 1);
-	len = cpu_to_le64(rctx->assoclen);
-	memcpy(&preq->tail.assoclen, &len, sizeof(len));
-	len = cpu_to_le64(rctx->cryptlen);
-	memcpy(&preq->tail.cryptlen, &len, sizeof(len));
-	sg_set_buf(preq->src, &preq->tail, sizeof(preq->tail));
+	preq->tail.assoclen = cpu_to_le64(rctx->assoclen);
+	preq->tail.cryptlen = cpu_to_le64(rctx->cryptlen);
+	sg_init_one(preq->src, &preq->tail, sizeof(preq->tail));
 
 	ahash_request_set_callback(&preq->req, rctx->flags,
 				   poly_tail_done, req);
@@ -215,13 +207,12 @@ static int poly_cipherpad(struct aead_request *req)
 	struct chachapoly_ctx *ctx = crypto_aead_ctx(crypto_aead_reqtfm(req));
 	struct chachapoly_req_ctx *rctx = aead_request_ctx(req);
 	struct poly_req *preq = &rctx->u.poly;
-	unsigned int padlen, bs = POLY1305_BLOCK_SIZE;
+	unsigned int padlen;
 	int err;
 
-	padlen = (bs - (rctx->cryptlen % bs)) % bs;
+	padlen = -rctx->cryptlen % POLY1305_BLOCK_SIZE;
 	memset(preq->pad, 0, sizeof(preq->pad));
-	sg_init_table(preq->src, 1);
-	sg_set_buf(preq->src, &preq->pad, padlen);
+	sg_init_one(preq->src, preq->pad, padlen);
 
 	ahash_request_set_callback(&preq->req, rctx->flags,
 				   poly_cipherpad_done, req);
@@ -251,7 +242,6 @@ static int poly_cipher(struct aead_request *req)
 	if (rctx->cryptlen == req->cryptlen) /* encrypting */
 		crypt = req->dst;
 
-	sg_init_table(rctx->src, 2);
 	crypt = scatterwalk_ffwd(rctx->src, crypt, req->assoclen);
 
 	ahash_request_set_callback(&preq->req, rctx->flags,
@@ -276,13 +266,12 @@ static int poly_adpad(struct aead_request *req)
 	struct chachapoly_ctx *ctx = crypto_aead_ctx(crypto_aead_reqtfm(req));
 	struct chachapoly_req_ctx *rctx = aead_request_ctx(req);
 	struct poly_req *preq = &rctx->u.poly;
-	unsigned int padlen, bs = POLY1305_BLOCK_SIZE;
+	unsigned int padlen;
 	int err;
 
-	padlen = (bs - (rctx->assoclen % bs)) % bs;
+	padlen = -rctx->assoclen % POLY1305_BLOCK_SIZE;
 	memset(preq->pad, 0, sizeof(preq->pad));
-	sg_init_table(preq->src, 1);
-	sg_set_buf(preq->src, preq->pad, padlen);
+	sg_init_one(preq->src, preq->pad, padlen);
 
 	ahash_request_set_callback(&preq->req, rctx->flags,
 				   poly_adpad_done, req);
@@ -332,8 +321,7 @@ static int poly_setkey(struct aead_request *req)
 	struct poly_req *preq = &rctx->u.poly;
 	int err;
 
-	sg_init_table(preq->src, 1);
-	sg_set_buf(preq->src, rctx->key, sizeof(rctx->key));
+	sg_init_one(preq->src, rctx->key, sizeof(rctx->key));
 
 	ahash_request_set_callback(&preq->req, rctx->flags,
 				   poly_setkey_done, req);
@@ -391,9 +379,8 @@ static int poly_genkey(struct aead_request *req)
 		rctx->assoclen -= 8;
 	}
 
-	sg_init_table(creq->src, 1);
 	memset(rctx->key, 0, sizeof(rctx->key));
-	sg_set_buf(creq->src, rctx->key, sizeof(rctx->key));
+	sg_init_one(creq->src, rctx->key, sizeof(rctx->key));
 
 	chacha_iv(creq->iv, req, 0);
 
@@ -428,14 +415,10 @@ static int chacha_encrypt(struct aead_request *req)
 
 	chacha_iv(creq->iv, req, 1);
 
-	sg_init_table(rctx->src, 2);
 	src = scatterwalk_ffwd(rctx->src, req->src, req->assoclen);
 	dst = src;
-
-	if (req->src != req->dst) {
-		sg_init_table(rctx->dst, 2);
+	if (req->src != req->dst)
 		dst = scatterwalk_ffwd(rctx->dst, req->dst, req->assoclen);
-	}
 
 	skcipher_request_set_callback(&creq->req, rctx->flags,
 				      chacha_encrypt_done, req);
-- 
2.21.0

