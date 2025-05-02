Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCACE3D6F
	for <linux-crypto@vger.kernel.org>; Fri,  2 May 2025 05:31:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746163866; cv=none; b=QugK6HoFmYQe5wQjaUeypje4Jt+nhVzcVZx4brGfVOd3EFLKzNFVeNdL8V7RCTh4Pyv5eI8cO59EbW+6DiwrPFk8o2w5nrF4loKBDrY9sSVwHEVdTu9qHJMW7zA66D/mWdh32RZ905KRdCgainuAfUH18gjowbDwfYlSdUuYsIQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746163866; c=relaxed/simple;
	bh=/092vDKI0jC6Eu/Iu4vTrVJgwKt14RwLIFFgnnmB5qE=;
	h=Date:Message-Id:In-Reply-To:References:From:Subject:To; b=RUvrVqdw0xbHbil0yjZVPB3zCxK8FNIYyZc+iM7zisxpoWRyNJJIGEsiLNcuroci4A6R0b5Uknm1xJzIb7LuEhQk1u3EnBvArTtym/Uq5Xk2pEprMQ66xHm0b8buQIa6303iSZbG8IuZx5vNvmHWYyUt8AufuNsWSWcfrgc7D4w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=cLk0jRcJ; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="cLk0jRcJ"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=To:Subject:From:References:In-Reply-To:Message-Id:Date:Sender:
	Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=R60FW3DMiGAexl+zhPl0TfHTpa2ofDgEGWwE1VOV5Eg=; b=cLk0jRcJlUwGg/Fg//yFAhTGCw
	4jvE5aTQBaIXFZ2oOHpLVbqIp2FTxVUbViFr6wOleIjWvBeZvJggbSWnb78IpqJXiuERM7f+OBNji
	dZzcg7fr6ORoc57zLkWkOTe2BHLvn9vpVBuxn8wzoxAt0j2sfrbzhn+9zJSi1/79bBnX97egPdcE0
	7812MfbVfwbkhvXXLDUZNU48XPTTqUqLa+Rz4jhUq0rXfxaE8pJ66RM6Xk9FWq9WlGB/kKdgg5NzK
	6aM7oQNppY7fol8osRv9M/7pf1APVPHO1yK/KUR7pD/zCfW+15mZupu0NeS0dLmkiml2033DCGrPr
	R7jUqgGQ==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1uAiz7-002lKF-2t;
	Fri, 02 May 2025 13:30:54 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 02 May 2025 13:30:53 +0800
Date: Fri, 02 May 2025 13:30:53 +0800
Message-Id: <c9e5c4beaad9c5876dc0f4ab15e16f020b992d9d.1746162259.git.herbert@gondor.apana.org.au>
In-Reply-To: <cover.1746162259.git.herbert@gondor.apana.org.au>
References: <cover.1746162259.git.herbert@gondor.apana.org.au>
From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [v2 PATCH 1/9] crypto: lib/sha256 - Add helpers for block-based shash
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>

Add an internal sha256_finup helper and move the finalisation code
from __sha256_final into it.

Also add sha256_choose_blocks and CRYPTO_ARCH_HAVE_LIB_SHA256_SIMD
so that the Crypto API can use the SIMD block function unconditionally.
The Crypto API must not be used in hard IRQs and there is no reason
to have a fallback path for hardirqs.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---
 include/crypto/internal/sha2.h | 45 ++++++++++++++++++++++++++++++++++
 lib/crypto/Kconfig             |  8 ++++++
 lib/crypto/sha256.c            | 32 +++++++-----------------
 3 files changed, 62 insertions(+), 23 deletions(-)

diff --git a/include/crypto/internal/sha2.h b/include/crypto/internal/sha2.h
index d641c67abcbc..fff156f66edc 100644
--- a/include/crypto/internal/sha2.h
+++ b/include/crypto/internal/sha2.h
@@ -3,7 +3,12 @@
 #ifndef _CRYPTO_INTERNAL_SHA2_H
 #define _CRYPTO_INTERNAL_SHA2_H
 
+#include <crypto/internal/simd.h>
 #include <crypto/sha2.h>
+#include <linux/compiler_attributes.h>
+#include <linux/string.h>
+#include <linux/types.h>
+#include <linux/unaligned.h>
 
 void sha256_update_generic(struct sha256_state *sctx,
 			   const u8 *data, size_t len);
@@ -24,5 +29,45 @@ void sha256_blocks_generic(u32 state[SHA256_STATE_WORDS],
 			   const u8 *data, size_t nblocks);
 void sha256_blocks_arch(u32 state[SHA256_STATE_WORDS],
 			const u8 *data, size_t nblocks);
