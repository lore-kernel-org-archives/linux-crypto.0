From: Nicolai Stange <nicstange@gmail.com>
Subject: [PATCH v3 13/14] lib/mpi: mpi_read_raw_from_sgl(): sanitize meaning of indices
Date: Tue, 22 Mar 2016 13:18:07 +0100
Message-ID: <1458649087-1721-1-git-send-email-nicstange@gmail.com>
References: <1458648768-1469-1-git-send-email-nicstange@gmail.com>
Cc: Tadeusz Struk <tadeusz.struk@intel.com>,
	Michal Marek <mmarek@suse.com>,
	Andrzej Zaborowski <andrew.zaborowski@intel.com>,
	Stephan Mueller <smueller@chronox.de>,
	Arnd Bergmann <arnd@arndb.de>, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org, Nicolai Stange <nicstange@gmail.com>
To: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wm0-f65.google.com ([74.125.82.65]:36195 "EHLO
	mail-wm0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756546AbcCVMSM (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 22 Mar 2016 08:18:12 -0400
In-Reply-To: <1458648768-1469-1-git-send-email-nicstange@gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Within the byte reading loop in mpi_read_raw_sgl(), there are two
housekeeping indices used, z and x.

At all times, the index z represents the number of output bytes covered
by the input SGEs for which processing has completed so far. This includes
any leading zero bytes within the most significant limb.

The index x changes its meaning after the first outer loop's iteration
though: while processing the first input SGE, it represents

  "number of leading zero bytes in most significant output limb" +
   "current position within current SGE"

For the remaining SGEs OTOH, x corresponds just to

  "current position within current SGE"

After all, it is only the sum of z and x that has any meaning for the
output buffer and thus, the

  "number of leading zero bytes in most significant output limb"

part can be moved away from x into z from the beginning, opening up the
opportunity for cleaner code.

Before the outer loop iterating over the SGEs, don't initialize z with
zero, but with the number of leading zero bytes in the most significant
output limb. For the inner loop iterating over a single SGE's bytes,
get rid of the buf_shift offset to x' bounds and let x run from zero to
sg->length - 1.

Signed-off-by: Nicolai Stange <nicstange@gmail.com>
---
 lib/mpi/mpicoder.c | 9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff --git a/lib/mpi/mpicoder.c b/lib/mpi/mpicoder.c
index 24a0155..a9f1097 100644
--- a/lib/mpi/mpicoder.c
+++ b/lib/mpi/mpicoder.c
@@ -477,19 +477,17 @@ MPI mpi_read_raw_from_sgl(struct scatterlist *sgl, unsigned int nbytes)
 
 	j = nlimbs - 1;
 	a = 0;
-	z = 0;
-	x = BYTES_PER_MPI_LIMB - nbytes % BYTES_PER_MPI_LIMB;
-	x %= BYTES_PER_MPI_LIMB;
+	z = BYTES_PER_MPI_LIMB - nbytes % BYTES_PER_MPI_LIMB;
+	z %= BYTES_PER_MPI_LIMB;
 
 	for_each_sg(sgl, sg, ents, i) {
 		const u8 *buffer = sg_virt(sg) + lzeros;
 		int len = sg->length - lzeros;
-		int buf_shift = x;
 
 		if  (sg_is_last(sg) && (len % BYTES_PER_MPI_LIMB))
 			len += BYTES_PER_MPI_LIMB - (len % BYTES_PER_MPI_LIMB);
 
-		for (; x < len + buf_shift; x++) {
+		for (x = 0; x < len; x++) {
 			a <<= 8;
 			a |= *buffer++;
 			if (((z + x + 1) % BYTES_PER_MPI_LIMB) == 0) {
@@ -498,7 +496,6 @@ MPI mpi_read_raw_from_sgl(struct scatterlist *sgl, unsigned int nbytes)
 			}
 		}
 		z += x;
-		x = 0;
 		lzeros = 0;
 	}
 	return val;
-- 
2.7.4
