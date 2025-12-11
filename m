Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 956A7246BA7;
	Thu, 11 Dec 2025 01:20:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765416053; cv=none; b=R8nNWuckRw0ngZUliXxVosteQcinTp1Anz6P99rDdgH2dGXnoqlE0422SI02WatqAuvVrlejTT73Qgl+6xo9Fzn/rvP0Nm81IsRjj0rcO/f9HOWFp6tyqyD3ErMzl/wpXcdOSsjfRxMUu4/HX8ZSEortQFUL7gvmGaNPsdvX/PU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765416053; c=relaxed/simple;
	bh=QA13DHhl+4YhpyPWe17T6LrXRA31xdotOdL51bY/g5o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=LcgWpBJHBH+Rr5DB28KbkURnF4fdgXOEtBtaUFKgchu6xJOZ07FN3zxZ1l5VF/za28VLfoT40+g4wPiK/e7x2NDJ1f10y9JlNxw1ekuL3nK8fspHn4m45fGJSoz55f1FjyDkB6ihd++FKO24MfMTOj38CnZOXq1TJ1VN/BunnAo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=btHQRYEi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="btHQRYEi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75CADC4AF0B;
	Thu, 11 Dec 2025 01:20:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1765416052;
	bh=QA13DHhl+4YhpyPWe17T6LrXRA31xdotOdL51bY/g5o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=btHQRYEiURiNQPiKLQUoBWNAu5j2IzeAKxyB3TvE33sA3mEdGrOmgwH/QXKsYaUjf
	 hZZdLwd12m3kEfAG4stbh3rKvuXnu9oDcogWgCe3tJnMm5FWhE7RXKRP0W2Oxe/FRu
	 LiIX6HpdHQT0OxeCC6W5yz5Z0ClQGJcS5hl5097iszy45H46c5J91NBflmzmcBcgcX
	 5hzv2zzRAphY9u+/9uq19JYrS1iVAxna9qa64rivAPJ1bLOCb9xhIfCTy4d+OK58gx
	 jlYFWXP4o9A6Znt7Kw+JG6tFzfHtgrrQOLOeSH2Qbe5Qv251/3QsTN1g1DHANA6FTt
	 9kBhoBMMGJjqg==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	Ard Biesheuvel <ardb@kernel.org>,
	"Jason A . Donenfeld" <Jason@zx2c4.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	linux-arm-kernel@lists.infradead.org,
	x86@kernel.org,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH 03/12] lib/crypto: arm/nh: Migrate optimized code into library
Date: Wed, 10 Dec 2025 17:18:35 -0800
Message-ID: <20251211011846.8179-4-ebiggers@kernel.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251211011846.8179-1-ebiggers@kernel.org>
References: <20251211011846.8179-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Migrate the arm32 NEON implementation of NH into lib/crypto/.  This
makes the nh() function be optimized on arm32 kernels.

Note: this temporarily makes the adiantum template not utilize the arm32
optimized NH code.  This is resolved in a later commit that converts the
adiantum template to use nh() instead of "nhpoly1305".

Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---
 arch/arm/crypto/Kconfig                       | 10 ---
 arch/arm/crypto/Makefile                      |  2 -
 arch/arm/crypto/nhpoly1305-neon-glue.c        | 80 -------------------
 lib/crypto/Kconfig                            |  1 +
 lib/crypto/Makefile                           |  1 +
 .../crypto => lib/crypto/arm}/nh-neon-core.S  |  0
 lib/crypto/arm/nh.h                           | 33 ++++++++
 7 files changed, 35 insertions(+), 92 deletions(-)
 delete mode 100644 arch/arm/crypto/nhpoly1305-neon-glue.c
 rename {arch/arm/crypto => lib/crypto/arm}/nh-neon-core.S (100%)
 create mode 100644 lib/crypto/arm/nh.h

diff --git a/arch/arm/crypto/Kconfig b/arch/arm/crypto/Kconfig
index f30d743df264..3eb5071bea14 100644
--- a/arch/arm/crypto/Kconfig
+++ b/arch/arm/crypto/Kconfig
@@ -21,20 +21,10 @@ config CRYPTO_GHASH_ARM_CE
 	  Use an implementation of GHASH (used by the GCM AEAD chaining mode)
 	  that uses the 64x64 to 128 bit polynomial multiplication (vmull.p64)
 	  that is part of the ARMv8 Crypto Extensions, or a slower variant that
 	  uses the vmull.p8 instruction that is part of the basic NEON ISA.
 
