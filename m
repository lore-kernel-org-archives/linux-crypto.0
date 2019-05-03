Return-Path: <SRS0=LfhG=TD=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A3AD4C43219
	for <linux-crypto@archiver.kernel.org>; Fri,  3 May 2019 12:06:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7F77C206C3
	for <linux-crypto@archiver.kernel.org>; Fri,  3 May 2019 12:06:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727022AbfECMGA (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 3 May 2019 08:06:00 -0400
Received: from inva021.nxp.com ([92.121.34.21]:57670 "EHLO inva021.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726047AbfECMGA (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 3 May 2019 08:06:00 -0400
Received: from inva021.nxp.com (localhost [127.0.0.1])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id 9B1A82001BF;
        Fri,  3 May 2019 14:05:58 +0200 (CEST)
Received: from inva024.eu-rdc02.nxp.com (inva024.eu-rdc02.nxp.com [134.27.226.22])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id 8ED7820011D;
        Fri,  3 May 2019 14:05:58 +0200 (CEST)
Received: from fsr-ub1864-014.ea.freescale.net (fsr-ub1864-014.ea.freescale.net [10.171.95.219])
        by inva024.eu-rdc02.nxp.com (Postfix) with ESMTP id 4525E205F4;
        Fri,  3 May 2019 14:05:58 +0200 (CEST)
From:   =?UTF-8?q?Horia=20Geant=C4=83?= <horia.geanta@nxp.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Aymen Sghaier <aymen.sghaier@nxp.com>,
        linux-crypto@vger.kernel.org, NXP Linux Team <linux-imx@nxp.com>,
        Iuliana Prodan <iuliana.prodan@nxp.com>
Subject: [PATCH] crypto: caam - fix DKP detection logic
Date:   Fri,  3 May 2019 15:05:48 +0300
Message-Id: <20190503120548.5576-1-horia.geanta@nxp.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

The detection whether DKP (Derived Key Protocol) is used relies on
the setkey callback.
Since "aead_setkey" was replaced in some cases with "des3_aead_setkey"
(for 3DES weak key checking), the logic has to be updated - otherwise
the DMA mapping direction is incorrect (leading to faults in case caam
is behind an IOMMU).

Fixes: 1b52c40919e6 ("crypto: caam - Forbid 2-key 3DES in FIPS mode")
Signed-off-by: Horia Geantă <horia.geanta@nxp.com>
---

This issue was noticed when testing with previously submitted IOMMU support:
https://patchwork.kernel.org/project/linux-crypto/list/?series=110277&state=*

 drivers/crypto/caam/caamalg.c     | 3 ++-
 drivers/crypto/caam/caamalg_qi.c  | 3 ++-
 drivers/crypto/caam/caamalg_qi2.c | 3 ++-
 3 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/crypto/caam/caamalg.c b/drivers/crypto/caam/caamalg.c
index 0030cee3e75d..015fca99d867 100644
--- a/drivers/crypto/caam/caamalg.c
+++ b/drivers/crypto/caam/caamalg.c
@@ -3418,7 +3418,8 @@ static int caam_aead_init(struct crypto_aead *tfm)
 	struct caam_ctx *ctx = crypto_aead_ctx(tfm);
 
 	return caam_init_common(ctx, &caam_alg->caam,
-				alg->setkey == aead_setkey);
+				alg->setkey == aead_setkey ||
+				alg->setkey == des3_aead_setkey);
 }
 
 static void caam_exit_common(struct caam_ctx *ctx)
diff --git a/drivers/crypto/caam/caamalg_qi.c b/drivers/crypto/caam/caamalg_qi.c
index 70af211d2d01..4d98f5664d3e 100644
--- a/drivers/crypto/caam/caamalg_qi.c
+++ b/drivers/crypto/caam/caamalg_qi.c
@@ -2434,7 +2434,8 @@ static int caam_aead_init(struct crypto_aead *tfm)
 	struct caam_ctx *ctx = crypto_aead_ctx(tfm);
 
 	return caam_init_common(ctx, &caam_alg->caam,
-				alg->setkey == aead_setkey);
+				alg->setkey == aead_setkey ||
+				alg->setkey == des3_aead_setkey);
 }
 
 static void caam_exit_common(struct caam_ctx *ctx)
diff --git a/drivers/crypto/caam/caamalg_qi2.c b/drivers/crypto/caam/caamalg_qi2.c
index 33a4df6b81de..5977e615ff10 100644
--- a/drivers/crypto/caam/caamalg_qi2.c
+++ b/drivers/crypto/caam/caamalg_qi2.c
@@ -1480,7 +1480,8 @@ static int caam_cra_init_aead(struct crypto_aead *tfm)
 
 	crypto_aead_set_reqsize(tfm, sizeof(struct caam_request));
 	return caam_cra_init(crypto_aead_ctx(tfm), &caam_alg->caam,
-			     alg->setkey == aead_setkey);
+			     alg->setkey == aead_setkey ||
+			     alg->setkey == des3_aead_setkey);
 }
 
 static void caam_exit_common(struct caam_ctx *ctx)
-- 
2.17.1

