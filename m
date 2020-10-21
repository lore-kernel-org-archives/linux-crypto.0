Return-Path: <SRS0=E9jf=D4=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CD702C4363A
	for <linux-crypto@archiver.kernel.org>; Wed, 21 Oct 2020 20:07:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5DCCE24171
	for <linux-crypto@archiver.kernel.org>; Wed, 21 Oct 2020 20:07:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2505080AbgJUUHI (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 21 Oct 2020 16:07:08 -0400
Received: from inva020.nxp.com ([92.121.34.13]:47712 "EHLO inva020.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2505078AbgJUUHI (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 21 Oct 2020 16:07:08 -0400
Received: from inva020.nxp.com (localhost [127.0.0.1])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id 384CB1A0A84;
        Wed, 21 Oct 2020 22:07:06 +0200 (CEST)
Received: from inva024.eu-rdc02.nxp.com (inva024.eu-rdc02.nxp.com [134.27.226.22])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id 2BA461A0C34;
        Wed, 21 Oct 2020 22:07:06 +0200 (CEST)
Received: from lorenz.ea.freescale.net (lorenz.ea.freescale.net [10.171.71.5])
        by inva024.eu-rdc02.nxp.com (Postfix) with ESMTP id AB7E02033F;
        Wed, 21 Oct 2020 22:07:05 +0200 (CEST)
From:   Iuliana Prodan <iuliana.prodan@nxp.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        Horia Geanta <horia.geanta@nxp.com>,
        Aymen Sghaier <aymen.sghaier@nxp.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Silvano Di Ninno <silvano.dininno@nxp.com>,
        Franck Lenormand <franck.lenormand@nxp.com>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-imx <linux-imx@nxp.com>,
        Andrei Botila <andrei.botila@nxp.com>,
        Dragos Rosioru <dragos.rosioru@nxp.com>,
        Iuliana Prodan <iuliana.prodan@nxp.com>
Subject: [PATCH] crypto: caam - enable crypto-engine retry mechanism
Date:   Wed, 21 Oct 2020 23:06:50 +0300
Message-Id: <1603310810-25307-1-git-send-email-iuliana.prodan@nxp.com>
X-Mailer: git-send-email 2.1.0
X-Virus-Scanned: ClamAV using ClamSMTP
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Use the new crypto_engine_alloc_init_and_set() function to
initialize crypto-engine and enable retry mechanism.

Set the maximum size for crypto-engine software queue based on
Job Ring size (JOBR_DEPTH) and a threshold (reserved for the
non-crypto-API requests that are not pass through crypto-engine).

The callback for do_batch_requests is NULL, since CAAM
doesn't support linked requests.

Signed-off-by: Iuliana Prodan <iuliana.prodan@nxp.com>
---
 drivers/crypto/caam/intern.h | 3 +++
 drivers/crypto/caam/jr.c     | 6 +++++-
 2 files changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/crypto/caam/intern.h b/drivers/crypto/caam/intern.h
index 9112279..44fe6ee 100644
--- a/drivers/crypto/caam/intern.h
+++ b/drivers/crypto/caam/intern.h
@@ -16,6 +16,9 @@
 /* Currently comes from Kconfig param as a ^2 (driver-required) */
 #define JOBR_DEPTH (1 << CONFIG_CRYPTO_DEV_FSL_CAAM_RINGSIZE)
 
+#define THRESHOLD 15
+#define CRYPTO_ENGINE_MAX_QLEN (2 * (JOBR_DEPTH - THRESHOLD))
+
 /* Kconfig params for interrupt coalescing if selected (else zero) */
 #ifdef CONFIG_CRYPTO_DEV_FSL_CAAM_INTC
 #define JOBR_INTC JRCFG_ICEN
diff --git a/drivers/crypto/caam/jr.c b/drivers/crypto/caam/jr.c
index 6f66996..88540c9 100644
--- a/drivers/crypto/caam/jr.c
+++ b/drivers/crypto/caam/jr.c
@@ -550,7 +550,11 @@ static int caam_jr_probe(struct platform_device *pdev)
 	}
 
 	/* Initialize crypto engine */
-	jrpriv->engine = crypto_engine_alloc_init(jrdev, false);
+	jrpriv->engine = crypto_engine_alloc_init_and_set(jrdev,
+							  true,
+							  NULL,
+							  false,
+							  CRYPTO_ENGINE_MAX_QLEN);
 	if (!jrpriv->engine) {
 		dev_err(jrdev, "Could not init crypto-engine\n");
 		return -ENOMEM;
-- 
2.1.0

