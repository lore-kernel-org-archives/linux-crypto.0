Received: from smtpout-04.galae.net (smtpout-04.galae.net [185.171.202.116])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 886633AA4E0;
	Thu, 28 May 2026 09:09:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.171.202.116
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779959378; cv=none; b=rDHDwNtZJcZz8eGcjQtRDKqjlg079nSdYhM/LJ8DgqGgD3GTZgJWelEHQxWGEd7yQ1xbvB0Sp+ONSidw/NWgmorPtzJXyLyTD1tieR53V6Nif3I5LiniTCH7HTicguVj7W5KtXw2FKMLtlAN55zxhyrF403kBFK8LzQirwhXDzE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779959378; c=relaxed/simple;
	bh=23qauHN6MqNQaOfYdnWzJ9I7zLJbxiyOIHAcimo8oAY=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=QpeVp6ehtXcze0wQkyua6PPNDRTkim/qLpSBUoaoZaizea0kqKErood9tUArEzCiM2LotY1PXAC15bi6IZ6W+sTu78UlLajk/xEJNykm3Pn8Ybc5+/9QuG+xoG/ZGzZWxQmlYdLcpf2h9Hw88wEyjNUG1ewxGAZszmMllKkAG5g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bootlin.com; spf=pass smtp.mailfrom=bootlin.com; dkim=pass (2048-bit key) header.d=bootlin.com header.i=@bootlin.com header.b=cGBNGq7f; arc=none smtp.client-ip=185.171.202.116
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bootlin.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bootlin.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bootlin.com header.i=@bootlin.com header.b="cGBNGq7f"
Received: from smtpout-01.galae.net (smtpout-01.galae.net [212.83.139.233])
	by smtpout-04.galae.net (Postfix) with ESMTPS id 9CC82C62445;
	Thu, 28 May 2026 09:09:32 +0000 (UTC)
Received: from mail.galae.net (mail.galae.net [212.83.136.155])
	by smtpout-01.galae.net (Postfix) with ESMTPS id 7368960495;
	Thu, 28 May 2026 09:09:32 +0000 (UTC)
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id E665610888CAB;
	Thu, 28 May 2026 11:09:30 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=dkim;
	t=1779959371; h=from:subject:date:message-id:to:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references;
	bh=233BQJqCuUoeXW8rbfAPDCIwm0S+paFXSEusAbBZBKs=;
	b=cGBNGq7fDj6oIVxuDieh2p799Uc9cYhLLsWL2DH5YXqOHlR+kPrx9SLPEykEQKxqF2UHlj
	mj2gTkmWTi5mI0rVGCX+jcqEaU+9T84npAZGJJFwVbfN2liugwir4p39lncQSHMpmzCZ4T
	vohT5UVpFu6uc9Fq34xu0KXU/dG86RrEgDp8XFS9toivBU6xLr738wkPCqk3K2PEKxKgkn
	xUxSKDCrNUptxAs97rypAL1xtrByTwOn7+64h0RT4hnybTkDabMX4nJNeEhNlDpQ7Vjpd0
	DfdfJhtkafArrUBuv5v6Am2Fdovvvn/7E854jx5c5oItgbPMz5ZEK/uIyZyA3g==
From: Paul Louvel <paul.louvel@bootlin.com>
Date: Thu, 28 May 2026 11:08:23 +0200
Subject: [PATCH 10/29] crypto: talitos - Remove alg settings in
 talitos_register_common()
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260528-7-1-rc1_talitos_cleanup-v1-10-cb1ad6cdea49@bootlin.com>
References: <20260528-7-1-rc1_talitos_cleanup-v1-0-cb1ad6cdea49@bootlin.com>
In-Reply-To: <20260528-7-1-rc1_talitos_cleanup-v1-0-cb1ad6cdea49@bootlin.com>
To: Herbert Xu <herbert@gondor.apana.org.au>, 
 "David S. Miller" <davem@davemloft.net>
Cc: Thomas Petazzoni <thomas.petazzoni@bootlin.com>, 
 Herve Codina <herve.codina@bootlin.com>, 
 Christophe Leroy <chleroy@kernel.org>, linux-crypto@vger.kernel.org, 
 linux-kernel@vger.kernel.org, Paul Louvel <paul.louvel@bootlin.com>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1779959350; l=28223;
 i=paul.louvel@bootlin.com; s=20260313; h=from:subject:message-id;
 bh=23qauHN6MqNQaOfYdnWzJ9I7zLJbxiyOIHAcimo8oAY=;
 b=TGKLzRUJZzDGwawxuxV+1RFsyDQLRh2jl8PkrR029QWq2Xjgxs1xmd3h2aTdvmvZzhUmYHtZL
 gUOYT0oKg3vDjEGBWfhMuZ9sQ1TzLUJoIa9hd9TZOvlFUyctZsjQYR0
X-Developer-Key: i=paul.louvel@bootlin.com; a=ed25519;
 pk=eLW50NT18UAvUT5cAcYf88zNbBCZDLFXuptpyLVhVIU=
X-Last-TLS-Session-Version: TLSv1.3

Algorithm properties should be set at definition time.

Signed-off-by: Paul Louvel <paul.louvel@bootlin.com>
---
 drivers/crypto/talitos/talitos-aead.c     | 131 +++++++++++++++++++++++-------
 drivers/crypto/talitos/talitos-hash.c     |  72 +++++++++++++---
 drivers/crypto/talitos/talitos-skcipher.c |  51 ++++++++++--
 drivers/crypto/talitos/talitos.c          |  23 ------
 4 files changed, 206 insertions(+), 71 deletions(-)

