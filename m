Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0E81BEE49A0
	for <linux-crypto@archiver.kernel.org>; Mon, 21 Aug 2023 06:07:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233304AbjHUGHs (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 21 Aug 2023 02:07:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49462 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233296AbjHUGHs (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 21 Aug 2023 02:07:48 -0400
Received: from mail-lf1-x135.google.com (mail-lf1-x135.google.com [IPv6:2a00:1450:4864:20::135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C103DA2
        for <linux-crypto@vger.kernel.org>; Sun, 20 Aug 2023 23:07:46 -0700 (PDT)
Received: by mail-lf1-x135.google.com with SMTP id 2adb3069b0e04-4fe4762173bso4380797e87.3
        for <linux-crypto@vger.kernel.org>; Sun, 20 Aug 2023 23:07:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1692598065; x=1693202865;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=abC59mP6JAJMeQMLsAfe2u+ZdmRJRLE9AtCEXGBBljg=;
        b=tlubH/Cjia7U7baDNzn/xFBRuZiX0j0OWI8OyOgzdmezw3ZIpFouzSFpC80kDVmRCX
         2Kmhh9iWMa90EU0LO4bAqQOA5dkKy121HTQxOj6nj4WreA3YhYSapS9xQUX1iC4Ls5FW
         kswd4DhEEd7x/jUgQB8cfSxRPiz7cG/ooKi55phUys+bFyNNBrGoVyRZW0SVPebHLYQ7
         LvP+sD/Y7X6Qoyk5uOrjHEI9KEDKpmCBKzC7mXCuvLC02xnOP7BDKWX0sARRjpFJpj0b
         Q060GleYwbeZW8jTC1/InS50SshmVTYXTtd3M2Dv5YXQbPQkdkmVbXvkSWTy3yul6HsR
         wHlw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692598065; x=1693202865;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=abC59mP6JAJMeQMLsAfe2u+ZdmRJRLE9AtCEXGBBljg=;
        b=KrYCQvj2nqxDkpKHmCoVmNgCQa6MsT0GmwQbx2nROdQjJUxQy4u8Tp6TiUQ8eqRx2x
         /kmYaoS/qC3ZilQ5Nfi/l8VvxjjH6ycBaGIOVWd29d+d2AvTN2MvGBdHt8qgVKqYBCq2
         MMgHMENLPetMaWZN2ivcNxIKhNrgSdmlGQoAMvBKsyu9ZSh1alHKgwwIPbg0OVrz176J
         LoYXIOD8VXGWjDMQhKZztsfpWqMQA1LmALDTvVZzdwuLpz+zZ5/sJLDsVnAHyqqGUT4t
         oh4lEkWUnzY8sGRu39tP2YijGjbHSfU8gA+RqacFBX5C1MIYL3vqnfA1Zo0FO0sw4fNS
         TyoA==
X-Gm-Message-State: AOJu0YwxRaUHG8d7Q/jcM55fit3R3pPYAg1WxxJsFd7H2mkukeYigAzg
        ULseOm+QtnEz0u8j2h/41RdCeQ==
X-Google-Smtp-Source: AGHT+IH6wBrCMNqusfsbYd6KwloxQeMounCo4oof+2Y9bKUVLZ4QpwHUSVeeCcxpZFabgVsKqsP2Fw==
X-Received: by 2002:a05:6512:2396:b0:4fd:fafd:1ed4 with SMTP id c22-20020a056512239600b004fdfafd1ed4mr4850733lfv.2.1692598064921;
        Sun, 20 Aug 2023 23:07:44 -0700 (PDT)
Received: from [192.168.0.22] ([77.252.47.198])
        by smtp.gmail.com with ESMTPSA id lg5-20020a170906f88500b009937dbabbd5sm5861855ejb.220.2023.08.20.23.07.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 20 Aug 2023 23:07:44 -0700 (PDT)
Message-ID: <1f492c4e-2125-73eb-8523-389e24727516@linaro.org>
Date:   Mon, 21 Aug 2023 08:07:43 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.14.0
Subject: Re: [PATCH 1/3] dt-bindings: crypto: qcom,prng: Add SM8450
Content-Language: en-US
To:     Om Prakash Singh <quic_omprsing@quicinc.com>,
        konrad.dybcio@linaro.org
Cc:     agross@kernel.org, andersson@kernel.org, conor+dt@kernel.org,
        davem@davemloft.net, devicetree@vger.kernel.org,
        herbert@gondor.apana.org.au, krzysztof.kozlowski+dt@linaro.org,
        linux-arm-msm@vger.kernel.org, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, marijn.suijten@somainline.org,
        robh+dt@kernel.org, vkoul@kernel.org
References: <20230811-topic-8450_prng-v1-1-01becceeb1ee@linaro.org>
 <20230818161720.3644424-1-quic_omprsing@quicinc.com>
 <2c208796-5ad6-c362-dabc-1228b978ca1d@linaro.org>
 <1cadb40e-b655-4b9b-9189-dfdb22a2c234@quicinc.com>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <1cadb40e-b655-4b9b-9189-dfdb22a2c234@quicinc.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 21/08/2023 02:52, Om Prakash Singh wrote:
> I meant first one. using "qcom,rng-ee".

Then please provide some reasons.

> 
> I am looking for generic compatible string for all SoCs for which core 
> clock can be optional, same as we have "qcom,prng-ee".

There is a generic compatible already... but anyway, is the clock really
optional? Or just configured by firmware?

> 
> If we are using SoC name in compatible string, for each SoC support we 
> need to update qcom,prng.yaml file.

So you were talking about second case from my email? Still not sure what
you want to propose, but just in case - please always follow DT bindings
guidelines:

https://elixir.bootlin.com/linux/v6.1-rc1/source/Documentation/devicetree/bindings/writing-bindings.rst#L42

Best regards,
Krzysztof

