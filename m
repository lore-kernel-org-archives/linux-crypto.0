Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 979B8C4321E
	for <linux-crypto@archiver.kernel.org>; Wed, 16 Nov 2022 12:02:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230411AbiKPMCZ (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 16 Nov 2022 07:02:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48212 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229907AbiKPMBs (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 16 Nov 2022 07:01:48 -0500
Received: from mail-lj1-x22d.google.com (mail-lj1-x22d.google.com [IPv6:2a00:1450:4864:20::22d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3BAC4532CB
        for <linux-crypto@vger.kernel.org>; Wed, 16 Nov 2022 03:54:14 -0800 (PST)
Received: by mail-lj1-x22d.google.com with SMTP id l8so21477025ljh.13
        for <linux-crypto@vger.kernel.org>; Wed, 16 Nov 2022 03:54:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=5qu18t2owTI6Gu3mppKuZjgeHfzPOjrYfqxjnbu+3xk=;
        b=PYMjBAbZ8CPsc0wU1Uq05ykCBH0Ougzr9SJcOr+RsoLvk2Pvb+n1ZNCvFj6VzAIvnQ
         Nf20RbMCWvTdxFjA8k2G3bpen4lzsq/+KX+/zjhYSdbnlasgbcJaMB5BPozRG/teCo92
         Y3O8Lv3I6GicmoAIA0KkEISvtzYHMKsXNxgO/Gr5w1qrUBi11Mkvo+Ewpmnwe372wV/P
         RySCHNqJp0Ab5V3msnvJbokSBEEwXdmlgBShLRM5jB/mlfX0MOz/TGLNC9opsh3VM5vx
         HowdG2KmGdxST+7YRwv+LGLFawWN6Fl+jNcHLo+H3n9jxX4X2R9W4ho62sPP8dymUS5k
         kMcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=5qu18t2owTI6Gu3mppKuZjgeHfzPOjrYfqxjnbu+3xk=;
        b=6OsOD5ROwVkvMkZrbIN8c3skwehhcWRqPgihN8f1LOqu6aJ2JD0zV1rNLJPxZAX/jO
         WmM+ch8TlcW5StLFF2n26j9sVhsgJ7dfx0auFawAkZUUZAk2wZpUg0wUOc4YPqMU9jxR
         kADHKNlawJ42on0OZROILe3Ql/nys7dy/YJ013mckEFx54SnjG0SiXWT53vI3l1iXHrk
         zFRukR9pi9HFQV51oqf4TmOqZWh5lmzX1HwtgPJUcDA7ltAZon28tfU9VF0xjrb0Ixgt
         xGLbZJ4SHYX7KKRFsd7ksF/Wvbvcwu3HKtUh+W1aWY6AMGgf4VaiJrbfmnl4xwbEPjfA
         xECQ==
X-Gm-Message-State: ANoB5pmDUM23SLj2XbaMZg1kFFJTIuNUX1XqY84uWDjYCi/y1DZa9rKO
        v1HsSS7R/5BoxSkxU6JyMvr2Qg==
X-Google-Smtp-Source: AA0mqf4Q0LoJ/MHQVTvoVlRTtGmUX1DOh+IlCKJyN9EqlcWKtpou/6fhq8P1gKb7J5VQVa0gzSCK7Q==
X-Received: by 2002:a2e:9788:0:b0:277:dba:2f65 with SMTP id y8-20020a2e9788000000b002770dba2f65mr7785483lji.201.1668599652592;
        Wed, 16 Nov 2022 03:54:12 -0800 (PST)
Received: from [192.168.0.20] (088156142067.dynamic-2-waw-k-3-2-0.vectranet.pl. [88.156.142.67])
        by smtp.gmail.com with ESMTPSA id d16-20020ac24c90000000b004949a8df775sm2569508lfl.33.2022.11.16.03.54.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 16 Nov 2022 03:54:12 -0800 (PST)
Message-ID: <51f5ee2c-bf25-71ab-594d-2da18a44d3b6@linaro.org>
Date:   Wed, 16 Nov 2022 12:54:10 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH 3/4] dt-bindings: qcom-qce: document sm8550 compatible
Content-Language: en-US
To:     Neil Armstrong <neil.armstrong@linaro.org>,
        Vinod Koul <vkoul@kernel.org>, Andy Gross <agross@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Bjorn Andersson <andersson@kernel.org>,
        Thara Gopinath <thara.gopinath@gmail.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Bhupesh Sharma <bhupesh.sharma@linaro.org>,
        Konrad Dybcio <konrad.dybcio@somainline.org>
Cc:     linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, dmaengine@vger.kernel.org,
        Abel Vesa <abel.vesa@linaro.org>, linux-arm-msm@vger.kernel.org
References: <20221114-narmstrong-sm8550-upstream-qce-v1-0-31b489d5690a@linaro.org>
 <20221114-narmstrong-sm8550-upstream-qce-v1-3-31b489d5690a@linaro.org>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <20221114-narmstrong-sm8550-upstream-qce-v1-3-31b489d5690a@linaro.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 16/11/2022 11:23, Neil Armstrong wrote:
> This documents the compatible used for QCE on SM8550.
> 

So we have a dedicated compatible... This should be squashed with
previous one, added allOf:if:then making clocks optional only for this
platform (assuming that my understanding of "enable=exclusive control"
is correct).

Best regards,
Krzysztof

