Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E7149C433FE
	for <linux-crypto@archiver.kernel.org>; Sat,  2 Apr 2022 12:07:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241863AbiDBMJW (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 2 Apr 2022 08:09:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51944 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233860AbiDBMJW (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 2 Apr 2022 08:09:22 -0400
Received: from mail-wr1-x42a.google.com (mail-wr1-x42a.google.com [IPv6:2a00:1450:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 086FD16F046
        for <linux-crypto@vger.kernel.org>; Sat,  2 Apr 2022 05:07:30 -0700 (PDT)
Received: by mail-wr1-x42a.google.com with SMTP id d7so7669154wrb.7
        for <linux-crypto@vger.kernel.org>; Sat, 02 Apr 2022 05:07:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=message-id:date:mime-version:user-agent:subject:content-language
         :from:to:cc:references:in-reply-to:content-transfer-encoding;
        bh=tWegABcqL32JHQCEXG4tw1Wn/lH2n3sQgzMVGFju1Cs=;
        b=HwCMC7Fs6Qb2QuSS8MU8sCLzdNl7szuWzkPtuaSXnBrOLarJ3PbGvfeLwluwcvbANo
         wMeuL2E4kruh+TfEEIyAO+P/tPVOsdKkwv0GKef9xJBdpCY3yYVDyE1L8lIFXocAkmWa
         9tjAMMQNnX6hwP430p/DwN6j1VFyaC5J7U5KynJLlBn3Pf723UmxBlrhB4ow3rWX6mMh
         +ZII1a4q5/NtTYGYtPV9dvMLGJmizPNEygoNv47iawEG30LTay2GZbInsZdsPB2iXvxe
         MrqKuRrDzDCh5aOQzqtKvbTf1qy5mz+QD1+tajr1b/TCD2rcWcluptG0Z591lj3JrUUI
         YShw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:from:to:cc:references:in-reply-to
         :content-transfer-encoding;
        bh=tWegABcqL32JHQCEXG4tw1Wn/lH2n3sQgzMVGFju1Cs=;
        b=68TmMTZfKUwFCQlC9oHgcKpbR0LfhTzVDTPbuuEaYmH0DlS+RIdvSz2ZtilChPqgLc
         rR2IbjqNblFsrwm+Xk43RpiddyeT+L59e2mHRNEyuNavJgz830QRzjmq+Y1SUJesWN5v
         iy99xrVzIrydTLWBsm8aki+MZfM9SMzYMwo4kqnvouClvJCECPKwg9ZwPuzwOsGymUvS
         br3Seh+iAh32UeI3hMxGTMx6mBX5zEyC+TI4t8gSy9w/WD36ux7kKBaitX/mFk+JGN34
         uVIgI00seMWJV2VxRa/pDs0AGzoyf6yYSEj1CJR2urwOj0I6UQ3dCO2Y9ahL6MH0FHTz
         U9Iw==
X-Gm-Message-State: AOAM531HLmTBdJlgdtIiyKuiNd3NlNaeRmmKfItOfR/B4N2YtU763/ow
        qGxuAeRH5A6ePeemG76ND9t2rA==
X-Google-Smtp-Source: ABdhPJzPZitI3n3ThcnCdyRgnFmVRxYn14MRQvub5AGIgjbCh1t8vEmzIgc5aZBv+SEfIpvDoJTA7g==
X-Received: by 2002:a5d:6dae:0:b0:205:dfbd:789f with SMTP id u14-20020a5d6dae000000b00205dfbd789fmr10672074wrs.142.1648901248486;
        Sat, 02 Apr 2022 05:07:28 -0700 (PDT)
Received: from [192.168.0.171] (xdsl-188-155-201-27.adslplus.ch. [188.155.201.27])
        by smtp.gmail.com with ESMTPSA id e13-20020a05600c4e4d00b0038e44e316c1sm6356644wmq.6.2022.04.02.05.07.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 02 Apr 2022 05:07:28 -0700 (PDT)
Message-ID: <d092ede9-df92-9b34-d2d0-5da043e11679@linaro.org>
Date:   Sat, 2 Apr 2022 14:07:26 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH v4 28/33] dt-bindings: crypto: rockchip: convert to new
 driver bindings
Content-Language: en-US
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
To:     Corentin Labbe <clabbe@baylibre.com>, heiko@sntech.de,
        herbert@gondor.apana.org.au, krzk+dt@kernel.org, robh+dt@kernel.org
Cc:     devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-rockchip@lists.infradead.org
References: <20220401201804.2867154-1-clabbe@baylibre.com>
 <20220401201804.2867154-29-clabbe@baylibre.com>
 <30305936-4b69-e1ce-44c2-0d1d113b460e@linaro.org>
In-Reply-To: <30305936-4b69-e1ce-44c2-0d1d113b460e@linaro.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 02/04/2022 13:53, Krzysztof Kozlowski wrote:
> On 01/04/2022 22:17, Corentin Labbe wrote:
>> The latest addition to the rockchip crypto driver need to update the
>> driver bindings.
>>
>> Signed-off-by: Corentin Labbe <clabbe@baylibre.com>
>> ---
>>  .../crypto/rockchip,rk3288-crypto.yaml        | 68 +++++++++++++++++--
>>  1 file changed, 63 insertions(+), 5 deletions(-)
>>
>> diff --git a/Documentation/devicetree/bindings/crypto/rockchip,rk3288-crypto.yaml b/Documentation/devicetree/bindings/crypto/rockchip,rk3288-crypto.yaml
>> index 66db671118c3..e6c00bc8bebf 100644
>> --- a/Documentation/devicetree/bindings/crypto/rockchip,rk3288-crypto.yaml
>> +++ b/Documentation/devicetree/bindings/crypto/rockchip,rk3288-crypto.yaml
>> @@ -11,8 +11,18 @@ maintainers:
>>  
>>  properties:
>>    compatible:
>> -    enum:
>> -      - rockchip,rk3288-crypto
>> +    oneOf:
>> +      - description: crypto IP present on RK3288 SoCs
>> +        items:
>> +          - const: rockchip,rk3288-crypto
>> +      - description: crypto IP present on RK3328 SoCs
> 
> These two comments are not helping, so this should be just enum.
> 
>> +        items:
>> +          - const: rockchip,rk3328-crypto
>> +      - description: crypto IPs present on RK3399. crypto0 is the first IP with
>> +                     RSA support, crypto1 is the second IP without RSA.
> 
> The second part of this comment is helpful, first not. You have chosen
> enum in your first patch, so just extend it with comments. Additionally
> indexing does not scale. What if next generation reverses it and crypto0
> does not have RSA and crypto1 has?

Actually let me re-think this. Is programming model (registers?) same
between crypto0 and crypto1? If yes, this should be same compatible and
add a dedicated property "rockchip,rsa"?

I looked at your driver and you modeled it as main and sub devices. I
wonder why - are there some dependencies? It would be helpful to have
such information here in commit msg as well. Your commit #26 says that
only difference is the RSA.

Best regards,
Krzysztof
