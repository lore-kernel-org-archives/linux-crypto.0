Return-Path: <SRS0=SwA+=7B=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DD6B4C433DF
	for <linux-crypto@archiver.kernel.org>; Tue, 19 May 2020 21:26:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B408D20823
	for <linux-crypto@archiver.kernel.org>; Tue, 19 May 2020 21:26:31 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="N7IZ1+XS"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727831AbgESV0b (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 19 May 2020 17:26:31 -0400
Received: from mailout2.w1.samsung.com ([210.118.77.12]:45563 "EHLO
        mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727833AbgESV0Y (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 19 May 2020 17:26:24 -0400
Received: from eucas1p1.samsung.com (unknown [182.198.249.206])
        by mailout2.w1.samsung.com (KnoxPortal) with ESMTP id 20200519212622euoutp02730512950293228a6f53c8c15160c3c8~QixMMjn292168721687euoutp02K
        for <linux-crypto@vger.kernel.org>; Tue, 19 May 2020 21:26:22 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.w1.samsung.com 20200519212622euoutp02730512950293228a6f53c8c15160c3c8~QixMMjn292168721687euoutp02K
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1589923582;
        bh=N/YA46ODGLlxDL+bldxjnjkd6gAUd4l+W7uUZ4+8mjA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=N7IZ1+XSIEc0+62ryPpHUXzd0heipsyVQ0dkcfzgbscuseoNoi/1W6A5OMxygUvoz
         gGVz/VRdDGT5B3uwP1IaPuZLr+xUrMQ5nC1d6xviRxNHBnYuamfvmLEH5irA1yWsCe
         FarzRJ93gzS8dHrHTZikamPUbOyPM+BcVAj/Fui4=
Received: from eusmges3new.samsung.com (unknown [203.254.199.245]) by
        eucas1p1.samsung.com (KnoxPortal) with ESMTP id
        20200519212621eucas1p1b01882c9c94ab188151dbd94fe920c74~QixLYgw792659226592eucas1p1d;
        Tue, 19 May 2020 21:26:21 +0000 (GMT)
Received: from eucas1p2.samsung.com ( [182.198.249.207]) by
        eusmges3new.samsung.com (EUCPMTA) with SMTP id EE.EC.60698.DFE44CE5; Tue, 19
        May 2020 22:26:21 +0100 (BST)
Received: from eusmtrp2.samsung.com (unknown [182.198.249.139]) by
        eucas1p1.samsung.com (KnoxPortal) with ESMTPA id
        20200519212621eucas1p13279db41d930b69e115972463c994a37~QixK7ptMf2557025570eucas1p1X;
        Tue, 19 May 2020 21:26:21 +0000 (GMT)
Received: from eusmgms1.samsung.com (unknown [182.198.249.179]) by
        eusmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20200519212620eusmtrp274dffa962a5015db7ae6426090390416~QixK4Em2R1118011180eusmtrp2Z;
        Tue, 19 May 2020 21:26:20 +0000 (GMT)
X-AuditID: cbfec7f5-a29ff7000001ed1a-23-5ec44efdac5c
Received: from eusmtip1.samsung.com ( [203.254.199.221]) by
        eusmgms1.samsung.com (EUCPMTA) with SMTP id D4.A7.08375.CFE44CE5; Tue, 19
        May 2020 22:26:20 +0100 (BST)
Received: from localhost (unknown [106.120.51.46]) by eusmtip1.samsung.com
        (KnoxPortal) with ESMTPA id
        20200519212620eusmtip12841b5e28e124c49be41bb02b995206c~QixKt8VyS2107921079eusmtip19;
        Tue, 19 May 2020 21:26:20 +0000 (GMT)
From:   =?UTF-8?q?=C5=81ukasz=20Stelmach?= <l.stelmach@samsung.com>
To:     Matt Mackall <mpm@selenic.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ray Jui <rjui@broadcom.com>,
        Scott Branden <sbranden@broadcom.com>,
        bcm-kernel-feedback-list@broadcom.com,
        Kukjin Kim <kgene@kernel.org>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Markus Elfring <elfring@users.sourceforge.net>,
        Matthias Brugger <mbrugger@suse.com>,
        Stefan Wahren <wahrenst@gmx.net>, linux-crypto@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org,
        Stephan Mueller <smueller@chronox.de>
Cc:     Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        =?UTF-8?q?=C5=81ukasz=20Stelmach?= <l.stelmach@samsung.com>
Subject: [PATCH v2 2/2] hwrng: exynos - Set the quality value
Date:   Tue, 19 May 2020 23:25:52 +0200
Message-Id: <20200519212552.11671-3-l.stelmach@samsung.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200519212552.11671-1-l.stelmach@samsung.com>
MIME-Version: 1.0
Organization: Samsung R&D Institute Poland
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA02Sa1CMYRTHPfte9q2x9dpKx2pklj5kKGHMY8RgzHi/kNH4YoiVVxptmd2S
        jFEjSmFrQrQqkWZXd1uWLsK2lTS1RrmNS9glMpax20i1Lu27hm+//3n+55z/mXkYQnqcljHx
        icm8KlGRIKe9SWPnD8sC1wZzzMI+3QzsKugU42vn6yhcc6qDxJYcHYHH7GYxziyvo/GJ4SCc
        Z/1EYIulXoyfmfQIG6yPKTz46ocI9zcX0/i8pU2Ey07bKFxm1CD8rqiBxvYqG8Jne2pI3HUv
        h1jlz42PFSBOO9hLc98GBkRck/almCs33KY5450QzlCZQ3O3S6rFXMOVdE7TWIk4zcd6xNU1
        PiK5I/ezKc5hmLXRZ4t35C4+IX4/rwpfucN7T8mDAWLfL/EBZ8uoKAM56VzkxQC7BN5WlVK5
        yJuRsnoE3ZpCQhBOBPWFWrEgHAhKj36h/rYM3jzjcekQtPaeIAUxhKDq7nu3i2ZXQ17FPTf7
        s7UUfK/gJ5lgU+HYG5u77seuAFdRv5tJNgROPhhys4RdDp+uPiaFbcGQrbvhDuvFRoJ5dIQW
        PNOgu8jm9viy86D6yBNSmB8MmdcvEELvAAOajhSB18JEZqHnAj8Y7moUCxwEv5ouinIR84fT
        4XTB0slbgD2JwFg86smwHF70jdGTHoINhbrmcKG8GqqttYTQ6gNPP08TEvhAgfGcpyyB41lS
        wT0XavNaPQNlcGpYj/KRXPvfLdr/8mv/7SpDRCUK5FPUyjhevTiRTw1TK5TqlMS4sNgkpQH9
        +Z89P7tGbqK2iZ0mxDJIPlXytKk9Rkop9qvTlCYEDCH3l+R/MMVIJbsUaQd5VdJ2VUoCrzah
        mQwpD5Qsvvxxm5SNUyTze3l+H6/6+ypivGQZyFcxkTzS/21+uwtFXJ+yIKK4ZaXjudGqdK0/
        nNWUeS3gYZRTP+VutK53c2xDaPx48O7ZO4deZqTroxdpcX/1nPYRxxr7rSjfcFnw9BD7a61t
        nSbGYAn/ujX165qSt/61YfWbQmWX4jrvzDf/dHT4dR+KX7Leao8NWBZlXlVJnUNOOaneo4iY
        R6jUit+0kkicmwMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprFKsWRmVeSWpSXmKPExsVy+t/xu7p//I7EGfx/Ymnxd9IxdouNM9az
        WqztPcpicb5zObPFr3dH2C2aF69ns+h+JWPR//g1s8X58xvYLW4eWsFosenxNVaL+/d+Mllc
        3jWHzWLG+X1MFgsmP2G1WLCtj9Hi6czNbBbvVj9htJh6ei2LxfETncwOIh6/f01i9Jh1/yyb
        x6crV5g8ds66y+6xeNN+No9tB1Q9Nq3qZPPYP3cNu8fmJfUefVtWMXr0vdzA6LF+y1UWj6ZT
        7awenzfJBfBF6dkU5ZeWpCpk5BeX2CpFG1oY6RlaWugZmVjqGRqbx1oZmSrp29mkpOZklqUW
        6dsl6GXMvXCFueA/e8WX3T+YGhi/sHUxcnJICJhI3N8xhbmLkYtDSGApo8TNHw8Yuxg5gBJS
        EivnpkPUCEv8udbFBlHzlFHi6IqfLCAJNgFHif6lJ1hBEiICe1gldt/oZAJJMAuUS7Q+fMIK
        YgsL2Er8nXkZzGYRUJXoufAczOYVsJZ4vfIaC8QGeYn25dvBLuIUsJE48uMrmC0kkCsx8c9Z
        qHpBiZMzn7CAHMcsoC6xfp4QSJhfQEtiTdN1Foi18hLNW2czT2AUmoWkYxZCxywkVQsYmVcx
        iqSWFuem5xYb6hUn5haX5qXrJefnbmIEpottx35u3sF4aWPwIUYBDkYlHl6DPYfjhFgTy4or
        cw8xSnAwK4nwTnhxKE6INyWxsiq1KD++qDQntfgQoynQmxOZpUST84GpLK8k3tDU0NzC0tDc
        2NzYzEJJnLdD4GCMkEB6YklqdmpqQWoRTB8TB6dUA6PH9Psbp7Ko73na4mv383qVXmnWwksP
        HlZN3RHTV8/3NpCvM+/dra8t2x/k38pT2/Oi+7D1m7q5xid0EzbtPnPVVfbBAU3WLp+2bk1G
        M7VXq3/5XVqm/8Qo8IJiTEzG/E+O9f1hPw59/3C977TGg+aITov0D0GyO7RPeDWK+q1+qlWY
        tykzwkKJpTgj0VCLuag4EQC9oUcTLQMAAA==
X-CMS-MailID: 20200519212621eucas1p13279db41d930b69e115972463c994a37
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-RootMTR: 20200519212621eucas1p13279db41d930b69e115972463c994a37
X-EPHeader: CA
CMS-TYPE: 201P
X-CMS-RootMailID: 20200519212621eucas1p13279db41d930b69e115972463c994a37
References: <20200514190734.32746-1-l.stelmach@samsung.com>
        <20200519212552.11671-1-l.stelmach@samsung.com>
        <CGME20200519212621eucas1p13279db41d930b69e115972463c994a37@eucas1p1.samsung.com>
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

The value was estimaded with ea_iid[1] using on 10485760 bytes read from
the RNG via /dev/hwrng. The min-entropy value calculated using the most
common value estimate (NIST SP 800-90P[2], section 6.3.1) was 7.489627.

[1] https://github.com/usnistgov/SP800-90B_EntropyAssessment
[2] https://csrc.nist.gov/publications/detail/sp/800-90b/final

Signed-off-by: Łukasz Stelmach <l.stelmach@samsung.com>
---
 drivers/char/hw_random/exynos-trng.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/char/hw_random/exynos-trng.c b/drivers/char/hw_random/exynos-trng.c
index 8e1fe3f8dd2d..2a5896122001 100644
--- a/drivers/char/hw_random/exynos-trng.c
+++ b/drivers/char/hw_random/exynos-trng.c
@@ -123,6 +123,7 @@ static int exynos_trng_probe(struct platform_device *pdev)
 	trng->rng.init = exynos_trng_init;
 	trng->rng.read = exynos_trng_do_read;
 	trng->rng.priv = (unsigned long) trng;
+	trng->rng.quality = 900;
 
 	platform_set_drvdata(pdev, trng);
 	trng->dev = &pdev->dev;
-- 
2.26.2

