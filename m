Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1E1DAC61DA4
	for <linux-crypto@archiver.kernel.org>; Thu,  2 Feb 2023 14:04:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231923AbjBBOEr (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 2 Feb 2023 09:04:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54698 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231836AbjBBOEp (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 2 Feb 2023 09:04:45 -0500
Received: from mail-ed1-x52c.google.com (mail-ed1-x52c.google.com [IPv6:2a00:1450:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3018266EFA
        for <linux-crypto@vger.kernel.org>; Thu,  2 Feb 2023 06:04:44 -0800 (PST)
Received: by mail-ed1-x52c.google.com with SMTP id f7so2100943edw.5
        for <linux-crypto@vger.kernel.org>; Thu, 02 Feb 2023 06:04:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=IHoq9f2Zn1W/sDuV+jwgMU21s17dLAzi7cnmxQ0SwVY=;
        b=Wt5jAtgjIU5sShKC+90oRxtl9+uKs299qm41mg8RYE5+oZRS8v0PwHVFIJRDDwSw1Q
         Q6Y2p1GcEiQTWqg3JEx8rXNayMuCTykK4wS+e0eCqNNXoHnvuG6ypvG3zRAxAHh+AUpv
         JnftM4VKEGbTiLH5OiUBrqRmWKGfwFwD7JvTUPsUMq1Zi8xvDFX70YLJGbRODPsIeVHM
         ggpCHIa7fmbdLqBFBiRfcCihXGGPMFXQykkv7qh9S/vKrgVLK/EjZI6HLC4TzkBhp87u
         Ha7Mky28YrDeuh48sHckdv6OQLrKTnKZml4SA7CQXL2t4WQwUA6gGKZtfoWEgtRV8BZq
         Xahg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=IHoq9f2Zn1W/sDuV+jwgMU21s17dLAzi7cnmxQ0SwVY=;
        b=hVSwzTb06ePS6PlSqE9EVPxwMn8kY/tAQPolLF8CTZNWph3vwZTmSgOpPwMYcRQKHP
         DAxwYE2KHLFcbnT93M7C7IraKw0Gm8yMuivhGaw1wUdgXx/ClHhpXoNKKycp5ct7sQb7
         6J0rSbG2ZrP2ifnr84DoBTGd4EEDRVG9Wtq4WcDSkFLjC0KxEFl2q09urJOPR5xjqoQA
         aVcnM7+TpGPMLhAki9L2lwLa767UvMljbehLbX+iDLCsnH4ltljrA2KwSjAMS5V01ure
         I+/FcJ9OxudXagu7NI3VEt6vbTD3jG+tn+5bb6hFLSJNuredVj137TU1qI78x5pJ0SEl
         Amlg==
X-Gm-Message-State: AO0yUKUA20aaVquCjo3563aiHh26Lqvu7MeLlozRWnNCOO3lFCWc9uOz
        v5ANexL9Ask9X56r6Hg2IZDzgA==
X-Google-Smtp-Source: AK7set9WK3ACkL/53gGbV+RFwL/EDOb4g+fxVkmMOxficxwf2qunm3jwyTTN1RoC22CyidgHU46TiQ==
X-Received: by 2002:a50:c350:0:b0:4a2:2e8a:14dc with SMTP id q16-20020a50c350000000b004a22e8a14dcmr7262915edb.3.1675346682681;
        Thu, 02 Feb 2023 06:04:42 -0800 (PST)
Received: from [192.168.1.102] (88-112-131-206.elisa-laajakaista.fi. [88.112.131.206])
        by smtp.gmail.com with ESMTPSA id l11-20020aa7d94b000000b004954c90c94bsm11390101eds.6.2023.02.02.06.04.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 02 Feb 2023 06:04:41 -0800 (PST)
Message-ID: <36b6f8f2-c438-f5e6-b48f-326e8b709de8@linaro.org>
Date:   Thu, 2 Feb 2023 16:04:40 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.0.2
Subject: Re: [PATCH v8 5/9] dt-bindings: qcom-qce: document clocks and
 clock-names as optional
Content-Language: en-US
To:     Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Thara Gopinath <thara.gopinath@gmail.com>,
        Bhupesh Sharma <bhupesh.sharma@linaro.org>
Cc:     Rob Herring <robh+dt@kernel.org>,
        Konrad Dybcio <konrad.dybcio@linaro.org>,
        Andy Gross <agross@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        devicetree@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-crypto@vger.kernel.org,
        Neil Armstrong <neil.armstrong@linaro.org>
References: <20230202135036.2635376-1-vladimir.zapolskiy@linaro.org>
 <20230202135036.2635376-6-vladimir.zapolskiy@linaro.org>
 <32c23da1-45f0-82a4-362d-ae5c06660e20@linaro.org>
From:   Vladimir Zapolskiy <vladimir.zapolskiy@linaro.org>
In-Reply-To: <32c23da1-45f0-82a4-362d-ae5c06660e20@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi Krzysztof,

On 2/2/23 15:53, Krzysztof Kozlowski wrote:
> On 02/02/2023 14:50, Vladimir Zapolskiy wrote:
>> From: Neil Armstrong <neil.armstrong@linaro.org>
>>
>> On certain Snapdragon processors, the crypto engine clocks are enabled by
>> default by security firmware.
> 
> Then probably we should not require them only on these variants.

I don't have the exact list of the affected SoCs, I believe Neil can provide
such a list, if you find it crucial.

--
Best wishes,
Vladimir
