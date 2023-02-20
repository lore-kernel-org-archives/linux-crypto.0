Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C0F64C05027
	for <linux-crypto@archiver.kernel.org>; Mon, 20 Feb 2023 07:18:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229652AbjBTHSY (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 20 Feb 2023 02:18:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60140 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229451AbjBTHSX (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 20 Feb 2023 02:18:23 -0500
Received: from mail-wr1-x431.google.com (mail-wr1-x431.google.com [IPv6:2a00:1450:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7A49B768
        for <linux-crypto@vger.kernel.org>; Sun, 19 Feb 2023 23:18:22 -0800 (PST)
Received: by mail-wr1-x431.google.com with SMTP id b10so1638279wrx.11
        for <linux-crypto@vger.kernel.org>; Sun, 19 Feb 2023 23:18:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=+TYrZcI8oZmBJI8gRHKnPvwWt4Ky2DBWZ4+TEcEBWbg=;
        b=RcBjSTMyU4bUL6GadSiyPG3lyr+fwiuarIyvIiS2KegkfuAHC6t2CrARADIWLLjOEh
         ckaQqS113vUNBgWODmcHl/oOFJ0ukdruArF0aP/Jik3onqjODzLh1ZKFKDCK5fMGMxNP
         35VqOwUCY2l8XoJia+zjVB5scbh7YtYkGdsBzei7FC4NE/6953Lgy1Tj6CC20dtkTh0I
         fJVhtFsboNMwRAb9RiSHCiznYEey38+yLQfsHHIugwzdgLNVLJqsjz33U2qJrKFOleg5
         8PMYS/GgfnRCMU9jPOA88kOgmrs1mQwUhPYBECTHLiIRfltBmbZd03Loxgd+qDS4fcXu
         4M8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=+TYrZcI8oZmBJI8gRHKnPvwWt4Ky2DBWZ4+TEcEBWbg=;
        b=YndJY+o/z93OL7i0tNam9QAO0T6t4eliieMOLdG08tdyXnIez1H8/VyKPWEuZz3L5E
         fhkTaByt1YobPRhZhyWXGJnWMXUzD+ei7Sxz4cpTjgYwUs1hGWeyywugJLfybganSUD6
         7o20OLmK7RPFujj719+cqtZUIlxy3tjsKySYY79oOWU+7UyYbGq2l/5R5cmKGW15A/7y
         h2pROWxXK47WplwRIA9jkwi/1pB1dgug/VZzNpZlqkg7gIK4K8jyIN7F/X0yKYrj9bJm
         lEfBetoHBexuWNiynUEgYckVwkv2V4cZRogwtv7sbzsddeGSbachxP1G/r7zNuIpQEQA
         4WIQ==
X-Gm-Message-State: AO0yUKX6KDS2ajryG/TEM8sD6sIwzKYmuFwR9QX708KJEHa8ntVGm9XG
        +e5mJkizunrXJhOSNrvgS/0=
X-Google-Smtp-Source: AK7set8u9kxAEpAQKgHwNoI6ElkWlxeNj36+HwGlKJtyqRZ+FljrZfUEdGxocK++KU4MDRFQ4kD7Mg==
X-Received: by 2002:a5d:4586:0:b0:2c6:e670:8867 with SMTP id p6-20020a5d4586000000b002c6e6708867mr1911727wrq.0.1676877501235;
        Sun, 19 Feb 2023 23:18:21 -0800 (PST)
Received: from ?IPV6:2a01:c22:77a6:b600:7c00:d16a:3ffc:2f37? (dynamic-2a01-0c22-77a6-b600-7c00-d16a-3ffc-2f37.c22.pool.telefonica.de. [2a01:c22:77a6:b600:7c00:d16a:3ffc:2f37])
        by smtp.googlemail.com with ESMTPSA id a17-20020adfdd11000000b002c6e81a7e5esm621333wrm.107.2023.02.19.23.18.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 19 Feb 2023 23:18:20 -0800 (PST)
Message-ID: <426a526b-cd55-0bd0-1ab9-623832ef7417@gmail.com>
Date:   Mon, 20 Feb 2023 08:18:18 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH 4/5] hwrng: meson: use struct hw_random priv data
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     Olivia Mackall <olivia@selenic.com>,
        Neil Armstrong <neil.armstrong@linaro.org>,
        Kevin Hilman <khilman@baylibre.com>,
        Jerome Brunet <jbrunet@baylibre.com>,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "open list:ARM/Amlogic Meson..." <linux-amlogic@lists.infradead.org>
References: <26216f60-d9b9-f40c-2c2a-95b3fde6c3bc@gmail.com>
 <4dafc70f-be7f-bfdc-8845-bd97b27d1c4c@gmail.com>
 <Y/L6E+7SmLha7Bp8@gondor.apana.org.au>
Content-Language: en-US
From:   Heiner Kallweit <hkallweit1@gmail.com>
In-Reply-To: <Y/L6E+7SmLha7Bp8@gondor.apana.org.au>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 20.02.2023 05:41, Herbert Xu wrote:
> On Sat, Feb 18, 2023 at 09:58:07PM +0100, Heiner Kallweit wrote:
>> Use the priv data member of struct hwrng to make the iomem base address
>> available in meson_rng_read(). This allows for removing struct
>> meson_rng_data completely in the next step.
>> __force is used to silence sparse warnings.
>>
>> Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
>> ---
>>  drivers/char/hw_random/meson-rng.c | 14 +++++++-------
>>  1 file changed, 7 insertions(+), 7 deletions(-)
>>
>> diff --git a/drivers/char/hw_random/meson-rng.c b/drivers/char/hw_random/meson-rng.c
>> index a4eb8e35f..bf7a6e594 100644
>> --- a/drivers/char/hw_random/meson-rng.c
>> +++ b/drivers/char/hw_random/meson-rng.c
>> @@ -17,16 +17,14 @@
>>  #define RNG_DATA 0x00
>>  
>>  struct meson_rng_data {
>> -	void __iomem *base;
>>  	struct hwrng rng;
>>  };
> 
> This is too ugly for words.  If you're trying to save memory we
> should instead get rid of rng.priv and convert the drivers that
> user it over to this model of embedding struct hwrng inside the
> driver struct.
> 
OK, then let's omit patches 4 and 5.
Patches 1-3 have a Reviewed-by, can you apply them as-is or do
you need a resubmit of the series with patch 1-3 only?

> Thanks,

