Return-Path: <SRS0=t+Y3=BH=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.0 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0CAF6C433EA
	for <linux-crypto@archiver.kernel.org>; Tue, 28 Jul 2020 07:18:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E937820792
	for <linux-crypto@archiver.kernel.org>; Tue, 28 Jul 2020 07:18:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727906AbgG1HSw (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 28 Jul 2020 03:18:52 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:54758 "EHLO fornost.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727904AbgG1HSw (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 28 Jul 2020 03:18:52 -0400
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.0.7])
        by fornost.hmeau.com with smtp (Exim 4.92 #5 (Debian))
        id 1k0Jsu-0006JL-QP; Tue, 28 Jul 2020 17:18:49 +1000
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Tue, 28 Jul 2020 17:18:48 +1000
From:   "Herbert Xu" <herbert@gondor.apana.org.au>
Date:   Tue, 28 Jul 2020 17:18:48 +1000
Subject: [v3 PATCH 5/31] crypto: nitrox - Add support for chaining CTS
References: <20200728071746.GA22352@gondor.apana.org.au>
To:     Ard Biesheuvel <ardb@kernel.org>,
        Stephan Mueller <smueller@chronox.de>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Eric Biggers <ebiggers@kernel.org>
Message-Id: <E1k0Jsu-0006JL-QP@fornost.hmeau.com>
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

As it stands cts cannot do chaining.  That is, it always performs
the cipher-text stealing at the end of a request.  This patch adds
support for chaining when the CRYPTO_TM_REQ_MORE flag is set.

It also sets the final_chunksize so that data can be withheld by
the caller to enable correct processing at the true end of a request.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---

 drivers/crypto/cavium/nitrox/nitrox_skcipher.c |  124 ++++++++++++++++++++++---
 1 file changed, 113 insertions(+), 11 deletions(-)

diff --git a/drivers/crypto/cavium/nitrox/nitrox_skcipher.c b/drivers/crypto/cavium/nitrox/nitrox_skcipher.c
index a553ac65f3249..7a159a5da30a0 100644
--- a/drivers/crypto/cavium/nitrox/nitrox_skcipher.c
+++ b/drivers/crypto/cavium/nitrox/nitrox_skcipher.c
@@ -20,6 +20,16 @@ struct nitrox_cipher {
 	enum flexi_cipher value;
 };
 
+struct nitrox_crypto_cts_ctx {
+	struct nitrox_crypto_ctx base;
+	union {
+		u8 *u8p;
+		u64 ctx_handle;
+		struct flexi_crypto_context *fctx;
+	} cbc;
+	struct crypto_ctx_hdr *cbchdr;
+};
+
 /**
  * supported cipher list
  */
@@ -105,6 +115,18 @@ static void nitrox_cbc_cipher_callback(void *arg, int err)
 	nitrox_skcipher_callback(arg, err);
 }
 
+static void nitrox_cts_cipher_callback(void *arg, int err)
+{
+	struct skcipher_request *skreq = arg;
+
+	if (skreq->base.flags & CRYPTO_TFM_REQ_MORE) {
+		nitrox_cbc_cipher_callback(arg, err);
+		return;
+	}
+
+	nitrox_skcipher_callback(arg, err);
+}
+
 static int nitrox_skcipher_init(struct crypto_skcipher *tfm)
 {
 	struct nitrox_crypto_ctx *nctx = crypto_skcipher_ctx(tfm);
@@ -162,6 +184,42 @@ static void nitrox_skcipher_exit(struct crypto_skcipher *tfm)
 	nctx->ndev = NULL;
 }
 
+static int nitrox_cts_init(struct crypto_skcipher *tfm)
+{
+	struct nitrox_crypto_cts_ctx *ctsctx = crypto_skcipher_ctx(tfm);
+	struct nitrox_crypto_ctx *nctx = &ctsctx->base;
+	struct crypto_ctx_hdr *chdr;
+	int err;
+
+	err = nitrox_skcipher_init(tfm);
+	if (err)
+		return err;
+
+	chdr = crypto_alloc_context(nctx->ndev);
+	if (!chdr) {
+		nitrox_skcipher_exit(tfm);
+		return -ENOMEM;
+	}
+
+	ctsctx->cbchdr = chdr;
+	ctsctx->cbc.u8p = chdr->vaddr;
+	ctsctx->cbc.u8p += sizeof(struct ctx_hdr);
+	nctx->callback = nitrox_cts_cipher_callback;
+	return 0;
+}
+
+static void nitrox_cts_exit(struct crypto_skcipher *tfm)
+{
+	struct nitrox_crypto_cts_ctx *ctsctx = crypto_skcipher_ctx(tfm);
+	struct flexi_crypto_context *fctx = ctsctx->cbc.fctx;
+
+	memset(&fctx->crypto, 0, sizeof(struct crypto_keys));
+	memset(&fctx->auth, 0, sizeof(struct auth_keys));
+	crypto_free_context(ctsctx->cbchdr);
+
+	nitrox_skcipher_exit(tfm);
+}
+
 static inline int nitrox_skcipher_setkey(struct crypto_skcipher *cipher,
 					 int aes_keylen, const u8 *key,
 					 unsigned int keylen)
@@ -244,7 +302,8 @@ static int alloc_dst_sglist(struct skcipher_request *skreq, int ivsize)
 	return 0;
 }
 
