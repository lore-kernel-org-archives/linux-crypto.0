Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 383F919AD5C
	for <linux-crypto@vger.kernel.org>; Mon, 28 Apr 2025 04:56:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745816182; cv=none; b=Kl6zmoOygXiGN7PTiKFwFaNwJlzHabE9J6Y3VsUSWQ0UcDFfIrxGQT4GTNjXzIP+U5+i7DdcSMqwnBBw3iMa3EBEwR02IlIQTIlQ/LJy4BK1epqr+m7mz2hTRNfR02gJwtZR7SJlviqPU6jhiIxv8u0XxWT6T754A40vSONuh6U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745816182; c=relaxed/simple;
	bh=ESx0J8pgoqbMFasL6vUSYb2D+iB33/ZG+uMlwsVXdXs=;
	h=Date:Message-Id:In-Reply-To:References:From:Subject:To; b=UtCPBXSHjfw88l3FLamYRRpeL3/LEHpZiTSj3qbgL02AnwJwcDvMsw4l8+aSB76g7BlVOfxcEYDuhPzIlHk0biqq2lkEwohchSBmZg7OmhV2LdRmq7OgMh2ZcxuIWxydI6hdLRLy4fsStXtCB0xrB+7vw3ce98o25JJaA0wRfMQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=TxAuZHe5; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="TxAuZHe5"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=To:Subject:From:References:In-Reply-To:Message-Id:Date:Sender:
	Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=XV5PvwlJ4J+9DQkXbaYE7c06SZojO4Q/UNQTGMaL6kE=; b=TxAuZHe5o22qFt+9DII8ZvMBfD
	AklBq31R64hLrnMu7DFRU9nW3OkhHRs5O1FEMqr/lQc+f4TT5TRvZsK0Xa8AuKCpxG3hbr0WNiAbk
	4VqHpPpEvgRZCcc7fzRuRt44Jo5LHmkLgTvH1Fh31nbTmmyxZhM9l9nC0sWiLCFyuYH3nxB2osQ2N
	kRRoDTyR6LmTG/J/P5/hNP7Q9N6RaetasBJoCyA1K5zSjE590KDrWZEUX6AHjLtXrbTlI5Cr5SHgO
	CiN17A3N80IQNvc+0mVFqd1bP+iVjCi3EMCKV9J6cMlBMIPGr471JV+OrjUF0RaEuVXY7A8vxjctn
	m+xPAG2Q==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1u9GXQ-001WFc-1q;
	Mon, 28 Apr 2025 12:56:17 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Mon, 28 Apr 2025 12:56:16 +0800
Date: Mon, 28 Apr 2025 12:56:16 +0800
Message-Id: <53b572d2695d6d554f365fca0c52f9f09fe7a8f8.1745815528.git.herbert@gondor.apana.org.au>
In-Reply-To: <cover.1745815528.git.herbert@gondor.apana.org.au>
References: <cover.1745815528.git.herbert@gondor.apana.org.au>
From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [v4 PATCH 06/11] crypto: powerpc/poly1305 - Add block-only interface
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
 arch/powerpc/lib/crypto/poly1305-p10-glue.c | 84 ++++++++++++---------
 1 file changed, 49 insertions(+), 35 deletions(-)

diff --git a/arch/powerpc/lib/crypto/poly1305-p10-glue.c b/arch/powerpc/lib/crypto/poly1305-p10-glue.c
index 00617f4c58e6..708435beaba6 100644
--- a/arch/powerpc/lib/crypto/poly1305-p10-glue.c
+++ b/arch/powerpc/lib/crypto/poly1305-p10-glue.c
@@ -4,19 +4,20 @@
  *
  * Copyright 2023- IBM Corp. All rights reserved.
  */
+#include <asm/switch_to.h>
+#include <crypto/internal/poly1305.h>
+#include <linux/cpufeature.h>
+#include <linux/jump_label.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
-#include <linux/jump_label.h>
-#include <crypto/internal/simd.h>
-#include <crypto/poly1305.h>
-#include <linux/cpufeature.h>
+#include <linux/string.h>
 #include <linux/unaligned.h>
-#include <asm/simd.h>
-#include <asm/switch_to.h>
 
-asmlinkage void poly1305_p10le_4blocks(void *h, const u8 *m, u32 mlen);
-asmlinkage void poly1305_64s(void *h, const u8 *m, u32 mlen, int highbit);
-asmlinkage void poly1305_emit_64(void *h, void *s, u8 *dst);
+asmlinkage void poly1305_p10le_4blocks(struct poly1305_block_state *state, const u8 *m, u32 mlen);
+asmlinkage void poly1305_64s(struct poly1305_block_state *state, const u8 *m, u32 mlen, int highbit);
+asmlinkage void poly1305_emit_arch(const struct poly1305_state *state,
+				   u8 digest[POLY1305_DIGEST_SIZE],
+				   const u32 nonce[4]);
 
 static __ro_after_init DEFINE_STATIC_KEY_FALSE(have_p10);
 
