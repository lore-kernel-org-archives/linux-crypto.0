Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6F0C7C61DA4
	for <linux-crypto@archiver.kernel.org>; Thu,  9 Feb 2023 09:19:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230054AbjBIJTT (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 9 Feb 2023 04:19:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53696 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230138AbjBIJTK (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 9 Feb 2023 04:19:10 -0500
Received: from mail-wm1-x32c.google.com (mail-wm1-x32c.google.com [IPv6:2a00:1450:4864:20::32c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B1AF61848
        for <linux-crypto@vger.kernel.org>; Thu,  9 Feb 2023 01:18:54 -0800 (PST)
Received: by mail-wm1-x32c.google.com with SMTP id hn2-20020a05600ca38200b003dc5cb96d46so3371921wmb.4
        for <linux-crypto@vger.kernel.org>; Thu, 09 Feb 2023 01:18:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=8xKTTF13TuTGcMYnAy1hWjGraIh0S3K+pSaF1w8Q3zo=;
        b=xs7Q4mmPj8u33vupAygAL8RuVKlC6EKKdmfyF+kkgWOujcytRxJIOx5Y4SAs6FaS5V
         HIyn9tFlA4cBihMXK9hzx8q170ZLTncfXKdo8vXjbkG810AG8fKWLPRcvB+qYbxdTgqh
         cHRWM1oxcgBAgZM28jKebD8VWvN2+XUr7zdIsJwxgcl6bDgBjVnaSL7rUj+1VYoY8+Ay
         S/hpfjMt6n76SB049n5M9Nj6YBu60al6ieUMhf0S6hmHo5itpzM7JKoAzlKhSEdeeVGo
         PK+1HuzxjXtVWr552yVPcfMJf9I24fwUHd3ihi+OnQgCLkdA/idhQdy9+1o/lRo3u80n
         Rekg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=8xKTTF13TuTGcMYnAy1hWjGraIh0S3K+pSaF1w8Q3zo=;
        b=7LN3CkDH0yOSTaSN/vEEevyfRNeVp/DmqQty3QDmidXj9Yukwsmz3Td3F6O0RW55By
         auKvAQZSFrxrsBwGOaAtUyAmnFp0+GNddZM+JVwljZ/3M/JeL2gVSZIngxqLezIQEZBc
         c73BopDbcqrkBPE38qe9kKoWRqKmu7D5W27izpG7B5GnWWQLY/LfWzFZuzHGM3wQI1jU
         m72N75Zz258jnke8JCon2rWZ9WsNyAjjyUoO09u1qYSppNcYlA55nCpzBYLd8lNvF/3n
         eGnug8/WAav2atskyDGa/BHJWctZBAbYlsMTgKkYakZE+CNm3+F4IwLLmfs/oEZ1lebk
         GjAQ==
X-Gm-Message-State: AO0yUKWvSkSrvlti3waeXjBhniBDJ9fmMc2uVibd8OHFooP4ySaJrUiY
        FWayEtEQwhR8V1rSYJmV6M+Hil1XJhPRwunY
X-Google-Smtp-Source: AK7set9XI6TCiVDXHBQ00wIrpN5n0MrSPkmDWY0y02F6jIukBOaxh8N9JZIw08zehf0kd3ep1rJmAQ==
X-Received: by 2002:a05:600c:16c8:b0:3da:2ba4:b97 with SMTP id l8-20020a05600c16c800b003da2ba40b97mr3753928wmn.19.1675934332766;
        Thu, 09 Feb 2023 01:18:52 -0800 (PST)
Received: from [192.168.1.109] ([178.197.216.144])
        by smtp.gmail.com with ESMTPSA id g12-20020a5d540c000000b002bff1de8d4bsm757371wrv.49.2023.02.09.01.18.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 09 Feb 2023 01:18:52 -0800 (PST)
Message-ID: <bc088534-ac1d-0504-9961-d3cd3740e2f3@linaro.org>
Date:   Thu, 9 Feb 2023 10:18:50 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [PATCH v9 05/14] dt-bindings: qcom-qce: Add new SoC compatible
 strings for qcom-qce
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
 <20230208183755.2907771-6-vladimir.zapolskiy@linaro.org>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <20230208183755.2907771-6-vladimir.zapolskiy@linaro.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 08/02/2023 19:37, Vladimir Zapolskiy wrote:
> Change QCE IP version specific compatible to two QCE IP family compatibles
> based on SoC name and populate these two IP families with particular SoC
> specific IP compatible names, which are known at the moment.
> 
> Keep the old compatible 'qcom,crypto-v5.1' for backward compatibility
> of DTB ABI, but mark it as deprecated.
> 
> The change is based on the original one written by Bhupesh Sharma.
> 
> Cc: Bhupesh Sharma <bhupesh.sharma@linaro.org>
> Signed-off-by: Vladimir Zapolskiy <vladimir.zapolskiy@linaro.org>
> ---
>  .../devicetree/bindings/crypto/qcom-qce.yaml  | 24 +++++++++++++++++--
>  1 file changed, 22 insertions(+), 2 deletions(-)
> 
> diff --git a/Documentation/devicetree/bindings/crypto/qcom-qce.yaml b/Documentation/devicetree/bindings/crypto/qcom-qce.yaml
> index 4e00e7925fed..f6f1759a2f6e 100644
> --- a/Documentation/devicetree/bindings/crypto/qcom-qce.yaml
> +++ b/Documentation/devicetree/bindings/crypto/qcom-qce.yaml
> @@ -15,7 +15,27 @@ description:
>  
>  properties:
>    compatible:
> -    const: qcom,crypto-v5.1
> +    oneOf:
> +      - const: qcom,crypto-v5.1
> +        deprecated: true
> +        description: Kept only for ABI backward compatibility
> +      - const: qcom,crypto-v5.4

You should mention in commit msg that you document existing compatible
v5.4. Otherwise it looks unrelated/unexplained. Especially adding
deprecated compatible is unexpected.

> +        deprecated: true
> +        description: Kept only for ABI backward compatibility


Best regards,
Krzysztof

