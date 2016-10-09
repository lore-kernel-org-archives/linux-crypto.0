From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH 3/6] crypto: arm64/sha1-ce - fix for big endian
Date: Sun,  9 Oct 2016 18:42:22 +0100
Message-ID: <1476034945-9186-4-git-send-email-ard.biesheuvel@linaro.org>
References: <1476034945-9186-1-git-send-email-ard.biesheuvel@linaro.org>
Cc: catalin.marinas@arm.com, will.deacon@arm.com,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>
To: linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-lf0-f42.google.com ([209.85.215.42]:33003 "EHLO
        mail-lf0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751352AbcJIRml (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 9 Oct 2016 13:42:41 -0400
Received: by mail-lf0-f42.google.com with SMTP id x79so84675626lff.0
        for <linux-crypto@vger.kernel.org>; Sun, 09 Oct 2016 10:42:41 -0700 (PDT)
In-Reply-To: <1476034945-9186-1-git-send-email-ard.biesheuvel@linaro.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

The SHA1 digest is an array of 5 32-bit quantities, so we should refer
to them as such in order for this code to work correctly when built for
big endian. So replace 16 byte scalar loads and stores with 4x4 vector
ones where appropriate.

Fixes: 2c98833a42cd ("arm64/crypto: SHA-1 using ARMv8 Crypto Extensions")
Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 arch/arm64/crypto/sha1-ce-core.S | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/crypto/sha1-ce-core.S b/arch/arm64/crypto/sha1-ce-core.S
index 033aae6d732a..c98e7e849f06 100644
--- a/arch/arm64/crypto/sha1-ce-core.S
+++ b/arch/arm64/crypto/sha1-ce-core.S
@@ -78,7 +78,7 @@ ENTRY(sha1_ce_transform)
 	ld1r		{k3.4s}, [x6]
 
 	/* load state */
-	ldr		dga, [x0]
+	ld1		{dgav.4s}, [x0]
 	ldr		dgb, [x0, #16]
 
 	/* load sha1_ce_state::finalize */
@@ -144,7 +144,7 @@ CPU_LE(	rev32		v11.16b, v11.16b	)
 	b		1b
 
 	/* store new state */
-3:	str		dga, [x0]
+3:	st1		{dgav.4s}, [x0]
 	str		dgb, [x0, #16]
 	ret
 ENDPROC(sha1_ce_transform)
-- 
2.7.4
