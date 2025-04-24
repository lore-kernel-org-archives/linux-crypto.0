Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76A56225A47
	for <linux-crypto@vger.kernel.org>; Thu, 24 Apr 2025 10:47:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745491643; cv=none; b=alFqdSDPhlcsTiWfN9t4+KrloI+POf+8dr7d7kgquUreUcjwvOTqjmAEfY393pvT0SRNlvPnA1AVRfPg5rGAK+m02L27zMl07Rmk1IwXeMweBX5WMy8ObpQ9zC+2WBUJcpB5J7EJgLgXa7chIF9d375Uj+B1fhto+L5Ui/6uRYc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745491643; c=relaxed/simple;
	bh=UsMZBCD5SaCF48KNqiXQ031n4pNhyPVGFmDcLfoshwI=;
	h=Date:Message-Id:In-Reply-To:References:From:Subject:To; b=EPg91Xnnvq61yDJrINjYTPv4vKZivUjADfWMEH+ypH4do+J7csuVkTieNYT1ZAUDCdNiDrEjf+bxLPCqp2mYHg46rVKhfCHDumdVK3WozWxmLqHatZ8YmkOBAUF4wRdt3lz1annNV4FMlR3BwrsSveH+lFmAMK8INvKCTFT5O0c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=hXZPtSm1; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="hXZPtSm1"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=To:Subject:From:References:In-Reply-To:Message-Id:Date:Sender:
	Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=jU4PS2dP4ny+hkgHM9GdrByIvEyYgtPJ80/WwT6ZJ8Y=; b=hXZPtSm1tEPXcJV97ay8d3FP0f
	ptn7QkAnDYINHZRAF5ER5YdGPafvCd7sUSekz4Gxxo/tgPWs2I/NtHQSlJYyKB0uBLazh5CgauG5V
	57LqB2sd7x7Y6wE6Yp1eCWqWqXqdQpl0zr4szALsnrMkkc7NykC9knry7VmIaH7hlq1jdmzXv5TNJ
	tbhcwB6r4yTJkjnlMg/abhQGlazkD+FOUi/79sMPkAXDvrSRZ7kFEzxDyJSxKC0iHjHcm8ur4ylXV
	j8yfd9DVgZaQ/bmo0m6aScMGjp5XvLGOz6VZUd/aI2qIPiW3U/rvXvJKxfMi3sTKBe7eQmC6eOGG0
	feVtQcag==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1u7u6v-000fMp-00;
	Thu, 24 Apr 2025 18:47:18 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Thu, 24 Apr 2025 18:47:16 +0800
Date: Thu, 24 Apr 2025 18:47:16 +0800
Message-Id: <6c08ba96e4cb6a6219e06bb77006cba91e6e84a2.1745490652.git.herbert@gondor.apana.org.au>
In-Reply-To: <cover.1745490652.git.herbert@gondor.apana.org.au>
References: <cover.1745490652.git.herbert@gondor.apana.org.au>
From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 09/15] crypto: lib/poly1305 - Use block-only interface
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>

Now that every architecture provides a block function, use that
to implement the lib/poly1305 and remove the old per-arch code.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---
 arch/arm/lib/crypto/poly1305-glue.c         | 57 -------------------
 arch/arm64/lib/crypto/poly1305-glue.c       | 58 -------------------
 arch/mips/lib/crypto/poly1305-glue.c        | 60 --------------------
 arch/powerpc/lib/crypto/poly1305-p10-glue.c | 63 ---------------------
 arch/x86/lib/crypto/poly1305_glue.c         | 60 --------------------
 include/crypto/poly1305.h                   | 53 ++---------------
 lib/crypto/poly1305.c                       | 42 +++++++++-----
 7 files changed, 33 insertions(+), 360 deletions(-)

diff --git a/arch/arm/lib/crypto/poly1305-glue.c b/arch/arm/lib/crypto/poly1305-glue.c
index e9082d0d9e99..aa7402523f41 100644
--- a/arch/arm/lib/crypto/poly1305-glue.c
+++ b/arch/arm/lib/crypto/poly1305-glue.c
@@ -12,7 +12,6 @@
 #include <linux/jump_label.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
