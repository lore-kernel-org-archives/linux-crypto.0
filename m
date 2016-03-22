From: Nicolai Stange <nicstange@gmail.com>
Subject: [PATCH v3 11/14] lib/mpi: mpi_read_raw_from_sgl(): purge redundant clearing of nbits
Date: Tue, 22 Mar 2016 13:12:45 +0100
Message-ID: <1458648768-1469-12-git-send-email-nicstange@gmail.com>
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
Received: from mail-wm0-f67.google.com ([74.125.82.67]:35976 "EHLO
	mail-wm0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758442AbcCVMOL (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 22 Mar 2016 08:14:11 -0400
In-Reply-To: <1458648768-1469-1-git-send-email-nicstange@gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

In mpi_read_raw_from_sgl(), unsigned nbits is calculated as follows:

  nbits = nbytes * 8;

and redundantly cleared later on if nbytes == 0:

  if (nbytes > 0)
    ...
  else
    nbits = 0;

Purge this redundant clearing for the sake of clarity.

Signed-off-by: Nicolai Stange <nicstange@gmail.com>
---
 lib/mpi/mpicoder.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/lib/mpi/mpicoder.c b/lib/mpi/mpicoder.c
index 4ba0f23..27703aa 100644
--- a/lib/mpi/mpicoder.c
+++ b/lib/mpi/mpicoder.c
@@ -461,8 +461,6 @@ MPI mpi_read_raw_from_sgl(struct scatterlist *sgl, unsigned int nbytes)
 
 	if (nbytes > 0)
 		nbits -= count_leading_zeros(*(u8 *)(sg_virt(sgl) + lzeros));
-	else
-		nbits = 0;
 
 	nlimbs = DIV_ROUND_UP(nbytes, BYTES_PER_MPI_LIMB);
 	val = mpi_alloc(nlimbs);
-- 
2.7.4
