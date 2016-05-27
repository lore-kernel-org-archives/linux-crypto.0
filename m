From: Baolin Wang <baolin.wang@linaro.org>
Subject: [RFC v2 1/3] block: Introduce blk_bio_map_sg() to map one bio
Date: Fri, 27 May 2016 19:11:22 +0800
Message-ID: <2f0f6811938dafd14c6c7b1dbe8fbabfdcbb19c1.1464346333.git.baolin.wang@linaro.org>
References: <cover.1464346333.git.baolin.wang@linaro.org>
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
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-pa0-f48.google.com ([209.85.220.48]:35115 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753491AbcE0LMH (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 27 May 2016 07:12:07 -0400
Received: by mail-pa0-f48.google.com with SMTP id fy7so22880487pac.2
        for <linux-crypto@vger.kernel.org>; Fri, 27 May 2016 04:12:01 -0700 (PDT)
In-Reply-To: <cover.1464346333.git.baolin.wang@linaro.org>
In-Reply-To: <cover.1464346333.git.baolin.wang@linaro.org>
References: <cover.1464346333.git.baolin.wang@linaro.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

In dm-crypt, it need to map one bio to scatterlist for improving the
hardware engine encryption efficiency. Thus this patch introduces the
blk_bio_map_sg() function to map one bio with scatterlists.

For avoiding the duplicated code in __blk_bios_map_sg() function, add
one parameter to distinguish bio map or request map.

Signed-off-by: Baolin Wang <baolin.wang@linaro.org>
---
 block/blk-merge.c      |   36 +++++++++++++++++++++++++++++++-----
 include/linux/blkdev.h |    2 ++
 2 files changed, 33 insertions(+), 5 deletions(-)

diff --git a/block/blk-merge.c b/block/blk-merge.c
index 2613531..badae44 100644
--- a/block/blk-merge.c
+++ b/block/blk-merge.c
@@ -376,7 +376,7 @@ new_segment:
 
 static int __blk_bios_map_sg(struct request_queue *q, struct bio *bio,
 			     struct scatterlist *sglist,
-			     struct scatterlist **sg)
+			     struct scatterlist **sg, bool single_bio)
 {
 	struct bio_vec bvec, bvprv = { NULL };
 	struct bvec_iter iter;
@@ -408,13 +408,39 @@ single_segment:
 		return 1;
 	}
 
-	for_each_bio(bio)
+	if (!single_bio) {
+		for_each_bio(bio)
+			bio_for_each_segment(bvec, bio, iter)
+				__blk_segment_map_sg(q, &bvec, sglist, &bvprv,
+						     sg, &nsegs, &cluster);
+	} else {
 		bio_for_each_segment(bvec, bio, iter)
-			__blk_segment_map_sg(q, &bvec, sglist, &bvprv, sg,
-					     &nsegs, &cluster);
+			__blk_segment_map_sg(q, &bvec, sglist, &bvprv,
+					     sg, &nsegs, &cluster);
+	}
+
+	return nsegs;
+}
+
+/*
+ * Map a bio to scatterlist, return number of sg entries setup. Caller must
+ * make sure sg can hold bio segments entries.
+ */
+int blk_bio_map_sg(struct request_queue *q, struct bio *bio,
+		   struct scatterlist *sglist)
+{
+	struct scatterlist *sg = NULL;
+	int nsegs = 0;
+
+	if (bio)
+		nsegs = __blk_bios_map_sg(q, bio, sglist, &sg, true);
+
+	if (sg)
+		sg_mark_end(sg);
 
 	return nsegs;
 }
+EXPORT_SYMBOL(blk_bio_map_sg);
 
 /*
  * map a request to scatterlist, return number of sg entries setup. Caller
@@ -427,7 +453,7 @@ int blk_rq_map_sg(struct request_queue *q, struct request *rq,
 	int nsegs = 0;
 
 	if (rq->bio)
-		nsegs = __blk_bios_map_sg(q, rq->bio, sglist, &sg);
+		nsegs = __blk_bios_map_sg(q, rq->bio, sglist, &sg, false);
 
 	if (unlikely(rq->cmd_flags & REQ_COPY_USER) &&
 	    (blk_rq_bytes(rq) & q->dma_pad_mask)) {
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 1fd8fdf..5868062 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -1013,6 +1013,8 @@ extern void blk_queue_write_cache(struct request_queue *q, bool enabled, bool fu
 extern struct backing_dev_info *blk_get_backing_dev_info(struct block_device *bdev);
 
 extern int blk_rq_map_sg(struct request_queue *, struct request *, struct scatterlist *);
+extern int blk_bio_map_sg(struct request_queue *q, struct bio *bio,
+			  struct scatterlist *sglist);
 extern void blk_dump_rq_flags(struct request *, char *);
 extern long nr_blockdev_pages(void);
 
-- 
1.7.9.5
