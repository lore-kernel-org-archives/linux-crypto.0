Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 264EAC83F19
	for <linux-crypto@archiver.kernel.org>; Tue, 29 Aug 2023 06:39:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232228AbjH2GjT (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 29 Aug 2023 02:39:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231814AbjH2Gix (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 29 Aug 2023 02:38:53 -0400
Received: from mail-ed1-x529.google.com (mail-ed1-x529.google.com [IPv6:2a00:1450:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2DA2E18F
        for <linux-crypto@vger.kernel.org>; Mon, 28 Aug 2023 23:38:51 -0700 (PDT)
Received: by mail-ed1-x529.google.com with SMTP id 4fb4d7f45d1cf-5256d74dab9so5313646a12.1
        for <linux-crypto@vger.kernel.org>; Mon, 28 Aug 2023 23:38:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1693291129; x=1693895929;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=uTFBVeroMlwiaB9gHfLPinmkZc9PWCk3ZLgrqKzf1pw=;
        b=nYYqLRMEg7Cvj15A32kSNX9hEbEqCdeQQh9M4vtDd8nI4N6lc0TQZaYa2FJBg7sxWW
         /ip5KLQPlSPhbzg3Uf9DHyOt1Rp9rILEE0pnhVxji9OE+wr33E04M0K6+wuMnmG34/S2
         EgHLravxjXGuem8SCYBpMiUNMpF3cfRp9C/nv65gLcCvC3ftvdbTHVH4Zf45gKm+ef7S
         4H+EA1OYVp1+CdT1X2a0RCb2MNHKlimhM+ZIVG3+3glmLong8ftqzIA7ErWoGX4MRmQ/
         IqdA6VyHzYltyDNmkod3Hbr1dRdmfr3Tal5WwI7xgWVtwYBzH/le39KwETqA+bIKDjy/
         BuPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1693291129; x=1693895929;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=uTFBVeroMlwiaB9gHfLPinmkZc9PWCk3ZLgrqKzf1pw=;
        b=WkL3MJzNpL6T/9s9JYYZd76u85OddDpRBP2kmqYRf3wUQ4h4gYrko4t/5m7CB7lHcS
         xkhjpdVGXteRiUbbUB1pqE0SzmSCk/SvwSdn367ausyZfxq/g7TD9AHWW63OumS8wgtw
         V8OJWJpxtyA9wkLQq38PEtRQ+pibypn/dAMRxfE5mU+LDKq8b6whxR38P9lY8yrVx14G
         xlyPMchVg5UOQyfw9BeOy/m52ubb3hej8VA9uC9l6Pn4o0BNPzNQmc+VligfKk431qt4
         1y9uF/aAGpoLS9ugr+8GEPTpRpOoYpxV3Zgdp54fapzb3ZdsCAlv1PadJ+i7VghFnl5r
         +sfA==
X-Gm-Message-State: AOJu0YzrEhu4orCARCyBM9TEw0GyADpvryf9LzgFiNyc6Hf6UT/+5P6H
        5pDP1dRy+aPTzVCUkTBsMQbvUtSlaffOJrvMpnM=
X-Google-Smtp-Source: AGHT+IFCjFH9WZZy4ewTzzinqqQNY1wtNO3veQypzJO2IyjqazARAD1wZudxhl3FNBa5+1z0saPEag==
X-Received: by 2002:aa7:ca59:0:b0:51d:f5bd:5a88 with SMTP id j25-20020aa7ca59000000b0051df5bd5a88mr19933585edt.38.1693291129694;
        Mon, 28 Aug 2023 23:38:49 -0700 (PDT)
Received: from [192.168.0.22] ([77.252.47.196])
        by smtp.gmail.com with ESMTPSA id u8-20020aa7d888000000b00527e7087d5dsm5281390edq.15.2023.08.28.23.38.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 28 Aug 2023 23:38:49 -0700 (PDT)
Message-ID: <c741c4be-50b4-0bd8-79eb-37895342f5af@linaro.org>
Date:   Tue, 29 Aug 2023 08:38:48 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.14.0
Subject: Re: [PATCH v3 4/6] dt-bindings: crypto: qcom,prng: document SM8550
Content-Language: en-US
To:     Rob Herring <robh@kernel.org>,
        Neil Armstrong <neil.armstrong@linaro.org>
Cc:     Andy Gross <agross@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konrad.dybcio@linaro.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Conor Dooley <conor+dt@kernel.org>,
        Vinod Koul <vkoul@kernel.org>, linux-arm-msm@vger.kernel.org,
        linux-crypto@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Om Prakash Singh <quic_omprsing@quicinc.com>
References: <20230828-topic-sm8550-rng-v3-0-7a0678ca7988@linaro.org>
 <20230828-topic-sm8550-rng-v3-4-7a0678ca7988@linaro.org>
 <20230828213610.GA386486-robh@kernel.org>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <20230828213610.GA386486-robh@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 28/08/2023 23:36, Rob Herring wrote:
> On Mon, Aug 28, 2023 at 10:04:39AM +0200, Neil Armstrong wrote:
>> Document SM8550 compatible for the True Random Number Generator.
>>
>> Reviewed-by: Om Prakash Singh <quic_omprsing@quicinc.com>
>> Signed-off-by: Neil Armstrong <neil.armstrong@linaro.org>
> 
> Where's Krzysztof's tag?
> 

The patch evolved and Neil mentioned in cover letter changelog that he
did not collect Reviews because of that. Seems ok for me.

For the patch:

Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>

Best regards,
Krzysztof

