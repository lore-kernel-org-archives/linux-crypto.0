From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH 2/2] crypto: arm/sha1-neon - add support for building in Thumb2 mode
Date: Mon, 29 Aug 2016 12:19:54 +0100
Message-ID: <1472469594-27315-2-git-send-email-ard.biesheuvel@linaro.org>
References: <1472469594-27315-1-git-send-email-ard.biesheuvel@linaro.org>
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>
To: linux-crypto@vger.kernel.org, herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wm0-f42.google.com ([74.125.82.42]:35420 "EHLO
        mail-wm0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932346AbcH2LUT (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 29 Aug 2016 07:20:19 -0400
Received: by mail-wm0-f42.google.com with SMTP id f65so73933302wmi.0
        for <linux-crypto@vger.kernel.org>; Mon, 29 Aug 2016 04:20:19 -0700 (PDT)
In-Reply-To: <1472469594-27315-1-git-send-email-ard.biesheuvel@linaro.org>
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
