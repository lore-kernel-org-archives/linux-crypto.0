From: Nicolai Stange <nicstange@gmail.com>
Subject: [PATCH v3 02/14] lib/mpi: mpi_write_sgl(): fix style issue with lzero decrement
Date: Tue, 22 Mar 2016 13:12:36 +0100
Message-ID: <1458648768-1469-3-git-send-email-nicstange@gmail.com>
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
Received: from mail-wm0-f68.google.com ([74.125.82.68]:36780 "EHLO
	mail-wm0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756204AbcCVMN6 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 22 Mar 2016 08:13:58 -0400
In-Reply-To: <1458648768-1469-1-git-send-email-nicstange@gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Within the copying loop in mpi_write_sgl(), we have

  if (lzeros > 0) {
    ...
    lzeros -= sizeof(alimb);
  }

However, at this point, lzeros < sizeof(alimb) holds. Make this fact
explicit by rewriting the above to

  if (lzeros) {
    ...
    lzeros = 0;
  }

Signed-off-by: Nicolai Stange <nicstange@gmail.com>
---
 lib/mpi/mpicoder.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/lib/mpi/mpicoder.c b/lib/mpi/mpicoder.c
index 6bb52be..d8b372b 100644
--- a/lib/mpi/mpicoder.c
+++ b/lib/mpi/mpicoder.c
@@ -402,14 +402,14 @@ int mpi_write_to_sgl(MPI a, struct scatterlist *sgl, unsigned *nbytes,
 #else
 #error please implement for this limb size.
 #endif
-		if (lzeros > 0) {
+		if (lzeros) {
 			mpi_limb_t *limb1 = (void *)p - sizeof(alimb);
 			mpi_limb_t *limb2 = (void *)p - sizeof(alimb)
 				+ lzeros;
 			*limb1 = *limb2;
 			p -= lzeros;
 			y = lzeros;
-			lzeros -= sizeof(alimb);
+			lzeros = 0;
 		}
 
 		p = p - (sizeof(alimb) - y);
-- 
2.7.4
