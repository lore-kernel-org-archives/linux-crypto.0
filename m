Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 12B3AC433E6
	for <linux-crypto@archiver.kernel.org>; Sat, 20 Feb 2021 19:13:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DD87764EC0
	for <linux-crypto@archiver.kernel.org>; Sat, 20 Feb 2021 19:13:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230009AbhBTTNe (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 20 Feb 2021 14:13:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43152 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229812AbhBTTNd (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 20 Feb 2021 14:13:33 -0500
Received: from mail-wr1-x435.google.com (mail-wr1-x435.google.com [IPv6:2a00:1450:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DAE95C061786;
        Sat, 20 Feb 2021 11:12:49 -0800 (PST)
Received: by mail-wr1-x435.google.com with SMTP id 7so14572117wrz.0;
        Sat, 20 Feb 2021 11:12:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=qrC9ugpTSFJhkRwNI6sJByWWg907u86/Upjg3HOk4D0=;
        b=Hp515hymLEetLq9ONPca46+wj+BWbhIYyqsKw35C6b8hV75FdrFL78b7u+VQ8GkZ0W
         dEEuUDm4wmI1Ny9jpg/AxGfDEV2oDYeUFazTZPtMPuVYDGRPzuhOde/DjN/1Yjz5oQoQ
         6ovOX6ddBoRHp8KUmxJAowBTQ/Q4eLr6dviQ/Vr0UdLc/IP7k7r7Wci9JhVjtSASgIkY
         OomnA8iznkkjvuKVhAAteqlOAnQzLQUg7ENIjCGIU7/n+hPGDvQPm2bObTrEfpGasr4I
         aVSbN6TPnDNlgXmviXZzPw5gSgsm9klouQUAUYj628DlclmBWK458p+J80ktsA6dONII
         R2XA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=qrC9ugpTSFJhkRwNI6sJByWWg907u86/Upjg3HOk4D0=;
        b=iiltZ3JJy1x6zrc14aZ/fZ2Hcj+ULgocBKj5MKuNNvmP8iZ8QHfT9GUDgN+Hmo6bjp
         YIhniTDWTyBLCwG7PoOnRoV8XCuGXy1Q5ePypn93Uie02F89yYDZ8X5/OXjRJkV7U4rm
         BCGaDFaws2h+izDJArkG2FerdJRjuK7tgs/Gb4/9H0BcJu7wVtDzt5zE/fWYm0eVXAlL
         3CedhS/ze0uY1VmdTx2cBcHoR5s4svnaZJ9IJLfYOTE5L4RdS2Um8a55b3AWJAuP7Zbw
         kFh7fdAGscFTbESRVvSx12bD8qZS2kZp+yWcoK+Ka2qNj1tg2vIEcRgMD57T3mTJshJo
         7VKQ==
X-Gm-Message-State: AOAM531iAs2INk7NYHFTedUW6GIDiMjVP3EBDyUGE/N0ctIKZHLiwnf9
        K3XWh/odolUt28aazBoFxNc=
X-Google-Smtp-Source: ABdhPJwONz0TGGNpJOR78cmtrhV6BpLoc4v6UgNQOaVFSOHTj9Hy1TQuN0eZ40BJcE7rMraXJPfFIg==
X-Received: by 2002:adf:f750:: with SMTP id z16mr12357490wrp.108.1613848366898;
        Sat, 20 Feb 2021 11:12:46 -0800 (PST)
Received: from [192.168.1.10] (23.red-2-137-25.dynamicip.rima-tde.net. [2.137.25.23])
        by smtp.gmail.com with ESMTPSA id h12sm24987060wru.18.2021.02.20.11.12.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 20 Feb 2021 11:12:46 -0800 (PST)
Subject: Re: [PATCH] hwrng: bcm2835: set quality to 1000
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     mpm@selenic.com, herbert@gondor.apana.org.au,
        nsaenzjulienne@suse.de, f.fainelli@gmail.com, rjui@broadcom.com,
        sbranden@broadcom.com, bcm-kernel-feedback-list@broadcom.com,
        rikard.falkeborn@gmail.com, linux-crypto@vger.kernel.org,
        linux-rpi-kernel@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        stijn@linux-ipv6.be, ynezz@true.cz
References: <20210220174741.23665-1-noltari@gmail.com>
 <YDFeao/bOxvoXI9D@lunn.ch>
From:   =?UTF-8?Q?=c3=81lvaro_Fern=c3=a1ndez_Rojas?= <noltari@gmail.com>
Message-ID: <9b86c773-7153-1e18-472a-f66b01c83173@gmail.com>
Date:   Sat, 20 Feb 2021 20:12:45 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <YDFeao/bOxvoXI9D@lunn.ch>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: es-ES
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi Andrew,

I ran rngtest and this is what I got:
root@OpenWrt:/# cat /dev/hwrng | rngtest -c 1000
rngtest 6.10
Copyright (c) 2004 by Henrique de Moraes Holschuh
This is free software; see the source for copying conditions.  There is 
NO warranty; not even for MERCHANTABILITY or FITNESS FOR A PARTICULAR 
PURPOSE.

rngtest: starting FIPS tests...
rngtest: bits received from input: 20000032
rngtest: FIPS 140-2 successes: 996
rngtest: FIPS 140-2 failures: 4
rngtest: FIPS 140-2(2001-10-10) Monobit: 0
rngtest: FIPS 140-2(2001-10-10) Poker: 0
rngtest: FIPS 140-2(2001-10-10) Runs: 1
rngtest: FIPS 140-2(2001-10-10) Long run: 3
rngtest: FIPS 140-2(2001-10-10) Continuous run: 0
rngtest: input channel speed: (min=146.002; avg=349.394; 
max=1302083.333)Kibits/s
rngtest: FIPS tests speed: (min=12.126; avg=22.750; max=23.432)Mibits/s
rngtest: Program run time: 56826982 microseconds

996 successes and 4 failures -> 99.6% success rate
1024 * 99.6% = 1019 (rounded down to 1000)

I'm not sure if I can rely on rngtest for that...

Best regards,
Álvaro.

El 20/02/2021 a las 20:09, Andrew Lunn escribió:
> On Sat, Feb 20, 2021 at 06:47:40PM +0100, Álvaro Fernández Rojas wrote:
>> This allows devices without a high precission timer to reduce boot from >100s
>> to <30s.
>> diff --git a/drivers/char/hw_random/bcm2835-rng.c b/drivers/char/hw_random/bcm2835-rng.c
>> index 1a7c43b43c6b..4b48cb7176b0 100644
>> --- a/drivers/char/hw_random/bcm2835-rng.c
>> +++ b/drivers/char/hw_random/bcm2835-rng.c
>> @@ -163,6 +163,7 @@ static int bcm2835_rng_probe(struct platform_device *pdev)
>>   	priv->rng.init = bcm2835_rng_init;
>>   	priv->rng.read = bcm2835_rng_read;
>>   	priv->rng.cleanup = bcm2835_rng_cleanup;
>> +	priv->rng.quality = 1000;
> 
> Hi Alvero
> 
>   * @quality:		Estimation of true entropy in RNG's bitstream
>   *			(in bits of entropy per 1024 bits of input;
>   *			valid values: 1 to 1024, or 0 for unknown).
> 
> How did you determine this device produces 1000 bits of true entropy
> per 1024?
> 
>      Andrew
> 
