From: Sowmini Varadhan <sowmini.varadhan@oracle.com>
Subject: [PATCH v2] lib/mpi: Fix kernel unaligned access in mpi_write_to_sgl
Date: Wed, 27 Apr 2016 13:43:56 -0400
Message-ID: <20160427174338.GA15460__37473.3697310605$1461805669$gmane$org@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: herbert@gondor.apana.org.au, smueller@chronox.de, mmarek@suse.com,
	arnd@arndb.de, andrew.zaborowski@intel.com
To: sowmini.varadhan@oracle.com, tadeusz.struk@intel.com,
	linux-kernel@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:47462 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753759AbcD1BH2 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 27 Apr 2016 21:07:28 -0400
Received: from userv0021.oracle.com (userv0021.oracle.com [156.151.31.71])
	by aserp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id u3S17QWF030963
	(version=TLSv1 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-crypto@vger.kernel.org>; Thu, 28 Apr 2016 01:07:26 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
	by userv0021.oracle.com (8.13.8/8.13.8) with ESMTP id u3S17PXI011384
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-crypto@vger.kernel.org>; Thu, 28 Apr 2016 01:07:25 GMT
Received: from abhmp0016.oracle.com (abhmp0016.oracle.com [141.146.116.22])
	by userv0121.oracle.com (8.13.8/8.13.8) with ESMTP id u3S17OCt023978
	for <linux-crypto@vger.kernel.org>; Thu, 28 Apr 2016 01:07:24 GMT
Content-Disposition: inline
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>


Commit 2d4d1eea540b ("lib/mpi: Add mpi sgl helpers") added
mpi_write_to_sgl() which generates traps due to unaligned
access on some platforms like sparc. Fix this by using
the get_unaligned* and put_unaligned* functions.

Fixes: 2d4d1eea540b ("lib/mpi: Add mpi sgl helpers")
Signed-off-by: Sowmini Varadhan <sowmini.varadhan@oracle.com>
---
v2: tadeusz.struk comments: Predicate on BYTES_PER_MPI_LIMB.

 lib/mpi/mpicoder.c |   21 +++++++++++++++++----
 1 files changed, 17 insertions(+), 4 deletions(-)

diff --git a/lib/mpi/mpicoder.c b/lib/mpi/mpicoder.c
index eb15e7d..b61eb6b 100644
--- a/lib/mpi/mpicoder.c
+++ b/lib/mpi/mpicoder.c
@@ -21,6 +21,7 @@
 #include <linux/bitops.h>
 #include <linux/count_zeros.h>
 #include "mpi-internal.h"
+#include <asm/unaligned.h>
 
 #define MAX_EXTERN_MPI_BITS 16384
 
@@ -405,10 +406,22 @@ int mpi_write_to_sgl(MPI a, struct scatterlist *sgl, unsigned *nbytes,
 				p -= sizeof(alimb);
 				continue;
 			} else {
-				mpi_limb_t *limb1 = (void *)p - sizeof(alimb);
-				mpi_limb_t *limb2 = (void *)p - sizeof(alimb)
-							+ lzeros;
-				*limb1 = *limb2;
+				mpi_limb_t tmp;
+#if BYTES_PER_MPI_LIMB == 4
+				tmp = get_unaligned_be32((void *)p -
+							 sizeof(alimb) +
+							 lzeros);
+				put_unaligned_be32(tmp, (void *)p -
+						   sizeof(alimb));
+#elif BYTES_PER_MPI_LIMB == 8
+				tmp = get_unaligned_be64((void *)p -
+							 sizeof(alimb) +
+							 lzeros);
+				put_unaligned_be64(tmp, (void *)p -
+						   sizeof(alimb));
+#else
+#error please implement for this limb size.
+#endif
 				p -= lzeros;
 				y = lzeros;
 			}
-- 
1.7.1
