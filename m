Received: from smtpout-03.galae.net (smtpout-03.galae.net [185.246.85.4])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58CE84C0403
	for <linux-crypto@vger.kernel.org>; Wed, 22 Jul 2026 08:54:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.246.85.4
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784710489; cv=none; b=jyg9S1SXFJk4ig+5nkjMPGT4f2dUWO0ObTw0X+A7qAR3g2+l9seA7XKOWYb7kkkmHjCv9BoveUwq0TR17tE7btXyMmkbqdars3+BSMMnb6E1FNBABpqSted+xlkK84w7HFiLDfbZXAbxqlYzK5kSEhmUD1H1JdBuK+pMM4IuujA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784710489; c=relaxed/simple;
	bh=qqLLj4KoJG6D8N0Jbdrrhwcva4ksz4o8Yfl1gYxeD7E=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=iMMsKjMYBVqXxxTujGnk4qB/4FuYL3OiuKgIijNUBjOssOvSruHzPlWse+swrmSB0L5LDXJJ8StWUcoqwzLqcE/YYEpbs9LU/J7UIsxXlbi5FZHyIpvVIMbRfmv/sL5z7R1kXpAD6ipJzWlvehXYWrKt5i2FpX0eOsJdY2h957A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bootlin.com; spf=pass smtp.mailfrom=bootlin.com; dkim=pass (2048-bit key) header.d=bootlin.com header.i=@bootlin.com header.b=JC2T9MFH; arc=none smtp.client-ip=185.246.85.4
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bootlin.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bootlin.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bootlin.com header.i=@bootlin.com header.b="JC2T9MFH"
Received: from smtpout-01.galae.net (smtpout-01.galae.net [212.83.139.233])
	by smtpout-03.galae.net (Postfix) with ESMTPS id 971E94E40EC3;
	Wed, 22 Jul 2026 08:54:44 +0000 (UTC)
Received: from mail.galae.net (mail.galae.net [212.83.136.155])
	by smtpout-01.galae.net (Postfix) with ESMTPS id 6D97660388;
	Wed, 22 Jul 2026 08:54:44 +0000 (UTC)
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id DA87011BD3B3C;
	Wed, 22 Jul 2026 10:54:42 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=dkim;
	t=1784710483; h=from:subject:date:message-id:to:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references;
	bh=ONJSgG4NQ96s41PxkyUrFO+vQWnshxBftk5AF9g6FW8=;
	b=JC2T9MFHmqK+2JnYUynFOyjX3v1Gjp2ZkUUNmO+mfqirUoPKus2d91Jcx+e/AHWWDXuAFe
	PS48oXTTaGrTioW1QwL14HSH1ZeEqb4EsxyTpqJ4cjChfGezLqLZOWb6gohzMEN0/QaAkE
	itqZkfoQoTkrWALvNIBDWHuUDGNBqwoMmLy8Ni44nbXyoturnTIRHjZDfRGbbXfukDMsng
	ZB//CjBwq5hNJMu2r3ClpZuHM/2EBOANKJwtXNFG3FunVUNiYwMWV65csVsKOJr/m1EGiv
	/yk8essv6X8t82AXkDgGsaaXONw84+FtIIvGdFY/i+SHR9+eQy4nGBgHwzQRdw==
From: Paul Louvel <paul.louvel@bootlin.com>
Date: Wed, 22 Jul 2026 10:53:58 +0200
Subject: [PATCH v4 14/19] crypto: talitos/aead - Use macro for algorithm
 definitions
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260722-7-1-rc1_talitos_cleanup-v4-14-81d1ed2ad911@bootlin.com>
References: <20260722-7-1-rc1_talitos_cleanup-v4-0-81d1ed2ad911@bootlin.com>
In-Reply-To: <20260722-7-1-rc1_talitos_cleanup-v4-0-81d1ed2ad911@bootlin.com>
To: Herbert Xu <herbert@gondor.apana.org.au>, 
 "David S. Miller" <davem@davemloft.net>
