Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB704269D03
	for <linux-crypto@vger.kernel.org>; Fri, 18 Apr 2025 03:00:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744945218; cv=none; b=fZIlPfWAm9AUN+qQghv78GiL7pzkf2ojYXp2fIO0s6fdYpMNsMVoOPY4Yqcjcgd+TmqmbZcfEWwsBynMEVOqBSBDrGotyx7AeI01pOsoNRDbBaEcoaLFxXiDi28RFZThkHd68acqwLDYTKOAHEMrrmmyJFzxXyYurjxmk89/Hfg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744945218; c=relaxed/simple;
	bh=kPnUWCPL04GprDGYvkseljJln0LQeBSjZrw0+n8ZVv4=;
	h=Date:Message-Id:In-Reply-To:References:From:Subject:To; b=i+T3LsoOCXo1u6CjeEPM7yNgY5WZ/4HjVLs0RS8XqjKpulb7HliwQvL6yQo2nj3j7BhelFhKz8HOvkyxoguGnoANWHxqAZeHAQiANPDdgShPbiWWBxRo0svwZEdFHhrtjkEAycObFsvNHYppkJu/ek5g7HY+gLydYdEN30dAlzU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=YSU1iL5U; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="YSU1iL5U"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=To:Subject:From:References:In-Reply-To:Message-Id:Date:Sender:
	Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=csPN8K5z1CIFQsTyMZ0+YtYPiNByTEOYomMgQdJdtBo=; b=YSU1iL5UgRsNLlqpvzIesLrk4d
	vzOMzMLgFn8/3BboQbFeDuU8dGi8joyGFgTPZwsKIqYHzFw4e+OXGfiCPoWWYT0LtqvCUnb18BzQ6
	PXSFkQN+wiQi7WbsDFHOd5DHlMbUNjxQakclR8JV8gNgcB/274oTAyFFwoaHI7DrCuw0Skth4hxpz
	tzHZg4OQ7nrAmISCXXuUCUxIHOFPz27+uVmyYFsFQ9ODIE0mw+4x5HmKC0n2EF9DU+2ZUOzVnlt3e
	afFk3/CoKyFcErgRydebiLA28LYhDX8XlgBBTLeuxUgclIbsuAZuqLul46r6IhhorqIoJY6aEpoW6
	kjdGSY2A==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1u5bxd-00GeBZ-1I;
	Fri, 18 Apr 2025 11:00:14 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 18 Apr 2025 11:00:13 +0800
Date: Fri, 18 Apr 2025 11:00:13 +0800
Message-Id: <6139886bc9294c6b05758039c834ed6f759eae70.1744945025.git.herbert@gondor.apana.org.au>
In-Reply-To: <cover.1744945025.git.herbert@gondor.apana.org.au>
References: <cover.1744945025.git.herbert@gondor.apana.org.au>
From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [v2 PATCH 41/67] crypto: s390/sha3 - Use API partial block handling
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>

Use the Crypto API partial block handling.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---
 arch/s390/crypto/sha3_256_s390.c | 60 +++++++++++++---------------
 arch/s390/crypto/sha3_512_s390.c | 67 +++++++++++++-------------------
 arch/s390/crypto/sha_common.c    |  4 +-
 3 files changed, 56 insertions(+), 75 deletions(-)

diff --git a/arch/s390/crypto/sha3_256_s390.c b/arch/s390/crypto/sha3_256_s390.c
index a84ef692f572..4a7731ac6bcd 100644
--- a/arch/s390/crypto/sha3_256_s390.c
+++ b/arch/s390/crypto/sha3_256_s390.c
@@ -8,12 +8,14 @@
  *   Copyright IBM Corp. 2019
  *   Author(s): Joerg Schmidbauer (jschmidb@de.ibm.com)
  */
-#include <crypto/internal/hash.h>
-#include <linux/init.h>
-#include <linux/module.h>
-#include <linux/cpufeature.h>
-#include <crypto/sha3.h>
 #include <asm/cpacf.h>
+#include <crypto/internal/hash.h>
+#include <crypto/sha3.h>
+#include <linux/cpufeature.h>
+#include <linux/errno.h>
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/string.h>
 
 #include "sha.h"
 
