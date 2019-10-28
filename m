Return-Path: <SRS0=YLdW=YV=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 67E21CA9EA0
	for <linux-crypto@archiver.kernel.org>; Mon, 28 Oct 2019 07:39:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 446222054F
	for <linux-crypto@archiver.kernel.org>; Mon, 28 Oct 2019 07:39:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732992AbfJ1HjL (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 28 Oct 2019 03:39:11 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:49738 "EHLO deadmen.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732043AbfJ1HjL (ORCPT <rfc822;linux-crypto@vger.kernel.orG>);
        Mon, 28 Oct 2019 03:39:11 -0400
Received: from gondobar.mordor.me.apana.org.au ([192.168.128.4] helo=gondobar)
        by deadmen.hmeau.com with esmtps (Exim 4.89 #2 (Debian))
        id 1iOzcL-0000ZD-QS; Mon, 28 Oct 2019 15:39:09 +0800
Received: from herbert by gondobar with local (Exim 4.89)
        (envelope-from <herbert@gondor.apana.org.au>)
        id 1iOzcJ-0002sI-Ds; Mon, 28 Oct 2019 15:39:07 +0800
Date:   Mon, 28 Oct 2019 15:39:07 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Cyrille Pitchen <cyrille.pitchen@atmel.com>,
        Tudor Ambarus <tudor.ambarus@microchip.com>
Subject: crypto: atmel - Fix authenc support when it is set to m
Message-ID: <20191028073907.pbk6j5fvi7ludbvx@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

As it is if CONFIG_CRYPTO_DEV_ATMEL_AUTHENC is set to m it is in
effect disabled.  This patch fixes it by using IS_ENABLED instead
of ifdef.

Fixes: 89a82ef87e01 ("crypto: atmel-authenc - add support to...")
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

diff --git a/drivers/crypto/atmel-aes.c b/drivers/crypto/atmel-aes.c
index 33a76d1f4a6e..c5ec74171fbf 100644
--- a/drivers/crypto/atmel-aes.c
+++ b/drivers/crypto/atmel-aes.c
@@ -145,7 +145,7 @@ struct atmel_aes_xts_ctx {
 	u32			key2[AES_KEYSIZE_256 / sizeof(u32)];
 };
 
-#ifdef CONFIG_CRYPTO_DEV_ATMEL_AUTHENC
+#if IS_ENABLED(CONFIG_CRYPTO_DEV_ATMEL_AUTHENC)
 struct atmel_aes_authenc_ctx {
 	struct atmel_aes_base_ctx	base;
 	struct atmel_sha_authenc_ctx	*auth;
@@ -157,7 +157,7 @@ struct atmel_aes_reqctx {
 	u32			lastc[AES_BLOCK_SIZE / sizeof(u32)];
 };
 
-#ifdef CONFIG_CRYPTO_DEV_ATMEL_AUTHENC
+#if IS_ENABLED(CONFIG_CRYPTO_DEV_ATMEL_AUTHENC)
 struct atmel_aes_authenc_reqctx {
 	struct atmel_aes_reqctx	base;
 
@@ -486,7 +486,7 @@ static inline bool atmel_aes_is_encrypt(const struct atmel_aes_dev *dd)
 	return (dd->flags & AES_FLAGS_ENCRYPT);
 }
 
-#ifdef CONFIG_CRYPTO_DEV_ATMEL_AUTHENC
+#if IS_ENABLED(CONFIG_CRYPTO_DEV_ATMEL_AUTHENC)
 static void atmel_aes_authenc_complete(struct atmel_aes_dev *dd, int err);
 #endif
 
@@ -515,7 +515,7 @@ static void atmel_aes_set_iv_as_last_ciphertext_block(struct atmel_aes_dev *dd)
 
 static inline int atmel_aes_complete(struct atmel_aes_dev *dd, int err)
 {
-#ifdef CONFIG_CRYPTO_DEV_ATMEL_AUTHENC
+#if IS_ENABLED(CONFIG_CRYPTO_DEV_ATMEL_AUTHENC)
 	if (dd->ctx->is_aead)
 		atmel_aes_authenc_complete(dd, err);
 #endif
@@ -1980,7 +1980,7 @@ static struct crypto_alg aes_xts_alg = {
 	}
 };
 
-#ifdef CONFIG_CRYPTO_DEV_ATMEL_AUTHENC
+#if IS_ENABLED(CONFIG_CRYPTO_DEV_ATMEL_AUTHENC)
 /* authenc aead functions */
 
 static int atmel_aes_authenc_start(struct atmel_aes_dev *dd);
@@ -2467,7 +2467,7 @@ static void atmel_aes_unregister_algs(struct atmel_aes_dev *dd)
 {
 	int i;
 
-#ifdef CONFIG_CRYPTO_DEV_ATMEL_AUTHENC
+#if IS_ENABLED(CONFIG_CRYPTO_DEV_ATMEL_AUTHENC)
 	if (dd->caps.has_authenc)
 		for (i = 0; i < ARRAY_SIZE(aes_authenc_algs); i++)
 			crypto_unregister_aead(&aes_authenc_algs[i]);
@@ -2514,7 +2514,7 @@ static int atmel_aes_register_algs(struct atmel_aes_dev *dd)
 			goto err_aes_xts_alg;
 	}
 
-#ifdef CONFIG_CRYPTO_DEV_ATMEL_AUTHENC
+#if IS_ENABLED(CONFIG_CRYPTO_DEV_ATMEL_AUTHENC)
 	if (dd->caps.has_authenc) {
 		for (i = 0; i < ARRAY_SIZE(aes_authenc_algs); i++) {
 			err = crypto_register_aead(&aes_authenc_algs[i]);
@@ -2526,7 +2526,7 @@ static int atmel_aes_register_algs(struct atmel_aes_dev *dd)
 
 	return 0;
 
-#ifdef CONFIG_CRYPTO_DEV_ATMEL_AUTHENC
+#if IS_ENABLED(CONFIG_CRYPTO_DEV_ATMEL_AUTHENC)
 	/* i = ARRAY_SIZE(aes_authenc_algs); */
 err_aes_authenc_alg:
 	for (j = 0; j < i; j++)
@@ -2716,7 +2716,7 @@ static int atmel_aes_probe(struct platform_device *pdev)
 
 	atmel_aes_get_cap(aes_dd);
 
-#ifdef CONFIG_CRYPTO_DEV_ATMEL_AUTHENC
+#if IS_ENABLED(CONFIG_CRYPTO_DEV_ATMEL_AUTHENC)
 	if (aes_dd->caps.has_authenc && !atmel_sha_authenc_is_ready()) {
 		err = -EPROBE_DEFER;
 		goto iclk_unprepare;
diff --git a/drivers/crypto/atmel-authenc.h b/drivers/crypto/atmel-authenc.h
index cbd37a2edada..d6de810df44f 100644
--- a/drivers/crypto/atmel-authenc.h
+++ b/drivers/crypto/atmel-authenc.h
@@ -12,7 +12,7 @@
 #ifndef __ATMEL_AUTHENC_H__
 #define __ATMEL_AUTHENC_H__
 
-#ifdef CONFIG_CRYPTO_DEV_ATMEL_AUTHENC
+#if IS_ENABLED(CONFIG_CRYPTO_DEV_ATMEL_AUTHENC)
 
 #include <crypto/authenc.h>
 #include <crypto/hash.h>
diff --git a/drivers/crypto/atmel-sha.c b/drivers/crypto/atmel-sha.c
index 84cb8748a795..d32626458e67 100644
--- a/drivers/crypto/atmel-sha.c
+++ b/drivers/crypto/atmel-sha.c
@@ -2212,7 +2212,7 @@ static struct ahash_alg sha_hmac_algs[] = {
 },
 };
 
-#ifdef CONFIG_CRYPTO_DEV_ATMEL_AUTHENC
+#if IS_ENABLED(CONFIG_CRYPTO_DEV_ATMEL_AUTHENC)
 /* authenc functions */
 
 static int atmel_sha_authenc_init2(struct atmel_sha_dev *dd);
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
