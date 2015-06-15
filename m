From: Victoria Milhoan <vicki.milhoan@freescale.com>
Subject: [PATCH RFC 04/11] crypto: caam - Modify Freescale CAAM driver Scatter Gather entry definition
Date: Mon, 15 Jun 2015 16:52:52 -0700
Message-ID: <1434412379-11623-5-git-send-email-vicki.milhoan@freescale.com>
References: <1434412379-11623-1-git-send-email-vicki.milhoan@freescale.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: <herbert@gondor.apana.org.au>, <horia.geanta@freescale.com>,
	<ruchika.gupta@freescale.com>
To: <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-bl2on0142.outbound.protection.outlook.com ([65.55.169.142]:38728
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751789AbbFOXxO (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Mon, 15 Jun 2015 19:53:14 -0400
In-Reply-To: <1434412379-11623-1-git-send-email-vicki.milhoan@freescale.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Modify the Scatter-Gather entry definitions for the Freescale
CAAM driver.

Signed-off-by: Victoria Milhoan <vicki.milhoan@freescale.com>
---
 drivers/crypto/caam/desc.h | 24 ++++++++++++++++++++----
 1 file changed, 20 insertions(+), 4 deletions(-)

diff --git a/drivers/crypto/caam/desc.h b/drivers/crypto/caam/desc.h
index d397ff9..67e3c89 100644
--- a/drivers/crypto/caam/desc.h
+++ b/drivers/crypto/caam/desc.h
@@ -8,13 +8,29 @@
 #ifndef DESC_H
 #define DESC_H
 
+/*
+ * 16-byte hardware scatter/gather table
+ * An 8-byte table exists in the hardware spec, but has never been
+ * implemented to date. The 8/16 option is selected at RTL-compile-time.
+ * and this selection is visible in the Compile Time Parameters Register
+ */
+
+#define SEC4_SG_LEN_EXT		0x80000000	/* Entry points to table */
+#define SEC4_SG_LEN_FIN		0x40000000	/* Last ent in table */
+#define SEC4_SG_BPID_MASK	0x000000ff
+#define SEC4_SG_BPID_SHIFT	16
+#define SEC4_SG_LEN_MASK	0x3fffffff	/* Excludes EXT and FINAL */
+#define SEC4_SG_OFFS_MASK	0x00001fff
+
 struct sec4_sg_entry {
+#ifdef CONFIG_64BIT
 	u64 ptr;
-#define SEC4_SG_LEN_FIN 0x40000000
-#define SEC4_SG_LEN_EXT 0x80000000
+#else
+	u32 reserved;
+	u32 ptr;
+#endif
 	u32 len;
-	u8 reserved;
-	u8 buf_pool_id;
+	u16 buf_pool_id;
 	u16 offset;
 };
 
-- 
2.1.4
