Received: from smtpout-03.galae.net (smtpout-03.galae.net [185.246.85.4])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B35C4EBAF1
	for <linux-crypto@vger.kernel.org>; Mon,  7 Sep 2026 13:23:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.246.85.4
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788787427; cv=none; b=KHGmgG0VngMaNqSRTX/hg+Z0gb2ElDD+nHFREAddqSKu+dBYOz0BhyUUa1zezwD74NDtL4kiuig3GBW4QrpMEh4p+CQBG6DTiMvUMkHXoBubfwsAmj0RBIB6pRQNQGZk7NTysnIUXJhCCTYx9hV9eVCad/PfrHD7CILOZsHASFQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788787427; c=relaxed/simple;
	bh=omYJ9qYzU/QEfBStHEzGw53Ud0NO18760mQ77Yxhzgs=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=HXFBF6K/1maR5SzFcvSRf4PD93avmFOlHg1MCSacs6uiYb5Hdt6EsiTmJFLGmUjCxA06Q9RYxhnbC1diftRY2BK35zSina7KeK4PtNMwCDGgQvwWJcmymc+a0YSKG1b6i6aRg+ChJcpmOzNRB0HgItM+EBbfNw3vPcqcpzoHCf8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bootlin.com; spf=pass smtp.mailfrom=bootlin.com; dkim=pass (2048-bit key) header.d=bootlin.com header.i=@bootlin.com header.b=ROZUYLZD; arc=none smtp.client-ip=185.246.85.4
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bootlin.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bootlin.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bootlin.com header.i=@bootlin.com header.b="ROZUYLZD"
Received: from smtpout-01.galae.net (smtpout-01.galae.net [212.83.139.233])
	by smtpout-03.galae.net (Postfix) with ESMTPS id 57F844E4156E;
	Mon,  7 Sep 2026 13:23:38 +0000 (UTC)
Received: from mail.galae.net (mail.galae.net [212.83.136.155])
	by smtpout-01.galae.net (Postfix) with ESMTPS id 2D44260383;
	Mon,  7 Sep 2026 13:23:38 +0000 (UTC)
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id EBFF711C7AF1D;
	Mon,  7 Sep 2026 15:23:32 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=dkim;
	t=1788787413; h=from:subject:date:message-id:to:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references;
	bh=lSLvkGWLl5t5FA6v8LOlMVengpBcacv7JAWtziZeGX8=;
	b=ROZUYLZD4Aj6VYxZFGRenkyeuPi17QfS9P1rTwqiTDM+2AJ1aw1DBJYyNyGzcaDtkReDGS
	GoUrv625cMJyEQmo0uEdKprzmnVounSUQotUb/JbHyMZREWpcbTZnJEwiTEMZAcMqDXfPb
	VGGaS6Cpq43kyt8ayKMdeF7+y4AbsrhX0s0C8ES2A+lZ2MtG1CYsxDGbivnDNruGDP1IFC
	jHc/SL22Nb0IGHxxsUaxh4kbmlQy+hDUV7tml5f1MbisDcNLjItnEtm46nJixIrYxX2Hen
	Z5QrtEH++8bBoVjwXZ7Dt+UXrSzMZovN8Eav60YPiy6YrBoMRUxPelw8QBSkpA==
From: Paul Louvel <paul.louvel@bootlin.com>
Date: Mon, 07 Sep 2026 15:22:46 +0200
Subject: [PATCH v5 12/19] crypto: talitos - Remove alg settings in
 talitos_register_common()
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260907-7-1-rc1_talitos_cleanup-v5-12-860f43cd7317@bootlin.com>
References: <20260907-7-1-rc1_talitos_cleanup-v5-0-860f43cd7317@bootlin.com>
In-Reply-To: <20260907-7-1-rc1_talitos_cleanup-v5-0-860f43cd7317@bootlin.com>
To: Herbert Xu <herbert@gondor.apana.org.au>, 
 "David S. Miller" <davem@davemloft.net>
Cc: Thomas Petazzoni <thomas.petazzoni@bootlin.com>, 
 Herve Codina <herve.codina@bootlin.com>, 
 Christophe Leroy <chleroy@kernel.org>, linux-crypto@vger.kernel.org, 
 linux-kernel@vger.kernel.org, Paul Louvel <paul.louvel@bootlin.com>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1788787387; l=22584;
 i=paul.louvel@bootlin.com; s=20260313; h=from:subject:message-id;
 bh=omYJ9qYzU/QEfBStHEzGw53Ud0NO18760mQ77Yxhzgs=;
 b=GtECWhVDQaGjGxmHbq87JeDb47FE3Mq+hvlFSf64rvInp9oO7DKSHB75vy1kkAWfnB0KlreyN
 Rj85w6a/72uDqSBCUpnEfPNd451PjiuJjZJ+muHrliVjt0m3lVwaibe
X-Developer-Key: i=paul.louvel@bootlin.com; a=ed25519;
 pk=eLW50NT18UAvUT5cAcYf88zNbBCZDLFXuptpyLVhVIU=
