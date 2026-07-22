Received: from smtpout-03.galae.net (smtpout-03.galae.net [185.246.85.4])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9B294BC018
	for <linux-crypto@vger.kernel.org>; Wed, 22 Jul 2026 08:54:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.246.85.4
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784710487; cv=none; b=A2GVV9LDEGbShgaPbqSsL6smudA/vdsOIxMMvcgMBEJK+DjYjFV/JNO7EwvzRqTkFZ1+mJ9kxOGRNO0/dKRw4D6CimVY6CsQXCqVV64asqzJY4sTpgTHyijkBQzz1QFXpTuebd7oCBbMqa2gD0wWa4ohjuqAGps50MNfKaPsoIM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784710487; c=relaxed/simple;
	bh=mXIa89rnqO/hfwJSkqBKeSHCffU6DMQLwzpd/0d37+4=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=Se6jGLXt+CICOqfwN3oeyihM2M1VYDvwz+7DXHB7FFFxQvMsnRvHoGnKUCsr97SZp7WRpbVw4qTZKq/fUjDQudOnT6PSzIAG+ydwhR/8hj+DVofKYCXKQZVWRQqwvroNYZ1FeCH5VSV8wNyS4tNLEiFd69WNQyG/5rZ/tPQqiic=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bootlin.com; spf=pass smtp.mailfrom=bootlin.com; dkim=pass (2048-bit key) header.d=bootlin.com header.i=@bootlin.com header.b=VZJwSVol; arc=none smtp.client-ip=185.246.85.4
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bootlin.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bootlin.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bootlin.com header.i=@bootlin.com header.b="VZJwSVol"
Received: from smtpout-01.galae.net (smtpout-01.galae.net [212.83.139.233])
	by smtpout-03.galae.net (Postfix) with ESMTPS id 7B8424E40EC2;
	Wed, 22 Jul 2026 08:54:43 +0000 (UTC)
Received: from mail.galae.net (mail.galae.net [212.83.136.155])
	by smtpout-01.galae.net (Postfix) with ESMTPS id 504EE60388;
	Wed, 22 Jul 2026 08:54:43 +0000 (UTC)
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id A6A3C11BD3B3A;
	Wed, 22 Jul 2026 10:54:41 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=dkim;
	t=1784710482; h=from:subject:date:message-id:to:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references;
	bh=Wg1P3RqPZ7L5AELW1eFbAuTPco7L4Mda/oe5h4/hL44=;
	b=VZJwSVol3RDkm0i8eRA1xrBfX/C5W/ouIKBwiOSjSNA0xqFHfiXhrhSp82GMdgGq+1hWw8
	uMQAhVtG3DTC0ALOz2sDeSiKI8nQhwNEQ64nF3LDOYbO4GqkG+yrgGLVHqe2Ix0q8D6tuA
	RVRGLeMdJE6R4zg6H3Xvw+G7hQQ/DtYsjA9lmO98OUCBgeeN+WaQC/aFH9xon14k3QnsDH
	g/N88UKPQcoG44Ct9hKQrJSC0hVSrWWhLwWfQ9j/GgvMMBP80zRgwtpyAXEm+qoukrRVKo
	vjXe9w9jRp1RTFFSDZ1UgBdOkMx5Gs/7khWWHO0ny0Tl2dfN3xudgc1xJGntoQ==
From: Paul Louvel <paul.louvel@bootlin.com>
Date: Wed, 22 Jul 2026 10:53:57 +0200
Subject: [PATCH v4 13/19] crypto: talitos/skcipher - Use macro for
 algorithm definitions
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260722-7-1-rc1_talitos_cleanup-v4-13-81d1ed2ad911@bootlin.com>
References: <20260722-7-1-rc1_talitos_cleanup-v4-0-81d1ed2ad911@bootlin.com>
In-Reply-To: <20260722-7-1-rc1_talitos_cleanup-v4-0-81d1ed2ad911@bootlin.com>
To: Herbert Xu <herbert@gondor.apana.org.au>, 
 "David S. Miller" <davem@davemloft.net>
