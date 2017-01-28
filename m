From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH v3 08/10] crypto: arm64/aes - performance tweak
Date: Sat, 28 Jan 2017 23:25:37 +0000
Message-ID: <1485645939-17126-9-git-send-email-ard.biesheuvel@linaro.org>
References: <1485645939-17126-1-git-send-email-ard.biesheuvel@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, herbert@gondor.apana.org.au,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wm0-f45.google.com ([74.125.82.45]:38104 "EHLO
        mail-wm0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752164AbdA1X0K (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 28 Jan 2017 18:26:10 -0500
Received: by mail-wm0-f45.google.com with SMTP id r126so35382017wmr.1
        for <linux-crypto@vger.kernel.org>; Sat, 28 Jan 2017 15:26:09 -0800 (PST)
In-Reply-To: <1485645939-17126-1-git-send-email-ard.biesheuvel@linaro.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Shuffle some instructions around in the __hround macro to shave off
0.1 cycles per byte on Cortex-A57.

Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 arch/arm64/crypto/aes-cipher-core.S | 52 +++++++-------------
 1 file changed, 19 insertions(+), 33 deletions(-)

diff --git a/arch/arm64/crypto/aes-cipher-core.S b/arch/arm64/crypto/aes-cipher-core.S
index cd58c61e6677..f2f9cc519309 100644
--- a/arch/arm64/crypto/aes-cipher-core.S
+++ b/arch/arm64/crypto/aes-cipher-core.S
@@ -20,46 +20,32 @@
 	tt		.req	x4
 	lt		.req	x2
 
-	.macro		__hround, out0, out1, in0, in1, in2, in3, t0, t1, enc
-	ldp		\out0, \out1, [rk], #8
-
-	ubfx		w13, \in0, #0, #8
-	ubfx		w14, \in1, #8, #8
-	ldr		w13, [tt, w13, uxtw #2]
-	ldr		w14, [tt, w14, uxtw #2]
-
+	.macro		__pair, enc, reg0, reg1, in0, in1e, in1d, shift
+	ubfx		\reg0, \in0, #\shift, #8
 	.if		\enc
-	ubfx		w17, \in1, #0, #8
-	ubfx		w18, \in2, #8, #8
+	ubfx		\reg1, \in1e, #\shift, #8
 	.else
-	ubfx		w17, \in3, #0, #8
-	ubfx		w18, \in0, #8, #8
+	ubfx		\reg1, \in1d, #\shift, #8
 	.endif
-	ldr		w17, [tt, w17, uxtw #2]
-	ldr		w18, [tt, w18, uxtw #2]
+	ldr		\reg0, [tt, \reg0, uxtw #2]
+	ldr		\reg1, [tt, \reg1, uxtw #2]
+	.endm
 
-	ubfx		w15, \in2, #16, #8
-	ubfx		w16, \in3, #24, #8
-	ldr		w15, [tt, w15, uxtw #2]
-	ldr		w16, [tt, w16, uxtw #2]
+	.macro		__hround, out0, out1, in0, in1, in2, in3, t0, t1, enc
+	ldp		\out0, \out1, [rk], #8
 
-	.if		\enc
-	ubfx		\t0, \in3, #16, #8
-	ubfx		\t1, \in0, #24, #8
-	.else
-	ubfx		\t0, \in1, #16, #8
-	ubfx		\t1, \in2, #24, #8
-	.endif
-	ldr		\t0, [tt, \t0, uxtw #2]
-	ldr		\t1, [tt, \t1, uxtw #2]
+	__pair		\enc, w13, w14, \in0, \in1, \in3, 0
+	__pair		\enc, w15, w16, \in1, \in2, \in0, 8
+	__pair		\enc, w17, w18, \in2, \in3, \in1, 16
+	__pair		\enc, \t0, \t1, \in3, \in0, \in2, 24
 
 	eor		\out0, \out0, w13
-	eor		\out1, \out1, w17
-	eor		\out0, \out0, w14, ror #24
-	eor		\out1, \out1, w18, ror #24
-	eor		\out0, \out0, w15, ror #16
-	eor		\out1, \out1, \t0, ror #16
-	eor		\out0, \out0, w16, ror #8
+	eor		\out1, \out1, w14
+	eor		\out0, \out0, w15, ror #24
+	eor		\out1, \out1, w16, ror #24
+	eor		\out0, \out0, w17, ror #16
+	eor		\out1, \out1, w18, ror #16
+	eor		\out0, \out0, \t0, ror #8
 	eor		\out1, \out1, \t1, ror #8
 	.endm
 
-- 
2.7.4
