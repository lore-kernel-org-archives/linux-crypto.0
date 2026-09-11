Received: from smtpout-02.galae.net (smtpout-02.galae.net [185.246.84.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC9003911CE;
	Fri, 11 Sep 2026 14:47:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.246.84.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789138068; cv=none; b=Exo1Y3SKX47WLAJwzisZ0SwyRkvkVXkiRNiHxzoSMnDYB3cdNnN2KFyH9RFqKXFLrO+odcom5ZvbzjmPXQHDSvcWoKLUJLeF+ZYI0DILQ27WG+h+XNnaQWlBRsU6J+C8bbyg7wXqXxDzBkCT+e4Kmh1o96BHeZezPi2HnovplQo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789138068; c=relaxed/simple;
	bh=yl2oSYq28HHoD/I6T9naGGTG/87ynXJdLMVArr7HCWo=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=WA7nFa66qNaYAU9LDQ95n4cNGeTNztfY5rwnQPP+aCoWr789t1eRRiRfHkvJ1EZOKpHTT4DShP3Xr+wiVE5LpRFi9fJ+t7QJtbmqNdn0DBStYxV8UMhzyQf9aOfg509llfgzb3htqYYHMw5xpGMl3BeZIw07vDdcS/cPBRSb1do=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bootlin.com; spf=pass smtp.mailfrom=bootlin.com; dkim=pass (2048-bit key) header.d=bootlin.com header.i=@bootlin.com header.b=qbIvfvNV; arc=none smtp.client-ip=185.246.84.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bootlin.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bootlin.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bootlin.com header.i=@bootlin.com header.b="qbIvfvNV"
Received: from smtpout-01.galae.net (smtpout-01.galae.net [212.83.139.233])
	by smtpout-02.galae.net (Postfix) with ESMTPS id 3E6291A010A;
	Fri, 11 Sep 2026 14:47:43 +0000 (UTC)
Received: from mail.galae.net (mail.galae.net [212.83.136.155])
	by smtpout-01.galae.net (Postfix) with ESMTPS id 12D0E601DE;
	Fri, 11 Sep 2026 14:47:43 +0000 (UTC)
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id EC21F11C7AFC0;
	Fri, 11 Sep 2026 16:47:37 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=dkim;
	t=1789138058; h=from:subject:date:message-id:to:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references;
	bh=MRvoC/SHMN8glx1Jk4i2Iutk0etKiEBMqe8UEKp/XJs=;
	b=qbIvfvNVRNoIcrlXMabiILTn8LTsNQqs3bw1eI8HWIHQACfOnzqUUVfYhm0NbmBN0GE0Hk
	eYicaf1d3Ro8RDyVp47pbKD+6G9Uo8Rh2MU8jF5stDMGMQxTadN+p+pro4Jrp/8oaEmqxE
	Iyk09e507TMLsT3FURmU6F4CMOJnF++RaDrrbqt+rPgs/vkfrm24Bs4xHU6NsSzelMVDob
	c2V+wCWAGnEBfz5c7LTnrdN43kdFu022Be1kotaH2oLrC1c4jxMX738yTCgdObZszTR7kv
	sOWl64BCUXog8qTM7M5Sy3TGP1I1B7v37cgwZcsDRpwdXRPZ8cJYxeSXKd473g==
From: Paul Louvel <paul.louvel@bootlin.com>
Date: Fri, 11 Sep 2026 16:46:32 +0200
Subject: [PATCH v6 15/19] crypto: talitos/aead - Use macro for algorithm
 definitions
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260911-7-3-rc2_talitos_cleanup-v6-15-4215f347c97a@bootlin.com>
References: <20260911-7-3-rc2_talitos_cleanup-v6-0-4215f347c97a@bootlin.com>
In-Reply-To: <20260911-7-3-rc2_talitos_cleanup-v6-0-4215f347c97a@bootlin.com>
To: Herbert Xu <herbert@gondor.apana.org.au>, 
 "David S. Miller" <davem@davemloft.net>
Cc: Paul Louvel <paul.louvel@bootlin.com>, linux-crypto@vger.kernel.org, 
 linux-kernel@vger.kernel.org, 
 Thomas Petazzoni <thomas.petazzoni@bootlin.com>, 
 Christophe Leroy <chleroy@kernel.org>, 
 "Christophe Leroy (CS GROUP)" <chleroy@kernel.org>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1789138028; l=28746;
 i=paul.louvel@bootlin.com; s=20260313; h=from:subject:message-id;
 bh=yl2oSYq28HHoD/I6T9naGGTG/87ynXJdLMVArr7HCWo=;
 b=5X7Umiu8pwpq0a5Ua91epYreRoTUowi6IZ8PKM7bAXuzN+wIUklzIVifp84CynlYyxI2oB/Yo
 UvJdAGsGt6WDTGTL5E/GzLV0oYFR5WdI4knvQ2rlSgSnQapSZy1i0A4
X-Developer-Key: i=paul.louvel@bootlin.com; a=ed25519;
 pk=eLW50NT18UAvUT5cAcYf88zNbBCZDLFXuptpyLVhVIU=
X-Last-TLS-Session-Version: TLSv1.3

Replace the repetitive struct initializer entries with preprocessor
macros.

The fallback setkey assignment (aead_alg->setkey ?: aead_setkey) is
replaced by specifying the correct setkey handler directly in each macro
invocation.

Reviewed-by: Christophe Leroy (CS GROUP) <chleroy@kernel.org>
Signed-off-by: Paul Louvel <paul.louvel@bootlin.com>
---
 drivers/crypto/talitos/talitos-aead.c | 771 +++++++++++-----------------------
 1 file changed, 238 insertions(+), 533 deletions(-)

diff --git a/drivers/crypto/talitos/talitos-aead.c b/drivers/crypto/talitos/talitos-aead.c
index 0504b8575e26..60bc727f76dc 100644
--- a/drivers/crypto/talitos/talitos-aead.c
+++ b/drivers/crypto/talitos/talitos-aead.c
@@ -405,535 +405,245 @@ static void talitos_cra_exit_aead(struct crypto_aead *tfm)
 	talitos_cra_exit(crypto_aead_tfm(tfm));
 }
 
+#define TALITOS_AEAD_ALG_COMMON(name, driver_name, name_prefix, set_key, block_size, \
+				max_auth_size, template, priority)      \
+	{ \
+		.type = CRYPTO_ALG_TYPE_AEAD, \
+		.alg.aead = { \
+			.base = { \
+				.cra_name = name, \
+				.cra_driver_name = driver_name"-talitos"name_prefix, \
+				.cra_blocksize = block_size, \
+				.cra_flags = CRYPTO_ALG_ASYNC | \
+					     CRYPTO_ALG_ALLOCATES_MEMORY | \
+					     CRYPTO_ALG_KERN_DRIVER_ONLY, \
+				.cra_priority = (priority), \
+				.cra_ctxsize = sizeof(struct talitos_ctx), \
+				.cra_module = THIS_MODULE, \
+			}, \
+			.ivsize = block_size, \
+			.maxauthsize = max_auth_size, \
+			.setkey = set_key, \
+			.init = talitos_cra_init_aead, \
+			.exit = talitos_cra_exit_aead, \
+			.encrypt = aead_encrypt, \
+			.decrypt = aead_decrypt, \
+		}, \
+		.desc_hdr_template = template, \
+	}
+
+#define TALITOS_AEAD_ALG(name, driver_name, set_key, block_size, max_auth_size, template)  \
+	TALITOS_AEAD_ALG_COMMON(name, driver_name, "", set_key, block_size, max_auth_size, \
+				template, TALITOS_CRA_PRIORITY)
+
+#define TALITOS_AEAD_ALG_HSNA(name, driver_name, set_key, block_size, max_auth_size, \
+			      template)                                 \
+	TALITOS_AEAD_ALG_COMMON(name, driver_name, "-hsna", set_key, block_size,     \
+				max_auth_size, template,                \
+				TALITOS_CRA_PRIORITY_AEAD_HSNA)
+
 static const struct talitos_alg_template aead_driver_algs[] = {
-	{	.type = CRYPTO_ALG_TYPE_AEAD,
-		.alg.aead = {
-			.base = {
-				.cra_name = "authenc(hmac(sha1),cbc(aes))",
-				.cra_driver_name = "authenc-hmac-sha1-"
-						   "cbc-aes-talitos",
-				.cra_blocksize = AES_BLOCK_SIZE,
-				.cra_module = THIS_MODULE,
-				.cra_priority = TALITOS_CRA_PRIORITY,
-				.cra_ctxsize = sizeof(struct talitos_ctx),
-				.cra_flags = CRYPTO_ALG_KERN_DRIVER_ONLY |
-					     CRYPTO_ALG_ASYNC |
-					     CRYPTO_ALG_ALLOCATES_MEMORY,
-			},
-			.ivsize = AES_BLOCK_SIZE,
-			.maxauthsize = SHA1_DIGEST_SIZE,
-		},
-		.desc_hdr_template = DESC_HDR_TYPE_IPSEC_ESP |
-				     DESC_HDR_SEL0_AESU |
-				     DESC_HDR_MODE0_AESU_CBC |
-				     DESC_HDR_SEL1_MDEUA |
-				     DESC_HDR_MODE1_MDEU_INIT |
-				     DESC_HDR_MODE1_MDEU_PAD |
-				     DESC_HDR_MODE1_MDEU_SHA1_HMAC,
-	},
-	{	.type = CRYPTO_ALG_TYPE_AEAD,
-		.alg.aead = {
-			.base = {
-				.cra_name = "authenc(hmac(sha1),cbc(aes))",
-				.cra_driver_name = "authenc-hmac-sha1-"
-						   "cbc-aes-talitos-hsna",
-				.cra_blocksize = AES_BLOCK_SIZE,
-				.cra_module = THIS_MODULE,
-				.cra_priority = TALITOS_CRA_PRIORITY_AEAD_HSNA,
-				.cra_ctxsize = sizeof(struct talitos_ctx),
-				.cra_flags = CRYPTO_ALG_KERN_DRIVER_ONLY |
-					     CRYPTO_ALG_ASYNC |
-					     CRYPTO_ALG_ALLOCATES_MEMORY,
-			},
-			.ivsize = AES_BLOCK_SIZE,
-			.maxauthsize = SHA1_DIGEST_SIZE,
-		},
-		.desc_hdr_template = DESC_HDR_TYPE_HMAC_SNOOP_NO_AFEU |
-				     DESC_HDR_SEL0_AESU |
-				     DESC_HDR_MODE0_AESU_CBC |
-				     DESC_HDR_SEL1_MDEUA |
-				     DESC_HDR_MODE1_MDEU_INIT |
-				     DESC_HDR_MODE1_MDEU_PAD |
-				     DESC_HDR_MODE1_MDEU_SHA1_HMAC,
-	},
-	{	.type = CRYPTO_ALG_TYPE_AEAD,
-		.alg.aead = {
-			.base = {
-				.cra_name = "authenc(hmac(sha1),"
-					    "cbc(des3_ede))",
-				.cra_driver_name = "authenc-hmac-sha1-"
-						   "cbc-3des-talitos",
-				.cra_blocksize = DES3_EDE_BLOCK_SIZE,
-				.cra_module = THIS_MODULE,
-				.cra_priority = TALITOS_CRA_PRIORITY,
-				.cra_ctxsize = sizeof(struct talitos_ctx),
-				.cra_flags = CRYPTO_ALG_KERN_DRIVER_ONLY |
-					     CRYPTO_ALG_ASYNC |
-					     CRYPTO_ALG_ALLOCATES_MEMORY,
-			},
-			.ivsize = DES3_EDE_BLOCK_SIZE,
-			.maxauthsize = SHA1_DIGEST_SIZE,
-			.setkey = aead_des3_setkey,
-		},
-		.desc_hdr_template = DESC_HDR_TYPE_IPSEC_ESP |
-				     DESC_HDR_SEL0_DEU |
-				     DESC_HDR_MODE0_DEU_CBC |
-				     DESC_HDR_MODE0_DEU_3DES |
-				     DESC_HDR_SEL1_MDEUA |
-				     DESC_HDR_MODE1_MDEU_INIT |
-				     DESC_HDR_MODE1_MDEU_PAD |
-				     DESC_HDR_MODE1_MDEU_SHA1_HMAC,
-	},
-	{	.type = CRYPTO_ALG_TYPE_AEAD,
-		.alg.aead = {
-			.base = {
-				.cra_name = "authenc(hmac(sha1),"
-					    "cbc(des3_ede))",
-				.cra_driver_name = "authenc-hmac-sha1-"
-						   "cbc-3des-talitos-hsna",
-				.cra_blocksize = DES3_EDE_BLOCK_SIZE,
-				.cra_module = THIS_MODULE,
-				.cra_priority = TALITOS_CRA_PRIORITY_AEAD_HSNA,
-				.cra_ctxsize = sizeof(struct talitos_ctx),
-				.cra_flags = CRYPTO_ALG_KERN_DRIVER_ONLY |
-					     CRYPTO_ALG_ASYNC |
-					     CRYPTO_ALG_ALLOCATES_MEMORY,
-			},
-			.ivsize = DES3_EDE_BLOCK_SIZE,
-			.maxauthsize = SHA1_DIGEST_SIZE,
-			.setkey = aead_des3_setkey,
-		},
-		.desc_hdr_template = DESC_HDR_TYPE_HMAC_SNOOP_NO_AFEU |
-				     DESC_HDR_SEL0_DEU |
-				     DESC_HDR_MODE0_DEU_CBC |
-				     DESC_HDR_MODE0_DEU_3DES |
-				     DESC_HDR_SEL1_MDEUA |
-				     DESC_HDR_MODE1_MDEU_INIT |
-				     DESC_HDR_MODE1_MDEU_PAD |
-				     DESC_HDR_MODE1_MDEU_SHA1_HMAC,
-	},
-	{       .type = CRYPTO_ALG_TYPE_AEAD,
-		.alg.aead = {
-			.base = {
-				.cra_name = "authenc(hmac(sha224),cbc(aes))",
-				.cra_driver_name = "authenc-hmac-sha224-"
-						   "cbc-aes-talitos",
-				.cra_blocksize = AES_BLOCK_SIZE,
-				.cra_module = THIS_MODULE,
-				.cra_priority = TALITOS_CRA_PRIORITY,
-				.cra_ctxsize = sizeof(struct talitos_ctx),
-				.cra_flags = CRYPTO_ALG_KERN_DRIVER_ONLY |
-					     CRYPTO_ALG_ASYNC |
-					     CRYPTO_ALG_ALLOCATES_MEMORY,
-			},
-			.ivsize = AES_BLOCK_SIZE,
-			.maxauthsize = SHA224_DIGEST_SIZE,
-		},
-		.desc_hdr_template = DESC_HDR_TYPE_IPSEC_ESP |
-				     DESC_HDR_SEL0_AESU |
-				     DESC_HDR_MODE0_AESU_CBC |
-				     DESC_HDR_SEL1_MDEUA |
-				     DESC_HDR_MODE1_MDEU_INIT |
-				     DESC_HDR_MODE1_MDEU_PAD |
-				     DESC_HDR_MODE1_MDEU_SHA224_HMAC,
-	},
-	{       .type = CRYPTO_ALG_TYPE_AEAD,
-		.alg.aead = {
-			.base = {
-				.cra_name = "authenc(hmac(sha224),cbc(aes))",
-				.cra_driver_name = "authenc-hmac-sha224-"
-						   "cbc-aes-talitos-hsna",
-				.cra_blocksize = AES_BLOCK_SIZE,
-				.cra_module = THIS_MODULE,
-				.cra_priority = TALITOS_CRA_PRIORITY_AEAD_HSNA,
-				.cra_ctxsize = sizeof(struct talitos_ctx),
-				.cra_flags = CRYPTO_ALG_KERN_DRIVER_ONLY |
-					     CRYPTO_ALG_ASYNC |
-					     CRYPTO_ALG_ALLOCATES_MEMORY,
-			},
-			.ivsize = AES_BLOCK_SIZE,
-			.maxauthsize = SHA224_DIGEST_SIZE,
-		},
-		.desc_hdr_template = DESC_HDR_TYPE_HMAC_SNOOP_NO_AFEU |
-				     DESC_HDR_SEL0_AESU |
-				     DESC_HDR_MODE0_AESU_CBC |
-				     DESC_HDR_SEL1_MDEUA |
-				     DESC_HDR_MODE1_MDEU_INIT |
-				     DESC_HDR_MODE1_MDEU_PAD |
-				     DESC_HDR_MODE1_MDEU_SHA224_HMAC,
-	},
-	{	.type = CRYPTO_ALG_TYPE_AEAD,
-		.alg.aead = {
-			.base = {
-				.cra_name = "authenc(hmac(sha224),"
-					    "cbc(des3_ede))",
-				.cra_driver_name = "authenc-hmac-sha224-"
-						   "cbc-3des-talitos",
-				.cra_blocksize = DES3_EDE_BLOCK_SIZE,
-				.cra_module = THIS_MODULE,
-				.cra_priority = TALITOS_CRA_PRIORITY,
-				.cra_ctxsize = sizeof(struct talitos_ctx),
-				.cra_flags = CRYPTO_ALG_KERN_DRIVER_ONLY |
-					     CRYPTO_ALG_ASYNC |
-					     CRYPTO_ALG_ALLOCATES_MEMORY,
-			},
-			.ivsize = DES3_EDE_BLOCK_SIZE,
-			.maxauthsize = SHA224_DIGEST_SIZE,
-			.setkey = aead_des3_setkey,
-		},
-		.desc_hdr_template = DESC_HDR_TYPE_IPSEC_ESP |
-				     DESC_HDR_SEL0_DEU |
-				     DESC_HDR_MODE0_DEU_CBC |
-				     DESC_HDR_MODE0_DEU_3DES |
-				     DESC_HDR_SEL1_MDEUA |
-				     DESC_HDR_MODE1_MDEU_INIT |
-				     DESC_HDR_MODE1_MDEU_PAD |
-				     DESC_HDR_MODE1_MDEU_SHA224_HMAC,
-	},
-	{	.type = CRYPTO_ALG_TYPE_AEAD,
-		.alg.aead = {
-			.base = {
-				.cra_name = "authenc(hmac(sha224),"
-					    "cbc(des3_ede))",
-				.cra_driver_name = "authenc-hmac-sha224-"
-						   "cbc-3des-talitos-hsna",
-				.cra_blocksize = DES3_EDE_BLOCK_SIZE,
-				.cra_module = THIS_MODULE,
-				.cra_priority = TALITOS_CRA_PRIORITY_AEAD_HSNA,
-				.cra_ctxsize = sizeof(struct talitos_ctx),
-				.cra_flags = CRYPTO_ALG_KERN_DRIVER_ONLY |
-					     CRYPTO_ALG_ASYNC |
-					     CRYPTO_ALG_ALLOCATES_MEMORY,
-			},
-			.ivsize = DES3_EDE_BLOCK_SIZE,
-			.maxauthsize = SHA224_DIGEST_SIZE,
-			.setkey = aead_des3_setkey,
-		},
-		.desc_hdr_template = DESC_HDR_TYPE_HMAC_SNOOP_NO_AFEU |
-				     DESC_HDR_SEL0_DEU |
-				     DESC_HDR_MODE0_DEU_CBC |
-				     DESC_HDR_MODE0_DEU_3DES |
-				     DESC_HDR_SEL1_MDEUA |
-				     DESC_HDR_MODE1_MDEU_INIT |
-				     DESC_HDR_MODE1_MDEU_PAD |
-				     DESC_HDR_MODE1_MDEU_SHA224_HMAC,
-	},
-	{	.type = CRYPTO_ALG_TYPE_AEAD,
-		.alg.aead = {
-			.base = {
-				.cra_name = "authenc(hmac(sha256),cbc(aes))",
-				.cra_driver_name = "authenc-hmac-sha256-"
-						   "cbc-aes-talitos",
-				.cra_blocksize = AES_BLOCK_SIZE,
-				.cra_module = THIS_MODULE,
-				.cra_priority = TALITOS_CRA_PRIORITY,
-				.cra_ctxsize = sizeof(struct talitos_ctx),
-				.cra_flags = CRYPTO_ALG_KERN_DRIVER_ONLY |
-					     CRYPTO_ALG_ASYNC |
-					     CRYPTO_ALG_ALLOCATES_MEMORY,
-			},
-			.ivsize = AES_BLOCK_SIZE,
-			.maxauthsize = SHA256_DIGEST_SIZE,
-		},
-		.desc_hdr_template = DESC_HDR_TYPE_IPSEC_ESP |
-				     DESC_HDR_SEL0_AESU |
-				     DESC_HDR_MODE0_AESU_CBC |
-				     DESC_HDR_SEL1_MDEUA |
-				     DESC_HDR_MODE1_MDEU_INIT |
-				     DESC_HDR_MODE1_MDEU_PAD |
-				     DESC_HDR_MODE1_MDEU_SHA256_HMAC,
-	},
-	{	.type = CRYPTO_ALG_TYPE_AEAD,
-		.alg.aead = {
-			.base = {
-				.cra_name = "authenc(hmac(sha256),cbc(aes))",
-				.cra_driver_name = "authenc-hmac-sha256-"
-						   "cbc-aes-talitos-hsna",
-				.cra_blocksize = AES_BLOCK_SIZE,
-				.cra_module = THIS_MODULE,
-				.cra_priority = TALITOS_CRA_PRIORITY_AEAD_HSNA,
-				.cra_ctxsize = sizeof(struct talitos_ctx),
-				.cra_flags = CRYPTO_ALG_KERN_DRIVER_ONLY |
-					     CRYPTO_ALG_ASYNC |
-					     CRYPTO_ALG_ALLOCATES_MEMORY,
-			},
-			.ivsize = AES_BLOCK_SIZE,
-			.maxauthsize = SHA256_DIGEST_SIZE,
-		},
-		.desc_hdr_template = DESC_HDR_TYPE_HMAC_SNOOP_NO_AFEU |
-				     DESC_HDR_SEL0_AESU |
-				     DESC_HDR_MODE0_AESU_CBC |
-				     DESC_HDR_SEL1_MDEUA |
-				     DESC_HDR_MODE1_MDEU_INIT |
-				     DESC_HDR_MODE1_MDEU_PAD |
-				     DESC_HDR_MODE1_MDEU_SHA256_HMAC,
-	},
-	{	.type = CRYPTO_ALG_TYPE_AEAD,
-		.alg.aead = {
-			.base = {
-				.cra_name = "authenc(hmac(sha256),"
-					    "cbc(des3_ede))",
-				.cra_driver_name = "authenc-hmac-sha256-"
-						   "cbc-3des-talitos",
-				.cra_blocksize = DES3_EDE_BLOCK_SIZE,
-				.cra_module = THIS_MODULE,
-				.cra_priority = TALITOS_CRA_PRIORITY,
-				.cra_ctxsize = sizeof(struct talitos_ctx),
-				.cra_flags = CRYPTO_ALG_KERN_DRIVER_ONLY |
-					     CRYPTO_ALG_ASYNC |
-					     CRYPTO_ALG_ALLOCATES_MEMORY,
-			},
-			.ivsize = DES3_EDE_BLOCK_SIZE,
-			.maxauthsize = SHA256_DIGEST_SIZE,
-			.setkey = aead_des3_setkey,
-		},
-		.desc_hdr_template = DESC_HDR_TYPE_IPSEC_ESP |
-				     DESC_HDR_SEL0_DEU |
-				     DESC_HDR_MODE0_DEU_CBC |
-				     DESC_HDR_MODE0_DEU_3DES |
-				     DESC_HDR_SEL1_MDEUA |
-				     DESC_HDR_MODE1_MDEU_INIT |
-				     DESC_HDR_MODE1_MDEU_PAD |
-				     DESC_HDR_MODE1_MDEU_SHA256_HMAC,
-	},
-	{	.type = CRYPTO_ALG_TYPE_AEAD,
-		.alg.aead = {
-			.base = {
-				.cra_name = "authenc(hmac(sha256),"
-					    "cbc(des3_ede))",
-				.cra_driver_name = "authenc-hmac-sha256-"
-						   "cbc-3des-talitos-hsna",
-				.cra_blocksize = DES3_EDE_BLOCK_SIZE,
-				.cra_module = THIS_MODULE,
-				.cra_priority = TALITOS_CRA_PRIORITY_AEAD_HSNA,
-				.cra_ctxsize = sizeof(struct talitos_ctx),
-				.cra_flags = CRYPTO_ALG_KERN_DRIVER_ONLY |
-					     CRYPTO_ALG_ASYNC |
-					     CRYPTO_ALG_ALLOCATES_MEMORY,
-			},
-			.ivsize = DES3_EDE_BLOCK_SIZE,
-			.maxauthsize = SHA256_DIGEST_SIZE,
-			.setkey = aead_des3_setkey,
-		},
-		.desc_hdr_template = DESC_HDR_TYPE_HMAC_SNOOP_NO_AFEU |
-				     DESC_HDR_SEL0_DEU |
-				     DESC_HDR_MODE0_DEU_CBC |
-				     DESC_HDR_MODE0_DEU_3DES |
-				     DESC_HDR_SEL1_MDEUA |
-				     DESC_HDR_MODE1_MDEU_INIT |
-				     DESC_HDR_MODE1_MDEU_PAD |
-				     DESC_HDR_MODE1_MDEU_SHA256_HMAC,
-	},
-	{	.type = CRYPTO_ALG_TYPE_AEAD,
-		.alg.aead = {
-			.base = {
-				.cra_name = "authenc(hmac(sha384),cbc(aes))",
-				.cra_driver_name = "authenc-hmac-sha384-"
-						   "cbc-aes-talitos",
-				.cra_blocksize = AES_BLOCK_SIZE,
-				.cra_module = THIS_MODULE,
-				.cra_priority = TALITOS_CRA_PRIORITY,
-				.cra_ctxsize = sizeof(struct talitos_ctx),
-				.cra_flags = CRYPTO_ALG_KERN_DRIVER_ONLY |
-					     CRYPTO_ALG_ASYNC |
-					     CRYPTO_ALG_ALLOCATES_MEMORY,
-			},
-			.ivsize = AES_BLOCK_SIZE,
-			.maxauthsize = SHA384_DIGEST_SIZE,
-		},
-		.desc_hdr_template = DESC_HDR_TYPE_IPSEC_ESP |
-				     DESC_HDR_SEL0_AESU |
-				     DESC_HDR_MODE0_AESU_CBC |
-				     DESC_HDR_SEL1_MDEUB |
-				     DESC_HDR_MODE1_MDEU_INIT |
-				     DESC_HDR_MODE1_MDEU_PAD |
-				     DESC_HDR_MODE1_MDEUB_SHA384_HMAC,
-	},
-	{	.type = CRYPTO_ALG_TYPE_AEAD,
-		.alg.aead = {
-			.base = {
-				.cra_name = "authenc(hmac(sha384),"
-					    "cbc(des3_ede))",
-				.cra_driver_name = "authenc-hmac-sha384-"
-						   "cbc-3des-talitos",
-				.cra_blocksize = DES3_EDE_BLOCK_SIZE,
-				.cra_module = THIS_MODULE,
-				.cra_priority = TALITOS_CRA_PRIORITY,
-				.cra_ctxsize = sizeof(struct talitos_ctx),
-				.cra_flags = CRYPTO_ALG_KERN_DRIVER_ONLY |
-					     CRYPTO_ALG_ASYNC |
-					     CRYPTO_ALG_ALLOCATES_MEMORY,
-			},
-			.ivsize = DES3_EDE_BLOCK_SIZE,
-			.maxauthsize = SHA384_DIGEST_SIZE,
-			.setkey = aead_des3_setkey,
-		},
-		.desc_hdr_template = DESC_HDR_TYPE_IPSEC_ESP |
-				     DESC_HDR_SEL0_DEU |
-				     DESC_HDR_MODE0_DEU_CBC |
-				     DESC_HDR_MODE0_DEU_3DES |
-				     DESC_HDR_SEL1_MDEUB |
-				     DESC_HDR_MODE1_MDEU_INIT |
-				     DESC_HDR_MODE1_MDEU_PAD |
-				     DESC_HDR_MODE1_MDEUB_SHA384_HMAC,
-	},
-	{	.type = CRYPTO_ALG_TYPE_AEAD,
-		.alg.aead = {
-			.base = {
-				.cra_name = "authenc(hmac(sha512),cbc(aes))",
-				.cra_driver_name = "authenc-hmac-sha512-"
-						   "cbc-aes-talitos",
-				.cra_blocksize = AES_BLOCK_SIZE,
-				.cra_module = THIS_MODULE,
-				.cra_priority = TALITOS_CRA_PRIORITY,
-				.cra_ctxsize = sizeof(struct talitos_ctx),
-				.cra_flags = CRYPTO_ALG_KERN_DRIVER_ONLY |
-					     CRYPTO_ALG_ASYNC |
-					     CRYPTO_ALG_ALLOCATES_MEMORY,
-			},
-			.ivsize = AES_BLOCK_SIZE,
-			.maxauthsize = SHA512_DIGEST_SIZE,
-		},
-		.desc_hdr_template = DESC_HDR_TYPE_IPSEC_ESP |
-				     DESC_HDR_SEL0_AESU |
-				     DESC_HDR_MODE0_AESU_CBC |
-				     DESC_HDR_SEL1_MDEUB |
-				     DESC_HDR_MODE1_MDEU_INIT |
-				     DESC_HDR_MODE1_MDEU_PAD |
-				     DESC_HDR_MODE1_MDEUB_SHA512_HMAC,
-	},
-	{	.type = CRYPTO_ALG_TYPE_AEAD,
-		.alg.aead = {
-			.base = {
-				.cra_name = "authenc(hmac(sha512),"
-					    "cbc(des3_ede))",
-				.cra_driver_name = "authenc-hmac-sha512-"
-						   "cbc-3des-talitos",
-				.cra_blocksize = DES3_EDE_BLOCK_SIZE,
-				.cra_module = THIS_MODULE,
-				.cra_priority = TALITOS_CRA_PRIORITY,
-				.cra_ctxsize = sizeof(struct talitos_ctx),
-				.cra_flags = CRYPTO_ALG_KERN_DRIVER_ONLY |
-					     CRYPTO_ALG_ASYNC |
-					     CRYPTO_ALG_ALLOCATES_MEMORY,
-			},
-			.ivsize = DES3_EDE_BLOCK_SIZE,
-			.maxauthsize = SHA512_DIGEST_SIZE,
-			.setkey = aead_des3_setkey,
-		},
-		.desc_hdr_template = DESC_HDR_TYPE_IPSEC_ESP |
-				     DESC_HDR_SEL0_DEU |
-				     DESC_HDR_MODE0_DEU_CBC |
-				     DESC_HDR_MODE0_DEU_3DES |
-				     DESC_HDR_SEL1_MDEUB |
-				     DESC_HDR_MODE1_MDEU_INIT |
-				     DESC_HDR_MODE1_MDEU_PAD |
-				     DESC_HDR_MODE1_MDEUB_SHA512_HMAC,
-	},
-	{	.type = CRYPTO_ALG_TYPE_AEAD,
-		.alg.aead = {
-			.base = {
-				.cra_name = "authenc(hmac(md5),cbc(aes))",
-				.cra_driver_name = "authenc-hmac-md5-"
-						   "cbc-aes-talitos",
-				.cra_blocksize = AES_BLOCK_SIZE,
-				.cra_module = THIS_MODULE,
-				.cra_priority = TALITOS_CRA_PRIORITY,
-				.cra_ctxsize = sizeof(struct talitos_ctx),
-				.cra_flags = CRYPTO_ALG_KERN_DRIVER_ONLY |
-					     CRYPTO_ALG_ASYNC |
-					     CRYPTO_ALG_ALLOCATES_MEMORY,
-			},
-			.ivsize = AES_BLOCK_SIZE,
-			.maxauthsize = MD5_DIGEST_SIZE,
-		},
-		.desc_hdr_template = DESC_HDR_TYPE_IPSEC_ESP |
-				     DESC_HDR_SEL0_AESU |
-				     DESC_HDR_MODE0_AESU_CBC |
-				     DESC_HDR_SEL1_MDEUA |
-				     DESC_HDR_MODE1_MDEU_INIT |
-				     DESC_HDR_MODE1_MDEU_PAD |
-				     DESC_HDR_MODE1_MDEU_MD5_HMAC,
-	},
-	{	.type = CRYPTO_ALG_TYPE_AEAD,
-		.alg.aead = {
-			.base = {
-				.cra_name = "authenc(hmac(md5),cbc(aes))",
-				.cra_driver_name = "authenc-hmac-md5-"
-						   "cbc-aes-talitos-hsna",
-				.cra_blocksize = AES_BLOCK_SIZE,
-				.cra_module = THIS_MODULE,
-				.cra_priority = TALITOS_CRA_PRIORITY_AEAD_HSNA,
-				.cra_ctxsize = sizeof(struct talitos_ctx),
-				.cra_flags = CRYPTO_ALG_KERN_DRIVER_ONLY |
-					     CRYPTO_ALG_ASYNC |
-					     CRYPTO_ALG_ALLOCATES_MEMORY,
-			},
-			.ivsize = AES_BLOCK_SIZE,
-			.maxauthsize = MD5_DIGEST_SIZE,
-		},
-		.desc_hdr_template = DESC_HDR_TYPE_HMAC_SNOOP_NO_AFEU |
-				     DESC_HDR_SEL0_AESU |
-				     DESC_HDR_MODE0_AESU_CBC |
-				     DESC_HDR_SEL1_MDEUA |
-				     DESC_HDR_MODE1_MDEU_INIT |
-				     DESC_HDR_MODE1_MDEU_PAD |
-				     DESC_HDR_MODE1_MDEU_MD5_HMAC,
-	},
-	{	.type = CRYPTO_ALG_TYPE_AEAD,
-		.alg.aead = {
-			.base = {
-				.cra_name = "authenc(hmac(md5),cbc(des3_ede))",
-				.cra_driver_name = "authenc-hmac-md5-"
-						   "cbc-3des-talitos",
-				.cra_blocksize = DES3_EDE_BLOCK_SIZE,
-				.cra_module = THIS_MODULE,
-				.cra_priority = TALITOS_CRA_PRIORITY,
-				.cra_ctxsize = sizeof(struct talitos_ctx),
-				.cra_flags = CRYPTO_ALG_KERN_DRIVER_ONLY |
-					     CRYPTO_ALG_ASYNC |
-					     CRYPTO_ALG_ALLOCATES_MEMORY,
-			},
-			.ivsize = DES3_EDE_BLOCK_SIZE,
-			.maxauthsize = MD5_DIGEST_SIZE,
-			.setkey = aead_des3_setkey,
-		},
-		.desc_hdr_template = DESC_HDR_TYPE_IPSEC_ESP |
-				     DESC_HDR_SEL0_DEU |
-				     DESC_HDR_MODE0_DEU_CBC |
-				     DESC_HDR_MODE0_DEU_3DES |
-				     DESC_HDR_SEL1_MDEUA |
-				     DESC_HDR_MODE1_MDEU_INIT |
-				     DESC_HDR_MODE1_MDEU_PAD |
-				     DESC_HDR_MODE1_MDEU_MD5_HMAC,
-	},
-	{	.type = CRYPTO_ALG_TYPE_AEAD,
-		.alg.aead = {
-			.base = {
-				.cra_name = "authenc(hmac(md5),cbc(des3_ede))",
-				.cra_driver_name = "authenc-hmac-md5-"
-						   "cbc-3des-talitos-hsna",
-				.cra_blocksize = DES3_EDE_BLOCK_SIZE,
-				.cra_module = THIS_MODULE,
-				.cra_priority = TALITOS_CRA_PRIORITY_AEAD_HSNA,
-				.cra_ctxsize = sizeof(struct talitos_ctx),
-				.cra_flags = CRYPTO_ALG_KERN_DRIVER_ONLY |
-					     CRYPTO_ALG_ASYNC |
-					     CRYPTO_ALG_ALLOCATES_MEMORY,
-			},
-			.ivsize = DES3_EDE_BLOCK_SIZE,
-			.maxauthsize = MD5_DIGEST_SIZE,
-			.setkey = aead_des3_setkey,
-		},
-		.desc_hdr_template = DESC_HDR_TYPE_HMAC_SNOOP_NO_AFEU |
-				     DESC_HDR_SEL0_DEU |
-				     DESC_HDR_MODE0_DEU_CBC |
-				     DESC_HDR_MODE0_DEU_3DES |
-				     DESC_HDR_SEL1_MDEUA |
-				     DESC_HDR_MODE1_MDEU_INIT |
-				     DESC_HDR_MODE1_MDEU_PAD |
-				     DESC_HDR_MODE1_MDEU_MD5_HMAC,
-	},
+	/* AEAD algorithms.  These use a single-pass ipsec_esp descriptor */
+
+	/* sha1 auth */
+
+	TALITOS_AEAD_ALG("authenc(hmac(sha1),cbc(aes))",
+			 "authenc-hmac-sha1-cbc-aes", aead_setkey,
+			 AES_BLOCK_SIZE, SHA1_DIGEST_SIZE,
+			 DESC_HDR_TYPE_IPSEC_ESP | DESC_HDR_SEL0_AESU |
+				 DESC_HDR_MODE0_AESU_CBC | DESC_HDR_SEL1_MDEUA |
+				 DESC_HDR_MODE1_MDEU_INIT |
+				 DESC_HDR_MODE1_MDEU_PAD |
+				 DESC_HDR_MODE1_MDEU_SHA1_HMAC),
+
+	TALITOS_AEAD_ALG_HSNA(
+		"authenc(hmac(sha1),cbc(aes))",
+		"authenc-hmac-sha1-cbc-aes", aead_setkey, AES_BLOCK_SIZE,
+		SHA1_DIGEST_SIZE,
+		DESC_HDR_TYPE_HMAC_SNOOP_NO_AFEU | DESC_HDR_SEL0_AESU |
+			DESC_HDR_MODE0_AESU_CBC | DESC_HDR_SEL1_MDEUA |
+			DESC_HDR_MODE1_MDEU_INIT | DESC_HDR_MODE1_MDEU_PAD |
+			DESC_HDR_MODE1_MDEU_SHA1_HMAC),
+
+	TALITOS_AEAD_ALG("authenc(hmac(sha1),cbc(des3_ede))",
+			 "authenc-hmac-sha1-cbc-3des", aead_des3_setkey,
+			 DES3_EDE_BLOCK_SIZE, SHA1_DIGEST_SIZE,
+			 DESC_HDR_TYPE_IPSEC_ESP | DESC_HDR_SEL0_DEU |
+				 DESC_HDR_MODE0_DEU_CBC |
+				 DESC_HDR_MODE0_DEU_3DES | DESC_HDR_SEL1_MDEUA |
+				 DESC_HDR_MODE1_MDEU_INIT |
+				 DESC_HDR_MODE1_MDEU_PAD |
+				 DESC_HDR_MODE1_MDEU_SHA1_HMAC),
+
+	TALITOS_AEAD_ALG_HSNA(
+		"authenc(hmac(sha1),cbc(des3_ede))",
+		"authenc-hmac-sha1-cbc-3des", aead_des3_setkey,
+		DES3_EDE_BLOCK_SIZE, SHA1_DIGEST_SIZE,
+		DESC_HDR_TYPE_HMAC_SNOOP_NO_AFEU | DESC_HDR_SEL0_DEU |
+			DESC_HDR_MODE0_DEU_CBC | DESC_HDR_MODE0_DEU_3DES |
+			DESC_HDR_SEL1_MDEUA | DESC_HDR_MODE1_MDEU_INIT |
+			DESC_HDR_MODE1_MDEU_PAD |
+			DESC_HDR_MODE1_MDEU_SHA1_HMAC),
+
+	/* sha224 auth */
+
+	TALITOS_AEAD_ALG("authenc(hmac(sha224),cbc(aes))",
+			 "authenc-hmac-sha224-cbc-aes", aead_setkey,
+			 AES_BLOCK_SIZE, SHA224_DIGEST_SIZE,
+			 DESC_HDR_TYPE_IPSEC_ESP | DESC_HDR_SEL0_AESU |
+				 DESC_HDR_MODE0_AESU_CBC | DESC_HDR_SEL1_MDEUA |
+				 DESC_HDR_MODE1_MDEU_INIT |
+				 DESC_HDR_MODE1_MDEU_PAD |
+				 DESC_HDR_MODE1_MDEU_SHA224_HMAC),
+
+	TALITOS_AEAD_ALG_HSNA(
+		"authenc(hmac(sha224),cbc(aes))",
+		"authenc-hmac-sha224-cbc-aes", aead_setkey, AES_BLOCK_SIZE,
+		SHA224_DIGEST_SIZE,
+		DESC_HDR_TYPE_HMAC_SNOOP_NO_AFEU | DESC_HDR_SEL0_AESU |
+			DESC_HDR_MODE0_AESU_CBC | DESC_HDR_SEL1_MDEUA |
+			DESC_HDR_MODE1_MDEU_INIT | DESC_HDR_MODE1_MDEU_PAD |
+			DESC_HDR_MODE1_MDEU_SHA224_HMAC),
+
+	TALITOS_AEAD_ALG(
+		"authenc(hmac(sha224),cbc(des3_ede))",
+		"authenc-hmac-sha224-cbc-3des", aead_des3_setkey,
+		DES3_EDE_BLOCK_SIZE, SHA224_DIGEST_SIZE,
+		DESC_HDR_TYPE_IPSEC_ESP | DESC_HDR_SEL0_DEU |
+			DESC_HDR_MODE0_DEU_CBC | DESC_HDR_MODE0_DEU_3DES |
+			DESC_HDR_SEL1_MDEUA | DESC_HDR_MODE1_MDEU_INIT |
+			DESC_HDR_MODE1_MDEU_PAD |
+			DESC_HDR_MODE1_MDEU_SHA224_HMAC),
+
+	TALITOS_AEAD_ALG_HSNA(
+		"authenc(hmac(sha224),cbc(des3_ede))",
+		"authenc-hmac-sha224-cbc-3des", aead_des3_setkey,
+		DES3_EDE_BLOCK_SIZE, SHA224_DIGEST_SIZE,
+		DESC_HDR_TYPE_HMAC_SNOOP_NO_AFEU | DESC_HDR_SEL0_DEU |
+			DESC_HDR_MODE0_DEU_CBC | DESC_HDR_MODE0_DEU_3DES |
+			DESC_HDR_SEL1_MDEUA | DESC_HDR_MODE1_MDEU_INIT |
+			DESC_HDR_MODE1_MDEU_PAD |
+			DESC_HDR_MODE1_MDEU_SHA224_HMAC),
+
+	/* sha256 auth */
+
+	TALITOS_AEAD_ALG("authenc(hmac(sha256),cbc(aes))",
+			 "authenc-hmac-sha256-cbc-aes", aead_setkey,
+			 AES_BLOCK_SIZE, SHA256_DIGEST_SIZE,
+			 DESC_HDR_TYPE_IPSEC_ESP | DESC_HDR_SEL0_AESU |
+				 DESC_HDR_MODE0_AESU_CBC | DESC_HDR_SEL1_MDEUA |
+				 DESC_HDR_MODE1_MDEU_INIT |
+				 DESC_HDR_MODE1_MDEU_PAD |
+				 DESC_HDR_MODE1_MDEU_SHA256_HMAC),
+
+	TALITOS_AEAD_ALG_HSNA(
+		"authenc(hmac(sha256),cbc(aes))",
+		"authenc-hmac-sha256-cbc-aes", aead_setkey, AES_BLOCK_SIZE,
+		SHA256_DIGEST_SIZE,
+		DESC_HDR_TYPE_HMAC_SNOOP_NO_AFEU | DESC_HDR_SEL0_AESU |
+			DESC_HDR_MODE0_AESU_CBC | DESC_HDR_SEL1_MDEUA |
+			DESC_HDR_MODE1_MDEU_INIT | DESC_HDR_MODE1_MDEU_PAD |
+			DESC_HDR_MODE1_MDEU_SHA256_HMAC),
+
+	TALITOS_AEAD_ALG(
+		"authenc(hmac(sha256),cbc(des3_ede))",
+		"authenc-hmac-sha256-cbc-3des", aead_des3_setkey,
+		DES3_EDE_BLOCK_SIZE, SHA256_DIGEST_SIZE,
+		DESC_HDR_TYPE_IPSEC_ESP | DESC_HDR_SEL0_DEU |
+			DESC_HDR_MODE0_DEU_CBC | DESC_HDR_MODE0_DEU_3DES |
+			DESC_HDR_SEL1_MDEUA | DESC_HDR_MODE1_MDEU_INIT |
+			DESC_HDR_MODE1_MDEU_PAD |
+			DESC_HDR_MODE1_MDEU_SHA256_HMAC),
+
+	TALITOS_AEAD_ALG_HSNA(
+		"authenc(hmac(sha256),cbc(des3_ede))",
+		"authenc-hmac-sha256-cbc-3des", aead_des3_setkey,
+		DES3_EDE_BLOCK_SIZE, SHA256_DIGEST_SIZE,
+		DESC_HDR_TYPE_HMAC_SNOOP_NO_AFEU | DESC_HDR_SEL0_DEU |
+			DESC_HDR_MODE0_DEU_CBC | DESC_HDR_MODE0_DEU_3DES |
+			DESC_HDR_SEL1_MDEUA | DESC_HDR_MODE1_MDEU_INIT |
+			DESC_HDR_MODE1_MDEU_PAD |
+			DESC_HDR_MODE1_MDEU_SHA256_HMAC),
+
+	/* sha384 auth */
+
+	TALITOS_AEAD_ALG("authenc(hmac(sha384),cbc(aes))",
+			 "authenc-hmac-sha384-cbc-aes", aead_setkey,
+			 AES_BLOCK_SIZE, SHA384_DIGEST_SIZE,
+			 DESC_HDR_TYPE_IPSEC_ESP | DESC_HDR_SEL0_AESU |
+				 DESC_HDR_MODE0_AESU_CBC | DESC_HDR_SEL1_MDEUB |
+				 DESC_HDR_MODE1_MDEU_INIT |
+				 DESC_HDR_MODE1_MDEU_PAD |
+				 DESC_HDR_MODE1_MDEUB_SHA384_HMAC),
+
+	TALITOS_AEAD_ALG(
+		"authenc(hmac(sha384),cbc(des3_ede))",
+		"authenc-hmac-sha384-cbc-3des", aead_des3_setkey,
+		DES3_EDE_BLOCK_SIZE, SHA384_DIGEST_SIZE,
+		DESC_HDR_TYPE_IPSEC_ESP | DESC_HDR_SEL0_DEU |
+			DESC_HDR_MODE0_DEU_CBC | DESC_HDR_MODE0_DEU_3DES |
+			DESC_HDR_SEL1_MDEUB | DESC_HDR_MODE1_MDEU_INIT |
+			DESC_HDR_MODE1_MDEU_PAD |
+			DESC_HDR_MODE1_MDEUB_SHA384_HMAC),
+
+	/* sha512 auth */
+
+	TALITOS_AEAD_ALG("authenc(hmac(sha512),cbc(aes))",
+			 "authenc-hmac-sha512-cbc-aes", aead_setkey,
+			 AES_BLOCK_SIZE, SHA512_DIGEST_SIZE,
+			 DESC_HDR_TYPE_IPSEC_ESP | DESC_HDR_SEL0_AESU |
+				 DESC_HDR_MODE0_AESU_CBC | DESC_HDR_SEL1_MDEUB |
+				 DESC_HDR_MODE1_MDEU_INIT |
+				 DESC_HDR_MODE1_MDEU_PAD |
+				 DESC_HDR_MODE1_MDEUB_SHA512_HMAC),
+
+	TALITOS_AEAD_ALG(
+		"authenc(hmac(sha512),cbc(des3_ede))",
+		"authenc-hmac-sha512-cbc-3des", aead_des3_setkey,
+		DES3_EDE_BLOCK_SIZE, SHA512_DIGEST_SIZE,
+		DESC_HDR_TYPE_IPSEC_ESP | DESC_HDR_SEL0_DEU |
+			DESC_HDR_MODE0_DEU_CBC | DESC_HDR_MODE0_DEU_3DES |
+			DESC_HDR_SEL1_MDEUB | DESC_HDR_MODE1_MDEU_INIT |
+			DESC_HDR_MODE1_MDEU_PAD |
+			DESC_HDR_MODE1_MDEUB_SHA512_HMAC),
+
+	/* md5 auth */
+
+	TALITOS_AEAD_ALG("authenc(hmac(md5),cbc(aes))",
+			 "authenc-hmac-md5-cbc-aes", aead_setkey,
+			 AES_BLOCK_SIZE, MD5_DIGEST_SIZE,
+			 DESC_HDR_TYPE_IPSEC_ESP | DESC_HDR_SEL0_AESU |
+				 DESC_HDR_MODE0_AESU_CBC | DESC_HDR_SEL1_MDEUA |
+				 DESC_HDR_MODE1_MDEU_INIT |
+				 DESC_HDR_MODE1_MDEU_PAD |
+				 DESC_HDR_MODE1_MDEU_MD5_HMAC),
+
+	TALITOS_AEAD_ALG_HSNA(
+		"authenc(hmac(md5),cbc(aes))",
+		"authenc-hmac-md5-cbc-aes", aead_setkey, AES_BLOCK_SIZE,
+		MD5_DIGEST_SIZE,
+		DESC_HDR_TYPE_HMAC_SNOOP_NO_AFEU | DESC_HDR_SEL0_AESU |
+			DESC_HDR_MODE0_AESU_CBC | DESC_HDR_SEL1_MDEUA |
+			DESC_HDR_MODE1_MDEU_INIT | DESC_HDR_MODE1_MDEU_PAD |
+			DESC_HDR_MODE1_MDEU_MD5_HMAC),
+
+	TALITOS_AEAD_ALG(
+		"authenc(hmac(md5),cbc(des3_ede))",
+		"authenc-hmac-md5-cbc-3des", aead_des3_setkey,
+		DES3_EDE_BLOCK_SIZE, MD5_DIGEST_SIZE,
+		DESC_HDR_TYPE_IPSEC_ESP | DESC_HDR_SEL0_DEU |
+			DESC_HDR_MODE0_DEU_CBC | DESC_HDR_MODE0_DEU_3DES |
+			DESC_HDR_SEL1_MDEUA | DESC_HDR_MODE1_MDEU_INIT |
+			DESC_HDR_MODE1_MDEU_PAD | DESC_HDR_MODE1_MDEU_MD5_HMAC),
+
+	TALITOS_AEAD_ALG_HSNA(
+		"authenc(hmac(md5),cbc(des3_ede))",
+		"authenc-hmac-md5-cbc-3des", aead_des3_setkey,
+		DES3_EDE_BLOCK_SIZE, MD5_DIGEST_SIZE,
+		DESC_HDR_TYPE_HMAC_SNOOP_NO_AFEU | DESC_HDR_SEL0_DEU |
+			DESC_HDR_MODE0_DEU_CBC | DESC_HDR_MODE0_DEU_3DES |
+			DESC_HDR_SEL1_MDEUA | DESC_HDR_MODE1_MDEU_INIT |
+			DESC_HDR_MODE1_MDEU_PAD | DESC_HDR_MODE1_MDEU_MD5_HMAC),
 };
 
 int talitos_register_aead(struct device *dev)
@@ -958,11 +668,6 @@ int talitos_register_aead(struct device *dev)
 		if (has_ftr_sec1(priv))
 			alg->cra_alignmask = 3;
 
-		aead_alg->init = talitos_cra_init_aead;
-		aead_alg->exit = talitos_cra_exit_aead;
-		aead_alg->setkey = aead_alg->setkey ?: aead_setkey;
-		aead_alg->encrypt = aead_encrypt;
-		aead_alg->decrypt = aead_decrypt;
 		if (!(priv->features & TALITOS_FTR_SHA224_HWINIT) &&
 		    !strncmp(alg->cra_name, "authenc(hmac(sha224)", 20)) {
 			continue;

-- 
2.55.0

