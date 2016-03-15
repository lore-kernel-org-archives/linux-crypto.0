From: Baolin Wang <baolin.wang@linaro.org>
Subject: [PATCH v2 2/4] crypto: Introduce some helper functions to help to merge requests
Date: Tue, 15 Mar 2016 15:48:00 +0800
Message-ID: <92a18ed761d18993087aad46d0c0f4f4721be6a3.1458023698.git.baolin.wang@linaro.org>
References: <cover.1458023695.git.baolin.wang@linaro.org>
Cc: akpm@linux-foundation.org, david.s.gordon@intel.com,
	thomas.lendacky@amd.com, robert.jarzmik@free.fr,
	yamada.masahiro@socionext.com, smueller@chronox.de,
	tadeusz.struk@intel.com, standby24x7@gmail.com, shli@kernel.org,
	broonie@kernel.org, linus.walleij@linaro.org, arnd@arndb.de,
	baolin.wang@linaro.org, linux-kernel@vger.kernel.org,
	linux-crypto@vger.kernel.org, linux-raid@vger.kernel.org
To: herbert@gondor.apana.org.au, davem@davemloft.net, agk@redhat.com,
	snitzer@redhat.com, axboe@fb.com, dm-devel@redhat.com
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <cover.1458023695.git.baolin.wang@linaro.org>
In-Reply-To: <cover.1458023695.git.baolin.wang@linaro.org>
References: <cover.1458023695.git.baolin.wang@linaro.org>
Sender: linux-raid-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Usually the dm-crypt subsystem will send encryption/descryption requests to
the crypto layer one block at a time, making each request 512 bytes long,
which is a much smaller size for hardware engine, that means the hardware
engine can not play its best performance.

Now some cipher hardware engines prefer to handle bulk block rather than one
sector (512 bytes) created by dm-crypt, cause these cipher engines can handle
the intermediate values (IV) by themselves in one bulk block. This means we
can increase the size of the request by merging request rather than always 512
bytes and thus increase the hardware engine processing speed.

This patch introduces some helper functions to help to merge requests to improve
hardware engine efficiency.

Signed-off-by: Baolin Wang <baolin.wang@linaro.org>
---
 crypto/ablk_helper.c         |  135 ++++++++++++++++++++++++++++++++++++++++++
 include/crypto/ablk_helper.h |    3 +
 include/linux/crypto.h       |    5 ++
 3 files changed, 143 insertions(+)

diff --git a/crypto/ablk_helper.c b/crypto/ablk_helper.c
index e1fcf53..3cf15cb 100644
--- a/crypto/ablk_helper.c
+++ b/crypto/ablk_helper.c
@@ -26,6 +26,7 @@
 
 #include <linux/kernel.h>
 #include <linux/crypto.h>
+#include <linux/device-mapper.h>
 #include <linux/init.h>
 #include <linux/module.h>
 #include <linux/hardirq.h>
@@ -34,6 +35,140 @@
 #include <crypto/ablk_helper.h>
 #include <asm/simd.h>
 
