Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 688A2C74A5B
	for <linux-crypto@archiver.kernel.org>; Fri, 17 Mar 2023 09:03:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231891AbjCQJDw (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 17 Mar 2023 05:03:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51206 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231368AbjCQJD3 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 17 Mar 2023 05:03:29 -0400
Received: from mail-ed1-x52f.google.com (mail-ed1-x52f.google.com [IPv6:2a00:1450:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79DB661326
        for <linux-crypto@vger.kernel.org>; Fri, 17 Mar 2023 02:01:49 -0700 (PDT)
Received: by mail-ed1-x52f.google.com with SMTP id fd5so17592018edb.7
        for <linux-crypto@vger.kernel.org>; Fri, 17 Mar 2023 02:01:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1679043706;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=GBWALVr8KY1goXZeil3F5gNo955a6USL6Kw1fweeuxw=;
        b=ecBf25k/N3YtrG/Y1ehTw2E3CsRToRHDfcjgg+0a3f6Sy4G5N8+s5zNjQLF7ceSdui
         6SS6LQZ/5I6dZfIea20VXsWXfcSbc881NIBQYPBeKJwxsgwp3mUXO7m3e0j92udaSJ1C
         AqWDVoiYlCEOcCeHiploU5k02fzYkG7WF6MbUAtwGC0wtLiMRTRUknptCkIHpJ/vNDNg
         TKm2MB6xGCK3du6EiKIjYtgZSHvarNwgAg80jrLj+E5GybqdpY7tdYFRTS2veWL+MB4E
         PF0MATYH35iObdp2diDneXl1sPs2x9+uFhcDIKL4HZwWwh/W3EjMNANlXY26llnWo4Qs
         6llg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679043706;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=GBWALVr8KY1goXZeil3F5gNo955a6USL6Kw1fweeuxw=;
        b=7EuL8UutafP9vPJ7VfOhS++ZRaR2Ytba0lJLv/crjnYtVloezv/d4ZMIk4R4PIvMbY
         mhQJ258l/chIyP5P/szKFa3Z6BCU023PCmjUf4lwyn3usqIC3UPSv+a87OsEmPO0n0tT
         1tNWuZelsxEYs+EU8Ad6W0HW8r9TfCjHHiWlCplHJ34PHnVcaAlxdLSTdcy0oUlSRVkw
         KaRcm3NiMja9oPG2Gu1a0eRRWwTyvrCTITL41wUY7IU6WzvvJA1KHJDHuIuTSvEblsuu
         4AitnCE7RqR+3LcOSor3kRfB5zvUlPDc6z0roif9vhM/ectUUTB/xgfNri8EbUCbhVwL
         z+9w==
X-Gm-Message-State: AO0yUKWBQrPQhWt2Iw0okG1XMwAuKU2zbpaTZswjizdmXjU6v0mHonHs
        V4pMhBKiKrY+UpFZqGav3tc4NA==
X-Google-Smtp-Source: AK7set+RLMqFJAmEQQOX0KsfvOHG0SQZiKe3Ky+yEBGorEgZgQ89ZoXPnun4I4cXtON8LBpVC4/K4A==
X-Received: by 2002:a17:907:3206:b0:932:8dc:5afe with SMTP id xg6-20020a170907320600b0093208dc5afemr1206946ejb.67.1679043706138;
        Fri, 17 Mar 2023 02:01:46 -0700 (PDT)
Received: from ?IPV6:2a02:810d:15c0:828:848a:1971:93e0:b465? ([2a02:810d:15c0:828:848a:1971:93e0:b465])
        by smtp.gmail.com with ESMTPSA id sd13-20020a170906ce2d00b008e09deb6610sm705584ejb.200.2023.03.17.02.01.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 17 Mar 2023 02:01:45 -0700 (PDT)
Message-ID: <e7cd7252-9cc6-0970-b0e2-35fccde45e86@linaro.org>
Date:   Fri, 17 Mar 2023 10:01:44 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.0
Subject: Re: [PATCH 2/2] crypto - img-hash: Drop of_match_ptr for ID table
Content-Language: en-US
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
 <b8cd828b-edc5-6748-bf97-af0fc85e14a4@linaro.org>
 <ZBQlKMTcTm1yjete@gondor.apana.org.au>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <ZBQlKMTcTm1yjete@gondor.apana.org.au>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 17/03/2023 09:30, Herbert Xu wrote:
> On Fri, Mar 17, 2023 at 09:12:05AM +0100, Krzysztof Kozlowski wrote:
>>
>> The missing dependency on OF is not a problem. The OF code is prepare
>> and will work fine if the driver is built with !OF. The point is that
>> with !OF after dropping of_match_ptr(), the driver could match via ACPI
>> (PRP0001). If we make it depending on OF, the driver won't be able to
>> use it, unless kernel is built with OF which is unlikely for ACPI systems.
> 
> I know it works now, but what I'm saying is that if struct device_driver
> actually had of_match_table as conditional on OF, which ideally it
> should, then removing of_match_ptr will break the build.
> 
> I know that it's currently unconditionally defined, but that's
> just wasting memory on non-OF machines such as x86.

That's not true. There is no waste because having it on x86 allows to
match via ACPI PRP0001. It's on purpose there.

> So either this driver is OF-only, in which case you can drop
> the of_match_ptr but must add a dependency on OF.  Or it's not
> OF-only, in which case you should use of_match_ptr.

There are OF-drivers used on ACPI and x86/arm64.

The true question is whether this device will be ever used on ACPI via
PRP0001, but you are not referring to this?

Best regards,
Krzysztof

