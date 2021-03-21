Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9EBE0C433E0
	for <linux-crypto@archiver.kernel.org>; Sun, 21 Mar 2021 12:09:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7609761931
	for <linux-crypto@archiver.kernel.org>; Sun, 21 Mar 2021 12:09:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229834AbhCUMIu (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 21 Mar 2021 08:08:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47354 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229875AbhCUMIn (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 21 Mar 2021 08:08:43 -0400
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C58EC061574;
        Sun, 21 Mar 2021 05:08:43 -0700 (PDT)
Received: by mail-pj1-x1029.google.com with SMTP id il9-20020a17090b1649b0290114bcb0d6c2so1675979pjb.0;
        Sun, 21 Mar 2021 05:08:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=HSSxmK0cuYym1ybatHcy4VDPR1/GI7z2xQ4QQD17/2E=;
        b=Neb8wtf2p//f3Otyc2TbcDU+ldeRf0C6iOO8DJCuZE41gFObRc7+PgE5xkMQ9uQaAy
         g2/rUzMMdlAVaSUrTpwhodDRAyTq9CVYuEGK1SSyTWz5uFcMACoDhNzGP/ZiVa3Cptla
         VpUdXxlXgAuFtblc9qg/UL7C7qGGork2vp0gnL8UsPkFxz191fNZ7adV3zR3XLSPfW30
         7vlodxxaYg5VkemD/IxpIQx8Ljb+yMU0wmswBp6V/P21fLIl07MuNElj1Uibsr3VrjkB
         ByaA768cVPb4NW9g5egzhtxZeNlU8chQtOuisipAav4d6xQNDiZdLdpuVksl9+uE/J+k
         gc/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=HSSxmK0cuYym1ybatHcy4VDPR1/GI7z2xQ4QQD17/2E=;
        b=kWgqP3nPY265+llgfX20Ope6jgvooC7rBTVvH3odzwi9PA9VJZmrMfdYSyFaW79Qa7
         lXyeRvZ2Wc9xx1ov8xvknRm5kpSpRc/+DWPa3PZXNuouzCKL1HPBZd9gsfuWmEhzAq6+
         frBLVVgtuw7lgGM1j6Vkh3FgqUd1rf+loGYbrzL3FSXPVJewbPe90y0sjJjSU6cWGJnQ
         lGp7j/WIFZtYt7gJDQEMiiNQ+YbN40G0QObbZFulszZLo+1UO3ARrWd1Hf2RlWjazlF7
         31hT2kGjif/7Buo1CY1HzGQTYf611RkrFSXtkE8pfGinVz4a8GYnZsTKAIN9JKA9VP93
         oR1w==
X-Gm-Message-State: AOAM533rAW3qd78o7qqCzBKNql0EBRUgBYJcvto3jme4PwkkHttUbFHW
        m1rrrs6cqQ7zmBxuFz/Dz2U=
X-Google-Smtp-Source: ABdhPJxXEOiDyKvrZhYHlXQHR2Nq21Enp8+krSaKOI5PBk9iFqnMgxEwQ0Q1sdr7/QsNJThJxNT4eg==
X-Received: by 2002:a17:90b:1296:: with SMTP id fw22mr7971426pjb.93.1616328522829;
        Sun, 21 Mar 2021 05:08:42 -0700 (PDT)
Received: from localhost.localdomain ([2405:201:600d:a089:4cb7:d0cb:1241:5cf8])
        by smtp.googlemail.com with ESMTPSA id mp1sm10460317pjb.48.2021.03.21.05.08.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 21 Mar 2021 05:08:42 -0700 (PDT)
From:   Aditya Srivastava <yashsri421@gmail.com>
To:     herbert@gondor.apana.org.au
Cc:     yashsri421@gmail.com, lukas.bulwahn@gmail.com, corbet@lwn.net,
        rdunlap@infradead.org,
        linux-kernel-mentees@lists.linuxfoundation.org,
        davem@davemloft.net, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] crypto: amcc: fix incorrect kernel-doc comment syntax in files
Date:   Sun, 21 Mar 2021 17:38:32 +0530
Message-Id: <20210321120832.12837-1-yashsri421@gmail.com>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

The opening comment mark '/**' is used for highlighting the beginning of
kernel-doc comments.
There are certain files in drivers/crypto/amcc, which follow this syntax,
but the content inside does not comply with kernel-doc.
Such lines were probably not meant for kernel-doc parsing, but are parsed
due to the presence of kernel-doc like comment syntax(i.e, '/**'), which
causes unexpected warnings from kernel-doc.

E.g., presence of kernel-doc like comment in
drivers/crypto/amcc/crypto4xx_alg.c at header, and some other lines,
causes these warnings by kernel-doc:

"warning: expecting prototype for AMCC SoC PPC4xx Crypto Driver(). Prototype was for set_dynamic_sa_command_0() instead"
"warning: Function parameter or member 'dir' not described in 'set_dynamic_sa_command_0'"
etc..

Provide a simple fix by replacing such occurrences with general comment
format, i.e. '/*', to prevent kernel-doc from parsing it.

Signed-off-by: Aditya Srivastava <yashsri421@gmail.com>
---
 drivers/crypto/amcc/crypto4xx_alg.c     | 12 ++++++------
 drivers/crypto/amcc/crypto4xx_core.c    | 18 +++++++++---------
 drivers/crypto/amcc/crypto4xx_core.h    |  4 ++--
 drivers/crypto/amcc/crypto4xx_reg_def.h |  8 ++++----
 drivers/crypto/amcc/crypto4xx_sa.h      | 18 +++++++++---------
 drivers/crypto/amcc/crypto4xx_trng.h    |  2 +-
 6 files changed, 31 insertions(+), 31 deletions(-)

diff --git a/drivers/crypto/amcc/crypto4xx_alg.c b/drivers/crypto/amcc/crypto4xx_alg.c
index a3fa849b139a..ded732242732 100644
--- a/drivers/crypto/amcc/crypto4xx_alg.c
+++ b/drivers/crypto/amcc/crypto4xx_alg.c
@@ -1,5 +1,5 @@
 // SPDX-License-Identifier: GPL-2.0-or-later
-/**
+/*
  * AMCC SoC PPC4xx Crypto Driver
  *
  * Copyright (c) 2008 Applied Micro Circuits Corporation.
@@ -115,7 +115,7 @@ int crypto4xx_decrypt_iv_block(struct skcipher_request *req)
 	return crypto4xx_crypt(req, AES_IV_SIZE, true, true);
 }
 
-/**
+/*
  * AES Functions
  */
 static int crypto4xx_setkey_aes(struct crypto_skcipher *cipher,
@@ -374,7 +374,7 @@ static int crypto4xx_aead_setup_fallback(struct crypto4xx_ctx *ctx,
 	return crypto_aead_setkey(ctx->sw_cipher.aead, key, keylen);
 }
 
-/**
+/*
  * AES-CCM Functions
  */
 
@@ -489,7 +489,7 @@ int crypto4xx_setauthsize_aead(struct crypto_aead *cipher,
 	return crypto_aead_setauthsize(ctx->sw_cipher.aead, authsize);
 }
 
-/**
+/*
  * AES-GCM Functions
  */
 
@@ -617,7 +617,7 @@ int crypto4xx_decrypt_aes_gcm(struct aead_request *req)
 	return crypto4xx_crypt_aes_gcm(req, true);
 }
 
-/**
+/*
  * HASH SHA1 Functions
  */
 static int crypto4xx_hash_alg_init(struct crypto_tfm *tfm,
@@ -711,7 +711,7 @@ int crypto4xx_hash_digest(struct ahash_request *req)
 				  ctx->sa_len, 0, NULL);
 }
 
