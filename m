Return-Path: <SRS0=rdxF=Q5=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E136BC4360F
	for <linux-crypto@archiver.kernel.org>; Fri, 22 Feb 2019 12:22:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A84DE2075A
	for <linux-crypto@archiver.kernel.org>; Fri, 22 Feb 2019 12:22:27 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="rmGnXphb"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727073AbfBVMWH (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 22 Feb 2019 07:22:07 -0500
Received: from mailout1.w1.samsung.com ([210.118.77.11]:58099 "EHLO
        mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727027AbfBVMWH (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 22 Feb 2019 07:22:07 -0500
Received: from eucas1p2.samsung.com (unknown [182.198.249.207])
        by mailout1.w1.samsung.com (KnoxPortal) with ESMTP id 20190222122205euoutp016c65476461c3220573ec180d5f9b51c9~Frw74ZNAU0126801268euoutp01a
        for <linux-crypto@vger.kernel.org>; Fri, 22 Feb 2019 12:22:05 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.w1.samsung.com 20190222122205euoutp016c65476461c3220573ec180d5f9b51c9~Frw74ZNAU0126801268euoutp01a
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1550838125;
        bh=xlSz81GvCZhztdwAJRu4Jfn6laXgQkbfkvEaBLXtFvA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rmGnXphbaWCK2888Ub8Bh9TmUaI0NHkJ2agW6r+eRbZlnz/eVOqZ/SVqr0T7o4o0r
         u46hL5b/u7ZaHeW0iRfaaCaxVHclNjiPvuPvLvOTs4Rgv58bOmBbpUPtVqK2M7iIM1
         iZ3wdfIC4IzqgtdZvuzNR7ltl62dOWKQVtFhW6iU=
Received: from eusmges3new.samsung.com (unknown [203.254.199.245]) by
        eucas1p2.samsung.com (KnoxPortal) with ESMTP id
        20190222122204eucas1p2d211c78ea7698f473e7d8ae3990dde08~Frw7G4F5Y2782227822eucas1p2D;
        Fri, 22 Feb 2019 12:22:04 +0000 (GMT)
Received: from eucas1p2.samsung.com ( [182.198.249.207]) by
        eusmges3new.samsung.com (EUCPMTA) with SMTP id 0B.4D.04806.C69EF6C5; Fri, 22
        Feb 2019 12:22:04 +0000 (GMT)
Received: from eusmtrp2.samsung.com (unknown [182.198.249.139]) by
        eucas1p1.samsung.com (KnoxPortal) with ESMTPA id
        20190222122203eucas1p19a77c1cb72526ce36e99542926fd5a17~Frw6V_ZsV2682126821eucas1p1f;
        Fri, 22 Feb 2019 12:22:03 +0000 (GMT)
Received: from eusmgms1.samsung.com (unknown [182.198.249.179]) by
        eusmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20190222122203eusmtrp2183da97cfd1865b021a7069258dd8883~Frw6HVGU22907329073eusmtrp2R;
        Fri, 22 Feb 2019 12:22:03 +0000 (GMT)
X-AuditID: cbfec7f5-367ff700000012c6-92-5c6fe96c7390
Received: from eusmtip1.samsung.com ( [203.254.199.221]) by
        eusmgms1.samsung.com (EUCPMTA) with SMTP id 7A.77.04284.B69EF6C5; Fri, 22
        Feb 2019 12:22:03 +0000 (GMT)
Received: from AMDC3218.DIGITAL.local (unknown [106.120.51.18]) by
        eusmtip1.samsung.com (KnoxPortal) with ESMTPA id
        20190222122202eusmtip1c9270701b75d7b53637a359d77c2ca84~Frw5hYwzu1239012390eusmtip1F;
        Fri, 22 Feb 2019 12:22:02 +0000 (GMT)
From:   Kamil Konieczny <k.konieczny@partner.samsung.com>
To:     k.konieczny@partner.samsung.com
Cc:     Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Kukjin Kim <kgene@kernel.org>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        devicetree@vger.kernel.org, linux-crypto@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>
Subject: [PATCH v4 1/3] arm64: dts: exynos: add SlimSSS for Exynos5433
Date:   Fri, 22 Feb 2019 13:21:42 +0100
Message-Id: <20190222122144.19024-2-k.konieczny@partner.samsung.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190222122144.19024-1-k.konieczny@partner.samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA01Se0hTcRjtd+92dx1eu07JD42ipfQAXz1vWpFksfqnCBI0wWZeVNIpm9NM
        KCk1H6SpkY98FUayzMfSpaZiS5TyMcWcErlM85FZIlooisvtzvK/833nnN/5DvxIXNTCdyTD
        ZTGsXCaNEBNCnqZjWeca8T0q0GMiDZja/Go+U9rey2cyW42IyRr/gTM6XY2AUY/r+cwXwzLG
        DDQVEUy+rhVjXraPCJhnQ/0Yk9zSLjhlLaksqUQStSqNkLwqvy15+6sZk2TWqZBkQb3jIhEg
        PB7CRoTHsnL3k1eFYYbFNiw6i7zRr9JgiWiCSEdWJNCH4MW8Hk9HQlJEVyCY/DRtGRYRNPau
        YdywgMC4ZBBsWFb78giOeI5grGGa98/S9aSfb1IR9FEYe92NmbA9vRtyDXnmd3G6GIfysSVz
        uh19FmYGVLgJ82gXqBgZ4JkwRftC09cqnIvbCbr7VeZoK/oMJK58RpzGFt4XfDPr8XXN3frH
        5gCgWwUwm/0H48y+kJE0ZLnbDmY66yx4OxgbSy2aOHhTPyngzEkIinOfWghveNdpqkOuJ+yD
        6iZ3bu0DNaXLuGkNtA0M/7TlbrCBHE2eZU1BaoqIU7tCibGbz2EnSDdWWbAERtV69ADtKtzU
        pnBTm8L/uWUIVyEHVqmIDGUVB2VsnJtCGqlQykLdrkVFqtH6p+pa6/zdgFpXg7WIJpHYmmJq
        ZYEivjRWER+pRUDiYntqy1RUoIgKkcbfZOVRQXJlBKvQIieSJ3agEraMXhHRodIY9jrLRrPy
        DRYjrRwTkXPABT99h/XpouzCfKVLyCWvqfPznnuHtcEPA6gKQdmBhDnskeee5kGC7onzOKZN
        7rPx+XgYpc4c+VA8KL4skWfUlTqKg2b1ZNkJT8O5O5p7/cG3QrzEzt5En3xEvTWlIDldQHbn
        IJu6If+8cY3MMEY5C9t6VrBtfhPUnH+mmKcIk3rux+UK6V+KZqwgUAMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrFIsWRmVeSWpSXmKPExsVy+t/xu7rZL/NjDBrOKVlsnLGe1WL+kXOs
        Fn37/jNa9D9+zWxx/vwGdotNj6+xWty/95PJ4vKuOWwWM87vY7JYe+Quu8XS6xeZLFr3HmF3
        4PFYM28No8emVZ1sHpuX1HscfLeHyaNvyypGj8+b5ALYovRsivJLS1IVMvKLS2yVog0tjPQM
        LS30jEws9QyNzWOtjEyV9O1sUlJzMstSi/TtEvQy7n05wFTQz1FxcdU2pgbGp2xdjJwcEgIm
        En8uTAeyuTiEBJYySjzvP8YKkZCWaDy9mgnCFpb4c60LqugTo8TKVbvButkEzCUebT8DViQi
        oCwx+d50ZpAiZoHlzBJTtz8DKxIWcJN4dXkVM4jNIqAqseLuZRYQm1fARWLXw3XMEBvkJc73
        rmMHsTkFXCUaft9h7GLkANrmIvFgfxVEuaDEyZlPwFqZgcqbt85mnsAoMAtJahaS1AJGplWM
        IqmlxbnpucWGesWJucWleel6yfm5mxiB8bTt2M/NOxgvbQw+xCjAwajEw2uxMS9GiDWxrLgy
        9xCjBAezkggvw/P8GCHelMTKqtSi/Pii0pzU4kOMpkA/TGSWEk3OB8Z6Xkm8oamhuYWlobmx
        ubGZhZI473mDyighgfTEktTs1NSC1CKYPiYOTqkGxrnuud8V6h//3LzZXu78F/9zUo7TFjhy
        RF5Z8/P0c4/3i/eE3uC8FrW92mtJePeX/U+/K8+NvvHG4nltVelD0eU/lte8UGh5//zm7SP5
        n4WWnyw3+PHk+YviTVzPrkfXzTHZccklUGbHXxX1dp6lp1jWdnwIOW11infFg11TpNc5i1X5
        8N63zjqvxFKckWioxVxUnAgA8/DUVL0CAAA=
X-CMS-MailID: 20190222122203eucas1p19a77c1cb72526ce36e99542926fd5a17
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-RootMTR: 20190222122203eucas1p19a77c1cb72526ce36e99542926fd5a17
X-EPHeader: CA
CMS-TYPE: 201P
X-CMS-RootMailID: 20190222122203eucas1p19a77c1cb72526ce36e99542926fd5a17
References: <20190222122144.19024-1-k.konieczny@partner.samsung.com>
        <CGME20190222122203eucas1p19a77c1cb72526ce36e99542926fd5a17@eucas1p1.samsung.com>
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Add DT node for SlimSSS (aka Slim SecuritySubSystem) in Exynos5433 SoC.
The users can use compatibility "samsung,exynos5433-slim-sss".

Signed-off-by: Kamil Konieczny <k.konieczny@partner.samsung.com>
---
 arch/arm64/boot/dts/exynos/exynos5433.dtsi | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/arch/arm64/boot/dts/exynos/exynos5433.dtsi b/arch/arm64/boot/dts/exynos/exynos5433.dtsi
index e7cd3b67d818..9e5fcb6c7776 100644
--- a/arch/arm64/boot/dts/exynos/exynos5433.dtsi
+++ b/arch/arm64/boot/dts/exynos/exynos5433.dtsi
@@ -559,6 +559,15 @@
 				<&cmu_top CLK_DIV_ACLK_IMEM_200>;
 		};
 
+		slim_sss: slim-sss@11140000 {
+			compatible = "samsung,exynos5433-slim-sss";
+			reg = <0x11140000 0x1000>;
+			interrupts = <GIC_SPI 312 IRQ_TYPE_LEVEL_HIGH>;
+			clock-names = "aclk", "pclk";
+			clocks = <&cmu_imem CLK_ACLK_SLIMSSS>,
+				 <&cmu_imem CLK_PCLK_SLIMSSS>;
+		};
+
 		pd_gscl: power-domain@105c4000 {
 			compatible = "samsung,exynos5433-pd";
 			reg = <0x105c4000 0x20>;
-- 
2.20.1

