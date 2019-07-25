Return-Path: <SRS0=g3pl=VW=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EB49EC76191
	for <linux-crypto@archiver.kernel.org>; Thu, 25 Jul 2019 13:58:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C5CE222C7B
	for <linux-crypto@archiver.kernel.org>; Thu, 25 Jul 2019 13:58:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404337AbfGYN6y (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 25 Jul 2019 09:58:54 -0400
Received: from inva020.nxp.com ([92.121.34.13]:49044 "EHLO inva020.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728268AbfGYN6n (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 25 Jul 2019 09:58:43 -0400
Received: from inva020.nxp.com (localhost [127.0.0.1])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id 296101A0714;
        Thu, 25 Jul 2019 15:58:41 +0200 (CEST)
Received: from inva024.eu-rdc02.nxp.com (inva024.eu-rdc02.nxp.com [134.27.226.22])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id 1D46D1A0709;
        Thu, 25 Jul 2019 15:58:41 +0200 (CEST)
Received: from lorenz.ea.freescale.net (lorenz.ea.freescale.net [10.171.71.5])
        by inva024.eu-rdc02.nxp.com (Postfix) with ESMTP id BEACF205E8;
        Thu, 25 Jul 2019 15:58:40 +0200 (CEST)
From:   Iuliana Prodan <iuliana.prodan@nxp.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        Horia Geanta <horia.geanta@nxp.com>,
        Aymen Sghaier <aymen.sghaier@nxp.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-imx <linux-imx@nxp.com>
Subject: [PATCH v3 12/14] crypto: caam - execute module exit point only if necessary
Date:   Thu, 25 Jul 2019 16:58:24 +0300
Message-Id: <1564063106-9552-13-git-send-email-iuliana.prodan@nxp.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1564063106-9552-1-git-send-email-iuliana.prodan@nxp.com>
References: <1564063106-9552-1-git-send-email-iuliana.prodan@nxp.com>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Commit 1b46c90c8e00 ("crypto: caam - convert top level drivers to libraries")
changed entry and exit points behavior for caamalg,
caamalg_qi, caamalg_qi2, caamhash, caampkc, caamrng.

For example, previously caam_pkc_init() and caam_pkc_exit() were
module entry/exit points. This means that if an error would happen
in caam_pkc_init(), then caam_pkc_exit() wouldn't have been called.
After the mentioned commit, caam_pkc_init() and caam_pkc_exit()
are manually called - from jr.c. caam_pkc_exit() is called
unconditionally, even if caam_pkc_init() failed.

Added a global variable to keep the status of the algorithm
registration and free of resources.
The exit point of caampkc/caamrng module is executed only if the
registration was successful. Therefore we avoid double free of
resources in case the algorithm registration failed.

Fixes: 1b46c90c8e00 ("crypto: caam - convert top level drivers to libraries")
Signed-off-by: Iuliana Prodan <iuliana.prodan@nxp.com>
Reviewed-by: Horia Geanta <horia.geanta@nxp.com>
---
 drivers/crypto/caam/caampkc.c | 11 +++++++++++
 drivers/crypto/caam/caamrng.c | 14 +++++++++++++-
 2 files changed, 24 insertions(+), 1 deletion(-)

diff --git a/drivers/crypto/caam/caampkc.c b/drivers/crypto/caam/caampkc.c
index 574428c7..cfdf7a2 100644
--- a/drivers/crypto/caam/caampkc.c
+++ b/drivers/crypto/caam/caampkc.c
@@ -29,6 +29,12 @@
 /* buffer filled with zeros, used for padding */
 static u8 *zero_buffer;
 
+/*
+ * variable used to avoid double free of resources in case
+ * algorithm registration was unsuccessful
+ */
+static bool init_done;
+
 static void rsa_io_unmap(struct device *dev, struct rsa_edesc *edesc,
 			 struct akcipher_request *req)
 {
@@ -1081,6 +1087,7 @@ int caam_pkc_init(struct device *ctrldev)
 	struct caam_drv_private *priv = dev_get_drvdata(ctrldev);
 	u32 pk_inst;
 	int err;
+	init_done = false;
 
 	/* Determine public key hardware accelerator presence. */
 	if (priv->era < 10)
@@ -1105,6 +1112,7 @@ int caam_pkc_init(struct device *ctrldev)
 		dev_warn(ctrldev, "%s alg registration failed\n",
 			 caam_rsa.base.cra_driver_name);
 	} else {
+		init_done = true;
 		dev_info(ctrldev, "caam pkc algorithms registered in /proc/crypto\n");
 	}
 
@@ -1113,6 +1121,9 @@ int caam_pkc_init(struct device *ctrldev)
 
 void caam_pkc_exit(void)
 {
+	if (!init_done)
+		return;
+
 	kfree(zero_buffer);
 	crypto_unregister_akcipher(&caam_rsa);
 }
diff --git a/drivers/crypto/caam/caamrng.c b/drivers/crypto/caam/caamrng.c
index 54c32d5..7fbda1b 100644
--- a/drivers/crypto/caam/caamrng.c
+++ b/drivers/crypto/caam/caamrng.c
@@ -80,6 +80,12 @@ struct caam_rng_ctx {
 
 static struct caam_rng_ctx *rng_ctx;
 
+/*
+ * Variable used to avoid double free of resources in case
+ * algorithm registration was unsuccessful
+ */
+static bool init_done;
+
 static inline void rng_unmap_buf(struct device *jrdev, struct buf_data *bd)
 {
 	if (bd->addr)
@@ -296,6 +302,9 @@ static struct hwrng caam_rng = {
 
 void caam_rng_exit(void)
 {
+	if (!init_done)
+		return;
+
 	caam_jr_free(rng_ctx->jrdev);
 	hwrng_unregister(&caam_rng);
 	kfree(rng_ctx);
@@ -307,6 +316,7 @@ int caam_rng_init(struct device *ctrldev)
 	u32 rng_inst;
 	struct caam_drv_private *priv = dev_get_drvdata(ctrldev);
 	int err;
+	init_done = false;
 
 	/* Check for an instantiated RNG before registration */
 	if (priv->era < 10)
@@ -335,8 +345,10 @@ int caam_rng_init(struct device *ctrldev)
 	dev_info(dev, "registering rng-caam\n");
 
 	err = hwrng_register(&caam_rng);
-	if (!err)
+	if (!err) {
+		init_done = true;
 		return err;
+	}
 
 free_rng_ctx:
 	kfree(rng_ctx);
-- 
2.1.0

