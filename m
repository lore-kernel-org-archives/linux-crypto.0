From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH v2 7/8] crypto: arm64/aes-xts-ce: fix for big endian
Date: Tue, 11 Oct 2016 19:15:19 +0100
Message-ID: <1476209720-21114-8-git-send-email-ard.biesheuvel@linaro.org>
References: <1476209720-21114-1-git-send-email-ard.biesheuvel@linaro.org>
Cc: will.deacon@arm.com, catalin.marinas@arm.com,
        linux@arm.linux.org.uk, Ard Biesheuvel <ard.biesheuvel@linaro.org>
To: linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wm0-f54.google.com ([74.125.82.54]:34913 "EHLO
        mail-wm0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752924AbcJKSQJ (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 11 Oct 2016 14:16:09 -0400
Received: by mail-wm0-f54.google.com with SMTP id f193so834246wmg.0
        for <linux-crypto@vger.kernel.org>; Tue, 11 Oct 2016 11:15:47 -0700 (PDT)
In-Reply-To: <1476209720-21114-1-git-send-email-ard.biesheuvel@linaro.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Emit the XTS tweak literal constants in the appropriate order for a
single 128-bit scalar literal load.

Fixes: 49788fe2a128 ("arm64/crypto: AES-ECB/CBC/CTR/XTS using ARMv8 NEON and Crypto Extensions")
Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 arch/arm64/crypto/aes-ce.S    | 1 +
 arch/arm64/crypto/aes-modes.S | 3 ++-
 2 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/crypto/aes-ce.S b/arch/arm64/crypto/aes-ce.S
index 78f3cfe92c08..b46093d567e5 100644
--- a/arch/arm64/crypto/aes-ce.S
+++ b/arch/arm64/crypto/aes-ce.S
@@ -10,6 +10,7 @@
  */
 
 #include <linux/linkage.h>
+#include <asm/assembler.h>
 
 #define AES_ENTRY(func)		ENTRY(ce_ ## func)
 #define AES_ENDPROC(func)	ENDPROC(ce_ ## func)
diff --git a/arch/arm64/crypto/aes-modes.S b/arch/arm64/crypto/aes-modes.S
index f6e372c528eb..c53dbeae79f2 100644
--- a/arch/arm64/crypto/aes-modes.S
+++ b/arch/arm64/crypto/aes-modes.S
@@ -386,7 +386,8 @@ AES_ENDPROC(aes_ctr_encrypt)
 	.endm
 
 .Lxts_mul_x:
-	.word		1, 0, 0x87, 0
+CPU_LE(	.quad		1, 0x87		)
+CPU_BE(	.quad		0x87, 1		)
 
 AES_ENTRY(aes_xts_encrypt)
 	FRAME_PUSH
-- 
2.7.4
