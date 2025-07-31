Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3A8E21CFF6
	for <linux-crypto@vger.kernel.org>; Thu, 31 Jul 2025 22:36:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754001364; cv=none; b=QT20Q1c5FhhqGA+5Y0x/5QCYq+Vbsv0WzBPNwF/JUPGY2CkfHAXSCKK9R275oaNnGGM69HInjpiKNMz1T4/K72mAK9KJfOb1Kv7T5o/lBX/4eKFQAP12xnOWngk/QkTuUIYO/kfk+n7MLw1U9Q0IWvd6dZeP3/WwQPVwr8uYc8c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754001364; c=relaxed/simple;
	bh=xwxurTBqcnXKRsLc5f2dN9h8euuvPUjfi5dm2FHbjIk=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=P3bfLCrHQdksvwVd2Py0B1Pm3RYlDtXxY2theyDh1e7vRcfuxYaQ1GKv3W1Hq1j7s8j66QNVhgGhcS1jab6sqQA7QAtbyZI/fEoRw4tte4rQKG9nysxjOwRpQmQFy4rviAAKfH2Vzf1DOEgTeYG/K9ua5JaaSsCjPvFMQeGFc7w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=YzQJG5UM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YzQJG5UM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8143C4CEEF;
	Thu, 31 Jul 2025 22:36:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1754001364;
	bh=xwxurTBqcnXKRsLc5f2dN9h8euuvPUjfi5dm2FHbjIk=;
	h=From:To:Cc:Subject:Date:From;
	b=YzQJG5UMfzF+ATMY24BUW6wn3774F3EtmgJQo0rinEbdekwWXdSZGjCqZcqF29W91
	 OxMYNJyKEpzPjX0QPVpA9tIDJyqYwKR8J5LeJM93RlFSopywr9RV0XVsiYGiKjPbV9
	 SibuKh+Z3T6x2BD8mmbmETy5tH/KTqv2PGai5qrx76ZQDdm2P7lfxWKqpVNS8gvkCe
	 LjFKlfeqv6Iz79i79w+6XKBp/pnqX966XiFGgap4okjfOTmwZHsA8foR1NPFhnUzpk
	 1CtJ5Ig13YwfbK4/Dghx80Ye09eA7qhfOVYbfA3oihC6VbKnc+qRrgz72cONQp5qgM
	 rANWQ4PjNe8kA==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Cc: Ard Biesheuvel <ardb@kernel.org>,
	"Jason A . Donenfeld" <Jason@zx2c4.com>,
	linux-arm-kernel@lists.infradead.org,
	x86@kernel.org,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH] lib/crypto: sha256: Use underlying functions instead of crypto_simd_usable()
Date: Thu, 31 Jul 2025 15:35:10 -0700
Message-ID: <20250731223510.136650-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.50.1
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Since sha256_kunit tests the fallback code paths without using
crypto_simd_disabled_for_test, make the SHA-256 code just use the
underlying may_use_simd() and irq_fpu_usable() functions directly
instead of crypto_simd_usable().  This eliminates an unnecessary layer.

While doing this, also add likely() annotations, and fix a minor
inconsistency where the static keys in the sha256.h files were in a
different place than in the corresponding sha1.h and sha512.h files.

Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---
 lib/crypto/arm/sha256.h   | 10 +++++-----
 lib/crypto/arm64/sha256.h | 10 +++++-----
 lib/crypto/riscv/sha256.h |  8 ++++----
 lib/crypto/x86/sha256.h   |  3 +--
 4 files changed, 15 insertions(+), 16 deletions(-)

diff --git a/lib/crypto/arm/sha256.h b/lib/crypto/arm/sha256.h
index da75cbdc51d41..eab713e650f33 100644
--- a/lib/crypto/arm/sha256.h
+++ b/lib/crypto/arm/sha256.h
@@ -3,27 +3,27 @@
  * SHA-256 optimized for ARM
  *
  * Copyright 2025 Google LLC
  */
 #include <asm/neon.h>
-#include <crypto/internal/simd.h>
+#include <asm/simd.h>
+
+static __ro_after_init DEFINE_STATIC_KEY_FALSE(have_neon);
+static __ro_after_init DEFINE_STATIC_KEY_FALSE(have_ce);
 
 asmlinkage void sha256_block_data_order(struct sha256_block_state *state,
 					const u8 *data, size_t nblocks);
 asmlinkage void sha256_block_data_order_neon(struct sha256_block_state *state,
 					     const u8 *data, size_t nblocks);
 asmlinkage void sha256_ce_transform(struct sha256_block_state *state,
 				    const u8 *data, size_t nblocks);
 
