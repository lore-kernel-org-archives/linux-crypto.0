Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6F8022CBE9;
	Sun,  6 Jul 2025 23:11:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751843505; cv=none; b=d55O9EtWhSI0ocwzpvWU9L4k8hZPgWtbRfpxeEThK/L8U2tfRdpe+Xab2Oi+E3TFDFKi36WYs/6oxq7+kHBBvkr9ZU3XjgV17VAbihkg2RK31VZ81V5FPs8EEWYkaepiM6wUTBJqXX60J3lHEciKznQKCPUAhI3vHC+sNLZwsD8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751843505; c=relaxed/simple;
	bh=eNLm4Gv8Ke0apz7fKKHlDcDiwap6peJnw5T7wbtI+Fk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ydmz+jsdiQbPa/rYYRmZ4C8wH7yPGupaoGLOqvfRI3v+1EaLk5Gu26Y2bjQOoSEjKhzoUabH7mxvlowPbfiM/TvTte/hnL5YsxU2L0mxSJEnwQab5SbVcJxDWbCuksnbZBNphgyf9q5dAomReFNRKRxHMBb33+M9sVtZzY3vyNc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KEl716Q/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KEl716Q/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 88026C4CEF1;
	Sun,  6 Jul 2025 23:11:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1751843505;
	bh=eNLm4Gv8Ke0apz7fKKHlDcDiwap6peJnw5T7wbtI+Fk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KEl716Q/rK2VskCIQXoLJ37scDB2Fm19apyuGqS/cPSPUMWjpMuGpH/CQk/nCvxwb
	 0MOsJ+LZR5sAEBNawyFs1A2IcutUGYMhilgG4Ih6IqfQ8BpjMY2o02fcqr9jU+Jl/b
	 Z6l54XfQegzQi4jRdpmV+zohLeDQV5EHEV+VY4hyXDxchkcv7lhdl0v90Tpa/f3OkR
	 abOc6SXVC0dtEWnbp6fgSs2+TAdnF4bOVLhfh/p6Hnm7SFGUUxIbWCt0cWRdQHedNu
	 ARrsqagae5ClEE5uLmBvMtLYXcrMWFInU4JuU4LAwq8PDUCxnKXm3ijXOM0XWDgD17
	 pIZeqhJR8EasA==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	Ard Biesheuvel <ardb@kernel.org>,
	"Jason A . Donenfeld" <Jason@zx2c4.com>,
	linux-arm-kernel@lists.infradead.org,
	x86@kernel.org,
	Eric Biggers <ebiggers@kernel.org>,
	stable@vger.kernel.org
Subject: [PATCH 3/5] lib/crypto: arm64/poly1305: Fix register corruption in no-SIMD contexts
Date: Sun,  6 Jul 2025 16:10:58 -0700
Message-ID: <20250706231100.176113-4-ebiggers@kernel.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250706231100.176113-1-ebiggers@kernel.org>
References: <20250706231100.176113-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Restore the SIMD usability check that was removed by commit a59e5468a921
("crypto: arm64/poly1305 - Add block-only interface").

This safety check is cheap and is well worth eliminating a footgun.
While the Poly1305 functions *should* be called only where SIMD
registers are usable, if they are anyway, they should just do the right
thing instead of corrupting random tasks' registers and/or computing
incorrect MACs.  Fixing this is also needed for poly1305_kunit to pass.

Just use may_use_simd() instead of the original crypto_simd_usable(),
since poly1305_kunit won't rely on crypto_simd_disabled_for_test.

Fixes: a59e5468a921 ("crypto: arm64/poly1305 - Add block-only interface")
Cc: stable@vger.kernel.org
Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---
 lib/crypto/arm64/poly1305-glue.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/lib/crypto/arm64/poly1305-glue.c b/lib/crypto/arm64/poly1305-glue.c
index c9a74766785b..31aea21ce42f 100644
--- a/lib/crypto/arm64/poly1305-glue.c
+++ b/lib/crypto/arm64/poly1305-glue.c
@@ -5,10 +5,11 @@
  * Copyright (C) 2019 Linaro Ltd. <ard.biesheuvel@linaro.org>
  */
 
 #include <asm/hwcap.h>
 #include <asm/neon.h>
+#include <asm/simd.h>
 #include <crypto/internal/poly1305.h>
 #include <linux/cpufeature.h>
 #include <linux/jump_label.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
@@ -31,11 +32,11 @@ static __ro_after_init DEFINE_STATIC_KEY_FALSE(have_neon);
 
 void poly1305_blocks_arch(struct poly1305_block_state *state, const u8 *src,
 			  unsigned int len, u32 padbit)
 {
 	len = round_down(len, POLY1305_BLOCK_SIZE);
-	if (static_branch_likely(&have_neon)) {
+	if (static_branch_likely(&have_neon) && likely(may_use_simd())) {
 		do {
 			unsigned int todo = min_t(unsigned int, len, SZ_4K);
 
 			kernel_neon_begin();
 			poly1305_blocks_neon(state, src, todo, padbit);
-- 
2.50.0

