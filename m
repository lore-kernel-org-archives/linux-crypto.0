Return-Path: <SRS0=8F2V=WQ=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 283D7C3A589
	for <linux-crypto@archiver.kernel.org>; Tue, 20 Aug 2019 09:51:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E1C1622CF7
	for <linux-crypto@archiver.kernel.org>; Tue, 20 Aug 2019 09:51:21 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="cm89pN4f"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729426AbfHTJvU (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 20 Aug 2019 05:51:20 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:38981 "EHLO
        mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729396AbfHTJvU (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 20 Aug 2019 05:51:20 -0400
Received: from eucas1p2.samsung.com (unknown [182.198.249.207])
        by mailout1.w1.samsung.com (KnoxPortal) with ESMTP id 20190820095118euoutp01845b801f357292b77fbb6927078ed151~8mLYndFVQ2255322553euoutp01Z
        for <linux-crypto@vger.kernel.org>; Tue, 20 Aug 2019 09:51:18 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.w1.samsung.com 20190820095118euoutp01845b801f357292b77fbb6927078ed151~8mLYndFVQ2255322553euoutp01Z
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1566294678;
        bh=Ria6Ts4p/gejJHlfXvC/EYsyxDWKSLIxPSraAQyiQRg=;
        h=Subject:To:Cc:From:Date:In-Reply-To:References:From;
        b=cm89pN4fLtgAlCzL0qUp5O36j7SNJ+VkwKqLdcmrZxMMVC6ny4VTDK5A8CS7jdZiS
         ypjcdW2Ykad8AwP8K1MbU7V1tCY2v+xJfysljPqIGNNgassV2TskGby8c2mXYe58R4
         PgNc4/MC5Kn4FD9F+9atepKXQAkIWeICDagBgP84=
Received: from eusmges3new.samsung.com (unknown [203.254.199.245]) by
        eucas1p1.samsung.com (KnoxPortal) with ESMTP id
        20190820095118eucas1p11c0eb071023691e46fe34f67b441cf3d~8mLYKqr063186931869eucas1p1v;
        Tue, 20 Aug 2019 09:51:18 +0000 (GMT)
Received: from eucas1p2.samsung.com ( [182.198.249.207]) by
        eusmges3new.samsung.com (EUCPMTA) with SMTP id 95.40.04374.592CB5D5; Tue, 20
        Aug 2019 10:51:17 +0100 (BST)
Received: from eusmtrp1.samsung.com (unknown [182.198.249.138]) by
        eucas1p1.samsung.com (KnoxPortal) with ESMTPA id
        20190820095117eucas1p19f867e0bf42eea9750548c90cfafe644~8mLXbOi3w3107331073eucas1p1I;
        Tue, 20 Aug 2019 09:51:17 +0000 (GMT)
Received: from eusmgms2.samsung.com (unknown [182.198.249.180]) by
        eusmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20190820095117eusmtrp1ac5ceb3199e6f8868b2e8b1d22cf73ed~8mLXM6kos2773327733eusmtrp1J;
        Tue, 20 Aug 2019 09:51:17 +0000 (GMT)
X-AuditID: cbfec7f5-4ddff70000001116-04-5d5bc295e453
Received: from eusmtip2.samsung.com ( [203.254.199.222]) by
        eusmgms2.samsung.com (EUCPMTA) with SMTP id B0.B9.04117.492CB5D5; Tue, 20
        Aug 2019 10:51:16 +0100 (BST)
Received: from [106.120.51.18] (unknown [106.120.51.18]) by
        eusmtip2.samsung.com (KnoxPortal) with ESMTPA id
        20190820095116eusmtip27176177f7709d721edeba2701bc6a8d0~8mLW6PgGL2921529215eusmtip2k;
        Tue, 20 Aug 2019 09:51:16 +0000 (GMT)
Subject: Re: [PATCH 1/2] crypto: s5p - deal gracefully with bogus input
 sizes
To:     Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        linux-crypto@vger.kernel.org
Cc:     herbert@gondor.apana.org.au, Krzysztof Kozlowski <krzk@kernel.org>,
        Vladimir Zapolskiy <vz@mleia.com>,
        linux-samsung-soc@vger.kernel.org
From:   Kamil Konieczny <k.konieczny@partner.samsung.com>
Message-ID: <e0eec29e-d869-0d58-75d9-1e2118b649ef@partner.samsung.com>
Date:   Tue, 20 Aug 2019 11:51:15 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
        Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190819142226.1703-2-ard.biesheuvel@linaro.org>
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrMKsWRmVeSWpSXmKPExsWy7djP87pTD0XHGuzv17P4/2E3o0X3KxmL
        8+c3sFvcv/eTyWLG+X1MFv9/NTM7sHlsO6DqsWlVJ5vHnWt72Dz+LZzC4vF5k1wAaxSXTUpq
        TmZZapG+XQJXxpRHrSwF17kr9iyfwdzAuJ+zi5GTQ0LAROJo21zmLkYuDiGBFYwS5769YoVw
        vjBKHHo1lQ3C+cwosezmCiCHA6zlUpc4RHw5o8TKWReYIJy3jBLb7h1mBJkrLOAvcWHzErAG
        EQEfiUsnwRqYBfoYJbYv3MwKUsMmYC7xaPsZJhCbV8BN4vLdGWwgNouAqsT1hVfB5ogKREh8
        enCYFaJGUOLkzCcsIDangJ3E6U3v2EFsZgFxiVtP5jNB2PIS29/OAftHQmAdu8TK/lY2iEdd
        JCZOamGCsIUlXh3fwg5hy0icntzDAmGXSzxd2McO0dzCKPGg/SNUwlri8PGLrCDfMAtoSqzf
        pQ8RdpSYe/IVNFT4JG68FYS4gU9i0rbpzBBhXomONiGIalWJ56d6oC6Qluj6v451AqPSLCSf
        zULyzSwk38xC2LuAkWUVo3hqaXFuemqxcV5quV5xYm5xaV66XnJ+7iZGYNI5/e/41x2M+/4k
        HWIU4GBU4uH1mBYVK8SaWFZcmXuIUYKDWUmEt2IOUIg3JbGyKrUoP76oNCe1+BCjNAeLkjhv
        NcODaCGB9MSS1OzU1ILUIpgsEwenVANju3xlIFtvV9n+o3PnvODqW8y1hT9ZVjedeeKUmctP
        ce2+vlY7TGbq5PjN5z5sfPI5+PiSBLZQK9flV6uaH7GpfHqyc3dzoqyF+5lrN3hvv28vOCdl
        EvD74eatR7ddE7OJXxx5xbD237YlgndaeKPO/vp05KXDguq//k5rkx6XC1kd7vu5VfviHCWW
        4oxEQy3mouJEANB1eFI2AwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrGIsWRmVeSWpSXmKPExsVy+t/xe7pTDkXHGsyaamPx/8NuRovuVzIW
        589vYLe4f+8nk8WM8/uYLP7/amZ2YPPYdkDVY9OqTjaPO9f2sHn8WziFxePzJrkA1ig9m6L8
        0pJUhYz84hJbpWhDCyM9Q0sLPSMTSz1DY/NYKyNTJX07m5TUnMyy1CJ9uwS9jCmPWlkKrnNX
        7Fk+g7mBcT9nFyMHh4SAicSlLvEuRi4OIYGljBKzL6xn7WLkBIpLSzSeXs0EYQtL/LnWxQZR
        9JpR4snaX+wgCWEBX4n56/vZQQaJCPhIXDoJNohZoI9RomHuTHaIhqOMEvcbmplBGtgEzCUe
        bT8DNpVXwE3i8t0ZbCA2i4CqxPWFVxlBbFGBCInDO2YxQtQISpyc+YQFxOYUsJM4vekd2GJm
        AXWJP/MuMUPY4hK3nsxngrDlJba/ncM8gVFoFpL2WUhaZiFpmYWkZQEjyypGkdTS4tz03GIj
        veLE3OLSvHS95PzcTYzAONt27OeWHYxd74IPMQpwMCrx8HpMi4oVYk0sK67MPcQowcGsJMJb
        MQcoxJuSWFmVWpQfX1Sak1p8iNEU6LmJzFKiyfnAFJBXEm9oamhuYWlobmxubGahJM7bIXAw
        RkggPbEkNTs1tSC1CKaPiYNTqoGxve6boO+Gr0IJr7yv7PksfY2d16b0cPfrzUmMi/meiPbP
        EZ83f42h4b+k/ttae3Vvam01KHp64a3xAUnxarc1yf3Hjol/2lioPtP03VPnv3f7RKdaLy1U
        Of9j7bKTT3m9mxk1D2yqv+T6o41Lj7FFyTJa7tQPpnd+DKunL1xkEXqf6f2iea+9lViKMxIN
        tZiLihMBfTc3NskCAAA=
X-CMS-MailID: 20190820095117eucas1p19f867e0bf42eea9750548c90cfafe644
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-RootMTR: 20190819142411epcas2p2237fe8748123416a55680322244c4717
X-EPHeader: CA
CMS-TYPE: 201P
X-CMS-RootMailID: 20190819142411epcas2p2237fe8748123416a55680322244c4717
References: <20190819142226.1703-1-ard.biesheuvel@linaro.org>
        <CGME20190819142411epcas2p2237fe8748123416a55680322244c4717@epcas2p2.samsung.com>
        <20190819142226.1703-2-ard.biesheuvel@linaro.org>
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org



On 19.08.2019 16:22, Ard Biesheuvel wrote:
> The s5p skcipher driver returns -EINVAL for zero length inputs, which
> deviates from the behavior of the generic ECB template, and causes fuzz
> tests to fail. In cases where the input is not a multiple of the AES
> block size (and the chaining mode is not CTR), it prints an error to
> the kernel log, which is a thing we usually try to avoid in response
> to situations that can be triggered by unprivileged users.
> 
> Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
> ---
>  drivers/crypto/s5p-sss.c | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/crypto/s5p-sss.c b/drivers/crypto/s5p-sss.c
> index 9ef25230c199..ef90c58edb1f 100644
> --- a/drivers/crypto/s5p-sss.c
> +++ b/drivers/crypto/s5p-sss.c
> @@ -2056,9 +2056,12 @@ static int s5p_aes_crypt(struct ablkcipher_request *req, unsigned long mode)
>  	struct s5p_aes_ctx *ctx = crypto_ablkcipher_ctx(tfm);
>  	struct s5p_aes_dev *dev = ctx->dev;
>  
> +	if (!req->nbytes)
> +		return 0;
> +
>  	if (!IS_ALIGNED(req->nbytes, AES_BLOCK_SIZE) &&
>  			((mode & FLAGS_AES_MODE_MASK) != FLAGS_AES_CTR)) {
> -		dev_err(dev->dev, "request size is not exact amount of AES blocks\n");
> +		dev_dbg(dev->dev, "request size is not exact amount of AES blocks\n");
>  		return -EINVAL;
>  	}

Acked-by: Kamil Konieczny <k.konieczny@partner.samsung.com>

-- 
Best regards,
Kamil Konieczny
Samsung R&D Institute Poland