-config CRYPTO_NHPOLY1305_NEON
-	tristate "Hash functions: NHPoly1305 (NEON)"
-	depends on KERNEL_MODE_NEON
-	select CRYPTO_NHPOLY1305
-	help
-	  NHPoly1305 hash function (Adiantum)
-
-	  Architecture: arm using:
-	  - NEON (Advanced SIMD) extensions
-
 config CRYPTO_AES_ARM
 	tristate "Ciphers: AES"
 	select CRYPTO_ALGAPI
 	select CRYPTO_AES
 	help
diff --git a/arch/arm/crypto/Makefile b/arch/arm/crypto/Makefile
index 86dd43313dbf..d6683e9d4992 100644
--- a/arch/arm/crypto/Makefile
+++ b/arch/arm/crypto/Makefile
@@ -3,15 +3,13 @@
 # Arch-specific CryptoAPI modules.
 #
 
 obj-$(CONFIG_CRYPTO_AES_ARM) += aes-arm.o
 obj-$(CONFIG_CRYPTO_AES_ARM_BS) += aes-arm-bs.o
-obj-$(CONFIG_CRYPTO_NHPOLY1305_NEON) += nhpoly1305-neon.o
 
 obj-$(CONFIG_CRYPTO_AES_ARM_CE) += aes-arm-ce.o
 obj-$(CONFIG_CRYPTO_GHASH_ARM_CE) += ghash-arm-ce.o
 
 aes-arm-y	:= aes-cipher-core.o aes-cipher-glue.o
 aes-arm-bs-y	:= aes-neonbs-core.o aes-neonbs-glue.o
 aes-arm-ce-y	:= aes-ce-core.o aes-ce-glue.o
 ghash-arm-ce-y	:= ghash-ce-core.o ghash-ce-glue.o
-nhpoly1305-neon-y := nh-neon-core.o nhpoly1305-neon-glue.o
diff --git a/arch/arm/crypto/nhpoly1305-neon-glue.c b/arch/arm/crypto/nhpoly1305-neon-glue.c
deleted file mode 100644
index 62cf7ccdde73..000000000000
--- a/arch/arm/crypto/nhpoly1305-neon-glue.c
+++ /dev/null
@@ -1,80 +0,0 @@
-// SPDX-License-Identifier: GPL-2.0
-/*
- * NHPoly1305 - ε-almost-∆-universal hash function for Adiantum
- * (NEON accelerated version)
- *
- * Copyright 2018 Google LLC
- */
-
-#include <asm/neon.h>
-#include <asm/simd.h>
-#include <crypto/internal/hash.h>
-#include <crypto/internal/simd.h>
-#include <crypto/nhpoly1305.h>
-#include <linux/module.h>
-
-asmlinkage void nh_neon(const u32 *key, const u8 *message, size_t message_len,
-			__le64 hash[NH_NUM_PASSES]);
-
-static int nhpoly1305_neon_update(struct shash_desc *desc,
-				  const u8 *src, unsigned int srclen)
-{
-	if (srclen < 64 || !crypto_simd_usable())
-		return crypto_nhpoly1305_update(desc, src, srclen);
-
-	do {
-		unsigned int n = min_t(unsigned int, srclen, SZ_4K);
-
-		kernel_neon_begin();
-		crypto_nhpoly1305_update_helper(desc, src, n, nh_neon);
-		kernel_neon_end();
-		src += n;
-		srclen -= n;
-	} while (srclen);
-	return 0;
-}
-
-static int nhpoly1305_neon_digest(struct shash_desc *desc,
-				  const u8 *src, unsigned int srclen, u8 *out)
-{
-	return crypto_nhpoly1305_init(desc) ?:
-	       nhpoly1305_neon_update(desc, src, srclen) ?:
-	       crypto_nhpoly1305_final(desc, out);
-}
-
-static struct shash_alg nhpoly1305_alg = {
-	.base.cra_name		= "nhpoly1305",
-	.base.cra_driver_name	= "nhpoly1305-neon",
-	.base.cra_priority	= 200,
-	.base.cra_ctxsize	= sizeof(struct nhpoly1305_key),
-	.base.cra_module	= THIS_MODULE,
-	.digestsize		= POLY1305_DIGEST_SIZE,
-	.init			= crypto_nhpoly1305_init,
-	.update			= nhpoly1305_neon_update,
-	.final			= crypto_nhpoly1305_final,
-	.digest			= nhpoly1305_neon_digest,
-	.setkey			= crypto_nhpoly1305_setkey,
-	.descsize		= sizeof(struct nhpoly1305_state),
-};
-
-static int __init nhpoly1305_mod_init(void)
-{
-	if (!(elf_hwcap & HWCAP_NEON))
-		return -ENODEV;
-
-	return crypto_register_shash(&nhpoly1305_alg);
-}
-
-static void __exit nhpoly1305_mod_exit(void)
-{
-	crypto_unregister_shash(&nhpoly1305_alg);
-}
-
-module_init(nhpoly1305_mod_init);
-module_exit(nhpoly1305_mod_exit);
-
-MODULE_DESCRIPTION("NHPoly1305 ε-almost-∆-universal hash function (NEON-accelerated)");
-MODULE_LICENSE("GPL v2");
-MODULE_AUTHOR("Eric Biggers <ebiggers@google.com>");
-MODULE_ALIAS_CRYPTO("nhpoly1305");
-MODULE_ALIAS_CRYPTO("nhpoly1305-neon");
diff --git a/lib/crypto/Kconfig b/lib/crypto/Kconfig
index f14c9f5974d8..c6ee7ca77632 100644
--- a/lib/crypto/Kconfig
+++ b/lib/crypto/Kconfig
@@ -115,10 +115,11 @@ config CRYPTO_LIB_NH
 	  the variant of NH used in Adiantum.
 
 config CRYPTO_LIB_NH_ARCH
 	bool
 	depends on CRYPTO_LIB_NH && !UML