Cc: Thomas Petazzoni <thomas.petazzoni@bootlin.com>, 
 Herve Codina <herve.codina@bootlin.com>, 
 Christophe Leroy <chleroy@kernel.org>, linux-crypto@vger.kernel.org, 
 linux-kernel@vger.kernel.org, Paul Louvel <paul.louvel@bootlin.com>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1784710463; l=24908;
 i=paul.louvel@bootlin.com; s=20260313; h=from:subject:message-id;
 bh=qqLLj4KoJG6D8N0Jbdrrhwcva4ksz4o8Yfl1gYxeD7E=;
 b=080rt+5wQkjCI8RR0TU592amVKDlYhtEiOO6cxnu97o4TccwxmLAsAW6tSLJWMs/TVwuLGeei
 LEIxBuaiz0wD4JVvdzQkRZSfHuB7iV7xiRHSFj5I6y+I8mDB+JLPVm6
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
 drivers/crypto/talitos/talitos-aead.c | 679 +++++++++++-----------------------
 1 file changed, 218 insertions(+), 461 deletions(-)

diff --git a/drivers/crypto/talitos/talitos-aead.c b/drivers/crypto/talitos/talitos-aead.c
index 5537f2b6317f..cd1b8e6d371b 100644
--- a/drivers/crypto/talitos/talitos-aead.c
+++ b/drivers/crypto/talitos/talitos-aead.c
@@ -405,463 +405,225 @@ static void talitos_cra_exit_aead(struct crypto_aead *tfm)
 	talitos_cra_exit(crypto_aead_tfm(tfm));
 }
 
