Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09AD926B96E
	for <linux-crypto@vger.kernel.org>; Tue, 29 Apr 2025 05:50:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745905844; cv=none; b=GaKSERefPS+tQJw9DHE+eJKneJxjBn0x5graOMyaC8iEJqDP14VekLR3dsMCIaAAOVb7p3i7pgUQFQOex2iBM/kF8GivJrTxmyoK5dquLs+sFZzAqjFuyBov4bAUVzgWmo53IwrX2vlPENuQgvUt+yUulZ8l/wK4yR3rXgUZeV4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745905844; c=relaxed/simple;
	bh=/J4jrdowLfHU8GHMFl3QjYWYQaDEtE/aTqPm47FxmWM=;
	h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=UHyYiAwgnOEd61VBAUobvhzOLYPT56MmPad+tnluC36VYv06VQ5S4nu5bvp2E2QndUQ/GRqGJiG6xDMga42bbuHSWo9YlXvnP7Udyzdhn9qj6fQSeu5Jhka3/nvKITUR1h46m5GhpN5MsDYC0uYeJ1BjvIz29XIfSuncqLhWI7c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=JTI5zInG; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="JTI5zInG"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=Content-Transfer-Encoding:Content-Type:MIME-Version:Message-ID:
	Subject:To:From:Date:Sender:Reply-To:Cc:Content-ID:Content-Description:
	Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
	In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=vMEItlAjA9JkzniJpTGL8MZRCPDKsztduuZIt7h0WAk=; b=JTI5zInGyhaMnrXLGrPhS1HZwO
	gVbksyMP5jFLB5YiI579vAZ2IJjCWEiZK6pr4GUv0NuUouJch7VjHI6ByKZOEBCRnCeAJe9HrQU35
	heDIVbXBdZmYjjP/9Xannkwc1p6yyHMOFT8bucxD8mL1Tfxw2eqRFblzoTbsDIJjdtr9lY16yAVGT
	cXQxtghOovnQLVSlzdx3BvmESa+p5RWkgG2niXoLb7IPa7ec/0f3L5lr8867TIDbiAqQJQBHHOByt
	a/SeWCpnkOc8pde6vNEliIylO0+Y6x9uYSVMrxxOLfnMzoAk1D2nfmTMC9K3upSVurkgj9M4lonjv
	PYImjfjQ==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1u9drW-001qbk-2P;
	Tue, 29 Apr 2025 13:50:35 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Tue, 29 Apr 2025 13:50:34 +0800
Date: Tue, 29 Apr 2025 13:50:34 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Subject: [PATCH 1/1] Revert "crypto: run initcalls for generic
 implementations earlier"
Message-ID: <aBBoqm4u6ufapUXK@gondor.apana.org.au>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

This reverts commit c4741b23059794bd99beef0f700103b0d983b3fd.

Crypto API self-tests no longer run at registration time and now
occur either at late_initcall or upon the first use.

Therefore the premise of the above commit no longer exists.  Revert
it and subsequent additions of subsys_initcall and arch_initcall.

Note that some lib/crypto calls to subsys_initcall have been kept
(or rather downgraded from arch_initcall) because they need to
occur before Crypto API registration.

The subsys_initcall in blake2s appears to be gratuitous as it
occurred as a response to the removal of linux/module.h.  Make
it a device_initcall instead.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---
 arch/arm/crypto/aes-neonbs-glue.c           |  2 +-
 arch/arm/lib/crypto/chacha-glue.c           |  2 +-
 arch/arm/lib/crypto/poly1305-glue.c         |  2 +-
 arch/arm/lib/crypto/sha256.c                |  2 +-
 arch/arm64/lib/crypto/chacha-neon-glue.c    |  2 +-
 arch/arm64/lib/crypto/poly1305-glue.c       |  2 +-
 arch/arm64/lib/crypto/sha256.c              |  2 +-
 arch/powerpc/lib/crypto/chacha-p10-glue.c   |  2 +-
 arch/powerpc/lib/crypto/poly1305-p10-glue.c |  2 +-
 arch/riscv/lib/crypto/chacha-riscv64-glue.c |  2 +-
 arch/riscv/lib/crypto/sha256.c              |  2 +-
 arch/s390/lib/crypto/sha256.c               |  2 +-
 arch/sparc/lib/crypto/sha256.c              |  2 +-
 arch/x86/lib/crypto/blake2s-glue.c          | 14 ++++++--------
 arch/x86/lib/crypto/chacha_glue.c           |  2 +-
 arch/x86/lib/crypto/poly1305_glue.c         |  2 +-
 arch/x86/lib/crypto/sha256.c                |  2 +-
 crypto/842.c                                |  2 +-
 crypto/adiantum.c                           |  2 +-
 crypto/aegis128-core.c                      |  2 +-
 crypto/aes_generic.c                        |  2 +-
 crypto/algboss.c                            |  8 +-------
 crypto/ansi_cprng.c                         |  2 +-
 crypto/anubis.c                             |  2 +-
 crypto/arc4.c                               |  2 +-
 crypto/aria_generic.c                       |  2 +-
 crypto/authenc.c                            |  2 +-
 crypto/authencesn.c                         |  2 +-
 crypto/blake2b_generic.c                    |  2 +-
 crypto/blowfish_generic.c                   |  2 +-
 crypto/camellia_generic.c                   |  2 +-
 crypto/cast5_generic.c                      |  2 +-
 crypto/cast6_generic.c                      |  2 +-
 crypto/cbc.c                                |  2 +-
 crypto/ccm.c                                |  2 +-
 crypto/chacha.c                             |  2 +-
 crypto/chacha20poly1305.c                   |  2 +-
 crypto/cmac.c                               |  2 +-
 crypto/crc32_generic.c                      |  2 +-
 crypto/crc32c_generic.c                     |  2 +-
 crypto/cryptd.c                             |  2 +-
 crypto/crypto_null.c                        |  2 +-
 crypto/ctr.c                                |  2 +-
 crypto/cts.c                                |  2 +-
 crypto/curve25519-generic.c                 |  2 +-
 crypto/deflate.c                            |  2 +-
 crypto/des_generic.c                        |  2 +-
 crypto/dh.c                                 |  2 +-
 crypto/drbg.c                               |  2 +-
 crypto/ecb.c                                |  2 +-
 crypto/ecdh.c                               |  2 +-
 crypto/ecdsa.c                              |  2 +-
 crypto/echainiv.c                           |  2 +-
 crypto/essiv.c                              |  2 +-
 crypto/fcrypt.c                             |  2 +-
 crypto/fips.c                               |  2 +-
 crypto/gcm.c                                |  2 +-
 crypto/ghash-generic.c                      |  2 +-
 crypto/hctr2.c                              |  2 +-
 crypto/hmac.c                               |  2 +-
 crypto/khazad.c                             |  2 +-
 crypto/krb5enc.c                            |  2 +-
 crypto/lrw.c                                |  2 +-
 crypto/lz4.c                                |  2 +-
 crypto/lz4hc.c                              |  2 +-
 crypto/lzo-rle.c                            |  2 +-
 crypto/lzo.c                                |  2 +-
 crypto/md4.c                                |  2 +-
 crypto/md5.c                                |  2 +-
 crypto/michael_mic.c                        |  2 +-
 crypto/nhpoly1305.c                         |  2 +-
 crypto/pcbc.c                               |  2 +-
 crypto/pcrypt.c                             |  2 +-
 crypto/polyval-generic.c                    |  2 +-
 crypto/rmd160.c                             |  2 +-
 crypto/rsa.c                                |  2 +-
 crypto/seed.c                               |  2 +-
 crypto/seqiv.c                              |  2 +-
 crypto/serpent_generic.c                    |  2 +-
 crypto/sha1_generic.c                       |  2 +-
 crypto/sha256.c                             |  2 +-
 crypto/sha512_generic.c                     |  2 +-
 crypto/sm3_generic.c                        |  2 +-
 crypto/sm4_generic.c                        |  2 +-
 crypto/streebog_generic.c                   |  2 +-
 crypto/tea.c                                |  2 +-
 crypto/twofish_generic.c                    |  2 +-
 crypto/wp512.c                              |  2 +-
 crypto/xcbc.c                               |  2 +-
 crypto/xctr.c                               |  2 +-
 crypto/xts.c                                |  2 +-
 crypto/xxhash_generic.c                     |  2 +-
 crypto/zstd.c                               |  2 +-
 93 files changed, 98 insertions(+), 106 deletions(-)

