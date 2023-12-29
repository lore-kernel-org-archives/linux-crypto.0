Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A571224DB
	for <linux-crypto@vger.kernel.org>; Tue, 13 Feb 2024 09:16:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707815818; cv=none; b=NKbdoc92Eh6ihA3RUCiy+5+q9ggPmMrvm0az7T0mZD4/ROE23n4MlQFnMHrySSNFFtvMsMLsMbJAG+K0ZLs2uhnVC8RlP2gxybUTLiP7jc8c5iq93LIBc05blkYY/9mORLC6OhDhmo6p8kQ5BC9PnBPBGRAJ2VR1rt7PbvdCAOw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707815818; c=relaxed/simple;
	bh=AosTdJux9FpTkqOdf6BbQcKggE31iTN6p6/FdEAFUYU=;
	h=Message-Id:In-Reply-To:References:From:Date:Subject:To; b=rHIknL2JljV/O15fwEZNhFyy/HlpCq8ri+wNFkXvvxvTdqplgmQKiLQNzGqo53cJZS1DugenbV9rf79RMibw1xzwSzVCWUhVK9dUZF866ions4mEg1s9cqXWDyG+PwXejjIcKOUmF9vCafbOJl2LQFZ5vPKe5L1z16XNgz2MyOI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
	id 1rZouJ-00D1tJ-6S; Tue, 13 Feb 2024 17:16:52 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Tue, 13 Feb 2024 17:17:05 +0800
Message-Id: <b149e8743355be694c96da02ced0811963298373.1707815065.git.herbert@gondor.apana.org.au>
In-Reply-To: <cover.1707815065.git.herbert@gondor.apana.org.au>
References: <cover.1707815065.git.herbert@gondor.apana.org.au>
From: Herbert Xu <herbert@gondor.apana.org.au>
Date: Fri, 29 Dec 2023 18:47:00 +0800
Subject: [PATCH 13/15] crypto: cts,xts - Update parameters
 blocksize/chunksize/tailsize
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>

As all implementations need to use the same paramters, change
all implementations of cts and xts to use the correct block, chunk
and tail size.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---
 arch/arm/crypto/aes-ce-glue.c                 |  8 +++++--
 arch/arm/crypto/aes-neonbs-glue.c             |  4 +++-
 arch/arm64/crypto/aes-glue.c                  |  8 +++++--
 arch/arm64/crypto/aes-neonbs-glue.c           |  4 +++-
 arch/arm64/crypto/sm4-ce-glue.c               |  8 +++++--
 arch/powerpc/crypto/aes-spe-glue.c            |  4 +++-
 arch/powerpc/crypto/aes_xts.c                 |  4 +++-
 arch/s390/crypto/aes_s390.c                   |  4 +++-
 arch/s390/crypto/paes_s390.c                  |  4 +++-
 arch/x86/crypto/aesni-intel_glue.c            |  8 +++++--
 drivers/crypto/atmel-aes.c                    |  4 +++-
 drivers/crypto/axis/artpec6_crypto.c          |  2 ++
 drivers/crypto/bcm/cipher.c                   |  4 +++-
 drivers/crypto/caam/caamalg.c                 |  4 +++-
 drivers/crypto/caam/caamalg_qi.c              |  4 +++-
 drivers/crypto/caam/caamalg_qi2.c             |  4 +++-
 drivers/crypto/cavium/cpt/cptvf_algs.c        |  4 +++-
 .../crypto/cavium/nitrox/nitrox_skcipher.c    |  8 +++++--
 drivers/crypto/ccp/ccp-crypto-aes-xts.c       |  4 +++-
 drivers/crypto/ccree/cc_cipher.c              | 12 ++++++++--
 drivers/crypto/chelsio/chcr_algo.c            |  4 +++-
 drivers/crypto/hisilicon/sec/sec_algs.c       |  4 +++-
 drivers/crypto/hisilicon/sec2/sec_crypto.c    | 23 +++++++++++--------
 .../crypto/inside-secure/safexcel_cipher.c    |  4 +++-
 .../intel/keembay/keembay-ocs-aes-core.c      | 11 ++++++---
 .../crypto/intel/qat/qat_common/qat_algs.c    |  4 +++-
 .../crypto/marvell/octeontx/otx_cptvf_algs.c  |  4 +++-
 .../marvell/octeontx2/otx2_cptvf_algs.c       |  4 +++-
 drivers/crypto/qce/skcipher.c                 |  6 ++++-
 29 files changed, 125 insertions(+), 45 deletions(-)

