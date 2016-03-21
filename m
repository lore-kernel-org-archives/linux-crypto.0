From: Nicolai Stange <nicstange@gmail.com>
Subject: [PATCH RESEND v2 06/14] lib/mpi: mpi_read_buffer(): optimize skipping of leading zero limbs
Date: Mon, 21 Mar 2016 14:26:07 +0100
Message-ID: <1458566775-5239-7-git-send-email-nicstange@gmail.com>
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

Currently, if the number of leading zeros is greater than fits into a
complete limb, mpi_read_buffer() skips them by iterating over them
limb-wise.

Instead of skipping the high order zero limbs within the loop as shown
above, adjust the copying loop's bounds.

Signed-off-by: Nicolai Stange <nicstange@gmail.com>
---
 lib/mpi/mpicoder.c | 18 ++++++++----------
 1 file changed, 8 insertions(+), 10 deletions(-)

diff --git a/lib/mpi/mpicoder.c b/lib/mpi/mpicoder.c
index 623439e..2fd8d41 100644
--- a/lib/mpi/mpicoder.c
+++ b/lib/mpi/mpicoder.c
@@ -184,7 +184,9 @@ int mpi_read_buffer(MPI a, uint8_t *buf, unsigned buf_len, unsigned *nbytes,
 	p = buf;
 	*nbytes = n - lzeros;
 
-	for (i = a->nlimbs - 1; i >= 0; i--) {
+	for (i = a->nlimbs - 1 - lzeros / BYTES_PER_MPI_LIMB,
+			lzeros %= BYTES_PER_MPI_LIMB;
+		i >= 0; i--) {
 		alimb = a->d[i];
 #if BYTES_PER_MPI_LIMB == 4
 		*p++ = alimb >> 24;
@@ -205,15 +207,11 @@ int mpi_read_buffer(MPI a, uint8_t *buf, unsigned buf_len, unsigned *nbytes,
 #endif
 
 		if (lzeros > 0) {
-			if (lzeros >= sizeof(alimb)) {
-				p -= sizeof(alimb);
-			} else {
-				mpi_limb_t *limb1 = (void *)p - sizeof(alimb);
-				mpi_limb_t *limb2 = (void *)p - sizeof(alimb)
-							+ lzeros;
-				*limb1 = *limb2;
-				p -= lzeros;
-			}
+			mpi_limb_t *limb1 = (void *)p - sizeof(alimb);
+			mpi_limb_t *limb2 = (void *)p - sizeof(alimb)
+				+ lzeros;
+			*limb1 = *limb2;
+			p -= lzeros;
 			lzeros -= sizeof(alimb);
 		}
 	}
-- 
2.7.3
