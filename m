Return-Path: <SRS0=Eyne=7C=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B939FC433E2
	for <linux-crypto@archiver.kernel.org>; Wed, 20 May 2020 08:18:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8B3762072C
	for <linux-crypto@archiver.kernel.org>; Wed, 20 May 2020 08:18:36 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="YvT6s8mK"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726436AbgETISf (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 20 May 2020 04:18:35 -0400
Received: from mailout2.w1.samsung.com ([210.118.77.12]:56053 "EHLO
        mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726425AbgETISf (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 20 May 2020 04:18:35 -0400
Received: from eucas1p1.samsung.com (unknown [182.198.249.206])
        by mailout2.w1.samsung.com (KnoxPortal) with ESMTP id 20200520081832euoutp02d46899f6d9941e2581509da47d9b1a62~QrqmqdVs_2998929989euoutp02R
        for <linux-crypto@vger.kernel.org>; Wed, 20 May 2020 08:18:32 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.w1.samsung.com 20200520081832euoutp02d46899f6d9941e2581509da47d9b1a62~QrqmqdVs_2998929989euoutp02R
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1589962712;
        bh=ofqge9eLurcw12bkh9bRZU2bEi4+BPAAQ1dx+dpIZQI=;
        h=Subject:To:Cc:From:Date:In-Reply-To:References:From;
        b=YvT6s8mKd0OKIQJfx84xXHF7ZsyXKEG7LHQ1XVrITcieAmJq97kZdCZNM5F/2iarM
         4qBPwRF5VnDvvT5qy1Xgh0wBTxXZoGHuOg0zakNUZdGLtQk29L5kywf0vcpLkq0J/j
         qB4RQHFVCeJb5mPPGKefcmkOCPomRmBl9upI8Uk8=
Received: from eusmges3new.samsung.com (unknown [203.254.199.245]) by
        eucas1p1.samsung.com (KnoxPortal) with ESMTP id
        20200520081831eucas1p106cf83e4f00015b72f80e760a0eceee4~QrqmQw4uq2188421884eucas1p1i;
        Wed, 20 May 2020 08:18:31 +0000 (GMT)
Received: from eucas1p2.samsung.com ( [182.198.249.207]) by
        eusmges3new.samsung.com (EUCPMTA) with SMTP id 53.2B.60698.7D7E4CE5; Wed, 20
        May 2020 09:18:31 +0100 (BST)
Received: from eusmtrp2.samsung.com (unknown [182.198.249.139]) by
        eucas1p2.samsung.com (KnoxPortal) with ESMTPA id
        20200520081831eucas1p2fef65ce5e9847e051f0c9d13e03c1892~QrqlzlBHK1468714687eucas1p21;
        Wed, 20 May 2020 08:18:31 +0000 (GMT)
Received: from eusmgms1.samsung.com (unknown [182.198.249.179]) by
        eusmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20200520081831eusmtrp2e900a7aed40971e6833b817be2124e31~QrqlysWqC0267902679eusmtrp2j;
        Wed, 20 May 2020 08:18:31 +0000 (GMT)
X-AuditID: cbfec7f5-a0fff7000001ed1a-09-5ec4e7d7ab51
Received: from eusmtip2.samsung.com ( [203.254.199.222]) by
        eusmgms1.samsung.com (EUCPMTA) with SMTP id C8.D1.08375.7D7E4CE5; Wed, 20
        May 2020 09:18:31 +0100 (BST)
Received: from [106.120.51.18] (unknown [106.120.51.18]) by
        eusmtip2.samsung.com (KnoxPortal) with ESMTPA id
        20200520081830eusmtip20b394f0405bf25bf73ffaca23c8ea528~Qrqk4AggG2560225602eusmtip2h;
        Wed, 20 May 2020 08:18:30 +0000 (GMT)
Subject: Re: [PATCH v2 1/2] hwrng: iproc-rng200 - Set the quality value
To:     =?UTF-8?Q?=c5=81ukasz_Stelmach?= <l.stelmach@samsung.com>,
        Matt Mackall <mpm@selenic.com>,
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
        linux-samsung-soc@vger.kernel.org,
        Stephan Mueller <smueller@chronox.de>
Cc:     Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
From:   Kamil Konieczny <k.konieczny@samsung.com>
Message-ID: <a257d9fe-0a6d-8dd5-cdaf-5b3e7fdf3391@samsung.com>
Date:   Wed, 20 May 2020 10:18:30 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
        Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <20200519212552.11671-2-l.stelmach@samsung.com>
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA01Sf0zMYRzee9+fF9e+neizamy3RTFCmXfH/C7fjT/848dY5eiroiu7k59/
        aFJcl7RLo6M5+l1yue5uYirnCKkbwmFpdpFYNv1Ahbj7Mv33vM/zed7n87x7WUJeRAezKWn7
        BE2aKlVB+5H2eyOuuS96nfHzq4vn4J+Gewy+ds5M4bpTd0ns0lUSePSzk8FZpWYa6z+G4tOe
        TwR2ueoZ/NJRhbDF85zC3W9GJPjpjQs0PudqkmBTYQ+FTfZ8hN8VN9D4c20PwkVtdSRuva8j
        VgTyY6MGxBu722l+oLNTwjcauxi+1NJM8/aWMN5So6P55pIrDN9QdpTPt9YgPr+vHvFm6zOS
        P/bwBMUPWqZv8N/qtzRRSE3ZL2gil233S7Z1Wai9lZMOdpTqUSZqk+YiKQtcNDQP32RykR8r
        56oQ5D2rJr2CnBtCkD2cLAqDCB4d7/gjsD5HdkWCyFci6MhppsRDP4JftlHa657CrYVL7grS
        KwRyfRTUl1/3CQSHwWarZbyY5iLhdvsDX5yMWwZu02sfT3JhcEk/4sNTuS0wbvD8nQmAB8U9
        vi2k3FIw6JTilUHwqueiRMQzIMt2nvDmAtfJQvWXJlLsuQYsDU6JiKfAx1YrI+JQGG/0mr2G
        LARtmUWMeMhDcGvISotTS2DwSwvtTSa4CDDfiBTpleAceEyLz+IP7v4AcQl/MNjPEiItg5M5
        cnE6DHof5v1dIQRyx69SBUhhnNDMOKGOcUId4/9cEyJrUJCQoVUnCdqoNOHAPK1Krc1IS5q3
        M11tQX8+a9uv1uHrqOnHDgfiWKSYLHM33omXU6r92kNqBwKWUATKCj444uWyRNWhw4ImPUGT
        kSpoHSiEJRVBsqjLfXFyLkm1T9gjCHsFzT9VwkqDM1HxrIGxEiVrlTO7aj2eb+bu8YtSXbJm
        29vhmNZFm9/bo1ULXhNPlNsG+BhWMmMwMJipyywv2hSr7zJt3L163eL6XXX5oZ15eHF6hDM6
        /IrBvGF50211b5x+5xD1Jqns+7Sase2rFimPuHPKrdXlH7jCnFPhQseaM5fXz1xofPk1VkFq
        k1ULZhMareo3HdwD56gDAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA02Sa0hTcRjG+++cnU1rdZwz/5ldPCCS4OY03V8xqQ/ioQ92QyordehBLbfF
        OVO0L2oiOiVvEeiy1Czvpc5NKipzecnmDTNvZQYqlppBBuGlTB2B3x6e5/m9vC+8QkxczXcS
        xqm1DKtWxlOELW752/XZY2S2PdxzpU6E/hR2ClBTUQMfPb7VgaN+XRWGVhbbBSi9ooFAOXPO
        KG9qHkP9/Y0CNGauBsgwNcxHk5+Xeej98xICFfW/4qGy29N8VNaSC9BMcTOBFuumAbpjeYyj
        rrc67LiEXl0pBLR+spegfw4N8ehn+gkBXWFoJeiW1660oVZH0K336gV088MUOtdYC+jcb42A
        bjB+wOmb7zL59JLh4OndYdIAVpOgZQ7HajjtMeqSHHlJ5X5I6nXUTyr3Vlzx9/KhZIEB0Ux8
        XCLDygIjpbGmCQP/etXOpL6KHJAKLDbZQCiE5FGYURmRDWyFYvIRgB8XBohsYLPh74dpljqe
        VdvDteFswlqaB3B0bGGrZE8Gw/LRSnwzkJDf+XCu0IhvBhiJoMlUJ7ASSwDOWFoFmwFBymBb
        b/dWSUQGwtGyj1s+TrrC8pzlLe1AXoBLbe2EtWMHu4un8c1VbcgAWKjzt853g2v3BzGrdoTj
        06U8qz4E0013sXwg1m+j9dsQ/TZEvw0pA3gtkDAJnCpGxcmlnFLFJahjpFEalQFsfElL53Lz
        UzDYdM4MSCGgdok8X7wJF/OViVyyygygEKMkovyv5nCxKFqZfINhNRFsQjzDmYHPxm0FmJND
        lGbj59TaCLmPXIH85ApvhbcvohxFWWTbZTEZo9Qy1xjmOsP+53hCG6dUcHXyx5eePSnEjvPe
        QTWueoeOLA9Hg0tvZtSUOvhAdOXAvi7qlDHHfjFswr2nL+R3zUXpmdV10/qsNtYtFNYPjWae
        oEM70jJd9LqlI+TeT6kDIbpxNsMOeb3Me5K0crbE+UGkMSTIF8kkySPl9ePnWZl4NeRgyqpk
        rfTXyQIFReFcrFLujrGc8h84CK51OwMAAA==
X-CMS-MailID: 20200520081831eucas1p2fef65ce5e9847e051f0c9d13e03c1892
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-RootMTR: 20200519212619eucas1p22fa5d3db2521096dc4b79f6e53016d17
X-EPHeader: CA
CMS-TYPE: 201P
X-CMS-RootMailID: 20200519212619eucas1p22fa5d3db2521096dc4b79f6e53016d17
References: <20200514190734.32746-1-l.stelmach@samsung.com>
        <20200519212552.11671-1-l.stelmach@samsung.com>
        <CGME20200519212619eucas1p22fa5d3db2521096dc4b79f6e53016d17@eucas1p2.samsung.com>
        <20200519212552.11671-2-l.stelmach@samsung.com>
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi,

On 19.05.2020 23:25, Łukasz Stelmach wrote:
> The value was estimaded with ea_iid[1] using on 10485760 bytes read from
> the RNG via /dev/hwrng. The min-entropy value calculated using the most
> common value estimate (NIST SP 800-90P[2], section 6.3.1) was 7.964464.
> 
> [1] https://protect2.fireeye.com/url?k=316f3d79-6cf9840e-316eb636-0cc47a312ab0-5f119f729b3ddc11&q=1&u=https%3A%2F%2Fgithub.com%2Fusnistgov%2FSP800-90B_EntropyAssessment

This link looks ugly and do not protect anything.
Can you just cut out that "protect2" thing and put proper direct link to github ?

> [2] https://csrc.nist.gov/publications/detail/sp/800-90b/final
> 
> Signed-off-by: Łukasz Stelmach <l.stelmach@samsung.com>
> ---
>  drivers/char/hw_random/iproc-rng200.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/char/hw_random/iproc-rng200.c b/drivers/char/hw_random/iproc-rng200.c
> index 32d9fe61a225..95669ece050f 100644
> --- a/drivers/char/hw_random/iproc-rng200.c
> +++ b/drivers/char/hw_random/iproc-rng200.c
> @@ -199,6 +199,7 @@ static int iproc_rng200_probe(struct platform_device *pdev)
>  	priv->rng.read = iproc_rng200_read,
>  	priv->rng.init = iproc_rng200_init,
>  	priv->rng.cleanup = iproc_rng200_cleanup,
> +	priv->rng.quality = 1000,
>  
>  	/* Register driver */
>  	ret = devm_hwrng_register(dev, &priv->rng);
> 

-- 
Best regards,
Kamil Konieczny
Samsung R&D Institute Poland

