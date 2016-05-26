From: Nicolai Stange <nicstange@gmail.com>
Subject: [PATCH 2/2] lib/mpi: mpi_read_raw_data(): fix nbits calculation
Date: Thu, 26 May 2016 13:05:32 +0200
Message-ID: <1464260732-4446-2-git-send-email-nicstange@gmail.com>
References: <1464260732-4446-1-git-send-email-nicstange@gmail.com>
Cc: Tadeusz Struk <tadeusz.struk@intel.com>,
	Michal Marek <mmarek@suse.com>, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org, Nicolai Stange <nicstange@gmail.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wm0-f67.google.com ([74.125.82.67]:33340 "EHLO
	mail-wm0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753647AbcEZLGC (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 26 May 2016 07:06:02 -0400
In-Reply-To: <1464260732-4446-1-git-send-email-nicstange@gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

The number of bits, nbits, is calculated in mpi_read_raw_data() as follows:

  nbits = nbytes * 8;

Afterwards, the number of leading zero bits of the first byte get
subtracted:

  nbits -= count_leading_zeros(buffer[0]);

However, count_leading_zeros() takes an unsigned long and thus,
the u8 gets promoted to an unsigned long.

Thus, the above doesn't subtract the number of leading zeros in the most
significant nonzero input byte from nbits, but the number of leading
zeros of the most significant nonzero input byte promoted to unsigned long,
i.e. BITS_PER_LONG - 8 too many.

Fix this by subtracting

  count_leading_zeros(...) - (BITS_PER_LONG - 8)

from nbits only.

Fixes: e1045992949 ("MPILIB: Provide a function to read raw data into an
                     MPI")
Signed-off-by: Nicolai Stange <nicstange@gmail.com>
---
 Applicable to linux-next-20150525.

 lib/mpi/mpicoder.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/lib/mpi/mpicoder.c b/lib/mpi/mpicoder.c
index c160393..d197210 100644
--- a/lib/mpi/mpicoder.c
+++ b/lib/mpi/mpicoder.c
@@ -50,7 +50,7 @@ MPI mpi_read_raw_data(const void *xbuffer, size_t nbytes)
 		return NULL;
 	}
 	if (nbytes > 0)
-		nbits -= count_leading_zeros(buffer[0]);
+		nbits -= count_leading_zeros(buffer[0]) - (BITS_PER_LONG - 8);
 
 	nlimbs = DIV_ROUND_UP(nbytes, BYTES_PER_MPI_LIMB);
 	val = mpi_alloc(nlimbs);
-- 
2.8.2
