Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B81E3911A2;
	Mon, 12 Oct 2026 21:31:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791840685; cv=none; b=YSqs8KQxDWiWntNyQt0K2HGgAEHkrsqxokidkZ99uJZVYTKA5XHRDiLcm5wu8JwivZyMMKKPoi7snTDRGuppcu6EsbC0jbvLBC2FHSPyo1mKgb0Fn1PFcoks0y4crtFPTn+KOMCuugTjXG2rKGfDIAyACcZD6fEftNknrkyi5sU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791840685; c=relaxed/simple;
	bh=OmbX5DkcDbQMDiXeEHY8HnEaIOdVNKFBqOECIGPHiyk=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=QWMtlVcGo6+kPD72BExwPFrLzjfPy3U6/4rvAOaxbv8mdA8oi5mFIN6Zd4BTPgFC4qP3YpMUCylkVMBnfaseWxZXBl04o/gsvzOrxKYM0NlfCliyFW4CR9wbWVS5k2Zqqs4nXAeNXt743neTTaiz4ZYFbBJR3jaj7sT0DgrpGpk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=p/Xiertw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="p/Xiertw"
Received: by smtp.kernel.org (Postfix) with ESMTPS id CACA9C2BCFC;
	Mon, 12 Oct 2026 21:31:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1791840684;
	bh=OmbX5DkcDbQMDiXeEHY8HnEaIOdVNKFBqOECIGPHiyk=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=p/Xiertwj6st63/cEcMxhxQ22yG45SM7+PoUE9hhmUE6IygIQyAwAmVHfezJCtCta
	 mu+wzYuH0gU+e+WDR8ht2H+uWlvSJIPIdwfwtNO3wa3uYmLP1R1Dht9bgYOzXr/v0D
	 rRn20A43PSVLk5NAxsPYhibZYguSA3vEZxxYxpKD03z1fFl7ls4lG6LeRY7wjXEl2w
	 pIQTrOQDfKwLBO+WXnYzrHvh4P/C/a/A/MjsUAO0+n2XAl9jm71WB8266ODus0I6sc
	 oOyk8op3/9H7u2ozQKXFTEfiG2CvgWPZTuDL40LFm1RdDl5iZgtx9DDqcsjSmGj0zE
	 D220W9IAWXNWA==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AB205CA9ED2;
	Mon, 12 Oct 2026 21:31:24 +0000 (UTC)
From: Vladimir Kukharenko via B4 Relay <devnull+vladimir.genproof.com@kernel.org>
Date: Mon, 12 Oct 2026 21:31:18 +0000
Subject: [PATCH 1/5] lib/crypto: riscv/poly1305: Fix 32-bit length treated
 as 64-bit
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261012-libcrypto-4gib-lengths-v1-1-ea566c129a2e@genproof.com>
References: <20261012-libcrypto-4gib-lengths-v1-0-ea566c129a2e@genproof.com>
In-Reply-To: <20261012-libcrypto-4gib-lengths-v1-0-ea566c129a2e@genproof.com>
To: Herbert Xu <herbert@gondor.apana.org.au>, 
 "David S. Miller" <davem@davemloft.net>, Eric Biggers <ebiggers@kernel.org>, 
 "Jason A. Donenfeld" <Jason@zx2c4.com>, Ard Biesheuvel <ardb@kernel.org>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-riscv@lists.infradead.org, linux-mips@vger.kernel.org, 
 linux-arm-kernel@lists.infradead.org, Paul Walmsley <pjw@kernel.org>, 
 Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, 
 Alexandre Ghiti <alex@ghiti.fr>, 
 Vladimir Kukharenko <vladimir@genproof.com>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1791840683; l=1981;
 i=vladimir@genproof.com; s=20261012; h=from:subject:message-id;
 bh=FUk3igHcdyvJr77P9LhCKrgECrkRv7kXrMD3TWIWkCM=;
 b=dyyyhEM/gItvT7Fo5HXi8C3uel40Qr+fe+goqtFZzKvMbMv5Ls7+Z/8XLcKwxhlxwqC5KvITd
 CADJ0jH+RMoCfR/VzHLC0DoHk09yrD44sOW0otUWBXCwpqIsybInjJu
X-Developer-Key: i=vladimir@genproof.com; a=ed25519;
 pk=EqOzBSKBgFn7ExzKj5f9T8u+1yTrGVlLBwf3fj/sdHM=
X-Endpoint-Received: by B4 Relay for vladimir@genproof.com/20261012 with
 auth_id=1169
X-Original-From: Vladimir Kukharenko <vladimir@genproof.com>
Reply-To: vladimir@genproof.com

From: Vladimir Kukharenko <vladimir@genproof.com>

The C code declares the length argument of the assembly function
poly1305_blocks() as u32.  The assembly comes from OpenSSL/CRYPTOGAMS,
which declares the length as size_t, and on riscv64 it uses all 64 bits
of the register.  However, the RISC-V psABI sign-extends 32-bit
arguments, including unsigned ones, to 64 bits.  So for a length of
2 GiB or more, the assembly computes an end pointer 4 GiB lower than the
correct one, below the start of the input, and the loop reads past the
input until it faults.  poly1305_update() passes all complete blocks to
poly1305_blocks() in one call, so a single poly1305_update() of 2 GiB to
4 GiB triggers this.

Declare the length as size_t, as OpenSSL and the x86_64 code do, rather
than changing the imported assembly.  On riscv32, size_t is 32 bits
wide, so nothing changes there.

This bug was introduced by commit bef9c7559869 ("lib/crypto:
riscv/poly1305: Import OpenSSL/CRYPTOGAMS implementation").  No in-tree
caller passes 2 GiB or more in one call, so this is an ABI robustness
improvement.

I reproduced the fault on riscv64 in QEMU with a single 2 GiB
poly1305_update(), and this patch fixes it.

Assisted-by: LLM
Signed-off-by: Vladimir Kukharenko <vladimir@genproof.com>
---
 lib/crypto/riscv/poly1305.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/lib/crypto/riscv/poly1305.h b/lib/crypto/riscv/poly1305.h
index 88f3df44e355..aaf24d0f6674 100644
--- a/lib/crypto/riscv/poly1305.h
+++ b/lib/crypto/riscv/poly1305.h
@@ -8,7 +8,7 @@
 asmlinkage void poly1305_block_init(struct poly1305_block_state *state,
 				    const u8 raw_key[POLY1305_BLOCK_SIZE]);
 asmlinkage void poly1305_blocks(struct poly1305_block_state *state,
-				const u8 *src, u32 len, u32 hibit);
+				const u8 *src, size_t len, u32 hibit);
 asmlinkage void poly1305_emit(const struct poly1305_state *state,
 			      u8 digest[POLY1305_DIGEST_SIZE],
 			      const u32 nonce[4]);

-- 
2.43.0


