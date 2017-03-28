From: Gary R Hook <gary.hook@amd.com>
Subject: [PATCH V2] crypto: ccp - Rearrange structure members to minimize
 size
Date: Tue, 28 Mar 2017 10:57:26 -0500
Message-ID: <20170328155725.9578.85077.stgit@taos>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: <thomas.lendacky@amd.com>, <gary.hook@amd.com>,
        <herbert@gondor.apana.org.au>, <arnd@arndb.de>,
        <davem@davemloft.net>
To: <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-co1nam03on0080.outbound.protection.outlook.com ([104.47.40.80]:16000
        "EHLO NAM03-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752545AbdC1P5t (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 28 Mar 2017 11:57:49 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

The AES GCM function (in ccp-ops) requires a fair amount of
stack space, which elicits a complaint when KASAN is enabled.
Rearranging and packing a few structures eliminates the
warning.

Signed-off-by: Gary R Hook <gary.hook@amd.com>
---
 drivers/crypto/ccp/ccp-dev.h |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/crypto/ccp/ccp-dev.h b/drivers/crypto/ccp/ccp-dev.h
index 3a45c2a..191274d 100644
--- a/drivers/crypto/ccp/ccp-dev.h
+++ b/drivers/crypto/ccp/ccp-dev.h
@@ -427,33 +427,33 @@ enum ccp_memtype {
 };
 #define	CCP_MEMTYPE_LSB	CCP_MEMTYPE_KSB
 
+
 struct ccp_dma_info {
 	dma_addr_t address;
 	unsigned int offset;
 	unsigned int length;
 	enum dma_data_direction dir;
-};
+} __packed __aligned(4);
 
 struct ccp_dm_workarea {
 	struct device *dev;
 	struct dma_pool *dma_pool;
-	unsigned int length;
 
 	u8 *address;
 	struct ccp_dma_info dma;
+	unsigned int length;
 };
 
 struct ccp_sg_workarea {
 	struct scatterlist *sg;
 	int nents;
+	unsigned int sg_used;
 
 	struct scatterlist *dma_sg;
 	struct device *dma_dev;
 	unsigned int dma_count;
 	enum dma_data_direction dma_dir;
 
-	unsigned int sg_used;
-
 	u64 bytes_left;
 };
 