diff --git a/drivers/crypto/talitos/talitos-aead.c b/drivers/crypto/talitos/talitos-aead.c
index ce6bd6133fd0..c09ed08be2ef 100644
--- a/drivers/crypto/talitos/talitos-aead.c
+++ b/drivers/crypto/talitos/talitos-aead.c
@@ -409,7 +409,11 @@ static struct talitos_alg_template aead_driver_algs[] = {
 						   "cbc-aes-talitos",
 				.cra_blocksize = AES_BLOCK_SIZE,
 				.cra_flags = CRYPTO_ALG_ASYNC |
-					     CRYPTO_ALG_ALLOCATES_MEMORY,
+					     CRYPTO_ALG_ALLOCATES_MEMORY |
+					     CRYPTO_ALG_KERN_DRIVER_ONLY,
+				.cra_priority = TALITOS_CRA_PRIORITY,
+				.cra_ctxsize = sizeof(struct talitos_ctx),
+				.cra_module = THIS_MODULE,
 			},
 			.ivsize = AES_BLOCK_SIZE,
 			.maxauthsize = SHA1_DIGEST_SIZE,
@@ -423,7 +427,6 @@ static struct talitos_alg_template aead_driver_algs[] = {
 				     DESC_HDR_MODE1_MDEU_SHA1_HMAC,
 	},
 	{	.type = CRYPTO_ALG_TYPE_AEAD,
-		.priority = TALITOS_CRA_PRIORITY_AEAD_HSNA,
 		.alg.aead = {
 			.base = {
 				.cra_name = "authenc(hmac(sha1),cbc(aes))",
@@ -431,7 +434,11 @@ static struct talitos_alg_template aead_driver_algs[] = {
 						   "cbc-aes-talitos-hsna",
 				.cra_blocksize = AES_BLOCK_SIZE,
 				.cra_flags = CRYPTO_ALG_ASYNC |
-					     CRYPTO_ALG_ALLOCATES_MEMORY,
+					     CRYPTO_ALG_ALLOCATES_MEMORY |
+					     CRYPTO_ALG_KERN_DRIVER_ONLY,
+				.cra_priority = TALITOS_CRA_PRIORITY_AEAD_HSNA,
+				.cra_ctxsize = sizeof(struct talitos_ctx),
+				.cra_module = THIS_MODULE,
 			},
 			.ivsize = AES_BLOCK_SIZE,
 			.maxauthsize = SHA1_DIGEST_SIZE,
@@ -453,7 +460,11 @@ static struct talitos_alg_template aead_driver_algs[] = {
 						   "cbc-3des-talitos",
 				.cra_blocksize = DES3_EDE_BLOCK_SIZE,
 				.cra_flags = CRYPTO_ALG_ASYNC |
-					     CRYPTO_ALG_ALLOCATES_MEMORY,
+					     CRYPTO_ALG_ALLOCATES_MEMORY |
+					     CRYPTO_ALG_KERN_DRIVER_ONLY,
+				.cra_priority = TALITOS_CRA_PRIORITY,
+				.cra_ctxsize = sizeof(struct talitos_ctx),
+				.cra_module = THIS_MODULE,
 			},
 			.ivsize = DES3_EDE_BLOCK_SIZE,
 			.maxauthsize = SHA1_DIGEST_SIZE,
@@ -469,7 +480,6 @@ static struct talitos_alg_template aead_driver_algs[] = {
 				     DESC_HDR_MODE1_MDEU_SHA1_HMAC,
 	},
 	{	.type = CRYPTO_ALG_TYPE_AEAD,
-		.priority = TALITOS_CRA_PRIORITY_AEAD_HSNA,
 		.alg.aead = {
 			.base = {
 				.cra_name = "authenc(hmac(sha1),"
@@ -478,7 +488,11 @@ static struct talitos_alg_template aead_driver_algs[] = {
 						   "cbc-3des-talitos-hsna",
 				.cra_blocksize = DES3_EDE_BLOCK_SIZE,
 				.cra_flags = CRYPTO_ALG_ASYNC |
-					     CRYPTO_ALG_ALLOCATES_MEMORY,
+					     CRYPTO_ALG_ALLOCATES_MEMORY |
+					     CRYPTO_ALG_KERN_DRIVER_ONLY,
+				.cra_priority = TALITOS_CRA_PRIORITY_AEAD_HSNA,
+				.cra_ctxsize = sizeof(struct talitos_ctx),
+				.cra_module = THIS_MODULE,
 			},
 			.ivsize = DES3_EDE_BLOCK_SIZE,
 			.maxauthsize = SHA1_DIGEST_SIZE,
@@ -501,7 +515,11 @@ static struct talitos_alg_template aead_driver_algs[] = {
 						   "cbc-aes-talitos",
 				.cra_blocksize = AES_BLOCK_SIZE,
 				.cra_flags = CRYPTO_ALG_ASYNC |
-					     CRYPTO_ALG_ALLOCATES_MEMORY,
+					     CRYPTO_ALG_ALLOCATES_MEMORY |
+					     CRYPTO_ALG_KERN_DRIVER_ONLY,
+				.cra_priority = TALITOS_CRA_PRIORITY,
+				.cra_ctxsize = sizeof(struct talitos_ctx),
+				.cra_module = THIS_MODULE,
 			},
 			.ivsize = AES_BLOCK_SIZE,
 			.maxauthsize = SHA224_DIGEST_SIZE,
@@ -515,7 +533,6 @@ static struct talitos_alg_template aead_driver_algs[] = {
 				     DESC_HDR_MODE1_MDEU_SHA224_HMAC,
 	},
 	{       .type = CRYPTO_ALG_TYPE_AEAD,
-		.priority = TALITOS_CRA_PRIORITY_AEAD_HSNA,
 		.alg.aead = {
 			.base = {
 				.cra_name = "authenc(hmac(sha224),cbc(aes))",
@@ -523,7 +540,11 @@ static struct talitos_alg_template aead_driver_algs[] = {
 						   "cbc-aes-talitos-hsna",
 				.cra_blocksize = AES_BLOCK_SIZE,
 				.cra_flags = CRYPTO_ALG_ASYNC |
-					     CRYPTO_ALG_ALLOCATES_MEMORY,
+					     CRYPTO_ALG_ALLOCATES_MEMORY |
+					     CRYPTO_ALG_KERN_DRIVER_ONLY,
+				.cra_priority = TALITOS_CRA_PRIORITY_AEAD_HSNA,
+				.cra_ctxsize = sizeof(struct talitos_ctx),
+				.cra_module = THIS_MODULE,
 			},
 			.ivsize = AES_BLOCK_SIZE,
 			.maxauthsize = SHA224_DIGEST_SIZE,
@@ -545,7 +566,11 @@ static struct talitos_alg_template aead_driver_algs[] = {
 						   "cbc-3des-talitos",
 				.cra_blocksize = DES3_EDE_BLOCK_SIZE,
 				.cra_flags = CRYPTO_ALG_ASYNC |
-					     CRYPTO_ALG_ALLOCATES_MEMORY,
+					     CRYPTO_ALG_ALLOCATES_MEMORY |
+					     CRYPTO_ALG_KERN_DRIVER_ONLY,
+				.cra_priority = TALITOS_CRA_PRIORITY,
+				.cra_ctxsize = sizeof(struct talitos_ctx),
+				.cra_module = THIS_MODULE,
 			},
 			.ivsize = DES3_EDE_BLOCK_SIZE,
 			.maxauthsize = SHA224_DIGEST_SIZE,
@@ -561,7 +586,6 @@ static struct talitos_alg_template aead_driver_algs[] = {
 				     DESC_HDR_MODE1_MDEU_SHA224_HMAC,
 	},
 	{	.type = CRYPTO_ALG_TYPE_AEAD,
-		.priority = TALITOS_CRA_PRIORITY_AEAD_HSNA,
 		.alg.aead = {
 			.base = {
 				.cra_name = "authenc(hmac(sha224),"
@@ -570,7 +594,11 @@ static struct talitos_alg_template aead_driver_algs[] = {
 						   "cbc-3des-talitos-hsna",
 				.cra_blocksize = DES3_EDE_BLOCK_SIZE,
 				.cra_flags = CRYPTO_ALG_ASYNC |
-					     CRYPTO_ALG_ALLOCATES_MEMORY,
+					     CRYPTO_ALG_ALLOCATES_MEMORY |
+					     CRYPTO_ALG_KERN_DRIVER_ONLY,
+				.cra_priority = TALITOS_CRA_PRIORITY_AEAD_HSNA,
+				.cra_ctxsize = sizeof(struct talitos_ctx),
+				.cra_module = THIS_MODULE,
 			},
 			.ivsize = DES3_EDE_BLOCK_SIZE,
 			.maxauthsize = SHA224_DIGEST_SIZE,
@@ -593,7 +621,11 @@ static struct talitos_alg_template aead_driver_algs[] = {
 						   "cbc-aes-talitos",
 				.cra_blocksize = AES_BLOCK_SIZE,
 				.cra_flags = CRYPTO_ALG_ASYNC |
-					     CRYPTO_ALG_ALLOCATES_MEMORY,
+					     CRYPTO_ALG_ALLOCATES_MEMORY |
+					     CRYPTO_ALG_KERN_DRIVER_ONLY,
+				.cra_priority = TALITOS_CRA_PRIORITY,
+				.cra_ctxsize = sizeof(struct talitos_ctx),
+				.cra_module = THIS_MODULE,
 			},
 			.ivsize = AES_BLOCK_SIZE,
 			.maxauthsize = SHA256_DIGEST_SIZE,
@@ -607,7 +639,6 @@ static struct talitos_alg_template aead_driver_algs[] = {
 				     DESC_HDR_MODE1_MDEU_SHA256_HMAC,
 	},
 	{	.type = CRYPTO_ALG_TYPE_AEAD,
-		.priority = TALITOS_CRA_PRIORITY_AEAD_HSNA,
 		.alg.aead = {
 			.base = {
 				.cra_name = "authenc(hmac(sha256),cbc(aes))",
@@ -615,7 +646,11 @@ static struct talitos_alg_template aead_driver_algs[] = {
 						   "cbc-aes-talitos-hsna",
 				.cra_blocksize = AES_BLOCK_SIZE,
 				.cra_flags = CRYPTO_ALG_ASYNC |
-					     CRYPTO_ALG_ALLOCATES_MEMORY,
+					     CRYPTO_ALG_ALLOCATES_MEMORY |
+					     CRYPTO_ALG_KERN_DRIVER_ONLY,
+				.cra_priority = TALITOS_CRA_PRIORITY_AEAD_HSNA,
+				.cra_ctxsize = sizeof(struct talitos_ctx),
+				.cra_module = THIS_MODULE,
 			},
 			.ivsize = AES_BLOCK_SIZE,
 			.maxauthsize = SHA256_DIGEST_SIZE,
@@ -637,7 +672,11 @@ static struct talitos_alg_template aead_driver_algs[] = {
 						   "cbc-3des-talitos",
 				.cra_blocksize = DES3_EDE_BLOCK_SIZE,
 				.cra_flags = CRYPTO_ALG_ASYNC |
-					     CRYPTO_ALG_ALLOCATES_MEMORY,
+					     CRYPTO_ALG_ALLOCATES_MEMORY |
+					     CRYPTO_ALG_KERN_DRIVER_ONLY,
+				.cra_priority = TALITOS_CRA_PRIORITY,
+				.cra_ctxsize = sizeof(struct talitos_ctx),
+				.cra_module = THIS_MODULE,
 			},
 			.ivsize = DES3_EDE_BLOCK_SIZE,
 			.maxauthsize = SHA256_DIGEST_SIZE,
@@ -653,7 +692,6 @@ static struct talitos_alg_template aead_driver_algs[] = {
 				     DESC_HDR_MODE1_MDEU_SHA256_HMAC,
 	},
 	{	.type = CRYPTO_ALG_TYPE_AEAD,
-		.priority = TALITOS_CRA_PRIORITY_AEAD_HSNA,
 		.alg.aead = {
 			.base = {
 				.cra_name = "authenc(hmac(sha256),"
@@ -662,7 +700,11 @@ static struct talitos_alg_template aead_driver_algs[] = {
 						   "cbc-3des-talitos-hsna",
 				.cra_blocksize = DES3_EDE_BLOCK_SIZE,
 				.cra_flags = CRYPTO_ALG_ASYNC |
-					     CRYPTO_ALG_ALLOCATES_MEMORY,
+					     CRYPTO_ALG_ALLOCATES_MEMORY |
+					     CRYPTO_ALG_KERN_DRIVER_ONLY,
+				.cra_priority = TALITOS_CRA_PRIORITY_AEAD_HSNA,
+				.cra_ctxsize = sizeof(struct talitos_ctx),
+				.cra_module = THIS_MODULE,
 			},
 			.ivsize = DES3_EDE_BLOCK_SIZE,
 			.maxauthsize = SHA256_DIGEST_SIZE,
@@ -685,7 +727,11 @@ static struct talitos_alg_template aead_driver_algs[] = {
 						   "cbc-aes-talitos",
 				.cra_blocksize = AES_BLOCK_SIZE,
 				.cra_flags = CRYPTO_ALG_ASYNC |
-					     CRYPTO_ALG_ALLOCATES_MEMORY,
+					     CRYPTO_ALG_ALLOCATES_MEMORY |
+					     CRYPTO_ALG_KERN_DRIVER_ONLY,
+				.cra_priority = TALITOS_CRA_PRIORITY,
+				.cra_ctxsize = sizeof(struct talitos_ctx),
+				.cra_module = THIS_MODULE,
 			},
 			.ivsize = AES_BLOCK_SIZE,
 			.maxauthsize = SHA384_DIGEST_SIZE,
@@ -707,7 +753,11 @@ static struct talitos_alg_template aead_driver_algs[] = {
 						   "cbc-3des-talitos",
 				.cra_blocksize = DES3_EDE_BLOCK_SIZE,
 				.cra_flags = CRYPTO_ALG_ASYNC |
-					     CRYPTO_ALG_ALLOCATES_MEMORY,
+					     CRYPTO_ALG_ALLOCATES_MEMORY |
+					     CRYPTO_ALG_KERN_DRIVER_ONLY,
+				.cra_priority = TALITOS_CRA_PRIORITY,
+				.cra_ctxsize = sizeof(struct talitos_ctx),
+				.cra_module = THIS_MODULE,
 			},
 			.ivsize = DES3_EDE_BLOCK_SIZE,
 			.maxauthsize = SHA384_DIGEST_SIZE,
@@ -730,7 +780,11 @@ static struct talitos_alg_template aead_driver_algs[] = {
 						   "cbc-aes-talitos",
 				.cra_blocksize = AES_BLOCK_SIZE,
 				.cra_flags = CRYPTO_ALG_ASYNC |
-					     CRYPTO_ALG_ALLOCATES_MEMORY,
+					     CRYPTO_ALG_ALLOCATES_MEMORY |
+					     CRYPTO_ALG_KERN_DRIVER_ONLY,
+				.cra_priority = TALITOS_CRA_PRIORITY,
+				.cra_ctxsize = sizeof(struct talitos_ctx),
+				.cra_module = THIS_MODULE,
 			},
 			.ivsize = AES_BLOCK_SIZE,
 			.maxauthsize = SHA512_DIGEST_SIZE,
@@ -752,7 +806,11 @@ static struct talitos_alg_template aead_driver_algs[] = {
 						   "cbc-3des-talitos",
 				.cra_blocksize = DES3_EDE_BLOCK_SIZE,
 				.cra_flags = CRYPTO_ALG_ASYNC |
-					     CRYPTO_ALG_ALLOCATES_MEMORY,
+					     CRYPTO_ALG_ALLOCATES_MEMORY |
+					     CRYPTO_ALG_KERN_DRIVER_ONLY,
+				.cra_priority = TALITOS_CRA_PRIORITY,
+				.cra_ctxsize = sizeof(struct talitos_ctx),
+				.cra_module = THIS_MODULE,
 			},
 			.ivsize = DES3_EDE_BLOCK_SIZE,
 			.maxauthsize = SHA512_DIGEST_SIZE,
@@ -775,7 +833,11 @@ static struct talitos_alg_template aead_driver_algs[] = {
 						   "cbc-aes-talitos",
 				.cra_blocksize = AES_BLOCK_SIZE,
 				.cra_flags = CRYPTO_ALG_ASYNC |
-					     CRYPTO_ALG_ALLOCATES_MEMORY,
+					     CRYPTO_ALG_ALLOCATES_MEMORY |
+					     CRYPTO_ALG_KERN_DRIVER_ONLY,
+				.cra_priority = TALITOS_CRA_PRIORITY,
+				.cra_ctxsize = sizeof(struct talitos_ctx),
+				.cra_module = THIS_MODULE,
 			},
 			.ivsize = AES_BLOCK_SIZE,
 			.maxauthsize = MD5_DIGEST_SIZE,
@@ -789,7 +851,6 @@ static struct talitos_alg_template aead_driver_algs[] = {
 				     DESC_HDR_MODE1_MDEU_MD5_HMAC,
 	},
 	{	.type = CRYPTO_ALG_TYPE_AEAD,
-		.priority = TALITOS_CRA_PRIORITY_AEAD_HSNA,
 		.alg.aead = {
 			.base = {
 				.cra_name = "authenc(hmac(md5),cbc(aes))",
@@ -797,7 +858,11 @@ static struct talitos_alg_template aead_driver_algs[] = {
 						   "cbc-aes-talitos-hsna",
 				.cra_blocksize = AES_BLOCK_SIZE,
 				.cra_flags = CRYPTO_ALG_ASYNC |
-					     CRYPTO_ALG_ALLOCATES_MEMORY,
+					     CRYPTO_ALG_ALLOCATES_MEMORY |
+					     CRYPTO_ALG_KERN_DRIVER_ONLY,
+				.cra_priority = TALITOS_CRA_PRIORITY_AEAD_HSNA,
+				.cra_ctxsize = sizeof(struct talitos_ctx),
+				.cra_module = THIS_MODULE,
 			},
 			.ivsize = AES_BLOCK_SIZE,
 			.maxauthsize = MD5_DIGEST_SIZE,
@@ -818,7 +883,11 @@ static struct talitos_alg_template aead_driver_algs[] = {
 						   "cbc-3des-talitos",
 				.cra_blocksize = DES3_EDE_BLOCK_SIZE,
 				.cra_flags = CRYPTO_ALG_ASYNC |
-					     CRYPTO_ALG_ALLOCATES_MEMORY,
+					     CRYPTO_ALG_ALLOCATES_MEMORY |
+					     CRYPTO_ALG_KERN_DRIVER_ONLY,
+				.cra_priority = TALITOS_CRA_PRIORITY,
+				.cra_ctxsize = sizeof(struct talitos_ctx),
+				.cra_module = THIS_MODULE,
 			},
 			.ivsize = DES3_EDE_BLOCK_SIZE,
 			.maxauthsize = MD5_DIGEST_SIZE,
@@ -834,7 +903,6 @@ static struct talitos_alg_template aead_driver_algs[] = {
 				     DESC_HDR_MODE1_MDEU_MD5_HMAC,
 	},
 	{	.type = CRYPTO_ALG_TYPE_AEAD,
-		.priority = TALITOS_CRA_PRIORITY_AEAD_HSNA,
 		.alg.aead = {
 			.base = {
 				.cra_name = "authenc(hmac(md5),cbc(des3_ede))",
@@ -842,7 +910,11 @@ static struct talitos_alg_template aead_driver_algs[] = {
 						   "cbc-3des-talitos-hsna",
 				.cra_blocksize = DES3_EDE_BLOCK_SIZE,
 				.cra_flags = CRYPTO_ALG_ASYNC |
-					     CRYPTO_ALG_ALLOCATES_MEMORY,
+					     CRYPTO_ALG_ALLOCATES_MEMORY |
+					     CRYPTO_ALG_KERN_DRIVER_ONLY,
+				.cra_priority = TALITOS_CRA_PRIORITY_AEAD_HSNA,
+				.cra_ctxsize = sizeof(struct talitos_ctx),
+				.cra_module = THIS_MODULE,
 			},
 			.ivsize = DES3_EDE_BLOCK_SIZE,
 			.maxauthsize = MD5_DIGEST_SIZE,
@@ -875,6 +947,9 @@ int talitos_register_aead(struct device *dev)
 		aead_alg = &aead_driver_algs[i].alg.aead;
 		alg = &aead_alg->base;
 
+		if (has_ftr_sec1(priv))
+			alg->cra_alignmask = 3;
+
 		alg->cra_exit = talitos_cra_exit;
 		aead_alg->init = talitos_cra_init_aead;
 		aead_alg->setkey = aead_alg->setkey ?: aead_setkey;
diff --git a/drivers/crypto/talitos/talitos-hash.c b/drivers/crypto/talitos/talitos-hash.c
index 5792e7093392..3793b6fd5b75 100644
--- a/drivers/crypto/talitos/talitos-hash.c
+++ b/drivers/crypto/talitos/talitos-hash.c
@@ -559,8 +559,12 @@ static struct talitos_alg_template hash_driver_algs[] = {
 				.cra_reqsize = sizeof(struct talitos_ahash_req_ctx),
 				.cra_flags = CRYPTO_ALG_ASYNC |
 					     CRYPTO_ALG_ALLOCATES_MEMORY |
-					     CRYPTO_AHASH_ALG_BLOCK_ONLY |
+					     CRYPTO_ALG_KERN_DRIVER_ONLY |
+			     CRYPTO_AHASH_ALG_BLOCK_ONLY |
 					     CRYPTO_AHASH_ALG_FINAL_NONZERO,
+				.cra_priority = TALITOS_CRA_PRIORITY,
+				.cra_ctxsize = sizeof(struct talitos_ctx),
+				.cra_module = THIS_MODULE,
 			}
 		},
 		.desc_hdr_template = DESC_HDR_TYPE_COMMON_NONSNOOP_NO_AFEU |
@@ -578,8 +582,12 @@ static struct talitos_alg_template hash_driver_algs[] = {
 				.cra_reqsize = sizeof(struct talitos_ahash_req_ctx),
 				.cra_flags = CRYPTO_ALG_ASYNC |
 					     CRYPTO_ALG_ALLOCATES_MEMORY |
-					     CRYPTO_AHASH_ALG_BLOCK_ONLY |
+					     CRYPTO_ALG_KERN_DRIVER_ONLY |
+			     CRYPTO_AHASH_ALG_BLOCK_ONLY |
 					     CRYPTO_AHASH_ALG_FINAL_NONZERO,
+				.cra_priority = TALITOS_CRA_PRIORITY,
+				.cra_ctxsize = sizeof(struct talitos_ctx),
+				.cra_module = THIS_MODULE,
 			}
 		},
 		.desc_hdr_template = DESC_HDR_TYPE_COMMON_NONSNOOP_NO_AFEU |
@@ -597,8 +605,12 @@ static struct talitos_alg_template hash_driver_algs[] = {
 				.cra_reqsize = sizeof(struct talitos_ahash_req_ctx),
 				.cra_flags = CRYPTO_ALG_ASYNC |
 					     CRYPTO_ALG_ALLOCATES_MEMORY |
-					     CRYPTO_AHASH_ALG_BLOCK_ONLY |
+					     CRYPTO_ALG_KERN_DRIVER_ONLY |
+			     CRYPTO_AHASH_ALG_BLOCK_ONLY |
 					     CRYPTO_AHASH_ALG_FINAL_NONZERO,
+				.cra_priority = TALITOS_CRA_PRIORITY,
+				.cra_ctxsize = sizeof(struct talitos_ctx),
+				.cra_module = THIS_MODULE,
 			}
 		},
 		.desc_hdr_template = DESC_HDR_TYPE_COMMON_NONSNOOP_NO_AFEU |
@@ -616,8 +628,12 @@ static struct talitos_alg_template hash_driver_algs[] = {
 				.cra_reqsize = sizeof(struct talitos_ahash_req_ctx),
 				.cra_flags = CRYPTO_ALG_ASYNC |
 					     CRYPTO_ALG_ALLOCATES_MEMORY |
-					     CRYPTO_AHASH_ALG_BLOCK_ONLY |
+					     CRYPTO_ALG_KERN_DRIVER_ONLY |
+			     CRYPTO_AHASH_ALG_BLOCK_ONLY |
 					     CRYPTO_AHASH_ALG_FINAL_NONZERO,
+				.cra_priority = TALITOS_CRA_PRIORITY,
+				.cra_ctxsize = sizeof(struct talitos_ctx),
+				.cra_module = THIS_MODULE,
 			}
 		},
 		.desc_hdr_template = DESC_HDR_TYPE_COMMON_NONSNOOP_NO_AFEU |
@@ -635,8 +651,12 @@ static struct talitos_alg_template hash_driver_algs[] = {
 				.cra_reqsize = sizeof(struct talitos_ahash_req_ctx),
 				.cra_flags = CRYPTO_ALG_ASYNC |
 					     CRYPTO_ALG_ALLOCATES_MEMORY |
-					     CRYPTO_AHASH_ALG_BLOCK_ONLY |
+					     CRYPTO_ALG_KERN_DRIVER_ONLY |
+			     CRYPTO_AHASH_ALG_BLOCK_ONLY |
 					     CRYPTO_AHASH_ALG_FINAL_NONZERO,
+				.cra_priority = TALITOS_CRA_PRIORITY,
+				.cra_ctxsize = sizeof(struct talitos_ctx),
+				.cra_module = THIS_MODULE,
 			}
 		},
 		.desc_hdr_template = DESC_HDR_TYPE_COMMON_NONSNOOP_NO_AFEU |
@@ -654,8 +674,12 @@ static struct talitos_alg_template hash_driver_algs[] = {
 				.cra_reqsize = sizeof(struct talitos_ahash_req_ctx),
 				.cra_flags = CRYPTO_ALG_ASYNC |
 					     CRYPTO_ALG_ALLOCATES_MEMORY |
-					     CRYPTO_AHASH_ALG_BLOCK_ONLY |
+					     CRYPTO_ALG_KERN_DRIVER_ONLY |
+			     CRYPTO_AHASH_ALG_BLOCK_ONLY |
 					     CRYPTO_AHASH_ALG_FINAL_NONZERO,
+				.cra_priority = TALITOS_CRA_PRIORITY,
+				.cra_ctxsize = sizeof(struct talitos_ctx),
+				.cra_module = THIS_MODULE,
 			}
 		},
 		.desc_hdr_template = DESC_HDR_TYPE_COMMON_NONSNOOP_NO_AFEU |
@@ -673,8 +697,12 @@ static struct talitos_alg_template hash_driver_algs[] = {
 				.cra_reqsize = sizeof(struct talitos_ahash_req_ctx),
 				.cra_flags = CRYPTO_ALG_ASYNC |
 					     CRYPTO_ALG_ALLOCATES_MEMORY |
-					     CRYPTO_AHASH_ALG_BLOCK_ONLY |
+					     CRYPTO_ALG_KERN_DRIVER_ONLY |
+			     CRYPTO_AHASH_ALG_BLOCK_ONLY |
 					     CRYPTO_AHASH_ALG_FINAL_NONZERO,
+				.cra_priority = TALITOS_CRA_PRIORITY,
+				.cra_ctxsize = sizeof(struct talitos_ctx),
+				.cra_module = THIS_MODULE,
 			}
 		},
 		.desc_hdr_template = DESC_HDR_TYPE_COMMON_NONSNOOP_NO_AFEU |
@@ -692,8 +720,12 @@ static struct talitos_alg_template hash_driver_algs[] = {
 				.cra_reqsize = sizeof(struct talitos_ahash_req_ctx),
 				.cra_flags = CRYPTO_ALG_ASYNC |
 					     CRYPTO_ALG_ALLOCATES_MEMORY |
-					     CRYPTO_AHASH_ALG_BLOCK_ONLY |
+					     CRYPTO_ALG_KERN_DRIVER_ONLY |
+			     CRYPTO_AHASH_ALG_BLOCK_ONLY |
 					     CRYPTO_AHASH_ALG_FINAL_NONZERO,
+				.cra_priority = TALITOS_CRA_PRIORITY,
+				.cra_ctxsize = sizeof(struct talitos_ctx),
+				.cra_module = THIS_MODULE,
 			}
 		},
 		.desc_hdr_template = DESC_HDR_TYPE_COMMON_NONSNOOP_NO_AFEU |
@@ -711,8 +743,12 @@ static struct talitos_alg_template hash_driver_algs[] = {
 				.cra_reqsize = sizeof(struct talitos_ahash_req_ctx),
 				.cra_flags = CRYPTO_ALG_ASYNC |
 					     CRYPTO_ALG_ALLOCATES_MEMORY |
-					     CRYPTO_AHASH_ALG_BLOCK_ONLY |
+					     CRYPTO_ALG_KERN_DRIVER_ONLY |
+			     CRYPTO_AHASH_ALG_BLOCK_ONLY |
 					     CRYPTO_AHASH_ALG_FINAL_NONZERO,
+				.cra_priority = TALITOS_CRA_PRIORITY,
+				.cra_ctxsize = sizeof(struct talitos_ctx),
+				.cra_module = THIS_MODULE,
 			}
 		},
 		.desc_hdr_template = DESC_HDR_TYPE_COMMON_NONSNOOP_NO_AFEU |
@@ -730,8 +766,12 @@ static struct talitos_alg_template hash_driver_algs[] = {
 				.cra_reqsize = sizeof(struct talitos_ahash_req_ctx),
 				.cra_flags = CRYPTO_ALG_ASYNC |
 					     CRYPTO_ALG_ALLOCATES_MEMORY |
-					     CRYPTO_AHASH_ALG_BLOCK_ONLY |
+					     CRYPTO_ALG_KERN_DRIVER_ONLY |
+			     CRYPTO_AHASH_ALG_BLOCK_ONLY |
 					     CRYPTO_AHASH_ALG_FINAL_NONZERO,
+				.cra_priority = TALITOS_CRA_PRIORITY,
+				.cra_ctxsize = sizeof(struct talitos_ctx),
+				.cra_module = THIS_MODULE,
 			}
 		},
 		.desc_hdr_template = DESC_HDR_TYPE_COMMON_NONSNOOP_NO_AFEU |
@@ -749,8 +789,12 @@ static struct talitos_alg_template hash_driver_algs[] = {
 				.cra_reqsize = sizeof(struct talitos_ahash_req_ctx),
 				.cra_flags = CRYPTO_ALG_ASYNC |
 					     CRYPTO_ALG_ALLOCATES_MEMORY |
-					     CRYPTO_AHASH_ALG_BLOCK_ONLY |
+					     CRYPTO_ALG_KERN_DRIVER_ONLY |
+			     CRYPTO_AHASH_ALG_BLOCK_ONLY |
 					     CRYPTO_AHASH_ALG_FINAL_NONZERO,
+				.cra_priority = TALITOS_CRA_PRIORITY,
+				.cra_ctxsize = sizeof(struct talitos_ctx),
+				.cra_module = THIS_MODULE,
 			}
 		},
 		.desc_hdr_template = DESC_HDR_TYPE_COMMON_NONSNOOP_NO_AFEU |
@@ -768,8 +812,12 @@ static struct talitos_alg_template hash_driver_algs[] = {
 				.cra_reqsize = sizeof(struct talitos_ahash_req_ctx),
 				.cra_flags = CRYPTO_ALG_ASYNC |
 					     CRYPTO_ALG_ALLOCATES_MEMORY |
-					     CRYPTO_AHASH_ALG_BLOCK_ONLY |
+					     CRYPTO_ALG_KERN_DRIVER_ONLY |
+			     CRYPTO_AHASH_ALG_BLOCK_ONLY |
 					     CRYPTO_AHASH_ALG_FINAL_NONZERO,
+				.cra_priority = TALITOS_CRA_PRIORITY,
+				.cra_ctxsize = sizeof(struct talitos_ctx),
+				.cra_module = THIS_MODULE,
 			}
 		},
 		.desc_hdr_template = DESC_HDR_TYPE_COMMON_NONSNOOP_NO_AFEU |
diff --git a/drivers/crypto/talitos/talitos-skcipher.c b/drivers/crypto/talitos/talitos-skcipher.c
index 4f742930ec47..ff7b8f9344c4 100644
--- a/drivers/crypto/talitos/talitos-skcipher.c
+++ b/drivers/crypto/talitos/talitos-skcipher.c
@@ -239,7 +239,11 @@ static struct talitos_alg_template skcipher_driver_algs[] = {
 			.base.cra_driver_name = "ecb-aes-talitos",
 			.base.cra_blocksize = AES_BLOCK_SIZE,
 			.base.cra_flags = CRYPTO_ALG_ASYNC |
-					  CRYPTO_ALG_ALLOCATES_MEMORY,
+					  CRYPTO_ALG_ALLOCATES_MEMORY |
+					  CRYPTO_ALG_KERN_DRIVER_ONLY,
+			.base.cra_priority = TALITOS_CRA_PRIORITY,
+			.base.cra_ctxsize = sizeof(struct talitos_ctx),
+			.base.cra_module = THIS_MODULE,
 			.min_keysize = AES_MIN_KEY_SIZE,
 			.max_keysize = AES_MAX_KEY_SIZE,
 			.setkey = skcipher_aes_setkey,
@@ -253,7 +257,11 @@ static struct talitos_alg_template skcipher_driver_algs[] = {
 			.base.cra_driver_name = "cbc-aes-talitos",
 			.base.cra_blocksize = AES_BLOCK_SIZE,
 			.base.cra_flags = CRYPTO_ALG_ASYNC |
-					  CRYPTO_ALG_ALLOCATES_MEMORY,
+					  CRYPTO_ALG_ALLOCATES_MEMORY |
+					  CRYPTO_ALG_KERN_DRIVER_ONLY,
+			.base.cra_priority = TALITOS_CRA_PRIORITY,
+			.base.cra_ctxsize = sizeof(struct talitos_ctx),
+			.base.cra_module = THIS_MODULE,
 			.min_keysize = AES_MIN_KEY_SIZE,
 			.max_keysize = AES_MAX_KEY_SIZE,
 			.ivsize = AES_BLOCK_SIZE,
@@ -269,7 +277,11 @@ static struct talitos_alg_template skcipher_driver_algs[] = {
 			.base.cra_driver_name = "ctr-aes-talitos",
 			.base.cra_blocksize = 1,
 			.base.cra_flags = CRYPTO_ALG_ASYNC |
-					  CRYPTO_ALG_ALLOCATES_MEMORY,
+					  CRYPTO_ALG_ALLOCATES_MEMORY |
+					  CRYPTO_ALG_KERN_DRIVER_ONLY,
+			.base.cra_priority = TALITOS_CRA_PRIORITY,
+			.base.cra_ctxsize = sizeof(struct talitos_ctx),
+			.base.cra_module = THIS_MODULE,
 			.min_keysize = AES_MIN_KEY_SIZE,
 			.max_keysize = AES_MAX_KEY_SIZE,
 			.ivsize = AES_BLOCK_SIZE,
@@ -285,7 +297,11 @@ static struct talitos_alg_template skcipher_driver_algs[] = {
 			.base.cra_driver_name = "ctr-aes-talitos",
 			.base.cra_blocksize = 1,
 			.base.cra_flags = CRYPTO_ALG_ASYNC |
-					  CRYPTO_ALG_ALLOCATES_MEMORY,
+					  CRYPTO_ALG_ALLOCATES_MEMORY |
+					  CRYPTO_ALG_KERN_DRIVER_ONLY,
+			.base.cra_priority = TALITOS_CRA_PRIORITY,
+			.base.cra_ctxsize = sizeof(struct talitos_ctx),
+			.base.cra_module = THIS_MODULE,
 			.min_keysize = AES_MIN_KEY_SIZE,
 			.max_keysize = AES_MAX_KEY_SIZE,
 			.ivsize = AES_BLOCK_SIZE,
@@ -301,7 +317,11 @@ static struct talitos_alg_template skcipher_driver_algs[] = {
 			.base.cra_driver_name = "ecb-des-talitos",
 			.base.cra_blocksize = DES_BLOCK_SIZE,
 			.base.cra_flags = CRYPTO_ALG_ASYNC |
-					  CRYPTO_ALG_ALLOCATES_MEMORY,
+					  CRYPTO_ALG_ALLOCATES_MEMORY |
+					  CRYPTO_ALG_KERN_DRIVER_ONLY,
+			.base.cra_priority = TALITOS_CRA_PRIORITY,
+			.base.cra_ctxsize = sizeof(struct talitos_ctx),
+			.base.cra_module = THIS_MODULE,
 			.min_keysize = DES_KEY_SIZE,
 			.max_keysize = DES_KEY_SIZE,
 			.setkey = skcipher_des_setkey,
@@ -315,7 +335,11 @@ static struct talitos_alg_template skcipher_driver_algs[] = {
 			.base.cra_driver_name = "cbc-des-talitos",
 			.base.cra_blocksize = DES_BLOCK_SIZE,
 			.base.cra_flags = CRYPTO_ALG_ASYNC |
-					  CRYPTO_ALG_ALLOCATES_MEMORY,
+					  CRYPTO_ALG_ALLOCATES_MEMORY |
+					  CRYPTO_ALG_KERN_DRIVER_ONLY,
+			.base.cra_priority = TALITOS_CRA_PRIORITY,
+			.base.cra_ctxsize = sizeof(struct talitos_ctx),
+			.base.cra_module = THIS_MODULE,
 			.min_keysize = DES_KEY_SIZE,
 			.max_keysize = DES_KEY_SIZE,
 			.ivsize = DES_BLOCK_SIZE,
@@ -331,7 +355,11 @@ static struct talitos_alg_template skcipher_driver_algs[] = {
 			.base.cra_driver_name = "ecb-3des-talitos",
 			.base.cra_blocksize = DES3_EDE_BLOCK_SIZE,
 			.base.cra_flags = CRYPTO_ALG_ASYNC |
-					  CRYPTO_ALG_ALLOCATES_MEMORY,
+					  CRYPTO_ALG_ALLOCATES_MEMORY |
+					  CRYPTO_ALG_KERN_DRIVER_ONLY,
+			.base.cra_priority = TALITOS_CRA_PRIORITY,
+			.base.cra_ctxsize = sizeof(struct talitos_ctx),
+			.base.cra_module = THIS_MODULE,
 			.min_keysize = DES3_EDE_KEY_SIZE,
 			.max_keysize = DES3_EDE_KEY_SIZE,
 			.setkey = skcipher_des3_setkey,
@@ -346,7 +374,11 @@ static struct talitos_alg_template skcipher_driver_algs[] = {
 			.base.cra_driver_name = "cbc-3des-talitos",
 			.base.cra_blocksize = DES3_EDE_BLOCK_SIZE,
 			.base.cra_flags = CRYPTO_ALG_ASYNC |
-					  CRYPTO_ALG_ALLOCATES_MEMORY,
+					  CRYPTO_ALG_ALLOCATES_MEMORY |
+					  CRYPTO_ALG_KERN_DRIVER_ONLY,
+			.base.cra_priority = TALITOS_CRA_PRIORITY,
+			.base.cra_ctxsize = sizeof(struct talitos_ctx),
+			.base.cra_module = THIS_MODULE,
 			.min_keysize = DES3_EDE_KEY_SIZE,
 			.max_keysize = DES3_EDE_KEY_SIZE,
 			.ivsize = DES3_EDE_BLOCK_SIZE,
@@ -375,6 +407,9 @@ int talitos_register_skcipher(struct device *dev)
 		skcipher_alg = &skcipher_driver_algs[i].alg.skcipher;
 		alg = &skcipher_alg->base;
 
+		if (has_ftr_sec1(priv))
+			alg->cra_alignmask = 3;
+
 		alg->cra_exit = talitos_cra_exit;
 		skcipher_alg->init = talitos_cra_init_skcipher;
 		skcipher_alg->setkey = skcipher_alg->setkey ?: skcipher_setkey;
diff --git a/drivers/crypto/talitos/talitos.c b/drivers/crypto/talitos/talitos.c
index 41d7d0e570e3..f38a156a0459 100644
--- a/drivers/crypto/talitos/talitos.c
+++ b/drivers/crypto/talitos/talitos.c
@@ -1133,23 +1133,6 @@ static void talitos_remove(struct platform_device *ofdev)
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
@@ -1168,20 +1151,14 @@ int talitos_register_common(struct device *dev,
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

-- 
2.54.0

