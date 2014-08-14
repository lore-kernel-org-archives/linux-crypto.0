From: Horia Geanta <horia.geanta@freescale.com>
Subject: [PATCH v2 02/12] crypto: caam - desc.h fixes
Date: Thu, 14 Aug 2014 15:54:24 +0300
Message-ID: <1408020874-2211-3-git-send-email-horia.geanta@freescale.com>
References: <1408020874-2211-1-git-send-email-horia.geanta@freescale.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: "David S. Miller" <davem@davemloft.net>,
	Carmen Iorga <carmen.iorga@freescale.com>,
	Kim Phillips <kim.phillips@freescale.com>,
	Alexandru Porosanu <alexandru.porosanu@freescale.com>,
	Vakul Garg <vakul@freescale.com>,
	Ruchika Gupta <ruchika.gupta@freescale.com>,
	"Horia Geanta" <horia.geanta@freescale.com>
To: Herbert Xu <herbert@gondor.apana.org.au>,
	<linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-bl2lp0204.outbound.protection.outlook.com ([207.46.163.204]:51987
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754819AbaHNM4L (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Thu, 14 Aug 2014 08:56:11 -0400
In-Reply-To: <1408020874-2211-1-git-send-email-horia.geanta@freescale.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

1. fix HDR_START_IDX_MASK, HDR_SD_SHARE_MASK, HDR_JD_SHARE_MASK
Define HDR_START_IDX_MASK consistently with the other masks:
mask = bitmask << offset

2. OP_ALG_TYPE_CLASS1 and OP_ALG_TYPE_CLASS2 must be shifted.

3. fix FIFO_STORE output data type value for AFHA S-Box

4. fix OPERATION pkha modular arithmetic source mask

5. rename LDST_SRCDST_WORD_CLASS1_ICV_SZ to
LDST_SRCDST_WORD_CLASS1_IV_SZ (it refers to IV, not ICV).

Signed-off-by: Horia Geanta <horia.geanta@freescale.com>
---
 drivers/crypto/caam/desc.h | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/crypto/caam/desc.h b/drivers/crypto/caam/desc.h
index d397ff9d56fd..f891a67c4786 100644
--- a/drivers/crypto/caam/desc.h
+++ b/drivers/crypto/caam/desc.h
@@ -80,8 +80,8 @@ struct sec4_sg_entry {
 #define HDR_ZRO			0x00008000
 
 /* Start Index or SharedDesc Length */
-#define HDR_START_IDX_MASK	0x3f
 #define HDR_START_IDX_SHIFT	16
+#define HDR_START_IDX_MASK	(0x3f << HDR_START_IDX_SHIFT)
 
 /* If shared descriptor header, 6-bit length */
 #define HDR_DESCLEN_SHR_MASK	0x3f
@@ -111,10 +111,10 @@ struct sec4_sg_entry {
 #define HDR_PROP_DNR		0x00000800
 
 /* JobDesc/SharedDesc share property */
-#define HDR_SD_SHARE_MASK	0x03
 #define HDR_SD_SHARE_SHIFT	8
-#define HDR_JD_SHARE_MASK	0x07
+#define HDR_SD_SHARE_MASK	(0x03 << HDR_SD_SHARE_SHIFT)
 #define HDR_JD_SHARE_SHIFT	8
+#define HDR_JD_SHARE_MASK	(0x07 << HDR_JD_SHARE_SHIFT)
 
 #define HDR_SHARE_NEVER		(0x00 << HDR_SD_SHARE_SHIFT)
 #define HDR_SHARE_WAIT		(0x01 << HDR_SD_SHARE_SHIFT)
@@ -225,7 +225,7 @@ struct sec4_sg_entry {
 #define LDST_SRCDST_WORD_DECO_MATH2	(0x0a << LDST_SRCDST_SHIFT)
 #define LDST_SRCDST_WORD_DECO_AAD_SZ	(0x0b << LDST_SRCDST_SHIFT)
 #define LDST_SRCDST_WORD_DECO_MATH3	(0x0b << LDST_SRCDST_SHIFT)
-#define LDST_SRCDST_WORD_CLASS1_ICV_SZ	(0x0c << LDST_SRCDST_SHIFT)
+#define LDST_SRCDST_WORD_CLASS1_IV_SZ	(0x0c << LDST_SRCDST_SHIFT)
 #define LDST_SRCDST_WORD_ALTDS_CLASS1	(0x0f << LDST_SRCDST_SHIFT)
 #define LDST_SRCDST_WORD_PKHA_A_SZ	(0x10 << LDST_SRCDST_SHIFT)
 #define LDST_SRCDST_WORD_PKHA_B_SZ	(0x11 << LDST_SRCDST_SHIFT)
@@ -390,7 +390,7 @@ struct sec4_sg_entry {
 #define FIFOST_TYPE_PKHA_N	 (0x08 << FIFOST_TYPE_SHIFT)
 #define FIFOST_TYPE_PKHA_A	 (0x0c << FIFOST_TYPE_SHIFT)
 #define FIFOST_TYPE_PKHA_B	 (0x0d << FIFOST_TYPE_SHIFT)
-#define FIFOST_TYPE_AF_SBOX_JKEK (0x10 << FIFOST_TYPE_SHIFT)
+#define FIFOST_TYPE_AF_SBOX_JKEK (0x20 << FIFOST_TYPE_SHIFT)
 #define FIFOST_TYPE_AF_SBOX_TKEK (0x21 << FIFOST_TYPE_SHIFT)
 #define FIFOST_TYPE_PKHA_E_JKEK	 (0x22 << FIFOST_TYPE_SHIFT)
 #define FIFOST_TYPE_PKHA_E_TKEK	 (0x23 << FIFOST_TYPE_SHIFT)
@@ -1095,8 +1095,8 @@ struct sec4_sg_entry {
 /* For non-protocol/alg-only op commands */
 #define OP_ALG_TYPE_SHIFT	24
 #define OP_ALG_TYPE_MASK	(0x7 << OP_ALG_TYPE_SHIFT)
-#define OP_ALG_TYPE_CLASS1	2
-#define OP_ALG_TYPE_CLASS2	4
+#define OP_ALG_TYPE_CLASS1	(2 << OP_ALG_TYPE_SHIFT)
+#define OP_ALG_TYPE_CLASS2	(4 << OP_ALG_TYPE_SHIFT)
 
 #define OP_ALG_ALGSEL_SHIFT	16
 #define OP_ALG_ALGSEL_MASK	(0xff << OP_ALG_ALGSEL_SHIFT)
@@ -1237,7 +1237,7 @@ struct sec4_sg_entry {
 #define OP_ALG_PKMODE_MOD_PRIMALITY	0x00f
 
 /* PKHA mode copy-memory functions */
-#define OP_ALG_PKMODE_SRC_REG_SHIFT	13
+#define OP_ALG_PKMODE_SRC_REG_SHIFT	17
 #define OP_ALG_PKMODE_SRC_REG_MASK	(7 << OP_ALG_PKMODE_SRC_REG_SHIFT)
 #define OP_ALG_PKMODE_DST_REG_SHIFT	10
 #define OP_ALG_PKMODE_DST_REG_MASK	(7 << OP_ALG_PKMODE_DST_REG_SHIFT)
-- 
1.8.3.1
