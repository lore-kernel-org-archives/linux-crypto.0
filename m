From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH] arm64: crypto: increase AES interleave to 4x
Date: Thu, 19 Feb 2015 17:25:16 +0000
Message-ID: <1424366716-30439-1-git-send-email-ard.biesheuvel@linaro.org>
Cc: steve.capper@linaro.org, herbert@gondor.apana.org.au,
	linux-crypto@vger.kernel.org,
	Ard Biesheuvel <ard.biesheuvel@linaro.org>
To: will.deacon@arm.com, linux-arm-kernel@lists.infradead.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wg0-f54.google.com ([74.125.82.54]:64136 "EHLO
	mail-wg0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752018AbbBSRZ1 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 19 Feb 2015 12:25:27 -0500
Received: by mail-wg0-f54.google.com with SMTP id y19so8492627wgg.13
        for <linux-crypto@vger.kernel.org>; Thu, 19 Feb 2015 09:25:25 -0800 (PST)
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

This patch increases the interleave factor for parallel AES modes
to 4x. This improves performance on Cortex-A57 by ~35%. This is
due to the 3-cycle latency of AES instructions on the A57's
relatively deep pipeline (compared to Cortex-A53 where the AES
instruction latency is only 2 cycles).

At the same time, disable inline expansion of the core AES functions,
as the performance benefit of this feature is negligible.

  Measured on AMD Seattle (using tcrypt.ko mode=500 sec=1):

  Baseline (2x interleave, inline expansion)
  ------------------------------------------
  testing speed of async cbc(aes) (cbc-aes-ce) decryption
  test 4 (128 bit key, 8192 byte blocks): 95545 operations in 1 seconds
  test 14 (256 bit key, 8192 byte blocks): 68496 operations in 1 seconds

  This patch (4x interleave, no inline expansion)
  -----------------------------------------------
  testing speed of async cbc(aes) (cbc-aes-ce) decryption
  test 4 (128 bit key, 8192 byte blocks): 124735 operations in 1 seconds
  test 14 (256 bit key, 8192 byte blocks): 92328 operations in 1 seconds

Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 arch/arm64/crypto/Makefile | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/crypto/Makefile b/arch/arm64/crypto/Makefile
index 5720608c50b1..abb79b3cfcfe 100644
--- a/arch/arm64/crypto/Makefile
+++ b/arch/arm64/crypto/Makefile
@@ -29,7 +29,7 @@ aes-ce-blk-y := aes-glue-ce.o aes-ce.o
 obj-$(CONFIG_CRYPTO_AES_ARM64_NEON_BLK) += aes-neon-blk.o
 aes-neon-blk-y := aes-glue-neon.o aes-neon.o
 
-AFLAGS_aes-ce.o		:= -DINTERLEAVE=2 -DINTERLEAVE_INLINE
+AFLAGS_aes-ce.o		:= -DINTERLEAVE=4
 AFLAGS_aes-neon.o	:= -DINTERLEAVE=4
 
 CFLAGS_aes-glue-ce.o	:= -DUSE_V8_CRYPTO_EXTENSIONS
-- 
1.8.3.2
