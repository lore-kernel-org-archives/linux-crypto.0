From: Tadeusz Struk <tadeusz.struk@intel.com>
Subject: [PATCH  v5 1/2] lib/mpi: Add mpi sgl helpers
Date: Thu, 01 Oct 2015 22:10:38 -0700
Message-ID: <20151002051038.27263.5476.stgit@tstruk-mobl1>
References: <20151002051032.27263.21150.stgit@tstruk-mobl1>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: linux-crypto@vger.kernel.org, qat-linux@intel.com,
	tadeusz.struk@intel.com
To: herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:23557 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751170AbbJBFMn (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Fri, 2 Oct 2015 01:12:43 -0400
In-Reply-To: <20151002051032.27263.21150.stgit@tstruk-mobl1>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Add mpi_read_raw_from_sgl and mpi_write_to_sgl helpers.

Signed-off-by: Tadeusz Struk <tadeusz.struk@intel.com>
---
 include/linux/mpi.h |    4 +
 lib/mpi/mpicoder.c  |  191 +++++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 195 insertions(+)

diff --git a/include/linux/mpi.h b/include/linux/mpi.h
index 641b7d6..8b8269f 100644
--- a/include/linux/mpi.h
+++ b/include/linux/mpi.h
@@ -31,6 +31,7 @@
 #define G10_MPI_H
 
 #include <linux/types.h>
+#include <linux/scatterlist.h>
 
 /* DSI defines */
 
@@ -78,6 +79,7 @@ void mpi_swap(MPI a, MPI b);
 MPI do_encode_md(const void *sha_buffer, unsigned nbits);
 MPI mpi_read_raw_data(const void *xbuffer, size_t nbytes);
 MPI mpi_read_from_buffer(const void *buffer, unsigned *ret_nread);
+MPI mpi_read_raw_from_sgl(struct scatterlist *sgl, unsigned int len);
 int mpi_fromstr(MPI val, const char *str);
 u32 mpi_get_keyid(MPI a, u32 *keyid);
 void *mpi_get_buffer(MPI a, unsigned *nbytes, int *sign);
@@ -85,6 +87,8 @@ int mpi_read_buffer(MPI a, uint8_t *buf, unsigned buf_len, unsigned *nbytes,
 		    int *sign);
 void *mpi_get_secure_buffer(MPI a, unsigned *nbytes, int *sign);
 int mpi_set_buffer(MPI a, const void *buffer, unsigned nbytes, int sign);
+int mpi_write_to_sgl(MPI a, struct scatterlist *sg, unsigned *nbytes,
+		     int *sign);
 
 #define log_mpidump g10_log_mpidump
 
diff --git a/lib/mpi/mpicoder.c b/lib/mpi/mpicoder.c
index 95c52a9..ae1efa8 100644
--- a/lib/mpi/mpicoder.c
+++ b/lib/mpi/mpicoder.c
@@ -319,3 +319,194 @@ int mpi_set_buffer(MPI a, const void *xbuffer, unsigned nbytes, int sign)
 	return 0;
 }
 EXPORT_SYMBOL_GPL(mpi_set_buffer);
