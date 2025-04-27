Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52D7C2192F3
	for <linux-crypto@vger.kernel.org>; Sun, 27 Apr 2025 05:22:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745731340; cv=none; b=byEc4H+zPQVN4gA3QXHYVEm5q9odtJsB/dm5eZhwGcXzPYz7rpUawclyB8tnFWGH4nzvgwLridpVIHX+haAaNDraq2SYea97MiH942jvIJbMKEgJj13rIdSHsrmOFkFtqjEOAH9z3N6PTxFDzRuE0eL1BLKzKok63DXBidqGY0g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745731340; c=relaxed/simple;
	bh=UuRt7OQ4Z7nSQ0BYTfR5ENiO02Moab2MSDIZMtxiitc=;
	h=Date:Message-Id:In-Reply-To:References:From:Subject:To; b=AkAH+viPSMnVzihQeI7T7JBo7aRo6dwMGTCpJR4LZUcVMOqaypZ59LHoiJEVJeB6nu1DNSLtouC87xNUxVUWygTNFQsOSLwyRTkxOxVVPpHcJFCQaDwQLU1au4KhB9weqggmuRovPwHYUavtg0Gpm3VEb3NgE6L7MvYunYs3Prw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=oWZMZsq7; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="oWZMZsq7"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=To:Subject:From:References:In-Reply-To:Message-Id:Date:Sender:
	Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=nMpmJ+1Dj0u63TbXpHYoBqzH0PHfnbRVekOhk4nMNMo=; b=oWZMZsq7GxuchMM7LajQsEPrSv
	SQlgPdC5L7RWelyEshNr/IoNbvSMJVx+1ATVU7afv2wH0cJ9cZt6f+IJ1sHOG8rEaYafY6imHbEC0
	CsykMbtEOBbx80ziNKAl5fTC0uuIPPRGegnS0GJIKFyKg49zrTT4QJ4yaUp8a2f0Jm/CBTOWrelbt
	fvMzgvdDcaK2Rw0BbY3QFITWqReVsjoiV5EKkUW35OtIx34DWpDTReqCyUEEXVkbD+Gb6r8VrHW4Y
	3pcxJgy18BTpiGZY+Srjlf6Upt+naHJu3xsfSV/Gh4jjvZeEtHXwfcnTEDmiRpnuuAbiewXDaKKUw
	pQkipi6g==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1u8uT0-001Kz5-1S;
	Sun, 27 Apr 2025 13:22:15 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Sun, 27 Apr 2025 13:22:14 +0800
Date: Sun, 27 Apr 2025 13:22:14 +0800
Message-Id: <aa94ce0c038a99925dc227079d6275783c0ed7ea.1745730946.git.herbert@gondor.apana.org.au>
In-Reply-To: <cover.1745730946.git.herbert@gondor.apana.org.au>
References: <cover.1745730946.git.herbert@gondor.apana.org.au>
From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [v3 PATCH 04/11] crypto: arm64/poly1305 - Add block-only interface
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
 arch/arm64/lib/crypto/Makefile        |  3 +-
 arch/arm64/lib/crypto/poly1305-glue.c | 71 ++++++++++++++++-----------
 2 files changed, 45 insertions(+), 29 deletions(-)

diff --git a/arch/arm64/lib/crypto/Makefile b/arch/arm64/lib/crypto/Makefile
index ac624c3effda..6207088397a7 100644
--- a/arch/arm64/lib/crypto/Makefile
+++ b/arch/arm64/lib/crypto/Makefile
@@ -5,7 +5,8 @@ chacha-neon-y := chacha-neon-core.o chacha-neon-glue.o
 
 obj-$(CONFIG_CRYPTO_POLY1305_NEON) += poly1305-neon.o
 poly1305-neon-y := poly1305-core.o poly1305-glue.o
-AFLAGS_poly1305-core.o += -Dpoly1305_init=poly1305_init_arm64
+AFLAGS_poly1305-core.o += -Dpoly1305_init=poly1305_block_init_arch
+AFLAGS_poly1305-core.o += -Dpoly1305_emit=poly1305_emit_arch
 
 quiet_cmd_perlasm = PERLASM $@
       cmd_perlasm = $(PERL) $(<) void $(@)
