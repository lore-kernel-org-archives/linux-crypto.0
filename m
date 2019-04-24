Return-Path: <SRS0=+uK6=S2=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 28F65C10F11
	for <linux-crypto@archiver.kernel.org>; Wed, 24 Apr 2019 13:35:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D996F21773
	for <linux-crypto@archiver.kernel.org>; Wed, 24 Apr 2019 13:35:28 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=st.com header.i=@st.com header.b="JSGflCjC"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726168AbfDXNf1 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 24 Apr 2019 09:35:27 -0400
Received: from mx08-00178001.pphosted.com ([91.207.212.93]:37710 "EHLO
        mx07-00178001.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726165AbfDXNf1 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 24 Apr 2019 09:35:27 -0400
Received: from pps.filterd (m0046661.ppops.net [127.0.0.1])
        by mx08-00178001.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x3ODU5Ht019761;
        Wed, 24 Apr 2019 15:35:05 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=st.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-type; s=STMicroelectronics;
 bh=xOH1uezZYiVgXb4civrf+VPd+S3UtcRRe2DHQxQ7b9Q=;
 b=JSGflCjCEjM3sO+fYFYpGxz8wdlYs7FkwzMsHwVEwG9BY2WE1tzCWfOGmWfgJimVg7ve
 P2svm8ddjhXZuj8iV1v9JJKi8lvmkXqLWmMz75joggT7KS1xZI5ejwkrSXZjroAgcs7D
 yGs9Gvw8wPEAbgRw8lE3lLCEihThDj7bLS5Og0bI/to4v4QjpO/2konv+U8RMePQLtYr
 Ln8yoFj18X9ysl33g/HRoERM2sPowZ1VAtuXBKF7TfrzBFhOAk9auLAPjagU0kdbLnJB
 cAf8jycot7pz/CtlnAn/QAIc6tTP1hctbhL43s0nQc6dgOApO2mTLMXxxtNpVU/ykkyD Fw== 
Received: from beta.dmz-eu.st.com (beta.dmz-eu.st.com [164.129.1.35])
        by mx08-00178001.pphosted.com with ESMTP id 2rytad6ttk-1
        (version=TLSv1 cipher=ECDHE-RSA-AES256-SHA bits=256 verify=NOT);
        Wed, 24 Apr 2019 15:35:05 +0200
Received: from zeta.dmz-eu.st.com (zeta.dmz-eu.st.com [164.129.230.9])
        by beta.dmz-eu.st.com (STMicroelectronics) with ESMTP id 2DD103F;
        Wed, 24 Apr 2019 13:35:04 +0000 (GMT)
Received: from Webmail-eu.st.com (Safex1hubcas21.st.com [10.75.90.44])
        by zeta.dmz-eu.st.com (STMicroelectronics) with ESMTP id E189626A8;
        Wed, 24 Apr 2019 13:35:03 +0000 (GMT)
Received: from SAFEX1HUBCAS22.st.com (10.75.90.93) by SAFEX1HUBCAS21.st.com
 (10.75.90.44) with Microsoft SMTP Server (TLS) id 14.3.361.1; Wed, 24 Apr
 2019 15:35:04 +0200
Received: from localhost (10.201.23.65) by Webmail-ga.st.com (10.75.90.48)
 with Microsoft SMTP Server (TLS) id 14.3.361.1; Wed, 24 Apr 2019 15:35:03
 +0200
From:   Lionel Debieve <lionel.debieve@st.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        "Alexandre Torgue" <alexandre.torgue@st.com>,
        <linux-crypto@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>
CC:     Benjamin Gaignard <benjamin.gaignard@st.com>,
        Fabien Dessenne <fabien.dessenne@st.com>,
        <linux-stm32@st-md-mailman.stormreply.com>
Subject: [PATCH 2/3] crypto: stm32/cryp - remove request mutex protection
Date:   Wed, 24 Apr 2019 15:34:52 +0200
Message-ID: <1556112893-13116-2-git-send-email-lionel.debieve@st.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1556112893-13116-1-git-send-email-lionel.debieve@st.com>
References: <1556112893-13116-1-git-send-email-lionel.debieve@st.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.201.23.65]
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-04-24_09:,,
 signatures=0
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Mutex is badly used between threaded irq and driver.
This mutex must be removed as the framework must ensure
that requests must be serialized to avoid issue. Rework
req to avoid crash during finalize by fixing the NULL
pointer issue.

