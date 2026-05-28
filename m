Received: from smtpout-02.galae.net (smtpout-02.galae.net [185.246.84.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F33963AD51C
	for <linux-crypto@vger.kernel.org>; Thu, 28 May 2026 09:09:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.246.84.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779959385; cv=none; b=BHCG4oNDgGg5kRjY4MT0R0O8QimZ8l8Q5s2hk5bayageOP9wwaASoquHOJntjwoj76Hjclw03kGE7tXuSj8ILcbN+unlWORcOmLlwyb9z24SPB8UsotCm34uLWTqnzJcwrOB17iool6GnlrU/pe5t3PZcJEkmZGO22CBOH32fpU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779959385; c=relaxed/simple;
	bh=hhYsVanrXyzb+tob9dsvLMayir9e1H6WeaRtwq4PGpc=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=QakJnEQ6ug+1HN0Z/lhR41ckOxnde5QH2CIGlU3L/6Z/DmuBVMLa726uL5XNc0A7W5t88CWt/eVUrOOkkQPNwou55EPtRjEHLxFF8tVKsQ2/YAmWvQVWDtnGCLaDZUoENB2RMyitqzMrs2prFrhyFySMJjcciHU3xA6eKYUzkcg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bootlin.com; spf=pass smtp.mailfrom=bootlin.com; dkim=pass (2048-bit key) header.d=bootlin.com header.i=@bootlin.com header.b=w11IxH+r; arc=none smtp.client-ip=185.246.84.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bootlin.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bootlin.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bootlin.com header.i=@bootlin.com header.b="w11IxH+r"
Received: from smtpout-01.galae.net (smtpout-01.galae.net [212.83.139.233])
	by smtpout-02.galae.net (Postfix) with ESMTPS id 8E77A1A36FC;
	Thu, 28 May 2026 09:09:40 +0000 (UTC)
Received: from mail.galae.net (mail.galae.net [212.83.136.155])
	by smtpout-01.galae.net (Postfix) with ESMTPS id 5DE8460495;
	Thu, 28 May 2026 09:09:40 +0000 (UTC)
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id 9F0FB10888CA6;
	Thu, 28 May 2026 11:09:38 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=dkim;
	t=1779959379; h=from:subject:date:message-id:to:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references;
	bh=nK7aLxnbgh2LvF1eUah5cZDWiub2DETCbV8lSv4qK9A=;
	b=w11IxH+rqWWfMa8VJWT1f/bu4vPgkYIGamAJ4uaC+LRU3/W+SFatIjQ9AQVYJL1ZHe2wSw
	4Y4IX2esSN3e0Z/3iszFIVnPnfwzG+UiBOr3MuP37FRp1gigG32HQSZWgEzsyXtRKXi+4g
	RhgMnIJ5IjzjkC607mo69iwyetNo+wcp9bzEz/SPImO/+FmyRDUZvTas5LbDKf+Jm7BByu
	WH0EtWYdKesNUe08v10oZubyhCifeIPw9WmcRwz/sbrtL//K8OVyXMZs/EnYh4eVM38Gqp
	geOswRV7DFwB8iPLym/MK2LB3fF5Jhme5VN2y4oYtiazNrkST1nV6VAdQ2gajg==
From: Paul Louvel <paul.louvel@bootlin.com>
Date: Thu, 28 May 2026 11:08:29 +0200
Subject: [PATCH 16/29] crypto: talitos/skcipher - Use macro for algorithm
 definitions
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260528-7-1-rc1_talitos_cleanup-v1-16-cb1ad6cdea49@bootlin.com>
References: <20260528-7-1-rc1_talitos_cleanup-v1-0-cb1ad6cdea49@bootlin.com>
In-Reply-To: <20260528-7-1-rc1_talitos_cleanup-v1-0-cb1ad6cdea49@bootlin.com>
To: Herbert Xu <herbert@gondor.apana.org.au>, 
 "David S. Miller" <davem@davemloft.net>
Cc: Thomas Petazzoni <thomas.petazzoni@bootlin.com>, 
 Herve Codina <herve.codina@bootlin.com>, 
 Christophe Leroy <chleroy@kernel.org>, linux-crypto@vger.kernel.org, 
 linux-kernel@vger.kernel.org, Paul Louvel <paul.louvel@bootlin.com>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1779959350; l=10554;
 i=paul.louvel@bootlin.com; s=20260313; h=from:subject:message-id;
 bh=hhYsVanrXyzb+tob9dsvLMayir9e1H6WeaRtwq4PGpc=;
 b=vCLBVrzpd6R+m4A5P/LlaJZoo2i6bXY7rq1W3uNae1UyBt+Uj+fl1he+XEET2jeDRp2T3cpmS
 wC2T0+BKYH/CIwmT5l9UAJnR++dnxkDmq/laPcABjogEzPTcXYxboNH
X-Developer-Key: i=paul.louvel@bootlin.com; a=ed25519;
 pk=eLW50NT18UAvUT5cAcYf88zNbBCZDLFXuptpyLVhVIU=
X-Last-TLS-Session-Version: TLSv1.3

Replace the repetitive struct initializer entries in
skcipher_driver_algs[] with preprocessor macros
(TALITOS_SKCIPHER_ALG_AES, TALITOS_SKCIPHER_ALG_DES,
TALITOS_SKCIPHER_ALG_DES3).

Move the function pointer assignments (init, exit, encrypt, decrypt)
from the registration loop into the static initializer, since they are
identical for all algorithms.

The fallback setkey assignment (skcipher_alg->setkey ?: skcipher_setkey)
is no longer needed because each macro specifies the correct setkey
handler directly.

Signed-off-by: Paul Louvel <paul.louvel@bootlin.com>
---
 drivers/crypto/talitos/talitos-skcipher.c | 244 ++++++++++--------------------
 1 file changed, 82 insertions(+), 162 deletions(-)

diff --git a/drivers/crypto/talitos/talitos-skcipher.c b/drivers/crypto/talitos/talitos-skcipher.c
index f86a0a9a0ffe..b12191243aae 100644
--- a/drivers/crypto/talitos/talitos-skcipher.c
+++ b/drivers/crypto/talitos/talitos-skcipher.c
@@ -237,163 +237,89 @@ static void talitos_cra_exit_skcipher(struct crypto_skcipher *tfm)
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
-					  CRYPTO_ALG_ALLOCATES_MEMORY |
-					  CRYPTO_ALG_KERN_DRIVER_ONLY,
-			.base.cra_priority = TALITOS_CRA_PRIORITY,
-			.base.cra_ctxsize = sizeof(struct talitos_ctx),
-			.base.cra_module = THIS_MODULE,
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
-					  CRYPTO_ALG_ALLOCATES_MEMORY |
-					  CRYPTO_ALG_KERN_DRIVER_ONLY,
-			.base.cra_priority = TALITOS_CRA_PRIORITY,
-			.base.cra_ctxsize = sizeof(struct talitos_ctx),
-			.base.cra_module = THIS_MODULE,
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
-					  CRYPTO_ALG_ALLOCATES_MEMORY |
-					  CRYPTO_ALG_KERN_DRIVER_ONLY,
-			.base.cra_priority = TALITOS_CRA_PRIORITY,
-			.base.cra_ctxsize = sizeof(struct talitos_ctx),
-			.base.cra_module = THIS_MODULE,
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
-					  CRYPTO_ALG_ALLOCATES_MEMORY |
-					  CRYPTO_ALG_KERN_DRIVER_ONLY,
-			.base.cra_priority = TALITOS_CRA_PRIORITY,
-			.base.cra_ctxsize = sizeof(struct talitos_ctx),
-			.base.cra_module = THIS_MODULE,
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
-					  CRYPTO_ALG_ALLOCATES_MEMORY |
-					  CRYPTO_ALG_KERN_DRIVER_ONLY,
-			.base.cra_priority = TALITOS_CRA_PRIORITY,
-			.base.cra_ctxsize = sizeof(struct talitos_ctx),
-			.base.cra_module = THIS_MODULE,
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
-					  CRYPTO_ALG_ALLOCATES_MEMORY |
-					  CRYPTO_ALG_KERN_DRIVER_ONLY,
-			.base.cra_priority = TALITOS_CRA_PRIORITY,
-			.base.cra_ctxsize = sizeof(struct talitos_ctx),
-			.base.cra_module = THIS_MODULE,
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
-					  CRYPTO_ALG_ALLOCATES_MEMORY |
-					  CRYPTO_ALG_KERN_DRIVER_ONLY,
-			.base.cra_priority = TALITOS_CRA_PRIORITY,
-			.base.cra_ctxsize = sizeof(struct talitos_ctx),
-			.base.cra_module = THIS_MODULE,
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
-					  CRYPTO_ALG_ALLOCATES_MEMORY |
-					  CRYPTO_ALG_KERN_DRIVER_ONLY,
-			.base.cra_priority = TALITOS_CRA_PRIORITY,
-			.base.cra_ctxsize = sizeof(struct talitos_ctx),
-			.base.cra_module = THIS_MODULE,
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
@@ -415,12 +341,6 @@ int talitos_register_skcipher(struct device *dev)
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
2.54.0

