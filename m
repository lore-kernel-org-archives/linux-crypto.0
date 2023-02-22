Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E36ACC64EC7
	for <linux-crypto@archiver.kernel.org>; Wed, 22 Feb 2023 18:27:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232212AbjBVS1z (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 22 Feb 2023 13:27:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60968 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232303AbjBVS1s (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 22 Feb 2023 13:27:48 -0500
Received: from mail-lf1-x131.google.com (mail-lf1-x131.google.com [IPv6:2a00:1450:4864:20::131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 409203C796
        for <linux-crypto@vger.kernel.org>; Wed, 22 Feb 2023 10:27:46 -0800 (PST)
Received: by mail-lf1-x131.google.com with SMTP id g8so7518898lfj.2
        for <linux-crypto@vger.kernel.org>; Wed, 22 Feb 2023 10:27:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1677090464;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=yhC/1G7/U4NfbpQ099CYTdbkKgQWiiedngLMds7AUj4=;
        b=gg3rmKkXYFo4OccDD+m9aZehc77Awfn85YOU0zE/MKaNhpLx74aRaQRua9M1lbctiF
         KfZV/GSaCa2ZFH0DBuoHOgWGuxGL/kM+f8AkqT9rc8lBHQO5BG4/wKR7SfF7f8kV8+Mk
         jmWc59GyyLEA/PnX4Eaxbw+FYHpF/mkCh5nrVGJuBpGH9jcSzo8TatnNTJxedM3YzAtV
         vRxQXqEdkb37eJ3OeJ+6bPvFuZgzSb/sjaLl29FdEwl6/g9Qb2Ld+Hj1s1v4+YtVwJEo
         8sMc1w2V/1JpZX4zZPJtBJxmMj6IHpvtb/W9/fBmaiCKTYie64qa+Y8Yy95JP7/Wy+qR
         yyxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1677090464;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=yhC/1G7/U4NfbpQ099CYTdbkKgQWiiedngLMds7AUj4=;
        b=E2DdysL3zhMyr6yFVtiFB9chh6r9rnhQKiPBOwXcvl0Q0424ZD78PZvo/XEsoqwd3S
         CtClDHf2OCp0kLvdjay3gs/iBwia9SAuCNMs+rC6Y8u5jz/lpweQj2OKYYk315V27FJy
         hLvaNgVxkWFdGBxiOL6LTBIXbq8RLNMz5MrRdO1G8IlvZshPhWU9x9j8ymU/Xz2fX2Db
         Cjrq16kTWj6fGlBPuIE6UfAKmkz6OjE1k8Bx99SCxEjqMcnevvBhvFMMjxHu9devZwZS
         jIDXD+/avooc1+H9wgCUpjtR/mN3SvDAnAyBzkSZhvA5Q2hOJZHe3eSPyfgMR+MdmYwu
         0jig==
X-Gm-Message-State: AO0yUKVqkYcKz0V29eQJavFg43KkTkpTY+8buHCQsvYcp+JbRJWOFllj
        HujnVeKwwabQRUCSDH3KwjPhIw==
X-Google-Smtp-Source: AK7set8v+KInbVZqzQunon5Tq0Q6FaxLc4fVXlo31GQDC4NWbpBpKJh6gQPUSKGLWKKiRkdITPJGjw==
X-Received: by 2002:a19:f00e:0:b0:4a4:68b9:26c with SMTP id p14-20020a19f00e000000b004a468b9026cmr2817622lfc.6.1677090464484;
        Wed, 22 Feb 2023 10:27:44 -0800 (PST)
Received: from [192.168.1.102] (88-112-131-206.elisa-laajakaista.fi. [88.112.131.206])
        by smtp.gmail.com with ESMTPSA id m6-20020ac24ac6000000b004cafe65883dsm40789lfp.122.2023.02.22.10.27.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 22 Feb 2023 10:27:43 -0800 (PST)
Message-ID: <44f99635-69b0-4ab1-aa58-417824aae8d6@linaro.org>
Date:   Wed, 22 Feb 2023 20:27:36 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.0.2
Subject: Re: [PATCH v11 09/10] crypto: qce: core: Make clocks optional
Content-Language: en-US
To:     Konrad Dybcio <konrad.dybcio@linaro.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Thara Gopinath <thara.gopinath@gmail.com>,
        Bhupesh Sharma <bhupesh.sharma@linaro.org>
Cc:     Rob Herring <robh+dt@kernel.org>, Andy Gross <agross@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        devicetree@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-crypto@vger.kernel.org, Jordan Crouse <jorcrous@amazon.com>
References: <20230222172240.3235972-1-vladimir.zapolskiy@linaro.org>
 <20230222172240.3235972-10-vladimir.zapolskiy@linaro.org>
 <cdc87c95-a845-904b-1a57-0895b9f93d9f@linaro.org>
From:   Vladimir Zapolskiy <vladimir.zapolskiy@linaro.org>
In-Reply-To: <cdc87c95-a845-904b-1a57-0895b9f93d9f@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi Konrad,

On 2/22/23 19:33, Konrad Dybcio wrote:
> 
> 
> On 22.02.2023 18:22, Vladimir Zapolskiy wrote:
>> From: Thara Gopinath <thara.gopinath@gmail.com>
>>
>> On certain Snapdragon processors, the crypto engine clocks are enabled by
>> default by security firmware and the driver should not handle the clocks.
>> Make acquiring of all the clocks optional in crypto engine driver, so that
>> the driver initializes properly even if no clocks are specified in the dt.
>>
>> Tested-by: Jordan Crouse <jorcrous@amazon.com>
>> Signed-off-by: Thara Gopinath <thara.gopinath@gmail.com>
>> Signed-off-by: Bhupesh Sharma <bhupesh.sharma@linaro.org>
>> [Bhupesh: Massage the commit log]
>> Signed-off-by: Vladimir Zapolskiy <vladimir.zapolskiy@linaro.org>
>> ---
> I'm not sure which is the preferred approach, but generally I'd
> stick with keeping them non-optional for the SoCs that need them..
> So perhaps introducing a flag in of_match_data for qcom,sm8150-qce
> (which was created solely to take care of the no-HLOS-clocks cases)
> and then skipping the clock operations based on that would be a
> good idea.

thank you for review. As you can get it from 06/10 the task to distinguish
IPs with clocks and without clocks is offloaded to dtb. I believe a better
support of two cases should be added to the driver on the basis of QCE IP
versions obtained in runtime, or, alternatively and like you propose, it
can be taken from a compatible. IMHO the latter one is a weak improvement,
since it can be considered as a workaround in the driver to a known to be
broken device tree node.

--
Best wishes,
Vladimir