Cc: Thomas Petazzoni <thomas.petazzoni@bootlin.com>, 
 Herve Codina <herve.codina@bootlin.com>, 
 Christophe Leroy <chleroy@kernel.org>, linux-crypto@vger.kernel.org, 
 linux-kernel@vger.kernel.org, Paul Louvel <paul.louvel@bootlin.com>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1784710463; l=8918;
 i=paul.louvel@bootlin.com; s=20260313; h=from:subject:message-id;
 bh=mXIa89rnqO/hfwJSkqBKeSHCffU6DMQLwzpd/0d37+4=;
 b=8JUDiYiRlnytAcOxXkBzJF0EWN2ccfVidNJineoDrLB0RmSka2DoPALY/uQwxxNeGxR308HRC
 CUN+/GxW4eMA0Ct8z3JBuiFpmc0hzs8UgHjbCRyvZtPCrya7LraR+gP
X-Developer-Key: i=paul.louvel@bootlin.com; a=ed25519;
 pk=eLW50NT18UAvUT5cAcYf88zNbBCZDLFXuptpyLVhVIU=
X-Last-TLS-Session-Version: TLSv1.3

Replace the repetitive struct initializer entries with preprocessor
macros.

The fallback setkey assignment (skcipher_alg->setkey ?: skcipher_setkey)
is no longer needed because each macro specifies the correct setkey
handler directly.

Reviewed-by: Christophe Leroy (CS GROUP) <chleroy@kernel.org>
Signed-off-by: Paul Louvel <paul.louvel@bootlin.com>
---
 drivers/crypto/talitos/talitos-skcipher.c | 212 ++++++++++++------------------
 1 file changed, 82 insertions(+), 130 deletions(-)

diff --git a/drivers/crypto/talitos/talitos-skcipher.c b/drivers/crypto/talitos/talitos-skcipher.c
index 4c03573efb0a..b12191243aae 100644
--- a/drivers/crypto/talitos/talitos-skcipher.c
+++ b/drivers/crypto/talitos/talitos-skcipher.c
@@ -237,131 +237,89 @@ static void talitos_cra_exit_skcipher(struct crypto_skcipher *tfm)
 	talitos_cra_exit(crypto_skcipher_tfm(tfm));
 }
 
