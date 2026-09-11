Received: from smtpout-03.galae.net (smtpout-03.galae.net [185.246.85.4])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB08637475C
	for <linux-crypto@vger.kernel.org>; Fri, 11 Sep 2026 14:47:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.246.85.4
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789138057; cv=none; b=I/paSBGur2RYCX2o/kOu1StTgJeHnPofiNQY22VlVyRdZcW7IJZVJtn1pLJfoSEFbZyUHcsNMvbjWmQfJwBeQs+F5GFvodCBfGbigWJw21xQ8trniOMxymxdkApN3pOJ++hlWAntjds4WzhkOQNQ7ZuQr7skQhNdsKa9rkqRuZg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789138057; c=relaxed/simple;
	bh=PZ6wssFg/kk7/ebPKx6ZwoL6iQ38/wrqTcXyNMXgE9o=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=ZD4fFx7wk6j+A7bRLoOExKMbCM4D8HZIH0xzdZtm0smPnwwLokku9jPx2N2jExpcGDgMg1wmZHDT7PALusJkmPKPoveFxNYe+NL+HJ+hsLfUOsnlUHsijHXGxRsbjY4uHPBP7ze/zj/ycxH3CVJ7koCzY1rKDn1FlQ5o96oHRjs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bootlin.com; spf=pass smtp.mailfrom=bootlin.com; dkim=pass (2048-bit key) header.d=bootlin.com header.i=@bootlin.com header.b=pOgQjS8A; arc=none smtp.client-ip=185.246.85.4
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bootlin.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bootlin.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bootlin.com header.i=@bootlin.com header.b="pOgQjS8A"
Received: from smtpout-01.galae.net (smtpout-01.galae.net [212.83.139.233])
	by smtpout-03.galae.net (Postfix) with ESMTPS id 81BAF4E401EF
	for <linux-crypto@vger.kernel.org>; Fri, 11 Sep 2026 14:47:33 +0000 (UTC)
Received: from mail.galae.net (mail.galae.net [212.83.136.155])
	by smtpout-01.galae.net (Postfix) with ESMTPS id 5724F601DE;
	Fri, 11 Sep 2026 14:47:33 +0000 (UTC)
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id C351B11C7AFBD;
	Fri, 11 Sep 2026 16:47:31 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=dkim;
	t=1789138052; h=from:subject:date:message-id:to:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references;
	bh=Ah+jyGeqYgfsbusugUY/B12VTUYA2L7ZAotxb8cKmZE=;
	b=pOgQjS8AMoZBXVEBOeNRKp9YXLRALhc6tWYXH0w0bu+XCRNyat2kZ9xoaaIPuh0dtAN2g0
	9sNbMToSsYOSqH4YthXz8stdKIn7C7uH+sWd4BBQzgeMik8H6NhhkYo3bp3opHHZWUzD2B
	WQE8cXk7iR2A80gWjyMRK0owrHu/zXJHA6Y7NXtW4KpX84thFAUZffeSBExE0qB28CpMNK
	fdUwnrA5DecpFmn+K/nqDB9U82Il/i5xgPhY8f+WBo8MAPARCvUJL354uunCT+To/YPFS9
	9Ex6vbTqyEn/dmqQ1wbUgbEILBfMTdY2biRQF3VETM3wAwkPdXSIp18gkQDWOQ==
From: Paul Louvel <paul.louvel@bootlin.com>
Date: Fri, 11 Sep 2026 16:46:30 +0200
Subject: [PATCH v6 13/19] crypto: talitos/hash - Use macro for algorithm
 definitions
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260911-7-3-rc2_talitos_cleanup-v6-13-4215f347c97a@bootlin.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1789138028; l=15357;
 i=paul.louvel@bootlin.com; s=20260313; h=from:subject:message-id;
 bh=PZ6wssFg/kk7/ebPKx6ZwoL6iQ38/wrqTcXyNMXgE9o=;
 b=NhngQom2G4RFUY1duvXjOfa7yXTqhmpcGRABTz0UBKAQhitYva1EVBa8+WL7gynkn5aagpFRE
 WAtfAerl22KCCzObT6SO/PXwfn74X6gwmSrDEVu+FDKmJUP5UZSNbRq
