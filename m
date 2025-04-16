Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3957823A564
	for <linux-crypto@vger.kernel.org>; Wed, 16 Apr 2025 06:44:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744785863; cv=none; b=Wnq8iuioJw/sW5iIRPFRJfW31VgJOqiy5oi4ctElyGmtarfBkFjh3WQmigcS07/EzMsNaQeL8N4Yv93w2Qz4NPwyOHio5W3QFIuTYP+Oz5NUt/93yD5FvOHaFSjfTRq3yTHvOPBtrYvh5G/TzsWcQOfa7GRxqDnMARtLn0tbfQg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744785863; c=relaxed/simple;
	bh=kPnUWCPL04GprDGYvkseljJln0LQeBSjZrw0+n8ZVv4=;
	h=Date:Message-Id:In-Reply-To:References:From:Subject:To; b=G7ZtZLa+or+zSPjVdMmucm3AuzMqyEnWkH1NJ1oNSMzRbnniN2UFmE/uGwKowRQ3OGqXrUxnzBYWUsbadzTcSFYvAVkaGq+CvatVGHdbhGPke7G3VDEiKVYXwEeuz655RWn6fjLbnNTii9jeyB8U7iSP3sUSz7cufS5HbZZiRXE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=CHcnCi/0; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="CHcnCi/0"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=To:Subject:From:References:In-Reply-To:Message-Id:Date:Sender:
	Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=csPN8K5z1CIFQsTyMZ0+YtYPiNByTEOYomMgQdJdtBo=; b=CHcnCi/0GE8aRzLWm34DkkkRh8
	pg7kn4r7QncN+o6Og4NRrLkl7hmYAnYIc2xqddcOzK3B1Z8B3I48BRq4AGI6sq88L3vMDABy7yFze
	j3SdWtAkv2OJGg/PkBVER6ldHloOFbp+X118Y4BTfQQtzWKdOU0GiCcZEkKdqdc+TP1nQaM9dA8u/
	HvwPma3ByTy8yEYurPy2bMvB7iBzHzuILr8CEK33OBr8KjI/9MjB3D4R5AV5JbsEUwiZgg/6sBCAY
	DqFSLAqGp9lXmvZRRQdbX57Bp/0x/kNTLrKl+wkstrYoW2Gj01zcKY+9H7EkOKO4SkBb3kOaUPtr4
	F9ecWmxQ==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1u4wVN-00G6OU-1I;
	Wed, 16 Apr 2025 14:44:18 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Wed, 16 Apr 2025 14:44:17 +0800
Date: Wed, 16 Apr 2025 14:44:17 +0800
Message-Id: <cb54cd7b9e5396bc46a6236539e47c1ee64cb8d1.1744784515.git.herbert@gondor.apana.org.au>
In-Reply-To: <cover.1744784515.git.herbert@gondor.apana.org.au>
References: <cover.1744784515.git.herbert@gondor.apana.org.au>
From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 41/67] crypto: s390/sha3 - Use API partial block handling
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

