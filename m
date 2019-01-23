Return-Path: <SRS0=I8vn=P7=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 899ACC282C6
	for <linux-crypto@archiver.kernel.org>; Wed, 23 Jan 2019 16:56:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5046C2085A
	for <linux-crypto@archiver.kernel.org>; Wed, 23 Jan 2019 16:56:06 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="n9BdjdqC"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726140AbfAWQ4F (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 23 Jan 2019 11:56:05 -0500
Received: from mailout2.w1.samsung.com ([210.118.77.12]:36783 "EHLO
        mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726352AbfAWQzz (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 23 Jan 2019 11:55:55 -0500
Received: from eucas1p1.samsung.com (unknown [182.198.249.206])
        by mailout2.w1.samsung.com (KnoxPortal) with ESMTP id 20190123165552euoutp02549c319cb8fc0982e35cf4c15e3012f4~8iJbAm7cw1410514105euoutp02Q
        for <linux-crypto@vger.kernel.org>; Wed, 23 Jan 2019 16:55:52 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.w1.samsung.com 20190123165552euoutp02549c319cb8fc0982e35cf4c15e3012f4~8iJbAm7cw1410514105euoutp02Q
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1548262553;
        bh=9HACaCuVm3TaJmSWoPwBbGNxjVOi+0UlEM55NHEYao8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=n9BdjdqCPbIFz/rIlN2X5fBPz+n+jHlb1OqnXLFJasDxAaXyPgJCS8x58EjPZ7MEX
         uJ1Omsl6W/66I5TzOxXJIKNFdQuEmqnrjJXdidAWcWGaW1FzGy74Qv25RtK2oKrccQ
         kyXBU47o+wrdp7p5o++8ebwpUKmm2USjPImhj0Uo=
Received: from eusmges1new.samsung.com (unknown [203.254.199.242]) by
        eucas1p1.samsung.com (KnoxPortal) with ESMTP id
        20190123165552eucas1p1ba8cce25881c10e171bb8ced4a618a14~8iJaOh0he2039320393eucas1p1v;
        Wed, 23 Jan 2019 16:55:52 +0000 (GMT)
Received: from eucas1p1.samsung.com ( [182.198.249.206]) by
        eusmges1new.samsung.com (EUCPMTA) with SMTP id F0.36.04441.79C984C5; Wed, 23
        Jan 2019 16:55:51 +0000 (GMT)
Received: from eusmtrp2.samsung.com (unknown [182.198.249.139]) by
        eucas1p2.samsung.com (KnoxPortal) with ESMTPA id
        20190123165551eucas1p2bb80cfe58535b5f665271c7448cffc30~8iJZeCHov0817608176eucas1p2O;
        Wed, 23 Jan 2019 16:55:51 +0000 (GMT)
Received: from eusmgms2.samsung.com (unknown [182.198.249.180]) by
        eusmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20190123165551eusmtrp25a7ab1357b771981655a8c938ce9a1d3~8iJZPbW-C0112001120eusmtrp2K;
        Wed, 23 Jan 2019 16:55:51 +0000 (GMT)
X-AuditID: cbfec7f2-5c9ff70000001159-69-5c489c97f1a2
Received: from eusmtip1.samsung.com ( [203.254.199.221]) by
        eusmgms2.samsung.com (EUCPMTA) with SMTP id 73.58.04128.69C984C5; Wed, 23
        Jan 2019 16:55:50 +0000 (GMT)
Received: from AMDC3218.DIGITAL.local (unknown [106.120.51.18]) by
        eusmtip1.samsung.com (KnoxPortal) with ESMTPA id
        20190123165550eusmtip1246a775a7ecd3b13a56b24fbcd9c00e4~8iJYpEFl60728607286eusmtip1W;
        Wed, 23 Jan 2019 16:55:50 +0000 (GMT)
From:   Kamil Konieczny <k.konieczny@partner.samsung.com>
To:     k.konieczny@partner.samsung.com
Cc:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        linux-crypto@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>
Subject: [PATCH v2 2/3] dt-bindings: crypto: document Exynos5433 SlimSSS
Date:   Wed, 23 Jan 2019 17:55:32 +0100
Message-Id: <20190123165533.29645-3-k.konieczny@partner.samsung.com>
X-Mailer: git-send-email 2.20.0
In-Reply-To: <20190123165533.29645-1-k.konieczny@partner.samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrFKsWRmVeSWpSXmKPExsWy7djPc7rT53jEGKz5YWSxccZ6Vos551tY
        LOYfOcdq0f1KxqJv339Gi/PnN7Bb3L/3k8ni8q45bBZrj9xlt1h6/SKTReveI+wO3B5r5q1h
        9Niy8iaTx7YDqh6bVnWyeRx8t4fJo2/LKkaPz5vkAtijuGxSUnMyy1KL9O0SuDLmLGpmKrjE
        X9HROo2pgbGZt4uRk0NCwETizrqTzF2MXBxCAisYJT49fMoK4XxhlDh6ajkbhPOZUeJs3yk2
        mJZtKy8xQiSWM0rc/LmSCa7l2oOpYFVsAuYSj7afYQKxRQSUJSbfmw62hFmgg1ni7ZHZ7CAJ
        YQEPiTtfD7OC2CwCqhLHNjcwg9i8Ai4Sl7bNZ4FYJy8xbXUX0CAODk4BV4nOX2EQJYISJ2c+
        ASthBipp3jobbL6EwC52iUuHz7OB1EsAzVm9OApijLDEq+Nb2CFsGYn/O+czQdjlEru3PmOH
        6G1hlJg7eRFUwlri8PGLrCBzmAU0Jdbv0ocIO0rcnvMYajyfxI23ghAn8ElM2gbyIkiYV6Kj
        TQiiWldi3v8zrBC2tETX/3VQtofE/IfTWSYwKs5C8swsJM/MQti7gJF5FaN4amlxbnpqsWFe
        arlecWJucWleul5yfu4mRmCKOv3v+KcdjF8vJR1iFOBgVOLh5Sj0iBFiTSwrrsw9xCjBwawk
        wut60S1GiDclsbIqtSg/vqg0J7X4EKM0B4uSOG81w4NoIYH0xJLU7NTUgtQimCwTB6dUA2OD
        cEag2vVEn5u7BF51vd//yWuZwV8JkZPTzs/gjHcOsI96+/yKRbdf3DFP+/au0H8MxfsYv69R
        OtfRcrRnv7LnMhcZXWbdo4U9ET/ui3/9euvXhk5hpjVO6pEbWnrWd/50+VVUYcrQuOvH3km5
        mq79ha05kXXiLTv/sPnkTjSW2LRScfsFdyWW4oxEQy3mouJEAJmhDyhNAwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrBIsWRmVeSWpSXmKPExsVy+t/xu7rT5njEGCxdZ2WxccZ6Vos551tY
        LOYfOcdq0f1KxqJv339Gi/PnN7Bb3L/3k8ni8q45bBZrj9xlt1h6/SKTReveI+wO3B5r5q1h
        9Niy8iaTx7YDqh6bVnWyeRx8t4fJo2/LKkaPz5vkAtij9GyK8ktLUhUy8otLbJWiDS2M9Awt
        LfSMTCz1DI3NY62MTJX07WxSUnMyy1KL9O0S9DLmLGpmKrjEX9HROo2pgbGZt4uRk0NCwERi
        28pLjCC2kMBSRom3LVYQcWmJxtOrmSBsYYk/17rYuhi5gGo+MUqcPrKGBSTBJmAu8Wj7GbAi
        EQFlicn3pjODFDELTGCWaFuyBmyqsICHxJ2vh1lBbBYBVYljmxuYQWxeAReJS9vms0BskJeY
        troLaBAHB6eAq0TnrzCIg1wknh/4wgpRLihxcuYTsHJmoPLmrbOZJzAKzEKSmoUktYCRaRWj
        SGppcW56brGRXnFibnFpXrpecn7uJkZgLG079nPLDsaud8GHGAU4GJV4eDkKPWKEWBPLiitz
        DzFKcDArifC6XnSLEeJNSaysSi3Kjy8qzUktPsRoCvTDRGYp0eR8YJznlcQbmhqaW1gamhub
        G5tZKInznjeojBISSE8sSc1OTS1ILYLpY+LglGpgnCN6fYHDhxiv74fYpR78uPss8DNXkQWj
        y+xZdztNRFgWCL/Mv3NMmVXk+GPZZ7ffJki0P69NPJ8Z8sBpahzrz0i7vrMJV7RXMNWW+jc+
        eNs5ZU9cuc3+74umrripn7ZAcPnRmWayXpOe/n+k+TZi78enjW7sweUqk7lfRjduSf13udfs
        1UHjcCWW4oxEQy3mouJEAHKfBzm7AgAA
X-CMS-MailID: 20190123165551eucas1p2bb80cfe58535b5f665271c7448cffc30
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-RootMTR: 20190123165551eucas1p2bb80cfe58535b5f665271c7448cffc30
X-EPHeader: CA
CMS-TYPE: 201P
X-CMS-RootMailID: 20190123165551eucas1p2bb80cfe58535b5f665271c7448cffc30
References: <20190123165533.29645-1-k.konieczny@partner.samsung.com>
        <CGME20190123165551eucas1p2bb80cfe58535b5f665271c7448cffc30@eucas1p2.samsung.com>
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Document DT bindings for crypto Samsung Exynos5433 SlimSSS (Slim Security
SubSystem) IP.

Signed-off-by: Kamil Konieczny <k.konieczny@partner.samsung.com>
---
 .../devicetree/bindings/crypto/samsung-sss.txt     | 14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)

diff --git a/Documentation/devicetree/bindings/crypto/samsung-sss.txt b/Documentation/devicetree/bindings/crypto/samsung-sss.txt
index 7a5ca56683cc..d9af679d38ab 100644
--- a/Documentation/devicetree/bindings/crypto/samsung-sss.txt
+++ b/Documentation/devicetree/bindings/crypto/samsung-sss.txt
@@ -1,4 +1,4 @@
-Samsung SoC SSS (Security SubSystem) module
+Samsung SoC SSS (Security SubSystem) and SlimSSS module
 
 The SSS module in S5PV210 SoC supports the following:
 -- Feeder (FeedCtrl)
@@ -15,6 +15,12 @@ supports the following also:
 -- True Random Number Generator (TRNG)
 -- Secure Key Manager
 
+Exynos5433 has both SSS and SlimSSS module.
+SlimSSS in Exynos5433 supports:
+-- Feeder (FeedCtrl)
+-- Advanced Encryption Standard (AES)
+-- SHA-1/SHA-256/HMAC (SHA-1/SHA-256)
+
 Required properties:
 
 - compatible : Should contain entries for this and backward compatible
@@ -22,11 +28,13 @@ Required properties:
   - "samsung,s5pv210-secss" for S5PV210 SoC.
   - "samsung,exynos4210-secss" for Exynos4210, Exynos4212, Exynos4412, Exynos5250,
 		Exynos5260 and Exynos5420 SoCs.
+  - "samsung,exynos5433-slim-sss" for Exynos5433 SoCs.
 - reg : Offset and length of the register set for the module
 - interrupts : interrupt specifiers of SSS module interrupts (one feed
 		control interrupt).
 
 - clocks : list of clock phandle and specifier pairs for all clocks  listed in
 		clock-names property.
-- clock-names : list of device clock input names; should contain one entry
-		"secss".
+- clock-names : list of device clock input names; should contain "pclk" and
+		"aclk" for slim-sss in Exynos5433, and one entry "secss" for
+		other compatibles.
-- 
2.20.0

