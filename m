Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 812411F0E47
	for <linux-crypto@vger.kernel.org>; Thu, 24 Apr 2025 10:47:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745491633; cv=none; b=bKEvcjC3vRt/a0ItIC2HuraKcQ52hgXy/Z0TGF5Yq3G9i4j38yng+LqMHmsjYVpMjAXeguvz7HH8Yfnj83TvkSDdTSqOINffZuK1FseAPl88yheiKNib5xBGibMkSkHgNrILaPeOc0zEr7vzpad762am9yEz4nPjPOJsBi9EMbI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745491633; c=relaxed/simple;
	bh=MppoNuwbKwzAWErSnM7IVUKSs/CGSDIGBmRVSuOaJ2M=;
	h=Date:Message-Id:In-Reply-To:References:From:Subject:To; b=dLu/WBBUSJzlBY00lznfvEd5XsrAZZSsuDTMLkhQTuGegAelAb5Iwb190s/nFn+mrp1htaYT8DIlehaRbxWJf/LrLjclIuBLVMmbVU++yFoyshlj/X5hA6xqNyhsNXUyTsRu+/PtjL5sM0qDhw9ykpfqBl3qY0SF10/29eRp6LQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=YMgstW5q; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="YMgstW5q"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=To:Subject:From:References:In-Reply-To:Message-Id:Date:Sender:
	Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=iqtms7F7kkvqGAx6C7Vu9N/6a0sOPJJAEFz5Uc1UeJ0=; b=YMgstW5q3uvbKcIGQ1bc45EGbj
	bMK3HdSLY0X0wam4bUKca87vllmkEaAEk69olSnyfhXuViOPJF+NTJJ/YVmP40m5MeVzKxkgqzpff
	PX+rTXZejqOCAJuw4uij90NjQnjbXP6yxpNXjbgonxKgn6m7gMtlpWEdjgpHyRiC9v6Tx/uDCgJ3y
	Ts0k2ap04VFJMGrf3TN13EI9mNaVFHNy6PNQwq7N1qz2L6c7449smG06pCHpO0BhTT+AhrxJmEqEx
	cDgttmSwOdEpgTDLMgjcNpfTF7thaeqX+rQkVr+b2NcXPzEMqVSivDpKkm/ADdgs2XSWOrcomulIE
	kwqWU92w==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1u7u6l-000fM7-2L;
	Thu, 24 Apr 2025 18:47:08 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Thu, 24 Apr 2025 18:47:07 +0800
Date: Thu, 24 Apr 2025 18:47:07 +0800
Message-Id: <c59424f3287cbbb7a124052554c2231a9c4f39cf.1745490652.git.herbert@gondor.apana.org.au>
In-Reply-To: <cover.1745490652.git.herbert@gondor.apana.org.au>
References: <cover.1745490652.git.herbert@gondor.apana.org.au>
From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 05/15] crypto: mips/poly1305 - Add block-only interface
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>

Add block-only interface.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---
 arch/mips/lib/crypto/poly1305-glue.c  | 28 ++++++++++++++++++---------
 arch/mips/lib/crypto/poly1305-mips.pl | 12 ++++++------
 2 files changed, 25 insertions(+), 15 deletions(-)

diff --git a/arch/mips/lib/crypto/poly1305-glue.c b/arch/mips/lib/crypto/poly1305-glue.c
index 576e7a58e0b1..fc00e96b2a5b 100644
--- a/arch/mips/lib/crypto/poly1305-glue.c
+++ b/arch/mips/lib/crypto/poly1305-glue.c
@@ -5,23 +5,32 @@
  * Copyright (C) 2019 Linaro Ltd. <ard.biesheuvel@linaro.org>
  */
 
-#include <crypto/poly1305.h>
+#include <crypto/internal/poly1305.h>
 #include <linux/cpufeature.h>
+#include <linux/kernel.h>
 #include <linux/module.h>
+#include <linux/string.h>
 #include <linux/unaligned.h>
 
