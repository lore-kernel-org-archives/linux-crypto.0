Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 237EE268C78
	for <linux-crypto@vger.kernel.org>; Fri, 18 Apr 2025 03:01:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744945262; cv=none; b=hoPEkwwju/l4pGvm6kGhVbzUSm8ekVejU9ZSWzDZAK5EM492ngRttqECwBdQ/hfGIC+bHOGPZXEIBvF1PL7qhDHJ21iycNtD2q+BGoXj5JP659os/7TAXK4uGab4JTwB5rX6uL1maMV0U3go42WhdbfdDRSQFYJXFMBVT3bwTZ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744945262; c=relaxed/simple;
	bh=dfNbIsXQHToDrEGE+EtMScO6oM8R6Due51q6kz8zv5U=;
	h=Date:Message-Id:In-Reply-To:References:From:Subject:To; b=B6/DTGlnynESChLSX5/l9NktCTPC0kW0vSCBuFVhh1x73XEqS2Mgqo6AB5NS3Re1b7ECrpkveN6RRR3hveSeg3mEJuU/U8RoNT7LZOBX556H1XNeayMMMmNyWpNHeV7lD8qFvOHYRcX8j7pCDahV7KqHEm+tvQJaEXmotX1nssw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=Skw/Eu0O; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="Skw/Eu0O"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=To:Subject:From:References:In-Reply-To:Message-Id:Date:Sender:
	Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=EdZlhMvgzRu6AICH3kL4akeIuzBk8xM74RpK6P87z9I=; b=Skw/Eu0OkATbgflHzdq1/yhFQY
	9oXfQtcUDEjRuITzvl4Y9C2vdgokjtW4MaYSFQyDKnFwEUpnGCmYGgG7+TmD4quivKNbTa1OHwl3z
	Lf0T9p5W0jAPLB+2yq3gKKR/ODLjKj978N7Q5zoNDiHbazuiKN8Kzd39wUrimEJqpXvENVkbRg5o2
	XWJAAa1ts5jTK9k1E21kBYGPN/OxeaH8mj5WBPqWwhFtGOZ9H0kNMHNwKLpCEvxr78tBzBJnBQXdY
	FkAxgowEMDrD/Xzoi6HSW5wIlHd6ceWpgShg5VJIvoYb8WTVFY57jGPUIKkaq62RM667vu9su22U2
	2N+6rlMA==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1u5byL-00GeIR-1h;
	Fri, 18 Apr 2025 11:00:58 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 18 Apr 2025 11:00:57 +0800
Date: Fri, 18 Apr 2025 11:00:57 +0800
Message-Id: <af345a7b596347b32e9f1ae7b305c7e9d7f48c30.1744945025.git.herbert@gondor.apana.org.au>
In-Reply-To: <cover.1744945025.git.herbert@gondor.apana.org.au>
References: <cover.1744945025.git.herbert@gondor.apana.org.au>
From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [v2 PATCH 60/67] crypto: lib/sm3 - Remove partial block helpers
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>

Now that all sm3_base users have been converted to use the API
partial block handling, remove the partial block helpers as well
as the lib/crypto functions.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---
 include/crypto/sm3.h      |  2 --
 include/crypto/sm3_base.h | 64 ++----------------------------------
 lib/crypto/sm3.c          | 68 +++------------------------------------
 3 files changed, 6 insertions(+), 128 deletions(-)

diff --git a/include/crypto/sm3.h b/include/crypto/sm3.h
index 6dc95264a836..c8d02c86c298 100644
--- a/include/crypto/sm3.h
+++ b/include/crypto/sm3.h
@@ -60,7 +60,5 @@ static inline void sm3_init(struct sm3_state *sctx)
 }
 
 void sm3_block_generic(struct sm3_state *sctx, u8 const *data, int blocks);
-void sm3_update(struct sm3_state *sctx, const u8 *data, unsigned int len);
-void sm3_final(struct sm3_state *sctx, u8 *out);
 
 #endif
diff --git a/include/crypto/sm3_base.h b/include/crypto/sm3_base.h
index 9460589c8cb8..7c53570bc05e 100644
--- a/include/crypto/sm3_base.h
+++ b/include/crypto/sm3_base.h
@@ -11,9 +11,10 @@
 
 #include <crypto/internal/hash.h>
 #include <crypto/sm3.h>
-#include <linux/crypto.h>
+#include <linux/math.h>
 #include <linux/module.h>
 #include <linux/string.h>
+#include <linux/types.h>
 #include <linux/unaligned.h>
 
 typedef void (sm3_block_fn)(struct sm3_state *sst, u8 const *src, int blocks);
@@ -24,44 +25,6 @@ static inline int sm3_base_init(struct shash_desc *desc)
 	return 0;
 }
 
