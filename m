From: Horia Geanta <horia.geanta@freescale.com>
Subject: [PATCH] crypto: caam - set DK (Decrypt Key) bit only for AES accelerator
Date: Fri, 11 Jul 2014 15:46:58 +0300
Message-ID: <1405082818-30267-1-git-send-email-horia.geanta@freescale.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: <linux-crypto@vger.kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Ruchika Gupta <ruchika.gupta@freescale.com>,
	Vakul Garg <vakul@freescale.com>,
	Kim Phillips <kim.phillips@freescale.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-bn1lp0142.outbound.protection.outlook.com ([207.46.163.142]:50816
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753637AbaGKNCU (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Fri, 11 Jul 2014 09:02:20 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

AES currently shares descriptor creation functions with DES and 3DES.
DK bit is set in all cases, however it is valid only for
the AES accelerator.

Signed-off-by: Horia Geanta <horia.geanta@freescale.com>
---
 drivers/crypto/caam/caamalg.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/crypto/caam/caamalg.c b/drivers/crypto/caam/caamalg.c
index 64c606d9e821..7848be88ea5a 100644
--- a/drivers/crypto/caam/caamalg.c
+++ b/drivers/crypto/caam/caamalg.c
@@ -97,6 +97,13 @@ static inline void append_dec_op1(u32 *desc, u32 type)
 {
 	u32 *jump_cmd, *uncond_jump_cmd;
 
+	/* DK bit is valid only for AES */
+	if ((type & OP_ALG_ALGSEL_MASK) != OP_ALG_ALGSEL_AES) {
+		append_operation(desc, type | OP_ALG_AS_INITFINAL |
+				 OP_ALG_DECRYPT);
+		return;
+	}
+
 	jump_cmd = append_jump(desc, JUMP_TEST_ALL | JUMP_COND_SHRD);
 	append_operation(desc, type | OP_ALG_AS_INITFINAL |
 			 OP_ALG_DECRYPT);
-- 
1.8.3.1
