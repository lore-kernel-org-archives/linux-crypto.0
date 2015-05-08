From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH 2/2] crypto: arm/aes - streamline AES-192 code path
Date: Fri,  8 May 2015 10:46:22 +0200
Message-ID: <1431074782-22141-2-git-send-email-ard.biesheuvel@linaro.org>
References: <1431074782-22141-1-git-send-email-ard.biesheuvel@linaro.org>
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>
To: herbert@gondor.apana.org.au, linux-crypto@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wi0-f179.google.com ([209.85.212.179]:33728 "EHLO
	mail-wi0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752341AbbEHIqa (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 8 May 2015 04:46:30 -0400
Received: by wief7 with SMTP id f7so31633052wie.0
        for <linux-crypto@vger.kernel.org>; Fri, 08 May 2015 01:46:28 -0700 (PDT)
In-Reply-To: <1431074782-22141-1-git-send-email-ard.biesheuvel@linaro.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

This trims off a couple of instructions of the total size of the
core AES transform by reordering the final branch in the AES-192
code path with the rounds that are performed regardless of whether
the branch is taken or not. Other than the slight size reduction,
this has no performance benefit.

Fix up a comment regarding the prototype of this function while
we're at it.

Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 arch/arm/crypto/aes-ce-core.S | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/arch/arm/crypto/aes-ce-core.S b/arch/arm/crypto/aes-ce-core.S
index 8cfa468ee570..987aa632c9f0 100644
--- a/arch/arm/crypto/aes-ce-core.S
+++ b/arch/arm/crypto/aes-ce-core.S
@@ -101,15 +101,14 @@
 	\dround		q10, q11
 	blo		0f			@ AES-128: 10 rounds
 	vld1.8		{q10-q11}, [ip]!
-	beq		1f			@ AES-192: 12 rounds
 	\dround		q12, q13
+	beq		1f			@ AES-192: 12 rounds
 	vld1.8		{q12-q13}, [ip]
 	\dround		q10, q11
 0:	\fround		q12, q13, q14
 	bx		lr
 
-1:	\dround		q12, q13
-	\fround		q10, q11, q14
+1:	\fround		q10, q11, q14
 	bx		lr
 	.endm
 
@@ -122,8 +121,8 @@
 	 *   q2        : third in/output block (_3x version only)
 	 *   q8        : first round key
 	 *   q9        : secound round key
-	 *   ip        : address of 3rd round key
 	 *   q14       : final round key
+	 *   r2        : address of round key array
 	 *   r3        : number of rounds
 	 */
 	.align		6
-- 
1.9.1
