Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F239BC636D6
	for <linux-crypto@archiver.kernel.org>; Fri, 17 Feb 2023 08:58:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229976AbjBQI57 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 17 Feb 2023 03:57:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33290 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229966AbjBQI56 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 17 Feb 2023 03:57:58 -0500
Received: from mail-ed1-x52b.google.com (mail-ed1-x52b.google.com [IPv6:2a00:1450:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 601CABBBD
        for <linux-crypto@vger.kernel.org>; Fri, 17 Feb 2023 00:57:54 -0800 (PST)
Received: by mail-ed1-x52b.google.com with SMTP id cn2so1675396edb.4
        for <linux-crypto@vger.kernel.org>; Fri, 17 Feb 2023 00:57:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=JxmTPfEZSHv/qWrcZKvsN9uAVFNGcnCsPAcIEn+aGbM=;
        b=S3hhqXofYhKYklwyVx1ZiaQVV6VUVxQl+CNp6N2KHoO/UUbSNw+3Td5LP2oYASqzUE
         M7OAtXBpVInxsSayj23toB0vGa3eNd1R/CQzLMYehtOMXDEuBo+jRRWtYPdl3O3ymj68
         wYm5hr3vcVph1ZKGwrTvEzyWyqWU+0sH66QfQFNQ5nNNs3PNdXWT6Mnsh0c/A065HGBh
         HRXIN+ARWXjVn2pAjZRKGW7pfCQNiJlAeyPy7XkwY8NKMPUL2xL+YDZWiQEw9m4eW24e
         Bp2IAnTkMM6ZShPMQdvPc31wCddIrMcKmJiEhEQDYvqTObdVIhFFUpBQ5bxu+X2sU97g
         bIkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=JxmTPfEZSHv/qWrcZKvsN9uAVFNGcnCsPAcIEn+aGbM=;
        b=4Ai4C10+ejSBmH+H3JL7VpPGiTpc3x/aGPzV1/b/ZT57ulOAkze5sUBlZ08C8NKaDD
         uJDMNWCIUVXJO8O7d9xpdUe5HN0fPPXDtBsQIBGRjiXtRVM9rj9bk80ACvitPoDWBlbM
         zzezAMwryVyjZafJjVmbVdp/M/j22DdyMxDGxqmv2ZZxlDlq52NejPaIrwZDwtNAINTt
         URbC2BGR9UnLNzfCUGDI9Ch1bbUnSAOnOOClhrFIvxcFM+TGpyphZOYDhyGw5GOeMX9a
         Eo9oVYW799gdyZDq8U0FSChdDFzSx5A7p1yI883MXzo4kDsV0kt357BsoPzbDT2UE1Sz
         t1eQ==
X-Gm-Message-State: AO0yUKWf/kz0ta49CGTNnsuI3xdC/Q2tfsABT+HPD8pgwBJ1TvA7jmE8
        rUSl8UKnjywbuPULOLjlwrLwVg==
X-Google-Smtp-Source: AK7set9s6X9YCl0+Jv/Abcpk9KSI2ZLrpWThyt+bZQlD5CjypRTHefOM/EEsy2zJt587ycEEWaGNUQ==
X-Received: by 2002:a17:906:944b:b0:8b1:3ba8:3f4d with SMTP id z11-20020a170906944b00b008b13ba83f4dmr8436182ejx.70.1676624272837;
        Fri, 17 Feb 2023 00:57:52 -0800 (PST)
Received: from [192.168.1.109] ([178.197.216.144])
        by smtp.gmail.com with ESMTPSA id jz19-20020a17090775f300b008b17cc28d3dsm993330ejc.20.2023.02.17.00.57.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 17 Feb 2023 00:57:52 -0800 (PST)
Message-ID: <6217b51c-4982-8548-688d-8bfce97d3352@linaro.org>
Date:   Fri, 17 Feb 2023 09:57:50 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [PATCH v10 05/10] dt-bindings: qcom-qce: Add new SoC compatible
 strings for Qualcomm QCE IP
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
 <20230216131430.3107308-6-vladimir.zapolskiy@linaro.org>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <20230216131430.3107308-6-vladimir.zapolskiy@linaro.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 16/02/2023 14:14, Vladimir Zapolskiy wrote:
> Introduce a generic IP family compatible 'qcom,qce' and its two derivatives
> based on SoC names rather than on IP versions. Having a generic compatible
> is only partially sufficient, the QCE IP version can be discovered in
> runtime, however there are two known groups of QCE IP versions, which
> require different DT properties, these two groups are populated with SoC
> based compatibles known at the moment.
> 
> Keep the old compatibles 'qcom,crypto-v5.1' and 'qcom,crypto-v5.4' for
> backward compatibility of DTB ABI, but mark them as deprecated.
> 

As I asked at v9, please mention that you document already used v5.4
compatible. You do not "keep it", because it was never there in the binding.

Best regards,
Krzysztof

