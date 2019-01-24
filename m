Return-Path: <SRS0=smUI=QA=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0F24FC282C3
	for <linux-crypto@archiver.kernel.org>; Thu, 24 Jan 2019 14:50:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C2BB1218A2
	for <linux-crypto@archiver.kernel.org>; Thu, 24 Jan 2019 14:50:26 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="JWB8WMQ0"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728036AbfAXOu0 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 24 Jan 2019 09:50:26 -0500
Received: from mailout1.w1.samsung.com ([210.118.77.11]:37988 "EHLO
        mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727649AbfAXOu0 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 24 Jan 2019 09:50:26 -0500
Received: from eucas1p2.samsung.com (unknown [182.198.249.207])
        by mailout1.w1.samsung.com (KnoxPortal) with ESMTP id 20190124145023euoutp0172b065aaef886453039d344314b0c865~80FI1hQly3015630156euoutp01u
        for <linux-crypto@vger.kernel.org>; Thu, 24 Jan 2019 14:50:23 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.w1.samsung.com 20190124145023euoutp0172b065aaef886453039d344314b0c865~80FI1hQly3015630156euoutp01u
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1548341423;
        bh=H+NOTlc0XM1kKAaSD4H19lSnjpfC4vO8qfAVF9C0Osw=;
        h=Subject:To:Cc:From:Date:In-Reply-To:References:From;
        b=JWB8WMQ0uc7RM8u635dFTtAhficA+3ZgpYtvsqjWtVSkJa9EUvej+ZgtZYx86V5aI
         49DlsRZbyVWNrXr8AI6jdyVVWW8BgxMEfKSxuRLJdtt1zKr3T7S3BAS2q6QJSrsdj6
         a5fCWWM3jHKXU+mTVTToIngryppRQo+MmnqI1EWs=
Received: from eusmges3new.samsung.com (unknown [203.254.199.245]) by
        eucas1p1.samsung.com (KnoxPortal) with ESMTP id
        20190124145022eucas1p1b67f22e8f0ca9131a01af773919fd817~80FINZe_-2748427484eucas1p1z;
        Thu, 24 Jan 2019 14:50:22 +0000 (GMT)
Received: from eucas1p1.samsung.com ( [182.198.249.206]) by
        eusmges3new.samsung.com (EUCPMTA) with SMTP id 62.B9.04806.EA0D94C5; Thu, 24
        Jan 2019 14:50:22 +0000 (GMT)
Received: from eusmtrp2.samsung.com (unknown [182.198.249.139]) by
        eucas1p1.samsung.com (KnoxPortal) with ESMTPA id
        20190124145021eucas1p1866079d4010503764e0ac6769de40d04~80FHZY-Ep2749227492eucas1p10;
        Thu, 24 Jan 2019 14:50:21 +0000 (GMT)
Received: from eusmgms2.samsung.com (unknown [182.198.249.180]) by
        eusmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20190124145021eusmtrp2c63475a35763059eea8bae855cf1b59e~80FHK4BTt0281802818eusmtrp2A;
        Thu, 24 Jan 2019 14:50:21 +0000 (GMT)
X-AuditID: cbfec7f5-367ff700000012c6-c6-5c49d0ae75f1
Received: from eusmtip2.samsung.com ( [203.254.199.222]) by
        eusmgms2.samsung.com (EUCPMTA) with SMTP id F7.F8.04128.DA0D94C5; Thu, 24
        Jan 2019 14:50:21 +0000 (GMT)
Received: from [106.120.51.18] (unknown [106.120.51.18]) by
        eusmtip2.samsung.com (KnoxPortal) with ESMTPA id
        20190124145021eusmtip213819744c6bf6c4a69f5ab2a735c1d6b~80FGvoig40979809798eusmtip28;
        Thu, 24 Jan 2019 14:50:21 +0000 (GMT)
Subject: Re: [PATCH v2 3/3] crypto: s5p: add AES support for Exynos5433
To:     Krzysztof Kozlowski <krzk@kernel.org>
Cc:     Corentin Labbe <clabbe.montjoie@gmail.com>,
        Vladimir Zapolskiy <vz@mleia.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org,
        "linux-samsung-soc@vger.kernel.org" 
        <linux-samsung-soc@vger.kernel.org>, linux-kernel@vger.kernel.org,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>
From:   Kamil Konieczny <k.konieczny@partner.samsung.com>
Message-ID: <2ba3ca26-d4cd-5c9c-35a1-ab34e965fc0f@partner.samsung.com>
Date:   Thu, 24 Jan 2019 15:50:20 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
        Thunderbird/60.2.1
MIME-Version: 1.0
In-Reply-To: <CAJKOXPdPM_PpVPjJUTdg2_nJ1R2o2Rt1-XA8rPi=bLMrXeQeqw@mail.gmail.com>
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrAKsWRmVeSWpSXmKPExsWy7djPc7rrLnjGGCyZL2uxccZ6Vou/fyst
        5pxvYbHofiVjcf78BnaL+/d+Mllc3jWHzWLG+X1MFmuP3GW3+P+rmdmBy2PLyptMHjtn3WX3
        2HZA1WPTqk42j38Lp7B49G1ZxejxeZNcAHsUl01Kak5mWWqRvl0CV8bZvadZCs7yVrxfNou9
        gfEqVxcjB4eEgInErF1RXYxcHEICKxglVh4/ygbhfGGU2PptBjuE85lRYvvyqUAZTrCOP29u
        QlUtZ5SY2tjIAuG8ZZR4PuMMI0iVsIC7xKUld9hBbBEBTYnrf7+zghQxC0xjlphzbhpYEZuA
        ucSj7WeYQGxeATeJx3/usoMcxSKgKnH1lAxIWFQgQqLj/mo2iBJBiZMzn7CA2JwCgRJ/Zz1g
        BrGZBcQlbj2ZzwRhy0tsfzuHGWSXhMA1domDG9cyQpztIrG3aT07hC0s8er4FihbRuL/Tohm
        CYFyid1bn7FDNLcwSsydvAgqYS1x+PhFVpDjmIG+Wb9LHyLsKLG4p4UFEpB8EjfeCkLcwCcx
        adt0Zogwr0RHmxBEta7EvP9nWCFsaYmu/+tYJzAqzULy2Swk38xC8s0shL0LGFlWMYqnlhbn
        pqcWG+ellusVJ+YWl+al6yXn525iBKar0/+Of93BuO9P0iFGAQ5GJR7ejkOeMUKsiWXFlbmH
        GCU4mJVEeF0vusUI8aYkVlalFuXHF5XmpBYfYpTmYFES561meBAtJJCeWJKanZpakFoEk2Xi
        4JRqYLwWb+z5VKKmtNx331WVR1F3NSzFP+j0bZrcO+lcVeOUj+f9PjayXbbVuNwpVqqnoat5
        6EhdrOQNO5MzRd8mMnXUX2t6kdSxjy9+2p/M7Q/eT8zVd83I3v70r+CV4577ig8reV/61ZM8
        l6e8dILfCR0Hrs+1HkrWzqz+jPt3aXF8a/56/F+vlBJLcUaioRZzUXEiAJ3C+/FTAwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrCIsWRmVeSWpSXmKPExsVy+t/xe7prL3jGGCy/pWKxccZ6Vou/fyst
        5pxvYbHofiVjcf78BnaL+/d+Mllc3jWHzWLG+X1MFmuP3GW3+P+rmdmBy2PLyptMHjtn3WX3
        2HZA1WPTqk42j38Lp7B49G1ZxejxeZNcAHuUnk1RfmlJqkJGfnGJrVK0oYWRnqGlhZ6RiaWe
        obF5rJWRqZK+nU1Kak5mWWqRvl2CXsbZvadZCs7yVrxfNou9gfEqVxcjJ4eEgInEnzc32boY
        uTiEBJYySkya+ZQRIiEt0Xh6NROELSzx51oXVNFrRomtZ3YzgySEBdwlLi25ww5iiwhoSlz/
        +50VpIhZYAazxMppa5khOr4xSezcuAlsFJuAucSj7WfAbF4BN4nHf+4CdXNwsAioSlw9JQMS
        FhWIkDj7ch0jRImgxMmZT1hAbE6BQIm/sx6ALWYWUJf4M+8SlC0ucevJfCYIW15i+9s5zBMY
        hWYhaZ+FpGUWkpZZSFoWMLKsYhRJLS3OTc8tNtIrTswtLs1L10vOz93ECIzRbcd+btnB2PUu
        +BCjAAejEg9vxyHPGCHWxLLiytxDjBIczEoivK4X3WKEeFMSK6tSi/Lji0pzUosPMZoC/TaR
        WUo0OR+YPvJK4g1NDc0tLA3Njc2NzSyUxHnPG1RGCQmkJ5akZqemFqQWwfQxcXBKNTDuEqoQ
        jj5urNgyNXjKz9+nrMW95e4x1Pnnf59WEXLmcn4id9AiHsFYQd4NleFz5vuGHZTc/3rfkW/n
        lmXE89yvO7bm3LUnh8SPXTdcbpJ+oObSpNKu/KWTK0xXnFtYzHhxn4PZKsE2y5IEu4P8JkIK
        tsdlzeJKnDq7Js683G343fF1Ya8CZ7ISS3FGoqEWc1FxIgDgLF6p5wIAAA==
X-CMS-MailID: 20190124145021eucas1p1866079d4010503764e0ac6769de40d04
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-RootMTR: 20190123165551eucas1p1cd99462e3767dbb4feb88b996225ed21
X-EPHeader: CA
CMS-TYPE: 201P
X-CMS-RootMailID: 20190123165551eucas1p1cd99462e3767dbb4feb88b996225ed21
References: <20190123165533.29645-1-k.konieczny@partner.samsung.com>
        <CGME20190123165551eucas1p1cd99462e3767dbb4feb88b996225ed21@eucas1p1.samsung.com>
        <20190123165533.29645-4-k.konieczny@partner.samsung.com>
        <20190124133729.GB13624@Red>
        <75f3be00-8035-0586-1611-99e5da53a8e7@partner.samsung.com>
        <CAJKOXPdPM_PpVPjJUTdg2_nJ1R2o2Rt1-XA8rPi=bLMrXeQeqw@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 24.01.2019 15:39, Krzysztof Kozlowski wrote:
> On Thu, 24 Jan 2019 at 15:34, Kamil Konieczny
> <k.konieczny@partner.samsung.com> wrote:
>>
>>
>>
>> On 24.01.2019 14:37, Corentin Labbe wrote:
>>> On Wed, Jan 23, 2019 at 05:55:33PM +0100, Kamil Konieczny wrote:
>>>> Add AES crypto HW acceleration for Exynos5433, with the help of SlimSSS IP.
>>>>
>>>> Signed-off-by: Kamil Konieczny <k.konieczny@partner.samsung.com>
>>>> ---
>>>>  drivers/crypto/s5p-sss.c | 50 ++++++++++++++++++++++++++++++++++++----
>>>>  1 file changed, 46 insertions(+), 4 deletions(-)
>>>>
>>>> diff --git a/drivers/crypto/s5p-sss.c b/drivers/crypto/s5p-sss.c
>>>> index 0064be0e3941..e2d247f59254 100644
>>>> [...]
>>>> @@ -240,6 +241,7 @@
>>>>  struct samsung_aes_variant {
>>>>      unsigned int                    aes_offset;
>>>>      unsigned int                    hash_offset;
>>>> +    char                            *clk_names[];
>>>
>>> Hello
>>>
>>> this could be set as const
>>
>> Definitions sets const:
>>
>> grep "static const" drivers/crypto/s5p-sss.c
>>
>> static const struct samsung_aes_variant s5p_aes_data = {
>> static const struct samsung_aes_variant exynos_aes_data = {
>> static const struct samsung_aes_variant exynos5433_slim_aes_data = {
>>
>> so it is not needed at struct declaration, or am I missing something ?
> 
> The struct contains the pointer, so the pointer will be const. However
> the pointer can point to either const string or non-const string.
> That's the Corentin's comment about. So in fact as he says - this
> should be a pointer to a const string.

Thank you for clarifing this, I will send v3 soon.

-- 
Best regards,
Kamil Konieczny
Samsung R&D Institute Poland

