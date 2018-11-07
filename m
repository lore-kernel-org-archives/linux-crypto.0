Return-Path: <SRS0=rMEF=NS=vger.kernel.org=linux-crypto-owner@kernel.org>
Received: from mail-eopbgr40073.outbound.protection.outlook.com ([40.107.4.73]:2145
        "EHLO EUR03-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727387AbeKHBE1 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 7 Nov 2018 20:04:27 -0500
From: Leonard Crestez <leonard.crestez@nxp.com>
To: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller " <davem@davemloft.net>,
        Marek Vasut <marek.vasut@gmail.com>
CC: Horia Geanta <horia.geanta@nxp.com>,
        Franck Lenormand <franck.lenormand@nxp.com>,
        Fabio Estevam <fabio.estevam@nxp.com>,
        Shawn Guo <shawnguo@kernel.org>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        dl-linux-imx <linux-imx@nxp.com>,
        "kernel@pengutronix.de" <kernel@pengutronix.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [RESEND 2/2] crypto: mxs-dcp - Add support for dcp clk
Date: Wed, 7 Nov 2018 15:33:32 +0000
Message-ID: <d59eb933624a2da6432a31cdab7616629fe6ac71.1541604742.git.leonard.crestez@nxp.com>
References: <cover.1541604742.git.leonard.crestez@nxp.com>
In-Reply-To: <cover.1541604742.git.leonard.crestez@nxp.com>
Content-Language: en-US
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 6ull and 6sll the DCP block has a clock which needs to be explicitly
enabled.

Add minimal handling for this at probe/remove time.

Signed-off-by: Leonard Crestez <leonard.crestez@nxp.com>
Reviewed-by: Fabio Estevam <festevam@gmail.com>
---
 drivers/crypto/mxs-dcp.c | 28 +++++++++++++++++++++++++---
 1 file changed, 25 insertions(+), 3 deletions(-)

diff --git a/drivers/crypto/mxs-dcp.c b/drivers/crypto/mxs-dcp.c
index 4e6ff32f8a7e..a2105cf33abb 100644
--- a/drivers/crypto/mxs-dcp.c
+++ b/drivers/crypto/mxs-dcp.c
@@ -18,10 +18,11 @@
 #include <linux/kthread.h>
 #include <linux/module.h>
 #include <linux/of.h>
 #include <linux/platform_device.h>
 #include <linux/stmp_device.h>
+#include <linux/clk.h>
=20
 #include <crypto/aes.h>
 #include <crypto/sha.h>
 #include <crypto/internal/hash.h>
 #include <crypto/internal/skcipher.h>
@@ -80,10 +81,11 @@ struct dcp {
=20
 	struct completion		completion[DCP_MAX_CHANS];
 	spinlock_t			lock[DCP_MAX_CHANS];
 	struct task_struct		*thread[DCP_MAX_CHANS];
 	struct crypto_queue		queue[DCP_MAX_CHANS];
+	struct clk			*dcp_clk;
 };
=20
 enum dcp_chan {
 	DCP_CHAN_HASH_SHA	=3D 0,
 	DCP_CHAN_CRYPTO		=3D 2,
@@ -1051,15 +1053,28 @@ static int mxs_dcp_probe(struct platform_device *pd=
ev)
 		return -ENOMEM;
=20
 	/* Re-align the structure so it fits the DCP constraints. */
 	sdcp->coh =3D PTR_ALIGN(sdcp->coh, DCP_ALIGNMENT);
=20
-	/* Restart the DCP block. */
-	ret =3D stmp_reset_block(sdcp->base);
+	/* DCP clock is optional, only used on some SOCs */
+	sdcp->dcp_clk =3D devm_clk_get(dev, "dcp");
+	if (IS_ERR(sdcp->dcp_clk)) {
+		if (sdcp->dcp_clk !=3D ERR_PTR(-ENOENT))
+			return PTR_ERR(sdcp->dcp_clk);
+		sdcp->dcp_clk =3D NULL;
+	}
+	ret =3D clk_prepare_enable(sdcp->dcp_clk);
 	if (ret)
 		return ret;
=20
+	/* Restart the DCP block. */
+	ret =3D stmp_reset_block(sdcp->base);
+	if (ret) {
+		dev_err(dev, "Failed reset\n");
+		goto err_disable_unprepare_clk;
+	}
+
 	/* Initialize control register. */
 	writel(MXS_DCP_CTRL_GATHER_RESIDUAL_WRITES |
 	       MXS_DCP_CTRL_ENABLE_CONTEXT_CACHING | 0xf,
 	       sdcp->base + MXS_DCP_CTRL);
=20
@@ -1092,11 +1107,12 @@ static int mxs_dcp_probe(struct platform_device *pd=
ev)
 	/* Create the SHA and AES handler threads. */
 	sdcp->thread[DCP_CHAN_HASH_SHA] =3D kthread_run(dcp_chan_thread_sha,
 						      NULL, "mxs_dcp_chan/sha");
 	if (IS_ERR(sdcp->thread[DCP_CHAN_HASH_SHA])) {
 		dev_err(dev, "Error starting SHA thread!\n");
-		return PTR_ERR(sdcp->thread[DCP_CHAN_HASH_SHA]);
+		ret =3D PTR_ERR(sdcp->thread[DCP_CHAN_HASH_SHA]);
+		goto err_disable_unprepare_clk;
 	}
=20
 	sdcp->thread[DCP_CHAN_CRYPTO] =3D kthread_run(dcp_chan_thread_aes,
 						    NULL, "mxs_dcp_chan/aes");
 	if (IS_ERR(sdcp->thread[DCP_CHAN_CRYPTO])) {
@@ -1149,10 +1165,14 @@ static int mxs_dcp_probe(struct platform_device *pd=
ev)
 err_destroy_aes_thread:
 	kthread_stop(sdcp->thread[DCP_CHAN_CRYPTO]);
=20
 err_destroy_sha_thread:
 	kthread_stop(sdcp->thread[DCP_CHAN_HASH_SHA]);
+
+err_disable_unprepare_clk:
+	clk_disable_unprepare(sdcp->dcp_clk);
+
 	return ret;
 }
=20
 static int mxs_dcp_remove(struct platform_device *pdev)
 {
@@ -1168,10 +1188,12 @@ static int mxs_dcp_remove(struct platform_device *p=
dev)
 		crypto_unregister_algs(dcp_aes_algs, ARRAY_SIZE(dcp_aes_algs));
=20
 	kthread_stop(sdcp->thread[DCP_CHAN_HASH_SHA]);
 	kthread_stop(sdcp->thread[DCP_CHAN_CRYPTO]);
=20
+	clk_disable_unprepare(sdcp->dcp_clk);
+
 	platform_set_drvdata(pdev, NULL);
=20
 	global_sdcp =3D NULL;
=20
 	return 0;
--=20
2.17.1
