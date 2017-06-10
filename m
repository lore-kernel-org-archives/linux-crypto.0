From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH 04/12] crypto: arm64/crc32 - add non-SIMD scalar fallback
Date: Sat, 10 Jun 2017 16:22:50 +0000
Message-ID: <1497111778-4210-5-git-send-email-ard.biesheuvel@linaro.org>
References: <1497111778-4210-1-git-send-email-ard.biesheuvel@linaro.org>
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>
To: linux-crypto@vger.kernel.org, herbert@gondor.apana.org.au,
        linux-arm-kernel@lists.infradead.org, catalin.marinas@arm.com,
        will.deacon@arm.com, dave.martin@arm.com
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wr0-f171.google.com ([209.85.128.171]:36019 "EHLO
        mail-wr0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751958AbdFJQXP (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 10 Jun 2017 12:23:15 -0400
Received: by mail-wr0-f171.google.com with SMTP id v111so58815720wrc.3
        for <linux-crypto@vger.kernel.org>; Sat, 10 Jun 2017 09:23:14 -0700 (PDT)
In-Reply-To: <1497111778-4210-1-git-send-email-ard.biesheuvel@linaro.org>
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
2.7.4
