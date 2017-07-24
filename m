From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH resend 04/18] crypto: arm64/crct10dif - add non-SIMD generic fallback
Date: Mon, 24 Jul 2017 11:28:06 +0100
Message-ID: <20170724102820.16534-5-ard.biesheuvel@linaro.org>
References: <20170724102820.16534-1-ard.biesheuvel@linaro.org>
Cc: herbert@gondor.apana.org.au, dave.martin@arm.com,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>
To: linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wm0-f48.google.com ([74.125.82.48]:37898 "EHLO
        mail-wm0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751559AbdGXK2i (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 24 Jul 2017 06:28:38 -0400
Received: by mail-wm0-f48.google.com with SMTP id m85so13408426wma.1
        for <linux-crypto@vger.kernel.org>; Mon, 24 Jul 2017 03:28:37 -0700 (PDT)
In-Reply-To: <20170724102820.16534-1-ard.biesheuvel@linaro.org>
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
2.9.3