X-Last-TLS-Session-Version: TLSv1.3

Algorithm properties are now set at compile time for those who are not
dependent on runtime features.
Remove now-unused function and struct member.
---
 drivers/crypto/talitos/talitos-aead.c | 128 ++++++++++++++++++++++++++--------
 drivers/crypto/talitos/talitos-hash.c |  72 +++++++++++++++----
 drivers/crypto/talitos/talitos.c      |  23 ------
 drivers/crypto/talitos/talitos.h      |   1 -
 4 files changed, 160 insertions(+), 64 deletions(-)

diff --git a/drivers/crypto/talitos/talitos-aead.c b/drivers/crypto/talitos/talitos-aead.c
index 40d048de0502..0504b8575e26 100644
--- a/drivers/crypto/talitos/talitos-aead.c
+++ b/drivers/crypto/talitos/talitos-aead.c
@@ -413,7 +413,11 @@ static const struct talitos_alg_template aead_driver_algs[] = {
 				.cra_driver_name = "authenc-hmac-sha1-"
 						   "cbc-aes-talitos",
 				.cra_blocksize = AES_BLOCK_SIZE,
-				.cra_flags = CRYPTO_ALG_ASYNC |
+				.cra_module = THIS_MODULE,
+				.cra_priority = TALITOS_CRA_PRIORITY,
+				.cra_ctxsize = sizeof(struct talitos_ctx),
+				.cra_flags = CRYPTO_ALG_KERN_DRIVER_ONLY |
+					     CRYPTO_ALG_ASYNC |
 					     CRYPTO_ALG_ALLOCATES_MEMORY,
 			},
 			.ivsize = AES_BLOCK_SIZE,
