Return-Path: <SRS0=UCGI=RJ=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 04920C43381
	for <linux-crypto@archiver.kernel.org>; Wed,  6 Mar 2019 17:32:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C63C820854
	for <linux-crypto@archiver.kernel.org>; Wed,  6 Mar 2019 17:32:02 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="iddYJEMT"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726793AbfCFRcC (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 6 Mar 2019 12:32:02 -0500
Received: from mail-pg1-f195.google.com ([209.85.215.195]:43483 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726705AbfCFRcC (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 6 Mar 2019 12:32:02 -0500
Received: by mail-pg1-f195.google.com with SMTP id l11so8945473pgq.10;
        Wed, 06 Mar 2019 09:32:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=QEnwC5zQV6B0f1JWqNUn4NI17gvaaqipfmZp43yIiEU=;
        b=iddYJEMTU6gnrSxyxP1PnOV0f9Cat4RNd0GbcKPOKDWN3b6BY35V3Ny2a0sDtD9/SP
         HHaw5rup6U3Gyvn0amMVCpCnxaIPR1LaTw6u7c1qDb9d2mOwHiBpESo4q47KjYD/uf2I
         TLqIOosAtK3gCJnB5sjX+NCbDuiOSZbAPw5X302LT6MYDtJAsGtcxlboixRsMWXhKrDP
         hZM3tP9R5hBHZ5lLoI0QTKfm4qUAcofn7JK/xcxdKpT64cXVTahpdv/S/ScIkhJXExp7
         4WJ7l9OjJOnaThWApjiTkCbUi/7df1judbSjFZ5LqSOUhFNv/xWvFfPbv/pc2/7oqKGf
         A/ZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:subject:to:cc:references:from:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=QEnwC5zQV6B0f1JWqNUn4NI17gvaaqipfmZp43yIiEU=;
        b=bTA5EdbqrXi+6aJi+XWF95dDUmOD6v2Fd0PldfT5v3D3+73edUmHDxdim5k2ZoLeyb
         WVFB9bn1XiUwj3YkQgGBeVZxs0EqXWnOgSMPtCDZL9yqc0CXkm1tvKZ7UqJVL6DRHjJG
         TyfjwLSkQ080reG2m2DMo+6R5DUa4s638D48vR+F3VbE1G+yoa2YDptU6QPL51Xy1BXE
         ABeS21MudaMoLxMs65AhNk7zeBz2IoZkMgkqk5hgZqFcXZgqxrh3vWwCGyc6fjkxgdcz
         706UmruHrEZ6bg0eeHyzEQzQ5jG0I5b11SLSs8277wn+Bm5wh5xOgpTaDcQU4onJqsUs
         /QoA==
X-Gm-Message-State: APjAAAVb98vnyuAmkHuHocPZC1YQivYFsWlD2i3aaQ4w0NbxK0Gvl+Cf
        fCIViSi9Qto+iQr2cxP1Ic8=
X-Google-Smtp-Source: APXvYqxdI5HqytF8ZFAunUHwGdQZ1aCk0co+mwMXr9nguvro7NM1uv5vZhRMVOuBfT/hm5kjjSQ6rg==
X-Received: by 2002:a17:902:7b85:: with SMTP id w5mr8232067pll.288.1551893521313;
        Wed, 06 Mar 2019 09:32:01 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id x8sm8093642pfe.1.2019.03.06.09.31.59
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 06 Mar 2019 09:32:00 -0800 (PST)
Subject: Re: [PATCH v4 3/3] crypto: s5p: add AES support for Exynos5433
To:     Krzysztof Kozlowski <krzk@kernel.org>
Cc:     Kamil Konieczny <k.konieczny@partner.samsung.com>,
        Vladimir Zapolskiy <vz@mleia.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org,
        "linux-samsung-soc@vger.kernel.org" 
        <linux-samsung-soc@vger.kernel.org>, linux-kernel@vger.kernel.org,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>
References: <20190222122144.19024-1-k.konieczny@partner.samsung.com>
 <CGME20190222122204eucas1p1ee66c9d937bdf328588ececb1f005526@eucas1p1.samsung.com>
 <20190222122144.19024-4-k.konieczny@partner.samsung.com>
 <20190305171303.GA29802@roeck-us.net>
 <CAJKOXPdqf6b6LSxyhFJwoP+Jk+KCDvTtN1yM-LSP3n3kVt_nLQ@mail.gmail.com>
From:   Guenter Roeck <linux@roeck-us.net>
Message-ID: <873d345a-4893-412d-78d7-58c3e8cd61c2@roeck-us.net>
Date:   Wed, 6 Mar 2019 09:31:58 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.5.1
MIME-Version: 1.0
In-Reply-To: <CAJKOXPdqf6b6LSxyhFJwoP+Jk+KCDvTtN1yM-LSP3n3kVt_nLQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 3/5/19 11:51 AM, Krzysztof Kozlowski wrote:
> On Tue, 5 Mar 2019 at 18:13, Guenter Roeck <linux@roeck-us.net> wrote:
>>
>> On Fri, Feb 22, 2019 at 01:21:44PM +0100, Kamil Konieczny wrote:
>>> Add AES crypto HW acceleration for Exynos5433, with the help of SlimSSS IP.
>>>
>>> Reviewed-by: Krzysztof Kozlowski <krzk@kernel.org>
>>> Signed-off-by: Kamil Konieczny <k.konieczny@partner.samsung.com>
>>> ---
>>>   drivers/crypto/s5p-sss.c | 50 ++++++++++++++++++++++++++++++++++++----
>>>   1 file changed, 46 insertions(+), 4 deletions(-)
>>>
>>> diff --git a/drivers/crypto/s5p-sss.c b/drivers/crypto/s5p-sss.c
>>> index 0064be0e3941..3f45cc5cb94a 100644
>>> --- a/drivers/crypto/s5p-sss.c
>>> +++ b/drivers/crypto/s5p-sss.c
>>> @@ -232,6 +232,7 @@
>>>    * struct samsung_aes_variant - platform specific SSS driver data
>>>    * @aes_offset: AES register offset from SSS module's base.
>>>    * @hash_offset: HASH register offset from SSS module's base.
>>> + * @clk_names: names of clocks needed to run SSS IP
>>>    *
>>>    * Specifies platform specific configuration of SSS module.
>>>    * Note: A structure for driver specific platform data is used for future
>>> @@ -240,6 +241,7 @@
>>>   struct samsung_aes_variant {
>>>        unsigned int                    aes_offset;
>>>        unsigned int                    hash_offset;
>>> +     const char                      *clk_names[];
>>
>> This array does not have a fixed size.
> 
> Yes, correct. Kamil already sent a fix:
> https://patchwork.kernel.org/patch/10835389/
> 

Excellent. Note that the offending patch is now in mainline.

Guenter
