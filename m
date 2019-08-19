Return-Path: <SRS0=LpGJ=WP=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 35DB5C3A5A0
	for <linux-crypto@archiver.kernel.org>; Mon, 19 Aug 2019 23:44:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EE9D722CF8
	for <linux-crypto@archiver.kernel.org>; Mon, 19 Aug 2019 23:44:19 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="K/sy7g3s"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728578AbfHSXoT (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 19 Aug 2019 19:44:19 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:22201 "EHLO
        mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728305AbfHSXoT (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 19 Aug 2019 19:44:19 -0400
Received: from epcas1p2.samsung.com (unknown [182.195.41.46])
        by mailout3.samsung.com (KnoxPortal) with ESMTP id 20190819234417epoutp033129d52a2ab68cfe307c50bcfb50c6ec~8d5Yp4_yK0433904339epoutp03H
        for <linux-crypto@vger.kernel.org>; Mon, 19 Aug 2019 23:44:17 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20190819234417epoutp033129d52a2ab68cfe307c50bcfb50c6ec~8d5Yp4_yK0433904339epoutp03H
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1566258257;
        bh=vmQQpSvhO+NOIFRR33czksndsdtC6ZWE3vrlipr9SU0=;
        h=Subject:To:From:Date:In-Reply-To:References:From;
        b=K/sy7g3sqhM5o09aJf2zg2WLLjCgcs0fqBl/q2EfBLQisuIDhGHKQrMqgwXZuQ+DD
         N3YQu4nb6oatCniNUuMak9wQZJhDm6QkEQwmezy/E7nMrUEngwDrgIrrcDtAsEmqrZ
         zGxE6feVtqnVVUDoM9xeMJ0hHHPH/ki4BcHO4/Xo=
Received: from epsnrtp5.localdomain (unknown [182.195.42.166]) by
        epcas1p4.samsung.com (KnoxPortal) with ESMTP id
        20190819234416epcas1p47ce8684570146aa0344c59cabf337814~8d5YR6nyQ1517015170epcas1p4M;
        Mon, 19 Aug 2019 23:44:16 +0000 (GMT)
Received: from epsmges1p3.samsung.com (unknown [182.195.40.157]) by
        epsnrtp5.localdomain (Postfix) with ESMTP id 46C9W23v0FzMqYkf; Mon, 19 Aug
        2019 23:44:14 +0000 (GMT)
Received: from epcas1p4.samsung.com ( [182.195.41.48]) by
        epsmges1p3.samsung.com (Symantec Messaging Gateway) with SMTP id
        FC.91.04066.E443B5D5; Tue, 20 Aug 2019 08:44:14 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
        epcas1p3.samsung.com (KnoxPortal) with ESMTPA id
        20190819234413epcas1p39f66a61fda4a86b7913d6f9bd7ba8c55~8d5U9KjTh0081300813epcas1p3-;
        Mon, 19 Aug 2019 23:44:13 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
        epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20190819234413epsmtrp2e632f52582d069a8cc20b205d1a4a5b2~8d5U8NuEm2043620436epsmtrp2Q;
        Mon, 19 Aug 2019 23:44:13 +0000 (GMT)
X-AuditID: b6c32a37-e27ff70000000fe2-c5-5d5b344e3b33
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
        epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        91.42.03706.D443B5D5; Tue, 20 Aug 2019 08:44:13 +0900 (KST)
Received: from [10.113.221.102] (unknown [10.113.221.102]) by
        epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
        20190819234412epsmtip12cb3f8d7a40f36bb54864a1ce6b17f1e~8d5UpZc081355113551epsmtip19;
        Mon, 19 Aug 2019 23:44:12 +0000 (GMT)
Subject: Re: [PATCH] MAINTAINERS: Extend patterns for Samsung SoC, Security
 Subsystem and clock drivers
To:     Krzysztof Kozlowski <krzk@kernel.org>,
        Kukjin Kim <kgene@kernel.org>,
        Vladimir Zapolskiy <vz@mleia.com>,
        Kamil Konieczny <k.konieczny@partner.samsung.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Tomasz Figa <tomasz.figa@gmail.com>,
        Michael Turquette <mturquette@baylibre.com>,
        Stephen Boyd <sboyd@kernel.org>,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-crypto@vger.kernel.org, linux-clk@vger.kernel.org,
        "cpgs (cpgs@samsung.com)" <cpgs@samsung.com>
From:   Chanwoo Choi <cw00.choi@samsung.com>
Organization: Samsung Electronics
Message-ID: <0bc1c3a5-cdf2-eeab-e547-97598ca1fbd1@samsung.com>
Date:   Tue, 20 Aug 2019 08:48:07 +0900
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
        Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190818172750.20921-1-krzk@kernel.org>
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrOJsWRmVeSWpSXmKPExsWy7bCmga6fSXSswdn10hYvD2lazDnfwmLR
        /UrGom/ff0aL/sevmS3On9/AbrHp8TVWi48991gt7t/7yWRxedccNosZ5/cxWVw85Wpx+E07
        q8W/axtZLFbt+sNo8f9XM7ODgMf7G63sHltW3mTy2DnrLrvHtgOqHptWdbJ5bF5S7/Fv4RQW
        j4Pv9jB59G1ZxejxeZNcAFdUtk1GamJKapFCal5yfkpmXrqtkndwvHO8qZmBoa6hpYW5kkJe
        Ym6qrZKLT4CuW2YO0B9KCmWJOaVAoYDE4mIlfTubovzSklSFjPziElul1IKUnALLAr3ixNzi
        0rx0veT8XCtDAwMjU6DChOyMv525BUeFK17/ucvYwHhOoIuRk0NCwERiweL9LF2MXBxCAjsY
        JT4vvM0I4XxilNg2aw2U841R4sej3cwwLQ3zX7JBJPYySlxcfpgJwnnPKPHn9lwWkCphgUyJ
        /et/gbWLCLxnkVixeDY7SIJNQEti/4sbbCA2v4CixNUfjxlBbF4BO4ntPc/BbBYBVYkv358y
        gdiiAhESnx4cZoWoEZQ4OfMJ2AJOAVOJmzv+gp3ELCAucevJfCYIW16ieetsZpDFEgKH2CXe
        Nr5ng7jbReLy+WusELawxKvjW9ghbCmJz+/2QtVUS6w8eYQNormDUWLL/gtQDcYS+5dOBtrA
        AbRBU2L9Ln2IsKLEzt9zGSFsXomGjb/ZIY7gk3j3tYcVpBwk3tEmBFGiLHH5wV0mCFtSYnF7
        J9sERqVZSF6bheSdWUjemYWweAEjyypGsdSC4tz01GLDAmPk6N7ECE7kWuY7GDec8znEKMDB
        qMTD6zEtKlaINbGsuDL3EKMEB7OSCG/FHKAQb0piZVVqUX58UWlOavEhRlNgyE9klhJNzgdm
        mbySeENTI2NjYwsTQzNTQ0Mlcd6FPyxihQTSE0tSs1NTC1KLYPqYODilGhgFTl/iu3ZLcmn8
        kc2Gn2LfbzqnKqL78JLhnsR54m/O6wUUORzdp8I0Mf+/0RqlIy+27tZNeirwrulcStPG5bJS
        UZO2vp50tub6D6OypX89zR3M2oXuv529vc7JqNV2q88e5ytOHLM9r7jZ7N7VJynXdKJVs8j4
        2yUznRdL1u9ll83T9GJWfjBZiaU4I9FQi7moOBEAmBA7/PoDAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrKIsWRmVeSWpSXmKPExsWy7bCSnK6vSXSswcF+NouXhzQt5pxvYbHo
        fiVj0bfvP6NF/+PXzBbnz29gt9j0+Bqrxceee6wW9+/9ZLK4vGsOm8WM8/uYLC6ecrU4/Kad
        1eLftY0sFqt2/WG0+P+rmdlBwOP9jVZ2jy0rbzJ57Jx1l91j2wFVj02rOtk8Ni+p9/i3cAqL
        x8F3e5g8+rasYvT4vEkugCuKyyYlNSezLLVI3y6BK+NvZ27BUeGK13/uMjYwnhPoYuTkkBAw
        kWiY/5Kti5GLQ0hgN6PEnblrWSESkhLTLh5l7mLkALKFJQ4fLoaoecsosX3hTjaQGmGBTIn9
        638xgiREBL6ySDy/vI8FoqqDUeLMhVZ2kCo2AS2J/S9ugHXwCyhKXP3xmBHE5hWwk9je8xzM
        ZhFQlfjy/SkTiC0qECFxeMcsqBpBiZMzn7CA2JwCphI3d/xlBrGZBdQl/sy7BGWLS9x6Mp8J
        wpaXaN46m3kCo9AsJO2zkLTMQtIyC0nLAkaWVYySqQXFuem5xYYFhnmp5XrFibnFpXnpesn5
        uZsYwZGrpbmD8fKS+EOMAhyMSjy8HtOiYoVYE8uKK3MPMUpwMCuJ8FbMAQrxpiRWVqUW5ccX
        leakFh9ilOZgURLnfZp3LFJIID2xJDU7NbUgtQgmy8TBKdXAuE5MkVdHNyGI8+gTps332Lo7
        Sr49qVO8oLLr1NbleT8qDeWv+77JPtuvmr/y7+RHTcb/Hiu5pynFzJgVoJacnpN2IEZsft/S
        4yVOL+I1Awzazv5jXCCyT8+Zf8GZ5X98yysPrtnKE9f76pZ+jq/KpHulW6fc8Jz+SjPt0Z8F
        F7fJR5w3dfBWV2Ipzkg01GIuKk4EAOjbrsTYAgAA
X-CMS-MailID: 20190819234413epcas1p39f66a61fda4a86b7913d6f9bd7ba8c55
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: SVC_REQ_APPROVE
X-CPGSPASS: Y
CMS-TYPE: 101P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20190818172803epcas1p32db0707cb391c5ca1795ba2690284a56
References: <CGME20190818172803epcas1p32db0707cb391c5ca1795ba2690284a56@epcas1p3.samsung.com>
        <20190818172750.20921-1-krzk@kernel.org>
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi Krzysztof,

On 19. 8. 19. 오전 2:27, Krzysztof Kozlowski wrote:
> Extend the patterns to cover all related files in respective
> categories:
> 1. Samsung Exynos ARM architecture: add soc drivers headers and make
>    directory matches consistent,
> 2. Samsung Security SubSystem driver (crypto): add bindings,
> 3. Samsung SoC clock drivers: add S3C24xx, S3C64xx and S5Pv210 bindings.
> 
> Cc: Kukjin Kim <kgene@kernel.org>
> Cc: Vladimir Zapolskiy <vz@mleia.com>
> Cc: Kamil Konieczny <k.konieczny@partner.samsung.com>
> Cc: Sylwester Nawrocki <s.nawrocki@samsung.com>
> Cc: Tomasz Figa <tomasz.figa@gmail.com>
> Cc: Chanwoo Choi <cw00.choi@samsung.com>
> Signed-off-by: Krzysztof Kozlowski <krzk@kernel.org>
> 
> ---
> 
> Cc: linux-arm-kernel@lists.infradead.org
> Cc: linux-samsung-soc@vger.kernel.org
> Cc: linux-crypto@vger.kernel.org
> Cc: linux-clk@vger.kernel.org
> ---
>  MAINTAINERS | 9 +++++++--
>  1 file changed, 7 insertions(+), 2 deletions(-)
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 420567d1519a..35a4002ac58b 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -2199,8 +2199,9 @@ F:	drivers/*/*s3c24*
>  F:	drivers/*/*/*s3c24*
>  F:	drivers/*/*s3c64xx*
>  F:	drivers/*/*s5pv210*
> -F:	drivers/memory/samsung/*
> -F:	drivers/soc/samsung/*
> +F:	drivers/memory/samsung/
> +F:	drivers/soc/samsung/
> +F:	include/linux/soc/samsung/
>  F:	Documentation/arm/samsung/
>  F:	Documentation/devicetree/bindings/arm/samsung/
>  F:	Documentation/devicetree/bindings/sram/samsung-sram.txt
> @@ -14174,6 +14175,8 @@ M:	Kamil Konieczny <k.konieczny@partner.samsung.com>
>  L:	linux-crypto@vger.kernel.org
>  L:	linux-samsung-soc@vger.kernel.org
>  S:	Maintained
> +F:	Documentation/devicetree/bindings/crypto/samsung-slimsss.txt
> +F:	Documentation/devicetree/bindings/crypto/samsung-sss.txt
>  F:	drivers/crypto/s5p-sss.c
>  
>  SAMSUNG S5P/EXYNOS4 SOC SERIES CAMERA SUBSYSTEM DRIVERS
> @@ -14194,6 +14197,8 @@ T:	git git://git.kernel.org/pub/scm/linux/kernel/git/snawrocki/clk.git
>  F:	drivers/clk/samsung/
>  F:	include/dt-bindings/clock/exynos*.h
>  F:	Documentation/devicetree/bindings/clock/exynos*.txt
> +F:	Documentation/devicetree/bindings/clock/samsung,s3c*
> +F:	Documentation/devicetree/bindings/clock/samsung,s5p*
>  
>  SAMSUNG SPI DRIVERS
>  M:	Kukjin Kim <kgene@kernel.org>
> 

For clock part,
Acked-by: Chanwoo Choi <cw00.choi@samsung.com>


-- 
Best Regards,
Chanwoo Choi
Samsung Electronics
