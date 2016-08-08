From: Russell King <rmk+kernel@arm.linux.org.uk>
Subject: [PATCH 02/11] crypto: caam: ensure descriptor buffers are cacheline
 aligned
Date: Mon, 08 Aug 2016 18:04:36 +0100
Message-ID: <E1bWnye-0002VD-UI@rmk-PC.armlinux.org.uk>
References: <20160808170400.GC1041@n2100.armlinux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Cc: "David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org
To: Fabio Estevam <fabio.estevam@freescale.com>,
	Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from pandora.armlinux.org.uk ([78.32.30.218]:57474 "EHLO
	pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752152AbcHHREm (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 8 Aug 2016 13:04:42 -0400
In-Reply-To: <20160808170400.GC1041@n2100.armlinux.org.uk>
Content-Disposition: inline
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
---
 drivers/crypto/caam/caamhash.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/crypto/caam/caamhash.c b/drivers/crypto/caam/caamhash.c
index 85c8b048bdc1..47ea7b428156 100644
--- a/drivers/crypto/caam/caamhash.c
+++ b/drivers/crypto/caam/caamhash.c
@@ -99,17 +99,17 @@ static struct list_head hash_list;
 
 /* ahash per-session context */
 struct caam_hash_ctx {
-	struct device *jrdev;
-	u32 sh_desc_update[DESC_HASH_MAX_USED_LEN];
-	u32 sh_desc_update_first[DESC_HASH_MAX_USED_LEN];
-	u32 sh_desc_fin[DESC_HASH_MAX_USED_LEN];
-	u32 sh_desc_digest[DESC_HASH_MAX_USED_LEN];
-	u32 sh_desc_finup[DESC_HASH_MAX_USED_LEN];
-	dma_addr_t sh_desc_update_dma;
+	u32 sh_desc_update[DESC_HASH_MAX_USED_LEN] ____cacheline_aligned;
+	u32 sh_desc_update_first[DESC_HASH_MAX_USED_LEN] ____cacheline_aligned;
+	u32 sh_desc_fin[DESC_HASH_MAX_USED_LEN] ____cacheline_aligned;
+	u32 sh_desc_digest[DESC_HASH_MAX_USED_LEN] ____cacheline_aligned;
+	u32 sh_desc_finup[DESC_HASH_MAX_USED_LEN] ____cacheline_aligned;
+	dma_addr_t sh_desc_update_dma ____cacheline_aligned;
 	dma_addr_t sh_desc_update_first_dma;
 	dma_addr_t sh_desc_fin_dma;
 	dma_addr_t sh_desc_digest_dma;
 	dma_addr_t sh_desc_finup_dma;
+	struct device *jrdev;
 	u32 alg_type;
 	u32 alg_op;
 	u8 key[CAAM_MAX_HASH_KEY_SIZE];
-- 
2.1.0
