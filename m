From: Michael Ellerman <michael@ellerman.id.au>
Subject: [PATCH] powerpc/crypto: Remove virt_to_abs() usage in nx-842.c
Date: Fri,  3 Aug 2012 12:23:15 +1000
Message-ID: <1343960595-30232-1-git-send-email-michael@ellerman.id.au>
Cc: linux-crypto@vger.kernel.org, <linuxppc-dev@ozlabs.org>,
	Benjamin Herrenschmidt <benh@kernel.crashing.org>,
	sjenning@linux.vnet.ibm.com
To: herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from ozlabs.org ([203.10.76.45]:59521 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751265Ab2HCCbJ (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Thu, 2 Aug 2012 22:31:09 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

virt_to_abs() is just a wrapper around __pa(), use __pa() directly.

We should be including <asm/page.h> to get __pa(). abs_addr.h will be
removed shortly so drop that.

We were getting of.h via abs_addr.h so we need to include that directly.

Having done all that, clean up the ordering of the includes.

Signed-off-by: Michael Ellerman <michael@ellerman.id.au>
---
 drivers/crypto/nx/nx-842.c |   34 ++++++++++++++++++----------------
 1 file changed, 18 insertions(+), 16 deletions(-)

diff --git a/drivers/crypto/nx/nx-842.c b/drivers/crypto/nx/nx-842.c
index 9da0fb2..0ce6257 100644
--- a/drivers/crypto/nx/nx-842.c
+++ b/drivers/crypto/nx/nx-842.c
@@ -21,13 +21,15 @@
  *          Seth Jennings <sjenning@linux.vnet.ibm.com>
  */
 
+#include <linux/kernel.h>
 #include <linux/module.h>
-#include <asm/vio.h>
-#include <asm/pSeries_reconfig.h>
-#include <linux/slab.h>
-#include <asm/abs_addr.h>
 #include <linux/nx842.h>
-#include <linux/kernel.h>
+#include <linux/of.h>
+#include <linux/slab.h>
+
+#include <asm/page.h>
+#include <asm/pSeries_reconfig.h>
+#include <asm/vio.h>
 
 #include "nx_csbcpb.h" /* struct nx_csbcpb */
 
@@ -140,7 +142,7 @@ static unsigned long nx842_get_desired_dma(struct vio_dev *viodev)
 }
 
 struct nx842_slentry {
-	unsigned long ptr; /* Absolute address (use virt_to_abs()) */
+	unsigned long ptr; /* Real address (use __pa()) */
 	unsigned long len;
 };
 
@@ -167,7 +169,7 @@ static int nx842_build_scatterlist(unsigned long buf, int len,
 
 	entry = sl->entries;
 	while (len) {
-		entry->ptr = virt_to_abs(buf);
+		entry->ptr = __pa(buf);
 		nextpage = ALIGN(buf + 1, NX842_HW_PAGE_SIZE);
 		if (nextpage < buf + len) {
 			/* we aren't at the end yet */
@@ -369,8 +371,8 @@ int nx842_compress(const unsigned char *in, unsigned int inlen,
 	op.flags = NX842_OP_COMPRESS;
 	csbcpb = &workmem->csbcpb;
 	memset(csbcpb, 0, sizeof(*csbcpb));
-	op.csbcpb = virt_to_abs(csbcpb);
-	op.out = virt_to_abs(slout.entries);
+	op.csbcpb = __pa(csbcpb);
+	op.out = __pa(slout.entries);
 
 	for (i = 0; i < hdr->blocks_nr; i++) {
 		/*
@@ -400,13 +402,13 @@ int nx842_compress(const unsigned char *in, unsigned int inlen,
 		 */
 		if (likely(max_sync_size == NX842_HW_PAGE_SIZE)) {
 			/* Create direct DDE */
-			op.in = virt_to_abs(inbuf);
+			op.in = __pa(inbuf);
 			op.inlen = max_sync_size;
 
 		} else {
 			/* Create indirect DDE (scatterlist) */
 			nx842_build_scatterlist(inbuf, max_sync_size, &slin);
-			op.in = virt_to_abs(slin.entries);
+			op.in = __pa(slin.entries);
 			op.inlen = -nx842_get_scatterlist_size(&slin);
 		}
 
@@ -564,7 +566,7 @@ int nx842_decompress(const unsigned char *in, unsigned int inlen,
 	op.flags = NX842_OP_DECOMPRESS;
 	csbcpb = &workmem->csbcpb;
 	memset(csbcpb, 0, sizeof(*csbcpb));
-	op.csbcpb = virt_to_abs(csbcpb);
+	op.csbcpb = __pa(csbcpb);
 
 	/*
 	 * max_sync_size may have changed since compression,
@@ -596,12 +598,12 @@ int nx842_decompress(const unsigned char *in, unsigned int inlen,
 		if (likely((inbuf & NX842_HW_PAGE_MASK) ==
 			((inbuf + hdr->sizes[i] - 1) & NX842_HW_PAGE_MASK))) {
 			/* Create direct DDE */
-			op.in = virt_to_abs(inbuf);
+			op.in = __pa(inbuf);
 			op.inlen = hdr->sizes[i];
 		} else {
 			/* Create indirect DDE (scatterlist) */
 			nx842_build_scatterlist(inbuf, hdr->sizes[i] , &slin);
-			op.in = virt_to_abs(slin.entries);
+			op.in = __pa(slin.entries);
 			op.inlen = -nx842_get_scatterlist_size(&slin);
 		}
 
@@ -612,12 +614,12 @@ int nx842_decompress(const unsigned char *in, unsigned int inlen,
 		 */
 		if (likely(max_sync_size == NX842_HW_PAGE_SIZE)) {
 			/* Create direct DDE */
-			op.out = virt_to_abs(outbuf);
+			op.out = __pa(outbuf);
 			op.outlen = max_sync_size;
 		} else {
 			/* Create indirect DDE (scatterlist) */
 			nx842_build_scatterlist(outbuf, max_sync_size, &slout);
-			op.out = virt_to_abs(slout.entries);
+			op.out = __pa(slout.entries);
 			op.outlen = -nx842_get_scatterlist_size(&slout);
 		}
 
-- 
1.7.9.5