diff --git a/arch/arm/crypto/aes-neonbs-glue.c b/arch/arm/crypto/aes-neonbs-glue.c
index 95418df97fb4..c60104dc1585 100644
--- a/arch/arm/crypto/aes-neonbs-glue.c
+++ b/arch/arm/crypto/aes-neonbs-glue.c
@@ -407,5 +407,5 @@ static int __init aes_init(void)
 	return crypto_register_skciphers(aes_algs, ARRAY_SIZE(aes_algs));
 }
 
-late_initcall(aes_init);
+module_init(aes_init);
 module_exit(aes_exit);
diff --git a/arch/arm/lib/crypto/chacha-glue.c b/arch/arm/lib/crypto/chacha-glue.c
index 12afb40cf1ff..eb73ff0eaf2e 100644
--- a/arch/arm/lib/crypto/chacha-glue.c
+++ b/arch/arm/lib/crypto/chacha-glue.c
@@ -122,7 +122,7 @@ static int __init chacha_arm_mod_init(void)
 	}
 	return 0;
 }
-arch_initcall(chacha_arm_mod_init);
+module_init(chacha_arm_mod_init);
 
 static void __exit chacha_arm_mod_exit(void)
 {
diff --git a/arch/arm/lib/crypto/poly1305-glue.c b/arch/arm/lib/crypto/poly1305-glue.c
index 91da42b26d9c..8259dcb85d97 100644
--- a/arch/arm/lib/crypto/poly1305-glue.c
+++ b/arch/arm/lib/crypto/poly1305-glue.c
@@ -69,7 +69,7 @@ static int __init arm_poly1305_mod_init(void)
 		static_branch_enable(&have_neon);
 	return 0;
 }
-arch_initcall(arm_poly1305_mod_init);
+module_init(arm_poly1305_mod_init);
 
 static void __exit arm_poly1305_mod_exit(void)
 {
diff --git a/arch/arm/lib/crypto/sha256.c b/arch/arm/lib/crypto/sha256.c
index 1dd71b8fd611..8bc89e58242a 100644
--- a/arch/arm/lib/crypto/sha256.c
+++ b/arch/arm/lib/crypto/sha256.c
@@ -53,7 +53,7 @@ static int __init sha256_arm_mod_init(void)
 	}
 	return 0;
 }
-arch_initcall(sha256_arm_mod_init);
+module_init(sha256_arm_mod_init);
 
 static void __exit sha256_arm_mod_exit(void)
 {
diff --git a/arch/arm64/lib/crypto/chacha-neon-glue.c b/arch/arm64/lib/crypto/chacha-neon-glue.c
index 14a2836eff61..2b0de97a6daf 100644
--- a/arch/arm64/lib/crypto/chacha-neon-glue.c
+++ b/arch/arm64/lib/crypto/chacha-neon-glue.c
@@ -104,7 +104,7 @@ static int __init chacha_simd_mod_init(void)
 		static_branch_enable(&have_neon);
 	return 0;
 }
-arch_initcall(chacha_simd_mod_init);
+subsys_initcall(chacha_simd_mod_init);
 
 static void __exit chacha_simd_mod_exit(void)
 {
diff --git a/arch/arm64/lib/crypto/poly1305-glue.c b/arch/arm64/lib/crypto/poly1305-glue.c
index 681c26557336..42cc29f5c507 100644
--- a/arch/arm64/lib/crypto/poly1305-glue.c
+++ b/arch/arm64/lib/crypto/poly1305-glue.c
@@ -62,7 +62,7 @@ static int __init neon_poly1305_mod_init(void)
 		static_branch_enable(&have_neon);
 	return 0;
 }
-arch_initcall(neon_poly1305_mod_init);
+module_init(neon_poly1305_mod_init);
 
 static void __exit neon_poly1305_mod_exit(void)
 {
diff --git a/arch/arm64/lib/crypto/sha256.c b/arch/arm64/lib/crypto/sha256.c
index fdceb2d0899c..8455524e3573 100644
--- a/arch/arm64/lib/crypto/sha256.c
+++ b/arch/arm64/lib/crypto/sha256.c
@@ -64,7 +64,7 @@ static int __init sha256_arm64_mod_init(void)
 	}
 	return 0;
 }
-arch_initcall(sha256_arm64_mod_init);
+module_init(sha256_arm64_mod_init);
 
 static void __exit sha256_arm64_mod_exit(void)
 {
diff --git a/arch/powerpc/lib/crypto/chacha-p10-glue.c b/arch/powerpc/lib/crypto/chacha-p10-glue.c
index 351ed409f9b2..51daeaf5d26e 100644
--- a/arch/powerpc/lib/crypto/chacha-p10-glue.c
+++ b/arch/powerpc/lib/crypto/chacha-p10-glue.c
@@ -87,7 +87,7 @@ static int __init chacha_p10_init(void)
 		static_branch_enable(&have_p10);
 	return 0;
 }
-arch_initcall(chacha_p10_init);
+subsys_initcall(chacha_p10_init);
 
 static void __exit chacha_p10_exit(void)
 {
diff --git a/arch/powerpc/lib/crypto/poly1305-p10-glue.c b/arch/powerpc/lib/crypto/poly1305-p10-glue.c
index 50ac802220e0..7dee128be81f 100644
--- a/arch/powerpc/lib/crypto/poly1305-p10-glue.c
+++ b/arch/powerpc/lib/crypto/poly1305-p10-glue.c
@@ -76,7 +76,7 @@ static int __init poly1305_p10_init(void)
 		static_branch_enable(&have_p10);
 	return 0;
 }
-arch_initcall(poly1305_p10_init);
+module_init(poly1305_p10_init);
 
 static void __exit poly1305_p10_exit(void)
 {
diff --git a/arch/riscv/lib/crypto/chacha-riscv64-glue.c b/arch/riscv/lib/crypto/chacha-riscv64-glue.c
index afc4e3be3cac..1740e1ca3a94 100644
--- a/arch/riscv/lib/crypto/chacha-riscv64-glue.c
+++ b/arch/riscv/lib/crypto/chacha-riscv64-glue.c
@@ -62,7 +62,7 @@ static int __init riscv64_chacha_mod_init(void)
 		static_branch_enable(&use_zvkb);
 	return 0;
 }
-arch_initcall(riscv64_chacha_mod_init);
+subsys_initcall(riscv64_chacha_mod_init);
 
 static void __exit riscv64_chacha_mod_exit(void)
 {
diff --git a/arch/riscv/lib/crypto/sha256.c b/arch/riscv/lib/crypto/sha256.c
index c1358eafc2ad..71808397dff4 100644
--- a/arch/riscv/lib/crypto/sha256.c
+++ b/arch/riscv/lib/crypto/sha256.c
@@ -55,7 +55,7 @@ static int __init riscv64_sha256_mod_init(void)
 		static_branch_enable(&have_extensions);
 	return 0;
 }
-arch_initcall(riscv64_sha256_mod_init);
+subsys_initcall(riscv64_sha256_mod_init);
 
 static void __exit riscv64_sha256_mod_exit(void)
 {
diff --git a/arch/s390/lib/crypto/sha256.c b/arch/s390/lib/crypto/sha256.c
index fcfa2706a7f9..7dfe120fafab 100644
--- a/arch/s390/lib/crypto/sha256.c
+++ b/arch/s390/lib/crypto/sha256.c
@@ -36,7 +36,7 @@ static int __init sha256_s390_mod_init(void)
 		static_branch_enable(&have_cpacf_sha256);
 	return 0;
 }
