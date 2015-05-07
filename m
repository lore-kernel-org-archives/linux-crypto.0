From: Dan Streetman <ddstreet@ieee.org>
Subject: [PATCH 09/10] drivers/crypto/nx: simplify pSeries nx842 driver
Date: Thu,  7 May 2015 13:49:20 -0400
Message-ID: <1431020961-22285-10-git-send-email-ddstreet@ieee.org>
References: <1431020961-22285-1-git-send-email-ddstreet@ieee.org>
Cc: Seth Jennings <sjennings@variantweb.net>,
	Robert Jennings <rob@pochix.net>, linux-crypto@vger.kernel.org,
	linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
	Dan Streetman <ddstreet@ieee.org>
To: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Benjamin Herrenschmidt <benh@kernel.crashing.org>,
	Paul Mackerras <paulus@samba.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1431020961-22285-1-git-send-email-ddstreet@ieee.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Simplify the pSeries NX-842 driver: do not expect incoming buffers to be
exactly page-sized; do not break up input buffers to compress smaller
blocks; do not use any internal headers in the compressed data blocks;
remove the software decompression implementation; implement the pSeries
nx842_constraints.

This changes the pSeries NX-842 driver to perform constraints-based
compression so that it only needs to compress one entire input block at a
time.  This removes the need for it to split input data blocks into
multiple compressed data sections in the output buffer, and removes the
need for any extra header info in the compressed data; all that is moved
(in a later patch) into the main crypto 842 driver.  Additionally, the
842 software decompression implementation is no longer needed here, as
the crypto 842 driver will use the generic software 842 decompression
function as a fallback if any hardware 842 driver fails.

Signed-off-by: Dan Streetman <ddstreet@ieee.org>
---
 drivers/crypto/nx/nx-842-pseries.c | 779 ++++++++-----------------------------
 1 file changed, 153 insertions(+), 626 deletions(-)

diff --git a/drivers/crypto/nx/nx-842-pseries.c b/drivers/crypto/nx/nx-842-pseries.c
index 6db9992..85837e9 100644
--- a/drivers/crypto/nx/nx-842-pseries.c
+++ b/drivers/crypto/nx/nx-842-pseries.c
@@ -21,7 +21,6 @@
  *          Seth Jennings <sjenning@linux.vnet.ibm.com>
  */
 
-#include <asm/page.h>
 #include <asm/vio.h>
 
 #include "nx-842.h"
@@ -32,11 +31,6 @@ MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Robert Jennings <rcj@linux.vnet.ibm.com>");
 MODULE_DESCRIPTION("842 H/W Compression driver for IBM Power processors");
 
-#define SHIFT_4K 12
-#define SHIFT_64K 16
-#define SIZE_4K (1UL << SHIFT_4K)
-#define SIZE_64K (1UL << SHIFT_64K)
-
 /* IO buffer must be 128 byte aligned */
 #define IO_BUFFER_ALIGN 128
 
@@ -47,18 +41,52 @@ static struct nx842_constraints nx842_pseries_constraints = {
 	.maximum =	PAGE_SIZE, /* dynamic, max_sync_size */
 };
 
-struct nx842_header {
-	int blocks_nr; /* number of compressed blocks */
-	int offset; /* offset of the first block (from beginning of header) */
-	int sizes[0]; /* size of compressed blocks */
-};
-
-static inline int nx842_header_size(const struct nx842_header *hdr)
+static int check_constraints(unsigned long buf, unsigned int *len, bool in)
 {
-	return sizeof(struct nx842_header) +
-			hdr->blocks_nr * sizeof(hdr->sizes[0]);
+	if (!IS_ALIGNED(buf, nx842_pseries_constraints.alignment)) {
+		pr_debug("%s buffer 0x%lx not aligned to 0x%x\n",
+			 in ? "input" : "output", buf,
+			 nx842_pseries_constraints.alignment);
+		return -EINVAL;
+	}
+	if (*len % nx842_pseries_constraints.multiple) {
+		pr_debug("%s buffer len 0x%x not multiple of 0x%x\n",
+			 in ? "input" : "output", *len,
+			 nx842_pseries_constraints.multiple);
+		if (in)
+			return -EINVAL;
+		*len = round_down(*len, nx842_pseries_constraints.multiple);
+	}
+	if (*len < nx842_pseries_constraints.minimum) {
+		pr_debug("%s buffer len 0x%x under minimum 0x%x\n",
+			 in ? "input" : "output", *len,
+			 nx842_pseries_constraints.minimum);
+		return -EINVAL;
+	}
+	if (*len > nx842_pseries_constraints.maximum) {
+		pr_debug("%s buffer len 0x%x over maximum 0x%x\n",
+			 in ? "input" : "output", *len,
+			 nx842_pseries_constraints.maximum);
+		if (in)
+			return -EINVAL;
+		*len = nx842_pseries_constraints.maximum;
+	}
+	return 0;
 }
 
