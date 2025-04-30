Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39F5D1E5B78
	for <linux-crypto@vger.kernel.org>; Wed, 30 Apr 2025 06:06:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745993206; cv=none; b=i1arwGrZisJB10PpqMEFdHX5+yrbHzsVDHQNNKpU4nlat9He5b3v3qQqR05+S3xoKgrnjQaPH0S0Ql+SmvJ9y8tZl6nKOX+zFaZnpXXBlt+PzRG7XT0I1A1FrkRb8iLN6ADP4duHViB8aRhHeWbaYlsaDDRXF4S/GVoeMLzEYY4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745993206; c=relaxed/simple;
	bh=rGBaW5Zm6Y0yApqkMQFTJkbr8/vE3xs98UvLXYf4w7o=;
	h=Date:Message-Id:In-Reply-To:References:From:Subject:To; b=eWEtDuL/bj6A5LqYRsiIYJNNeMMRZgzrq5noYU5U8epMuZnF2NY/ARHk8HrnVIw3FM8xJ+pYhaRKLWZXsRONfldEQTkPNb+fybFxfBbWlak14EFN21gO5FPgX3CGyTk7DfxcQ8z5+Tgc3XUwoQqt5bJiMdBQ00h+0FDvJMeqqPI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=mrcj5bVS; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="mrcj5bVS"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=To:Subject:From:References:In-Reply-To:Message-Id:Date:Sender:
	Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=e6jM9cbI82J3LROUlhbl54tA+NLFfhFStzUtlyi8fo0=; b=mrcj5bVS8QDYi4twltlwnQM8c1
	mrqT5lU2t50YxYLwd3YxMyiHWLwYZMPW9l8B0s5k/8lWy7ROLcEbGPtHJ+r7mvVrn1k/kXW660zP9
	sU5jr5D4GVkbdh+BGFewZ1HTnVIri1LyjCM5HAjKumBTUW1eYHFsEAJcp9EF4culeNkpvslO+eDtI
	ltkPJZYj6qEDww0/U8C8bDQpNuDE9nL7JXuKPRPV3kBHFoJtUMu+WqGBD0T4qtGVbVxhOVM1u4rdp
	TgkEeohuJM8DrZ407vT/onA8BEW2UUAwGCdG38C5rT89V5oQUmUk/KmEypemo+DmF4no75uAOdpy/
	r219GnEg==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1uA0ae-002Abq-1o;
	Wed, 30 Apr 2025 14:06:41 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Wed, 30 Apr 2025 14:06:40 +0800
Date: Wed, 30 Apr 2025 14:06:40 +0800
Message-Id: <cf645ff0d7941dfcd52cb6ddc60e45e94e0ff1a7.1745992998.git.herbert@gondor.apana.org.au>
In-Reply-To: <cover.1745992998.git.herbert@gondor.apana.org.au>
References: <cover.1745992998.git.herbert@gondor.apana.org.au>
From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 11/12] crypto: lib/sha256 - Use generic block helper
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>

Use the BLOCK_HASH_UPDATE_BLOCKS helper instead of duplicating
partial block handling.

Also remove the unused lib/sha256 force-generic interface.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---
 lib/crypto/sha256.c | 75 ++++++++-------------------------------------
 1 file changed, 12 insertions(+), 63 deletions(-)

diff --git a/lib/crypto/sha256.c b/lib/crypto/sha256.c
index b5ffff032718..35019d3b2874 100644
--- a/lib/crypto/sha256.c
+++ b/lib/crypto/sha256.c
@@ -11,6 +11,7 @@
  * Copyright (c) 2014 Red Hat Inc.
  */
 
+#include <crypto/internal/blockhash.h>
 #include <crypto/internal/sha2.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
