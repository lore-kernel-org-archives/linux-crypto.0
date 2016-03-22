From: Nicolai Stange <nicstange@gmail.com>
Subject: [PATCH v3 10/14] lib/mpi: mpi_read_raw_from_sgl(): don't include leading zero SGEs in nbytes
Date: Tue, 22 Mar 2016 13:12:44 +0100
Message-ID: <1458648768-1469-11-git-send-email-nicstange@gmail.com>
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
Received: from mail-wm0-f65.google.com ([74.125.82.65]:35947 "EHLO
	mail-wm0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758364AbcCVMOK (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 22 Mar 2016 08:14:10 -0400
In-Reply-To: <1458648768-1469-1-git-send-email-nicstange@gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

At the very beginning of mpi_read_raw_from_sgl(), the leading zeros of
the input scatterlist are counted:

  lzeros = 0;
  for_each_sg(sgl, sg, ents, i) {
    ...
    if (/* sg contains nonzero bytes */)
      break;

    /* sg contains nothing but zeros here */
    ents--;
    lzeros = 0;
  }

Later on, the total number of trailing nonzero bytes is calculated by
subtracting the number of leading zero bytes from the total number of input
bytes:

  nbytes -= lzeros;

However, since lzeros gets reset to zero for each completely zero leading
sg in the loop above, it doesn't include those.

Besides wasting resources by allocating a too large output buffer,
this mistake propagates into the calculation of x, the number of
leading zeros within the most significant output limb:

  x = BYTES_PER_MPI_LIMB - nbytes % BYTES_PER_MPI_LIMB;

What's more, the low order bytes of the output, equal in number to the
extra bytes in nbytes, are left uninitialized.

Fix this by adjusting nbytes for each completely zero leading scatterlist
entry.

Fixes: 2d4d1eea540b ("lib/mpi: Add mpi sgl helpers")
Signed-off-by: Nicolai Stange <nicstange@gmail.com>
---
 lib/mpi/mpicoder.c | 8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/lib/mpi/mpicoder.c b/lib/mpi/mpicoder.c
index 048f0aa..4ba0f23 100644
--- a/lib/mpi/mpicoder.c
+++ b/lib/mpi/mpicoder.c
@@ -447,16 +447,12 @@ MPI mpi_read_raw_from_sgl(struct scatterlist *sgl, unsigned int nbytes)
 			break;
 
 		ents--;
+		nbytes -= lzeros;
 		lzeros = 0;
 	}
 
 	sgl = sg;
-
-	if (!ents)
-		nbytes = 0;
-	else
-		nbytes -= lzeros;
-
+	nbytes -= lzeros;
 	nbits = nbytes * 8;
 	if (nbits > MAX_EXTERN_MPI_BITS) {
 		pr_info("MPI: mpi too large (%u bits)\n", nbits);
-- 
2.7.4