-static int nitrox_skcipher_crypt(struct skcipher_request *skreq, bool enc)
+static int nitrox_skcipher_crypt_handle(struct skcipher_request *skreq,
+					bool enc, u64 handle)
 {
 	struct crypto_skcipher *cipher = crypto_skcipher_reqtfm(skreq);
 	struct nitrox_crypto_ctx *nctx = crypto_skcipher_ctx(cipher);
@@ -269,7 +328,7 @@ static int nitrox_skcipher_crypt(struct skcipher_request *skreq, bool enc)
 	creq->gph.param2 = cpu_to_be16(ivsize);
 	creq->gph.param3 = 0;
 
-	creq->ctx_handle = nctx->u.ctx_handle;
+	creq->ctx_handle = handle;
 	creq->ctrl.s.ctxl = sizeof(struct flexi_crypto_context);
 
 	ret = alloc_src_sglist(skreq, ivsize);
@@ -287,7 +346,16 @@ static int nitrox_skcipher_crypt(struct skcipher_request *skreq, bool enc)
 					 skreq);
 }
 
-static int nitrox_cbc_decrypt(struct skcipher_request *skreq)
+static int nitrox_skcipher_crypt(struct skcipher_request *skreq, bool enc)
+{
+	struct crypto_skcipher *cipher = crypto_skcipher_reqtfm(skreq);
+	struct nitrox_crypto_ctx *nctx = crypto_skcipher_ctx(cipher);
+
+	return nitrox_skcipher_crypt_handle(skreq, enc, nctx->u.ctx_handle);
+}
+
+static int nitrox_cbc_decrypt_handle(struct skcipher_request *skreq,
+				     u64 handle)
 {
 	struct nitrox_kcrypt_request *nkreq = skcipher_request_ctx(skreq);
 	struct crypto_skcipher *cipher = crypto_skcipher_reqtfm(skreq);
@@ -297,14 +365,46 @@ static int nitrox_cbc_decrypt(struct skcipher_request *skreq)
 	unsigned int start = skreq->cryptlen - ivsize;
 
 	if (skreq->src != skreq->dst)
-		return nitrox_skcipher_crypt(skreq, false);
+		return nitrox_skcipher_crypt_handle(skreq, false, handle);
 
 	nkreq->iv_out = kmalloc(ivsize, flags);
 	if (!nkreq->iv_out)
 		return -ENOMEM;
 
 	scatterwalk_map_and_copy(nkreq->iv_out, skreq->src, start, ivsize, 0);
-	return nitrox_skcipher_crypt(skreq, false);
+	return nitrox_skcipher_crypt_handle(skreq, false, handle);
+}
+
+static int nitrox_cbc_decrypt(struct skcipher_request *skreq)
+{
+	struct crypto_skcipher *cipher = crypto_skcipher_reqtfm(skreq);
+	struct nitrox_crypto_ctx *nctx = crypto_skcipher_ctx(cipher);
+
+	return nitrox_cbc_decrypt_handle(skreq, nctx->u.ctx_handle);
+}
+
+static int nitrox_cts_encrypt(struct skcipher_request *skreq)
+{
+	if (skreq->base.flags & CRYPTO_TFM_REQ_MORE) {
+		struct nitrox_crypto_cts_ctx *ctsctx;
+
+		ctsctx = crypto_skcipher_ctx(crypto_skcipher_reqtfm(skreq));
+		return nitrox_skcipher_crypt_handle(skreq, true,
+						    ctsctx->cbc.ctx_handle);
+	}
+
+	return nitrox_skcipher_crypt(skreq, true);
+}
+
+static int nitrox_cts_decrypt(struct skcipher_request *skreq)
+{
+	struct nitrox_crypto_cts_ctx *ctsctx;
+
+	if (!(skreq->base.flags & CRYPTO_TFM_REQ_MORE))
+		return nitrox_skcipher_crypt(skreq, false);
+
+	ctsctx = crypto_skcipher_ctx(crypto_skcipher_reqtfm(skreq));
+	return nitrox_cbc_decrypt_handle(skreq, ctsctx->cbc.ctx_handle);
 }
 
 static int nitrox_aes_encrypt(struct skcipher_request *skreq)
@@ -484,19 +584,21 @@ static struct skcipher_alg nitrox_skciphers[] = { {
 		.cra_driver_name = "n5_cts(cbc(aes))",
 		.cra_priority = PRIO,
 		.cra_flags = CRYPTO_ALG_ASYNC | CRYPTO_ALG_ALLOCATES_MEMORY,
-		.cra_blocksize = AES_BLOCK_SIZE,
-		.cra_ctxsize = sizeof(struct nitrox_crypto_ctx),
+		.cra_blocksize = 1,
+		.cra_ctxsize = sizeof(struct nitrox_crypto_cts_ctx),
 		.cra_alignmask = 0,
 		.cra_module = THIS_MODULE,
 	},
 	.min_keysize = AES_MIN_KEY_SIZE,
 	.max_keysize = AES_MAX_KEY_SIZE,
 	.ivsize = AES_BLOCK_SIZE,
+	.chunksize = AES_BLOCK_SIZE,
+	.final_chunksize = 2 * AES_BLOCK_SIZE,
 	.setkey = nitrox_aes_setkey,
-	.encrypt = nitrox_aes_encrypt,
-	.decrypt = nitrox_aes_decrypt,
-	.init = nitrox_skcipher_init,
-	.exit = nitrox_skcipher_exit,
+	.encrypt = nitrox_cts_encrypt,
+	.decrypt = nitrox_cts_decrypt,
+	.init = nitrox_cts_init,
+	.exit = nitrox_cts_exit,
 }, {
 	.base = {
 		.cra_name = "cbc(des3_ede)",
