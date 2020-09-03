Return-Path: <SRS0=A9EK=CM=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 42729C433E2
	for <linux-crypto@archiver.kernel.org>; Thu,  3 Sep 2020 09:04:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0FC6B2071B
	for <linux-crypto@archiver.kernel.org>; Thu,  3 Sep 2020 09:04:39 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="KhUfao3C"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726855AbgICJEi (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 3 Sep 2020 05:04:38 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:45255 "EHLO
        mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726536AbgICJEg (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 3 Sep 2020 05:04:36 -0400
Received: from eucas1p2.samsung.com (unknown [182.198.249.207])
        by mailout1.w1.samsung.com (KnoxPortal) with ESMTP id 20200903090433euoutp0117b7fcbbc0ae4bfb374c35946d3654eb~xOrDWNKP52842728427euoutp01U
        for <linux-crypto@vger.kernel.org>; Thu,  3 Sep 2020 09:04:33 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.w1.samsung.com 20200903090433euoutp0117b7fcbbc0ae4bfb374c35946d3654eb~xOrDWNKP52842728427euoutp01U
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1599123873;
        bh=8SKkJ1P3CFsYFDquCJuoGEoO9YIbmH4NihYBqf9L70Q=;
        h=Subject:To:Cc:From:Date:In-Reply-To:References:From;
        b=KhUfao3CUy5JJLz+Ipa6lPJuR34TiZxrTt9mhcgXS1FVhR6CRXaywkfsYUUo/QKQr
         /HkDoVgHMfEQEzN803qXq31Q2sJbRtCFBnDA90RTb+5vwZIIKqhpNDxeWZwdD5iMxU
         o9E3xsPsSKlSVErc8XurrEBDMQJ214i1wFO5UZ48=
Received: from eusmges1new.samsung.com (unknown [203.254.199.242]) by
        eucas1p2.samsung.com (KnoxPortal) with ESMTP id
        20200903090433eucas1p2597db220995e3b922eaa8ff2a42a176b~xOrC-wwoo0789707897eucas1p2S;
        Thu,  3 Sep 2020 09:04:33 +0000 (GMT)
Received: from eucas1p1.samsung.com ( [182.198.249.206]) by
        eusmges1new.samsung.com (EUCPMTA) with SMTP id 79.0A.06456.1A1B05F5; Thu,  3
        Sep 2020 10:04:33 +0100 (BST)
Received: from eusmtrp1.samsung.com (unknown [182.198.249.138]) by
        eucas1p1.samsung.com (KnoxPortal) with ESMTPA id
        20200903090433eucas1p1161cd2c29655020d5625442eac095b23~xOrCjAHpg3247532475eucas1p1j;
        Thu,  3 Sep 2020 09:04:33 +0000 (GMT)
Received: from eusmgms2.samsung.com (unknown [182.198.249.180]) by
        eusmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20200903090432eusmtrp170e3fc3581c9c22e1051e3504c642787~xOrChopjX2799327993eusmtrp1G;
        Thu,  3 Sep 2020 09:04:32 +0000 (GMT)
X-AuditID: cbfec7f2-809ff70000001938-c8-5f50b1a10bed
Received: from eusmtip1.samsung.com ( [203.254.199.221]) by
        eusmgms2.samsung.com (EUCPMTA) with SMTP id 6C.B1.06017.0A1B05F5; Thu,  3
        Sep 2020 10:04:32 +0100 (BST)
Received: from [106.120.51.18] (unknown [106.120.51.18]) by
        eusmtip1.samsung.com (KnoxPortal) with ESMTPA id
        20200903090432eusmtip149265b768cb1c43ed1f8101726aacc0f~xOrCG8EOd2874328743eusmtip1K;
        Thu,  3 Sep 2020 09:04:32 +0000 (GMT)
Subject: Re: [PATCH] crypto: s5p-sss: remove redundant null check
To:     Xu Wang <vulab@iscas.ac.cn>, krzk@kernel.org, vz@mleia.com,
        herbert@gondor.apana.org.au, davem@davemloft.net
Cc:     linux-crypto@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        linux-kernel@vger.kernel.org
From:   Kamil Konieczny <k.konieczny@samsung.com>
Message-ID: <5349cd5e-4ea5-3cc5-971a-b96b499b6f25@samsung.com>
Date:   Thu, 3 Sep 2020 11:04:32 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
        Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200903083738.85345-1-vulab@iscas.ac.cn>
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA01SfSyUcRzf73m5e5iznyP3HVbbjam2yErOLkqrua2RsmXawuEZ8to9TvjL
        IsvFZip0k9CLl5ZyJG7cMO+GJnlJZStmxJSjxYacJ8t/n7fvfp/P9mNIsY62Y2ISkllVgjJO
        KjCnGrvXh46V1wWEHtcXgaxkOIuS3VtwkA0PvxHKpr+uE7IP+hKBrHjYQMiq77RSsu2NTPIs
        o2ioniQUjW1OCkNTPVLoanIEiq3yB5TCqDsYILhmfjqSjYtJYVWu3mHm0c1ZI3RSNp36NF+P
        MlAFpUFmDOCTMLnYRGiQOSPGVQgGGrsonqwi+PLjO80TI4IX1ePCvZNNYwvijUoEVT/rkckQ
        4yUEzf0SE7bGPmBs3949sMEqGMspoE2YxBGwYpja1QXYFdoH+3Z7iLA3dOrGSA1iGAo7wvPb
        Pib5AA6G5tl5IR+xgr5HM7txM+wBf97zfUgsgU8zTwgeH4J3SyWkqRtgvRDylhdpvvR5+Jg9
        9W+ANSz0NPzDDjBwP5fiDzJ39mc8FPIkF0HraoOAT8nB+KtNYGpH4iPwWu/Kyz6w+KqOMsmA
        LWFiyYovYQkFjUUkL4vgbraYTzvBXH8uwWN70GzX0vlIqt03TbtvjnbfHO3/d8sQVYMkrJqL
        j2I5twT2lgunjOfUCVEuEYnxOrTzkwa2elaa0NpIeAfCDJJaiHrfXgoV08oULi2+AwFDSm1E
        5wYHQsSiSGVaOqtKDFWp41iuA9kzlFQiOlExf12Mo5TJbCzLJrGqPZdgzOwykI+w2f3w48DU
        iUpveWFYuu7yleI85zpnua08TCKpkG4OhRumoy16PguIod9wsbas0k9L+I62Bnm4t3nW0Rtn
        Bn2/oS6vvrmu2Zar8vFO8eiErdczqSFKGHJqyW8msLe79YZ/7FbA2subpaWOwZoVf0/FBQ4C
        CpcX1EG1VSWOUoqLVrodJVWc8i8qeXM7RQMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrCIsWRmVeSWpSXmKPExsVy+t/xu7oLNgbEG8z6aGkx53wLi0X3KxmL
        8+c3sFvcv/eTyeLyrjlsFjPO72OyWNm6l8Xi/69mZgcOjy0rbzJ5bDug6rFvx2ZGj02rOtk8
        /i2cwuLxeZNcAFuUnk1RfmlJqkJGfnGJrVK0oYWRnqGlhZ6RiaWeobF5rJWRqZK+nU1Kak5m
        WWqRvl2CXsbOlkusBW2sFYsn7GJsYFzE0sXIySEhYCLx9/Mexi5GLg4hgaWMEjMu32CFSEhL
        NJ5ezQRhC0v8udbFBlH0mlGicVYPWJGwgKPE54P/2UFsEYEiibYZk5hBbGaBZIkPy/ZDTe1i
        lLh1bRMbSIJNQF/i4NmTYKt5Bewkjmy6BtTAwcEioCKxtMkRxBQViJTYucMSokJQ4uTMJ2DV
        nALmEj8uXGeHGK8u8WfeJahV4hK3nsxngrDlJba/ncM8gVFoFpL2WUhaZiFpmYWkZQEjyypG
        kdTS4tz03GIjveLE3OLSvHS95PzcTYzAGNx27OeWHYxd74IPMQpwMCrx8J7Y6h8vxJpYVlyZ
        e4hRgoNZSYTX6ezpOCHelMTKqtSi/Pii0pzU4kOMpkCvTWSWEk3OB6aHvJJ4Q1NDcwtLQ3Nj
        c2MzCyVx3g6BgzFCAumJJanZqakFqUUwfUwcnFINjAvnr2vnjJZqiTDXPHtrXr1LgBFnVLbi
        pOj6X0UrzxtOUFoYk/Ly1AeTIqkwdf2DjgukGy+d2u3M/ed2Xsupi4yx+w2NeduDNK97Ry6p
        /RVtXXugg89319qp881FMjx/X3I5PfO4Jc/EH7dX3PDx9P7PfkxnyZWly8p3rfv38qxeRdvX
        ldn9b5VYijMSDbWYi4oTAeZCP9rXAgAA
X-CMS-MailID: 20200903090433eucas1p1161cd2c29655020d5625442eac095b23
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-RootMTR: 20200903083751eucas1p2e8419fda42358247a38e5f6c6b345414
X-EPHeader: CA
CMS-TYPE: 201P
X-CMS-RootMailID: 20200903083751eucas1p2e8419fda42358247a38e5f6c6b345414
References: <CGME20200903083751eucas1p2e8419fda42358247a38e5f6c6b345414@eucas1p2.samsung.com>
        <20200903083738.85345-1-vulab@iscas.ac.cn>
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org



On 9/3/20 10:37 AM, Xu Wang wrote:
> Because clk_disable_unprepare already checked NULL clock
> parameter, so the additional checks are unnecessary, just remove them.
> 
> Signed-off-by: Xu Wang <vulab@iscas.ac.cn>
> ---
>  drivers/crypto/s5p-sss.c | 6 ++----
>  1 file changed, 2 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/crypto/s5p-sss.c b/drivers/crypto/s5p-sss.c
> index 341433fbcc4a..fdcbfd45c884 100644
> --- a/drivers/crypto/s5p-sss.c
> +++ b/drivers/crypto/s5p-sss.c
> @@ -2307,8 +2307,7 @@ static int s5p_aes_probe(struct platform_device *pdev)
> [...]

Acked-by: Kamil Konieczny <k.konieczny@samsung.com>
