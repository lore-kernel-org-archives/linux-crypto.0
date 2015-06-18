From: Dan Streetman <ddstreet@ieee.org>
Subject: [PATCH] crypto: nx - add LE support to pSeries platform driver
Date: Thu, 18 Jun 2015 12:05:30 -0400
Message-ID: <1434643530-17728-1-git-send-email-ddstreet@ieee.org>
Cc: "David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	Dan Streetman <ddstreet@ieee.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-ig0-f180.google.com ([209.85.213.180]:35449 "EHLO
	mail-ig0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751799AbbFRQFo (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 18 Jun 2015 12:05:44 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Add support to the nx-842-pseries.c driver for running in little endian
mode.

The pSeries platform NX 842 driver currently only works as big endian.
This adds cpu_to_be*() and be*_to_cpu() in the appropriate places to
work in LE mode also.

Signed-off-by: Dan Streetman <ddstreet@ieee.org>
---
 drivers/crypto/nx/Kconfig          |  2 +-
 drivers/crypto/nx/nx-842-pseries.c | 83 +++++++++++++++++++-------------------
 drivers/crypto/nx/nx-842.h         |  3 +-
 3 files changed, 45 insertions(+), 43 deletions(-)

diff --git a/drivers/crypto/nx/Kconfig b/drivers/crypto/nx/Kconfig
index b1addf6..e421c96 100644
--- a/drivers/crypto/nx/Kconfig
+++ b/drivers/crypto/nx/Kconfig
@@ -24,7 +24,7 @@ if CRYPTO_DEV_NX_COMPRESS
 
 config CRYPTO_DEV_NX_COMPRESS_PSERIES
 	tristate "Compression acceleration support on pSeries platform"
-	depends on PPC_PSERIES && IBMVIO && !CPU_LITTLE_ENDIAN
+	depends on PPC_PSERIES && IBMVIO
 	default y
 	help
 	  Support for PowerPC Nest (NX) compression acceleration. This
diff --git a/drivers/crypto/nx/nx-842-pseries.c b/drivers/crypto/nx/nx-842-pseries.c
index da52d8e..3040a60 100644
--- a/drivers/crypto/nx/nx-842-pseries.c
+++ b/drivers/crypto/nx/nx-842-pseries.c
@@ -166,8 +166,8 @@ static unsigned long nx842_get_desired_dma(struct vio_dev *viodev)
 }
 
 struct nx842_slentry {
-	unsigned long ptr; /* Real address (use __pa()) */
-	unsigned long len;
+	__be64 ptr; /* Real address (use __pa()) */
+	__be64 len;
 };
 
 /* pHyp scatterlist entry */
@@ -186,30 +186,21 @@ static inline unsigned long nx842_get_scatterlist_size(
 static int nx842_build_scatterlist(unsigned long buf, int len,
 			struct nx842_scatterlist *sl)
 {
-	unsigned long nextpage;
+	unsigned long entrylen;
 	struct nx842_slentry *entry;
 
 	sl->entry_nr = 0;
 
 	entry = sl->entries;
 	while (len) {
-		entry->ptr = nx842_get_pa((void *)buf);
-		nextpage = ALIGN(buf + 1, NX842_HW_PAGE_SIZE);
-		if (nextpage < buf + len) {
-			/* we aren't at the end yet */
-			if (IS_ALIGNED(buf, NX842_HW_PAGE_SIZE))
-				/* we are in the middle (or beginning) */
-				entry->len = NX842_HW_PAGE_SIZE;
-			else
-				/* we are at the beginning */
-				entry->len = nextpage - buf;
-		} else {
-			/* at the end */
-			entry->len = len;
-		}
-
-		len -= entry->len;
-		buf += entry->len;
+		entry->ptr = cpu_to_be64(nx842_get_pa((void *)buf));
+		entrylen = min_t(int, len,
+				 LEN_ON_SIZE(buf, NX842_HW_PAGE_SIZE));
+		entry->len = cpu_to_be64(entrylen);
+
+		len -= entrylen;
+		buf += entrylen;
+
 		sl->entry_nr++;
 		entry++;
 	}
@@ -230,8 +221,8 @@ static int nx842_validate_result(struct device *dev,
 				csb->completion_code,
 				csb->completion_extension);
 		dev_dbg(dev, "processed_bytes:%d address:0x%016lx\n",
-				csb->processed_byte_count,
-				(unsigned long)csb->address);
+				be32_to_cpu(csb->processed_byte_count),
+				(unsigned long)be64_to_cpu(csb->address));
 		return -EIO;
 	}
 
