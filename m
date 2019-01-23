Return-Path: <SRS0=I8vn=P7=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4AB0DC282C0
	for <linux-crypto@archiver.kernel.org>; Wed, 23 Jan 2019 14:27:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D5FFC21726
	for <linux-crypto@archiver.kernel.org>; Wed, 23 Jan 2019 14:27:19 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="TYqz7e9z"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727100AbfAWO1T (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 23 Jan 2019 09:27:19 -0500
Received: from mailout2.w1.samsung.com ([210.118.77.12]:50160 "EHLO
        mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726236AbfAWO1T (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 23 Jan 2019 09:27:19 -0500
Received: from eucas1p2.samsung.com (unknown [182.198.249.207])
        by mailout2.w1.samsung.com (KnoxPortal) with ESMTP id 20190123142717euoutp02df9c85e469287e5c9ac83f78feb8cbab~8gHr3CWoy0344603446euoutp02U
        for <linux-crypto@vger.kernel.org>; Wed, 23 Jan 2019 14:27:17 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.w1.samsung.com 20190123142717euoutp02df9c85e469287e5c9ac83f78feb8cbab~8gHr3CWoy0344603446euoutp02U
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1548253637;
        bh=AugPDrmgrMRjM0cHD/ojRLVacU55v3gLC/WAbxNm5/A=;
        h=Subject:To:Cc:From:Date:In-Reply-To:References:From;
        b=TYqz7e9zc99f0zgjuvrUj4f9eqfDcdJv1h973IzO+8glvcKSZG17VtKaU6s0z35bD
         ymJ/l83pdUH0udLtgJfD8AjkjDA4g4i5FxctOxz7wdGrmKJQdeRoNzlnl9bvV5PBG0
         L7Op4JgYUyIuKYOLtLVzgKCaYs7NJmRuVfHGZ6YQ=
Received: from eusmges2new.samsung.com (unknown [203.254.199.244]) by
        eucas1p2.samsung.com (KnoxPortal) with ESMTP id
        20190123142717eucas1p20f42ad1213b1473099ef1bb306bd0bad~8gHrbpQ9t1770217702eucas1p2k;
        Wed, 23 Jan 2019 14:27:17 +0000 (GMT)
Received: from eucas1p2.samsung.com ( [182.198.249.207]) by
        eusmges2new.samsung.com (EUCPMTA) with SMTP id 11.A9.04294.4C9784C5; Wed, 23
        Jan 2019 14:27:16 +0000 (GMT)
Received: from eusmtrp2.samsung.com (unknown [182.198.249.139]) by
        eucas1p1.samsung.com (KnoxPortal) with ESMTPA id
        20190123142716eucas1p1119528e3db67c463436bb1fd87dda6bf~8gHql4nEI1853418534eucas1p1c;
        Wed, 23 Jan 2019 14:27:16 +0000 (GMT)
Received: from eusmgms2.samsung.com (unknown [182.198.249.180]) by
        eusmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20190123142715eusmtrp260d3878a17b594a6bc674670a8bd8755~8gHqXLhfF2535025350eusmtrp2f;
        Wed, 23 Jan 2019 14:27:15 +0000 (GMT)
X-AuditID: cbfec7f4-c77a99c0000010c6-5b-5c4879c48669
Received: from eusmtip1.samsung.com ( [203.254.199.221]) by
        eusmgms2.samsung.com (EUCPMTA) with SMTP id BE.87.04128.3C9784C5; Wed, 23
        Jan 2019 14:27:15 +0000 (GMT)
Received: from [106.120.51.18] (unknown [106.120.51.18]) by
        eusmtip1.samsung.com (KnoxPortal) with ESMTPA id
        20190123142715eusmtip170295fd8f3ec55011b6fef21569e42ba~8gHp3mOGw3092430924eusmtip1y;
        Wed, 23 Jan 2019 14:27:15 +0000 (GMT)
Subject: Re: [PATCH v1 3/3] crypto: s5p: add AES support for Exynos5433
To:     Krzysztof Kozlowski <krzk@kernel.org>
Cc:     Vladimir Zapolskiy <vz@mleia.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org,
        "linux-samsung-soc@vger.kernel.org" 
        <linux-samsung-soc@vger.kernel.org>, linux-kernel@vger.kernel.org,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>
From:   Kamil Konieczny <k.konieczny@partner.samsung.com>
Message-ID: <9654ab25-2f9f-9bd1-e60c-df1ba5e90e98@partner.samsung.com>
Date:   Wed, 23 Jan 2019 15:27:14 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
        Thunderbird/60.2.1
MIME-Version: 1.0
In-Reply-To: <CAJKOXPdkDrwy2rSs-Fj1rq8rTOHvtQTrZTY5ER=pPWRPwx5qfA@mail.gmail.com>
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrKKsWRmVeSWpSXmKPExsWy7djP87pHKj1iDLoO61psnLGe1WLO+RYW
        i+5XMhbnz29gt7h/7yeTxeVdc9gsZpzfx2Sx9shddov/v5qZHTg9tqy8yeSx7YCqx6ZVnWwe
        /xZOYfHo27KK0ePzJrkAtigum5TUnMyy1CJ9uwSujMmbe1gK3vNW3P21iaWBcSJnFyMHh4SA
        icTh5/FdjFwcQgIrGCX2XfvIDuF8AXImNkM5nxkl/jT2scB0HJ0oBRFfzijxd8sjVgjnLaPE
        5fMzmLsYOTmEBdwl/l7fwAhiiwhoSlz/+x2siFngFZPEpu63YAk2AXOJR9vPMIFM5RVwk1h9
        xwckzCKgKrHqSy/YHFGBCImO+6vZQGxeAUGJkzOfgB3BKRAosfqAFUiYWUBc4taT+UwQtrzE
        9rdzmEFWSQicY5fombEcrFdCwEXiz4lmJghbWOLV8S3sELaMxP+d86Hi5RK7tz5jh2huYZSY
        O3kRVMJa4vDxi6wgi5mBnlm/Sx8i7CjxaOIzaKDwSdx4KwhxA5/EpG3TmSHCvBIdbUIQ1boS
        8/6fYYWwpSW6/q9jncCoNAvJY7OQfDMLyTezEPYuYGRZxSieWlqcm55abJSXWq5XnJhbXJqX
        rpecn7uJEZiYTv87/mUH464/SYcYBTgYlXh4OQo9YoRYE8uKK3MPMUpwMCuJ8LpedIsR4k1J
        rKxKLcqPLyrNSS0+xCjNwaIkzlvN8CBaSCA9sSQ1OzW1ILUIJsvEwSnVwGj2dr/4r6tF2hdV
        U/8n3A6+fcOhWrum/6naD7tp03wjfzXc85gevvLui71C59135+Wej5P6Odn69jR1l/UTzDR3
        Myi+XnL25Ua1O9kmDwKnO3C4710UxJV00sZ516WyRd5Ki0qvXK9QUl0fGrxe+vbmCeZiFzpy
        9cpLzdvOt525uLM1YvtnzZlKLMUZiYZazEXFiQBK/76pSAMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrJIsWRmVeSWpSXmKPExsVy+t/xu7qHKz1iDFp3G1lsnLGe1WLO+RYW
        i+5XMhbnz29gt7h/7yeTxeVdc9gsZpzfx2Sx9shddov/v5qZHTg9tqy8yeSx7YCqx6ZVnWwe
        /xZOYfHo27KK0ePzJrkAtig9m6L80pJUhYz84hJbpWhDCyM9Q0sLPSMTSz1DY/NYKyNTJX07
        m5TUnMyy1CJ9uwS9jMmbe1gK3vNW3P21iaWBcSJnFyMHh4SAicTRiVJdjFwcQgJLGSXap65m
        7mLkBIpLSzSeXs0EYQtL/LnWxQZR9JpR4sOp9WwgCWEBd4m/1zcwgtgiApoS1/9+ZwUpYhZ4
        wyTROHchO0THDCaJaX+bWUCq2ATMJR5tP8MEsppXwE1i9R0fkDCLgKrEqi+9YJtFBSIkzr5c
        BzaUV0BQ4uTMJywg5ZwCgRKrD1iBhJkF1CX+zLvEDGGLS9x6Mp8JwpaX2P52DvMERqFZSLpn
        IWmZhaRlFpKWBYwsqxhFUkuLc9Nzi430ihNzi0vz0vWS83M3MQKjcduxn1t2MHa9Cz7EKMDB
        qMTDy1HoESPEmlhWXJl7iFGCg1lJhNf1oluMEG9KYmVValF+fFFpTmrxIUZToN8mMkuJJucD
        E0VeSbyhqaG5haWhubG5sZmFkjjveYPKKCGB9MSS1OzU1ILUIpg+Jg5OqQZGlwUpxdOKPl0P
        5dOO3rKHe5VMv/W0tVM2MV367LLY4m/vU65r6498dA+c5nr0ysw6lWjJxTa7d28r9Nv3wj1E
        paz+7LQ9NtM8Nl669WQrb43vf+cNtxKa0uf8kn1doFi9j3Od+VzfNYsS89JfVSyV/lnRsVdw
        rWvOfN7bEUHya748cF5pd1qwXomlOCPRUIu5qDgRAOqZb17cAgAA
X-CMS-MailID: 20190123142716eucas1p1119528e3db67c463436bb1fd87dda6bf
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-RootMTR: 20190122152609eucas1p287b83592af600dc080374a197e6dd917
X-EPHeader: CA
CMS-TYPE: 201P
X-CMS-RootMailID: 20190122152609eucas1p287b83592af600dc080374a197e6dd917
References: <CGME20190122152609eucas1p287b83592af600dc080374a197e6dd917@eucas1p2.samsung.com>
        <20190122152553.1537-1-k.konieczny@partner.samsung.com>
        <20190122152553.1537-4-k.konieczny@partner.samsung.com>
        <CAJKOXPdkDrwy2rSs-Fj1rq8rTOHvtQTrZTY5ER=pPWRPwx5qfA@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi Krzysztof,

On 23.01.2019 09:13, Krzysztof Kozlowski wrote:
> On Tue, 22 Jan 2019 at 16:26, Kamil Konieczny
> <k.konieczny@partner.samsung.com> wrote:
>>
>> Add AES crypto HW acceleration for Exynos5433, with the help of SlimSSS IP.
>>
>> Signed-off-by: Kamil Konieczny <k.konieczny@partner.samsung.com>
>> [...]
>> @@ -384,11 +387,19 @@ struct s5p_hash_ctx {
>>  static const struct samsung_aes_variant s5p_aes_data = {
>>         .aes_offset     = 0x4000,
>>         .hash_offset    = 0x6000,
>> +       .clk_names      = { "secss", }
> 
> Put trailing comma so it can be extended without touching previous
> line (just like old code).
> 

ok, I will do this and two following commas.

>>  [...]
>> +       if (variant->clk_names[1]) {
>> +               pdata->pclk = devm_clk_get(dev, variant->clk_names[1]);
>> +               if (IS_ERR(pdata->pclk)) {
>> +                       dev_err(dev, "failed to find clock %s\n",
>> +                               variant->clk_names[1]);
>> +                       clk_disable_unprepare(pdata->clk);
>> +                       return -ENOENT;
> 
> goto err_irq (eventually rename the label)?

I will add 'goto err_clk' with proper cleanup.

>> +                       }
> 
> Indentation looks wrong here.

ok

>> +
>> +               err = clk_prepare_enable(pdata->pclk);
>> +               if (err < 0) {
>> +                       dev_err(dev, "Enabling clock %s failed, err %d\n",
>> +                               variant->clk_names[0], err);
>> +                       clk_disable_unprepare(pdata->clk);
>> +                       return err;
> 
> goto...

Yes, I will put the same goto here.

-- 
Best regards,
Kamil Konieczny
Samsung R&D Institute Poland

