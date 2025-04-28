Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C84719DF52
	for <linux-crypto@vger.kernel.org>; Mon, 28 Apr 2025 04:56:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745816176; cv=none; b=gIVUvgiVk6tkbZder3PPjGKy9qVtucyADDJUa+6PBhHSKWuKSx+hoRyYb/qlHSOZAwLYb6tfhNYtIt8gyyxt22NDwkxI+NJJ2v1BQ7nG+ClE7mGCzsERgLe0TNkVqBlFfKExcCqIrP1IJUQIz2otioZ60bfBkgPXUm/tu8MlHho=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745816176; c=relaxed/simple;
	bh=FeAAPgHSRSxdvMHW6GOaIC1zEdt1Yzy9bN8oRMaR/vQ=;
	h=Date:Message-Id:In-Reply-To:References:From:Subject:To; b=YkMCV7TUpiV3Yd3NAUSTt7ACJoCNdmAMuhXZ4kcjocBp+08NM48e6JUzsE6sNPvR3JM6en1kIbVJTv8Kd2QkDEYuPYM5zGBVcUJqlx1NdOIK0S25MUIjdLiNNtwVLskPkLwQQihlf3yetVuXNsuOvTqn7XgyeCvY316d7zBcynY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=LHn3tPF5; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="LHn3tPF5"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=To:Subject:From:References:In-Reply-To:Message-Id:Date:Sender:
	Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=+7XXZdrlPD0SOg7FX28pRrElOCBpzjElynHrx5ID5QY=; b=LHn3tPF5UDkggys8jq2IVcE9JD
	SfZIAT8ioxaWZuCOPRCv9J73yCmea6QhnqG6/EnlrC+K9bxpoFhlO0jcJAjbvPBivgPzovXR3GClG
	ywizL1wwSs+JZ8mj4MK1aAKaG9iKC25/9P13BjLWaKg39G2sTVBq92iT6/g6R0DYj8JFkrLA38ZmG
	Z2/uYWoDdmazUYMeEAbxR+VGl0vARhN0yaAOISF3jrQ9HviBOOm2KYFp9nhlTcnlDwcr5Bzig3W/3
	062MEEDD9GfQXHh65lBAvWK5pLDgScoh2dClGKWfJPupfG4HWSeqsqTRxTNOPy1AUl/zT6H630W1n
	G2Gsv8sw==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1u9GXJ-001WF5-22;
	Mon, 28 Apr 2025 12:56:10 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Mon, 28 Apr 2025 12:56:09 +0800
Date: Mon, 28 Apr 2025 12:56:09 +0800
Message-Id: <15f85b9781a085723605fabbe31dd997fc1f7997.1745815528.git.herbert@gondor.apana.org.au>
In-Reply-To: <cover.1745815528.git.herbert@gondor.apana.org.au>
References: <cover.1745815528.git.herbert@gondor.apana.org.au>
From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [v4 PATCH 03/11] crypto: arm/poly1305 - Add block-only interface
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>

Add block-only interface.

Also remove the unnecessary SIMD fallback path.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---
 arch/arm/lib/crypto/poly1305-armv4.pl |  4 +-
 arch/arm/lib/crypto/poly1305-glue.c   | 78 +++++++++++++++------------
 2 files changed, 47 insertions(+), 35 deletions(-)

diff --git a/arch/arm/lib/crypto/poly1305-armv4.pl b/arch/arm/lib/crypto/poly1305-armv4.pl
index 6d79498d3115..d57c6e2fc84a 100644
--- a/arch/arm/lib/crypto/poly1305-armv4.pl
+++ b/arch/arm/lib/crypto/poly1305-armv4.pl
@@ -43,9 +43,9 @@ $code.=<<___;
 #else
 # define __ARM_ARCH__ __LINUX_ARM_ARCH__
 # define __ARM_MAX_ARCH__ __LINUX_ARM_ARCH__
-# define poly1305_init   poly1305_init_arm
+# define poly1305_init   poly1305_block_init_arch
 # define poly1305_blocks poly1305_blocks_arm
-# define poly1305_emit   poly1305_emit_arm
+# define poly1305_emit   poly1305_emit_arch
 .globl	poly1305_blocks_neon
 #endif
 
diff --git a/arch/arm/lib/crypto/poly1305-glue.c b/arch/arm/lib/crypto/poly1305-glue.c
index 42d0ebde1ae1..3ee16048ec7c 100644
--- a/arch/arm/lib/crypto/poly1305-glue.c
+++ b/arch/arm/lib/crypto/poly1305-glue.c
@@ -7,20 +7,29 @@
 
 #include <asm/hwcap.h>
 #include <asm/neon.h>
-#include <asm/simd.h>
-#include <crypto/poly1305.h>
-#include <crypto/internal/simd.h>
+#include <crypto/internal/poly1305.h>
 #include <linux/cpufeature.h>
 #include <linux/jump_label.h>
+#include <linux/kernel.h>
 #include <linux/module.h>
+#include <linux/string.h>
 #include <linux/unaligned.h>
 
