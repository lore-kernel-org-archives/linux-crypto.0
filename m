From: Nicolai Stange <nicstange@gmail.com>
Subject: [PATCH v3 12/14] lib/mpi: mpi_read_raw_from_sgl(): fix nbits calculation
Date: Tue, 22 Mar 2016 13:17:27 +0100
Message-ID: <1458649047-1661-1-git-send-email-nicstange@gmail.com>
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
Received: from mail-wm0-f65.google.com ([74.125.82.65]:36643 "EHLO
	mail-wm0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755926AbcCVMRc (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 22 Mar 2016 08:17:32 -0400
In-Reply-To: <1458648768-1469-1-git-send-email-nicstange@gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

The number of bits, nbits, is calculated in mpi_read_raw_from_sgl() as
follows:

  nbits = nbytes * 8;

Afterwards, the number of leading zero bits of the first byte get
subtracted:

  nbits -= count_leading_zeros(*(u8 *)(sg_virt(sgl) + lzeros));

However, count_leading_zeros() takes an unsigned long and thus,
the u8 gets promoted to an unsigned long.

Thus, the above doesn't subtract the number of leading zeros in the most
significant nonzero input byte from nbits, but the number of leading
zeros of the most significant nonzero input byte promoted to unsigned long,
i.e. BITS_PER_LONG - 8 too many.

Fix this by subtracting

  count_leading_zeros(...) - (BITS_PER_LONG - 8)

from nbits only.

Fixes: 2d4d1eea540b ("lib/mpi: Add mpi sgl helpers")
Signed-off-by: Nicolai Stange <nicstange@gmail.com>
---
 lib/mpi/mpicoder.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/lib/mpi/mpicoder.c b/lib/mpi/mpicoder.c
index 27703aa..24a0155 100644
--- a/lib/mpi/mpicoder.c
+++ b/lib/mpi/mpicoder.c
@@ -460,7 +460,8 @@ MPI mpi_read_raw_from_sgl(struct scatterlist *sgl, unsigned int nbytes)
 	}
 
 	if (nbytes > 0)
-		nbits -= count_leading_zeros(*(u8 *)(sg_virt(sgl) + lzeros));
+		nbits -= count_leading_zeros(*(u8 *)(sg_virt(sgl) + lzeros)) -
+			(BITS_PER_LONG - 8);
 
 	nlimbs = DIV_ROUND_UP(nbytes, BYTES_PER_MPI_LIMB);
 	val = mpi_alloc(nlimbs);
-- 
2.7.4