-/**
+/*
  * SHA1 Algorithm
  */
 int crypto4xx_sha1_alg_init(struct crypto_tfm *tfm)
diff --git a/drivers/crypto/amcc/crypto4xx_core.c b/drivers/crypto/amcc/crypto4xx_core.c
index 8d1b918a0533..8278d98074e9 100644
--- a/drivers/crypto/amcc/crypto4xx_core.c
+++ b/drivers/crypto/amcc/crypto4xx_core.c
@@ -1,5 +1,5 @@
 // SPDX-License-Identifier: GPL-2.0-or-later
-/**
+/*
  * AMCC SoC PPC4xx Crypto Driver
  *
  * Copyright (c) 2008 Applied Micro Circuits Corporation.
@@ -44,7 +44,7 @@
 
 #define PPC4XX_SEC_VERSION_STR			"0.5"
 
-/**
+/*
  * PPC4xx Crypto Engine Initialization Routine
  */
 static void crypto4xx_hw_init(struct crypto4xx_device *dev)
@@ -159,7 +159,7 @@ void crypto4xx_free_sa(struct crypto4xx_ctx *ctx)
 	ctx->sa_len = 0;
 }
 
-/**
+/*
  * alloc memory for the gather ring
  * no need to alloc buf for the ring
  * gdr_tail, gdr_head and gdr_count are initialized by this function
@@ -268,7 +268,7 @@ static u32 crypto4xx_put_pd_to_pdr(struct crypto4xx_device *dev, u32 idx)
 	return tail;
 }
 
-/**
+/*
  * alloc memory for the gather ring
  * no need to alloc buf for the ring
  * gdr_tail, gdr_head and gdr_count are initialized by this function
@@ -346,7 +346,7 @@ static inline struct ce_gd *crypto4xx_get_gdp(struct crypto4xx_device *dev,
 	return &dev->gdr[idx];
 }
 
-/**
+/*
  * alloc memory for the scatter ring
  * need to alloc buf for the ring
  * sdr_tail, sdr_head and sdr_count are initialized by this function
@@ -930,7 +930,7 @@ int crypto4xx_build_pd(struct crypto_async_request *req,
 	return is_busy ? -EBUSY : -EINPROGRESS;
 }
 
-/**
+/*
  * Algorithm Registration Functions
  */
 static void crypto4xx_ctx_init(struct crypto4xx_alg *amcc_alg,
@@ -1097,7 +1097,7 @@ static void crypto4xx_bh_tasklet_cb(unsigned long data)
 	} while (head != tail);
 }
 
