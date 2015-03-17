From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH] arm64/crypto: issue aese/aesmc instructions in pairs
Date: Tue, 17 Mar 2015 19:05:13 +0100
Message-ID: <1426615513-28587-1-git-send-email-ard.biesheuvel@linaro.org>
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>
To: will.deacon@arm.com, catalin.marinas@arm.com,
	herbert@gondor.apana.org.au, linux-arm-kernel@lists.infradead.org,
	linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wi0-f178.google.com ([209.85.212.178]:38825 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753496AbbCQSFc (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 17 Mar 2015 14:05:32 -0400
Received: by wifj2 with SMTP id j2so18021111wif.1
        for <linux-crypto@vger.kernel.org>; Tue, 17 Mar 2015 11:05:30 -0700 (PDT)
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

This changes the AES core transform implementations to issue aese/aesmc
(and aesd/aesimc) in pairs. This enables a micro-architectural optimization
in recent Cortex-A5x cores that improves performance by 50-90%.

Measured performance in cycles per byte (Cortex-A57):

                CBC enc         CBC dec         CTR
  before        3.64            1.34            1.32
  after         1.95            0.85            0.93

Note that this results in a ~5% performance decrease for older cores.

Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---

Will,

This is the optimization you yourself mentioned to me about a year ago
(or even longer perhaps?) Anyway, we have now been able to confirm it
on a sample 'in the wild', (i.e., a Galaxy S6 phone)

 arch/arm64/crypto/aes-ce-ccm-core.S | 12 ++++++------
 arch/arm64/crypto/aes-ce.S          | 10 +++-------
 2 files changed, 9 insertions(+), 13 deletions(-)

diff --git a/arch/arm64/crypto/aes-ce-ccm-core.S b/arch/arm64/crypto/aes-ce-ccm-core.S
index 432e4841cd81..a2a7fbcacc14 100644
--- a/arch/arm64/crypto/aes-ce-ccm-core.S
+++ b/arch/arm64/crypto/aes-ce-ccm-core.S
@@ -101,19 +101,19 @@ ENTRY(ce_aes_ccm_final)
 0:	mov	v4.16b, v3.16b
 1:	ld1	{v5.2d}, [x2], #16		/* load next round key */
 	aese	v0.16b, v4.16b
-	aese	v1.16b, v4.16b
 	aesmc	v0.16b, v0.16b
+	aese	v1.16b, v4.16b
 	aesmc	v1.16b, v1.16b
 2:	ld1	{v3.2d}, [x2], #16		/* load next round key */
 	aese	v0.16b, v5.16b
-	aese	v1.16b, v5.16b
 	aesmc	v0.16b, v0.16b
+	aese	v1.16b, v5.16b
 	aesmc	v1.16b, v1.16b
 3:	ld1	{v4.2d}, [x2], #16		/* load next round key */
 	subs	w3, w3, #3
 	aese	v0.16b, v3.16b
-	aese	v1.16b, v3.16b
 	aesmc	v0.16b, v0.16b
+	aese	v1.16b, v3.16b
 	aesmc	v1.16b, v1.16b
 	bpl	1b
 	aese	v0.16b, v4.16b
@@ -146,19 +146,19 @@ ENDPROC(ce_aes_ccm_final)
 	ld1	{v5.2d}, [x10], #16		/* load 2nd round key */
 2:	/* inner loop: 3 rounds, 2x interleaved */
 	aese	v0.16b, v4.16b
-	aese	v1.16b, v4.16b
 	aesmc	v0.16b, v0.16b
+	aese	v1.16b, v4.16b
 	aesmc	v1.16b, v1.16b
 3:	ld1	{v3.2d}, [x10], #16		/* load next round key */
 	aese	v0.16b, v5.16b
-	aese	v1.16b, v5.16b
 	aesmc	v0.16b, v0.16b
+	aese	v1.16b, v5.16b
 	aesmc	v1.16b, v1.16b
 4:	ld1	{v4.2d}, [x10], #16		/* load next round key */
 	subs	w7, w7, #3
 	aese	v0.16b, v3.16b
-	aese	v1.16b, v3.16b
 	aesmc	v0.16b, v0.16b
+	aese	v1.16b, v3.16b
 	aesmc	v1.16b, v1.16b
 	ld1	{v5.2d}, [x10], #16		/* load next round key */
 	bpl	2b
diff --git a/arch/arm64/crypto/aes-ce.S b/arch/arm64/crypto/aes-ce.S
index 685a18f731eb..78f3cfe92c08 100644
--- a/arch/arm64/crypto/aes-ce.S
+++ b/arch/arm64/crypto/aes-ce.S
@@ -45,18 +45,14 @@
 
 	.macro		do_enc_Nx, de, mc, k, i0, i1, i2, i3
 	aes\de		\i0\().16b, \k\().16b
-	.ifnb		\i1
-	aes\de		\i1\().16b, \k\().16b
-	.ifnb		\i3
-	aes\de		\i2\().16b, \k\().16b
-	aes\de		\i3\().16b, \k\().16b
-	.endif
-	.endif
 	aes\mc		\i0\().16b, \i0\().16b
 	.ifnb		\i1
+	aes\de		\i1\().16b, \k\().16b
 	aes\mc		\i1\().16b, \i1\().16b
 	.ifnb		\i3
+	aes\de		\i2\().16b, \k\().16b
 	aes\mc		\i2\().16b, \i2\().16b
+	aes\de		\i3\().16b, \k\().16b
 	aes\mc		\i3\().16b, \i3\().16b
 	.endif
 	.endif
-- 
1.8.3.2