@@ -32,22 +33,49 @@ static void vsx_end(void)
 	preempt_enable();
 }
 
-void poly1305_init_arch(struct poly1305_desc_ctx *dctx, const u8 key[POLY1305_KEY_SIZE])
+void poly1305_block_init_arch(struct poly1305_block_state *dctx,
+			      const u8 raw_key[POLY1305_BLOCK_SIZE])
 {
 	if (!static_key_enabled(&have_p10))
-		return poly1305_init_generic(dctx, key);
+		return poly1305_block_init_generic(dctx, raw_key);
 
 	dctx->h = (struct poly1305_state){};
-	dctx->core_r.key.r64[0] = get_unaligned_le64(key + 0);
-	dctx->core_r.key.r64[1] = get_unaligned_le64(key + 8);
+	dctx->core_r.key.r64[0] = get_unaligned_le64(raw_key + 0);
+	dctx->core_r.key.r64[1] = get_unaligned_le64(raw_key + 8);
+}
+EXPORT_SYMBOL_GPL(poly1305_block_init_arch);
+
+void poly1305_init_arch(struct poly1305_desc_ctx *dctx, const u8 key[POLY1305_KEY_SIZE])
+{
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
+	if (!static_key_enabled(&have_p10))
+		return poly1305_blocks_generic(state, src, len, padbit);
+	vsx_begin();
+	if (len >= POLY1305_BLOCK_SIZE * 4) {
+		poly1305_p10le_4blocks(state, src, len);
+		src += len - (len % (POLY1305_BLOCK_SIZE * 4));
+		len %= POLY1305_BLOCK_SIZE * 4;
+	}
+	while (len >= POLY1305_BLOCK_SIZE) {
+		poly1305_64s(state, src, POLY1305_BLOCK_SIZE, padbit);
+		len -= POLY1305_BLOCK_SIZE;
+		src += POLY1305_BLOCK_SIZE;
+	}
+	vsx_end();
+}
+EXPORT_SYMBOL_GPL(poly1305_blocks_arch);
+
 void poly1305_update_arch(struct poly1305_desc_ctx *dctx,
 			  const u8 *src, unsigned int srclen)
 {
@@ -64,28 +92,15 @@ void poly1305_update_arch(struct poly1305_desc_ctx *dctx,
 		dctx->buflen += bytes;
 		if (dctx->buflen < POLY1305_BLOCK_SIZE)
 			return;
-		vsx_begin();
-		poly1305_64s(&dctx->h, dctx->buf, POLY1305_BLOCK_SIZE, 1);
-		vsx_end();
+		poly1305_blocks_arch(&dctx->state, dctx->buf,
+				     POLY1305_BLOCK_SIZE, 1);
 		dctx->buflen = 0;
 	}
 
 	if (likely(srclen >= POLY1305_BLOCK_SIZE)) {
-		bytes = round_down(srclen, POLY1305_BLOCK_SIZE);
-		if (crypto_simd_usable() && (srclen >= POLY1305_BLOCK_SIZE*4)) {
-			vsx_begin();
-			poly1305_p10le_4blocks(&dctx->h, src, srclen);
-			vsx_end();
-			src += srclen - (srclen % (POLY1305_BLOCK_SIZE * 4));
-			srclen %= POLY1305_BLOCK_SIZE * 4;
-		}
-		while (srclen >= POLY1305_BLOCK_SIZE) {
-			vsx_begin();
-			poly1305_64s(&dctx->h, src, POLY1305_BLOCK_SIZE, 1);
-			vsx_end();
-			srclen -= POLY1305_BLOCK_SIZE;
-			src += POLY1305_BLOCK_SIZE;
-		}
+		poly1305_blocks_arch(&dctx->state, src, srclen, 1);
+		src += srclen - (srclen % POLY1305_BLOCK_SIZE);
+		srclen %= POLY1305_BLOCK_SIZE;
 	}
 
 	if (unlikely(srclen)) {
@@ -104,12 +119,11 @@ void poly1305_final_arch(struct poly1305_desc_ctx *dctx, u8 *dst)
 		dctx->buf[dctx->buflen++] = 1;
 		memset(dctx->buf + dctx->buflen, 0,
 		       POLY1305_BLOCK_SIZE - dctx->buflen);
-		vsx_begin();
-		poly1305_64s(&dctx->h, dctx->buf, POLY1305_BLOCK_SIZE, 0);
-		vsx_end();
+		poly1305_blocks_arch(&dctx->state, dctx->buf,
+				     POLY1305_BLOCK_SIZE, 0);
 	}
 
-	poly1305_emit_64(&dctx->h, &dctx->s, dst);
+	poly1305_emit_arch(&dctx->h, dst, dctx->s);
 }
 EXPORT_SYMBOL(poly1305_final_arch);
 
-- 
2.39.5