@@ -428,14 +432,17 @@ static const struct talitos_alg_template aead_driver_algs[] = {
 				     DESC_HDR_MODE1_MDEU_SHA1_HMAC,
 	},
 	{	.type = CRYPTO_ALG_TYPE_AEAD,
-		.priority = TALITOS_CRA_PRIORITY_AEAD_HSNA,
 		.alg.aead = {
 			.base = {
 				.cra_name = "authenc(hmac(sha1),cbc(aes))",
 				.cra_driver_name = "authenc-hmac-sha1-"
 						   "cbc-aes-talitos-hsna",
 				.cra_blocksize = AES_BLOCK_SIZE,
-				.cra_flags = CRYPTO_ALG_ASYNC |
+				.cra_module = THIS_MODULE,
+				.cra_priority = TALITOS_CRA_PRIORITY_AEAD_HSNA,
+				.cra_ctxsize = sizeof(struct talitos_ctx),
+				.cra_flags = CRYPTO_ALG_KERN_DRIVER_ONLY |
+					     CRYPTO_ALG_ASYNC |
 					     CRYPTO_ALG_ALLOCATES_MEMORY,
 			},
 			.ivsize = AES_BLOCK_SIZE,
@@ -457,7 +464,11 @@ static const struct talitos_alg_template aead_driver_algs[] = {
 				.cra_driver_name = "authenc-hmac-sha1-"
 						   "cbc-3des-talitos",
 				.cra_blocksize = DES3_EDE_BLOCK_SIZE,
-				.cra_flags = CRYPTO_ALG_ASYNC |
+				.cra_module = THIS_MODULE,
+				.cra_priority = TALITOS_CRA_PRIORITY,
+				.cra_ctxsize = sizeof(struct talitos_ctx),
+				.cra_flags = CRYPTO_ALG_KERN_DRIVER_ONLY |
+					     CRYPTO_ALG_ASYNC |
 					     CRYPTO_ALG_ALLOCATES_MEMORY,
 			},
 			.ivsize = DES3_EDE_BLOCK_SIZE,
@@ -474,7 +485,6 @@ static const struct talitos_alg_template aead_driver_algs[] = {
 				     DESC_HDR_MODE1_MDEU_SHA1_HMAC,
 	},
 	{	.type = CRYPTO_ALG_TYPE_AEAD,
-		.priority = TALITOS_CRA_PRIORITY_AEAD_HSNA,
 		.alg.aead = {
 			.base = {
 				.cra_name = "authenc(hmac(sha1),"
@@ -482,7 +492,11 @@ static const struct talitos_alg_template aead_driver_algs[] = {
 				.cra_driver_name = "authenc-hmac-sha1-"
 						   "cbc-3des-talitos-hsna",
 				.cra_blocksize = DES3_EDE_BLOCK_SIZE,
-				.cra_flags = CRYPTO_ALG_ASYNC |
+				.cra_module = THIS_MODULE,
+				.cra_priority = TALITOS_CRA_PRIORITY_AEAD_HSNA,
+				.cra_ctxsize = sizeof(struct talitos_ctx),
+				.cra_flags = CRYPTO_ALG_KERN_DRIVER_ONLY |
+					     CRYPTO_ALG_ASYNC |
 					     CRYPTO_ALG_ALLOCATES_MEMORY,
 			},
 			.ivsize = DES3_EDE_BLOCK_SIZE,
@@ -505,7 +519,11 @@ static const struct talitos_alg_template aead_driver_algs[] = {
 				.cra_driver_name = "authenc-hmac-sha224-"
 						   "cbc-aes-talitos",
 				.cra_blocksize = AES_BLOCK_SIZE,
-				.cra_flags = CRYPTO_ALG_ASYNC |
+				.cra_module = THIS_MODULE,
+				.cra_priority = TALITOS_CRA_PRIORITY,
+				.cra_ctxsize = sizeof(struct talitos_ctx),
+				.cra_flags = CRYPTO_ALG_KERN_DRIVER_ONLY |
+					     CRYPTO_ALG_ASYNC |
 					     CRYPTO_ALG_ALLOCATES_MEMORY,
 			},
 			.ivsize = AES_BLOCK_SIZE,
@@ -520,14 +538,17 @@ static const struct talitos_alg_template aead_driver_algs[] = {
 				     DESC_HDR_MODE1_MDEU_SHA224_HMAC,
 	},
 	{       .type = CRYPTO_ALG_TYPE_AEAD,
-		.priority = TALITOS_CRA_PRIORITY_AEAD_HSNA,
 		.alg.aead = {
 			.base = {
 				.cra_name = "authenc(hmac(sha224),cbc(aes))",
 				.cra_driver_name = "authenc-hmac-sha224-"
 						   "cbc-aes-talitos-hsna",
 				.cra_blocksize = AES_BLOCK_SIZE,
-				.cra_flags = CRYPTO_ALG_ASYNC |
+				.cra_module = THIS_MODULE,
+				.cra_priority = TALITOS_CRA_PRIORITY_AEAD_HSNA,
+				.cra_ctxsize = sizeof(struct talitos_ctx),
+				.cra_flags = CRYPTO_ALG_KERN_DRIVER_ONLY |
+					     CRYPTO_ALG_ASYNC |
 					     CRYPTO_ALG_ALLOCATES_MEMORY,
 			},
 			.ivsize = AES_BLOCK_SIZE,
@@ -549,7 +570,11 @@ static const struct talitos_alg_template aead_driver_algs[] = {
 				.cra_driver_name = "authenc-hmac-sha224-"
 						   "cbc-3des-talitos",
 				.cra_blocksize = DES3_EDE_BLOCK_SIZE,
-				.cra_flags = CRYPTO_ALG_ASYNC |
+				.cra_module = THIS_MODULE,
+				.cra_priority = TALITOS_CRA_PRIORITY,
+				.cra_ctxsize = sizeof(struct talitos_ctx),
+				.cra_flags = CRYPTO_ALG_KERN_DRIVER_ONLY |
+					     CRYPTO_ALG_ASYNC |
 					     CRYPTO_ALG_ALLOCATES_MEMORY,
 			},
 			.ivsize = DES3_EDE_BLOCK_SIZE,
@@ -566,7 +591,6 @@ static const struct talitos_alg_template aead_driver_algs[] = {
 				     DESC_HDR_MODE1_MDEU_SHA224_HMAC,
 	},
 	{	.type = CRYPTO_ALG_TYPE_AEAD,
-		.priority = TALITOS_CRA_PRIORITY_AEAD_HSNA,
 		.alg.aead = {
 			.base = {
 				.cra_name = "authenc(hmac(sha224),"
@@ -574,7 +598,11 @@ static const struct talitos_alg_template aead_driver_algs[] = {
 				.cra_driver_name = "authenc-hmac-sha224-"
 						   "cbc-3des-talitos-hsna",
 				.cra_blocksize = DES3_EDE_BLOCK_SIZE,
-				.cra_flags = CRYPTO_ALG_ASYNC |
+				.cra_module = THIS_MODULE,
+				.cra_priority = TALITOS_CRA_PRIORITY_AEAD_HSNA,
+				.cra_ctxsize = sizeof(struct talitos_ctx),
+				.cra_flags = CRYPTO_ALG_KERN_DRIVER_ONLY |
+					     CRYPTO_ALG_ASYNC |
 					     CRYPTO_ALG_ALLOCATES_MEMORY,
 			},
 			.ivsize = DES3_EDE_BLOCK_SIZE,
@@ -597,7 +625,11 @@ static const struct talitos_alg_template aead_driver_algs[] = {
 				.cra_driver_name = "authenc-hmac-sha256-"
 						   "cbc-aes-talitos",
 				.cra_blocksize = AES_BLOCK_SIZE,
-				.cra_flags = CRYPTO_ALG_ASYNC |
+				.cra_module = THIS_MODULE,
+				.cra_priority = TALITOS_CRA_PRIORITY,
+				.cra_ctxsize = sizeof(struct talitos_ctx),
+				.cra_flags = CRYPTO_ALG_KERN_DRIVER_ONLY |
+					     CRYPTO_ALG_ASYNC |
 					     CRYPTO_ALG_ALLOCATES_MEMORY,
 			},
 			.ivsize = AES_BLOCK_SIZE,
@@ -612,14 +644,17 @@ static const struct talitos_alg_template aead_driver_algs[] = {
 				     DESC_HDR_MODE1_MDEU_SHA256_HMAC,
 	},
 	{	.type = CRYPTO_ALG_TYPE_AEAD,
-		.priority = TALITOS_CRA_PRIORITY_AEAD_HSNA,
 		.alg.aead = {
 			.base = {
 				.cra_name = "authenc(hmac(sha256),cbc(aes))",
 				.cra_driver_name = "authenc-hmac-sha256-"
 						   "cbc-aes-talitos-hsna",
 				.cra_blocksize = AES_BLOCK_SIZE,
-				.cra_flags = CRYPTO_ALG_ASYNC |
+				.cra_module = THIS_MODULE,
+				.cra_priority = TALITOS_CRA_PRIORITY_AEAD_HSNA,
+				.cra_ctxsize = sizeof(struct talitos_ctx),
+				.cra_flags = CRYPTO_ALG_KERN_DRIVER_ONLY |
+					     CRYPTO_ALG_ASYNC |
 					     CRYPTO_ALG_ALLOCATES_MEMORY,
 			},
 			.ivsize = AES_BLOCK_SIZE,
@@ -641,7 +676,11 @@ static const struct talitos_alg_template aead_driver_algs[] = {
 				.cra_driver_name = "authenc-hmac-sha256-"
 						   "cbc-3des-talitos",
 				.cra_blocksize = DES3_EDE_BLOCK_SIZE,
-				.cra_flags = CRYPTO_ALG_ASYNC |
+				.cra_module = THIS_MODULE,
+				.cra_priority = TALITOS_CRA_PRIORITY,
+				.cra_ctxsize = sizeof(struct talitos_ctx),
+				.cra_flags = CRYPTO_ALG_KERN_DRIVER_ONLY |
+					     CRYPTO_ALG_ASYNC |
 					     CRYPTO_ALG_ALLOCATES_MEMORY,
 			},
 			.ivsize = DES3_EDE_BLOCK_SIZE,
@@ -658,7 +697,6 @@ static const struct talitos_alg_template aead_driver_algs[] = {
 				     DESC_HDR_MODE1_MDEU_SHA256_HMAC,
 	},
 	{	.type = CRYPTO_ALG_TYPE_AEAD,
-		.priority = TALITOS_CRA_PRIORITY_AEAD_HSNA,
 		.alg.aead = {
 			.base = {
 				.cra_name = "authenc(hmac(sha256),"
@@ -666,7 +704,11 @@ static const struct talitos_alg_template aead_driver_algs[] = {
 				.cra_driver_name = "authenc-hmac-sha256-"
 						   "cbc-3des-talitos-hsna",
 				.cra_blocksize = DES3_EDE_BLOCK_SIZE,
-				.cra_flags = CRYPTO_ALG_ASYNC |
+				.cra_module = THIS_MODULE,
+				.cra_priority = TALITOS_CRA_PRIORITY_AEAD_HSNA,
+				.cra_ctxsize = sizeof(struct talitos_ctx),
+				.cra_flags = CRYPTO_ALG_KERN_DRIVER_ONLY |
+					     CRYPTO_ALG_ASYNC |
 					     CRYPTO_ALG_ALLOCATES_MEMORY,
 			},
 			.ivsize = DES3_EDE_BLOCK_SIZE,
@@ -689,7 +731,11 @@ static const struct talitos_alg_template aead_driver_algs[] = {
 				.cra_driver_name = "authenc-hmac-sha384-"
 						   "cbc-aes-talitos",
 				.cra_blocksize = AES_BLOCK_SIZE,
-				.cra_flags = CRYPTO_ALG_ASYNC |
+				.cra_module = THIS_MODULE,
+				.cra_priority = TALITOS_CRA_PRIORITY,
+				.cra_ctxsize = sizeof(struct talitos_ctx),
+				.cra_flags = CRYPTO_ALG_KERN_DRIVER_ONLY |
+					     CRYPTO_ALG_ASYNC |
 					     CRYPTO_ALG_ALLOCATES_MEMORY,
 			},
 			.ivsize = AES_BLOCK_SIZE,
@@ -711,7 +757,11 @@ static const struct talitos_alg_template aead_driver_algs[] = {
 				.cra_driver_name = "authenc-hmac-sha384-"
 						   "cbc-3des-talitos",
 				.cra_blocksize = DES3_EDE_BLOCK_SIZE,
-				.cra_flags = CRYPTO_ALG_ASYNC |
+				.cra_module = THIS_MODULE,
+				.cra_priority = TALITOS_CRA_PRIORITY,
+				.cra_ctxsize = sizeof(struct talitos_ctx),
+				.cra_flags = CRYPTO_ALG_KERN_DRIVER_ONLY |
+					     CRYPTO_ALG_ASYNC |
 					     CRYPTO_ALG_ALLOCATES_MEMORY,
 			},
 			.ivsize = DES3_EDE_BLOCK_SIZE,
@@ -734,7 +784,11 @@ static const struct talitos_alg_template aead_driver_algs[] = {
 				.cra_driver_name = "authenc-hmac-sha512-"
 						   "cbc-aes-talitos",
 				.cra_blocksize = AES_BLOCK_SIZE,
-				.cra_flags = CRYPTO_ALG_ASYNC |
+				.cra_module = THIS_MODULE,
+				.cra_priority = TALITOS_CRA_PRIORITY,
+				.cra_ctxsize = sizeof(struct talitos_ctx),
+				.cra_flags = CRYPTO_ALG_KERN_DRIVER_ONLY |
+					     CRYPTO_ALG_ASYNC |
 					     CRYPTO_ALG_ALLOCATES_MEMORY,
 			},
 			.ivsize = AES_BLOCK_SIZE,
@@ -756,7 +810,11 @@ static const struct talitos_alg_template aead_driver_algs[] = {
 				.cra_driver_name = "authenc-hmac-sha512-"
 						   "cbc-3des-talitos",
 				.cra_blocksize = DES3_EDE_BLOCK_SIZE,
-				.cra_flags = CRYPTO_ALG_ASYNC |
+				.cra_module = THIS_MODULE,
+				.cra_priority = TALITOS_CRA_PRIORITY,
+				.cra_ctxsize = sizeof(struct talitos_ctx),
+				.cra_flags = CRYPTO_ALG_KERN_DRIVER_ONLY |
+					     CRYPTO_ALG_ASYNC |
 					     CRYPTO_ALG_ALLOCATES_MEMORY,
 			},
 			.ivsize = DES3_EDE_BLOCK_SIZE,
@@ -779,7 +837,11 @@ static const struct talitos_alg_template aead_driver_algs[] = {
 				.cra_driver_name = "authenc-hmac-md5-"
 						   "cbc-aes-talitos",
 				.cra_blocksize = AES_BLOCK_SIZE,
-				.cra_flags = CRYPTO_ALG_ASYNC |
+				.cra_module = THIS_MODULE,
+				.cra_priority = TALITOS_CRA_PRIORITY,
+				.cra_ctxsize = sizeof(struct talitos_ctx),
+				.cra_flags = CRYPTO_ALG_KERN_DRIVER_ONLY |
+					     CRYPTO_ALG_ASYNC |
 					     CRYPTO_ALG_ALLOCATES_MEMORY,
 			},
 			.ivsize = AES_BLOCK_SIZE,
@@ -794,14 +856,17 @@ static const struct talitos_alg_template aead_driver_algs[] = {
 				     DESC_HDR_MODE1_MDEU_MD5_HMAC,
 	},
 	{	.type = CRYPTO_ALG_TYPE_AEAD,
-		.priority = TALITOS_CRA_PRIORITY_AEAD_HSNA,
 		.alg.aead = {
 			.base = {
 				.cra_name = "authenc(hmac(md5),cbc(aes))",
 				.cra_driver_name = "authenc-hmac-md5-"
 						   "cbc-aes-talitos-hsna",
 				.cra_blocksize = AES_BLOCK_SIZE,
-				.cra_flags = CRYPTO_ALG_ASYNC |
+				.cra_module = THIS_MODULE,
+				.cra_priority = TALITOS_CRA_PRIORITY_AEAD_HSNA,
+				.cra_ctxsize = sizeof(struct talitos_ctx),
+				.cra_flags = CRYPTO_ALG_KERN_DRIVER_ONLY |
+					     CRYPTO_ALG_ASYNC |
 					     CRYPTO_ALG_ALLOCATES_MEMORY,
 			},
 			.ivsize = AES_BLOCK_SIZE,
@@ -822,7 +887,11 @@ static const struct talitos_alg_template aead_driver_algs[] = {
 				.cra_driver_name = "authenc-hmac-md5-"
 						   "cbc-3des-talitos",
 				.cra_blocksize = DES3_EDE_BLOCK_SIZE,
-				.cra_flags = CRYPTO_ALG_ASYNC |
+				.cra_module = THIS_MODULE,
+				.cra_priority = TALITOS_CRA_PRIORITY,
+				.cra_ctxsize = sizeof(struct talitos_ctx),
+				.cra_flags = CRYPTO_ALG_KERN_DRIVER_ONLY |
+					     CRYPTO_ALG_ASYNC |
 					     CRYPTO_ALG_ALLOCATES_MEMORY,
 			},
 			.ivsize = DES3_EDE_BLOCK_SIZE,
@@ -839,14 +908,17 @@ static const struct talitos_alg_template aead_driver_algs[] = {
 				     DESC_HDR_MODE1_MDEU_MD5_HMAC,
 	},
 	{	.type = CRYPTO_ALG_TYPE_AEAD,
-		.priority = TALITOS_CRA_PRIORITY_AEAD_HSNA,
 		.alg.aead = {
 			.base = {
 				.cra_name = "authenc(hmac(md5),cbc(des3_ede))",
 				.cra_driver_name = "authenc-hmac-md5-"
 						   "cbc-3des-talitos-hsna",
 				.cra_blocksize = DES3_EDE_BLOCK_SIZE,
-				.cra_flags = CRYPTO_ALG_ASYNC |
+				.cra_module = THIS_MODULE,
+				.cra_priority = TALITOS_CRA_PRIORITY_AEAD_HSNA,
+				.cra_ctxsize = sizeof(struct talitos_ctx),
+				.cra_flags = CRYPTO_ALG_KERN_DRIVER_ONLY |
+					     CRYPTO_ALG_ASYNC |
 					     CRYPTO_ALG_ALLOCATES_MEMORY,
 			},
 			.ivsize = DES3_EDE_BLOCK_SIZE,
diff --git a/drivers/crypto/talitos/talitos-hash.c b/drivers/crypto/talitos/talitos-hash.c
index 4224563ac701..3cfa739dab64 100644
--- a/drivers/crypto/talitos/talitos-hash.c
+++ b/drivers/crypto/talitos/talitos-hash.c
@@ -571,7 +571,11 @@ static const struct talitos_alg_template hash_driver_algs[] = {
 				.cra_driver_name = "md5-talitos",
 				.cra_blocksize = MD5_HMAC_BLOCK_SIZE,
 				.cra_reqsize = sizeof(struct talitos_ahash_req_ctx),
-				.cra_flags = CRYPTO_ALG_ASYNC |
+				.cra_module = THIS_MODULE,
+				.cra_priority = TALITOS_CRA_PRIORITY,
+				.cra_ctxsize = sizeof(struct talitos_ctx),
+				.cra_flags = CRYPTO_ALG_KERN_DRIVER_ONLY |
+					     CRYPTO_ALG_ASYNC |
 					     CRYPTO_ALG_ALLOCATES_MEMORY |
 					     CRYPTO_AHASH_ALG_BLOCK_ONLY,
 			}
@@ -589,7 +593,11 @@ static const struct talitos_alg_template hash_driver_algs[] = {
 				.cra_driver_name = "sha1-talitos",
 				.cra_blocksize = SHA1_BLOCK_SIZE,
 				.cra_reqsize = sizeof(struct talitos_ahash_req_ctx),
-				.cra_flags = CRYPTO_ALG_ASYNC |
+				.cra_module = THIS_MODULE,
+				.cra_priority = TALITOS_CRA_PRIORITY,
+				.cra_ctxsize = sizeof(struct talitos_ctx),
+				.cra_flags = CRYPTO_ALG_KERN_DRIVER_ONLY |
+					     CRYPTO_ALG_ASYNC |
 					     CRYPTO_ALG_ALLOCATES_MEMORY |
 					     CRYPTO_AHASH_ALG_BLOCK_ONLY,
 			}
@@ -607,7 +615,11 @@ static const struct talitos_alg_template hash_driver_algs[] = {
 				.cra_driver_name = "sha224-talitos",
 				.cra_blocksize = SHA224_BLOCK_SIZE,
 				.cra_reqsize = sizeof(struct talitos_ahash_req_ctx),
-				.cra_flags = CRYPTO_ALG_ASYNC |
+				.cra_module = THIS_MODULE,
+				.cra_priority = TALITOS_CRA_PRIORITY,
+				.cra_ctxsize = sizeof(struct talitos_ctx),
+				.cra_flags = CRYPTO_ALG_KERN_DRIVER_ONLY |
+					     CRYPTO_ALG_ASYNC |
 					     CRYPTO_ALG_ALLOCATES_MEMORY |
 					     CRYPTO_AHASH_ALG_BLOCK_ONLY,
 			}
@@ -625,7 +637,11 @@ static const struct talitos_alg_template hash_driver_algs[] = {
 				.cra_driver_name = "sha256-talitos",
 				.cra_blocksize = SHA256_BLOCK_SIZE,
 				.cra_reqsize = sizeof(struct talitos_ahash_req_ctx),
-				.cra_flags = CRYPTO_ALG_ASYNC |
+				.cra_module = THIS_MODULE,
+				.cra_priority = TALITOS_CRA_PRIORITY,
+				.cra_ctxsize = sizeof(struct talitos_ctx),
+				.cra_flags = CRYPTO_ALG_KERN_DRIVER_ONLY |
+					     CRYPTO_ALG_ASYNC |
 					     CRYPTO_ALG_ALLOCATES_MEMORY |
 					     CRYPTO_AHASH_ALG_BLOCK_ONLY,
 			}
@@ -643,7 +659,11 @@ static const struct talitos_alg_template hash_driver_algs[] = {
 				.cra_driver_name = "sha384-talitos",
 				.cra_blocksize = SHA384_BLOCK_SIZE,
 				.cra_reqsize = sizeof(struct talitos_ahash_req_ctx),
-				.cra_flags = CRYPTO_ALG_ASYNC |
+				.cra_module = THIS_MODULE,
+				.cra_priority = TALITOS_CRA_PRIORITY,
+				.cra_ctxsize = sizeof(struct talitos_ctx),
+				.cra_flags = CRYPTO_ALG_KERN_DRIVER_ONLY |
+					     CRYPTO_ALG_ASYNC |
 					     CRYPTO_ALG_ALLOCATES_MEMORY |
 					     CRYPTO_AHASH_ALG_BLOCK_ONLY,
 			}
@@ -661,7 +681,11 @@ static const struct talitos_alg_template hash_driver_algs[] = {
 				.cra_driver_name = "sha512-talitos",
 				.cra_blocksize = SHA512_BLOCK_SIZE,
 				.cra_reqsize = sizeof(struct talitos_ahash_req_ctx),
-				.cra_flags = CRYPTO_ALG_ASYNC |
+				.cra_module = THIS_MODULE,
+				.cra_priority = TALITOS_CRA_PRIORITY,
+				.cra_ctxsize = sizeof(struct talitos_ctx),
+				.cra_flags = CRYPTO_ALG_KERN_DRIVER_ONLY |
+					     CRYPTO_ALG_ASYNC |
 					     CRYPTO_ALG_ALLOCATES_MEMORY |
 					     CRYPTO_AHASH_ALG_BLOCK_ONLY,
 			}
@@ -679,7 +703,11 @@ static const struct talitos_alg_template hash_driver_algs[] = {
 				.cra_driver_name = "hmac-md5-talitos",
 				.cra_blocksize = MD5_HMAC_BLOCK_SIZE,
 				.cra_reqsize = sizeof(struct talitos_ahash_req_ctx),
-				.cra_flags = CRYPTO_ALG_ASYNC |
+				.cra_module = THIS_MODULE,
+				.cra_priority = TALITOS_CRA_PRIORITY,
+				.cra_ctxsize = sizeof(struct talitos_ctx),
+				.cra_flags = CRYPTO_ALG_KERN_DRIVER_ONLY |
+					     CRYPTO_ALG_ASYNC |
 					     CRYPTO_ALG_ALLOCATES_MEMORY |
 					     CRYPTO_AHASH_ALG_BLOCK_ONLY,
 			}
@@ -697,7 +725,11 @@ static const struct talitos_alg_template hash_driver_algs[] = {
 				.cra_driver_name = "hmac-sha1-talitos",
 				.cra_blocksize = SHA1_BLOCK_SIZE,
 				.cra_reqsize = sizeof(struct talitos_ahash_req_ctx),
-				.cra_flags = CRYPTO_ALG_ASYNC |
+				.cra_module = THIS_MODULE,
+				.cra_priority = TALITOS_CRA_PRIORITY,
+				.cra_ctxsize = sizeof(struct talitos_ctx),
+				.cra_flags = CRYPTO_ALG_KERN_DRIVER_ONLY |
+					     CRYPTO_ALG_ASYNC |
 					     CRYPTO_ALG_ALLOCATES_MEMORY |
 					     CRYPTO_AHASH_ALG_BLOCK_ONLY,
 			}
@@ -715,7 +747,11 @@ static const struct talitos_alg_template hash_driver_algs[] = {
 				.cra_driver_name = "hmac-sha224-talitos",
 				.cra_blocksize = SHA224_BLOCK_SIZE,
 				.cra_reqsize = sizeof(struct talitos_ahash_req_ctx),
-				.cra_flags = CRYPTO_ALG_ASYNC |
+				.cra_module = THIS_MODULE,
+				.cra_priority = TALITOS_CRA_PRIORITY,
+				.cra_ctxsize = sizeof(struct talitos_ctx),
+				.cra_flags = CRYPTO_ALG_KERN_DRIVER_ONLY |
+					     CRYPTO_ALG_ASYNC |
 					     CRYPTO_ALG_ALLOCATES_MEMORY |
 					     CRYPTO_AHASH_ALG_BLOCK_ONLY,
 			}
@@ -733,7 +769,11 @@ static const struct talitos_alg_template hash_driver_algs[] = {
 				.cra_driver_name = "hmac-sha256-talitos",
 				.cra_blocksize = SHA256_BLOCK_SIZE,
 				.cra_reqsize = sizeof(struct talitos_ahash_req_ctx),
-				.cra_flags = CRYPTO_ALG_ASYNC |
+				.cra_module = THIS_MODULE,
+				.cra_priority = TALITOS_CRA_PRIORITY,
+				.cra_ctxsize = sizeof(struct talitos_ctx),
+				.cra_flags = CRYPTO_ALG_KERN_DRIVER_ONLY |
+					     CRYPTO_ALG_ASYNC |
 					     CRYPTO_ALG_ALLOCATES_MEMORY |
 					     CRYPTO_AHASH_ALG_BLOCK_ONLY,
 			}
@@ -751,7 +791,11 @@ static const struct talitos_alg_template hash_driver_algs[] = {
 				.cra_driver_name = "hmac-sha384-talitos",
 				.cra_blocksize = SHA384_BLOCK_SIZE,
 				.cra_reqsize = sizeof(struct talitos_ahash_req_ctx),
-				.cra_flags = CRYPTO_ALG_ASYNC |
+				.cra_module = THIS_MODULE,
+				.cra_priority = TALITOS_CRA_PRIORITY,
+				.cra_ctxsize = sizeof(struct talitos_ctx),
+				.cra_flags = CRYPTO_ALG_KERN_DRIVER_ONLY |
+					     CRYPTO_ALG_ASYNC |
 					     CRYPTO_ALG_ALLOCATES_MEMORY |
 					     CRYPTO_AHASH_ALG_BLOCK_ONLY,
 			}
@@ -769,7 +813,11 @@ static const struct talitos_alg_template hash_driver_algs[] = {
 				.cra_driver_name = "hmac-sha512-talitos",
 				.cra_blocksize = SHA512_BLOCK_SIZE,
 				.cra_reqsize = sizeof(struct talitos_ahash_req_ctx),
-				.cra_flags = CRYPTO_ALG_ASYNC |
+				.cra_module = THIS_MODULE,
+				.cra_priority = TALITOS_CRA_PRIORITY,
+				.cra_ctxsize = sizeof(struct talitos_ctx),
+				.cra_flags = CRYPTO_ALG_KERN_DRIVER_ONLY |
+					     CRYPTO_ALG_ASYNC |
 					     CRYPTO_ALG_ALLOCATES_MEMORY |
 					     CRYPTO_AHASH_ALG_BLOCK_ONLY,
 			}
diff --git a/drivers/crypto/talitos/talitos.c b/drivers/crypto/talitos/talitos.c
index 52ff5ef46fb6..ff938cc4e837 100644
--- a/drivers/crypto/talitos/talitos.c
+++ b/drivers/crypto/talitos/talitos.c
@@ -1040,23 +1040,6 @@ static void talitos_remove(struct platform_device *ofdev)
 		tasklet_kill(&priv->done_task[1]);
 }
 
-static void talitos_alg_set_common(struct talitos_private *priv,
-				   struct crypto_alg *alg, u32 custom_priority,
-				   u32 type)
-{
-	alg->cra_module = THIS_MODULE;
-	if (custom_priority)
-		alg->cra_priority = custom_priority;
-	else
-		alg->cra_priority = TALITOS_CRA_PRIORITY;
-	if (has_ftr_sec1(priv) && type != CRYPTO_ALG_TYPE_AHASH)
-		alg->cra_alignmask = 3;
-	else
-		alg->cra_alignmask = 0;
-	alg->cra_ctxsize = sizeof(struct talitos_ctx);
-	alg->cra_flags |= CRYPTO_ALG_KERN_DRIVER_ONLY;
-}
-
 int talitos_register_common(struct device *dev,
 			    struct talitos_alg_template *template)
 {
@@ -1075,20 +1058,14 @@ int talitos_register_common(struct device *dev,
 	switch (t_alg->algt.type) {
 	case CRYPTO_ALG_TYPE_AHASH:
 		alg = &t_alg->algt.alg.hash.halg.base;
-		talitos_alg_set_common(priv, alg, t_alg->algt.priority,
-				       t_alg->algt.type);
 		ret = crypto_register_ahash(&t_alg->algt.alg.hash);
 		break;
 	case CRYPTO_ALG_TYPE_SKCIPHER:
 		alg = &t_alg->algt.alg.skcipher.base;
-		talitos_alg_set_common(priv, alg, t_alg->algt.priority,
-				       t_alg->algt.type);
 		ret = crypto_register_skcipher(&t_alg->algt.alg.skcipher);
 		break;
 	case CRYPTO_ALG_TYPE_AEAD:
 		alg = &t_alg->algt.alg.aead.base;
-		talitos_alg_set_common(priv, alg, t_alg->algt.priority,
-				       t_alg->algt.type);
 		ret = crypto_register_aead(&t_alg->algt.alg.aead);
 		break;
 	default:
diff --git a/drivers/crypto/talitos/talitos.h b/drivers/crypto/talitos/talitos.h
index 8aa3102e9935..c2fc71282c0b 100644
--- a/drivers/crypto/talitos/talitos.h
+++ b/drivers/crypto/talitos/talitos.h
@@ -203,7 +203,6 @@ struct talitos_ctx {
 
 struct talitos_alg_template {
 	u32 type;
-	u32 priority;
 	union {
 		struct skcipher_alg skcipher;
 		struct ahash_alg hash;

-- 
2.55.0

