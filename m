From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH 07/10] crypto: arm64/aes - avoid literals for cross-module symbol references
Date: Tue, 17 Jan 2017 15:22:34 +0000
Message-ID: <1484666557-31458-8-git-send-email-ard.biesheuvel@linaro.org>
References: <1484666557-31458-1-git-send-email-ard.biesheuvel@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>
To: linux-crypto@vger.kernel.org, herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wm0-f41.google.com ([74.125.82.41]:36937 "EHLO
        mail-wm0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750892AbdAQPX4 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 17 Jan 2017 10:23:56 -0500
Received: by mail-wm0-f41.google.com with SMTP id c206so227927090wme.0
        for <linux-crypto@vger.kernel.org>; Tue, 17 Jan 2017 07:23:06 -0800 (PST)
In-Reply-To: <1484666557-31458-1-git-send-email-ard.biesheuvel@linaro.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Using simple adrp/add pairs to refer to the AES lookup tables exposed by
the generic AES driver (which could be loaded far away from this driver
when KASLR is in effect) was unreliable at module load time before commit
41c066f2c4d4 ("arm64: assembler: make adr_l work in modules under KASLR"),
which is why the AES code used literals instead.

So now we can get rid of the literals, and switch to the adr_l macro.

Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 arch/arm64/crypto/aes-cipher-core.S | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/arch/arm64/crypto/aes-cipher-core.S b/arch/arm64/crypto/aes-cipher-core.S
index 37590ab8121a..cd58c61e6677 100644
--- a/arch/arm64/crypto/aes-cipher-core.S
+++ b/arch/arm64/crypto/aes-cipher-core.S
@@ -89,8 +89,8 @@ CPU_BE(	rev		w8, w8		)
 	eor		w7, w7, w11
 	eor		w8, w8, w12
 
-	ldr		tt, =\ttab
-	ldr		lt, =\ltab
+	adr_l		tt, \ttab
+	adr_l		lt, \ltab
 
 	tbnz		rounds, #1, 1f
 
@@ -111,9 +111,6 @@ CPU_BE(	rev		w8, w8		)
 	stp		w5, w6, [out]
 	stp		w7, w8, [out, #8]
 	ret
-
-	.align		4
-	.ltorg
 	.endm
 
 	.align		5
-- 
2.7.4
