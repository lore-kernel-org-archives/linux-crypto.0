Return-Path: <SRS0=X5ob=U7=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 14A27C06510
	for <linux-crypto@archiver.kernel.org>; Tue,  2 Jul 2019 19:42:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D96EF21850
	for <linux-crypto@archiver.kernel.org>; Tue,  2 Jul 2019 19:42:48 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="XwQyVakf"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727117AbfGBTms (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 2 Jul 2019 15:42:48 -0400
Received: from mail-lj1-f193.google.com ([209.85.208.193]:39804 "EHLO
        mail-lj1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727101AbfGBTmr (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 2 Jul 2019 15:42:47 -0400
Received: by mail-lj1-f193.google.com with SMTP id v18so18159360ljh.6
        for <linux-crypto@vger.kernel.org>; Tue, 02 Jul 2019 12:42:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=k85BuBqTS4QnHHKvJGZeRTIiktlXAufYc+fdc/GM7hc=;
        b=XwQyVakfS2MsDBlX+7hNIYUBZc7U36OH8US9LRD0upZFq+OSdzfTxlHIQf3H01WYUl
         8OiEthnZ0z2bQt6ERIHAhozAdhMBovIaU2RyREBLW/FsJ83gF3ph15uXVjWnAsi7xSa/
         1HlxquQSrSYBY+fdOXu9U7hNs+4IhOUB3t/OOo2WD0DuUaq3Pym1LY5qMIMRQBW1FyQi
         E+9v8RuOtHm8Pm+UcC7wLyzXHYpxXmZ9gwb08yE0poaGHuMkO1Dd/Vc3uHLR9ULFLi0J
         05ePtEH8KONkSiigpy7VTESCHphlb1Up1lR2zfnFuRlujE4BfesacuR4Ct8QtZKTUtW1
         LxmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=k85BuBqTS4QnHHKvJGZeRTIiktlXAufYc+fdc/GM7hc=;
        b=D7HTxC6WiMdvqGYLim1xAHJAJ6JbqNX1f8qPb22dOIUgjdIfHVDojIjVwVfHetBQ7g
         xR5DwEX6zI+oI8XggYFC4TzolqL1BXMHBwWGHX/Q9rBuzogwmNw7zx0XWU+itEZOrMVW
         qHQsU9wkeM9AZOajZcHoQ0X/lncyjcBaQeIckXKiyyTVrPSPAjQ8adWrzEXyc6Gklq18
         uXeiuQa2ULJb1nEdBK7r1YSggoKVssamThdBEM2e+NSIZwgLP06oz+65MkvMXGWSK1l0
         u0Obuo9geKPd/b9NGVc0DUb5UuB1UchdOdQtoj9jj523/tKQV6Kr0ceNFXzdRrfcv8Bv
         7R9Q==
X-Gm-Message-State: APjAAAXEqURxTPAQpHY+AoUfek8OvZ1rg14yrbLlkdYEL++AZRq8BTon
        05yHBFBxRetvFyXQG1hVDqRHz5D3LrQvdBGe
X-Google-Smtp-Source: APXvYqxUcGUyKMdDmnzAhqxQUnNq8mCrmnE2CO8qF3rcThXRT9KyDUJNgAqpix8Ar5egNOnGRvkvqA==
X-Received: by 2002:a2e:1290:: with SMTP id 16mr17669109ljs.88.1562096564836;
        Tue, 02 Jul 2019 12:42:44 -0700 (PDT)
Received: from e111045-lin.arm.com (89-212-78-239.static.t-2.net. [89.212.78.239])
        by smtp.gmail.com with ESMTPSA id 24sm4475163ljs.63.2019.07.02.12.42.43
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Tue, 02 Jul 2019 12:42:44 -0700 (PDT)
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
To:     linux-crypto@vger.kernel.org
Cc:     herbert@gondor.apana.org.au, ebiggers@google.com,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH v4 26/32] crypto: chelsio/aes - replace AES cipher calls with library calls
Date:   Tue,  2 Jul 2019 21:41:44 +0200
Message-Id: <20190702194150.10405-27-ard.biesheuvel@linaro.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190702194150.10405-1-ard.biesheuvel@linaro.org>
References: <20190702194150.10405-1-ard.biesheuvel@linaro.org>
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Replace a couple of occurrences where the "aes-generic" cipher is
instantiated explicitly and only used for encryption of a single block.
Use AES library calls instead.

Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 drivers/crypto/chelsio/Kconfig          |  1 +
 drivers/crypto/chelsio/chcr_algo.c      | 46 ++++++--------------
 drivers/crypto/chelsio/chcr_crypto.h    |  1 -
 drivers/crypto/chelsio/chcr_ipsec.c     | 19 +++-----
 drivers/crypto/chelsio/chtls/chtls_hw.c | 20 +++------
 5 files changed, 26 insertions(+), 61 deletions(-)

diff --git a/drivers/crypto/chelsio/Kconfig b/drivers/crypto/chelsio/Kconfig
index 930d82d991f2..36402ba63b50 100644
--- a/drivers/crypto/chelsio/Kconfig
+++ b/drivers/crypto/chelsio/Kconfig
@@ -1,6 +1,7 @@
 config CRYPTO_DEV_CHELSIO
 	tristate "Chelsio Crypto Co-processor Driver"
 	depends on CHELSIO_T4
+	select CRYPTO_LIB_AES
 	select CRYPTO_SHA1
 	select CRYPTO_SHA256
 	select CRYPTO_SHA512
diff --git a/drivers/crypto/chelsio/chcr_algo.c b/drivers/crypto/chelsio/chcr_algo.c
index 177f572b9589..38ee38b37ae6 100644
--- a/drivers/crypto/chelsio/chcr_algo.c
+++ b/drivers/crypto/chelsio/chcr_algo.c
@@ -1023,22 +1023,21 @@ static int chcr_update_tweak(struct ablkcipher_request *req, u8 *iv,
 	struct crypto_ablkcipher *tfm = crypto_ablkcipher_reqtfm(req);
 	struct ablk_ctx *ablkctx = ABLK_CTX(c_ctx(tfm));
 	struct chcr_blkcipher_req_ctx *reqctx = ablkcipher_request_ctx(req);
-	struct crypto_cipher *cipher;
+	struct crypto_aes_ctx aes;
 	int ret, i;
 	u8 *key;
 	unsigned int keylen;
 	int round = reqctx->last_req_len / AES_BLOCK_SIZE;
 	int round8 = round / 8;
 
-	cipher = ablkctx->aes_generic;
 	memcpy(iv, reqctx->iv, AES_BLOCK_SIZE);
 
 	keylen = ablkctx->enckey_len / 2;
 	key = ablkctx->key + keylen;
-	ret = crypto_cipher_setkey(cipher, key, keylen);
+	ret = aes_expandkey(&aes, key, keylen);
 	if (ret)
-		goto out;
-	crypto_cipher_encrypt_one(cipher, iv, iv);
+		return ret;
+	aes_encrypt(&aes, iv, iv);
 	for (i = 0; i < round8; i++)
 		gf128mul_x8_ble((le128 *)iv, (le128 *)iv);
 
@@ -1046,9 +1045,10 @@ static int chcr_update_tweak(struct ablkcipher_request *req, u8 *iv,
 		gf128mul_x_ble((le128 *)iv, (le128 *)iv);
 
 	if (!isfinal)
-		crypto_cipher_decrypt_one(cipher, iv, iv);
-out:
-	return ret;
+		aes_decrypt(&aes, iv, iv);
+
+	memzero_explicit(&aes, sizeof(aes));
+	return 0;
 }
 
 static int chcr_update_cipher_iv(struct ablkcipher_request *req,
@@ -1411,16 +1411,6 @@ static int chcr_cra_init(struct crypto_tfm *tfm)
 		return PTR_ERR(ablkctx->sw_cipher);
 	}
 
-	if (get_cryptoalg_subtype(tfm) == CRYPTO_ALG_SUB_TYPE_XTS) {
-		/* To update tweak*/
-		ablkctx->aes_generic = crypto_alloc_cipher("aes-generic", 0, 0);
-		if (IS_ERR(ablkctx->aes_generic)) {
-			pr_err("failed to allocate aes cipher for tweak\n");
-			return PTR_ERR(ablkctx->aes_generic);
-		}
-	} else
-		ablkctx->aes_generic = NULL;
-
 	tfm->crt_ablkcipher.reqsize =  sizeof(struct chcr_blkcipher_req_ctx);
 	return chcr_device_init(crypto_tfm_ctx(tfm));
 }
@@ -1451,8 +1441,6 @@ static void chcr_cra_exit(struct crypto_tfm *tfm)
 	struct ablk_ctx *ablkctx = ABLK_CTX(ctx);
 
 	crypto_free_sync_skcipher(ablkctx->sw_cipher);
-	if (ablkctx->aes_generic)
-		crypto_free_cipher(ablkctx->aes_generic);
 }
 
 static int get_alg_config(struct algo_param *params,
@@ -3364,9 +3352,9 @@ static int chcr_gcm_setkey(struct crypto_aead *aead, const u8 *key,
 {
 	struct chcr_aead_ctx *aeadctx = AEAD_CTX(a_ctx(aead));
 	struct chcr_gcm_ctx *gctx = GCM_CTX(aeadctx);
-	struct crypto_cipher *cipher;
 	unsigned int ck_size;
 	int ret = 0, key_ctx_size = 0;
+	struct crypto_aes_ctx aes;
 
 	aeadctx->enckey_len = 0;
 	crypto_aead_clear_flags(aeadctx->sw_cipher, CRYPTO_TFM_REQ_MASK);
@@ -3409,23 +3397,15 @@ static int chcr_gcm_setkey(struct crypto_aead *aead, const u8 *key,
 	/* Calculate the H = CIPH(K, 0 repeated 16 times).
 	 * It will go in key context
 	 */
-	cipher = crypto_alloc_cipher("aes-generic", 0, 0);
-	if (IS_ERR(cipher)) {
-		aeadctx->enckey_len = 0;
-		ret = -ENOMEM;
-		goto out;
-	}
-
-	ret = crypto_cipher_setkey(cipher, key, keylen);
+	ret = aes_expandkey(&aes, key, keylen);
 	if (ret) {
 		aeadctx->enckey_len = 0;
-		goto out1;
+		goto out;
 	}
 	memset(gctx->ghash_h, 0, AEAD_H_SIZE);
-	crypto_cipher_encrypt_one(cipher, gctx->ghash_h, gctx->ghash_h);
+	aes_encrypt(&aes, gctx->ghash_h, gctx->ghash_h);
+	memzero_explicit(&aes, sizeof(aes));
 
-out1:
-	crypto_free_cipher(cipher);
 out:
 	return ret;
 }
diff --git a/drivers/crypto/chelsio/chcr_crypto.h b/drivers/crypto/chelsio/chcr_crypto.h
index 655606f2e4d0..993c97e70565 100644
--- a/drivers/crypto/chelsio/chcr_crypto.h
+++ b/drivers/crypto/chelsio/chcr_crypto.h
@@ -172,7 +172,6 @@ static inline struct chcr_context *h_ctx(struct crypto_ahash *tfm)
 
 struct ablk_ctx {
 	struct crypto_sync_skcipher *sw_cipher;
-	struct crypto_cipher *aes_generic;
 	__be32 key_ctx_hdr;
 	unsigned int enckey_len;
 	unsigned char ciph_mode;
diff --git a/drivers/crypto/chelsio/chcr_ipsec.c b/drivers/crypto/chelsio/chcr_ipsec.c
index f429aae72542..24355680f30a 100644
--- a/drivers/crypto/chelsio/chcr_ipsec.c
+++ b/drivers/crypto/chelsio/chcr_ipsec.c
@@ -132,11 +132,11 @@ static inline int chcr_ipsec_setauthsize(struct xfrm_state *x,
 static inline int chcr_ipsec_setkey(struct xfrm_state *x,
 				    struct ipsec_sa_entry *sa_entry)
 {
-	struct crypto_cipher *cipher;
 	int keylen = (x->aead->alg_key_len + 7) / 8;
 	unsigned char *key = x->aead->alg_key;
 	int ck_size, key_ctx_size = 0;
 	unsigned char ghash_h[AEAD_H_SIZE];
+	struct crypto_aes_ctx aes;
 	int ret = 0;
 
 	if (keylen > 3) {
@@ -170,26 +170,19 @@ static inline int chcr_ipsec_setkey(struct xfrm_state *x,
 	/* Calculate the H = CIPH(K, 0 repeated 16 times).
 	 * It will go in key context
 	 */
-	cipher = crypto_alloc_cipher("aes-generic", 0, 0);
-	if (IS_ERR(cipher)) {
-		sa_entry->enckey_len = 0;
-		ret = -ENOMEM;
-		goto out;
-	}
-
-	ret = crypto_cipher_setkey(cipher, key, keylen);
+	ret = aes_expandkey(&aes, key, keylen);
 	if (ret) {
 		sa_entry->enckey_len = 0;
-		goto out1;
+		goto out;
 	}
 	memset(ghash_h, 0, AEAD_H_SIZE);
-	crypto_cipher_encrypt_one(cipher, ghash_h, ghash_h);
+	aes_encrypt(&aes, ghash_h, ghash_h);
+	memzero_explicit(&aes, sizeof(aes));
+
 	memcpy(sa_entry->key + (DIV_ROUND_UP(sa_entry->enckey_len, 16) *
 	       16), ghash_h, AEAD_H_SIZE);
 	sa_entry->kctx_len = ((DIV_ROUND_UP(sa_entry->enckey_len, 16)) << 4) +
 			      AEAD_H_SIZE;
-out1:
-	crypto_free_cipher(cipher);
 out:
 	return ret;
 }
diff --git a/drivers/crypto/chelsio/chtls/chtls_hw.c b/drivers/crypto/chelsio/chtls/chtls_hw.c
index 490960755864..a6f0278f3597 100644
--- a/drivers/crypto/chelsio/chtls/chtls_hw.c
+++ b/drivers/crypto/chelsio/chtls/chtls_hw.c
@@ -216,8 +216,8 @@ static int chtls_key_info(struct chtls_sock *csk,
 	unsigned char key[AES_KEYSIZE_128];
 	struct tls12_crypto_info_aes_gcm_128 *gcm_ctx;
 	unsigned char ghash_h[AEAD_H_SIZE];
-	struct crypto_cipher *cipher;
 	int ck_size, key_ctx_size;
+	struct crypto_aes_ctx aes;
 	int ret;
 
 	gcm_ctx = (struct tls12_crypto_info_aes_gcm_128 *)
@@ -237,18 +237,13 @@ static int chtls_key_info(struct chtls_sock *csk,
 	/* Calculate the H = CIPH(K, 0 repeated 16 times).
 	 * It will go in key context
 	 */
-	cipher = crypto_alloc_cipher("aes", 0, 0);
-	if (IS_ERR(cipher)) {
-		ret = -ENOMEM;
-		goto out;
-	}
-
-	ret = crypto_cipher_setkey(cipher, key, keylen);
+	ret = aes_expandkey(&aes, key, keylen);
 	if (ret)
-		goto out1;
+		return ret;
 
 	memset(ghash_h, 0, AEAD_H_SIZE);
-	crypto_cipher_encrypt_one(cipher, ghash_h, ghash_h);
+	aes_encrypt(&aes, ghash_h, ghash_h);
+	memzero_explicit(&aes, sizeof(aes));
 	csk->tlshws.keylen = key_ctx_size;
 
 	/* Copy the Key context */
@@ -272,10 +267,7 @@ static int chtls_key_info(struct chtls_sock *csk,
 	/* erase key info from driver */
 	memset(gcm_ctx->key, 0, keylen);
 
-out1:
-	crypto_free_cipher(cipher);
-out:
-	return ret;
+	return 0;
 }
 
 static void chtls_set_scmd(struct chtls_sock *csk)
-- 
2.17.1