-static inline int sm3_base_do_update(struct shash_desc *desc,
-				      const u8 *data,
-				      unsigned int len,
-				      sm3_block_fn *block_fn)
-{
-	struct sm3_state *sctx = shash_desc_ctx(desc);
-	unsigned int partial = sctx->count % SM3_BLOCK_SIZE;
-
-	sctx->count += len;
-
-	if (unlikely((partial + len) >= SM3_BLOCK_SIZE)) {
-		int blocks;
-
-		if (partial) {
-			int p = SM3_BLOCK_SIZE - partial;
-
-			memcpy(sctx->buffer + partial, data, p);
-			data += p;
-			len -= p;
-
-			block_fn(sctx, sctx->buffer, 1);
-		}
-
-		blocks = len / SM3_BLOCK_SIZE;
-		len %= SM3_BLOCK_SIZE;
-
-		if (blocks) {
-			block_fn(sctx, data, blocks);
-			data += blocks * SM3_BLOCK_SIZE;
-		}
-		partial = 0;
-	}
-	if (len)
-		memcpy(sctx->buffer + partial, data, len);
-
-	return 0;
-}
-
 static inline int sm3_base_do_update_blocks(struct shash_desc *desc,
 					    const u8 *data, unsigned int len,
 					    sm3_block_fn *block_fn)
@@ -105,29 +68,6 @@ static inline int sm3_base_do_finup(struct shash_desc *desc,
 	return 0;
 }
 
-static inline int sm3_base_do_finalize(struct shash_desc *desc,
-					sm3_block_fn *block_fn)
-{
-	const int bit_offset = SM3_BLOCK_SIZE - sizeof(__be64);
-	struct sm3_state *sctx = shash_desc_ctx(desc);
-	__be64 *bits = (__be64 *)(sctx->buffer + bit_offset);
-	unsigned int partial = sctx->count % SM3_BLOCK_SIZE;
-
-	sctx->buffer[partial++] = 0x80;
-	if (partial > bit_offset) {
-		memset(sctx->buffer + partial, 0x0, SM3_BLOCK_SIZE - partial);
-		partial = 0;
-
-		block_fn(sctx, sctx->buffer, 1);
-	}
-
-	memset(sctx->buffer + partial, 0x0, bit_offset - partial);
-	*bits = cpu_to_be64(sctx->count << 3);
-	block_fn(sctx, sctx->buffer, 1);
-
-	return 0;
-}
-
 static inline int sm3_base_finish(struct shash_desc *desc, u8 *out)
 {
 	struct sm3_state *sctx = shash_desc_ctx(desc);
diff --git a/lib/crypto/sm3.c b/lib/crypto/sm3.c
index de64aa913280..efff0e267d84 100644
--- a/lib/crypto/sm3.c
+++ b/lib/crypto/sm3.c
@@ -8,9 +8,11 @@
  * Copyright (C) 2021 Tianjia Zhang <tianjia.zhang@linux.alibaba.com>
  */
 
-#include <linux/module.h>
-#include <linux/unaligned.h>
 #include <crypto/sm3.h>
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/string.h>
+#include <linux/unaligned.h>
 
 static const u32 ____cacheline_aligned K[64] = {
 	0x79cc4519, 0xf3988a32, 0xe7311465, 0xce6228cb,
@@ -179,67 +181,5 @@ void sm3_block_generic(struct sm3_state *sctx, u8 const *data, int blocks)
 }
 EXPORT_SYMBOL_GPL(sm3_block_generic);
 
-void sm3_update(struct sm3_state *sctx, const u8 *data, unsigned int len)
-{
-	unsigned int partial = sctx->count % SM3_BLOCK_SIZE;
-
-	sctx->count += len;
-
-	if ((partial + len) >= SM3_BLOCK_SIZE) {
-		int blocks;
-
-		if (partial) {
-			int p = SM3_BLOCK_SIZE - partial;
-
-			memcpy(sctx->buffer + partial, data, p);
-			data += p;
-			len -= p;
-
-			sm3_block_generic(sctx, sctx->buffer, 1);
-		}
-
-		blocks = len / SM3_BLOCK_SIZE;
-		len %= SM3_BLOCK_SIZE;
-
-		if (blocks) {
-			sm3_block_generic(sctx, data, blocks);
-			data += blocks * SM3_BLOCK_SIZE;
-		}
-
-		partial = 0;
-	}
-	if (len)
-		memcpy(sctx->buffer + partial, data, len);
-}
-EXPORT_SYMBOL_GPL(sm3_update);
-
-void sm3_final(struct sm3_state *sctx, u8 *out)
-{
-	const int bit_offset = SM3_BLOCK_SIZE - sizeof(u64);
-	__be64 *bits = (__be64 *)(sctx->buffer + bit_offset);
-	__be32 *digest = (__be32 *)out;
-	unsigned int partial = sctx->count % SM3_BLOCK_SIZE;
-	int i;
-
-	sctx->buffer[partial++] = 0x80;
-	if (partial > bit_offset) {
-		memset(sctx->buffer + partial, 0, SM3_BLOCK_SIZE - partial);
-		partial = 0;
-
-		sm3_block_generic(sctx, sctx->buffer, 1);
-	}
-
-	memset(sctx->buffer + partial, 0, bit_offset - partial);
-	*bits = cpu_to_be64(sctx->count << 3);
-	sm3_block_generic(sctx, sctx->buffer, 1);
-
-	for (i = 0; i < 8; i++)
-		put_unaligned_be32(sctx->state[i], digest++);
-
-	/* Zeroize sensitive information. */
-	memzero_explicit(sctx, sizeof(*sctx));
-}
-EXPORT_SYMBOL_GPL(sm3_final);
-
 MODULE_DESCRIPTION("Generic SM3 library");
 MODULE_LICENSE("GPL v2");
-- 
2.39.5

