Return-Path: <SRS0=smUI=QA=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8EFB0C282C6
	for <linux-crypto@archiver.kernel.org>; Thu, 24 Jan 2019 15:46:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 56B98218AF
	for <linux-crypto@archiver.kernel.org>; Thu, 24 Jan 2019 15:46:03 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="fIViX1cz"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728650AbfAXPqB (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 24 Jan 2019 10:46:01 -0500
Received: from mailout1.w1.samsung.com ([210.118.77.11]:55973 "EHLO
        mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728490AbfAXPpn (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 24 Jan 2019 10:45:43 -0500
Received: from eucas1p2.samsung.com (unknown [182.198.249.207])
        by mailout1.w1.samsung.com (KnoxPortal) with ESMTP id 20190124154541euoutp016456138a2a755111681e9707f22f0419~801ayqDyR2677026770euoutp01W
        for <linux-crypto@vger.kernel.org>; Thu, 24 Jan 2019 15:45:41 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.w1.samsung.com 20190124154541euoutp016456138a2a755111681e9707f22f0419~801ayqDyR2677026770euoutp01W
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1548344741;
        bh=PY8DpUrIo0Jx0XrM9G1AyZ811SfA+Y4/vcYC6ZiNijg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fIViX1czGuHmzso6xjzJ7p32VyiSfvw/QeO7lwYlRI97xUcOpW6c1bWEOhZmy6IbU
         /3zAKHOIxQF+8m1NkW0nuPXS4kiXGOh9XMUqzzJTzaBHuBn5sdl3B/Mze3ur2pIRwW
         sXxhFKQNcI01lYAMU94r77KwjBmLCg4jV9q9Y35Q=
Received: from eusmges3new.samsung.com (unknown [203.254.199.245]) by
        eucas1p1.samsung.com (KnoxPortal) with ESMTP id
        20190124154540eucas1p1edcb3f904130471f947ed46a31733e33~801aGU5KO0096200962eucas1p1y;
        Thu, 24 Jan 2019 15:45:40 +0000 (GMT)
Received: from eucas1p1.samsung.com ( [182.198.249.206]) by
        eusmges3new.samsung.com (EUCPMTA) with SMTP id 4A.31.04806.4ADD94C5; Thu, 24
        Jan 2019 15:45:40 +0000 (GMT)
Received: from eusmtrp1.samsung.com (unknown [182.198.249.138]) by
        eucas1p1.samsung.com (KnoxPortal) with ESMTPA id
        20190124154539eucas1p16fb97dd0cab2c18d82113c511cd8a1ca~801ZTiw1k2703127031eucas1p1k;
        Thu, 24 Jan 2019 15:45:39 +0000 (GMT)
Received: from eusmgms2.samsung.com (unknown [182.198.249.180]) by
        eusmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20190124154539eusmtrp1149f35d549662f84bb8c31d048036083~801ZE9i7f0583405834eusmtrp1Z;
        Thu, 24 Jan 2019 15:45:39 +0000 (GMT)
X-AuditID: cbfec7f5-34dff700000012c6-ea-5c49dda4aa55
Received: from eusmtip2.samsung.com ( [203.254.199.222]) by
        eusmgms2.samsung.com (EUCPMTA) with SMTP id 4B.9F.04128.3ADD94C5; Thu, 24
        Jan 2019 15:45:39 +0000 (GMT)
Received: from AMDC3218.DIGITAL.local (unknown [106.120.51.18]) by
        eusmtip2.samsung.com (KnoxPortal) with ESMTPA id
        20190124154538eusmtip2a1448bd55629f1a887da46e9b0cb2fab~801YXIhgu2617026170eusmtip2q;
        Thu, 24 Jan 2019 15:45:38 +0000 (GMT)
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
Subject: [PATCH v3 2/3] dt-bindings: crypto: document Exynos5433 SlimSSS
Date:   Thu, 24 Jan 2019 16:45:20 +0100
Message-Id: <20190124154521.13589-3-k.konieczny@partner.samsung.com>
X-Mailer: git-send-email 2.20.0
In-Reply-To: <20190124154521.13589-1-k.konieczny@partner.samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrNKsWRmVeSWpSXmKPExsWy7djPc7pL7nrGGLzazmGxccZ6Vos551tY
        LOYfOcdq0f1KxqJv339Gi/PnN7Bb3L/3k8ni8q45bBZrj9xlt1h6/SKTReveI+wO3B5r5q1h
        9Niy8iaTx7YDqh6bVnWyeRx8t4fJo2/LKkaPz5vkAtijuGxSUnMyy1KL9O0SuDLmdaxhKWgT
        qDj/YAtzA+Mm3i5GTg4JAROJM/t2s3QxcnEICaxglDh8pIUdwvnCKPH5zCqozGdGiY0fW9lh
        Wh7MmcoMkVjOKLHy9hNGuJbb7/8xglSxCZhLPNp+hgnEFhFQlph8bzpYB7NAB7PE2yOzwUYJ
        C3hIfNyxmhXEZhFQlbh6aQOQzcHBK+Ai8flYAMQ2eYlpq7vA5nAKuErsndDMAmLzCghKnJz5
        BMxmBqpp3jobbL6EwC52iXtHnzBCNLtI7Hq/ngXCFpZ4dXwL1AsyEqcn90DFyyV2b33GDtHc
        wigxd/IiJoiEtcTh4xfBDmIW0JRYv0sfIuwo8WtPDyNIWEKAT+LGW0GIG/gkJm0D+REkzCvR
        0SYEUa0rMe//GVYIW1qi6/86KNtD4vrcRYwTGBVnIflmFpJvZiHsXcDIvIpRPLW0ODc9tdg4
        L7Vcrzgxt7g0L10vOT93EyMwSZ3+d/zrDsZ9f5IOMQpwMCrx8HYc8owRYk0sK67MPcQowcGs
        JMLretEtRog3JbGyKrUoP76oNCe1+BCjNAeLkjhvNcODaCGB9MSS1OzU1ILUIpgsEwenVAPj
        WoYpXOw+qsKhjV91fnOsbQrI2VFetNiqbL4jz6u2gqJFM/zVM+ZpNj9/rekd49GTw1vtqZoa
        vTTK5d2XOacTp38I0mhaXRKc/Xij6YfcJy6+slKPvmX3lF550/XjWKmp5bULxfev3pQwULh7
        cr2z1pqb12Yf0bl539/HxnNxgN4J9+PHj79UYinOSDTUYi4qTgQAEcKLh04DAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrJIsWRmVeSWpSXmKPExsVy+t/xe7qL73rGGCz9LmKxccZ6Vos551tY
        LOYfOcdq0f1KxqJv339Gi/PnN7Bb3L/3k8ni8q45bBZrj9xlt1h6/SKTReveI+wO3B5r5q1h
        9Niy8iaTx7YDqh6bVnWyeRx8t4fJo2/LKkaPz5vkAtij9GyK8ktLUhUy8otLbJWiDS2M9Awt
        LfSMTCz1DI3NY62MTJX07WxSUnMyy1KL9O0S9DLmdaxhKWgTqDj/YAtzA+Mm3i5GTg4JAROJ
        B3OmMncxcnEICSxllDi0vpsFIiEt0Xh6NROELSzx51oXG0TRJ0aJ6XOegCXYBMwlHm0/A2aL
        CChLTL43HWwSs8AEZom2JWsYQRLCAh4SH3esZgWxWQRUJa5e2gBkc3DwCrhIfD4WALFAXmLa
        6i6wOZwCrhJ7JzSDHSEEVDL32yw2EJtXQFDi5MwnYHFmoPrmrbOZJzAKzEKSmoUktYCRaRWj
        SGppcW56brGRXnFibnFpXrpecn7uJkZgNG079nPLDsaud8GHGAU4GJV4eDsOecYIsSaWFVfm
        HmKU4GBWEuF1vegWI8SbklhZlVqUH19UmpNafIjRFOiHicxSosn5wEjPK4k3NDU0t7A0NDc2
        NzazUBLnPW9QGSUkkJ5YkpqdmlqQWgTTx8TBKdXA2H6wqPaK5rzZTTufflyQ3tZd9E6aQaP1
        4D+dkFv1x4x0o2K3rZ5Q5vbYQMH24iI3BZOAUmXjXY/Sr7sprUt5P+tCKn/wYoa/tkJvptdr
        H8rYkF4juj486+2tTRNu/tSSF6vc++vc8abuuYopbgfy3+eIFL3Z1P5gc0ToM/tgMaZJiveF
        Jhi7KLEUZyQaajEXFScCAJd7s+C8AgAA
X-CMS-MailID: 20190124154539eucas1p16fb97dd0cab2c18d82113c511cd8a1ca
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-RootMTR: 20190124154539eucas1p16fb97dd0cab2c18d82113c511cd8a1ca
X-EPHeader: CA
CMS-TYPE: 201P
X-CMS-RootMailID: 20190124154539eucas1p16fb97dd0cab2c18d82113c511cd8a1ca
References: <20190124154521.13589-1-k.konieczny@partner.samsung.com>
        <CGME20190124154539eucas1p16fb97dd0cab2c18d82113c511cd8a1ca@eucas1p1.samsung.com>
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Document DT bindings for crypto Samsung Exynos5433 SlimSSS (Slim Security
SubSystem) IP.

Reviewed-by: Krzysztof Kozlowski <krzk@kernel.org>
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

