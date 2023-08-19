Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 81D49EE49A9
	for <linux-crypto@archiver.kernel.org>; Sat, 19 Aug 2023 07:46:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344366AbjHSHpd (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 19 Aug 2023 03:45:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43056 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344408AbjHSHpO (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 19 Aug 2023 03:45:14 -0400
Received: from mail-ej1-x630.google.com (mail-ej1-x630.google.com [IPv6:2a00:1450:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 205643ABA
        for <linux-crypto@vger.kernel.org>; Sat, 19 Aug 2023 00:45:13 -0700 (PDT)
Received: by mail-ej1-x630.google.com with SMTP id a640c23a62f3a-99bf1f632b8so216052066b.1
        for <linux-crypto@vger.kernel.org>; Sat, 19 Aug 2023 00:45:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1692431111; x=1693035911;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=QYxJHRkfz5+E7C/DgQtipVS7sPzq8usuIEMiG66wgWA=;
        b=Z76wT0UlYmYwypK8d0yXNx14meVAJawQSYz0sz3zjQB77X2ELCAotD1bGWZ/gu71xY
         FfEnulmEL9kNtN3lRB+JDAM3JLuc1ZQihAgFvLhe+MsafkjUQWkZD0+tGVRtFLV7/DG/
         TDOdfLOb930E6EWwuSyiwc8CIzatjkybKfh0HCBMKbPgWbuau2arlKFk3ACtShubUwwz
         4rugrL3N/BQM3H9aPIw0QEvbPWtBnWWLcaHS+q0w6osdIP2W1JSWOPnHT9fuomat536w
         AT+fDm4DiVUuG+A2/ynIAsDh0acQjBCUkLarC8KCT6AuUzXXyPpSWgQIgp54qVFx+T7X
         kAZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692431111; x=1693035911;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=QYxJHRkfz5+E7C/DgQtipVS7sPzq8usuIEMiG66wgWA=;
        b=RApuQ0SBIE0bGORoati09OZMuHNZww+OwJnBnfDbxG085y8Lbf8e3sUc9QkwbT9N/j
         lQkbz2wE5NCkfDSbBensdQAhZ+8KP45P7pM3zfopz7+uXq90eUo0+xk7TIdy9e0EPbeF
         RIAc1yfMVF5gQnj8hZLma54CUJJS55PiBzcWPaKW+e9zPGSX2O63CeDB0v8iQH4yLByK
         hwkeJLxU6kJPhdXVuuOsAtWzUBgxlGPuiq5AhWwnTPffPoCjIAn5uwasUeiKfqn6ei1E
         9XyBE/zTnixAVX352IkMoZ+0LMVwaTrz018d2IhnGSzZvs4YGvx9IlRD0Q4WfcyAawM9
         61hQ==
X-Gm-Message-State: AOJu0YyrP+okH4vVXAoShyeQIVlZ7g9J4lCBtboKtBmOj2WBnDHbojj6
        1q1w2WTuqcV02BUgfH8OvBj22Q==
X-Google-Smtp-Source: AGHT+IFA0oacvhzZRaqDxr5uNcec9rVnKY7L81x5sqkIXHlHXR5tkc9/fjtKUDaKebMkt+7tmCa1Ew==
X-Received: by 2002:a17:907:763b:b0:99b:66eb:2162 with SMTP id jy27-20020a170907763b00b0099b66eb2162mr1072866ejc.5.1692431111213;
        Sat, 19 Aug 2023 00:45:11 -0700 (PDT)
Received: from [192.168.0.22] ([77.252.47.198])
        by smtp.gmail.com with ESMTPSA id k17-20020a1709062a5100b0099bc2d1429csm2261089eje.72.2023.08.19.00.45.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 19 Aug 2023 00:45:10 -0700 (PDT)
Message-ID: <2c208796-5ad6-c362-dabc-1228b978ca1d@linaro.org>
Date:   Sat, 19 Aug 2023 09:45:09 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.14.0
Subject: Re: [PATCH 1/3] dt-bindings: crypto: qcom,prng: Add SM8450
Content-Language: en-US
To:     Om Prakash Singh <quic_omprsing@quicinc.com>,
        konrad.dybcio@linaro.org
Cc:     agross@kernel.org, andersson@kernel.org, conor+dt@kernel.org,
        davem@davemloft.net, devicetree@vger.kernel.org,
        herbert@gondor.apana.org.au, krzysztof.kozlowski+dt@linaro.org,
        linux-arm-msm@vger.kernel.org, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, marijn.suijten@somainline.org,
        robh+dt@kernel.org, vkoul@kernel.org
References: <20230811-topic-8450_prng-v1-1-01becceeb1ee@linaro.org>
 <20230818161720.3644424-1-quic_omprsing@quicinc.com>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <20230818161720.3644424-1-quic_omprsing@quicinc.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 18/08/2023 18:17, Om Prakash Singh wrote:
> Instead of having SoC name "qcom,sm8450-prng-ee" we could use "qcom,rng-ee" as
> new IP core is not longer pseudo random number generator. so "prng" can be
> changed to "rng". Clock configuration is not needed on sm8550 as well. So it is
> better to use generic compatible string.

I am not sure if I understand your point. You mean drop "p" in "prng" or
drop specific compatible? The first depends in the block - if it is
still pseudo. The second - why? That's contradictory to what is in the
guidelines and what we have been pushing for very long time. Going
against guidelines would require proper justification (and not some
usual justification "I don't need it", because we talked about this many
many times). One should not bring downstream poor practices to upstream,
but the other way. You should fix downstream code.

Best regards,
Krzysztof

