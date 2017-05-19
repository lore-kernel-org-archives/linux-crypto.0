From: Corentin Labbe <clabbe.montjoie-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH v2 4/9] crypto: marvell - Use IPAD/OPAD constant
Date: Fri, 19 May 2017 08:53:26 +0200
Message-ID: <20170519065331.27670-5-clabbe.montjoie@gmail.com>
References: <20170519065331.27670-1-clabbe.montjoie@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: qat-linux-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
 Corentin Labbe <clabbe.montjoie-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-crypto-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
 linux-mediatek-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org
To: herbert-lOAM2aK0SrRLBo1qDEOMRrpzq4S04n8Q@public.gmane.org, davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org, thomas.lendacky-5C7GfCeVMHo@public.gmane.org,
 gary.hook-5C7GfCeVMHo@public.gmane.org, boris.brezillon-wi1+55ScJUtKEb57/3fJTNBPR1lH4CV8@public.gmane.org, arno-LkuqDEemtHBg9hUCZPvPmw@public.gmane.org,
 matthias.bgg-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, giovanni.cabiddu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org,
 salvatore.benedetto-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Return-path: <linux-mediatek-bounces+glpam-linux-mediatek=m.gmane.org-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>
In-Reply-To: <20170519065331.27670-1-clabbe.montjoie-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-mediatek>,
 <mailto:linux-mediatek-request-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-mediatek/>
List-Post: <mailto:linux-mediatek-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>
List-Help: <mailto:linux-mediatek-request-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-mediatek>,
 <mailto:linux-mediatek-request-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org?subject=subscribe>
Sender: "Linux-mediatek" <linux-mediatek-bounces-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>
Errors-To: linux-mediatek-bounces+glpam-linux-mediatek=m.gmane.org-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org
List-Id: linux-crypto.vger.kernel.org

This patch simply replace all occurrence of HMAC IPAD/OPAD value by their
define.

Signed-off-by: Corentin Labbe <clabbe.montjoie-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
 drivers/crypto/marvell/hash.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/crypto/marvell/hash.c b/drivers/crypto/marvell/hash.c
index 77c0fb936f47..e61b08566093 100644
--- a/drivers/crypto/marvell/hash.c
+++ b/drivers/crypto/marvell/hash.c
@@ -12,6 +12,7 @@
  * by the Free Software Foundation.
  */
 
+#include <crypto/hmac.h>
 #include <crypto/md5.h>
 #include <crypto/sha.h>
 
@@ -1164,8 +1165,8 @@ static int mv_cesa_ahmac_pad_init(struct ahash_request *req,
 	memcpy(opad, ipad, blocksize);
 
 	for (i = 0; i < blocksize; i++) {
-		ipad[i] ^= 0x36;
-		opad[i] ^= 0x5c;
+		ipad[i] ^= HMAC_IPAD_VALUE;
+		opad[i] ^= HMAC_OPAD_VALUE;
 	}
 
 	return 0;
-- 
2.13.0