@@ -21,11 +23,11 @@ static int sha3_256_init(struct shash_desc *desc)
 {
 	struct s390_sha_ctx *sctx = shash_desc_ctx(desc);
 
-	if (!test_facility(86)) /* msa 12 */
+	sctx->first_message_part = test_facility(86);
+	if (!sctx->first_message_part)
 		memset(sctx->state, 0, sizeof(sctx->state));
 	sctx->count = 0;
 	sctx->func = CPACF_KIMD_SHA3_256;
-	sctx->first_message_part = 1;
 
 	return 0;
 }
@@ -35,11 +37,11 @@ static int sha3_256_export(struct shash_desc *desc, void *out)
 	struct s390_sha_ctx *sctx = shash_desc_ctx(desc);
 	struct sha3_state *octx = out;
 
-	octx->rsiz = sctx->count;
+	if (sctx->first_message_part) {
+		memset(sctx->state, 0, sizeof(sctx->state));
+		sctx->first_message_part = 0;
+	}
 	memcpy(octx->st, sctx->state, sizeof(octx->st));
-	memcpy(octx->buf, sctx->buf, sizeof(octx->buf));
-	octx->partial = sctx->first_message_part;
-
 	return 0;
 }
 
@@ -48,10 +50,9 @@ static int sha3_256_import(struct shash_desc *desc, const void *in)
 	struct s390_sha_ctx *sctx = shash_desc_ctx(desc);
 	const struct sha3_state *ictx = in;
 
-	sctx->count = ictx->rsiz;
+	sctx->count = 0;
 	memcpy(sctx->state, ictx->st, sizeof(ictx->st));
-	memcpy(sctx->buf, ictx->buf, sizeof(ictx->buf));
-	sctx->first_message_part = ictx->partial;
+	sctx->first_message_part = 0;
 	sctx->func = CPACF_KIMD_SHA3_256;
 
 	return 0;