X-Developer-Key: i=paul.louvel@bootlin.com; a=ed25519;
 pk=eLW50NT18UAvUT5cAcYf88zNbBCZDLFXuptpyLVhVIU=
X-Last-TLS-Session-Version: TLSv1.3

Replace the repetitive struct initializer entries with preprocessor
macros.

The HMAC setkey assignment, previously done by comparing the algorithm
name at runtime, is now handled by passing ahash_setkey directly through
the TALITOS_HMAC_HASH_ALG macro variant.

Reviewed-by: Christophe Leroy (CS GROUP) <chleroy@kernel.org>
Signed-off-by: Paul Louvel <paul.louvel@bootlin.com>
---
 drivers/crypto/talitos/talitos-hash.c | 380 ++++++++++------------------------
 1 file changed, 104 insertions(+), 276 deletions(-)

diff --git a/drivers/crypto/talitos/talitos-hash.c b/drivers/crypto/talitos/talitos-hash.c
index 3cfa739dab64..455c751b9073 100644
--- a/drivers/crypto/talitos/talitos-hash.c
+++ b/drivers/crypto/talitos/talitos-hash.c
@@ -561,271 +561,111 @@ static void talitos_cra_exit_ahash(struct crypto_ahash *tfm)
 	talitos_cra_exit(crypto_ahash_tfm(tfm));
 }
 