+	default y if ARM && KERNEL_MODE_NEON
 
 config CRYPTO_LIB_POLY1305
 	tristate
 	help
 	  The Poly1305 library functions.  Select this if your module uses any
diff --git a/lib/crypto/Makefile b/lib/crypto/Makefile
index 929b84568809..6dae7e182847 100644
--- a/lib/crypto/Makefile
+++ b/lib/crypto/Makefile
@@ -133,10 +133,11 @@ libmldsa-y := mldsa.o
 
 obj-$(CONFIG_CRYPTO_LIB_NH) += libnh.o
 libnh-y := nh.o
 ifeq ($(CONFIG_CRYPTO_LIB_NH_ARCH),y)
 CFLAGS_nh.o += -I$(src)/$(SRCARCH)
+libnh-$(CONFIG_ARM) += arm/nh-neon-core.o
 endif
 
 ################################################################################
 
 obj-$(CONFIG_CRYPTO_LIB_POLY1305) += libpoly1305.o
diff --git a/arch/arm/crypto/nh-neon-core.S b/lib/crypto/arm/nh-neon-core.S
similarity index 100%
rename from arch/arm/crypto/nh-neon-core.S
rename to lib/crypto/arm/nh-neon-core.S
diff --git a/lib/crypto/arm/nh.h b/lib/crypto/arm/nh.h
new file mode 100644
index 000000000000..c9f39d819336
--- /dev/null
+++ b/lib/crypto/arm/nh.h
@@ -0,0 +1,33 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * ARM32 accelerated implementation of NH
+ *
+ * Copyright 2018 Google LLC
+ */
+
+#include <asm/neon.h>
+#include <asm/simd.h>
+
+static __ro_after_init DEFINE_STATIC_KEY_FALSE(have_neon);
+
+asmlinkage void nh_neon(const u32 *key, const u8 *message, size_t message_len,
+			__le64 hash[NH_NUM_PASSES]);
+
+static bool nh_arch(const u32 *key, const u8 *message, size_t message_len,
+		    __le64 hash[NH_NUM_PASSES])
+{
+	if (static_branch_likely(&have_neon) && message_len >= 64 &&
+	    may_use_simd()) {
+		scoped_ksimd()
+			nh_neon(key, message, message_len, hash);
+		return true;
+	}
+	return false;
+}
+
+#define nh_mod_init_arch nh_mod_init_arch
+static void nh_mod_init_arch(void)
+{
+	if (elf_hwcap & HWCAP_NEON)
+		static_branch_enable(&have_neon);
+}
-- 
2.52.0

