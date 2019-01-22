Return-Path: <SRS0=98p2=P6=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 143EEC282C5
	for <linux-crypto@archiver.kernel.org>; Tue, 22 Jan 2019 15:26:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D0282217D6
	for <linux-crypto@archiver.kernel.org>; Tue, 22 Jan 2019 15:26:16 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="N2ch5Cln"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729838AbfAVP0M (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 22 Jan 2019 10:26:12 -0500
Received: from mailout2.w1.samsung.com ([210.118.77.12]:54847 "EHLO
        mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728997AbfAVP0M (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 22 Jan 2019 10:26:12 -0500
Received: from eucas1p2.samsung.com (unknown [182.198.249.207])
        by mailout2.w1.samsung.com (KnoxPortal) with ESMTP id 20190122152610euoutp02fd8bc5151160210360081ea572cc486a~8NR0YF9Hd3007530075euoutp02G
        for <linux-crypto@vger.kernel.org>; Tue, 22 Jan 2019 15:26:10 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.w1.samsung.com 20190122152610euoutp02fd8bc5151160210360081ea572cc486a~8NR0YF9Hd3007530075euoutp02G
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1548170771;
        bh=0iS4N47zJ6GyLB+EN4i3sgvj82GJztVtoi19B0s9OrY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=N2ch5ClnWlOS1nbrsqbHwDuKEsNYdG5V1cCuj3I0vkV6v0LemsZqZio3hxqHMSvLM
         JFFUQr4AwX/PysyjcM/5SP+7Ia83OkBf3UPLQlE7mkE/YVX6+rtL6yBBXfN94lyGXY
         RTB5iW1OKOdfctBwgoHydZ6/Yv0kib3j+UKkhyRs=
Received: from eusmges2new.samsung.com (unknown [203.254.199.244]) by
        eucas1p1.samsung.com (KnoxPortal) with ESMTP id
        20190122152610eucas1p1bafb37c557947c997db48bc4f47c8553~8NRzxvR2f2950829508eucas1p1N;
        Tue, 22 Jan 2019 15:26:10 +0000 (GMT)
Received: from eucas1p2.samsung.com ( [182.198.249.207]) by
        eusmges2new.samsung.com (EUCPMTA) with SMTP id E2.69.04294.216374C5; Tue, 22
        Jan 2019 15:26:10 +0000 (GMT)
Received: from eusmtrp2.samsung.com (unknown [182.198.249.139]) by
        eucas1p2.samsung.com (KnoxPortal) with ESMTPA id
        20190122152609eucas1p287b83592af600dc080374a197e6dd917~8NRzGSoR51298012980eucas1p2M;
        Tue, 22 Jan 2019 15:26:09 +0000 (GMT)
Received: from eusmgms1.samsung.com (unknown [182.198.249.179]) by
        eusmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20190122152609eusmtrp23b76f5bd4ca80b7a783816e0197c5107~8NRyweIKw0539705397eusmtrp2Y;
        Tue, 22 Jan 2019 15:26:09 +0000 (GMT)
X-AuditID: cbfec7f4-84fff700000010c6-e8-5c4736126fb7
Received: from eusmtip2.samsung.com ( [203.254.199.222]) by
        eusmgms1.samsung.com (EUCPMTA) with SMTP id 8A.89.04284.116374C5; Tue, 22
        Jan 2019 15:26:09 +0000 (GMT)
Received: from AMDC3218.DIGITAL.local (unknown [106.120.51.18]) by
        eusmtip2.samsung.com (KnoxPortal) with ESMTPA id
        20190122152608eusmtip2f0abca2c9e35bd6a8c2e15adb74672e1~8NRyRd97Y0551005510eusmtip25;
        Tue, 22 Jan 2019 15:26:08 +0000 (GMT)
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
Subject: [PATCH v1 3/3] crypto: s5p: add AES support for Exynos5433
Date:   Tue, 22 Jan 2019 16:25:53 +0100
Message-Id: <20190122152553.1537-4-k.konieczny@partner.samsung.com>
X-Mailer: git-send-email 2.20.0
In-Reply-To: <20190122152553.1537-1-k.konieczny@partner.samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrGKsWRmVeSWpSXmKPExsWy7djP87pCZu4xBmfOs1hsnLGe1WLO+RYW
        i+5XMhZ9+/4zWpw/v4Hd4v69n0wWl3fNYbOYcX4fk8XaI3fZLf7/amZ24PLYsvImk8e2A6oe
        m1Z1snn8WziFxePguz1MHn1bVjF6fN4kF8AexWWTkpqTWZZapG+XwJWxt6mfqeCBXMX041YN
        jBcluhg5OSQETCR2XGtm62Lk4hASWMEoMXH7dXYI5wujxOfzC1ghnM+MEreaTrDBtHxqO8EE
        kVjOKHGypZkJruVH50OwKjYBc4lH288wgdgiAsoSk+9NZwYpYhZ4zSSx4fYrsISwgLPE0TUL
        mUFsFgFViQ2zVrOC2LxA8UdH1zJCrJOXmLa6C6yeU8BF4vypVVA1ghInZz5hAbGZgWqat84G
        WyAhsI5d4uz9b1DNLhJTH72CultY4tXxLewQtozE/53zmSDscondW5+xQzS3MErMnbwIKmEt
        cfj4RaBtHEAbNCXW79KHCDtKPJr4jAUkLCHAJ3HjrSDEDXwSk7aBPAkS5pXoaBOCqNaVmPf/
        DCuELS3R9X8dlO0h8WHNY+YJjIqzkHwzC8k3sxD2LmBkXsUonlpanJueWmyUl1quV5yYW1ya
        l66XnJ+7iRGYmk7/O/5lB+OuP0mHGAU4GJV4eBMuuMYIsSaWFVfmHmKU4GBWEuF1vegWI8Sb
        klhZlVqUH19UmpNafIhRmoNFSZy3muFBtJBAemJJanZqakFqEUyWiYNTqoHRyHemdZzA65vz
        ehccrapjLNvn2b8w9n1Hofj5Jk6p+7x9/mV12Vk+QvnT/VkddszZ0fLO8NXHb18lA3Levmw/
        rX+x8tnKk2WGNbnFEf94d8zZI25r+SiWfe+PEpY/EXyWC+UeK8mfKCquvdJwKzMtwu/Kk48L
        53ZN/F6x7rqHwrQlW4oW2n1WYinOSDTUYi4qTgQAiyMrlUkDAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrEIsWRmVeSWpSXmKPExsVy+t/xe7qCZu4xBs0zuS02zljPajHnfAuL
        RfcrGYu+ff8ZLc6f38Bucf/eTyaLy7vmsFnMOL+PyWLtkbvsFv9/NTM7cHlsWXmTyWPbAVWP
        Tas62Tz+LZzC4nHw3R4mj74tqxg9Pm+SC2CP0rMpyi8tSVXIyC8usVWKNrQw0jO0tNAzMrHU
        MzQ2j7UyMlXSt7NJSc3JLEst0rdL0MvY29TPVPBArmL6casGxosSXYycHBICJhKf2k4wgdhC
        AksZJVrOyULEpSUaT69mgrCFJf5c62LrYuQCqvnEKHH+9DF2kASbgLnEo+1nwIpEBJQlJt+b
        zgxiMwt8ZJL4s4obxBYWcJY4umYhWJxFQFViw6zVrCA2L1D80dG1jBAL5CWmre4Cm8Mp4CJx
        /tQqVoiDnCUeT5gDVS8ocXLmExaI+fISzVtnM09gFJiFJDULSWoBI9MqRpHU0uLc9NxiQ73i
        xNzi0rx0veT83E2MwPjZduzn5h2MlzYGH2IU4GBU4uHlOOcaI8SaWFZcmXuIUYKDWUmE1/Wi
        W4wQb0piZVVqUX58UWlOavEhRlOgJyYyS4km5wNjO68k3tDU0NzC0tDc2NzYzEJJnPe8QWWU
        kEB6YklqdmpqQWoRTB8TB6dUA6Pipxn7e0syLv7SDHLLqFTeJFn9h+vyw5LLHvc1pPdeFn79
        Ivv3Uqnm8r1F33+JJoX3mjuknn5Sm57MMzfhfbxXK/MfryPKtzt0Z+vc5T7neMz6lvOlORMF
        nrl+PLFok+v8SYef6z30zaz9+L2aPfHmM9ZS7rp5RUZbc9fb2v+VzBO5oud2g1mJpTgj0VCL
        uag4EQAmdMqstQIAAA==
X-CMS-MailID: 20190122152609eucas1p287b83592af600dc080374a197e6dd917
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-RootMTR: 20190122152609eucas1p287b83592af600dc080374a197e6dd917
X-EPHeader: CA
CMS-TYPE: 201P
X-CMS-RootMailID: 20190122152609eucas1p287b83592af600dc080374a197e6dd917
References: <20190122152553.1537-1-k.konieczny@partner.samsung.com>
        <CGME20190122152609eucas1p287b83592af600dc080374a197e6dd917@eucas1p2.samsung.com>
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
index 0064be0e3941..1ae570ad4391 100644
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
+	.clk_names	= { "secss", }
 };
 
 static const struct samsung_aes_variant exynos_aes_data = {
 	.aes_offset	= 0x200,
 	.hash_offset	= 0x400,
+	.clk_names	= { "secss", }
+};
+
+static const struct samsung_aes_variant exynos5433_slim_aes_data = {
+	.aes_offset	= 0x400,
+	.hash_offset	= 0x800,
+	.clk_names	= { "pclk", "aclk", }
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
@@ -2208,18 +2223,40 @@ static int s5p_aes_probe(struct platform_device *pdev)
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
+			clk_disable_unprepare(pdata->clk);
+			return -ENOENT;
+			}
+
+		err = clk_prepare_enable(pdata->pclk);
+		if (err < 0) {
+			dev_err(dev, "Enabling clock %s failed, err %d\n",
+				variant->clk_names[0], err);
+			clk_disable_unprepare(pdata->clk);
+			return err;
+		}
+	} else {
+		pdata->pclk = NULL;
+	}
+
 	spin_lock_init(&pdata->lock);
 	spin_lock_init(&pdata->hash_lock);
 
@@ -2295,8 +2332,10 @@ static int s5p_aes_probe(struct platform_device *pdev)
 	tasklet_kill(&pdata->tasklet);
 
 err_irq:
-	clk_disable_unprepare(pdata->clk);
+	if (pdata->pclk)
+		clk_disable_unprepare(pdata->pclk);
 
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

