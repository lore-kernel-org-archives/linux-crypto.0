Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3883B1553AA;
	Sat, 17 May 2025 02:25:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747448718; cv=none; b=CzR0s97ggI/rHy5cj4exzdb+d2GDgnzG95JyYI+XEWKe5GU4w3wew01agucUeN/aq0ch4OSYD/fAbUR1RPkcggy6kmH23QWg3HCP3VAy6jI8xuQTL2aMTYSW1JjKpz5PNGN5e4kj69Y8uxUHlAvfl7FwB8Nj3dZDw9eeB7GGWUk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747448718; c=relaxed/simple;
	bh=zUUQ2TPc05qFjP/3dGiAormza2njLcbl0lYH1g6EJzM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FSva9bnjLoo/vQLt9Fzi3U9aF7soRgBkXsPF+/zRt/OCfYM+EZ2zuIkanFhMXQbsOipV46ga/9KgczR5fsLkGIhf9Nw44OeoTJnUi4g0C5kwjPX/q0GU/cLZJKYggQav3eSF2HySfhi031RTVt3z1axQwEeZ0XOfcW5xeVyQGrA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Z2S/9K23; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Z2S/9K23"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D65BC4CEF0;
	Sat, 17 May 2025 02:25:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1747448717;
	bh=zUUQ2TPc05qFjP/3dGiAormza2njLcbl0lYH1g6EJzM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Z2S/9K23SvOJkqAVecLH7gOCj9koGAHFiDlFoWZ2b+ne16GebeCSatT+reQ4uAp7R
	 pX20NSu9qRDSfNTk657+KJE6lgHArP7KHk22E7agp7tA6OZuOKnbZ+JluzxAg8p5/w
	 OsDz19ZO+3WbbSP0w71lA+bWAl30BS7oqaGF6UuteQlgD+pnxzvPmAn5LcBZFlDa5C
	 sIwYNTLw9G2t9y1yC4FaDb5Vhfk2DB1tfT0WTNTeD0AN8LSx4SZJ69N6+uZU20xi4Y
	 JZEQEialJvh7iGIXvjlOe7B5S0BlYUiAFh5tykVUacYbEdIY7Vp+RZ78o1LY8obUia
	 0e1tXmGNhptXA==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 3/8] Revert "crypto: x86/sha256 - Add simd block function"
Date: Fri, 16 May 2025 19:24:23 -0700
Message-ID: <20250517022428.401622-4-ebiggers@kernel.org>
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

This reverts commit ee8a720e39ceb7495ab639c1eb6d4987fb6a52bf which got
pushed out despite being nacked.

That commit added a special low-level interface to allow the
crypto_shash API to bypass the safety check for using kernel-mode FPU.
It could give a marginal performance benefit for crypto_shash, but just
is not worth the complexity and footgun.  Moreover, the distinction
between "arch" and "simd" is confusing and is not something that really
should exist in generic code, given that different architectures can
mean different things by "simd".

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 arch/x86/lib/crypto/Kconfig  |  1 -
 arch/x86/lib/crypto/sha256.c | 12 +++---------
 2 files changed, 3 insertions(+), 10 deletions(-)

diff --git a/arch/x86/lib/crypto/Kconfig b/arch/x86/lib/crypto/Kconfig
index 5e94cdee492c2..e344579db3d85 100644
--- a/arch/x86/lib/crypto/Kconfig
+++ b/arch/x86/lib/crypto/Kconfig
@@ -28,7 +28,6 @@ config CRYPTO_POLY1305_X86_64
 config CRYPTO_SHA256_X86_64
 	tristate
 	depends on 64BIT
 	default CRYPTO_LIB_SHA256
 	select CRYPTO_ARCH_HAVE_LIB_SHA256
-	select CRYPTO_ARCH_HAVE_LIB_SHA256_SIMD
 	select CRYPTO_LIB_SHA256_GENERIC
diff --git a/arch/x86/lib/crypto/sha256.c b/arch/x86/lib/crypto/sha256.c
index 80380f8fdcee4..baba74d7d26f2 100644
--- a/arch/x86/lib/crypto/sha256.c
+++ b/arch/x86/lib/crypto/sha256.c
@@ -4,10 +4,11 @@
  *
  * Copyright 2025 Google LLC
  */
 #include <asm/fpu/api.h>
 #include <crypto/internal/sha2.h>
+#include <crypto/internal/simd.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/static_call.h>
 
 asmlinkage void sha256_transform_ssse3(u32 state[SHA256_STATE_WORDS],
@@ -21,28 +22,21 @@ asmlinkage void sha256_ni_transform(u32 state[SHA256_STATE_WORDS],
 
 static __ro_after_init DEFINE_STATIC_KEY_FALSE(have_sha256_x86);
 
 DEFINE_STATIC_CALL(sha256_blocks_x86, sha256_transform_ssse3);
 
-void sha256_blocks_simd(u32 state[SHA256_STATE_WORDS],
+void sha256_blocks_arch(u32 state[SHA256_STATE_WORDS],
 			const u8 *data, size_t nblocks)
 {
-	if (static_branch_likely(&have_sha256_x86)) {
+	if (static_branch_likely(&have_sha256_x86) && crypto_simd_usable()) {
 		kernel_fpu_begin();
 		static_call(sha256_blocks_x86)(state, data, nblocks);
 		kernel_fpu_end();
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
 	return static_key_enabled(&have_sha256_x86);
-- 
2.49.0

