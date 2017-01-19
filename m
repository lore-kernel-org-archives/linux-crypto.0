From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH] crypto: arm/aes-neonbs - fix issue with v2.22 and older assembler
Date: Thu, 19 Jan 2017 12:23:32 +0000
Message-ID: <1484828612-18956-1-git-send-email-ard.biesheuvel@linaro.org>
Cc: arnd@arndb.de, paul.gortmaker@windriver.com,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>
To: linux-crypto@vger.kernel.org, herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wm0-f54.google.com ([74.125.82.54]:36659 "EHLO
        mail-wm0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752194AbdASMYC (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 19 Jan 2017 07:24:02 -0500
Received: by mail-wm0-f54.google.com with SMTP id c85so286278309wmi.1
        for <linux-crypto@vger.kernel.org>; Thu, 19 Jan 2017 04:23:37 -0800 (PST)
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

The GNU assembler for ARM version 2.22 or older fails to infer the
element size from the vmov instructions, and aborts the build in
the following way;

.../aes-neonbs-core.S: Assembler messages:
.../aes-neonbs-core.S:817: Error: bad type for scalar -- `vmov q1h[1],r10'
.../aes-neonbs-core.S:817: Error: bad type for scalar -- `vmov q1h[0],r9'
.../aes-neonbs-core.S:817: Error: bad type for scalar -- `vmov q1l[1],r8'
.../aes-neonbs-core.S:817: Error: bad type for scalar -- `vmov q1l[0],r7'
.../aes-neonbs-core.S:818: Error: bad type for scalar -- `vmov q2h[1],r10'
.../aes-neonbs-core.S:818: Error: bad type for scalar -- `vmov q2h[0],r9'
.../aes-neonbs-core.S:818: Error: bad type for scalar -- `vmov q2l[1],r8'
.../aes-neonbs-core.S:818: Error: bad type for scalar -- `vmov q2l[0],r7'

Fix this by setting the element size explicitly, by replacing vmov with
vmov.32.

Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
Please add to the cryptodev-2.6 queue for v4.11

 arch/arm/crypto/aes-neonbs-core.S | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/arm/crypto/aes-neonbs-core.S b/arch/arm/crypto/aes-neonbs-core.S
index c9477044fbba..12da247164d1 100644
--- a/arch/arm/crypto/aes-neonbs-core.S
+++ b/arch/arm/crypto/aes-neonbs-core.S
@@ -766,13 +766,13 @@ ENTRY(aesbs_cbc_decrypt)
 ENDPROC(aesbs_cbc_decrypt)
 
 	.macro		next_ctr, q
-	vmov		\q\()h[1], r10
+	vmov.32		\q\()h[1], r10
 	adds		r10, r10, #1
-	vmov		\q\()h[0], r9
+	vmov.32		\q\()h[0], r9
 	adcs		r9, r9, #0
-	vmov		\q\()l[1], r8
+	vmov.32		\q\()l[1], r8
 	adcs		r8, r8, #0
-	vmov		\q\()l[0], r7
+	vmov.32		\q\()l[0], r7
 	adc		r7, r7, #0
 	vrev32.8	\q, \q
 	.endm
-- 
2.7.4
