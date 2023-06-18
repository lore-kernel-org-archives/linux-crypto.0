Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 27E80EB64D7
	for <linux-crypto@archiver.kernel.org>; Sun, 18 Jun 2023 08:39:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229447AbjFRIjK (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 18 Jun 2023 04:39:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37726 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229651AbjFRIjI (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 18 Jun 2023 04:39:08 -0400
Received: from mail-ej1-x634.google.com (mail-ej1-x634.google.com [IPv6:2a00:1450:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B400610E0
        for <linux-crypto@vger.kernel.org>; Sun, 18 Jun 2023 01:39:06 -0700 (PDT)
Received: by mail-ej1-x634.google.com with SMTP id a640c23a62f3a-978863fb00fso382696066b.3
        for <linux-crypto@vger.kernel.org>; Sun, 18 Jun 2023 01:39:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1687077545; x=1689669545;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=9UyA3hve3xqw+sdsT5ZWCGTlCEA9xRySCIjO+MMCiLQ=;
        b=gd6GWLW5N1St5Q4nYQfmRG9DQhWzeHHQldClzZTYzcuA4Cde5T0PZfHFRmhB+id7yQ
         9RL79p/I5SxHRGJqElqmEr0NuYPweTTopI7bU0ECo2Gn14e5lYJzUqdMrXK4BNarUwea
         3Mh3HlTogsKEIXhwIJJkEXiOzJP0WXCJc8uzyYZMCNtL47COxdHD1nbNTmvVfs7bxgQt
         +69vCKkeCTS7/2yaBn3QX5cYVfXPexWlTOilqc8Cmf8Tt3y9HqM7g9OYRLOwLBMBanAw
         OG7OFQEGwKos1m8HCp55hXkSu1PFzsSl2VeKL+qylKMsH48lcCRLiRZNCP5A0vY/zKRN
         AV0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687077545; x=1689669545;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=9UyA3hve3xqw+sdsT5ZWCGTlCEA9xRySCIjO+MMCiLQ=;
        b=SQz0bcNQMAWcjaFhRNKqb/Uu0LqQ+/EfL4SdNMBMitTpMIzB/xlwJ0Swr01IyYTbuc
         pl066nQ1HrGmRH4ttWJAI9JLZi5XbcwjGXkrz52TXBTuaXL6W027AUEWkNhKKqGcLJW+
         tCA3Buwcu9UEkZQ8s9T9lZHIbqidETEZlDQYQ/rx4xftXF6Y6re6CVKW13a0e9pPaicx
         wgjsFtVPYTjjydasc+WAQ4Yrn4Gggr+19XHfLWOttyC/HkwdKSjX+bkQ5G2eRpcUOotX
         iFNSZbGq55sGGKR9RFB/vUCDLOTQAes8kPyFf4ZovU+MxJGVL2iAHap8fRiwJA31oCyX
         1Eiw==
X-Gm-Message-State: AC+VfDxS8RyWdWpYk+JdZdAokNe1n9EUS8hqJ0ePdwjh+kHLXdL7+967
        xvutULa8iAvAJBoPNgrPYSe/CA==
X-Google-Smtp-Source: ACHHUZ6IBsZP/mUu94tjlGbEtnaYcAMXUk02/bHR4PWeAdpbSzxJIHffQyZbJ/q1chW8yOrQbwGChQ==
X-Received: by 2002:a17:907:7dab:b0:94e:8559:b5c5 with SMTP id oz43-20020a1709077dab00b0094e8559b5c5mr6878580ejc.64.1687077545201;
        Sun, 18 Jun 2023 01:39:05 -0700 (PDT)
Received: from [192.168.1.20] ([178.197.219.26])
        by smtp.gmail.com with ESMTPSA id s14-20020a170906354e00b009888b71c368sm293900eja.152.2023.06.18.01.39.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 18 Jun 2023 01:39:04 -0700 (PDT)
Message-ID: <27b85110-9eb8-84dc-17a9-908e312e2e22@linaro.org>
Date:   Sun, 18 Jun 2023 10:39:02 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.12.0
Subject: Re: [PATCH v8 02/11] dt-bindings: dma: Increase iommu maxItems for
 BAM DMA
Content-Language: en-US
To:     Bhupesh Sharma <bhupesh.sharma@linaro.org>,
        linux-arm-msm@vger.kernel.org, devicetree@vger.kernel.org
Cc:     agross@kernel.org, linux-kernel@vger.kernel.org,
        linux-crypto@vger.kernel.org, andersson@kernel.org,
        bhupesh.linux@gmail.com, robh+dt@kernel.org,
        konrad.dybcio@linaro.org, vladimir.zapolskiy@linaro.org,
        rfoss@kernel.org, neil.armstrong@linaro.org, djakov@kernel.org,
        stephan@gerhold.net, Anders Roxell <anders.roxell@linaro.org>,
        Linux Kernel Functional Testing <lkft@linaro.org>
References: <20230526192210.3146896-1-bhupesh.sharma@linaro.org>
 <20230526192210.3146896-3-bhupesh.sharma@linaro.org>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <20230526192210.3146896-3-bhupesh.sharma@linaro.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 26/05/2023 21:22, Bhupesh Sharma wrote:
> Since SM8450 BAM DMA engine supports five iommu entries,
> increase the maxItems in the iommu property section, without
> which 'dtbs_check' reports the following error:
> 
>   arch/arm64/boot/dts/qcom/sm8450-sony-xperia-nagara-pdx224.dtb:
>     dma-controller@1dc4000: iommus: is too long

Also, please drop error message, because it is not true. The files do
not have such device node, so you cannot have such warning.

Please rewrite the commit msg to explain that certain devices, e.g.
sm8250, use more iommus.

Best regards,
Krzysztof

