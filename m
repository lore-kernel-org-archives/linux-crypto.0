Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 549AF268698
	for <linux-crypto@vger.kernel.org>; Fri, 18 Apr 2025 03:00:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744945214; cv=none; b=ejj50Snqyu733fKu/9E1u5AWqhGLzgcs0+95K/jhdVNNsdnIkcifo7vxvT9oqfQrq6JcOI2p1Ak7ykAQV3E/fMAl5uNvG6GcPnJkL9hB4gEUYrG1vE4UJaqYKs0FpByLY9rr1D+apnw2V5W3z9cGvx3mEHSDi+0XagGkYhD/J+o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744945214; c=relaxed/simple;
	bh=5wVrGI2gS5+HB3UdHS+8ZtgttZQhMVEM0MAswMETZJ8=;
	h=Date:Message-Id:In-Reply-To:References:From:Subject:To; b=s2V9vSM+Fry3FunLMUQ+P0K7BDmMZCGYZUH93zTsCdR6/rfNW+hBb+zYVosPl1oY1eIy7I7G9XkZYEXj9EfyRkCOJzXXcR2ygQX2Paf13V98NeiQy4ulhZcbRAruUKhACrox7gxL2oKz1lh3dCkZPZcTMXtQVEvFM0qGLRd9Mlw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=gq4uAl31; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="gq4uAl31"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=To:Subject:From:References:In-Reply-To:Message-Id:Date:Sender:
	Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=u/WXOO9pOHoqBv0bRLHcxi+DCIn+o/GeLwYlPL3aJEM=; b=gq4uAl31cZ77dIqGNl1uElmMpe
	GCZsZgRo6CrVDTFDHQwLtDpEw4Q278K7IePFPUoRppX+SiVre6xmtfLH4OVCcPYitqL2M95/eiCC2
	buZFsrzPrzjXGdUNABF7+kpH28z0vjfESD72g0EuEOu3dXtwsX5J7PvC/noD0pArFFBnFTiZlOUkT
	8wo6IQHYmG62VzP7NvE7Tk5O5JI/AfGOYxsyrLvaEddyMYaXcq5rS623juAVDX1PPXYIifwIFBbj8
	AEl8Rv3+ishqb4kHfrptv7TYT55kSFKhxsU8FQA4oh1K9aPiT8ApWInz2QQS7G2gGj0s8E+hAmuWg
	CWFtK9gg==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1u5bxY-00GeBD-2d;
	Fri, 18 Apr 2025 11:00:09 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 18 Apr 2025 11:00:08 +0800
Date: Fri, 18 Apr 2025 11:00:08 +0800
Message-Id: <81e0b146c9b6ca135bee16c89572c3234bb19d59.1744945025.git.herbert@gondor.apana.org.au>
In-Reply-To: <cover.1744945025.git.herbert@gondor.apana.org.au>
References: <cover.1744945025.git.herbert@gondor.apana.org.au>
From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [v2 PATCH 39/67] crypto: sha256_base - Remove partial block helpers
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>

Now that all sha256_base users have been converted to use the API
partial block handling, remove the partial block helpers.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---
 arch/x86/crypto/sha256_ssse3_glue.c |  4 +--
 include/crypto/sha256_base.h        | 50 ++++++++---------------------
 lib/crypto/sha256.c                 | 11 ++-----
 3 files changed, 17 insertions(+), 48 deletions(-)