-#include <linux/string.h>
 #include <linux/unaligned.h>
 
 asmlinkage void poly1305_block_init_arch(struct poly1305_block_state *state,
@@ -34,17 +33,6 @@ void __weak poly1305_blocks_neon(struct poly1305_block_state *state,
 
 static __ro_after_init DEFINE_STATIC_KEY_FALSE(have_neon);
 
-void poly1305_init_arch(struct poly1305_desc_ctx *dctx, const u8 key[POLY1305_KEY_SIZE])
-{
-	dctx->s[0] = get_unaligned_le32(key + 16);
-	dctx->s[1] = get_unaligned_le32(key + 20);
-	dctx->s[2] = get_unaligned_le32(key + 24);
-	dctx->s[3] = get_unaligned_le32(key + 28);
-	dctx->buflen = 0;
-	poly1305_block_init_arch(&dctx->state, key);
-}
-EXPORT_SYMBOL(poly1305_init_arch);
-
 void poly1305_blocks_arch(struct poly1305_block_state *state, const u8 *src,
 			  unsigned int len, u32 padbit)
 {
@@ -66,51 +54,6 @@ void poly1305_blocks_arch(struct poly1305_block_state *state, const u8 *src,
 }
 EXPORT_SYMBOL_GPL(poly1305_blocks_arch);
 
-void poly1305_update_arch(struct poly1305_desc_ctx *dctx, const u8 *src,
-			  unsigned int nbytes)
-{
-	if (unlikely(dctx->buflen)) {
-		u32 bytes = min(nbytes, POLY1305_BLOCK_SIZE - dctx->buflen);
-
-		memcpy(dctx->buf + dctx->buflen, src, bytes);
-		src += bytes;
-		nbytes -= bytes;
-		dctx->buflen += bytes;
-
-		if (dctx->buflen == POLY1305_BLOCK_SIZE) {
-			poly1305_blocks_arch(&dctx->state, dctx->buf,
-					     POLY1305_BLOCK_SIZE, 1);
-			dctx->buflen = 0;
-		}
-	}
-
-	if (likely(nbytes >= POLY1305_BLOCK_SIZE)) {
-		poly1305_blocks_arch(&dctx->state, src, nbytes, 1);
-		src += round_down(nbytes, POLY1305_BLOCK_SIZE);
-		nbytes %= POLY1305_BLOCK_SIZE;
-	}
-
-	if (unlikely(nbytes)) {
-		dctx->buflen = nbytes;
-		memcpy(dctx->buf, src, nbytes);
-	}
-}
-EXPORT_SYMBOL(poly1305_update_arch);
-
-void poly1305_final_arch(struct poly1305_desc_ctx *dctx, u8 *dst)
-{
-	if (unlikely(dctx->buflen)) {
-		dctx->buf[dctx->buflen++] = 1;
-		memset(dctx->buf + dctx->buflen, 0,
-		       POLY1305_BLOCK_SIZE - dctx->buflen);
-		poly1305_blocks_arch(&dctx->state, dctx->buf, POLY1305_BLOCK_SIZE, 0);
-	}
-
-	poly1305_emit_arch(&dctx->h, dst, dctx->s);
-	*dctx = (struct poly1305_desc_ctx){};
-}
-EXPORT_SYMBOL(poly1305_final_arch);
-
 bool poly1305_is_arch_optimized(void)
 {
 	/* We always can use at least the ARM scalar implementation. */
diff --git a/arch/arm64/lib/crypto/poly1305-glue.c b/arch/arm64/lib/crypto/poly1305-glue.c
index 9fdb5bd3dbb0..ab7b120bcc81 100644
--- a/arch/arm64/lib/crypto/poly1305-glue.c
+++ b/arch/arm64/lib/crypto/poly1305-glue.c
@@ -12,7 +12,6 @@
 #include <linux/jump_label.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
-#include <linux/string.h>
 #include <linux/unaligned.h>
 
 asmlinkage void poly1305_block_init_arch(struct poly1305_block_state *state,
@@ -29,17 +28,6 @@ EXPORT_SYMBOL_GPL(poly1305_emit_arch);
 
 static __ro_after_init DEFINE_STATIC_KEY_FALSE(have_neon);
 
-void poly1305_init_arch(struct poly1305_desc_ctx *dctx, const u8 key[POLY1305_KEY_SIZE])
-{
-	dctx->s[0] = get_unaligned_le32(key + 16);
-	dctx->s[1] = get_unaligned_le32(key + 20);
-	dctx->s[2] = get_unaligned_le32(key + 24);
-	dctx->s[3] = get_unaligned_le32(key + 28);
-	dctx->buflen = 0;
-	poly1305_block_init_arch(&dctx->state, key);
-}
-EXPORT_SYMBOL(poly1305_init_arch);
-
 void poly1305_blocks_arch(struct poly1305_block_state *state, const u8 *src,
 			  unsigned int len, u32 padbit)
 {
@@ -60,52 +48,6 @@ void poly1305_blocks_arch(struct poly1305_block_state *state, const u8 *src,
 }
 EXPORT_SYMBOL_GPL(poly1305_blocks_arch);
 
-void poly1305_update_arch(struct poly1305_desc_ctx *dctx, const u8 *src,
-			  unsigned int nbytes)
-{
-	if (unlikely(dctx->buflen)) {
-		u32 bytes = min(nbytes, POLY1305_BLOCK_SIZE - dctx->buflen);
-
-		memcpy(dctx->buf + dctx->buflen, src, bytes);
-		src += bytes;
-		nbytes -= bytes;
-		dctx->buflen += bytes;
-
-		if (dctx->buflen == POLY1305_BLOCK_SIZE) {
-			poly1305_blocks_arch(&dctx->state, dctx->buf,
-					     POLY1305_BLOCK_SIZE, 1);
-			dctx->buflen = 0;
-		}
-	}
-
-	if (likely(nbytes >= POLY1305_BLOCK_SIZE)) {
-		poly1305_blocks_arch(&dctx->state, src, nbytes, 1);
-		src += round_down(nbytes, POLY1305_BLOCK_SIZE);
-		nbytes %= POLY1305_BLOCK_SIZE;
-	}
-
-	if (unlikely(nbytes)) {
-		dctx->buflen = nbytes;
-		memcpy(dctx->buf, src, nbytes);
-	}
-}
-EXPORT_SYMBOL(poly1305_update_arch);
-
-void poly1305_final_arch(struct poly1305_desc_ctx *dctx, u8 *dst)
-{
-	if (unlikely(dctx->buflen)) {
-		dctx->buf[dctx->buflen++] = 1;
-		memset(dctx->buf + dctx->buflen, 0,
-		       POLY1305_BLOCK_SIZE - dctx->buflen);
-		poly1305_blocks_arch(&dctx->state, dctx->buf,
-				     POLY1305_BLOCK_SIZE, 0);
-	}
-
-	poly1305_emit_arch(&dctx->h, dst, dctx->s);
-	memzero_explicit(dctx, sizeof(*dctx));
-}
-EXPORT_SYMBOL(poly1305_final_arch);
-
 bool poly1305_is_arch_optimized(void)
 {
 	/* We always can use at least the ARM64 scalar implementation. */
diff --git a/arch/mips/lib/crypto/poly1305-glue.c b/arch/mips/lib/crypto/poly1305-glue.c
index fc00e96b2a5b..4550abe587b3 100644
--- a/arch/mips/lib/crypto/poly1305-glue.c
+++ b/arch/mips/lib/crypto/poly1305-glue.c
@@ -9,7 +9,6 @@
 #include <linux/cpufeature.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
-#include <linux/string.h>
 #include <linux/unaligned.h>
 
 asmlinkage void poly1305_block_init_arch(struct poly1305_block_state *state,
@@ -23,65 +22,6 @@ asmlinkage void poly1305_emit_arch(const struct poly1305_state *state,
 				   const u32 nonce[4]);
 EXPORT_SYMBOL_GPL(poly1305_emit_arch);
 
-void poly1305_init_arch(struct poly1305_desc_ctx *dctx, const u8 key[POLY1305_KEY_SIZE])
-{
-	dctx->s[0] = get_unaligned_le32(key + 16);
-	dctx->s[1] = get_unaligned_le32(key + 20);
-	dctx->s[2] = get_unaligned_le32(key + 24);
-	dctx->s[3] = get_unaligned_le32(key + 28);
-	dctx->buflen = 0;
-	poly1305_block_init_arch(&dctx->state, key);
-}
-EXPORT_SYMBOL(poly1305_init_arch);
-
-void poly1305_update_arch(struct poly1305_desc_ctx *dctx, const u8 *src,
-			  unsigned int nbytes)
-{
-	if (unlikely(dctx->buflen)) {
-		u32 bytes = min(nbytes, POLY1305_BLOCK_SIZE - dctx->buflen);
-
-		memcpy(dctx->buf + dctx->buflen, src, bytes);
-		src += bytes;
-		nbytes -= bytes;
-		dctx->buflen += bytes;
-
-		if (dctx->buflen == POLY1305_BLOCK_SIZE) {
-			poly1305_blocks_arch(&dctx->state, dctx->buf,
-					     POLY1305_BLOCK_SIZE, 1);
-			dctx->buflen = 0;
-		}
-	}
-
-	if (likely(nbytes >= POLY1305_BLOCK_SIZE)) {
-		unsigned int len = round_down(nbytes, POLY1305_BLOCK_SIZE);
-
-		poly1305_blocks_arch(&dctx->state, src, len, 1);
-		src += len;
-		nbytes %= POLY1305_BLOCK_SIZE;
-	}
-
-	if (unlikely(nbytes)) {
-		dctx->buflen = nbytes;
-		memcpy(dctx->buf, src, nbytes);
-	}
-}
-EXPORT_SYMBOL(poly1305_update_arch);
-
-void poly1305_final_arch(struct poly1305_desc_ctx *dctx, u8 *dst)
-{
-	if (unlikely(dctx->buflen)) {
-		dctx->buf[dctx->buflen++] = 1;
-		memset(dctx->buf + dctx->buflen, 0,
-		       POLY1305_BLOCK_SIZE - dctx->buflen);
-		poly1305_blocks_arch(&dctx->state, dctx->buf,
-				     POLY1305_BLOCK_SIZE, 0);
-	}
-
-	poly1305_emit_arch(&dctx->h, dst, dctx->s);
-	*dctx = (struct poly1305_desc_ctx){};
-}
-EXPORT_SYMBOL(poly1305_final_arch);
-
 bool poly1305_is_arch_optimized(void)
 {
 	return true;
diff --git a/arch/powerpc/lib/crypto/poly1305-p10-glue.c b/arch/powerpc/lib/crypto/poly1305-p10-glue.c
index a33c61efd360..cef56a0e4c12 100644
--- a/arch/powerpc/lib/crypto/poly1305-p10-glue.c
+++ b/arch/powerpc/lib/crypto/poly1305-p10-glue.c
@@ -10,7 +10,6 @@
 #include <linux/jump_label.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
-#include <linux/string.h>
 #include <linux/unaligned.h>
 
 asmlinkage void poly1305_p10le_4blocks(struct poly1305_block_state *state, const u8 *m, u32 mlen);
@@ -45,17 +44,6 @@ void poly1305_block_init_arch(struct poly1305_block_state *dctx,
 }
 EXPORT_SYMBOL_GPL(poly1305_block_init_arch);
 
-void poly1305_init_arch(struct poly1305_desc_ctx *dctx, const u8 key[POLY1305_KEY_SIZE])
-{
-	dctx->s[0] = get_unaligned_le32(key + 16);
-	dctx->s[1] = get_unaligned_le32(key + 20);
-	dctx->s[2] = get_unaligned_le32(key + 24);
-	dctx->s[3] = get_unaligned_le32(key + 28);
-	dctx->buflen = 0;
-	poly1305_block_init_arch(&dctx->state, key);
-}
-EXPORT_SYMBOL(poly1305_init_arch);
-
 void poly1305_blocks_arch(struct poly1305_block_state *state, const u8 *src,
 			  unsigned int len, u32 padbit)
 {
@@ -76,57 +64,6 @@ void poly1305_blocks_arch(struct poly1305_block_state *state, const u8 *src,
 }
 EXPORT_SYMBOL_GPL(poly1305_blocks_arch);
 
-void poly1305_update_arch(struct poly1305_desc_ctx *dctx,
-			  const u8 *src, unsigned int srclen)
-{
-	unsigned int bytes;
-
-	if (!static_key_enabled(&have_p10))
-		return poly1305_update_generic(dctx, src, srclen);
-
-	if (unlikely(dctx->buflen)) {
-		bytes = min(srclen, POLY1305_BLOCK_SIZE - dctx->buflen);
-		memcpy(dctx->buf + dctx->buflen, src, bytes);
-		src += bytes;
-		srclen -= bytes;
-		dctx->buflen += bytes;
-		if (dctx->buflen < POLY1305_BLOCK_SIZE)
-			return;
-		poly1305_blocks_arch(&dctx->state, dctx->buf,
-				     POLY1305_BLOCK_SIZE, 1);
-		dctx->buflen = 0;
-	}
-
-	if (likely(srclen >= POLY1305_BLOCK_SIZE)) {
-		poly1305_blocks_arch(&dctx->state, src, srclen, 1);
-		src += srclen - (srclen % POLY1305_BLOCK_SIZE);
-		srclen %= POLY1305_BLOCK_SIZE;
-	}
-
-	if (unlikely(srclen)) {
-		dctx->buflen = srclen;
-		memcpy(dctx->buf, src, srclen);
-	}
-}
-EXPORT_SYMBOL(poly1305_update_arch);
-
-void poly1305_final_arch(struct poly1305_desc_ctx *dctx, u8 *dst)
-{
-	if (!static_key_enabled(&have_p10))
-		return poly1305_final_generic(dctx, dst);
-
-	if (dctx->buflen) {
-		dctx->buf[dctx->buflen++] = 1;
-		memset(dctx->buf + dctx->buflen, 0,
-		       POLY1305_BLOCK_SIZE - dctx->buflen);
-		poly1305_blocks_arch(&dctx->state, dctx->buf,
-				     POLY1305_BLOCK_SIZE, 0);
-	}
-
-	poly1305_emit_arch(&dctx->h, dst, dctx->s);
-}
-EXPORT_SYMBOL(poly1305_final_arch);
-
 bool poly1305_is_arch_optimized(void)
 {
 	return static_key_enabled(&have_p10);
diff --git a/arch/x86/lib/crypto/poly1305_glue.c b/arch/x86/lib/crypto/poly1305_glue.c
index b45818c51223..0881b3e73388 100644
--- a/arch/x86/lib/crypto/poly1305_glue.c
+++ b/arch/x86/lib/crypto/poly1305_glue.c
@@ -10,7 +10,6 @@
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/sizes.h>
-#include <linux/string.h>
 #include <linux/unaligned.h>
 
 struct poly1305_arch_internal {
@@ -101,65 +100,6 @@ void poly1305_emit_arch(const struct poly1305_state *ctx,
 }
 EXPORT_SYMBOL_GPL(poly1305_emit_arch);
 
-void poly1305_init_arch(struct poly1305_desc_ctx *dctx, const u8 key[POLY1305_KEY_SIZE])
-{
-	dctx->s[0] = get_unaligned_le32(&key[16]);
-	dctx->s[1] = get_unaligned_le32(&key[20]);
-	dctx->s[2] = get_unaligned_le32(&key[24]);
-	dctx->s[3] = get_unaligned_le32(&key[28]);
-	dctx->buflen = 0;
-	poly1305_block_init_arch(&dctx->state, key);
-}
-EXPORT_SYMBOL(poly1305_init_arch);
-
-void poly1305_update_arch(struct poly1305_desc_ctx *dctx, const u8 *src,
-			  unsigned int srclen)
-{
-	unsigned int bytes;
-
-	if (unlikely(dctx->buflen)) {
-		bytes = min(srclen, POLY1305_BLOCK_SIZE - dctx->buflen);
-		memcpy(dctx->buf + dctx->buflen, src, bytes);
-		src += bytes;
-		srclen -= bytes;
-		dctx->buflen += bytes;
-
-		if (dctx->buflen == POLY1305_BLOCK_SIZE) {
-			poly1305_blocks_arch(&dctx->state, dctx->buf,
-					     POLY1305_BLOCK_SIZE, 1);
-			dctx->buflen = 0;
-		}
-	}
-
-	if (likely(srclen >= POLY1305_BLOCK_SIZE)) {
-		bytes = round_down(srclen, POLY1305_BLOCK_SIZE);
-		poly1305_blocks_arch(&dctx->state, src, bytes, 1);
-		src += bytes;
-		srclen -= bytes;
-	}
-
-	if (unlikely(srclen)) {
-		dctx->buflen = srclen;
-		memcpy(dctx->buf, src, srclen);
-	}
-}
-EXPORT_SYMBOL(poly1305_update_arch);
-
-void poly1305_final_arch(struct poly1305_desc_ctx *dctx, u8 *dst)
-{
-	if (unlikely(dctx->buflen)) {
-		dctx->buf[dctx->buflen++] = 1;
-		memset(dctx->buf + dctx->buflen, 0,
-		       POLY1305_BLOCK_SIZE - dctx->buflen);
-		poly1305_blocks_arch(&dctx->state, dctx->buf,
-				     POLY1305_BLOCK_SIZE, 0);
-	}
-
-	poly1305_emit_arch(&dctx->h, dst, dctx->s);
-	memzero_explicit(dctx, sizeof(*dctx));
-}
-EXPORT_SYMBOL(poly1305_final_arch);
-
 bool poly1305_is_arch_optimized(void)
 {
 	return static_key_enabled(&poly1305_use_avx);
diff --git a/include/crypto/poly1305.h b/include/crypto/poly1305.h
index 027d74842cd5..e54abda8cfe9 100644
--- a/include/crypto/poly1305.h
+++ b/include/crypto/poly1305.h
@@ -55,55 +55,14 @@ struct poly1305_desc_ctx {
 	unsigned int buflen;
 	/* finalize key */
 	u32 s[4];
-	union {
-		struct {
-			struct poly1305_state h;
-			union {
-				struct poly1305_key opaque_r[CONFIG_CRYPTO_LIB_POLY1305_RSIZE];
-				struct poly1305_core_key core_r;
-			};
-		};
-		struct poly1305_block_state state;
-	};
+	struct poly1305_block_state state;
 };
 
-void poly1305_init_arch(struct poly1305_desc_ctx *desc,
-			const u8 key[POLY1305_KEY_SIZE]);
-void poly1305_init_generic(struct poly1305_desc_ctx *desc,
-			   const u8 key[POLY1305_KEY_SIZE]);
-
-static inline void poly1305_init(struct poly1305_desc_ctx *desc, const u8 *key)
-{
-	if (IS_ENABLED(CONFIG_CRYPTO_ARCH_HAVE_LIB_POLY1305))
-		poly1305_init_arch(desc, key);
-	else
-		poly1305_init_generic(desc, key);
-}
-
-void poly1305_update_arch(struct poly1305_desc_ctx *desc, const u8 *src,
-			  unsigned int nbytes);
-void poly1305_update_generic(struct poly1305_desc_ctx *desc, const u8 *src,
-			     unsigned int nbytes);
-
-static inline void poly1305_update(struct poly1305_desc_ctx *desc,
-				   const u8 *src, unsigned int nbytes)
-{
-	if (IS_ENABLED(CONFIG_CRYPTO_ARCH_HAVE_LIB_POLY1305))
-		poly1305_update_arch(desc, src, nbytes);
-	else
-		poly1305_update_generic(desc, src, nbytes);
-}
-
-void poly1305_final_arch(struct poly1305_desc_ctx *desc, u8 *digest);
-void poly1305_final_generic(struct poly1305_desc_ctx *desc, u8 *digest);
-
-static inline void poly1305_final(struct poly1305_desc_ctx *desc, u8 *digest)
-{
-	if (IS_ENABLED(CONFIG_CRYPTO_ARCH_HAVE_LIB_POLY1305))
-		poly1305_final_arch(desc, digest);
-	else
-		poly1305_final_generic(desc, digest);
-}
+void poly1305_init(struct poly1305_desc_ctx *desc,
+		   const u8 key[POLY1305_KEY_SIZE]);
+void poly1305_update(struct poly1305_desc_ctx *desc,
+		     const u8 *src, unsigned int nbytes);
+void poly1305_final(struct poly1305_desc_ctx *desc, u8 *digest);
 
 #if IS_ENABLED(CONFIG_CRYPTO_ARCH_HAVE_LIB_POLY1305)
 bool poly1305_is_arch_optimized(void);
diff --git a/lib/crypto/poly1305.c b/lib/crypto/poly1305.c
index ebdfccf378ee..a37b424ee84b 100644
--- a/lib/crypto/poly1305.c
+++ b/lib/crypto/poly1305.c
@@ -22,47 +22,59 @@ void poly1305_block_init_generic(struct poly1305_block_state *desc,
 }
 EXPORT_SYMBOL_GPL(poly1305_block_init_generic);
 
-void poly1305_init_generic(struct poly1305_desc_ctx *desc,
-			   const u8 key[POLY1305_KEY_SIZE])
+void poly1305_init(struct poly1305_desc_ctx *desc,
+		   const u8 key[POLY1305_KEY_SIZE])
 {
 	desc->s[0] = get_unaligned_le32(key + 16);
 	desc->s[1] = get_unaligned_le32(key + 20);
 	desc->s[2] = get_unaligned_le32(key + 24);
 	desc->s[3] = get_unaligned_le32(key + 28);
 	desc->buflen = 0;
-	poly1305_block_init_generic(&desc->state, key);
+	if (IS_ENABLED(CONFIG_CRYPTO_ARCH_HAVE_LIB_POLY1305))
+		poly1305_block_init_arch(&desc->state, key);
+	else
+		poly1305_block_init_generic(&desc->state, key);
 }
-EXPORT_SYMBOL_GPL(poly1305_init_generic);
+EXPORT_SYMBOL(poly1305_init);
 
-static inline void poly1305_block(struct poly1305_block_state *state, const u8 *src,
-				  unsigned int len)
+static inline void poly1305_block(struct poly1305_block_state *state,
+				  const u8 *src, unsigned int len)
 {
-	poly1305_blocks_generic(state, src, len, 1);
+	if (!IS_ENABLED(CONFIG_CRYPTO_ARCH_HAVE_LIB_POLY1305))
+		poly1305_blocks_generic(state, src, len, 1);
+	poly1305_blocks_arch(state, src, len, 1);
 }
 
-void poly1305_update_generic(struct poly1305_desc_ctx *desc, const u8 *src,
-			     unsigned int nbytes)
+void poly1305_update(struct poly1305_desc_ctx *desc,
+		     const u8 *src, unsigned int nbytes)
 {
 	desc->buflen = BLOCK_HASH_UPDATE(&poly1305_block, &desc->state,
 					 src, nbytes, POLY1305_BLOCK_SIZE,
 					 desc->buf, desc->buflen);
 }
-EXPORT_SYMBOL_GPL(poly1305_update_generic);
+EXPORT_SYMBOL(poly1305_update);
 
-void poly1305_final_generic(struct poly1305_desc_ctx *desc, u8 *dst)
+void poly1305_final(struct poly1305_desc_ctx *desc, u8 *dst)
 {
 	if (unlikely(desc->buflen)) {
 		desc->buf[desc->buflen++] = 1;
 		memset(desc->buf + desc->buflen, 0,
 		       POLY1305_BLOCK_SIZE - desc->buflen);
-		poly1305_blocks_generic(&desc->state, desc->buf,
-					POLY1305_BLOCK_SIZE, 0);
+		if (IS_ENABLED(CONFIG_CRYPTO_ARCH_HAVE_LIB_POLY1305))
+			poly1305_blocks_arch(&desc->state, desc->buf,
+					     POLY1305_BLOCK_SIZE, 0);
+		else
+			poly1305_blocks_generic(&desc->state, desc->buf,
+						POLY1305_BLOCK_SIZE, 0);
 	}
 
-	poly1305_emit_generic(&desc->h, dst, desc->s);
+	if (IS_ENABLED(CONFIG_CRYPTO_ARCH_HAVE_LIB_POLY1305))
+		poly1305_emit_arch(&desc->state.h, dst, desc->s);
+	else
+		poly1305_emit_generic(&desc->state.h, dst, desc->s);
 	*desc = (struct poly1305_desc_ctx){};
 }
-EXPORT_SYMBOL_GPL(poly1305_final_generic);
+EXPORT_SYMBOL(poly1305_final);
 
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Martin Willi <martin@strongswan.org>");
-- 
2.39.5