+
+/**
+ * mpi_write_to_sgl() - Funnction exports MPI to an sgl (msb first)
+ *
+ * This function works in the same way as the mpi_read_buffer, but it
+ * takes an sgl instead of u8 * buf.
+ *
+ * @a:		a multi precision integer
+ * @sgl:	scatterlist to write to. Needs to be at least
+ *		mpi_get_size(a) long.
+ * @nbytes:	receives the actual length of the data written.
+ * @sign:	if not NULL, it will be set to the sign of a.
+ *
+ * Return:	0 on success or error code in case of error
+ */
+int mpi_write_to_sgl(MPI a, struct scatterlist *sgl, unsigned *nbytes,
+		     int *sign)
+{
+	u8 *p, *p2;
+	mpi_limb_t alimb, alimb2;
+	unsigned int n = mpi_get_size(a);
+	int i, x, y = 0, lzeros = 0, buf_len;
+
+	if (!nbytes)
+		return -EINVAL;
+
+	if (sign)
+		*sign = a->sign;
+
+	p = (void *)&a->d[a->nlimbs] - 1;
+
+	for (i = a->nlimbs * sizeof(alimb) - 1; i >= 0; i--, p--) {
+		if (!*p)
+			lzeros++;
+		else
+			break;
+	}
+
+	*nbytes = n - lzeros;
+	buf_len = sgl->length;
+	p2 = sg_virt(sgl);
+
+	for (i = a->nlimbs - 1; i >= 0; i--) {
+		alimb = a->d[i];
+		p = (u8 *)&alimb2;
+#if BYTES_PER_MPI_LIMB == 4
+		*p++ = alimb >> 24;
+		*p++ = alimb >> 16;
+		*p++ = alimb >> 8;
+		*p++ = alimb;
+#elif BYTES_PER_MPI_LIMB == 8
+		*p++ = alimb >> 56;
+		*p++ = alimb >> 48;
+		*p++ = alimb >> 40;
+		*p++ = alimb >> 32;
+		*p++ = alimb >> 24;
+		*p++ = alimb >> 16;
+		*p++ = alimb >> 8;
+		*p++ = alimb;
+#else
+#error please implement for this limb size.
+#endif
+		if (lzeros > 0) {
+			if (lzeros >= sizeof(alimb)) {
+				p -= sizeof(alimb);
+				continue;
+			} else {
+				mpi_limb_t *limb1 = (void *)p - sizeof(alimb);
+				mpi_limb_t *limb2 = (void *)p - sizeof(alimb)
+							+ lzeros;
+				*limb1 = *limb2;
+				p -= lzeros;
+				y = lzeros;
+			}
+			lzeros -= sizeof(alimb);
+		}
+
+		p = p - (sizeof(alimb) - y);
+
+		for (x = 0; x < sizeof(alimb) - y; x++) {
+			if (!buf_len) {
+				sgl = sg_next(sgl);
+				buf_len = sgl->length;
+				p2 = sg_virt(sgl);
+			}
+			*p2++ = *p++;
+			buf_len--;
+		}
+		y = 0;
+	}
+	return 0;
+}
+EXPORT_SYMBOL_GPL(mpi_write_to_sgl);
+
+/*
+ * mpi_read_raw_from_sgl() - Function allocates an MPI and populates it with
+ *			     data from the sgl
+ *
+ * This function works in the same way as the mpi_read_raw_data, but it
+ * takes an sgl instead of void * buffer. i.e. it allocates
+ * a new MPI and reads the content of the sgl to the MPI.
+ *
+ * @sgl:	scatterlist to read from
+ * @len:	number of bytes to read
+ *
+ * Return:	Pointer to a new MPI or NULL on error
+ */
+MPI mpi_read_raw_from_sgl(struct scatterlist *sgl, unsigned int len)
+{
+	struct scatterlist *sg;
+	int x, i, j, z, lzeros, ents;
+	unsigned int nbits, nlimbs, nbytes;
+	mpi_limb_t a;
+	MPI val = NULL;
+
+	lzeros = 0;
+	ents = sg_nents(sgl);
+
+	for_each_sg(sgl, sg, ents, i) {
+		const u8 *buff = sg_virt(sg);
+		int len = sg->length;
+
+		while (len-- && !*buff++)
+			lzeros++;
+
+		if (len && *buff)
+			break;
+
+		ents--;
+		lzeros = 0;
+	}
+
+	sgl = sg;
+
+	if (!ents)
+		nbytes = 0;
+	else
+		nbytes = len - lzeros;
+
+	nbits = nbytes * 8;
+	if (nbits > MAX_EXTERN_MPI_BITS) {
+		pr_info("MPI: mpi too large (%u bits)\n", nbits);
+		return NULL;
+	}
+
+	if (nbytes > 0)
+		nbits -= count_leading_zeros(*(u8 *)(sg_virt(sgl) + lzeros));
+	else
+		nbits = 0;
+
+	nlimbs = DIV_ROUND_UP(nbytes, BYTES_PER_MPI_LIMB);
+	val = mpi_alloc(nlimbs);
+	if (!val)
+		return NULL;
+
+	val->nbits = nbits;
+	val->sign = 0;
+	val->nlimbs = nlimbs;
+
+	if (nbytes == 0)
+		return val;
+
+	j = nlimbs - 1;
+	a = 0;
+	z = 0;
+	x = BYTES_PER_MPI_LIMB - nbytes % BYTES_PER_MPI_LIMB;
+	x %= BYTES_PER_MPI_LIMB;
+
+	for_each_sg(sgl, sg, ents, i) {
+		const u8 *buffer = sg_virt(sg) + lzeros;
+		int len = sg->length - lzeros;
+		int buf_shift = x;
+
+		if  (sg_is_last(sg) && (len % BYTES_PER_MPI_LIMB))
+			len += BYTES_PER_MPI_LIMB - (len % BYTES_PER_MPI_LIMB);
+
+		for (; x < len + buf_shift; x++) {
+			a <<= 8;
+			a |= *buffer++;
+			if (((z + x + 1) % BYTES_PER_MPI_LIMB) == 0) {
+				val->d[j--] = a;
+				a = 0;
+			}
+		}
+		z += x;
+		x = 0;
+		lzeros = 0;
+	}
+	return val;
+}
+EXPORT_SYMBOL_GPL(mpi_read_raw_from_sgl);
