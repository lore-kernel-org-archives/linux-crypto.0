Return-Path: <SRS0=IkvS=ZM=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNWANTED_LANGUAGE_BODY,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0A47BC432C3
	for <linux-crypto@archiver.kernel.org>; Wed, 20 Nov 2019 13:38:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C827E22529
	for <linux-crypto@archiver.kernel.org>; Wed, 20 Nov 2019 13:38:14 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="HhojbSGY"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730990AbfKTNiO (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 20 Nov 2019 08:38:14 -0500
Received: from mailout2.w1.samsung.com ([210.118.77.12]:53363 "EHLO
        mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729792AbfKTNiN (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 20 Nov 2019 08:38:13 -0500
Received: from eucas1p1.samsung.com (unknown [182.198.249.206])
        by mailout2.w1.samsung.com (KnoxPortal) with ESMTP id 20191120133811euoutp02d35d4b868a7bbbf7d171595999a67b45~Y4nvl16iq0153401534euoutp02u
        for <linux-crypto@vger.kernel.org>; Wed, 20 Nov 2019 13:38:11 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.w1.samsung.com 20191120133811euoutp02d35d4b868a7bbbf7d171595999a67b45~Y4nvl16iq0153401534euoutp02u
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1574257091;
        bh=NZ/p/16m2xALQW3+YM64mLJ35Kbe8jF90nNS0QSxIQM=;
        h=From:To:Cc:Subject:Date:References:From;
        b=HhojbSGYAr8MKMnOjHdM6O/+UTWie+iWs7Hr3PR5lU5W4ZQc0uKdT6EOvaGplOgDq
         9li00ilq8F6AjP3/yn5GwDiOV54K+lzLtx82wN/Ur6UwODOSkP0NxFt82rXZs8Smp5
         yNoGeGMEXDTbdyz5D2m8BZ7RbFraIUYjZXkHCOOg=
Received: from eusmges2new.samsung.com (unknown [203.254.199.244]) by
        eucas1p1.samsung.com (KnoxPortal) with ESMTP id
        20191120133811eucas1p1aeae67c68b1bf1cfa0ee5c35ca02693c~Y4nvPrd4z1877618776eucas1p16;
        Wed, 20 Nov 2019 13:38:11 +0000 (GMT)
Received: from eucas1p2.samsung.com ( [182.198.249.207]) by
        eusmges2new.samsung.com (EUCPMTA) with SMTP id B4.A2.04309.3C145DD5; Wed, 20
        Nov 2019 13:38:11 +0000 (GMT)
Received: from eusmtrp2.samsung.com (unknown [182.198.249.139]) by
        eucas1p1.samsung.com (KnoxPortal) with ESMTPA id
        20191120133810eucas1p1731d928e7870f8b1815d955d2e0331d7~Y4nu_78U21877618776eucas1p15;
        Wed, 20 Nov 2019 13:38:10 +0000 (GMT)
Received: from eusmgms1.samsung.com (unknown [182.198.249.179]) by
        eusmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20191120133810eusmtrp2ecb96d0be4071c7a66731ad1031b775b~Y4nu_RV8H1397513975eusmtrp2a;
        Wed, 20 Nov 2019 13:38:10 +0000 (GMT)
X-AuditID: cbfec7f4-ae1ff700000010d5-e1-5dd541c3e7cf
Received: from eusmtip1.samsung.com ( [203.254.199.221]) by
        eusmgms1.samsung.com (EUCPMTA) with SMTP id 74.68.04166.2C145DD5; Wed, 20
        Nov 2019 13:38:10 +0000 (GMT)
Received: from AMDC3218.digital.local (unknown [106.120.51.18]) by
        eusmtip1.samsung.com (KnoxPortal) with ESMTPA id
        20191120133810eusmtip1a990f6ba622461c83c81e9a136dd478f~Y4nunjxkG1799317993eusmtip1V;
        Wed, 20 Nov 2019 13:38:10 +0000 (GMT)
From:   Kamil Konieczny <k.konieczny@samsung.com>
To:     linux-kernel@vger.kernel.org
Cc:     Kamil Konieczny <k.konieczny@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Chanwoo Choi <cw00.choi@samsung.com>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        linux-crypto@vger.kernel.org, linux-samsung-soc@vger.kernel.org
Subject: [PATCH] MAINTAINERS: update my e-mail address
Date:   Wed, 20 Nov 2019 14:37:55 +0100
Message-Id: <20191120133755.6508-1-k.konieczny@samsung.com>
X-Mailer: git-send-email 2.24.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprIKsWRmVeSWpSXmKPExsWy7djP87qHHa/GGsy+yW6xccZ6VovrX56z
        Wiz4NIPV4vz5DewW9+/9ZLK4vGsOm8WM8/uYHNg9Nq3qZPPo27KK0ePzJrkA5igum5TUnMyy
        1CJ9uwSujNmHW1kL5nBVdHT1sDcwPuLoYuTgkBAwkdh1wL6LkYtDSGAFo8SJn78YIZwvjBJz
        e38zQTifGSV+LN7HAtOx9GIARHw5o8Szk8/Y4Tq6V/WydTFycrAJ6EscPHuSBcQWEVCQ2Nz7
        jBWkiFngO6PEl4ufGUESwgJmEiueP2cFsVkEVCUWnZwAtoFXwFri6aQQiGXyEnPeaoBU8AoI
        Spyc+QRsJDNQuHnrbGaQkRICr9kknq5axASSkBBwkZixsJkRwhaWeHV8CzuELSPxf+d8qJpy
        iacL+9ghmlsYJR60f2SBSFhLHD5+kRVkMbOApsT6XfoQNzhK3HwfA2HySdx4KwhxAp/EpG3T
        mSHCvBIdbUIQM1Qlnp/qgVokLdH1fx0rhO0h8WL7SrC4kECsxI9Dc1gnMCrMQvLYLCSPzUI4
        YQEj8ypG8dTS4tz01GKjvNRyveLE3OLSvHS95PzcTYzAhHL63/EvOxh3/Uk6xCjAwajEwyug
        djVWiDWxrLgy9xCjBAezkgjvnutXYoV4UxIrq1KL8uOLSnNSiw8xSnOwKInzVjM8iBYSSE8s
        Sc1OTS1ILYLJMnFwSjUwah3cJvSy+ckrz8maq1QKXsjNPch7blKt55JTPzdyl36+X1hWf3TC
        6rlSD++9+aDgrFGQuma3L0PXB4cHl2492fHPg/HWrJzLX6QP6bzLaRA8n66U2rJufW7nApHI
        Rw8XvW8Xl2m4/TpTtOxS+bpbj9f9Vl/url28rqFLnr08+VsJ65eiLYvPnFBiKc5INNRiLipO
        BABXwBm5JAMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrJLMWRmVeSWpSXmKPExsVy+t/xu7qHHK/GGnx9bWSxccZ6VovrX56z
        Wiz4NIPV4vz5DewW9+/9ZLK4vGsOm8WM8/uYHNg9Nq3qZPPo27KK0ePzJrkA5ig9m6L80pJU
        hYz84hJbpWhDCyM9Q0sLPSMTSz1DY/NYKyNTJX07m5TUnMyy1CJ9uwS9jNmHW1kL5nBVdHT1
        sDcwPuLoYuTgkBAwkVh6MaCLkYtDSGApo8SZnuOMXYycQHFpicbTq5kgbGGJP9e62CCKPjFK
        NEz5zgaSYBPQlzh49iQLiC0ioCCxufcZK0gRs8BvRok5J0EcTg5hATOJFc+fg9ksAqoSi05O
        YAHZzCtgLfF0UgjEEfISc95qgFTwCghKnJz5BGwkM1C4eets5gmMfLOQpGYhSS1gZFrFKJJa
        WpybnltsqFecmFtcmpeul5yfu4kRGMzbjv3cvIPx0sbgQ4wCHIxKPLwCaldjhVgTy4orcw8x
        SnAwK4nw7rl+JVaINyWxsiq1KD++qDQntfgQoynQqROZpUST84GRllcSb2hqaG5haWhubG5s
        ZqEkztshcDBGSCA9sSQ1OzW1ILUIpo+Jg1OqgTHd22qbrpzRyZYfwcvtbzc+qSxpDepvrDgT
        rpr3YKHpgacOU19LR+p3e1zpy8nvCjXl6tnUVL4xbi3fmsCl/8x9yyVfGNw86vFcZ/Irb+FN
        RsFnMo7niqw+++bnj71Fcq9TszOqqtbcnefgyCzKt0LbaHXkgePbP+TV1UaYG26YznxFerns
        RCWW4oxEQy3mouJEAHq+bfx8AgAA
X-CMS-MailID: 20191120133810eucas1p1731d928e7870f8b1815d955d2e0331d7
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-RootMTR: 20191120133810eucas1p1731d928e7870f8b1815d955d2e0331d7
X-EPHeader: CA
CMS-TYPE: 201P
X-CMS-RootMailID: 20191120133810eucas1p1731d928e7870f8b1815d955d2e0331d7
References: <CGME20191120133810eucas1p1731d928e7870f8b1815d955d2e0331d7@eucas1p1.samsung.com>
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

