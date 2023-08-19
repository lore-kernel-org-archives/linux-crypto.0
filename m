Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4B21EEE49A5
	for <linux-crypto@archiver.kernel.org>; Sat, 19 Aug 2023 14:34:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233558AbjHSOe2 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 19 Aug 2023 10:34:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53156 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233527AbjHSOe1 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 19 Aug 2023 10:34:27 -0400
Received: from mail-ej1-x62d.google.com (mail-ej1-x62d.google.com [IPv6:2a00:1450:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68B18B249
        for <linux-crypto@vger.kernel.org>; Sat, 19 Aug 2023 07:34:25 -0700 (PDT)
Received: by mail-ej1-x62d.google.com with SMTP id a640c23a62f3a-99c1d03e124so225424066b.2
        for <linux-crypto@vger.kernel.org>; Sat, 19 Aug 2023 07:34:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1692455664; x=1693060464;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ha1KjyT6V1o5qZr6TeP96iO4FdCTMuqeCrmWHV7Hty4=;
        b=T6nKXyb3SPnRAQgMVcJtyOkq++PRIN9F2MYLPzZ7i6aXrnuV5ZkO7/roBqiSSm2EJa
         XuNrMA2OLKK34/zc0qiHpe/3Viah0SHiX8nfdTFNpL31EDlXhy2gbwNc1B8E3ZlVAfNJ
         fJ2Yr5LwKJV2qgD9xySbgzzqraX2XrNPMY/POPrlD9eDJcFB0gJePCPbsimMUzVv53kP
         90LaQY4brexucXTo1L4FXzMihfOR6UDlxZmLVYIzNFdOr8UJz+L5Q3pajkKTVnzGN23E
         s64pGmTjEIea/C9lsG1G+gJlxZxNG4ClPTr1+toCMPT2S1Y4IRiZ7XcJaLy5nQQqhbOK
         kGnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692455664; x=1693060464;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ha1KjyT6V1o5qZr6TeP96iO4FdCTMuqeCrmWHV7Hty4=;
        b=gJ3m7XyftRuN4YGlF1Y0dM7FewOMjbXyc/uFaNxXr78PqKS0TP6q/5Ie4JiIbjrTpv
         JDiuI+pk5MZMIUkWzvxZo9IKb8FL0CJ8ph2WNl1JIioCCxnRUBtbtOk/hDQDmQ4fTrJE
         hBzAy4WdpwSh5HNkWd85fHS1YQw2poZMLw2FD0QPH58ae+xamnIQ/EzJOtCU9r54pXcV
         oEyVwwP7RVcPE2aRpBSVlzcu07qwhq7Ag3HyVOYyLJMHUNCjL0UAG16pwb9GLDyUsg27
         L/WF2qdbVLt/AJRcOGaYJ+3uPGzl/Z+HE00q5QYY5sMj8EKmw5V0Iholq3D/rSuEK1Ke
         kkKg==
X-Gm-Message-State: AOJu0Yx4iAZYxLee1ckfbAJ8r5b6BDhRKKXjCEdMrm2HEPz9ojTu42gx
        z8XJKZC4JYguYmfvAuSKcBg2iw==
X-Google-Smtp-Source: AGHT+IEGkqcrHrpAGksQSYiS8m/z8KkdErgOQRR/5f21rHWfqDaiJDIuag576zuL8QVsVpeRdHeT7Q==
X-Received: by 2002:a17:906:310d:b0:992:1233:9c45 with SMTP id 13-20020a170906310d00b0099212339c45mr1257628ejx.69.1692455663844;
        Sat, 19 Aug 2023 07:34:23 -0700 (PDT)
Received: from [192.168.0.22] ([77.252.47.198])
        by smtp.gmail.com with ESMTPSA id k21-20020a1709063fd500b0099bcf1c07c6sm2834891ejj.138.2023.08.19.07.34.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 19 Aug 2023 07:34:23 -0700 (PDT)
Message-ID: <96033a59-a2ea-c906-a033-84119c5783d7@linaro.org>
Date:   Sat, 19 Aug 2023 16:34:21 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.14.0
Subject: Re: [PATCH v3 11/50] dt-bindings: crypto: add sam9x7 in Atmel TDES
Content-Language: en-US
To:     Tudor Ambarus <tudor.ambarus@linaro.org>,
        Varshini.Rajendran@microchip.com, herbert@gondor.apana.org.au,
        davem@davemloft.net, robh+dt@kernel.org,
        krzysztof.kozlowski+dt@linaro.org, conor+dt@kernel.org,
        Nicolas.Ferre@microchip.com, alexandre.belloni@bootlin.com,
        claudiu.beznea@microchip.com, linux-crypto@vger.kernel.org,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
References: <20230728102442.265820-1-varshini.rajendran@microchip.com>
 <09bd1388-02aa-32c7-319e-d7150a0f3e9c@linaro.org>
 <1ec901d0-44c2-1d28-5976-d93abfffee67@microchip.com>
 <37782447-43c7-50f9-b9b4-5fbca94ce8c6@linaro.org>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <37782447-43c7-50f9-b9b4-5fbca94ce8c6@linaro.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 10/08/2023 09:22, Tudor Ambarus wrote:
> 
> 
> On 8/10/23 06:38, Varshini.Rajendran@microchip.com wrote:
>>> On 7/28/23 11:24, Varshini Rajendran wrote:
>>>> Add DT bindings for atmel TDES.
>>> NACK. The atmel crypto drivers check the version at runtime and
>>> fill a capabilities structure based on the version identified.
>>> There's a single compatible regardless of the version of the IP
>>> used until now, why do you want to change it?
>>>
>> Hi Tudor,
> 
> Hi,
> 
>>
>> I am aware that there is no change in the crypto IP used. This patch is 
>> to add a SoC specific compatible as expected by writing-bindings 
>> guideline. Maybe a bit more explanation in the commit description might 
>> do the trick.
>>
> 
> So you add a compatible that will never be used just to comply with
> the writing bindings guideline?

How do you know that it is never going to be used? The guideline asks
for this on purpose, so any future quirks or incompatibilities can be
easily addressed.

Best regards,
Krzysztof

