Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CBEAEC74A5B
	for <linux-crypto@archiver.kernel.org>; Fri, 17 Mar 2023 08:13:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231490AbjCQINa (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 17 Mar 2023 04:13:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37102 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231437AbjCQINM (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 17 Mar 2023 04:13:12 -0400
Received: from mail-ed1-x529.google.com (mail-ed1-x529.google.com [IPv6:2a00:1450:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F27DB3D092
        for <linux-crypto@vger.kernel.org>; Fri, 17 Mar 2023 01:12:23 -0700 (PDT)
Received: by mail-ed1-x529.google.com with SMTP id y4so17255176edo.2
        for <linux-crypto@vger.kernel.org>; Fri, 17 Mar 2023 01:12:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1679040729;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=f2NLPcV0e15KR2VTYIT5DvaZtAMS3Pymgc/Hfm10LCg=;
        b=bB4UQ33s1eTTVAAub1pQzyWt3Di5LZgHJWZ25KaHFZBwA3tasImcJ1vp5SpqERMiJG
         NpwWdBwxP56J0+eCfQDb5aitXcuu/Lkgmo+4AUI6Lb94dnXkuAp1UC010SHLItVZAEHO
         pwT333nCQbCA8rwKLwhoUhgPWWP3jsBV2Dn+Shql4GhmNKk2ol6kTrt0kjK60ktwtgT3
         1u3J8OpEv9x5ttql4H/6K4re27i9Y34TWZOCc4QHEiK4OvYhhl0+pTQFv6bVxMWfVFTw
         Vvb6ffTO8Kb1yNnz6pvmGnK9VyKdZAmhWE3MVRBeKqsPyJRzUFFudPTPiDih/gdp5v4+
         QJPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679040729;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=f2NLPcV0e15KR2VTYIT5DvaZtAMS3Pymgc/Hfm10LCg=;
        b=vg5k4svOptCG671qnQhAo9BHcw67bZiR/2XoTOqMF5FmPJdkJ5U+dpDMdgDcl9DnSY
         ToEFccD9Naecbg8AuP8vVz5EdbYEhry+/+wsMr0dmRpvr7U5UqeCBZ+39pZ1aiWcwc9Z
         cU9hU+VLBWw7ANSOdtrDkWtepW+dx+efZDZQHbdmKldi5XPC9UOLxerOdFuAG99tnYXt
         bNlwl2uhvKzDQihjboc/hnB5ig7HAQowEDFTxODa9c/1y9YkOg5FyV0h8q34NFIzvH0Z
         BbXIoXmKfmAqN0lcmE3FA4yGbtLvje0FEWFOH1I84ZTRTg04YNqj0JSZSLFGqN+1z79N
         NfDA==
X-Gm-Message-State: AO0yUKXo4ASnH+0W4itl7s3c7OrBDM2fW0X9e3gYvzP1OBXdLSFU5O/X
        8g769H7PBxT3O6cBMPFn4xMxxw==
X-Google-Smtp-Source: AK7set8gXdMOUdQI+eibIGjQnRru2oIk5Y3dI3YgsRE3c5Tf6Zc3nEUpuNboj1Tcph8pjWe6MWJ+zA==
X-Received: by 2002:a17:906:e0d2:b0:92b:f3c3:7c5f with SMTP id gl18-20020a170906e0d200b0092bf3c37c5fmr12382818ejb.53.1679040728917;
        Fri, 17 Mar 2023 01:12:08 -0700 (PDT)
Received: from ?IPV6:2a02:810d:15c0:828:848a:1971:93e0:b465? ([2a02:810d:15c0:828:848a:1971:93e0:b465])
        by smtp.gmail.com with ESMTPSA id n7-20020a170906b30700b0092f500c5936sm658182ejz.201.2023.03.17.01.12.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 17 Mar 2023 01:12:08 -0700 (PDT)
Message-ID: <b8cd828b-edc5-6748-bf97-af0fc85e14a4@linaro.org>
Date:   Fri, 17 Mar 2023 09:12:05 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.0
Subject: Re: [PATCH 2/2] crypto - img-hash: Drop of_match_ptr for ID table
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Nicolas Ferre <nicolas.ferre@microchip.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Claudiu Beznea <claudiu.beznea@microchip.com>,
        linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
References: <20230310223027.315954-1-krzysztof.kozlowski@linaro.org>
 <20230310223027.315954-2-krzysztof.kozlowski@linaro.org>
 <ZBPYpYfd29YwN1Dy@gondor.apana.org.au>
Content-Language: en-US
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <ZBPYpYfd29YwN1Dy@gondor.apana.org.au>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 17/03/2023 04:04, Herbert Xu wrote:
> On Fri, Mar 10, 2023 at 11:30:27PM +0100, Krzysztof Kozlowski wrote:
>>
>> diff --git a/drivers/crypto/img-hash.c b/drivers/crypto/img-hash.c
>> index fe93d19e3044..4e9a6660d791 100644
>> --- a/drivers/crypto/img-hash.c
>> +++ b/drivers/crypto/img-hash.c
>> @@ -1106,7 +1106,7 @@ static struct platform_driver img_hash_driver = {
>>  	.driver		= {
>>  		.name	= "img-hash-accelerator",
>>  		.pm	= &img_hash_pm_ops,
>> -		.of_match_table	= of_match_ptr(img_hash_match),
>> +		.of_match_table	= img_hash_match,
> 
> I think we should keep this because this driver doesn't explicitly
> depend on OF.  Sure of_match_table is unconditionally defined but
> I'd call that a bug instead of a feature :)

The missing dependency on OF is not a problem. The OF code is prepare
and will work fine if the driver is built with !OF. The point is that
with !OF after dropping of_match_ptr(), the driver could match via ACPI
(PRP0001). If we make it depending on OF, the driver won't be able to
use it, unless kernel is built with OF which is unlikely for ACPI systems.

> 
> However, I would take this if you resend it with a Kconfig update
> to add an explicit dependency on OF.
> 
> Thanks,

Best regards,
Krzysztof

