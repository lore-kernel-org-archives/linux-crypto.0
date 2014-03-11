From: Jason Cooper <jason@lakedaemon.net>
Subject: [RFC PATCH 06/22] staging: crypto: skein: remove __cplusplus and an unneeded stddef.h
Date: Tue, 11 Mar 2014 21:32:38 +0000
Message-ID: <a612f45d72034f86c0fc2e01a38b954322e2ad01.1394570067.git.jason@lakedaemon.net>
References: <cover.1394570067.git.jason@lakedaemon.net>
Cc: devel@driverdev.osuosl.org, linux-crypto@vger.kernel.org,
	Jason Cooper <jason@lakedaemon.net>
To: Greg KH <gregkh@linuxfoundation.org>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:22317 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755745AbaCKVzl (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 11 Mar 2014 17:55:41 -0400
In-Reply-To: <cover.1394570067.git.jason@lakedaemon.net>
In-Reply-To: <cover.1394570067.git.jason@lakedaemon.net>
References: <cover.1394570067.git.jason@lakedaemon.net>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Signed-off-by: Jason Cooper <jason@lakedaemon.net>
---
 drivers/staging/skein/include/skein.h        | 11 -----------
 drivers/staging/skein/include/skeinApi.h     |  9 ---------
 drivers/staging/skein/include/threefishApi.h |  9 ---------
 3 files changed, 29 deletions(-)

diff --git a/drivers/staging/skein/include/skein.h b/drivers/staging/skein/include/skein.h
index 211aca1b1036..b1e55b08d150 100644
--- a/drivers/staging/skein/include/skein.h
+++ b/drivers/staging/skein/include/skein.h
@@ -27,13 +27,6 @@
 **                                1: return SKEIN_FAIL to flag errors
 **
 ***************************************************************************/
-#ifdef __cplusplus
-extern "C"
-{
-#endif
-
-#include <stddef.h>                          /* get size_t definition */
-
 typedef unsigned int    uint_t;             /* native unsigned integer */
 typedef uint8_t         u08b_t;             /*  8-bit unsigned integer */
 typedef uint64_t        u64b_t;             /* 64-bit unsigned integer */
@@ -322,8 +315,4 @@ enum
 #define SKEIN1024_ROUNDS_TOTAL (8*((((SKEIN_ROUNDS    ) + 5) % 10) + 5))
 #endif
 
-#ifdef __cplusplus
-}
-#endif
-
 #endif  /* ifndef _SKEIN_H_ */
diff --git a/drivers/staging/skein/include/skeinApi.h b/drivers/staging/skein/include/skeinApi.h
index 734d27b79f01..f55c67e81f2b 100755
--- a/drivers/staging/skein/include/skeinApi.h
+++ b/drivers/staging/skein/include/skeinApi.h
@@ -81,11 +81,6 @@ OTHER DEALINGS IN THE SOFTWARE.
 #include <linux/types.h>
 #include <skein.h>
 
-#ifdef __cplusplus
-extern "C"
-{
-#endif
-
     /**
      * Which Skein size to use
      */
@@ -229,10 +224,6 @@ extern "C"
      */
     int skeinFinal(SkeinCtx_t* ctx, uint8_t* hash);
 
-#ifdef __cplusplus
-}
-#endif
-
 /**
  * @}
  */
diff --git a/drivers/staging/skein/include/threefishApi.h b/drivers/staging/skein/include/threefishApi.h
index dae270cf71d3..aaecfe822142 100644
--- a/drivers/staging/skein/include/threefishApi.h
+++ b/drivers/staging/skein/include/threefishApi.h
@@ -33,11 +33,6 @@
 
 #define KeyScheduleConst 0x1BD11BDAA9FC1A22L
 
-#ifdef __cplusplus
-extern "C"
-{
-#endif
-
     /**
      * Which Threefish size to use
      */
@@ -157,10 +152,6 @@ extern "C"
     void threefishDecrypt256(ThreefishKey_t* keyCtx, uint64_t* input, uint64_t* output);
     void threefishDecrypt512(ThreefishKey_t* keyCtx, uint64_t* input, uint64_t* output);
     void threefishDecrypt1024(ThreefishKey_t* keyCtx, uint64_t* input, uint64_t* output);
-#ifdef __cplusplus
-}
-#endif
-
 /**
  * @}
  */
-- 
1.9.0
