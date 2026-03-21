Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D42834B661;
	Sat, 21 Mar 2026 04:12:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774066322; cv=none; b=kDajW0vkmxafU+wN6ucPIVhTlLkcsESfUhjnsMi4y5/X69OiMoWvXd2FoF/ben4QAOj0HHKcs7uyUORmVdPMLJY3iAf5jnyvadHbogFeTvCooF5/FCMesIVpNufpMwezB1ixPd7/6OY9etMG5hhEqYFk8ZwHG15gWxQs/HzE85I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774066322; c=relaxed/simple;
	bh=YTCXNwCW0pq6MdfWR7uCz9B7vdUNcCWmKts2sjqXBG4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LXTppnmI71zVrrcgnUZuESRC3nplzR1Mmlm+XDjg3GH5polytJfWLusNoKAPLg7Q/LHYG0d8b4hEmROVMppvXwTyLUeQeHbReDcLAmrEPKVOgljacgXv9EFmow4KAjwJu2ugVdoLuDMx9eA4VPsciMqwPvx2P9GSzSOd/Zixn1I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mxIeQ4nX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mxIeQ4nX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 279C0C2BCB6;
	Sat, 21 Mar 2026 04:12:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774066322;
	bh=YTCXNwCW0pq6MdfWR7uCz9B7vdUNcCWmKts2sjqXBG4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mxIeQ4nXmXOm+FC9A25/2GNvGqGXr3MsknSYssoxvx/2YrDB6qkriCl6SG6OujLq1
	 wENn7p9NRFovoYtvcgvm0ObpcE1HckNEU5ixH5vIlSDwhWKf33m6fwxPcpyfj3lYgh
	 K2E/PAlFCOBXsVlpuCC/4cBb46R8fKyYzyNDWif1QybebUP3dQCPNTG32TZmye1Yhr
	 ykI1r/IJSZ32SsnhjxG4d95cZNc/hXaUEAJwZI6pWJvlpEEjETv69Jujd7IUFM5oil
	 6BKgaTy+APxjb4I5mjDHeIBdc2tokUsSxfdqQODJ51V0pwACykij9VDeoibrhX/LLB
	 oUw6/Dtz8p0qA==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	Ard Biesheuvel <ardb@kernel.org>,
	"Jason A . Donenfeld" <Jason@zx2c4.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Tianjia Zhang <tianjia.zhang@linux.alibaba.com>,
	linux-arm-kernel@lists.infradead.org,
	linux-riscv@lists.infradead.org,
	x86@kernel.org,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH 10/12] crypto: sm3 - Remove sm3_base.h
Date: Fri, 20 Mar 2026 21:09:33 -0700
Message-ID: <20260321040935.410034-11-ebiggers@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260321040935.410034-1-ebiggers@kernel.org>
References: <20260321040935.410034-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Remove include/crypto/sm3_base.h, since it's no longer used.  The
corresponding logic was reimplemented in a central place in lib/crypto/.

Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---
 include/crypto/sm3_base.h | 92 ---------------------------------------
 1 file changed, 92 deletions(-)
 delete mode 100644 include/crypto/sm3_base.h

diff --git a/include/crypto/sm3_base.h b/include/crypto/sm3_base.h
deleted file mode 100644
index 9fa995617495..000000000000
--- a/include/crypto/sm3_base.h
+++ /dev/null
@@ -1,92 +0,0 @@
-/* SPDX-License-Identifier: GPL-2.0-only */
-/*
- * sm3_base.h - core logic for SM3 implementations
- *
- * Copyright (C) 2017 ARM Limited or its affiliates.
- * Written by Gilad Ben-Yossef <gilad@benyossef.com>
- */
-
-#ifndef _CRYPTO_SM3_BASE_H
-#define _CRYPTO_SM3_BASE_H
-
-#include <crypto/internal/hash.h>
-#include <crypto/sm3.h>
-#include <linux/math.h>
-#include <linux/module.h>
-#include <linux/string.h>
-#include <linux/types.h>
-#include <linux/unaligned.h>
-
-typedef void (sm3_block_fn)(struct sm3_state *sst, u8 const *src, int blocks);
-
-static inline int sm3_base_init(struct shash_desc *desc)
-{
-	struct sm3_state *sctx = shash_desc_ctx(desc);
-
-	sctx->state[0] = SM3_IVA;
-	sctx->state[1] = SM3_IVB;
-	sctx->state[2] = SM3_IVC;
-	sctx->state[3] = SM3_IVD;
-	sctx->state[4] = SM3_IVE;
-	sctx->state[5] = SM3_IVF;
-	sctx->state[6] = SM3_IVG;
-	sctx->state[7] = SM3_IVH;
-	sctx->count = 0;
-	return 0;
-}
-
-static inline int sm3_base_do_update_blocks(struct shash_desc *desc,
-					    const u8 *data, unsigned int len,
-					    sm3_block_fn *block_fn)
-{
-	unsigned int remain = len - round_down(len, SM3_BLOCK_SIZE);
-	struct sm3_state *sctx = shash_desc_ctx(desc);
-
-	sctx->count += len - remain;
-	block_fn(sctx, data, len / SM3_BLOCK_SIZE);
-	return remain;
-}
-
-static inline int sm3_base_do_finup(struct shash_desc *desc,
-				    const u8 *src, unsigned int len,
-				    sm3_block_fn *block_fn)
-{
-	unsigned int bit_offset = SM3_BLOCK_SIZE / 8 - 1;
-	struct sm3_state *sctx = shash_desc_ctx(desc);
-	union {
-		__be64 b64[SM3_BLOCK_SIZE / 4];
-		u8 u8[SM3_BLOCK_SIZE * 2];
-	} block = {};
-
-	if (len >= SM3_BLOCK_SIZE) {
-		int remain;
-
-		remain = sm3_base_do_update_blocks(desc, src, len, block_fn);
-		src += len - remain;
-		len = remain;
-	}
-
-	if (len >= bit_offset * 8)
-		bit_offset += SM3_BLOCK_SIZE / 8;
-	memcpy(&block, src, len);
-	block.u8[len] = 0x80;
-	sctx->count += len;
-	block.b64[bit_offset] = cpu_to_be64(sctx->count << 3);
-	block_fn(sctx, block.u8, (bit_offset + 1) * 8 / SM3_BLOCK_SIZE);
-	memzero_explicit(&block, sizeof(block));
-
-	return 0;
-}
-
-static inline int sm3_base_finish(struct shash_desc *desc, u8 *out)
-{
-	struct sm3_state *sctx = shash_desc_ctx(desc);
-	__be32 *digest = (__be32 *)out;
-	int i;
-
-	for (i = 0; i < SM3_DIGEST_SIZE / sizeof(__be32); i++)
-		put_unaligned_be32(sctx->state[i], digest++);
-	return 0;
-}
-
-#endif /* _CRYPTO_SM3_BASE_H */
-- 
2.53.0