-static __ro_after_init DEFINE_STATIC_KEY_FALSE(have_neon);
-static __ro_after_init DEFINE_STATIC_KEY_FALSE(have_ce);
-
 static void sha256_blocks(struct sha256_block_state *state,
 			  const u8 *data, size_t nblocks)
 {
 	if (IS_ENABLED(CONFIG_KERNEL_MODE_NEON) &&
-	    static_branch_likely(&have_neon) && crypto_simd_usable()) {
+	    static_branch_likely(&have_neon) && likely(may_use_simd())) {
 		kernel_neon_begin();
 		if (static_branch_likely(&have_ce))
 			sha256_ce_transform(state, data, nblocks);
 		else
 			sha256_block_data_order_neon(state, data, nblocks);
diff --git a/lib/crypto/arm64/sha256.h b/lib/crypto/arm64/sha256.h
index a211966c124a9..d95f1077c32bd 100644
--- a/lib/crypto/arm64/sha256.h
+++ b/lib/crypto/arm64/sha256.h
@@ -3,28 +3,28 @@
  * SHA-256 optimized for ARM64
  *
  * Copyright 2025 Google LLC
  */
 #include <asm/neon.h>
-#include <crypto/internal/simd.h>
+#include <asm/simd.h>
 #include <linux/cpufeature.h>
 
+static __ro_after_init DEFINE_STATIC_KEY_FALSE(have_neon);
+static __ro_after_init DEFINE_STATIC_KEY_FALSE(have_ce);
+
 asmlinkage void sha256_block_data_order(struct sha256_block_state *state,
 					const u8 *data, size_t nblocks);
 asmlinkage void sha256_block_neon(struct sha256_block_state *state,
 				  const u8 *data, size_t nblocks);
 asmlinkage size_t __sha256_ce_transform(struct sha256_block_state *state,
 					const u8 *data, size_t nblocks);
 
-static __ro_after_init DEFINE_STATIC_KEY_FALSE(have_neon);
-static __ro_after_init DEFINE_STATIC_KEY_FALSE(have_ce);
-
 static void sha256_blocks(struct sha256_block_state *state,
 			  const u8 *data, size_t nblocks)
 {
 	if (IS_ENABLED(CONFIG_KERNEL_MODE_NEON) &&
-	    static_branch_likely(&have_neon) && crypto_simd_usable()) {
+	    static_branch_likely(&have_neon) && likely(may_use_simd())) {
 		if (static_branch_likely(&have_ce)) {
 			do {
 				size_t rem;
 
 				kernel_neon_begin();
diff --git a/lib/crypto/riscv/sha256.h b/lib/crypto/riscv/sha256.h
index c0f79c18f1199..f36f68d2e88cc 100644
--- a/lib/crypto/riscv/sha256.h
+++ b/lib/crypto/riscv/sha256.h
@@ -7,23 +7,23 @@
  *
  * Copyright (C) 2023 SiFive, Inc.
  * Author: Jerry Shih <jerry.shih@sifive.com>
  */
 
+#include <asm/simd.h>
 #include <asm/vector.h>
-#include <crypto/internal/simd.h>
+
+static __ro_after_init DEFINE_STATIC_KEY_FALSE(have_extensions);
 
 asmlinkage void
 sha256_transform_zvknha_or_zvknhb_zvkb(struct sha256_block_state *state,
 				       const u8 *data, size_t nblocks);
 
-static __ro_after_init DEFINE_STATIC_KEY_FALSE(have_extensions);
-
 static void sha256_blocks(struct sha256_block_state *state,
 			  const u8 *data, size_t nblocks)
 {
-	if (static_branch_likely(&have_extensions) && crypto_simd_usable()) {
+	if (static_branch_likely(&have_extensions) && likely(may_use_simd())) {
 		kernel_vector_begin();
 		sha256_transform_zvknha_or_zvknhb_zvkb(state, data, nblocks);
 		kernel_vector_end();
 	} else {
 		sha256_blocks_generic(state, data, nblocks);
diff --git a/lib/crypto/x86/sha256.h b/lib/crypto/x86/sha256.h
index 669bc06538b67..c852396ef3190 100644
--- a/lib/crypto/x86/sha256.h
+++ b/lib/crypto/x86/sha256.h
@@ -3,22 +3,21 @@
  * SHA-256 optimized for x86_64
  *
  * Copyright 2025 Google LLC
  */
 #include <asm/fpu/api.h>
-#include <crypto/internal/simd.h>
 #include <linux/static_call.h>
 
 DEFINE_STATIC_CALL(sha256_blocks_x86, sha256_blocks_generic);
 
 #define DEFINE_X86_SHA256_FN(c_fn, asm_fn)                                 \
 	asmlinkage void asm_fn(struct sha256_block_state *state,           \
 			       const u8 *data, size_t nblocks);            \
 	static void c_fn(struct sha256_block_state *state, const u8 *data, \
 			 size_t nblocks)                                   \
 	{                                                                  \
-		if (likely(crypto_simd_usable())) {                        \
+		if (likely(irq_fpu_usable())) {                            \
 			kernel_fpu_begin();                                \
 			asm_fn(state, data, nblocks);                      \
 			kernel_fpu_end();                                  \
 		} else {                                                   \
 			sha256_blocks_generic(state, data, nblocks);       \

base-commit: d6084bb815c453de27af8071a23163a711586a6c
-- 
2.50.1

