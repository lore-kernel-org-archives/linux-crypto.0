From: Nicolai Stange <nicstange@gmail.com>
Subject: [PATCH v3 05/14] lib/mpi: mpi_write_sgl(): replace open coded endian conversion
Date: Tue, 22 Mar 2016 13:12:39 +0100
Message-ID: <1458648768-1469-6-git-send-email-nicstange@gmail.com>
References: <1458648768-1469-1-git-send-email-nicstange@gmail.com>
Cc: Tadeusz Struk <tadeusz.struk@intel.com>,
	Michal Marek <mmarek@suse.com>,
	Andrzej Zaborowski <andrew.zaborowski@intel.com>,
	Stephan Mueller <smueller@chronox.de>,
	Arnd Bergmann <arnd@arndb.de>, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org, Nicolai Stange <nicstange@gmail.com>
To: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1458648768-1469-1-git-send-email-nicstange@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Currently, the endian conversion from CPU order to BE is open coded in
mpi_write_sgl().

Replace this by the centrally provided cpu_to_be*() macros.

Signed-off-by: Nicolai Stange <nicstange@gmail.com>
---
 lib/mpi/mpicoder.c | 27 +++++++++++----------------
 1 file changed, 11 insertions(+), 16 deletions(-)

diff --git a/lib/mpi/mpicoder.c b/lib/mpi/mpicoder.c
index b05d390..623439e 100644
--- a/lib/mpi/mpicoder.c
+++ b/lib/mpi/mpicoder.c
@@ -20,6 +20,7 @@
 
 #include <linux/bitops.h>
 #include <linux/count_zeros.h>
+#include <linux/byteorder/generic.h>
 #include "mpi-internal.h"
 
 #define MAX_EXTERN_MPI_BITS 16384
@@ -359,7 +360,13 @@ int mpi_write_to_sgl(MPI a, struct scatterlist *sgl, unsigned *nbytes,
 		     int *sign)
 {
 	u8 *p, *p2;
-	mpi_limb_t alimb, alimb2;
+#if BYTES_PER_MPI_LIMB == 4
+	__be32 alimb;
+#elif BYTES_PER_MPI_LIMB == 8
+	__be64 alimb;
+#else
+#error please implement for this limb size.
+#endif
 	unsigned int n = mpi_get_size(a);
 	int i, x, y = 0, lzeros, buf_len;
 
@@ -383,22 +390,10 @@ int mpi_write_to_sgl(MPI a, struct scatterlist *sgl, unsigned *nbytes,
 	for (i = a->nlimbs - 1 - lzeros / BYTES_PER_MPI_LIMB,
 			lzeros %= BYTES_PER_MPI_LIMB;
 		i >= 0; i--) {
-		alimb = a->d[i];
-		p = (u8 *)&alimb2;
 #if BYTES_PER_MPI_LIMB == 4
-		*p++ = alimb >> 24;
-		*p++ = alimb >> 16;
-		*p++ = alimb >> 8;
-		*p++ = alimb;
+		alimb = cpu_to_be32(a->d[i]);
 #elif BYTES_PER_MPI_LIMB == 8
-		*p++ = alimb >> 56;
-		*p++ = alimb >> 48;
-		*p++ = alimb >> 40;
-		*p++ = alimb >> 32;
-		*p++ = alimb >> 24;
-		*p++ = alimb >> 16;
-		*p++ = alimb >> 8;
-		*p++ = alimb;
+		alimb = cpu_to_be64(a->d[i]);
 #else
 #error please implement for this limb size.
 #endif
@@ -407,7 +402,7 @@ int mpi_write_to_sgl(MPI a, struct scatterlist *sgl, unsigned *nbytes,
 			lzeros = 0;
 		}
 
-		p = p - sizeof(alimb) + y;
+		p = (u8 *)&alimb + y;
 
 		for (x = 0; x < sizeof(alimb) - y; x++) {
 			if (!buf_len) {
-- 
2.7.4
