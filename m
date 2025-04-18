Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94B77268C5D
	for <linux-crypto@vger.kernel.org>; Fri, 18 Apr 2025 03:00:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744945251; cv=none; b=bGm2BOZxYp+S+V3h8pu7ioVzlTVzW0ApmRAbjbTuUYPMHGogQAmEn0pmlLlu65qdVDjUQyf6E5s/oAdenz25S9jZ2UimxSVZIOf3fJl5hveB0DCIE4T5CgZpS9h1DrG6qjTjqYD/aejkKV+bgn/iQSEc8N2RlUg1gN5zuYsIakE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744945251; c=relaxed/simple;
	bh=z6+c2uy5p5MDVNl2dtt8a5GCIMvg0pqU3d4n9oY8GNk=;
	h=Date:Message-Id:In-Reply-To:References:From:Subject:To; b=XT4NXqTqkFIC192Mm9nxkLG1CGRMwWTg52Nf9pWeQFoxNLCN1q2+7O/6FtfSli90nhD4sm3tRKBlDlo58jsoclfc3Pc+gdPYLTzbjWJysjbhU6VtaSqy5y7fVrDaxCjqJFroA21Fiz8puu5nNowojrY1p1OV6b+hLY8ZN4wYfEI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=OhSHYUii; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="OhSHYUii"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=To:Subject:From:References:In-Reply-To:Message-Id:Date:Sender:
	Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=/QZyI2wHRGLI6WGF8lIk6OwjeyN1UVWvba1YY9U3iOc=; b=OhSHYUiiEiboAVqTd4IaaxGkbX
	b23FV+jMnLWjpOu7tT7tFBPtb73/+ri9Z9MkO9a1qTQpcxoK7NxebJlnPhNysOWA1xr4oZbOZo+Zh
	4bX6r6dyiDxt4knVdtQbmiOHhJE1M6+zl+FVXpHcQOykGIsJW/B9uUml1f9/LPjBM1afWTUr7y+Je
	Rpi6De8l7xpmz0qYuni3Fjj6Y6bgzdD8bYXyn/67Px2A2v6Tz70H08fA8n1lxCUUy7DM1HEjaV+ue
	1MrBp1mN4CQLq+c6YkaW5FUWpRgRitIppznGELiho80ZRHnY40psgox2El6NMmUYL3eBC5ZzD5pja
	kNFeLxqw==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1u5by9-00GeHA-2g;
	Fri, 18 Apr 2025 11:00:46 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 18 Apr 2025 11:00:45 +0800
Date: Fri, 18 Apr 2025 11:00:45 +0800
Message-Id: <a274ebcf5ab4a85e4afbfdd8a18e2458011159f9.1744945025.git.herbert@gondor.apana.org.au>
In-Reply-To: <cover.1744945025.git.herbert@gondor.apana.org.au>
References: <cover.1744945025.git.herbert@gondor.apana.org.au>
From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [v2 PATCH 55/67] crypto: sm3-generic - Use API partial block handling
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>

Use the Crypto API partial block handling.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---
 crypto/sm3_generic.c      | 31 +++++++--------------------
 include/crypto/sm3.h      |  1 +
 include/crypto/sm3_base.h | 45 +++++++++++++++++++++++++++++++++++++--
 3 files changed, 52 insertions(+), 25 deletions(-)

diff --git a/crypto/sm3_generic.c b/crypto/sm3_generic.c
index a2d23a46924e..4fb6957c2f0c 100644
--- a/crypto/sm3_generic.c
+++ b/crypto/sm3_generic.c
@@ -9,15 +9,10 @@
  */
 
 #include <crypto/internal/hash.h>
-#include <linux/init.h>
-#include <linux/module.h>
-#include <linux/mm.h>
-#include <linux/types.h>
 #include <crypto/sm3.h>
 #include <crypto/sm3_base.h>