-arch_initcall(sha256_s390_mod_init);
+subsys_initcall(sha256_s390_mod_init);
 
 static void __exit sha256_s390_mod_exit(void)
 {
diff --git a/arch/sparc/lib/crypto/sha256.c b/arch/sparc/lib/crypto/sha256.c
index b4fc475dcc40..8bdec2db08b3 100644
--- a/arch/sparc/lib/crypto/sha256.c
+++ b/arch/sparc/lib/crypto/sha256.c
@@ -53,7 +53,7 @@ static int __init sha256_sparc64_mod_init(void)
 	pr_info("Using sparc64 sha256 opcode optimized SHA-256/SHA-224 implementation\n");
 	return 0;
 }
-arch_initcall(sha256_sparc64_mod_init);
+subsys_initcall(sha256_sparc64_mod_init);
 
 static void __exit sha256_sparc64_mod_exit(void)
 {
diff --git a/arch/x86/lib/crypto/blake2s-glue.c b/arch/x86/lib/crypto/blake2s-glue.c
index 00f84f29cc8c..e0a46bfa53e4 100644
--- a/arch/x86/lib/crypto/blake2s-glue.c
+++ b/arch/x86/lib/crypto/blake2s-glue.c
@@ -3,17 +3,15 @@
  * Copyright (C) 2015-2019 Jason A. Donenfeld <Jason@zx2c4.com>. All Rights Reserved.
  */
 
-#include <crypto/internal/blake2s.h>
-
-#include <linux/types.h>
-#include <linux/jump_label.h>
-#include <linux/kernel.h>
-#include <linux/sizes.h>
-
 #include <asm/cpufeature.h>
 #include <asm/fpu/api.h>
 #include <asm/processor.h>
 #include <asm/simd.h>
+#include <crypto/internal/blake2s.h>
+#include <linux/init.h>
+#include <linux/jump_label.h>
+#include <linux/kernel.h>
+#include <linux/sizes.h>
 
 asmlinkage void blake2s_compress_ssse3(struct blake2s_state *state,
 				       const u8 *block, const size_t nblocks,
@@ -69,4 +67,4 @@ static int __init blake2s_mod_init(void)
 	return 0;
 }
 
-subsys_initcall(blake2s_mod_init);
+device_initcall(blake2s_mod_init);
diff --git a/arch/x86/lib/crypto/chacha_glue.c b/arch/x86/lib/crypto/chacha_glue.c
index 59bf63c00072..94fcefbc8827 100644
--- a/arch/x86/lib/crypto/chacha_glue.c
+++ b/arch/x86/lib/crypto/chacha_glue.c
@@ -174,7 +174,7 @@ static int __init chacha_simd_mod_init(void)
 	}
 	return 0;
 }
-arch_initcall(chacha_simd_mod_init);
+subsys_initcall(chacha_simd_mod_init);
 
 static void __exit chacha_simd_mod_exit(void)
 {
diff --git a/arch/x86/lib/crypto/poly1305_glue.c b/arch/x86/lib/crypto/poly1305_glue.c
index f799828c5809..71626e75dafc 100644
--- a/arch/x86/lib/crypto/poly1305_glue.c
+++ b/arch/x86/lib/crypto/poly1305_glue.c
@@ -117,7 +117,7 @@ static int __init poly1305_simd_mod_init(void)
 		static_branch_enable(&poly1305_use_avx512);
 	return 0;
 }
-arch_initcall(poly1305_simd_mod_init);
+module_init(poly1305_simd_mod_init);
 
 static void __exit poly1305_simd_mod_exit(void)
 {
diff --git a/arch/x86/lib/crypto/sha256.c b/arch/x86/lib/crypto/sha256.c
index cdd88497eedf..80380f8fdcee 100644
--- a/arch/x86/lib/crypto/sha256.c
+++ b/arch/x86/lib/crypto/sha256.c
@@ -69,7 +69,7 @@ static int __init sha256_x86_mod_init(void)
 	static_branch_enable(&have_sha256_x86);
 	return 0;
 }
-arch_initcall(sha256_x86_mod_init);
+subsys_initcall(sha256_x86_mod_init);
 
 static void __exit sha256_x86_mod_exit(void)
 {
diff --git a/crypto/842.c b/crypto/842.c
index 881945d44328..8c257c40e2b9 100644
--- a/crypto/842.c
+++ b/crypto/842.c
@@ -70,7 +70,7 @@ static int __init crypto842_mod_init(void)
 {
 	return crypto_register_scomp(&scomp);
 }
-subsys_initcall(crypto842_mod_init);
+module_init(crypto842_mod_init);
 
 static void __exit crypto842_mod_exit(void)
 {
diff --git a/crypto/adiantum.c b/crypto/adiantum.c
index c3ef583598b4..a6bca877c3c7 100644
--- a/crypto/adiantum.c
+++ b/crypto/adiantum.c
@@ -639,7 +639,7 @@ static void __exit adiantum_module_exit(void)
 	crypto_unregister_template(&adiantum_tmpl);
 }
 
-subsys_initcall(adiantum_module_init);
+module_init(adiantum_module_init);
 module_exit(adiantum_module_exit);
 
 MODULE_DESCRIPTION("Adiantum length-preserving encryption mode");
diff --git a/crypto/aegis128-core.c b/crypto/aegis128-core.c
index 72f6ee1345ef..ca80d861345d 100644
--- a/crypto/aegis128-core.c
+++ b/crypto/aegis128-core.c
@@ -566,7 +566,7 @@ static void __exit crypto_aegis128_module_exit(void)
 	crypto_unregister_aead(&crypto_aegis128_alg_generic);
 }
 
-subsys_initcall(crypto_aegis128_module_init);
+module_init(crypto_aegis128_module_init);
 module_exit(crypto_aegis128_module_exit);
 
 MODULE_LICENSE("GPL");
diff --git a/crypto/aes_generic.c b/crypto/aes_generic.c
index 3c66d425c97b..85d2e78c8ef2 100644
--- a/crypto/aes_generic.c
+++ b/crypto/aes_generic.c
@@ -1311,7 +1311,7 @@ static void __exit aes_fini(void)
 	crypto_unregister_alg(&aes_alg);
 }
 
-subsys_initcall(aes_init);
+module_init(aes_init);
 module_exit(aes_fini);
 
 MODULE_DESCRIPTION("Rijndael (AES) Cipher Algorithm");
diff --git a/crypto/algboss.c b/crypto/algboss.c
index a20926bfd34e..ef5c73780fc7 100644
--- a/crypto/algboss.c
+++ b/crypto/algboss.c
@@ -247,13 +247,7 @@ static void __exit cryptomgr_exit(void)
 	BUG_ON(err);
 }
 
-/*
- * This is arch_initcall() so that the crypto self-tests are run on algorithms
- * registered early by subsys_initcall().  subsys_initcall() is needed for
- * generic implementations so that they're available for comparison tests when
- * other implementations are registered later by module_init().
- */
-arch_initcall(cryptomgr_init);
+module_init(cryptomgr_init);
 module_exit(cryptomgr_exit);
 
 MODULE_LICENSE("GPL");
diff --git a/crypto/ansi_cprng.c b/crypto/ansi_cprng.c
index 64f57c4c4b06..153523ce6076 100644
--- a/crypto/ansi_cprng.c
+++ b/crypto/ansi_cprng.c
@@ -467,7 +467,7 @@ MODULE_DESCRIPTION("Software Pseudo Random Number Generator");
 MODULE_AUTHOR("Neil Horman <nhorman@tuxdriver.com>");
 module_param(dbg, int, 0);
 MODULE_PARM_DESC(dbg, "Boolean to enable debugging (0/1 == off/on)");
