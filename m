Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 322B4C433FE
	for <linux-crypto@archiver.kernel.org>; Tue, 19 Apr 2022 11:55:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242774AbiDSL6I (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 19 Apr 2022 07:58:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48100 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351970AbiDSL5l (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 19 Apr 2022 07:57:41 -0400
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1BE923895
        for <linux-crypto@vger.kernel.org>; Tue, 19 Apr 2022 04:54:58 -0700 (PDT)
Received: by mail-ed1-x536.google.com with SMTP id u18so20931615eda.3
        for <linux-crypto@vger.kernel.org>; Tue, 19 Apr 2022 04:54:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=nfsMBJ2xALLgOjM4oOlK5BSYjJIFPGL8NAkh/N0/6yg=;
        b=ZyjMtC8vDpunrZ/RnPfYn6O9lMWHMhEmyFxdKg41YVJvyDuwtoxrmOfkHUt26wLrf0
         8Vra8yynqYlFbnTVedtpqXhG3EjBrNLGB0d4IE5S7o6A2XMii46/SNSAWK0yXDPm10up
         7CSFHusMxjfK2TCkeN6FCjVfhsJgIRRzP6n8gHvMuQZ8OcTpG2OHJft/fq1Cnw0gIVOr
         OwYI8aF1erqTvLAp3Urtm0zi7uAfXiutEQwIOjVKoyHnALBOzadlbILaB2ILvfYmzI4U
         M3lD7DO+wmXjYcJC83REAy8fnhkz/1nN5Q5gW8yGlB64nU3tnbXxpG4SUtR3hFvlovKD
         pfjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=nfsMBJ2xALLgOjM4oOlK5BSYjJIFPGL8NAkh/N0/6yg=;
        b=jziDSvvGqS1edcv8X4vouy78rW6TzdFsIxJT3jUeCN8kGk1A/Pr/W+3m8RHMTMG3mk
         mQoaWK+R82CRGAAxXZN/83Wvsl0WMIKHcKKhul4NdI7DpPIdUJ9QRrqAMrnr4BrJb2Rl
         0qyOz5Lw5D8jZqsgofwpT+A+Bn61oZXH3d56Xhv0RqOwLo+LqaFhpWn2DXrUxmm+2InN
         7pw1nx3UzwAG2eowTjwruGiruB8qgNkQ2jsNHEPU64eelphY+5V9RbKM0SOkL4goKOHE
         w89LMHjvp82ymBwVEM9CsT1JD5S2fbOb6zpMZoGXhM9/ypDuCK39JoxqTpUQV/NXL6c0
         vqzQ==
X-Gm-Message-State: AOAM532HhwI/MP1PzwCc9qyqs/OYSohDFHOpxT6nkXN/ad5VsUQ6APJa
        23Q3Td0IEU6r/gUoZJH9LroNnQ==
X-Google-Smtp-Source: ABdhPJwTmG5NGqJbQnGnpk+8S5HiLxzmh4OPgLZyw4Ghg8byqWFSS06JiSgvvJYqgbuxen9bp911BA==
X-Received: by 2002:a05:6402:3046:b0:420:120e:ef2c with SMTP id bs6-20020a056402304600b00420120eef2cmr17002877edb.160.1650369296744;
        Tue, 19 Apr 2022 04:54:56 -0700 (PDT)
Received: from [192.168.0.217] (xdsl-188-155-176-92.adslplus.ch. [188.155.176.92])
        by smtp.gmail.com with ESMTPSA id r24-20020aa7c158000000b00423fd948d56sm952196edp.3.2022.04.19.04.54.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 19 Apr 2022 04:54:56 -0700 (PDT)
Message-ID: <07d7fa69-dd2f-3e10-f959-474814105d3b@linaro.org>
Date:   Tue, 19 Apr 2022 13:54:55 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH v5 24/33] dt-bindings: crypto: convert rockchip-crypto to
 YAML
Content-Language: en-US
To:     LABBE Corentin <clabbe@baylibre.com>
Cc:     heiko@sntech.de, herbert@gondor.apana.org.au,
        krzysztof.kozlowski+dt@linaro.org, robh+dt@kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org,
        linux-rockchip@lists.infradead.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20220413190713.1427956-1-clabbe@baylibre.com>
 <20220413190713.1427956-25-clabbe@baylibre.com>
 <44efe8b6-1712-5b87-f030-2f1328533ee8@linaro.org> <Yl6YV9nLVI4qYsPP@Red>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <Yl6YV9nLVI4qYsPP@Red>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 19/04/2022 13:09, LABBE Corentin wrote:
>> This is not needed and dt_bindings_check should complain.
>>
>>> +    items:
>>> +      const: aclk
>>> +      const: hclk
>>> +      const: sclk
>>> +      const: apb_pclk
>>> +
>>> +  resets:
>>> +    maxItems: 1
>>> +
>>> +  reset-names:
>>> +    maxItems: 1
>>
>> The same.
>>
> 
> I forgot to test the intermediate patch...
> Before I send a new version, does the final document is okay ?

Looks ok, if it works. :) I don't remember if dtschema likes the cases:
clock-names:
  minItems:3
  maxItems:4
if:
 ...
clock-names:
  items:
    - ...
     ...
  maxItems:3

This should work correctly, but dtschema has checks for unneeded
min/maxItems so be sure they are not complaining.

Best regards,
Krzysztof