-static const struct talitos_alg_template hash_driver_algs[] = {
-	{	.type = CRYPTO_ALG_TYPE_AHASH,
-		.alg.hash = {
-			.halg.digestsize = MD5_DIGEST_SIZE,
-			.halg.statesize = sizeof(struct talitos_export_state),
-			.halg.base = {
-				.cra_name = "md5",
-				.cra_driver_name = "md5-talitos",
-				.cra_blocksize = MD5_HMAC_BLOCK_SIZE,
-				.cra_reqsize = sizeof(struct talitos_ahash_req_ctx),
-				.cra_module = THIS_MODULE,
-				.cra_priority = TALITOS_CRA_PRIORITY,
-				.cra_ctxsize = sizeof(struct talitos_ctx),
-				.cra_flags = CRYPTO_ALG_KERN_DRIVER_ONLY |
-					     CRYPTO_ALG_ASYNC |
-					     CRYPTO_ALG_ALLOCATES_MEMORY |
-					     CRYPTO_AHASH_ALG_BLOCK_ONLY,
-			}
-		},
-		.desc_hdr_template = DESC_HDR_TYPE_COMMON_NONSNOOP_NO_AFEU |
-				     DESC_HDR_SEL0_MDEUA |
-				     DESC_HDR_MODE0_MDEU_MD5,
-	},
-	{	.type = CRYPTO_ALG_TYPE_AHASH,
-		.alg.hash = {
-			.halg.digestsize = SHA1_DIGEST_SIZE,
-			.halg.statesize = sizeof(struct talitos_export_state),
-			.halg.base = {
-				.cra_name = "sha1",
-				.cra_driver_name = "sha1-talitos",
-				.cra_blocksize = SHA1_BLOCK_SIZE,
-				.cra_reqsize = sizeof(struct talitos_ahash_req_ctx),
-				.cra_module = THIS_MODULE,
-				.cra_priority = TALITOS_CRA_PRIORITY,
-				.cra_ctxsize = sizeof(struct talitos_ctx),
-				.cra_flags = CRYPTO_ALG_KERN_DRIVER_ONLY |
-					     CRYPTO_ALG_ASYNC |
-					     CRYPTO_ALG_ALLOCATES_MEMORY |
-					     CRYPTO_AHASH_ALG_BLOCK_ONLY,
-			}
-		},
-		.desc_hdr_template = DESC_HDR_TYPE_COMMON_NONSNOOP_NO_AFEU |
-				     DESC_HDR_SEL0_MDEUA |
-				     DESC_HDR_MODE0_MDEU_SHA1,
-	},
-	{	.type = CRYPTO_ALG_TYPE_AHASH,
-		.alg.hash = {
-			.halg.digestsize = SHA224_DIGEST_SIZE,
-			.halg.statesize = sizeof(struct talitos_export_state),
-			.halg.base = {
-				.cra_name = "sha224",
-				.cra_driver_name = "sha224-talitos",
-				.cra_blocksize = SHA224_BLOCK_SIZE,
-				.cra_reqsize = sizeof(struct talitos_ahash_req_ctx),
-				.cra_module = THIS_MODULE,
-				.cra_priority = TALITOS_CRA_PRIORITY,
-				.cra_ctxsize = sizeof(struct talitos_ctx),
-				.cra_flags = CRYPTO_ALG_KERN_DRIVER_ONLY |
-					     CRYPTO_ALG_ASYNC |
-					     CRYPTO_ALG_ALLOCATES_MEMORY |
-					     CRYPTO_AHASH_ALG_BLOCK_ONLY,
-			}
-		},
-		.desc_hdr_template = DESC_HDR_TYPE_COMMON_NONSNOOP_NO_AFEU |
-				     DESC_HDR_SEL0_MDEUA |
-				     DESC_HDR_MODE0_MDEU_SHA224,
-	},
-	{	.type = CRYPTO_ALG_TYPE_AHASH,
-		.alg.hash = {
-			.halg.digestsize = SHA256_DIGEST_SIZE,
-			.halg.statesize = sizeof(struct talitos_export_state),
-			.halg.base = {
-				.cra_name = "sha256",
-				.cra_driver_name = "sha256-talitos",
-				.cra_blocksize = SHA256_BLOCK_SIZE,
-				.cra_reqsize = sizeof(struct talitos_ahash_req_ctx),
-				.cra_module = THIS_MODULE,
-				.cra_priority = TALITOS_CRA_PRIORITY,
-				.cra_ctxsize = sizeof(struct talitos_ctx),
-				.cra_flags = CRYPTO_ALG_KERN_DRIVER_ONLY |
-					     CRYPTO_ALG_ASYNC |
-					     CRYPTO_ALG_ALLOCATES_MEMORY |
-					     CRYPTO_AHASH_ALG_BLOCK_ONLY,
-			}
-		},
-		.desc_hdr_template = DESC_HDR_TYPE_COMMON_NONSNOOP_NO_AFEU |
-				     DESC_HDR_SEL0_MDEUA |
-				     DESC_HDR_MODE0_MDEU_SHA256,
-	},
-	{	.type = CRYPTO_ALG_TYPE_AHASH,
-		.alg.hash = {
-			.halg.digestsize = SHA384_DIGEST_SIZE,
-			.halg.statesize = sizeof(struct talitos_export_state),
-			.halg.base = {
-				.cra_name = "sha384",
-				.cra_driver_name = "sha384-talitos",
-				.cra_blocksize = SHA384_BLOCK_SIZE,
-				.cra_reqsize = sizeof(struct talitos_ahash_req_ctx),
-				.cra_module = THIS_MODULE,
-				.cra_priority = TALITOS_CRA_PRIORITY,
-				.cra_ctxsize = sizeof(struct talitos_ctx),
-				.cra_flags = CRYPTO_ALG_KERN_DRIVER_ONLY |
-					     CRYPTO_ALG_ASYNC |
-					     CRYPTO_ALG_ALLOCATES_MEMORY |
-					     CRYPTO_AHASH_ALG_BLOCK_ONLY,
-			}
-		},
-		.desc_hdr_template = DESC_HDR_TYPE_COMMON_NONSNOOP_NO_AFEU |
-				     DESC_HDR_SEL0_MDEUB |
-				     DESC_HDR_MODE0_MDEUB_SHA384,
-	},
-	{	.type = CRYPTO_ALG_TYPE_AHASH,
-		.alg.hash = {
-			.halg.digestsize = SHA512_DIGEST_SIZE,
-			.halg.statesize = sizeof(struct talitos_export_state),
-			.halg.base = {
-				.cra_name = "sha512",
-				.cra_driver_name = "sha512-talitos",
-				.cra_blocksize = SHA512_BLOCK_SIZE,
-				.cra_reqsize = sizeof(struct talitos_ahash_req_ctx),
-				.cra_module = THIS_MODULE,
-				.cra_priority = TALITOS_CRA_PRIORITY,
-				.cra_ctxsize = sizeof(struct talitos_ctx),
-				.cra_flags = CRYPTO_ALG_KERN_DRIVER_ONLY |
-					     CRYPTO_ALG_ASYNC |
-					     CRYPTO_ALG_ALLOCATES_MEMORY |
-					     CRYPTO_AHASH_ALG_BLOCK_ONLY,
-			}
-		},
-		.desc_hdr_template = DESC_HDR_TYPE_COMMON_NONSNOOP_NO_AFEU |
-				     DESC_HDR_SEL0_MDEUB |
-				     DESC_HDR_MODE0_MDEUB_SHA512,
-	},
-	{	.type = CRYPTO_ALG_TYPE_AHASH,
-		.alg.hash = {
-			.halg.digestsize = MD5_DIGEST_SIZE,
-			.halg.statesize = sizeof(struct talitos_export_state),
-			.halg.base = {
-				.cra_name = "hmac(md5)",
-				.cra_driver_name = "hmac-md5-talitos",
-				.cra_blocksize = MD5_HMAC_BLOCK_SIZE,
-				.cra_reqsize = sizeof(struct talitos_ahash_req_ctx),
-				.cra_module = THIS_MODULE,
-				.cra_priority = TALITOS_CRA_PRIORITY,
-				.cra_ctxsize = sizeof(struct talitos_ctx),
-				.cra_flags = CRYPTO_ALG_KERN_DRIVER_ONLY |
-					     CRYPTO_ALG_ASYNC |
-					     CRYPTO_ALG_ALLOCATES_MEMORY |
-					     CRYPTO_AHASH_ALG_BLOCK_ONLY,
-			}
-		},
-		.desc_hdr_template = DESC_HDR_TYPE_COMMON_NONSNOOP_NO_AFEU |
-				     DESC_HDR_SEL0_MDEUA |
-				     DESC_HDR_MODE0_MDEU_MD5,
-	},
-	{	.type = CRYPTO_ALG_TYPE_AHASH,
-		.alg.hash = {
-			.halg.digestsize = SHA1_DIGEST_SIZE,
-			.halg.statesize = sizeof(struct talitos_export_state),
-			.halg.base = {
-				.cra_name = "hmac(sha1)",
-				.cra_driver_name = "hmac-sha1-talitos",
-				.cra_blocksize = SHA1_BLOCK_SIZE,
-				.cra_reqsize = sizeof(struct talitos_ahash_req_ctx),
-				.cra_module = THIS_MODULE,
-				.cra_priority = TALITOS_CRA_PRIORITY,
-				.cra_ctxsize = sizeof(struct talitos_ctx),
-				.cra_flags = CRYPTO_ALG_KERN_DRIVER_ONLY |
-					     CRYPTO_ALG_ASYNC |
-					     CRYPTO_ALG_ALLOCATES_MEMORY |
-					     CRYPTO_AHASH_ALG_BLOCK_ONLY,
-			}
-		},
-		.desc_hdr_template = DESC_HDR_TYPE_COMMON_NONSNOOP_NO_AFEU |
-				     DESC_HDR_SEL0_MDEUA |
-				     DESC_HDR_MODE0_MDEU_SHA1,
-	},
-	{	.type = CRYPTO_ALG_TYPE_AHASH,
-		.alg.hash = {
-			.halg.digestsize = SHA224_DIGEST_SIZE,
-			.halg.statesize = sizeof(struct talitos_export_state),
-			.halg.base = {
-				.cra_name = "hmac(sha224)",
-				.cra_driver_name = "hmac-sha224-talitos",
-				.cra_blocksize = SHA224_BLOCK_SIZE,
-				.cra_reqsize = sizeof(struct talitos_ahash_req_ctx),
-				.cra_module = THIS_MODULE,
-				.cra_priority = TALITOS_CRA_PRIORITY,
-				.cra_ctxsize = sizeof(struct talitos_ctx),
-				.cra_flags = CRYPTO_ALG_KERN_DRIVER_ONLY |
-					     CRYPTO_ALG_ASYNC |
-					     CRYPTO_ALG_ALLOCATES_MEMORY |
-					     CRYPTO_AHASH_ALG_BLOCK_ONLY,
-			}
-		},
-		.desc_hdr_template = DESC_HDR_TYPE_COMMON_NONSNOOP_NO_AFEU |
-				     DESC_HDR_SEL0_MDEUA |
-				     DESC_HDR_MODE0_MDEU_SHA224,
-	},
-	{	.type = CRYPTO_ALG_TYPE_AHASH,
-		.alg.hash = {
-			.halg.digestsize = SHA256_DIGEST_SIZE,
-			.halg.statesize = sizeof(struct talitos_export_state),
-			.halg.base = {
-				.cra_name = "hmac(sha256)",
-				.cra_driver_name = "hmac-sha256-talitos",
-				.cra_blocksize = SHA256_BLOCK_SIZE,
-				.cra_reqsize = sizeof(struct talitos_ahash_req_ctx),
-				.cra_module = THIS_MODULE,
-				.cra_priority = TALITOS_CRA_PRIORITY,
-				.cra_ctxsize = sizeof(struct talitos_ctx),
-				.cra_flags = CRYPTO_ALG_KERN_DRIVER_ONLY |
-					     CRYPTO_ALG_ASYNC |
-					     CRYPTO_ALG_ALLOCATES_MEMORY |
-					     CRYPTO_AHASH_ALG_BLOCK_ONLY,
-			}
-		},
-		.desc_hdr_template = DESC_HDR_TYPE_COMMON_NONSNOOP_NO_AFEU |
-				     DESC_HDR_SEL0_MDEUA |
-				     DESC_HDR_MODE0_MDEU_SHA256,
-	},
-	{	.type = CRYPTO_ALG_TYPE_AHASH,
-		.alg.hash = {
-			.halg.digestsize = SHA384_DIGEST_SIZE,
-			.halg.statesize = sizeof(struct talitos_export_state),
-			.halg.base = {
-				.cra_name = "hmac(sha384)",
-				.cra_driver_name = "hmac-sha384-talitos",
-				.cra_blocksize = SHA384_BLOCK_SIZE,
-				.cra_reqsize = sizeof(struct talitos_ahash_req_ctx),
-				.cra_module = THIS_MODULE,
-				.cra_priority = TALITOS_CRA_PRIORITY,
-				.cra_ctxsize = sizeof(struct talitos_ctx),
-				.cra_flags = CRYPTO_ALG_KERN_DRIVER_ONLY |
-					     CRYPTO_ALG_ASYNC |
-					     CRYPTO_ALG_ALLOCATES_MEMORY |
-					     CRYPTO_AHASH_ALG_BLOCK_ONLY,
-			}
-		},
-		.desc_hdr_template = DESC_HDR_TYPE_COMMON_NONSNOOP_NO_AFEU |
-				     DESC_HDR_SEL0_MDEUB |
-				     DESC_HDR_MODE0_MDEUB_SHA384,
-	},
-	{	.type = CRYPTO_ALG_TYPE_AHASH,
-		.alg.hash = {
-			.halg.digestsize = SHA512_DIGEST_SIZE,
-			.halg.statesize = sizeof(struct talitos_export_state),
-			.halg.base = {
-				.cra_name = "hmac(sha512)",
-				.cra_driver_name = "hmac-sha512-talitos",
-				.cra_blocksize = SHA512_BLOCK_SIZE,
-				.cra_reqsize = sizeof(struct talitos_ahash_req_ctx),
-				.cra_module = THIS_MODULE,
-				.cra_priority = TALITOS_CRA_PRIORITY,
-				.cra_ctxsize = sizeof(struct talitos_ctx),
-				.cra_flags = CRYPTO_ALG_KERN_DRIVER_ONLY |
-					     CRYPTO_ALG_ASYNC |
-					     CRYPTO_ALG_ALLOCATES_MEMORY |
-					     CRYPTO_AHASH_ALG_BLOCK_ONLY,
-			}
-		},
-		.desc_hdr_template = DESC_HDR_TYPE_COMMON_NONSNOOP_NO_AFEU |
-				     DESC_HDR_SEL0_MDEUB |
-				     DESC_HDR_MODE0_MDEUB_SHA512,
+#define TALITOS_HASH_ALG_COMMON(name, driver_name, digest_size, block_size, template, \
+				set_key)                                 \
+	{ \
+		.type = CRYPTO_ALG_TYPE_AHASH, \
+		.alg.hash = { \
+			.init_tfm = talitos_cra_init_ahash, \
+			.exit_tfm = talitos_cra_exit_ahash, \
+			.init = ahash_init, \
+			.update = ahash_update, \
+			.final = ahash_final, \
+			.finup = ahash_finup, \
+			.digest = ahash_digest, \
+			.setkey = set_key, \
+			.import = ahash_import, \
+			.export = ahash_export, \
+			.halg.digestsize = digest_size, \
+			.halg.statesize = sizeof(struct talitos_export_state), \
+			.halg.base = { \
+				.cra_name = name, \
+				.cra_driver_name = driver_name"-talitos", \
+				.cra_blocksize = block_size, \
+				.cra_reqsize = sizeof(struct talitos_ahash_req_ctx), \
+				.cra_flags = CRYPTO_ALG_ASYNC | \
+					     CRYPTO_ALG_ALLOCATES_MEMORY | \
+					     CRYPTO_ALG_KERN_DRIVER_ONLY | \
+					     CRYPTO_AHASH_ALG_BLOCK_ONLY, \
+				.cra_priority = TALITOS_CRA_PRIORITY, \
+				.cra_ctxsize = sizeof(struct talitos_ctx), \
+				.cra_module = THIS_MODULE, \
+			}, \
+		}, \
+		.desc_hdr_template = template, \
 	}
+
+#define TALITOS_HASH_ALG(name, digest_size, block_size, desc_hdr_template) \
+	TALITOS_HASH_ALG_COMMON(name, name, digest_size, block_size,       \
+				desc_hdr_template, NULL)
+
+#define TALITOS_HMAC_HASH_ALG(name, digest_size, block_size,               \
+			      desc_hdr_template)                           \
+	TALITOS_HASH_ALG_COMMON("hmac(" name ")", "hmac-" name,           \
+				digest_size, block_size,                   \
+				desc_hdr_template, ahash_setkey)
+
+static const struct talitos_alg_template hash_driver_algs[] = {
+	TALITOS_HASH_ALG("md5", MD5_DIGEST_SIZE, MD5_HMAC_BLOCK_SIZE,
+			 DESC_HDR_TYPE_COMMON_NONSNOOP_NO_AFEU |
+				 DESC_HDR_SEL0_MDEUA | DESC_HDR_MODE0_MDEU_MD5),
+
+	TALITOS_HASH_ALG("sha1", SHA1_DIGEST_SIZE, SHA1_BLOCK_SIZE,
+			 DESC_HDR_TYPE_COMMON_NONSNOOP_NO_AFEU |
+				 DESC_HDR_SEL0_MDEUA |
+				 DESC_HDR_MODE0_MDEU_SHA1),
+
+	TALITOS_HASH_ALG("sha224", SHA224_DIGEST_SIZE, SHA224_BLOCK_SIZE,
+			 DESC_HDR_TYPE_COMMON_NONSNOOP_NO_AFEU |
+				 DESC_HDR_SEL0_MDEUA |
+				 DESC_HDR_MODE0_MDEU_SHA224),
+
+	TALITOS_HASH_ALG("sha256", SHA256_DIGEST_SIZE, SHA256_BLOCK_SIZE,
+			 DESC_HDR_TYPE_COMMON_NONSNOOP_NO_AFEU |
+				 DESC_HDR_SEL0_MDEUA |
+				 DESC_HDR_MODE0_MDEU_SHA256),
+
+	TALITOS_HASH_ALG("sha384", SHA384_DIGEST_SIZE, SHA384_BLOCK_SIZE,
+			 DESC_HDR_TYPE_COMMON_NONSNOOP_NO_AFEU |
+				 DESC_HDR_SEL0_MDEUB |
+				 DESC_HDR_MODE0_MDEUB_SHA384),
+
+	TALITOS_HASH_ALG("sha512", SHA512_DIGEST_SIZE, SHA512_BLOCK_SIZE,
+			 DESC_HDR_TYPE_COMMON_NONSNOOP_NO_AFEU |
+				 DESC_HDR_SEL0_MDEUB |
+				 DESC_HDR_MODE0_MDEUB_SHA512),
+
+	/* HMAC */
+
+	TALITOS_HMAC_HASH_ALG("md5", MD5_DIGEST_SIZE, MD5_HMAC_BLOCK_SIZE,
+			      DESC_HDR_TYPE_COMMON_NONSNOOP_NO_AFEU |
+				      DESC_HDR_SEL0_MDEUA |
+				      DESC_HDR_MODE0_MDEU_MD5),
+
+	TALITOS_HMAC_HASH_ALG("sha1", SHA1_DIGEST_SIZE, SHA1_BLOCK_SIZE,
+			      DESC_HDR_TYPE_COMMON_NONSNOOP_NO_AFEU |
+				      DESC_HDR_SEL0_MDEUA |
+				      DESC_HDR_MODE0_MDEU_SHA1),
+
+	TALITOS_HMAC_HASH_ALG("sha224", SHA224_DIGEST_SIZE, SHA224_BLOCK_SIZE,
+			      DESC_HDR_TYPE_COMMON_NONSNOOP_NO_AFEU |
+				      DESC_HDR_SEL0_MDEUA |
+				      DESC_HDR_MODE0_MDEU_SHA224),
+
+	TALITOS_HMAC_HASH_ALG("sha256", SHA256_DIGEST_SIZE, SHA256_BLOCK_SIZE,
+			      DESC_HDR_TYPE_COMMON_NONSNOOP_NO_AFEU |
+				      DESC_HDR_SEL0_MDEUA |
+				      DESC_HDR_MODE0_MDEU_SHA256),
+
+	TALITOS_HMAC_HASH_ALG("sha384", SHA384_DIGEST_SIZE, SHA384_BLOCK_SIZE,
+			      DESC_HDR_TYPE_COMMON_NONSNOOP_NO_AFEU |
+				      DESC_HDR_SEL0_MDEUB |
+				      DESC_HDR_MODE0_MDEUB_SHA384),
+
+	TALITOS_HMAC_HASH_ALG("sha512", SHA512_DIGEST_SIZE, SHA512_BLOCK_SIZE,
+			      DESC_HDR_TYPE_COMMON_NONSNOOP_NO_AFEU |
+				      DESC_HDR_SEL0_MDEUB |
+				      DESC_HDR_MODE0_MDEUB_SHA512),
 };
 
 int talitos_register_hash(struct device *dev)
@@ -847,18 +687,6 @@ int talitos_register_hash(struct device *dev)
 		ahash_alg = &talitos_alg_template.alg.hash;
 		alg = &ahash_alg->halg.base;
 
-		ahash_alg->init_tfm = talitos_cra_init_ahash;
-		ahash_alg->exit_tfm = talitos_cra_exit_ahash;
-		ahash_alg->init = ahash_init;
-		ahash_alg->update = ahash_update;
-		ahash_alg->final = ahash_final;
-		ahash_alg->finup = ahash_finup;
-		ahash_alg->digest = ahash_digest;
-		if (!strncmp(alg->cra_name, "hmac", 4))
-			ahash_alg->setkey = ahash_setkey;
-		ahash_alg->import = ahash_import;
-		ahash_alg->export = ahash_export;
-
 		if (!(priv->features & TALITOS_FTR_HMAC_OK) &&
 		    !strncmp(alg->cra_name, "hmac", 4)) {
 			/* not supported */

-- 
2.55.0

