Return-Path: <SRS0=65YJ=CK=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.5 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7A19FC43461
	for <linux-crypto@archiver.kernel.org>; Tue,  1 Sep 2020 14:49:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5F7D022210
	for <linux-crypto@archiver.kernel.org>; Tue,  1 Sep 2020 14:49:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727061AbgIAOtW (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 1 Sep 2020 10:49:22 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:38560 "EHLO fornost.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727037AbgIALsn (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 1 Sep 2020 07:48:43 -0400
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.0.7])
        by fornost.hmeau.com with smtp (Exim 4.92 #5 (Debian))
        id 1kD4mG-0000VO-VK; Tue, 01 Sep 2020 21:48:42 +1000
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Tue, 01 Sep 2020 21:48:40 +1000
Date:   Tue, 1 Sep 2020 21:48:40 +1000
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Ard Biesheuvel <ardb@kernel.org>
Cc:     Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Subject: [v2 PATCH 1/2] crypto: arm/aes-neonbs - Use generic cbc encryption
 path
Message-ID: <20200901114840.GA2519@gondor.apana.org.au>
References: <20200901062804.GA1533@gondor.apana.org.au>
 <CAMj1kXGDPTbhs_2FkvHROMmp+j7eON43r8muWgMGJpFQKpTjSw@mail.gmail.com>
 <20200901114542.GA2441@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200901114542.GA2441@gondor.apana.org.au>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Since commit b56f5cbc7e08ec7d31c42fc41e5247677f20b143 ("crypto:
arm/aes-neonbs - resolve fallback cipher at runtime") the CBC
encryption path in aes-neonbs is now identical to that obtained
through the cbc template.  This means that it can simply call
the generic cbc template instead of doing its own thing.

This patch removes the custom encryption path and simply invokes
the generic cbc template.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

diff --git a/arch/arm/crypto/aes-neonbs-glue.c b/arch/arm/crypto/aes-neonbs-glue.c
index e6fd32919c81..b324c5500846 100644
--- a/arch/arm/crypto/aes-neonbs-glue.c
+++ b/arch/arm/crypto/aes-neonbs-glue.c
@@ -8,7 +8,6 @@
 #include <asm/neon.h>
 #include <asm/simd.h>
 #include <crypto/aes.h>
-#include <crypto/cbc.h>
 #include <crypto/ctr.h>
 #include <crypto/internal/simd.h>
 #include <crypto/internal/skcipher.h>
@@ -49,7 +48,7 @@ struct aesbs_ctx {
 
 struct aesbs_cbc_ctx {
 	struct aesbs_ctx	key;
-	struct crypto_cipher	*enc_tfm;
+	struct crypto_skcipher	*enc_tfm;
 };
 
 struct aesbs_xts_ctx {
@@ -140,19 +139,23 @@ static int aesbs_cbc_setkey(struct crypto_skcipher *tfm, const u8 *in_key,
 	kernel_neon_end();
 	memzero_explicit(&rk, sizeof(rk));
 
-	return crypto_cipher_setkey(ctx->enc_tfm, in_key, key_len);
+	return crypto_skcipher_setkey(ctx->enc_tfm, in_key, key_len);
 }
 
-static void cbc_encrypt_one(struct crypto_skcipher *tfm, const u8 *src, u8 *dst)
+static int cbc_encrypt(struct skcipher_request *req)
 {
+	struct skcipher_request *subreq = skcipher_request_ctx(req);
+	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
 	struct aesbs_cbc_ctx *ctx = crypto_skcipher_ctx(tfm);
 
-	crypto_cipher_encrypt_one(ctx->enc_tfm, dst, src);
-}
+	skcipher_request_set_tfm(subreq, ctx->enc_tfm);
+	skcipher_request_set_callback(subreq,
+				      skcipher_request_flags(req),
+				      NULL, NULL);
+	skcipher_request_set_crypt(subreq, req->src, req->dst,
+				   req->cryptlen, req->iv);
 
-static int cbc_encrypt(struct skcipher_request *req)
-{
-	return crypto_cbc_encrypt_walk(req, cbc_encrypt_one);
+	return crypto_skcipher_encrypt(subreq);
 }
 
 static int cbc_decrypt(struct skcipher_request *req)
@@ -183,20 +186,27 @@ static int cbc_decrypt(struct skcipher_request *req)
 	return err;
 }
 
-static int cbc_init(struct crypto_tfm *tfm)
+static int cbc_init(struct crypto_skcipher *tfm)
 {
-	struct aesbs_cbc_ctx *ctx = crypto_tfm_ctx(tfm);
+	struct aesbs_cbc_ctx *ctx = crypto_skcipher_ctx(tfm);
+	unsigned int reqsize;
+
+	ctx->enc_tfm = crypto_alloc_skcipher("cbc(aes)", 0, CRYPTO_ALG_ASYNC);
+	if (IS_ERR(ctx->enc_tfm))
+		return PTR_ERR(ctx->enc_tfm);
 
-	ctx->enc_tfm = crypto_alloc_cipher("aes", 0, 0);
+	reqsize = sizeof(struct skcipher_request);
+	reqsize += crypto_skcipher_reqsize(ctx->enc_tfm);
+	crypto_skcipher_set_reqsize(tfm, reqsize);
 
-	return PTR_ERR_OR_ZERO(ctx->enc_tfm);
+	return 0;
 }
 
-static void cbc_exit(struct crypto_tfm *tfm)
+static void cbc_exit(struct crypto_skcipher *tfm)
 {
-	struct aesbs_cbc_ctx *ctx = crypto_tfm_ctx(tfm);
+	struct aesbs_cbc_ctx *ctx = crypto_skcipher_ctx(tfm);
 
-	crypto_free_cipher(ctx->enc_tfm);
+	crypto_free_skcipher(ctx->enc_tfm);
 }
 
 static int aesbs_ctr_setkey_sync(struct crypto_skcipher *tfm, const u8 *in_key,
@@ -432,8 +442,6 @@ static struct skcipher_alg aes_algs[] = { {
 	.base.cra_ctxsize	= sizeof(struct aesbs_cbc_ctx),
 	.base.cra_module	= THIS_MODULE,
 	.base.cra_flags		= CRYPTO_ALG_INTERNAL,
-	.base.cra_init		= cbc_init,
-	.base.cra_exit		= cbc_exit,
 
 	.min_keysize		= AES_MIN_KEY_SIZE,
 	.max_keysize		= AES_MAX_KEY_SIZE,
@@ -442,6 +450,8 @@ static struct skcipher_alg aes_algs[] = { {
 	.setkey			= aesbs_cbc_setkey,
 	.encrypt		= cbc_encrypt,
 	.decrypt		= cbc_decrypt,
+	.init			= cbc_init,
+	.exit			= cbc_exit,
 }, {
 	.base.cra_name		= "__ctr(aes)",
 	.base.cra_driver_name	= "__ctr-aes-neonbs",
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
