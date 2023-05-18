Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E91D7C7EE2A
	for <linux-crypto@archiver.kernel.org>; Thu, 18 May 2023 14:43:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231232AbjEROnY (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 18 May 2023 10:43:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60034 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231675AbjEROnX (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 18 May 2023 10:43:23 -0400
Received: from mail-ej1-x631.google.com (mail-ej1-x631.google.com [IPv6:2a00:1450:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E682AF7
        for <linux-crypto@vger.kernel.org>; Thu, 18 May 2023 07:43:20 -0700 (PDT)
Received: by mail-ej1-x631.google.com with SMTP id a640c23a62f3a-9659c5b14d8so330464366b.3
        for <linux-crypto@vger.kernel.org>; Thu, 18 May 2023 07:43:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1684420999; x=1687012999;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=c5mg0bYNmMZvR4XH2KepYJHCkc1QT01FXeVw0nsFkdI=;
        b=OE2AED9qmZeTEF4yTzRED57SFPtPzoTevCrBoA2Q6K6gvRvkQLMs6JKlvgW9jETwAT
         sp6LZGN/xQgYPx1elInzgtAzdG3z1OgVoXHWSSNpCjuCdDfXNhiIlxI8jFzKwreq+KpV
         t6vYmcjPbdFqMFTTLhtX607igdRWV+UuwJtM/wr4dgzRLg/qiMlIl1Kx51TJzB7pYgAZ
         w8R0wayIPAPMVBatVENiYy3xTDjOGl2vTYWhqnLXez6YZhMYHZSJnQ/RBJ5IrvEVWH1A
         Eavd23Glvi7/xu8ZnLh7ObYJnhLaX02jGOwI4obyur9GDUNATueJv8JPtxU/pQQMBtJ5
         Q0yg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684420999; x=1687012999;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=c5mg0bYNmMZvR4XH2KepYJHCkc1QT01FXeVw0nsFkdI=;
        b=STMvT85QGUz6Go7qi2/eASZWrczTfDETt1s1YkfmzZxHkk8IUVesfeSdYToXT2Kp+Z
         a9ZlzBXqQ/APLSi9tRR6sBFDsfdAbzQsEPUXVRB64BXL7eK/6oF4dJQDM2ZhNZYMYh5O
         gtAjHT/QgVVXgLSYfKMCnpB+JEMeCHQ80lFg+rzIi3/8RwjgrNgSftMJv+GiiA/loe31
         QefxQOpmLutj3YtOpOClHtx8IDC2PI1FXRo6Hg4oqW8aQD68oCnp30EfuEWmY0LiIEaK
         o7nbblGhhyrqXKoAUaIdGETnesiiXzRmhXgDkG50mUnch9JhhLoH/LOdvbHAz1mGGz9K
         SFgg==
X-Gm-Message-State: AC+VfDwOX8ejHozivDBNyoO8XS159mHBvLkmjIR+NvzN6vcUItV3aoUa
        RB7pOa/d2HOCKd+728Izw6kW4g==
X-Google-Smtp-Source: ACHHUZ45LkdJN1RAMofvHRAMOL/5aJwIIPt/2VGC/d6xWczG4Bg4nJDUcgLltbg0DwlPo+UOxleaXg==
X-Received: by 2002:a17:906:d542:b0:96b:e92:4feb with SMTP id cr2-20020a170906d54200b0096b0e924febmr15567096ejc.60.1684420999310;
        Thu, 18 May 2023 07:43:19 -0700 (PDT)
Received: from ?IPV6:2a02:810d:15c0:828:7e24:6d1b:6bf:4249? ([2a02:810d:15c0:828:7e24:6d1b:6bf:4249])
        by smtp.gmail.com with ESMTPSA id zm10-20020a170906994a00b0094a82a236cbsm1031416ejb.129.2023.05.18.07.43.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 18 May 2023 07:43:18 -0700 (PDT)
Message-ID: <1fe6d202-f180-b76f-bf8e-98280355ae5a@linaro.org>
Date:   Thu, 18 May 2023 16:43:17 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Subject: Re: [PATCH V3 4/4] arm64: dts: qcom: ipq9574: Enable crypto nodes
Content-Language: en-US
To:     Anusha Rao <quic_anusha@quicinc.com>, agross@kernel.org,
        andersson@kernel.org, konrad.dybcio@linaro.org,
        thara.gopinath@gmail.com, herbert@gondor.apana.org.au,
        davem@davemloft.net, robh+dt@kernel.org,
        krzysztof.kozlowski+dt@linaro.org, conor+dt@kernel.org,
        mturquette@baylibre.com, sboyd@kernel.org, p.zabel@pengutronix.de,
        bhupesh.sharma@linaro.org, linux-arm-msm@vger.kernel.org,
        linux-crypto@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-clk@vger.kernel.org
Cc:     quic_srichara@quicinc.com, quic_gokulsri@quicinc.com,
        quic_sjaganat@quicinc.com, quic_kathirav@quicinc.com,
        quic_arajkuma@quicinc.com, quic_poovendh@quicinc.com
References: <20230518141105.24741-1-quic_anusha@quicinc.com>
 <20230518141105.24741-5-quic_anusha@quicinc.com>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <20230518141105.24741-5-quic_anusha@quicinc.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 18/05/2023 16:11, Anusha Rao wrote:
> Enable crypto support for ipq9574.
> 
> Signed-off-by: Anusha Rao <quic_anusha@quicinc.com>
> ---

Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>

Best regards,
Krzysztof

