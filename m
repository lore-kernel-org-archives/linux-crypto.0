From: Alex Porosanu <alexandru.porosanu@freescale.com>
Subject: [PATCH 2/7] crypto: caam - fix hash, alg and rng registration if CAAM driver not initialized
Date: Mon, 9 Sep 2013 18:56:29 +0300
Message-ID: <1378742194-32194-3-git-send-email-alexandru.porosanu@freescale.com>
References: <1378742194-32194-1-git-send-email-alexandru.porosanu@freescale.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: <herbert@gondor.hengli.com.au>, <horia.geanta@freescale.com>,
	<vakul@freescale.com>
To: <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-db9lp0251.outbound.messaging.microsoft.com ([213.199.154.251]:25955
	"EHLO db9outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754067Ab3IIP7X (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 9 Sep 2013 11:59:23 -0400
In-Reply-To: <1378742194-32194-1-git-send-email-alexandru.porosanu@freescale.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

If the CAAM driver initialization failed (due to various reasons, e.g. RNG4
initialization failed), then the registration of hash/algorithms/rng shouldn't
take place. This patch adds the necessary code to prevent this registration.

Signed-off-by: Alex Porosanu <alexandru.porosanu@freescale.com>
---
 drivers/crypto/caam/caamalg.c  |    7 +++++++
 drivers/crypto/caam/caamhash.c |    7 +++++++
 drivers/crypto/caam/caamrng.c  |    7 +++++++
 3 files changed, 21 insertions(+), 0 deletions(-)

diff --git a/drivers/crypto/caam/caamalg.c b/drivers/crypto/caam/caamalg.c
index 7c63b72..86a0d41 100644
--- a/drivers/crypto/caam/caamalg.c
+++ b/drivers/crypto/caam/caamalg.c
@@ -2209,6 +2209,13 @@ static int __init caam_algapi_init(void)
 	priv = dev_get_drvdata(ctrldev);
 	of_node_put(dev_node);
 
+	/*
+	 * If priv is NULL, it's probably because the caam driver wasn't
+	 * properly initialized (e.g. RNG4 init failed). Thus, bail out here.
+	 */
+	if (!priv)
+		return -ENODEV;
+
 	INIT_LIST_HEAD(&priv->alg_list);
 
 	atomic_set(&priv->tfm_count, -1);
diff --git a/drivers/crypto/caam/caamhash.c b/drivers/crypto/caam/caamhash.c
index e732bd9..ca6218e 100644
--- a/drivers/crypto/caam/caamhash.c
+++ b/drivers/crypto/caam/caamhash.c
@@ -1833,6 +1833,13 @@ static int __init caam_algapi_hash_init(void)
 	priv = dev_get_drvdata(ctrldev);
 	of_node_put(dev_node);
 
+	/*
+	 * If priv is NULL, it's probably because the caam driver wasn't
+	 * properly initialized (e.g. RNG4 init failed). Thus, bail out here.
+	 */
+	if (!priv)
+		return -ENODEV;
+
 	INIT_LIST_HEAD(&priv->hash_list);
 
 	atomic_set(&priv->tfm_count, -1);
diff --git a/drivers/crypto/caam/caamrng.c b/drivers/crypto/caam/caamrng.c
index d1939a9..588ad22 100644
--- a/drivers/crypto/caam/caamrng.c
+++ b/drivers/crypto/caam/caamrng.c
@@ -298,6 +298,13 @@ static int __init caam_rng_init(void)
 	priv = dev_get_drvdata(ctrldev);
 	of_node_put(dev_node);
 
+	/*
+	 * If priv is NULL, it's probably because the caam driver wasn't
+	 * properly initialized (e.g. RNG4 init failed). Thus, bail out here.
+	 */
+	if (!priv)
+		return -ENODEV;
+
 	caam_init_rng(&rng_ctx, priv->jrdev[0]);
 
 	dev_info(priv->jrdev[0], "registering rng-caam\n");
-- 
1.7.7.6
