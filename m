Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A0A62EA480;
	Fri, 17 Jul 2026 02:48:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784256507; cv=none; b=ngZOz39wAlXlTglzEGWvI2ZTPa064FQXW7nflJMcgr89Tu0C/pejlV7WxrwPNiDfexIrgfXLX39t7PKrqgI+JQT9xRAE9LiKBAjO+QZe0Mn8QxQSTi7r7wYhINfIdjdZ12tFA79fEbb6mR1MK7k1u8/5JfBvbxwX7x8edAq6AxI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784256507; c=relaxed/simple;
	bh=tdVcTPss8lWm0vIXCfB5VwM80GI20MwMjQ8a3u+iRXg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ssWdksuOkx46JBIoNetma+lFCNMGjRXUQIptBq4M5tD9PsSjJ2boSYXWerG3/eGSD9EsAbtL1ANECSOBFyhXBVgT/ImwpoKJeTKan3DTf7vfXNB7Jp5di0wq7R6gnCLrAQ9L90bIJnzDkHD2pNPicBjZUAKNSnAYP0TrF7/N080=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MnFIbnJD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MnFIbnJD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF83D1F00A3D;
	Fri, 17 Jul 2026 02:48:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784256506;
	bh=Pl5Tt4V5lOJ/RkZBvr2XzmTT849Eep7rzAPwJ845SXg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MnFIbnJDDHSplzs0XlNnrEn1ZH6maEsQ4LtOvHzCKt6HaErDJ8MrYIP3p0ZPgxWqv
	 U5OOOkc1Z+d6JzKd/MjXXC+VJzVK2kXcicjyhgdCDGplBytfhdmt1t1NC0iLXUDcvR
	 4q4OZa5dHJwnNMbhlrWS02iUuAq5JQn9ijyPIsNk7xX+3rhUgIq8wRAzLXMI7ru5gK
	 05dgr17v/73Z1QHWftETtuN/pEjzCWqDZkbNb5mhUS3QEK+wvazkiYjASkHvADY5SN
	 BkrzCfyYilNPd6of685oGoF+hsxDSx4kmXylud/rdT73wIFQEyHzFTmTnJNMOBnlrF
	 FWwrK5uxHR1ng==
From: Eric Biggers <ebiggers@kernel.org>
To: stable@vger.kernel.org
Cc: linux-crypto@vger.kernel.org,
	Aditya Srivastava <yashsri421@gmail.com>,
	Randy Dunlap <rdunlap@infradead.org>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH 5.10 1/3] crypto: amcc - fix incorrect kernel-doc comment syntax in files
Date: Thu, 16 Jul 2026 19:46:03 -0700
Message-ID: <20260717024605.87486-2-ebiggers@kernel.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260717024605.87486-1-ebiggers@kernel.org>
References: <20260717024605.87486-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Aditya Srivastava <yashsri421@gmail.com>

commit 73f04d3d800f3c8058bb00447e3e1c4cdc85a2b0 upstream.

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
Acked-by: Randy Dunlap <rdunlap@infradead.org>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---
 drivers/crypto/amcc/crypto4xx_alg.c     | 12 ++++++------
 drivers/crypto/amcc/crypto4xx_core.c    | 18 +++++++++---------
 drivers/crypto/amcc/crypto4xx_core.h    |  4 ++--
 drivers/crypto/amcc/crypto4xx_reg_def.h |  8 ++++----
 drivers/crypto/amcc/crypto4xx_sa.h      | 18 +++++++++---------
 drivers/crypto/amcc/crypto4xx_trng.h    |  2 +-
 6 files changed, 31 insertions(+), 31 deletions(-)

diff --git a/drivers/crypto/amcc/crypto4xx_alg.c b/drivers/crypto/amcc/crypto4xx_alg.c
index 7729a637fb02..a90e30f742ed 100644
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
index 6d05ac0c0513..376ea3c239a9 100644
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
@@ -928,7 +928,7 @@ int crypto4xx_build_pd(struct crypto_async_request *req,
 	return is_busy ? -EBUSY : -EINPROGRESS;
 }
 
-/**
+/*
  * Algorithm Registration Functions
  */
 static void crypto4xx_ctx_init(struct crypto4xx_alg *amcc_alg,
@@ -1095,7 +1095,7 @@ static void crypto4xx_bh_tasklet_cb(unsigned long data)
 	} while (head != tail);
 }
 
-/**
+/*
  * Top Half of isr.
  */
 static inline irqreturn_t crypto4xx_interrupt_handler(int irq, void *data,
@@ -1184,7 +1184,7 @@ static int crypto4xx_prng_seed(struct crypto_rng *tfm, const u8 *seed,
 	return 0;
 }
 
-/**
+/*
  * Supported Crypto Algorithms
  */
 static struct crypto4xx_alg_common crypto4xx_alg[] = {
@@ -1367,7 +1367,7 @@ static struct crypto4xx_alg_common crypto4xx_alg[] = {
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
2.55.0

