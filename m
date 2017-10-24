From: =?UTF-8?q?Horia=20Geant=C4=83?= <horia.geanta@nxp.com>
Subject: [PATCH] crypto: caam - fix incorrect define
Date: Tue, 24 Oct 2017 09:27:30 +0300
Message-ID: <20171024062731.28070-1-horia.geanta@nxp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Cc: "David S. Miller" <davem@davemloft.net>,
        Dan Douglass <dan.douglass@nxp.com>,
        <linux-crypto@vger.kernel.org>, Radu Alexe <radu.alexe@nxp.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-cys01nam02on0047.outbound.protection.outlook.com ([104.47.37.47]:10688
        "EHLO NAM02-CY1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751646AbdJXG2E (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 24 Oct 2017 02:28:04 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

From: Radu Alexe <radu.alexe@nxp.com>

Fixes: 3ebfa92f49a6 ("crypto: caam - Add new macros for building extended SEC descriptors (> 64 words)")
Signed-off-by: Radu Alexe <radu.alexe@nxp.com>
Signed-off-by: Horia Geantă <horia.geanta@nxp.com>
---
 drivers/crypto/caam/desc.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/caam/desc.h b/drivers/crypto/caam/desc.h
index 2e6766a1573f..2386d3e2d2c9 100644
--- a/drivers/crypto/caam/desc.h
+++ b/drivers/crypto/caam/desc.h
@@ -1439,7 +1439,7 @@
 #define MATH_SRC1_REG2		(0x02 << MATH_SRC1_SHIFT)
 #define MATH_SRC1_REG3		(0x03 << MATH_SRC1_SHIFT)
 #define MATH_SRC1_IMM		(0x04 << MATH_SRC1_SHIFT)
-#define MATH_SRC1_DPOVRD	(0x07 << MATH_SRC0_SHIFT)
+#define MATH_SRC1_DPOVRD	(0x07 << MATH_SRC1_SHIFT)
 #define MATH_SRC1_INFIFO	(0x0a << MATH_SRC1_SHIFT)
 #define MATH_SRC1_OUTFIFO	(0x0b << MATH_SRC1_SHIFT)
 #define MATH_SRC1_ONE		(0x0c << MATH_SRC1_SHIFT)
-- 
2.12.0.264.gd6db3f216544
