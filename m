From: Jan Glauber <jglauber@cavium.com>
Subject: [PATCH 2/2] crypto: thunderx_zip: Limit result reading attempts
Date: Wed, 28 Mar 2018 15:05:57 +0200
Message-ID: <20180328130557.10560-2-jglauber@cavium.com>
References: <20180328130557.10560-1-jglauber@cavium.com>
Cc: "David S . Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        Mahipal Challa <Mahipal.Challa@cavium.com>,
        Robert Richter <rrichter@cavium.com>,
        Jan Glauber <jglauber@cavium.com>,
        stable <stable@vger.kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180328130557.10560-1-jglauber@cavium.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

After issuing a request an endless loop was used to read the
completion state from memory which is asynchronously updated
by the ZIP coprocessor.

Add an upper bound to the retry attempts to prevent a CPU getting stuck
forever in case of an error. Additionally, add a read memory barrier
and a small delay between the reading attempts.

Signed-off-by: Jan Glauber <jglauber@cavium.com>
Reviewed-by: Robert Richter <rrichter@cavium.com>
Cc: stable <stable@vger.kernel.org> # 4.14
---
 drivers/crypto/cavium/zip/common.h      | 22 ++++++++++++++++++++++
 drivers/crypto/cavium/zip/zip_deflate.c |  4 ++--
 drivers/crypto/cavium/zip/zip_inflate.c |  4 ++--
 3 files changed, 26 insertions(+), 4 deletions(-)

diff --git a/drivers/crypto/cavium/zip/common.h b/drivers/crypto/cavium/zip/common.h
index dc451e0..9067451 100644
--- a/drivers/crypto/cavium/zip/common.h
+++ b/drivers/crypto/cavium/zip/common.h
@@ -46,8 +46,10 @@
 #ifndef __COMMON_H__
 #define __COMMON_H__
 
+#include <linux/delay.h>
 #include <linux/init.h>
 #include <linux/interrupt.h>
+#include <linux/io.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/pci.h>
@@ -149,6 +151,26 @@ struct zip_operation {
 	u32   sizeofzops;
 };
 
+#define ZIP_POLL_DELAY 20 /* microseconds */
+#define ZIP_POLL_TIMEOUT (msecs_to_jiffies(1000))
+
+static inline int zip_poll_result(union zip_zres_s *result)
+{
+	u64 end = get_jiffies_64() + ZIP_POLL_TIMEOUT;
+
+	while (!result->s.compcode) {
+		/*
+		 * Force re-reading of compcode which is updated
+		 * by the ZIP coprocessor.
+		 */
+		rmb();
+		if (time_after64(get_jiffies_64(), end))
+			return -ETIMEDOUT;
+		usleep_range(ZIP_POLL_DELAY / 2, ZIP_POLL_DELAY);
+	}
+	return 0;
+}
+
 /* error messages */
 #define zip_err(fmt, args...) pr_err("ZIP ERR:%s():%d: " \
 			      fmt "\n", __func__, __LINE__, ## args)
diff --git a/drivers/crypto/cavium/zip/zip_deflate.c b/drivers/crypto/cavium/zip/zip_deflate.c
index 9a944b8..d7133f8 100644
--- a/drivers/crypto/cavium/zip/zip_deflate.c
+++ b/drivers/crypto/cavium/zip/zip_deflate.c
@@ -129,8 +129,8 @@ int zip_deflate(struct zip_operation *zip_ops, struct zip_state *s,
 	/* Stats update for compression requests submitted */
 	atomic64_inc(&zip_dev->stats.comp_req_submit);
 
-	while (!result_ptr->s.compcode)
-		continue;
+	/* Wait for completion or error */
+	zip_poll_result(result_ptr);
 
 	/* Stats update for compression requests completed */
 	atomic64_inc(&zip_dev->stats.comp_req_complete);
diff --git a/drivers/crypto/cavium/zip/zip_inflate.c b/drivers/crypto/cavium/zip/zip_inflate.c
index 50cbdd8..7e0d73e 100644
--- a/drivers/crypto/cavium/zip/zip_inflate.c
+++ b/drivers/crypto/cavium/zip/zip_inflate.c
@@ -143,8 +143,8 @@ int zip_inflate(struct zip_operation *zip_ops, struct zip_state *s,
 	/* Decompression requests submitted stats update */
 	atomic64_inc(&zip_dev->stats.decomp_req_submit);
 
-	while (!result_ptr->s.compcode)
-		continue;
+	/* Wait for completion or error */
+	zip_poll_result(result_ptr);
 
 	/* Decompression requests completed stats update */
 	atomic64_inc(&zip_dev->stats.decomp_req_complete);
-- 
2.7.4
