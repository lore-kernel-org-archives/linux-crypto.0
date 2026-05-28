Received: from smtpout-02.galae.net (smtpout-02.galae.net [185.246.84.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0FD23AC0C4
	for <linux-crypto@vger.kernel.org>; Thu, 28 May 2026 09:09:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.246.84.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779959384; cv=none; b=PM0+zQc1vumjssL4FftMa3ePIJobFNxRvVpDyeaY7M4LvUZg7PJPlZi0EczJ2w8NuFfmPP1iHWTZPBCR7K0LeYWM6LAz3gaumlMrE5qH3SDhLrhvO88swFE3++soEwtLt+kf6JoVn8LEi9ssKhSPN6V2YIKcuvLaifwhKqz9KBs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779959384; c=relaxed/simple;
	bh=DLC4pIGNz6aHaYwLLNtekInry3bIulgy7QMwDGrZrmM=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=uIALBEXBcdUIkoRE/qNyhQ0hoZtDu0kWsq3MGizxnK/AE13AZ2Qwp1BBYEpM9cs7iYIBgA0m7IcMHZm5amqm5dWL0bAQk4KJnEvF2yJKfuur8MAV6aRx1n3URnqFoPPOF46s/7lzv+EpPvILnWZZwQBNdPix4X9/8VXvuitGuHs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bootlin.com; spf=pass smtp.mailfrom=bootlin.com; dkim=pass (2048-bit key) header.d=bootlin.com header.i=@bootlin.com header.b=yiZEvneD; arc=none smtp.client-ip=185.246.84.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bootlin.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bootlin.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bootlin.com header.i=@bootlin.com header.b="yiZEvneD"
Received: from smtpout-01.galae.net (smtpout-01.galae.net [212.83.139.233])
	by smtpout-02.galae.net (Postfix) with ESMTPS id 458261A3700;
	Thu, 28 May 2026 09:09:39 +0000 (UTC)
Received: from mail.galae.net (mail.galae.net [212.83.136.155])
	by smtpout-01.galae.net (Postfix) with ESMTPS id 11C7560495;
	Thu, 28 May 2026 09:09:39 +0000 (UTC)
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id 0C2C710888CB2;
	Thu, 28 May 2026 11:09:36 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=dkim;
	t=1779959378; h=from:subject:date:message-id:to:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references;
	bh=1WYe0VAZorY8zEbQ7xQbUC7MjEQH8bd6sYe2kC6a1aU=;
	b=yiZEvneDBlQqvcuyLFbPIKMxKFCEri0I3n5qpcfpL8JmP54pPzFJit4Hfi1yRWq/I8bjkP
	a+u6+JGG4ONoAfPqiySkvQGLBpa1puH7OGY+SBnNfqb2PKFVyhvQ98pznu5QPNVEVDVtre
	rHIO45bEPrWQn4kj2VOn6xDvTLCwTFDjn4aBS9OScq+/iUOvp1hNebbGE/s3d2wTxk43QG
	cCDse/xxuFdjgIdR4ilsW0MMUw9GdUkVcTeEllh0i3ejXfgTEFYyf27exP9UA4Bzh6xCKH
	icAGfuMGPvkF4viffkOzSOHBTK1M1Pn+M91+NiKmOTSt3GIlwfCHY2oDax38eg==
From: Paul Louvel <paul.louvel@bootlin.com>
Date: Thu, 28 May 2026 11:08:28 +0200
Subject: [PATCH 15/29] crypto: talitos/hash - Use macro for algorithm
 definitions
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260528-7-1-rc1_talitos_cleanup-v1-15-cb1ad6cdea49@bootlin.com>
References: <20260528-7-1-rc1_talitos_cleanup-v1-0-cb1ad6cdea49@bootlin.com>
In-Reply-To: <20260528-7-1-rc1_talitos_cleanup-v1-0-cb1ad6cdea49@bootlin.com>
To: Herbert Xu <herbert@gondor.apana.org.au>, 
 "David S. Miller" <davem@davemloft.net>
Cc: Thomas Petazzoni <thomas.petazzoni@bootlin.com>, 
 Herve Codina <herve.codina@bootlin.com>, 
 Christophe Leroy <chleroy@kernel.org>, linux-crypto@vger.kernel.org, 
 linux-kernel@vger.kernel.org, Paul Louvel <paul.louvel@bootlin.com>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1779959350; l=15956;
 i=paul.louvel@bootlin.com; s=20260313; h=from:subject:message-id;
 bh=DLC4pIGNz6aHaYwLLNtekInry3bIulgy7QMwDGrZrmM=;
 b=0Jl3+rIu3VWUGlyzNG3Gu3Hm640EM+ep4olz6qhv77f6rtowmdj4lsDLuYVqUixFXYcOAjWSV
 BvPC4tJz6U2CgnXuUhXTnH9qA8NYb2kF2GpYXBGm1NDNOwKCAXmTqOH
X-Developer-Key: i=paul.louvel@bootlin.com; a=ed25519;
 pk=eLW50NT18UAvUT5cAcYf88zNbBCZDLFXuptpyLVhVIU=
X-Last-TLS-Session-Version: TLSv1.3

Replace the repetitive struct initializer entries in hash_driver_algs[]
with preprocessor macros (TALITOS_HASH_ALG, TALITOS_HMAC_HASH_ALG).

Remove the function pointer assignments (init_tfm, exit_tfm, init, update,
final, finup, digest, export, import).

The HMAC setkey assignment, previously done by comparing the algorithm
name at runtime, is now handled by passing ahash_setkey directly through
the TALITOS_HMAC_HASH_ALG macro variant.

Signed-off-by: Paul Louvel <paul.louvel@bootlin.com>
---
 drivers/crypto/talitos/talitos-hash.c | 392 +++++++++-------------------------
 1 file changed, 104 insertions(+), 288 deletions(-)

diff --git a/drivers/crypto/talitos/talitos-hash.c b/drivers/crypto/talitos/talitos-hash.c
index f7f6f01cfddf..9e6d849c3123 100644
--- a/drivers/crypto/talitos/talitos-hash.c
+++ b/drivers/crypto/talitos/talitos-hash.c
@@ -551,283 +551,111 @@ static void talitos_cra_exit_ahash(struct crypto_ahash *tfm)
 	talitos_cra_exit(crypto_ahash_tfm(tfm));
 }
 
-static struct talitos_alg_template hash_driver_algs[] = {
-	{	.type = CRYPTO_ALG_TYPE_AHASH,
-		.alg.hash = {
-			.halg.digestsize = MD5_DIGEST_SIZE,
-			.halg.statesize = sizeof(struct talitos_export_state),
-			.halg.base = {
-				.cra_name = "md5",
-				.cra_driver_name = "md5-talitos",
-				.cra_blocksize = MD5_HMAC_BLOCK_SIZE,
-				.cra_reqsize = sizeof(struct talitos_ahash_req_ctx),
-				.cra_flags = CRYPTO_ALG_ASYNC |
-					     CRYPTO_ALG_ALLOCATES_MEMORY |
-					     CRYPTO_ALG_KERN_DRIVER_ONLY |
-			     CRYPTO_AHASH_ALG_BLOCK_ONLY |
-					     CRYPTO_AHASH_ALG_FINAL_NONZERO,
-				.cra_priority = TALITOS_CRA_PRIORITY,
-				.cra_ctxsize = sizeof(struct talitos_ctx),
-				.cra_module = THIS_MODULE,
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
-				.cra_flags = CRYPTO_ALG_ASYNC |
-					     CRYPTO_ALG_ALLOCATES_MEMORY |
-					     CRYPTO_ALG_KERN_DRIVER_ONLY |
-			     CRYPTO_AHASH_ALG_BLOCK_ONLY |
-					     CRYPTO_AHASH_ALG_FINAL_NONZERO,
-				.cra_priority = TALITOS_CRA_PRIORITY,
-				.cra_ctxsize = sizeof(struct talitos_ctx),
-				.cra_module = THIS_MODULE,
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
-				.cra_flags = CRYPTO_ALG_ASYNC |
-					     CRYPTO_ALG_ALLOCATES_MEMORY |
-					     CRYPTO_ALG_KERN_DRIVER_ONLY |
-			     CRYPTO_AHASH_ALG_BLOCK_ONLY |
-					     CRYPTO_AHASH_ALG_FINAL_NONZERO,
-				.cra_priority = TALITOS_CRA_PRIORITY,
-				.cra_ctxsize = sizeof(struct talitos_ctx),
-				.cra_module = THIS_MODULE,
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
-				.cra_flags = CRYPTO_ALG_ASYNC |
-					     CRYPTO_ALG_ALLOCATES_MEMORY |
-					     CRYPTO_ALG_KERN_DRIVER_ONLY |
-			     CRYPTO_AHASH_ALG_BLOCK_ONLY |
-					     CRYPTO_AHASH_ALG_FINAL_NONZERO,
-				.cra_priority = TALITOS_CRA_PRIORITY,
-				.cra_ctxsize = sizeof(struct talitos_ctx),
-				.cra_module = THIS_MODULE,
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
-				.cra_flags = CRYPTO_ALG_ASYNC |
-					     CRYPTO_ALG_ALLOCATES_MEMORY |
-					     CRYPTO_ALG_KERN_DRIVER_ONLY |
-			     CRYPTO_AHASH_ALG_BLOCK_ONLY |
-					     CRYPTO_AHASH_ALG_FINAL_NONZERO,
-				.cra_priority = TALITOS_CRA_PRIORITY,
-				.cra_ctxsize = sizeof(struct talitos_ctx),
-				.cra_module = THIS_MODULE,
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
-				.cra_flags = CRYPTO_ALG_ASYNC |
-					     CRYPTO_ALG_ALLOCATES_MEMORY |
-					     CRYPTO_ALG_KERN_DRIVER_ONLY |
-			     CRYPTO_AHASH_ALG_BLOCK_ONLY |
-					     CRYPTO_AHASH_ALG_FINAL_NONZERO,
-				.cra_priority = TALITOS_CRA_PRIORITY,
-				.cra_ctxsize = sizeof(struct talitos_ctx),
-				.cra_module = THIS_MODULE,
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
-				.cra_flags = CRYPTO_ALG_ASYNC |
-					     CRYPTO_ALG_ALLOCATES_MEMORY |
-					     CRYPTO_ALG_KERN_DRIVER_ONLY |
-			     CRYPTO_AHASH_ALG_BLOCK_ONLY |
-					     CRYPTO_AHASH_ALG_FINAL_NONZERO,
-				.cra_priority = TALITOS_CRA_PRIORITY,
-				.cra_ctxsize = sizeof(struct talitos_ctx),
-				.cra_module = THIS_MODULE,
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
-				.cra_flags = CRYPTO_ALG_ASYNC |
-					     CRYPTO_ALG_ALLOCATES_MEMORY |
-					     CRYPTO_ALG_KERN_DRIVER_ONLY |
-			     CRYPTO_AHASH_ALG_BLOCK_ONLY |
-					     CRYPTO_AHASH_ALG_FINAL_NONZERO,
-				.cra_priority = TALITOS_CRA_PRIORITY,
-				.cra_ctxsize = sizeof(struct talitos_ctx),
-				.cra_module = THIS_MODULE,
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
-				.cra_flags = CRYPTO_ALG_ASYNC |
-					     CRYPTO_ALG_ALLOCATES_MEMORY |
-					     CRYPTO_ALG_KERN_DRIVER_ONLY |
-			     CRYPTO_AHASH_ALG_BLOCK_ONLY |
-					     CRYPTO_AHASH_ALG_FINAL_NONZERO,
-				.cra_priority = TALITOS_CRA_PRIORITY,
-				.cra_ctxsize = sizeof(struct talitos_ctx),
-				.cra_module = THIS_MODULE,
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
-				.cra_flags = CRYPTO_ALG_ASYNC |
-					     CRYPTO_ALG_ALLOCATES_MEMORY |
-					     CRYPTO_ALG_KERN_DRIVER_ONLY |
-			     CRYPTO_AHASH_ALG_BLOCK_ONLY |
-					     CRYPTO_AHASH_ALG_FINAL_NONZERO,
-				.cra_priority = TALITOS_CRA_PRIORITY,
-				.cra_ctxsize = sizeof(struct talitos_ctx),
-				.cra_module = THIS_MODULE,
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
-				.cra_flags = CRYPTO_ALG_ASYNC |
-					     CRYPTO_ALG_ALLOCATES_MEMORY |
-					     CRYPTO_ALG_KERN_DRIVER_ONLY |
-			     CRYPTO_AHASH_ALG_BLOCK_ONLY |
-					     CRYPTO_AHASH_ALG_FINAL_NONZERO,
-				.cra_priority = TALITOS_CRA_PRIORITY,
-				.cra_ctxsize = sizeof(struct talitos_ctx),
-				.cra_module = THIS_MODULE,
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
-				.cra_flags = CRYPTO_ALG_ASYNC |
-					     CRYPTO_ALG_ALLOCATES_MEMORY |
-					     CRYPTO_ALG_KERN_DRIVER_ONLY |
-			     CRYPTO_AHASH_ALG_BLOCK_ONLY |
-					     CRYPTO_AHASH_ALG_FINAL_NONZERO,
-				.cra_priority = TALITOS_CRA_PRIORITY,
-				.cra_ctxsize = sizeof(struct talitos_ctx),
-				.cra_module = THIS_MODULE,
-			}
-		},
-		.desc_hdr_template = DESC_HDR_TYPE_COMMON_NONSNOOP_NO_AFEU |
-				     DESC_HDR_SEL0_MDEUB |
-				     DESC_HDR_MODE0_MDEUB_SHA512,
+#define TALITOS_HASH_ALG_COMMON(name, digest_size, block_size, template, \
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
+				.cra_driver_name = name"-talitos", \
+				.cra_blocksize = block_size, \
+				.cra_reqsize = sizeof(struct talitos_ahash_req_ctx), \
+				.cra_flags = CRYPTO_ALG_ASYNC | \
+					     CRYPTO_ALG_ALLOCATES_MEMORY | \
+					     CRYPTO_ALG_KERN_DRIVER_ONLY | \
+					     CRYPTO_AHASH_ALG_BLOCK_ONLY | \
+					     CRYPTO_AHASH_ALG_FINAL_NONZERO, \
+				.cra_priority = TALITOS_CRA_PRIORITY, \
+				.cra_ctxsize = sizeof(struct talitos_ctx), \
+				.cra_module = THIS_MODULE, \
+			}, \
+		}, \
+		.desc_hdr_template = template, \
 	}
+
+#define TALITOS_HASH_ALG(name, digest_size, block_size, desc_hdr_template) \
+	TALITOS_HASH_ALG_COMMON(name, digest_size, block_size,             \
+				desc_hdr_template, NULL)
+
+#define TALITOS_HMAC_HASH_ALG(name, digest_size, block_size,               \
+			      desc_hdr_template)                           \
+	TALITOS_HASH_ALG_COMMON("hmac(" name ")", digest_size, block_size, \
+				desc_hdr_template, ahash_setkey)
+
+static struct talitos_alg_template hash_driver_algs[] = {
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
@@ -846,18 +674,6 @@ int talitos_register_hash(struct device *dev)
 		ahash_alg = &hash_driver_algs[i].alg.hash;
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
2.54.0

