From: Gary R Hook <gary.hook@amd.com>
Subject: [PATCH 08/10] crypto: ccp - Add support for the RNG in a version 5
 CCP
Date: Tue, 26 Jul 2016 19:10:31 -0500
Message-ID: <20160727001031.24944.90779.stgit@taos>
References: <20160727000652.24944.44919.stgit@taos>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: <thomas.lendacky@amd.com>, <herbert@gondor.apana.org.au>,
	<davem@davemloft.net>
To: <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-dm3nam03on0078.outbound.protection.outlook.com ([104.47.41.78]:43648
	"EHLO NAM03-DM3-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751583AbcG0A0g (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Tue, 26 Jul 2016 20:26:36 -0400
In-Reply-To: <20160727000652.24944.44919.stgit@taos>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Signed-off-by: Gary R Hook <gary.hook@amd.com>
---
 drivers/crypto/ccp/ccp-dev-v3.c |   13 ++++---------
 drivers/crypto/ccp/ccp-dev-v5.c |    7 +++++++
 drivers/crypto/ccp/ccp-dev.c    |   23 +++++++++++++++++++++++
 drivers/crypto/ccp/ccp-dev.h    |    2 ++
 4 files changed, 36 insertions(+), 9 deletions(-)

diff --git a/drivers/crypto/ccp/ccp-dev-v3.c b/drivers/crypto/ccp/ccp-dev-v3.c
index ff2d2a4..578522d 100644
--- a/drivers/crypto/ccp/ccp-dev-v3.c
+++ b/drivers/crypto/ccp/ccp-dev-v3.c
@@ -432,14 +432,9 @@ static int ccp_init(struct ccp_device *ccp)
 	dev_dbg(dev, "Registering device...\n");
 	ccp_add_device(ccp);
 
-	/* Register the RNG */
-	ccp->hwrng.name = ccp->rngname;
-	ccp->hwrng.read = ccp_trng_read;
-	ret = hwrng_register(&ccp->hwrng);
-	if (ret) {
-		dev_err(dev, "error registering hwrng (%d)\n", ret);
+	ret = ccp_register_rng(ccp);
+	if (ret)
 		goto e_kthread;
-	}
 
 	/* Register the DMA engine support */
 	ret = ccp_dmaengine_register(ccp);
@@ -449,7 +444,7 @@ static int ccp_init(struct ccp_device *ccp)
 	return 0;
 
 e_hwrng:
-	hwrng_unregister(&ccp->hwrng);
+	ccp_unregister_rng(ccp);
 
 e_kthread:
 	for (i = 0; i < ccp->cmd_q_count; i++)
@@ -475,7 +470,7 @@ static void ccp_destroy(struct ccp_device *ccp)
 	ccp_dmaengine_unregister(ccp);
 
 	/* Unregister the RNG */
-	hwrng_unregister(&ccp->hwrng);
+	ccp_unregister_rng(ccp);
 
 	/* Remove this device from the list of available units */
 	ccp_del_device(ccp);
diff --git a/drivers/crypto/ccp/ccp-dev-v5.c b/drivers/crypto/ccp/ccp-dev-v5.c
index 16dad96..ddce220 100644
--- a/drivers/crypto/ccp/ccp-dev-v5.c
+++ b/drivers/crypto/ccp/ccp-dev-v5.c
@@ -828,6 +828,10 @@ static int ccp5_init(struct ccp_device *ccp)
 	/* Put this on the unit list to make it available */
 	ccp_add_device(ccp);
 
+	ret = ccp_register_rng(ccp);
+	if (ret)
+		goto e_kthread;
+
 	return 0;
 
 e_kthread:
@@ -852,6 +856,9 @@ static void ccp5_destroy(struct ccp_device *ccp)
 	struct ccp_cmd *cmd;
 	unsigned int i;
 
+	/* Unregister the RNG */
+	ccp_unregister_rng(ccp);
+
 	/* Remove this device from the list of available units first */
 	ccp_del_device(ccp);
 
diff --git a/drivers/crypto/ccp/ccp-dev.c b/drivers/crypto/ccp/ccp-dev.c
index 6b44730..38a98d8 100644
--- a/drivers/crypto/ccp/ccp-dev.c
+++ b/drivers/crypto/ccp/ccp-dev.c
@@ -119,6 +119,29 @@ void ccp_del_device(struct ccp_device *ccp)
 	write_unlock_irqrestore(&ccp_unit_lock, flags);
 }
 
+
+
+int ccp_register_rng(struct ccp_device *ccp)
+{
+	int ret = 0;
+
+	dev_dbg(ccp->dev, "Registering RNG...\n");
+	/* Register an RNG */
+	ccp->hwrng.name = ccp->rngname;
+	ccp->hwrng.read = ccp_trng_read;
+	ret = hwrng_register(&ccp->hwrng);
+	if (ret)
+		dev_err(ccp->dev, "error registering hwrng (%d)\n", ret);
+
+	return ret;
+}
+
+void ccp_unregister_rng(struct ccp_device *ccp)
+{
+	if (ccp->hwrng.name)
+		hwrng_unregister(&ccp->hwrng);
+}
+
 static struct ccp_device *ccp_get_device(void)
 {
 	unsigned long flags;
diff --git a/drivers/crypto/ccp/ccp-dev.h b/drivers/crypto/ccp/ccp-dev.h
index 5ff4a73..d04bd61 100644
--- a/drivers/crypto/ccp/ccp-dev.h
+++ b/drivers/crypto/ccp/ccp-dev.h
@@ -601,6 +601,8 @@ int ccp_trng_read(struct hwrng *rng, void *data, size_t max, bool wait);
 
 int ccp_run_cmd(struct ccp_cmd_queue *cmd_q, struct ccp_cmd *cmd);
 
+int ccp_register_rng(struct ccp_device *ccp);
+void ccp_unregister_rng(struct ccp_device *ccp);
 int ccp_dmaengine_register(struct ccp_device *ccp);
 void ccp_dmaengine_unregister(struct ccp_device *ccp);
 
