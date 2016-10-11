From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH v2 3/8] crypto: arm64/sha1-ce - fix for big endian
Date: Tue, 11 Oct 2016 19:15:15 +0100
Message-ID: <1476209720-21114-4-git-send-email-ard.biesheuvel@linaro.org>
References: <1476209720-21114-1-git-send-email-ard.biesheuvel@linaro.org>
Cc: will.deacon@arm.com, catalin.marinas@arm.com,
        linux@arm.linux.org.uk, Ard Biesheuvel <ard.biesheuvel@linaro.org>
To: linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wm0-f45.google.com ([74.125.82.45]:37171 "EHLO
        mail-wm0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752729AbcJKSQJ (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 11 Oct 2016 14:16:09 -0400
Received: by mail-wm0-f45.google.com with SMTP id b201so857572wmb.0
        for <linux-crypto@vger.kernel.org>; Tue, 11 Oct 2016 11:15:38 -0700 (PDT)
In-Reply-To: <1476209720-21114-1-git-send-email-ard.biesheuvel@linaro.org>
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
