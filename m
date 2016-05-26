From: Nicolai Stange <nicstange@gmail.com>
Subject: [PATCH 1/5] lib/mpi: mpi_read_from_buffer(): return error code
Date: Thu, 26 May 2016 23:19:51 +0200
Message-ID: <1464297595-24032-2-git-send-email-nicstange@gmail.com>
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

mpi_read_from_buffer() reads a MPI from a buffer into a newly allocated
MPI instance. It expects the buffer's leading two bytes to contain the
number of bits, followed by the actual payload.

On failure, it returns NULL and updates the in/out argument ret_nread
somewhat inconsistently:
- If the given buffer is too short to contain the leading two bytes
  encoding the number of bits or their value is unsupported, then
  ret_nread will be cleared.
- If the allocation of the resulting MPI instance fails, ret_nread is left
  as is.

The only user of mpi_read_from_buffer(), digsig_verify_rsa(), simply checks
for a return value of NULL and returns -ENOMEM if that happens.

While this is all of cosmetic nature only, there is another error condition
which currently isn't detectable by the caller of mpi_read_from_buffer():
if the given buffer is too small to hold the number of bits as encoded in
its first two bytes, the return value will be non-NULL and *ret_nread > 0.

In preparation of communicating this condition to the caller, let
mpi_read_from_buffer() return error values by means of the ERR_PTR()
mechanism.

Make the sole caller of mpi_read_from_buffer(), digsig_verify_rsa(),
check the return value for IS_ERR() rather than == NULL. If IS_ERR() is
true, return the associated error value rather than the fixed -ENOMEM.

Signed-off-by: Nicolai Stange <nicstange@gmail.com>
---
 lib/digsig.c       | 12 ++++++++----
 lib/mpi/mpicoder.c |  6 +++---
 2 files changed, 11 insertions(+), 7 deletions(-)

diff --git a/lib/digsig.c b/lib/digsig.c
index 07be6c1..a121cbc 100644
--- a/lib/digsig.c
+++ b/lib/digsig.c
@@ -104,16 +104,18 @@ static int digsig_verify_rsa(struct key *key,
 	datap = pkh->mpi;
 	endp = ukp->data + ukp->datalen;
 
-	err = -ENOMEM;
-
 	for (i = 0; i < pkh->nmpi; i++) {
 		unsigned int remaining = endp - datap;
 		pkey[i] = mpi_read_from_buffer(datap, &remaining);
-		if (!pkey[i])
+		if (IS_ERR(pkey[i])) {
+			err = PTR_ERR(pkey[i]);
 			goto err;
+		}
 		datap += remaining;
 	}
 
+	err = -ENOMEM;
+
 	mblen = mpi_get_nbits(pkey[0]);
 	mlen = DIV_ROUND_UP(mblen, 8);
 
@@ -126,8 +128,10 @@ static int digsig_verify_rsa(struct key *key,
 
 	nret = siglen;
 	in = mpi_read_from_buffer(sig, &nret);
-	if (!in)
+	if (IS_ERR(in)) {
+		err = PTR_ERR(in);
 		goto err;
+	}
 
 	res = mpi_alloc(mpi_get_nlimbs(in) * 2);
 	if (!res)
diff --git a/lib/mpi/mpicoder.c b/lib/mpi/mpicoder.c
index 747606f..275c71e 100644
--- a/lib/mpi/mpicoder.c
+++ b/lib/mpi/mpicoder.c
@@ -88,12 +88,12 @@ MPI mpi_read_from_buffer(const void *xbuffer, unsigned *ret_nread)
 	MPI val = NULL;
 
 	if (*ret_nread < 2)
-		goto leave;
+		return ERR_PTR(-EINVAL);
 	nbits = buffer[0] << 8 | buffer[1];
 
 	if (nbits > MAX_EXTERN_MPI_BITS) {
 		pr_info("MPI: mpi too large (%u bits)\n", nbits);
-		goto leave;
+		return ERR_PTR(-EINVAL);
 	}
 	buffer += 2;
 	nread = 2;
@@ -102,7 +102,7 @@ MPI mpi_read_from_buffer(const void *xbuffer, unsigned *ret_nread)
 	nlimbs = DIV_ROUND_UP(nbytes, BYTES_PER_MPI_LIMB);
 	val = mpi_alloc(nlimbs);
 	if (!val)
-		return NULL;
+		return ERR_PTR(-ENOMEM);
 	i = BYTES_PER_MPI_LIMB - nbytes % BYTES_PER_MPI_LIMB;
 	i %= BYTES_PER_MPI_LIMB;
 	val->nbits = nbits;
-- 
2.8.2
