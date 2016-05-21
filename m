From: Andrea Gelmini <andrea.gelmini@gelma.net>
Subject: [PATCH 0211/1529] Fix typo
Date: Sat, 21 May 2016 14:03:38 +0200
Message-ID: <20160521120338.10915-1-andrea.gelmini@gelma.net>
Cc: trivial@kernel.org, herbert@gondor.apana.org.au,
	davem@davemloft.net, benh@kernel.crashing.org, paulus@samba.org,
	mpe@ellerman.id.au, linux-crypto@vger.kernel.org,
	linuxppc-dev@lists.ozlabs.org
To: andrea.gelmini@gelma.net
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-lb0-f194.google.com ([209.85.217.194]:35775 "EHLO
	mail-lb0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751641AbcEUMDo (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sat, 21 May 2016 08:03:44 -0400
Received: by mail-lb0-f194.google.com with SMTP id mx9so6877932lbb.2
        for <linux-crypto@vger.kernel.org>; Sat, 21 May 2016 05:03:44 -0700 (PDT)
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Signed-off-by: Andrea Gelmini <andrea.gelmini@gelma.net>
---
 arch/powerpc/crypto/aes-spe-regs.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/powerpc/crypto/aes-spe-regs.h b/arch/powerpc/crypto/aes-spe-regs.h
index 30d217b..2cc3a2c 100644
--- a/arch/powerpc/crypto/aes-spe-regs.h
+++ b/arch/powerpc/crypto/aes-spe-regs.h
@@ -18,7 +18,7 @@
 #define rLN r7	/* length of data to be processed			*/
 #define rIP r8	/* potiner to IV (CBC/CTR/XTS modes)			*/
 #define rKT r9	/* pointer to tweak key (XTS mode)			*/
-#define rT0 r11	/* pointers to en-/decrpytion tables			*/
+#define rT0 r11	/* pointers to en-/decryption tables			*/
 #define rT1 r10
 #define rD0 r9	/* data 						*/
 #define rD1 r14
-- 
2.8.2.534.g1f66975
