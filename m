From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 2/6] target/rd: always chain S/G list
Date: Fri,  7 Aug 2015 18:15:12 +0200
Message-ID: <1438964116-24321-3-git-send-email-hch@lst.de>
References: <1438964116-24321-1-git-send-email-hch@lst.de>
Cc: Dan Williams <dan.j.williams@intel.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:39244 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753697AbbHGQST (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 7 Aug 2015 12:18:19 -0400
In-Reply-To: <1438964116-24321-1-git-send-email-hch@lst.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

The rd sg lists are never passed to hardware, so use S/G chaining
unonditionally.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/target/target_core_rd.c | 44 -----------------------------------------
 1 file changed, 44 deletions(-)

diff --git a/drivers/target/target_core_rd.c b/drivers/target/target_core_rd.c
index 4703f40..badd927 100644
--- a/drivers/target/target_core_rd.c
+++ b/drivers/target/target_core_rd.c
@@ -138,16 +138,12 @@ static int rd_allocate_sgl_table(struct rd_dev *rd_dev, struct rd_dev_sg_table *
 		sg_per_table = (total_sg_needed > max_sg_per_table) ?
 			max_sg_per_table : total_sg_needed;
 
-#ifdef CONFIG_ARCH_HAS_SG_CHAIN
-
 		/*
 		 * Reserve extra element for chain entry
 		 */
 		if (sg_per_table < total_sg_needed)
 			chain_entry = 1;
 
-#endif /* CONFIG_ARCH_HAS_SG_CHAIN */
-
 		sg = kcalloc(sg_per_table + chain_entry, sizeof(*sg),
 				GFP_KERNEL);
 		if (!sg) {
@@ -158,15 +154,11 @@ static int rd_allocate_sgl_table(struct rd_dev *rd_dev, struct rd_dev_sg_table *
 
 		sg_init_table(sg, sg_per_table + chain_entry);
 
-#ifdef CONFIG_ARCH_HAS_SG_CHAIN
-
 		if (i > 0) {
 			sg_chain(sg_table[i - 1].sg_table,
 				 max_sg_per_table + 1, sg);
 		}
 
-#endif /* CONFIG_ARCH_HAS_SG_CHAIN */
-
 		sg_table[i].sg_table = sg;
 		sg_table[i].rd_sg_count = sg_per_table;
 		sg_table[i].page_start_offset = page_offset;
@@ -429,42 +421,6 @@ static sense_reason_t rd_do_prot_rw(struct se_cmd *cmd, bool is_read)
 	prot_sg = &prot_table->sg_table[prot_page -
 					prot_table->page_start_offset];
 
-#ifndef CONFIG_ARCH_HAS_SG_CHAIN
-
-	prot_npages = DIV_ROUND_UP(prot_offset + sectors * se_dev->prot_length,
-				   PAGE_SIZE);
-
-	/*
-	 * Allocate temporaly contiguous scatterlist entries if prot pages
-	 * straddles multiple scatterlist tables.
-	 */
-	if (prot_table->page_end_offset < prot_page + prot_npages - 1) {
-		int i;
-
-		prot_sg = kcalloc(prot_npages, sizeof(*prot_sg), GFP_KERNEL);
-		if (!prot_sg)
-			return TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE;
-
-		need_to_release = true;
-		sg_init_table(prot_sg, prot_npages);
-
-		for (i = 0; i < prot_npages; i++) {
-			if (prot_page + i > prot_table->page_end_offset) {
-				prot_table = rd_get_prot_table(dev,
-								prot_page + i);
-				if (!prot_table) {
-					kfree(prot_sg);
-					return rc;
-				}
-				sg_unmark_end(&prot_sg[i - 1]);
-			}
-			prot_sg[i] = prot_table->sg_table[prot_page + i -
-						prot_table->page_start_offset];
-		}
-	}
-
-#endif /* !CONFIG_ARCH_HAS_SG_CHAIN */
-
 	if (is_read)
 		rc = sbc_dif_verify(cmd, cmd->t_task_lba, sectors, 0,
 				    prot_sg, prot_offset);
-- 
1.9.1
