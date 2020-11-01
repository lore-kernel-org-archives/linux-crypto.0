Return-Path: <SRS0=Q/Sy=EH=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2A5A7C2D0A3
	for <linux-crypto@archiver.kernel.org>; Sun,  1 Nov 2020 20:06:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E637E20756
	for <linux-crypto@archiver.kernel.org>; Sun,  1 Nov 2020 20:06:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727056AbgKAUGS (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 1 Nov 2020 15:06:18 -0500
Received: from inva021.nxp.com ([92.121.34.21]:41210 "EHLO inva021.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726848AbgKAUGR (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 1 Nov 2020 15:06:17 -0500
Received: from inva021.nxp.com (localhost [127.0.0.1])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id 20CDA200E27;
        Sun,  1 Nov 2020 21:06:16 +0100 (CET)
Received: from inva024.eu-rdc02.nxp.com (inva024.eu-rdc02.nxp.com [134.27.226.22])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id 1488A2000D9;
        Sun,  1 Nov 2020 21:06:16 +0100 (CET)
Received: from fsr-ub1864-014.ea.freescale.net (fsr-ub1864-014.ea.freescale.net [10.171.95.219])
        by inva024.eu-rdc02.nxp.com (Postfix) with ESMTP id BA58720306;
        Sun,  1 Nov 2020 21:06:15 +0100 (CET)
From:   =?UTF-8?q?Horia=20Geant=C4=83?= <horia.geanta@nxp.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Aymen Sghaier <aymen.sghaier@nxp.com>
Cc:     Andrei Botila <andrei.botila@nxp.com>,
        linux-crypto@vger.kernel.org, NXP Linux Team <linux-imx@nxp.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH] crypto: caam - fix printing on xts fallback allocation error path
Date:   Sun,  1 Nov 2020 22:05:53 +0200
Message-Id: <20201101200553.25248-1-horia.geanta@nxp.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: ClamAV using ClamSMTP
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

At the time xts fallback tfm allocation fails the device struct
hasn't been enabled yet in the caam xts tfm's private context.

Fix this by using the device struct from xts algorithm's private context
or, when not available, by replacing dev_err with pr_err.

Fixes: 9d9b14dbe077 ("crypto: caam/jr - add fallback for XTS with more than 8B IV")
Fixes: 83e8aa912138 ("crypto: caam/qi - add fallback for XTS with more than 8B IV")
Fixes: 36e2d7cfdcf1 ("crypto: caam/qi2 - add fallback for XTS with more than 8B IV")
Signed-off-by: Horia Geantă <horia.geanta@nxp.com>
---
 drivers/crypto/caam/caamalg.c     | 4 ++--
 drivers/crypto/caam/caamalg_qi.c  | 4 ++--
 drivers/crypto/caam/caamalg_qi2.c | 3 ++-
 3 files changed, 6 insertions(+), 5 deletions(-)

diff --git a/drivers/crypto/caam/caamalg.c b/drivers/crypto/caam/caamalg.c
index cf5bd7666dfc..8697ae53b063 100644
--- a/drivers/crypto/caam/caamalg.c
+++ b/drivers/crypto/caam/caamalg.c
@@ -3404,8 +3404,8 @@ static int caam_cra_init(struct crypto_skcipher *tfm)
 		fallback = crypto_alloc_skcipher(tfm_name, 0,
 						 CRYPTO_ALG_NEED_FALLBACK);
 		if (IS_ERR(fallback)) {
-			dev_err(ctx->jrdev, "Failed to allocate %s fallback: %ld\n",
-				tfm_name, PTR_ERR(fallback));
+			pr_err("Failed to allocate %s fallback: %ld\n",
+			       tfm_name, PTR_ERR(fallback));
 			return PTR_ERR(fallback);
 		}
 
diff --git a/drivers/crypto/caam/caamalg_qi.c b/drivers/crypto/caam/caamalg_qi.c
index 66f60d78bdc8..a24ae966df4a 100644
--- a/drivers/crypto/caam/caamalg_qi.c
+++ b/drivers/crypto/caam/caamalg_qi.c
@@ -2502,8 +2502,8 @@ static int caam_cra_init(struct crypto_skcipher *tfm)
 		fallback = crypto_alloc_skcipher(tfm_name, 0,
 						 CRYPTO_ALG_NEED_FALLBACK);
 		if (IS_ERR(fallback)) {
-			dev_err(ctx->jrdev, "Failed to allocate %s fallback: %ld\n",
-				tfm_name, PTR_ERR(fallback));
+			pr_err("Failed to allocate %s fallback: %ld\n",
+			       tfm_name, PTR_ERR(fallback));
 			return PTR_ERR(fallback);
 		}
 
diff --git a/drivers/crypto/caam/caamalg_qi2.c b/drivers/crypto/caam/caamalg_qi2.c
index 98c1ff1744bb..a780e627838a 100644
--- a/drivers/crypto/caam/caamalg_qi2.c
+++ b/drivers/crypto/caam/caamalg_qi2.c
@@ -1611,7 +1611,8 @@ static int caam_cra_init_skcipher(struct crypto_skcipher *tfm)
 		fallback = crypto_alloc_skcipher(tfm_name, 0,
 						 CRYPTO_ALG_NEED_FALLBACK);
 		if (IS_ERR(fallback)) {
-			dev_err(ctx->dev, "Failed to allocate %s fallback: %ld\n",
+			dev_err(caam_alg->caam.dev,
+				"Failed to allocate %s fallback: %ld\n",
 				tfm_name, PTR_ERR(fallback));
 			return PTR_ERR(fallback);
 		}
-- 
2.17.1

