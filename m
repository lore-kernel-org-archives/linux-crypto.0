Return-Path: <SRS0=2Pww=CN=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A89A9C433E2
	for <linux-crypto@archiver.kernel.org>; Fri,  4 Sep 2020 09:07:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 70A5A2084D
	for <linux-crypto@archiver.kernel.org>; Fri,  4 Sep 2020 09:07:30 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="cTvEUuLm"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730000AbgIDJH0 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 4 Sep 2020 05:07:26 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:55275 "EHLO
        mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729901AbgIDJHZ (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 4 Sep 2020 05:07:25 -0400
Received: from eucas1p2.samsung.com (unknown [182.198.249.207])
        by mailout1.w1.samsung.com (KnoxPortal) with ESMTP id 20200904090723euoutp014dd457f2cdac0c5461e59adce746caab~xiWzr4J8M0628806288euoutp01X
        for <linux-crypto@vger.kernel.org>; Fri,  4 Sep 2020 09:07:23 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.w1.samsung.com 20200904090723euoutp014dd457f2cdac0c5461e59adce746caab~xiWzr4J8M0628806288euoutp01X
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1599210443;
        bh=ZQ0PXpDZj1o8rgqUA1eu6VEabHL0uTSRcNQeoD20uR0=;
        h=Subject:To:From:Date:In-Reply-To:References:From;
        b=cTvEUuLmmN0ks6vYuw9s2z/AzrBKuBNdstzVS+Kgu06fhhB9J/og6qavc+yOJyHVF
         wK4xz0lYe8R+2HM6hjbfhIumneeDJGQtRtn5h/Rz7EROPki+O7AdYrZq/5OFdtitN/
         QuFLeKAV8997PKMC5JCMo+yjfICpMTyPZWNRK/A4=
Received: from eusmges2new.samsung.com (unknown [203.254.199.244]) by
        eucas1p2.samsung.com (KnoxPortal) with ESMTP id
        20200904090723eucas1p2b6b993ca0c152d8ce3054d5fcb873e00~xiWzdWjSZ1442414424eucas1p2d;
        Fri,  4 Sep 2020 09:07:23 +0000 (GMT)
Received: from eucas1p2.samsung.com ( [182.198.249.207]) by
        eusmges2new.samsung.com (EUCPMTA) with SMTP id AF.2E.05997.BC3025F5; Fri,  4
        Sep 2020 10:07:23 +0100 (BST)
Received: from eusmtrp2.samsung.com (unknown [182.198.249.139]) by
        eucas1p1.samsung.com (KnoxPortal) with ESMTPA id
        20200904090723eucas1p10b7d6f01088aeeff289b22a9f65039d4~xiWzMO2Jh3163431634eucas1p1g;
        Fri,  4 Sep 2020 09:07:23 +0000 (GMT)
Received: from eusmgms2.samsung.com (unknown [182.198.249.180]) by
        eusmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20200904090723eusmtrp230de8f2e240726048cfdf0e965a07659~xiWzLlJnf0713607136eusmtrp2X;
        Fri,  4 Sep 2020 09:07:23 +0000 (GMT)
X-AuditID: cbfec7f4-677ff7000000176d-14-5f5203cb0ffa
Received: from eusmtip2.samsung.com ( [203.254.199.222]) by
        eusmgms2.samsung.com (EUCPMTA) with SMTP id 80.E9.06017.AC3025F5; Fri,  4
        Sep 2020 10:07:23 +0100 (BST)
Received: from [106.120.51.18] (unknown [106.120.51.18]) by
        eusmtip2.samsung.com (KnoxPortal) with ESMTPA id
        20200904090722eusmtip22b25fd0bae84585d038e6865193d691f~xiWyyHkq22235822358eusmtip2t;
        Fri,  4 Sep 2020 09:07:22 +0000 (GMT)
Subject: Re: [PATCH 1/3] dt-bindings: crypto: slimsss: Correct a typo in
 compatible
To:     Krzysztof Kozlowski <krzk@kernel.org>,
        Vladimir Zapolskiy <vz@mleia.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Rob Herring <robh+dt@kernel.org>, linux-crypto@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
From:   Kamil Konieczny <k.konieczny@samsung.com>
Message-ID: <3b8f5c30-a669-c228-5835-5e4efa431879@samsung.com>
Date:   Fri, 4 Sep 2020 11:07:22 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
        Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200903180400.2865-1-krzk@kernel.org>
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrEKsWRmVeSWpSXmKPExsWy7djP87qnmYPiDZrfClvMOd/CYjH/yDlW
        i+5XMhbnz29gt7h/7yeTxeVdc9gsZpzfx2TRuvcIu8X/X83MDpweW1beZPLYdkDVY9OqTjaP
        fwunsHh83iQXwBrFZZOSmpNZllqkb5fAlXHnzzfGgn3sFdun97A0MC5l62Lk5JAQMJG492Mi
        SxcjF4eQwApGicO3bzNDOF8YJY4unswG4XxmlJjbfJ0JpmVF73FWiMRyRolX66awdzFyADlv
        GSX6NEFqhAVCJT596gQbKyJwhEli7fM2VpAEm4C+xMGzJ1lAbF4BO4mH/YfAbBYBFYklLdPA
        akQFIiV2Pn3JDlEjKHFy5hOwGk6gxV+vHwarYRYQl7j1ZD4ThC0vsf3tHLCzJQQ2sUv0LL7B
        CnGpi8Sq3TOYIWxhiVfHt7BD2DIS/3eCNIM0NDNKnG6Yyg7h9DBK7P2yBRo01hKfPx5gA3mN
        WUBTYv0ufYiwo8Sp+RuYQMISAnwSN94KQhzBJzFp23RmiDCvREebEES1qsTzUz3QgJOW6Pq/
        jhWixEPiynKuCYyKs5B8OQvJZ7OQfDYL4YQFjCyrGMVTS4tz01OLjfJSy/WKE3OLS/PS9ZLz
        czcxAlPS6X/Hv+xg3PUn6RCjAAejEg/vjfcB8UKsiWXFlbmHGCU4mJVEeJ3Ono4T4k1JrKxK
        LcqPLyrNSS0+xCjNwaIkzmu86GWskEB6YklqdmpqQWoRTJaJg1OqgTHk1fnWU9V8Z9etFHNe
        Fu1uqnQueEFH8CzWZbeqBKvjF7e9KFIuzo/db9KS4xn1beL3e3tajP74/jvOHr1YeIGW4+eC
        pjtG8WbHT+8sVni+RU4jPNnQo3i+ec8b78+bkqpuzvhcL/FAdl5W6vaIW3bpXfXWRYzzjGyq
        e3jDvveXXHcsipslr8RSnJFoqMVcVJwIAC0KJbJFAwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrJIsWRmVeSWpSXmKPExsVy+t/xe7qnmYPiDbbNYbSYc76FxWL+kXOs
        Ft2vZCzOn9/AbnH/3k8mi8u75rBZzDi/j8mide8Rdov/v5qZHTg9tqy8yeSx7YCqx6ZVnWwe
        /xZOYfH4vEkugDVKz6Yov7QkVSEjv7jEVina0MJIz9DSQs/IxFLP0Ng81srIVEnfziYlNSez
        LLVI3y5BL+POn2+MBfvYK7ZP72FpYFzK1sXIySEhYCKxovc4K4gtJLCUUeLAakeIuLRE4+nV
        TBC2sMSfa11A9VxANa8ZJZYsWMwOkhAWCJX49KmTBSQhInCESWL9zOdMEFXtjBL7bu8Ca2cT
        0Jc4ePYkC4jNK2An8bD/EJjNIqAisaRlGtBqDg5RgUiJnTssIUoEJU7OfAJWwgl03dfrh8Gu
        YxZQl/gz7xIzhC0ucevJfCYIW15i+9s5zBMYBWchaZ+FpGUWkpZZSFoWMLKsYhRJLS3OTc8t
        NtIrTswtLs1L10vOz93ECIy2bcd+btnB2PUu+BCjAAejEg/vjfcB8UKsiWXFlbmHGCU4mJVE
        eJ3Ono4T4k1JrKxKLcqPLyrNSS0+xGgK9NtEZinR5HxgIsgriTc0NTS3sDQ0NzY3NrNQEuft
        EDgYIySQnliSmp2aWpBaBNPHxMEp1cAoF3jQIdruRPjR61dsrLnUD0b1LLsQUTKn9ab8gtlh
        zafUutcrd1zzURCKOPX2Z/3r/5maH/9sniQQ+dXjzKOb0g5T905N3GXtvH3xhfqaB78OqoQr
        XXxwee2awMlyRgfaJ1X9v7quVrs7h3/qtH9u0yeG//x2q/PpnoWr3yw20tlg/1nVY2ZBixJL
        cUaioRZzUXEiABmAcpDMAgAA
X-CMS-MailID: 20200904090723eucas1p10b7d6f01088aeeff289b22a9f65039d4
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-RootMTR: 20200903180412eucas1p10d854b51ba650b27265f088b07c93b15
X-EPHeader: CA
CMS-TYPE: 201P
X-CMS-RootMailID: 20200903180412eucas1p10d854b51ba650b27265f088b07c93b15
References: <CGME20200903180412eucas1p10d854b51ba650b27265f088b07c93b15@eucas1p1.samsung.com>
        <20200903180400.2865-1-krzk@kernel.org>
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org



On 9/3/20 8:03 PM, Krzysztof Kozlowski wrote:
> Correct a typo in the compatible - missing trailing 's'.
> 
> Signed-off-by: Krzysztof Kozlowski <krzk@kernel.org>
> ---
>  Documentation/devicetree/bindings/crypto/samsung-slimsss.yaml | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/Documentation/devicetree/bindings/crypto/samsung-slimsss.yaml b/Documentation/devicetree/bindings/crypto/samsung-slimsss.yaml
> index 04fe5dfa794a..7743eae049ab 100644
> --- a/Documentation/devicetree/bindings/crypto/samsung-slimsss.yaml
> +++ b/Documentation/devicetree/bindings/crypto/samsung-slimsss.yaml
> @@ -19,7 +19,7 @@ description: |+
>  properties:
>    compatible:
>      items:
> -      - const: samsung,exynos5433-slim-ss
> +      - const: samsung,exynos5433-slim-sss
>  
>    reg:
>      maxItems: 1
> 

Reviewed-by: Kamil Konieczny <k.konieczny@samsung.com>
Acked-by: Kamil Konieczny <k.konieczny@samsung.com>
