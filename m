From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH 3/5] crypto: arm/ghash-ce - enable module autoloading based on CPU feature bits
Date: Tue, 18 Oct 2016 11:52:17 +0100
Message-ID: <1476787939-21889-4-git-send-email-ard.biesheuvel@linaro.org>
References: <1476787939-21889-1-git-send-email-ard.biesheuvel@linaro.org>
Cc: steve.capper@linaro.org, Ard Biesheuvel <ard.biesheuvel@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org,
        linux@arm.linux.org.uk, herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-qk0-f169.google.com ([209.85.220.169]:33094 "EHLO
        mail-qk0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752803AbcJRKwg (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 18 Oct 2016 06:52:36 -0400
Received: by mail-qk0-f169.google.com with SMTP id n189so284262645qke.0
        for <linux-crypto@vger.kernel.org>; Tue, 18 Oct 2016 03:52:36 -0700 (PDT)
In-Reply-To: <1476787939-21889-1-git-send-email-ard.biesheuvel@linaro.org>
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
