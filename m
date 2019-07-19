Return-Path: <SRS0=r9n1=VQ=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B94FFC76188
	for <linux-crypto@archiver.kernel.org>; Fri, 19 Jul 2019 07:09:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 992B82173B
	for <linux-crypto@archiver.kernel.org>; Fri, 19 Jul 2019 07:09:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726909AbfGSHJf (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 19 Jul 2019 03:09:35 -0400
Received: from inva020.nxp.com ([92.121.34.13]:44554 "EHLO inva020.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725616AbfGSHJe (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 19 Jul 2019 03:09:34 -0400
Received: from inva020.nxp.com (localhost [127.0.0.1])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id 48E241A0128;
        Fri, 19 Jul 2019 09:09:32 +0200 (CEST)
Received: from inva024.eu-rdc02.nxp.com (inva024.eu-rdc02.nxp.com [134.27.226.22])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id 3CE121A0130;
        Fri, 19 Jul 2019 09:09:32 +0200 (CEST)
Received: from lorenz.ea.freescale.net (lorenz.ea.freescale.net [10.171.71.5])
        by inva024.eu-rdc02.nxp.com (Postfix) with ESMTP id EF955205D1;
        Fri, 19 Jul 2019 09:09:31 +0200 (CEST)
From:   Iuliana Prodan <iuliana.prodan@nxp.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Gilad Ben-Yossef <gilad@benyossef.com>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-imx <linux-imx@nxp.com>
Subject: [PATCH 1/2] crypto: ccree - check assoclen for rfc4543
Date:   Fri, 19 Jul 2019 10:09:23 +0300
Message-Id: <1563520164-1153-1-git-send-email-iuliana.prodan@nxp.com>
X-Mailer: git-send-email 2.1.0
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Check assoclen to solve the extra tests that expect -EINVAL to be
returned when the associated data size is not valid.

Validated assoclen for RFC4543 which expects an assoclen
of 16 or 20, the same as RFC4106.
Based on seqiv, IPsec ESP and RFC4543/RFC4106 the assoclen is sizeof
IP Header (spi, seq_no, extended seq_no) and IV len. This can be 16 or
20 bytes.

Signed-off-by: Iuliana Prodan <iuliana.prodan@nxp.com>
---
 drivers/crypto/ccree/cc_aead.c | 26 ++++++++++++++++++++------
 1 file changed, 20 insertions(+), 6 deletions(-)

diff --git a/drivers/crypto/ccree/cc_aead.c b/drivers/crypto/ccree/cc_aead.c
index 7aa4cbe..d80d709 100644
--- a/drivers/crypto/ccree/cc_aead.c
+++ b/drivers/crypto/ccree/cc_aead.c
@@ -2328,9 +2328,16 @@ static int cc_rfc4106_gcm_encrypt(struct aead_request *req)
 static int cc_rfc4543_gcm_encrypt(struct aead_request *req)
 {
 	/* Very similar to cc_aead_encrypt() above. */
-
+	struct crypto_aead *tfm = crypto_aead_reqtfm(req);
+	struct cc_aead_ctx *ctx = crypto_aead_ctx(tfm);
+	struct device *dev = drvdata_to_dev(ctx->drvdata);
 	struct aead_req_ctx *areq_ctx = aead_request_ctx(req);
-	int rc;
+	int rc = -EINVAL;
+
+	if (!valid_assoclen(req)) {
+		dev_err(dev, "invalid Assoclen:%u\n", req->assoclen);
+		goto out;
+	}
 
 	memset(areq_ctx, 0, sizeof(*areq_ctx));
 
@@ -2348,7 +2355,7 @@ static int cc_rfc4543_gcm_encrypt(struct aead_request *req)
 	rc = cc_proc_aead(req, DRV_CRYPTO_DIRECTION_ENCRYPT);
 	if (rc != -EINPROGRESS && rc != -EBUSY)
 		req->iv = areq_ctx->backup_iv;
-
+out:
 	return rc;
 }
 
@@ -2389,9 +2396,16 @@ static int cc_rfc4106_gcm_decrypt(struct aead_request *req)
 static int cc_rfc4543_gcm_decrypt(struct aead_request *req)
 {
 	/* Very similar to cc_aead_decrypt() above. */
-
+	struct crypto_aead *tfm = crypto_aead_reqtfm(req);
+	struct cc_aead_ctx *ctx = crypto_aead_ctx(tfm);
+	struct device *dev = drvdata_to_dev(ctx->drvdata);
 	struct aead_req_ctx *areq_ctx = aead_request_ctx(req);
-	int rc;
+	int rc = -EINVAL;
+
+	if (!valid_assoclen(req)) {
+		dev_err(dev, "invalid Assoclen:%u\n", req->assoclen);
+		goto out;
+	}
 
 	memset(areq_ctx, 0, sizeof(*areq_ctx));
 
@@ -2409,7 +2423,7 @@ static int cc_rfc4543_gcm_decrypt(struct aead_request *req)
 	rc = cc_proc_aead(req, DRV_CRYPTO_DIRECTION_DECRYPT);
 	if (rc != -EINPROGRESS && rc != -EBUSY)
 		req->iv = areq_ctx->backup_iv;
-
+out:
 	return rc;
 }
 
-- 
2.1.0

