Return-Path: <SRS0=09LE=QH=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5E279C169C4
	for <linux-crypto@archiver.kernel.org>; Thu, 31 Jan 2019 16:46:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2421D2086C
	for <linux-crypto@archiver.kernel.org>; Thu, 31 Jan 2019 16:46:00 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="jrI6uYkM"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388627AbfAaQpx (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 31 Jan 2019 11:45:53 -0500
Received: from mailout1.w1.samsung.com ([210.118.77.11]:49602 "EHLO
        mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388617AbfAaQpx (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 31 Jan 2019 11:45:53 -0500
Received: from eucas1p1.samsung.com (unknown [182.198.249.206])
        by mailout1.w1.samsung.com (KnoxPortal) with ESMTP id 20190131164551euoutp0158468dc86012eadc2d906b873dda5fb6~_-K9VTufr2348023480euoutp01h
        for <linux-crypto@vger.kernel.org>; Thu, 31 Jan 2019 16:45:51 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.w1.samsung.com 20190131164551euoutp0158468dc86012eadc2d906b873dda5fb6~_-K9VTufr2348023480euoutp01h
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1548953151;
        bh=LfBfor5qGmyUma7TrgBJLPaBuYmXpN4YgUDzWjLM2PU=;
        h=Subject:To:Cc:From:Date:In-Reply-To:References:From;
        b=jrI6uYkMVu2RPjuKz6pNAAy5JuEj2V2/MFBmMy5GS8dDHI84ROr1mfVDk+PY3Y4wB
         Qua01j59jd8do0rlZv9tdgnuD6WIN+NtGtnHyFvLB+/jjzjGYKYEZSNwGBScsOCkjt
         JW94KltxIBUO6ZnvFW2JiCk+DQwDo20Xh29Jajuo=
Received: from eusmges2new.samsung.com (unknown [203.254.199.244]) by
        eucas1p2.samsung.com (KnoxPortal) with ESMTP id
        20190131164550eucas1p29962729b9bac5a073e5f61d7fb258435~_-K74eytk0133401334eucas1p2z;
        Thu, 31 Jan 2019 16:45:50 +0000 (GMT)
Received: from eucas1p1.samsung.com ( [182.198.249.206]) by
        eusmges2new.samsung.com (EUCPMTA) with SMTP id 02.C3.04294.D36235C5; Thu, 31
        Jan 2019 16:45:49 +0000 (GMT)
Received: from eusmtrp2.samsung.com (unknown [182.198.249.139]) by
        eucas1p1.samsung.com (KnoxPortal) with ESMTPA id
        20190131164549eucas1p1170f7d0714f3543488bae809c7187539~_-K7A4pX-0575505755eucas1p1f;
        Thu, 31 Jan 2019 16:45:49 +0000 (GMT)
Received: from eusmgms1.samsung.com (unknown [182.198.249.179]) by
        eusmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20190131164549eusmtrp28880edc2c9c4e339afcae8ce349838d2~_-K6yDdrD2455324553eusmtrp2g;
        Thu, 31 Jan 2019 16:45:49 +0000 (GMT)
X-AuditID: cbfec7f4-835ff700000010c6-11-5c53263d3b68
Received: from eusmtip2.samsung.com ( [203.254.199.222]) by
        eusmgms1.samsung.com (EUCPMTA) with SMTP id 69.36.04284.C36235C5; Thu, 31
        Jan 2019 16:45:49 +0000 (GMT)
Received: from [106.120.51.18] (unknown [106.120.51.18]) by
        eusmtip2.samsung.com (KnoxPortal) with ESMTPA id
        20190131164548eusmtip2fb774bcc8edb3876a299d7fa25f6842b~_-K6T2nP21251712517eusmtip2b;
        Thu, 31 Jan 2019 16:45:48 +0000 (GMT)
Subject: Re: [PATCH v3 2/3] dt-bindings: crypto: document Exynos5433 SlimSSS
To:     Rob Herring <robh@kernel.org>
Cc:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Mark Rutland <mark.rutland@arm.com>,
        linux-crypto@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>
From:   Kamil Konieczny <k.konieczny@partner.samsung.com>
Message-ID: <ecb05f4f-3873-4029-3428-efb60c3fdabe@partner.samsung.com>
Date:   Thu, 31 Jan 2019 17:45:47 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
        Thunderbird/60.4.0
MIME-Version: 1.0
In-Reply-To: <20190130165115.GA8926@bogus>
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA02Sa0hTYRzGfc92trPR5Dg1/6ldHBg28ZIJHvBCRdgiP1h+0RJq5Wla6mTH
        a/bByMSmhiilLlMR1Bwzdeo03YdQc4oyEUXzmookCKapBV5qtR0jv/3e//M8/N/n5SU4YiPu
        SiQkp9KqZHmihCfkGgZ2zT6hZ6Ni/ffLg6nW8macqhzN5VLV/WacKlhzp0ZHW/jUl4VdjBrv
        ruRRTf3zfKpuagyjLMYu/kWhTFelQ7L2xmlMZvjoKdNrX/BkL9u1SLatPxXJuyUMiaMTE9Jp
        lV/YXWH8RP4mP8XokrmwUoTloAJHNRIQQAbCs7x6XI2EhJh8h6DOokZWQUzuIDDNhbDCNoKG
        jhmuGhG2hH5Vwc4bEEwcPOWzh3UEv5YreNa0IxkB45s5NnYiPWA/77VtBYf8ioFW3ca1Cjwy
        CJY7RzAri8hw+GRetTGX9ISy5kVb2JmMhr6ib4j1OMBQxYotKyCloDfX2phDusDMSjXG8mno
        XK/kWJcBaeaDrmcIY4teAePsEmLZEdZM7XyW3cHyofrQkwE9HV/5bDgXwdvS2kMhGPpMY7i1
        P4c8B83dfuz4EuwZCxH7LPbwed2BvYM9lBjKOOxYBPl5YtbtA1WWEZxlN1Bb3uPFSKI50kxz
        pI3mSBvN/701iKtFLnQak6SgmYBkOsOXkScxackK3/vKJD36+6eGf5t2ulD3wb1eRBJIckzU
        snczVozL05mspF4EBEfiJJr2iIoVi+LkWY9plfKOKi2RZnqRG8GVuIiy7RZvi0mFPJV+RNMp
        tOqfihEC1xxU5n18q3jrwvXsmK6hRV5gzDyudJZK4x/GYZd/SiuLW/0jiieb+rLa6JN2OV5e
        3jqD/slMSa3+xlzF7nydLmC25gwz+SZcE3pNlOerXFpoCcvsaPR9fvXH9uL4vrLQHCndUAii
        X41kfT8RMTieKXAbHsATpgZLp3z2H2zUoyAHCZeJl5+XclSM/A+WcsDxTwMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrAIsWRmVeSWpSXmKPExsVy+t/xe7q2asExBvebmSw2zljPajHnfAuL
        xfwj51gtul/JWJw/v4Hd4v69n0wWl3fNYbNYe+Quu8XS6xeZLP7v2cHuwOWxZt4aRo8tK28y
        eWw7oOqxaVUnm0ffllWMHp83yQWwRenZFOWXlqQqZOQXl9gqRRtaGOkZWlroGZlY6hkam8da
        GZkq6dvZpKTmZJalFunbJehlXOn4wF6wR7zi3pNepgbGbuEuRg4OCQETiU3P07sYuTiEBJYy
        Svy7OpW5i5ETKC4t0Xh6NROELSzx51oXG0TRa0aJQ3NWgSWEBXwkLn9oYAOxRQQUJX63TWMF
        KWIWeMEk8ejwZEaIjs+MEq+e3GYEqWITMJd4tP0MWDevgJvE0XPPwWwWAVWJ6esfgE0SFYiQ
        +Ph0H1SNoMTJmU9YQGxOAS2JTecWgdnMAuoSf+ZdYoawxSVuPZnPBGHLS2x/O4d5AqPQLCTt
        s5C0zELSMgtJywJGllWMIqmlxbnpucWGesWJucWleel6yfm5mxiBsbnt2M/NOxgvbQw+xCjA
        wajEw7vhV1CMEGtiWXFl7iFGCQ5mJRHes6rBMUK8KYmVValF+fFFpTmpxYcYTYGem8gsJZqc
        D0wbeSXxhqaG5haWhubG5sZmFkrivOcNKqOEBNITS1KzU1MLUotg+pg4OKUaGD2OXuZe5s67
        7mzh/eDirEtfX7reSZTS3T2/O5crOi1uy5eZEa2C1rVTlVn90nyMWrStdxou/NduPDNzbfSN
        A9wzi2co9nlZ3fdu+8wx09qB12/WrMfTa+3SdmU+WKZtYyFup1C078F9MXufI/tXn+ac8+PE
        ufnO9Y+Nv3eHucXP6y5/He1+TImlOCPRUIu5qDgRAFPBFY3jAgAA
X-CMS-MailID: 20190131164549eucas1p1170f7d0714f3543488bae809c7187539
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-RootMTR: 20190124154539eucas1p16fb97dd0cab2c18d82113c511cd8a1ca
X-EPHeader: CA
CMS-TYPE: 201P
X-CMS-RootMailID: 20190124154539eucas1p16fb97dd0cab2c18d82113c511cd8a1ca
References: <20190124154521.13589-1-k.konieczny@partner.samsung.com>
        <CGME20190124154539eucas1p16fb97dd0cab2c18d82113c511cd8a1ca@eucas1p1.samsung.com>
        <20190124154521.13589-3-k.konieczny@partner.samsung.com>
        <20190130165115.GA8926@bogus>
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi,

On 30.01.2019 17:51, Rob Herring wrote:
> On Thu, Jan 24, 2019 at 04:45:20PM +0100, Kamil Konieczny wrote:
>> Document DT bindings for crypto Samsung Exynos5433 SlimSSS (Slim Security
>> SubSystem) IP.
>>
>> Reviewed-by: Krzysztof Kozlowski <krzk@kernel.org>
>> Signed-off-by: Kamil Konieczny <k.konieczny@partner.samsung.com>
>> ---
>>  .../devicetree/bindings/crypto/samsung-sss.txt     | 14 +++++++++++---
>>  1 file changed, 11 insertions(+), 3 deletions(-)
>>
>> diff --git a/Documentation/devicetree/bindings/crypto/samsung-sss.txt b/Documentation/devicetree/bindings/crypto/samsung-sss.txt
>> index 7a5ca56683cc..d9af679d38ab 100644
>> --- a/Documentation/devicetree/bindings/crypto/samsung-sss.txt
>> +++ b/Documentation/devicetree/bindings/crypto/samsung-sss.txt
>> @@ -1,4 +1,4 @@
>> -Samsung SoC SSS (Security SubSystem) module
>> +Samsung SoC SSS (Security SubSystem) and SlimSSS module
>>  
>>  The SSS module in S5PV210 SoC supports the following:
>>  -- Feeder (FeedCtrl)
>> @@ -15,6 +15,12 @@ supports the following also:
>>  -- True Random Number Generator (TRNG)
>>  -- Secure Key Manager
>>  
>> +Exynos5433 has both SSS and SlimSSS module.
> 
> That's not really relevant to the binding.
> 
> What do the SSS and SlimSSS share? Only that both have a single reg and 
> interrupt based on the binding? This should probably be just 2 
> documents. If not now, it will have to be when converted to a DT schema.

They share hardware design, slimSSS is stripped-down SSS version,
and can be handled by the same crypto s5p-sss driver. The register
layout is the same for FeedControl (DMA) and AES crypt function.

Do you prefer to put this description in new file samsung-slimsss.txt ?
If yes, I can send v4, so it can be done right from beginning.

>> +SlimSSS in Exynos5433 supports:
>> +-- Feeder (FeedCtrl)
>> +-- Advanced Encryption Standard (AES)
>> +-- SHA-1/SHA-256/HMAC (SHA-1/SHA-256)
>> +
>>  Required properties:
>>  
>>  - compatible : Should contain entries for this and backward compatible
>> @@ -22,11 +28,13 @@ Required properties:
>>    - "samsung,s5pv210-secss" for S5PV210 SoC.
>>    - "samsung,exynos4210-secss" for Exynos4210, Exynos4212, Exynos4412, Exynos5250,
>>  		Exynos5260 and Exynos5420 SoCs.
>> +  - "samsung,exynos5433-slim-sss" for Exynos5433 SoCs.
>>  - reg : Offset and length of the register set for the module
>>  - interrupts : interrupt specifiers of SSS module interrupts (one feed
>>  		control interrupt).
>>  
>>  - clocks : list of clock phandle and specifier pairs for all clocks  listed in
>>  		clock-names property.
>> -- clock-names : list of device clock input names; should contain one entry
>> -		"secss".
>> +- clock-names : list of device clock input names; should contain "pclk" and
>> +		"aclk" for slim-sss in Exynos5433, and one entry "secss" for
>> +		other compatibles.
>> -- 
>> 2.20.0

-- 
Best regards,
Kamil Konieczny
Samsung R&D Institute Poland

