Return-Path: <SRS0=rdxF=Q5=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4AC3DC10F00
	for <linux-crypto@archiver.kernel.org>; Fri, 22 Feb 2019 12:22:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1184E2075A
	for <linux-crypto@archiver.kernel.org>; Fri, 22 Feb 2019 12:22:29 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="a1EgUQnN"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726977AbfBVMW2 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 22 Feb 2019 07:22:28 -0500
Received: from mailout1.w1.samsung.com ([210.118.77.11]:58091 "EHLO
        mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726980AbfBVMWH (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 22 Feb 2019 07:22:07 -0500
Received: from eucas1p1.samsung.com (unknown [182.198.249.206])
        by mailout1.w1.samsung.com (KnoxPortal) with ESMTP id 20190222122205euoutp01270619706ec283b299dda687fd1195b6~Frw7p7-EU0122601226euoutp01h
        for <linux-crypto@vger.kernel.org>; Fri, 22 Feb 2019 12:22:05 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.w1.samsung.com 20190222122205euoutp01270619706ec283b299dda687fd1195b6~Frw7p7-EU0122601226euoutp01h
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1550838125;
        bh=gfZSE0eRKNyUpk/q2xrM1z9/4QrmLyW79y9kFH42N8A=;
        h=From:To:Cc:Subject:Date:References:From;
        b=a1EgUQnNYoN8xAKK9+ifrjslZUIO/EXaY56lsMPgnFl8e9HO5R8lBHwswA7P6nzkn
         Bh5ScLDtwOtGOeWEnJgkANOQtbtEo0I/HhGAlM216HnPG7sCIL0TZnQ6z7mrfzh+qz
         drKfUjG1ESGhrf41Lljn93X0BB/3IFdIEl3Qmfxc=
Received: from eusmges1new.samsung.com (unknown [203.254.199.242]) by
        eucas1p2.samsung.com (KnoxPortal) with ESMTP id
        20190222122204eucas1p2cf57ccada7c4191f51c677dcba9fc154~Frw6lW43R2866028660eucas1p2H;
        Fri, 22 Feb 2019 12:22:04 +0000 (GMT)
Received: from eucas1p1.samsung.com ( [182.198.249.206]) by
        eusmges1new.samsung.com (EUCPMTA) with SMTP id BC.BF.04441.B69EF6C5; Fri, 22
        Feb 2019 12:22:03 +0000 (GMT)
Received: from eusmtrp1.samsung.com (unknown [182.198.249.138]) by
        eucas1p1.samsung.com (KnoxPortal) with ESMTPA id
        20190222122203eucas1p1e87a8066d4348be4beb3ff035ea55828~Frw5wNn3N1242112421eucas1p1n;
        Fri, 22 Feb 2019 12:22:03 +0000 (GMT)
Received: from eusmgms2.samsung.com (unknown [182.198.249.180]) by
        eusmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20190222122202eusmtrp1c54702f32321b1292e3651238f4be42c~Frw5hNirz1040810408eusmtrp10;
        Fri, 22 Feb 2019 12:22:02 +0000 (GMT)
X-AuditID: cbfec7f2-5c9ff70000001159-c2-5c6fe96b6cd5
Received: from eusmtip1.samsung.com ( [203.254.199.221]) by
        eusmgms2.samsung.com (EUCPMTA) with SMTP id 64.6F.04128.A69EF6C5; Fri, 22
        Feb 2019 12:22:02 +0000 (GMT)
Received: from AMDC3218.DIGITAL.local (unknown [106.120.51.18]) by
        eusmtip1.samsung.com (KnoxPortal) with ESMTPA id
        20190222122202eusmtip197b10c3e5578b4b03e39d2a0177c472b~Frw43TpYR1185211852eusmtip17;
        Fri, 22 Feb 2019 12:22:02 +0000 (GMT)
From:   Kamil Konieczny <k.konieczny@partner.samsung.com>
To:     k.konieczny@partner.samsung.com
Cc:     "David S. Miller" <davem@davemloft.net>,
        devicetree@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Kukjin Kim <kgene@kernel.org>,
        linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        Mark Rutland <mark.rutland@arm.com>,
        Rob Herring <robh+dt@kernel.org>,
        Vladimir Zapolskiy <vz@mleia.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>
Subject: [PATCH v4 0/3] add AES support for Exynos5433
Date:   Fri, 22 Feb 2019 13:21:41 +0100
Message-Id: <20190222122144.19024-1-k.konieczny@partner.samsung.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrOKsWRmVeSWpSXmKPExsWy7djPc7rZL/NjDF7MMrPYOGM9q8Wc8y0s
        FvOPnGO16H4lY9G37z+jRf/j18wW589vYLfY9Pgaq8X9ez+ZLC7vmsNmMeP8PiaLtUfuslss
        vX6RyaJ17xF2i/+/mpkd+D3WzFvD6LFl5U0mj20HVD02repk89i8pN7j38IpLB4H3+1h8ujb
        sorR4/MmuQDOKC6blNSczLLUIn27BK6M5y+b2AsmcVYsmtrE2MC4lr2LkZNDQsBEYuLrlUxd
        jFwcQgIrGCWW/fvKDuF8YZToXb8WyvnMKLHh32JmmJYlVxayQCSWM0rMbnrPCNfyf/40sCo2
        AXOJR9vPMIHYIgLKEpPvTWcGKWIWmM4icePHbLDtwgJmEpfXtoA1sAioSlx+NReogYODV8BF
        4tbZFIht8hLne9eBlfMKCEqcnPmEBcRmBoo3b50NNlNC4By7xMYL/WwQDS4S3zc/Y4WwhSVe
        Hd8C9amMxOnJPSwQdrnE7q3P2CGaWxgl5k5exASRsJY4fPwiK8gRzAKaEut36YOYEgKOEltv
        pUGYfBI33gpCnMAnMWkbyFsgYV6JjjYhiBm6EvP+n4E6QFqi6/86KNtD4vmHHWDHCAnESjRv
        O8w4gVFhFpLHZiF5bBbCCQsYmVcxiqeWFuempxYb5qWW6xUn5haX5qXrJefnbmIEJrfT/45/
        2sH49VLSIUYBDkYlHl6LjXkxQqyJZcWVuYcYJTiYlUR4GZ7nxwjxpiRWVqUW5ccXleakFh9i
        lOZgURLnrWZ4EC0kkJ5YkpqdmlqQWgSTZeLglGpgTPJ7d+XJreD1XrG/PhmUfSm/cnmqwbrN
        R4yaueetVhS9mGYn4+wZ5LiMcV/djlvbryql/mjvrlh9yVnd6Vnj/bJd/89JXU1hO1PlLqV+
        rf165/WzZXMVma00hHknWJm7GxzaYXZg40wBkYXqyznftrfOu/Ez7OSsLp/9s7YIRHd+8rFV
        PHxFVYmlOCPRUIu5qDgRAMM/drlqAwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrLIsWRmVeSWpSXmKPExsVy+t/xu7pZL/NjDG42W1tsnLGe1WLO+RYW
        i/lHzrFadL+Ssejb95/Rov/xa2aL8+c3sFtsenyN1eL+vZ9MFpd3zWGzmHF+H5PF2iN32S2W
        Xr/IZNG69wi7xf9fzcwO/B5r5q1h9Niy8iaTx7YDqh6bVnWyeWxeUu/xb+EUFo+D7/YwefRt
        WcXo8XmTXABnlJ5NUX5pSapCRn5xia1StKGFkZ6hpYWekYmlnqGxeayVkamSvp1NSmpOZllq
        kb5dgl7G85dN7AWTOCsWTW1ibGBcy97FyMkhIWAiseTKQhYQW0hgKaNE75IMiLi0ROPp1UwQ
        trDEn2tdbF2MXEA1nxglmnesZQNJsAmYSzzafgasSERAWWLyvenMIEXMAotZJA68+wCWEBYw
        k7i8toUZxGYRUJW4/GouUJyDg1fAReLW2RSIBfIS53vXgR3EKyAocXLmE7CDmIHizVtnM09g
        5JuFJDULSWoBI9MqRpHU0uLc9NxiI73ixNzi0rx0veT83E2MwKjaduznlh2MXe+CDzEKcDAq
        8fBabMyLEWJNLCuuzD3EKMHBrCTCy/A8P0aINyWxsiq1KD++qDQntfgQoynQrROZpUST84ER
        n1cSb2hqaG5haWhubG5sZqEkznveoDJKSCA9sSQ1OzW1ILUIpo+Jg1OqgbFSTOOpF5tN5qlL
        HmK+NxI5WE7z7XNoDl8xMTb13OWCH5ZRibnB5zY73FpXun7ZGY5X0WLSe5VnaN04zbj31rqt
        /y9u87+peHNVn6NPsKXfwoXri/exRHQ4Zd7aMO9Gq9wCfgnHm18M9uet9FzBkDYvqKuq5IzG
        E8/VXpmbN7pLLnTcM03Avk+JpTgj0VCLuag4EQB4rgo9wAIAAA==
X-CMS-MailID: 20190222122203eucas1p1e87a8066d4348be4beb3ff035ea55828
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-RootMTR: 20190222122203eucas1p1e87a8066d4348be4beb3ff035ea55828
X-EPHeader: CA
CMS-TYPE: 201P
X-CMS-RootMailID: 20190222122203eucas1p1e87a8066d4348be4beb3ff035ea55828
References: <CGME20190222122203eucas1p1e87a8066d4348be4beb3ff035ea55828@eucas1p1.samsung.com>
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Add slimSSS node to DT and crypto AES support for Exynos5433. Tested on
Exynos5433 board with crypto run-time self tests and with tcrypt with
command insmod tcrypt.ko mode=500 sec=1

Changes since v3:
- moved bindings documentation out from samsung-sss.txt into separate file
  samsung-slimsss.txt

Changes since v2:
- address Corentine Labbe note: add "const" to char* in declaration of
  struct samsung_aes_variant

Changes since v1:
- address Krzysztof Kozlowski review: add missing comma in struct
  definition, add goto for error code path, correct indentation,
  in documentation add that Exynos5433 has both slimSSS and SSS IPs.

Kamil Konieczny (3):
  arm64: dts: exynos: add SlimSSS for Exynos5433
  dt-bindings: crypto: document Exynos5433 SlimSSS
  crypto: s5p: add AES support for Exynos5433

 .../bindings/crypto/samsung-slimsss.txt       | 19 +++++++
 arch/arm64/boot/dts/exynos/exynos5433.dtsi    |  9 ++++
 drivers/crypto/s5p-sss.c                      | 50 +++++++++++++++++--
 3 files changed, 74 insertions(+), 4 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/crypto/samsung-slimsss.txt

-- 
2.20.1

