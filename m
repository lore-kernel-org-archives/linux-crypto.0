From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [v4 PATCH 2/8] crypto: rsa - Generate fixed-length output
Date: Wed, 29 Jun 2016 19:32:21 +0800
Message-ID: <E1bIDjB-0007Cn-Ju@gondolin.me.apana.org.au>
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
Received: from helcar.hengli.com.au ([209.40.204.226]:44569 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751825AbcF2LcY (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 29 Jun 2016 07:32:24 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Every implementation of RSA that we have naturally generates
output with leading zeroes.  The one and only user of RSA,
pkcs1pad wants to have those leading zeroes in place, in fact
because they are currently absent it has to write those zeroes
itself.

So we shouldn't be stripping leading zeroes in the first place.
In fact this patch makes rsa-generic produce output with fixed
length so that pkcs1pad does not need to do any extra work.

This patch also changes DH to use the new interface.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---

 crypto/dh.c         |    2 -
 crypto/rsa.c        |    8 +++----
 include/linux/mpi.h |    2 -
 lib/mpi/mpicoder.c  |   55 ++++++++++++++++++++++++----------------------------
 4 files changed, 32 insertions(+), 35 deletions(-)

diff --git a/crypto/dh.c b/crypto/dh.c
index 5e960fe..9d19360 100644
--- a/crypto/dh.c
+++ b/crypto/dh.c
@@ -129,7 +129,7 @@ static int dh_compute_value(struct kpp_request *req)
 	if (ret)
 		goto err_free_base;
 
-	ret = mpi_write_to_sgl(val, req->dst, &req->dst_len, &sign);
+	ret = mpi_write_to_sgl(val, req->dst, req->dst_len, &sign);
 	if (ret)
 		goto err_free_base;
 
diff --git a/crypto/rsa.c b/crypto/rsa.c
index dc692d4..4c280b6 100644
--- a/crypto/rsa.c
+++ b/crypto/rsa.c
@@ -108,7 +108,7 @@ static int rsa_enc(struct akcipher_request *req)
 	if (ret)
 		goto err_free_m;
 
-	ret = mpi_write_to_sgl(c, req->dst, &req->dst_len, &sign);
+	ret = mpi_write_to_sgl(c, req->dst, req->dst_len, &sign);
 	if (ret)
 		goto err_free_m;
 
@@ -147,7 +147,7 @@ static int rsa_dec(struct akcipher_request *req)
 	if (ret)
 		goto err_free_c;
 
-	ret = mpi_write_to_sgl(m, req->dst, &req->dst_len, &sign);
+	ret = mpi_write_to_sgl(m, req->dst, req->dst_len, &sign);
 	if (ret)
 		goto err_free_c;
 
@@ -185,7 +185,7 @@ static int rsa_sign(struct akcipher_request *req)
 	if (ret)
 		goto err_free_m;
 
-	ret = mpi_write_to_sgl(s, req->dst, &req->dst_len, &sign);
+	ret = mpi_write_to_sgl(s, req->dst, req->dst_len, &sign);
 	if (ret)
 		goto err_free_m;
 
@@ -226,7 +226,7 @@ static int rsa_verify(struct akcipher_request *req)
 	if (ret)
 		goto err_free_s;
 
-	ret = mpi_write_to_sgl(m, req->dst, &req->dst_len, &sign);
+	ret = mpi_write_to_sgl(m, req->dst, req->dst_len, &sign);
 	if (ret)
 		goto err_free_s;
 
diff --git a/include/linux/mpi.h b/include/linux/mpi.h
index f219559..1cc5ffb 100644
--- a/include/linux/mpi.h
+++ b/include/linux/mpi.h
@@ -80,7 +80,7 @@ void *mpi_get_buffer(MPI a, unsigned *nbytes, int *sign);
 int mpi_read_buffer(MPI a, uint8_t *buf, unsigned buf_len, unsigned *nbytes,
 		    int *sign);
 void *mpi_get_secure_buffer(MPI a, unsigned *nbytes, int *sign);
-int mpi_write_to_sgl(MPI a, struct scatterlist *sg, unsigned *nbytes,
+int mpi_write_to_sgl(MPI a, struct scatterlist *sg, unsigned nbytes,
 		     int *sign);
 
 #define log_mpidump g10_log_mpidump
diff --git a/lib/mpi/mpicoder.c b/lib/mpi/mpicoder.c
index 823cf5f..7150e5c 100644
--- a/lib/mpi/mpicoder.c
+++ b/lib/mpi/mpicoder.c
@@ -237,16 +237,13 @@ EXPORT_SYMBOL_GPL(mpi_get_buffer);
  * @a:		a multi precision integer
  * @sgl:	scatterlist to write to. Needs to be at least
  *		mpi_get_size(a) long.
- * @nbytes:	in/out param - it has the be set to the maximum number of
- *		bytes that can be written to sgl. This has to be at least
- *		the size of the integer a. On return it receives the actual
- *		length of the data written on success or the data that would
- *		be written if buffer was too small.
+ * @nbytes:	the number of bytes to write.  Leading bytes will be
+ *		filled with zero.
  * @sign:	if not NULL, it will be set to the sign of a.
  *
  * Return:	0 on success or error code in case of error
  */
-int mpi_write_to_sgl(MPI a, struct scatterlist *sgl, unsigned *nbytes,
+int mpi_write_to_sgl(MPI a, struct scatterlist *sgl, unsigned nbytes,
 		     int *sign)
 {
 	u8 *p, *p2;
@@ -258,43 +255,44 @@ int mpi_write_to_sgl(MPI a, struct scatterlist *sgl, unsigned *nbytes,
 #error please implement for this limb size.
 #endif
 	unsigned int n = mpi_get_size(a);
-	int i, x, y = 0, lzeros, buf_len;
-
-	if (!nbytes)
-		return -EINVAL;
+	int i, x, buf_len;
 
 	if (sign)
 		*sign = a->sign;
 
-	lzeros = count_lzeros(a);
-
-	if (*nbytes < n - lzeros) {
-		*nbytes = n - lzeros;
+	if (nbytes < n)
 		return -EOVERFLOW;
-	}
 
-	*nbytes = n - lzeros;
 	buf_len = sgl->length;
 	p2 = sg_virt(sgl);
 
-	for (i = a->nlimbs - 1 - lzeros / BYTES_PER_MPI_LIMB,
-			lzeros %= BYTES_PER_MPI_LIMB;
-		i >= 0; i--) {
+	while (nbytes > n) {
+		if (!buf_len) {
+			sgl = sg_next(sgl);
+			if (!sgl)
+				return -EINVAL;
+			buf_len = sgl->length;
+			p2 = sg_virt(sgl);
+		}
+
+		i = min_t(unsigned, nbytes - n, buf_len);
+		memset(p2, 0, i);
+		p2 += i;
+		buf_len -= i;
+		nbytes -= i;
+	}
+
+	for (i = a->nlimbs - 1; i >= 0; i--) {
 #if BYTES_PER_MPI_LIMB == 4
-		alimb = cpu_to_be32(a->d[i]);
+		alimb = a->d[i] ? cpu_to_be32(a->d[i]) : 0;
 #elif BYTES_PER_MPI_LIMB == 8
-		alimb = cpu_to_be64(a->d[i]);
+		alimb = a->d[i] ? cpu_to_be64(a->d[i]) : 0;
 #else
 #error please implement for this limb size.
 #endif
-		if (lzeros) {
-			y = lzeros;
-			lzeros = 0;
-		}
-
-		p = (u8 *)&alimb + y;
+		p = (u8 *)&alimb;
 
-		for (x = 0; x < sizeof(alimb) - y; x++) {
+		for (x = 0; x < sizeof(alimb); x++) {
 			if (!buf_len) {
 				sgl = sg_next(sgl);
 				if (!sgl)
@@ -305,7 +303,6 @@ int mpi_write_to_sgl(MPI a, struct scatterlist *sgl, unsigned *nbytes,
 			*p2++ = *p++;
 			buf_len--;
 		}
-		y = 0;
 	}
 	return 0;
 }
