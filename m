Received: from smtpout-02.galae.net (smtpout-02.galae.net [185.246.84.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E60150E5BB;
	Tue, 13 Oct 2026 13:12:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.246.84.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791897154; cv=none; b=unqSWys7n96HM2fmkRVQyuJX841wyVnmAsCOd/KaWNyOBcozg2R8ZTSungzLt44IFnD30h9Jtpw3Qvy9Ay6ds/NdoPjH3ars0xx0Nq+dDRHT7V0urwwh+e2k5aRLcf4qoNg492ypdQBr/47OdPjc5tqa9BpdBjhLMdTIekSfES4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791897154; c=relaxed/simple;
	bh=8ZUs9HDg66lMYSqZGIp+Mt18ruVw27G+rzMvgIaQeeA=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=dyCxBN3hwN0vQLGbnIJWrvsG1qvXQDbsq8fQMfMrhMn/MswDYkYzHeAg79aK0sDWMl4P9Vd0Vigvf8WnoAX7QT0H2pg5L2AMz/oZmmsMB2eQGCIrTQMGHr8CH1ZE/PvxwnB4hlh7XNODfBLZCvM4PDxAftoi8Eo3rNKdLOWhdg4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bootlin.com; spf=pass smtp.mailfrom=bootlin.com; dkim=pass (2048-bit key) header.d=bootlin.com header.i=@bootlin.com header.b=xisFaJwi; arc=none smtp.client-ip=185.246.84.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bootlin.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bootlin.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bootlin.com header.i=@bootlin.com header.b="xisFaJwi"
Received: from smtpout-01.galae.net (smtpout-01.galae.net [212.83.139.233])
	by smtpout-02.galae.net (Postfix) with ESMTPS id 0D74D1A1215;
	Tue, 13 Oct 2026 13:12:31 +0000 (UTC)
Received: from mail.galae.net (mail.galae.net [212.83.136.155])
	by smtpout-01.galae.net (Postfix) with ESMTPS id D40A760362;
	Tue, 13 Oct 2026 13:12:30 +0000 (UTC)
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id A1EE311D713AB;
	Tue, 13 Oct 2026 15:12:29 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=dkim;
	t=1791897150; h=from:subject:date:message-id:to:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references;
	bh=MnbUq/AzltFoAWJ+7dVMpmWSLXir0lYJFpLADOszq3U=;
	b=xisFaJwixYUdt8ezx3dUCnDhaJEo5Z8Ap30fJxIwVipTVH2sTZ/7B4LpFftdQFDle/+v5o
	bj22OQuOR/teClVpWpKDXwT9vMKXGrxazWjNlNjP7l4O5OyKqg+p3PVCIhoJVD4QEIrBjK
	ysbIA8F3YIMb5YoEq9z5L/X7ajs8sngH682rEV1Rn27X1PBpbpIDh76e/SZi9bS27fd/QD
	egRy3qXqgvMc+D92OC4aJTOXt7FE0Ekm4KGz6Yj6dhzfC7jgokcg+gSomUbsh9blKngM8h
	ngPlN5m8Y9DqQ+XtaxCXmyQDiatVuzMWAUI56DorB1h9w40PjAzBH5AOuceNSA==
From: Paul Louvel <paul.louvel@bootlin.com>
Date: Tue, 13 Oct 2026 15:11:38 +0200
Subject: [PATCH v8 12/20] crypto: talitos - Remove alg settings in
 talitos_register_common()
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261013-7-3-rc2_talitos_cleanup-v8-12-ca02be17696b@bootlin.com>
References: <20261013-7-3-rc2_talitos_cleanup-v8-0-ca02be17696b@bootlin.com>
In-Reply-To: <20261013-7-3-rc2_talitos_cleanup-v8-0-ca02be17696b@bootlin.com>
To: Herbert Xu <herbert@gondor.apana.org.au>, 
 "David S. Miller" <davem@davemloft.net>
Cc: Paul Louvel <paul.louvel@bootlin.com>, linux-crypto@vger.kernel.org, 
 linux-kernel@vger.kernel.org, 
 Thomas Petazzoni <thomas.petazzoni@bootlin.com>, 
 Christophe Leroy <chleroy@kernel.org>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1791897108; l=22604;
 i=paul.louvel@bootlin.com; s=20260313; h=from:subject:message-id;
 bh=8ZUs9HDg66lMYSqZGIp+Mt18ruVw27G+rzMvgIaQeeA=;
 b=p9y3HIDLtuRrbuXddOB8nTGnuHby3DIy08I94+4R991M7bBiPwNL/NPBYBCOdcW9OieBk0Xnt
 cpHpPm6doJ1BY8wtOjSIN3kI9o8yLcoWgvMMsyl/43o1A1bBhnCxFnV
X-Developer-Key: i=paul.louvel@bootlin.com; a=ed25519;
 pk=eLW50NT18UAvUT5cAcYf88zNbBCZDLFXuptpyLVhVIU=
X-Last-TLS-Session-Version: TLSv1.3

Algorithm properties are now set at compile time for those who are not
dependent on runtime features.
Remove now-unused function and struct member.
---
 drivers/crypto/talitos/talitos-aead.c | 128 ++++++++++++++++++++++++++--------
 drivers/crypto/talitos/talitos-core.c |  23 ------
 drivers/crypto/talitos/talitos-hash.c |  72 +++++++++++++++----
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
diff --git a/drivers/crypto/talitos/talitos-core.c b/drivers/crypto/talitos/talitos-core.c
index c4e8499a8178..4aba0379b4dc 100644
--- a/drivers/crypto/talitos/talitos-core.c
+++ b/drivers/crypto/talitos/talitos-core.c
@@ -1038,23 +1038,6 @@ static void talitos_remove(struct platform_device *ofdev)
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
@@ -1074,20 +1057,14 @@ int talitos_register_common(struct device *dev,
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
diff --git a/drivers/crypto/talitos/talitos-hash.c b/drivers/crypto/talitos/talitos-hash.c
index 1564e5ca918d..3efe434586eb 100644
--- a/drivers/crypto/talitos/talitos-hash.c
+++ b/drivers/crypto/talitos/talitos-hash.c
@@ -576,7 +576,11 @@ static const struct talitos_alg_template hash_driver_algs[] = {
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
@@ -594,7 +598,11 @@ static const struct talitos_alg_template hash_driver_algs[] = {
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
@@ -612,7 +620,11 @@ static const struct talitos_alg_template hash_driver_algs[] = {
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
@@ -630,7 +642,11 @@ static const struct talitos_alg_template hash_driver_algs[] = {
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
@@ -648,7 +664,11 @@ static const struct talitos_alg_template hash_driver_algs[] = {
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
@@ -666,7 +686,11 @@ static const struct talitos_alg_template hash_driver_algs[] = {
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
@@ -684,7 +708,11 @@ static const struct talitos_alg_template hash_driver_algs[] = {
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
@@ -702,7 +730,11 @@ static const struct talitos_alg_template hash_driver_algs[] = {
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
@@ -720,7 +752,11 @@ static const struct talitos_alg_template hash_driver_algs[] = {
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
@@ -738,7 +774,11 @@ static const struct talitos_alg_template hash_driver_algs[] = {
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
@@ -756,7 +796,11 @@ static const struct talitos_alg_template hash_driver_algs[] = {
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
@@ -774,7 +818,11 @@ static const struct talitos_alg_template hash_driver_algs[] = {
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
2.56.0