-void poly1305_init_arm(void *state, const u8 *key);
-void poly1305_blocks_arm(void *state, const u8 *src, u32 len, u32 hibit);
-void poly1305_blocks_neon(void *state, const u8 *src, u32 len, u32 hibit);
-void poly1305_emit_arm(void *state, u8 *digest, const u32 *nonce);
+asmlinkage void poly1305_block_init_arch(
+	struct poly1305_block_state *state,
+	const u8 raw_key[POLY1305_BLOCK_SIZE]);
+EXPORT_SYMBOL_GPL(poly1305_block_init_arch);
+asmlinkage void poly1305_blocks_arm(struct poly1305_block_state *state,
+				    const u8 *src, u32 len, u32 hibit);
+asmlinkage void poly1305_blocks_neon(struct poly1305_block_state *state,
+				     const u8 *src, u32 len, u32 hibit);
+asmlinkage void poly1305_emit_arch(const struct poly1305_state *state,
+				   u8 digest[POLY1305_DIGEST_SIZE],
+				   const u32 nonce[4]);
+EXPORT_SYMBOL_GPL(poly1305_emit_arch);
 
-void __weak poly1305_blocks_neon(void *state, const u8 *src, u32 len, u32 hibit)
+void __weak poly1305_blocks_neon(struct poly1305_block_state *state,
+				 const u8 *src, u32 len, u32 hibit)
 {
 }
 
@@ -28,21 +37,39 @@ static __ro_after_init DEFINE_STATIC_KEY_FALSE(have_neon);
 
 void poly1305_init_arch(struct poly1305_desc_ctx *dctx, const u8 key[POLY1305_KEY_SIZE])
 {
-	poly1305_init_arm(&dctx->h, key);
 	dctx->s[0] = get_unaligned_le32(key + 16);
 	dctx->s[1] = get_unaligned_le32(key + 20);
 	dctx->s[2] = get_unaligned_le32(key + 24);
 	dctx->s[3] = get_unaligned_le32(key + 28);
 	dctx->buflen = 0;
+	poly1305_block_init_arch(&dctx->state, key);
 }
 EXPORT_SYMBOL(poly1305_init_arch);
 
+void poly1305_blocks_arch(struct poly1305_block_state *state, const u8 *src,
+			  unsigned int len, u32 padbit)
+{
+	len = round_down(len, POLY1305_BLOCK_SIZE);
+	if (IS_ENABLED(CONFIG_KERNEL_MODE_NEON) &&
+	    static_branch_likely(&have_neon)) {
+		do {
+			unsigned int todo = min_t(unsigned int, len, SZ_4K);
+
+			kernel_neon_begin();
+			poly1305_blocks_neon(state, src, todo, padbit);
+			kernel_neon_end();
+
+			len -= todo;
+			src += todo;
+		} while (len);
+	} else
+		poly1305_blocks_arm(state, src, len, padbit);
+}
+EXPORT_SYMBOL_GPL(poly1305_blocks_arch);
+
 void poly1305_update_arch(struct poly1305_desc_ctx *dctx, const u8 *src,
 			  unsigned int nbytes)
 {
-	bool do_neon = IS_ENABLED(CONFIG_KERNEL_MODE_NEON) &&
-		       crypto_simd_usable();
-
 	if (unlikely(dctx->buflen)) {
 		u32 bytes = min(nbytes, POLY1305_BLOCK_SIZE - dctx->buflen);
 
@@ -52,30 +79,15 @@ void poly1305_update_arch(struct poly1305_desc_ctx *dctx, const u8 *src,
 		dctx->buflen += bytes;
 
 		if (dctx->buflen == POLY1305_BLOCK_SIZE) {
-			poly1305_blocks_arm(&dctx->h, dctx->buf,
-					    POLY1305_BLOCK_SIZE, 1);
+			poly1305_blocks_arch(&dctx->state, dctx->buf,
+					     POLY1305_BLOCK_SIZE, 1);
 			dctx->buflen = 0;
 		}
 	}
 
 	if (likely(nbytes >= POLY1305_BLOCK_SIZE)) {
-		unsigned int len = round_down(nbytes, POLY1305_BLOCK_SIZE);
-
-		if (static_branch_likely(&have_neon) && do_neon) {
-			do {
-				unsigned int todo = min_t(unsigned int, len, SZ_4K);
-
-				kernel_neon_begin();
-				poly1305_blocks_neon(&dctx->h, src, todo, 1);
-				kernel_neon_end();
-
-				len -= todo;
-				src += todo;
-			} while (len);
-		} else {
-			poly1305_blocks_arm(&dctx->h, src, len, 1);
-			src += len;
-		}
+		poly1305_blocks_arch(&dctx->state, src, nbytes, 1);
+		src += round_down(nbytes, POLY1305_BLOCK_SIZE);
 		nbytes %= POLY1305_BLOCK_SIZE;
 	}
 
@@ -92,10 +104,10 @@ void poly1305_final_arch(struct poly1305_desc_ctx *dctx, u8 *dst)
 		dctx->buf[dctx->buflen++] = 1;
 		memset(dctx->buf + dctx->buflen, 0,
 		       POLY1305_BLOCK_SIZE - dctx->buflen);
-		poly1305_blocks_arm(&dctx->h, dctx->buf, POLY1305_BLOCK_SIZE, 0);
+		poly1305_blocks_arch(&dctx->state, dctx->buf, POLY1305_BLOCK_SIZE, 0);
 	}
 
-	poly1305_emit_arm(&dctx->h, dst, dctx->s);
+	poly1305_emit_arch(&dctx->h, dst, dctx->s);
 	*dctx = (struct poly1305_desc_ctx){};
 }
 EXPORT_SYMBOL(poly1305_final_arch);
-- 
2.39.5