-subsys_initcall(prng_mod_init);
+module_init(prng_mod_init);
 module_exit(prng_mod_fini);
 MODULE_ALIAS_CRYPTO("stdrng");
 MODULE_ALIAS_CRYPTO("ansi_cprng");
diff --git a/crypto/anubis.c b/crypto/anubis.c
index 886e7c913688..4268c3833baa 100644
--- a/crypto/anubis.c
+++ b/crypto/anubis.c
@@ -694,7 +694,7 @@ static void __exit anubis_mod_fini(void)
 	crypto_unregister_alg(&anubis_alg);
 }
 
-subsys_initcall(anubis_mod_init);
+module_init(anubis_mod_init);
 module_exit(anubis_mod_fini);
 
 MODULE_LICENSE("GPL");
diff --git a/crypto/arc4.c b/crypto/arc4.c
index 1a4825c97c5a..1608018111d0 100644
--- a/crypto/arc4.c
+++ b/crypto/arc4.c
@@ -73,7 +73,7 @@ static void __exit arc4_exit(void)
 	crypto_unregister_lskcipher(&arc4_alg);
 }
 
-subsys_initcall(arc4_init);
+module_init(arc4_init);
 module_exit(arc4_exit);
 
 MODULE_LICENSE("GPL");
diff --git a/crypto/aria_generic.c b/crypto/aria_generic.c
index bd359d3313c2..faa7900383f6 100644
--- a/crypto/aria_generic.c
+++ b/crypto/aria_generic.c
@@ -304,7 +304,7 @@ static void __exit aria_fini(void)
 	crypto_unregister_alg(&aria_alg);
 }
 
-subsys_initcall(aria_init);
+module_init(aria_init);
 module_exit(aria_fini);
 
 MODULE_DESCRIPTION("ARIA Cipher Algorithm");
diff --git a/crypto/authenc.c b/crypto/authenc.c
index 3aaf3ab4e360..9521ae2f112e 100644
--- a/crypto/authenc.c
+++ b/crypto/authenc.c
@@ -451,7 +451,7 @@ static void __exit crypto_authenc_module_exit(void)
 	crypto_unregister_template(&crypto_authenc_tmpl);
 }
 
-subsys_initcall(crypto_authenc_module_init);
+module_init(crypto_authenc_module_init);
 module_exit(crypto_authenc_module_exit);
 
 MODULE_LICENSE("GPL");
diff --git a/crypto/authencesn.c b/crypto/authencesn.c
index 2cc933e2f790..b1c78313cbc1 100644
--- a/crypto/authencesn.c
+++ b/crypto/authencesn.c
@@ -465,7 +465,7 @@ static void __exit crypto_authenc_esn_module_exit(void)
 	crypto_unregister_template(&crypto_authenc_esn_tmpl);
 }
 
-subsys_initcall(crypto_authenc_esn_module_init);
+module_init(crypto_authenc_esn_module_init);
 module_exit(crypto_authenc_esn_module_exit);
 
 MODULE_LICENSE("GPL");
diff --git a/crypto/blake2b_generic.c b/crypto/blake2b_generic.c
index 6fa38965a493..60f056217510 100644
--- a/crypto/blake2b_generic.c
+++ b/crypto/blake2b_generic.c
@@ -176,7 +176,7 @@ static void __exit blake2b_mod_fini(void)
 	crypto_unregister_shashes(blake2b_algs, ARRAY_SIZE(blake2b_algs));
 }
 
-subsys_initcall(blake2b_mod_init);
+module_init(blake2b_mod_init);
 module_exit(blake2b_mod_fini);
 
 MODULE_AUTHOR("David Sterba <kdave@kernel.org>");
diff --git a/crypto/blowfish_generic.c b/crypto/blowfish_generic.c
index 0146bc762c09..f3c5f9b09850 100644
--- a/crypto/blowfish_generic.c
+++ b/crypto/blowfish_generic.c
@@ -124,7 +124,7 @@ static void __exit blowfish_mod_fini(void)
 	crypto_unregister_alg(&alg);
 }
 
-subsys_initcall(blowfish_mod_init);
+module_init(blowfish_mod_init);
 module_exit(blowfish_mod_fini);
 
 MODULE_LICENSE("GPL");
diff --git a/crypto/camellia_generic.c b/crypto/camellia_generic.c
index 197fcf3abc89..ee4336a04b93 100644
--- a/crypto/camellia_generic.c
+++ b/crypto/camellia_generic.c
@@ -1064,7 +1064,7 @@ static void __exit camellia_fini(void)
 	crypto_unregister_alg(&camellia_alg);
 }
 
-subsys_initcall(camellia_init);
+module_init(camellia_init);
 module_exit(camellia_fini);
 
 MODULE_DESCRIPTION("Camellia Cipher Algorithm");
diff --git a/crypto/cast5_generic.c b/crypto/cast5_generic.c
index f3e57775fa02..f68330793e0c 100644
--- a/crypto/cast5_generic.c
+++ b/crypto/cast5_generic.c
@@ -531,7 +531,7 @@ static void __exit cast5_mod_fini(void)
 	crypto_unregister_alg(&alg);
 }
 
-subsys_initcall(cast5_mod_init);
+module_init(cast5_mod_init);
 module_exit(cast5_mod_fini);
 
 MODULE_LICENSE("GPL");
diff --git a/crypto/cast6_generic.c b/crypto/cast6_generic.c
index 11b725b12f27..4c08c42646f0 100644
--- a/crypto/cast6_generic.c
+++ b/crypto/cast6_generic.c
@@ -271,7 +271,7 @@ static void __exit cast6_mod_fini(void)
 	crypto_unregister_alg(&alg);
 }
 
-subsys_initcall(cast6_mod_init);
+module_init(cast6_mod_init);
 module_exit(cast6_mod_fini);
 
 MODULE_LICENSE("GPL");
diff --git a/crypto/cbc.c b/crypto/cbc.c
index e81918ca68b7..ed3df6246765 100644
--- a/crypto/cbc.c
+++ b/crypto/cbc.c
@@ -179,7 +179,7 @@ static void __exit crypto_cbc_module_exit(void)
 	crypto_unregister_template(&crypto_cbc_tmpl);
 }
 
-subsys_initcall(crypto_cbc_module_init);
+module_init(crypto_cbc_module_init);
 module_exit(crypto_cbc_module_exit);
 
 MODULE_LICENSE("GPL");
diff --git a/crypto/ccm.c b/crypto/ccm.c
index f3f455e4908b..2ae929ffdef8 100644
--- a/crypto/ccm.c
+++ b/crypto/ccm.c
@@ -929,7 +929,7 @@ static void __exit crypto_ccm_module_exit(void)
 				    ARRAY_SIZE(crypto_ccm_tmpls));
 }
 
-subsys_initcall(crypto_ccm_module_init);
+module_init(crypto_ccm_module_init);
 module_exit(crypto_ccm_module_exit);
 
 MODULE_LICENSE("GPL");
diff --git a/crypto/chacha.c b/crypto/chacha.c
index 5103bc0b2881..28a8ad6197ab 100644
--- a/crypto/chacha.c
+++ b/crypto/chacha.c
@@ -243,7 +243,7 @@ static void __exit crypto_chacha_mod_fini(void)
 	crypto_unregister_skciphers(algs, num_algs);
 }
 
-subsys_initcall(crypto_chacha_mod_init);
+module_init(crypto_chacha_mod_init);
 module_exit(crypto_chacha_mod_fini);
 
 MODULE_LICENSE("GPL");
