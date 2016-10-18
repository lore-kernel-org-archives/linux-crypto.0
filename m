From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH 2/5] crypto: arm/aes-ce - enable module autoloading based on CPU feature bits
Date: Tue, 18 Oct 2016 11:52:16 +0100
Message-ID: <1476787939-21889-3-git-send-email-ard.biesheuvel@linaro.org>
References: <1476787939-21889-1-git-send-email-ard.biesheuvel@linaro.org>
Cc: steve.capper@linaro.org, Ard Biesheuvel <ard.biesheuvel@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org,
        linux@arm.linux.org.uk, herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-qk0-f180.google.com ([209.85.220.180]:34553 "EHLO
        mail-qk0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752193AbcJRKwe (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 18 Oct 2016 06:52:34 -0400
Received: by mail-qk0-f180.google.com with SMTP id f128so272315515qkb.1
        for <linux-crypto@vger.kernel.org>; Tue, 18 Oct 2016 03:52:34 -0700 (PDT)
In-Reply-To: <1476787939-21889-1-git-send-email-ard.biesheuvel@linaro.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Make the module autoloadable by tying it to the CPU feature bit that
describes whether the optional instructions it relies on are implemented
by the current CPU.

Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 arch/arm/crypto/aes-ce-glue.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/arch/arm/crypto/aes-ce-glue.c b/arch/arm/crypto/aes-ce-glue.c
index aef022a87c53..5b1af6f8b2b5 100644
--- a/arch/arm/crypto/aes-ce-glue.c
+++ b/arch/arm/crypto/aes-ce-glue.c
@@ -14,6 +14,7 @@
 #include <crypto/aes.h>
 #include <crypto/ablk_helper.h>
 #include <crypto/algapi.h>
+#include <linux/cpufeature.h>
 #include <linux/module.h>
 #include <crypto/xts.h>
 
@@ -515,8 +516,6 @@ static struct crypto_alg aes_algs[] = { {
 
 static int __init aes_init(void)
 {
-	if (!(elf_hwcap2 & HWCAP2_AES))
-		return -ENODEV;
 	return crypto_register_algs(aes_algs, ARRAY_SIZE(aes_algs));
 }
 
@@ -525,5 +524,5 @@ static void __exit aes_exit(void)
 	crypto_unregister_algs(aes_algs, ARRAY_SIZE(aes_algs));
 }
 
-module_init(aes_init);
+module_cpu_feature_match(AES, aes_init);
 module_exit(aes_exit);
-- 
2.7.4
