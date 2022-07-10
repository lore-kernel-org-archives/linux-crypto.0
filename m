Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5324BCCA479
	for <linux-crypto@archiver.kernel.org>; Sun, 10 Jul 2022 15:12:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229612AbiGJPMx (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 10 Jul 2022 11:12:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229505AbiGJPMw (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 10 Jul 2022 11:12:52 -0400
Received: from mail-lj1-x22a.google.com (mail-lj1-x22a.google.com [IPv6:2a00:1450:4864:20::22a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C15DBE00
        for <linux-crypto@vger.kernel.org>; Sun, 10 Jul 2022 08:12:51 -0700 (PDT)
Received: by mail-lj1-x22a.google.com with SMTP id 19so3632595ljz.4
        for <linux-crypto@vger.kernel.org>; Sun, 10 Jul 2022 08:12:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=NrSFqXui8IuFWW18AV7BX9JJnZg6RCMbeeOF3ySerrE=;
        b=QMoJgDgrWpoHgt8V935Yj0tZ7gW3LZdDygouB/iufA4mk/EYDXJyLplXfyn9C8aN3A
         uIDA0Tu/wnZF2BfBFlpKqh4VyroAYuQZqBcdpiZdNqmtc1Z5K0m7VaZCj9hr+NPEj35l
         BPUIU1LpogI7MI0Z2g9xvpzLPWDCfvUhqRZswOndvhygeYTuQ8N329fsjMyYoMlPMYqw
         F5KZ/a6Qya+85rPNA5stUj9xKIurX7xzNqVFP9yMbwrQYxAP3NoSkTUTKHqlfCKkzx6r
         PnWE30Qp6vO43T+WD+r3zVXt+y24fZZfpGbNtPSRRMTbGF8XcgFbk+cwU5SF+8I8uRG7
         8q0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=NrSFqXui8IuFWW18AV7BX9JJnZg6RCMbeeOF3ySerrE=;
        b=kzYRThUkZGECKZ+Lgvuo2gEYunSPK1wcL+yMmc+a2+zv4hY8GBzattK7ahywlvQahP
         hNmXlipRQ6H5LGHzyDmV/Yo5JxBQaE3R3cKbWAHilkONqE3NWwk6W1bOs+qQTgiUW9mp
         heP+H4G0Q/bjCQSsp2VoJdqPlbE6EQfUFUygvVO2+FxEgGVTZGJ4ZYIX5iiLvnI2Kzrg
         CSZNspczJ8HnD9JtTOYYj662q3aYoGBzDWIck/mdLi6vs26Xqiv5a85AlO4oQwgRTbVf
         rpFq90K+amGxRJZ1hjzc/4hznSAYPWOIdBZGBcQ386LcBpdirPpdVLllZbnhvrfRMqkO
         pxtQ==
X-Gm-Message-State: AJIora868+Oe58MkBs3HUlq0HMRnHJ+q/TxJfJEuODtVf8ZxetUDN0yk
        sYRvLROJ8VdxQJm7TR6uQZzdlQ==
X-Google-Smtp-Source: AGRyM1u4TGEfXbOJWoo2B3uuptUDQWrvhmxrihGijpLpTSzFLDT2nPpmDzKjXMxyCnypzScxX8fVbA==
X-Received: by 2002:a2e:83c7:0:b0:25b:c007:29e0 with SMTP id s7-20020a2e83c7000000b0025bc00729e0mr7525140ljh.378.1657465969512;
        Sun, 10 Jul 2022 08:12:49 -0700 (PDT)
Received: from [10.0.0.8] (fwa5cac-200.bb.online.no. [88.92.172.200])
        by smtp.gmail.com with ESMTPSA id y18-20020a199152000000b00486d8a63c07sm976213lfj.121.2022.07.10.08.12.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 10 Jul 2022 08:12:49 -0700 (PDT)
Message-ID: <f6ab024a-582f-45b0-7d26-94a85858c761@linaro.org>
Date:   Sun, 10 Jul 2022 17:12:46 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH v8 25/33] dt-bindings: crypto: rockchip: convert to new
 driver bindings
Content-Language: en-US
To:     LABBE Corentin <clabbe@baylibre.com>
Cc:     Rob Herring <robh@kernel.org>, john@metanate.com, heiko@sntech.de,
        p.zabel@pengutronix.de, krzysztof.kozlowski+dt@linaro.org,
        robh+dt@kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        didi.debian@cknow.org, herbert@gondor.apana.org.au,
        sboyd@kernel.org, mturquette@baylibre.com,
        linux-rockchip@lists.infradead.org, devicetree@vger.kernel.org,
        linux-clk@vger.kernel.org
References: <20220706090412.806101-1-clabbe@baylibre.com>
 <20220706090412.806101-26-clabbe@baylibre.com>
 <1657114144.957232.4099933.nullmailer@robh.at.kernel.org>
 <YsWcGDwPCX+/95i3@Red> <3e47b853-bb82-8766-8884-3da931c038a2@linaro.org>
 <YsabXrOyAsCkUUVN@Red>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <YsabXrOyAsCkUUVN@Red>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 07/07/2022 10:37, LABBE Corentin wrote:
> Le Wed, Jul 06, 2022 at 05:25:21PM +0200, Krzysztof Kozlowski a écrit :
>> On 06/07/2022 16:28, LABBE Corentin wrote:
>>> Le Wed, Jul 06, 2022 at 07:29:04AM -0600, Rob Herring a écrit :
>>>> On Wed, 06 Jul 2022 09:04:04 +0000, Corentin Labbe wrote:
>>>>> The latest addition to the rockchip crypto driver need to update the
>>>>> driver bindings.
>>>>>
>>>>> Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
>>>>> Signed-off-by: Corentin Labbe <clabbe@baylibre.com>
>>>>> ---
>>>>>  .../crypto/rockchip,rk3288-crypto.yaml        | 85 +++++++++++++++++--
>>>>>  1 file changed, 77 insertions(+), 8 deletions(-)
>>>>>
>>>>
>>>> My bot found errors running 'make DT_CHECKER_FLAGS=-m dt_binding_check'
>>>> on your patch (DT_CHECKER_FLAGS is new in v5.13):
>>>>
>>>> yamllint warnings/errors:
>>>>
>>>> dtschema/dtc warnings/errors:
>>>> /builds/robherring/linux-dt-review/Documentation/devicetree/bindings/crypto/rockchip,rk3288-crypto.yaml: allOf:0:then:properties:clock-names: 'oneOf' conditional failed, one must be fixed:
>>>> 	[{'const': 'aclk'}, {'const': 'hclk'}, {'const': 'sclk'}, {'const': 'apb_pclk'}] is too long
>>>> 	[{'const': 'aclk'}, {'const': 'hclk'}, {'const': 'sclk'}, {'const': 'apb_pclk'}] is too short
>>>> 	False schema does not allow 4
>>>> 	1 was expected
>>>> 	4 is greater than the maximum of 2
>>>> 	4 is greater than the maximum of 3
>>>
>>> Hello
>>>
>>> I upgraded to dt-schema 2022.07 and fail to reproduce all errors.
>>
>> Visible on older dtschema (2022.6.dev10+gcd64f75fe091), visible on
>> newest (2022.7).
>>
>> Exactly the same error.
>>
> 
> Hello
> 
> I am sorry, I finally succesfully reproduced it.
> Just doing what the hints gives (removing max/min-items) from "static" list fix the issue.

Not sure what do you mean by "static list". I think you should drop
min/maxItems from clock-names/reset-names in allOf:if:then sections.

> Does I need to remove your Reviewed-by ?

Let's drop, so it will be back to my to-review queue.

Best regards,
Krzysztof
