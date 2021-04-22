Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DD682C433B4
	for <linux-crypto@archiver.kernel.org>; Thu, 22 Apr 2021 10:41:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9EB0D613C3
	for <linux-crypto@archiver.kernel.org>; Thu, 22 Apr 2021 10:41:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235810AbhDVKmY (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 22 Apr 2021 06:42:24 -0400
Received: from mailout2.w1.samsung.com ([210.118.77.12]:13173 "EHLO
        mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235097AbhDVKmY (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 22 Apr 2021 06:42:24 -0400
Received: from eucas1p2.samsung.com (unknown [182.198.249.207])
        by mailout2.w1.samsung.com (KnoxPortal) with ESMTP id 20210422104146euoutp02992591d4b4ea987549b0c3dff83cdbad~4KA4Aecn53148431484euoutp02e
        for <linux-crypto@vger.kernel.org>; Thu, 22 Apr 2021 10:41:46 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.w1.samsung.com 20210422104146euoutp02992591d4b4ea987549b0c3dff83cdbad~4KA4Aecn53148431484euoutp02e
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1619088106;
        bh=jbZRehNx5NXEaCH90SwTt765oxUjcpQrES5K/+JgKcs=;
        h=From:To:Cc:Subject:Date:References:From;
        b=RC0ycAaB9RzBmBCUMVFP5uvtV2JJsgtmGffcCaMjjSvVXUSuuGLobBGpBUHzR3GMI
         CyyKlxOK+4/oVYUrGqp+W3cWdRtFhe401Z7oIERDSVoOZTax8Z/0O4isUO6P43MyK9
         42uygVv/PzHt7IzWi3ldNY34oei9QJRoGLVydUNo=
Received: from eusmges2new.samsung.com (unknown [203.254.199.244]) by
        eucas1p1.samsung.com (KnoxPortal) with ESMTP id
        20210422104146eucas1p105a060bb3b260394d6e9d661b4e513d1~4KA3djRMI1752617526eucas1p17;
        Thu, 22 Apr 2021 10:41:46 +0000 (GMT)
Received: from eucas1p2.samsung.com ( [182.198.249.207]) by
        eusmges2new.samsung.com (EUCPMTA) with SMTP id B1.6F.09444.9E251806; Thu, 22
        Apr 2021 11:41:45 +0100 (BST)
Received: from eusmtrp1.samsung.com (unknown [182.198.249.138]) by
        eucas1p1.samsung.com (KnoxPortal) with ESMTPA id
        20210422104145eucas1p17f46c95b72f3568761a9f7911bf072e1~4KA2tkWOq2196621966eucas1p1k;
        Thu, 22 Apr 2021 10:41:45 +0000 (GMT)
Received: from eusmgms1.samsung.com (unknown [182.198.249.179]) by
        eusmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20210422104145eusmtrp108e515d4b629345d47725dd03e17eb58~4KA2sxvw81696216962eusmtrp1U;
        Thu, 22 Apr 2021 10:41:45 +0000 (GMT)
X-AuditID: cbfec7f4-dbdff700000024e4-ce-608152e9da60
Received: from eusmtip1.samsung.com ( [203.254.199.221]) by
        eusmgms1.samsung.com (EUCPMTA) with SMTP id C0.07.08705.9E251806; Thu, 22
        Apr 2021 11:41:45 +0100 (BST)
Received: from localhost (unknown [106.120.51.46]) by eusmtip1.samsung.com
        (KnoxPortal) with ESMTPA id
        20210422104145eusmtip1fe9f73fb1e323c14c358b06019056b95~4KA2fnx0d3135731357eusmtip1P;
        Thu, 22 Apr 2021 10:41:44 +0000 (GMT)
From:   =?UTF-8?q?=C5=81ukasz=20Stelmach?= <l.stelmach@samsung.com>
To:     Matt Mackall <mpm@selenic.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>,
        linux-samsung-soc@vger.kernel.org, linux-crypto@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc:     =?UTF-8?q?Bart=C5=82omiej=20=C5=BBolnierkiewicz?= 
        <b.zolnierkie@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        =?UTF-8?q?=C5=81ukasz=20Stelmach?= <l.stelmach@samsung.com>
Subject: [PATCH v2] hwrng: exynos - Fix runtime PM imbalance on error
Date:   Thu, 22 Apr 2021 12:41:41 +0200
Message-Id: <20210422104141.17668-1-l.stelmach@samsung.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Organization: Samsung R&D Institute Poland
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrEKsWRmVeSWpSXmKPExsWy7djP87ovgxoTDJ7+sLTYOGM9q0X3KxmL
        jW9/MFncPLSC0WLT42usFvfv/WSyuLxrDpvFjPP7mCzWHrnLbrFgWx+jA5fHrIZeNo9tB1Q9
        Ni+p9+jbsorRo+/lBkaPz5vkAtiiuGxSUnMyy1KL9O0SuDLuXs8paOSuWNDynLmBcQpnFyMn
        h4SAicScJQ/Zuhi5OIQEVjBKnDl0mQnC+cIo8engHVYI5zOjxJb/s1lgWjouTWCHSCxnlHh7
        cQtU/3NGiSs7HrCDVLEJOEr0Lz0B1i4iMIlJYuW8H4wgDrPAPkaJnfemMINUCQu4SrRPvsAE
        YrMIqEqc3nYRrJtXwFriYddsVoh98hLty7ezQcQFJU7OfAJ2B7+AlsSaputgNjNQTfPW2cwQ
        9Xc4JBY984ewXSR2Letig7CFJV4d38IOYctInJ7cA9TLAWTXS0yeZAZym4RAD6PEtjk/oP60
        lrhz7hcbSA2zgKbE+l36EGFHiddLvzNBtPJJ3HgrCHEBn8SkbdOZIcK8Eh1tQhDVKhLr+vdA
        DZSS6H21ghHC9pB4fLWdaQKj4iwkf81C8ssshL0LGJlXMYqnlhbnpqcWG+WllusVJ+YWl+al
        6yXn525iBCaj0/+Of9nBuPzVR71DjEwcjIcYJTiYlUR41xY3JAjxpiRWVqUW5ccXleakFh9i
        lOZgURLnTdqyJl5IID2xJDU7NbUgtQgmy8TBKdXApHSt4l2IkOnTVQ4NPR/a80rvWX50VEmr
        3n7o/fN4zz8eUxIVNulMu37VVjN1nZp0/rQtQocXmR10W7LsQw2/rNEDGe9rGpda33uxvy1t
        Y2vc6GIza47Zo8Sel2ntB/j5/ZgZ90sWit/9P9+5qa0z3mWJi5zLqodmPP2/9iUsypVOqqt3
        fbX8rMW+yGZ3nl1vVMSfuN3Z7LPX2vdO2rnCJVduFB+2FHfczuzxT+XYhoIk99iM6YYtyUeu
        3v9R+3q19Zyg6EueOZW30/6tniGenC+yMZMv2SFD+k5r+Im5hZXaBR8fSUZHi9x9w5fV/KzP
        J0wzqPaRX3Lu6reLd4ZPybEJaHgtnST3w3aS4mMlluKMREMt5qLiRABYsBrVtQMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprNIsWRmVeSWpSXmKPExsVy+t/xu7ovgxoTDK7947DYOGM9q0X3KxmL
        jW9/MFncPLSC0WLT42usFvfv/WSyuLxrDpvFjPP7mCzWHrnLbrFgWx+jA5fHrIZeNo9tB1Q9
        Ni+p9+jbsorRo+/lBkaPz5vkAtii9GyK8ktLUhUy8otLbJWiDS2M9AwtLfSMTCz1DI3NY62M
        TJX07WxSUnMyy1KL9O0S9DLuXs8paOSuWNDynLmBcQpnFyMnh4SAiUTHpQnsXYxcHEICSxkl
        tr4+xtrFyAGUkJJYOTcdokZY4s+1LjaImqeMEhO/3mAGSbAJOEr0Lz3BCpIQEZjGJHF22Skw
        h1lgH6PE/qOL2UGqhAVcJdonX2ACsVkEVCVOb7sIFucVsJZ42DWbFWKFvET78u1sEHFBiZMz
        n7CAXMEsoC6xfp4QSJhfQEtiTdN1FhCbGai8eets5gmMArOQdMxC6JiFpGoBI/MqRpHU0uLc
        9NxiQ73ixNzi0rx0veT83E2MwFjaduzn5h2M81591DvEyMTBeIhRgoNZSYR3bXFDghBvSmJl
        VWpRfnxRaU5q8SFGU6APJjJLiSbnA6M5ryTe0MzA1NDEzNLA1NLMWEmcd+vcNfFCAumJJanZ
        qakFqUUwfUwcnFINTEGX1WxUw5uWBLw72ejAyeX2ddOpu4375As9HzL6/dgVvtZ5qdXiz+08
        k7JE7nQqf8rPsy+evX65bHTY+pSmuPqQ5XMDV/J/ZNj1xlzqpSKnutmNp0dufnJTkQzd8EKg
        1WuBz+nJvIufsLWK7vSS73jHUi/MzeN5zpI1f+nSRNcgnc6MUFMr/+XNepddjnQ6/V3U3zQ9
        U21bT1bQ5mCmjAzbK3/ZVk4PPzEptvnkj4DHH92M7qZM+2lmPedp8/WeV5494RN5Z/U2+nHH
        rG0ulPiSs91cTHi+wUfGV6dPXYrtn57scPUf7+rAxO+enjks39bwntBWiFX+PIlr4tyWJlf+
        pRuK/VS5vUWLf59SYinOSDTUYi4qTgQARow6/i4DAAA=
X-CMS-MailID: 20210422104145eucas1p17f46c95b72f3568761a9f7911bf072e1
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-RootMTR: 20210422104145eucas1p17f46c95b72f3568761a9f7911bf072e1
X-EPHeader: CA
CMS-TYPE: 201P
X-CMS-RootMailID: 20210422104145eucas1p17f46c95b72f3568761a9f7911bf072e1
References: <CGME20210422104145eucas1p17f46c95b72f3568761a9f7911bf072e1@eucas1p1.samsung.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

pm_runtime_get_sync() increments the runtime PM usage counter even
the call returns an error code. Thus a pairing decrement is needed
on the error handling path to keep the counter balanced.

Signed-off-by: Łukasz Stelmach <l.stelmach@samsung.com>
---
Changes in v2:
  - removed Change-Id from the commit message

 drivers/char/hw_random/exynos-trng.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/drivers/char/hw_random/exynos-trng.c b/drivers/char/hw_random/exynos-trng.c
index 8e1fe3f8dd2d..9f455d952e87 100644
--- a/drivers/char/hw_random/exynos-trng.c
+++ b/drivers/char/hw_random/exynos-trng.c
@@ -142,13 +142,13 @@ static int exynos_trng_probe(struct platform_device *pdev)
 	if (IS_ERR(trng->clk)) {
 		ret = PTR_ERR(trng->clk);
 		dev_err(&pdev->dev, "Could not get clock.\n");
-		goto err_clock;
+		goto err_pm_get;
 	}
 
 	ret = clk_prepare_enable(trng->clk);
 	if (ret) {
 		dev_err(&pdev->dev, "Could not enable the clk.\n");
-		goto err_clock;
+		goto err_pm_get;
 	}
 
 	ret = devm_hwrng_register(&pdev->dev, &trng->rng);
@@ -164,10 +164,8 @@ static int exynos_trng_probe(struct platform_device *pdev)
 err_register:
 	clk_disable_unprepare(trng->clk);
 
-err_clock:
-	pm_runtime_put_sync(&pdev->dev);
-
 err_pm_get:
+	pm_runtime_put_noidle(&pdev->dev);
 	pm_runtime_disable(&pdev->dev);
 
 	return ret;
-- 
2.26.2

