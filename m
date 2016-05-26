From: Nicolai Stange <nicstange@gmail.com>
Subject: [PATCH] lib/mpi: purge mpi_set_buffer()
Date: Thu, 26 May 2016 12:57:50 +0200
Message-ID: <1464260270-3525-1-git-send-email-nicstange@gmail.com>
Cc: Dmitry Kasatkin <dmitry.kasatkin@intel.com>,
	Tadeusz Struk <tadeusz.struk@intel.com>,
	LABBE Corentin <clabbe.montjoie@gmail.com>,
	Michal Marek <mmarek@suse.com>, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org, Nicolai Stange <nicstange@gmail.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wm0-f65.google.com ([74.125.82.65]:35130 "EHLO
	mail-wm0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752270AbcEZK56 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 26 May 2016 06:57:58 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

mpi_set_buffer() has no in-tree users and similar functionality is provided
by mpi_read_raw_data().

Remove mpi_set_buffer().

Signed-off-by: Nicolai Stange <nicstange@gmail.com>
---
 Applicable to linux-next-20150525.
 allmodconfig build on x86_64 succeeded.

 include/linux/mpi.h |  1 -
 lib/mpi/mpicoder.c  | 76 -----------------------------------------------------
 2 files changed, 77 deletions(-)

diff --git a/include/linux/mpi.h b/include/linux/mpi.h
index 3a5abe9..f219559 100644
--- a/include/linux/mpi.h
+++ b/include/linux/mpi.h
@@ -80,7 +80,6 @@ void *mpi_get_buffer(MPI a, unsigned *nbytes, int *sign);
 int mpi_read_buffer(MPI a, uint8_t *buf, unsigned buf_len, unsigned *nbytes,
 		    int *sign);
 void *mpi_get_secure_buffer(MPI a, unsigned *nbytes, int *sign);
-int mpi_set_buffer(MPI a, const void *buffer, unsigned nbytes, int sign);
 int mpi_write_to_sgl(MPI a, struct scatterlist *sg, unsigned *nbytes,
 		     int *sign);
 
diff --git a/lib/mpi/mpicoder.c b/lib/mpi/mpicoder.c
index 747606f..c742033 100644
--- a/lib/mpi/mpicoder.c
+++ b/lib/mpi/mpicoder.c
@@ -250,82 +250,6 @@ void *mpi_get_buffer(MPI a, unsigned *nbytes, int *sign)
 }
 EXPORT_SYMBOL_GPL(mpi_get_buffer);
 
-/****************
- * Use BUFFER to update MPI.
- */
-int mpi_set_buffer(MPI a, const void *xbuffer, unsigned nbytes, int sign)
-{
-	const uint8_t *buffer = xbuffer, *p;
-	mpi_limb_t alimb;
-	int nlimbs;
-	int i;
-
-	nlimbs = DIV_ROUND_UP(nbytes, BYTES_PER_MPI_LIMB);
-	if (RESIZE_IF_NEEDED(a, nlimbs) < 0)
-		return -ENOMEM;
-	a->sign = sign;
-
-	for (i = 0, p = buffer + nbytes - 1; p >= buffer + BYTES_PER_MPI_LIMB;) {
-#if BYTES_PER_MPI_LIMB == 4
-		alimb = (mpi_limb_t) *p--;
-		alimb |= (mpi_limb_t) *p-- << 8;
-		alimb |= (mpi_limb_t) *p-- << 16;
-		alimb |= (mpi_limb_t) *p-- << 24;
-#elif BYTES_PER_MPI_LIMB == 8
-		alimb = (mpi_limb_t) *p--;
-		alimb |= (mpi_limb_t) *p-- << 8;
-		alimb |= (mpi_limb_t) *p-- << 16;
-		alimb |= (mpi_limb_t) *p-- << 24;
-		alimb |= (mpi_limb_t) *p-- << 32;
-		alimb |= (mpi_limb_t) *p-- << 40;
-		alimb |= (mpi_limb_t) *p-- << 48;
-		alimb |= (mpi_limb_t) *p-- << 56;
-#else
-#error please implement for this limb size.
-#endif
-		a->d[i++] = alimb;
-	}
-	if (p >= buffer) {
-#if BYTES_PER_MPI_LIMB == 4
-		alimb = *p--;
-		if (p >= buffer)
-			alimb |= (mpi_limb_t) *p-- << 8;
-		if (p >= buffer)
-			alimb |= (mpi_limb_t) *p-- << 16;
-		if (p >= buffer)
-			alimb |= (mpi_limb_t) *p-- << 24;
-#elif BYTES_PER_MPI_LIMB == 8
-		alimb = (mpi_limb_t) *p--;
-		if (p >= buffer)
-			alimb |= (mpi_limb_t) *p-- << 8;
-		if (p >= buffer)
-			alimb |= (mpi_limb_t) *p-- << 16;
-		if (p >= buffer)
-			alimb |= (mpi_limb_t) *p-- << 24;
-		if (p >= buffer)
-			alimb |= (mpi_limb_t) *p-- << 32;
-		if (p >= buffer)
-			alimb |= (mpi_limb_t) *p-- << 40;
-		if (p >= buffer)
-			alimb |= (mpi_limb_t) *p-- << 48;
-		if (p >= buffer)
-			alimb |= (mpi_limb_t) *p-- << 56;
-#else
-#error please implement for this limb size.
-#endif
-		a->d[i++] = alimb;
-	}
-	a->nlimbs = i;
-
-	if (i != nlimbs) {
-		pr_emerg("MPI: mpi_set_buffer: Assertion failed (%d != %d)", i,
-		       nlimbs);
-		BUG();
-	}
-	return 0;
-}
-EXPORT_SYMBOL_GPL(mpi_set_buffer);
-
 /**
  * mpi_write_to_sgl() - Funnction exports MPI to an sgl (msb first)
  *
-- 
2.8.2
