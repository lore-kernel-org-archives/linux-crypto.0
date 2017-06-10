From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH 11/12] crypto: arm64/chacha20 - take may_use_simd() into account
Date: Sat, 10 Jun 2017 16:22:57 +0000
Message-ID: <1497111778-4210-12-git-send-email-ard.biesheuvel@linaro.org>
References: <1497111778-4210-1-git-send-email-ard.biesheuvel@linaro.org>
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>
To: linux-crypto@vger.kernel.org, herbert@gondor.apana.org.au,
        linux-arm-kernel@lists.infradead.org, catalin.marinas@arm.com,
        will.deacon@arm.com, dave.martin@arm.com
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wr0-f169.google.com ([209.85.128.169]:34910 "EHLO
        mail-wr0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752205AbdFJQXc (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 10 Jun 2017 12:23:32 -0400
Received: by mail-wr0-f169.google.com with SMTP id q97so58893555wrb.2
        for <linux-crypto@vger.kernel.org>; Sat, 10 Jun 2017 09:23:32 -0700 (PDT)
In-Reply-To: <1497111778-4210-1-git-send-email-ard.biesheuvel@linaro.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

To accommodate systems that disallow the use of kernel mode NEON in
some circumstances, take the return value of may_use_simd into
account when deciding whether to invoke the C fallback routine.

Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 arch/arm64/crypto/chacha20-neon-glue.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/crypto/chacha20-neon-glue.c b/arch/arm64/crypto/chacha20-neon-glue.c
index a7cd575ea223..cbdb75d15cd0 100644
--- a/arch/arm64/crypto/chacha20-neon-glue.c
+++ b/arch/arm64/crypto/chacha20-neon-glue.c
@@ -1,7 +1,7 @@
 /*
  * ChaCha20 256-bit cipher algorithm, RFC7539, arm64 NEON functions
  *
- * Copyright (C) 2016 Linaro, Ltd. <ard.biesheuvel@linaro.org>
+ * Copyright (C) 2016 - 2017 Linaro, Ltd. <ard.biesheuvel@linaro.org>
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License version 2 as
@@ -26,6 +26,7 @@
 
 #include <asm/hwcap.h>
 #include <asm/neon.h>
+#include <asm/simd.h>
 
 asmlinkage void chacha20_block_xor_neon(u32 *state, u8 *dst, const u8 *src);
 asmlinkage void chacha20_4block_xor_neon(u32 *state, u8 *dst, const u8 *src);
@@ -64,7 +65,7 @@ static int chacha20_neon(struct skcipher_request *req)
 	u32 state[16];
 	int err;
 
-	if (req->cryptlen <= CHACHA20_BLOCK_SIZE)
+	if (!may_use_simd() || req->cryptlen <= CHACHA20_BLOCK_SIZE)
 		return crypto_chacha20_crypt(req);
 
 	err = skcipher_walk_virt(&walk, req, true);
-- 
2.7.4
