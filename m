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
	by smtp.lore.kernel.org (Postfix) with ESMTP id BA0C5C433E2
	for <linux-crypto@archiver.kernel.org>; Fri,  4 Sep 2020 09:06:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7F62A2084D
	for <linux-crypto@archiver.kernel.org>; Fri,  4 Sep 2020 09:06:33 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="GeQkC1r8"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729978AbgIDJGc (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 4 Sep 2020 05:06:32 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:54915 "EHLO
        mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729824AbgIDJGc (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 4 Sep 2020 05:06:32 -0400
Received: from eucas1p1.samsung.com (unknown [182.198.249.206])
        by mailout1.w1.samsung.com (KnoxPortal) with ESMTP id 20200904090630euoutp01260ec46bec8fc0b191859ddb86d88812~xiWCPOiUD0707607076euoutp01X
        for <linux-crypto@vger.kernel.org>; Fri,  4 Sep 2020 09:06:30 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.w1.samsung.com 20200904090630euoutp01260ec46bec8fc0b191859ddb86d88812~xiWCPOiUD0707607076euoutp01X
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1599210390;
        bh=6OqO1CUFdorivY8AZ9gRzVFFyX34m++BSQuOYzmxIj0=;
        h=Subject:To:From:Date:In-Reply-To:References:From;
        b=GeQkC1r8CIj7Bz8pM6LdXvgcNYwZk4C8sYVoQRZYl+FczPoGgP5fxosb/vI/RalpQ
         WC0P6hOb4rYPDK27G/bQex8jV0ii9uEFWeiYwHsnMHy96hSbxNoBGtDfv48inDgokQ
         AzMjCP7tUhs56wwtHxO5JT0+aCtJ+TJ+6HcQPBlU=
Received: from eusmges2new.samsung.com (unknown [203.254.199.244]) by
        eucas1p2.samsung.com (KnoxPortal) with ESMTP id
        20200904090630eucas1p23567974017b8928b8f4a5001faa3bebb~xiWB79Vhw0523705237eucas1p2G;
        Fri,  4 Sep 2020 09:06:30 +0000 (GMT)
Received: from eucas1p2.samsung.com ( [182.198.249.207]) by
        eusmges2new.samsung.com (EUCPMTA) with SMTP id 3B.0E.05997.693025F5; Fri,  4
        Sep 2020 10:06:30 +0100 (BST)
Received: from eusmtrp1.samsung.com (unknown [182.198.249.138]) by
        eucas1p1.samsung.com (KnoxPortal) with ESMTPA id
        20200904090629eucas1p14a2b5cde706b4bf00f655498c3ee412a~xiWBgxt6W1577815778eucas1p1I;
        Fri,  4 Sep 2020 09:06:29 +0000 (GMT)
Received: from eusmgms2.samsung.com (unknown [182.198.249.180]) by
        eusmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20200904090629eusmtrp11948fbd22ee086f302ffc6a903fac8c7~xiWBgCpgZ2632626326eusmtrp1E;
        Fri,  4 Sep 2020 09:06:29 +0000 (GMT)
X-AuditID: cbfec7f4-677ff7000000176d-66-5f520396a462
Received: from eusmtip1.samsung.com ( [203.254.199.221]) by
        eusmgms2.samsung.com (EUCPMTA) with SMTP id 80.C9.06017.593025F5; Fri,  4
        Sep 2020 10:06:29 +0100 (BST)
Received: from [106.120.51.18] (unknown [106.120.51.18]) by
        eusmtip1.samsung.com (KnoxPortal) with ESMTPA id
        20200904090629eusmtip1b79504b29476411119819f071ca47a66~xiWBGTQSS1686616866eusmtip1E;
        Fri,  4 Sep 2020 09:06:29 +0000 (GMT)
Subject: Re: [PATCH 3/3] crypto: s5p-sss - Pass error from clk_get and
 reduce verbosity on deferral
To:     Krzysztof Kozlowski <krzk@kernel.org>,
        Vladimir Zapolskiy <vz@mleia.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Rob Herring <robh+dt@kernel.org>, linux-crypto@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
From:   Kamil Konieczny <k.konieczny@samsung.com>
Message-ID: <fa83ffad-845d-1eb1-41d8-5e99f324763c@samsung.com>
Date:   Fri, 4 Sep 2020 11:06:28 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
        Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200903180400.2865-3-krzk@kernel.org>
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA01Sa0hTYRjuO5ed43B2nJovKkojDcvULj8OZFIRtR8FEgQpla08bZKbsuNM
        jcDw2rTwVqkZlkaplMVaMxXLa6bDlhpiFpq2ECULnVBemOmOkv+e2/t9z/vx0bj0JelFx2oS
        Oa1GEScTiQnTu3nLrjv4yejQ+fsUW27JINiKjg8kmzvlw1osLyh2dGQeYwcay0VsieUNxmY2
        d1Ds8kI6ftBJbqz5jMlNLf5yQ+0Nkdz+sJiQ2wy+EWSUOCyGi4tN4rQh4efFqllbH55QIEke
        /NInSkNNYj1yooHZB91jtZgeiWkpU43gXmYLJZA5BD1N/bhAbAiq/piw9ZGxvvdrxhMEtvE0
        QiDTCAo7P5GrKTeGg/78McfB7kwHBs8mshyGiAmB1t5uYhVLmHCoG50V6RFNE8w2uP5TtSp7
        MJHQ8GOSEiKu0F1qdcSdVm62tvc6MM54wrC1AhOwH9RPl+NCOwMFTfpLAj4CI5N9IgG7wVSX
        kRKwD5iL8hylgUlHYE67TQkkD0HznHFtYj/YZloc5XAmEJ43hgjyIWjIbsVXZWBcYGjaVejg
        AoWmu2uyBHKypELaHyZ68tYezhv0y3WkgOVQ3FmN5aOtZRu2LNuwWdmGzcr+d3iAiFrkyel4
        tZLj92i4K8G8Qs3rNMrgi/FqA1r5SmZ719xr1Lh0oQ0xNJI5S4Z+R0RLSUUSn6JuQ0DjMnfJ
        4V7zOakkRpGSymnjo7W6OI5vQ940IfOU7K2cPCtllIpE7jLHJXDadRejnbzSUEAwP/MoNCxg
        oWhgC+nqXDWcJPI79TZ3vFT/6y8W6RxVumw7UZ8cfvOayqvbWHDLqvvmwcYpvBd9dc1VO48d
        qEtdWNzcSrd5+ufYT5NXWzeHxdYsacTOXzcFxpe0B2U3Wr4PHjdsJ5WP8/Cho4OUPejj04zM
        yjP6BhdlIFNofSUjeJVi9w5cyyv+AZN3KBBGAwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrJIsWRmVeSWpSXmKPExsVy+t/xu7pTmYPiDU7s1bSYc76FxWL+kXOs
        Ft2vZCzOn9/AbnH/3k8mi8u75rBZzDi/j8mide8Rdov/v5qZHTg9tqy8yeSx7YCqx6ZVnWwe
        /xZOYfH4vEkugDVKz6Yov7QkVSEjv7jEVina0MJIz9DSQs/IxFLP0Ng81srIVEnfziYlNSez
        LLVI3y5BL+PT54vMBRN5K67dvsjWwLibq4uRk0NCwETi4cUTzF2MXBxCAksZJY723mWBSEhL
        NJ5ezQRhC0v8udbFBlH0mlHix6w37CAJYYFUiReTNrGCJEQEjjBJrJ/5nAmiaiOjxISrmxlB
        qtgE9CUOnj0JNpZXwE5i3f1PQKM4OFgEVCQa32SAmKICkRI7d1hCVAhKnJz5BKyaE+i6J4fP
        gtnMAuoSf+ZdYoawxSVuPZnPBGHLS2x/O4d5AqPgLCTts5C0zELSMgtJywJGllWMIqmlxbnp
        ucVGesWJucWleel6yfm5mxiB0bbt2M8tOxi73gUfYhTgYFTi4b3xPiBeiDWxrLgy9xCjBAez
        kgiv09nTcUK8KYmVValF+fFFpTmpxYcYTYFem8gsJZqcD0wEeSXxhqaG5haWhubG5sZmFkri
        vB0CB2OEBNITS1KzU1MLUotg+pg4OKUaGO0+fL6x1CxfdtXnso/ht38aCIuLiUeuljFYUaef
        PH+KetU9KaHb5gwiLIseT5+9yMTY/+6jtwZnL8dlPZ07qaSEX/D95d7m2V1myQZFZrmZWQdf
        b/Hcf7NhxZGPTtmya3L+9S/406532jKLZ9+ZhqBoy65DYVpx4RU8uQbBsSlz7H80mFbNVmIp
        zkg01GIuKk4EABlL9YfMAgAA
X-CMS-MailID: 20200904090629eucas1p14a2b5cde706b4bf00f655498c3ee412a
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-RootMTR: 20200903180419eucas1p157549970b1db257022f6aef96cd3abbb
X-EPHeader: CA
CMS-TYPE: 201P
X-CMS-RootMailID: 20200903180419eucas1p157549970b1db257022f6aef96cd3abbb
References: <20200903180400.2865-1-krzk@kernel.org>
        <CGME20200903180419eucas1p157549970b1db257022f6aef96cd3abbb@eucas1p1.samsung.com>
        <20200903180400.2865-3-krzk@kernel.org>
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org



On 9/3/20 8:04 PM, Krzysztof Kozlowski wrote:
> Pass the error directly from devm_clk_get() to describe the real reason,
> instead of fixed ENOENT.  Do not print error messages on deferred probe.
> 
> Signed-off-by: Krzysztof Kozlowski <krzk@kernel.org>
> ---
>  drivers/crypto/s5p-sss.c | 15 +++++++--------
>  1 file changed, 7 insertions(+), 8 deletions(-)
> 
> diff --git a/drivers/crypto/s5p-sss.c b/drivers/crypto/s5p-sss.c
> index f67f1e22ecd1..e83145c43b18 100644
> --- a/drivers/crypto/s5p-sss.c
> +++ b/drivers/crypto/s5p-sss.c
> @@ -2201,11 +2201,10 @@ static int s5p_aes_probe(struct platform_device *pdev)
>  	}
>  
>  	pdata->clk = devm_clk_get(dev, variant->clk_names[0]);
> -	if (IS_ERR(pdata->clk)) {
> -		dev_err(dev, "failed to find secss clock %s\n",
> -			variant->clk_names[0]);
> -		return -ENOENT;
> -	}
> +	if (IS_ERR(pdata->clk))
> +		return dev_err_probe(dev, PTR_ERR(pdata->clk),
> +				     "failed to find secss clock %s\n",
> +				     variant->clk_names[0]);
>  
>  	err = clk_prepare_enable(pdata->clk);
>  	if (err < 0) {
> @@ -2217,9 +2216,9 @@ static int s5p_aes_probe(struct platform_device *pdev)
>  	if (variant->clk_names[1]) {
>  		pdata->pclk = devm_clk_get(dev, variant->clk_names[1]);
>  		if (IS_ERR(pdata->pclk)) {
> -			dev_err(dev, "failed to find clock %s\n",
> -				variant->clk_names[1]);
> -			err = -ENOENT;
> +			err = dev_err_probe(dev, PTR_ERR(pdata->pclk),
> +					    "failed to find clock %s\n",
> +					    variant->clk_names[1]);
>  			goto err_clk;
>  		}
>  
> 

Reviewed-by: Kamil Konieczny <k.konieczny@samsung.com>
Acked-by: Kamil Konieczny <k.konieczny@samsung.com>

