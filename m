Return-Path: <SRS0=4Nwj=Q2=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 872D3C4360F
	for <linux-crypto@archiver.kernel.org>; Tue, 19 Feb 2019 16:02:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4B0362147A
	for <linux-crypto@archiver.kernel.org>; Tue, 19 Feb 2019 16:02:56 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="DxVWiWxu"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725911AbfBSQCy (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 19 Feb 2019 11:02:54 -0500
Received: from mailout2.w1.samsung.com ([210.118.77.12]:46536 "EHLO
        mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726244AbfBSQCx (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 19 Feb 2019 11:02:53 -0500
Received: from eucas1p1.samsung.com (unknown [182.198.249.206])
        by mailout2.w1.samsung.com (KnoxPortal) with ESMTP id 20190219160251euoutp02765c249f3f28b994d23d903006ac9f0e~Ez11Of3nN1661616616euoutp02G
        for <linux-crypto@vger.kernel.org>; Tue, 19 Feb 2019 16:02:51 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.w1.samsung.com 20190219160251euoutp02765c249f3f28b994d23d903006ac9f0e~Ez11Of3nN1661616616euoutp02G
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1550592171;
        bh=p1vEeCGy2J+7TRnYeck4kNEAStoREQ02WTuF+VjnmF4=;
        h=From:To:Cc:Subject:Date:References:From;
        b=DxVWiWxupNPkfWAUDsadcydMskV1G8VfiO29bkF0jkpCX1+y3ZSAlS0HGZfo2j0sx
         GMQ/+EaUFrFjPwqbiLoaXguW9Scdti/gJtfxElg+ZFucvz/0Tg1y8GxZClB29xoie7
         auSp1IenTBqqv9ZuXA7lPzFtRhJqPyUxd+VuAcDE=
Received: from eusmges2new.samsung.com (unknown [203.254.199.244]) by
        eucas1p1.samsung.com (KnoxPortal) with ESMTP id
        20190219160250eucas1p17a41f28a4a7554e8549ac03b7da5516a~Ez10XGM1X0525105251eucas1p1d;
        Tue, 19 Feb 2019 16:02:50 +0000 (GMT)
Received: from eucas1p2.samsung.com ( [182.198.249.207]) by
        eusmges2new.samsung.com (EUCPMTA) with SMTP id 74.2C.04294.AA82C6C5; Tue, 19
        Feb 2019 16:02:50 +0000 (GMT)
Received: from eusmtrp2.samsung.com (unknown [182.198.249.139]) by
        eucas1p1.samsung.com (KnoxPortal) with ESMTPA id
        20190219160249eucas1p17f521e74a9acab6a330e72a3c682adce~Ez1zlWm3m2998429984eucas1p1P;
        Tue, 19 Feb 2019 16:02:49 +0000 (GMT)
Received: from eusmgms1.samsung.com (unknown [182.198.249.179]) by
        eusmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20190219160249eusmtrp2fb73802a50825b1b1f47b15de915cf74~Ez1zWjXrc1080810808eusmtrp29;
        Tue, 19 Feb 2019 16:02:49 +0000 (GMT)
X-AuditID: cbfec7f4-835ff700000010c6-25-5c6c28aab1b2
Received: from eusmtip2.samsung.com ( [203.254.199.222]) by
        eusmgms1.samsung.com (EUCPMTA) with SMTP id 91.ED.04284.9A82C6C5; Tue, 19
        Feb 2019 16:02:49 +0000 (GMT)
Received: from AMDC3218.DIGITAL.local (unknown [106.120.51.18]) by
        eusmtip2.samsung.com (KnoxPortal) with ESMTPA id
        20190219160248eusmtip27ae9ddcdcad5dc75c3a3d5480a4f2555~Ez1y2ucVQ1447414474eusmtip2i;
        Tue, 19 Feb 2019 16:02:48 +0000 (GMT)
From:   Kamil Konieczny <k.konieczny@partner.samsung.com>
To:     k.konieczny@partner.samsung.com
Cc:     Krzysztof Kozlowski <krzk@kernel.org>,
        Vladimir Zapolskiy <vz@mleia.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Biggers <ebiggers@kernel.org>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        linux-crypto@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2] crypto: s5p: update iv after AES-CBC op end
Date:   Tue, 19 Feb 2019 17:02:32 +0100
Message-Id: <20190219160232.22084-1-k.konieczny@partner.samsung.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrFKsWRmVeSWpSXmKPExsWy7djP87qrNHJiDPau4LbYOGM9q8Wc8y0s
        Fmv3/GG26H4lY9G37z+jxfnzG9gt7t/7yWRxedccNosZ5/cxWaw9cpfd4v+vZmYHbo8tK28y
        eWw7oOqxaVUnm8e/hVNYPA6+28Pk0bdlFaPH501yAexRXDYpqTmZZalF+nYJXBkLF35mLJjH
        U/H1xG/mBsZFXF2MnBwSAiYS77q/MXcxcnEICaxglGhpPcEO4XxhlHh/agkjhPOZUeLRxU0s
        XYwcYC2L/0IVLWeUmL1uMxtcR0PnXEaQuWwC5hKPtp9hArFFBJQlJt+bDraDWaCfWaLjzySw
        ImEBe4nFbR2sIDaLgKrE6kdTwOK8Ai4Szw8tZYI4UF7ifO86doi4oMTJmU9YQGxmoHjz1tlg
        QyUEFrFLHFt9mxWiwUXi6MlrLBC2sMSr41vYIWwZif8750MNLZfYvfUZO0RzC6PE3MmLoBLW
        EoePX2QF+ZNZQFNi/S59iJcdJSb0eEOYfBI33gpCnMAnMWkbyF8gYV6JjjYhiBm6EvP+n4E6
        Rlqi6/86KNtDYsuCxcwgtpBArMSGlQtZJzAqzELy2Cwkj81COGEBI/MqRvHU0uLc9NRio7zU
        cr3ixNzi0rx0veT83E2MwBR1+t/xLzsYd/1JOsQowMGoxMOrwZATI8SaWFZcmXuIUYKDWUmE
        15ALKMSbklhZlVqUH19UmpNafIhRmoNFSZy3muFBtJBAemJJanZqakFqEUyWiYNTqoEx85Si
        8kV1pt1u9ya2F7xMjKudnWfzbFvzvg0H+zrW/dmxk7FX8kFYpvS/+vUWDrWnveweVj79O7Nu
        grpb7O3nE+LLyzJn3gh33lafuOpVZYvQDN6DrOfEv/stqv5gMi+HZcUHj0RPWaYPPZUzyk6v
        3uZ8zJWjsLFYMthxee8rl3m9156wLjuqxFKckWioxVxUnAgAOK7dmU0DAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprIIsWRmVeSWpSXmKPExsVy+t/xe7orNXJiDA6tFrHYOGM9q8Wc8y0s
        Fmv3/GG26H4lY9G37z+jxfnzG9gt7t/7yWRxedccNosZ5/cxWaw9cpfd4v+vZmYHbo8tK28y
        eWw7oOqxaVUnm8e/hVNYPA6+28Pk0bdlFaPH501yAexRejZF+aUlqQoZ+cUltkrRhhZGeoaW
        FnpGJpZ6hsbmsVZGpkr6djYpqTmZZalF+nYJehkLF35mLJjHU/H1xG/mBsZFXF2MHBwSAiYS
        i/+ydzFycQgJLGWUuNE2k6WLkRMoLi3ReHo1E4QtLPHnWhcbRNEnRompxxaxgiTYBMwlHm0/
        A1YkIqAsMfnedGaQImaB6cwSXxYtZgRJCAvYSyxu6wBrYBFQlVj9aApYnFfAReL5oaVQG+Ql
        zveuY4eIC0qcnPkE7ApmoHjz1tnMExj5ZiFJzUKSWsDItIpRJLW0ODc9t9hQrzgxt7g0L10v
        OT93EyMwOrYd+7l5B+OljcGHGAU4GJV4eDUYcmKEWBPLiitzDzFKcDArifAacgGFeFMSK6tS
        i/Lji0pzUosPMZoCHTuRWUo0OR8YuXkl8YamhuYWlobmxubGZhZK4rznDSqjhATSE0tSs1NT
        C1KLYPqYODilGhjze4+xyy97eSp/ltyjSTNTDyhuWT0noI+poPHIyzOby6Wmz2G/sl5qQZE6
        R9WPtRWfl8+RkMm6VsF8p9AzyerCSpfspHM/AqfNu7BN1mV6Qpjf25zU41LbDY9NXvlmpRpX
        /mSZgIgXt/TstEqzueYvazBxP6zAMqFcomhVV+DG2xItCQHNYWxKLMUZiYZazEXFiQAZaD3B
        pAIAAA==
X-CMS-MailID: 20190219160249eucas1p17f521e74a9acab6a330e72a3c682adce
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-RootMTR: 20190219160249eucas1p17f521e74a9acab6a330e72a3c682adce
X-EPHeader: CA
CMS-TYPE: 201P
X-CMS-RootMailID: 20190219160249eucas1p17f521e74a9acab6a330e72a3c682adce
References: <CGME20190219160249eucas1p17f521e74a9acab6a330e72a3c682adce@eucas1p1.samsung.com>
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Fix bug "s5p-sss crypto driver doesn't set next AES-CBC IV". While at this,
fix also AES-CTR mode. Tested on Odroid U3 with Eric Biggers branch
"iv-out-testing".

Signed-off-by: Kamil Konieczny <k.konieczny@partner.samsung.com>
Reported-by: Eric Biggers <ebiggers@kernel.org>
---
Changes since v1:
 - reworded Subject and commit message
 - changed code according to comments by Krzysztof Kozlowski
 - added Reported-by line
---
 drivers/crypto/s5p-sss.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/crypto/s5p-sss.c b/drivers/crypto/s5p-sss.c
index 0064be0e3941..30b4f1015d8f 100644
--- a/drivers/crypto/s5p-sss.c
+++ b/drivers/crypto/s5p-sss.c
@@ -463,6 +463,9 @@ static void s5p_sg_copy_buf(void *buf, struct scatterlist *sg,
 
 static void s5p_sg_done(struct s5p_aes_dev *dev)
 {
+	struct ablkcipher_request *req = dev->req;
+	struct s5p_aes_reqctx *reqctx = ablkcipher_request_ctx(req);
+
 	if (dev->sg_dst_cpy) {
 		dev_dbg(dev->dev,
 			"Copying %d bytes of output data back to original place\n",
@@ -472,6 +475,11 @@ static void s5p_sg_done(struct s5p_aes_dev *dev)
 	}
 	s5p_free_sg_cpy(dev, &dev->sg_src_cpy);
 	s5p_free_sg_cpy(dev, &dev->sg_dst_cpy);
+	if (reqctx->mode & FLAGS_AES_CBC)
+		memcpy_fromio(req->info, dev->aes_ioaddr + SSS_REG_AES_IV_DATA(0), AES_BLOCK_SIZE);
+
+	else if (reqctx->mode & FLAGS_AES_CTR)
+		memcpy_fromio(req->info, dev->aes_ioaddr + SSS_REG_AES_CNT_DATA(0), AES_BLOCK_SIZE);
 }
 
 /* Calls the completion. Cannot be called with dev->lock hold. */
-- 
2.20.1

