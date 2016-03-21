From: Nicolai Stange <nicstange@gmail.com>
Subject: [PATCH RESEND v2 09/14] lib/mpi: mpi_read_raw_from_sgl(): replace len argument by nbytes
Date: Mon, 21 Mar 2016 14:26:10 +0100
Message-ID: <1458566775-5239-10-git-send-email-nicstange@gmail.com>
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

Currently, the nbytes local variable is calculated from the len argument
as follows:

  ... mpi_read_raw_from_sgl(..., unsigned int len)
  {
    unsigned nbytes;
    ...
    if (!ents)
      nbytes = 0;
    else
      nbytes = len - lzeros;
    ...
  }

Given that nbytes is derived from len in a trivial way and that the len
argument is shadowed by a local len variable in several loops, this is just
confusing.

Rename the len argument to nbytes and get rid of the nbytes local variable.
Do the nbytes calculation in place.

Signed-off-by: Nicolai Stange <nicstange@gmail.com>
---
 lib/mpi/mpicoder.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/lib/mpi/mpicoder.c b/lib/mpi/mpicoder.c
index 27582e2..2de2c7d 100644
--- a/lib/mpi/mpicoder.c
+++ b/lib/mpi/mpicoder.c
@@ -418,15 +418,15 @@ EXPORT_SYMBOL_GPL(mpi_write_to_sgl);
  * a new MPI and reads the content of the sgl to the MPI.
  *
  * @sgl:	scatterlist to read from
- * @len:	number of bytes to read
+ * @nbytes:	number of bytes to read
  *
  * Return:	Pointer to a new MPI or NULL on error
  */
-MPI mpi_read_raw_from_sgl(struct scatterlist *sgl, unsigned int len)
+MPI mpi_read_raw_from_sgl(struct scatterlist *sgl, unsigned int nbytes)
 {
 	struct scatterlist *sg;
 	int x, i, j, z, lzeros, ents;
-	unsigned int nbits, nlimbs, nbytes;
+	unsigned int nbits, nlimbs;
 	mpi_limb_t a;
 	MPI val = NULL;
 
@@ -455,7 +455,7 @@ MPI mpi_read_raw_from_sgl(struct scatterlist *sgl, unsigned int len)
 	if (!ents)
 		nbytes = 0;
 	else
-		nbytes = len - lzeros;
+		nbytes -= lzeros;
 
 	nbits = nbytes * 8;
 	if (nbits > MAX_EXTERN_MPI_BITS) {
-- 
2.7.3
