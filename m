Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFA3F22655E
	for <linux-crypto@vger.kernel.org>; Thu, 24 Apr 2025 10:47:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745491635; cv=none; b=EycRVT10XQeh/7hmr4xIzYaO9gjnc+H+zYTiK7vE5SFYIiCmnIxpqBzBpy2PoxpUQnmioPEaf3Vf4f6KqsUNmfja1hZOGB5ZJjPeo0G+PVkqq24YCYkHTFJaNV9MCLF7YihxKEgEgOHLR2JsRAq/oyURfhhkG0G+8f8FEoih5QY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745491635; c=relaxed/simple;
	bh=Q6azOVeK8G09nhZlwr5j2pmQwK/gzk7oegCEL9YJasw=;
	h=Date:Message-Id:In-Reply-To:References:From:Subject:To; b=hjEXBPJ9G0JTZsQNusTfvBuC8JSoubBPab/0KS8GjeU1yHjsDdyvSslzyax0U9QlQvpiRvS61EFL0wI7XqYL6nY47mJXxZXfy4GNoHYtlp3suNwItHeJxHXfrxFE0eMQpd7oyLsQk1yvV5FZ8TqU4R39f1PhK8ZJKDEpjqndQeU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=LktY3GLG; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="LktY3GLG"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=To:Subject:From:References:In-Reply-To:Message-Id:Date:Sender:
	Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=+cQWm32WblOituON1ktqHoKwzBn739M7nDg3QzEO0xU=; b=LktY3GLGqRdvtIlFQKSY1V1koY
	Gxn1WY7W95QMxD+6C1/4PFgFnvQPQ9fzTWzQnHxAbBUKXhSTiG/1KJNtetvrRZ7So8VcRRVC9YT63
	89Xdxe3f78kldzzV7VqD59pIE9Nyn2K7vTyPda7wonIjcpn3nJRFoSZfY95Iv2TbdJW0A1p7E/Vo0
	7Jt08TDMl/M6esx+XGPzhGnzKf2o88z16LGlxjZhVsMHkjh1E7WeHSJu9GcRnK3x53Ix3/ozPkpy+
	tBa6KnQhY41p1zHuTs8JN19lbcQfAMpPvq2NE4MvO7P9y0rPL6geblrcnTGWcccrh3Cf0VJww0R9/
	Wy1dAcuw==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1u7u6o-000fMI-08;
	Thu, 24 Apr 2025 18:47:11 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Thu, 24 Apr 2025 18:47:10 +0800
Date: Thu, 24 Apr 2025 18:47:10 +0800
Message-Id: <6739eccab80468c828e2cf1dd30ee666d8d23149.1745490652.git.herbert@gondor.apana.org.au>
In-Reply-To: <cover.1745490652.git.herbert@gondor.apana.org.au>
References: <cover.1745490652.git.herbert@gondor.apana.org.au>
From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 06/15] crypto: powerpc/poly1305 - Add block-only interface
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
 arch/powerpc/lib/crypto/poly1305-p10-glue.c | 80 ++++++++++++---------
 1 file changed, 47 insertions(+), 33 deletions(-)

diff --git a/arch/powerpc/lib/crypto/poly1305-p10-glue.c b/arch/powerpc/lib/crypto/poly1305-p10-glue.c
index 00617f4c58e6..a33c61efd360 100644
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
+			      const u8 key[POLY1305_BLOCK_SIZE])
 {
 	if (!static_key_enabled(&have_p10))
-		return poly1305_init_generic(dctx, key);
+		return poly1305_block_init_generic(dctx, key);
 
 	dctx->h = (struct poly1305_state){};
 	dctx->core_r.key.r64[0] = get_unaligned_le64(key + 0);
 	dctx->core_r.key.r64[1] = get_unaligned_le64(key + 8);
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

