From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH 5/5] crypto: arm/crc32 - enable module autoloading based on CPU feature bits
Date: Sun, 21 May 2017 10:23:40 +0000
Message-ID: <1495362220-30044-6-git-send-email-ard.biesheuvel@linaro.org>
References: <1495362220-30044-1-git-send-email-ard.biesheuvel@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>
To: linux-crypto@vger.kernel.org, herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wm0-f52.google.com ([74.125.82.52]:35346 "EHLO
        mail-wm0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752701AbdEUKX6 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 21 May 2017 06:23:58 -0400
Received: by mail-wm0-f52.google.com with SMTP id b84so267511457wmh.0
        for <linux-crypto@vger.kernel.org>; Sun, 21 May 2017 03:23:57 -0700 (PDT)
In-Reply-To: <1495362220-30044-1-git-send-email-ard.biesheuvel@linaro.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Make the module autoloadable by tying it to the CPU feature bits that
describe whether the optional instructions it relies on are implemented
by the current CPU.

Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 arch/arm/crypto/crc32-ce-glue.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/arch/arm/crypto/crc32-ce-glue.c b/arch/arm/crypto/crc32-ce-glue.c
index e1566bec1016..1b0e0e86ee9c 100644
--- a/arch/arm/crypto/crc32-ce-glue.c
+++ b/arch/arm/crypto/crc32-ce-glue.c
@@ -8,6 +8,7 @@
  * published by the Free Software Foundation.
  */
 
+#include <linux/cpufeature.h>
 #include <linux/crc32.h>
 #include <linux/init.h>
 #include <linux/kernel.h>
@@ -233,6 +234,11 @@ static void __exit crc32_pmull_mod_exit(void)
 				  ARRAY_SIZE(crc32_pmull_algs));
 }
 
+static const struct cpu_feature crc32_cpu_feature[] = {
+	{ cpu_feature(CRC32) }, { cpu_feature(PMULL) }, { }
+};
+MODULE_DEVICE_TABLE(cpu, crc32_cpu_feature);
+
 module_init(crc32_pmull_mod_init);
 module_exit(crc32_pmull_mod_exit);
 
-- 
2.7.4