+#define TALITOS_AEAD_ALG_COMMON(name, name_prefix, set_key, block_size, \
+				max_auth_size, template, priority)      \
+	{ \
+		.type = CRYPTO_ALG_TYPE_AEAD, \
+		.alg.aead = { \
+			.base = { \
+				.cra_name = name, \
+				.cra_driver_name = name"-talitos"name_prefix, \
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
+#define TALITOS_AEAD_ALG(name, set_key, block_size, max_auth_size, template)  \
+	TALITOS_AEAD_ALG_COMMON(name, "", set_key, block_size, max_auth_size, \
+				template, TALITOS_CRA_PRIORITY)
+
+#define TALITOS_AEAD_ALG_HSNA(name, set_key, block_size, max_auth_size, \
+			      template)                                 \
+	TALITOS_AEAD_ALG_COMMON(name, "-hsna", set_key, block_size,     \
+				max_auth_size, template,                \
+				TALITOS_CRA_PRIORITY_AEAD_HSNA)
+
 static struct talitos_alg_template aead_driver_algs[] = {
-	{	.type = CRYPTO_ALG_TYPE_AEAD,
-		.alg.aead = {
-			.base = {
-				.cra_name = "authenc(hmac(sha1),cbc(aes))",
-				.cra_driver_name = "authenc-hmac-sha1-"
-						   "cbc-aes-talitos",
-				.cra_blocksize = AES_BLOCK_SIZE,
-				.cra_flags = CRYPTO_ALG_ASYNC |
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
-		.priority = TALITOS_CRA_PRIORITY_AEAD_HSNA,
-		.alg.aead = {
-			.base = {
-				.cra_name = "authenc(hmac(sha1),cbc(aes))",
-				.cra_driver_name = "authenc-hmac-sha1-"
-						   "cbc-aes-talitos-hsna",
-				.cra_blocksize = AES_BLOCK_SIZE,
-				.cra_flags = CRYPTO_ALG_ASYNC |
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
-				.cra_flags = CRYPTO_ALG_ASYNC |
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
-		.priority = TALITOS_CRA_PRIORITY_AEAD_HSNA,
-		.alg.aead = {
-			.base = {
-				.cra_name = "authenc(hmac(sha1),"
-					    "cbc(des3_ede))",
-				.cra_driver_name = "authenc-hmac-sha1-"
-						   "cbc-3des-talitos-hsna",
-				.cra_blocksize = DES3_EDE_BLOCK_SIZE,
-				.cra_flags = CRYPTO_ALG_ASYNC |
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
-				.cra_flags = CRYPTO_ALG_ASYNC |
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
-		.priority = TALITOS_CRA_PRIORITY_AEAD_HSNA,
-		.alg.aead = {
-			.base = {
-				.cra_name = "authenc(hmac(sha224),cbc(aes))",
-				.cra_driver_name = "authenc-hmac-sha224-"
-						   "cbc-aes-talitos-hsna",
-				.cra_blocksize = AES_BLOCK_SIZE,
-				.cra_flags = CRYPTO_ALG_ASYNC |
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
-				.cra_flags = CRYPTO_ALG_ASYNC |
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
-		.priority = TALITOS_CRA_PRIORITY_AEAD_HSNA,
-		.alg.aead = {
-			.base = {
-				.cra_name = "authenc(hmac(sha224),"
-					    "cbc(des3_ede))",
-				.cra_driver_name = "authenc-hmac-sha224-"
-						   "cbc-3des-talitos-hsna",
-				.cra_blocksize = DES3_EDE_BLOCK_SIZE,
-				.cra_flags = CRYPTO_ALG_ASYNC |
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
-				.cra_flags = CRYPTO_ALG_ASYNC |
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
-		.priority = TALITOS_CRA_PRIORITY_AEAD_HSNA,
-		.alg.aead = {
-			.base = {
-				.cra_name = "authenc(hmac(sha256),cbc(aes))",
-				.cra_driver_name = "authenc-hmac-sha256-"
-						   "cbc-aes-talitos-hsna",
-				.cra_blocksize = AES_BLOCK_SIZE,
-				.cra_flags = CRYPTO_ALG_ASYNC |
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
-				.cra_flags = CRYPTO_ALG_ASYNC |
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
-		.priority = TALITOS_CRA_PRIORITY_AEAD_HSNA,
-		.alg.aead = {
-			.base = {
-				.cra_name = "authenc(hmac(sha256),"
-					    "cbc(des3_ede))",
-				.cra_driver_name = "authenc-hmac-sha256-"
-						   "cbc-3des-talitos-hsna",
-				.cra_blocksize = DES3_EDE_BLOCK_SIZE,
-				.cra_flags = CRYPTO_ALG_ASYNC |
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
-				.cra_flags = CRYPTO_ALG_ASYNC |
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
-				.cra_flags = CRYPTO_ALG_ASYNC |
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
-				.cra_flags = CRYPTO_ALG_ASYNC |
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
-				.cra_flags = CRYPTO_ALG_ASYNC |
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
-				.cra_flags = CRYPTO_ALG_ASYNC |
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
-		.priority = TALITOS_CRA_PRIORITY_AEAD_HSNA,
-		.alg.aead = {
-			.base = {
-				.cra_name = "authenc(hmac(md5),cbc(aes))",
-				.cra_driver_name = "authenc-hmac-md5-"
-						   "cbc-aes-talitos-hsna",
-				.cra_blocksize = AES_BLOCK_SIZE,
-				.cra_flags = CRYPTO_ALG_ASYNC |
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
-				.cra_flags = CRYPTO_ALG_ASYNC |
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
-		.priority = TALITOS_CRA_PRIORITY_AEAD_HSNA,
-		.alg.aead = {
-			.base = {
-				.cra_name = "authenc(hmac(md5),cbc(des3_ede))",
-				.cra_driver_name = "authenc-hmac-md5-"
-						   "cbc-3des-talitos-hsna",
-				.cra_blocksize = DES3_EDE_BLOCK_SIZE,
-				.cra_flags = CRYPTO_ALG_ASYNC |
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
+	TALITOS_AEAD_ALG("authenc(hmac(sha1),cbc(aes))", aead_setkey,
+			 AES_BLOCK_SIZE, SHA1_DIGEST_SIZE,
+			 DESC_HDR_TYPE_IPSEC_ESP | DESC_HDR_SEL0_AESU |
+				 DESC_HDR_MODE0_AESU_CBC | DESC_HDR_SEL1_MDEUA |
+				 DESC_HDR_MODE1_MDEU_INIT |
+				 DESC_HDR_MODE1_MDEU_PAD |
+				 DESC_HDR_MODE1_MDEU_SHA1_HMAC),
+
+	TALITOS_AEAD_ALG_HSNA(
+		"authenc(hmac(sha1),cbc(aes))", aead_setkey, AES_BLOCK_SIZE,
+		SHA1_DIGEST_SIZE,
+		DESC_HDR_TYPE_HMAC_SNOOP_NO_AFEU | DESC_HDR_SEL0_AESU |
+			DESC_HDR_MODE0_AESU_CBC | DESC_HDR_SEL1_MDEUA |
+			DESC_HDR_MODE1_MDEU_INIT | DESC_HDR_MODE1_MDEU_PAD |
+			DESC_HDR_MODE1_MDEU_SHA1_HMAC),
+
+	TALITOS_AEAD_ALG("authenc(hmac(sha1),cbc(des3_ede))", aead_des3_setkey,
+			 DES3_EDE_BLOCK_SIZE, SHA1_DIGEST_SIZE,
+			 DESC_HDR_TYPE_IPSEC_ESP | DESC_HDR_SEL0_DEU |
+				 DESC_HDR_MODE0_DEU_CBC |
+				 DESC_HDR_MODE0_DEU_3DES | DESC_HDR_SEL1_MDEUA |
+				 DESC_HDR_MODE1_MDEU_INIT |
+				 DESC_HDR_MODE1_MDEU_PAD |
+				 DESC_HDR_MODE1_MDEU_SHA1_HMAC),
+
+	TALITOS_AEAD_ALG_HSNA(
+		"authenc(hmac(sha1),cbc(des3_ede))", aead_des3_setkey,
+		DES3_EDE_BLOCK_SIZE, SHA1_DIGEST_SIZE,
+		DESC_HDR_TYPE_HMAC_SNOOP_NO_AFEU | DESC_HDR_SEL0_DEU |
+			DESC_HDR_MODE0_DEU_CBC | DESC_HDR_MODE0_DEU_3DES |
+			DESC_HDR_SEL1_MDEUA | DESC_HDR_MODE1_MDEU_INIT |
+			DESC_HDR_MODE1_MDEU_PAD |
+			DESC_HDR_MODE1_MDEU_SHA1_HMAC),
+
+	/* sha224 auth */
+
+	TALITOS_AEAD_ALG("authenc(hmac(sha224),cbc(aes))", aead_setkey,
+			 AES_BLOCK_SIZE, SHA224_DIGEST_SIZE,
+			 DESC_HDR_TYPE_IPSEC_ESP | DESC_HDR_SEL0_AESU |
+				 DESC_HDR_MODE0_AESU_CBC | DESC_HDR_SEL1_MDEUA |
+				 DESC_HDR_MODE1_MDEU_INIT |
+				 DESC_HDR_MODE1_MDEU_PAD |
+				 DESC_HDR_MODE1_MDEU_SHA224_HMAC),
+
+	TALITOS_AEAD_ALG_HSNA(
+		"authenc(hmac(sha224),cbc(aes))", aead_setkey, AES_BLOCK_SIZE,
+		SHA224_DIGEST_SIZE,
+		DESC_HDR_TYPE_HMAC_SNOOP_NO_AFEU | DESC_HDR_SEL0_AESU |
+			DESC_HDR_MODE0_AESU_CBC | DESC_HDR_SEL1_MDEUA |
+			DESC_HDR_MODE1_MDEU_INIT | DESC_HDR_MODE1_MDEU_PAD |
+			DESC_HDR_MODE1_MDEU_SHA224_HMAC),
+
+	TALITOS_AEAD_ALG(
+		"authenc(hmac(sha224),cbc(des3_ede))", aead_des3_setkey,
+		DES3_EDE_BLOCK_SIZE, SHA224_DIGEST_SIZE,
+		DESC_HDR_TYPE_IPSEC_ESP | DESC_HDR_SEL0_DEU |
+			DESC_HDR_MODE0_DEU_CBC | DESC_HDR_MODE0_DEU_3DES |
+			DESC_HDR_SEL1_MDEUA | DESC_HDR_MODE1_MDEU_INIT |
+			DESC_HDR_MODE1_MDEU_PAD |
+			DESC_HDR_MODE1_MDEU_SHA224_HMAC),
+
+	TALITOS_AEAD_ALG_HSNA(
+		"authenc(hmac(sha224),cbc(des3_ede))", aead_des3_setkey,
+		DES3_EDE_BLOCK_SIZE, SHA224_DIGEST_SIZE,
+		DESC_HDR_TYPE_HMAC_SNOOP_NO_AFEU | DESC_HDR_SEL0_DEU |
+			DESC_HDR_MODE0_DEU_CBC | DESC_HDR_MODE0_DEU_3DES |
+			DESC_HDR_SEL1_MDEUA | DESC_HDR_MODE1_MDEU_INIT |
+			DESC_HDR_MODE1_MDEU_PAD |
+			DESC_HDR_MODE1_MDEU_SHA224_HMAC),
+
+	/* sha256 auth */
+
+	TALITOS_AEAD_ALG("authenc(hmac(sha256),cbc(aes))", aead_setkey,
+			 AES_BLOCK_SIZE, SHA256_DIGEST_SIZE,
+			 DESC_HDR_TYPE_IPSEC_ESP | DESC_HDR_SEL0_AESU |
+				 DESC_HDR_MODE0_AESU_CBC | DESC_HDR_SEL1_MDEUA |
+				 DESC_HDR_MODE1_MDEU_INIT |
+				 DESC_HDR_MODE1_MDEU_PAD |
+				 DESC_HDR_MODE1_MDEU_SHA256_HMAC),
+
+	TALITOS_AEAD_ALG_HSNA(
+		"authenc(hmac(sha256),cbc(aes))", aead_setkey, AES_BLOCK_SIZE,
+		SHA256_DIGEST_SIZE,
+		DESC_HDR_TYPE_HMAC_SNOOP_NO_AFEU | DESC_HDR_SEL0_AESU |
+			DESC_HDR_MODE0_AESU_CBC | DESC_HDR_SEL1_MDEUA |
+			DESC_HDR_MODE1_MDEU_INIT | DESC_HDR_MODE1_MDEU_PAD |
+			DESC_HDR_MODE1_MDEU_SHA256_HMAC),
+
+	TALITOS_AEAD_ALG(
+		"authenc(hmac(sha256),cbc(des3_ede))", aead_des3_setkey,
+		DES3_EDE_BLOCK_SIZE, SHA256_DIGEST_SIZE,
+		DESC_HDR_TYPE_IPSEC_ESP | DESC_HDR_SEL0_DEU |
+			DESC_HDR_MODE0_DEU_CBC | DESC_HDR_MODE0_DEU_3DES |
+			DESC_HDR_SEL1_MDEUA | DESC_HDR_MODE1_MDEU_INIT |
+			DESC_HDR_MODE1_MDEU_PAD |
+			DESC_HDR_MODE1_MDEU_SHA256_HMAC),
+
+	TALITOS_AEAD_ALG_HSNA(
+		"authenc(hmac(sha256),cbc(des3_ede))", aead_des3_setkey,
+		DES3_EDE_BLOCK_SIZE, SHA256_DIGEST_SIZE,
+		DESC_HDR_TYPE_HMAC_SNOOP_NO_AFEU | DESC_HDR_SEL0_DEU |
+			DESC_HDR_MODE0_DEU_CBC | DESC_HDR_MODE0_DEU_3DES |
+			DESC_HDR_SEL1_MDEUA | DESC_HDR_MODE1_MDEU_INIT |
+			DESC_HDR_MODE1_MDEU_PAD |
+			DESC_HDR_MODE1_MDEU_SHA256_HMAC),
+
+	/* sha384 auth */
+
+	TALITOS_AEAD_ALG("authenc(hmac(sha384),cbc(aes))", aead_setkey,
+			 AES_BLOCK_SIZE, SHA384_DIGEST_SIZE,
+			 DESC_HDR_TYPE_IPSEC_ESP | DESC_HDR_SEL0_AESU |
+				 DESC_HDR_MODE0_AESU_CBC | DESC_HDR_SEL1_MDEUB |
+				 DESC_HDR_MODE1_MDEU_INIT |
+				 DESC_HDR_MODE1_MDEU_PAD |
+				 DESC_HDR_MODE1_MDEUB_SHA384_HMAC),
+
+	TALITOS_AEAD_ALG(
+		"authenc(hmac(sha384),cbc(des3_ede))", aead_des3_setkey,
+		DES3_EDE_BLOCK_SIZE, SHA384_DIGEST_SIZE,
+		DESC_HDR_TYPE_IPSEC_ESP | DESC_HDR_SEL0_DEU |
+			DESC_HDR_MODE0_DEU_CBC | DESC_HDR_MODE0_DEU_3DES |
+			DESC_HDR_SEL1_MDEUB | DESC_HDR_MODE1_MDEU_INIT |
+			DESC_HDR_MODE1_MDEU_PAD |
+			DESC_HDR_MODE1_MDEUB_SHA384_HMAC),
+
+	/* sha512 auth */
+
+	TALITOS_AEAD_ALG("authenc(hmac(sha512),cbc(aes))", aead_setkey,
+			 AES_BLOCK_SIZE, SHA512_DIGEST_SIZE,
+			 DESC_HDR_TYPE_IPSEC_ESP | DESC_HDR_SEL0_AESU |
+				 DESC_HDR_MODE0_AESU_CBC | DESC_HDR_SEL1_MDEUB |
+				 DESC_HDR_MODE1_MDEU_INIT |
+				 DESC_HDR_MODE1_MDEU_PAD |
+				 DESC_HDR_MODE1_MDEUB_SHA512_HMAC),
+
+	TALITOS_AEAD_ALG(
+		"authenc(hmac(sha512),cbc(des3_ede))", aead_des3_setkey,
+		DES3_EDE_BLOCK_SIZE, SHA512_DIGEST_SIZE,
+		DESC_HDR_TYPE_IPSEC_ESP | DESC_HDR_SEL0_DEU |
+			DESC_HDR_MODE0_DEU_CBC | DESC_HDR_MODE0_DEU_3DES |
+			DESC_HDR_SEL1_MDEUB | DESC_HDR_MODE1_MDEU_INIT |
+			DESC_HDR_MODE1_MDEU_PAD |
+			DESC_HDR_MODE1_MDEUB_SHA512_HMAC),
+
+	/* md5 auth */
+
+	TALITOS_AEAD_ALG("authenc(hmac(md5),cbc(aes))", aead_setkey,
+			 AES_BLOCK_SIZE, MD5_DIGEST_SIZE,
+			 DESC_HDR_TYPE_IPSEC_ESP | DESC_HDR_SEL0_AESU |
+				 DESC_HDR_MODE0_AESU_CBC | DESC_HDR_SEL1_MDEUA |
+				 DESC_HDR_MODE1_MDEU_INIT |
+				 DESC_HDR_MODE1_MDEU_PAD |
+				 DESC_HDR_MODE1_MDEU_MD5_HMAC),
+
+	TALITOS_AEAD_ALG_HSNA(
+		"authenc(hmac(md5),cbc(aes))", aead_setkey, AES_BLOCK_SIZE,
+		MD5_DIGEST_SIZE,
+		DESC_HDR_TYPE_HMAC_SNOOP_NO_AFEU | DESC_HDR_SEL0_AESU |
+			DESC_HDR_MODE0_AESU_CBC | DESC_HDR_SEL1_MDEUA |
+			DESC_HDR_MODE1_MDEU_INIT | DESC_HDR_MODE1_MDEU_PAD |
+			DESC_HDR_MODE1_MDEU_MD5_HMAC),
+
+	TALITOS_AEAD_ALG(
+		"authenc(hmac(md5),cbc(des3_ede))", aead_des3_setkey,
+		DES3_EDE_BLOCK_SIZE, MD5_DIGEST_SIZE,
+		DESC_HDR_TYPE_IPSEC_ESP | DESC_HDR_SEL0_DEU |
+			DESC_HDR_MODE0_DEU_CBC | DESC_HDR_MODE0_DEU_3DES |
+			DESC_HDR_SEL1_MDEUA | DESC_HDR_MODE1_MDEU_INIT |
+			DESC_HDR_MODE1_MDEU_PAD | DESC_HDR_MODE1_MDEU_MD5_HMAC),
+
+	TALITOS_AEAD_ALG_HSNA(
+		"authenc(hmac(md5),cbc(des3_ede))", aead_des3_setkey,
+		DES3_EDE_BLOCK_SIZE, MD5_DIGEST_SIZE,
+		DESC_HDR_TYPE_HMAC_SNOOP_NO_AFEU | DESC_HDR_SEL0_DEU |
+			DESC_HDR_MODE0_DEU_CBC | DESC_HDR_MODE0_DEU_3DES |
+			DESC_HDR_SEL1_MDEUA | DESC_HDR_MODE1_MDEU_INIT |
+			DESC_HDR_MODE1_MDEU_PAD | DESC_HDR_MODE1_MDEU_MD5_HMAC),
 };
 
 int talitos_register_aead(struct device *dev)
@@ -883,11 +645,6 @@ int talitos_register_aead(struct device *dev)
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

