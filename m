From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH 2/6] crypto: arm64/ghash-ce - fix for big endian
Date: Sun,  9 Oct 2016 18:42:21 +0100
Message-ID: <1476034945-9186-3-git-send-email-ard.biesheuvel@linaro.org>
References: <1476034945-9186-1-git-send-email-ard.biesheuvel@linaro.org>
Cc: catalin.marinas@arm.com, will.deacon@arm.com,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>
To: linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-lf0-f41.google.com ([209.85.215.41]:36492 "EHLO
        mail-lf0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751947AbcJIRmk (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 9 Oct 2016 13:42:40 -0400
Received: by mail-lf0-f41.google.com with SMTP id b75so84199989lfg.3
        for <linux-crypto@vger.kernel.org>; Sun, 09 Oct 2016 10:42:39 -0700 (PDT)
In-Reply-To: <1476034945-9186-1-git-send-email-ard.biesheuvel@linaro.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

The GHASH key and digest are both pairs of 64-bit quantities, but the
GHASH code does not always refer to them as such, causing failures when
built for big endian. So replace the 16x1 loads and stores with 2x8 ones.

Fixes: b913a6404ce2 ("arm64/crypto: improve performance of GHASH algorithm")
Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 arch/arm64/crypto/ghash-ce-core.S | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/crypto/ghash-ce-core.S b/arch/arm64/crypto/ghash-ce-core.S
index dc457015884e..f0bb9f0b524f 100644
--- a/arch/arm64/crypto/ghash-ce-core.S
+++ b/arch/arm64/crypto/ghash-ce-core.S
@@ -29,8 +29,8 @@
 	 *			   struct ghash_key const *k, const char *head)
 	 */
 ENTRY(pmull_ghash_update)
-	ld1		{SHASH.16b}, [x3]
-	ld1		{XL.16b}, [x1]
+	ld1		{SHASH.2d}, [x3]
+	ld1		{XL.2d}, [x1]
 	movi		MASK.16b, #0xe1
 	ext		SHASH2.16b, SHASH.16b, SHASH.16b, #8
 	shl		MASK.2d, MASK.2d, #57
@@ -74,6 +74,6 @@ CPU_LE(	rev64		T1.16b, T1.16b	)
 
 	cbnz		w0, 0b
 
-	st1		{XL.16b}, [x1]
+	st1		{XL.2d}, [x1]
 	ret
 ENDPROC(pmull_ghash_update)
-- 
2.7.4
