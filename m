Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 387F5155335;
	Sat, 17 May 2025 02:25:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747448718; cv=none; b=mCZrsMQHwQnw+pVLREoIi2Q6hltVusa/s9zStksSlryL65GbfoWvK6ENng/KXhGL6HPjovRaAGtA30IMqB/fE1lCqNSWPbVkGHD+HvPsCAWpIBPB2wL9/Zs3NtOu77t47HxT5R9kEewp93G2pUaTw6gP84/v632gOtt14PXIj6s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747448718; c=relaxed/simple;
	bh=RQzXMFdhT1ylCP6mlf030+K7wWNM4Zi/92juH8XlYe8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=chJYKPe4FdgjYXjb3AV5XG8Jrvyr50DI0yzgHCtwe0Jpc9ybEh7mAN6QPUiHNILB9X7JP2Yi0LeRn9usm8hOdmj6+wDBSZ37G/4pXNomfJGygthdYFRoqnW0c/sC6IrGWQVteVciuXa2vW84DPtlVcwNmvWGK3qJY0BbhJfC5rc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=sFPr5i8J; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="sFPr5i8J"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0CFAC4CEF1;
	Sat, 17 May 2025 02:25:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1747448717;
	bh=RQzXMFdhT1ylCP6mlf030+K7wWNM4Zi/92juH8XlYe8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sFPr5i8JqNit2AvE7B26blWgaOQSyYK6Z77ZN/1NHPIgldG1VZfO7/5lLjfr6IIiX
	 4FEkrlZuinxg+xR0JYu1dlYeAV13u/sOGtQ8pSAgbBVqbIHytuS4woVxrBhSdUvGvr
	 wG0c0YkUDD4OnYnil/o5DXFlPvu8tGpJ/ZgK5nT8C5BwiAqipjFKNY3nUHW+6Qp74h
	 Fsq76s8NAFBMBdOwE1mMj6Y2T48JODZyLRNkDmQJPE16Ew8IydUth7HQ1WNkpJ8Sdy
	 brYy0fTE9pQg77kER9lEAAE/IvLnK88KnVIT8jRqCIKZ6xZ6SEh83CYN6KVEeac7tU
	 aup4xbVNHpVqA==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 4/8] Revert "crypto: riscv/sha256 - Add simd block function"
Date: Fri, 16 May 2025 19:24:24 -0700
Message-ID: <20250517022428.401622-5-ebiggers@kernel.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250517022428.401622-1-ebiggers@kernel.org>
References: <20250517022428.401622-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Eric Biggers <ebiggers@google.com>

This reverts commit 491d6024f2820c78216b07cec1cb47c87dcae077 which got
pushed out despite being nacked.

That commit added a special low-level interface to allow the
crypto_shash API to bypass the safety check for using kernel-mode
vector.  It could give a marginal performance benefit for crypto_shash,
but just is not worth the complexity and footgun.  Moreover, the
distinction between "arch" and "simd" is confusing and is not something
that really should exist in generic code, given that different
architectures can mean different things by "simd".

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 arch/riscv/lib/crypto/Kconfig  |  1 -
 arch/riscv/lib/crypto/sha256.c | 13 ++++---------
 2 files changed, 4 insertions(+), 10 deletions(-)

diff --git a/arch/riscv/lib/crypto/Kconfig b/arch/riscv/lib/crypto/Kconfig
index 47c99ea97ce2c..c100571feb7e8 100644
--- a/arch/riscv/lib/crypto/Kconfig
+++ b/arch/riscv/lib/crypto/Kconfig
@@ -10,7 +10,6 @@ config CRYPTO_CHACHA_RISCV64
 config CRYPTO_SHA256_RISCV64
 	tristate
 	depends on 64BIT && RISCV_ISA_V && TOOLCHAIN_HAS_VECTOR_CRYPTO
 	default CRYPTO_LIB_SHA256
 	select CRYPTO_ARCH_HAVE_LIB_SHA256
-	select CRYPTO_ARCH_HAVE_LIB_SHA256_SIMD
 	select CRYPTO_LIB_SHA256_GENERIC
diff --git a/arch/riscv/lib/crypto/sha256.c b/arch/riscv/lib/crypto/sha256.c
index 71808397dff4c..4ad3ffb8e0a98 100644
--- a/arch/riscv/lib/crypto/sha256.c
+++ b/arch/riscv/lib/crypto/sha256.c
@@ -7,38 +7,33 @@
  *
  * Copyright (C) 2023 SiFive, Inc.
  * Author: Jerry Shih <jerry.shih@sifive.com>
  */
 
+#include <asm/simd.h>
 #include <asm/vector.h>
 #include <crypto/internal/sha2.h>
+#include <crypto/internal/simd.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
 
 asmlinkage void sha256_transform_zvknha_or_zvknhb_zvkb(
 	u32 state[SHA256_STATE_WORDS], const u8 *data, size_t nblocks);
 
 static __ro_after_init DEFINE_STATIC_KEY_FALSE(have_extensions);
 
-void sha256_blocks_simd(u32 state[SHA256_STATE_WORDS],
+void sha256_blocks_arch(u32 state[SHA256_STATE_WORDS],
 			const u8 *data, size_t nblocks)
 {
-	if (static_branch_likely(&have_extensions)) {
+	if (static_branch_likely(&have_extensions) && crypto_simd_usable()) {
 		kernel_vector_begin();
 		sha256_transform_zvknha_or_zvknhb_zvkb(state, data, nblocks);
 		kernel_vector_end();
 	} else {
 		sha256_blocks_generic(state, data, nblocks);
 	}
 }
-EXPORT_SYMBOL_GPL(sha256_blocks_simd);
-
-void sha256_blocks_arch(u32 state[SHA256_STATE_WORDS],
-			const u8 *data, size_t nblocks)
-{
-	sha256_blocks_generic(state, data, nblocks);
-}
 EXPORT_SYMBOL_GPL(sha256_blocks_arch);
 
 bool sha256_is_arch_optimized(void)
 {
 	return static_key_enabled(&have_extensions);
-- 
2.49.0