-asmlinkage void poly1305_init_mips(void *state, const u8 *key);
-asmlinkage void poly1305_blocks_mips(void *state, const u8 *src, u32 len, u32 hibit);
-asmlinkage void poly1305_emit_mips(void *state, u8 *digest, const u32 *nonce);
+asmlinkage void poly1305_block_init_arch(struct poly1305_block_state *state,
+					 const u8 key[POLY1305_BLOCK_SIZE]);
+EXPORT_SYMBOL_GPL(poly1305_block_init_arch);
+asmlinkage void poly1305_blocks_arch(struct poly1305_block_state *state,
+				     const u8 *src, u32 len, u32 hibit);
+EXPORT_SYMBOL_GPL(poly1305_blocks_arch);
+asmlinkage void poly1305_emit_arch(const struct poly1305_state *state,
+				   u8 digest[POLY1305_DIGEST_SIZE],
+				   const u32 nonce[4]);
+EXPORT_SYMBOL_GPL(poly1305_emit_arch);
 
 void poly1305_init_arch(struct poly1305_desc_ctx *dctx, const u8 key[POLY1305_KEY_SIZE])
 {
-	poly1305_init_mips(&dctx->h, key);
 	dctx->s[0] = get_unaligned_le32(key + 16);
 	dctx->s[1] = get_unaligned_le32(key + 20);
 	dctx->s[2] = get_unaligned_le32(key + 24);
 	dctx->s[3] = get_unaligned_le32(key + 28);
 	dctx->buflen = 0;
+	poly1305_block_init_arch(&dctx->state, key);
 }
 EXPORT_SYMBOL(poly1305_init_arch);
 
@@ -37,7 +46,7 @@ void poly1305_update_arch(struct poly1305_desc_ctx *dctx, const u8 *src,
 		dctx->buflen += bytes;
 
 		if (dctx->buflen == POLY1305_BLOCK_SIZE) {
-			poly1305_blocks_mips(&dctx->h, dctx->buf,
+			poly1305_blocks_arch(&dctx->state, dctx->buf,
 					     POLY1305_BLOCK_SIZE, 1);
 			dctx->buflen = 0;
 		}
@@ -46,7 +55,7 @@ void poly1305_update_arch(struct poly1305_desc_ctx *dctx, const u8 *src,
 	if (likely(nbytes >= POLY1305_BLOCK_SIZE)) {
 		unsigned int len = round_down(nbytes, POLY1305_BLOCK_SIZE);
 
-		poly1305_blocks_mips(&dctx->h, src, len, 1);
+		poly1305_blocks_arch(&dctx->state, src, len, 1);
 		src += len;
 		nbytes %= POLY1305_BLOCK_SIZE;
 	}
@@ -64,10 +73,11 @@ void poly1305_final_arch(struct poly1305_desc_ctx *dctx, u8 *dst)
 		dctx->buf[dctx->buflen++] = 1;
 		memset(dctx->buf + dctx->buflen, 0,
 		       POLY1305_BLOCK_SIZE - dctx->buflen);
-		poly1305_blocks_mips(&dctx->h, dctx->buf, POLY1305_BLOCK_SIZE, 0);
+		poly1305_blocks_arch(&dctx->state, dctx->buf,
+				     POLY1305_BLOCK_SIZE, 0);
 	}
 
-	poly1305_emit_mips(&dctx->h, dst, dctx->s);
+	poly1305_emit_arch(&dctx->h, dst, dctx->s);
 	*dctx = (struct poly1305_desc_ctx){};
 }
 EXPORT_SYMBOL(poly1305_final_arch);
diff --git a/arch/mips/lib/crypto/poly1305-mips.pl b/arch/mips/lib/crypto/poly1305-mips.pl
index b05bab884ed2..399f10c3e385 100644
--- a/arch/mips/lib/crypto/poly1305-mips.pl
+++ b/arch/mips/lib/crypto/poly1305-mips.pl
@@ -93,9 +93,9 @@ $code.=<<___;
 #endif
 
 #ifdef	__KERNEL__
-# define poly1305_init   poly1305_init_mips
-# define poly1305_blocks poly1305_blocks_mips
-# define poly1305_emit   poly1305_emit_mips
+# define poly1305_init   poly1305_block_init_arch
+# define poly1305_blocks poly1305_blocks_arch
+# define poly1305_emit   poly1305_emit_arch
 #endif
 
 #if defined(__MIPSEB__) && !defined(MIPSEB)
@@ -565,9 +565,9 @@ $code.=<<___;
 #endif
 
 #ifdef	__KERNEL__
-# define poly1305_init   poly1305_init_mips
-# define poly1305_blocks poly1305_blocks_mips
-# define poly1305_emit   poly1305_emit_mips
+# define poly1305_init   poly1305_block_init_arch
+# define poly1305_blocks poly1305_blocks_arch
+# define poly1305_emit   poly1305_emit_arch
 #endif
 
 #if defined(__MIPSEB__) && !defined(MIPSEB)
-- 
2.39.5

