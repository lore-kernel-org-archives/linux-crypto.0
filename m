Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 00EC2C05027
	for <linux-crypto@archiver.kernel.org>; Thu,  9 Feb 2023 09:24:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230313AbjBIJX7 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 9 Feb 2023 04:23:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53684 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230121AbjBIJXn (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 9 Feb 2023 04:23:43 -0500
Received: from mail-wm1-x332.google.com (mail-wm1-x332.google.com [IPv6:2a00:1450:4864:20::332])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B23F627A2
        for <linux-crypto@vger.kernel.org>; Thu,  9 Feb 2023 01:23:24 -0800 (PST)
Received: by mail-wm1-x332.google.com with SMTP id bg26so1008183wmb.0
        for <linux-crypto@vger.kernel.org>; Thu, 09 Feb 2023 01:23:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Rg1xnALG728d9yrRQNfYTDJpvFZzQVo0glDl9c0KU8g=;
        b=ylfaPIrau2GVuy2PWOvVpjY94SYRFIv4Dx8UvMxBMbeIlN1ySBcEb+ts/IfRYUnEkt
         LBumYtLWZ74t2KOfWP0cc7P+L8Y3sbD981wW11BbpG7iac45WXZRJ1NgZp9yyCB/R2zu
         3eXJSZIEbIzOCk5JU1NADBbcZmx3w1deoJ5NpCwfKv94fBJZJysyPYH+1YehBYiiyKrI
         WCyKWGasAfD4aEmp/nconRLfKUIqXTJkckOJ4aQcHY/yu+GQhBJuEvnQj3OtkAn/GHwp
         KiqZ6DGLCQzEF90t/5Qt6A69GiXEIeXxAz7nnO4svBCxywDYjFd1D4gh9F/K4iG2WDCz
         XvJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Rg1xnALG728d9yrRQNfYTDJpvFZzQVo0glDl9c0KU8g=;
        b=5VZRNQiTW9cEGajVH7W+Mu/KdzpkP+kxfPffVNmkNC5n55L6EAklx+Cf9d/5kHNYiI
         Y8mn5/udbZLr8aJfCnJZBL5pRDQxwM3CtzT8KMZP0OuQZIrj1rDVoboAHRAAGwk5DXmE
         f31exiHSRv26kKkoQGxs21ZKceZjURzUOy98JDUU0qEajSgocHbaZKle2MNTmqAD2tC6
         N2GyhXlAIxljkduldiNqf742LFQYb0IWYTv58kpewvdVMLFEivg2Pd/vTlofHoorSPFi
         a+bJF/7JaSL6vOJx9NuQ7cTEqquhTRHZoY6d2EpVDMLsnDgf9JN7fCJjaOIJxpxIsCim
         XtGA==
X-Gm-Message-State: AO0yUKUyYs3ZdXBRBNZPoPtOK8bAbCDyX5nFyRq8B16yjLEauhGl6Ldf
        jDKHWkMFMgbJBe4p8H3R6/H5jQ==
X-Google-Smtp-Source: AK7set+kuQOw6MvvklRHgZa4rKOg1Qtj4HPYFHB2GY/SXg/CwJvzKfEIJQFF3R2oYqyfT/rCRiiLVw==
X-Received: by 2002:a05:600c:a695:b0:3da:1f6a:7b36 with SMTP id ip21-20020a05600ca69500b003da1f6a7b36mr12696210wmb.0.1675934602793;
        Thu, 09 Feb 2023 01:23:22 -0800 (PST)
Received: from [192.168.1.109] ([178.197.216.144])
        by smtp.gmail.com with ESMTPSA id x7-20020a05600c188700b003cffd3c3d6csm1257654wmp.12.2023.02.09.01.23.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 09 Feb 2023 01:23:22 -0800 (PST)
Message-ID: <4039738f-7a6a-0b64-ee7e-422cbfe468a9@linaro.org>
Date:   Thu, 9 Feb 2023 10:23:20 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [PATCH v9 08/14] arm64: dts: qcom: msm8996: update QCE compatible
 according to a new scheme
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
        linux-crypto@vger.kernel.org
References: <20230208183755.2907771-1-vladimir.zapolskiy@linaro.org>
 <20230208183755.2907771-9-vladimir.zapolskiy@linaro.org>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <20230208183755.2907771-9-vladimir.zapolskiy@linaro.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 08/02/2023 19:37, Vladimir Zapolskiy wrote:
> Change the old deprecated compatible name of QCE IP on MSM8996 to new ones
> based on SoC name.
> 
> Signed-off-by: Vladimir Zapolskiy <vladimir.zapolskiy@linaro.org>
> ---


Same dependency comment.

Best regards,
Krzysztof