+#define TALITOS_SKCIPHER_ALG_COMMON(name, blk_sz, iv_sz, min_ksz, max_ksz, \
+				    set_key, desc_template)                \
+	{ \
+		.type = CRYPTO_ALG_TYPE_SKCIPHER, \
+		.alg.skcipher = { \
+			.base.cra_name = name, \
+			.base.cra_driver_name = name"-talitos", \
+			.base.cra_blocksize = blk_sz, \
+			.base.cra_flags = CRYPTO_ALG_ASYNC | \
+					  CRYPTO_ALG_ALLOCATES_MEMORY | \
+					  CRYPTO_ALG_KERN_DRIVER_ONLY, \
+			.base.cra_priority = TALITOS_CRA_PRIORITY, \
+			.base.cra_ctxsize = sizeof(struct talitos_ctx), \
+			.base.cra_module = THIS_MODULE, \
+			.min_keysize = min_ksz, \
+			.max_keysize = max_ksz, \
+			.ivsize = iv_sz, \
+			.setkey = set_key, \
+			.init = talitos_cra_init_skcipher, \
+			.exit = talitos_cra_exit_skcipher, \
+			.encrypt = skcipher_encrypt, \
+			.decrypt = skcipher_decrypt, \
+		}, \
+		.desc_hdr_template = desc_template, \
+	}
+
+#define TALITOS_SKCIPHER_ALG_AES(name, blk_sz, iv_sz, desc_template)       \
+	TALITOS_SKCIPHER_ALG_COMMON(name, blk_sz, iv_sz, AES_MIN_KEY_SIZE, \
+				    AES_MAX_KEY_SIZE, skcipher_aes_setkey, \
+				    desc_template)
+
+#define TALITOS_SKCIPHER_ALG_DES(name, blk_sz, iv_sz, desc_template)   \
+	TALITOS_SKCIPHER_ALG_COMMON(name, blk_sz, iv_sz, DES_KEY_SIZE, \
+				    DES_KEY_SIZE, skcipher_des_setkey, \
+				    desc_template)
+
+#define TALITOS_SKCIPHER_ALG_DES3(name, blk_sz, iv_sz, desc_template)        \
+	TALITOS_SKCIPHER_ALG_COMMON(name, blk_sz, iv_sz, DES3_EDE_KEY_SIZE,  \
+				    DES3_EDE_KEY_SIZE, skcipher_des3_setkey, \
+				    desc_template)
+
 static struct talitos_alg_template skcipher_driver_algs[] = {
-	{	.type = CRYPTO_ALG_TYPE_SKCIPHER,
-		.alg.skcipher = {
-			.base.cra_name = "ecb(aes)",
-			.base.cra_driver_name = "ecb-aes-talitos",
-			.base.cra_blocksize = AES_BLOCK_SIZE,
-			.base.cra_flags = CRYPTO_ALG_ASYNC |
-					  CRYPTO_ALG_ALLOCATES_MEMORY,
-			.min_keysize = AES_MIN_KEY_SIZE,
-			.max_keysize = AES_MAX_KEY_SIZE,
-			.setkey = skcipher_aes_setkey,
-		},
-		.desc_hdr_template = DESC_HDR_TYPE_COMMON_NONSNOOP_NO_AFEU |
-				     DESC_HDR_SEL0_AESU,
-	},
-	{	.type = CRYPTO_ALG_TYPE_SKCIPHER,
-		.alg.skcipher = {
-			.base.cra_name = "cbc(aes)",
-			.base.cra_driver_name = "cbc-aes-talitos",
-			.base.cra_blocksize = AES_BLOCK_SIZE,
-			.base.cra_flags = CRYPTO_ALG_ASYNC |
-					  CRYPTO_ALG_ALLOCATES_MEMORY,
-			.min_keysize = AES_MIN_KEY_SIZE,
-			.max_keysize = AES_MAX_KEY_SIZE,
-			.ivsize = AES_BLOCK_SIZE,
-			.setkey = skcipher_aes_setkey,
-		},
-		.desc_hdr_template = DESC_HDR_TYPE_COMMON_NONSNOOP_NO_AFEU |
-				     DESC_HDR_SEL0_AESU |
-				     DESC_HDR_MODE0_AESU_CBC,
-	},
-	{	.type = CRYPTO_ALG_TYPE_SKCIPHER,
-		.alg.skcipher = {
-			.base.cra_name = "ctr(aes)",
-			.base.cra_driver_name = "ctr-aes-talitos",
-			.base.cra_blocksize = 1,
-			.base.cra_flags = CRYPTO_ALG_ASYNC |
-					  CRYPTO_ALG_ALLOCATES_MEMORY,
-			.min_keysize = AES_MIN_KEY_SIZE,
-			.max_keysize = AES_MAX_KEY_SIZE,
-			.ivsize = AES_BLOCK_SIZE,
-			.setkey = skcipher_aes_setkey,
-		},
-		.desc_hdr_template = DESC_HDR_TYPE_AESU_CTR_NONSNOOP |
-				     DESC_HDR_SEL0_AESU |
-				     DESC_HDR_MODE0_AESU_CTR,
-	},
-	{	.type = CRYPTO_ALG_TYPE_SKCIPHER,
-		.alg.skcipher = {
-			.base.cra_name = "ctr(aes)",
-			.base.cra_driver_name = "ctr-aes-talitos",
-			.base.cra_blocksize = 1,
-			.base.cra_flags = CRYPTO_ALG_ASYNC |
-					  CRYPTO_ALG_ALLOCATES_MEMORY,
-			.min_keysize = AES_MIN_KEY_SIZE,
-			.max_keysize = AES_MAX_KEY_SIZE,
-			.ivsize = AES_BLOCK_SIZE,
-			.setkey = skcipher_aes_setkey,
-		},
-		.desc_hdr_template = DESC_HDR_TYPE_COMMON_NONSNOOP_NO_AFEU |
-				     DESC_HDR_SEL0_AESU |
-				     DESC_HDR_MODE0_AESU_CTR,
-	},
-	{	.type = CRYPTO_ALG_TYPE_SKCIPHER,
-		.alg.skcipher = {
-			.base.cra_name = "ecb(des)",
-			.base.cra_driver_name = "ecb-des-talitos",
-			.base.cra_blocksize = DES_BLOCK_SIZE,
-			.base.cra_flags = CRYPTO_ALG_ASYNC |
-					  CRYPTO_ALG_ALLOCATES_MEMORY,
-			.min_keysize = DES_KEY_SIZE,
-			.max_keysize = DES_KEY_SIZE,
-			.setkey = skcipher_des_setkey,
-		},
-		.desc_hdr_template = DESC_HDR_TYPE_COMMON_NONSNOOP_NO_AFEU |
-				     DESC_HDR_SEL0_DEU,
-	},
-	{	.type = CRYPTO_ALG_TYPE_SKCIPHER,
-		.alg.skcipher = {
-			.base.cra_name = "cbc(des)",
-			.base.cra_driver_name = "cbc-des-talitos",
-			.base.cra_blocksize = DES_BLOCK_SIZE,
-			.base.cra_flags = CRYPTO_ALG_ASYNC |
-					  CRYPTO_ALG_ALLOCATES_MEMORY,
-			.min_keysize = DES_KEY_SIZE,
-			.max_keysize = DES_KEY_SIZE,
-			.ivsize = DES_BLOCK_SIZE,
-			.setkey = skcipher_des_setkey,
-		},
-		.desc_hdr_template = DESC_HDR_TYPE_COMMON_NONSNOOP_NO_AFEU |
-				     DESC_HDR_SEL0_DEU |
-				     DESC_HDR_MODE0_DEU_CBC,
-	},
-	{	.type = CRYPTO_ALG_TYPE_SKCIPHER,
-		.alg.skcipher = {
-			.base.cra_name = "ecb(des3_ede)",
-			.base.cra_driver_name = "ecb-3des-talitos",
-			.base.cra_blocksize = DES3_EDE_BLOCK_SIZE,
-			.base.cra_flags = CRYPTO_ALG_ASYNC |
-					  CRYPTO_ALG_ALLOCATES_MEMORY,
-			.min_keysize = DES3_EDE_KEY_SIZE,
-			.max_keysize = DES3_EDE_KEY_SIZE,
-			.setkey = skcipher_des3_setkey,
-		},
-		.desc_hdr_template = DESC_HDR_TYPE_COMMON_NONSNOOP_NO_AFEU |
-				     DESC_HDR_SEL0_DEU |
-				     DESC_HDR_MODE0_DEU_3DES,
-	},
-	{	.type = CRYPTO_ALG_TYPE_SKCIPHER,
-		.alg.skcipher = {
-			.base.cra_name = "cbc(des3_ede)",
-			.base.cra_driver_name = "cbc-3des-talitos",
-			.base.cra_blocksize = DES3_EDE_BLOCK_SIZE,
-			.base.cra_flags = CRYPTO_ALG_ASYNC |
-					  CRYPTO_ALG_ALLOCATES_MEMORY,
-			.min_keysize = DES3_EDE_KEY_SIZE,
-			.max_keysize = DES3_EDE_KEY_SIZE,
-			.ivsize = DES3_EDE_BLOCK_SIZE,
-			.setkey = skcipher_des3_setkey,
-		},
-		.desc_hdr_template = DESC_HDR_TYPE_COMMON_NONSNOOP_NO_AFEU |
-				     DESC_HDR_SEL0_DEU |
-				     DESC_HDR_MODE0_DEU_CBC |
-				     DESC_HDR_MODE0_DEU_3DES,
-	},
+	/* AES */
+
+	TALITOS_SKCIPHER_ALG_AES("ecb(aes)", AES_BLOCK_SIZE, 0,
+				 DESC_HDR_TYPE_COMMON_NONSNOOP_NO_AFEU |
+					 DESC_HDR_SEL0_AESU),
+
+	TALITOS_SKCIPHER_ALG_AES("cbc(aes)", AES_BLOCK_SIZE, AES_BLOCK_SIZE,
+				 DESC_HDR_TYPE_COMMON_NONSNOOP_NO_AFEU |
+					 DESC_HDR_SEL0_AESU |
+					 DESC_HDR_MODE0_AESU_CBC),
+
+	TALITOS_SKCIPHER_ALG_AES("ctr(aes)", 1, AES_BLOCK_SIZE,
+				 DESC_HDR_TYPE_AESU_CTR_NONSNOOP |
+					 DESC_HDR_SEL0_AESU |
+					 DESC_HDR_MODE0_AESU_CTR),
+
+	TALITOS_SKCIPHER_ALG_AES("ctr(aes)", 1, AES_BLOCK_SIZE,
+				 DESC_HDR_TYPE_COMMON_NONSNOOP_NO_AFEU |
+					 DESC_HDR_SEL0_AESU |
+					 DESC_HDR_MODE0_AESU_CTR),
+	/* DES */
+
+	TALITOS_SKCIPHER_ALG_DES("ecb(des)", DES_BLOCK_SIZE, 0,
+				 DESC_HDR_TYPE_COMMON_NONSNOOP_NO_AFEU |
+					 DESC_HDR_SEL0_DEU),
+
+	TALITOS_SKCIPHER_ALG_DES("cbc(des)", DES_BLOCK_SIZE, DES_BLOCK_SIZE,
+				 DESC_HDR_TYPE_COMMON_NONSNOOP_NO_AFEU |
+					 DESC_HDR_SEL0_DEU |
+					 DESC_HDR_MODE0_DEU_CBC),
+	/* DES3 */
+
+	TALITOS_SKCIPHER_ALG_DES3("ecb(des3_ede)", DES3_EDE_BLOCK_SIZE, 0,
+				  DESC_HDR_TYPE_COMMON_NONSNOOP_NO_AFEU |
+					  DESC_HDR_SEL0_DEU |
+					  DESC_HDR_MODE0_DEU_3DES),
+
+	TALITOS_SKCIPHER_ALG_DES3(
+		"cbc(des3_ede)", DES3_EDE_BLOCK_SIZE, DES3_EDE_BLOCK_SIZE,
+		DESC_HDR_TYPE_COMMON_NONSNOOP_NO_AFEU | DESC_HDR_SEL0_DEU |
+			DESC_HDR_MODE0_DEU_CBC | DESC_HDR_MODE0_DEU_3DES),
 };
 
 int talitos_register_skcipher(struct device *dev)
@@ -383,12 +341,6 @@ int talitos_register_skcipher(struct device *dev)
 		if (has_ftr_sec1(priv))
 			alg->cra_alignmask = 3;
 
-		skcipher_alg->init = talitos_cra_init_skcipher;
-		skcipher_alg->exit = talitos_cra_exit_skcipher;
-		skcipher_alg->setkey = skcipher_alg->setkey ?: skcipher_setkey;
-		skcipher_alg->encrypt = skcipher_encrypt;
-		skcipher_alg->decrypt = skcipher_decrypt;
-
 		if (!strcmp(alg->cra_name, "ctr(aes)") && !has_ftr_sec1(priv) &&
 		    DESC_TYPE(skcipher_driver_algs[i].desc_hdr_template) !=
 			    DESC_TYPE(DESC_HDR_TYPE_AESU_CTR_NONSNOOP)) {

-- 
2.55.0

