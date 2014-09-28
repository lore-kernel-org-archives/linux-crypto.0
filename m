From: Mathias Krause <minipli@googlemail.com>
Subject: [PATCH 1/3] crypto: aesni - fix counter overflow handling in "by8" variant
Date: Sun, 28 Sep 2014 22:23:59 +0200
Message-ID: <1411935841-11294-2-git-send-email-minipli@googlemail.com>
References: <1411935841-11294-1-git-send-email-minipli@googlemail.com>
Cc: Chandramouli Narayanan <mouli@linux.intel.com>,
	linux-crypto@vger.kernel.org,
	Mathias Krause <minipli@googlemail.com>,
	Romain Francoise <romain@orebokech.com>
To: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-we0-f169.google.com ([74.125.82.169]:42217 "EHLO
	mail-we0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751632AbaI1UYY (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sun, 28 Sep 2014 16:24:24 -0400
Received: by mail-we0-f169.google.com with SMTP id k48so12024423wev.0
        for <linux-crypto@vger.kernel.org>; Sun, 28 Sep 2014 13:24:23 -0700 (PDT)
In-Reply-To: <1411935841-11294-1-git-send-email-minipli@googlemail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

The "by8" CTR AVX implementation fails to propperly handle counter
overflows. That was the reason it got disabled in commit 7da4b29d496b
("crypto: aesni - disable "by8" AVX CTR optimization").

Fix the overflow handling by incrementing the counter block as a double
quad word, i.e. a 128 bit, and testing for overflows afterwards. We need
to use VPTEST to do so as VPADD* does not set the flags itself and
silently drops the carry bit.

As this change adds branches to the hot path, minor performance
regressions  might be a side effect. But, OTOH, we now have a conforming
implementation -- the preferable goal.

A tcrypt test on a SandyBridge system (i7-2620M) showed almost identical
numbers for the old and this version with differences within the noise
range. A dm-crypt test with the fixed version gave even slightly better
results for this version. So the performance impact might not be as big
as expected.

Tested-by: Romain Francoise <romain@orebokech.com>
Signed-off-by: Mathias Krause <minipli@googlemail.com>
Cc: Chandramouli Narayanan <mouli@linux.intel.com>
---
 arch/x86/crypto/aes_ctrby8_avx-x86_64.S |   17 +++++++++++++++--
 1 file changed, 15 insertions(+), 2 deletions(-)

diff --git a/arch/x86/crypto/aes_ctrby8_avx-x86_64.S b/arch/x86/crypto/aes_ctrby8_avx-x86_64.S
index f091f122ed24..a029bc744244 100644
--- a/arch/x86/crypto/aes_ctrby8_avx-x86_64.S
+++ b/arch/x86/crypto/aes_ctrby8_avx-x86_64.S
@@ -108,6 +108,10 @@
 
 byteswap_const:
 	.octa 0x000102030405060708090A0B0C0D0E0F
+ddq_low_msk:
+	.octa 0x0000000000000000FFFFFFFFFFFFFFFF
+ddq_high_add_1:
+	.octa 0x00000000000000010000000000000000
 ddq_add_1:
 	.octa 0x00000000000000000000000000000001
 ddq_add_2:
@@ -169,7 +173,12 @@ ddq_add_8:
 	.rept (by - 1)
 		club DDQ_DATA, i
 		club XDATA, i
-		vpaddd	var_ddq_add(%rip), xcounter, var_xdata
+		vpaddq	var_ddq_add(%rip), xcounter, var_xdata
+		vptest	ddq_low_msk(%rip), var_xdata
+		jnz 1f
+		vpaddq	ddq_high_add_1(%rip), var_xdata, var_xdata
+		vpaddq	ddq_high_add_1(%rip), xcounter, xcounter
+		1:
 		vpshufb	xbyteswap, var_xdata, var_xdata
 		.set i, (i +1)
 	.endr
@@ -178,7 +187,11 @@ ddq_add_8:
 
 	vpxor	xkey0, xdata0, xdata0
 	club DDQ_DATA, by
-	vpaddd	var_ddq_add(%rip), xcounter, xcounter
+	vpaddq	var_ddq_add(%rip), xcounter, xcounter
+	vptest	ddq_low_msk(%rip), xcounter
+	jnz	1f
+	vpaddq	ddq_high_add_1(%rip), xcounter, xcounter
+	1:
 
 	.set i, 1
 	.rept (by - 1)
-- 
1.7.10.4
