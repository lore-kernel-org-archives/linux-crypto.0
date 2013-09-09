From: Alex Porosanu <alexandru.porosanu@freescale.com>
Subject: [PATCH 6/7] crypto: caam - fix RNG4 AAI defines
Date: Mon, 9 Sep 2013 18:56:33 +0300
Message-ID: <1378742194-32194-7-git-send-email-alexandru.porosanu@freescale.com>
References: <1378742194-32194-1-git-send-email-alexandru.porosanu@freescale.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: <herbert@gondor.hengli.com.au>, <horia.geanta@freescale.com>,
	<vakul@freescale.com>
To: <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-db8lp0189.outbound.messaging.microsoft.com ([213.199.154.189]:1830
	"EHLO db8outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754067Ab3IIP7c (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 9 Sep 2013 11:59:32 -0400
In-Reply-To: <1378742194-32194-1-git-send-email-alexandru.porosanu@freescale.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

RNG4 defines in desc.h were incomplete (bits AI & PS were missing),
while SK was set as an ALG related bit. This patchs adds the
missing bits and corrects the SK bit.

Signed-off-by: Alex Porosanu <alexandru.porosanu@freescale.com>
---
 drivers/crypto/caam/ctrl.c |    2 +-
 drivers/crypto/caam/desc.h |   17 +++++++++--------
 2 files changed, 10 insertions(+), 9 deletions(-)

diff --git a/drivers/crypto/caam/ctrl.c b/drivers/crypto/caam/ctrl.c
index 9e9215a..29cbec1 100644
--- a/drivers/crypto/caam/ctrl.c
+++ b/drivers/crypto/caam/ctrl.c
@@ -39,7 +39,7 @@ static void build_instantiation_desc(u32 *desc)
 
 	/* generate secure keys (non-test) */
 	append_operation(desc, OP_TYPE_CLASS1_ALG | OP_ALG_ALGSEL_RNG |
-			 OP_ALG_RNG4_SK);
+			 OP_ALG_AAI_RNG4_SK);
 
 	append_jump(desc, JUMP_CLASS_CLASS1 | JUMP_TYPE_HALT);
 }
diff --git a/drivers/crypto/caam/desc.h b/drivers/crypto/caam/desc.h
index 53b296f..7e4500f 100644
--- a/drivers/crypto/caam/desc.h
+++ b/drivers/crypto/caam/desc.h
@@ -1155,8 +1155,15 @@ struct sec4_sg_entry {
 
 /* randomizer AAI set */
 #define OP_ALG_AAI_RNG		(0x00 << OP_ALG_AAI_SHIFT)
-#define OP_ALG_AAI_RNG_NOZERO	(0x10 << OP_ALG_AAI_SHIFT)
-#define OP_ALG_AAI_RNG_ODD	(0x20 << OP_ALG_AAI_SHIFT)
+#define OP_ALG_AAI_RNG_NZB	(0x10 << OP_ALG_AAI_SHIFT)
+#define OP_ALG_AAI_RNG_OBP	(0x20 << OP_ALG_AAI_SHIFT)
+
+/* RNG4 AAI set */
+#define OP_ALG_AAI_RNG4_SH_0	(0x00 << OP_ALG_AAI_SHIFT)
+#define OP_ALG_AAI_RNG4_SH_1	(0x01 << OP_ALG_AAI_SHIFT)
+#define OP_ALG_AAI_RNG4_PS	(0x40 << OP_ALG_AAI_SHIFT)
+#define OP_ALG_AAI_RNG4_AI	(0x80 << OP_ALG_AAI_SHIFT)
+#define OP_ALG_AAI_RNG4_SK	(0x100 << OP_ALG_AAI_SHIFT)
 
 /* hmac/smac AAI set */
 #define OP_ALG_AAI_HASH		(0x00 << OP_ALG_AAI_SHIFT)
@@ -1178,12 +1185,6 @@ struct sec4_sg_entry {
 #define OP_ALG_AAI_GSM		(0x10 << OP_ALG_AAI_SHIFT)
 #define OP_ALG_AAI_EDGE		(0x20 << OP_ALG_AAI_SHIFT)
 
-/* RNG4 set */
-#define OP_ALG_RNG4_SHIFT	4
-#define OP_ALG_RNG4_MASK	(0x1f3 << OP_ALG_RNG4_SHIFT)
-
-#define OP_ALG_RNG4_SK		(0x100 << OP_ALG_RNG4_SHIFT)
-
 #define OP_ALG_AS_SHIFT		2
 #define OP_ALG_AS_MASK		(0x3 << OP_ALG_AS_SHIFT)
 #define OP_ALG_AS_UPDATE	(0 << OP_ALG_AS_SHIFT)
-- 
1.7.7.6
