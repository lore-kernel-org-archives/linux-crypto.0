From: Nicolai Stange <nicstange@gmail.com>
Subject: [PATCH v3 03/14] lib/mpi: mpi_write_sgl(): purge redundant pointer arithmetic
Date: Tue, 22 Mar 2016 13:12:37 +0100
Message-ID: <1458648768-1469-4-git-send-email-nicstange@gmail.com>
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

Within the copying loop in mpi_write_sgl(), we have

  if (lzeros) {
    ...
    p -= lzeros;
    y = lzeros;
  }
  p = p - (sizeof(alimb) - y);

If lzeros == 0, then y == 0, too. Thus, lzeros gets subtracted and added
back again to p.

Purge this redundancy.

Signed-off-by: Nicolai Stange <nicstange@gmail.com>
---
 lib/mpi/mpicoder.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/lib/mpi/mpicoder.c b/lib/mpi/mpicoder.c
index d8b372b..78ec4e1 100644
--- a/lib/mpi/mpicoder.c
+++ b/lib/mpi/mpicoder.c
@@ -407,12 +407,11 @@ int mpi_write_to_sgl(MPI a, struct scatterlist *sgl, unsigned *nbytes,
 			mpi_limb_t *limb2 = (void *)p - sizeof(alimb)
 				+ lzeros;
 			*limb1 = *limb2;
-			p -= lzeros;
 			y = lzeros;
 			lzeros = 0;
 		}
 
-		p = p - (sizeof(alimb) - y);
+		p = p - sizeof(alimb);
 
 		for (x = 0; x < sizeof(alimb) - y; x++) {
 			if (!buf_len) {
-- 
2.7.4