+/* I assume we need to align the CSB? */
+#define WORKMEM_ALIGN	(256)
+
+struct nx842_workmem {
+	/* scatterlist */
+	char slin[4096];
+	char slout[4096];
+	/* coprocessor status/parameter block */
+	struct nx_csbcpb csbcpb;
+
+	char padding[WORKMEM_ALIGN];
+} __aligned(WORKMEM_ALIGN);
+
 /* Macros for fields within nx_csbcpb */
 /* Check the valid bit within the csbcpb valid field */
 #define NX842_CSBCBP_VALID_CHK(x) (x & BIT_MASK(7))
@@ -72,8 +100,7 @@ static inline int nx842_header_size(const struct nx842_header *hdr)
 #define NX842_CSBCPB_CE2(x)	(x & BIT_MASK(5))
 
 /* The NX unit accepts data only on 4K page boundaries */
-#define NX842_HW_PAGE_SHIFT	SHIFT_4K
-#define NX842_HW_PAGE_SIZE	(ASM_CONST(1) << NX842_HW_PAGE_SHIFT)
+#define NX842_HW_PAGE_SIZE	(4096)
 #define NX842_HW_PAGE_MASK	(~(NX842_HW_PAGE_SIZE-1))
 
 enum nx842_status {
@@ -194,41 +221,6 @@ static int nx842_build_scatterlist(unsigned long buf, int len,
 	return 0;
 }
 
-/*
- * Working memory for software decompression
- */
-struct sw842_fifo {
-	union {
-		char f8[256][8];
-		char f4[512][4];
-	};
-	char f2[256][2];
-	unsigned char f84_full;
-	unsigned char f2_full;
-	unsigned char f8_count;
-	unsigned char f2_count;
-	unsigned int f4_count;
-};
-
-/*
- * Working memory for crypto API
- */
-struct nx842_workmem {
-	char bounce[PAGE_SIZE]; /* bounce buffer for decompression input */
-	union {
-		/* hardware working memory */
-		struct {
-			/* scatterlist */
-			char slin[SIZE_4K];
-			char slout[SIZE_4K];
-			/* coprocessor status/parameter block */
-			struct nx_csbcpb csbcpb;
-		};
-		/* software working memory */
-		struct sw842_fifo swfifo; /* software decompression fifo */
-	};
-};
-
 static int nx842_validate_result(struct device *dev,
 	struct cop_status_block *csb)
 {
@@ -291,8 +283,8 @@ static int nx842_validate_result(struct device *dev,
  * compressed data.  If there is an error then @outlen will be 0 and an
  * error will be specified by the return code from this function.
  *
- * @in: Pointer to input buffer, must be page aligned
- * @inlen: Length of input buffer, must be PAGE_SIZE
+ * @in: Pointer to input buffer
+ * @inlen: Length of input buffer
  * @out: Pointer to output buffer
  * @outlen: Length of output buffer
  * @wrkmem: ptr to buffer for working memory, size determined by
@@ -302,7 +294,6 @@ static int nx842_validate_result(struct device *dev,
  *   0		Success, output of length @outlen stored in the buffer at @out
  *   -ENOMEM	Unable to allocate internal buffers
  *   -ENOSPC	Output buffer is to small
- *   -EMSGSIZE	XXX Difficult to describe this limitation
  *   -EIO	Internal error
  *   -ENODEV	Hardware unavailable
  */
@@ -310,29 +301,26 @@ static int nx842_pseries_compress(const unsigned char *in, unsigned int inlen,
 				  unsigned char *out, unsigned int *outlen,
 				  void *wmem)
 {
-	struct nx842_header *hdr;
 	struct nx842_devdata *local_devdata;
 	struct device *dev = NULL;
 	struct nx842_workmem *workmem;
 	struct nx842_scatterlist slin, slout;
 	struct nx_csbcpb *csbcpb;
-	int ret = 0, max_sync_size, i, bytesleft, size, hdrsize;
-	unsigned long inbuf, outbuf, padding;
+	int ret = 0, max_sync_size;
+	unsigned long inbuf, outbuf;
 	struct vio_pfo_op op = {
 		.done = NULL,
 		.handle = 0,
 		.timeout = 0,
 	};
-	unsigned long start_time = get_tb();
+	unsigned long start = get_tb();
 
-	/*
-	 * Make sure input buffer is 64k page aligned.  This is assumed since
-	 * this driver is designed for page compression only (for now).  This
-	 * is very nice since we can now use direct DDE(s) for the input and
-	 * the alignment is guaranteed.
-	*/
 	inbuf = (unsigned long)in;
-	if (!IS_ALIGNED(inbuf, PAGE_SIZE) || inlen != PAGE_SIZE)
+	if (check_constraints(inbuf, &inlen, true))
+		return -EINVAL;
+
+	outbuf = (unsigned long)out;
+	if (check_constraints(outbuf, outlen, false))
 		return -EINVAL;
 
 	rcu_read_lock();
@@ -344,16 +332,8 @@ static int nx842_pseries_compress(const unsigned char *in, unsigned int inlen,
 	max_sync_size = local_devdata->max_sync_size;
 	dev = local_devdata->dev;
 
-	/* Create the header */
-	hdr = (struct nx842_header *)out;
-	hdr->blocks_nr = PAGE_SIZE / max_sync_size;
-	hdrsize = nx842_header_size(hdr);
-	outbuf = (unsigned long)out + hdrsize;
-	bytesleft = *outlen - hdrsize;
-
 	/* Init scatterlist */
-	workmem = (struct nx842_workmem *)ALIGN((unsigned long)wmem,
-		NX842_HW_PAGE_SIZE);
+	workmem = PTR_ALIGN(wmem, WORKMEM_ALIGN);
 	slin.entries = (struct nx842_slentry *)workmem->slin;
 	slout.entries = (struct nx842_slentry *)workmem->slout;
 
@@ -364,105 +344,48 @@ static int nx842_pseries_compress(const unsigned char *in, unsigned int inlen,
 	op.csbcpb = nx842_get_pa(csbcpb);
 	op.out = nx842_get_pa(slout.entries);
 
-	for (i = 0; i < hdr->blocks_nr; i++) {
-		/*
-		 * Aligning the output blocks to 128 bytes does waste space,
-		 * but it prevents the need for bounce buffers and memory
-		 * copies.  It also simplifies the code a lot.  In the worst
-		 * case (64k page, 4k max_sync_size), you lose up to
-		 * (128*16)/64k = ~3% the compression factor. For 64k
-		 * max_sync_size, the loss would be at most 128/64k = ~0.2%.
-		 */
-		padding = ALIGN(outbuf, IO_BUFFER_ALIGN) - outbuf;
-		outbuf += padding;
-		bytesleft -= padding;
-		if (i == 0)
-			/* save offset into first block in header */
-			hdr->offset = padding + hdrsize;
-
-		if (bytesleft <= 0) {
-			ret = -ENOSPC;
-			goto unlock;
-		}
-
-		/*
-		 * NOTE: If the default max_sync_size is changed from 4k
-		 * to 64k, remove the "likely" case below, since a
-		 * scatterlist will always be needed.
-		 */
-		if (likely(max_sync_size == NX842_HW_PAGE_SIZE)) {
-			/* Create direct DDE */
-			op.in = nx842_get_pa((void *)inbuf);
-			op.inlen = max_sync_size;
-
-		} else {
-			/* Create indirect DDE (scatterlist) */
-			nx842_build_scatterlist(inbuf, max_sync_size, &slin);
-			op.in = nx842_get_pa(slin.entries);
-			op.inlen = -nx842_get_scatterlist_size(&slin);
-		}
+	if ((inbuf & NX842_HW_PAGE_MASK) ==
+	    ((inbuf + inlen - 1) & NX842_HW_PAGE_MASK)) {
+		/* Create direct DDE */
+		op.in = nx842_get_pa((void *)inbuf);
+		op.inlen = inlen;
+	} else {
+		/* Create indirect DDE (scatterlist) */
+		nx842_build_scatterlist(inbuf, inlen, &slin);
+		op.in = nx842_get_pa(slin.entries);
+		op.inlen = -nx842_get_scatterlist_size(&slin);
+	}
 
-		/*
-		 * If max_sync_size != NX842_HW_PAGE_SIZE, an indirect
-		 * DDE is required for the outbuf.
-		 * If max_sync_size == NX842_HW_PAGE_SIZE, outbuf must
-		 * also be page aligned (1 in 128/4k=32 chance) in order
-		 * to use a direct DDE.
-		 * This is unlikely, just use an indirect DDE always.
-		 */
-		nx842_build_scatterlist(outbuf,
-			min(bytesleft, max_sync_size), &slout);
-		/* op.out set before loop */
+	if ((outbuf & NX842_HW_PAGE_MASK) ==
+	    ((outbuf + *outlen - 1) & NX842_HW_PAGE_MASK)) {
+		/* Create direct DDE */
+		op.out = nx842_get_pa((void *)outbuf);
+		op.outlen = *outlen;
+	} else {
+		/* Create indirect DDE (scatterlist) */
+		nx842_build_scatterlist(outbuf, *outlen, &slout);
+		op.out = nx842_get_pa(slout.entries);
 		op.outlen = -nx842_get_scatterlist_size(&slout);
+	}
 
-		/* Send request to pHyp */
-		ret = vio_h_cop_sync(local_devdata->vdev, &op);
-
-		/* Check for pHyp error */
-		if (ret) {
-			dev_dbg(dev, "%s: vio_h_cop_sync error (ret=%d, hret=%ld)\n",
-				__func__, ret, op.hcall_err);
-			ret = -EIO;
-			goto unlock;
-		}
-
-		/* Check for hardware error */
-		ret = nx842_validate_result(dev, &csbcpb->csb);
-		if (ret && ret != -ENOSPC)
-			goto unlock;
-
-		/* Handle incompressible data */
-		if (unlikely(ret == -ENOSPC)) {
-			if (bytesleft < max_sync_size) {
-				/*
-				 * Not enough space left in the output buffer
-				 * to store uncompressed block
-				 */
-				goto unlock;
-			} else {
-				/* Store incompressible block */
-				memcpy((void *)outbuf, (void *)inbuf,
-					max_sync_size);
-				hdr->sizes[i] = -max_sync_size;
-				outbuf += max_sync_size;
-				bytesleft -= max_sync_size;
-				/* Reset ret, incompressible data handled */
-				ret = 0;
-			}
-		} else {
-			/* Normal case, compression was successful */
-			size = csbcpb->csb.processed_byte_count;
-			dev_dbg(dev, "%s: processed_bytes=%d\n",
-				__func__, size);
-			hdr->sizes[i] = size;
-			outbuf += size;
-			bytesleft -= size;
-		}
+	/* Send request to pHyp */
+	ret = vio_h_cop_sync(local_devdata->vdev, &op);
 
-		inbuf += max_sync_size;
+	/* Check for pHyp error */
+	if (ret) {
+		dev_dbg(dev, "%s: vio_h_cop_sync error (ret=%d, hret=%ld)\n",
+			__func__, ret, op.hcall_err);
+		ret = -EIO;
+		goto unlock;
 	}
 
-	*outlen = (unsigned int)(outbuf - (unsigned long)out);
+	/* Check for hardware error */
+	ret = nx842_validate_result(dev, &csbcpb->csb);
+	if (ret)
+		goto unlock;
+
+	*outlen = csbcpb->csb.processed_byte_count;
+	dev_dbg(dev, "%s: processed_bytes=%d\n", __func__, *outlen);
 
 unlock:
 	if (ret)
@@ -470,15 +393,12 @@ unlock:
 	else {
 		nx842_inc_comp_complete(local_devdata);
 		ibm_nx842_incr_hist(local_devdata->counters->comp_times,
-			(get_tb() - start_time) / tb_ticks_per_usec);
+			(get_tb() - start) / tb_ticks_per_usec);
 	}
 	rcu_read_unlock();
 	return ret;
 }
 
-static int sw842_decompress(const unsigned char *, int, unsigned char *, int *,
-			const void *);
-
 /**
  * nx842_pseries_decompress - Decompress data using the 842 algorithm
  *
@@ -490,11 +410,10 @@ static int sw842_decompress(const unsigned char *, int, unsigned char *, int *,
  * If there is an error then @outlen will be 0 and an error will be
  * specified by the return code from this function.
  *
- * @in: Pointer to input buffer, will use bounce buffer if not 128 byte
- *      aligned
+ * @in: Pointer to input buffer
  * @inlen: Length of input buffer
- * @out: Pointer to output buffer, must be page aligned
- * @outlen: Length of output buffer, must be PAGE_SIZE
+ * @out: Pointer to output buffer
+ * @outlen: Length of output buffer
  * @wrkmem: ptr to buffer for working memory, size determined by
  *          NX842_MEM_COMPRESS
  *
@@ -510,43 +429,39 @@ static int nx842_pseries_decompress(const unsigned char *in, unsigned int inlen,
 				    unsigned char *out, unsigned int *outlen,
 				    void *wmem)
 {
-	struct nx842_header *hdr;
 	struct nx842_devdata *local_devdata;
 	struct device *dev = NULL;
 	struct nx842_workmem *workmem;
 	struct nx842_scatterlist slin, slout;
 	struct nx_csbcpb *csbcpb;
-	int ret = 0, i, size, max_sync_size;
+	int ret = 0, max_sync_size;
 	unsigned long inbuf, outbuf;
 	struct vio_pfo_op op = {
 		.done = NULL,
 		.handle = 0,
 		.timeout = 0,
 	};
-	unsigned long start_time = get_tb();
+	unsigned long start = get_tb();
 
 	/* Ensure page alignment and size */
+	inbuf = (unsigned long)in;
+	if (check_constraints(inbuf, &inlen, true))
+		return -EINVAL;
+
 	outbuf = (unsigned long)out;
-	if (!IS_ALIGNED(outbuf, PAGE_SIZE) || *outlen != PAGE_SIZE)
+	if (check_constraints(outbuf, outlen, false))
 		return -EINVAL;
 
 	rcu_read_lock();
 	local_devdata = rcu_dereference(devdata);
-	if (local_devdata)
-		dev = local_devdata->dev;
-
-	/* Get header */
-	hdr = (struct nx842_header *)in;
-
-	workmem = (struct nx842_workmem *)ALIGN((unsigned long)wmem,
-		NX842_HW_PAGE_SIZE);
-
-	inbuf = (unsigned long)in + hdr->offset;
-	if (likely(!IS_ALIGNED(inbuf, IO_BUFFER_ALIGN))) {
-		/* Copy block(s) into bounce buffer for alignment */
-		memcpy(workmem->bounce, in + hdr->offset, inlen - hdr->offset);
-		inbuf = (unsigned long)workmem->bounce;
+	if (!local_devdata || !local_devdata->dev) {
+		rcu_read_unlock();
+		return -ENODEV;
 	}
+	max_sync_size = local_devdata->max_sync_size;
+	dev = local_devdata->dev;
+
+	workmem = PTR_ALIGN(wmem, WORKMEM_ALIGN);
 
 	/* Init scatterlist */
 	slin.entries = (struct nx842_slentry *)workmem->slin;
@@ -558,119 +473,55 @@ static int nx842_pseries_decompress(const unsigned char *in, unsigned int inlen,
 	memset(csbcpb, 0, sizeof(*csbcpb));
 	op.csbcpb = nx842_get_pa(csbcpb);
 
-	/*
-	 * max_sync_size may have changed since compression,
-	 * so we can't read it from the device info. We need
-	 * to derive it from hdr->blocks_nr.
-	 */
-	max_sync_size = PAGE_SIZE / hdr->blocks_nr;
-
-	for (i = 0; i < hdr->blocks_nr; i++) {
-		/* Skip padding */
-		inbuf = ALIGN(inbuf, IO_BUFFER_ALIGN);
-
-		if (hdr->sizes[i] < 0) {
-			/* Negative sizes indicate uncompressed data blocks */
-			size = abs(hdr->sizes[i]);
-			memcpy((void *)outbuf, (void *)inbuf, size);
-			outbuf += size;
-			inbuf += size;
-			continue;
-		}
-
-		if (!dev)
-			goto sw;
-
-		/*
-		 * The better the compression, the more likely the "likely"
-		 * case becomes.
-		 */
-		if (likely((inbuf & NX842_HW_PAGE_MASK) ==
-			((inbuf + hdr->sizes[i] - 1) & NX842_HW_PAGE_MASK))) {
-			/* Create direct DDE */
-			op.in = nx842_get_pa((void *)inbuf);
-			op.inlen = hdr->sizes[i];
-		} else {
-			/* Create indirect DDE (scatterlist) */
-			nx842_build_scatterlist(inbuf, hdr->sizes[i] , &slin);
-			op.in = nx842_get_pa(slin.entries);
-			op.inlen = -nx842_get_scatterlist_size(&slin);
-		}
-
-		/*
-		 * NOTE: If the default max_sync_size is changed from 4k
-		 * to 64k, remove the "likely" case below, since a
-		 * scatterlist will always be needed.
-		 */
-		if (likely(max_sync_size == NX842_HW_PAGE_SIZE)) {
-			/* Create direct DDE */
-			op.out = nx842_get_pa((void *)outbuf);
-			op.outlen = max_sync_size;
-		} else {
-			/* Create indirect DDE (scatterlist) */
-			nx842_build_scatterlist(outbuf, max_sync_size, &slout);
-			op.out = nx842_get_pa(slout.entries);
-			op.outlen = -nx842_get_scatterlist_size(&slout);
-		}
-
-		/* Send request to pHyp */
-		ret = vio_h_cop_sync(local_devdata->vdev, &op);
-
-		/* Check for pHyp error */
-		if (ret) {
-			dev_dbg(dev, "%s: vio_h_cop_sync error (ret=%d, hret=%ld)\n",
-				__func__, ret, op.hcall_err);
-			dev = NULL;
-			goto sw;
-		}
+	if ((inbuf & NX842_HW_PAGE_MASK) ==
+	    ((inbuf + inlen - 1) & NX842_HW_PAGE_MASK)) {
+		/* Create direct DDE */
+		op.in = nx842_get_pa((void *)inbuf);
+		op.inlen = inlen;
+	} else {
+		/* Create indirect DDE (scatterlist) */
+		nx842_build_scatterlist(inbuf, inlen, &slin);
+		op.in = nx842_get_pa(slin.entries);
+		op.inlen = -nx842_get_scatterlist_size(&slin);
+	}
 
-		/* Check for hardware error */
-		ret = nx842_validate_result(dev, &csbcpb->csb);
-		if (ret) {
-			dev = NULL;
-			goto sw;
-		}
+	if ((outbuf & NX842_HW_PAGE_MASK) ==
+	    ((outbuf + *outlen - 1) & NX842_HW_PAGE_MASK)) {
+		/* Create direct DDE */
+		op.out = nx842_get_pa((void *)outbuf);
+		op.outlen = *outlen;
+	} else {
+		/* Create indirect DDE (scatterlist) */
+		nx842_build_scatterlist(outbuf, *outlen, &slout);
+		op.out = nx842_get_pa(slout.entries);
+		op.outlen = -nx842_get_scatterlist_size(&slout);
+	}
 
-		/* HW decompression success */
-		inbuf += hdr->sizes[i];
-		outbuf += csbcpb->csb.processed_byte_count;
-		continue;
-
-sw:
-		/* software decompression */
-		size = max_sync_size;
-		ret = sw842_decompress(
-			(unsigned char *)inbuf, hdr->sizes[i],
-			(unsigned char *)outbuf, &size, wmem);
-		if (ret)
-			pr_debug("%s: sw842_decompress failed with %d\n",
-				__func__, ret);
-
-		if (ret) {
-			if (ret != -ENOSPC && ret != -EINVAL &&
-					ret != -EMSGSIZE)
-				ret = -EIO;
-			goto unlock;
-		}
+	/* Send request to pHyp */
+	ret = vio_h_cop_sync(local_devdata->vdev, &op);
 
-		/* SW decompression success */
-		inbuf += hdr->sizes[i];
-		outbuf += size;
+	/* Check for pHyp error */
+	if (ret) {
+		dev_dbg(dev, "%s: vio_h_cop_sync error (ret=%d, hret=%ld)\n",
+			__func__, ret, op.hcall_err);
+		goto unlock;
 	}
 
-	*outlen = (unsigned int)(outbuf - (unsigned long)out);
+	/* Check for hardware error */
+	ret = nx842_validate_result(dev, &csbcpb->csb);
+	if (ret)
+		goto unlock;
+
+	*outlen = csbcpb->csb.processed_byte_count;
 
 unlock:
 	if (ret)
 		/* decompress fail */
 		nx842_inc_decomp_failed(local_devdata);
 	else {
-		if (!dev)
-			/* software decompress */
-			nx842_inc_swdecomp(local_devdata);
 		nx842_inc_decomp_complete(local_devdata);
 		ibm_nx842_incr_hist(local_devdata->counters->decomp_times,
-			(get_tb() - start_time) / tb_ticks_per_usec);
+			(get_tb() - start) / tb_ticks_per_usec);
 	}
 
 	rcu_read_unlock();
@@ -829,9 +680,9 @@ static int nx842_OF_upd_maxsyncop(struct nx842_devdata *devdata,
 					maxsynccop->decomp_data_limit);
 
 	devdata->max_sync_size = min_t(unsigned int, devdata->max_sync_size,
-					SIZE_64K);
+					65536);
 
-	if (devdata->max_sync_size < SIZE_4K) {
+	if (devdata->max_sync_size < 4096) {
 		dev_err(devdata->dev, "%s: hardware max data size (%u) is "
 				"less than the driver minimum, unable to use "
 				"the hardware device\n",
@@ -1220,17 +1071,17 @@ static int __exit nx842_remove(struct vio_dev *viodev)
 	return 0;
 }
 
-static struct vio_device_id nx842_driver_ids[] = {
+static struct vio_device_id nx842_vio_driver_ids[] = {
 	{NX842_PSERIES_COMPAT_NAME "-v1", NX842_PSERIES_COMPAT_NAME},
 	{"", ""},
 };
 
-static struct vio_driver nx842_driver = {
+static struct vio_driver nx842_vio_driver = {
 	.name = MODULE_NAME,
 	.probe = nx842_probe,
 	.remove = __exit_p(nx842_remove),
 	.get_desired_dma = nx842_get_desired_dma,
-	.id_table = nx842_driver_ids,
+	.id_table = nx842_vio_driver_ids,
 };
 
 static int __init nx842_init(void)
@@ -1249,7 +1100,7 @@ static int __init nx842_init(void)
 	new_devdata->status = UNAVAILABLE;
 	RCU_INIT_POINTER(devdata, new_devdata);
 
-	return vio_register_driver(&nx842_driver);
+	return vio_register_driver(&nx842_vio_driver);
 }
 
 module_init(nx842_init);
@@ -1266,336 +1117,12 @@ static void __exit nx842_exit(void)
 	RCU_INIT_POINTER(devdata, NULL);
 	spin_unlock_irqrestore(&devdata_mutex, flags);
 	synchronize_rcu();
-	if (old_devdata)
+	if (old_devdata && old_devdata->dev)
 		dev_set_drvdata(old_devdata->dev, NULL);
 	kfree(old_devdata);
 	nx842_unregister_driver(&nx842_pseries_driver);
-	vio_unregister_driver(&nx842_driver);
+	vio_unregister_driver(&nx842_vio_driver);
 }
 
 module_exit(nx842_exit);
 
-/*********************************
- * 842 software decompressor
-*********************************/
-typedef int (*sw842_template_op)(const char **, int *, unsigned char **,
-						struct sw842_fifo *);
-
-static int sw842_data8(const char **, int *, unsigned char **,
-						struct sw842_fifo *);
-static int sw842_data4(const char **, int *, unsigned char **,
-						struct sw842_fifo *);
-static int sw842_data2(const char **, int *, unsigned char **,
-						struct sw842_fifo *);
-static int sw842_ptr8(const char **, int *, unsigned char **,
-						struct sw842_fifo *);
-static int sw842_ptr4(const char **, int *, unsigned char **,
-						struct sw842_fifo *);
-static int sw842_ptr2(const char **, int *, unsigned char **,
-						struct sw842_fifo *);
-
-/* special templates */
-#define SW842_TMPL_REPEAT 0x1B
-#define SW842_TMPL_ZEROS 0x1C
-#define SW842_TMPL_EOF 0x1E
-
-static sw842_template_op sw842_tmpl_ops[26][4] = {
-	{ sw842_data8, NULL}, /* 0 (00000) */
-	{ sw842_data4, sw842_data2, sw842_ptr2,  NULL},
-	{ sw842_data4, sw842_ptr2,  sw842_data2, NULL},
-	{ sw842_data4, sw842_ptr2,  sw842_ptr2,  NULL},
-	{ sw842_data4, sw842_ptr4,  NULL},
-	{ sw842_data2, sw842_ptr2,  sw842_data4, NULL},
-	{ sw842_data2, sw842_ptr2,  sw842_data2, sw842_ptr2},
-	{ sw842_data2, sw842_ptr2,  sw842_ptr2,  sw842_data2},
-	{ sw842_data2, sw842_ptr2,  sw842_ptr2,  sw842_ptr2,},
-	{ sw842_data2, sw842_ptr2,  sw842_ptr4,  NULL},
-	{ sw842_ptr2,  sw842_data2, sw842_data4, NULL}, /* 10 (01010) */
-	{ sw842_ptr2,  sw842_data4, sw842_ptr2,  NULL},
-	{ sw842_ptr2,  sw842_data2, sw842_ptr2,  sw842_data2},
-	{ sw842_ptr2,  sw842_data2, sw842_ptr2,  sw842_ptr2},
-	{ sw842_ptr2,  sw842_data2, sw842_ptr4,  NULL},
-	{ sw842_ptr2,  sw842_ptr2,  sw842_data4, NULL},
-	{ sw842_ptr2,  sw842_ptr2,  sw842_data2, sw842_ptr2},
-	{ sw842_ptr2,  sw842_ptr2,  sw842_ptr2,  sw842_data2},
-	{ sw842_ptr2,  sw842_ptr2,  sw842_ptr2,  sw842_ptr2},
-	{ sw842_ptr2,  sw842_ptr2,  sw842_ptr4,  NULL},
-	{ sw842_ptr4,  sw842_data4, NULL}, /* 20 (10100) */
-	{ sw842_ptr4,  sw842_data2, sw842_ptr2,  NULL},
-	{ sw842_ptr4,  sw842_ptr2,  sw842_data2, NULL},
-	{ sw842_ptr4,  sw842_ptr2,  sw842_ptr2,  NULL},
-	{ sw842_ptr4,  sw842_ptr4,  NULL},
-	{ sw842_ptr8,  NULL}
-};
-
-/* Software decompress helpers */
-
-static uint8_t sw842_get_byte(const char *buf, int bit)
-{
-	uint8_t tmpl;
-	uint16_t tmp;
-	tmp = htons(*(uint16_t *)(buf));
-	tmp = (uint16_t)(tmp << bit);
-	tmp = ntohs(tmp);
-	memcpy(&tmpl, &tmp, 1);
-	return tmpl;
-}
-
-static uint8_t sw842_get_template(const char **buf, int *bit)
-{
-	uint8_t byte;
-	byte = sw842_get_byte(*buf, *bit);
-	byte = byte >> 3;
-	byte &= 0x1F;
-	*buf += (*bit + 5) / 8;
-	*bit = (*bit + 5) % 8;
-	return byte;
-}
-
-/* repeat_count happens to be 5-bit too (like the template) */
-static uint8_t sw842_get_repeat_count(const char **buf, int *bit)
-{
-	uint8_t byte;
-	byte = sw842_get_byte(*buf, *bit);
-	byte = byte >> 2;
-	byte &= 0x3F;
-	*buf += (*bit + 6) / 8;
-	*bit = (*bit + 6) % 8;
-	return byte;
-}
-
-static uint8_t sw842_get_ptr2(const char **buf, int *bit)
-{
-	uint8_t ptr;
-	ptr = sw842_get_byte(*buf, *bit);
-	(*buf)++;
-	return ptr;
-}
-
-static uint16_t sw842_get_ptr4(const char **buf, int *bit,
-		struct sw842_fifo *fifo)
-{
-	uint16_t ptr;
-	ptr = htons(*(uint16_t *)(*buf));
-	ptr = (uint16_t)(ptr << *bit);
-	ptr = ptr >> 7;
-	ptr &= 0x01FF;
-	*buf += (*bit + 9) / 8;
-	*bit = (*bit + 9) % 8;
-	return ptr;
-}
-
-static uint8_t sw842_get_ptr8(const char **buf, int *bit,
-		struct sw842_fifo *fifo)
-{
-	return sw842_get_ptr2(buf, bit);
-}
-
-/* Software decompress template ops */
-
-static int sw842_data8(const char **inbuf, int *inbit,
-		unsigned char **outbuf, struct sw842_fifo *fifo)
-{
-	int ret;
-
-	ret = sw842_data4(inbuf, inbit, outbuf, fifo);
-	if (ret)
-		return ret;
-	ret = sw842_data4(inbuf, inbit, outbuf, fifo);
-	return ret;
-}
-
-static int sw842_data4(const char **inbuf, int *inbit,
-		unsigned char **outbuf, struct sw842_fifo *fifo)
-{
-	int ret;
-
-	ret = sw842_data2(inbuf, inbit, outbuf, fifo);
-	if (ret)
-		return ret;
-	ret = sw842_data2(inbuf, inbit, outbuf, fifo);
-	return ret;
-}
-
-static int sw842_data2(const char **inbuf, int *inbit,
-		unsigned char **outbuf, struct sw842_fifo *fifo)
-{
-	**outbuf = sw842_get_byte(*inbuf, *inbit);
-	(*inbuf)++;
-	(*outbuf)++;
-	**outbuf = sw842_get_byte(*inbuf, *inbit);
-	(*inbuf)++;
-	(*outbuf)++;
-	return 0;
-}
-
-static int sw842_ptr8(const char **inbuf, int *inbit,
-		unsigned char **outbuf, struct sw842_fifo *fifo)
-{
-	uint8_t ptr;
-	ptr = sw842_get_ptr8(inbuf, inbit, fifo);
-	if (!fifo->f84_full && (ptr >= fifo->f8_count))
-		return 1;
-	memcpy(*outbuf, fifo->f8[ptr], 8);
-	*outbuf += 8;
-	return 0;
-}
-
-static int sw842_ptr4(const char **inbuf, int *inbit,
-		unsigned char **outbuf, struct sw842_fifo *fifo)
-{
-	uint16_t ptr;
-	ptr = sw842_get_ptr4(inbuf, inbit, fifo);
-	if (!fifo->f84_full && (ptr >= fifo->f4_count))
-		return 1;
-	memcpy(*outbuf, fifo->f4[ptr], 4);
-	*outbuf += 4;
-	return 0;
-}
-
-static int sw842_ptr2(const char **inbuf, int *inbit,
-		unsigned char **outbuf, struct sw842_fifo *fifo)
-{
-	uint8_t ptr;
-	ptr = sw842_get_ptr2(inbuf, inbit);
-	if (!fifo->f2_full && (ptr >= fifo->f2_count))
-		return 1;
-	memcpy(*outbuf, fifo->f2[ptr], 2);
-	*outbuf += 2;
-	return 0;
-}
-
-static void sw842_copy_to_fifo(const char *buf, struct sw842_fifo *fifo)
-{
-	unsigned char initial_f2count = fifo->f2_count;
-
-	memcpy(fifo->f8[fifo->f8_count], buf, 8);
-	fifo->f4_count += 2;
-	fifo->f8_count += 1;
-
-	if (!fifo->f84_full && fifo->f4_count >= 512) {
-		fifo->f84_full = 1;
-		fifo->f4_count /= 512;
-	}
-
-	memcpy(fifo->f2[fifo->f2_count++], buf, 2);
-	memcpy(fifo->f2[fifo->f2_count++], buf + 2, 2);
-	memcpy(fifo->f2[fifo->f2_count++], buf + 4, 2);
-	memcpy(fifo->f2[fifo->f2_count++], buf + 6, 2);
-	if (fifo->f2_count < initial_f2count)
-		fifo->f2_full = 1;
-}
-
-static int sw842_decompress(const unsigned char *src, int srclen,
-			unsigned char *dst, int *destlen,
-			const void *wrkmem)
-{
-	uint8_t tmpl;
-	const char *inbuf;
-	int inbit = 0;
-	unsigned char *outbuf, *outbuf_end, *origbuf, *prevbuf;
-	const char *inbuf_end;
-	sw842_template_op op;
-	int opindex;
-	int i, repeat_count;
-	struct sw842_fifo *fifo;
-	int ret = 0;
-
-	fifo = &((struct nx842_workmem *)(wrkmem))->swfifo;
-	memset(fifo, 0, sizeof(*fifo));
-
-	origbuf = NULL;
-	inbuf = src;
-	inbuf_end = src + srclen;
-	outbuf = dst;
-	outbuf_end = dst + *destlen;
-
-	while ((tmpl = sw842_get_template(&inbuf, &inbit)) != SW842_TMPL_EOF) {
-		if (inbuf >= inbuf_end) {
-			ret = -EINVAL;
-			goto out;
-		}
-
-		opindex = 0;
-		prevbuf = origbuf;
-		origbuf = outbuf;
-		switch (tmpl) {
-		case SW842_TMPL_REPEAT:
-			if (prevbuf == NULL) {
-				ret = -EINVAL;
-				goto out;
-			}
-
-			repeat_count = sw842_get_repeat_count(&inbuf,
-								&inbit) + 1;
-
-			/* Did the repeat count advance past the end of input */
-			if (inbuf > inbuf_end) {
-				ret = -EINVAL;
-				goto out;
-			}
-
-			for (i = 0; i < repeat_count; i++) {
-				/* Would this overflow the output buffer */
-				if ((outbuf + 8) > outbuf_end) {
-					ret = -ENOSPC;
-					goto out;
-				}
-
-				memcpy(outbuf, prevbuf, 8);
-				sw842_copy_to_fifo(outbuf, fifo);
-				outbuf += 8;
-			}
-			break;
-
-		case SW842_TMPL_ZEROS:
-			/* Would this overflow the output buffer */
-			if ((outbuf + 8) > outbuf_end) {
-				ret = -ENOSPC;
-				goto out;
-			}
-
-			memset(outbuf, 0, 8);
-			sw842_copy_to_fifo(outbuf, fifo);
-			outbuf += 8;
-			break;
-
-		default:
-			if (tmpl > 25) {
-				ret = -EINVAL;
-				goto out;
-			}
-
-			/* Does this go past the end of the input buffer */
-			if ((inbuf + 2) > inbuf_end) {
-				ret = -EINVAL;
-				goto out;
-			}
-
-			/* Would this overflow the output buffer */
-			if ((outbuf + 8) > outbuf_end) {
-				ret = -ENOSPC;
-				goto out;
-			}
-
-			while (opindex < 4 &&
-				(op = sw842_tmpl_ops[tmpl][opindex++])
-					!= NULL) {
-				ret = (*op)(&inbuf, &inbit, &outbuf, fifo);
-				if (ret) {
-					ret = -EINVAL;
-					goto out;
-				}
-				sw842_copy_to_fifo(origbuf, fifo);
-			}
-		}
-	}
-
-out:
-	if (!ret)
-		*destlen = (unsigned int)(outbuf - dst);
-	else
-		*destlen = 0;
-
-	return ret;
-}
-- 
2.1.0
