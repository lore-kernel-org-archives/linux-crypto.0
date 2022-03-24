Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0B360C433F5
	for <linux-crypto@archiver.kernel.org>; Thu, 24 Mar 2022 18:19:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243827AbiCXSVH (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 24 Mar 2022 14:21:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40260 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243033AbiCXSVG (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 24 Mar 2022 14:21:06 -0400
Received: from mail-wr1-f51.google.com (mail-wr1-f51.google.com [209.85.221.51])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC628B0D3A;
        Thu, 24 Mar 2022 11:19:34 -0700 (PDT)
Received: by mail-wr1-f51.google.com with SMTP id b19so7775940wrh.11;
        Thu, 24 Mar 2022 11:19:34 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=sShruqNvZUchI28ILvTdEo38ieYS+DY+iNhiC6vHsC8=;
        b=NZDcJ3TMal4QJgsrqPJ0CbE4bvDXYMJm0rdFYtmdBksV4XOGYDjRqkq15EESvfw7mC
         Ulq4k1LU+kFZD2Hdwu/Jcra5JZR+ALXWdmSEYelp/OMC+kCr/PZ+tBZL5EaSg+AkId61
         yRXUT2p4Rjf1kN+VW3GxujkRTRp2YiXIW1MUyVBDMCr3ogM+nxrzk/v2jVKEJWIQQFkn
         3XzgOiDQAzWYOMZI7ny7f9UKiMv621E3RQkX6TlPki5TcUrS4ny7j0YlDatbhp3/cJ6T
         O6CsiFydZYB+m8WOJWof1X0YSK8wQOebv/QJj5M+GDm8TRNWoylYe74yhJ22LWidwgki
         JRFQ==
X-Gm-Message-State: AOAM532ARLEwLlbmuWdxBl/h8B9Hlb/XpEun1ls5BfpEmoMI7fJnWDn4
        tCAk4kpVU0AAd5YyCklajmk=
X-Google-Smtp-Source: ABdhPJzC6djT24nFCyVp44IEirJJaFJU/0jVblYX0o/KcYPym7BgkM7Zs06lR+obo/brOCN4fKSFvA==
X-Received: by 2002:a5d:6d44:0:b0:1e4:9a6d:c171 with SMTP id k4-20020a5d6d44000000b001e49a6dc171mr5714666wri.468.1648145973234;
        Thu, 24 Mar 2022 11:19:33 -0700 (PDT)
Received: from [192.168.0.158] (xdsl-188-155-201-27.adslplus.ch. [188.155.201.27])
        by smtp.googlemail.com with ESMTPSA id l15-20020a05600c1d0f00b0038c8ff8e708sm2655396wms.13.2022.03.24.11.19.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 24 Mar 2022 11:19:32 -0700 (PDT)
Message-ID: <c0ae3465-9185-197f-65a4-49df856bc2e0@kernel.org>
Date:   Thu, 24 Mar 2022 19:19:31 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH v3 21/26] dt-bindings: crypto: convert rockchip-crypto to
 yaml
Content-Language: en-US
To:     LABBE Corentin <clabbe@baylibre.com>
Cc:     heiko@sntech.de, herbert@gondor.apana.org.au, krzk+dt@kernel.org,
        mturquette@baylibre.com, robh+dt@kernel.org, sboyd@kernel.org,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-clk@vger.kernel.org, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-rockchip@lists.infradead.org
References: <20220321200739.3572792-1-clabbe@baylibre.com>
 <20220321200739.3572792-22-clabbe@baylibre.com>
 <90ebea0b-1d67-98dc-2b49-a6e3b97a2c4a@kernel.org> <YjyaV68mTsJAr9Xm@Red>
From:   Krzysztof Kozlowski <krzk@kernel.org>
In-Reply-To: <YjyaV68mTsJAr9Xm@Red>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 24/03/2022 17:20, LABBE Corentin wrote:

(...)
>>
>>> +    resets:
>>> +      minItems: 6
>>> +else:
>>> +  if:
>>> +    properties:
>>> +      compatible:
>>> +        const: rockchip,rk3328-crypto
>>> +  then:
>>> +    properties:
>>> +      clocks:
>>> +        minItems: 3
>>> +      clock-names:
>>> +        minItems: 3
>>> +
>>
> 
> I have create a binding update patch (https://github.com/montjoie/linux/commit/da05ef9bb488c16cfd15a47054f5b1161829b6bf)
> But I have lot of problem, DT are not validating.
> Example: Documentation/devicetree/bindings/crypto/rockchip,rk3288-crypto.example.dtb: crypto@ff8a0000: resets: [[4294967295, 174]] is too short
> 
> I have tried also to set default resets/maxItems to 3 and setting it to 4 via an if. But I still got error like maxItems cannot be update after initial set.
> 
> Any idea on why my new binding update patch is failling ?

For such case one way to solve is to:
1. Define the most relaxed min/maxItems in properties.
2. Narrow the min/maxItems in allOf for each flavor.
Something like in clocks for:
Documentation/devicetree/bindings/clock/samsung,exynos7885-clock.yaml


Best regards,
Krzysztof
