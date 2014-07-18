From: Horia Geanta <horia.geanta@freescale.com>
Subject: [PATCH 2/9] crypto: caam - desc.h fixes
Date: Fri, 18 Jul 2014 19:37:19 +0300
Message-ID: <1405701446-13656-3-git-send-email-horia.geanta@freescale.com>
References: <1405701446-13656-1-git-send-email-horia.geanta@freescale.com>
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
Received: from mail-bn1lp0145.outbound.protection.outlook.com ([207.46.163.145]:24050
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932384AbaGRQiu (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Fri, 18 Jul 2014 12:38:50 -0400
In-Reply-To: <1405701446-13656-1-git-send-email-horia.geanta@freescale.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

1. fix HDR_START_IDX_MASK
Define HDR_START_IDX_MASK consistently with the other masks:
mask = bitmask << offset

2. fix FIFO_STORE output data type value for AFHA S-Box

3. fix OPERATION pkha modular arithmetic source mask

Signed-off-by: Horia Geanta <horia.geanta@freescale.com>
---
 drivers/crypto/caam/desc.h | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/crypto/caam/desc.h b/drivers/crypto/caam/desc.h
index d397ff9d56fd..7a58d6ee801d 100644
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
@@ -390,7 +390,7 @@ struct sec4_sg_entry {
 #define FIFOST_TYPE_PKHA_N	 (0x08 << FIFOST_TYPE_SHIFT)
 #define FIFOST_TYPE_PKHA_A	 (0x0c << FIFOST_TYPE_SHIFT)
 #define FIFOST_TYPE_PKHA_B	 (0x0d << FIFOST_TYPE_SHIFT)
-#define FIFOST_TYPE_AF_SBOX_JKEK (0x10 << FIFOST_TYPE_SHIFT)
+#define FIFOST_TYPE_AF_SBOX_JKEK (0x20 << FIFOST_TYPE_SHIFT)
 #define FIFOST_TYPE_AF_SBOX_TKEK (0x21 << FIFOST_TYPE_SHIFT)
 #define FIFOST_TYPE_PKHA_E_JKEK	 (0x22 << FIFOST_TYPE_SHIFT)
 #define FIFOST_TYPE_PKHA_E_TKEK	 (0x23 << FIFOST_TYPE_SHIFT)
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