@@ -338,7 +329,6 @@ static int nx842_pseries_compress(const unsigned char *in, unsigned int inlen,
 	csbcpb = &workmem->csbcpb;
 	memset(csbcpb, 0, sizeof(*csbcpb));
 	op.csbcpb = nx842_get_pa(csbcpb);
-	op.out = nx842_get_pa(slout.entries);
 
 	if ((inbuf & NX842_HW_PAGE_MASK) ==
 	    ((inbuf + inlen - 1) & NX842_HW_PAGE_MASK)) {
@@ -364,6 +354,10 @@ static int nx842_pseries_compress(const unsigned char *in, unsigned int inlen,
 		op.outlen = -nx842_get_scatterlist_size(&slout);
 	}
 
+	dev_dbg(dev, "%s: op.in %lx op.inlen %ld op.out %lx op.outlen %ld\n",
+		__func__, (unsigned long)op.in, (long)op.inlen,
+		(unsigned long)op.out, (long)op.outlen);
+
 	/* Send request to pHyp */
 	ret = vio_h_cop_sync(local_devdata->vdev, &op);
 
@@ -380,7 +374,7 @@ static int nx842_pseries_compress(const unsigned char *in, unsigned int inlen,
 	if (ret)
 		goto unlock;
 
-	*outlen = csbcpb->csb.processed_byte_count;
+	*outlen = be32_to_cpu(csbcpb->csb.processed_byte_count);
 	dev_dbg(dev, "%s: processed_bytes=%d\n", __func__, *outlen);
 
 unlock:
@@ -493,6 +487,10 @@ static int nx842_pseries_decompress(const unsigned char *in, unsigned int inlen,
 		op.outlen = -nx842_get_scatterlist_size(&slout);
 	}
 
+	dev_dbg(dev, "%s: op.in %lx op.inlen %ld op.out %lx op.outlen %ld\n",
+		__func__, (unsigned long)op.in, (long)op.inlen,
+		(unsigned long)op.out, (long)op.outlen);
+
 	/* Send request to pHyp */
 	ret = vio_h_cop_sync(local_devdata->vdev, &op);
 
@@ -508,7 +506,7 @@ static int nx842_pseries_decompress(const unsigned char *in, unsigned int inlen,
 	if (ret)
 		goto unlock;
 
-	*outlen = csbcpb->csb.processed_byte_count;
+	*outlen = be32_to_cpu(csbcpb->csb.processed_byte_count);
 
 unlock:
 	if (ret)
@@ -600,16 +598,16 @@ static int nx842_OF_upd_status(struct nx842_devdata *devdata,
 static int nx842_OF_upd_maxsglen(struct nx842_devdata *devdata,
 					struct property *prop) {
 	int ret = 0;
-	const int *maxsglen = prop->value;
+	const unsigned int maxsglen = of_read_number(prop->value, 1);
 
-	if (prop->length != sizeof(*maxsglen)) {
+	if (prop->length != sizeof(maxsglen)) {
 		dev_err(devdata->dev, "%s: unexpected format for ibm,max-sg-len property\n", __func__);
 		dev_dbg(devdata->dev, "%s: ibm,max-sg-len is %d bytes long, expected %lu bytes\n", __func__,
-				prop->length, sizeof(*maxsglen));
+				prop->length, sizeof(maxsglen));
 		ret = -EINVAL;
 	} else {
-		devdata->max_sg_len = (unsigned int)min(*maxsglen,
-				(int)NX842_HW_PAGE_SIZE);
+		devdata->max_sg_len = min_t(unsigned int,
+					    maxsglen, NX842_HW_PAGE_SIZE);
 	}
 
 	return ret;
@@ -648,13 +646,15 @@ static int nx842_OF_upd_maxsglen(struct nx842_devdata *devdata,
 static int nx842_OF_upd_maxsyncop(struct nx842_devdata *devdata,
 					struct property *prop) {
 	int ret = 0;
+	unsigned int comp_data_limit, decomp_data_limit;
+	unsigned int comp_sg_limit, decomp_sg_limit;
 	const struct maxsynccop_t {
-		int comp_elements;
-		int comp_data_limit;
-		int comp_sg_limit;
-		int decomp_elements;
-		int decomp_data_limit;
-		int decomp_sg_limit;
+		__be32 comp_elements;
+		__be32 comp_data_limit;
+		__be32 comp_sg_limit;
+		__be32 decomp_elements;
+		__be32 decomp_data_limit;
+		__be32 decomp_sg_limit;
 	} *maxsynccop;
 
 	if (prop->length != sizeof(*maxsynccop)) {
@@ -666,14 +666,16 @@ static int nx842_OF_upd_maxsyncop(struct nx842_devdata *devdata,
 	}
 
 	maxsynccop = (const struct maxsynccop_t *)prop->value;
+	comp_data_limit = be32_to_cpu(maxsynccop->comp_data_limit);
+	comp_sg_limit = be32_to_cpu(maxsynccop->comp_sg_limit);
+	decomp_data_limit = be32_to_cpu(maxsynccop->decomp_data_limit);
+	decomp_sg_limit = be32_to_cpu(maxsynccop->decomp_sg_limit);
 
 	/* Use one limit rather than separate limits for compression and
 	 * decompression. Set a maximum for this so as not to exceed the
 	 * size that the header can support and round the value down to
 	 * the hardware page size (4K) */
-	devdata->max_sync_size =
-			(unsigned int)min(maxsynccop->comp_data_limit,
-					maxsynccop->decomp_data_limit);
+	devdata->max_sync_size = min(comp_data_limit, decomp_data_limit);
 
 	devdata->max_sync_size = min_t(unsigned int, devdata->max_sync_size,
 					65536);
@@ -689,8 +691,7 @@ static int nx842_OF_upd_maxsyncop(struct nx842_devdata *devdata,
 
 	nx842_pseries_constraints.maximum = devdata->max_sync_size;
 
-	devdata->max_sync_sg = (unsigned int)min(maxsynccop->comp_sg_limit,
-						maxsynccop->decomp_sg_limit);
+	devdata->max_sync_sg = min(comp_sg_limit, decomp_sg_limit);
 	if (devdata->max_sync_sg < 1) {
 		dev_err(devdata->dev, "%s: hardware max sg size (%u) is "
 				"less than the driver minimum, unable to use "
diff --git a/drivers/crypto/nx/nx-842.h b/drivers/crypto/nx/nx-842.h
index f6821b6..ac0ea79 100644
--- a/drivers/crypto/nx/nx-842.h
+++ b/drivers/crypto/nx/nx-842.h
@@ -88,7 +88,8 @@
 #define CCB_CM_EXTRA_WRITE	(CCB_CM0_ALL_COMPLETIONS & CCB_CM12_STORE)
 #define CCB_CM_INTERRUPT	(CCB_CM0_ALL_COMPLETIONS & CCB_CM12_INTERRUPT)
 
-#define LEN_ON_PAGE(pa)		(PAGE_SIZE - ((pa) & ~PAGE_MASK))
+#define LEN_ON_SIZE(pa, size)	((size) - ((pa) & ((size) - 1)))
+#define LEN_ON_PAGE(pa)		LEN_ON_SIZE(pa, PAGE_SIZE)
 
 static inline unsigned long nx842_get_pa(void *addr)
 {
-- 
2.1.0
