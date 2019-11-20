Return-Path: <SRS0=IkvS=ZM=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNWANTED_LANGUAGE_BODY,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0BF6CC432C0
	for <linux-crypto@archiver.kernel.org>; Wed, 20 Nov 2019 13:55:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C868822467
	for <linux-crypto@archiver.kernel.org>; Wed, 20 Nov 2019 13:55:47 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="XBwr4Kew"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729591AbfKTNzo (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 20 Nov 2019 08:55:44 -0500
Received: from mailout1.w1.samsung.com ([210.118.77.11]:36345 "EHLO
        mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730431AbfKTNzo (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 20 Nov 2019 08:55:44 -0500
Received: from eucas1p2.samsung.com (unknown [182.198.249.207])
        by mailout1.w1.samsung.com (KnoxPortal) with ESMTP id 20191120135542euoutp01f81f1b3937b57c96f33688995b135cd2~Y43CDQ-rw0155301553euoutp01D
        for <linux-crypto@vger.kernel.org>; Wed, 20 Nov 2019 13:55:42 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.w1.samsung.com 20191120135542euoutp01f81f1b3937b57c96f33688995b135cd2~Y43CDQ-rw0155301553euoutp01D
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1574258142;
        bh=NZ/p/16m2xALQW3+YM64mLJ35Kbe8jF90nNS0QSxIQM=;
        h=From:To:Cc:Subject:Date:References:From;
        b=XBwr4KewkBbCsT962PAiwKTrhHw7pNEPxsQVFroDaTJDgiY/KZyqeMxoXyDstAJgH
         N4ZZmVR2DFsjUEqPAN6U8WJUsOiAdcnte6TEqmepcMoSIH5rv3ehcVD5mIvoB7ttDP
         wHiSeOcUTYIjyuzenK71Lxc4nmd4lZS+o/YQDiNg=
Received: from eusmges3new.samsung.com (unknown [203.254.199.245]) by
        eucas1p2.samsung.com (KnoxPortal) with ESMTP id
        20191120135541eucas1p273fb0901b1b9fcc543e53e5736d90248~Y43B2KIME2043220432eucas1p27;
        Wed, 20 Nov 2019 13:55:41 +0000 (GMT)
Received: from eucas1p1.samsung.com ( [182.198.249.206]) by
        eusmges3new.samsung.com (EUCPMTA) with SMTP id 60.A1.04374.DD545DD5; Wed, 20
        Nov 2019 13:55:41 +0000 (GMT)
Received: from eusmtrp2.samsung.com (unknown [182.198.249.139]) by
        eucas1p1.samsung.com (KnoxPortal) with ESMTPA id
        20191120135541eucas1p14033edaac4d015cf1d2110d9d08f2f05~Y43BU-1Z11396813968eucas1p1J;
        Wed, 20 Nov 2019 13:55:41 +0000 (GMT)
Received: from eusmgms2.samsung.com (unknown [182.198.249.180]) by
        eusmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20191120135541eusmtrp2ddfbf473e86e56b177ea1f8cccf43255~Y43BT9YiH2368923689eusmtrp2u;
        Wed, 20 Nov 2019 13:55:41 +0000 (GMT)
X-AuditID: cbfec7f5-4f7ff70000001116-bf-5dd545dddafb
Received: from eusmtip2.samsung.com ( [203.254.199.222]) by
        eusmgms2.samsung.com (EUCPMTA) with SMTP id B2.C9.04117.DD545DD5; Wed, 20
        Nov 2019 13:55:41 +0000 (GMT)
Received: from AMDC3218.digital.local (unknown [106.120.51.18]) by
        eusmtip2.samsung.com (KnoxPortal) with ESMTPA id
        20191120135540eusmtip2b25ecf2cc120446234e9564f336be0aa~Y43Axpi2z3128231282eusmtip2K;
        Wed, 20 Nov 2019 13:55:40 +0000 (GMT)
From:   Kamil Konieczny <k.konieczny@samsung.com>
To:     linux-kernel@vger.kernel.org
Cc:     Kamil Konieczny <k.konieczny@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Vladimir Zapolskiy <vz@mleia.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org, linux-samsung-soc@vger.kernel.org
Subject: [RESEND PATCH] MAINTAINERS: update my e-mail address
Date:   Wed, 20 Nov 2019 14:55:27 +0100
Message-Id: <20191120135527.7636-1-k.konieczny@samsung.com>
X-Mailer: git-send-email 2.24.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrDKsWRmVeSWpSXmKPExsWy7djPc7p3Xa/GGhyabWKxccZ6Vos551tY
        LLpfyVgs+DSD1eL8+Q3sFvfv/WSyuLxrDpvFjPP7mCz+/2pmduD02LLyJpPHtgOqHptWdbJ5
        /Fs4hcWjb8sqRo/Pm+QC2KK4bFJSczLLUov07RK4MmYfbmUtmMNV0dHVw97A+Iiji5GTQ0LA
        RGLz5t8sXYxcHEICKxglln86wAjhfGGUaFzRyQThfGaUmPl5FQtMy8/GHlaIxHJGidbWl6xw
        LetfgzicHGwC+hIHz54E6xARUJDY3PsMrIhZ4CSTxPHt/xlBEsICthJf76wBs1kEVCUmretj
        ArF5Bawl5k37AdTAAbROXmLOWw2IsKDEyZlPwGYyA4Wbt85mBpkpIdDNLvFw4QWo81wkuo73
        s0LYwhKvjm9hh7BlJP7vnM8EYZdLPF3Yxw7R3MIo8aD9I1SztcTh4xfBFjMLaEqs36UPEXaU
        WN62ig3iHj6JG28FIW7gk5i0bTozRJhXoqNNCKJaVeL5qR6oTdISXf/XQV3jIfG8sRUsLiQQ
        K/Fq1lzmCYwKs5B8NgvJZ7MQbljAyLyKUTy1tDg3PbXYOC+1XK84Mbe4NC9dLzk/dxMjMA2d
        /nf86w7GfX+SDjEKcDAq8fAKqF2NFWJNLCuuzD3EKMHBrCTCu+f6lVgh3pTEyqrUovz4otKc
        1OJDjNIcLErivNUMD6KFBNITS1KzU1MLUotgskwcnFINjOx2FWui1HqO3F2zZ71SpsCOonOK
        q5z7P/37utBkasSnj4u8mi992L5t0uHV5vyMHn80uwsmMpTvW2K2b7/AqTNbRL/m/i5e+a2s
        52q86ZcNIVdYuduzr7mE/Tt6Udpyz2z+w0kP9t87HKb8lzf6b8y6Tx2cE9bstTVfeFV+79Yl
        9ay5r0XajW8rsRRnJBpqMRcVJwIAGRe80D8DAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpikeLIzCtJLcpLzFFi42I5/e/4Pd27rldjDfpXClhsnLGe1WLO+RYW
        i+5XMhYLPs1gtTh/fgO7xf17P5ksLu+aw2Yx4/w+Jov/v5qZHTg9tqy8yeSx7YCqx6ZVnWwe
        /xZOYfHo27KK0ePzJrkAtig9m6L80pJUhYz84hJbpWhDCyM9Q0sLPSMTSz1DY/NYKyNTJX07
        m5TUnMyy1CJ9uwS9jNmHW1kL5nBVdHT1sDcwPuLoYuTkkBAwkfjZ2MPaxcjFISSwlFHi+bV+
        doiEtETj6dVMELawxJ9rXWwQRZ8YJY5/PcAMkmAT0Jc4ePYkC4gtIqAgsbn3GdgkZoHzTBIT
        P05iBEkIC9hKfL2zBsxmEVCVmLSuD2wqr4C1xLxpP4AaOIA2yEvMeasBERaUODnzCdhMZqBw
        89bZzBMY+WYhSc1CklrAyLSKUSS1tDg3PbfYSK84Mbe4NC9dLzk/dxMjMPy3Hfu5ZQdj17vg
        Q4wCHIxKPLy7la/GCrEmlhVX5h5ilOBgVhLh3XP9SqwQb0piZVVqUX58UWlOavEhRlOgWycy
        S4km5wNjM68k3tDU0NzC0tDc2NzYzEJJnLdD4GCMkEB6YklqdmpqQWoRTB8TB6dUA6P6/AN7
        Yu/YmOkrRtTY853/zem3Rzjy2YcCQ6XU9mvbW3jjvi+OOTt9Ju+cP/dvRNqlH4g7YPXYMlA8
        S+Wm4qvPmxxE+bYoGh/Iif3BXeK5w+bj30uZlnXZx0TN9gptjH/BeGWNp9SEYJ6Ft5ZnRrX2
        vOZ59WPligweo3d2rTrbXwfLWWp9vKrEUpyRaKjFXFScCABpOT4ElQIAAA==
X-CMS-MailID: 20191120135541eucas1p14033edaac4d015cf1d2110d9d08f2f05
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-RootMTR: 20191120135541eucas1p14033edaac4d015cf1d2110d9d08f2f05
X-EPHeader: CA
CMS-TYPE: 201P
X-CMS-RootMailID: 20191120135541eucas1p14033edaac4d015cf1d2110d9d08f2f05
References: <CGME20191120135541eucas1p14033edaac4d015cf1d2110d9d08f2f05@eucas1p1.samsung.com>
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Update my e-mail address to @samsung.com in maintainers.
Add also map in .mailmap to new e-mail.

Signed-off-by: Kamil Konieczny <k.konieczny@samsung.com>
---
 .mailmap    | 1 +
 MAINTAINERS | 2 +-
 2 files changed, 2 insertions(+), 1 deletion(-)

diff --git a/.mailmap b/.mailmap
index fd6219293057..3727a0066bb1 100644
--- a/.mailmap
+++ b/.mailmap
@@ -133,6 +133,7 @@ Juha Yrjola <at solidboot.com>
 Juha Yrjola <juha.yrjola@nokia.com>
 Juha Yrjola <juha.yrjola@solidboot.com>
 Julien Thierry <julien.thierry.kdev@gmail.com> <julien.thierry@arm.com>
+Kamil Konieczny <k.konieczny@samsung.com> <k.konieczny@partner.samsung.com>
 Kay Sievers <kay.sievers@vrfy.org>
 Kenneth W Chen <kenneth.w.chen@intel.com>
 Konstantin Khlebnikov <koct9i@gmail.com> <k.khlebnikov@samsung.com>
diff --git a/MAINTAINERS b/MAINTAINERS
index e4f170d8bc29..0caf7560c782 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -14294,7 +14294,7 @@ F:	drivers/media/i2c/s5k5baf.c
 SAMSUNG S5P Security SubSystem (SSS) DRIVER
 M:	Krzysztof Kozlowski <krzk@kernel.org>
 M:	Vladimir Zapolskiy <vz@mleia.com>
-M:	Kamil Konieczny <k.konieczny@partner.samsung.com>
+M:	Kamil Konieczny <k.konieczny@samsung.com>
 L:	linux-crypto@vger.kernel.org
 L:	linux-samsung-soc@vger.kernel.org
 S:	Maintained
-- 
2.24.0