+void sha256_blocks_simd(u32 state[SHA256_STATE_WORDS],
+			const u8 *data, size_t nblocks);
+
+static inline void sha256_choose_blocks(
+	u32 state[SHA256_STATE_WORDS], const u8 *data, size_t nblocks,
+	bool force_generic, bool force_simd)
+{
+	if (!IS_ENABLED(CONFIG_CRYPTO_ARCH_HAVE_LIB_SHA256) || force_generic)
+		sha256_blocks_generic(state, data, nblocks);
+	else if (IS_ENABLED(CONFIG_CRYPTO_ARCH_HAVE_LIB_SHA256_SIMD) &&
+		 (force_simd || crypto_simd_usable()))
+		sha256_blocks_simd(state, data, nblocks);
+	else
+		sha256_blocks_arch(state, data, nblocks);
+}
+
+static __always_inline void sha256_finup(
+	struct crypto_sha256_state *sctx, u8 buf[SHA256_BLOCK_SIZE],
+	size_t len, u8 out[SHA256_DIGEST_SIZE], size_t digest_size,
+	bool force_generic, bool force_simd)
+{
+	const size_t bit_offset = SHA256_BLOCK_SIZE - 8;
+	__be64 *bits = (__be64 *)&buf[bit_offset];
+	int i;
+
+	buf[len++] = 0x80;
+	if (len > bit_offset) {
+		memset(&buf[len], 0, SHA256_BLOCK_SIZE - len);
+		sha256_choose_blocks(sctx->state, buf, 1, force_generic,
+				     force_simd);
+		len = 0;
+	}
+
+	memset(&buf[len], 0, bit_offset - len);
+	*bits = cpu_to_be64(sctx->count << 3);
+	sha256_choose_blocks(sctx->state, buf, 1, force_generic, force_simd);
+
+	for (i = 0; i < digest_size; i += 4)
+		put_unaligned_be32(sctx->state[i / 4], out + i);
+}
 
 #endif /* _CRYPTO_INTERNAL_SHA2_H */
diff --git a/lib/crypto/Kconfig b/lib/crypto/Kconfig
index 6319358b38c2..1ec1466108cc 100644
--- a/lib/crypto/Kconfig
+++ b/lib/crypto/Kconfig
@@ -150,6 +150,14 @@ config CRYPTO_ARCH_HAVE_LIB_SHA256
 	  Declares whether the architecture provides an arch-specific
 	  accelerated implementation of the SHA-256 library interface.
 
+config CRYPTO_ARCH_HAVE_LIB_SHA256_SIMD
+	bool
+	help
+	  Declares whether the architecture provides an arch-specific
+	  accelerated implementation of the SHA-256 library interface
+	  that is SIMD-based and therefore not usable in hardirq
+	  context.
+
 config CRYPTO_LIB_SHA256_GENERIC
 	tristate
 	default CRYPTO_LIB_SHA256 if !CRYPTO_ARCH_HAVE_LIB_SHA256
diff --git a/lib/crypto/sha256.c b/lib/crypto/sha256.c
index 563f09c9f381..2ced29efa181 100644
--- a/lib/crypto/sha256.c
+++ b/lib/crypto/sha256.c
@@ -15,7 +15,6 @@
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/string.h>
-#include <linux/unaligned.h>
 
 /*
  * If __DISABLE_EXPORTS is defined, then this file is being compiled for a
@@ -26,14 +25,16 @@
 #include "sha256-generic.c"
 #endif
 
+static inline bool sha256_purgatory(void)
+{
+	return __is_defined(__DISABLE_EXPORTS);
+}
+
 static inline void sha256_blocks(u32 state[SHA256_STATE_WORDS], const u8 *data,
 				 size_t nblocks, bool force_generic)
 {
-#if IS_ENABLED(CONFIG_CRYPTO_ARCH_HAVE_LIB_SHA256) && !defined(__DISABLE_EXPORTS)
-	if (!force_generic)
-		return sha256_blocks_arch(state, data, nblocks);
-#endif
-	sha256_blocks_generic(state, data, nblocks);
+	sha256_choose_blocks(state, data, nblocks,
+			     force_generic || sha256_purgatory(), false);
 }
 
 static inline void __sha256_update(struct sha256_state *sctx, const u8 *data,
@@ -79,25 +80,10 @@ EXPORT_SYMBOL(sha256_update);
 static inline void __sha256_final(struct sha256_state *sctx, u8 *out,
 				  size_t digest_size, bool force_generic)
 {
-	const size_t bit_offset = SHA256_BLOCK_SIZE - sizeof(__be64);
-	__be64 *bits = (__be64 *)&sctx->buf[bit_offset];
 	size_t partial = sctx->count % SHA256_BLOCK_SIZE;
-	size_t i;
-
-	sctx->buf[partial++] = 0x80;
-	if (partial > bit_offset) {
-		memset(&sctx->buf[partial], 0, SHA256_BLOCK_SIZE - partial);
-		sha256_blocks(sctx->state, sctx->buf, 1, force_generic);
-		partial = 0;
-	}
-
-	memset(&sctx->buf[partial], 0, bit_offset - partial);
-	*bits = cpu_to_be64(sctx->count << 3);
-	sha256_blocks(sctx->state, sctx->buf, 1, force_generic);
-
-	for (i = 0; i < digest_size; i += 4)
-		put_unaligned_be32(sctx->state[i / 4], out + i);
 
+	sha256_finup(&sctx->ctx, sctx->buf, partial, out, digest_size,
+		     force_generic || sha256_purgatory(), false);
 	memzero_explicit(sctx, sizeof(*sctx));
 }
 
-- 
2.39.5

