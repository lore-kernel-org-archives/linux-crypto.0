Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2DF20C61DA4
	for <linux-crypto@archiver.kernel.org>; Thu,  9 Feb 2023 09:26:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230016AbjBIJ00 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 9 Feb 2023 04:26:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229819AbjBIJ00 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 9 Feb 2023 04:26:26 -0500
Received: from mail-wm1-x32a.google.com (mail-wm1-x32a.google.com [IPv6:2a00:1450:4864:20::32a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2AB8DFF09
        for <linux-crypto@vger.kernel.org>; Thu,  9 Feb 2023 01:26:24 -0800 (PST)
Received: by mail-wm1-x32a.google.com with SMTP id bg5-20020a05600c3c8500b003e00c739ce4so992589wmb.5
        for <linux-crypto@vger.kernel.org>; Thu, 09 Feb 2023 01:26:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=HdNCaQA/ISgeLU5P3fZ4D7O83T+ao8B3Lddz0QCvUKg=;
        b=dSjZgdi7QEnveCnZRK7wW3MF7Yivb43goIbFe2YhF9tExKUmw5Xr/YEe2+C7H8rJq1
         LIe3hZJSrWhxh8djiBk69uJz08uNxQlKjPbo63HZmGK8e4Qfe0FJ1WvcsjVvPuTi8lLi
         mHWUcpR/pw/nSh5fGXNx7r3zgN/R/Z+ArIL0b08049Jx0lDFFh7fzEIV5yqKBG3pcpr1
         ce5KhD0gsLwW1+NjFrjM7DEZDvO1NcBCtyzLSh9KVMLeN8PmJ3lbbJbinxKDfdcK84SU
         Yet8YNyCYE2mCRFCb7hZEKPc/AojaDOtXK7j1WLfT+oe58FbXF5CoX7kzTeNh+WcgFb8
         AGNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=HdNCaQA/ISgeLU5P3fZ4D7O83T+ao8B3Lddz0QCvUKg=;
        b=QQz7vZj2zLPf00hsZFN3DYvLsK4EToaeEvCJ9XU7abv2+C9Bwv2TnSpFVlW9HJ2kb7
         OjhQbwz7tsfzbWd50NxWgwDKnYS1zIX6PID8bPD2RvvLMROYSALYoX+EkYsLjJY5pe7N
         o3wbB9caS2Bk/9lrV+U26o+m12ZdFSauj8fMqNy8OlRkTxjdQZIM6xd0YlA/xnW3BZLh
         Cs/u9nzr7sU3apcdXudtpwhRkkd/NgKxZS5Qlx1Tma1ZLi3CPyRKt1FOTqlO1hGpTVZa
         qJkXdNj+dgI0uyHCjtCEpCA9kODCA6BES8WEnBSIaBMc2vMQgtoeRYcHXBiRXSAXfIuY
         OXeQ==
X-Gm-Message-State: AO0yUKXJAgw0Q7+ojAO7LGxRx51/KUgAgU8m6awKKLbSjysqppFVNMRO
        dgW4hUUHguaQJ1YfylNnJ3e9/g==
X-Google-Smtp-Source: AK7set9215hWm4e1DkjEGdEPr1xhYcHwud0zS7JOIfssFkz9PA+uWdAidKNp2x5dBGXkXC4xZMjgdA==
X-Received: by 2002:a05:600c:358b:b0:3df:9858:c02e with SMTP id p11-20020a05600c358b00b003df9858c02emr5320055wmq.3.1675934782803;
        Thu, 09 Feb 2023 01:26:22 -0800 (PST)
Received: from [192.168.1.109] ([178.197.216.144])
        by smtp.gmail.com with ESMTPSA id f21-20020a05600c43d500b003dc522dd25esm1234234wmn.30.2023.02.09.01.26.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 09 Feb 2023 01:26:22 -0800 (PST)
Message-ID: <f747cfaf-ef50-743e-216b-6f950f9f23ff@linaro.org>
Date:   Thu, 9 Feb 2023 10:26:20 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [PATCH v9 14/14] crypto: qce: core: Add a compatible based on a
 SoC name
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
 <20230208183755.2907771-15-vladimir.zapolskiy@linaro.org>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <20230208183755.2907771-15-vladimir.zapolskiy@linaro.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 08/02/2023 19:37, Vladimir Zapolskiy wrote:
> The added 'qcom,ipq4019-qce' and 'qcom,sm8150-qce' compatible values will
> serve as QCE IP family compatibles, so that the crypto engine on added
> platforms can derive from one of these two. Also the compatibles serve as
> a fall-back for currently supported QCE IP variants on Qualcomm platforms.
> 
> At the moment there is no need to differentiate or add any other SoC
> specific compatible values to the list, however it's known in advance
> that the two QCE IP families are not fully compatible between each other.
> 
> The IP version based compatibles are left untouched to preserve backward
> DTB ABI compatibility.


Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>

Best regards,
Krzysztof