diff --git a/arch/arm/crypto/aes-ce-glue.c b/arch/arm/crypto/aes-ce-glue.c
index b668c97663ec..3bfa8accf2c2 100644
--- a/arch/arm/crypto/aes-ce-glue.c
+++ b/arch/arm/crypto/aes-ce-glue.c
@@ -619,13 +619,15 @@ static struct skcipher_alg aes_algs[] = { {
 	.base.cra_driver_name	= "__cts-cbc-aes-ce",
 	.base.cra_priority	= 300,
 	.base.cra_flags		= CRYPTO_ALG_INTERNAL,
-	.base.cra_blocksize	= AES_BLOCK_SIZE,
+	.base.cra_blocksize	= 1,
 	.base.cra_ctxsize	= sizeof(struct crypto_aes_ctx),
 	.base.cra_module	= THIS_MODULE,
 
 	.min_keysize		= AES_MIN_KEY_SIZE,
 	.max_keysize		= AES_MAX_KEY_SIZE,
 	.ivsize			= AES_BLOCK_SIZE,
+	.chunksize		= AES_BLOCK_SIZE,
+	.tailsize		= 2 * AES_BLOCK_SIZE,
 	.walksize		= 2 * AES_BLOCK_SIZE,
 	.setkey			= ce_aes_setkey,
 	.encrypt		= cts_cbc_encrypt,
@@ -666,13 +668,15 @@ static struct skcipher_alg aes_algs[] = { {
 	.base.cra_driver_name	= "__xts-aes-ce",
 	.base.cra_priority	= 300,
 	.base.cra_flags		= CRYPTO_ALG_INTERNAL,
-	.base.cra_blocksize	= AES_BLOCK_SIZE,
+	.base.cra_blocksize	= 1,
 	.base.cra_ctxsize	= sizeof(struct crypto_aes_xts_ctx),
 	.base.cra_module	= THIS_MODULE,
 
 	.min_keysize		= 2 * AES_MIN_KEY_SIZE,
 	.max_keysize		= 2 * AES_MAX_KEY_SIZE,
 	.ivsize			= AES_BLOCK_SIZE,
+	.chunksize		= AES_BLOCK_SIZE,
+	.tailsize		= 2 * AES_BLOCK_SIZE,
 	.walksize		= 2 * AES_BLOCK_SIZE,
 	.setkey			= xts_set_key,
 	.encrypt		= xts_encrypt,
diff --git a/arch/arm/crypto/aes-neonbs-glue.c b/arch/arm/crypto/aes-neonbs-glue.c
index f00f042ef357..d2a032cbc5ac 100644
--- a/arch/arm/crypto/aes-neonbs-glue.c
+++ b/arch/arm/crypto/aes-neonbs-glue.c
@@ -487,13 +487,15 @@ static struct skcipher_alg aes_algs[] = { {
 	.base.cra_name		= "__xts(aes)",
 	.base.cra_driver_name	= "__xts-aes-neonbs",
 	.base.cra_priority	= 250,
-	.base.cra_blocksize	= AES_BLOCK_SIZE,
+	.base.cra_blocksize	= 1,
 	.base.cra_ctxsize	= sizeof(struct aesbs_xts_ctx),
 	.base.cra_module	= THIS_MODULE,
 	.base.cra_flags		= CRYPTO_ALG_INTERNAL,
 
 	.min_keysize		= 2 * AES_MIN_KEY_SIZE,
 	.max_keysize		= 2 * AES_MAX_KEY_SIZE,
+	.chunksize		= AES_BLOCK_SIZE,
+	.tailsize		= 2 * AES_BLOCK_SIZE,
 	.walksize		= 8 * AES_BLOCK_SIZE,
 	.ivsize			= AES_BLOCK_SIZE,
 	.setkey			= aesbs_xts_setkey,
diff --git a/arch/arm64/crypto/aes-glue.c b/arch/arm64/crypto/aes-glue.c
index a147e847a5a1..733e40213445 100644
--- a/arch/arm64/crypto/aes-glue.c
+++ b/arch/arm64/crypto/aes-glue.c
@@ -750,13 +750,15 @@ static struct skcipher_alg aes_algs[] = { {
 		.cra_name		= "xts(aes)",
 		.cra_driver_name	= "xts-aes-" MODE,
 		.cra_priority		= PRIO,
-		.cra_blocksize		= AES_BLOCK_SIZE,
+		.cra_blocksize		= 1,
 		.cra_ctxsize		= sizeof(struct crypto_aes_xts_ctx),
 		.cra_module		= THIS_MODULE,
 	},
 	.min_keysize	= 2 * AES_MIN_KEY_SIZE,
 	.max_keysize	= 2 * AES_MAX_KEY_SIZE,
 	.ivsize		= AES_BLOCK_SIZE,
+	.chunksize	= AES_BLOCK_SIZE,
+	.tailsize	= 2 * AES_BLOCK_SIZE,
 	.walksize	= 2 * AES_BLOCK_SIZE,
 	.setkey		= xts_set_key,
 	.encrypt	= xts_encrypt,
@@ -767,13 +769,15 @@ static struct skcipher_alg aes_algs[] = { {
 		.cra_name		= "cts(cbc(aes))",
 		.cra_driver_name	= "cts-cbc-aes-" MODE,
 		.cra_priority		= PRIO,
-		.cra_blocksize		= AES_BLOCK_SIZE,
+		.cra_blocksize		= 1,
 		.cra_ctxsize		= sizeof(struct crypto_aes_ctx),
 		.cra_module		= THIS_MODULE,
 	},
 	.min_keysize	= AES_MIN_KEY_SIZE,
 	.max_keysize	= AES_MAX_KEY_SIZE,
 	.ivsize		= AES_BLOCK_SIZE,
+	.chunksize	= AES_BLOCK_SIZE,
+	.tailsize	= 2 * AES_BLOCK_SIZE,
 	.walksize	= 2 * AES_BLOCK_SIZE,
 	.setkey		= skcipher_aes_setkey,
 	.encrypt	= cts_cbc_encrypt,
diff --git a/arch/arm64/crypto/aes-neonbs-glue.c b/arch/arm64/crypto/aes-neonbs-glue.c
index bac4cabef607..f29770c3c063 100644
--- a/arch/arm64/crypto/aes-neonbs-glue.c
+++ b/arch/arm64/crypto/aes-neonbs-glue.c
@@ -427,12 +427,14 @@ static struct skcipher_alg aes_algs[] = { {
 	.base.cra_name		= "xts(aes)",
 	.base.cra_driver_name	= "xts-aes-neonbs",
 	.base.cra_priority	= 250,
-	.base.cra_blocksize	= AES_BLOCK_SIZE,
+	.base.cra_blocksize	= 1,
 	.base.cra_ctxsize	= sizeof(struct aesbs_xts_ctx),
 	.base.cra_module	= THIS_MODULE,
 
 	.min_keysize		= 2 * AES_MIN_KEY_SIZE,
 	.max_keysize		= 2 * AES_MAX_KEY_SIZE,
+	.chunksize		= AES_BLOCK_SIZE,
+	.tailsize		= 2 * AES_BLOCK_SIZE,
 	.walksize		= 8 * AES_BLOCK_SIZE,
 	.ivsize			= AES_BLOCK_SIZE,
 	.setkey			= aesbs_xts_setkey,
diff --git a/arch/arm64/crypto/sm4-ce-glue.c b/arch/arm64/crypto/sm4-ce-glue.c
index 43741bed874e..650049d51d99 100644
--- a/arch/arm64/crypto/sm4-ce-glue.c
+++ b/arch/arm64/crypto/sm4-ce-glue.c
@@ -474,13 +474,15 @@ static struct skcipher_alg sm4_algs[] = {
 			.cra_name		= "cts(cbc(sm4))",
 			.cra_driver_name	= "cts-cbc-sm4-ce",
 			.cra_priority		= 400,
-			.cra_blocksize		= SM4_BLOCK_SIZE,
+			.cra_blocksize		= 1,
 			.cra_ctxsize		= sizeof(struct sm4_ctx),
 			.cra_module		= THIS_MODULE,
 		},
 		.min_keysize	= SM4_KEY_SIZE,
 		.max_keysize	= SM4_KEY_SIZE,
 		.ivsize		= SM4_BLOCK_SIZE,
+		.chunksize	= SM4_BLOCK_SIZE,
+		.tailsize	= SM4_BLOCK_SIZE * 2,
 		.walksize	= SM4_BLOCK_SIZE * 2,
 		.setkey		= sm4_setkey,
 		.encrypt	= sm4_cbc_cts_encrypt,
@@ -490,13 +492,15 @@ static struct skcipher_alg sm4_algs[] = {
 			.cra_name		= "xts(sm4)",
 			.cra_driver_name	= "xts-sm4-ce",
 			.cra_priority		= 400,
-			.cra_blocksize		= SM4_BLOCK_SIZE,
+			.cra_blocksize		= 1,
 			.cra_ctxsize		= sizeof(struct sm4_xts_ctx),
 			.cra_module		= THIS_MODULE,
 		},
 		.min_keysize	= SM4_KEY_SIZE * 2,
 		.max_keysize	= SM4_KEY_SIZE * 2,
 		.ivsize		= SM4_BLOCK_SIZE,
+		.chunksize	= SM4_BLOCK_SIZE,
+		.tailsize	= SM4_BLOCK_SIZE * 2,
 		.walksize	= SM4_BLOCK_SIZE * 2,
 		.setkey		= sm4_xts_setkey,
 		.encrypt	= sm4_xts_encrypt,
diff --git a/arch/powerpc/crypto/aes-spe-glue.c b/arch/powerpc/crypto/aes-spe-glue.c
index efab78a3a8f6..b0c6cb44da94 100644
--- a/arch/powerpc/crypto/aes-spe-glue.c
+++ b/arch/powerpc/crypto/aes-spe-glue.c
@@ -474,12 +474,14 @@ static struct skcipher_alg aes_skcipher_algs[] = {
 		.base.cra_name		=	"xts(aes)",
 		.base.cra_driver_name	=	"xts-ppc-spe",
 		.base.cra_priority	=	300,
-		.base.cra_blocksize	=	AES_BLOCK_SIZE,
+		.base.cra_blocksize	=	1,
 		.base.cra_ctxsize	=	sizeof(struct ppc_xts_ctx),
 		.base.cra_module	=	THIS_MODULE,
 		.min_keysize		=	AES_MIN_KEY_SIZE * 2,
 		.max_keysize		=	AES_MAX_KEY_SIZE * 2,
 		.ivsize			=	AES_BLOCK_SIZE,
+		.chunksize		=	AES_BLOCK_SIZE,
+		.tailsize		=	AES_BLOCK_SIZE * 2,
 		.setkey			=	ppc_xts_setkey,
 		.encrypt		=	ppc_xts_encrypt,
 		.decrypt		=	ppc_xts_decrypt,
diff --git a/arch/powerpc/crypto/aes_xts.c b/arch/powerpc/crypto/aes_xts.c
index dabbccb41550..44828127156f 100644
--- a/arch/powerpc/crypto/aes_xts.c
+++ b/arch/powerpc/crypto/aes_xts.c
@@ -149,7 +149,7 @@ struct skcipher_alg p8_aes_xts_alg = {
 	.base.cra_module = THIS_MODULE,
 	.base.cra_priority = 2000,
 	.base.cra_flags = CRYPTO_ALG_NEED_FALLBACK,
-	.base.cra_blocksize = AES_BLOCK_SIZE,
+	.base.cra_blocksize = 1,
 	.base.cra_ctxsize = sizeof(struct p8_aes_xts_ctx),
 	.setkey = p8_aes_xts_setkey,
 	.encrypt = p8_aes_xts_encrypt,
@@ -159,4 +159,6 @@ struct skcipher_alg p8_aes_xts_alg = {
 	.min_keysize = 2 * AES_MIN_KEY_SIZE,
 	.max_keysize = 2 * AES_MAX_KEY_SIZE,
 	.ivsize = AES_BLOCK_SIZE,
+	.chunksize = AES_BLOCK_SIZE,
+	.tailsize = 2 * AES_BLOCK_SIZE,
 };
diff --git a/arch/s390/crypto/aes_s390.c b/arch/s390/crypto/aes_s390.c
index c6fe5405de4a..774c8f4e7a89 100644
--- a/arch/s390/crypto/aes_s390.c
+++ b/arch/s390/crypto/aes_s390.c
@@ -513,7 +513,7 @@ static struct skcipher_alg xts_aes_alg = {
 	.base.cra_driver_name	=	"xts-aes-s390",
 	.base.cra_priority	=	402,	/* ecb-aes-s390 + 1 */
 	.base.cra_flags		=	CRYPTO_ALG_NEED_FALLBACK,
-	.base.cra_blocksize	=	AES_BLOCK_SIZE,
+	.base.cra_blocksize	=	1,
 	.base.cra_ctxsize	=	sizeof(struct s390_xts_ctx),
 	.base.cra_module	=	THIS_MODULE,
 	.init			=	xts_fallback_init,
@@ -521,6 +521,8 @@ static struct skcipher_alg xts_aes_alg = {
 	.min_keysize		=	2 * AES_MIN_KEY_SIZE,
 	.max_keysize		=	2 * AES_MAX_KEY_SIZE,
 	.ivsize			=	AES_BLOCK_SIZE,
+	.chunksize		=	AES_BLOCK_SIZE,
+	.tailsize		=	2 * AES_BLOCK_SIZE,
 	.setkey			=	xts_aes_set_key,
 	.encrypt		=	xts_aes_encrypt,
 	.decrypt		=	xts_aes_decrypt,
diff --git a/arch/s390/crypto/paes_s390.c b/arch/s390/crypto/paes_s390.c
index 55ee5567a5ea..0bc03c999a6d 100644
--- a/arch/s390/crypto/paes_s390.c
+++ b/arch/s390/crypto/paes_s390.c
@@ -559,7 +559,7 @@ static struct skcipher_alg xts_paes_alg = {
 	.base.cra_name		=	"xts(paes)",
 	.base.cra_driver_name	=	"xts-paes-s390",
 	.base.cra_priority	=	402,	/* ecb-paes-s390 + 1 */
-	.base.cra_blocksize	=	AES_BLOCK_SIZE,
+	.base.cra_blocksize	=	1,
 	.base.cra_ctxsize	=	sizeof(struct s390_pxts_ctx),
 	.base.cra_module	=	THIS_MODULE,
 	.base.cra_list		=	LIST_HEAD_INIT(xts_paes_alg.base.cra_list),
@@ -568,6 +568,8 @@ static struct skcipher_alg xts_paes_alg = {
 	.min_keysize		=	2 * PAES_MIN_KEYSIZE,
 	.max_keysize		=	2 * PAES_MAX_KEYSIZE,
 	.ivsize			=	AES_BLOCK_SIZE,
+	.chunksize		=	AES_BLOCK_SIZE,
+	.tailsize		=	2 * AES_BLOCK_SIZE,
 	.setkey			=	xts_paes_set_key,
 	.encrypt		=	xts_paes_encrypt,
 	.decrypt		=	xts_paes_decrypt,
diff --git a/arch/x86/crypto/aesni-intel_glue.c b/arch/x86/crypto/aesni-intel_glue.c
index b1d90c25975a..a40f9a9c3978 100644
--- a/arch/x86/crypto/aesni-intel_glue.c
+++ b/arch/x86/crypto/aesni-intel_glue.c
@@ -1059,13 +1059,15 @@ static struct skcipher_alg aesni_skciphers[] = {
 			.cra_driver_name	= "__cts-cbc-aes-aesni",
 			.cra_priority		= 400,
 			.cra_flags		= CRYPTO_ALG_INTERNAL,
-			.cra_blocksize		= AES_BLOCK_SIZE,
+			.cra_blocksize		= 1,
 			.cra_ctxsize		= CRYPTO_AES_CTX_SIZE,
 			.cra_module		= THIS_MODULE,
 		},
 		.min_keysize	= AES_MIN_KEY_SIZE,
 		.max_keysize	= AES_MAX_KEY_SIZE,
 		.ivsize		= AES_BLOCK_SIZE,
+		.chunksize	= AES_BLOCK_SIZE,
+		.tailsize	= 2 * AES_BLOCK_SIZE,
 		.walksize	= 2 * AES_BLOCK_SIZE,
 		.setkey		= aesni_skcipher_setkey,
 		.encrypt	= cts_cbc_encrypt,
@@ -1095,13 +1097,15 @@ static struct skcipher_alg aesni_skciphers[] = {
 			.cra_driver_name	= "__xts-aes-aesni",
 			.cra_priority		= 401,
 			.cra_flags		= CRYPTO_ALG_INTERNAL,
-			.cra_blocksize		= AES_BLOCK_SIZE,
+			.cra_blocksize		= 1,
 			.cra_ctxsize		= XTS_AES_CTX_SIZE,
 			.cra_module		= THIS_MODULE,
 		},
 		.min_keysize	= 2 * AES_MIN_KEY_SIZE,
 		.max_keysize	= 2 * AES_MAX_KEY_SIZE,
 		.ivsize		= AES_BLOCK_SIZE,
+		.chunksize	= AES_BLOCK_SIZE,
+		.tailsize	= 2 * AES_BLOCK_SIZE,
 		.walksize	= 2 * AES_BLOCK_SIZE,
 		.setkey		= xts_aesni_setkey,
 		.encrypt	= xts_encrypt,
diff --git a/drivers/crypto/atmel-aes.c b/drivers/crypto/atmel-aes.c
index 8bd64fc37e75..4820f1c7fe09 100644
--- a/drivers/crypto/atmel-aes.c
+++ b/drivers/crypto/atmel-aes.c
@@ -1741,13 +1741,15 @@ static void atmel_aes_xts_exit_tfm(struct crypto_skcipher *tfm)
 static struct skcipher_alg aes_xts_alg = {
 	.base.cra_name		= "xts(aes)",
 	.base.cra_driver_name	= "atmel-xts-aes",
-	.base.cra_blocksize	= AES_BLOCK_SIZE,
+	.base.cra_blocksize	= 1,
 	.base.cra_ctxsize	= sizeof(struct atmel_aes_xts_ctx),
 	.base.cra_flags		= CRYPTO_ALG_NEED_FALLBACK,
 
 	.min_keysize		= 2 * AES_MIN_KEY_SIZE,
 	.max_keysize		= 2 * AES_MAX_KEY_SIZE,
 	.ivsize			= AES_BLOCK_SIZE,
+	.chunksize		= AES_BLOCK_SIZE,
+	.tailsize		= 2 * AES_BLOCK_SIZE,
 	.setkey			= atmel_aes_xts_setkey,
 	.encrypt		= atmel_aes_xts_encrypt,
 	.decrypt		= atmel_aes_xts_decrypt,
diff --git a/drivers/crypto/axis/artpec6_crypto.c b/drivers/crypto/axis/artpec6_crypto.c
index dbc1d483f2af..f2f19467d8e1 100644
--- a/drivers/crypto/axis/artpec6_crypto.c
+++ b/drivers/crypto/axis/artpec6_crypto.c
@@ -2777,6 +2777,8 @@ static struct skcipher_alg crypto_algos[] = {
 		.min_keysize = 2*AES_MIN_KEY_SIZE,
 		.max_keysize = 2*AES_MAX_KEY_SIZE,
 		.ivsize = 16,
+		.chunksize = 16,
+		.tailsize = 32,
 		.setkey = artpec6_crypto_xts_set_key,
 		.encrypt = artpec6_crypto_encrypt,
 		.decrypt = artpec6_crypto_decrypt,
diff --git a/drivers/crypto/bcm/cipher.c b/drivers/crypto/bcm/cipher.c
index 1a3ecd44cbaf..06b2a5cc9084 100644
--- a/drivers/crypto/bcm/cipher.c
+++ b/drivers/crypto/bcm/cipher.c
@@ -3652,10 +3652,12 @@ static struct iproc_alg_s driver_algs[] = {
 	 .alg.skcipher = {
 			.base.cra_name = "xts(aes)",
 			.base.cra_driver_name = "xts-aes-iproc",
-			.base.cra_blocksize = AES_BLOCK_SIZE,
+			.base.cra_blocksize = 1,
 			.min_keysize = 2 * AES_MIN_KEY_SIZE,
 			.max_keysize = 2 * AES_MAX_KEY_SIZE,
 			.ivsize = AES_BLOCK_SIZE,
+			.chunksize = AES_BLOCK_SIZE,
+			.tailsize = 2 * AES_BLOCK_SIZE,
 			},
 	 .cipher_info = {
 			 .alg = CIPHER_ALG_AES,
diff --git a/drivers/crypto/caam/caamalg.c b/drivers/crypto/caam/caamalg.c
index 066f08a3a040..b62aea2aa65e 100644
--- a/drivers/crypto/caam/caamalg.c
+++ b/drivers/crypto/caam/caamalg.c
@@ -1995,7 +1995,7 @@ static struct caam_skcipher_alg driver_algs[] = {
 				.cra_name = "xts(aes)",
 				.cra_driver_name = "xts-aes-caam",
 				.cra_flags = CRYPTO_ALG_NEED_FALLBACK,
-				.cra_blocksize = AES_BLOCK_SIZE,
+				.cra_blocksize = 1,
 			},
 			.setkey = xts_skcipher_setkey,
 			.encrypt = skcipher_encrypt,
@@ -2003,6 +2003,8 @@ static struct caam_skcipher_alg driver_algs[] = {
 			.min_keysize = 2 * AES_MIN_KEY_SIZE,
 			.max_keysize = 2 * AES_MAX_KEY_SIZE,
 			.ivsize = AES_BLOCK_SIZE,
+			.chunksize = AES_BLOCK_SIZE,
+			.tailsize = 2 * AES_BLOCK_SIZE,
 		},
 		.skcipher.op = {
 			.do_one_request = skcipher_do_one_req,
diff --git a/drivers/crypto/caam/caamalg_qi.c b/drivers/crypto/caam/caamalg_qi.c
index 743ce50c14f2..7658ffc70e1d 100644
--- a/drivers/crypto/caam/caamalg_qi.c
+++ b/drivers/crypto/caam/caamalg_qi.c
@@ -1574,7 +1574,7 @@ static struct caam_skcipher_alg driver_algs[] = {
 				.cra_name = "xts(aes)",
 				.cra_driver_name = "xts-aes-caam-qi",
 				.cra_flags = CRYPTO_ALG_NEED_FALLBACK,
-				.cra_blocksize = AES_BLOCK_SIZE,
+				.cra_blocksize = 1,
 			},
 			.setkey = xts_skcipher_setkey,
 			.encrypt = skcipher_encrypt,
@@ -1582,6 +1582,8 @@ static struct caam_skcipher_alg driver_algs[] = {
 			.min_keysize = 2 * AES_MIN_KEY_SIZE,
 			.max_keysize = 2 * AES_MAX_KEY_SIZE,
 			.ivsize = AES_BLOCK_SIZE,
+			.chunksize = AES_BLOCK_SIZE,
+			.tailsize = 2 * AES_BLOCK_SIZE,
 		},
 		.caam.class1_alg_type = OP_ALG_ALGSEL_AES | OP_ALG_AAI_XTS,
 	},
diff --git a/drivers/crypto/caam/caamalg_qi2.c b/drivers/crypto/caam/caamalg_qi2.c
index a4f6884416a0..b724671c04be 100644
--- a/drivers/crypto/caam/caamalg_qi2.c
+++ b/drivers/crypto/caam/caamalg_qi2.c
@@ -1767,7 +1767,7 @@ static struct caam_skcipher_alg driver_algs[] = {
 				.cra_name = "xts(aes)",
 				.cra_driver_name = "xts-aes-caam-qi2",
 				.cra_flags = CRYPTO_ALG_NEED_FALLBACK,
-				.cra_blocksize = AES_BLOCK_SIZE,
+				.cra_blocksize = 1,
 			},
 			.setkey = xts_skcipher_setkey,
 			.encrypt = skcipher_encrypt,
@@ -1775,6 +1775,8 @@ static struct caam_skcipher_alg driver_algs[] = {
 			.min_keysize = 2 * AES_MIN_KEY_SIZE,
 			.max_keysize = 2 * AES_MAX_KEY_SIZE,
 			.ivsize = AES_BLOCK_SIZE,
+			.chunksize = AES_BLOCK_SIZE,
+			.tailsize = 2 * AES_BLOCK_SIZE,
 		},
 		.caam.class1_alg_type = OP_ALG_ALGSEL_AES | OP_ALG_AAI_XTS,
 	},
diff --git a/drivers/crypto/cavium/cpt/cptvf_algs.c b/drivers/crypto/cavium/cpt/cptvf_algs.c
index 219fe9be7606..30f8f1dec5cd 100644
--- a/drivers/crypto/cavium/cpt/cptvf_algs.c
+++ b/drivers/crypto/cavium/cpt/cptvf_algs.c
@@ -335,7 +335,7 @@ static int cvm_enc_dec_init(struct crypto_skcipher *tfm)
 static struct skcipher_alg algs[] = { {
 	.base.cra_flags		= CRYPTO_ALG_ASYNC |
 				  CRYPTO_ALG_ALLOCATES_MEMORY,
-	.base.cra_blocksize	= AES_BLOCK_SIZE,
+	.base.cra_blocksize	= 1,
 	.base.cra_ctxsize	= sizeof(struct cvm_enc_ctx),
 	.base.cra_alignmask	= 7,
 	.base.cra_priority	= 4001,
@@ -344,6 +344,8 @@ static struct skcipher_alg algs[] = { {
 	.base.cra_module	= THIS_MODULE,
 
 	.ivsize			= AES_BLOCK_SIZE,
+	.chunksize		= AES_BLOCK_SIZE,
+	.tailsize		= 2 * AES_BLOCK_SIZE,
 	.min_keysize		= 2 * AES_MIN_KEY_SIZE,
 	.max_keysize		= 2 * AES_MAX_KEY_SIZE,
 	.setkey			= cvm_xts_setkey,
diff --git a/drivers/crypto/cavium/nitrox/nitrox_skcipher.c b/drivers/crypto/cavium/nitrox/nitrox_skcipher.c
index 6e5e667bab75..2f2c9a1170a0 100644
--- a/drivers/crypto/cavium/nitrox/nitrox_skcipher.c
+++ b/drivers/crypto/cavium/nitrox/nitrox_skcipher.c
@@ -425,7 +425,7 @@ static struct skcipher_alg nitrox_skciphers[] = { {
 		.cra_driver_name = "n5_xts(aes)",
 		.cra_priority = PRIO,
 		.cra_flags = CRYPTO_ALG_ASYNC | CRYPTO_ALG_ALLOCATES_MEMORY,
-		.cra_blocksize = AES_BLOCK_SIZE,
+		.cra_blocksize = 1,
 		.cra_ctxsize = sizeof(struct nitrox_crypto_ctx),
 		.cra_alignmask = 0,
 		.cra_module = THIS_MODULE,
@@ -433,6 +433,8 @@ static struct skcipher_alg nitrox_skciphers[] = { {
 	.min_keysize = 2 * AES_MIN_KEY_SIZE,
 	.max_keysize = 2 * AES_MAX_KEY_SIZE,
 	.ivsize = AES_BLOCK_SIZE,
+	.chunksize = AES_BLOCK_SIZE,
+	.tailsize = 2 * AES_BLOCK_SIZE,
 	.setkey = nitrox_aes_xts_setkey,
 	.encrypt = nitrox_aes_encrypt,
 	.decrypt = nitrox_aes_decrypt,
@@ -463,7 +465,7 @@ static struct skcipher_alg nitrox_skciphers[] = { {
 		.cra_driver_name = "n5_cts(cbc(aes))",
 		.cra_priority = PRIO,
 		.cra_flags = CRYPTO_ALG_ASYNC | CRYPTO_ALG_ALLOCATES_MEMORY,
-		.cra_blocksize = AES_BLOCK_SIZE,
+		.cra_blocksize = 1,
 		.cra_ctxsize = sizeof(struct nitrox_crypto_ctx),
 		.cra_alignmask = 0,
 		.cra_module = THIS_MODULE,
@@ -471,6 +473,8 @@ static struct skcipher_alg nitrox_skciphers[] = { {
 	.min_keysize = AES_MIN_KEY_SIZE,
 	.max_keysize = AES_MAX_KEY_SIZE,
 	.ivsize = AES_BLOCK_SIZE,
+	.chunksize = AES_BLOCK_SIZE,
+	.tailsize = 2 * AES_BLOCK_SIZE,
 	.setkey = nitrox_aes_setkey,
 	.encrypt = nitrox_aes_encrypt,
 	.decrypt = nitrox_aes_decrypt,
diff --git a/drivers/crypto/ccp/ccp-crypto-aes-xts.c b/drivers/crypto/ccp/ccp-crypto-aes-xts.c
index 93f735d6b02b..247025918861 100644
--- a/drivers/crypto/ccp/ccp-crypto-aes-xts.c
+++ b/drivers/crypto/ccp/ccp-crypto-aes-xts.c
@@ -246,7 +246,7 @@ static int ccp_register_aes_xts_alg(struct list_head *head,
 				  CRYPTO_ALG_ALLOCATES_MEMORY |
 				  CRYPTO_ALG_KERN_DRIVER_ONLY |
 				  CRYPTO_ALG_NEED_FALLBACK;
-	alg->base.cra_blocksize	= AES_BLOCK_SIZE;
+	alg->base.cra_blocksize	= 1;
 	alg->base.cra_ctxsize	= sizeof(struct ccp_ctx) +
 				  crypto_dma_padding();
 	alg->base.cra_priority	= CCP_CRA_PRIORITY;
@@ -258,6 +258,8 @@ static int ccp_register_aes_xts_alg(struct list_head *head,
 	alg->min_keysize	= AES_MIN_KEY_SIZE * 2;
 	alg->max_keysize	= AES_MAX_KEY_SIZE * 2;
 	alg->ivsize		= AES_BLOCK_SIZE;
+	alg->chunksize		= AES_BLOCK_SIZE;
+	alg->tailsize		= 2 * AES_BLOCK_SIZE;
 	alg->init		= ccp_aes_xts_init_tfm;
 	alg->exit		= ccp_aes_xts_exit_tfm;
 
diff --git a/drivers/crypto/ccree/cc_cipher.c b/drivers/crypto/ccree/cc_cipher.c
index cd66a580e8b6..18ea3e90d039 100644
--- a/drivers/crypto/ccree/cc_cipher.c
+++ b/drivers/crypto/ccree/cc_cipher.c
@@ -1018,6 +1018,8 @@ static const struct cc_alg_template skcipher_algs[] = {
 			.min_keysize = CC_HW_KEY_SIZE,
 			.max_keysize = CC_HW_KEY_SIZE,
 			.ivsize = AES_BLOCK_SIZE,
+			.chunksize = AES_BLOCK_SIZE,
+			.tailsize = 2 * AES_BLOCK_SIZE,
 			},
 		.cipher_mode = DRV_CIPHER_XTS,
 		.flow_mode = S_DIN_to_AES,
@@ -1082,7 +1084,7 @@ static const struct cc_alg_template skcipher_algs[] = {
 	{
 		.name = "cts(cbc(paes))",
 		.driver_name = "cts-cbc-paes-ccree",
-		.blocksize = AES_BLOCK_SIZE,
+		.blocksize = 1,
 		.template_skcipher = {
 			.setkey = cc_cipher_sethkey,
 			.encrypt = cc_cipher_encrypt,
@@ -1090,6 +1092,8 @@ static const struct cc_alg_template skcipher_algs[] = {
 			.min_keysize = CC_HW_KEY_SIZE,
 			.max_keysize = CC_HW_KEY_SIZE,
 			.ivsize = AES_BLOCK_SIZE,
+			.chunksize = AES_BLOCK_SIZE,
+			.tailsize = 2 * AES_BLOCK_SIZE,
 			},
 		.cipher_mode = DRV_CIPHER_CBC_CTS,
 		.flow_mode = S_DIN_to_AES,
@@ -1130,6 +1134,8 @@ static const struct cc_alg_template skcipher_algs[] = {
 			.min_keysize = AES_MIN_KEY_SIZE * 2,
 			.max_keysize = AES_MAX_KEY_SIZE * 2,
 			.ivsize = AES_BLOCK_SIZE,
+			.chunksize = AES_BLOCK_SIZE,
+			.tailsize = 2 * AES_BLOCK_SIZE,
 			},
 		.cipher_mode = DRV_CIPHER_XTS,
 		.flow_mode = S_DIN_to_AES,
@@ -1190,7 +1196,7 @@ static const struct cc_alg_template skcipher_algs[] = {
 	{
 		.name = "cts(cbc(aes))",
 		.driver_name = "cts-cbc-aes-ccree",
-		.blocksize = AES_BLOCK_SIZE,
+		.blocksize = 1,
 		.template_skcipher = {
 			.setkey = cc_cipher_setkey,
 			.encrypt = cc_cipher_encrypt,
@@ -1198,6 +1204,8 @@ static const struct cc_alg_template skcipher_algs[] = {
 			.min_keysize = AES_MIN_KEY_SIZE,
 			.max_keysize = AES_MAX_KEY_SIZE,
 			.ivsize = AES_BLOCK_SIZE,
+			.chunksize = AES_BLOCK_SIZE,
+			.tailsize = 2 * AES_BLOCK_SIZE,
 			},
 		.cipher_mode = DRV_CIPHER_CBC_CTS,
 		.flow_mode = S_DIN_to_AES,
diff --git a/drivers/crypto/chelsio/chcr_algo.c b/drivers/crypto/chelsio/chcr_algo.c
index 177428480c7d..cdad84a26a58 100644
--- a/drivers/crypto/chelsio/chcr_algo.c
+++ b/drivers/crypto/chelsio/chcr_algo.c
@@ -3882,13 +3882,15 @@ static struct chcr_alg_template driver_algs[] = {
 		.alg.skcipher = {
 			.base.cra_name		= "xts(aes)",
 			.base.cra_driver_name	= "xts-aes-chcr",
-			.base.cra_blocksize	= AES_BLOCK_SIZE,
+			.base.cra_blocksize	= 1,
 
 			.init			= chcr_init_tfm,
 			.exit			= chcr_exit_tfm,
 			.min_keysize		= 2 * AES_MIN_KEY_SIZE,
 			.max_keysize		= 2 * AES_MAX_KEY_SIZE,
 			.ivsize			= AES_BLOCK_SIZE,
+			.chunksize		= AES_BLOCK_SIZE,
+			.tailsize		= 2 * AES_BLOCK_SIZE,
 			.setkey			= chcr_aes_xts_setkey,
 			.encrypt		= chcr_aes_encrypt,
 			.decrypt		= chcr_aes_decrypt,
diff --git a/drivers/crypto/hisilicon/sec/sec_algs.c b/drivers/crypto/hisilicon/sec/sec_algs.c
index 1189effcdad0..7dcbeb824d23 100644
--- a/drivers/crypto/hisilicon/sec/sec_algs.c
+++ b/drivers/crypto/hisilicon/sec/sec_algs.c
@@ -996,7 +996,7 @@ static struct skcipher_alg sec_algs[] = {
 			.cra_priority = 4001,
 			.cra_flags = CRYPTO_ALG_ASYNC |
 				     CRYPTO_ALG_ALLOCATES_MEMORY,
-			.cra_blocksize = AES_BLOCK_SIZE,
+			.cra_blocksize = 1,
 			.cra_ctxsize = sizeof(struct sec_alg_tfm_ctx),
 			.cra_alignmask = 0,
 			.cra_module = THIS_MODULE,
@@ -1009,6 +1009,8 @@ static struct skcipher_alg sec_algs[] = {
 		.min_keysize = 2 * AES_MIN_KEY_SIZE,
 		.max_keysize = 2 * AES_MAX_KEY_SIZE,
 		.ivsize = AES_BLOCK_SIZE,
+		.chunksize = AES_BLOCK_SIZE,
+		.tailsize = 2 * AES_BLOCK_SIZE,
 	}, {
 	/* Unable to find any test vectors so untested */
 		.base = {
diff --git a/drivers/crypto/hisilicon/sec2/sec_crypto.c b/drivers/crypto/hisilicon/sec2/sec_crypto.c
index 93a972fcbf63..2fe673da569e 100644
--- a/drivers/crypto/hisilicon/sec2/sec_crypto.c
+++ b/drivers/crypto/hisilicon/sec2/sec_crypto.c
@@ -2142,7 +2142,8 @@ static int sec_skcipher_decrypt(struct skcipher_request *sk_req)
 }
 
 #define SEC_SKCIPHER_ALG(sec_cra_name, sec_set_key, \
-	sec_min_key_size, sec_max_key_size, blk_size, iv_size)\
+	sec_min_key_size, sec_max_key_size, blk_size, iv_size, \
+	chunk_size, tail_size) \
 {\
 	.base = {\
 		.cra_name = sec_cra_name,\
@@ -2162,54 +2163,56 @@ static int sec_skcipher_decrypt(struct skcipher_request *sk_req)
 	.min_keysize = sec_min_key_size,\
 	.max_keysize = sec_max_key_size,\
 	.ivsize = iv_size,\
+	.chunksize = chunk_size,\
+	.tailsize = tail_size,\
 }
 
 static struct sec_skcipher sec_skciphers[] = {
 	{
 		.alg_msk = BIT(0),
 		.alg = SEC_SKCIPHER_ALG("ecb(aes)", sec_setkey_aes_ecb, AES_MIN_KEY_SIZE,
-					AES_MAX_KEY_SIZE, AES_BLOCK_SIZE, 0),
+					AES_MAX_KEY_SIZE, AES_BLOCK_SIZE, 0, 0, 0),
 	},
 	{
 		.alg_msk = BIT(1),
 		.alg = SEC_SKCIPHER_ALG("cbc(aes)", sec_setkey_aes_cbc, AES_MIN_KEY_SIZE,
-					AES_MAX_KEY_SIZE, AES_BLOCK_SIZE, AES_BLOCK_SIZE),
+					AES_MAX_KEY_SIZE, AES_BLOCK_SIZE, AES_BLOCK_SIZE, 0, 0),
 	},
 	{
 		.alg_msk = BIT(2),
 		.alg = SEC_SKCIPHER_ALG("ctr(aes)", sec_setkey_aes_ctr,	AES_MIN_KEY_SIZE,
-					AES_MAX_KEY_SIZE, SEC_MIN_BLOCK_SZ, AES_BLOCK_SIZE),
+					AES_MAX_KEY_SIZE, SEC_MIN_BLOCK_SZ, AES_BLOCK_SIZE, 0, 0),
 	},
 	{
 		.alg_msk = BIT(3),
 		.alg = SEC_SKCIPHER_ALG("xts(aes)", sec_setkey_aes_xts,	SEC_XTS_MIN_KEY_SIZE,
-					SEC_XTS_MAX_KEY_SIZE, AES_BLOCK_SIZE, AES_BLOCK_SIZE),
+					SEC_XTS_MAX_KEY_SIZE, 1, AES_BLOCK_SIZE, AES_BLOCK_SIZE, AES_BLOCK_SIZE * 2),
 	},
 	{
 		.alg_msk = BIT(12),
 		.alg = SEC_SKCIPHER_ALG("cbc(sm4)", sec_setkey_sm4_cbc,	AES_MIN_KEY_SIZE,
-					AES_MIN_KEY_SIZE, AES_BLOCK_SIZE, AES_BLOCK_SIZE),
+					AES_MIN_KEY_SIZE, AES_BLOCK_SIZE, AES_BLOCK_SIZE, 0, 0),
 	},
 	{
 		.alg_msk = BIT(13),
 		.alg = SEC_SKCIPHER_ALG("ctr(sm4)", sec_setkey_sm4_ctr, AES_MIN_KEY_SIZE,
-					AES_MIN_KEY_SIZE, SEC_MIN_BLOCK_SZ, AES_BLOCK_SIZE),
+					AES_MIN_KEY_SIZE, SEC_MIN_BLOCK_SZ, AES_BLOCK_SIZE, 0, 0),
 	},
 	{
 		.alg_msk = BIT(14),
 		.alg = SEC_SKCIPHER_ALG("xts(sm4)", sec_setkey_sm4_xts,	SEC_XTS_MIN_KEY_SIZE,
-					SEC_XTS_MIN_KEY_SIZE, AES_BLOCK_SIZE, AES_BLOCK_SIZE),
+					SEC_XTS_MIN_KEY_SIZE, 1, AES_BLOCK_SIZE, AES_BLOCK_SIZE, AES_BLOCK_SIZE * 2),
 	},
 	{
 		.alg_msk = BIT(23),
 		.alg = SEC_SKCIPHER_ALG("ecb(des3_ede)", sec_setkey_3des_ecb, SEC_DES3_3KEY_SIZE,
-					SEC_DES3_3KEY_SIZE, DES3_EDE_BLOCK_SIZE, 0),
+					SEC_DES3_3KEY_SIZE, DES3_EDE_BLOCK_SIZE, 0, 0, 0),
 	},
 	{
 		.alg_msk = BIT(24),
 		.alg = SEC_SKCIPHER_ALG("cbc(des3_ede)", sec_setkey_3des_cbc, SEC_DES3_3KEY_SIZE,
 					SEC_DES3_3KEY_SIZE, DES3_EDE_BLOCK_SIZE,
-					DES3_EDE_BLOCK_SIZE),
+					DES3_EDE_BLOCK_SIZE, 0, 0),
 	},
 };
 
diff --git a/drivers/crypto/inside-secure/safexcel_cipher.c b/drivers/crypto/inside-secure/safexcel_cipher.c
index 42677f7458b7..a7e8f99924c4 100644
--- a/drivers/crypto/inside-secure/safexcel_cipher.c
+++ b/drivers/crypto/inside-secure/safexcel_cipher.c
@@ -2484,6 +2484,8 @@ struct safexcel_alg_template safexcel_alg_xts_aes = {
 		.min_keysize = AES_MIN_KEY_SIZE * 2,
 		.max_keysize = AES_MAX_KEY_SIZE * 2,
 		.ivsize = XTS_BLOCK_SIZE,
+		.chunksize = XTS_BLOCK_SIZE,
+		.tailsize = XTS_BLOCK_SIZE * 2,
 		.base = {
 			.cra_name = "xts(aes)",
 			.cra_driver_name = "safexcel-xts-aes",
@@ -2491,7 +2493,7 @@ struct safexcel_alg_template safexcel_alg_xts_aes = {
 			.cra_flags = CRYPTO_ALG_ASYNC |
 				     CRYPTO_ALG_ALLOCATES_MEMORY |
 				     CRYPTO_ALG_KERN_DRIVER_ONLY,
-			.cra_blocksize = XTS_BLOCK_SIZE,
+			.cra_blocksize = 1,
 			.cra_ctxsize = sizeof(struct safexcel_cipher_ctx),
 			.cra_alignmask = 0,
 			.cra_init = safexcel_skcipher_aes_xts_cra_init,
diff --git a/drivers/crypto/intel/keembay/keembay-ocs-aes-core.c b/drivers/crypto/intel/keembay/keembay-ocs-aes-core.c
index 9b2d098e5eb2..6cde89563e1d 100644
--- a/drivers/crypto/intel/keembay/keembay-ocs-aes-core.c
+++ b/drivers/crypto/intel/keembay/keembay-ocs-aes-core.c
@@ -11,6 +11,7 @@
 #include <crypto/internal/aead.h>
 #include <crypto/internal/skcipher.h>
 #include <crypto/scatterwalk.h>
+#include <crypto/sm4.h>
 #include <linux/clk.h>
 #include <linux/completion.h>
 #include <linux/dma-mapping.h>
@@ -1331,7 +1332,7 @@ static struct skcipher_engine_alg algs[] = {
 		.base.base.cra_flags = CRYPTO_ALG_ASYNC |
 				       CRYPTO_ALG_KERN_DRIVER_ONLY |
 				       CRYPTO_ALG_NEED_FALLBACK,
-		.base.base.cra_blocksize = AES_BLOCK_SIZE,
+		.base.base.cra_blocksize = 1,
 		.base.base.cra_ctxsize = sizeof(struct ocs_aes_tctx),
 		.base.base.cra_module = THIS_MODULE,
 		.base.base.cra_alignmask = 0,
@@ -1339,6 +1340,8 @@ static struct skcipher_engine_alg algs[] = {
 		.base.min_keysize = OCS_AES_MIN_KEY_SIZE,
 		.base.max_keysize = OCS_AES_MAX_KEY_SIZE,
 		.base.ivsize = AES_BLOCK_SIZE,
+		.base.chunksize = AES_BLOCK_SIZE,
+		.base.tailsize = 2 * AES_BLOCK_SIZE,
 		.base.setkey = kmb_ocs_aes_set_key,
 		.base.encrypt = kmb_ocs_aes_cts_encrypt,
 		.base.decrypt = kmb_ocs_aes_cts_decrypt,
@@ -1418,14 +1421,16 @@ static struct skcipher_engine_alg algs[] = {
 		.base.base.cra_priority = KMB_OCS_PRIORITY,
 		.base.base.cra_flags = CRYPTO_ALG_ASYNC |
 				       CRYPTO_ALG_KERN_DRIVER_ONLY,
-		.base.base.cra_blocksize = AES_BLOCK_SIZE,
+		.base.base.cra_blocksize = 1,
 		.base.base.cra_ctxsize = sizeof(struct ocs_aes_tctx),
 		.base.base.cra_module = THIS_MODULE,
 		.base.base.cra_alignmask = 0,
 
 		.base.min_keysize = OCS_SM4_KEY_SIZE,
 		.base.max_keysize = OCS_SM4_KEY_SIZE,
-		.base.ivsize = AES_BLOCK_SIZE,
+		.base.ivsize = SM4_BLOCK_SIZE,
+		.base.chunksize = SM4_BLOCK_SIZE,
+		.base.tailsize = 2 * SM4_BLOCK_SIZE,
 		.base.setkey = kmb_ocs_sm4_set_key,
 		.base.encrypt = kmb_ocs_sm4_cts_encrypt,
 		.base.decrypt = kmb_ocs_sm4_cts_decrypt,
diff --git a/drivers/crypto/intel/qat/qat_common/qat_algs.c b/drivers/crypto/intel/qat/qat_common/qat_algs.c
index 3c4bba4a8779..945f245f7640 100644
--- a/drivers/crypto/intel/qat/qat_common/qat_algs.c
+++ b/drivers/crypto/intel/qat/qat_common/qat_algs.c
@@ -1368,7 +1368,7 @@ static struct skcipher_alg qat_skciphers[] = { {
 	.base.cra_priority = 4001,
 	.base.cra_flags = CRYPTO_ALG_ASYNC | CRYPTO_ALG_NEED_FALLBACK |
 			  CRYPTO_ALG_ALLOCATES_MEMORY,
-	.base.cra_blocksize = AES_BLOCK_SIZE,
+	.base.cra_blocksize = 1,
 	.base.cra_ctxsize = sizeof(struct qat_alg_skcipher_ctx),
 	.base.cra_alignmask = 0,
 	.base.cra_module = THIS_MODULE,
@@ -1381,6 +1381,8 @@ static struct skcipher_alg qat_skciphers[] = { {
 	.min_keysize = 2 * AES_MIN_KEY_SIZE,
 	.max_keysize = 2 * AES_MAX_KEY_SIZE,
 	.ivsize = AES_BLOCK_SIZE,
+	.chunksize = AES_BLOCK_SIZE,
+	.tailsize = 2 * AES_BLOCK_SIZE,
 } };
 
 int qat_algs_register(void)
diff --git a/drivers/crypto/marvell/octeontx/otx_cptvf_algs.c b/drivers/crypto/marvell/octeontx/otx_cptvf_algs.c
index 3c5d577d8f0d..67e90b79e0ad 100644
--- a/drivers/crypto/marvell/octeontx/otx_cptvf_algs.c
+++ b/drivers/crypto/marvell/octeontx/otx_cptvf_algs.c
@@ -1298,7 +1298,7 @@ static struct skcipher_alg otx_cpt_skciphers[] = { {
 	.base.cra_name = "xts(aes)",
 	.base.cra_driver_name = "cpt_xts_aes",
 	.base.cra_flags = CRYPTO_ALG_ASYNC | CRYPTO_ALG_ALLOCATES_MEMORY,
-	.base.cra_blocksize = AES_BLOCK_SIZE,
+	.base.cra_blocksize = 1,
 	.base.cra_ctxsize = sizeof(struct otx_cpt_enc_ctx),
 	.base.cra_alignmask = 7,
 	.base.cra_priority = 4001,
@@ -1306,6 +1306,8 @@ static struct skcipher_alg otx_cpt_skciphers[] = { {
 
 	.init = otx_cpt_enc_dec_init,
 	.ivsize = AES_BLOCK_SIZE,
+	.chunksize = AES_BLOCK_SIZE,
+	.tailsize = 2 * AES_BLOCK_SIZE,
 	.min_keysize = 2 * AES_MIN_KEY_SIZE,
 	.max_keysize = 2 * AES_MAX_KEY_SIZE,
 	.setkey = otx_cpt_skcipher_xts_setkey,
diff --git a/drivers/crypto/marvell/octeontx2/otx2_cptvf_algs.c b/drivers/crypto/marvell/octeontx2/otx2_cptvf_algs.c
index 1604fc58dc13..13b9662c5f85 100644
--- a/drivers/crypto/marvell/octeontx2/otx2_cptvf_algs.c
+++ b/drivers/crypto/marvell/octeontx2/otx2_cptvf_algs.c
@@ -1396,7 +1396,7 @@ static struct skcipher_alg otx2_cpt_skciphers[] = { {
 	.base.cra_name = "xts(aes)",
 	.base.cra_driver_name = "cpt_xts_aes",
 	.base.cra_flags = CRYPTO_ALG_ASYNC | CRYPTO_ALG_NEED_FALLBACK,
-	.base.cra_blocksize = AES_BLOCK_SIZE,
+	.base.cra_blocksize = 1,
 	.base.cra_ctxsize = sizeof(struct otx2_cpt_enc_ctx),
 	.base.cra_alignmask = 7,
 	.base.cra_priority = 4001,
@@ -1405,6 +1405,8 @@ static struct skcipher_alg otx2_cpt_skciphers[] = { {
 	.init = otx2_cpt_enc_dec_init,
 	.exit = otx2_cpt_skcipher_exit,
 	.ivsize = AES_BLOCK_SIZE,
+	.chunksize = AES_BLOCK_SIZE,
+	.tailsize = 2 * AES_BLOCK_SIZE,
 	.min_keysize = 2 * AES_MIN_KEY_SIZE,
 	.max_keysize = 2 * AES_MAX_KEY_SIZE,
 	.setkey = otx2_cpt_skcipher_xts_setkey,
diff --git a/drivers/crypto/qce/skcipher.c b/drivers/crypto/qce/skcipher.c
index 5b493fdc1e74..015a02ccdb7b 100644
--- a/drivers/crypto/qce/skcipher.c
+++ b/drivers/crypto/qce/skcipher.c
@@ -353,6 +353,7 @@ struct qce_skcipher_def {
 	unsigned int blocksize;
 	unsigned int chunksize;
 	unsigned int ivsize;
+	unsigned int tailsize;
 	unsigned int min_keysize;
 	unsigned int max_keysize;
 };
@@ -390,8 +391,10 @@ static const struct qce_skcipher_def skcipher_def[] = {
 		.flags		= QCE_ALG_AES | QCE_MODE_XTS,
 		.name		= "xts(aes)",
 		.drv_name	= "xts-aes-qce",
-		.blocksize	= AES_BLOCK_SIZE,
+		.blocksize	= 1,
 		.ivsize		= AES_BLOCK_SIZE,
+		.chunksize	= AES_BLOCK_SIZE,
+		.tailsize	= AES_BLOCK_SIZE * 2,
 		.min_keysize	= AES_MIN_KEY_SIZE * 2,
 		.max_keysize	= AES_MAX_KEY_SIZE * 2,
 	},
@@ -453,6 +456,7 @@ static int qce_skcipher_register_one(const struct qce_skcipher_def *def,
 	alg->base.cra_blocksize		= def->blocksize;
 	alg->chunksize			= def->chunksize;
 	alg->ivsize			= def->ivsize;
+	alg->tailsize			= def->tailsize;
 	alg->min_keysize		= def->min_keysize;
 	alg->max_keysize		= def->max_keysize;
 	alg->setkey			= IS_3DES(def->flags) ? qce_des3_setkey :
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

