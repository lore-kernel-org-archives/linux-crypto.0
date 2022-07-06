Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5A78ECCA47F
	for <linux-crypto@archiver.kernel.org>; Wed,  6 Jul 2022 15:25:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233081AbiGFPZn (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 6 Jul 2022 11:25:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39494 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233111AbiGFPZ0 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 6 Jul 2022 11:25:26 -0400
Received: from mail-lf1-x12d.google.com (mail-lf1-x12d.google.com [IPv6:2a00:1450:4864:20::12d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE217237DA
        for <linux-crypto@vger.kernel.org>; Wed,  6 Jul 2022 08:25:24 -0700 (PDT)
Received: by mail-lf1-x12d.google.com with SMTP id d12so3185990lfq.12
        for <linux-crypto@vger.kernel.org>; Wed, 06 Jul 2022 08:25:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=s2u++J5w4NDwIl2ly2qjEOKSEw7r+aYlZPxk8tDl4yU=;
        b=pk5hd/IvYkLkIbMjLl+3RikyW0xoTset+iQYFryFsW/I+s24lsz9o8Cklus2QbjDrS
         fTLopnC3tP8Tgxb6id5LNbzOlagVM7wajEchHrhxhs4RTGPvA1jvZYuEsKyaMvsJ5lst
         EP4uXSsnokVfUY179M2SKS8ybC4aaKtAPqz1QswivD3/5JXqesOzr72Z4M/0IIT6Nhb2
         RS+nATTSSmsMDcjkBkBjijERiX/tHYUQlIFZaS/lXdiUAyCGf6tRSFEn8/XLan5otBRf
         iOW3EGwwOmL0aWPWKGitff/EIURBYj05PDccP0XqedV5InKTIBYAQjSI0a2fFcZeYiek
         Ih3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=s2u++J5w4NDwIl2ly2qjEOKSEw7r+aYlZPxk8tDl4yU=;
        b=bMtrRZIMP1mBmkxrMv+ljvu5XdmbVj0r+FM1bNcZtZqrv972ZbCeLWK1E2j/Zd34/3
         EaoxT+g36EEgSFBmsM9kU999Z6kUVMhg5fo9dXCAocbTwtTpEYmx2ApYndnbVWO8EGB/
         2lt9cW9KUptpuBDqVEKFzOwp79sAL5B9+/RsJYpv7pRMFjYo7j49Y3g7SIt0sunlH9CQ
         t2iVigFCUpAxqYr/QCIe+W5xvfCV8QN3Q8qmQlKdaV5PVTwZ+nMj5jpHEXdpmxkPbv6A
         vcsukXj0MZn2tt8kqLKf7ki7spxgccaPp3wCcuGGSDOYVZlBiOMwqChN1qmSK6IIeDYm
         fkrQ==
X-Gm-Message-State: AJIora925Jpo2o1YlThQQ4LpiE5b1sENYwRfse3DSLhPPH96n7TXjuYT
        ap+X5qtZfjgsj5VxYWUROUJM4Q==
X-Google-Smtp-Source: AGRyM1sl33iwmIsDfZENKyDLnobKwErOZsB1g6zI01WIfhPK+le8wb3cPVwq3Y8t8JUPspB3KmPC/w==
X-Received: by 2002:ac2:4a77:0:b0:484:d52:4e33 with SMTP id q23-20020ac24a77000000b004840d524e33mr5930342lfp.477.1657121123285;
        Wed, 06 Jul 2022 08:25:23 -0700 (PDT)
Received: from [192.168.1.52] ([84.20.121.239])
        by smtp.gmail.com with ESMTPSA id z3-20020a19f703000000b0047e789b9700sm6320314lfe.118.2022.07.06.08.25.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 06 Jul 2022 08:25:22 -0700 (PDT)
Message-ID: <3e47b853-bb82-8766-8884-3da931c038a2@linaro.org>
Date:   Wed, 6 Jul 2022 17:25:21 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH v8 25/33] dt-bindings: crypto: rockchip: convert to new
 driver bindings
Content-Language: en-US
To:     LABBE Corentin <clabbe@baylibre.com>, Rob Herring <robh@kernel.org>
Cc:     john@metanate.com, heiko@sntech.de, p.zabel@pengutronix.de,
        krzysztof.kozlowski+dt@linaro.org, robh+dt@kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, didi.debian@cknow.org,
        herbert@gondor.apana.org.au, sboyd@kernel.org,
        mturquette@baylibre.com, linux-rockchip@lists.infradead.org,
        devicetree@vger.kernel.org, linux-clk@vger.kernel.org
References: <20220706090412.806101-1-clabbe@baylibre.com>
 <20220706090412.806101-26-clabbe@baylibre.com>
 <1657114144.957232.4099933.nullmailer@robh.at.kernel.org>
 <YsWcGDwPCX+/95i3@Red>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <YsWcGDwPCX+/95i3@Red>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 06/07/2022 16:28, LABBE Corentin wrote:
> Le Wed, Jul 06, 2022 at 07:29:04AM -0600, Rob Herring a écrit :
>> On Wed, 06 Jul 2022 09:04:04 +0000, Corentin Labbe wrote:
>>> The latest addition to the rockchip crypto driver need to update the
>>> driver bindings.
>>>
>>> Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
>>> Signed-off-by: Corentin Labbe <clabbe@baylibre.com>
>>> ---
>>>  .../crypto/rockchip,rk3288-crypto.yaml        | 85 +++++++++++++++++--
>>>  1 file changed, 77 insertions(+), 8 deletions(-)
>>>
>>
>> My bot found errors running 'make DT_CHECKER_FLAGS=-m dt_binding_check'
>> on your patch (DT_CHECKER_FLAGS is new in v5.13):
>>
>> yamllint warnings/errors:
>>
>> dtschema/dtc warnings/errors:
>> /builds/robherring/linux-dt-review/Documentation/devicetree/bindings/crypto/rockchip,rk3288-crypto.yaml: allOf:0:then:properties:clock-names: 'oneOf' conditional failed, one must be fixed:
>> 	[{'const': 'aclk'}, {'const': 'hclk'}, {'const': 'sclk'}, {'const': 'apb_pclk'}] is too long
>> 	[{'const': 'aclk'}, {'const': 'hclk'}, {'const': 'sclk'}, {'const': 'apb_pclk'}] is too short
>> 	False schema does not allow 4
>> 	1 was expected
>> 	4 is greater than the maximum of 2
>> 	4 is greater than the maximum of 3
> 
> Hello
> 
> I upgraded to dt-schema 2022.07 and fail to reproduce all errors.

Visible on older dtschema (2022.6.dev10+gcd64f75fe091), visible on
newest (2022.7).

Exactly the same error.

Best regards,
Krzysztof
