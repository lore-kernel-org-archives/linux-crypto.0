From: Nicolai Stange <nicstange@gmail.com>
Subject: [PATCH 5/5] lib/mpi: refactor mpi_read_from_buffer() in terms of mpi_read_raw_data()
Date: Thu, 26 May 2016 23:19:55 +0200
Message-ID: <1464297595-24032-6-git-send-email-nicstange@gmail.com>
References: <1464297595-24032-1-git-send-email-nicstange@gmail.com>
Cc: David Howells <dhowells@redhat.com>,
	Tadeusz Struk <tadeusz.struk@intel.com>,
	Michal Marek <mmarek@suse.com>, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org, Nicolai Stange <nicstange@gmail.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1464297595-24032-1-git-send-email-nicstange@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

mpi_read_from_buffer() and mpi_read_raw_data() do basically the same thing
except that the former extracts the number of payload bits from the first
two bytes of the input buffer.

Besides that, the data copying logic is exactly the same.

Replace the open coded buffer to MPI instance conversion by a call to
mpi_read_raw_data().

Signed-off-by: Nicolai Stange <nicstange@gmail.com>
---
 lib/mpi/mpicoder.c | 24 +++---------------------
 1 file changed, 3 insertions(+), 21 deletions(-)

diff --git a/lib/mpi/mpicoder.c b/lib/mpi/mpicoder.c
index 2f4d039..e8a5742 100644
--- a/lib/mpi/mpicoder.c
+++ b/lib/mpi/mpicoder.c
@@ -82,10 +82,8 @@ EXPORT_SYMBOL_GPL(mpi_read_raw_data);
 MPI mpi_read_from_buffer(const void *xbuffer, unsigned *ret_nread)
 {
 	const uint8_t *buffer = xbuffer;
-	int i, j;
-	unsigned nbits, nbytes, nlimbs;
-	mpi_limb_t a;
-	MPI val = NULL;
+	unsigned int nbits, nbytes;
+	MPI val;
 
 	if (*ret_nread < 2)
 		return ERR_PTR(-EINVAL);
@@ -95,7 +93,6 @@ MPI mpi_read_from_buffer(const void *xbuffer, unsigned *ret_nread)
 		pr_info("MPI: mpi too large (%u bits)\n", nbits);
 		return ERR_PTR(-EINVAL);
 	}
-	buffer += 2;
 
 	nbytes = DIV_ROUND_UP(nbits, 8);
 	if (nbytes + 2 > *ret_nread) {
@@ -104,24 +101,9 @@ MPI mpi_read_from_buffer(const void *xbuffer, unsigned *ret_nread)
 		return ERR_PTR(-EINVAL);
 	}
 
-	nlimbs = DIV_ROUND_UP(nbytes, BYTES_PER_MPI_LIMB);
-	val = mpi_alloc(nlimbs);
+	val = mpi_read_raw_data(buffer + 2, nbytes);
 	if (!val)
 		return ERR_PTR(-ENOMEM);
-	i = BYTES_PER_MPI_LIMB - nbytes % BYTES_PER_MPI_LIMB;
-	i %= BYTES_PER_MPI_LIMB;
-	val->nbits = nbits;
-	j = val->nlimbs = nlimbs;
-	val->sign = 0;
-	for (; j > 0; j--) {
-		a = 0;
-		for (; i < BYTES_PER_MPI_LIMB; i++) {
-			a <<= 8;
-			a |= *buffer++;
-		}
-		i = 0;
-		val->d[j - 1] = a;
-	}
 
 	*ret_nread = nbytes + 2;
 	return val;
-- 
2.8.2
