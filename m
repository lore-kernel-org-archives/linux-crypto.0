From: Nicolai Stange <nicstange@gmail.com>
Subject: [PATCH 3/5] lib/mpi: mpi_read_from_buffer(): return -EINVAL upon too short buffer
Date: Thu, 26 May 2016 23:19:53 +0200
Message-ID: <1464297595-24032-4-git-send-email-nicstange@gmail.com>
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

Currently, if the input buffer is shorter than the expected length as
indicated by its first two bytes, an MPI instance of this expected length
will be allocated and filled with as much data as is available. The rest
will remain uninitialized.

Instead of leaving this condition undetected, an error code should be
reported to the caller.

Since this situation indicates that the input buffer's first two bytes,
encoding the number of expected bits, are garbled, -EINVAL is appropriate
here.

If the input buffer is shorter than indicated by its first two bytes,
make mpi_read_from_buffer() return -EINVAL.
Get rid of the 'nread' variable: with the new semantics, the total number
of bytes read from the input buffer is known in advance.

Signed-off-by: Nicolai Stange <nicstange@gmail.com>
---
 lib/mpi/mpicoder.c | 18 ++++++++----------
 1 file changed, 8 insertions(+), 10 deletions(-)

diff --git a/lib/mpi/mpicoder.c b/lib/mpi/mpicoder.c
index 275c71e..869c66c 100644
--- a/lib/mpi/mpicoder.c
+++ b/lib/mpi/mpicoder.c
@@ -83,7 +83,7 @@ MPI mpi_read_from_buffer(const void *xbuffer, unsigned *ret_nread)
 {
 	const uint8_t *buffer = xbuffer;
 	int i, j;
-	unsigned nbits, nbytes, nlimbs, nread = 0;
+	unsigned nbits, nbytes, nlimbs;
 	mpi_limb_t a;
 	MPI val = NULL;
 
@@ -96,9 +96,14 @@ MPI mpi_read_from_buffer(const void *xbuffer, unsigned *ret_nread)
 		return ERR_PTR(-EINVAL);
 	}
 	buffer += 2;
-	nread = 2;
 
 	nbytes = DIV_ROUND_UP(nbits, 8);
+	if (nbytes + 2 > *ret_nread) {
+		printk("MPI: mpi larger than buffer nread=%d ret_nread=%d\n",
+				*ret_nread + 1, *ret_nread);
+		return ERR_PTR(-EINVAL);
+	}
+
 	nlimbs = DIV_ROUND_UP(nbytes, BYTES_PER_MPI_LIMB);
 	val = mpi_alloc(nlimbs);
 	if (!val)
@@ -111,12 +116,6 @@ MPI mpi_read_from_buffer(const void *xbuffer, unsigned *ret_nread)
 	for (; j > 0; j--) {
 		a = 0;
 		for (; i < BYTES_PER_MPI_LIMB; i++) {
-			if (++nread > *ret_nread) {
-				printk
-				    ("MPI: mpi larger than buffer nread=%d ret_nread=%d\n",
-				     nread, *ret_nread);
-				goto leave;
-			}
 			a <<= 8;
 			a |= *buffer++;
 		}
@@ -124,8 +123,7 @@ MPI mpi_read_from_buffer(const void *xbuffer, unsigned *ret_nread)
 		val->d[j - 1] = a;
 	}
 
-leave:
-	*ret_nread = nread;
+	*ret_nread = nbytes + 2;
 	return val;
 }
 EXPORT_SYMBOL_GPL(mpi_read_from_buffer);
-- 
2.8.2
