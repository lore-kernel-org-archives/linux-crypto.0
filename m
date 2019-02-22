Return-Path: <SRS0=rdxF=Q5=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 883E8C43381
	for <linux-crypto@archiver.kernel.org>; Fri, 22 Feb 2019 12:22:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4F0D42075A
	for <linux-crypto@archiver.kernel.org>; Fri, 22 Feb 2019 12:22:28 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="HHO0kanh"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726356AbfBVMW1 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 22 Feb 2019 07:22:27 -0500
Received: from mailout1.w1.samsung.com ([210.118.77.11]:58106 "EHLO
        mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727049AbfBVMWH (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 22 Feb 2019 07:22:07 -0500
Received: from eucas1p2.samsung.com (unknown [182.198.249.207])
        by mailout1.w1.samsung.com (KnoxPortal) with ESMTP id 20190222122205euoutp0144b240bc9a9dd76c65bed69a8b2f1e04~Frw8MNYVO0136801368euoutp01H
        for <linux-crypto@vger.kernel.org>; Fri, 22 Feb 2019 12:22:05 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.w1.samsung.com 20190222122205euoutp0144b240bc9a9dd76c65bed69a8b2f1e04~Frw8MNYVO0136801368euoutp01H
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1550838125;
        bh=Mgc6BuPHG36agn925U0fFTtJA8SwkU3GacY/L83V0NY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HHO0kanhtmPhmkKUQ39YAR2b7ieMbb3qlPdIv5VNIntmTOo09txq7D8895CbXHD4P
         YBLU6Hue7zN8bdejV8KxT91deUf0cqpHydHhvyQ5aqZWQAx/wGLTZyjuRPN0xuh6k4
         9aRJ7gZEdqCLJ/NPy+svPcA7BQhF/64rW0NKp5DE=
Received: from eusmges1new.samsung.com (unknown [203.254.199.242]) by
        eucas1p1.samsung.com (KnoxPortal) with ESMTP id
        20190222122205eucas1p10a2e475ef2f1d10394bc8e587ad510de~Frw7loTD42681726817eucas1p1Z;
        Fri, 22 Feb 2019 12:22:05 +0000 (GMT)
Received: from eucas1p2.samsung.com ( [182.198.249.207]) by
        eusmges1new.samsung.com (EUCPMTA) with SMTP id BD.BF.04441.C69EF6C5; Fri, 22
        Feb 2019 12:22:04 +0000 (GMT)
Received: from eusmtrp2.samsung.com (unknown [182.198.249.139]) by
        eucas1p1.samsung.com (KnoxPortal) with ESMTPA id
        20190222122204eucas1p15e0e00e9b044d41d44c0d2e55cb6af9c~Frw6zzNEn2682126821eucas1p1g;
        Fri, 22 Feb 2019 12:22:04 +0000 (GMT)
Received: from eusmgms1.samsung.com (unknown [182.198.249.179]) by
        eusmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20190222122204eusmtrp22c105b9c52e91d1ed268ef4ad7820465~Frw6lK8bW2907329073eusmtrp2S;
        Fri, 22 Feb 2019 12:22:04 +0000 (GMT)
X-AuditID: cbfec7f2-5e3ff70000001159-c3-5c6fe96cad63
Received: from eusmtip1.samsung.com ( [203.254.199.221]) by
        eusmgms1.samsung.com (EUCPMTA) with SMTP id 5B.77.04284.C69EF6C5; Fri, 22
        Feb 2019 12:22:04 +0000 (GMT)
Received: from AMDC3218.DIGITAL.local (unknown [106.120.51.18]) by
        eusmtip1.samsung.com (KnoxPortal) with ESMTPA id
        20190222122203eusmtip142521965e5f2d568b323673bf23d9a30~Frw6FIHxt1160711607eusmtip1J;
        Fri, 22 Feb 2019 12:22:03 +0000 (GMT)
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
Subject: [PATCH v4 2/3] dt-bindings: crypto: document Exynos5433 SlimSSS
Date:   Fri, 22 Feb 2019 13:21:43 +0100
Message-Id: <20190222122144.19024-3-k.konieczny@partner.samsung.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190222122144.19024-1-k.konieczny@partner.samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrJKsWRmVeSWpSXmKPExsWy7djP87o5L/NjDCbNtLDYOGM9q8Wc8y0s
        FvOPnGO16H4lY9G37z+jxfnzG9gt7t/7yWRxedccNou1R+6yWyy9fpHJonXvEXYHbo8189Yw
        emxZeZPJY9sBVY9NqzrZPA6+28Pk0bdlFaPH501yAexRXDYpqTmZZalF+nYJXBnfu48wF+zm
        rmg4VtLAeI+zi5GTQ0LAROLP67OsXYxcHEICKxglvt6bwAbhfGGUuNC3kR2kSkjgM6PEt870
        LkYOsI7Jj8UhapYzSnz6fJ0RrmHWmoeMIA1sAuYSj7afYQKxRQSUJSbfm84MUsQs0MEs8fbI
        bLCpwgIeEuufngZrYBFQlTi7ehUziM0r4CIxf8JuRoj75CXO964Dq+cUcJVo+H2HEaJGUOLk
        zCcsIDYzUE3z1tlgCyQEdrFLbF68gg2i2UXi+ImD7BC2sMSr41ugbBmJ/zvnM0HY5RK7tz5j
        h2huYZSYO3kRVMJa4vDxi6wgPzMLaEqs36UPEXaUePD/AgskKPgkbrwVhLiBT2LSNpAnQcK8
        Eh1tQhDVuhLz/p9hhbClJbr+r4OyPSQ+ftrBOIFRcRaSb2Yh+WYWwt4FjMyrGMVTS4tz01OL
        DfNSy/WKE3OLS/PS9ZLzczcxAhPU6X/HgaZ9vZR0iFGAg1GJh9diY16MEGtiWXFl7iFGCQ5m
        JRFehuf5MUK8KYmVValF+fFFpTmpxYcYpTlYlMR5qxkeRAsJpCeWpGanphakFsFkmTg4pRoY
        I9cv+hJ2alropsSTuyKPFGuxbuPI3yMvveNO3l5Wn0f9AjYrdhdH7Lltlv+Wza9g8ed6czN1
        Qe0pS02ildvu34v985tRk89a/+xsmf7TK9PThN89ZHPwO624bf+LQPltm++e19z+ZEHwzdvP
        zctCXOxcf11SMPn33WFyyofoHqOY+sc2e45qKLEUZyQaajEXFScCAJDmzl9MAwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrOIsWRmVeSWpSXmKPExsVy+t/xu7o5L/NjDKY+ZrXYOGM9q8Wc8y0s
        FvOPnGO16H4lY9G37z+jxfnzG9gt7t/7yWRxedccNou1R+6yWyy9fpHJonXvEXYHbo8189Yw
        emxZeZPJY9sBVY9NqzrZPA6+28Pk0bdlFaPH501yAexRejZF+aUlqQoZ+cUltkrRhhZGeoaW
        FnpGJpZ6hsbmsVZGpkr6djYpqTmZZalF+nYJehnfu48wF+zmrmg4VtLAeI+zi5GDQ0LARGLy
        Y/EuRi4OIYGljBIrbj5i7WLkBIpLSzSeXs0EYQtL/LnWxQZR9IlRYt3lV2AJNgFziUfbz4DZ
        IgLKEpPvTWcGKWIWmMAs0bZkDSNIQljAQ2L909NgNouAqsTZ1auYQWxeAReJ+RN2M0JskJc4
        37uOHcTmFHCVaPh9hxHkOiGgmgf7qyDKBSVOznzCAmIzA5U3b53NPIFRYBaS1CwkqQWMTKsY
        RVJLi3PTc4sN9YoTc4tL89L1kvNzNzECI2nbsZ+bdzBe2hh8iFGAg1GJh9diY16MEGtiWXFl
        7iFGCQ5mJRFehuf5MUK8KYmVValF+fFFpTmpxYcYTYF+mMgsJZqcD4zyvJJ4Q1NDcwtLQ3Nj
        c2MzCyVx3vMGlVFCAumJJanZqakFqUUwfUwcnFINjAbJDTt7/yTq3n7S+lpF93iAa/Kkk9ck
        56aw3Z13JlF/upXe7+iD9kztEjtKPfV5e3TWrVJIWFXeL9X0e/IRdQ6XA+Urc1JS5oRl7OPj
        rJadV6pV4/n4scaKv2e99gcsLRZ+sOFPzfqXL8VZGW/zzPLmsnhoWHR/lrJo1dWqf18rJ+1k
        TGe2UmIpzkg01GIuKk4EAOkVsrS6AgAA
X-CMS-MailID: 20190222122204eucas1p15e0e00e9b044d41d44c0d2e55cb6af9c
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-RootMTR: 20190222122204eucas1p15e0e00e9b044d41d44c0d2e55cb6af9c
X-EPHeader: CA
CMS-TYPE: 201P
X-CMS-RootMailID: 20190222122204eucas1p15e0e00e9b044d41d44c0d2e55cb6af9c
References: <20190222122144.19024-1-k.konieczny@partner.samsung.com>
        <CGME20190222122204eucas1p15e0e00e9b044d41d44c0d2e55cb6af9c@eucas1p1.samsung.com>
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Document DT bindings for crypto Samsung Exynos5433 SlimSSS (Slim Security
SubSystem) IP.

Signed-off-by: Kamil Konieczny <k.konieczny@partner.samsung.com>
---
 .../bindings/crypto/samsung-slimsss.txt       | 19 +++++++++++++++++++
 1 file changed, 19 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/crypto/samsung-slimsss.txt

diff --git a/Documentation/devicetree/bindings/crypto/samsung-slimsss.txt b/Documentation/devicetree/bindings/crypto/samsung-slimsss.txt
new file mode 100644
index 000000000000..7ec9a5a7727a
--- /dev/null
+++ b/Documentation/devicetree/bindings/crypto/samsung-slimsss.txt
@@ -0,0 +1,19 @@
+Samsung SoC SlimSSS (Slim Security SubSystem) module
+
+The SlimSSS module in Exynos5433 SoC supports the following:
+-- Feeder (FeedCtrl)
+-- Advanced Encryption Standard (AES) with ECB,CBC,CTR,XTS and (CBC/XTS)/CTS
+-- SHA-1/SHA-256 and (SHA-1/SHA-256)/HMAC
+
+Required properties:
+
+- compatible : Should contain entry for slimSSS version:
+  - "samsung,exynos5433-slim-sss" for Exynos5433 SoC.
+- reg : Offset and length of the register set for the module
+- interrupts : interrupt specifiers of SlimSSS module interrupts (one feed
+		control interrupt).
+
+- clocks : list of clock phandle and specifier pairs for all clocks listed in
+		clock-names property.
+- clock-names : list of device clock input names; should contain "pclk" and
+		"aclk" for slim-sss in Exynos5433.
-- 
2.20.1