-/**
+/*
  * Top Half of isr.
  */
 static inline irqreturn_t crypto4xx_interrupt_handler(int irq, void *data,
@@ -1186,7 +1186,7 @@ static int crypto4xx_prng_seed(struct crypto_rng *tfm, const u8 *seed,
 	return 0;
 }
 
-/**
+/*
  * Supported Crypto Algorithms
  */
 static struct crypto4xx_alg_common crypto4xx_alg[] = {
@@ -1369,7 +1369,7 @@ static struct crypto4xx_alg_common crypto4xx_alg[] = {
 	} },
 };
 
-/**
+/*
  * Module Initialization Routine
  */
 static int crypto4xx_probe(struct platform_device *ofdev)
diff --git a/drivers/crypto/amcc/crypto4xx_core.h b/drivers/crypto/amcc/crypto4xx_core.h
index a4e25b46cd0a..56c10668c0ab 100644
--- a/drivers/crypto/amcc/crypto4xx_core.h
+++ b/drivers/crypto/amcc/crypto4xx_core.h
@@ -1,5 +1,5 @@
 /* SPDX-License-Identifier: GPL-2.0-or-later */
-/**
+/*
  * AMCC SoC PPC4xx Crypto Driver
  *
  * Copyright (c) 2008 Applied Micro Circuits Corporation.
@@ -188,7 +188,7 @@ int crypto4xx_hash_final(struct ahash_request *req);
 int crypto4xx_hash_update(struct ahash_request *req);
 int crypto4xx_hash_init(struct ahash_request *req);
 
-/**
+/*
  * Note: Only use this function to copy items that is word aligned.
  */
 static inline void crypto4xx_memcpy_swab32(u32 *dst, const void *buf,
diff --git a/drivers/crypto/amcc/crypto4xx_reg_def.h b/drivers/crypto/amcc/crypto4xx_reg_def.h
index c4c0a1a75941..1038061224da 100644
--- a/drivers/crypto/amcc/crypto4xx_reg_def.h
+++ b/drivers/crypto/amcc/crypto4xx_reg_def.h
@@ -1,5 +1,5 @@
 /* SPDX-License-Identifier: GPL-2.0-or-later */
-/**
+/*
  * AMCC SoC PPC4xx Crypto Driver
  *
  * Copyright (c) 2008 Applied Micro Circuits Corporation.
@@ -104,7 +104,7 @@
 #define CRYPTO4XX_PRNG_LFSR_L			0x00070030
 #define CRYPTO4XX_PRNG_LFSR_H			0x00070034
 
-/**
+/*
  * Initialize CRYPTO ENGINE registers, and memory bases.
  */
 #define PPC4XX_PDR_POLL				0x3ff
@@ -123,7 +123,7 @@
 #define PPC4XX_INT_TIMEOUT_CNT			0
 #define PPC4XX_INT_TIMEOUT_CNT_REVB		0x3FF
 #define PPC4XX_INT_CFG				1
-/**
+/*
  * all follow define are ad hoc
  */
 #define PPC4XX_RING_RETRY			100
@@ -131,7 +131,7 @@
 #define PPC4XX_SDR_SIZE				PPC4XX_NUM_SD
 #define PPC4XX_GDR_SIZE				PPC4XX_NUM_GD
 
-/**
+/*
   * Generic Security Association (SA) with all possible fields. These will
  * never likely used except for reference purpose. These structure format
  * can be not changed as the hardware expects them to be layout as defined.
diff --git a/drivers/crypto/amcc/crypto4xx_sa.h b/drivers/crypto/amcc/crypto4xx_sa.h
index fe756abfc19f..e98e4e7abbad 100644
--- a/drivers/crypto/amcc/crypto4xx_sa.h
+++ b/drivers/crypto/amcc/crypto4xx_sa.h
@@ -1,5 +1,5 @@
 /* SPDX-License-Identifier: GPL-2.0-or-later */
-/**
+/*
  * AMCC SoC PPC4xx Crypto Driver
  *
  * Copyright (c) 2008 Applied Micro Circuits Corporation.
@@ -14,7 +14,7 @@
 
 #define AES_IV_SIZE				16
 
-/**
+/*
  * Contents of Dynamic Security Association (SA) with all possible fields
  */
 union dynamic_sa_contents {
@@ -122,7 +122,7 @@ union sa_command_0 {
 #define SA_AES_KEY_LEN_256			4
 
 #define SA_REV2					1
-/**
+/*
  * The follow defines bits sa_command_1
  * In Basic hash mode  this bit define simple hash or hmac.
  * In IPsec mode, this bit define muting control.
@@ -172,7 +172,7 @@ struct dynamic_sa_ctl {
 	union sa_command_1 sa_command_1;
 } __attribute__((packed));
 
-/**
+/*
  * State Record for Security Association (SA)
  */
 struct  sa_state_record {
@@ -184,7 +184,7 @@ struct  sa_state_record {
 	};
 } __attribute__((packed));
 
-/**
+/*
  * Security Association (SA) for AES128
  *
  */
@@ -213,7 +213,7 @@ struct dynamic_sa_aes192 {
 #define SA_AES192_LEN		(sizeof(struct dynamic_sa_aes192)/4)
 #define SA_AES192_CONTENTS	0x3e000062
 
-/**
+/*
  * Security Association (SA) for AES256
  */
 struct dynamic_sa_aes256 {
@@ -228,7 +228,7 @@ struct dynamic_sa_aes256 {
 #define SA_AES256_CONTENTS	0x3e000082
 #define SA_AES_CONTENTS		0x3e000002
 
-/**
+/*
  * Security Association (SA) for AES128 CCM
  */
 struct dynamic_sa_aes128_ccm {
@@ -242,7 +242,7 @@ struct dynamic_sa_aes128_ccm {
 #define SA_AES128_CCM_CONTENTS	0x3e000042
 #define SA_AES_CCM_CONTENTS	0x3e000002
 
-/**
+/*
  * Security Association (SA) for AES128_GCM
  */
 struct dynamic_sa_aes128_gcm {
@@ -258,7 +258,7 @@ struct dynamic_sa_aes128_gcm {
 #define SA_AES128_GCM_CONTENTS	0x3e000442
 #define SA_AES_GCM_CONTENTS	0x3e000402
 
-/**
+/*
  * Security Association (SA) for HASH160: HMAC-SHA1
  */
 struct dynamic_sa_hash160 {
diff --git a/drivers/crypto/amcc/crypto4xx_trng.h b/drivers/crypto/amcc/crypto4xx_trng.h
index 3af732f25c1c..7356716274cb 100644
--- a/drivers/crypto/amcc/crypto4xx_trng.h
+++ b/drivers/crypto/amcc/crypto4xx_trng.h
@@ -1,5 +1,5 @@
 /* SPDX-License-Identifier: GPL-2.0-or-later */
-/**
+/*
  * AMCC SoC PPC4xx Crypto Driver
  *
  * Copyright (c) 2008 Applied Micro Circuits Corporation.
-- 
2.17.1

