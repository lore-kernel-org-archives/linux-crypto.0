From: Mathias Krause <minipli@googlemail.com>
Subject: [PATCH] crypto: aesni-intel - fix unaligned cbc decrypt for x86-32
Date: Wed, 30 May 2012 01:43:08 +0200
Message-ID: <1338334988-20025-1-git-send-email-minipli@googlemail.com>
Cc: Daniel <garkein@mailueberfall.de>, linux-crypto@vger.kernel.org,
	Mathias Krause <minipli@googlemail.com>
To: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from grimli.r00tworld.net ([83.169.44.195]:52546 "EHLO
	mail.r00tworld.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756010Ab2E2XnK (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 29 May 2012 19:43:10 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

The 32 bit variant of cbc(aes) decrypt is using instructions requiring
128 bit aligned memory locations but fails to ensure this constraint in
the code. Fix this by loading the data into intermediate registers with
load unaligned instructions.

This fixes reported general protection faults related to aesni.

References: https://bugzilla.kernel.org/show_bug.cgi?id=43223
Reported-by: Daniel <garkein@mailueberfall.de>
Cc: stable@kernel.org [v2.6.39+]
Signed-off-by: Mathias Krause <minipli@googlemail.com>
---
 arch/x86/crypto/aesni-intel_asm.S |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/arch/x86/crypto/aesni-intel_asm.S b/arch/x86/crypto/aesni-intel_asm.S
index be6d9e3..3470624 100644
--- a/arch/x86/crypto/aesni-intel_asm.S
+++ b/arch/x86/crypto/aesni-intel_asm.S
@@ -2460,10 +2460,12 @@ ENTRY(aesni_cbc_dec)
 	pxor IN3, STATE4
 	movaps IN4, IV
 #else
-	pxor (INP), STATE2
-	pxor 0x10(INP), STATE3
 	pxor IN1, STATE4
 	movaps IN2, IV
+	movups (INP), IN1
+	pxor IN1, STATE2
+	movups 0x10(INP), IN2
+	pxor IN2, STATE3
 #endif
 	movups STATE1, (OUTP)
 	movups STATE2, 0x10(OUTP)
-- 
1.7.10
