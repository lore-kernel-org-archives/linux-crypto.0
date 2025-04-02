Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D4BE139D;
	Wed,  2 Apr 2025 00:24:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743553484; cv=none; b=U40fEDCVOcltpDuDTmniu8kGHhWxvZ0AI+l2XXGH8fAX2z0KV2rxQsfMSOrOoB9+2Dx4yuNs1E9YBH/3QD/Za0heXJylp+qA949RtWgxDQgQ1NY8E2RPdCKBRq3S16X3TvjW2zIRaNTTU2P1gOPD0i9umONxufZmIXBUly80WZ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743553484; c=relaxed/simple;
	bh=RHdihWL21X6H3Xr8G5qFSEa6nM+x72C2e1YLrm6YdMo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VEJsjeN2E1YSdAn1eeja38c2Cz2vkoX9TJSnX7LYXoeNtvEAz+PrMlV/wUjxAW3yD2EzTZN7gjwmJ2GfdsRUuMnadYZEbTiBSr3Kb8YfA6eRbEZn3vScS0nAfGQu6Nby4cDgYb56mQjJ/9iYwfvS4jj+UatIUe2pKTWrY0nClpQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=vFbIuSN9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="vFbIuSN9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB4E6C4CEEE;
	Wed,  2 Apr 2025 00:24:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1743553483;
	bh=RHdihWL21X6H3Xr8G5qFSEa6nM+x72C2e1YLrm6YdMo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vFbIuSN98lE+s290fBROb3cw2Hg3B3Ga80y0EMo+9B+jAGQMpJpqprs9E3mPThMgD
	 7SVJ0ku4VyGKJRDcK2Uc23dlG29oKzDSjdUxOPXeyzHcZpnh2vsXhIjcdv+yW/myi8
	 2FBIf80kYV7lZRqzAvuzE86mY2NLGwbpzjTFpqaV9W/C5bV/snv0npK2OxQeQ6KH5e
	 c2YJRuhUyKNyBbP3zEgVen/bxtvaqI7/zUC6RoeqIfcX33TSw27mBfSDIMsrxLGvOZ
	 eKM9k+qd8ni1wCO1ozLjy0rq2O+bEtCwu+whLKpFxtZx7lXT2dsH9IgsRd272z84vC
	 9UnxzY+aOFASA==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	x86@kernel.org
Subject: [PATCH v2 2/9] crypto: x86/aegis - stop using the SIMD helper
Date: Tue,  1 Apr 2025 17:24:02 -0700
Message-ID: <20250402002420.89233-3-ebiggers@kernel.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250402002420.89233-1-ebiggers@kernel.org>
References: <20250402002420.89233-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Eric Biggers <ebiggers@google.com>

Stop wrapping skcipher and aead algorithms with the crypto SIMD helper
(crypto/simd.c).  The only purpose of doing so was to work around x86
not always supporting kernel-mode FPU in softirqs.  Specifically, if a
hardirq interrupted a task context kernel-mode FPU section and then a
softirqs were run at the end of that hardirq, those softirqs could not
use kernel-mode FPU.  This has now been fixed.  In combination with the
fact that the skcipher and aead APIs only support task and softirq
contexts, these can now just use kernel-mode FPU unconditionally on x86.

This simplifies the code and improves performance.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 arch/x86/crypto/Kconfig               |  1 -
 arch/x86/crypto/aegis128-aesni-glue.c | 13 ++++---------
 2 files changed, 4 insertions(+), 10 deletions(-)

diff --git a/arch/x86/crypto/Kconfig b/arch/x86/crypto/Kconfig
index 3d948f10c94cd..c15400efac075 100644
--- a/arch/x86/crypto/Kconfig
+++ b/arch/x86/crypto/Kconfig
@@ -367,11 +367,10 @@ config CRYPTO_CHACHA20_X86_64
 
 config CRYPTO_AEGIS128_AESNI_SSE2
 	tristate "AEAD ciphers: AEGIS-128 (AES-NI/SSE4.1)"
 	depends on X86 && 64BIT
 	select CRYPTO_AEAD
-	select CRYPTO_SIMD
 	help
 	  AEGIS-128 AEAD algorithm
 
 	  Architecture: x86_64 using:
 	  - AES-NI (AES New Instructions)
diff --git a/arch/x86/crypto/aegis128-aesni-glue.c b/arch/x86/crypto/aegis128-aesni-glue.c
index 26786e15abacf..f1b6d40154e35 100644
--- a/arch/x86/crypto/aegis128-aesni-glue.c
+++ b/arch/x86/crypto/aegis128-aesni-glue.c
@@ -6,11 +6,10 @@
  * Copyright (c) 2017-2018 Ondrej Mosnacek <omosnacek@gmail.com>
  * Copyright (C) 2017-2018 Red Hat, Inc. All rights reserved.
  */
 
 #include <crypto/internal/aead.h>
-#include <crypto/internal/simd.h>
 #include <crypto/internal/skcipher.h>
 #include <crypto/scatterwalk.h>
 #include <linux/module.h>
 #include <asm/fpu/api.h>
 #include <asm/cpu_device_id.h>
@@ -231,39 +230,35 @@ static struct aead_alg crypto_aegis128_aesni_alg = {
 	.ivsize = AEGIS128_NONCE_SIZE,
 	.maxauthsize = AEGIS128_MAX_AUTH_SIZE,
 	.chunksize = AEGIS128_BLOCK_SIZE,
 
 	.base = {
-		.cra_flags = CRYPTO_ALG_INTERNAL,
 		.cra_blocksize = 1,
 		.cra_ctxsize = sizeof(struct aegis_ctx) +
 			       __alignof__(struct aegis_ctx),
 		.cra_priority = 400,
 
-		.cra_name = "__aegis128",
-		.cra_driver_name = "__aegis128-aesni",
+		.cra_name = "aegis128",
+		.cra_driver_name = "aegis128-aesni",
 
 		.cra_module = THIS_MODULE,
 	}
 };
 
-static struct simd_aead_alg *simd_alg;
-
 static int __init crypto_aegis128_aesni_module_init(void)
 {
 	if (!boot_cpu_has(X86_FEATURE_XMM4_1) ||
 	    !boot_cpu_has(X86_FEATURE_AES) ||
 	    !cpu_has_xfeatures(XFEATURE_MASK_SSE, NULL))
 		return -ENODEV;
 
-	return simd_register_aeads_compat(&crypto_aegis128_aesni_alg, 1,
-					  &simd_alg);
+	return crypto_register_aead(&crypto_aegis128_aesni_alg);
 }
 
 static void __exit crypto_aegis128_aesni_module_exit(void)
 {
-	simd_unregister_aeads(&crypto_aegis128_aesni_alg, 1, &simd_alg);
+	crypto_unregister_aead(&crypto_aegis128_aesni_alg);
 }
 
 module_init(crypto_aegis128_aesni_module_init);
 module_exit(crypto_aegis128_aesni_module_exit);
 
-- 
2.49.0