diff --git a/crypto/chacha20poly1305.c b/crypto/chacha20poly1305.c
index b29f66ba1e2f..b4b5a7198d84 100644
--- a/crypto/chacha20poly1305.c
+++ b/crypto/chacha20poly1305.c
@@ -476,7 +476,7 @@ static void __exit chacha20poly1305_module_exit(void)
 				    ARRAY_SIZE(rfc7539_tmpls));
 }
 
-subsys_initcall(chacha20poly1305_module_init);
+module_init(chacha20poly1305_module_init);
 module_exit(chacha20poly1305_module_exit);
 
 MODULE_LICENSE("GPL");
diff --git a/crypto/cmac.c b/crypto/cmac.c
index f297042a324b..1b03964abe00 100644
--- a/crypto/cmac.c
+++ b/crypto/cmac.c
@@ -251,7 +251,7 @@ static void __exit crypto_cmac_module_exit(void)
 	crypto_unregister_template(&crypto_cmac_tmpl);
 }
 
-subsys_initcall(crypto_cmac_module_init);
+module_init(crypto_cmac_module_init);
 module_exit(crypto_cmac_module_exit);
 
 MODULE_LICENSE("GPL");
diff --git a/crypto/crc32_generic.c b/crypto/crc32_generic.c
index 783a30b27398..cc371d42601f 100644
--- a/crypto/crc32_generic.c
+++ b/crypto/crc32_generic.c
@@ -172,7 +172,7 @@ static void __exit crc32_mod_fini(void)
 	crypto_unregister_shashes(algs, num_algs);
 }
 
-subsys_initcall(crc32_mod_init);
+module_init(crc32_mod_init);
 module_exit(crc32_mod_fini);
 
 MODULE_AUTHOR("Alexander Boyko <alexander_boyko@xyratex.com>");
diff --git a/crypto/crc32c_generic.c b/crypto/crc32c_generic.c
index b1a36d32dc50..e5377898414a 100644
--- a/crypto/crc32c_generic.c
+++ b/crypto/crc32c_generic.c
@@ -212,7 +212,7 @@ static void __exit crc32c_mod_fini(void)
 	crypto_unregister_shashes(algs, num_algs);
 }
 
-subsys_initcall(crc32c_mod_init);
+module_init(crc32c_mod_init);
 module_exit(crc32c_mod_fini);
 
 MODULE_AUTHOR("Clay Haapala <chaapala@cisco.com>");
diff --git a/crypto/cryptd.c b/crypto/cryptd.c
index 31d022d47f7a..5bb6f8d88cc2 100644
--- a/crypto/cryptd.c
+++ b/crypto/cryptd.c
@@ -1138,7 +1138,7 @@ static void __exit cryptd_exit(void)
 	crypto_unregister_template(&cryptd_tmpl);
 }
 
-subsys_initcall(cryptd_init);
+module_init(cryptd_init);
 module_exit(cryptd_exit);
 
 MODULE_LICENSE("GPL");
diff --git a/crypto/crypto_null.c b/crypto/crypto_null.c
index ced90f88ee07..5822753b0995 100644
--- a/crypto/crypto_null.c
+++ b/crypto/crypto_null.c
@@ -210,7 +210,7 @@ static void __exit crypto_null_mod_fini(void)
 	crypto_unregister_skcipher(&skcipher_null);
 }
 
-subsys_initcall(crypto_null_mod_init);
+module_init(crypto_null_mod_init);
 module_exit(crypto_null_mod_fini);
 
 MODULE_LICENSE("GPL");
diff --git a/crypto/ctr.c b/crypto/ctr.c
index 97a947b0a876..a388f0ceb3a0 100644
--- a/crypto/ctr.c
+++ b/crypto/ctr.c
@@ -350,7 +350,7 @@ static void __exit crypto_ctr_module_exit(void)
 				    ARRAY_SIZE(crypto_ctr_tmpls));
 }
 
-subsys_initcall(crypto_ctr_module_init);
+module_init(crypto_ctr_module_init);
 module_exit(crypto_ctr_module_exit);
 
 MODULE_LICENSE("GPL");
diff --git a/crypto/cts.c b/crypto/cts.c
index f5b42156b6c7..48898d5e24ff 100644
--- a/crypto/cts.c
+++ b/crypto/cts.c
@@ -402,7 +402,7 @@ static void __exit crypto_cts_module_exit(void)
 	crypto_unregister_template(&crypto_cts_tmpl);
 }
 
-subsys_initcall(crypto_cts_module_init);
+module_init(crypto_cts_module_init);
 module_exit(crypto_cts_module_exit);
 
 MODULE_LICENSE("Dual BSD/GPL");
diff --git a/crypto/curve25519-generic.c b/crypto/curve25519-generic.c
index 68a673262e04..f3e56e73c66c 100644
--- a/crypto/curve25519-generic.c
+++ b/crypto/curve25519-generic.c
@@ -82,7 +82,7 @@ static void __exit curve25519_exit(void)
 	crypto_unregister_kpp(&curve25519_alg);
 }
 
-subsys_initcall(curve25519_init);
+module_init(curve25519_init);
 module_exit(curve25519_exit);
 
 MODULE_ALIAS_CRYPTO("curve25519");
diff --git a/crypto/deflate.c b/crypto/deflate.c
index 0d2b64d96d6e..7eb1a5c44ee0 100644
--- a/crypto/deflate.c
+++ b/crypto/deflate.c
@@ -243,7 +243,7 @@ static void __exit deflate_mod_fini(void)
 	crypto_acomp_free_streams(&deflate_streams);
 }
 
-subsys_initcall(deflate_mod_init);
+module_init(deflate_mod_init);
 module_exit(deflate_mod_fini);
 
 MODULE_LICENSE("GPL");
diff --git a/crypto/des_generic.c b/crypto/des_generic.c
index 1274e18d3eb9..fce341400914 100644
--- a/crypto/des_generic.c
+++ b/crypto/des_generic.c
@@ -122,7 +122,7 @@ static void __exit des_generic_mod_fini(void)
 	crypto_unregister_algs(des_algs, ARRAY_SIZE(des_algs));
 }
 
-subsys_initcall(des_generic_mod_init);
+module_init(des_generic_mod_init);
 module_exit(des_generic_mod_fini);
 
 MODULE_LICENSE("GPL");
diff --git a/crypto/dh.c b/crypto/dh.c
index afc0fd847761..8250eeeebd0f 100644
--- a/crypto/dh.c
+++ b/crypto/dh.c
@@ -920,7 +920,7 @@ static void __exit dh_exit(void)
 	crypto_unregister_kpp(&dh);
 }
 
-subsys_initcall(dh_init);
+module_init(dh_init);
 module_exit(dh_exit);
 MODULE_ALIAS_CRYPTO("dh");
 MODULE_LICENSE("GPL");
diff --git a/crypto/drbg.c b/crypto/drbg.c
index f28dfc2511a2..dbe4c8bb5ceb 100644
--- a/crypto/drbg.c
+++ b/crypto/drbg.c
@@ -2132,7 +2132,7 @@ static void __exit drbg_exit(void)
 	crypto_unregister_rngs(drbg_algs, (ARRAY_SIZE(drbg_cores) * 2));
 }
 
-subsys_initcall(drbg_init);
+module_init(drbg_init);
 module_exit(drbg_exit);
 #ifndef CRYPTO_DRBG_HASH_STRING
 #define CRYPTO_DRBG_HASH_STRING ""
diff --git a/crypto/ecb.c b/crypto/ecb.c
index 95d7e972865a..cd1b20456dad 100644
--- a/crypto/ecb.c
+++ b/crypto/ecb.c
@@ -219,7 +219,7 @@ static void __exit crypto_ecb_module_exit(void)
 	crypto_unregister_template(&crypto_ecb_tmpl);
 }
 
-subsys_initcall(crypto_ecb_module_init);
+module_init(crypto_ecb_module_init);
 module_exit(crypto_ecb_module_exit);
 
 MODULE_LICENSE("GPL");
