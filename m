From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH 5/5] crypto: arm/sha2-ce - enable module autoloading based on CPU feature bits
Date: Tue, 18 Oct 2016 11:52:19 +0100
Message-ID: <1476787939-21889-6-git-send-email-ard.biesheuvel@linaro.org>
References: <1476787939-21889-1-git-send-email-ard.biesheuvel@linaro.org>
Cc: steve.capper@linaro.org, Ard Biesheuvel <ard.biesheuvel@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org,
        linux@arm.linux.org.uk, herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-qt0-f182.google.com ([209.85.216.182]:35844 "EHLO
        mail-qt0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753905AbcJRKwk (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 18 Oct 2016 06:52:40 -0400
Received: by mail-qt0-f182.google.com with SMTP id m5so146933377qtb.3
        for <linux-crypto@vger.kernel.org>; Tue, 18 Oct 2016 03:52:39 -0700 (PDT)
In-Reply-To: <1476787939-21889-1-git-send-email-ard.biesheuvel@linaro.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Make the module autoloadable by tying it to the CPU feature bit that
describes whether the optional instructions it relies on are implemented
by the current CPU.

Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 arch/arm/crypto/sha2-ce-glue.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/arch/arm/crypto/sha2-ce-glue.c b/arch/arm/crypto/sha2-ce-glue.c
index 0755b2d657f3..df4dcef054ae 100644
--- a/arch/arm/crypto/sha2-ce-glue.c
+++ b/arch/arm/crypto/sha2-ce-glue.c
@@ -11,6 +11,7 @@
 #include <crypto/internal/hash.h>
 #include <crypto/sha.h>
 #include <crypto/sha256_base.h>
+#include <linux/cpufeature.h>
 #include <linux/crypto.h>
 #include <linux/module.h>
 
@@ -100,8 +101,6 @@ static struct shash_alg algs[] = { {
 
 static int __init sha2_ce_mod_init(void)
 {
-	if (!(elf_hwcap2 & HWCAP2_SHA2))
-		return -ENODEV;
 	return crypto_register_shashes(algs, ARRAY_SIZE(algs));
 }
 
@@ -110,5 +109,5 @@ static void __exit sha2_ce_mod_fini(void)
 	crypto_unregister_shashes(algs, ARRAY_SIZE(algs));
 }
 
-module_init(sha2_ce_mod_init);
+module_cpu_feature_match(SHA2, sha2_ce_mod_init);
 module_exit(sha2_ce_mod_fini);
-- 
2.7.4