-#include <linux/bitops.h>
-#include <asm/byteorder.h>
-#include <linux/unaligned.h>
+#include <linux/kernel.h>
+#include <linux/module.h>
 
 const u8 sm3_zero_message_hash[SM3_DIGEST_SIZE] = {
 	0x1A, 0xB2, 0x1D, 0x83, 0x55, 0xCF, 0xA1, 0x7F,
@@ -30,38 +25,28 @@ EXPORT_SYMBOL_GPL(sm3_zero_message_hash);
 static int crypto_sm3_update(struct shash_desc *desc, const u8 *data,
 			  unsigned int len)
 {
-	sm3_update(shash_desc_ctx(desc), data, len);
-	return 0;
-}
-
-static int crypto_sm3_final(struct shash_desc *desc, u8 *out)
-{
-	sm3_final(shash_desc_ctx(desc), out);
-	return 0;
+	return sm3_base_do_update_blocks(desc, data, len, sm3_block_generic);
 }
 
 static int crypto_sm3_finup(struct shash_desc *desc, const u8 *data,
 			unsigned int len, u8 *hash)
 {
-	struct sm3_state *sctx = shash_desc_ctx(desc);
-
-	if (len)
-		sm3_update(sctx, data, len);
-	sm3_final(sctx, hash);
-	return 0;
+	sm3_base_do_finup(desc, data, len, sm3_block_generic);
+	return sm3_base_finish(desc, hash);
 }
 
 static struct shash_alg sm3_alg = {
 	.digestsize	=	SM3_DIGEST_SIZE,
 	.init		=	sm3_base_init,
 	.update		=	crypto_sm3_update,
-	.final		=	crypto_sm3_final,
 	.finup		=	crypto_sm3_finup,
-	.descsize	=	sizeof(struct sm3_state),
+	.descsize	=	SM3_STATE_SIZE,
 	.base		=	{
 		.cra_name	 =	"sm3",
 		.cra_driver_name =	"sm3-generic",
 		.cra_priority	=	100,
+		.cra_flags	 =	CRYPTO_AHASH_ALG_BLOCK_ONLY |
+					CRYPTO_AHASH_ALG_FINUP_MAX,
 		.cra_blocksize	 =	SM3_BLOCK_SIZE,
 		.cra_module	 =	THIS_MODULE,
 	}
diff --git a/include/crypto/sm3.h b/include/crypto/sm3.h
index d49211ba9a20..6dc95264a836 100644
--- a/include/crypto/sm3.h
+++ b/include/crypto/sm3.h
@@ -14,6 +14,7 @@
 
 #define SM3_DIGEST_SIZE	32
 #define SM3_BLOCK_SIZE	64
+#define SM3_STATE_SIZE	40
 
 #define SM3_T1		0x79CC4519
 #define SM3_T2		0x7A879D8A
diff --git a/include/crypto/sm3_base.h b/include/crypto/sm3_base.h
index 835896228e8e..9460589c8cb8 100644
--- a/include/crypto/sm3_base.h
+++ b/include/crypto/sm3_base.h
@@ -62,6 +62,49 @@ static inline int sm3_base_do_update(struct shash_desc *desc,
 	return 0;
 }
 
+static inline int sm3_base_do_update_blocks(struct shash_desc *desc,
+					    const u8 *data, unsigned int len,
+					    sm3_block_fn *block_fn)
+{
+	unsigned int remain = len - round_down(len, SM3_BLOCK_SIZE);
+	struct sm3_state *sctx = shash_desc_ctx(desc);
+
+	sctx->count += len - remain;
+	block_fn(sctx, data, len / SM3_BLOCK_SIZE);
+	return remain;
+}
+
+static inline int sm3_base_do_finup(struct shash_desc *desc,
+				    const u8 *src, unsigned int len,
+				    sm3_block_fn *block_fn)
+{
+	unsigned int bit_offset = SM3_BLOCK_SIZE / 8 - 1;
+	struct sm3_state *sctx = shash_desc_ctx(desc);
+	union {
+		__be64 b64[SM3_BLOCK_SIZE / 4];
+		u8 u8[SM3_BLOCK_SIZE * 2];
+	} block = {};
+
+	if (len >= SM3_BLOCK_SIZE) {
+		int remain;
+
+		remain = sm3_base_do_update_blocks(desc, src, len, block_fn);
+		src += len - remain;
+		len = remain;
+	}
+
+	if (len >= bit_offset * 8)
+		bit_offset += SM3_BLOCK_SIZE / 8;
+	memcpy(&block, src, len);
+	block.u8[len] = 0x80;
+	sctx->count += len;
+	block.b64[bit_offset] = cpu_to_be64(sctx->count << 3);
+	block_fn(sctx, block.u8, (bit_offset + 1) * 8 / SM3_BLOCK_SIZE);
+	memzero_explicit(&block, sizeof(block));
+
+	return 0;
+}
+
 static inline int sm3_base_do_finalize(struct shash_desc *desc,
 					sm3_block_fn *block_fn)
 {
@@ -93,8 +136,6 @@ static inline int sm3_base_finish(struct shash_desc *desc, u8 *out)
 
 	for (i = 0; i < SM3_DIGEST_SIZE / sizeof(__be32); i++)
 		put_unaligned_be32(sctx->state[i], digest++);
-
-	memzero_explicit(sctx, sizeof(*sctx));
 	return 0;
 }
 
-- 
2.39.5

