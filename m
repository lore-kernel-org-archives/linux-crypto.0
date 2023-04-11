Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E1120C77B6F
	for <linux-crypto@archiver.kernel.org>; Tue, 11 Apr 2023 05:49:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230101AbjDKFtB (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 11 Apr 2023 01:49:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57468 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230108AbjDKFsp (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 11 Apr 2023 01:48:45 -0400
Received: from mail-ej1-x633.google.com (mail-ej1-x633.google.com [IPv6:2a00:1450:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 535BD10CA
        for <linux-crypto@vger.kernel.org>; Mon, 10 Apr 2023 22:48:09 -0700 (PDT)
Received: by mail-ej1-x633.google.com with SMTP id jg21so17115365ejc.2
        for <linux-crypto@vger.kernel.org>; Mon, 10 Apr 2023 22:48:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1681192086;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=oKyTkKx/Pdu1EWbCPSTT+2QzhVLCfP4CgxSI4AwVzug=;
        b=LaY6lJoVaISAEhrl0jkh8B0UQoGv/9VX+s3CiP0PdffntWZMjZYmBQkqgAM/2PwTsd
         v/1OY8+YRXjuKKYYH+Uz/QiTcCD5K+yk+BnfqCZgOl49refSXvAuws28pbKY1ooGCmwd
         kbx8w2cYLYELhH4ROznsrDRT6eBQkXE7MpFvSZHToBY64NKXZ4lkOiTkMsjqxawhp0ol
         JVQB/e/QA4NSBJvpO5V+RdtOPsHUsS2r+1u9vC/OGHNbmaCNFtLY38dAAlikRRTQKmzt
         sohrfkAxdvaniAQvfrODCQDhBGixyJgj99KHKzw56hvXf3Y9cRnyr+TDEBG8HhSl5Vuk
         gJJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1681192086;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=oKyTkKx/Pdu1EWbCPSTT+2QzhVLCfP4CgxSI4AwVzug=;
        b=zJVf2ZW0BucSrKJ/thWkfCjCkbAqvFJ5L5P6Z1r0Nm+EZTe9h1EWEYDqY8IAnJxubm
         CsB3hp7cbWCD9Pm1L+h4u/GGYbHN6A2ovOjIgea1HL8i0PCj9tZXm7xu3T5VcePSgaUF
         CFPuSM7HyM/ENXfImH+ovYrNUD7hfPpBC56HMWF5INOzMasJMYy8ZWUIyGuFx1pzShRB
         rQbKqFRxcgS6mc3QnrYf0vpGv54E5OVc+oH88BQRrDI6BBFeXlSeMs/e++T8P+v+Yb2X
         GJ76hVckaY2v6kdjug47BNEh9aVI+JqqBNzd4xOGSmnoAMjY/ZzXHfpA/HFNFFXDdcZL
         Bu+w==
X-Gm-Message-State: AAQBX9dUuHutRPlUmj+QYQH/c2HyzvzcBN0kuKps+myi21rFtJtpbkMq
        M34+S5PxJtdjxFk1pzl9pGnRMg==
X-Google-Smtp-Source: AKy350biNPfenXSztI0xSOcWHuEry7OjPgnxeO4EilfTtNC8jliNoZlIZ+yXGM5RXFz5sKPy1k1ovQ==
X-Received: by 2002:a17:907:c20a:b0:94a:9abf:c3b with SMTP id ti10-20020a170907c20a00b0094a9abf0c3bmr3897080ejc.75.1681192086066;
        Mon, 10 Apr 2023 22:48:06 -0700 (PDT)
Received: from ?IPV6:2a02:810d:15c0:828:dad2:72b7:3626:af61? ([2a02:810d:15c0:828:dad2:72b7:3626:af61])
        by smtp.gmail.com with ESMTPSA id mp36-20020a1709071b2400b0094a511b9e6csm2824691ejc.139.2023.04.10.22.48.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 10 Apr 2023 22:48:05 -0700 (PDT)
Message-ID: <eb9d5fe0-a8fb-e8ee-d13c-357ea408e2d1@linaro.org>
Date:   Tue, 11 Apr 2023 07:48:04 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.1
Subject: Re: [PATCH V2 4/6] dt-bindings: imxgpt: add imx6ul compatible
Content-Language: en-US
To:     Stefan Wahren <stefan.wahren@i2se.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Shawn Guo <shawnguo@kernel.org>,
        Sascha Hauer <s.hauer@pengutronix.de>
Cc:     kernel@pengutronix.de, Fabio Estevam <festevam@gmail.com>,
        linux-imx@nxp.com, "Rafael J . Wysocki" <rafael@kernel.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Amit Kucheria <amitk@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        linux-crypto@vger.kernel.org, devicetree@vger.kernel.org,
        linux-serial@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-pm@vger.kernel.org
References: <20230410205803.45853-1-stefan.wahren@i2se.com>
 <20230410205803.45853-5-stefan.wahren@i2se.com>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <20230410205803.45853-5-stefan.wahren@i2se.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 10/04/2023 22:58, Stefan Wahren wrote:
> Currently the dtbs_check for imx6ul generates warnings like this:
> 
> ['fsl,imx6ul-gpt', 'fsl,imx6sx-gpt'] is too long
> 
> According to the timer-imx-gpt driver all imx6 use the same imx6dl data,
> but according to the existing DTS files the imx6ul GPT IP is derived from
> imx6sx. So better follow the DTS files here and make the imx6ul GPT
> compatible to the imx6sl one to fix the warning.
> 
> Signed-off-by: Stefan Wahren <stefan.wahren@i2se.com>
> ---

Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>

Best regards,
Krzysztof

