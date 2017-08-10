From: Stephan =?ISO-8859-1?Q?M=FCller?= <smueller@chronox.de>
Subject: [PATCH] crypto: MPI - kunmap after finishing accessing buffer
Date: Thu, 10 Aug 2017 08:06:18 +0200
Message-ID: <3348160.hjCpAHFZrS@positron.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: linux-crypto@vger.kernel.org
To: herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:58428 "EHLO mail.eperm.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750735AbdHJGGV (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 10 Aug 2017 02:06:21 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Herbert,

I found that issue while playing around with edge conditions in my
algif_akcipher implementation. This issue only manifests in a
segmentation violation on 32 bit machines and with an SGL where each
SG points to one byte. SGLs with larger buffers seem to be not
affected by this issue.

Yet this access-after-unmap should be a candidate for stable, IMHO.

---8<---

Using sg_miter_start and sg_miter_next, the buffer of an SG is kmap'ed
to *buff. The current code calls sg_miter_stop (and thus kunmap) on the
SG entry before the last access of *buff.

The patch moves the sg_miter_stop call after the last access to *buff to
ensure that the memory pointed to by *buff is still mapped.

Signed-off-by: Stephan Mueller <smueller@chronox.de>
---
 lib/mpi/mpicoder.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/lib/mpi/mpicoder.c b/lib/mpi/mpicoder.c
index 5a0f75a3bf01..eead4b339466 100644
--- a/lib/mpi/mpicoder.c
+++ b/lib/mpi/mpicoder.c
@@ -364,11 +364,11 @@ MPI mpi_read_raw_from_sgl(struct scatterlist *sgl, unsigned int nbytes)
 	}
 
 	miter.consumed = lzeros;
-	sg_miter_stop(&miter);
 
 	nbytes -= lzeros;
 	nbits = nbytes * 8;
 	if (nbits > MAX_EXTERN_MPI_BITS) {
+		sg_miter_stop(&miter);
 		pr_info("MPI: mpi too large (%u bits)\n", nbits);
 		return NULL;
 	}
@@ -376,6 +376,8 @@ MPI mpi_read_raw_from_sgl(struct scatterlist *sgl, unsigned int nbytes)
 	if (nbytes > 0)
 		nbits -= count_leading_zeros(*buff) - (BITS_PER_LONG - 8);
 
+	sg_miter_stop(&miter);
+
 	nlimbs = DIV_ROUND_UP(nbytes, BYTES_PER_MPI_LIMB);
 	val = mpi_alloc(nlimbs);
 	if (!val)
-- 
2.13.4
