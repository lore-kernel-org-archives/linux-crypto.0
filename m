From: Fabio Estevam <fabio.estevam@freescale.com>
Subject: [PATCH v2] mxs-dcp: Remove global mutex
Date: Mon, 12 May 2014 08:44:28 -0300
Message-ID: <1399895068-3326-1-git-send-email-fabio.estevam@freescale.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: <linux-crypto@vger.kernel.org>, <shawn.guo@freescale.com>,
	<marex@denx.de>, <shc_work@mail.ru>,
	Fabio Estevam <fabio.estevam@freescale.com>
To: <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-bl2on0080.outbound.protection.outlook.com ([65.55.169.80]:57129
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1758377AbaELNRh (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Mon, 12 May 2014 09:17:37 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Remove mutex_lock from probe in order to avoid the following warning:

[    8.526613] Freeing unused kernel memory: 232K (c0683000 - c06bd000)
starting pid 56, tty '': '/etc/rc.d/rcS'
[    9.110314]
[    9.111864] =====================================
[    9.116603] [ BUG: init/1 still has locks held! ]
[    9.121488] 3.15.0-rc4-next-20140509-00001-g319564e #1154 Not tainted
[    9.128071] -------------------------------------
[    9.132825] 1 lock held by init/1:
[    9.136252]  #0:  (global_mutex){+.+.+.}, at: [<c0387d68>] mxs_dcp_probe+0x14
[    9.144196]
[    9.144196] stack backtrace:
[    9.148888] CPU: 0 PID: 1 Comm: init Not tainted 3.15.0-rc4-next-20140509-004
[    9.157610] [<c000da40>] (unwind_backtrace) from [<c000bda4>] (show_stack+0x)
[    9.165595] [<c000bda4>] (show_stack) from [<c00153d4>] (do_fork+0x2c8/0x3cc)
[    9.172921] [<c00153d4>] (do_fork) from [<c0015550>] (sys_vfork+0x20/0x2c)
[    9.179973] [<c0015550>] (sys_vfork) from [<c0009580>] (ret_fast_syscall+0x0)

Signed-off-by: Fabio Estevam <fabio.estevam@freescale.com>
---
Changes since v1:
- Remove global_mutex entirely

 drivers/crypto/mxs-dcp.c | 50 ++++++++++++++++--------------------------------
 1 file changed, 16 insertions(+), 34 deletions(-)

diff --git a/drivers/crypto/mxs-dcp.c b/drivers/crypto/mxs-dcp.c
index 7bbe0ab..e48f0b8 100644
--- a/drivers/crypto/mxs-dcp.c
+++ b/drivers/crypto/mxs-dcp.c
@@ -104,7 +104,6 @@ struct dcp_sha_req_ctx {
  * design of Linux Crypto API.
  */
 static struct dcp *global_sdcp;
-static DEFINE_MUTEX(global_mutex);
 
 /* DCP register layout. */
 #define MXS_DCP_CTRL				0x00
@@ -907,60 +906,49 @@ static int mxs_dcp_probe(struct platform_device *pdev)
 	struct resource *iores;
 	int dcp_vmi_irq, dcp_irq;
 
-	mutex_lock(&global_mutex);
 	if (global_sdcp) {
 		dev_err(dev, "Only one DCP instance allowed!\n");
-		ret = -ENODEV;
-		goto err_mutex;
+		return -ENODEV;
 	}
 
 	iores = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	dcp_vmi_irq = platform_get_irq(pdev, 0);
-	if (dcp_vmi_irq < 0) {
-		ret = dcp_vmi_irq;
-		goto err_mutex;
-	}
+	if (dcp_vmi_irq < 0)
+		return dcp_vmi_irq;
 
 	dcp_irq = platform_get_irq(pdev, 1);
-	if (dcp_irq < 0) {
-		ret = dcp_irq;
-		goto err_mutex;
-	}
+	if (dcp_irq < 0)
+		return dcp_irq;
 
 	sdcp = devm_kzalloc(dev, sizeof(*sdcp), GFP_KERNEL);
-	if (!sdcp) {
-		ret = -ENOMEM;
-		goto err_mutex;
-	}
+	if (!sdcp)
+		return -ENOMEM;
 
 	sdcp->dev = dev;
 	sdcp->base = devm_ioremap_resource(dev, iores);
-	if (IS_ERR(sdcp->base)) {
-		ret = PTR_ERR(sdcp->base);
-		goto err_mutex;
-	}
+	if (IS_ERR(sdcp->base))
+		return PTR_ERR(sdcp->base);
+
 
 	ret = devm_request_irq(dev, dcp_vmi_irq, mxs_dcp_irq, 0,
 			       "dcp-vmi-irq", sdcp);
 	if (ret) {
 		dev_err(dev, "Failed to claim DCP VMI IRQ!\n");
-		goto err_mutex;
+		return ret;
 	}
 
 	ret = devm_request_irq(dev, dcp_irq, mxs_dcp_irq, 0,
 			       "dcp-irq", sdcp);
 	if (ret) {
 		dev_err(dev, "Failed to claim DCP IRQ!\n");
-		goto err_mutex;
+		return ret;
 	}
 
 	/* Allocate coherent helper block. */
 	sdcp->coh = devm_kzalloc(dev, sizeof(*sdcp->coh) + DCP_ALIGNMENT,
 				   GFP_KERNEL);
-	if (!sdcp->coh) {
-		ret = -ENOMEM;
-		goto err_mutex;
-	}
+	if (!sdcp->coh)
+		return -ENOMEM;
 
 	/* Re-align the structure so it fits the DCP constraints. */
 	sdcp->coh = PTR_ALIGN(sdcp->coh, DCP_ALIGNMENT);
@@ -968,7 +956,7 @@ static int mxs_dcp_probe(struct platform_device *pdev)
 	/* Restart the DCP block. */
 	ret = stmp_reset_block(sdcp->base);
 	if (ret)
-		goto err_mutex;
+		return ret;
 
 	/* Initialize control register. */
 	writel(MXS_DCP_CTRL_GATHER_RESIDUAL_WRITES |
@@ -1006,8 +994,7 @@ static int mxs_dcp_probe(struct platform_device *pdev)
 						      NULL, "mxs_dcp_chan/sha");
 	if (IS_ERR(sdcp->thread[DCP_CHAN_HASH_SHA])) {
 		dev_err(dev, "Error starting SHA thread!\n");
-		ret = PTR_ERR(sdcp->thread[DCP_CHAN_HASH_SHA]);
-		goto err_mutex;
+		return PTR_ERR(sdcp->thread[DCP_CHAN_HASH_SHA]);
 	}
 
 	sdcp->thread[DCP_CHAN_CRYPTO] = kthread_run(dcp_chan_thread_aes,
@@ -1064,9 +1051,6 @@ err_destroy_aes_thread:
 
 err_destroy_sha_thread:
 	kthread_stop(sdcp->thread[DCP_CHAN_HASH_SHA]);
-
-err_mutex:
-	mutex_unlock(&global_mutex);
 	return ret;
 }
 
@@ -1088,9 +1072,7 @@ static int mxs_dcp_remove(struct platform_device *pdev)
 
 	platform_set_drvdata(pdev, NULL);
 
-	mutex_lock(&global_mutex);
 	global_sdcp = NULL;
-	mutex_unlock(&global_mutex);
 
 	return 0;
 }
-- 
1.8.3.2