+/**
+ * ablk_link_request_if_contigous - try to link one request into previous one
+ * if the page address is contiguous.
+ * @list_req: the request from queue list
+ * @req: the new request need to be merged
+ *
+ * If the listed request and new request's pages of the scatterlists are
+ * contiguous, then merge the scatterlists of new request into the listed one.
+ *
+ * Return true on success, others means failed.
+ */
+static bool ablk_link_request_if_contigous(struct ablkcipher_request *list_req,
+					   struct ablkcipher_request *req)
+{
+	struct scatterlist *last_src_sg =
+		sg_last(list_req->sgt_src.sgl, list_req->sgt_src.nents);
+	struct scatterlist *last_dst_sg =
+		sg_last(list_req->sgt_dst.sgl, list_req->sgt_dst.nents);
+	struct scatterlist *req_src_sg = req->src;
+	struct scatterlist *req_dst_sg = req->dst;
+
+	if (!last_src_sg || !last_dst_sg)
+		return false;
+
+	/* Check if the src/dst scatterlists are contiguous */
+	if (!sg_is_contiguous(last_src_sg, req_src_sg) ||
+	    !sg_is_contiguous(last_dst_sg, req_dst_sg))
+		return false;
+
+	/*
+	 * If the request can be merged into the listed request after the
+	 * checking, then expand the listed request scatterlists' length.
+	 */
+	last_src_sg->length += req_src_sg->length;
+	last_dst_sg->length += req_dst_sg->length;
+	list_req->nbytes += req->nbytes;
+
+	return true;
+}
+
+/**
+ * ablk_merge_request - try to merge one request into previous one
+ * @list_req: the request from queue list
+ * @req: the request need to be merged
+ *
+ * This function will create a dynamic scatterlist table for both source
+ * and destination if the request is the first coming in.
+ *
+ * Return true on success, others means failed.
+ */
+static bool ablk_merge_request(struct ablkcipher_request *list_req,
+			       struct ablkcipher_request *req)
+{
+	struct sg_table *sgt_src = &list_req->sgt_src;
+	struct sg_table *sgt_dst = &list_req->sgt_dst;
+	unsigned int nents = SG_MAX_SINGLE_ALLOC;
+
+	if (sg_table_is_empty(sgt_src)) {
+		if (sg_alloc_empty_table(sgt_src, nents, GFP_ATOMIC))
+			return false;
+
+		if (sg_add_sg_to_table(sgt_src, list_req->src))
+			return false;
+	}
+
+	if (sg_table_is_empty(sgt_dst)) {
+		if (sg_alloc_empty_table(sgt_dst, nents, GFP_ATOMIC))
+			return false;
+
+		if (sg_add_sg_to_table(sgt_dst, list_req->dst))
+			return false;
+	}
+
+	/*
+	 * Check if the new request is contiguous for the listed request,
+	 * if it is contiguous then merge the new request into the listed one.
+	 */
+	if (ablk_link_request_if_contigous(list_req, req))
+		return true;
+
+	if (sg_add_sg_to_table(sgt_src, req->src))
+		return false;
+
+	if (sg_add_sg_to_table(sgt_dst, req->dst))
+		return false;
+
+	list_req->nbytes += req->nbytes;
+	return true;
+}
+
+/**
+ * ablk_try_merge - try to merge one request into previous one
+ * @queue: the crypto queue list
+ * @req: the request need to be merged
+ *
+ * Note: The merging action should be under the spinlock or mutex protection.
+ *
+ * Return 0 on success and others are failed.
+ */
+int ablk_try_merge(struct crypto_queue *queue,
+		   struct ablkcipher_request *req)
+{
+	struct ablkcipher_request *list_req;
+	struct crypto_async_request *async_req;
+
+	list_for_each_entry(async_req, &queue->list, list) {
+		list_req = ablkcipher_request_cast(async_req);
+
+		if (list_req->base.flags != req->base.flags)
+			continue;
+
+		/* Check that the request adds up to an even number of sectors */
+		if (!IS_ALIGNED(list_req->nbytes, (1U << SECTOR_SHIFT)))
+			continue;
+
+		if (list_req->nbytes + req->nbytes > UINT_MAX)
+			continue;
+
+		/*
+		 * We first check that the sectors are adjacent so we don't
+		 * mistadly coalesce something that is contigous in memory but
+		 * not contigous on disk.
+		 */
+		if (list_req->sector + list_req->nbytes /
+		    (1U << SECTOR_SHIFT) == req->sector) {
+			if (ablk_merge_request(list_req, req))
+				return 0;
+		}
+	}
+
+	return 1;
+}
+EXPORT_SYMBOL_GPL(ablk_try_merge);
+
 int ablk_set_key(struct crypto_ablkcipher *tfm, const u8 *key,
 		 unsigned int key_len)
 {
diff --git a/include/crypto/ablk_helper.h b/include/crypto/ablk_helper.h
index 4f93df5..12ae00d 100644
--- a/include/crypto/ablk_helper.h
+++ b/include/crypto/ablk_helper.h
@@ -8,6 +8,7 @@
 #include <linux/crypto.h>
 #include <linux/kernel.h>
 #include <crypto/cryptd.h>
+#include <crypto/algapi.h>
 
 struct async_helper_ctx {
 	struct cryptd_ablkcipher *cryptd_tfm;
@@ -28,4 +29,6 @@ extern int ablk_init_common(struct crypto_tfm *tfm, const char *drv_name);
 
 extern int ablk_init(struct crypto_tfm *tfm);
 
+extern int ablk_try_merge(struct crypto_queue *queue,
+			  struct ablkcipher_request *req);
 #endif /* _CRYPTO_ABLK_HELPER_H */
diff --git a/include/linux/crypto.h b/include/linux/crypto.h
index e71cb70..f878bb1 100644
--- a/include/linux/crypto.h
+++ b/include/linux/crypto.h
@@ -21,6 +21,7 @@
 #include <linux/kernel.h>
 #include <linux/list.h>
 #include <linux/bug.h>
+#include <linux/scatterlist.h>
 #include <linux/slab.h>
 #include <linux/string.h>
 #include <linux/uaccess.h>
@@ -170,6 +171,10 @@ struct ablkcipher_request {
 	struct scatterlist *src;
 	struct scatterlist *dst;
 
+	struct sg_table sgt_src;
+	struct sg_table sgt_dst;
+	sector_t	sector;
+
 	void *__ctx[] CRYPTO_MINALIGN_ATTR;
 };
 
-- 
1.7.9.5

