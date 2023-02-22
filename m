Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8D367C64EC7
	for <linux-crypto@archiver.kernel.org>; Wed, 22 Feb 2023 17:34:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230291AbjBVRe3 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 22 Feb 2023 12:34:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50010 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229561AbjBVRe2 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 22 Feb 2023 12:34:28 -0500
Received: from mail-lf1-x129.google.com (mail-lf1-x129.google.com [IPv6:2a00:1450:4864:20::129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32F4A360BF
        for <linux-crypto@vger.kernel.org>; Wed, 22 Feb 2023 09:34:24 -0800 (PST)
Received: by mail-lf1-x129.google.com with SMTP id i9so10880907lfc.6
        for <linux-crypto@vger.kernel.org>; Wed, 22 Feb 2023 09:34:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=dN59YH7HktjgMj5OjrTUOtlbYhIW/Rx8QjDE6EyJw6k=;
        b=A62osjPfpGpdg0t63Vx3paXGtgYpu0xHbhgXtxWw9PUFmspKHqgU1zXxUiY6n/ljRM
         56F3WU0UxqpRAaggnfFobSyQtl95t9uxsNV0DWAZG3HPDxVRE5feN7k4vUbFFDZO0u8A
         yVHCfff8tbqelbL6b7aPQnYs0QSjpEffYc4fVMINaz+TfKtHkAJ+Vr03utr04azgA8x/
         rQH4HdMnQPM+oumHdIcCVdooW6sL3tPGkJmACH0WbFK78mJ3mguL8iZeoWTz+oBVlhG0
         yHrYRfESJOr+WXC7WAsOvRoTQmdLl9ttEIK+9FvuCbwnvmkEminwQ1593YMvFOhpTN7p
         QNYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=dN59YH7HktjgMj5OjrTUOtlbYhIW/Rx8QjDE6EyJw6k=;
        b=NO7U8pjztuaLlq2f5rwVPK5L45K1XfSb85HCwiPtLh6DzdnlZHulEjFFvSi5XdnU2H
         upyOcGXJ/DZL6+IJJF3VmYEI0kniqWDZtBij5N9AfPENjz5rw9oKUV+i+Dn5fCOSS7Ag
         LoL1+NlMbAY6EAoZ+82YGAc0ChOHaZRWrsD3gThuMuTa5glfSwEPJPFRXyNeaqEqJI07
         BJcrodNzQbGcHkZFufBR8j5ZgbjNstgMflREzzdcUJjyeO/nbmQTdBE83k6TwcowlXVK
         AoC8QPmpfo4UmsfHo0u2s9p4aeiMzMITwtdRUR18IwELJU9V4i66CgVbKr1Y5Pj6aaWc
         qb6w==
X-Gm-Message-State: AO0yUKUOiFXcSnQqPKopdMuo84NAYcjOPjTXov5Vdem9h9Ge7ngl/QQr
        AYz7utomPEn6f93/YU/x3xlujg==
X-Google-Smtp-Source: AK7set+STaQ15AJMYhkHPL7UhEGo+p3D9Rno4QNj6KEvcO/5dJ9mhbNlj8YfNmhwIr0Iu3uu2G1d4Q==
X-Received: by 2002:a19:ee0b:0:b0:4db:2cdf:4c12 with SMTP id g11-20020a19ee0b000000b004db2cdf4c12mr3450237lfb.43.1677087262601;
        Wed, 22 Feb 2023 09:34:22 -0800 (PST)
Received: from [192.168.1.101] (abxi151.neoplus.adsl.tpnet.pl. [83.9.2.151])
        by smtp.gmail.com with ESMTPSA id l18-20020a19c212000000b004a91df49508sm695013lfc.177.2023.02.22.09.34.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 22 Feb 2023 09:34:22 -0800 (PST)
Message-ID: <ebffa713-fa55-63e6-7f45-3b4739d38184@linaro.org>
Date:   Wed, 22 Feb 2023 18:34:20 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH v11 10/10] crypto: qce: core: Add a QCE IP family
 compatible 'qcom,qce'
Content-Language: en-US
To:     Vladimir Zapolskiy <vladimir.zapolskiy@linaro.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Thara Gopinath <thara.gopinath@gmail.com>,
        Bhupesh Sharma <bhupesh.sharma@linaro.org>
Cc:     Rob Herring <robh+dt@kernel.org>, Andy Gross <agross@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        devicetree@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-crypto@vger.kernel.org
References: <20230222172240.3235972-1-vladimir.zapolskiy@linaro.org>
 <20230222172240.3235972-11-vladimir.zapolskiy@linaro.org>
From:   Konrad Dybcio <konrad.dybcio@linaro.org>
In-Reply-To: <20230222172240.3235972-11-vladimir.zapolskiy@linaro.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org



On 22.02.2023 18:22, Vladimir Zapolskiy wrote:
> The added 'qcom,qce' compatible value will serve as a sole QCE IP family
> compatible, since a particular QCE IP version is discoverablem thus, if
> it'd be needed to differentiate various IP versions, it can be obtained
> in runtime.
> 
> Two IP version based compatibles are left untouched to preserve backward
> DTB ABI compatibility.
> 
> Signed-off-by: Vladimir Zapolskiy <vladimir.zapolskiy@linaro.org>
> ---
Reviewed-by: Konrad Dybcio <konrad.dybcio@linaro.org>

Konrad
>  drivers/crypto/qce/core.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/crypto/qce/core.c b/drivers/crypto/qce/core.c
> index 5bb2128c95ca..fce49c0dee3e 100644
> --- a/drivers/crypto/qce/core.c
> +++ b/drivers/crypto/qce/core.c
> @@ -293,6 +293,7 @@ static int qce_crypto_remove(struct platform_device *pdev)
>  static const struct of_device_id qce_crypto_of_match[] = {
>  	{ .compatible = "qcom,crypto-v5.1", },
>  	{ .compatible = "qcom,crypto-v5.4", },
> +	{ .compatible = "qcom,qce", },
>  	{}
>  };
>  MODULE_DEVICE_TABLE(of, qce_crypto_of_match);