@@ -31,72 +32,41 @@ static inline bool sha256_purgatory(void)
 }
 
 static inline void sha256_blocks(u32 state[SHA256_STATE_WORDS], const u8 *data,
-				 size_t nblocks, bool force_generic)
+				 size_t nblocks)
 {
-	sha256_choose_blocks(state, data, nblocks,
-			     force_generic || sha256_purgatory(), false);
-}
-
-static inline void __sha256_update(struct sha256_state *sctx, const u8 *data,
-				   size_t len, bool force_generic)
-{
-	size_t partial = sctx->count % SHA256_BLOCK_SIZE;
-
-	sctx->count += len;
-
-	if (partial + len >= SHA256_BLOCK_SIZE) {
-		size_t nblocks;
-
-		if (partial) {
-			size_t l = SHA256_BLOCK_SIZE - partial;
-
-			memcpy(&sctx->buf[partial], data, l);
-			data += l;
-			len -= l;
-
-			sha256_blocks(sctx->state, sctx->buf, 1, force_generic);
-		}
-
-		nblocks = len / SHA256_BLOCK_SIZE;
-		len %= SHA256_BLOCK_SIZE;
-
-		if (nblocks) {
-			sha256_blocks(sctx->state, data, nblocks,
-				      force_generic);
-			data += nblocks * SHA256_BLOCK_SIZE;
-		}
-		partial = 0;
-	}
-	if (len)
-		memcpy(&sctx->buf[partial], data, len);
+	sha256_choose_blocks(state, data, nblocks, sha256_purgatory(), false);
 }
 
 void sha256_update(struct sha256_state *sctx, const u8 *data, size_t len)
 {
-	__sha256_update(sctx, data, len, false);
+	size_t partial = sctx->count % SHA256_BLOCK_SIZE;
+
+	sctx->count += len;
+	BLOCK_HASH_UPDATE_BLOCKS(sha256_blocks, sctx->ctx.state, data, len,
+				 SHA256_BLOCK_SIZE, sctx->buf, partial);
 }
 EXPORT_SYMBOL(sha256_update);
 
 static inline void __sha256_final(struct sha256_state *sctx, u8 *out,
-				  size_t digest_size, bool force_generic)
+				  size_t digest_size)
 {
 	unsigned int len = sctx->count % SHA256_BLOCK_SIZE;
 
 	sctx->count -= len;
 	sha256_finup(&sctx->ctx, sctx->buf, len, out, digest_size,
-		     force_generic || sha256_purgatory(), false);
+		     sha256_purgatory(), false);
 	memzero_explicit(sctx, sizeof(*sctx));
 }
 
 void sha256_final(struct sha256_state *sctx, u8 out[SHA256_DIGEST_SIZE])
 {
-	__sha256_final(sctx, out, SHA256_DIGEST_SIZE, false);
+	__sha256_final(sctx, out, SHA256_DIGEST_SIZE);
 }
 EXPORT_SYMBOL(sha256_final);
 
 void sha224_final(struct sha256_state *sctx, u8 out[SHA224_DIGEST_SIZE])
 {
-	__sha256_final(sctx, out, SHA224_DIGEST_SIZE, false);
+	__sha256_final(sctx, out, SHA224_DIGEST_SIZE);
 }
 EXPORT_SYMBOL(sha224_final);
 
@@ -110,26 +80,5 @@ void sha256(const u8 *data, size_t len, u8 out[SHA256_DIGEST_SIZE])
 }
 EXPORT_SYMBOL(sha256);
 
-#if IS_ENABLED(CONFIG_CRYPTO_SHA256) && !defined(__DISABLE_EXPORTS)
-void sha256_update_generic(struct sha256_state *sctx,
-			   const u8 *data, size_t len)
-{
-	__sha256_update(sctx, data, len, true);
-}
-EXPORT_SYMBOL(sha256_update_generic);
-
-void sha256_final_generic(struct sha256_state *sctx, u8 out[SHA256_DIGEST_SIZE])
-{
-	__sha256_final(sctx, out, SHA256_DIGEST_SIZE, true);
-}
-EXPORT_SYMBOL(sha256_final_generic);
-
-void sha224_final_generic(struct sha256_state *sctx, u8 out[SHA224_DIGEST_SIZE])
-{
-	__sha256_final(sctx, out, SHA224_DIGEST_SIZE, true);
-}
-EXPORT_SYMBOL(sha224_final_generic);
-#endif
-
 MODULE_DESCRIPTION("SHA-256 Algorithm");
 MODULE_LICENSE("GPL");
-- 
2.39.5

