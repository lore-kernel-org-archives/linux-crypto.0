Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3B111D540;
	Wed,  2 Apr 2025 00:24:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743553485; cv=none; b=GcZkH2dvebO+gfO+6OokxEaL/3ypbkUuH/3bDU5laakf+VLR4QqLRFlcYjNj6yWwQ8EXZyoBIXSYt3PigJI6JXRt27qvb9h/eEJI3WKFhwsaTBPPs8TCl5MCuxV4S3XYXjSKSzzm/kf2krdiVVr6bD/byv3YjmEm2VkyAhhbP/U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743553485; c=relaxed/simple;
	bh=jxfrg4Acxbf7rgK+nlySQZwUCd6hpAuZTygmvCK15tA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uTQ/toQGeV+Mk2eYxTx5NKZizrZfXBYkjs2FY+my97rOCQ1nlb4qyjsVU1FHHYm6MxoYsy6/LVoRjoMevcyuJcqJWFuM4++hsh0eyy/dz3HZQEJC4lTrSFpFieEnXdrKZOA2+NBW3b3gBsY/n7L3iCYrqlIht5L7FR90DjaxbHk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=g7SL84ac; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="g7SL84ac"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D636C4CEED;
	Wed,  2 Apr 2025 00:24:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1743553485;
	bh=jxfrg4Acxbf7rgK+nlySQZwUCd6hpAuZTygmvCK15tA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=g7SL84acA54mErkpBWG+FvmQ5ctbbW9IGPxG8X6xhCcZ1To0OFmnPtS6uB1722UPW
	 g+85uyqvxL7OTPIHe99yDO07QOO3l7EckyDg9xGdNi3ZCSbTQ8g/gJP2v/jq38r5Ub
	 JaZ0r72e37CIeF+cherf9J7khABeVqq0QUHLCSlF04KJDC1nuMFCcDWhzFYKfC3anb
	 9G5ugrKlbn4jQEaSTnHkoNQ2zHc7JqnkunT4TFrzpaJtC/rr09bikpMiMPYSsHz4l2
	 Vgtqt6XrMWRkBnTV+tFX5JdkqZnQVZRaTIqUXySnixKoYRIZam5R1YNqcHWvspLX1z
	 meVtWIglTXf8A==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	x86@kernel.org
Subject: [PATCH v2 9/9] crypto: x86/twofish - stop using the SIMD helper
Date: Tue,  1 Apr 2025 17:24:09 -0700
Message-ID: <20250402002420.89233-10-ebiggers@kernel.org>
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
 arch/x86/crypto/Kconfig            |  1 -
 arch/x86/crypto/twofish_avx_glue.c | 21 +++++++--------------
 2 files changed, 7 insertions(+), 15 deletions(-)

diff --git a/arch/x86/crypto/Kconfig b/arch/x86/crypto/Kconfig
index afc1a05e663dd..f9e46e83440f1 100644
--- a/arch/x86/crypto/Kconfig
+++ b/arch/x86/crypto/Kconfig
@@ -268,11 +268,10 @@ config CRYPTO_TWOFISH_X86_64_3WAY
 
 config CRYPTO_TWOFISH_AVX_X86_64
 	tristate "Ciphers: Twofish with modes: ECB, CBC (AVX)"
 	depends on X86 && 64BIT
 	select CRYPTO_SKCIPHER
-	select CRYPTO_SIMD
 	select CRYPTO_TWOFISH_COMMON
 	select CRYPTO_TWOFISH_X86_64
 	select CRYPTO_TWOFISH_X86_64_3WAY
 	imply CRYPTO_XTS
 	help
diff --git a/arch/x86/crypto/twofish_avx_glue.c b/arch/x86/crypto/twofish_avx_glue.c
index 3eb3440b477a8..9e20db0137501 100644
--- a/arch/x86/crypto/twofish_avx_glue.c
+++ b/arch/x86/crypto/twofish_avx_glue.c
@@ -11,11 +11,10 @@
 #include <linux/module.h>
 #include <linux/types.h>
 #include <linux/crypto.h>
 #include <linux/err.h>
 #include <crypto/algapi.h>
-#include <crypto/internal/simd.h>
 #include <crypto/twofish.h>
 
 #include "twofish.h"
 #include "ecb_cbc_helpers.h"
 
@@ -72,27 +71,25 @@ static int cbc_decrypt(struct skcipher_request *req)
 	CBC_WALK_END();
 }
 
 static struct skcipher_alg twofish_algs[] = {
 	{
-		.base.cra_name		= "__ecb(twofish)",
-		.base.cra_driver_name	= "__ecb-twofish-avx",
+		.base.cra_name		= "ecb(twofish)",
+		.base.cra_driver_name	= "ecb-twofish-avx",
 		.base.cra_priority	= 400,
-		.base.cra_flags		= CRYPTO_ALG_INTERNAL,
 		.base.cra_blocksize	= TF_BLOCK_SIZE,
 		.base.cra_ctxsize	= sizeof(struct twofish_ctx),
 		.base.cra_module	= THIS_MODULE,
 		.min_keysize		= TF_MIN_KEY_SIZE,
 		.max_keysize		= TF_MAX_KEY_SIZE,
 		.setkey			= twofish_setkey_skcipher,
 		.encrypt		= ecb_encrypt,
 		.decrypt		= ecb_decrypt,
 	}, {
-		.base.cra_name		= "__cbc(twofish)",
-		.base.cra_driver_name	= "__cbc-twofish-avx",
+		.base.cra_name		= "cbc(twofish)",
+		.base.cra_driver_name	= "cbc-twofish-avx",
 		.base.cra_priority	= 400,
-		.base.cra_flags		= CRYPTO_ALG_INTERNAL,
 		.base.cra_blocksize	= TF_BLOCK_SIZE,
 		.base.cra_ctxsize	= sizeof(struct twofish_ctx),
 		.base.cra_module	= THIS_MODULE,
 		.min_keysize		= TF_MIN_KEY_SIZE,
 		.max_keysize		= TF_MAX_KEY_SIZE,
@@ -101,30 +98,26 @@ static struct skcipher_alg twofish_algs[] = {
 		.encrypt		= cbc_encrypt,
 		.decrypt		= cbc_decrypt,
 	},
 };
 
-static struct simd_skcipher_alg *twofish_simd_algs[ARRAY_SIZE(twofish_algs)];
-
 static int __init twofish_init(void)
 {
 	const char *feature_name;
 
 	if (!cpu_has_xfeatures(XFEATURE_MASK_SSE | XFEATURE_MASK_YMM, &feature_name)) {
 		pr_info("CPU feature '%s' is not supported.\n", feature_name);
 		return -ENODEV;
 	}
 
-	return simd_register_skciphers_compat(twofish_algs,
-					      ARRAY_SIZE(twofish_algs),
-					      twofish_simd_algs);
+	return crypto_register_skciphers(twofish_algs,
+					 ARRAY_SIZE(twofish_algs));
 }
 
 static void __exit twofish_exit(void)
 {
-	simd_unregister_skciphers(twofish_algs, ARRAY_SIZE(twofish_algs),
-				  twofish_simd_algs);
+	crypto_unregister_skciphers(twofish_algs, ARRAY_SIZE(twofish_algs));
 }
 
 module_init(twofish_init);
 module_exit(twofish_exit);
 
-- 
2.49.0

