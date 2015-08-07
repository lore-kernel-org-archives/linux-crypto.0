From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 1/6] scatterlist: allow limited chaining without ARCH_HAS_SG_CHAIN
Date: Fri,  7 Aug 2015 18:15:11 +0200
Message-ID: <1438964116-24321-2-git-send-email-hch@lst.de>
References: <1438964116-24321-1-git-send-email-hch@lst.de>
Cc: Dan Williams <dan.j.williams@intel.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:39239 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753659AbbHGQST (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 7 Aug 2015 12:18:19 -0400
In-Reply-To: <1438964116-24321-1-git-send-email-hch@lst.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

There are a couple of uses of struct scatterlist that never go to
the dma_map_sg() helper and thus don't care about ARCH_HAS_SG_CHAIN
which indicates that we can map chained S/G list.

The most important one is the crypto code, which currently has
to open code a few helpers to always allow chaining.  This patch
removes a few #ifdef ARCH_HAS_SG_CHAIN statements so that we can
switch the crypto code to these common helpers.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 include/linux/scatterlist.h | 4 ----
 lib/scatterlist.c           | 4 ----
 2 files changed, 8 deletions(-)

diff --git a/include/linux/scatterlist.h b/include/linux/scatterlist.h
index 9b1ef0c..698e906 100644
--- a/include/linux/scatterlist.h
+++ b/include/linux/scatterlist.h
@@ -161,10 +161,6 @@ static inline void sg_set_buf(struct scatterlist *sg, const void *buf,
 static inline void sg_chain(struct scatterlist *prv, unsigned int prv_nents,
 			    struct scatterlist *sgl)
 {
-#ifndef CONFIG_ARCH_HAS_SG_CHAIN
-	BUG();
-#endif
-
 	/*
 	 * offset and length are unused for chain entry.  Clear them.
 	 */
diff --git a/lib/scatterlist.c b/lib/scatterlist.c
index d105a9f..bafa993 100644
--- a/lib/scatterlist.c
+++ b/lib/scatterlist.c
@@ -105,16 +105,12 @@ EXPORT_SYMBOL(sg_nents_for_len);
  **/
 struct scatterlist *sg_last(struct scatterlist *sgl, unsigned int nents)
 {
-#ifndef CONFIG_ARCH_HAS_SG_CHAIN
-	struct scatterlist *ret = &sgl[nents - 1];
-#else
 	struct scatterlist *sg, *ret = NULL;
 	unsigned int i;
 
 	for_each_sg(sgl, sg, nents, i)
 		ret = sg;
 
-#endif
 #ifdef CONFIG_DEBUG_SG
 	BUG_ON(sgl[0].sg_magic != SG_MAGIC);
 	BUG_ON(!sg_is_last(ret));
-- 
1.9.1
