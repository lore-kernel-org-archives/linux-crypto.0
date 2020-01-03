Return-Path: <SRS0=TjYB=2Y=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 98BADC3276C
	for <linux-crypto@archiver.kernel.org>; Fri,  3 Jan 2020 01:04:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7339C22314
	for <linux-crypto@archiver.kernel.org>; Fri,  3 Jan 2020 01:04:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726299AbgACBDQ (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 2 Jan 2020 20:03:16 -0500
Received: from inva021.nxp.com ([92.121.34.21]:48388 "EHLO inva021.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726121AbgACBDP (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 2 Jan 2020 20:03:15 -0500
Received: from inva021.nxp.com (localhost [127.0.0.1])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id 0BE48200930;
        Fri,  3 Jan 2020 02:03:14 +0100 (CET)
Received: from inva024.eu-rdc02.nxp.com (inva024.eu-rdc02.nxp.com [134.27.226.22])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id E9273200812;
        Fri,  3 Jan 2020 02:03:13 +0100 (CET)
Received: from lorenz.ea.freescale.net (lorenz.ea.freescale.net [10.171.71.5])
        by inva024.eu-rdc02.nxp.com (Postfix) with ESMTP id 9033C20567;
        Fri,  3 Jan 2020 02:03:13 +0100 (CET)
From:   Iuliana Prodan <iuliana.prodan@nxp.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        Horia Geanta <horia.geanta@nxp.com>,
        Aymen Sghaier <aymen.sghaier@nxp.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-imx <linux-imx@nxp.com>,
        Iuliana Prodan <iuliana.prodan@nxp.com>
Subject: [PATCH v2 04/10] crypto: caam - refactor RSA private key _done callbacks
Date:   Fri,  3 Jan 2020 03:02:47 +0200
Message-Id: <1578013373-1956-5-git-send-email-iuliana.prodan@nxp.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1578013373-1956-1-git-send-email-iuliana.prodan@nxp.com>
References: <1578013373-1956-1-git-send-email-iuliana.prodan@nxp.com>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Create a common rsa_priv_f_done function, which based
on private key form calls the specific unmap function.

Signed-off-by: Iuliana Prodan <iuliana.prodan@nxp.com>
Reviewed-by: Horia Geanta <horia.geanta@nxp.com>
---
 drivers/crypto/caam/caampkc.c | 61 +++++++++++++------------------------------
 1 file changed, 18 insertions(+), 43 deletions(-)

diff --git a/drivers/crypto/caam/caampkc.c b/drivers/crypto/caam/caampkc.c
index 6619c51..ebf1677 100644
--- a/drivers/crypto/caam/caampkc.c
+++ b/drivers/crypto/caam/caampkc.c
@@ -132,29 +132,13 @@ static void rsa_pub_done(struct device *dev, u32 *desc, u32 err, void *context)
 	akcipher_request_complete(req, ecode);
 }
 
-static void rsa_priv_f1_done(struct device *dev, u32 *desc, u32 err,
-			     void *context)
-{
-	struct akcipher_request *req = context;
-	struct rsa_edesc *edesc;
-	int ecode = 0;
-
-	if (err)
-		ecode = caam_jr_strstatus(dev, err);
-
-	edesc = container_of(desc, struct rsa_edesc, hw_desc[0]);
-
-	rsa_priv_f1_unmap(dev, edesc, req);
-	rsa_io_unmap(dev, edesc, req);
-	kfree(edesc);
-
-	akcipher_request_complete(req, ecode);
-}
-
-static void rsa_priv_f2_done(struct device *dev, u32 *desc, u32 err,
-			     void *context)
+static void rsa_priv_f_done(struct device *dev, u32 *desc, u32 err,
+			    void *context)
 {
 	struct akcipher_request *req = context;
+	struct crypto_akcipher *tfm = crypto_akcipher_reqtfm(req);
+	struct caam_rsa_ctx *ctx = akcipher_tfm_ctx(tfm);
+	struct caam_rsa_key *key = &ctx->key;
 	struct rsa_edesc *edesc;
 	int ecode = 0;
 
@@ -163,26 +147,17 @@ static void rsa_priv_f2_done(struct device *dev, u32 *desc, u32 err,
 
 	edesc = container_of(desc, struct rsa_edesc, hw_desc[0]);
 
-	rsa_priv_f2_unmap(dev, edesc, req);
-	rsa_io_unmap(dev, edesc, req);
-	kfree(edesc);
-
-	akcipher_request_complete(req, ecode);
-}
-
-static void rsa_priv_f3_done(struct device *dev, u32 *desc, u32 err,
-			     void *context)
-{
-	struct akcipher_request *req = context;
-	struct rsa_edesc *edesc;
-	int ecode = 0;
-
-	if (err)
-		ecode = caam_jr_strstatus(dev, err);
-
-	edesc = container_of(desc, struct rsa_edesc, hw_desc[0]);
+	switch (key->priv_form) {
+	case FORM1:
+		rsa_priv_f1_unmap(dev, edesc, req);
+		break;
+	case FORM2:
+		rsa_priv_f2_unmap(dev, edesc, req);
+		break;
+	case FORM3:
+		rsa_priv_f3_unmap(dev, edesc, req);
+	}
 
-	rsa_priv_f3_unmap(dev, edesc, req);
 	rsa_io_unmap(dev, edesc, req);
 	kfree(edesc);
 
@@ -691,7 +666,7 @@ static int caam_rsa_dec_priv_f1(struct akcipher_request *req)
 	/* Initialize Job Descriptor */
 	init_rsa_priv_f1_desc(edesc->hw_desc, &edesc->pdb.priv_f1);
 
-	ret = caam_jr_enqueue(jrdev, edesc->hw_desc, rsa_priv_f1_done, req);
+	ret = caam_jr_enqueue(jrdev, edesc->hw_desc, rsa_priv_f_done, req);
 	if (!ret)
 		return -EINPROGRESS;
 
@@ -724,7 +699,7 @@ static int caam_rsa_dec_priv_f2(struct akcipher_request *req)
 	/* Initialize Job Descriptor */
 	init_rsa_priv_f2_desc(edesc->hw_desc, &edesc->pdb.priv_f2);
 
-	ret = caam_jr_enqueue(jrdev, edesc->hw_desc, rsa_priv_f2_done, req);
+	ret = caam_jr_enqueue(jrdev, edesc->hw_desc, rsa_priv_f_done, req);
 	if (!ret)
 		return -EINPROGRESS;
 
@@ -757,7 +732,7 @@ static int caam_rsa_dec_priv_f3(struct akcipher_request *req)
 	/* Initialize Job Descriptor */
 	init_rsa_priv_f3_desc(edesc->hw_desc, &edesc->pdb.priv_f3);
 
-	ret = caam_jr_enqueue(jrdev, edesc->hw_desc, rsa_priv_f3_done, req);
+	ret = caam_jr_enqueue(jrdev, edesc->hw_desc, rsa_priv_f_done, req);
 	if (!ret)
 		return -EINPROGRESS;
 
-- 
2.1.0

