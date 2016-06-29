From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [v4 PATCH 3/8] lib/mpi: Do not do sg_virt
Date: Wed, 29 Jun 2016 19:32:22 +0800
Message-ID: <E1bIDjC-0007D4-MX@gondolin.me.apana.org.au>
References: <20160629113125.GA27643@gondor.apana.org.au>
To: Andrzej Zaborowski <andrew.zaborowski@intel.com>,
	Tadeusz Struk <tadeusz.struk@intel.com>,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
	Tudor Ambarus <tudor-dan.ambarus@nxp.com>,
	Stephan Mueller <smueller@chronox.de>,
	Mat Martineau <mathew.j.martineau@linux.intel.com>,
	Denis Kenzior <denkenz@gmail.com>,
	Salvatore Benedetto <salvatore.benedetto@intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:39373 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751936AbcF2LcZ (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 29 Jun 2016 07:32:25 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Currently the mpi SG helpers use sg_virt which is completely
broken.  It happens to work with normal kernel memory but will
fail with anything that is not linearly mapped.

This patch fixes this by using the SG iterator helpers.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---

 lib/mpi/mpicoder.c |   86 ++++++++++++++++++++++++++++++-----------------------
 1 file changed, 50 insertions(+), 36 deletions(-)

diff --git a/lib/mpi/mpicoder.c b/lib/mpi/mpicoder.c
index 7150e5c..c6272ae 100644
--- a/lib/mpi/mpicoder.c
+++ b/lib/mpi/mpicoder.c
@@ -21,6 +21,7 @@
 #include <linux/bitops.h>
 #include <linux/count_zeros.h>
 #include <linux/byteorder/generic.h>
+#include <linux/scatterlist.h>
 #include <linux/string.h>
 #include "mpi-internal.h"
 
@@ -255,7 +256,9 @@ int mpi_write_to_sgl(MPI a, struct scatterlist *sgl, unsigned nbytes,
 #error please implement for this limb size.
 #endif
 	unsigned int n = mpi_get_size(a);
+	struct sg_mapping_iter miter;
 	int i, x, buf_len;
+	int nents;
 
 	if (sign)
 		*sign = a->sign;
@@ -263,23 +266,27 @@ int mpi_write_to_sgl(MPI a, struct scatterlist *sgl, unsigned nbytes,
 	if (nbytes < n)
 		return -EOVERFLOW;
 
-	buf_len = sgl->length;
-	p2 = sg_virt(sgl);
+	nents = sg_nents_for_len(sgl, nbytes);
+	if (nents < 0)
+		return -EINVAL;
 
-	while (nbytes > n) {
-		if (!buf_len) {
-			sgl = sg_next(sgl);
-			if (!sgl)
-				return -EINVAL;
-			buf_len = sgl->length;
-			p2 = sg_virt(sgl);
-		}
+	sg_miter_start(&miter, sgl, nents, SG_MITER_ATOMIC | SG_MITER_TO_SG);
+	sg_miter_next(&miter);
+	buf_len = miter.length;
+	p2 = miter.addr;
 
+	while (nbytes > n) {
 		i = min_t(unsigned, nbytes - n, buf_len);
 		memset(p2, 0, i);
 		p2 += i;
-		buf_len -= i;
 		nbytes -= i;
+
+		buf_len -= i;
+		if (!buf_len) {
+			sg_miter_next(&miter);
+			buf_len = miter.length;
+			p2 = miter.addr;
+		}
 	}
 
 	for (i = a->nlimbs - 1; i >= 0; i--) {
@@ -293,17 +300,16 @@ int mpi_write_to_sgl(MPI a, struct scatterlist *sgl, unsigned nbytes,
 		p = (u8 *)&alimb;
 
 		for (x = 0; x < sizeof(alimb); x++) {
-			if (!buf_len) {
-				sgl = sg_next(sgl);
-				if (!sgl)
-					return -EINVAL;
-				buf_len = sgl->length;
-				p2 = sg_virt(sgl);
-			}
 			*p2++ = *p++;
-			buf_len--;
+			if (!--buf_len) {
+				sg_miter_next(&miter);
+				buf_len = miter.length;
+				p2 = miter.addr;
+			}
 		}
 	}
+
+	sg_miter_stop(&miter);
 	return 0;
 }
 EXPORT_SYMBOL_GPL(mpi_write_to_sgl);
@@ -323,19 +329,23 @@ EXPORT_SYMBOL_GPL(mpi_write_to_sgl);
  */
 MPI mpi_read_raw_from_sgl(struct scatterlist *sgl, unsigned int nbytes)
 {
-	struct scatterlist *sg;
-	int x, i, j, z, lzeros, ents;
+	struct sg_mapping_iter miter;
 	unsigned int nbits, nlimbs;
+	int x, j, z, lzeros, ents;
+	unsigned int len;
+	const u8 *buff;
 	mpi_limb_t a;
 	MPI val = NULL;
 
-	lzeros = 0;
-	ents = sg_nents(sgl);
+	ents = sg_nents_for_len(sgl, nbytes);
+	if (ents < 0)
+		return NULL;
 
-	for_each_sg(sgl, sg, ents, i) {
-		const u8 *buff = sg_virt(sg);
-		int len = sg->length;
+	sg_miter_start(&miter, sgl, ents, SG_MITER_ATOMIC | SG_MITER_FROM_SG);
 
+	lzeros = 0;
+	len = 0;
+	while (nbytes > 0) {
 		while (len && !*buff) {
 			lzeros++;
 			len--;
@@ -345,12 +355,14 @@ MPI mpi_read_raw_from_sgl(struct scatterlist *sgl, unsigned int nbytes)
 		if (len && *buff)
 			break;
 
-		ents--;
+		sg_miter_next(&miter);
+		buff = miter.addr;
+		len = miter.length;
+
 		nbytes -= lzeros;
 		lzeros = 0;
 	}
 
-	sgl = sg;
 	nbytes -= lzeros;
 	nbits = nbytes * 8;
 	if (nbits > MAX_EXTERN_MPI_BITS) {
@@ -359,8 +371,7 @@ MPI mpi_read_raw_from_sgl(struct scatterlist *sgl, unsigned int nbytes)
 	}
 
 	if (nbytes > 0)
-		nbits -= count_leading_zeros(*(u8 *)(sg_virt(sgl) + lzeros)) -
-			(BITS_PER_LONG - 8);
+		nbits -= count_leading_zeros(*buff) - (BITS_PER_LONG - 8);
 
 	nlimbs = DIV_ROUND_UP(nbytes, BYTES_PER_MPI_LIMB);
 	val = mpi_alloc(nlimbs);
@@ -379,21 +390,24 @@ MPI mpi_read_raw_from_sgl(struct scatterlist *sgl, unsigned int nbytes)
 	z = BYTES_PER_MPI_LIMB - nbytes % BYTES_PER_MPI_LIMB;
 	z %= BYTES_PER_MPI_LIMB;
 
-	for_each_sg(sgl, sg, ents, i) {
-		const u8 *buffer = sg_virt(sg) + lzeros;
-		int len = sg->length - lzeros;
-
+	for (;;) {
 		for (x = 0; x < len; x++) {
 			a <<= 8;
-			a |= *buffer++;
+			a |= *buff++;
 			if (((z + x + 1) % BYTES_PER_MPI_LIMB) == 0) {
 				val->d[j--] = a;
 				a = 0;
 			}
 		}
 		z += x;
-		lzeros = 0;
+
+		if (!sg_miter_next(&miter))
+			break;
+
+		buff = miter.addr;
+		len = miter.length;
 	}
+
 	return val;
 }
 EXPORT_SYMBOL_GPL(mpi_read_raw_from_sgl);
