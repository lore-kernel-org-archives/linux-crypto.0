From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH 03/12] crypto: arm64/crct10dif - add non-SIMD generic fallback
Date: Sat, 10 Jun 2017 16:22:49 +0000
Message-ID: <1497111778-4210-4-git-send-email-ard.biesheuvel@linaro.org>
References: <1497111778-4210-1-git-send-email-ard.biesheuvel@linaro.org>
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>
To: linux-crypto@vger.kernel.org, herbert@gondor.apana.org.au,
        linux-arm-kernel@lists.infradead.org, catalin.marinas@arm.com,
        will.deacon@arm.com, dave.martin@arm.com
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wr0-f172.google.com ([209.85.128.172]:35838 "EHLO
        mail-wr0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751958AbdFJQXN (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 10 Jun 2017 12:23:13 -0400
Received: by mail-wr0-f172.google.com with SMTP id q97so58889441wrb.2
        for <linux-crypto@vger.kernel.org>; Sat, 10 Jun 2017 09:23:12 -0700 (PDT)
In-Reply-To: <1497111778-4210-1-git-send-email-ard.biesheuvel@linaro.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

The arm64 kernel will shortly disallow nested kernel mode NEON, so
add a fallback to scalar C code that can be invoked in that case.

Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 arch/arm64/crypto/crct10dif-ce-glue.c | 13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/crypto/crct10dif-ce-glue.c b/arch/arm64/crypto/crct10dif-ce-glue.c
index 60cb590c2590..96f0cae4a022 100644
--- a/arch/arm64/crypto/crct10dif-ce-glue.c
+++ b/arch/arm64/crypto/crct10dif-ce-glue.c
@@ -1,7 +1,7 @@
 /*
  * Accelerated CRC-T10DIF using arm64 NEON and Crypto Extensions instructions
  *
- * Copyright (C) 2016 Linaro Ltd <ard.biesheuvel@linaro.org>
+ * Copyright (C) 2016 - 2017 Linaro Ltd <ard.biesheuvel@linaro.org>
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License version 2 as
@@ -18,6 +18,7 @@
 #include <crypto/internal/hash.h>
 
 #include <asm/neon.h>
+#include <asm/simd.h>
 
 #define CRC_T10DIF_PMULL_CHUNK_SIZE	16U
 
@@ -48,9 +49,13 @@ static int crct10dif_update(struct shash_desc *desc, const u8 *data,
 	}
 
 	if (length > 0) {
-		kernel_neon_begin_partial(14);
-		*crc = crc_t10dif_pmull(*crc, data, length);
-		kernel_neon_end();
+		if (may_use_simd()) {
+			kernel_neon_begin();
+			*crc = crc_t10dif_pmull(*crc, data, length);
+			kernel_neon_end();
+		} else {
+			*crc = crc_t10dif_generic(*crc, data, length);
+		}
 	}
 
 	return 0;
-- 
2.7.4
