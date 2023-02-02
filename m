Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DB11CC636D4
	for <linux-crypto@archiver.kernel.org>; Thu,  2 Feb 2023 14:22:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232335AbjBBOWA (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 2 Feb 2023 09:22:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38008 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232301AbjBBOV7 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 2 Feb 2023 09:21:59 -0500
Received: from mail-wr1-x434.google.com (mail-wr1-x434.google.com [IPv6:2a00:1450:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2A7A8E4A5
        for <linux-crypto@vger.kernel.org>; Thu,  2 Feb 2023 06:21:56 -0800 (PST)
Received: by mail-wr1-x434.google.com with SMTP id t7so1861447wrp.5
        for <linux-crypto@vger.kernel.org>; Thu, 02 Feb 2023 06:21:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:in-reply-to:organization:references:cc:to
         :content-language:subject:reply-to:from:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=hT2Sg5RCvxGVieyn9ThyduouHJ14wDuCxDRQiyyVT08=;
        b=J6bhMmXWXuIVKrracXN1hlO5UL0c6ORDi0dUF8738D5qvkC1WsSJBXct9MGnh924bg
         qF3zQAqtRSsf99OkABnyTd0y2Rj8v2L/ib8Zz0o7sR+XqKyv1YmWpo+h3ueIWxA/vKaJ
         T2r7o3MtRmED/rnfD7WvZynzpNr4x5FBztsRaYjR7uWN9cNqUXAzCCAOst4gV0HDBI6v
         ucE7apxixCOH1p0k7Lo/4HB7rqd+bLocQm5ighQ+vLsL1s1VupL9FKi7ixf4obEfLmMp
         3DptFuEl7NZxpLachyXgQeCLrXX+vppdRUJ35lVqGOu2TcrpJBZNx8kb9R2hJcmjTejr
         En/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:organization:references:cc:to
         :content-language:subject:reply-to:from:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=hT2Sg5RCvxGVieyn9ThyduouHJ14wDuCxDRQiyyVT08=;
        b=JqPJUHEzi1Lqy+xlnsxuVqoqw7s105E3tlLbeaSQA6XsqFfhX6xal+q1RTot9Z7ELj
         QjW2Nf+rjRT3ejpMtn+LqyoNOvGXhrPFxpBfWj0hHyti7tnu+O/0ZTy2ZK0epi42SOm3
         tJAeEKzaPYmaHAmMS7zewt33TdSKI96as1s+O+sT6nbjICqottv0vHKUyfIZdUfIY9yz
         rnrDxAUwUb+8xfPpXWu08tllVRrnXfe5ienVRTa3KiJpzZ9vuIoypwT0wrKpfNqi3OlA
         Z/zzINxlzEpRI0XBBMYwYs/bxaAenk7eJ5aOWKaYcv6z73Oq7Lk6Wwzl/CTB8Znm9u3v
         qClg==
X-Gm-Message-State: AO0yUKVnLTOMN/bkrMKkjMsrIFGVRbsmt2PhRJli2N3jiDjuzgDa7bpv
        5oK1gkhPPCvGw6keE6WWtyUZLg==
X-Google-Smtp-Source: AK7set8zei2DpYWSg2v+HiyD2kgij91FDnUnAnI8IZ3BcHnTi/6hAy3n2MqL/MiZxc82RKC8sSDjRg==
X-Received: by 2002:a05:6000:68a:b0:2be:c5d:adc4 with SMTP id bo10-20020a056000068a00b002be0c5dadc4mr6235940wrb.13.1675347715298;
        Thu, 02 Feb 2023 06:21:55 -0800 (PST)
Received: from ?IPV6:2a01:e0a:982:cbb0:ce5b:78ab:f662:ef0d? ([2a01:e0a:982:cbb0:ce5b:78ab:f662:ef0d])
        by smtp.gmail.com with ESMTPSA id p6-20020a5d48c6000000b002bfc0558ecdsm19701947wrs.113.2023.02.02.06.21.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 02 Feb 2023 06:21:54 -0800 (PST)
Message-ID: <a2e4dff0-af8f-dccb-9074-8244b054c448@linaro.org>
Date:   Thu, 2 Feb 2023 15:21:53 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
From:   Neil Armstrong <neil.armstrong@linaro.org>
Reply-To: neil.armstrong@linaro.org
Subject: Re: [PATCH v8 5/9] dt-bindings: qcom-qce: document clocks and
 clock-names as optional
Content-Language: en-US
To:     Vladimir Zapolskiy <vladimir.zapolskiy@linaro.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Thara Gopinath <thara.gopinath@gmail.com>,
        Bhupesh Sharma <bhupesh.sharma@linaro.org>
Cc:     Rob Herring <robh+dt@kernel.org>,
        Konrad Dybcio <konrad.dybcio@linaro.org>,
        Andy Gross <agross@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        devicetree@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-crypto@vger.kernel.org
References: <20230202135036.2635376-1-vladimir.zapolskiy@linaro.org>
 <20230202135036.2635376-6-vladimir.zapolskiy@linaro.org>
 <32c23da1-45f0-82a4-362d-ae5c06660e20@linaro.org>
 <36b6f8f2-c438-f5e6-b48f-326e8b709de8@linaro.org>
Organization: Linaro Developer Services
In-Reply-To: <36b6f8f2-c438-f5e6-b48f-326e8b709de8@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 02/02/2023 15:04, Vladimir Zapolskiy wrote:
> Hi Krzysztof,
> 
> On 2/2/23 15:53, Krzysztof Kozlowski wrote:
>> On 02/02/2023 14:50, Vladimir Zapolskiy wrote:
>>> From: Neil Armstrong <neil.armstrong@linaro.org>
>>>
>>> On certain Snapdragon processors, the crypto engine clocks are enabled by
>>> default by security firmware.
>>
>> Then probably we should not require them only on these variants.
> 
> I don't have the exact list of the affected SoCs, I believe Neil can provide
> such a list, if you find it crucial.

It's the case for SM8350, SM8450 & SM8550.

Neil

> 
> -- 
> Best wishes,
> Vladimir

