From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH 2/5] crypto: arm/ghash-ce - enable module autoloading based on CPU feature bits
Date: Sun, 21 May 2017 10:23:37 +0000
Message-ID: <1495362220-30044-3-git-send-email-ard.biesheuvel@linaro.org>
References: <1495362220-30044-1-git-send-email-ard.biesheuvel@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>
To: linux-crypto@vger.kernel.org, herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wm0-f53.google.com ([74.125.82.53]:37005 "EHLO
        mail-wm0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752646AbdEUKXw (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 21 May 2017 06:23:52 -0400
Received: by mail-wm0-f53.google.com with SMTP id d127so117725278wmf.0
        for <linux-crypto@vger.kernel.org>; Sun, 21 May 2017 03:23:51 -0700 (PDT)
In-Reply-To: <1495362220-30044-1-git-send-email-ard.biesheuvel@linaro.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Make the module autoloadable by tying it to the CPU feature bit that
describes whether the optional instructions it relies on are implemented
by the current CPU.

Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 arch/arm/crypto/ghash-ce-glue.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/arch/arm/crypto/ghash-ce-glue.c b/arch/arm/crypto/ghash-ce-glue.c
index 7546b3c02466..6bac8bea9f1e 100644
--- a/arch/arm/crypto/ghash-ce-glue.c
+++ b/arch/arm/crypto/ghash-ce-glue.c
@@ -15,6 +15,7 @@
 #include <crypto/cryptd.h>
 #include <crypto/internal/hash.h>
 #include <crypto/gf128mul.h>
+#include <linux/cpufeature.h>
 #include <linux/crypto.h>
 #include <linux/module.h>
 
@@ -311,9 +312,6 @@ static int __init ghash_ce_mod_init(void)
 {
 	int err;
 
-	if (!(elf_hwcap2 & HWCAP2_PMULL))
-		return -ENODEV;
-
 	err = crypto_register_shash(&ghash_alg);
 	if (err)
 		return err;
@@ -334,5 +332,5 @@ static void __exit ghash_ce_mod_exit(void)
 	crypto_unregister_shash(&ghash_alg);
 }
 
-module_init(ghash_ce_mod_init);
+module_cpu_feature_match(PMULL, ghash_ce_mod_init);
 module_exit(ghash_ce_mod_exit);
-- 
2.7.4