diff --git a/crypto/ecdh.c b/crypto/ecdh.c
index 72cfd1590156..9f0b93b3166d 100644
--- a/crypto/ecdh.c
+++ b/crypto/ecdh.c
@@ -240,7 +240,7 @@ static void __exit ecdh_exit(void)
 	crypto_unregister_kpp(&ecdh_nist_p384);
 }
 
-subsys_initcall(ecdh_init);
+module_init(ecdh_init);
 module_exit(ecdh_exit);
 MODULE_ALIAS_CRYPTO("ecdh");
 MODULE_LICENSE("GPL");
diff --git a/crypto/ecdsa.c b/crypto/ecdsa.c
index a70b60a90a3c..ce8e4364842f 100644
--- a/crypto/ecdsa.c
+++ b/crypto/ecdsa.c
@@ -334,7 +334,7 @@ static void __exit ecdsa_exit(void)
 	crypto_unregister_sig(&ecdsa_nist_p521);
 }
 
-subsys_initcall(ecdsa_init);
+module_init(ecdsa_init);
 module_exit(ecdsa_exit);
 
 MODULE_LICENSE("GPL");
diff --git a/crypto/echainiv.c b/crypto/echainiv.c
index 69686668625e..1913be8dfbba 100644
--- a/crypto/echainiv.c
+++ b/crypto/echainiv.c
@@ -157,7 +157,7 @@ static void __exit echainiv_module_exit(void)
 	crypto_unregister_template(&echainiv_tmpl);
 }
 
-subsys_initcall(echainiv_module_init);
+module_init(echainiv_module_init);
 module_exit(echainiv_module_exit);
 
 MODULE_LICENSE("GPL");
diff --git a/crypto/essiv.c b/crypto/essiv.c
index cfce8ef7ab1f..d003b78fcd85 100644
--- a/crypto/essiv.c
+++ b/crypto/essiv.c
@@ -641,7 +641,7 @@ static void __exit essiv_module_exit(void)
 	crypto_unregister_template(&essiv_tmpl);
 }
 
-subsys_initcall(essiv_module_init);
+module_init(essiv_module_init);
 module_exit(essiv_module_exit);
 
 MODULE_DESCRIPTION("ESSIV skcipher/aead wrapper for block encryption");
diff --git a/crypto/fcrypt.c b/crypto/fcrypt.c
index 95a16e88899b..80036835cec5 100644
--- a/crypto/fcrypt.c
+++ b/crypto/fcrypt.c
@@ -411,7 +411,7 @@ static void __exit fcrypt_mod_fini(void)
 	crypto_unregister_alg(&fcrypt_alg);
 }
 
-subsys_initcall(fcrypt_mod_init);
+module_init(fcrypt_mod_init);
 module_exit(fcrypt_mod_fini);
 
 MODULE_LICENSE("Dual BSD/GPL");
diff --git a/crypto/fips.c b/crypto/fips.c
index 2fa3a9ee61a1..e88a604cb42b 100644
--- a/crypto/fips.c
+++ b/crypto/fips.c
@@ -95,5 +95,5 @@ static void __exit fips_exit(void)
 	crypto_proc_fips_exit();
 }
 
-subsys_initcall(fips_init);
+module_init(fips_init);
 module_exit(fips_exit);
diff --git a/crypto/gcm.c b/crypto/gcm.c
index 84f7c23d14e4..54ca9faf0e0c 100644
--- a/crypto/gcm.c
+++ b/crypto/gcm.c
@@ -1152,7 +1152,7 @@ static void __exit crypto_gcm_module_exit(void)
 				    ARRAY_SIZE(crypto_gcm_tmpls));
 }
 
-subsys_initcall(crypto_gcm_module_init);
+module_init(crypto_gcm_module_init);
 module_exit(crypto_gcm_module_exit);
 
 MODULE_LICENSE("GPL");
diff --git a/crypto/ghash-generic.c b/crypto/ghash-generic.c
index b5fc20a0dafc..e5803c249c12 100644
--- a/crypto/ghash-generic.c
+++ b/crypto/ghash-generic.c
@@ -153,7 +153,7 @@ static void __exit ghash_mod_exit(void)
 	crypto_unregister_shash(&ghash_alg);
 }
 
-subsys_initcall(ghash_mod_init);
+module_init(ghash_mod_init);
 module_exit(ghash_mod_exit);
 
 MODULE_LICENSE("GPL");
diff --git a/crypto/hctr2.c b/crypto/hctr2.c
index cbcd673be481..c8932777bba8 100644
--- a/crypto/hctr2.c
+++ b/crypto/hctr2.c
@@ -570,7 +570,7 @@ static void __exit hctr2_module_exit(void)
 					   ARRAY_SIZE(hctr2_tmpls));
 }
 
-subsys_initcall(hctr2_module_init);
+module_init(hctr2_module_init);
 module_exit(hctr2_module_exit);
 
 MODULE_DESCRIPTION("HCTR2 length-preserving encryption mode");
diff --git a/crypto/hmac.c b/crypto/hmac.c
index dfb153511865..ba36ddf50037 100644
--- a/crypto/hmac.c
+++ b/crypto/hmac.c
@@ -257,7 +257,7 @@ static void __exit hmac_module_exit(void)
 	crypto_unregister_template(&hmac_tmpl);
 }
 
-subsys_initcall(hmac_module_init);
+module_init(hmac_module_init);
 module_exit(hmac_module_exit);
 
 MODULE_LICENSE("GPL");
diff --git a/crypto/khazad.c b/crypto/khazad.c
index 7ad338ca2c18..024264ee9cd1 100644
--- a/crypto/khazad.c
+++ b/crypto/khazad.c
@@ -871,7 +871,7 @@ static void __exit khazad_mod_fini(void)
 }
 
 
-subsys_initcall(khazad_mod_init);
+module_init(khazad_mod_init);
 module_exit(khazad_mod_fini);
 
 MODULE_LICENSE("GPL");
diff --git a/crypto/krb5enc.c b/crypto/krb5enc.c
index d07769bf149e..a1de55994d92 100644
--- a/crypto/krb5enc.c
+++ b/crypto/krb5enc.c
@@ -496,7 +496,7 @@ static void __exit crypto_krb5enc_module_exit(void)
 	crypto_unregister_template(&crypto_krb5enc_tmpl);
 }
 
-subsys_initcall(crypto_krb5enc_module_init);
+module_init(crypto_krb5enc_module_init);
 module_exit(crypto_krb5enc_module_exit);
 
 MODULE_LICENSE("GPL");
diff --git a/crypto/lrw.c b/crypto/lrw.c
index 391ae0f7641f..e7f0368f8c97 100644
--- a/crypto/lrw.c
+++ b/crypto/lrw.c
@@ -420,7 +420,7 @@ static void __exit lrw_module_exit(void)
 	crypto_unregister_template(&lrw_tmpl);
 }
 
-subsys_initcall(lrw_module_init);
+module_init(lrw_module_init);
 module_exit(lrw_module_exit);
 
 MODULE_LICENSE("GPL");
diff --git a/crypto/lz4.c b/crypto/lz4.c
index 9661ed01692f..7a984ae5ae52 100644
--- a/crypto/lz4.c
+++ b/crypto/lz4.c
@@ -89,7 +89,7 @@ static void __exit lz4_mod_fini(void)
 	crypto_unregister_scomp(&scomp);
 }
 
-subsys_initcall(lz4_mod_init);
+module_init(lz4_mod_init);
 module_exit(lz4_mod_fini);
 
 MODULE_LICENSE("GPL");
diff --git a/crypto/lz4hc.c b/crypto/lz4hc.c
index a637fddc1ccd..9c61d05b6214 100644
--- a/crypto/lz4hc.c
+++ b/crypto/lz4hc.c
@@ -87,7 +87,7 @@ static void __exit lz4hc_mod_fini(void)
 	crypto_unregister_scomp(&scomp);
 }
 
