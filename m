Return-Path: <SRS0=98p2=P6=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5FBFBC282C3
	for <linux-crypto@archiver.kernel.org>; Tue, 22 Jan 2019 15:26:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2699A217D6
	for <linux-crypto@archiver.kernel.org>; Tue, 22 Jan 2019 15:26:49 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="d02JLUi/"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729282AbfAVP0s (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 22 Jan 2019 10:26:48 -0500
Received: from mailout1.w1.samsung.com ([210.118.77.11]:49949 "EHLO
        mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728918AbfAVP0M (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 22 Jan 2019 10:26:12 -0500
Received: from eucas1p1.samsung.com (unknown [182.198.249.206])
        by mailout1.w1.samsung.com (KnoxPortal) with ESMTP id 20190122152610euoutp01eb9c1a5a7323fda00d5d451037a6fdac~8NRz-Z-2-0912009120euoutp01u
        for <linux-crypto@vger.kernel.org>; Tue, 22 Jan 2019 15:26:10 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.w1.samsung.com 20190122152610euoutp01eb9c1a5a7323fda00d5d451037a6fdac~8NRz-Z-2-0912009120euoutp01u
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1548170770;
        bh=XhXEUQE5xAKbwygfA7Rdfb9KqEGaRFuvNk9iE5BJLeQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=d02JLUi/7SY+ki+lRCcSToGkr87xVapJusChBZjFwT7vv3UMyxDFO7+axUWuyEjMk
         8ZCzeRyt16jQcHV2XsdbQSujhfiE1G/QdL4Q8lZoD7PkdUg10m+0aJXUDcBmvd+Yf0
         p/edVB8hT8A9WNcgIGcs5xJ8z6wApWspJzQjdbyc=
Received: from eusmges3new.samsung.com (unknown [203.254.199.245]) by
        eucas1p1.samsung.com (KnoxPortal) with ESMTP id
        20190122152609eucas1p1be2c43da974544abc829e9d5f9aa37ef~8NRzRT7uj0417804178eucas1p1D;
        Tue, 22 Jan 2019 15:26:09 +0000 (GMT)
Received: from eucas1p1.samsung.com ( [182.198.249.206]) by
        eusmges3new.samsung.com (EUCPMTA) with SMTP id 06.F0.04806.116374C5; Tue, 22
        Jan 2019 15:26:09 +0000 (GMT)
Received: from eusmtrp2.samsung.com (unknown [182.198.249.139]) by
        eucas1p2.samsung.com (KnoxPortal) with ESMTPA id
        20190122152608eucas1p27cff7b53eb3bb23447ef7ba2b3f69671~8NRyhJlmc1355913559eucas1p2b;
        Tue, 22 Jan 2019 15:26:08 +0000 (GMT)
Received: from eusmgms2.samsung.com (unknown [182.198.249.180]) by
        eusmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20190122152608eusmtrp20261dd303d1b385f6046d7859c7a4e03~8NRySmTs10539205392eusmtrp2V;
        Tue, 22 Jan 2019 15:26:08 +0000 (GMT)
X-AuditID: cbfec7f5-367ff700000012c6-1a-5c4736118956
Received: from eusmtip2.samsung.com ( [203.254.199.222]) by
        eusmgms2.samsung.com (EUCPMTA) with SMTP id FD.FF.04128.016374C5; Tue, 22
        Jan 2019 15:26:08 +0000 (GMT)
Received: from AMDC3218.DIGITAL.local (unknown [106.120.51.18]) by
        eusmtip2.samsung.com (KnoxPortal) with ESMTPA id
        20190122152608eusmtip21d8df1e7e36aaccbdea35ed588611300~8NRxyhDUY0551405514eusmtip2y;
        Tue, 22 Jan 2019 15:26:08 +0000 (GMT)
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
Subject: [PATCH v1 2/3] dt-bindings: crypto: document Exynos5433 SlimSSS
Date:   Tue, 22 Jan 2019 16:25:52 +0100
Message-Id: <20190122152553.1537-3-k.konieczny@partner.samsung.com>
X-Mailer: git-send-email 2.20.0
In-Reply-To: <20190122152553.1537-1-k.konieczny@partner.samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA01Sa0hTYRjuO2fbOZvOjnPki1nRwh8VZmHUiSIKtQ6ioFAkZdS0g0rbtB2v
        9SeYt2aIJGl5TUO0ecuhs1yK2UhTc9nFkkotS7qgRlqmVrbjUfLf8z0XnueFj8QVVrEHGaOL
        Z/U6tUYlkYksD2f7vF13HQ7f3v7Ok264Vi+mi+ypIrrU1iems7540tltC4i2228T9PDQLEY/
        aymS0LW2twRd8bIfo9NabcQBJ6ampAYxjbcGMcbS7sWYTZckzP2JexiT3WhCzJR5fQhxXLbv
        DKuJSWT1PvtPy6Kvmt6huK7VyYaer6KLaN7ZiKQkUDvBUFaLGZGMVFBVCKxFDWJeUFDTCIps
        CYIwhaBsvEq0nCg0ZEkEoRLBSOlHJDwciSHTC8S7JNRueN/ci/FYSW2C3KF8nDfhVCYO47ZC
        ghfcKAYel5fgPBZRXpCbOroYkFN+YDZP4ELdBsirNi7yUsof7N0mseBxhUfXPyxOwh0eQ1Ph
        YgFQFgJsM61LW/2hubtiCbvBl85GQsCesHC3FBNwElibxgghnIqgOLd8SdgLDzr7HW2ko2Ez
        1Lf4CPRBaPtzk+BpoFzg1birsMEFrlj4I3laDpnpCsHtDSULvWIBrwXjQt0SZsCUly3OQRsL
        VlxTsOKagv+9NxBuQu5sAqeNYjlfHZu0jVNruQRd1LbIWK0ZOb5Uz9/OH3dQ2++IDkSRSOUs
        J/sCwhVidSKXou1AQOIqpTyg/1C4Qn5GnXKe1cee0idoWK4DrSVFKnf5hVUjJxRUlDqePcuy
        cax+WcVIqcdFVJuxx+iXbM9+apNaua29PcM1R46tm/z56VcoasooCNMawk6l18uMz++qAufS
        8n2eKPHKIKgeKDHXfc4Jr3O77HuBjByIXDM5P/d65OSYpetvBBYy7OQSKMqfCRp945Vr2Bvq
        la6s/a76qT8XljlfHPxtkCzVHEXG+mmf2OJgq0rERat3bMH1nPof6ZApLk4DAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrFIsWRmVeSWpSXmKPExsVy+t/xe7oCZu4xBm9Wa1lsnLGe1WLO+RYW
        i/lHzrFadL+Ssejb95/R4vz5DewW9+/9ZLK4vGsOm8XaI3fZLZZev8hk0br3CLsDt8eaeWsY
        PbasvMnkse2AqsemVZ1sHgff7WHy6NuyitHj8ya5APYoPZui/NKSVIWM/OISW6VoQwsjPUNL
        Cz0jE0s9Q2PzWCsjUyV9O5uU1JzMstQifbsEvYypqx4yFpzgr2g+/ZqlgfE3TxcjJ4eEgInE
        7OZuti5GLg4hgaWMEq2/3zBDJKQlGk+vZoKwhSX+XOuCKvrEKDHt+SU2kASbgLnEo+1nwIpE
        BJQlJt+bzgxSxCwwgVmibckaRpCEsICHxNlF88CmsgioSkxueQzWwCvgLLFp0zuobfIS01Z3
        gcU5BVwkzp9axQpiCwHVPJ4whxWiXlDi5MwnLCA2M1B989bZzBMYBWYhSc1CklrAyLSKUSS1
        tDg3PbfYSK84Mbe4NC9dLzk/dxMjMJ62Hfu5ZQdj17vgQ4wCHIxKPLwJF1xjhFgTy4orcw8x
        SnAwK4nwul50ixHiTUmsrEotyo8vKs1JLT7EaAr0xERmKdHkfGCs55XEG5oamltYGpobmxub
        WSiJ8543qIwSEkhPLEnNTk0tSC2C6WPi4JRqYLSabK253Mjl8g9/may4WzKlYe9sUxximN0r
        Kt1jt6xk9O/NeLo83kjKdJuxq7WCKJdTe12L48RPyT6cZ+JENSorjJ3Ftgc3Fs61SwmyDvw6
        z7Ve+Hxd1W8rkX1Z8v4HX89X6fney2Az1XCdz6xfCY73nhTezv1lyXSdJ5zBj11n5fYPBfFK
        LMUZiYZazEXFiQD+1HEkvQIAAA==
X-CMS-MailID: 20190122152608eucas1p27cff7b53eb3bb23447ef7ba2b3f69671
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-RootMTR: 20190122152608eucas1p27cff7b53eb3bb23447ef7ba2b3f69671
X-EPHeader: CA
CMS-TYPE: 201P
X-CMS-RootMailID: 20190122152608eucas1p27cff7b53eb3bb23447ef7ba2b3f69671
References: <20190122152553.1537-1-k.konieczny@partner.samsung.com>
        <CGME20190122152608eucas1p27cff7b53eb3bb23447ef7ba2b3f69671@eucas1p2.samsung.com>
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Document DT bindings for crypto Samsung Exynos5433 SlimSSS (Slim Security
SubSystem) IP.

Signed-off-by: Kamil Konieczny <k.konieczny@partner.samsung.com>
---
 .../devicetree/bindings/crypto/samsung-sss.txt      | 13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

diff --git a/Documentation/devicetree/bindings/crypto/samsung-sss.txt b/Documentation/devicetree/bindings/crypto/samsung-sss.txt
index 7a5ca56683cc..75718f86fe50 100644
--- a/Documentation/devicetree/bindings/crypto/samsung-sss.txt
+++ b/Documentation/devicetree/bindings/crypto/samsung-sss.txt
@@ -1,4 +1,4 @@
-Samsung SoC SSS (Security SubSystem) module
+Samsung SoC SSS (Security SubSystem) and SlimSSS module
 
 The SSS module in S5PV210 SoC supports the following:
 -- Feeder (FeedCtrl)
@@ -15,6 +15,11 @@ supports the following also:
 -- True Random Number Generator (TRNG)
 -- Secure Key Manager
 
+The SlimSSS module in Exynos5 (Exynos5433) supports:
+-- Feeder (FeedCtrl)
+-- Advanced Encryption Standard (AES)
+-- SHA-1/SHA-256/HMAC (SHA-1/SHA-256)
+
 Required properties:
 
 - compatible : Should contain entries for this and backward compatible
@@ -22,11 +27,13 @@ Required properties:
   - "samsung,s5pv210-secss" for S5PV210 SoC.
   - "samsung,exynos4210-secss" for Exynos4210, Exynos4212, Exynos4412, Exynos5250,
 		Exynos5260 and Exynos5420 SoCs.
+  - "samsung,exynos5433-slim-sss" for Exynos542x and Exynos5433 SoCs.
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

