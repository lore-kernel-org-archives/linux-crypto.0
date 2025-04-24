Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 145161F0E47
	for <linux-crypto@vger.kernel.org>; Thu, 24 Apr 2025 10:47:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745491629; cv=none; b=hxGWooKP58A3UxBXrAjygxbPpAiHLX4aa4g9vALuf5GKBlBqrW36YYAsdBe3rQugBhyoTBUR9vwG9l91edJXZNA0ZGh2pg1Lb+hAXjwbGO/yRwlhPf2zlWTcBAGgZjnFkNxBlZPlhpMZGY1NBXS4YbwMZovdTf7N/aLfF3Tz6ZI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745491629; c=relaxed/simple;
	bh=UsM0XbEusUr0lC4MllKynTLIvoGmPTFMixDGT8FDOv8=;
	h=Date:Message-Id:In-Reply-To:References:From:Subject:To; b=iuBTFe+8kwTb9buJw7tCLfAShm6zsgUO+4UTppwMwIPm0B8oPzW/SU1HE688DHQHP6oyxNvzlSYdgFNCWr1iaCAe51egDctgInXIWoVymayMU+El6UgzVUINCCEvJkOQsd3YXdIYmBwv0Bp8ZsZjBMUaYh7EUq9ywucGzguIw+I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=D1edC4hQ; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="D1edC4hQ"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=To:Subject:From:References:In-Reply-To:Message-Id:Date:Sender:
	Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=0HlilcKT3IskbtVTsgPUPvbWYKBws35GdN7HbjtHKYc=; b=D1edC4hQwhFBhCJzlp4cFfLOZQ
	q26uglV3MewubVrvTwwE9OzPg4QfjgFPB2r91viEOraIQ5/Rh6WhmvGWhlyUbYB7Bbi9KOU/HONP9
	FLM5NmBM+uKzQI9X+IUK4bA/d7irl88YXPjRat6ylfE7TaltAKQ6C7uVoCkwUFPsYSPB1Uxzu2sgm
	YGOxk3WqoNb0WTuw8hv3TPcAoUdvRqSR5jUzExMmxRCbk050ve7AYLXbdlJXsKMKqM+SfL33SXzdH
	GhGD89xEJjI5ZekQEou9eoBJVlzhV3N3iXea7NwWjnC7eUPHHt2cydBvDTaPfMlRth+KuxQ1KfgLI
	X2oJ4TcQ==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1u7u6h-000fLl-0V;
	Thu, 24 Apr 2025 18:47:04 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Thu, 24 Apr 2025 18:47:03 +0800
Date: Thu, 24 Apr 2025 18:47:03 +0800
Message-Id: <4d5023d077557cb2e3bc1f620bc888e9c0e855e8.1745490652.git.herbert@gondor.apana.org.au>
In-Reply-To: <cover.1745490652.git.herbert@gondor.apana.org.au>
References: <cover.1745490652.git.herbert@gondor.apana.org.au>
From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 03/15] crypto: arm/poly1305 - Add block-only interface
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
 arch/arm/lib/crypto/poly1305-glue.c   | 77 +++++++++++++++------------
 2 files changed, 46 insertions(+), 35 deletions(-)

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
index 42d0ebde1ae1..e9082d0d9e99 100644
--- a/arch/arm/lib/crypto/poly1305-glue.c
+++ b/arch/arm/lib/crypto/poly1305-glue.c
@@ -7,20 +7,28 @@
 
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
+asmlinkage void poly1305_block_init_arch(struct poly1305_block_state *state,
+					 const u8 key[POLY1305_BLOCK_SIZE]);
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
 
@@ -28,21 +36,39 @@ static __ro_after_init DEFINE_STATIC_KEY_FALSE(have_neon);
 
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
 
@@ -52,30 +78,15 @@ void poly1305_update_arch(struct poly1305_desc_ctx *dctx, const u8 *src,
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
 
@@ -92,10 +103,10 @@ void poly1305_final_arch(struct poly1305_desc_ctx *dctx, u8 *dst)
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

