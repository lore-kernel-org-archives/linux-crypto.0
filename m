Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-19.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B0C54C433ED
	for <linux-crypto@archiver.kernel.org>; Wed,  5 May 2021 18:29:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7CFCB613B3
	for <linux-crypto@archiver.kernel.org>; Wed,  5 May 2021 18:29:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234553AbhEESaS (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 5 May 2021 14:30:18 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:43680 "EHLO
        mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234180AbhEESaR (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 5 May 2021 14:30:17 -0400
Received: from eucas1p2.samsung.com (unknown [182.198.249.207])
        by mailout1.w1.samsung.com (KnoxPortal) with ESMTP id 20210505182919euoutp01fc695dd9522c08bdecb996049e9d4e72~8Pxz4T7Mr1687016870euoutp01A
        for <linux-crypto@vger.kernel.org>; Wed,  5 May 2021 18:29:19 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.w1.samsung.com 20210505182919euoutp01fc695dd9522c08bdecb996049e9d4e72~8Pxz4T7Mr1687016870euoutp01A
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1620239359;
        bh=oVEQziOY+kXo+vyFMVyn0DaTqxIxQdU0Ku2D15pzPhY=;
        h=From:To:Cc:Subject:Date:References:From;
        b=pyu4k/3tZ3pWUwIUxmiXti+W0wGcQhC/9oe7gw0kj24GLWmOKfU269XWTBfDUxisQ
         ZwFsq1dzDOrIfQPXwMyrslQdKZDHGcISfhh+oPsdlEZxyGx5pkUfOQbE7aRPmyvbJc
         LbWVuKM892hiwEs3Q2L8iBfafeJPpTwJet4g8PUU=
Received: from eusmges1new.samsung.com (unknown [203.254.199.242]) by
        eucas1p2.samsung.com (KnoxPortal) with ESMTP id
        20210505182919eucas1p2c19b3c886e883bcafe5021335a2c58c2~8PxzjV3bn2241322413eucas1p28;
        Wed,  5 May 2021 18:29:19 +0000 (GMT)
Received: from eucas1p2.samsung.com ( [182.198.249.207]) by
        eusmges1new.samsung.com (EUCPMTA) with SMTP id 8A.E6.09452.FF3E2906; Wed,  5
        May 2021 19:29:19 +0100 (BST)
Received: from eusmtrp1.samsung.com (unknown [182.198.249.138]) by
        eucas1p1.samsung.com (KnoxPortal) with ESMTPA id
        20210505182918eucas1p18a11263e5d214e3356ac65d79504e430~8PxytjLWH2149121491eucas1p1s;
        Wed,  5 May 2021 18:29:18 +0000 (GMT)
Received: from eusmgms2.samsung.com (unknown [182.198.249.180]) by
        eusmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20210505182918eusmtrp1e1f8a821222adcd91ffb99da175a5325~8PxyqeMlv0828408284eusmtrp1C;
        Wed,  5 May 2021 18:29:18 +0000 (GMT)
X-AuditID: cbfec7f2-ab7ff700000024ec-2c-6092e3ff52f1
Received: from eusmtip1.samsung.com ( [203.254.199.221]) by
        eusmgms2.samsung.com (EUCPMTA) with SMTP id 1B.61.08696.EF3E2906; Wed,  5
        May 2021 19:29:18 +0100 (BST)
Received: from localhost (unknown [106.120.51.46]) by eusmtip1.samsung.com
        (KnoxPortal) with ESMTPA id
        20210505182918eusmtip16ca47f8c61710aa88104b0177f7601c5~8PxycSDaL2219822198eusmtip1g;
        Wed,  5 May 2021 18:29:18 +0000 (GMT)
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
Subject: [PATCH v3] hwrng: exynos - Fix runtime PM imbalance on error
Date:   Wed,  5 May 2021 20:29:14 +0200
Message-Id: <20210505182914.13394-1-l.stelmach@samsung.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Organization: Samsung R&D Institute Poland
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA01SaUwTYRDNt7uUpUlxKUYmQD0a+SGJgEbNJihKorGJJuKBP4xEVlkBobW2
        okgUiQoaRapYFVutqChXEVpwRdCi9aBqFOsBSEBpSiIWRAUP8KDSLkb/zXvz3sy8ZEhcfMkn
        mExVbGdVCiZdKhAS3IORlpluZ2FilMskoE1F1T70EVcobfowjNGvrWWINjtbfei3b0Yw+kXD
        WQFd1GLB6Kp7Xb50MVeAFgllupyjAhl3O0xWW7JXVlBXgWQF72uQbMg8OU6wTjg/iU1P3cGq
        ImMShSntr3Jx5UFhZpHdjeeg++Rh5EcCNQdOfjMQh5GQFFNlCB5pcsfBFwS2CgPGgyEEOtM1
        4q/la/cnX75RiqDYeAfnwTsEWsd53KMSULGguWzz8TQmUoUYlBuGkQfglAXBjTdaryqQWgJP
        Te3IUxNUGIwWDXh5ERUNVqMW8fumwMHS6wKeD4CHZ3q8d0ygwsG4r81b42Oa/df03jOA6iTh
        bk/rmJkcA4uh6mcaPycQXM11vnwdCo9P5BO8ZC+cKJzHW/MRcGeHx3NGQ+fTHwKPBqdmQHVD
        JE/HwlvHF1/e6g/tHwL4C/yhkDuN87QIDuWJefV0uKq5OT4wGI66ysZDyeC5swc7hqbp/sul
        +y+L7t/eYoRXoCA2Qy1PZtWzFOzOCDUjV2cokiM2bZWb0dgfPR5tHqxH51yfI6wII5EVAYlL
        J4qUVZpEsSiJ2ZXFqrZuUGWks2orCiEJaZCoQm/cIKaSme1sGssqWdXfLkb6Bedge37N7Teu
        /mbPyBJ3NcRufu5Iq1yQST1RJFy5ZRg9MEMbqqpdbhMtrX+wbNVPjaUzaxJXLxdJfvdEm4eC
        SrLLQ0Lml+fts00uy934mbE4+vzkBb3KWH8UZr7ZpO/YLXU3cs+sV+s0BqbmovYitsx0abBv
        5ZLKvDhld1V4c3PT95T4/OCB45nc3GOGiF0lTW2rmdst6tbIysYV8pcXJGtLiajUtFfu2TEL
        7NWL7V1Tt+gHbEsdfi8/tkXFOHQXuBtHLGcGWoJ687q/T8Ml8QnKmdlrdvdLAsK2rN/ZmL05
        qcZe+zBb5NzkXI67++f0dQyKT0l6txEBC5niuI5ToB+REuoUZlY4rlIzfwBfSQGVtgMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprDIsWRmVeSWpSXmKPExsVy+t/xu7r/Hk9KMOhdzG2xccZ6VovuVzIW
        G9/+YLK4eWgFo8Wmx9dYLe7f+8lkcXnXHDaLGef3MVmsPXKX3WLBtj5GBy6PWQ29bB7bDqh6
        bF5S79G3ZRWjR9/LDYwenzfJBbBF6dkU5ZeWpCpk5BeX2CpFG1oY6RlaWugZmVjqGRqbx1oZ
        mSrp29mkpOZklqUW6dsl6GXcuNrKXNDOVTHj4n/mBsajHF2MnBwSAiYSXx98YO9i5OIQEljK
        KPHzzQ2WLkYOoISUxMq56RA1whJ/rnWxQdQ8ZZTYsKeLBSTBJuAo0b/0BCtIQkRgGpPE2WWn
        wBxmgX2MEvuPLmYHqRIWcJU4t/EGI4jNIqAq8W/GO2YQm1fAWuLQmimMECvkJdqXb2eDiAtK
        nJz5BOwKZgF1ifXzhEDC/AJaEmuaroMtZgYqb946m3kCo8AsJB2zEDpmIalawMi8ilEktbQ4
        Nz232EivODG3uDQvXS85P3cTIzCath37uWUH48pXH/UOMTJxMB5ilOBgVhLhLVjbnyDEm5JY
        WZValB9fVJqTWnyI0RTog4nMUqLJ+cB4ziuJNzQzMDU0MbM0MLU0M1YS5zU5siZeSCA9sSQ1
        OzW1ILUIpo+Jg1OqgYlrpsKyDTf3VfxprVhSWn+ogZU58ZLQ30/1byt3/WN5onLpg+Lrb71H
        NxrH3+I8ZKyycnkSw53nHj4Hm/1MPYzl7CVSdbW2zT4c9U8r+1p34NsKKe6L558aa37f0P+H
        1fxnav2z5CnthZNFAnmmLRVkC3oW2paQfGSebrWu3CO13PuHRLTOmEX5lQkpe/5ueKSSKaxU
        2ZWX8Le0imUas4ObUJnc+ubZvLNsWz/KTRZysnw9p6Jxe/fGr5PuBVtonz09XSL73P97MvVL
        5irf0WF01lrY3LhO9cMakyDT1S8ua1y7aWm0R+TbbfHZzj1rUj3bpn64/0zl9YGmFVFPBd1/
        /nJZ8F02z+36h1v1dUosxRmJhlrMRcWJAF3J5cUvAwAA
X-CMS-MailID: 20210505182918eucas1p18a11263e5d214e3356ac65d79504e430
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-RootMTR: 20210505182918eucas1p18a11263e5d214e3356ac65d79504e430
X-EPHeader: CA
CMS-TYPE: 201P
X-CMS-RootMailID: 20210505182918eucas1p18a11263e5d214e3356ac65d79504e430
References: <CGME20210505182918eucas1p18a11263e5d214e3356ac65d79504e430@eucas1p1.samsung.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

pm_runtime_resume_and_get() wraps around pm_runtime_get_sync() and
decrements the runtime PM usage counter in case the latter function
fails and keeps the counter balanced.

Signed-off-by: Łukasz Stelmach <l.stelmach@samsung.com>
---
Changes in v3:
  - use pm_runtime_resume_and_get()

Changes in v2:
  - removed Change-Id from the commit message

 drivers/char/hw_random/exynos-trng.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/char/hw_random/exynos-trng.c b/drivers/char/hw_random/exynos-trng.c
index 8e1fe3f8dd2d..c8db62bc5ff7 100644
--- a/drivers/char/hw_random/exynos-trng.c
+++ b/drivers/char/hw_random/exynos-trng.c
@@ -132,7 +132,7 @@ static int exynos_trng_probe(struct platform_device *pdev)
 		return PTR_ERR(trng->mem);
 
 	pm_runtime_enable(&pdev->dev);
-	ret = pm_runtime_get_sync(&pdev->dev);
+	ret = pm_runtime_resume_and_get(&pdev->dev);
 	if (ret < 0) {
 		dev_err(&pdev->dev, "Could not get runtime PM.\n");
 		goto err_pm_get;
@@ -165,7 +165,7 @@ static int exynos_trng_probe(struct platform_device *pdev)
 	clk_disable_unprepare(trng->clk);
 
 err_clock:
-	pm_runtime_put_sync(&pdev->dev);
+	pm_runtime_put_noidle(&pdev->dev);
 
 err_pm_get:
 	pm_runtime_disable(&pdev->dev);
-- 
2.26.2