-subsys_initcall(lz4hc_mod_init);
+module_init(lz4hc_mod_init);
 module_exit(lz4hc_mod_fini);
 
 MODULE_LICENSE("GPL");
diff --git a/crypto/lzo-rle.c b/crypto/lzo-rle.c
index e7efcf107179..ba013f2d5090 100644
--- a/crypto/lzo-rle.c
+++ b/crypto/lzo-rle.c
@@ -91,7 +91,7 @@ static void __exit lzorle_mod_fini(void)
 	crypto_unregister_scomp(&scomp);
 }
 
-subsys_initcall(lzorle_mod_init);
+module_init(lzorle_mod_init);
 module_exit(lzorle_mod_fini);
 
 MODULE_LICENSE("GPL");
diff --git a/crypto/lzo.c b/crypto/lzo.c
index f1b36a1ca6f6..7867e2c67c4e 100644
--- a/crypto/lzo.c
+++ b/crypto/lzo.c
@@ -91,7 +91,7 @@ static void __exit lzo_mod_fini(void)
 	crypto_unregister_scomp(&scomp);
 }
 
-subsys_initcall(lzo_mod_init);
+module_init(lzo_mod_init);
 module_exit(lzo_mod_fini);
 
 MODULE_LICENSE("GPL");
diff --git a/crypto/md4.c b/crypto/md4.c
index 2e7f2f319f95..55bf47e23c13 100644
--- a/crypto/md4.c
+++ b/crypto/md4.c
@@ -233,7 +233,7 @@ static void __exit md4_mod_fini(void)
 	crypto_unregister_shash(&alg);
 }
 
-subsys_initcall(md4_mod_init);
+module_init(md4_mod_init);
 module_exit(md4_mod_fini);
 
 MODULE_LICENSE("GPL");
diff --git a/crypto/md5.c b/crypto/md5.c
index 994005cd977d..32c0819f5118 100644
--- a/crypto/md5.c
+++ b/crypto/md5.c
@@ -216,7 +216,7 @@ static void __exit md5_mod_fini(void)
 	crypto_unregister_shash(&alg);
 }
 
-subsys_initcall(md5_mod_init);
+module_init(md5_mod_init);
 module_exit(md5_mod_fini);
 
 MODULE_LICENSE("GPL");
diff --git a/crypto/michael_mic.c b/crypto/michael_mic.c
index 0d14e980d4d6..69ad35f524d7 100644
--- a/crypto/michael_mic.c
+++ b/crypto/michael_mic.c
@@ -167,7 +167,7 @@ static void __exit michael_mic_exit(void)
 }
 
 
-subsys_initcall(michael_mic_init);
+module_init(michael_mic_init);
 module_exit(michael_mic_exit);
 
 MODULE_LICENSE("GPL v2");
diff --git a/crypto/nhpoly1305.c b/crypto/nhpoly1305.c
index a661d4f667cd..2b648615b5ec 100644
--- a/crypto/nhpoly1305.c
+++ b/crypto/nhpoly1305.c
@@ -245,7 +245,7 @@ static void __exit nhpoly1305_mod_exit(void)
 	crypto_unregister_shash(&nhpoly1305_alg);
 }
 
-subsys_initcall(nhpoly1305_mod_init);
+module_init(nhpoly1305_mod_init);
 module_exit(nhpoly1305_mod_exit);
 
 MODULE_DESCRIPTION("NHPoly1305 ε-almost-∆-universal hash function");
diff --git a/crypto/pcbc.c b/crypto/pcbc.c
index 9d2e56d6744a..d092717ea4fc 100644
--- a/crypto/pcbc.c
+++ b/crypto/pcbc.c
@@ -186,7 +186,7 @@ static void __exit crypto_pcbc_module_exit(void)
 	crypto_unregister_template(&crypto_pcbc_tmpl);
 }
 
-subsys_initcall(crypto_pcbc_module_init);
+module_init(crypto_pcbc_module_init);
 module_exit(crypto_pcbc_module_exit);
 
 MODULE_LICENSE("GPL");
diff --git a/crypto/pcrypt.c b/crypto/pcrypt.c
index 7fc79e7dce44..c33d29a523e0 100644
--- a/crypto/pcrypt.c
+++ b/crypto/pcrypt.c
@@ -381,7 +381,7 @@ static void __exit pcrypt_exit(void)
 	kset_unregister(pcrypt_kset);
 }
 
-subsys_initcall(pcrypt_init);
+module_init(pcrypt_init);
 module_exit(pcrypt_exit);
 
 MODULE_LICENSE("GPL");
diff --git a/crypto/polyval-generic.c b/crypto/polyval-generic.c
index ffd174e75420..db8adb56e4ca 100644
--- a/crypto/polyval-generic.c
+++ b/crypto/polyval-generic.c
@@ -196,7 +196,7 @@ static void __exit polyval_mod_exit(void)
 	crypto_unregister_shash(&polyval_alg);
 }
 
-subsys_initcall(polyval_mod_init);
+module_init(polyval_mod_init);
 module_exit(polyval_mod_exit);
 
 MODULE_LICENSE("GPL");
diff --git a/crypto/rmd160.c b/crypto/rmd160.c
index c5fe4034b153..1599f603fbaa 100644
--- a/crypto/rmd160.c
+++ b/crypto/rmd160.c
@@ -358,7 +358,7 @@ static void __exit rmd160_mod_fini(void)
 	crypto_unregister_shash(&alg);
 }
 
-subsys_initcall(rmd160_mod_init);
+module_init(rmd160_mod_init);
 module_exit(rmd160_mod_fini);
 
 MODULE_LICENSE("GPL");
diff --git a/crypto/rsa.c b/crypto/rsa.c
index b7d21529c552..6c7734083c98 100644
--- a/crypto/rsa.c
+++ b/crypto/rsa.c
@@ -430,7 +430,7 @@ static void __exit rsa_exit(void)
 	crypto_unregister_akcipher(&rsa);
 }
 
-subsys_initcall(rsa_init);
+module_init(rsa_init);
 module_exit(rsa_exit);
 MODULE_ALIAS_CRYPTO("rsa");
 MODULE_LICENSE("GPL");
diff --git a/crypto/seed.c b/crypto/seed.c
index d05d8ed909fa..815391f213de 100644
--- a/crypto/seed.c
+++ b/crypto/seed.c
@@ -460,7 +460,7 @@ static void __exit seed_fini(void)
 	crypto_unregister_alg(&seed_alg);
 }
 
-subsys_initcall(seed_init);
+module_init(seed_init);
 module_exit(seed_fini);
 
 MODULE_DESCRIPTION("SEED Cipher Algorithm");
diff --git a/crypto/seqiv.c b/crypto/seqiv.c
index 17e11d51ddc3..a17ef5184398 100644
--- a/crypto/seqiv.c
+++ b/crypto/seqiv.c
@@ -179,7 +179,7 @@ static void __exit seqiv_module_exit(void)
 	crypto_unregister_template(&seqiv_tmpl);
 }
 
-subsys_initcall(seqiv_module_init);
+module_init(seqiv_module_init);
 module_exit(seqiv_module_exit);
 
 MODULE_LICENSE("GPL");
diff --git a/crypto/serpent_generic.c b/crypto/serpent_generic.c
index f6ef187be6fe..b21e7606c652 100644
--- a/crypto/serpent_generic.c
+++ b/crypto/serpent_generic.c
@@ -599,7 +599,7 @@ static void __exit serpent_mod_fini(void)
 	crypto_unregister_alg(&srp_alg);
 }
 
-subsys_initcall(serpent_mod_init);
+module_init(serpent_mod_init);
 module_exit(serpent_mod_fini);
 
 MODULE_LICENSE("GPL");
