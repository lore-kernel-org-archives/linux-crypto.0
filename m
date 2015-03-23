From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH] crypto/arm: fix big-endian bug in ghash
Date: Mon, 23 Mar 2015 21:33:09 +0100
Message-ID: <1427142789-13960-1-git-send-email-ard.biesheuvel@linaro.org>
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>
To: herbert@gondor.apana.org.au, linux-crypto@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wi0-f175.google.com ([209.85.212.175]:35392 "EHLO
	mail-wi0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752603AbbCWUdQ (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 23 Mar 2015 16:33:16 -0400
Received: by wibdy8 with SMTP id dy8so57814741wib.0
        for <linux-crypto@vger.kernel.org>; Mon, 23 Mar 2015 13:33:14 -0700 (PDT)
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

This fixes a bug in the new v8 Crypto Extensions GHASH code
that only manifests itself in big-endian mode.

Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 arch/arm/crypto/ghash-ce-core.S | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/crypto/ghash-ce-core.S b/arch/arm/crypto/ghash-ce-core.S
index e643a15eadf2..f6ab8bcc9efe 100644
--- a/arch/arm/crypto/ghash-ce-core.S
+++ b/arch/arm/crypto/ghash-ce-core.S
@@ -40,7 +40,7 @@
 	 *			   struct ghash_key const *k, const char *head)
 	 */
 ENTRY(pmull_ghash_update)
-	vld1.8		{SHASH}, [r3]
+	vld1.64		{SHASH}, [r3]
 	vld1.64		{XL}, [r1]
 	vmov.i8		MASK, #0xe1
 	vext.8		SHASH2, SHASH, SHASH, #8
-- 
1.8.3.2
