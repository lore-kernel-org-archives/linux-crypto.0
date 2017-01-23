From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH v2 01/10] crypto: arm64/aes-neon-bs - honour iv_out requirement in CTR mode
Date: Mon, 23 Jan 2017 14:05:17 +0000
Message-ID: <1485180326-25612-2-git-send-email-ard.biesheuvel@linaro.org>
References: <1485180326-25612-1-git-send-email-ard.biesheuvel@linaro.org>
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>
To: linux-crypto@vger.kernel.org, herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wm0-f53.google.com ([74.125.82.53]:37461 "EHLO
        mail-wm0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751113AbdAWOFf (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 23 Jan 2017 09:05:35 -0500
Received: by mail-wm0-f53.google.com with SMTP id c206so157127865wme.0
        for <linux-crypto@vger.kernel.org>; Mon, 23 Jan 2017 06:05:34 -0800 (PST)
In-Reply-To: <1485180326-25612-1-git-send-email-ard.biesheuvel@linaro.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Update the new bitsliced NEON AES implementation in CTR mode to return
the next IV back to the skcipher API client. This is necessary for
chaining to work correctly.

Note that this is only done if the request is a round multiple of the
block size, since otherwise, chaining is impossible anyway.

Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 arch/arm64/crypto/aes-neonbs-core.S | 25 +++++++++++++-------
 1 file changed, 16 insertions(+), 9 deletions(-)

diff --git a/arch/arm64/crypto/aes-neonbs-core.S b/arch/arm64/crypto/aes-neonbs-core.S
index 8d0cdaa2768d..2ada12dd768e 100644
--- a/arch/arm64/crypto/aes-neonbs-core.S
+++ b/arch/arm64/crypto/aes-neonbs-core.S
@@ -874,12 +874,19 @@ CPU_LE(	rev		x8, x8		)
 	csel		x4, x4, xzr, pl
 	csel		x9, x9, xzr, le
 
+	tbnz		x9, #1, 0f
 	next_ctr	v1
+	tbnz		x9, #2, 0f
 	next_ctr	v2
+	tbnz		x9, #3, 0f
 	next_ctr	v3
+	tbnz		x9, #4, 0f
 	next_ctr	v4
+	tbnz		x9, #5, 0f
 	next_ctr	v5
+	tbnz		x9, #6, 0f
 	next_ctr	v6
+	tbnz		x9, #7, 0f
 	next_ctr	v7
 
 0:	mov		bskey, x2
@@ -928,11 +935,11 @@ CPU_LE(	rev		x8, x8		)
 	eor		v5.16b, v5.16b, v15.16b
 	st1		{v5.16b}, [x0], #16
 
-	next_ctr	v0
+8:	next_ctr	v0
 	cbnz		x4, 99b
 
 0:	st1		{v0.16b}, [x5]
-8:	ldp		x29, x30, [sp], #16
+9:	ldp		x29, x30, [sp], #16
 	ret
 
 	/*
@@ -941,23 +948,23 @@ CPU_LE(	rev		x8, x8		)
 	 */
 1:	cbz		x6, 8b
 	st1		{v1.16b}, [x5]
-	b		8b
+	b		9b
 2:	cbz		x6, 8b
 	st1		{v4.16b}, [x5]
-	b		8b
+	b		9b
 3:	cbz		x6, 8b
 	st1		{v6.16b}, [x5]
-	b		8b
+	b		9b
 4:	cbz		x6, 8b
 	st1		{v3.16b}, [x5]
-	b		8b
+	b		9b
 5:	cbz		x6, 8b
 	st1		{v7.16b}, [x5]
-	b		8b
+	b		9b
 6:	cbz		x6, 8b
 	st1		{v2.16b}, [x5]
-	b		8b
+	b		9b
 7:	cbz		x6, 8b
 	st1		{v5.16b}, [x5]
-	b		8b
+	b		9b
 ENDPROC(aesbs_ctr_encrypt)
-- 
2.7.4
