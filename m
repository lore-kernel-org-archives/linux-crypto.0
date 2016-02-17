From: Michal Marek <mmarek@suse.com>
Subject: [PATCH] MPI: Endianness fix
Date: Wed, 17 Feb 2016 14:46:59 +0100
Message-ID: <1455716819-6771-1-git-send-email-mmarek@suse.com>
Cc: linux-crypto@vger.kernel.org,
	Tadeusz Struk <tadeusz.struk@intel.com>,
	linux-kernel@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:58911 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422986AbcBQNrR (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Wed, 17 Feb 2016 08:47:17 -0500
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

The limbs are integers in the host endianness, so we can't simply
iterate over the individual bytes. The current code happens to work on
little-endian, because the order of the limbs in the MPI array is the
same as the order of the bytes in each limb, but it breaks on
big-endian.

Fixes: 0f74fbf77d45 ("MPI: Fix mpi_read_buffer")
Signed-off-by: Michal Marek <mmarek@suse.com>
---
 lib/mpi/mpicoder.c | 39 +++++++++++++++++++++------------------
 1 file changed, 21 insertions(+), 18 deletions(-)

diff --git a/lib/mpi/mpicoder.c b/lib/mpi/mpicoder.c
index ec533a6c77b5..eb15e7dc7b65 100644
--- a/lib/mpi/mpicoder.c
+++ b/lib/mpi/mpicoder.c
@@ -128,6 +128,23 @@ MPI mpi_read_from_buffer(const void *xbuffer, unsigned *ret_nread)
 }
 EXPORT_SYMBOL_GPL(mpi_read_from_buffer);
 
+static int count_lzeros(MPI a)
+{
+	mpi_limb_t alimb;
+	int i, lzeros = 0;
+
+	for (i = a->nlimbs - 1; i >= 0; i--) {
+		alimb = a->d[i];
+		if (alimb == 0) {
+			lzeros += sizeof(mpi_limb_t);
+		} else {
+			lzeros += count_leading_zeros(alimb) / 8;
+			break;
+		}
+	}
+	return lzeros;
+}
+
 /**
  * mpi_read_buffer() - read MPI to a bufer provided by user (msb first)
  *
@@ -148,7 +165,7 @@ int mpi_read_buffer(MPI a, uint8_t *buf, unsigned buf_len, unsigned *nbytes,
 	uint8_t *p;
 	mpi_limb_t alimb;
 	unsigned int n = mpi_get_size(a);
-	int i, lzeros = 0;
+	int i, lzeros;
 
 	if (!buf || !nbytes)
 		return -EINVAL;
@@ -156,14 +173,7 @@ int mpi_read_buffer(MPI a, uint8_t *buf, unsigned buf_len, unsigned *nbytes,
 	if (sign)
 		*sign = a->sign;
 
-	p = (void *)&a->d[a->nlimbs] - 1;
-
-	for (i = a->nlimbs * sizeof(alimb) - 1; i >= 0; i--, p--) {
-		if (!*p)
-			lzeros++;
-		else
-			break;
-	}
+	lzeros = count_lzeros(a);
 
 	if (buf_len < n - lzeros) {
 		*nbytes = n - lzeros;
@@ -351,7 +361,7 @@ int mpi_write_to_sgl(MPI a, struct scatterlist *sgl, unsigned *nbytes,
 	u8 *p, *p2;
 	mpi_limb_t alimb, alimb2;
 	unsigned int n = mpi_get_size(a);
-	int i, x, y = 0, lzeros = 0, buf_len;
+	int i, x, y = 0, lzeros, buf_len;
 
 	if (!nbytes)
 		return -EINVAL;
@@ -359,14 +369,7 @@ int mpi_write_to_sgl(MPI a, struct scatterlist *sgl, unsigned *nbytes,
 	if (sign)
 		*sign = a->sign;
 
-	p = (void *)&a->d[a->nlimbs] - 1;
-
-	for (i = a->nlimbs * sizeof(alimb) - 1; i >= 0; i--, p--) {
-		if (!*p)
-			lzeros++;
-		else
-			break;
-	}
+	lzeros = count_lzeros(a);
 
 	if (*nbytes < n - lzeros) {
 		*nbytes = n - lzeros;
-- 
2.1.4
