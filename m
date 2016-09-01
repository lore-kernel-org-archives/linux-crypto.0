From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH v2 1/3] crypto: arm/sha1-neon - add support for building in Thumb2 mode
Date: Thu,  1 Sep 2016 14:25:41 +0100
Message-ID: <1472736343-15305-2-git-send-email-ard.biesheuvel@linaro.org>
References: <1472736343-15305-1-git-send-email-ard.biesheuvel@linaro.org>
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>
To: linux-crypto@vger.kernel.org, herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wm0-f48.google.com ([74.125.82.48]:37927 "EHLO
        mail-wm0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754858AbcIAN1R (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 1 Sep 2016 09:27:17 -0400
Received: by mail-wm0-f48.google.com with SMTP id 1so94996362wmz.1
        for <linux-crypto@vger.kernel.org>; Thu, 01 Sep 2016 06:27:17 -0700 (PDT)
In-Reply-To: <1472736343-15305-1-git-send-email-ard.biesheuvel@linaro.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

The ARMv7 NEON module is explicitly built in ARM mode, which is not
supported by the Thumb2 kernel. So remove the explicit override, and
leave it up to the build environment to decide whether the core SHA1
routines are assembled as ARM or as Thumb2 code.

Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 arch/arm/crypto/sha1-armv7-neon.S | 1 -
 1 file changed, 1 deletion(-)

diff --git a/arch/arm/crypto/sha1-armv7-neon.S b/arch/arm/crypto/sha1-armv7-neon.S
index dcd01f3f0bb0..2468fade49cf 100644
--- a/arch/arm/crypto/sha1-armv7-neon.S
+++ b/arch/arm/crypto/sha1-armv7-neon.S
@@ -12,7 +12,6 @@
 #include <asm/assembler.h>
 
 .syntax unified
-.code   32
 .fpu neon
 
 .text
-- 
2.7.4
