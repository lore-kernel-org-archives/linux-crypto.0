Return-Path: <SRS0=I8vn=P7=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EE364C282C0
	for <linux-crypto@archiver.kernel.org>; Wed, 23 Jan 2019 16:56:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B44002085A
	for <linux-crypto@archiver.kernel.org>; Wed, 23 Jan 2019 16:56:20 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="nLSINnov"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726357AbfAWQ4I (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 23 Jan 2019 11:56:08 -0500
Received: from mailout1.w1.samsung.com ([210.118.77.11]:33352 "EHLO
        mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726234AbfAWQzy (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 23 Jan 2019 11:55:54 -0500
Received: from eucas1p2.samsung.com (unknown [182.198.249.207])
        by mailout1.w1.samsung.com (KnoxPortal) with ESMTP id 20190123165553euoutp014e58a537417f7227bf8650b5de126477~8iJbSzNFu2585325853euoutp01Y
        for <linux-crypto@vger.kernel.org>; Wed, 23 Jan 2019 16:55:53 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.w1.samsung.com 20190123165553euoutp014e58a537417f7227bf8650b5de126477~8iJbSzNFu2585325853euoutp01Y
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1548262553;
        bh=nYdt+zRspMtA6gW+2p85Ojif+/CqFQBWjZ0c05/P7qM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nLSINnov9BLC//2uBfNt9bbk4aaQDdAF8T2S2SS4yaSuP8hYIOrGR7b7qZHvxlxbC
         keq3xf6dPlAlXAowf6QYqr4gB8CUoOTkVl3Y+8S81ZaRNwAbjn1L//Ecrwcy5ObCUN
         xDz++jbGahWDVOYnWUvII6n+AjC9qmeO/QEQekZQ=
Received: from eusmges1new.samsung.com (unknown [203.254.199.242]) by
        eucas1p1.samsung.com (KnoxPortal) with ESMTP id
        20190123165552eucas1p1b41feb57b4b7316a1a26f337b3618706~8iJa1yZnG0827108271eucas1p1Q;
        Wed, 23 Jan 2019 16:55:52 +0000 (GMT)
Received: from eucas1p2.samsung.com ( [182.198.249.207]) by
        eusmges1new.samsung.com (EUCPMTA) with SMTP id B1.36.04441.89C984C5; Wed, 23
        Jan 2019 16:55:52 +0000 (GMT)
Received: from eusmtrp2.samsung.com (unknown [182.198.249.139]) by
        eucas1p1.samsung.com (KnoxPortal) with ESMTPA id
        20190123165551eucas1p1cd99462e3767dbb4feb88b996225ed21~8iJaGU02y2306623066eucas1p1E;
        Wed, 23 Jan 2019 16:55:51 +0000 (GMT)
Received: from eusmgms1.samsung.com (unknown [182.198.249.179]) by
        eusmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20190123165551eusmtrp25017c8ec7c0ba3f83ec0b703bb4488f5~8iJZ35FjS0112001120eusmtrp2M;
        Wed, 23 Jan 2019 16:55:51 +0000 (GMT)
X-AuditID: cbfec7f2-5c9ff70000001159-6b-5c489c989e65
Received: from eusmtip1.samsung.com ( [203.254.199.221]) by
        eusmgms1.samsung.com (EUCPMTA) with SMTP id 99.32.04284.79C984C5; Wed, 23
        Jan 2019 16:55:51 +0000 (GMT)
Received: from AMDC3218.DIGITAL.local (unknown [106.120.51.18]) by
        eusmtip1.samsung.com (KnoxPortal) with ESMTPA id
        20190123165551eusmtip1875742def9bbc0418dbc5950aa0c7edf~8iJZLe56a0754507545eusmtip15;
        Wed, 23 Jan 2019 16:55:50 +0000 (GMT)
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
Subject: [PATCH v2 3/3] crypto: s5p: add AES support for Exynos5433
Date:   Wed, 23 Jan 2019 17:55:33 +0100
Message-Id: <20190123165533.29645-4-k.konieczny@partner.samsung.com>
X-Mailer: git-send-email 2.20.0
In-Reply-To: <20190123165533.29645-1-k.konieczny@partner.samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA01Sa0gUYRTtm5l1x8WxcRW8qBhtChWpCUYDhihpza+Qon6YZZsOKj7b8V2B
        5eJjFSs136WWko9ydVnNV2ImLZW0mEiG5SPSzHSVTEQJN3dnLf+de+8595wLl8SlHSInMjo+
        iVPEy2NlVhKi8/WG3qO8mg09emsJmPZytYip1isJJn/BhSnsNyJGr28TM1OTGxgz2lNtxZTr
        +zHm2dAXMWPczML9Jay26RPGdg64s5rmPCt2q66EYF8a+jC2UNuM2FWNa7A4RHIigouNTuEU
        Xn5XJFHFdwwosd01bbaoT5SJ6kGFrEmgfWBifYZQIQkppRsRTN1fFgnFbwT5xctioVhF8Kdx
        k9iRqAtqLJIn25KPJfg/yXpLmZllRR+Hr8+HMRN2oA9A8WSZmYTTPzFom1gwD+zpk2CYn90W
        kCRBu0NVl7epTdGBUFq7JBbc9kFpiwozUazpIMjbvCBQ7OBNxTezFb5NyeqoMq8HWiOGgW6D
        JWkgVCw2WLA9LOi0lp0uYOyuwQScCr0dc2JBrETwoPiRZeALr3QjIpMxTh8CdY+X0A6AxwVK
        c2SgbWF8yU7IYAtFnaYTTW0KcrOlAtsDHhqHRQJ2BpWx1YJZyF6/je6i/ZW7rqncdU3lf99a
        hDcjRy6Zj4vkeO94LtWTl8fxyfGRnuEJcRq0/UzvtnS/utDah6uDiCaRzIYir7GhUpE8hU+P
        G0RA4jIHKmjkVKiUipCnZ3CKhDBFcizHDyJnkpA5Utf3TF+U0pHyJC6G4xI5xc4UI62dMtHl
        wacqNqfV/3tVfzilV7tFf/7xfnFTeaNuXn2kYmnNkAb3TuM+e3PO+a2sNSj1wTMKYrH9mGrc
        o0Qb4JPBD9UGndfMSsdCPHtTKYfJlaHU3rmz07FuTbq+t2k3x+r0B7UeZ8J8I+tHxvup0emy
        FzWuuTHalHmb8kvZWQug08gIPkrufRhX8PK/tcDkjUgDAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrEIsWRmVeSWpSXmKPExsVy+t/xu7rT53jEGFy4JmexccZ6Vos551tY
        LLpfyVj07fvPaHH+/AZ2i/v3fjJZXN41h81ixvl9TBZrj9xlt/j/q5nZgctjy8qbTB7bDqh6
        bFrVyebxb+EUFo+D7/YwefRtWcXo8XmTXAB7lJ5NUX5pSapCRn5xia1StKGFkZ6hpYWekYml
        nqGxeayVkamSvp1NSmpOZllqkb5dgl7G5P53jAUb5SqeTtrD2sC4RKKLkZNDQsBEYn3PfJYu
        Ri4OIYGljBJvGs+yQCSkJRpPr2aCsIUl/lzrYoMo+sQo8WrldjaQBJuAucSj7WfAikQElCUm
        35vODGIzC3xkkvizihvEFhZwlnj34inQUA4OFgFVidk7DEHCvAIuEtMWvGWHmC8vMW11FxNI
        CaeAq0TnrzCQsBBQyfMDX1ghygUlTs58wgIxXV6ieets5gmMArOQpGYhSS1gZFrFKJJaWpyb
        nltsqFecmFtcmpeul5yfu4kRGD/bjv3cvIPx0sbgQ4wCHIxKPLwb8jxihFgTy4orcw8xSnAw
        K4nwul50ixHiTUmsrEotyo8vKs1JLT7EaAr0wkRmKdHkfGBs55XEG5oamltYGpobmxubWSiJ
        8543qIwSEkhPLEnNTk0tSC2C6WPi4JRqYIxS/fzGQbLUpenHu/5G2aDw/fwrNARms619zlrc
        6zYtN76ocfrLtb+6p8/QzDpQZfAt1czxvBKv5YmNF9bYVu9fdbDtpavfmuc6i92Xq/fKh22d
        a1emmJrDfGZnI8s5tjyn7tw/Ry6qnJv1PmO9fJnTn+M2OgKK10oydIr8iyamJLKmWPbeUmIp
        zkg01GIuKk4EAEESLf+1AgAA
X-CMS-MailID: 20190123165551eucas1p1cd99462e3767dbb4feb88b996225ed21
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-RootMTR: 20190123165551eucas1p1cd99462e3767dbb4feb88b996225ed21
X-EPHeader: CA
CMS-TYPE: 201P
X-CMS-RootMailID: 20190123165551eucas1p1cd99462e3767dbb4feb88b996225ed21
References: <20190123165533.29645-1-k.konieczny@partner.samsung.com>
        <CGME20190123165551eucas1p1cd99462e3767dbb4feb88b996225ed21@eucas1p1.samsung.com>
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Add AES crypto HW acceleration for Exynos5433, with the help of SlimSSS IP.

Signed-off-by: Kamil Konieczny <k.konieczny@partner.samsung.com>
---
 drivers/crypto/s5p-sss.c | 50 ++++++++++++++++++++++++++++++++++++----
 1 file changed, 46 insertions(+), 4 deletions(-)

diff --git a/drivers/crypto/s5p-sss.c b/drivers/crypto/s5p-sss.c
index 0064be0e3941..e2d247f59254 100644
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
+	char				*clk_names[];
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