Signed-off-by: Lionel Debieve <lionel.debieve@st.com>
---
 drivers/crypto/stm32/stm32-cryp.c | 26 +++++++-------------------
 1 file changed, 7 insertions(+), 19 deletions(-)

diff --git a/drivers/crypto/stm32/stm32-cryp.c b/drivers/crypto/stm32/stm32-cryp.c
index cfcb640..eb525669 100644
--- a/drivers/crypto/stm32/stm32-cryp.c
+++ b/drivers/crypto/stm32/stm32-cryp.c
@@ -137,7 +137,6 @@ struct stm32_cryp {
 
 	struct crypto_engine    *engine;
 
-	struct mutex            lock; /* protects req / areq */
 	struct ablkcipher_request *req;
 	struct aead_request     *areq;
 
@@ -645,18 +644,13 @@ static void stm32_cryp_finish_req(struct stm32_cryp *cryp, int err)
 	pm_runtime_mark_last_busy(cryp->dev);
 	pm_runtime_put_autosuspend(cryp->dev);
 
-	if (is_gcm(cryp) || is_ccm(cryp)) {
+	if (is_gcm(cryp) || is_ccm(cryp))
 		crypto_finalize_aead_request(cryp->engine, cryp->areq, err);
-		cryp->areq = NULL;
-	} else {
+	else
 		crypto_finalize_ablkcipher_request(cryp->engine, cryp->req,
 						   err);
-		cryp->req = NULL;
-	}
 
 	memset(cryp->ctx->key, 0, cryp->ctx->keylen);
-
-	mutex_unlock(&cryp->lock);
 }
 
 static int stm32_cryp_cpu_start(struct stm32_cryp *cryp)
@@ -933,8 +927,6 @@ static int stm32_cryp_prepare_req(struct ablkcipher_request *req,
 	if (!cryp)
 		return -ENODEV;
 
-	mutex_lock(&cryp->lock);
-
 	rctx = req ? ablkcipher_request_ctx(req) : aead_request_ctx(areq);
 	rctx->mode &= FLG_MODE_MASK;
 
@@ -946,6 +938,7 @@ static int stm32_cryp_prepare_req(struct ablkcipher_request *req,
 
 	if (req) {
 		cryp->req = req;
+		cryp->areq = NULL;
 		cryp->total_in = req->nbytes;
 		cryp->total_out = cryp->total_in;
 	} else {
@@ -971,6 +964,7 @@ static int stm32_cryp_prepare_req(struct ablkcipher_request *req,
 		 *          <---------- total_out ----------------->
 		 */
 		cryp->areq = areq;
+		cryp->req = NULL;
 		cryp->authsize = crypto_aead_authsize(crypto_aead_reqtfm(areq));
 		cryp->total_in = areq->assoclen + areq->cryptlen;
 		if (is_encrypt(cryp))
@@ -992,19 +986,19 @@ static int stm32_cryp_prepare_req(struct ablkcipher_request *req,
 	if (cryp->in_sg_len < 0) {
 		dev_err(cryp->dev, "Cannot get in_sg_len\n");
 		ret = cryp->in_sg_len;
-		goto out;
+		return ret;
 	}
 
 	cryp->out_sg_len = sg_nents_for_len(cryp->out_sg, cryp->total_out);
 	if (cryp->out_sg_len < 0) {
 		dev_err(cryp->dev, "Cannot get out_sg_len\n");
 		ret = cryp->out_sg_len;
-		goto out;
+		return ret;
 	}
 
 	ret = stm32_cryp_copy_sgs(cryp);
 	if (ret)
-		goto out;
+		return ret;
 
 	scatterwalk_start(&cryp->in_walk, cryp->in_sg);
 	scatterwalk_start(&cryp->out_walk, cryp->out_sg);
@@ -1016,10 +1010,6 @@ static int stm32_cryp_prepare_req(struct ablkcipher_request *req,
 	}
 
 	ret = stm32_cryp_hw_init(cryp);
-out:
-	if (ret)
-		mutex_unlock(&cryp->lock);
-
 	return ret;
 }
 
@@ -1959,8 +1949,6 @@ static int stm32_cryp_probe(struct platform_device *pdev)
 
 	cryp->dev = dev;
 
-	mutex_init(&cryp->lock);
-
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	cryp->regs = devm_ioremap_resource(dev, res);
 	if (IS_ERR(cryp->regs))
-- 
2.7.4

