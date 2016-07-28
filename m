From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: lib/mpi: BUG: sleeping function called from invalid context on
 next-20160726
Date: Thu, 28 Jul 2016 13:29:17 +0800
Message-ID: <20160728052917.GA811@gondor.apana.org.au>
References: <87d1lyiygu.fsf@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: Nicolai Stange <nicstange@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:53285 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754537AbcG1F3W (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 28 Jul 2016 01:29:22 -0400
Content-Disposition: inline
In-Reply-To: <87d1lyiygu.fsf@gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, Jul 27, 2016 at 11:05:05PM +0200, Nicolai Stange wrote:
> 
> with linux-next-20160726, I get this:
> 
>  BUG: sleeping function called from invalid context at /mnt/scratch/nic/linux-next/mm/slab.h:388

Does this patch help?
 
> I would have sent a patch, but there is another point which puzzles me
> in mpi_read_raw_from_sgl():
> 
>   [...]
>   const u8 *buff;
>   [...]
>   sg_miter_start(&miter, sgl, ents, SG_MITER_ATOMIC | SG_MITER_FROM_SG);
> 
>   lzeros = 0;
>   len = 0;
>   while (nbytes > 0) {
>   	while (len && !*buff) {
>   		lzeros++;
>   		len--;
>   		buff++;
>   	}
> 
> 
> Thus, buff isn't initialized before its first use? Or am I misreading
> something here?

On the first entry len is zero therefore we will go to the end of the
loop and initialise buff.  Anyway, it will no longer be as confusing
with this patch applied.

Thanks,

---8<---
Subject: lib/mpi: Fix SG miter leak

In mpi_read_raw_from_sgl we may leak the SG miter resouces after
reading the leading zeroes.  This patch fixes this by stopping the
iteration once the leading zeroes have been read.

Fixes: 127827b9c295 ("lib/mpi: Do not do sg_virt")
Reported-by: Nicolai Stange <nicstange@gmail.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

diff --git a/lib/mpi/mpicoder.c b/lib/mpi/mpicoder.c
index c6272ae..5a0f75a 100644
--- a/lib/mpi/mpicoder.c
+++ b/lib/mpi/mpicoder.c
@@ -363,6 +363,9 @@ MPI mpi_read_raw_from_sgl(struct scatterlist *sgl, unsigned int nbytes)
 		lzeros = 0;
 	}
 
+	miter.consumed = lzeros;
+	sg_miter_stop(&miter);
+
 	nbytes -= lzeros;
 	nbits = nbytes * 8;
 	if (nbits > MAX_EXTERN_MPI_BITS) {
@@ -390,7 +393,10 @@ MPI mpi_read_raw_from_sgl(struct scatterlist *sgl, unsigned int nbytes)
 	z = BYTES_PER_MPI_LIMB - nbytes % BYTES_PER_MPI_LIMB;
 	z %= BYTES_PER_MPI_LIMB;
 
-	for (;;) {
+	while (sg_miter_next(&miter)) {
+		buff = miter.addr;
+		len = miter.length;
+
 		for (x = 0; x < len; x++) {
 			a <<= 8;
 			a |= *buff++;
@@ -400,12 +406,6 @@ MPI mpi_read_raw_from_sgl(struct scatterlist *sgl, unsigned int nbytes)
 			}
 		}
 		z += x;
-
-		if (!sg_miter_next(&miter))
-			break;
-
-		buff = miter.addr;
-		len = miter.length;
 	}
 
 	return val;
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
