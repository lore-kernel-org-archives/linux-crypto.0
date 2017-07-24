From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH resend 05/18] crypto: arm64/crc32 - add non-SIMD scalar fallback
Date: Mon, 24 Jul 2017 11:28:07 +0100
Message-ID: <20170724102820.16534-6-ard.biesheuvel@linaro.org>
References: <20170724102820.16534-1-ard.biesheuvel@linaro.org>
Cc: herbert@gondor.apana.org.au, dave.martin@arm.com,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>
To: linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wr0-f180.google.com ([209.85.128.180]:34653 "EHLO
        mail-wr0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751559AbdGXK2k (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 24 Jul 2017 06:28:40 -0400
Received: by mail-wr0-f180.google.com with SMTP id 12so104447461wrb.1
        for <linux-crypto@vger.kernel.org>; Mon, 24 Jul 2017 03:28:39 -0700 (PDT)
In-Reply-To: <20170724102820.16534-1-ard.biesheuvel@linaro.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

The arm64 kernel will shortly disallow nested kernel mode NEON, so
add a fallback to scalar C code that can be invoked in that case.

Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 arch/arm64/crypto/crc32-ce-glue.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/arch/arm64/crypto/crc32-ce-glue.c b/arch/arm64/crypto/crc32-ce-glue.c
index eccb1ae90064..624f4137918c 100644
--- a/arch/arm64/crypto/crc32-ce-glue.c
+++ b/arch/arm64/crypto/crc32-ce-glue.c
@@ -1,7 +1,7 @@
 /*
  * Accelerated CRC32(C) using arm64 NEON and Crypto Extensions instructions
  *
- * Copyright (C) 2016 Linaro Ltd <ard.biesheuvel@linaro.org>
+ * Copyright (C) 2016 - 2017 Linaro Ltd <ard.biesheuvel@linaro.org>
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License version 2 as
@@ -19,6 +19,7 @@
 
 #include <asm/hwcap.h>
 #include <asm/neon.h>
+#include <asm/simd.h>
 #include <asm/unaligned.h>
 
 #define PMULL_MIN_LEN		64L	/* minimum size of buffer
@@ -105,10 +106,10 @@ static int crc32_pmull_update(struct shash_desc *desc, const u8 *data,
 		length -= l;
 	}
 
-	if (length >= PMULL_MIN_LEN) {
+	if (length >= PMULL_MIN_LEN && may_use_simd()) {
 		l = round_down(length, SCALE_F);
 
-		kernel_neon_begin_partial(10);
+		kernel_neon_begin();
 		*crc = crc32_pmull_le(data, l, *crc);
 		kernel_neon_end();
 
@@ -137,10 +138,10 @@ static int crc32c_pmull_update(struct shash_desc *desc, const u8 *data,
 		length -= l;
 	}
 
-	if (length >= PMULL_MIN_LEN) {
+	if (length >= PMULL_MIN_LEN && may_use_simd()) {
 		l = round_down(length, SCALE_F);
 
-		kernel_neon_begin_partial(10);
+		kernel_neon_begin();
 		*crc = crc32c_pmull_le(data, l, *crc);
 		kernel_neon_end();
 
-- 
2.9.3
