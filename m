Return-Path: <SRS0=CUNG=U2=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 13393C48BD9
	for <linux-crypto@archiver.kernel.org>; Thu, 27 Jun 2019 10:28:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D33E320828
	for <linux-crypto@archiver.kernel.org>; Thu, 27 Jun 2019 10:28:22 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="YlrnsHIG"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726465AbfF0K2W (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 27 Jun 2019 06:28:22 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:33862 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726623AbfF0K2V (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 27 Jun 2019 06:28:21 -0400
Received: by mail-wr1-f68.google.com with SMTP id k11so1941343wrl.1
        for <linux-crypto@vger.kernel.org>; Thu, 27 Jun 2019 03:28:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=SI+i3SEIksVLr/oeokNkhVP46cu/BheSlfNWTBwHojU=;
        b=YlrnsHIGinzZy0k+MYE7NtYe+nhsMUqfbjKt5N2RkCbkWb4iDdr98mmEpHvrTZpd/9
         Tt9KNknJ1853cgPae5Aipruh7cClUth2tF1isvYt50KVV2xisZhz7M2/wMDYetWMagxS
         4IBP46vwDnG6pZNKinGQ5FFjAJkYORLu0rHbAC+854Obb4F9pNOhXxdeRExMHu6DApUQ
         CnxxJJJcEANcdPoD4jI41zEh+sk3F0OYmKHWamKeR8I3EF/juq2mqDZ6rxpIlwylM/Cc
         KCo7NIK01uQdbT8jQrfzipd6GKHOLnD+W58/fSrWr/3WTj7ZsUI/nDOGuaDlzF3Wrbyi
         POZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=SI+i3SEIksVLr/oeokNkhVP46cu/BheSlfNWTBwHojU=;
        b=p/PRfEwdhideLM/KwuNBtlKmNRdyfzZNDUp4YunpIT61CAT888S5Y/625+y/B6zzOA
         l8hbIJrBHb0XFhBB9v7vsBvxT9AlfAKCqqfVfWcyaTvzuBRIh9zexFPFwBTcTTc4wcD4
         AnX2uCOYjCkfpZe7/JhfWzM7W9t24QN6sgmPRpPg6ByeMTbHjj3aHFO6s25pAynyMZXo
         KEmjzT/H4Vkii/2aW6AMmXZ94pzY6YTdfSpMUaxpBaCEh+DnV5hI0TItqFTiS0XCrbjw
         tcoWoIHIh8WW03nrpuL+wcXNgrJ1G/PVyz00f1SDGpRk8kfUiMGpCaWrG02Ro0VMUv3Y
         0iDg==
X-Gm-Message-State: APjAAAWHqOJfogOMZssNux5k6dWLv3NJp1RPep3buLn81/kWg2XLK4k/
        LIuMVacGnYLg/laSrlAg6wPYBmfVq7Y=
X-Google-Smtp-Source: APXvYqycjE9g/OOxyl2U9gJkDahd6GfCYDIDbdW8d8bVkuPrb85x1qAqI0fz/EulEamSa3TeorHoJg==
X-Received: by 2002:a5d:5745:: with SMTP id q5mr2800024wrw.75.1561631298633;
        Thu, 27 Jun 2019 03:28:18 -0700 (PDT)
Received: from localhost.localdomain (aaubervilliers-681-1-8-173.w90-88.abo.wanadoo.fr. [90.88.13.173])
        by smtp.gmail.com with ESMTPSA id g2sm5584533wmh.0.2019.06.27.03.28.17
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Thu, 27 Jun 2019 03:28:18 -0700 (PDT)
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
To:     linux-crypto@vger.kernel.org
Cc:     herbert@gondor.apana.org.au, ebiggers@kernel.org,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH v3 26/32] crypto: chelsio/aes - replace AES cipher calls with library calls
Date:   Thu, 27 Jun 2019 12:26:41 +0200
Message-Id: <20190627102647.2992-27-ard.biesheuvel@linaro.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190627102647.2992-1-ard.biesheuvel@linaro.org>
References: <20190627102647.2992-1-ard.biesheuvel@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
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
2.20.1

