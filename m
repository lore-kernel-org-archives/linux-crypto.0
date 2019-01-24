Return-Path: <SRS0=smUI=QA=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 34E74C282C3
	for <linux-crypto@archiver.kernel.org>; Thu, 24 Jan 2019 15:46:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F0039218AF
	for <linux-crypto@archiver.kernel.org>; Thu, 24 Jan 2019 15:46:00 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="SWJoHpXm"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728456AbfAXPpy (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 24 Jan 2019 10:45:54 -0500
Received: from mailout1.w1.samsung.com ([210.118.77.11]:55981 "EHLO
        mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728061AbfAXPpn (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 24 Jan 2019 10:45:43 -0500
Received: from eucas1p1.samsung.com (unknown [182.198.249.206])
        by mailout1.w1.samsung.com (KnoxPortal) with ESMTP id 20190124154541euoutp0113c8e28b44b2261101be6d24d2687313~801bEQHRo2685826858euoutp019
        for <linux-crypto@vger.kernel.org>; Thu, 24 Jan 2019 15:45:41 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.w1.samsung.com 20190124154541euoutp0113c8e28b44b2261101be6d24d2687313~801bEQHRo2685826858euoutp019
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1548344741;
        bh=bekSzHOo2GCKZ35Z2Xc2Fk5V/yJ6eHX4HVfuY/nsook=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SWJoHpXmmFBkZ2yDKSX2D16QSsvJoD6O6ry3OSfWdPiGhoYVyAe7A5XVOrhKc5JKr
         36jp7nFhuqe4dien0hK0+6imSeNfGto2CgIseK+ZZPYEJ/PMORQeXsfoMmy7QNMwVD
         r8/nSb++bemDszZnch+6ZlfuDTVQfdwRWQ28oCeE=
Received: from eusmges3new.samsung.com (unknown [203.254.199.245]) by
        eucas1p2.samsung.com (KnoxPortal) with ESMTP id
        20190124154541eucas1p2579b51846dc71a82d036633186e2640b~801apqYDm0830008300eucas1p2T;
        Thu, 24 Jan 2019 15:45:41 +0000 (GMT)
Received: from eucas1p1.samsung.com ( [182.198.249.206]) by
        eusmges3new.samsung.com (EUCPMTA) with SMTP id 2B.31.04806.4ADD94C5; Thu, 24
        Jan 2019 15:45:40 +0000 (GMT)
Received: from eusmtrp2.samsung.com (unknown [182.198.249.139]) by
        eucas1p2.samsung.com (KnoxPortal) with ESMTPA id
        20190124154540eucas1p219536f93a4b1e9133d2859e3c38c1f66~801Z4_Kb30349403494eucas1p2P;
        Thu, 24 Jan 2019 15:45:40 +0000 (GMT)
Received: from eusmgms1.samsung.com (unknown [182.198.249.179]) by
        eusmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20190124154540eusmtrp2068ff0f0e1a58c780e5a2a2970b4df57~801ZqI8wI1826018260eusmtrp2v;
        Thu, 24 Jan 2019 15:45:40 +0000 (GMT)
X-AuditID: cbfec7f5-34dff700000012c6-ec-5c49dda4a44e
Received: from eusmtip2.samsung.com ( [203.254.199.222]) by
        eusmgms1.samsung.com (EUCPMTA) with SMTP id F3.59.04284.3ADD94C5; Thu, 24
        Jan 2019 15:45:39 +0000 (GMT)
Received: from AMDC3218.DIGITAL.local (unknown [106.120.51.18]) by
        eusmtip2.samsung.com (KnoxPortal) with ESMTPA id
        20190124154539eusmtip2faf91dda7e2f8afc22b8932f35612a26~801ZFcStM2591025910eusmtip2p;
        Thu, 24 Jan 2019 15:45:39 +0000 (GMT)
From:   Kamil Konieczny <k.konieczny@partner.samsung.com>
To:     k.konieczny@partner.samsung.com
Cc:     Krzysztof Kozlowski <krzk@kernel.org>,
        Vladimir Zapolskiy <vz@mleia.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>
Subject: [PATCH v3 3/3] crypto: s5p: add AES support for Exynos5433
Date:   Thu, 24 Jan 2019 16:45:21 +0100
Message-Id: <20190124154521.13589-4-k.konieczny@partner.samsung.com>
X-Mailer: git-send-email 2.20.0
In-Reply-To: <20190124154521.13589-1-k.konieczny@partner.samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrGKsWRmVeSWpSXmKPExsWy7djPc7pL7nrGGKzsMbTYOGM9q8Wc8y0s
        Ft2vZCz69v1ntDh/fgO7xf17P5ksLu+aw2Yx4/w+Jou1R+6yW/z/1czswOWxZeVNJo9tB1Q9
        Nq3qZPP4t3AKi8fBd3uYPPq2rGL0+LxJLoA9issmJTUnsyy1SN8ugSvj67ZWloJXchX7d91m
        a2C8IdHFyMkhIWAisXPLacYuRi4OIYEVjBLn93VDOV8YJZoafrFCOJ8ZJRoPzGDpYuQAa9l9
        nwkivpxR4suTeexwHR0/v7OBzGUTMJd4tP0ME4gtIqAsMfnedGaQImaB10wSG26/AksICzhL
        nDs2jwXEZhFQleg7vYIdxOYVcJHY3jGTDeJAeYlpq7vA6jkFXCX2TmhmgagRlDg58wmYzQxU
        07x1NtgCCYFN7BIdTa/YIZpdJPrevmCGsIUlXh3fAhWXkfi/cz4ThF0usXvrM3aI5hZGibmT
        F0ElrCUOH7/ICvIzs4CmxPpd+hBhR4kj875Cg4JP4sZbQYgb+CQmbQN5EiTMK9HRJgRRrSsx
        7/8ZVghbWqLr/zoo20Pi5O3zrBMYFWch+WYWkm9mIexdwMi8ilE8tbQ4Nz212DgvtVyvODG3
        uDQvXS85P3cTIzA1nf53/OsOxn1/kg4xCnAwKvHwdhzyjBFiTSwrrsw9xCjBwawkwut60S1G
        iDclsbIqtSg/vqg0J7X4EKM0B4uSOG81w4NoIYH0xJLU7NTUgtQimCwTB6dUA+OtOVq5fZ+u
        elhVL/b2fmjzVv+pTL2R/Vk5mVjDdXtuxJ7V2b1cqWV/FM+Wku7rO86YFahIWd2NOrm7yeM/
        e6F13O+H4c7iXe/33Jgg8/iKQNT1DN8tNgxHjvcoNEnl8c47uo/VeeejlRJeIldrzpT5sZ+s
        bY7ZudL1Vqj74t+GWswviyL59ZVYijMSgZyi4kQARt8PcUkDAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrMIsWRmVeSWpSXmKPExsVy+t/xe7qL73rGGDScsLHYOGM9q8Wc8y0s
        Ft2vZCz69v1ntDh/fgO7xf17P5ksLu+aw2Yx4/w+Jou1R+6yW/z/1czswOWxZeVNJo9tB1Q9
        Nq3qZPP4t3AKi8fBd3uYPPq2rGL0+LxJLoA9Ss+mKL+0JFUhI7+4xFYp2tDCSM/Q0kLPyMRS
        z9DYPNbKyFRJ384mJTUnsyy1SN8uQS/j67ZWloJXchX7d91ma2C8IdHFyMEhIWAisfs+Uxcj
        F4eQwFJGic1bLrB3MXICxaUlGk+vZoKwhSX+XOtigyj6xCjxc8lesCI2AXOJR9vPgBWJCChL
        TL43nRnEZhb4yCTxZxU3iC0s4Cxx7tg8FhCbRUBVou/0CrBeXgEXie0dM9kgFshLTFvdBTaH
        U8BVYu+EZrB6IaCaud9msUHUC0qcnPmEBWK+vETz1tnMExgFZiFJzUKSWsDItIpRJLW0ODc9
        t9hQrzgxt7g0L10vOT93EyMwgrYd+7l5B+OljcGHGAU4GJV4eDsOecYIsSaWFVfmHmKU4GBW
        EuF1vegWI8SbklhZlVqUH19UmpNafIjRFOiJicxSosn5wOjOK4k3NDU0t7A0NDc2NzazUBLn
        PW9QGSUkkJ5YkpqdmlqQWgTTx8TBKdXAWCKbmFrxcxLDqV/634JSjvOVPZQVnaBy0VV39pYg
        Ecc9h2aWfgv90Hqh657Dac/1QU3v61Yen/KtlGv/NmaPZtlvuz+oT9bcGTorKDxB7KG2+bPj
        C9dEbt80IdSCT+XHvSOvzicfVXz2hWH/HpWrXXfOf7m3iCtbisee70Oh8aY8Z6Vr9nw5YUos
        xRmJhlrMRcWJAP5kMI+2AgAA
X-CMS-MailID: 20190124154540eucas1p219536f93a4b1e9133d2859e3c38c1f66
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-RootMTR: 20190124154540eucas1p219536f93a4b1e9133d2859e3c38c1f66
X-EPHeader: CA
CMS-TYPE: 201P
X-CMS-RootMailID: 20190124154540eucas1p219536f93a4b1e9133d2859e3c38c1f66
References: <20190124154521.13589-1-k.konieczny@partner.samsung.com>
        <CGME20190124154540eucas1p219536f93a4b1e9133d2859e3c38c1f66@eucas1p2.samsung.com>
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Add AES crypto HW acceleration for Exynos5433, with the help of SlimSSS IP.

Reviewed-by: Krzysztof Kozlowski <krzk@kernel.org>
Signed-off-by: Kamil Konieczny <k.konieczny@partner.samsung.com>
---
 drivers/crypto/s5p-sss.c | 50 ++++++++++++++++++++++++++++++++++++----
 1 file changed, 46 insertions(+), 4 deletions(-)

diff --git a/drivers/crypto/s5p-sss.c b/drivers/crypto/s5p-sss.c
index 0064be0e3941..3f45cc5cb94a 100644
--- a/drivers/crypto/s5p-sss.c
+++ b/drivers/crypto/s5p-sss.c
@@ -232,6 +232,7 @@
  * struct samsung_aes_variant - platform specific SSS driver data
  * @aes_offset: AES register offset from SSS module's base.
  * @hash_offset: HASH register offset from SSS module's base.
+ * @clk_names: names of clocks needed to run SSS IP
  *
  * Specifies platform specific configuration of SSS module.
  * Note: A structure for driver specific platform data is used for future
@@ -240,6 +241,7 @@
 struct samsung_aes_variant {
 	unsigned int			aes_offset;
 	unsigned int			hash_offset;
+	const char			*clk_names[];
 };
 
 struct s5p_aes_reqctx {
@@ -296,6 +298,7 @@ struct s5p_aes_ctx {
 struct s5p_aes_dev {
 	struct device			*dev;
 	struct clk			*clk;
+	struct clk			*pclk;
 	void __iomem			*ioaddr;
 	void __iomem			*aes_ioaddr;
 	int				irq_fc;
@@ -384,11 +387,19 @@ struct s5p_hash_ctx {
 static const struct samsung_aes_variant s5p_aes_data = {
 	.aes_offset	= 0x4000,
 	.hash_offset	= 0x6000,
+	.clk_names	= { "secss", },
 };
 
 static const struct samsung_aes_variant exynos_aes_data = {
 	.aes_offset	= 0x200,
 	.hash_offset	= 0x400,
+	.clk_names	= { "secss", },
+};
+
+static const struct samsung_aes_variant exynos5433_slim_aes_data = {
+	.aes_offset	= 0x400,
+	.hash_offset	= 0x800,
+	.clk_names	= { "pclk", "aclk", },
 };
 
 static const struct of_device_id s5p_sss_dt_match[] = {
@@ -400,6 +411,10 @@ static const struct of_device_id s5p_sss_dt_match[] = {
 		.compatible = "samsung,exynos4210-secss",
 		.data = &exynos_aes_data,
 	},
+	{
+		.compatible = "samsung,exynos5433-slim-sss",
+		.data = &exynos5433_slim_aes_data,
+	},
 	{ },
 };
 MODULE_DEVICE_TABLE(of, s5p_sss_dt_match);
@@ -2208,18 +2223,39 @@ static int s5p_aes_probe(struct platform_device *pdev)
 			return PTR_ERR(pdata->ioaddr);
 	}
 
-	pdata->clk = devm_clk_get(dev, "secss");
+	pdata->clk = devm_clk_get(dev, variant->clk_names[0]);
 	if (IS_ERR(pdata->clk)) {
-		dev_err(dev, "failed to find secss clock source\n");
+		dev_err(dev, "failed to find secss clock %s\n",
+			variant->clk_names[0]);
 		return -ENOENT;
 	}
 
 	err = clk_prepare_enable(pdata->clk);
 	if (err < 0) {
-		dev_err(dev, "Enabling SSS clk failed, err %d\n", err);
+		dev_err(dev, "Enabling clock %s failed, err %d\n",
+			variant->clk_names[0], err);
 		return err;
 	}
 
+	if (variant->clk_names[1]) {
+		pdata->pclk = devm_clk_get(dev, variant->clk_names[1]);
+		if (IS_ERR(pdata->pclk)) {
+			dev_err(dev, "failed to find clock %s\n",
+				variant->clk_names[1]);
+			err = -ENOENT;
+			goto err_clk;
+		}
+
+		err = clk_prepare_enable(pdata->pclk);
+		if (err < 0) {
+			dev_err(dev, "Enabling clock %s failed, err %d\n",
+				variant->clk_names[0], err);
+			goto err_clk;
+		}
+	} else {
+		pdata->pclk = NULL;
+	}
+
 	spin_lock_init(&pdata->lock);
 	spin_lock_init(&pdata->hash_lock);
 
@@ -2295,8 +2331,11 @@ static int s5p_aes_probe(struct platform_device *pdev)
 	tasklet_kill(&pdata->tasklet);
 
 err_irq:
-	clk_disable_unprepare(pdata->clk);
+	if (pdata->pclk)
+		clk_disable_unprepare(pdata->pclk);
 
+err_clk:
+	clk_disable_unprepare(pdata->clk);
 	s5p_dev = NULL;
 
 	return err;
@@ -2323,6 +2362,9 @@ static int s5p_aes_remove(struct platform_device *pdev)
 		pdata->use_hash = false;
 	}
 
+	if (pdata->pclk)
+		clk_disable_unprepare(pdata->pclk);
+
 	clk_disable_unprepare(pdata->clk);
 	s5p_dev = NULL;
 
-- 
2.20.0

