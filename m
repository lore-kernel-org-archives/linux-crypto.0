From: Russell King <rmk+kernel@arm.linux.org.uk>
Subject: [PATCH RFC 02/11] crypto: caam: ensure descriptor buffers are
 cacheline aligned
Date: Mon, 07 Dec 2015 19:12:05 +0000
Message-ID: <E1a61Cf-0007mM-AU@rmk-PC.arm.linux.org.uk>
References: <20151207191134.GV8644@n2100.arm.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Cc: "David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org
To: Fabio Estevam <fabio.estevam@freescale.com>,
	Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from pandora.arm.linux.org.uk ([78.32.30.218]:60508 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932328AbbLGTML (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 7 Dec 2015 14:12:11 -0500
In-Reply-To: <20151207191134.GV8644@n2100.arm.linux.org.uk>
Content-Disposition: inline
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
---
 drivers/crypto/caam/caamhash.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/crypto/caam/caamhash.c b/drivers/crypto/caam/caamhash.c
index eccde7207f92..6a6d74f38300 100644
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
