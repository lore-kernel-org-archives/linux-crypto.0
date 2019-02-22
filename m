Return-Path: <SRS0=rdxF=Q5=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A75EDC4151A
	for <linux-crypto@archiver.kernel.org>; Fri, 22 Feb 2019 12:22:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6DDC82075A
	for <linux-crypto@archiver.kernel.org>; Fri, 22 Feb 2019 12:22:23 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="PJpNeavy"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727099AbfBVMWS (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 22 Feb 2019 07:22:18 -0500
Received: from mailout2.w1.samsung.com ([210.118.77.12]:33272 "EHLO
        mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727097AbfBVMWI (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 22 Feb 2019 07:22:08 -0500
Received: from eucas1p2.samsung.com (unknown [182.198.249.207])
        by mailout2.w1.samsung.com (KnoxPortal) with ESMTP id 20190222122206euoutp0226fa6595718a1ee0038c8ba206003df4~Frw8hm85B0090000900euoutp02C
        for <linux-crypto@vger.kernel.org>; Fri, 22 Feb 2019 12:22:06 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.w1.samsung.com 20190222122206euoutp0226fa6595718a1ee0038c8ba206003df4~Frw8hm85B0090000900euoutp02C
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1550838126;
        bh=VG6oAC5U9XTdjvMniG4O/CFb//GFZSZ9LzVAmwE443c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PJpNeavyTvvuf7BNF9OP4tkGco4mef6DF69kUjaOLJKpUZU8VrXY/Ro55FmjkEY6Z
         9A6cBYnyav1G71cYBb0i8Fc+ppl+SSCd1OdylpbG0smMITBqv/5xfFpSWyvtkLU/d/
         Yx3j89BV3+i7F8Q0nX8bsAWQ1Z4o15UmcDGviB90=
Received: from eusmges1new.samsung.com (unknown [203.254.199.242]) by
        eucas1p1.samsung.com (KnoxPortal) with ESMTP id
        20190222122205eucas1p1fc5c2e5d5e76efead31ca6e8d6af7209~Frw8Jf-W-2093320933eucas1p1D;
        Fri, 22 Feb 2019 12:22:05 +0000 (GMT)
Received: from eucas1p1.samsung.com ( [182.198.249.206]) by
        eusmges1new.samsung.com (EUCPMTA) with SMTP id EE.BF.04441.D69EF6C5; Fri, 22
        Feb 2019 12:22:05 +0000 (GMT)
Received: from eusmtrp1.samsung.com (unknown [182.198.249.138]) by
        eucas1p1.samsung.com (KnoxPortal) with ESMTPA id
        20190222122204eucas1p1ee66c9d937bdf328588ececb1f005526~Frw7VHecE1233312333eucas1p1C;
        Fri, 22 Feb 2019 12:22:04 +0000 (GMT)
Received: from eusmgms2.samsung.com (unknown [182.198.249.180]) by
        eusmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20190222122204eusmtrp11c8f8dec82bcb08e4fa381ec79d109cf~Frw7Gmifj1040810408eusmtrp12;
        Fri, 22 Feb 2019 12:22:04 +0000 (GMT)
X-AuditID: cbfec7f2-5e3ff70000001159-c7-5c6fe96d0e63
Received: from eusmtip1.samsung.com ( [203.254.199.221]) by
        eusmgms2.samsung.com (EUCPMTA) with SMTP id 16.6F.04128.C69EF6C5; Fri, 22
        Feb 2019 12:22:04 +0000 (GMT)
Received: from AMDC3218.DIGITAL.local (unknown [106.120.51.18]) by
        eusmtip1.samsung.com (KnoxPortal) with ESMTPA id
        20190222122204eusmtip15dd7560288b814ad81af00aa6ad82deb~Frw6kiR6-1159911599eusmtip1W;
        Fri, 22 Feb 2019 12:22:04 +0000 (GMT)
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
Subject: [PATCH v4 3/3] crypto: s5p: add AES support for Exynos5433
Date:   Fri, 22 Feb 2019 13:21:44 +0100
Message-Id: <20190222122144.19024-4-k.konieczny@partner.samsung.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190222122144.19024-1-k.konieczny@partner.samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrCKsWRmVeSWpSXmKPExsWy7djPc7q5L/NjDDa8UbDYOGM9q8Wc8y0s
        Ft2vZCz69v1ntDh/fgO7xf17P5ksLu+aw2Yx4/w+Jou1R+6yW/z/1czswOWxZeVNJo9tB1Q9
        Nq3qZPP4t3AKi8fBd3uYPPq2rGL0+LxJLoA9issmJTUnsyy1SN8ugStj4qbrjAWv5Cq2PnzG
        2MB4Q6KLkZNDQsBEYllzC1sXIxeHkMAKRom5F7exQjhfGCWO9C5lgnA+M0r09L5mhml5PWM3
        mC0ksJxRYskNfbiOyR+2MYIk2ATMJR5tP8MEYosIKEtMvjedGaSIWeA1k8SG26/AEsICzhIv
        dt1jAbFZBFQl7nW1sIPYvAIuEmunPYDaJi9xvncdWJxTwFWi4fcdRogaQYmTM5+A9TID1TRv
        nQ22QEJgE7vEvWWLgRwOIMdF4tATXog5whKvjm9hh7BlJE5P7mGBsMsldm99xg7R2wIMgMmL
        mCAS1hKHj19kBZnDLKApsX6XPsRIR4krr70gTD6JG28FIS7gk5i0bTrUUl6JjjYhiBm6EvP+
        n2GFsKUluv6vg7I9JI4fesIygVFxFpJfZiH5ZRbC2gWMzKsYxVNLi3PTU4sN81LL9YoTc4tL
        89L1kvNzNzEC09Lpf8c/7WD8einpEKMAB6MSD6/FxrwYIdbEsuLK3EOMEhzMSiK8DM/zY4R4
        UxIrq1KL8uOLSnNSiw8xSnOwKInzVjM8iBYSSE8sSc1OTS1ILYLJMnFwSjUwWi5ddmzOevUP
        Z73tDvgc6/q+6sfzvF0C8gf+Ss+VO8Cx+JcL95yGgPPJXewWS07s2vSp2OxPUUpqo0GhrZZ0
        SjgLs0XW8yhHj5dzz4ceWL8ihu+n7vKm5ku/BI5p8nbxaj2Y/bOES0OuOseYYX904S35mYY6
        QV/eR0d6f1/Cl/X2tTbLv6cSSizFGYmGWsxFxYkAvm6QjkcDAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrEIsWRmVeSWpSXmKPExsVy+t/xu7o5L/NjDK7cULbYOGM9q8Wc8y0s
        Ft2vZCz69v1ntDh/fgO7xf17P5ksLu+aw2Yx4/w+Jou1R+6yW/z/1czswOWxZeVNJo9tB1Q9
        Nq3qZPP4t3AKi8fBd3uYPPq2rGL0+LxJLoA9Ss+mKL+0JFUhI7+4xFYp2tDCSM/Q0kLPyMRS
        z9DYPNbKyFRJ384mJTUnsyy1SN8uQS9j4qbrjAWv5Cq2PnzG2MB4Q6KLkZNDQsBE4vWM3cwg
        tpDAUkaJSV+MIOLSEo2nVzNB2MISf651sXUxcgHVfGKU+DhjBgtIgk3AXOLR9jNgRSICyhKT
        700HG8Qs8JFJ4s8qbhBbWMBZ4sWue2D1LAKqEve6WthBbF4BF4m10x4wQyyQlzjfuw4szing
        KtHw+w5jFyMH0DIXiQf7qyDKBSVOznzCAjFeXqJ562zmCYwCs5CkZiFJLWBkWsUoklpanJue
        W2ykV5yYW1yal66XnJ+7iREYP9uO/dyyg7HrXfAhRgEORiUeXouNeTFCrIllxZW5hxglOJiV
        RHgZnufHCPGmJFZWpRblxxeV5qQWH2I0BfphIrOUaHI+MLbzSuINTQ3NLSwNzY3Njc0slMR5
        zxtURgkJpCeWpGanphakFsH0MXFwSjUw9qZEdc5aeszYe75EV1y/OqvH260a29VsbCbz1Byd
        fJ5J5cKOSTxNCy6xsrIGXbztpVznXnua80muaoFd3StfybdFEdfXad5WFb+gw/L5uutGvvNH
        JrcdTzC/wbO42jamv4j//CplVqne2edsav9PbLA1e2N/2rL9qZFbntOzRxPjA7a7fv6ixFKc
        kWioxVxUnAgAmsFr/rUCAAA=
X-CMS-MailID: 20190222122204eucas1p1ee66c9d937bdf328588ececb1f005526
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-RootMTR: 20190222122204eucas1p1ee66c9d937bdf328588ececb1f005526
X-EPHeader: CA
CMS-TYPE: 201P
X-CMS-RootMailID: 20190222122204eucas1p1ee66c9d937bdf328588ececb1f005526
References: <20190222122144.19024-1-k.konieczny@partner.samsung.com>
        <CGME20190222122204eucas1p1ee66c9d937bdf328588ececb1f005526@eucas1p1.samsung.com>
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
2.20.1

