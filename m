Received: from smtpout-02.galae.net (smtpout-02.galae.net [185.246.84.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12D62393DF9;
	Fri, 11 Sep 2026 14:47:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.246.84.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789138062; cv=none; b=Lj8A88GTyNYjd0IJLm29LIrJtzh05EKTZ6DEprFYBosj/QhjhAfeRd7FCN8abM6u41GwgT9KjhfueCtE6FNWfFSkQpVNEMUd8V1mGb+z5uMRDzF2pvKpXMp9V4Su+nsiXyP7nH83NX8mWJ/HAfXBDyXrpIbSe7WMcyc2UjdZRyk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789138062; c=relaxed/simple;
	bh=brEGUYZKaNNO3u6r1PMA7TjGMwU57Zrw9OoF9YO2U04=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=rv3z058tMeHi4TW8rNAjk4DpzEr5mIWKsl4NPNgobrX17WcFm5iOUaWWwK6tjItEh2Y56VS+54doDiWaxKpjNxIFnPLwURoMACjPO30YHQb/JHwRjty8Jd5FfW/L4x6Q35bCQnGVIcbtp485silikftYPerFaXHuYvgMIbASzsA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bootlin.com; spf=pass smtp.mailfrom=bootlin.com; dkim=pass (2048-bit key) header.d=bootlin.com header.i=@bootlin.com header.b=unMoEQBK; arc=none smtp.client-ip=185.246.84.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bootlin.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bootlin.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bootlin.com header.i=@bootlin.com header.b="unMoEQBK"
Received: from smtpout-01.galae.net (smtpout-01.galae.net [212.83.139.233])
	by smtpout-02.galae.net (Postfix) with ESMTPS id 67C631A010A;
	Fri, 11 Sep 2026 14:47:38 +0000 (UTC)
Received: from mail.galae.net (mail.galae.net [212.83.136.155])
	by smtpout-01.galae.net (Postfix) with ESMTPS id 3DC26601DE;
	Fri, 11 Sep 2026 14:47:38 +0000 (UTC)
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id 177DD11C7AFC2;
	Fri, 11 Sep 2026 16:47:33 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=dkim;
	t=1789138053; h=from:subject:date:message-id:to:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references;
	bh=qb1wUb4EMthjmNfom9HtvCpm5Q01NkTLeocM6P8AyjI=;
	b=unMoEQBKKLiuqK97gez8hQevI54aUIQtjSkG9uG7gi+2QL+XqU19jxpuEfiMY7zDZozGEm
	qrqaR26z4w534Ho0xkNRsrnzHEUgWPaMK/CbTbvKTGrEJAtvLrkrGoBdtPW7g4DAgiDZXS
	Msq3dmy4ds0DbP/zQScfWvJZeDO4n3pNdJ+NmaRAagXIBM9dOvV8B8BETV1KsHzobdoGQj
	jB1TsiYAEV2ztPP4PSGO94Ux9APaPzbVOi27yR7K4rRBH7z8ISb3bV/IEYzzRQuRatqHSE
	YpjddA5LGZ9S4KousvZyfVpY1pLqW0qjwCe2nR+WRY5rvSmr5uju5Qlkd9OO0w==
From: Paul Louvel <paul.louvel@bootlin.com>
Date: Fri, 11 Sep 2026 16:46:31 +0200
Subject: [PATCH v6 14/19] crypto: talitos/skcipher - Use macro for
 algorithm definitions
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260911-7-3-rc2_talitos_cleanup-v6-14-4215f347c97a@bootlin.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1789138028; l=9109;
 i=paul.louvel@bootlin.com; s=20260313; h=from:subject:message-id;
 bh=brEGUYZKaNNO3u6r1PMA7TjGMwU57Zrw9OoF9YO2U04=;
 b=7KYs/hJmTSUFaVCKpF6EcfZbiT1ihHrNj6HqMN5K5BGLtJUNPl+Ry5M/qL7ZF8WB9bU2X+RcP
 LCOnL5BTOtRAIL4OEzJac0UTLyoA+BfV5TMn11z6iW1xNAf1K8TMsJP
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
index 6c60ad6aa9be..8360181840f6 100644
--- a/drivers/crypto/talitos/talitos-skcipher.c
+++ b/drivers/crypto/talitos/talitos-skcipher.c
@@ -237,131 +237,89 @@ static void talitos_cra_exit_skcipher(struct crypto_skcipher *tfm)
 	talitos_cra_exit(crypto_skcipher_tfm(tfm));
 }
 
+#define TALITOS_SKCIPHER_ALG_COMMON(name, driver_name, blk_sz, iv_sz, min_ksz, max_ksz, \
+				    set_key, desc_template)                \
+	{ \
+		.type = CRYPTO_ALG_TYPE_SKCIPHER, \
+		.alg.skcipher = { \
+			.base.cra_name = name, \
+			.base.cra_driver_name = driver_name"-talitos", \
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
+#define TALITOS_SKCIPHER_ALG_AES(name, driver_name, blk_sz, iv_sz, desc_template)       \
+	TALITOS_SKCIPHER_ALG_COMMON(name, driver_name, blk_sz, iv_sz, AES_MIN_KEY_SIZE, \
+				    AES_MAX_KEY_SIZE, skcipher_aes_setkey, \
+				    desc_template)
+
+#define TALITOS_SKCIPHER_ALG_DES(name, driver_name, blk_sz, iv_sz, desc_template)   \
+	TALITOS_SKCIPHER_ALG_COMMON(name, driver_name, blk_sz, iv_sz, DES_KEY_SIZE, \
+				    DES_KEY_SIZE, skcipher_des_setkey, \
+				    desc_template)
+
+#define TALITOS_SKCIPHER_ALG_DES3(name, driver_name, blk_sz, iv_sz, desc_template)        \
+	TALITOS_SKCIPHER_ALG_COMMON(name, driver_name, blk_sz, iv_sz, DES3_EDE_KEY_SIZE,  \
+				    DES3_EDE_KEY_SIZE, skcipher_des3_setkey, \
+				    desc_template)
+
 static const struct talitos_alg_template skcipher_driver_algs[] = {
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
+	TALITOS_SKCIPHER_ALG_AES("ecb(aes)", "ecb-aes", AES_BLOCK_SIZE, 0,
+				 DESC_HDR_TYPE_COMMON_NONSNOOP_NO_AFEU |
+					 DESC_HDR_SEL0_AESU),
+
+	TALITOS_SKCIPHER_ALG_AES("cbc(aes)", "cbc-aes", AES_BLOCK_SIZE, AES_BLOCK_SIZE,
+				 DESC_HDR_TYPE_COMMON_NONSNOOP_NO_AFEU |
+					 DESC_HDR_SEL0_AESU |
+					 DESC_HDR_MODE0_AESU_CBC),
+
+	TALITOS_SKCIPHER_ALG_AES("ctr(aes)", "ctr-aes", 1, AES_BLOCK_SIZE,
+				 DESC_HDR_TYPE_AESU_CTR_NONSNOOP |
+					 DESC_HDR_SEL0_AESU |
+					 DESC_HDR_MODE0_AESU_CTR),
+
+	TALITOS_SKCIPHER_ALG_AES("ctr(aes)", "ctr-aes", 1, AES_BLOCK_SIZE,
+				 DESC_HDR_TYPE_COMMON_NONSNOOP_NO_AFEU |
+					 DESC_HDR_SEL0_AESU |
+					 DESC_HDR_MODE0_AESU_CTR),
+	/* DES */
+
+	TALITOS_SKCIPHER_ALG_DES("ecb(des)", "ecb-des", DES_BLOCK_SIZE, 0,
+				 DESC_HDR_TYPE_COMMON_NONSNOOP_NO_AFEU |
+					 DESC_HDR_SEL0_DEU),
+
+	TALITOS_SKCIPHER_ALG_DES("cbc(des)", "cbc-des", DES_BLOCK_SIZE, DES_BLOCK_SIZE,
+				 DESC_HDR_TYPE_COMMON_NONSNOOP_NO_AFEU |
+					 DESC_HDR_SEL0_DEU |
+					 DESC_HDR_MODE0_DEU_CBC),
+	/* DES3 */
+
+	TALITOS_SKCIPHER_ALG_DES3("ecb(des3_ede)", "ecb-3des", DES3_EDE_BLOCK_SIZE, 0,
+				  DESC_HDR_TYPE_COMMON_NONSNOOP_NO_AFEU |
+					  DESC_HDR_SEL0_DEU |
+					  DESC_HDR_MODE0_DEU_3DES),
+
+	TALITOS_SKCIPHER_ALG_DES3(
+		"cbc(des3_ede)", "cbc-3des", DES3_EDE_BLOCK_SIZE, DES3_EDE_BLOCK_SIZE,
+		DESC_HDR_TYPE_COMMON_NONSNOOP_NO_AFEU | DESC_HDR_SEL0_DEU |
+			DESC_HDR_MODE0_DEU_CBC | DESC_HDR_MODE0_DEU_3DES),
 };
 
 int talitos_register_skcipher(struct device *dev)
@@ -386,12 +344,6 @@ int talitos_register_skcipher(struct device *dev)
 		if (has_ftr_sec1(priv))
 			alg->cra_alignmask = 3;
 
-		skcipher_alg->init = talitos_cra_init_skcipher;
-		skcipher_alg->exit = talitos_cra_exit_skcipher;
-		skcipher_alg->setkey = skcipher_alg->setkey ?: skcipher_setkey;
-		skcipher_alg->encrypt = skcipher_encrypt;
-		skcipher_alg->decrypt = skcipher_decrypt;
-
 		if (!strcmp(alg->cra_name, "ctr(aes)") && !has_ftr_sec1(priv) &&
 		    DESC_TYPE(talitos_alg_template.desc_hdr_template) !=
 			    DESC_TYPE(DESC_HDR_TYPE_AESU_CTR_NONSNOOP)) {

-- 
2.55.0

