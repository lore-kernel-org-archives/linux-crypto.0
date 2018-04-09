From: Jan Glauber <jglauber@cavium.com>
Subject: [PATCH v2 5/5] crypto: thunderx_zip: Fix smp_processor_id() warnings
Date: Mon,  9 Apr 2018 17:45:54 +0200
Message-ID: <20180409154554.7578-6-jglauber@cavium.com>
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

Switch to raw_smp_processor_id() to prevent a number of
warnings from kernel debugging. We do not care about
preemption here, as the CPU number is only used as a
poor mans load balancing or device selection. If preemption
happens during a compress/decompress operation a small performance
hit will occur but everything will continue to work, so just
ignore it.

Signed-off-by: Jan Glauber <jglauber@cavium.com>
Reviewed-by: Robert Richter <rrichter@cavium.com>
---
 drivers/crypto/cavium/zip/zip_device.c | 4 ++--
 drivers/crypto/cavium/zip/zip_main.c   | 2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/crypto/cavium/zip/zip_device.c b/drivers/crypto/cavium/zip/zip_device.c
index ccf21fb91513..f174ec29ed69 100644
--- a/drivers/crypto/cavium/zip/zip_device.c
+++ b/drivers/crypto/cavium/zip/zip_device.c
@@ -87,12 +87,12 @@ u32 zip_load_instr(union zip_inst_s *instr,
 	 * Distribute the instructions between the enabled queues based on
 	 * the CPU id.
 	 */
-	if (smp_processor_id() % 2 == 0)
+	if (raw_smp_processor_id() % 2 == 0)
 		queue = 0;
 	else
 		queue = 1;
 
-	zip_dbg("CPU Core: %d Queue number:%d", smp_processor_id(), queue);
+	zip_dbg("CPU Core: %d Queue number:%d", raw_smp_processor_id(), queue);
 
 	/* Take cmd buffer lock */
 	spin_lock(&zip_dev->iq[queue].lock);
diff --git a/drivers/crypto/cavium/zip/zip_main.c b/drivers/crypto/cavium/zip/zip_main.c
index ae5b20c695ca..be055b9547f6 100644
--- a/drivers/crypto/cavium/zip/zip_main.c
+++ b/drivers/crypto/cavium/zip/zip_main.c
@@ -113,7 +113,7 @@ struct zip_device *zip_get_device(int node)
  */
 int zip_get_node_id(void)
 {
-	return cpu_to_node(smp_processor_id());
+	return cpu_to_node(raw_smp_processor_id());
 }
 
 /* Initializes the ZIP h/w sub-system */
-- 
2.16.2
