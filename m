Return-Path: <SRS0=peSz=64=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BE921C433E1
	for <linux-crypto@archiver.kernel.org>; Thu, 14 May 2020 19:07:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9BAB220675
	for <linux-crypto@archiver.kernel.org>; Thu, 14 May 2020 19:07:54 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="L72k8lV6"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729497AbgENTHx (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 14 May 2020 15:07:53 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:57893 "EHLO
        mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730198AbgENTHm (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 14 May 2020 15:07:42 -0400
Received: from eucas1p2.samsung.com (unknown [182.198.249.207])
        by mailout1.w1.samsung.com (KnoxPortal) with ESMTP id 20200514190741euoutp013c6df0928e6c1bf6ce9ade3f9e189a2e~O_prY_IbN1335313353euoutp01U
        for <linux-crypto@vger.kernel.org>; Thu, 14 May 2020 19:07:41 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.w1.samsung.com 20200514190741euoutp013c6df0928e6c1bf6ce9ade3f9e189a2e~O_prY_IbN1335313353euoutp01U
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1589483261;
        bh=ZtfxDhdLs90OyvVegf5gSIpg3nb7fV8VW4Z3SaViPnA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=L72k8lV60AbOjZg4Ks2+xX2iK3uN69F1iHAeMmo4D7spNYxMf2Blvth3ZPDEEneU9
         il3Jyq0CqykA+cqzRud5bB9/6A4Sjrw+MdE4NgD1koZYJt30BBbe54oGaI5EUBhQxh
         omjPKPB4HL462umdcropg/8mf4yx1V6zd30p3i9s=
Received: from eusmges1new.samsung.com (unknown [203.254.199.242]) by
        eucas1p1.samsung.com (KnoxPortal) with ESMTP id
        20200514190740eucas1p1b78f50aa2a8c350a702be990ef03efe9~O_pqww51q0232902329eucas1p1_;
        Thu, 14 May 2020 19:07:40 +0000 (GMT)
Received: from eucas1p1.samsung.com ( [182.198.249.206]) by
        eusmges1new.samsung.com (EUCPMTA) with SMTP id 7B.D4.61286.CF69DBE5; Thu, 14
        May 2020 20:07:40 +0100 (BST)
Received: from eusmtrp1.samsung.com (unknown [182.198.249.138]) by
        eucas1p2.samsung.com (KnoxPortal) with ESMTPA id
        20200514190740eucas1p293129b2ef3ba706652a9327e55db9649~O_pqCM4Hi0297902979eucas1p21;
        Thu, 14 May 2020 19:07:40 +0000 (GMT)
Received: from eusmgms2.samsung.com (unknown [182.198.249.180]) by
        eusmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20200514190740eusmtrp1551cbba1be4f614ee676bbff1259ef18~O_pqBgBsy2577025770eusmtrp1o;
        Thu, 14 May 2020 19:07:40 +0000 (GMT)
X-AuditID: cbfec7f2-f0bff7000001ef66-df-5ebd96fc26b3
Received: from eusmtip2.samsung.com ( [203.254.199.222]) by
        eusmgms2.samsung.com (EUCPMTA) with SMTP id 16.BE.07950.BF69DBE5; Thu, 14
        May 2020 20:07:39 +0100 (BST)
Received: from localhost (unknown [106.120.51.46]) by eusmtip2.samsung.com
        (KnoxPortal) with ESMTPA id
        20200514190739eusmtip2b58bea1e9cfb3ef1c0fcca3c010eee29~O_pp2e-ro1760217602eusmtip2F;
        Thu, 14 May 2020 19:07:39 +0000 (GMT)
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
        linux-samsung-soc@vger.kernel.org
Cc:     Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        =?UTF-8?q?=C5=81ukasz=20Stelmach?= <l.stelmach@samsung.com>
Subject: [PATCH 2/2] hwrng: exynos - Set the quality value
Date:   Thu, 14 May 2020 21:07:34 +0200
Message-Id: <20200514190734.32746-3-l.stelmach@samsung.com>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200514190734.32746-1-l.stelmach@samsung.com>
MIME-Version: 1.0
Organization: Samsung R&D Institute Poland
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA01SfUzMcRjf934v9+vW1a+L9ayMuZVN81Jj7RstjM1vtuRPY+Lwk+htd73Q
        H6S63lC5K9UVWoXW2+XkKJGu00mrNiEqFHkpFIWUMt39zvjveZ7P2/NsD0PIEml3JiwyhldG
        KsLltIQ0tk13rZw9fyfEJz13JZ7TtInxtQI9hWvO3idxd8ZVAs+MmcU4uUxP49Oji3D2m48E
        7u6uE+PnpgqEDW+eUvjVy2kR7mkspnFB910RLtEOU7jEmIXw28LrNB6rGkbY8iCD2OjK/ZrR
        IE73qpPmGnQvxFyZoZnmjPe8OENlBs01X6gWc9fLT3JZ9ZWIyxqpQ5y+/gnJJT1Mo7hJw+Id
        0l2SgIN8eFgcr1wduE9y+MWcGUVni4/1F78jE1ESnYkcGGDXgrr0McpEEkbGViD4NN5LCs03
        BKcbau3IJIIecy76K7lUmUYJwFUEX/Jb7M17BHM1jTYWzW6C7MsPbMACVk2B9msOaQUINh7U
        Q8OUtXZl10FWVxNhrUnWC1L6p21bSdn10P7rnliIWwJFpzpscwc2AHo/zIgEjgu0Fw7bPJ1Z
        b6hO6rX7L4HkG0WENRhYMwMX6lNFgtEWaHh00X6DK4xa6u0Bi6BDe2ZezMzXJ0Gr8RO0ZxAY
        i3+SAmc9DHTN0FYOwS4HfeNqYbwJqt5PIUHqBM8+uwgrOIHGmE8IYymkp8oEtifUZjfZDd3h
        7GgFykFy3X/H6P47QPcvqwQRlciNj1VFhPIq30g+fpVKEaGKjQxddSAqwoDm/7Ljt2XiFvr+
        aL8JsQySO0p98u6EyChFnOp4hAkBQ8gXSLfrb4fIpAcVxxN4ZdReZWw4rzIhD4aUu0nXlI7s
        kbGhihj+KM9H88q/qIhxcE9EwZOd5tkpr7Cg+Md1Hpszdo43D0b1LNNYAtt5Z9D7L9uWs9Zv
        oC8xendVJ11WcMvtytyU709uzdIUU9sh+cSJwSnLVkf906C76f2SchftkVOORRvaXFo6/d3F
        VI5f4GsiaDJP09Qz1OrWd7M/LGH6a57aM3xFq1PCj4Ux5xZPvA6Wk6rDCl9vQqlS/AGqd5uO
        kwMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupnleLIzCtJLcpLzFFi42I5/e/4Pd3f0/bGGWxotbL4O+kYu8XGGetZ
        Ldb2HmWxON+5nNni17sj7BbNi9ezWXS/krHof/ya2eL8+Q3sFjcPrWC02PT4GqvF/Xs/mSwu
        75rDZjHj/D4miwWTn7BaLNjWx2jxdOZmNot3q58wWhw/0cnsIOzx+9ckRo9Z98+yeeycdZfd
        Y/Gm/Wwe2w6oemxa1cnmsX/uGnaPzUvqPfq2rGL06Hu5gdFj/ZarLB5Np9pZPT5vkgvgjdKz
        KcovLUlVyMgvLrFVija0MNIztLTQMzKx1DM0No+1MjJV0rezSUnNySxLLdK3S9DLuPv3CGNB
        P3vF7TnPWBoYm9i6GDk5JARMJOavamftYuTiEBJYyijxbMlvpi5GDqCElMTKuekQNcISf651
        gdULCTxllHh8Rw/EZhNwlOhfegKsV0RgMqvEmz2tTCAJZoFyidaHT1hBbGEBK4m+c3uYQWwW
        AVWJlts/wQbxClhLnPx9gB1igbzE7MbTYHFOARuJ6y9+MUEss5a482UuK0S9oMTJmU9YQG5j
        FlCXWD9PCCTML6AlsabpOgvEWnmJ5q2zmScwCs1C0jELoWMWkqoFjMyrGEVSS4tz03OLjfSK
        E3OLS/PS9ZLzczcxAhPDtmM/t+xg7HoXfIhRgINRiYfXYOreOCHWxLLiytxDjBIczEoivH7r
        d8cJ8aYkVlalFuXHF5XmpBYfYjQFenMis5Rocj4waeWVxBuaGppbWBqaG5sbm1koifN2CByM
        ERJITyxJzU5NLUgtgulj4uCUamA0yDu9I/q3DtOHdw8nizxJWCC3YXNlQ9jxECu9IxZMR7PU
        wkNarYL+CZcUfwh94Ln33O/Px68LfFt2+JmU3W7O2buN3nktPq+yNi0v89Ldl2fey14OX+xV
        2uDQ8iUz+tyjjqyMRxHXZQ22zelcGTJX6P3RSIY/5+07Dz2UvbhDcn3GHiGlOw/UlFiKMxIN
        tZiLihMBTXD5ViIDAAA=
X-CMS-MailID: 20200514190740eucas1p293129b2ef3ba706652a9327e55db9649
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-RootMTR: 20200514190740eucas1p293129b2ef3ba706652a9327e55db9649
X-EPHeader: CA
CMS-TYPE: 201P
X-CMS-RootMailID: 20200514190740eucas1p293129b2ef3ba706652a9327e55db9649
References: <20200514190734.32746-1-l.stelmach@samsung.com>
        <CGME20200514190740eucas1p293129b2ef3ba706652a9327e55db9649@eucas1p2.samsung.com>
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

The value has been estimaded by obtainig 1024 chunks of data 128 bytes
(1024 bits) each from the generator and finding chunk with minimal
entropy using the ent(1) tool. The value was 6.332937 bits of entropy
in each 8 bits of data.

Signed-off-by: Łukasz Stelmach <l.stelmach@samsung.com>
---
 drivers/char/hw_random/exynos-trng.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/char/hw_random/exynos-trng.c b/drivers/char/hw_random/exynos-trng.c
index 8e1fe3f8dd2d..ff6739272bf5 100644
--- a/drivers/char/hw_random/exynos-trng.c
+++ b/drivers/char/hw_random/exynos-trng.c
@@ -123,6 +123,7 @@ static int exynos_trng_probe(struct platform_device *pdev)
 	trng->rng.init = exynos_trng_init;
 	trng->rng.read = exynos_trng_do_read;
 	trng->rng.priv = (unsigned long) trng;
+	trng->rng.quality = 800;
 
 	platform_set_drvdata(pdev, trng);
 	trng->dev = &pdev->dev;
-- 
2.25.0

