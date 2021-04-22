Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8DCA3C433ED
	for <linux-crypto@archiver.kernel.org>; Thu, 22 Apr 2021 10:17:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5871261450
	for <linux-crypto@archiver.kernel.org>; Thu, 22 Apr 2021 10:17:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235814AbhDVKSC (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 22 Apr 2021 06:18:02 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:47760 "EHLO
        mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234773AbhDVKSB (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 22 Apr 2021 06:18:01 -0400
Received: from eucas1p1.samsung.com (unknown [182.198.249.206])
        by mailout1.w1.samsung.com (KnoxPortal) with ESMTP id 20210422101725euoutp01660a75bcca86d892c124df819e9be153~4JrnN_v831728317283euoutp01-
        for <linux-crypto@vger.kernel.org>; Thu, 22 Apr 2021 10:17:25 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.w1.samsung.com 20210422101725euoutp01660a75bcca86d892c124df819e9be153~4JrnN_v831728317283euoutp01-
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1619086645;
        bh=P1yzkGOkcnvwxAl/j9BN4l/zvJWfv1wrbb1pE4xRYuM=;
        h=From:To:Cc:Subject:Date:References:From;
        b=RcUhcTXN1DSYB74xXQfJEQ4+3eU85kNobs/vbNmi9iZzthxc9sGKKvkt3Z2raapF7
         /GwjJsy3H73qGhmh/3wxg2LEj7S7gQkWQJhFQvN65HmxyVbk6/HL2lfNuLnEhnRyYu
         Dqi5/lnR+GHzuUsHlwBZtdhRlQcPpOXNigI83GEA=
Received: from eusmges2new.samsung.com (unknown [203.254.199.244]) by
        eucas1p2.samsung.com (KnoxPortal) with ESMTP id
        20210422101724eucas1p24cc33a8c94a8771cfe703895822760de~4JrmqwteE2135021350eucas1p2E;
        Thu, 22 Apr 2021 10:17:24 +0000 (GMT)
Received: from eucas1p1.samsung.com ( [182.198.249.206]) by
        eusmges2new.samsung.com (EUCPMTA) with SMTP id CF.0B.09444.43D41806; Thu, 22
        Apr 2021 11:17:24 +0100 (BST)
Received: from eusmtrp2.samsung.com (unknown [182.198.249.139]) by
        eucas1p1.samsung.com (KnoxPortal) with ESMTPA id
        20210422101724eucas1p13e2f002b63fe94ef2aa5268383f3a207~4Jrl9yJHG1714217142eucas1p1O;
        Thu, 22 Apr 2021 10:17:24 +0000 (GMT)
Received: from eusmgms1.samsung.com (unknown [182.198.249.179]) by
        eusmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20210422101724eusmtrp298a6611e5e2ac13712205d842e700acc~4Jrl86WF62586025860eusmtrp2K;
        Thu, 22 Apr 2021 10:17:24 +0000 (GMT)
X-AuditID: cbfec7f4-dd5ff700000024e4-73-60814d34a820
Received: from eusmtip2.samsung.com ( [203.254.199.222]) by
        eusmgms1.samsung.com (EUCPMTA) with SMTP id AE.23.08705.33D41806; Thu, 22
        Apr 2021 11:17:24 +0100 (BST)
Received: from localhost (unknown [106.120.51.46]) by eusmtip2.samsung.com
        (KnoxPortal) with ESMTPA id
        20210422101723eusmtip2d58a0b0baa6994b96081725352605b63~4JrlubzJW2583225832eusmtip27;
        Thu, 22 Apr 2021 10:17:23 +0000 (GMT)
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
Subject: [PATCH] hwrng: exynos - Fix runtime PM imbalance on error
Date:   Thu, 22 Apr 2021 12:17:05 +0200
Message-Id: <20210422101705.15617-1-l.stelmach@samsung.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Organization: Samsung R&D Institute Poland
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrEKsWRmVeSWpSXmKPExsWy7djPc7omvo0JBk//GVtsnLGe1aL7lYzF
        xrc/mCxuHlrBaLHp8TVWi/v3fjJZXN41h81ixvl9TBZrj9xlt1iwrY/RgctjVkMvm8e2A6oe
        m5fUe/RtWcXo0fdyA6PH501yAWxRXDYpqTmZZalF+nYJXBmL9u9jLfjGVTH93Cr2BsZpnF2M
        nBwSAiYS+9rXsncxcnEICaxglPhxdwcbhPOFUeLz40eMEM5nRomuV3OZYFq6Ju1igkgsZ5T4
        NW02VMtzRonf558wg1SxCThK9C89wQqSEBGYxCSxct4PsFnMAvsYJXbemwJWJSzgJPH0dBuQ
        zcHBIqAq0XMnHcTkFbCW2DHVD2KbvET78u1sIDavgKDEyZlPWEBsfgEtiTVN18FsZqCa5q2z
        mUHGSwg84JC4+OwtO0Szi8Sh5l5GCFtY4tXxLVBxGYn/O+czgeySEKiXmDzJDKK3h1Fi25wf
        LBA11hJ3zv1iA6lhFtCUWL9LHyLsKNE0fTIjRCufxI23ghAn8ElM2jadGSLMK9HRJgRRrSKx
        rn8P1EApid5XK6CO8ZC4efgt0wRGxVlIHpuF5JlZCHsXMDKvYhRPLS3OTU8tNspLLdcrTswt
        Ls1L10vOz93ECExGp/8d/7KDcfmrj3qHGJk4GA8xSnAwK4nwri1uSBDiTUmsrEotyo8vKs1J
        LT7EKM3BoiTOm7RlTbyQQHpiSWp2ampBahFMlomDU6qBKf5K99Ir+fFrXdYnZdj1K/4IT1jp
        tj7jpaK1+527NdylH9nEjKzn/FFibN+qXn23kuVt/t4VukrKD65pr3J9G3T6X7H9ifvz93e8
        uaw2m2/q5cap0w4dnBbD/9uc0/B/6KrC9bFbdx52+/A88eH57NsHRG9l3r1Ze6yu5FD/6YcB
        Wj/W5d68de7GnaUVB3bf0WiZuiu4Xb1hqozfsauyJ0NCCi8lexyYXjbvD8/KuBub24wD3+/N
        6F0ts+g1Y0j/heRvNTU2vtbHYyp3B8/4omEZYLDf7fujOQ0XmJYudFM+w8Wte/7Vr/ViV0wr
        467o3Nh6eJuDd6bN/vQnqkcl38eKvI9p+pGkNNPG8OKsuclKLMUZiYZazEXFiQA7EitGtQMA
        AA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprJIsWRmVeSWpSXmKPExsVy+t/xe7omvo0JBjOfM1psnLGe1aL7lYzF
        xrc/mCxuHlrBaLHp8TVWi/v3fjJZXN41h81ixvl9TBZrj9xlt1iwrY/RgctjVkMvm8e2A6oe
        m5fUe/RtWcXo0fdyA6PH501yAWxRejZF+aUlqQoZ+cUltkrRhhZGeoaWFnpGJpZ6hsbmsVZG
        pkr6djYpqTmZZalF+nYJehmL9u9jLfjGVTH93Cr2BsZpnF2MnBwSAiYSXZN2MXUxcnEICSxl
        lNjyeC9rFyMHUEJKYuXcdIgaYYk/17rYQGwhgaeMEss7REBsNgFHif6lJ1hBekUEpjFJnF12
        CsxhFtjHKLH/6GJ2kCphASeJp6fbmEGGsgioSvTcSQcxeQWsJXZM9YOYLy/Rvnw72HxeAUGJ
        kzOfsICUMAuoS6yfJwQS5hfQkljTdJ0FxGYGKm/eOpt5AqPALCQdsxA6ZiGpWsDIvIpRJLW0
        ODc9t9hQrzgxt7g0L10vOT93EyMwjrYd+7l5B+O8Vx/1DjEycTAeYpTgYFYS4V1b3JAgxJuS
        WFmVWpQfX1Sak1p8iNEU6P6JzFKiyfnASM4riTc0MzA1NDGzNDC1NDNWEufdOndNvJBAemJJ
        anZqakFqEUwfEwenVANTfxzfQqmSsqlOD9cdWvDy1RnW3jttHO5O2138s+rE+6WzXHO9ZBf/
        dn+womBKvf+ZD4l2j3eFr1EVUyub+cop/eJUw7vnH7O8mnf16IoP657KpVtPYmB7eclZTX15
        9Wqmr2frWH62HHx6UHmHyAam/2yhTMEmPG94Vq7rZixjlfqeUWB8ftmll6kRez9v7Wwp/r17
        o9TvTZ3WTKcjRWra/WJPNxhri25Xcr5+3M/D9gqj78S1nOd2r8tW0frgIuIXcemH9Mp7Gy+n
        TI3tazRllVLeMqNc5Xm98B2OJL/swpJ3zwLbU6vaZ893nPDex70kIfyo9s2Ip++/iRqdfcK+
        pvyW2LTOuQIpN/ZITM9WYinOSDTUYi4qTgQARlr7viwDAAA=
X-CMS-MailID: 20210422101724eucas1p13e2f002b63fe94ef2aa5268383f3a207
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-RootMTR: 20210422101724eucas1p13e2f002b63fe94ef2aa5268383f3a207
X-EPHeader: CA
CMS-TYPE: 201P
X-CMS-RootMailID: 20210422101724eucas1p13e2f002b63fe94ef2aa5268383f3a207
References: <CGME20210422101724eucas1p13e2f002b63fe94ef2aa5268383f3a207@eucas1p1.samsung.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

pm_runtime_get_sync() increments the runtime PM usage counter even
the call returns an error code. Thus a pairing decrement is needed
on the error handling path to keep the counter balanced.

Change-Id: I028915fbee9e4a050a1313119872d6043696632d
Signed-off-by: Łukasz Stelmach <l.stelmach@samsung.com>
---
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

