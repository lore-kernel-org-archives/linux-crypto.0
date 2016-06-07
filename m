From: Baolin Wang <baolin.wang@linaro.org>
Subject: [RFC v4 1/4] block: Introduce blk_bio_map_sg() to map one bio
Date: Tue,  7 Jun 2016 20:17:04 +0800
Message-ID: <311c342ac55d36ab03e44c31dc65ebfa24cbc8aa.1465301616.git.baolin.wang@linaro.org>
References: <cover.1465301616.git.baolin.wang@linaro.org>
Cc: ebiggers3@gmail.com, js1304@gmail.com, tadeusz.struk@intel.com,
	smueller@chronox.de, standby24x7@gmail.com, shli@kernel.org,
	dan.j.williams@intel.com, martin.petersen@oracle.com,
	sagig@mellanox.com, kent.overstreet@gmail.com,
	keith.busch@intel.com, tj@kernel.org, ming.lei@canonical.com,
	broonie@kernel.org, arnd@arndb.de, linux-crypto@vger.kernel.org,
	linux-block@vger.kernel.org, linux-raid@vger.kernel.org,
	linux-kernel@vger.kernel.org, baolin.wang@linaro.org
To: axboe@kernel.dk, agk@redhat.com, snitzer@redhat.com,
	dm-devel@redhat.com, herbert@gondor.apana.org.au,
	davem@davemloft.net
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <cover.1465301616.git.baolin.wang@linaro.org>
In-Reply-To: <cover.1465301616.git.baolin.wang@linaro.org>
References: <cover.1465301616.git.baolin.wang@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

In dm-crypt, it need to map one bio to scatterlist for improving the
hardware engine encryption efficiency. Thus this patch introduces the
blk_bio_map_sg() function to map one bio with scatterlists.

Signed-off-by: Baolin Wang <baolin.wang@linaro.org>
---
 block/blk-merge.c      |   19 +++++++++++++++++++
 include/linux/blkdev.h |    2 ++
 2 files changed, 21 insertions(+)

diff --git a/block/blk-merge.c b/block/blk-merge.c
index 2613531..bca0609 100644
--- a/block/blk-merge.c
+++ b/block/blk-merge.c
@@ -417,6 +417,25 @@ single_segment:
 }
 
 /*
+ * Map a bio to scatterlist, return number of sg entries setup. Caller must
+ * make sure sg can hold bio segments entries and detach the bio from list.
+ */
+int blk_bio_map_sg(struct request_queue *q, struct bio *bio,
+		   struct scatterlist *sglist)
+{
+	struct scatterlist *sg = NULL;
+	int nsegs;
+
+	nsegs = __blk_bios_map_sg(q, bio, sglist, &sg);
+
+	if (sg)
+		sg_mark_end(sg);
+
+	return nsegs;
+}
+EXPORT_SYMBOL(blk_bio_map_sg);
+
+/*
  * map a request to scatterlist, return number of sg entries setup. Caller
  * must make sure sg can hold rq->nr_phys_segments entries
  */
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 3d9cf32..cbe31f9 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -1024,6 +1024,8 @@ extern void blk_queue_write_cache(struct request_queue *q, bool enabled, bool fu
 extern struct backing_dev_info *blk_get_backing_dev_info(struct block_device *bdev);
 
 extern int blk_rq_map_sg(struct request_queue *, struct request *, struct scatterlist *);
+extern int blk_bio_map_sg(struct request_queue *q, struct bio *bio,
+			  struct scatterlist *sglist);
 extern void blk_dump_rq_flags(struct request *, char *);
 extern long nr_blockdev_pages(void);
 
-- 
1.7.9.5
