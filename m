From: Nicolai Stange <nicstange@gmail.com>
Subject: [PATCH RESEND v2 07/14] lib/mpi: mpi_read_buffer(): replace open coded endian conversion
Date: Mon, 21 Mar 2016 14:26:08 +0100
Message-ID: <1458566775-5239-8-git-send-email-nicstange@gmail.com>
References: <1458566775-5239-1-git-send-email-nicstange@gmail.com>
Cc: Tadeusz Struk <tadeusz.struk@intel.com>,
	Michal Marek <mmarek@suse.com>,
	Andrzej Zaborowski <andrew.zaborowski@intel.com>,
	Stephan Mueller <smueller@chronox.de>,
	Arnd Bergmann <arnd@arndb.de>, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org, Nicolai Stange <nicstange@gmail.com>
To: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1458566775-5239-1-git-send-email-nicstange@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Currently, the endian conversion from CPU order to BE is open coded in
mpi_read_buffer().

Replace this by the centrally provided cpu_to_be*() macros.
Copy from the temporary storage on stack to the destination buffer
by means of memcpy().

Signed-off-by: Nicolai Stange <nicstange@gmail.com>
---
 lib/mpi/mpicoder.c | 27 ++++++++++++---------------
 1 file changed, 12 insertions(+), 15 deletions(-)

diff --git a/lib/mpi/mpicoder.c b/lib/mpi/mpicoder.c
index 2fd8d41..a999ee1 100644
--- a/lib/mpi/mpicoder.c
+++ b/lib/mpi/mpicoder.c
@@ -21,6 +21,7 @@
 #include <linux/bitops.h>
 #include <linux/count_zeros.h>
 #include <linux/byteorder/generic.h>
+#include <linux/string.h>
 #include "mpi-internal.h"
 
 #define MAX_EXTERN_MPI_BITS 16384
@@ -164,7 +165,13 @@ int mpi_read_buffer(MPI a, uint8_t *buf, unsigned buf_len, unsigned *nbytes,
 		    int *sign)
 {
 	uint8_t *p;
-	mpi_limb_t alimb;
+#if BYTES_PER_MPI_LIMB == 4
+	__be32 alimb;
+#elif BYTES_PER_MPI_LIMB == 8
+	__be64 alimb;
+#else
+#error please implement for this limb size.
+#endif
 	unsigned int n = mpi_get_size(a);
 	int i, lzeros;
 
@@ -187,25 +194,15 @@ int mpi_read_buffer(MPI a, uint8_t *buf, unsigned buf_len, unsigned *nbytes,
 	for (i = a->nlimbs - 1 - lzeros / BYTES_PER_MPI_LIMB,
 			lzeros %= BYTES_PER_MPI_LIMB;
 		i >= 0; i--) {
-		alimb = a->d[i];
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
-
+		memcpy(p, &alimb, BYTES_PER_MPI_LIMB);
+		p += BYTES_PER_MPI_LIMB;
 		if (lzeros > 0) {
 			mpi_limb_t *limb1 = (void *)p - sizeof(alimb);
 			mpi_limb_t *limb2 = (void *)p - sizeof(alimb)
-- 
2.7.3