diff --git a/crypto/sha1_generic.c b/crypto/sha1_generic.c
index 7a3c837923b5..024e8043bab0 100644
--- a/crypto/sha1_generic.c
+++ b/crypto/sha1_generic.c
@@ -77,7 +77,7 @@ static void __exit sha1_generic_mod_fini(void)
 	crypto_unregister_shash(&alg);
 }
 
-subsys_initcall(sha1_generic_mod_init);
+module_init(sha1_generic_mod_init);
 module_exit(sha1_generic_mod_fini);
 
 MODULE_LICENSE("GPL");
diff --git a/crypto/sha256.c b/crypto/sha256.c
index 50b10c9106ed..00316425ff1c 100644
--- a/crypto/sha256.c
+++ b/crypto/sha256.c
@@ -270,7 +270,7 @@ static int __init crypto_sha256_mod_init(void)
 	}
 	return crypto_register_shashes(algs, num_algs);
 }
-subsys_initcall(crypto_sha256_mod_init);
+module_init(crypto_sha256_mod_init);
 
 static void __exit crypto_sha256_mod_exit(void)
 {
diff --git a/crypto/sha512_generic.c b/crypto/sha512_generic.c
index bfea65f4181c..7368173f545e 100644
--- a/crypto/sha512_generic.c
+++ b/crypto/sha512_generic.c
@@ -205,7 +205,7 @@ static void __exit sha512_generic_mod_fini(void)
 	crypto_unregister_shashes(sha512_algs, ARRAY_SIZE(sha512_algs));
 }
 
-subsys_initcall(sha512_generic_mod_init);
+module_init(sha512_generic_mod_init);
 module_exit(sha512_generic_mod_fini);
 
 MODULE_LICENSE("GPL");
diff --git a/crypto/sm3_generic.c b/crypto/sm3_generic.c
index 4fb6957c2f0c..7529139fcc96 100644
--- a/crypto/sm3_generic.c
+++ b/crypto/sm3_generic.c
@@ -62,7 +62,7 @@ static void __exit sm3_generic_mod_fini(void)
 	crypto_unregister_shash(&sm3_alg);
 }
 
-subsys_initcall(sm3_generic_mod_init);
+module_init(sm3_generic_mod_init);
 module_exit(sm3_generic_mod_fini);
 
 MODULE_LICENSE("GPL v2");
diff --git a/crypto/sm4_generic.c b/crypto/sm4_generic.c
index 7df86369ac00..d57444e8428c 100644
--- a/crypto/sm4_generic.c
+++ b/crypto/sm4_generic.c
@@ -83,7 +83,7 @@ static void __exit sm4_fini(void)
 	crypto_unregister_alg(&sm4_alg);
 }
 
-subsys_initcall(sm4_init);
+module_init(sm4_init);
 module_exit(sm4_fini);
 
 MODULE_DESCRIPTION("SM4 Cipher Algorithm");
diff --git a/crypto/streebog_generic.c b/crypto/streebog_generic.c
index dc625ffc54ad..0cfb63fd5df6 100644
--- a/crypto/streebog_generic.c
+++ b/crypto/streebog_generic.c
@@ -1082,7 +1082,7 @@ static void __exit streebog_mod_fini(void)
 	crypto_unregister_shashes(algs, ARRAY_SIZE(algs));
 }
 
-subsys_initcall(streebog_mod_init);
+module_init(streebog_mod_init);
 module_exit(streebog_mod_fini);
 
 MODULE_LICENSE("GPL");
diff --git a/crypto/tea.c b/crypto/tea.c
index b315da8c89eb..cb05140e3470 100644
--- a/crypto/tea.c
+++ b/crypto/tea.c
@@ -255,7 +255,7 @@ MODULE_ALIAS_CRYPTO("tea");
 MODULE_ALIAS_CRYPTO("xtea");
 MODULE_ALIAS_CRYPTO("xeta");
 
-subsys_initcall(tea_mod_init);
+module_init(tea_mod_init);
 module_exit(tea_mod_fini);
 
 MODULE_LICENSE("GPL");
diff --git a/crypto/twofish_generic.c b/crypto/twofish_generic.c
index 19f2b365e140..368018cfa9bf 100644
--- a/crypto/twofish_generic.c
+++ b/crypto/twofish_generic.c
@@ -187,7 +187,7 @@ static void __exit twofish_mod_fini(void)
 	crypto_unregister_alg(&alg);
 }
 
-subsys_initcall(twofish_mod_init);
+module_init(twofish_mod_init);
 module_exit(twofish_mod_fini);
 
 MODULE_LICENSE("GPL");
diff --git a/crypto/wp512.c b/crypto/wp512.c
index 07994e5ebf4e..41f13d490333 100644
--- a/crypto/wp512.c
+++ b/crypto/wp512.c
@@ -1169,7 +1169,7 @@ MODULE_ALIAS_CRYPTO("wp512");
 MODULE_ALIAS_CRYPTO("wp384");
 MODULE_ALIAS_CRYPTO("wp256");
 
-subsys_initcall(wp512_mod_init);
+module_init(wp512_mod_init);
 module_exit(wp512_mod_fini);
 
 MODULE_LICENSE("GPL");
diff --git a/crypto/xcbc.c b/crypto/xcbc.c
index 970ff581dc58..6c5f6766fdd6 100644
--- a/crypto/xcbc.c
+++ b/crypto/xcbc.c
@@ -199,7 +199,7 @@ static void __exit crypto_xcbc_module_exit(void)
 	crypto_unregister_template(&crypto_xcbc_tmpl);
 }
 
-subsys_initcall(crypto_xcbc_module_init);
+module_init(crypto_xcbc_module_init);
 module_exit(crypto_xcbc_module_exit);
 
 MODULE_LICENSE("GPL");
diff --git a/crypto/xctr.c b/crypto/xctr.c
index 9c536ab6d2e5..607ab82cb19b 100644
--- a/crypto/xctr.c
+++ b/crypto/xctr.c
@@ -182,7 +182,7 @@ static void __exit crypto_xctr_module_exit(void)
 	crypto_unregister_template(&crypto_xctr_tmpl);
 }
 
-subsys_initcall(crypto_xctr_module_init);
+module_init(crypto_xctr_module_init);
 module_exit(crypto_xctr_module_exit);
 
 MODULE_LICENSE("GPL");
diff --git a/crypto/xts.c b/crypto/xts.c
index 31529c9ef08f..1a9edd55a3a2 100644
--- a/crypto/xts.c
+++ b/crypto/xts.c
@@ -466,7 +466,7 @@ static void __exit xts_module_exit(void)
 	crypto_unregister_template(&xts_tmpl);
 }
 
-subsys_initcall(xts_module_init);
+module_init(xts_module_init);
 module_exit(xts_module_exit);
 
 MODULE_LICENSE("GPL");
diff --git a/crypto/xxhash_generic.c b/crypto/xxhash_generic.c
index ac206ad4184d..175bb7ae0fcd 100644
--- a/crypto/xxhash_generic.c
+++ b/crypto/xxhash_generic.c
@@ -96,7 +96,7 @@ static void __exit xxhash_mod_fini(void)
 	crypto_unregister_shash(&alg);
 }
 
-subsys_initcall(xxhash_mod_init);
+module_init(xxhash_mod_init);
 module_exit(xxhash_mod_fini);
 
 MODULE_AUTHOR("Nikolay Borisov <nborisov@suse.com>");
diff --git a/crypto/zstd.c b/crypto/zstd.c
index 90bb4f36f846..7570e11b4ee6 100644
--- a/crypto/zstd.c
+++ b/crypto/zstd.c
@@ -196,7 +196,7 @@ static void __exit zstd_mod_fini(void)
 	crypto_unregister_scomp(&scomp);
 }
 
-subsys_initcall(zstd_mod_init);
+module_init(zstd_mod_init);
 module_exit(zstd_mod_fini);
 
 MODULE_LICENSE("GPL");
-- 
2.39.5

-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
