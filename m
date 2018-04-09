From: Jan Glauber <jglauber@cavium.com>
Subject: [PATCH v2 4/5] crypto: thunderx_zip: Fix statistics pending request value
Date: Mon,  9 Apr 2018 17:45:53 +0200
Message-ID: <20180409154554.7578-5-jglauber@cavium.com>
References: <20180409154554.7578-1-jglauber@cavium.com>
Cc: "David S . Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        Mahipal Challa <Mahipal.Challa@cavium.com>,
        Robert Richter <rrichter@cavium.com>,
        Jan Glauber <jglauber@cavium.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180409154554.7578-1-jglauber@cavium.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

The pending request counter was read from the wrong register. While
at it, there is no need to use an atomic for it as it is only read
localy in a loop.

Signed-off-by: Jan Glauber <jglauber@cavium.com>
Reviewed-by: Robert Richter <rrichter@cavium.com>
---
 drivers/crypto/cavium/zip/zip_main.c | 13 +++++--------
 drivers/crypto/cavium/zip/zip_main.h |  1 -
 2 files changed, 5 insertions(+), 9 deletions(-)

diff --git a/drivers/crypto/cavium/zip/zip_main.c b/drivers/crypto/cavium/zip/zip_main.c
index 79b449e0f955..ae5b20c695ca 100644
--- a/drivers/crypto/cavium/zip/zip_main.c
+++ b/drivers/crypto/cavium/zip/zip_main.c
@@ -469,6 +469,8 @@ static int zip_show_stats(struct seq_file *s, void *unused)
 	struct zip_stats  *st;
 
 	for (index = 0; index < MAX_ZIP_DEVICES; index++) {
+		u64 pending = 0;
+
 		if (zip_dev[index]) {
 			zip = zip_dev[index];
 			st  = &zip->stats;
@@ -476,10 +478,8 @@ static int zip_show_stats(struct seq_file *s, void *unused)
 			/* Get all the pending requests */
 			for (q = 0; q < ZIP_NUM_QUEUES; q++) {
 				val = zip_reg_read((zip->reg_base +
-						    ZIP_DBG_COREX_STA(q)));
-				val = (val >> 32);
-				val = val & 0xffffff;
-				atomic64_add(val, &st->pending_req);
+						    ZIP_DBG_QUEX_STA(q)));
+				pending += val >> 32 & 0xffffff;
 			}
 
 			val = atomic64_read(&st->comp_req_complete);
@@ -514,10 +514,7 @@ static int zip_show_stats(struct seq_file *s, void *unused)
 				       (u64)atomic64_read(&st->decomp_in_bytes),
 				       (u64)atomic64_read(&st->decomp_out_bytes),
 				       (u64)atomic64_read(&st->decomp_bad_reqs),
-				       (u64)atomic64_read(&st->pending_req));
-
-			/* Reset pending requests  count */
-			atomic64_set(&st->pending_req, 0);
+				       pending);
 		}
 	}
 	return 0;
diff --git a/drivers/crypto/cavium/zip/zip_main.h b/drivers/crypto/cavium/zip/zip_main.h
index 64e051f60784..e1e4fa92ce80 100644
--- a/drivers/crypto/cavium/zip/zip_main.h
+++ b/drivers/crypto/cavium/zip/zip_main.h
@@ -74,7 +74,6 @@ struct zip_stats {
 	atomic64_t    comp_req_complete;
 	atomic64_t    decomp_req_submit;
 	atomic64_t    decomp_req_complete;
-	atomic64_t    pending_req;
 	atomic64_t    comp_in_bytes;
 	atomic64_t    comp_out_bytes;
 	atomic64_t    decomp_in_bytes;
-- 
2.16.2
