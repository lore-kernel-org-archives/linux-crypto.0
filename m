Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9EFCBC433B4
	for <linux-crypto@archiver.kernel.org>; Wed,  5 May 2021 20:26:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8343A61132
	for <linux-crypto@archiver.kernel.org>; Wed,  5 May 2021 20:26:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235485AbhEEU1g (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 5 May 2021 16:27:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33574 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235349AbhEEU1a (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 5 May 2021 16:27:30 -0400
Received: from mail-wr1-x436.google.com (mail-wr1-x436.google.com [IPv6:2a00:1450:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C4C8C06138B
        for <linux-crypto@vger.kernel.org>; Wed,  5 May 2021 13:26:31 -0700 (PDT)
Received: by mail-wr1-x436.google.com with SMTP id t18so3221050wry.1
        for <linux-crypto@vger.kernel.org>; Wed, 05 May 2021 13:26:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=up2i6BSkNCXIRfVxIx1vgf9CT89LYsI7fxJGSIwU7yA=;
        b=OCN/arZi01XT5TrIGcmybaG9S+5x8cxjpNdF+9gKr76V6k7UJW8IZyDNihMCLuBTD7
         ee3n2e5l8/KaxPlsywXE5C1O8qxfVzPOU/uMdXMLfilJfB0BnjDdpXorse4tKI2+a8JY
         CVwQKR25wtwGLfauJ4Tw3qhdZO1P1Q8XsPanYCD2SsJ17xUeECBnifKJT1fL608LZhfE
         BZAbEMehbmwawkrNUf0T/imqfwcMzBPPsi5mDRh7YypusAefHx2KxjvVH1kPN1+jZ3Da
         ZTNJG/yhydYqVMesmyaXFEMRVo0H/i9ydgFD3PFkfEobuqZiLVgTHv+/cfkllCgaWXyV
         NKHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=up2i6BSkNCXIRfVxIx1vgf9CT89LYsI7fxJGSIwU7yA=;
        b=NgQH52wo7Y97FZhvN4qIanFORUMln7JXEXqHg/VeLWagOWrQE/hi+mUmJP7YkyrUpK
         M56e8/TheG95g1VdPuFQ4BzGLN+6CgCNqKfQ9Ccxtv2HiIb51xqWiJnCSICwjdxR4+Ee
         W+WTh0D6BdFBPaII0n3k82eJE86O3V+EuEmqwEjatR0V9Z/lcqiWWKcKP5AExk7hXy6B
         yNyLdrVBZIeOzccRkwdrMKQ00DGuJooyJbUYPGWPy7lR+934QygBqepNJEYUKntyd6IS
         UJxy/DgVv2D/ZLm3wIVwzrAqodjoUaeSl6gLneR/ZcfiEPMDBCCFYDWitF7crFm0X3O5
         XgvA==
X-Gm-Message-State: AOAM530UkQ9v/bcqhLB8jxcBsZdW1zGfW+Umjx8T38n+Nt9uJGRGYMB4
        kHdetG8Z4hnYHWzC3+/tDKLKvA==
X-Google-Smtp-Source: ABdhPJyjCguIwk/Z+HydyU/P+TiAkfOu0bhIJn0wH1WjnBcyXFGyPyrHLa+UzGMJR09EIOGZvInqiQ==
X-Received: by 2002:adf:f80a:: with SMTP id s10mr823496wrp.319.1620246390069;
        Wed, 05 May 2021 13:26:30 -0700 (PDT)
Received: from localhost.localdomain (laubervilliers-658-1-213-31.w90-63.abo.wanadoo.fr. [90.63.244.31])
        by smtp.googlemail.com with ESMTPSA id a15sm497245wrr.53.2021.05.05.13.26.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 May 2021 13:26:29 -0700 (PDT)
From:   Corentin Labbe <clabbe@baylibre.com>
To:     chohnstaedt@innominate.com, davem@davemloft.net,
        herbert@gondor.apana.org.au
Cc:     linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        Corentin Labbe <clabbe@baylibre.com>
Subject: [PATCH 06/11] crypto: ixp4xx: whitespace fixes
Date:   Wed,  5 May 2021 20:26:13 +0000
Message-Id: <20210505202618.2663889-7-clabbe@baylibre.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210505202618.2663889-1-clabbe@baylibre.com>
References: <20210505202618.2663889-1-clabbe@baylibre.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Fixes all whitespace issues reported by checkpatch

Signed-off-by: Corentin Labbe <clabbe@baylibre.com>
---
 drivers/crypto/ixp4xx_crypto.c | 43 +++++++++++++++++++---------------
 1 file changed, 24 insertions(+), 19 deletions(-)

diff --git a/drivers/crypto/ixp4xx_crypto.c b/drivers/crypto/ixp4xx_crypto.c
index 486a388c909f..5b8ffa4db45d 100644
--- a/drivers/crypto/ixp4xx_crypto.c
+++ b/drivers/crypto/ixp4xx_crypto.c
@@ -213,6 +213,7 @@ static const struct ix_hash_algo hash_alg_md5 = {
 	.icv		= "\x01\x23\x45\x67\x89\xAB\xCD\xEF"
 			  "\xFE\xDC\xBA\x98\x76\x54\x32\x10",
 };
+
 static const struct ix_hash_algo hash_alg_sha1 = {
 	.cfgword	= 0x00000005,
 	.icv		= "\x67\x45\x23\x01\xEF\xCD\xAB\x89\x98\xBA"
@@ -244,12 +245,12 @@ static inline struct crypt_ctl *crypt_phys2virt(dma_addr_t phys)
 
 static inline u32 cipher_cfg_enc(struct crypto_tfm *tfm)
 {
-	return container_of(tfm->__crt_alg, struct ixp_alg,crypto.base)->cfg_enc;
+	return container_of(tfm->__crt_alg, struct ixp_alg, crypto.base)->cfg_enc;
 }
 
 static inline u32 cipher_cfg_dec(struct crypto_tfm *tfm)
 {
-	return container_of(tfm->__crt_alg, struct ixp_alg,crypto.base)->cfg_dec;
+	return container_of(tfm->__crt_alg, struct ixp_alg, crypto.base)->cfg_dec;
 }
 
 static inline const struct ix_hash_algo *ix_hash(struct crypto_tfm *tfm)
@@ -260,6 +261,7 @@ static inline const struct ix_hash_algo *ix_hash(struct crypto_tfm *tfm)
 static int setup_crypt_desc(void)
 {
 	struct device *dev = &pdev->dev;
+
 	BUILD_BUG_ON(sizeof(struct crypt_ctl) != 64);
 	crypt_virt = dma_alloc_coherent(dev,
 					NPE_QLEN * sizeof(struct crypt_ctl),
@@ -290,7 +292,7 @@ static struct crypt_ctl *get_crypt_desc(void)
 			idx = 0;
 		crypt_virt[i].ctl_flags = CTL_FLAG_USED;
 		spin_unlock_irqrestore(&desc_lock, flags);
-		return crypt_virt +i;
+		return crypt_virt + i;
 	} else {
 		spin_unlock_irqrestore(&desc_lock, flags);
 		return NULL;
@@ -318,7 +320,7 @@ static struct crypt_ctl *get_crypt_desc_emerg(void)
 			idx = NPE_QLEN;
 		crypt_virt[i].ctl_flags = CTL_FLAG_USED;
 		spin_unlock_irqrestore(&emerg_lock, flags);
-		return crypt_virt +i;
+		return crypt_virt + i;
 	} else {
 		spin_unlock_irqrestore(&emerg_lock, flags);
 		return NULL;
@@ -417,7 +419,7 @@ static void one_packet(dma_addr_t phys)
 		break;
 	case CTL_FLAG_GEN_REVAES:
 		ctx = crypto_tfm_ctx(crypt->data.tfm);
-		*(u32*)ctx->decrypt.npe_ctx &= cpu_to_be32(~CIPH_ENCR);
+		*(u32 *)ctx->decrypt.npe_ctx &= cpu_to_be32(~CIPH_ENCR);
 		if (atomic_dec_and_test(&ctx->configuring))
 			complete(&ctx->completion);
 		break;
@@ -436,8 +438,9 @@ static void crypto_done_action(unsigned long arg)
 {
 	int i;
 
-	for(i=0; i<4; i++) {
+	for (i = 0; i < 4; i++) {
 		dma_addr_t phys = qmgr_get_entry(RECV_QID);
+
 		if (!phys)
 			return;
 		one_packet(phys);
@@ -473,7 +476,7 @@ static int init_ixp_crypto(struct device *dev)
 			goto npe_error;
 	}
 
-	switch ((msg[1]>>16) & 0xff) {
+	switch ((msg[1] >> 16) & 0xff) {
 	case 3:
 		dev_warn(dev, "Firmware of %s lacks AES support\n", npe_name(npe_c));
 		support_aes = 0;
@@ -619,6 +622,7 @@ static int init_tfm_aead(struct crypto_aead *tfm)
 static void exit_tfm(struct crypto_tfm *tfm)
 {
 	struct ixp_ctx *ctx = crypto_tfm_ctx(tfm);
+
 	free_sa_dir(&ctx->encrypt);
 	free_sa_dir(&ctx->decrypt);
 }
@@ -709,11 +713,11 @@ static int setup_auth(struct crypto_tfm *tfm, int encrypt, unsigned int authsize
 	algo = ix_hash(tfm);
 
 	/* write cfg word to cryptinfo */
-	cfgword = algo->cfgword | ( authsize << 6); /* (authsize/4) << 8 */
+	cfgword = algo->cfgword | (authsize << 6); /* (authsize/4) << 8 */
 #ifndef __ARMEB__
 	cfgword ^= 0xAA000000; /* change the "byte swap" flags */
 #endif
-	*(u32*)cinfo = cpu_to_be32(cfgword);
+	*(u32 *)cinfo = cpu_to_be32(cfgword);
 	cinfo += sizeof(cfgword);
 
 	/* write ICV to cryptinfo */
@@ -750,7 +754,7 @@ static int gen_rev_aes_key(struct crypto_tfm *tfm)
 	if (!crypt) {
 		return -EAGAIN;
 	}
-	*(u32*)dir->npe_ctx |= cpu_to_be32(CIPH_ENCR);
+	*(u32 *)dir->npe_ctx |= cpu_to_be32(CIPH_ENCR);
 
 	crypt->data.tfm = tfm;
 	crypt->crypt_offs = 0;
@@ -802,21 +806,21 @@ static int setup_cipher(struct crypto_tfm *tfm, int encrypt,
 			return err;
 	}
 	/* write cfg word to cryptinfo */
-	*(u32*)cinfo = cpu_to_be32(cipher_cfg);
+	*(u32 *)cinfo = cpu_to_be32(cipher_cfg);
 	cinfo += sizeof(cipher_cfg);
 
 	/* write cipher key to cryptinfo */
 	memcpy(cinfo, key, key_len);
 	/* NPE wants keylen set to DES3_EDE_KEY_SIZE even for single DES */
 	if (key_len < DES3_EDE_KEY_SIZE && !(cipher_cfg & MOD_AES)) {
-		memset(cinfo + key_len, 0, DES3_EDE_KEY_SIZE -key_len);
+		memset(cinfo + key_len, 0, DES3_EDE_KEY_SIZE - key_len);
 		key_len = DES3_EDE_KEY_SIZE;
 	}
 	dir->npe_ctx_idx = sizeof(cipher_cfg) + key_len;
 	dir->npe_mode |= NPE_OP_CRYPT_ENABLE;
-	if ((cipher_cfg & MOD_AES) && !encrypt) {
+	if ((cipher_cfg & MOD_AES) && !encrypt)
 		return gen_rev_aes_key(tfm);
-	}
+
 	return 0;
 }
 
@@ -971,6 +975,7 @@ static int ablk_perform(struct skcipher_request *req, int encrypt)
 	}
 	if (req->src != req->dst) {
 		struct buffer_desc dst_hook;
+
 		crypt->mode |= NPE_OP_NOT_IN_PLACE;
 		/* This was never tested by Intel
 		 * for more than one dst buffer, I think. */
@@ -1025,7 +1030,7 @@ static int ablk_rfc3686_crypt(struct skcipher_request *req)
 	int ret;
 
 	/* set up counter block */
-        memcpy(iv, ctx->nonce, CTR_RFC3686_NONCE_SIZE);
+	memcpy(iv, ctx->nonce, CTR_RFC3686_NONCE_SIZE);
 	memcpy(iv + CTR_RFC3686_NONCE_SIZE, info, CTR_RFC3686_IV_SIZE);
 
 	/* initialize counter portion of counter block */
@@ -1067,7 +1072,7 @@ static int aead_perform(struct aead_request *req, int encrypt,
 	} else {
 		dir = &ctx->decrypt;
 		/* req->cryptlen includes the authsize when decrypting */
-		cryptlen = req->cryptlen -authsize;
+		cryptlen = req->cryptlen - authsize;
 		eff_cryptlen -= authsize;
 	}
 	crypt = get_crypt_desc();
@@ -1188,7 +1193,7 @@ static int aead_setauthsize(struct crypto_aead *tfm, unsigned int authsize)
 {
 	int max = crypto_aead_maxauthsize(tfm) >> 2;
 
-	if ((authsize>>2) < 1 || (authsize>>2) > max || (authsize & 3))
+	if ((authsize >> 2) < 1 || (authsize >> 2) > max || (authsize & 3))
 		return -EINVAL;
 	return aead_setup(tfm, authsize);
 }
@@ -1453,7 +1458,7 @@ static int __init ixp_module_init(void)
 		platform_device_unregister(pdev);
 		return err;
 	}
-	for (i=0; i< num; i++) {
+	for (i = 0; i < num; i++) {
 		struct skcipher_alg *cra = &ixp4xx_algos[i].crypto;
 
 		if (snprintf(cra->base.cra_driver_name, CRYPTO_MAX_ALG_NAME,
@@ -1536,7 +1541,7 @@ static void __exit ixp_module_exit(void)
 			crypto_unregister_aead(&ixp4xx_aeads[i].crypto);
 	}
 
-	for (i=0; i< num; i++) {
+	for (i = 0; i < num; i++) {
 		if (ixp4xx_algos[i].registered)
 			crypto_unregister_skcipher(&ixp4xx_algos[i].crypto);
 	}
-- 
2.26.3

