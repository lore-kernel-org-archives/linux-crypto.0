Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 09590C05027
	for <linux-crypto@archiver.kernel.org>; Thu,  2 Feb 2023 14:23:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230259AbjBBOXM (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 2 Feb 2023 09:23:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39292 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232428AbjBBOXK (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 2 Feb 2023 09:23:10 -0500
Received: from mail-wm1-x333.google.com (mail-wm1-x333.google.com [IPv6:2a00:1450:4864:20::333])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35A1A24CB0
        for <linux-crypto@vger.kernel.org>; Thu,  2 Feb 2023 06:23:05 -0800 (PST)
Received: by mail-wm1-x333.google.com with SMTP id l21-20020a05600c1d1500b003dfe462b7e4so132471wms.0
        for <linux-crypto@vger.kernel.org>; Thu, 02 Feb 2023 06:23:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=YB4h/C/CtbFY4rXmucKBqG0MqbmHC4KWkwhlRlIb+2I=;
        b=bzo3nwG7ZmwfN9KX3sxXEcPruFfXZNJTO5B2WFHTKCYsxSVEzj+Y6q35NuOHb84umr
         cq5wnf0sUjSTAleMT8Fum8Iac+2tBlg/2F486oM7FdVjQ66EpIRpraiRWfW0MhFXeU4W
         nF3gmIXQl9wLgpOnwKz5/7Z+4G4Lj/RZza1yZC7x/l6Li/ar9PVMLZ5aBuoN7t2GLphI
         wB5hNk5q1rqAKAL5bgKJJInH72Rjrm2dg5u0oKufxSGEtvcQ52jknKvSGfdrGNAreO1p
         zsRd9kBWMQTolj1TajyH0FlTmRxpGIyfVUD+2DgXd+c8V16+T1Ss69clGoqAHFXwxLho
         kCRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=YB4h/C/CtbFY4rXmucKBqG0MqbmHC4KWkwhlRlIb+2I=;
        b=JiiG7yIUpWpa25+WKQr/xqEe7tJugDCaArqDl+hp/zOQKQxrPVWqJLJiajGMFd+PPp
         MPUaNlD4CxrhTw/IBcErpVtvC9IwKV/8R4Ol1GJRrPsxBXsiiZMRGSfoVNSgKyFuFPk+
         9bIzfzXTyDooGV5khb5+b1fMIeHlCL2wA+rSluNIefF7bf2nHBQLGPwrE32NiKO5Pxv4
         8XjykYX3HH4t0uWtqiw9uFFDiE+J8HKuP4jiCg3QJtreR+lq9ufX97eXFbxvPwJ012Y3
         Ep4E319qXFjTNmXRPhosMirNlo8W+aNKXSYbJ1cmc+DbsKBX3FiVnoTCy6lUI2zbEzIL
         6GoQ==
X-Gm-Message-State: AO0yUKUeq95mZNEeZMiPgDxDoQKPMjFJPoPnghHqcOMfwvuu/HF/ZOJE
        1cYM04uxgiQMsKeuTN0cPp9LwQ==
X-Google-Smtp-Source: AK7set/HE5p2w/dzpHWaV2sxuNs7PJNgTft5opkJSpseRkiLmxy5Popw8z4rysmsYdiYCtz3baLOrQ==
X-Received: by 2002:a05:600c:5491:b0:3dc:16d3:8c95 with SMTP id iv17-20020a05600c549100b003dc16d38c95mr6366493wmb.30.1675347783631;
        Thu, 02 Feb 2023 06:23:03 -0800 (PST)
Received: from [192.168.1.109] ([178.197.216.144])
        by smtp.gmail.com with ESMTPSA id u6-20020a5d4346000000b002bc84c55758sm21647028wrr.63.2023.02.02.06.23.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 02 Feb 2023 06:23:03 -0800 (PST)
Message-ID: <cc0cc6a0-2403-82e5-fff0-630dcce99b89@linaro.org>
Date:   Thu, 2 Feb 2023 15:23:01 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [PATCH v8 5/9] dt-bindings: qcom-qce: document clocks and
 clock-names as optional
Content-Language: en-US
To:     neil.armstrong@linaro.org,
        Vladimir Zapolskiy <vladimir.zapolskiy@linaro.org>,
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
References: <20230202135036.2635376-1-vladimir.zapolskiy@linaro.org>
 <20230202135036.2635376-6-vladimir.zapolskiy@linaro.org>
 <32c23da1-45f0-82a4-362d-ae5c06660e20@linaro.org>
 <36b6f8f2-c438-f5e6-b48f-326e8b709de8@linaro.org>
 <a2e4dff0-af8f-dccb-9074-8244b054c448@linaro.org>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <a2e4dff0-af8f-dccb-9074-8244b054c448@linaro.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 02/02/2023 15:21, Neil Armstrong wrote:
> On 02/02/2023 15:04, Vladimir Zapolskiy wrote:
>> Hi Krzysztof,
>>
>> On 2/2/23 15:53, Krzysztof Kozlowski wrote:
>>> On 02/02/2023 14:50, Vladimir Zapolskiy wrote:
>>>> From: Neil Armstrong <neil.armstrong@linaro.org>
>>>>
>>>> On certain Snapdragon processors, the crypto engine clocks are enabled by
>>>> default by security firmware.
>>>
>>> Then probably we should not require them only on these variants.
>>
>> I don't have the exact list of the affected SoCs, I believe Neil can provide
>> such a list, if you find it crucial.
> 
> It's the case for SM8350, SM8450 & SM8550.

So let's keep them required for explicit list of compatibles (older
devices).

Best regards,
Krzysztof

