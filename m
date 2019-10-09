Return-Path: <SRS0=7GLU=YC=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0348CC47404
	for <linux-crypto@archiver.kernel.org>; Wed,  9 Oct 2019 14:17:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A3260218DE
	for <linux-crypto@archiver.kernel.org>; Wed,  9 Oct 2019 14:17:38 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="EK+3IWi8"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729491AbfJIORi (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 9 Oct 2019 10:17:38 -0400
Received: from mailout2.w1.samsung.com ([210.118.77.12]:49728 "EHLO
        mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729471AbfJIORh (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 9 Oct 2019 10:17:37 -0400
Received: from eucas1p1.samsung.com (unknown [182.198.249.206])
        by mailout2.w1.samsung.com (KnoxPortal) with ESMTP id 20191009141736euoutp02318d52b826737ebbf9f9298c54dd9faa~MAEKgBTcl1085310853euoutp02c
        for <linux-crypto@vger.kernel.org>; Wed,  9 Oct 2019 14:17:36 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.w1.samsung.com 20191009141736euoutp02318d52b826737ebbf9f9298c54dd9faa~MAEKgBTcl1085310853euoutp02c
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1570630656;
        bh=l0k8UfZ5aEmAEi8xzOk+QCWgw11xExX4Rs2PigDQi0s=;
        h=From:To:Cc:Subject:Date:References:From;
        b=EK+3IWi87XasWHfdjRvmWfwhsDHO6FPi+a7oI0dTB443e4aETGB1rlfa0eAaF+tjP
         iSXgdwR1AWyn12QaQn3uYJscjTOJAQpDRJsSX+yr3waGJRjI0dDAGA9MlX9rH3HBFZ
         4BykVrsn8m0ikBwJn/MVHI2jbOmn1XN182/ZfaKY=
Received: from eusmges1new.samsung.com (unknown [203.254.199.242]) by
        eucas1p1.samsung.com (KnoxPortal) with ESMTP id
        20191009141736eucas1p17c4d9a9ca07b1b83b50c3869bd2c0193~MAEKU7SBr0835608356eucas1p1e;
        Wed,  9 Oct 2019 14:17:36 +0000 (GMT)
Received: from eucas1p2.samsung.com ( [182.198.249.207]) by
        eusmges1new.samsung.com (EUCPMTA) with SMTP id F9.A3.04469.FFBED9D5; Wed,  9
        Oct 2019 15:17:35 +0100 (BST)
Received: from eusmtrp1.samsung.com (unknown [182.198.249.138]) by
        eucas1p2.samsung.com (KnoxPortal) with ESMTPA id
        20191009141735eucas1p216018d6fd7716bde4143f70e51b58ef2~MAEJ0NA361027810278eucas1p2j;
        Wed,  9 Oct 2019 14:17:35 +0000 (GMT)
Received: from eusmgms1.samsung.com (unknown [182.198.249.179]) by
        eusmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20191009141735eusmtrp185989123481dcef8e3f017324825b120~MAEJzoI5e0651506515eusmtrp1U;
        Wed,  9 Oct 2019 14:17:35 +0000 (GMT)
X-AuditID: cbfec7f2-569ff70000001175-5b-5d9debff0258
Received: from eusmtip2.samsung.com ( [203.254.199.222]) by
        eusmgms1.samsung.com (EUCPMTA) with SMTP id F0.DD.04166.FFBED9D5; Wed,  9
        Oct 2019 15:17:35 +0100 (BST)
Received: from localhost (unknown [106.120.51.46]) by eusmtip2.samsung.com
        (KnoxPortal) with ESMTPA id
        20191009141735eusmtip23e3c7af21b6f626eeda9228f965ef98a~MAEJqZ_6-3242332423eusmtip2V;
        Wed,  9 Oct 2019 14:17:35 +0000 (GMT)
From:   =?UTF-8?q?=C5=81ukasz=20Stelmach?= <l.stelmach@samsung.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        linux-crypto@vger.kernel.org
Cc:     =?UTF-8?q?=C5=81ukasz=20Stelmach?= <l.stelmach@samsung.com>,
        Rob Herring <robh@kernel.org>,
        Krzysztof Kozlowski <krzk@kernel.org>
Subject: [PATCH] dt-bindings: hwrng: Add Samsung Exynos 5250+ True RNG
 bindings
Date:   Wed,  9 Oct 2019 16:17:32 +0200
Message-Id: <20191009141732.1489-1-l.stelmach@samsung.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Organization: Samsung R&D Institute Poland
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFuphleLIzCtJLcpLzFFi42LZduzned3/r+fGGlz+ZG7R/UrG4vz5DewW
        Nw+tYLS4f+8nk8X/PTvYHVg9th1Q9di0qpPNo2/LKkaPz5vkAliiuGxSUnMyy1KL9O0SuDJO
        P57NWvCZs2L2gj1sDYzrOLoYOTkkBEwkvi3ZwN7FyMUhJLCCUaL72wwo5wujxImOA0wQzmdG
        if8LJ7PAtBzuXAyVWM4o8eX6ekYI5zmjxPaPM8Cq2AQcJfqXnmAFsUUEvCR+HloN1sEs0M4o
        8XP/ZEaQhLBAoMTKj3fYQWwWAVWJ8+82sHUxcnDwClhJ7L8ZDLFNXuJ87zqwEl4BQYmTM5+A
        zecX0JJY03QdzGYGqmneOpsZor6ZXWLSMhkI20Viw4ZOdghbWOLV8S1QtozE6ck9LCCrJATq
        JSZPMgM5TUKgh1Fi25wfUF9aSxw+fpEVpIZZQFNi/S59iLCjRMfXv4wQrXwSN94KQlzAJzFp
        23RmiDCvREebEES1isS6/j1QA6Ukel+tYISwPSS+3HzJOIFRcRaSv2Yh+WUWwt4FjMyrGMVT
        S4tz01OLDfNSy/WKE3OLS/PS9ZLzczcxAtPI6X/HP+1g/Hop6RCjAAejEg9vxsm5sUKsiWXF
        lbmHGCU4mJVEeBfNmhMrxJuSWFmVWpQfX1Sak1p8iFGag0VJnLea4UG0kEB6YklqdmpqQWoR
        TJaJg1OqgbHx1u4qQxERvp9b1EseWr5ax/tEY6+babxUujXftzQlz7jSv/sms6ildvtPvqD+
        PvR/DouIStESCVbbNe2TZr3l1t0qH5N3Lp1B5ExG5dS6G7Ux038c8Nb/IufEeZo3b6GQ/4la
        sY6DaWsmtRbGB3h9sQw84RQ2YV++6Z4J737cCf9twLxgnxJLcUaioRZzUXEiAPOpHJkfAwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmplkeLIzCtJLcpLzFFi42I5/e/4Pd3/r+fGGrQdkbTofiVjcf78BnaL
        m4dWMFrcv/eTyeL/nh3sDqwe2w6oemxa1cnm0bdlFaPH501yASxRejZF+aUlqQoZ+cUltkrR
        hhZGeoaWFnpGJpZ6hsbmsVZGpkr6djYpqTmZZalF+nYJehmnH89mLfjMWTF7wR62BsZ1HF2M
        nBwSAiYShzsXM3UxcnEICSxllNj7dS5bFyMHUEJKYuXcdIgaYYk/17rYIGqeMkpcv7eOHSTB
        JuAo0b/0BCuILSLgI3Hjx0awQcwCnYwSaxcuYwZJCAv4SzQ/OcMGYrMIqEqcf7cBbAGvgJXE
        /pvBEAvkJc73QszkFRCUODnzCQtICbOAusT6eUIgYX4BLYk1TddZQGxmoPLmrbOZJzAKzELS
        MQuhYxaSqgWMzKsYRVJLi3PTc4sN9YoTc4tL89L1kvNzNzECo2DbsZ+bdzBe2hh8iFGAg1GJ
        hzfj5NxYIdbEsuLK3EOMEhzMSiK8i2bNiRXiTUmsrEotyo8vKs1JLT7EaAr0zURmKdHkfGCE
        5pXEG5oamltYGpobmxubWSiJ83YIHIwREkhPLEnNTk0tSC2C6WPi4JRqYEySWFuub97Z0CRk
        9jD96G2FTRlnnL3KfrzvXjTrZJfx58cae/c7HLN7u3aK35G0r/9zXq+X/PLhdMGDKWb/CphW
        Tblu9X3L0rDHtfULymyEb/+4FLDHmXvZuonHaoWzDmpFLk9jDT1vIfUoN1v3nKJ7pMu1fR2b
        JFkPLYvpV2U5uez9rDqlgypKLMUZiYZazEXFiQAcHyVEmAIAAA==
X-CMS-MailID: 20191009141735eucas1p216018d6fd7716bde4143f70e51b58ef2
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-RootMTR: 20191009141735eucas1p216018d6fd7716bde4143f70e51b58ef2
X-EPHeader: CA
CMS-TYPE: 201P
X-CMS-RootMailID: 20191009141735eucas1p216018d6fd7716bde4143f70e51b58ef2
References: <CGME20191009141735eucas1p216018d6fd7716bde4143f70e51b58ef2@eucas1p2.samsung.com>
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Add binding documentation for the True Random Number Generator
found on Samsung Exynos 5250+ SoCs.

Acked-by: Rob Herring <robh@kernel.org>
Reviewed-by: Krzysztof Kozlowski <krzk@kernel.org>
Signed-off-by: Łukasz Stelmach <l.stelmach@samsung.com>
---
 .../bindings/rng/samsung,exynos5250-trng.txt    | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/rng/samsung,exynos5250-trng.txt

diff --git Documentation/devicetree/bindings/rng/samsung,exynos5250-trng.txt Documentation/devicetree/bindings/rng/samsung,exynos5250-trng.txt
new file mode 100644
index 000000000000..5a613a4ec780
--- /dev/null
+++ Documentation/devicetree/bindings/rng/samsung,exynos5250-trng.txt
@@ -0,0 +1,17 @@
+Exynos True Random Number Generator
+
+Required properties:
+
+- compatible  : Should be "samsung,exynos5250-trng".
+- reg         : Specifies base physical address and size of the registers map.
+- clocks      : Phandle to clock-controller plus clock-specifier pair.
+- clock-names : "secss" as a clock name.
+
+Example:
+
+	rng@10830600 {
+		compatible = "samsung,exynos5250-trng";
+		reg = <0x10830600 0x100>;
+		clocks = <&clock CLK_SSS>;
+		clock-names = "secss";
+	};
-- 
2.20.1

