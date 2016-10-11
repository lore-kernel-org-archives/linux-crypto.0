From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH v2 4/8] crypto: arm64/sha2-ce - fix for big endian
Date: Tue, 11 Oct 2016 19:15:16 +0100
Message-ID: <1476209720-21114-5-git-send-email-ard.biesheuvel@linaro.org>
References: <1476209720-21114-1-git-send-email-ard.biesheuvel@linaro.org>
Cc: will.deacon@arm.com, catalin.marinas@arm.com,
        linux@arm.linux.org.uk, Ard Biesheuvel <ard.biesheuvel@linaro.org>
To: linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wm0-f54.google.com ([74.125.82.54]:35828 "EHLO
        mail-wm0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752820AbcJKSQJ (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 11 Oct 2016 14:16:09 -0400
Received: by mail-wm0-f54.google.com with SMTP id f193so828484wmg.0
        for <linux-crypto@vger.kernel.org>; Tue, 11 Oct 2016 11:15:40 -0700 (PDT)
In-Reply-To: <1476209720-21114-1-git-send-email-ard.biesheuvel@linaro.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

The SHA256 digest is an array of 8 32-bit quantities, so we should refer
to them as such in order for this code to work correctly when built for
big endian. So replace 16 byte scalar loads and stores with 4x32 vector
ones where appropriate.

Fixes: 6ba6c74dfc6b ("arm64/crypto: SHA-224/SHA-256 using ARMv8 Crypto Extensions")
Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 arch/arm64/crypto/sha2-ce-core.S | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/crypto/sha2-ce-core.S b/arch/arm64/crypto/sha2-ce-core.S
index 5df9d9d470ad..01cfee066837 100644
--- a/arch/arm64/crypto/sha2-ce-core.S
+++ b/arch/arm64/crypto/sha2-ce-core.S
@@ -85,7 +85,7 @@ ENTRY(sha2_ce_transform)
 	ld1		{v12.4s-v15.4s}, [x8]
 
 	/* load state */
-	ldp		dga, dgb, [x0]
+	ld1		{dgav.4s, dgbv.4s}, [x0]
 
 	/* load sha256_ce_state::finalize */
 	ldr		w4, [x0, #:lo12:sha256_ce_offsetof_finalize]
@@ -148,6 +148,6 @@ CPU_LE(	rev32		v19.16b, v19.16b	)
 	b		1b
 
 	/* store new state */
-3:	stp		dga, dgb, [x0]
+3:	st1		{dgav.4s, dgbv.4s}, [x0]
 	ret
 ENDPROC(sha2_ce_transform)
-- 
2.7.4