@@ -60,30 +61,26 @@ static int sha3_256_import(struct shash_desc *desc, const void *in)
 static int sha3_224_import(struct shash_desc *desc, const void *in)
 {
 	struct s390_sha_ctx *sctx = shash_desc_ctx(desc);
-	const struct sha3_state *ictx = in;
 
-	sctx->count = ictx->rsiz;
-	memcpy(sctx->state, ictx->st, sizeof(ictx->st));
-	memcpy(sctx->buf, ictx->buf, sizeof(ictx->buf));
-	sctx->first_message_part = ictx->partial;
+	sha3_256_import(desc, in);
 	sctx->func = CPACF_KIMD_SHA3_224;
-
 	return 0;
 }
 
 static struct shash_alg sha3_256_alg = {
 	.digestsize	=	SHA3_256_DIGEST_SIZE,	   /* = 32 */
 	.init		=	sha3_256_init,
-	.update		=	s390_sha_update,
-	.final		=	s390_sha_final,
+	.update		=	s390_sha_update_blocks,
+	.finup		=	s390_sha_finup,
 	.export		=	sha3_256_export,
 	.import		=	sha3_256_import,
-	.descsize	=	sizeof(struct s390_sha_ctx),
-	.statesize	=	sizeof(struct sha3_state),
+	.descsize	=	S390_SHA_CTX_SIZE,
+	.statesize	=	SHA3_STATE_SIZE,
 	.base		=	{
 		.cra_name	 =	"sha3-256",
 		.cra_driver_name =	"sha3-256-s390",
 		.cra_priority	 =	300,
+		.cra_flags	 =	CRYPTO_AHASH_ALG_BLOCK_ONLY,
 		.cra_blocksize	 =	SHA3_256_BLOCK_SIZE,
 		.cra_module	 =	THIS_MODULE,
 	}
@@ -93,28 +90,25 @@ static int sha3_224_init(struct shash_desc *desc)
 {
 	struct s390_sha_ctx *sctx = shash_desc_ctx(desc);
 
-	if (!test_facility(86)) /* msa 12 */
-		memset(sctx->state, 0, sizeof(sctx->state));
-	sctx->count = 0;
+	sha3_256_init(desc);
 	sctx->func = CPACF_KIMD_SHA3_224;
-	sctx->first_message_part = 1;
-
 	return 0;
 }
 
 static struct shash_alg sha3_224_alg = {
 	.digestsize	=	SHA3_224_DIGEST_SIZE,
 	.init		=	sha3_224_init,
-	.update		=	s390_sha_update,
-	.final		=	s390_sha_final,
+	.update		=	s390_sha_update_blocks,
+	.finup		=	s390_sha_finup,
 	.export		=	sha3_256_export, /* same as for 256 */
 	.import		=	sha3_224_import, /* function code different! */
-	.descsize	=	sizeof(struct s390_sha_ctx),
-	.statesize	=	sizeof(struct sha3_state),
+	.descsize	=	S390_SHA_CTX_SIZE,
+	.statesize	=	SHA3_STATE_SIZE,
 	.base		=	{
 		.cra_name	 =	"sha3-224",
 		.cra_driver_name =	"sha3-224-s390",
 		.cra_priority	 =	300,
+		.cra_flags	 =	CRYPTO_AHASH_ALG_BLOCK_ONLY,
 		.cra_blocksize	 =	SHA3_224_BLOCK_SIZE,
 		.cra_module	 =	THIS_MODULE,
 	}
diff --git a/arch/s390/crypto/sha3_512_s390.c b/arch/s390/crypto/sha3_512_s390.c
index 07528fc98ff7..018f02fff444 100644
--- a/arch/s390/crypto/sha3_512_s390.c
+++ b/arch/s390/crypto/sha3_512_s390.c
@@ -7,12 +7,14 @@
  * Copyright IBM Corp. 2019
  * Author(s): Joerg Schmidbauer (jschmidb@de.ibm.com)
  */
-#include <crypto/internal/hash.h>
-#include <linux/init.h>
-#include <linux/module.h>
-#include <linux/cpufeature.h>
-#include <crypto/sha3.h>
 #include <asm/cpacf.h>
+#include <crypto/internal/hash.h>
+#include <crypto/sha3.h>
+#include <linux/cpufeature.h>
+#include <linux/errno.h>
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/string.h>
 
 #include "sha.h"
 
@@ -20,11 +22,11 @@ static int sha3_512_init(struct shash_desc *desc)
 {
 	struct s390_sha_ctx *sctx = shash_desc_ctx(desc);
 
-	if (!test_facility(86)) /* msa 12 */
+	sctx->first_message_part = test_facility(86);
+	if (!sctx->first_message_part)
 		memset(sctx->state, 0, sizeof(sctx->state));
 	sctx->count = 0;
 	sctx->func = CPACF_KIMD_SHA3_512;
-	sctx->first_message_part = 1;
 
 	return 0;
 }
@@ -34,13 +36,12 @@ static int sha3_512_export(struct shash_desc *desc, void *out)
 	struct s390_sha_ctx *sctx = shash_desc_ctx(desc);
 	struct sha3_state *octx = out;
 
-	octx->rsiz = sctx->count;
-	octx->rsizw = sctx->count >> 32;
 
+	if (sctx->first_message_part) {
+		memset(sctx->state, 0, sizeof(sctx->state));
+		sctx->first_message_part = 0;
+	}
 	memcpy(octx->st, sctx->state, sizeof(octx->st));
-	memcpy(octx->buf, sctx->buf, sizeof(octx->buf));
-	octx->partial = sctx->first_message_part;
-
 	return 0;
 }
 
@@ -49,13 +50,9 @@ static int sha3_512_import(struct shash_desc *desc, const void *in)
 	struct s390_sha_ctx *sctx = shash_desc_ctx(desc);
 	const struct sha3_state *ictx = in;
 
-	if (unlikely(ictx->rsizw))
-		return -ERANGE;
-	sctx->count = ictx->rsiz;
-
+	sctx->count = 0;
 	memcpy(sctx->state, ictx->st, sizeof(ictx->st));
-	memcpy(sctx->buf, ictx->buf, sizeof(ictx->buf));
-	sctx->first_message_part = ictx->partial;
+	sctx->first_message_part = 0;
 	sctx->func = CPACF_KIMD_SHA3_512;
 
 	return 0;
@@ -64,33 +61,26 @@ static int sha3_512_import(struct shash_desc *desc, const void *in)
 static int sha3_384_import(struct shash_desc *desc, const void *in)
 {
 	struct s390_sha_ctx *sctx = shash_desc_ctx(desc);
-	const struct sha3_state *ictx = in;
 
-	if (unlikely(ictx->rsizw))
-		return -ERANGE;
-	sctx->count = ictx->rsiz;
-
-	memcpy(sctx->state, ictx->st, sizeof(ictx->st));
-	memcpy(sctx->buf, ictx->buf, sizeof(ictx->buf));
-	sctx->first_message_part = ictx->partial;
+	sha3_512_import(desc, in);
 	sctx->func = CPACF_KIMD_SHA3_384;
-
 	return 0;
 }
 
 static struct shash_alg sha3_512_alg = {
 	.digestsize	=	SHA3_512_DIGEST_SIZE,
 	.init		=	sha3_512_init,
-	.update		=	s390_sha_update,
-	.final		=	s390_sha_final,
+	.update		=	s390_sha_update_blocks,
+	.finup		=	s390_sha_finup,
 	.export		=	sha3_512_export,
 	.import		=	sha3_512_import,
-	.descsize	=	sizeof(struct s390_sha_ctx),
-	.statesize	=	sizeof(struct sha3_state),
+	.descsize	=	S390_SHA_CTX_SIZE,
+	.statesize	=	SHA3_STATE_SIZE,
 	.base		=	{
 		.cra_name	 =	"sha3-512",
 		.cra_driver_name =	"sha3-512-s390",
 		.cra_priority	 =	300,
+		.cra_flags	 =	CRYPTO_AHASH_ALG_BLOCK_ONLY,
 		.cra_blocksize	 =	SHA3_512_BLOCK_SIZE,
 		.cra_module	 =	THIS_MODULE,
 	}
@@ -102,28 +92,25 @@ static int sha3_384_init(struct shash_desc *desc)
 {
 	struct s390_sha_ctx *sctx = shash_desc_ctx(desc);
 
-	if (!test_facility(86)) /* msa 12 */
-		memset(sctx->state, 0, sizeof(sctx->state));
-	sctx->count = 0;
+	sha3_512_init(desc);
 	sctx->func = CPACF_KIMD_SHA3_384;
-	sctx->first_message_part = 1;
-
 	return 0;
 }
 
 static struct shash_alg sha3_384_alg = {
 	.digestsize	=	SHA3_384_DIGEST_SIZE,
 	.init		=	sha3_384_init,
-	.update		=	s390_sha_update,
-	.final		=	s390_sha_final,
+	.update		=	s390_sha_update_blocks,
+	.finup		=	s390_sha_finup,
 	.export		=	sha3_512_export, /* same as for 512 */
 	.import		=	sha3_384_import, /* function code different! */
-	.descsize	=	sizeof(struct s390_sha_ctx),
-	.statesize	=	sizeof(struct sha3_state),
+	.descsize	=	S390_SHA_CTX_SIZE,
+	.statesize	=	SHA3_STATE_SIZE,
 	.base		=	{
 		.cra_name	 =	"sha3-384",
 		.cra_driver_name =	"sha3-384-s390",
 		.cra_priority	 =	300,
+		.cra_flags	 =	CRYPTO_AHASH_ALG_BLOCK_ONLY,
 		.cra_blocksize	 =	SHA3_384_BLOCK_SIZE,
 		.cra_ctxsize	 =	sizeof(struct s390_sha_ctx),
 		.cra_module	 =	THIS_MODULE,
diff --git a/arch/s390/crypto/sha_common.c b/arch/s390/crypto/sha_common.c
index 013bb37ad3ef..69e23e0c5394 100644
--- a/arch/s390/crypto/sha_common.c
+++ b/arch/s390/crypto/sha_common.c
@@ -29,7 +29,7 @@ int s390_sha_update(struct shash_desc *desc, const u8 *data, unsigned int len)
 
 	fc = ctx->func;
 	if (ctx->first_message_part)
-		fc |= test_facility(86) ? CPACF_KIMD_NIP : 0;
+		fc |= CPACF_KIMD_NIP;
 
 	/* process one stored block */
 	if (index) {
@@ -68,7 +68,7 @@ int s390_sha_update_blocks(struct shash_desc *desc, const u8 *data,
 
 	fc = ctx->func;
 	if (ctx->first_message_part)
-		fc |= test_facility(86) ? CPACF_KIMD_NIP : 0;
+		fc |= CPACF_KIMD_NIP;
 
 	/* process as many blocks as possible */
 	n = (len / bsize) * bsize;
-- 
2.39.5