diff --git a/arch/x86/crypto/sha256_ssse3_glue.c b/arch/x86/crypto/sha256_ssse3_glue.c
index 7c5b498c1a85..b3115e207a9f 100644
--- a/arch/x86/crypto/sha256_ssse3_glue.c
+++ b/arch/x86/crypto/sha256_ssse3_glue.c
@@ -50,7 +50,7 @@ MODULE_DEVICE_TABLE(x86cpu, module_cpu_ids);
 
 static int _sha256_update(struct shash_desc *desc, const u8 *data,
 			  unsigned int len,
-			  crypto_sha256_block_fn *sha256_xform)
+			  sha256_block_fn *sha256_xform)
 {
 	int remain;
 
@@ -68,7 +68,7 @@ static int _sha256_update(struct shash_desc *desc, const u8 *data,
 }
 
 static int sha256_finup(struct shash_desc *desc, const u8 *data,
-	      unsigned int len, u8 *out, crypto_sha256_block_fn *sha256_xform)
+	      unsigned int len, u8 *out, sha256_block_fn *sha256_xform)
 {
 	kernel_fpu_begin();
 	sha256_base_do_finup(desc, data, len, sha256_xform);
diff --git a/include/crypto/sha256_base.h b/include/crypto/sha256_base.h
index b9d3583b6256..08cd5e41d4fd 100644
--- a/include/crypto/sha256_base.h
+++ b/include/crypto/sha256_base.h
@@ -15,10 +15,8 @@
 #include <linux/types.h>
 #include <linux/unaligned.h>
 
-typedef void (sha256_block_fn)(struct sha256_state *sst, u8 const *src,
+typedef void (sha256_block_fn)(struct crypto_sha256_state *sst, u8 const *src,
 			       int blocks);
-typedef void (crypto_sha256_block_fn)(struct crypto_sha256_state *sst,
-				      u8 const *src, int blocks);
 
 static inline int sha224_base_init(struct shash_desc *desc)
 {
@@ -42,6 +40,7 @@ static inline int lib_sha256_base_do_update(struct sha256_state *sctx,
 					    sha256_block_fn *block_fn)
 {
 	unsigned int partial = sctx->count % SHA256_BLOCK_SIZE;
+	struct crypto_sha256_state *state = (void *)sctx;
 
 	sctx->count += len;
 
@@ -55,14 +54,14 @@ static inline int lib_sha256_base_do_update(struct sha256_state *sctx,
 			data += p;
 			len -= p;
 
-			block_fn(sctx, sctx->buf, 1);
+			block_fn(state, sctx->buf, 1);
 		}
 
 		blocks = len / SHA256_BLOCK_SIZE;
 		len %= SHA256_BLOCK_SIZE;
 
 		if (blocks) {
-			block_fn(sctx, data, blocks);
+			block_fn(state, data, blocks);
 			data += blocks * SHA256_BLOCK_SIZE;
 		}
 		partial = 0;
@@ -73,19 +72,9 @@ static inline int lib_sha256_base_do_update(struct sha256_state *sctx,
 	return 0;
 }
 
-static inline int sha256_base_do_update(struct shash_desc *desc,
-					const u8 *data,
-					unsigned int len,
-					sha256_block_fn *block_fn)
-{
-	struct sha256_state *sctx = shash_desc_ctx(desc);
-
-	return lib_sha256_base_do_update(sctx, data, len, block_fn);
-}
-
 static inline int lib_sha256_base_do_update_blocks(
 	struct crypto_sha256_state *sctx, const u8 *data, unsigned int len,
-	crypto_sha256_block_fn *block_fn)
+	sha256_block_fn *block_fn)
 {
 	unsigned int remain = len - round_down(len, SHA256_BLOCK_SIZE);
 
@@ -96,7 +85,7 @@ static inline int lib_sha256_base_do_update_blocks(
 
 static inline int sha256_base_do_update_blocks(
 	struct shash_desc *desc, const u8 *data, unsigned int len,
-	crypto_sha256_block_fn *block_fn)
+	sha256_block_fn *block_fn)
 {
 	return lib_sha256_base_do_update_blocks(shash_desc_ctx(desc), data,
 						len, block_fn);
@@ -104,7 +93,7 @@ static inline int sha256_base_do_update_blocks(
 
 static inline int lib_sha256_base_do_finup(struct crypto_sha256_state *sctx,
 					   const u8 *src, unsigned int len,
-					   crypto_sha256_block_fn *block_fn)
+					   sha256_block_fn *block_fn)
 {
 	unsigned int bit_offset = SHA256_BLOCK_SIZE / 8 - 1;
 	union {
@@ -126,7 +115,7 @@ static inline int lib_sha256_base_do_finup(struct crypto_sha256_state *sctx,
 
 static inline int sha256_base_do_finup(struct shash_desc *desc,
 				       const u8 *src, unsigned int len,
-				       crypto_sha256_block_fn *block_fn)
+				       sha256_block_fn *block_fn)
 {
 	struct crypto_sha256_state *sctx = shash_desc_ctx(desc);
 
@@ -144,23 +133,11 @@ static inline int sha256_base_do_finup(struct shash_desc *desc,
 static inline int lib_sha256_base_do_finalize(struct sha256_state *sctx,
 					      sha256_block_fn *block_fn)
 {
-	const int bit_offset = SHA256_BLOCK_SIZE - sizeof(__be64);
-	__be64 *bits = (__be64 *)(sctx->buf + bit_offset);
 	unsigned int partial = sctx->count % SHA256_BLOCK_SIZE;
+	struct crypto_sha256_state *state = (void *)sctx;
 
-	sctx->buf[partial++] = 0x80;
-	if (partial > bit_offset) {
-		memset(sctx->buf + partial, 0x0, SHA256_BLOCK_SIZE - partial);
-		partial = 0;
-
-		block_fn(sctx, sctx->buf, 1);
-	}
-
-	memset(sctx->buf + partial, 0x0, bit_offset - partial);
-	*bits = cpu_to_be64(sctx->count << 3);
-	block_fn(sctx, sctx->buf, 1);
-
-	return 0;
+	sctx->count -= partial;
+	return lib_sha256_base_do_finup(state, sctx->buf, partial, block_fn);
 }
 
 static inline int sha256_base_do_finalize(struct shash_desc *desc,
@@ -182,12 +159,11 @@ static inline int __sha256_base_finish(u32 state[SHA256_DIGEST_SIZE / 4],
 	return 0;
 }
 
-static inline int lib_sha256_base_finish(struct sha256_state *sctx, u8 *out,
-					 unsigned int digest_size)
+static inline void lib_sha256_base_finish(struct sha256_state *sctx, u8 *out,
+					  unsigned int digest_size)
 {
 	__sha256_base_finish(sctx->state, out, digest_size);
 	memzero_explicit(sctx, sizeof(*sctx));
-	return 0;
 }
 
 static inline int sha256_base_finish(struct shash_desc *desc, u8 *out)
diff --git a/lib/crypto/sha256.c b/lib/crypto/sha256.c
index 39ead0222937..a89bab377de1 100644
--- a/lib/crypto/sha256.c
+++ b/lib/crypto/sha256.c
@@ -132,22 +132,15 @@ void sha256_transform_blocks(struct crypto_sha256_state *sst,
 }
 EXPORT_SYMBOL_GPL(sha256_transform_blocks);
 
-static void lib_sha256_transform_blocks(struct sha256_state *sctx,
-					const u8 *input, int blocks)
-{
-	sha256_transform_blocks((struct crypto_sha256_state *)sctx, input,
-				blocks);
-}
-
 void sha256_update(struct sha256_state *sctx, const u8 *data, unsigned int len)
 {
-	lib_sha256_base_do_update(sctx, data, len, lib_sha256_transform_blocks);
+	lib_sha256_base_do_update(sctx, data, len, sha256_transform_blocks);
 }
 EXPORT_SYMBOL(sha256_update);
 
 static void __sha256_final(struct sha256_state *sctx, u8 *out, int digest_size)
 {
-	lib_sha256_base_do_finalize(sctx, lib_sha256_transform_blocks);
+	lib_sha256_base_do_finalize(sctx, sha256_transform_blocks);
 	lib_sha256_base_finish(sctx, out, digest_size);
 }
 
-- 
2.39.5

