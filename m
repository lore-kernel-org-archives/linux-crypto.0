Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 63D57C636D6
	for <linux-crypto@archiver.kernel.org>; Fri, 17 Feb 2023 08:58:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229959AbjBQI65 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 17 Feb 2023 03:58:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34100 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229816AbjBQI64 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 17 Feb 2023 03:58:56 -0500
Received: from mail-ed1-x530.google.com (mail-ed1-x530.google.com [IPv6:2a00:1450:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65544604F4
        for <linux-crypto@vger.kernel.org>; Fri, 17 Feb 2023 00:58:55 -0800 (PST)
Received: by mail-ed1-x530.google.com with SMTP id j20so3168065edw.0
        for <linux-crypto@vger.kernel.org>; Fri, 17 Feb 2023 00:58:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=qs4gU72VHUNMPaZOm7nEODtbU0mJ0OdcIK2lIN68xlo=;
        b=EunzvhkEUXQIZuBifghYhfX2/i2ffpXe+kAn9O9nV/EWtNPVhBw2kOBMqnRoiLGDjw
         gxRp6z+zSIbe3JTaqvKqv/uflQneZuaXmXzMUdgfnF9EFm+j+3XKpU5OtE831H3Clnvi
         uiYlcUYttBToyPQStxktVeVHo5lxzqJv5JzAFJ/FAmPB/E7gZdW0ENpeVDgo2bwkUroH
         K+ukFLX/d5L0CAOAm7iOt9kc4uJg2dy/P/gsH1xcIXQkAW+2a8CbOLX1sP7hY2O71GtZ
         /WRh9x+vBFKVplBnqdjWSOulIrEUiMtcms09vQMJrsq5m8866IEgZfezxR4T3CpDE/dW
         9XMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=qs4gU72VHUNMPaZOm7nEODtbU0mJ0OdcIK2lIN68xlo=;
        b=BxEoFKmqyK7NH4S84tXhO39ZsOwL69Mn9zrOkNRbnUKNrq1lnDFz69cBMr796da0rm
         OGLXgmvT4pWPc9rImbp5BMN+lzkI3rW373L/OPpUB6EEZz18GAE7sgcep3wbA9jMrVKo
         W+fi2dP9h6kFHFWmJ9+qxH1DA4w0QmBgCDP8urzlXbcLocRb6A4TYCRXaMTO2JR1iB2+
         GTZriUe3rnQ41Pm71fM6xAyZ+MbVeOpD1Ebbet+nIkCuvaSGX2tkQzEwz+5Euu83su3X
         2TBdc2UZMHkwGl3yeVTDfkobNVLUuq4xc/LhLlUVy4CdbUlpeJvuyYnDMJYRAxIPE4VI
         MG7Q==
X-Gm-Message-State: AO0yUKUT8wvAfnPQ+vuzkMP5F4NH4SfIdLv32ueeh0XxG7AzWAcuUKNC
        y3yYzjzh2VvwRjuDYFdffIpSeg==
X-Google-Smtp-Source: AK7set8D5qS/zMbMErNjB8zzWJHf8Tn+NYft2qeWuFWehFZgyXd9JIBBN8/HkaD53f6LphX148o2/g==
X-Received: by 2002:a17:907:76ad:b0:8b1:749f:b2c0 with SMTP id jw13-20020a17090776ad00b008b1749fb2c0mr3716140ejc.74.1676624333946;
        Fri, 17 Feb 2023 00:58:53 -0800 (PST)
Received: from [192.168.1.109] ([178.197.216.144])
        by smtp.gmail.com with ESMTPSA id t1-20020a17090616c100b008b13a1abadasm1852257ejd.75.2023.02.17.00.58.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 17 Feb 2023 00:58:53 -0800 (PST)
Message-ID: <60d012ee-d511-81b7-dff3-7f01d947bdf7@linaro.org>
Date:   Fri, 17 Feb 2023 09:58:51 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [PATCH v10 06/10] dt-bindings: qcom-qce: document optional clocks
 and clock-names properties
Content-Language: en-US
To:     Vladimir Zapolskiy <vladimir.zapolskiy@linaro.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
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
References: <20230216131430.3107308-1-vladimir.zapolskiy@linaro.org>
 <20230216131430.3107308-7-vladimir.zapolskiy@linaro.org>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <20230216131430.3107308-7-vladimir.zapolskiy@linaro.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 16/02/2023 14:14, Vladimir Zapolskiy wrote:
> On newer Qualcomm SoCs the crypto engine clocks are enabled by default
> by security firmware. To drop clocks and clock-names from the list of
> required properties use 'qcom,sm8150-qce' compatible name.
> 
> The change is based on Neil Armstrong's observation and an original change.
> 
> Cc: Neil Armstrong <neil.armstrong@linaro.org>
> Signed-off-by: Vladimir Zapolskiy <vladimir.zapolskiy@linaro.org>
> ---


Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>

Best regards,
Krzysztof

