Received: from smtpout-03.galae.net (smtpout-03.galae.net [185.246.85.4])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A78350EC04;
	Tue, 13 Oct 2026 13:12:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.246.85.4
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791897155; cv=none; b=VKY/ppzbzOGrofJnf/ocrREr9ch8V8WLO1WyRLyX/6TolpodNWgsVUN5/tC+5YcP55zm0BhNLLPQWVKnKL/ovZir8aFLimPf1f1/PjmDmwO3QtG3B7HodPchjlGc3Zc1C7AvZ230p4S4oLFDCxyuPIE+2cc+bps8jfMfUyEpnok=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791897155; c=relaxed/simple;
	bh=HmZFCo2C0RePI8+R4l5pS6IlnOBggZnj61UU+uU7/WA=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=XhNZuOSdpfJlIpMDdfWtFPyoo+3wMLhve/ROoekhW/xI1VWLtOhmVXq9OGb2hw/U6K9i1SFIBBseoxBxlMj5TATrf8TPjnT6CzXCxsBGovOfHxIKtZPinO8ZnutLkW9FVnHQCHjEYY41SU+AgxXJ/l0wKX192jLMd/KLQScxjzI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bootlin.com; spf=pass smtp.mailfrom=bootlin.com; dkim=pass (2048-bit key) header.d=bootlin.com header.i=@bootlin.com header.b=DQy59z/W; arc=none smtp.client-ip=185.246.85.4
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bootlin.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bootlin.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bootlin.com header.i=@bootlin.com header.b="DQy59z/W"
Received: from smtpout-01.galae.net (smtpout-01.galae.net [212.83.139.233])
	by smtpout-03.galae.net (Postfix) with ESMTPS id D3D9D4E411FB;
	Tue, 13 Oct 2026 13:12:31 +0000 (UTC)
Received: from mail.galae.net (mail.galae.net [212.83.136.155])
	by smtpout-01.galae.net (Postfix) with ESMTPS id AA04C60362;
	Tue, 13 Oct 2026 13:12:31 +0000 (UTC)
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id AA62D11D7139E;
	Tue, 13 Oct 2026 15:12:30 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=dkim;
	t=1791897151; h=from:subject:date:message-id:to:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references;
	bh=3T65WkXxGvyG6GR8plAzg2pGnE+YzVSLqgsuHCI2V/w=;
	b=DQy59z/WW7vaDQ+qjTwFcyO+gAqEhCA8ZV3GADa3YX5fbtB8ayEjeiUW1YoAXTmkAPd/RN
	ZfD2OWJcfyZzOsvUCxIGJD7n61WBE/J9XwAd0xjU0o6meUJUUAtewFVXuifakoAOo7snCi
	PS1HhZMaHrJbJdRC6G7YpDVQjn0hN/eq8wGkC5S6nm9TFv2ttse3z1/a3IlXQ+UCWkCn8r
	fgdskfxpWLZiTqdQgAt+Umc1qHK0ylyI16rnuUy4SaLICEygQD2B6/j1VIc3zz2AeUYx5J
	VPL9Mi/M29Uo91Rj5zFl+JixGjGqW15HQj3qZuEZ1ZjSSnt1QTz42cwrgRFo9w==
From: Paul Louvel <paul.louvel@bootlin.com>
Date: Tue, 13 Oct 2026 15:11:39 +0200
Subject: [PATCH v8 13/20] crypto: talitos/hash - Use macro for algorithm
 definitions
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261013-7-3-rc2_talitos_cleanup-v8-13-ca02be17696b@bootlin.com>
References: <20261013-7-3-rc2_talitos_cleanup-v8-0-ca02be17696b@bootlin.com>
In-Reply-To: <20261013-7-3-rc2_talitos_cleanup-v8-0-ca02be17696b@bootlin.com>
To: Herbert Xu <herbert@gondor.apana.org.au>, 
 "David S. Miller" <davem@davemloft.net>
Cc: Paul Louvel <paul.louvel@bootlin.com>, linux-crypto@vger.kernel.org, 
 linux-kernel@vger.kernel.org, 
 Thomas Petazzoni <thomas.petazzoni@bootlin.com>, 
 Christophe Leroy <chleroy@kernel.org>, 
 "Christophe Leroy (CS GROUP)" <chleroy@kernel.org>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1791897108; l=15357;
 i=paul.louvel@bootlin.com; s=20260313; h=from:subject:message-id;
 bh=HmZFCo2C0RePI8+R4l5pS6IlnOBggZnj61UU+uU7/WA=;
 b=YsScs3cb9o4l3cpbTWb2UgkpNFevE6B8OGK8IjfBdFSqEyE369p55CIwlPJE2z8mx+mvuzpnh
 eJIsGPsDU60DVydNVzPymxfF5X8QENqnHxZ65QwS1AXDGyobQ5HxNUc
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
index 3efe434586eb..ddb0e7310446 100644
--- a/drivers/crypto/talitos/talitos-hash.c
+++ b/drivers/crypto/talitos/talitos-hash.c
@@ -566,271 +566,111 @@ static void talitos_cra_exit_ahash(struct crypto_ahash *tfm)
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
@@ -852,18 +692,6 @@ int talitos_register_hash(struct device *dev)
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
2.56.0

