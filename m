From: Nicolai Stange <nicstange@gmail.com>
Subject: [PATCH 1/2] lib/mpi: mpi_read_raw_data(): purge redundant clearing of nbits
Date: Thu, 26 May 2016 13:05:31 +0200
Message-ID: <1464260732-4446-1-git-send-email-nicstange@gmail.com>
Cc: Tadeusz Struk <tadeusz.struk@intel.com>,
	Michal Marek <mmarek@suse.com>, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org, Nicolai Stange <nicstange@gmail.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wm0-f67.google.com ([74.125.82.67]:35606 "EHLO
	mail-wm0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753191AbcEZLFt (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 26 May 2016 07:05:49 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

In mpi_read_raw_data(), unsigned nbits is calculated as follows:

 nbits = nbytes * 8;

and redundantly cleared later on if nbytes == 0:

  if (nbytes > 0)
    ...
  else
    nbits = 0;

Purge this redundant clearing for the sake of clarity.

Signed-off-by: Nicolai Stange <nicstange@gmail.com>
---
 Applicable to linux-next-20160525.

 lib/mpi/mpicoder.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/lib/mpi/mpicoder.c b/lib/mpi/mpicoder.c
index 747606f..c160393 100644
--- a/lib/mpi/mpicoder.c
+++ b/lib/mpi/mpicoder.c
@@ -51,8 +51,6 @@ MPI mpi_read_raw_data(const void *xbuffer, size_t nbytes)
 	}
 	if (nbytes > 0)
 		nbits -= count_leading_zeros(buffer[0]);
-	else
-		nbits = 0;
 
 	nlimbs = DIV_ROUND_UP(nbytes, BYTES_PER_MPI_LIMB);
 	val = mpi_alloc(nlimbs);
-- 
2.8.2