diff --git a/arch/arm64/lib/crypto/poly1305-glue.c b/arch/arm64/lib/crypto/poly1305-glue.c
index 906970dd5373..d66a820e32d5 100644
--- a/arch/arm64/lib/crypto/poly1305-glue.c
+++ b/arch/arm64/lib/crypto/poly1305-glue.c
@@ -7,32 +7,60 @@
 
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
 
-asmlinkage void poly1305_init_arm64(void *state, const u8 *key);
-asmlinkage void poly1305_blocks(void *state, const u8 *src, u32 len, u32 hibit);
-asmlinkage void poly1305_blocks_neon(void *state, const u8 *src, u32 len, u32 hibit);
-asmlinkage void poly1305_emit(void *state, u8 *digest, const u32 *nonce);
+asmlinkage void poly1305_block_init_arch(
+	struct poly1305_block_state *state,
+	const u8 raw_key[POLY1305_BLOCK_SIZE]);
+EXPORT_SYMBOL_GPL(poly1305_block_init_arch);
+asmlinkage void poly1305_blocks(struct poly1305_block_state *state,
+				const u8 *src, u32 len, u32 hibit);
+asmlinkage void poly1305_blocks_neon(struct poly1305_block_state *state,
+				     const u8 *src, u32 len, u32 hibit);
+asmlinkage void poly1305_emit_arch(const struct poly1305_state *state,
+				   u8 digest[POLY1305_DIGEST_SIZE],
+				   const u32 nonce[4]);
+EXPORT_SYMBOL_GPL(poly1305_emit_arch);
 
 static __ro_after_init DEFINE_STATIC_KEY_FALSE(have_neon);
 
 void poly1305_init_arch(struct poly1305_desc_ctx *dctx, const u8 key[POLY1305_KEY_SIZE])
 {
-	poly1305_init_arm64(&dctx->h, key);
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
+	if (static_branch_likely(&have_neon)) {
+		do {
+			unsigned int todo = min_t(unsigned int, len, SZ_4K);
+
+			kernel_neon_begin();
+			poly1305_blocks_neon(state, src, todo, 1);
+			kernel_neon_end();
+
+			len -= todo;
+			src += todo;
+		} while (len);
+	} else
+		poly1305_blocks(state, src, len, 1);
+}
+EXPORT_SYMBOL_GPL(poly1305_blocks_arch);
+
 void poly1305_update_arch(struct poly1305_desc_ctx *dctx, const u8 *src,
 			  unsigned int nbytes)
 {
@@ -45,29 +73,15 @@ void poly1305_update_arch(struct poly1305_desc_ctx *dctx, const u8 *src,
 		dctx->buflen += bytes;
 
 		if (dctx->buflen == POLY1305_BLOCK_SIZE) {
-			poly1305_blocks(&dctx->h, dctx->buf, POLY1305_BLOCK_SIZE, 1);
+			poly1305_blocks_arch(&dctx->state, dctx->buf,
+					     POLY1305_BLOCK_SIZE, 1);
 			dctx->buflen = 0;
 		}
 	}
 
 	if (likely(nbytes >= POLY1305_BLOCK_SIZE)) {
-		unsigned int len = round_down(nbytes, POLY1305_BLOCK_SIZE);
-
-		if (static_branch_likely(&have_neon) && crypto_simd_usable()) {
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
-			poly1305_blocks(&dctx->h, src, len, 1);
-			src += len;
-		}
+		poly1305_blocks_arch(&dctx->state, src, nbytes, 1);
+		src += round_down(nbytes, POLY1305_BLOCK_SIZE);
 		nbytes %= POLY1305_BLOCK_SIZE;
 	}
 
@@ -84,10 +98,11 @@ void poly1305_final_arch(struct poly1305_desc_ctx *dctx, u8 *dst)
 		dctx->buf[dctx->buflen++] = 1;
 		memset(dctx->buf + dctx->buflen, 0,
 		       POLY1305_BLOCK_SIZE - dctx->buflen);
-		poly1305_blocks(&dctx->h, dctx->buf, POLY1305_BLOCK_SIZE, 0);
+		poly1305_blocks_arch(&dctx->state, dctx->buf,
+				     POLY1305_BLOCK_SIZE, 0);
 	}
 
-	poly1305_emit(&dctx->h, dst, dctx->s);
+	poly1305_emit_arch(&dctx->h, dst, dctx->s);
 	memzero_explicit(dctx, sizeof(*dctx));
 }
 EXPORT_SYMBOL(poly1305_final_arch);
-- 
2.39.5

