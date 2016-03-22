From: Nicolai Stange <nicstange@gmail.com>
Subject: [PATCH v3 01/14] lib/mpi: mpi_write_sgl(): fix skipping of leading zero limbs
Date: Tue, 22 Mar 2016 13:12:35 +0100
Message-ID: <1458648768-1469-2-git-send-email-nicstange@gmail.com>
References: <1458648768-1469-1-git-send-email-nicstange@gmail.com>
Cc: Tadeusz Struk <tadeusz.struk@intel.com>,
	Michal Marek <mmarek@suse.com>,
	Andrzej Zaborowski <andrew.zaborowski@intel.com>,
	Stephan Mueller <smueller@chronox.de>,
	Arnd Bergmann <arnd@arndb.de>, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org, Nicolai Stange <nicstange@gmail.com>
To: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wm0-f66.google.com ([74.125.82.66]:35321 "EHLO
	mail-wm0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755926AbcCVMN4 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 22 Mar 2016 08:13:56 -0400
In-Reply-To: <1458648768-1469-1-git-send-email-nicstange@gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Currently, if the number of leading zeros is greater than fits into a
complete limb, mpi_write_sgl() skips them by iterating over them limb-wise.

However, it fails to adjust its internal leading zeros tracking variable,
lzeros, accordingly: it does a

  p -= sizeof(alimb);
  continue;

which should really have been a

  lzeros -= sizeof(alimb);
  continue;

Since lzeros never decreases if its initial value >= sizeof(alimb), nothing
gets copied by mpi_write_sgl() in that case.

Instead of skipping the high order zero limbs within the loop as shown
above, fix the issue by adjusting the copying loop's bounds.

Fixes: 2d4d1eea540b ("lib/mpi: Add mpi sgl helpers")
Signed-off-by: Nicolai Stange <nicstange@gmail.com>
---
 lib/mpi/mpicoder.c | 21 +++++++++------------
 1 file changed, 9 insertions(+), 12 deletions(-)

diff --git a/lib/mpi/mpicoder.c b/lib/mpi/mpicoder.c
index eb15e7d..6bb52be 100644
--- a/lib/mpi/mpicoder.c
+++ b/lib/mpi/mpicoder.c
@@ -380,7 +380,9 @@ int mpi_write_to_sgl(MPI a, struct scatterlist *sgl, unsigned *nbytes,
 	buf_len = sgl->length;
 	p2 = sg_virt(sgl);
 
-	for (i = a->nlimbs - 1; i >= 0; i--) {
+	for (i = a->nlimbs - 1 - lzeros / BYTES_PER_MPI_LIMB,
+			lzeros %= BYTES_PER_MPI_LIMB;
+		i >= 0; i--) {
 		alimb = a->d[i];
 		p = (u8 *)&alimb2;
 #if BYTES_PER_MPI_LIMB == 4
@@ -401,17 +403,12 @@ int mpi_write_to_sgl(MPI a, struct scatterlist *sgl, unsigned *nbytes,
 #error please implement for this limb size.
 #endif
 		if (lzeros > 0) {
-			if (lzeros >= sizeof(alimb)) {
-				p -= sizeof(alimb);
-				continue;
-			} else {
-				mpi_limb_t *limb1 = (void *)p - sizeof(alimb);
-				mpi_limb_t *limb2 = (void *)p - sizeof(alimb)
-							+ lzeros;
-				*limb1 = *limb2;
-				p -= lzeros;
-				y = lzeros;
-			}
+			mpi_limb_t *limb1 = (void *)p - sizeof(alimb);
+			mpi_limb_t *limb2 = (void *)p - sizeof(alimb)
+				+ lzeros;
+			*limb1 = *limb2;
+			p -= lzeros;
+			y = lzeros;
 			lzeros -= sizeof(alimb);
 		}
 
-- 
2.7.4
