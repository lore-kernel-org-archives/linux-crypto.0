Return-Path: <SRS0=jX8O=RE=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2D307C43381
	for <linux-crypto@archiver.kernel.org>; Fri,  1 Mar 2019 14:03:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BF1DE20851
	for <linux-crypto@archiver.kernel.org>; Fri,  1 Mar 2019 14:03:25 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="MFobuByC"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732808AbfCAODZ (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 1 Mar 2019 09:03:25 -0500
Received: from mailout1.w1.samsung.com ([210.118.77.11]:42091 "EHLO
        mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728017AbfCAODY (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 1 Mar 2019 09:03:24 -0500
Received: from eucas1p1.samsung.com (unknown [182.198.249.206])
        by mailout1.w1.samsung.com (KnoxPortal) with ESMTP id 20190301140323euoutp01a88b8462fad8f40fbc4577ec46a122cd~H2qYHWooM0525005250euoutp01P
        for <linux-crypto@vger.kernel.org>; Fri,  1 Mar 2019 14:03:23 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.w1.samsung.com 20190301140323euoutp01a88b8462fad8f40fbc4577ec46a122cd~H2qYHWooM0525005250euoutp01P
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1551449003;
        bh=bQPqFzz2fmJkWr/uClmGTOF0FqSo0MUh9CDopv6RO/4=;
        h=From:To:Cc:Subject:Date:References:From;
        b=MFobuByCDPg2mTEMh2mlLga4IwKi1TqWnH47fepvsgQZKMQEpFTh6np+4eM1Bgbew
         RO34rWsDDV/WkP5SNVwZ0FAmjHbePE7dBXJtK85fqYhLyJtRoz4APB2EdbM337qO6L
         oAHuTuvmMScXCZH3TSXKktPuvmggCOghhs+0wins=
Received: from eusmges3new.samsung.com (unknown [203.254.199.245]) by
        eucas1p1.samsung.com (KnoxPortal) with ESMTP id
        20190301140322eucas1p18c2e5f30802fd7ad16854b6eb521b7fb~H2qXqMMD62620126201eucas1p1O;
        Fri,  1 Mar 2019 14:03:22 +0000 (GMT)
Received: from eucas1p2.samsung.com ( [182.198.249.207]) by
        eusmges3new.samsung.com (EUCPMTA) with SMTP id BD.88.04806.AAB397C5; Fri,  1
        Mar 2019 14:03:22 +0000 (GMT)
Received: from eusmtrp2.samsung.com (unknown [182.198.249.139]) by
        eucas1p2.samsung.com (KnoxPortal) with ESMTPA id
        20190301140321eucas1p2bf17a6e35d29e8d5f582a2d99fbf4c83~H2qW0Yp_o3213732137eucas1p2K;
        Fri,  1 Mar 2019 14:03:21 +0000 (GMT)
Received: from eusmgms2.samsung.com (unknown [182.198.249.180]) by
        eusmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20190301140321eusmtrp2251ca495ae042e85682659bb93a9cb62~H2qWlrb9n1128711287eusmtrp2j;
        Fri,  1 Mar 2019 14:03:21 +0000 (GMT)
X-AuditID: cbfec7f5-34dff700000012c6-ec-5c793baa509d
Received: from eusmtip2.samsung.com ( [203.254.199.222]) by
        eusmgms2.samsung.com (EUCPMTA) with SMTP id 85.09.04128.9AB397C5; Fri,  1
        Mar 2019 14:03:21 +0000 (GMT)
Received: from AMDC3218.DIGITAL.local (unknown [106.120.51.18]) by
        eusmtip2.samsung.com (KnoxPortal) with ESMTPA id
        20190301140321eusmtip2e3d60231d4f8627f339fede325a1f4ae~H2qWCTIkC0829808298eusmtip2n;
        Fri,  1 Mar 2019 14:03:21 +0000 (GMT)
From:   Kamil Konieczny <k.konieczny@partner.samsung.com>
To:     k.konieczny@partner.samsung.com
Cc:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Vladimir Zapolskiy <vz@mleia.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        linux-crypto@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] crypto: s5p-sss - fix AES support for Exynos5433
Date:   Fri,  1 Mar 2019 15:02:54 +0100
Message-Id: <20190301140254.19341-1-k.konieczny@partner.samsung.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrMKsWRmVeSWpSXmKPExsWy7djP87qrrCtjDHZck7fYOGM9q8Wc8y0s
        Ft2vZCz69v1ntDh/fgO7xf17P5ksLu+aw2Yx4/w+Jou1R+6yW/z/1czswOWxZeVNJo9tB1Q9
        Nq3qZPP4t3AKi8fBd3uYPPq2rGL0+LxJLoA9issmJTUnsyy1SN8ugSvjzc7gggWcFZ2vr7A3
        MD5l72Lk4JAQMJGYuEWoi5GLQ0hgBaPElH0rWCGcL4wSGxq/MUM4nxklmk9eZuxi5ATruHzw
        JlRiOaPExNudLHAt706/BatiEzCXeLT9DBOILSKgLDH53nRmEJtZ4DWTRO+/LBBbWMBRYuXs
        BewgNouAqsTtntdg9bwCLhKTru5jhdgmL/FzxSZ2iLigxMmZT1gg5shLNG+dDXaFhMBkdolt
        yx+xQTS4SJyZ3c0EYQtLvDq+hR3ClpH4v3M+VLxcYvfWZ+wQzS2MEnMnL4JKWEscPn6RFRQy
        zAKaEut36UOEHSXWvGljgwQYn8SNt4IQN/BJTNoG8hdImFeio00IolpXYt7/M1DnS0t0/V/H
        ClHiIXH1rCtIWEggVuLw6+eMExgVZiF5bBaSx2YhnLCAkXkVo3hqaXFuemqxcV5quV5xYm5x
        aV66XnJ+7iZGYFI6/e/41x2M+/4kHWIU4GBU4uGt0KqMEWJNLCuuzD3EKMHBrCTCO8MSKMSb
        klhZlVqUH19UmpNafIhRmoNFSZy3muFBtJBAemJJanZqakFqEUyWiYNTqoFxfsTyPY++3Pxx
        +FY2U+kOd85jKReXM5ncu1UQ6XZr2Z7PDtM/ulWa9r2a57X0nahKWZswB9fnyLTX0stnO+jM
        //nsBFfLr5frJ2UvfXcx8FvYzb4Ixr+XPgUdr2bxjfkzrWaT2dMP/9RFuL4ucEmf+2vWOZmQ
        LsM/yrdspytvvMr2T90lOMjpjhJLcUaioRZzUXEiAE1WWvVGAwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupmkeLIzCtJLcpLzFFi42I5/e/4Pd2V1pUxBi+nKlpsnLGe1WLO+RYW
        i+5XMhZ9+/4zWpw/v4Hd4v69n0wWl3fNYbOYcX4fk8XaI3fZLf7/amZ24PLYsvImk8e2A6oe
        m1Z1snn8WziFxePguz1MHn1bVjF6fN4kF8AepWdTlF9akqqQkV9cYqsUbWhhpGdoaaFnZGKp
        Z2hsHmtlZKqkb2eTkpqTWZZapG+XoJfxZmdwwQLOis7XV9gbGJ+ydzFyckgImEhcPniTGcQW
        EljKKLHpRCVEXFqi8fRqJghbWOLPtS62LkYuoJpPjBJ3PzwCa2YTMJd4tP0MWJGIgLLE5HvT
        mUGKmAU+Mkk8PvmaFSQhLOAosXL2ArAGFgFVids9r8EaeAVcJCZd3ccKsUFe4ueKTewQcUGJ
        kzOfsIDYzEDx5q2zmScw8s1CkpqFJLWAkWkVo0hqaXFuem6xkV5xYm5xaV66XnJ+7iZGYERs
        O/Zzyw7GrnfBhxgFOBiVeHgrtCpjhFgTy4orcw8xSnAwK4nwzrAECvGmJFZWpRblxxeV5qQW
        H2I0BTp2IrOUaHI+MFrzSuINTQ3NLSwNzY3Njc0slMR5zxtURgkJpCeWpGanphakFsH0MXFw
        SjUwBlubqt4TCEz2sXrVtPHD9ZMic8yTJBo/7kvbsoVrkyBf4e7gRYoPPH8Ffq5Ln3Vu6e3z
        QYrrd7VHuZld+mfryTHFbfWU1niWZ/yLMn8k/I6O++Rezb01c59LyvK1axILcyLU1sco7Uy3
        CVpTuyP1zLxw1c/8vDmbORKycmJl/16uvLGhK+WzEktxRqKhFnNRcSIAy/QkKp4CAAA=
X-CMS-MailID: 20190301140321eucas1p2bf17a6e35d29e8d5f582a2d99fbf4c83
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-RootMTR: 20190301140321eucas1p2bf17a6e35d29e8d5f582a2d99fbf4c83
X-EPHeader: CA
CMS-TYPE: 201P
X-CMS-RootMailID: 20190301140321eucas1p2bf17a6e35d29e8d5f582a2d99fbf4c83
References: <CGME20190301140321eucas1p2bf17a6e35d29e8d5f582a2d99fbf4c83@eucas1p2.samsung.com>
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Commit 0918f18c7179 ("crypto: s5p - add AES support for Exynos5433")
introduced bug in dereferencing clk_names[1] on platforms different from
Exynos5433. On Exynos board XU3 call trace is:

"Unable to handle kernel paging request at virtual address 00004000"
(strcmp) from [<c0774014>] (of_property_match_string+0x58/0xd0)
...
(devm_clk_get) from [<c075c248>] (s5p_aes_probe+0xd4/0x4a0)
(s5p_aes_probe) from [<c059dbc4>] (platform_drv_probe+0x6c/0xa4)

Fix this by setting array clk_names size to 2.

Fixes: 0918f18c7179 ("crypto: s5p - add AES support for Exynos5433")
Reported-by: Krzysztof Kozlowski <krzk@kernel.org>
Signed-off-by: Kamil Konieczny <k.konieczny@partner.samsung.com>
---
 drivers/crypto/s5p-sss.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/s5p-sss.c b/drivers/crypto/s5p-sss.c
index 3f45cc5cb94a..2fb4ae459c45 100644
--- a/drivers/crypto/s5p-sss.c
+++ b/drivers/crypto/s5p-sss.c
@@ -241,7 +241,7 @@
 struct samsung_aes_variant {
 	unsigned int			aes_offset;
 	unsigned int			hash_offset;
-	const char			*clk_names[];
+	const char			*clk_names[2];
 };
 
 struct s5p_aes_reqctx {
-- 
2.21.0

