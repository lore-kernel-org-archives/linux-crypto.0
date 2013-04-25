From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH] ARM: crypto: fix stack frame handling in SHA1 asm code
Date: Thu, 25 Apr 2013 14:51:50 +0200
Message-ID: <1366894310-19998-1-git-send-email-ard.biesheuvel@linaro.org>
Cc: david_mccullough@mcafee.com, appro@openssl.org,
	Ard Biesheuvel <ard.biesheuvel@linaro.org>
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wi0-f171.google.com ([209.85.212.171]:54258 "EHLO
	mail-wi0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758463Ab3DYMwb (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 25 Apr 2013 08:52:31 -0400
Received: by mail-wi0-f171.google.com with SMTP id l13so8605974wie.16
        for <linux-crypto@vger.kernel.org>; Thu, 25 Apr 2013 05:52:30 -0700 (PDT)
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

The current code increases its stack frame size a couple of
times throughout the function, but still performs some writes
below the stack pointer.

This change applies the fix from the original author so all
writes to the stack are above the stack pointer.

Taken from origin:
http://git.openssl.org/gitweb/?p=openssl.git;a=commit;h=1a9d60d2

Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 arch/arm/crypto/sha1-armv4-large.S |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/crypto/sha1-armv4-large.S b/arch/arm/crypto/sha1-armv4-large.S
index 92c6eed..99207c4 100644
--- a/arch/arm/crypto/sha1-armv4-large.S
+++ b/arch/arm/crypto/sha1-armv4-large.S
@@ -195,6 +195,7 @@ ENTRY(sha1_block_data_order)
 	add	r3,r3,r10			@ E+=F_00_19(B,C,D)
 	cmp	r14,sp
 	bne	.L_00_15		@ [((11+4)*5+2)*3]
+	sub	sp,sp,#25*4
 #if __ARM_ARCH__<7
 	ldrb	r10,[r1,#2]
 	ldrb	r9,[r1,#3]
@@ -290,7 +291,6 @@ ENTRY(sha1_block_data_order)
 	add	r3,r3,r10			@ E+=F_00_19(B,C,D)
 
 	ldr	r8,.LK_20_39		@ [+15+16*4]
-	sub	sp,sp,#25*4
 	cmn	sp,#0			@ [+3], clear carry to denote 20_39
 .L_20_39_or_60_79:
 	ldr	r9,[r14,#15*4]
-- 
1.7.10.4
