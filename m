Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0BFE29E11F;
	Sun,  6 Jul 2025 23:11:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751843504; cv=none; b=CAIgK5fwZAXCyf7n1SruYGpi3Apzr5V890eoP39Jin/7G6/2Ca5wM/jvOmRdF9S4Q1CpYkHc8jfvOUR+8anWEeOU49fQqhsOAsILH2Kf76jOBeZyY3JrxNBJXgGy6tbV2TZjSaNdygIsGjnfmTm5+IQzAWQRbYfhOLqJ9OUwGHI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751843504; c=relaxed/simple;
	bh=XWfjXYT5FJgcE1mXz/f5qW91oQVmDL2Rc7vpGHvJHCk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=j7RM/qkUK366Z98/WYmqJZyQmx/d7eyRAOS5NA6Fq6KEamFciYvBmIWz86FCGKmr1Q2Os3vE3wSF2jhNU1hb0LtCSru5yosTRP+WFYNusszCTQKC2sx0B8CsfE4qyeJ4+jAtyL66qFPTuCRLP04loXODm0HQASPcgVfj9Yi00mw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VZw/74aY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VZw/74aY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF17FC4CEF2;
	Sun,  6 Jul 2025 23:11:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1751843504;
	bh=XWfjXYT5FJgcE1mXz/f5qW91oQVmDL2Rc7vpGHvJHCk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VZw/74aYNyJCvF/E+Jw7X4nCvVoF1NKvNTDjDkO+pFKvp8sd1Hz2oEKygRlE9SNKD
	 kZ6an3PCWsh5GWm4eMc0X8yp39Cjrm1ZDbhlNAHXcL7A2Hj3wQt94iyJgg1j3YllVj
	 LxG3tdal1EGEqgsswwdZlSoWFhiD993bVunTZl5qv22vTFOfJTiKotnaUjdeT6OXIC
	 WaE5LyvYbTUdDj6xTB49htkSUrkp6/8JHXjo7OS4mMbxaYsF5dUu9nY1urWz8hF1yv
	 /iReSS8SiAP6BNraPAb3kD7t4mi6PAgY3hiAddznUaDRLWYDpS+nqW+r75G3sHJXR7
	 UwsKKa0LsJ0Rw==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	Ard Biesheuvel <ardb@kernel.org>,
	"Jason A . Donenfeld" <Jason@zx2c4.com>,
	linux-arm-kernel@lists.infradead.org,
	x86@kernel.org,
	Eric Biggers <ebiggers@kernel.org>,
	stable@vger.kernel.org
Subject: [PATCH 2/5] lib/crypto: arm/poly1305: Fix register corruption in no-SIMD contexts
Date: Sun,  6 Jul 2025 16:10:57 -0700
Message-ID: <20250706231100.176113-3-ebiggers@kernel.org>
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

Restore the SIMD usability check that was removed by commit 773426f4771b
("crypto: arm/poly1305 - Add block-only interface").

This safety check is cheap and is well worth eliminating a footgun.
While the Poly1305 functions *should* be called only where SIMD
registers are usable, if they are anyway, they should just do the right
thing instead of corrupting random tasks' registers and/or computing
incorrect MACs.  Fixing this is also needed for poly1305_kunit to pass.

Just use may_use_simd() instead of the original crypto_simd_usable(),
since poly1305_kunit won't rely on crypto_simd_disabled_for_test.

Fixes: 773426f4771b ("crypto: arm/poly1305 - Add block-only interface")
Cc: stable@vger.kernel.org
Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---
 lib/crypto/arm/poly1305-glue.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/lib/crypto/arm/poly1305-glue.c b/lib/crypto/arm/poly1305-glue.c
index 5b65b840c166..2d86c78af883 100644
--- a/lib/crypto/arm/poly1305-glue.c
+++ b/lib/crypto/arm/poly1305-glue.c
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
@@ -32,11 +33,11 @@ static __ro_after_init DEFINE_STATIC_KEY_FALSE(have_neon);
 void poly1305_blocks_arch(struct poly1305_block_state *state, const u8 *src,
 			  unsigned int len, u32 padbit)
 {
 	len = round_down(len, POLY1305_BLOCK_SIZE);
 	if (IS_ENABLED(CONFIG_KERNEL_MODE_NEON) &&
-	    static_branch_likely(&have_neon)) {
+	    static_branch_likely(&have_neon) && likely(may_use_simd())) {
 		do {
 			unsigned int todo = min_t(unsigned int, len, SZ_4K);
 
 			kernel_neon_begin();
 			poly1305_blocks_neon(state, src, todo, padbit);
-- 
2.50.0

