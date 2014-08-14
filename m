From: Horia Geanta <horia.geanta@freescale.com>
Subject: [PATCH v2 04/12] crypto: caam - move sec4_sg_entry to sg_sw_sec4.h
Date: Thu, 14 Aug 2014 15:54:26 +0300
Message-ID: <1408020874-2211-5-git-send-email-horia.geanta@freescale.com>
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
Received: from mail-bn1lp0139.outbound.protection.outlook.com ([207.46.163.139]:7512
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754520AbaHNM4B (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Thu, 14 Aug 2014 08:56:01 -0400
In-Reply-To: <1408020874-2211-1-git-send-email-horia.geanta@freescale.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

sec4_sg_entry structure is used only by helper functions in sg_sw_sec4.h.
Since SEC HW S/G entries are to be manipulated only indirectly, via these
functions, move sec4_sg_entry to the corresponding header.

Signed-off-by: Horia Geanta <horia.geanta@freescale.com>
---
 drivers/crypto/caam/desc.h       | 10 ----------
 drivers/crypto/caam/sg_sw_sec4.h | 10 +++++++++-
 2 files changed, 9 insertions(+), 11 deletions(-)

diff --git a/drivers/crypto/caam/desc.h b/drivers/crypto/caam/desc.h
index f891a67c4786..eb8b870d03a9 100644
--- a/drivers/crypto/caam/desc.h
+++ b/drivers/crypto/caam/desc.h
@@ -8,16 +8,6 @@
 #ifndef DESC_H
 #define DESC_H
 
-struct sec4_sg_entry {
-	u64 ptr;
-#define SEC4_SG_LEN_FIN 0x40000000
-#define SEC4_SG_LEN_EXT 0x80000000
-	u32 len;
-	u8 reserved;
-	u8 buf_pool_id;
-	u16 offset;
-};
-
 /* Max size of any CAAM descriptor in 32-bit words, inclusive of header */
 #define MAX_CAAM_DESCSIZE	64
 
diff --git a/drivers/crypto/caam/sg_sw_sec4.h b/drivers/crypto/caam/sg_sw_sec4.h
index a6e5b94756d4..e6fa2c226b8f 100644
--- a/drivers/crypto/caam/sg_sw_sec4.h
+++ b/drivers/crypto/caam/sg_sw_sec4.h
@@ -5,7 +5,15 @@
  *
  */
 
-struct sec4_sg_entry;
+struct sec4_sg_entry {
+	u64 ptr;
+#define SEC4_SG_LEN_FIN 0x40000000
+#define SEC4_SG_LEN_EXT 0x80000000
+	u32 len;
+	u8 reserved;
+	u8 buf_pool_id;
+	u16 offset;
+};
 
 /*
  * convert single dma address to h/w link table format
-- 
1.8.3.1
