From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 4/6] scatterlist: remove open coded sg_unmark_end instances
Date: Fri,  7 Aug 2015 18:15:14 +0200
Message-ID: <1438964116-24321-5-git-send-email-hch@lst.de>
References: <1438964116-24321-1-git-send-email-hch@lst.de>
Cc: Dan Williams <dan.j.williams@intel.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1438964116-24321-1-git-send-email-hch@lst.de>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

From: Dan Williams <dan.j.williams@intel.com>

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
[hch: split from a larger patch by Dan]
Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 block/blk-merge.c        | 2 +-
 drivers/mmc/card/queue.c | 4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/block/blk-merge.c b/block/blk-merge.c
index 30a0d9f..f4a3e87 100644
--- a/block/blk-merge.c
+++ b/block/blk-merge.c
@@ -266,7 +266,7 @@ int blk_rq_map_sg(struct request_queue *q, struct request *rq,
 		if (rq->cmd_flags & REQ_WRITE)
 			memset(q->dma_drain_buffer, 0, q->dma_drain_size);
 
-		sg->page_link &= ~0x02;
+		sg_unmark_end(sg);
 		sg = sg_next(sg);
 		sg_set_page(sg, virt_to_page(q->dma_drain_buffer),
 			    q->dma_drain_size,
diff --git a/drivers/mmc/card/queue.c b/drivers/mmc/card/queue.c
index b5a2b14..9b214da 100644
--- a/drivers/mmc/card/queue.c
+++ b/drivers/mmc/card/queue.c
@@ -467,7 +467,7 @@ static unsigned int mmc_queue_packed_map_sg(struct mmc_queue *mq,
 			sg_set_buf(__sg, buf + offset, len);
 			offset += len;
 			remain -= len;
-			(__sg++)->page_link &= ~0x02;
+			sg_unmark_end(__sg++);
 			sg_len++;
 		} while (remain);
 	}
@@ -475,7 +475,7 @@ static unsigned int mmc_queue_packed_map_sg(struct mmc_queue *mq,
 	list_for_each_entry(req, &packed->list, queuelist) {
 		sg_len += blk_rq_map_sg(mq->queue, req, __sg);
 		__sg = sg + (sg_len - 1);
-		(__sg++)->page_link &= ~0x02;
+		sg_unmark_end(__sg++);
 	}
 	sg_mark_end(sg + (sg_len - 1));
 	return sg_len;
-- 
1.9.1
