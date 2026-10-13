Received: from smtpout-03.galae.net (smtpout-03.galae.net [185.246.85.4])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B00565013A9;
	Tue, 13 Oct 2026 13:12:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.246.85.4
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791897156; cv=none; b=YJNrb4xwze1J/sYmjUice+eX5FDpraKNe+U6qKApHDDz4fCTGEz/2wh/2F8M5L33MpqoLU8VC21l8+CwHu5/8RBw99TBZ2HgFw/OloFwBvsL8JTSDm7lw5ZexXDsw2nC80bcTZCw9TAlu8G5RsfYk08N6FEeIE3sQ3QaByhzYQc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791897156; c=relaxed/simple;
	bh=FCRQlNF32AvvnBoVC4KlScM8ApXVc5COnUq54vWOsbY=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=g2JZ+fDB+JysCFazL5htHKyBAz4Ry01KnRmGeXgeMm4yta2OOeXLM10vtEyzmgg9Q149C8ohEFdHsSj32fClMUz1eVQXE7W9O6hit96WZUoebQrs2Pehzp3Dxqe/Etb9LV/Z8NovND0wYB1M431HQdEqExvV3rWmBN93wDcm6zM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bootlin.com; spf=pass smtp.mailfrom=bootlin.com; dkim=pass (2048-bit key) header.d=bootlin.com header.i=@bootlin.com header.b=0eE7ATI9; arc=none smtp.client-ip=185.246.85.4
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bootlin.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bootlin.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bootlin.com header.i=@bootlin.com header.b="0eE7ATI9"
Received: from smtpout-01.galae.net (smtpout-01.galae.net [212.83.139.233])
	by smtpout-03.galae.net (Postfix) with ESMTPS id 4704A4E41209;
	Tue, 13 Oct 2026 13:12:33 +0000 (UTC)
Received: from mail.galae.net (mail.galae.net [212.83.136.155])
	by smtpout-01.galae.net (Postfix) with ESMTPS id 16EDC60362;
	Tue, 13 Oct 2026 13:12:33 +0000 (UTC)
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id 7211111D71253;
	Tue, 13 Oct 2026 15:12:31 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=dkim;
	t=1791897152; h=from:subject:date:message-id:to:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references;
	bh=pwIbgBjmuYRUrnS8G2jUAUEWB3rPhvONDl1eF9vspDQ=;
	b=0eE7ATI9FK/dlnZlrEwCU0dqvdst+A5m89Q7UkEjJ68TtP/6CLhvEVC1SLtp5Qyp3gmHGM
	faxlQ2E1TMkmcG8HHFHSY5gAFqnUhXykTKBVWtNyyUApXPFLs1rNlUO7/SXn8fJCnzAuca
	CqXo1NcNUQeMxyM+cBPFq/hWtm4u9lJvH98Jm3m7JdwGv5cfV68xZgMAe0XCwwWsCDyfzv
	RWWWj6cnGtmlzNO9j07Pz9+/IW+HWMzPtSn3+M8xfGgUF1WEsrhMTZjklQIVB1Rkck68Ke
	cYhaf0MSRm3GOmrCz3IXIAX4PwIc1KhGXAEuTi02RdWRw3o+zqcDSkxnTvwbTg==
From: Paul Louvel <paul.louvel@bootlin.com>
Date: Tue, 13 Oct 2026 15:11:40 +0200
Subject: [PATCH v8 14/20] crypto: talitos/skcipher - Use macro for
 algorithm definitions
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261013-7-3-rc2_talitos_cleanup-v8-14-ca02be17696b@bootlin.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1791897108; l=9109;
 i=paul.louvel@bootlin.com; s=20260313; h=from:subject:message-id;
 bh=FCRQlNF32AvvnBoVC4KlScM8ApXVc5COnUq54vWOsbY=;
 b=QI1nyQ5kLTxZjogjKGvzzyp5BITYyd1vF4tbTnAnMHjlXe5Cgoxn8qqO16tgdBJvv/iehqZbf
 Ee2TaqqJAMfAq+8oxySu3hM5T7azBN6qGy8Dd9SI6LjkO9q2wogPqUL
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
2.56.0

