Return-Path: <SRS0=BCrf=T5=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2B5CEC28CC0
	for <linux-crypto@archiver.kernel.org>; Wed, 29 May 2019 17:11:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0749E23EFF
	for <linux-crypto@archiver.kernel.org>; Wed, 29 May 2019 17:11:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726005AbfE2RLF (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 29 May 2019 13:11:05 -0400
Received: from inva021.nxp.com ([92.121.34.21]:33252 "EHLO inva021.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725917AbfE2RLE (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 29 May 2019 13:11:04 -0400
Received: from inva021.nxp.com (localhost [127.0.0.1])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id D71A72001B9;
        Wed, 29 May 2019 19:11:01 +0200 (CEST)
Received: from inva024.eu-rdc02.nxp.com (inva024.eu-rdc02.nxp.com [134.27.226.22])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id CA1142004B3;
        Wed, 29 May 2019 19:11:01 +0200 (CEST)
Received: from lorenz.ea.freescale.net (lorenz.ea.freescale.net [10.171.71.5])
        by inva024.eu-rdc02.nxp.com (Postfix) with ESMTP id 6DF3D205E4;
        Wed, 29 May 2019 19:11:01 +0200 (CEST)
From:   Iuliana Prodan <iuliana.prodan@nxp.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Horia Geanta <horia.geanta@nxp.com>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-imx <linux-imx@nxp.com>
Subject: [PATCH] crypto: gcm - fix cacheline sharing
Date:   Wed, 29 May 2019 20:10:56 +0300
Message-Id: <1559149856-7938-1-git-send-email-iuliana.prodan@nxp.com>
X-Mailer: git-send-email 2.1.0
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

The generic GCM driver should ensure that whatever it passes into
scatterlists is safe for non-cache coherent DMA.
The issue was seen while running GCM on CAAM driver. But, since CAAM
does not support GHASH on i.MX6, only CTR skcipher part of the GCM is
offloaded.
The skcipher request received by CAAM has req->src pointing to
auth_tag[16] and req->iv pointing to iv[16]. Problem is that when
the iv is updated (crypto API requires skcipher implementations to
update the IV with the last ciphertext block) is written in iv[16],
which is on the same cacheline as auth_tag[16] that was previously
DMA mapped.
Solution is to use a pointer, aligned to cache line, instead of auth_tag
buffer, for encryption/decryption and then free it on completion.

Link: https://lore.kernel.org/linux-crypto/20190208114459.5nixe76xmmkhur75@gondor.apana.org.au/
Cc: <stable@vger.kernel.org> # v4.19+
Fixes: adcbc688fe2f ("crypto: gcm - Convert to new AEAD interface")
Suggested-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Signed-off-by: Iuliana Prodan <iuliana.prodan@nxp.com>

---
I've checked the reproducibility of this issue starting with 4.19.y.
---
 crypto/gcm.c         | 26 +++++++++++++++++---------
 include/crypto/gcm.h |  1 +
 2 files changed, 18 insertions(+), 9 deletions(-)

diff --git a/crypto/gcm.c b/crypto/gcm.c
index 33f45a9..53e3ce5 100644
--- a/crypto/gcm.c
+++ b/crypto/gcm.c
@@ -66,7 +66,7 @@ struct crypto_gcm_ghash_ctx {
 
 struct crypto_gcm_req_priv_ctx {
 	u8 iv[16];
-	u8 auth_tag[16];
+	u8 *auth_tag;
 	u8 iauth_tag[16];
 	struct scatterlist src[3];
 	struct scatterlist dst[3];
@@ -177,19 +177,23 @@ static void crypto_gcm_init_common(struct aead_request *req)
 	__be32 counter = cpu_to_be32(1);
 	struct scatterlist *sg;
 
-	memset(pctx->auth_tag, 0, sizeof(pctx->auth_tag));
+	/*
+	 * kzalloc alignment is at least the cache line size
+	 * for non-cache coherent architectures.
+	 */
+	pctx->auth_tag = kzalloc(GCM_MAX_AUTH_SIZE, GFP_KERNEL);
 	memcpy(pctx->iv, req->iv, GCM_AES_IV_SIZE);
 	memcpy(pctx->iv + GCM_AES_IV_SIZE, &counter, 4);
 
 	sg_init_table(pctx->src, 3);
-	sg_set_buf(pctx->src, pctx->auth_tag, sizeof(pctx->auth_tag));
+	sg_set_buf(pctx->src, pctx->auth_tag, GCM_MAX_AUTH_SIZE);
 	sg = scatterwalk_ffwd(pctx->src + 1, req->src, req->assoclen);
 	if (sg != pctx->src + 1)
 		sg_chain(pctx->src, 2, sg);
 
 	if (req->src != req->dst) {
 		sg_init_table(pctx->dst, 3);
-		sg_set_buf(pctx->dst, pctx->auth_tag, sizeof(pctx->auth_tag));
+		sg_set_buf(pctx->dst, pctx->auth_tag, GCM_MAX_AUTH_SIZE);
 		sg = scatterwalk_ffwd(pctx->dst + 1, req->dst, req->assoclen);
 		if (sg != pctx->dst + 1)
 			sg_chain(pctx->dst, 2, sg);
@@ -208,9 +212,8 @@ static void crypto_gcm_init_crypt(struct aead_request *req,
 	dst = req->src == req->dst ? pctx->src : pctx->dst;
 
 	skcipher_request_set_tfm(skreq, ctx->ctr);
-	skcipher_request_set_crypt(skreq, pctx->src, dst,
-				     cryptlen + sizeof(pctx->auth_tag),
-				     pctx->iv);
+	skcipher_request_set_crypt(skreq, pctx->src, dst, cryptlen +
+				   GCM_MAX_AUTH_SIZE, pctx->iv);
 }
 
 static inline unsigned int gcm_remain(unsigned int len)
@@ -440,6 +443,7 @@ static int gcm_enc_copy_hash(struct aead_request *req, u32 flags)
 	scatterwalk_map_and_copy(auth_tag, req->dst,
 				 req->assoclen + req->cryptlen,
 				 crypto_aead_authsize(aead), 1);
+	kfree(auth_tag);
 	return 0;
 }
 
@@ -492,11 +496,15 @@ static int crypto_gcm_verify(struct aead_request *req)
 	u8 *iauth_tag = pctx->iauth_tag;
 	unsigned int authsize = crypto_aead_authsize(aead);
 	unsigned int cryptlen = req->cryptlen - authsize;
+	int err;
 
 	crypto_xor(auth_tag, iauth_tag, 16);
 	scatterwalk_map_and_copy(iauth_tag, req->src,
 				 req->assoclen + cryptlen, authsize, 0);
-	return crypto_memneq(iauth_tag, auth_tag, authsize) ? -EBADMSG : 0;
+	err = crypto_memneq(iauth_tag, auth_tag, authsize) ? -EBADMSG : 0;
+	kfree(auth_tag);
+
+	return err;
 }
 
 static void gcm_decrypt_done(struct crypto_async_request *areq, int err)
@@ -678,7 +686,7 @@ static int crypto_gcm_create_common(struct crypto_template *tmpl,
 	inst->alg.base.cra_ctxsize = sizeof(struct crypto_gcm_ctx);
 	inst->alg.ivsize = GCM_AES_IV_SIZE;
 	inst->alg.chunksize = crypto_skcipher_alg_chunksize(ctr);
-	inst->alg.maxauthsize = 16;
+	inst->alg.maxauthsize = GCM_MAX_AUTH_SIZE;
 	inst->alg.init = crypto_gcm_init_tfm;
 	inst->alg.exit = crypto_gcm_exit_tfm;
 	inst->alg.setkey = crypto_gcm_setkey;
diff --git a/include/crypto/gcm.h b/include/crypto/gcm.h
index c50e057..6b634ff 100644
--- a/include/crypto/gcm.h
+++ b/include/crypto/gcm.h
@@ -1,6 +1,7 @@
 #ifndef _CRYPTO_GCM_H
 #define _CRYPTO_GCM_H
 
+#define GCM_MAX_AUTH_SIZE 16
 #define GCM_AES_IV_SIZE 12
 #define GCM_RFC4106_IV_SIZE 8
 #define GCM_RFC4543_IV_SIZE 8
-- 
2.1.0

