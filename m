Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D401BC433F5
	for <linux-crypto@archiver.kernel.org>; Wed,  1 Jun 2022 07:45:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243001AbiFAHpz (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 1 Jun 2022 03:45:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47810 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350417AbiFAHpo (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 1 Jun 2022 03:45:44 -0400
Received: from mail-ej1-x62b.google.com (mail-ej1-x62b.google.com [IPv6:2a00:1450:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F1C59CF7C
        for <linux-crypto@vger.kernel.org>; Wed,  1 Jun 2022 00:45:39 -0700 (PDT)
Received: by mail-ej1-x62b.google.com with SMTP id f9so2068010ejc.0
        for <linux-crypto@vger.kernel.org>; Wed, 01 Jun 2022 00:45:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=icaxq30mttf79C4R9dYRsj76DdZgYPdfcBXzW0d+jXk=;
        b=qhdsg4Ya4YN7Vaxx4KRqhrWlzhNNHdf0PVdqfG2J6C64ZYh4eb930sm0pQWNlvi5fz
         e8MtDtNaaVfEvSo2ezzPWrRLXro7Sqa26fIPFSbaCr+rJ0K5llS8sj1WuXS0ZDeTRMW1
         Lla3hXfeN1OxJw12hVjMokIA+Gg3SyEJ/1OccTNwV4hxjUV6DOmLxRNU0yqHr1WBheJA
         DKAN/4VPGv+Rrlo/v4AXp1Snc9fqApNwGr7Sp7dRydFF6Uesn3rngsZOtwm7jmbM10Py
         IXF8drlRGeO2+SbhjYcSN+V7StztXVXY7g8jUAjlpSxc7L9HE7C7byGXkP65BsiWnwF1
         DWqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=icaxq30mttf79C4R9dYRsj76DdZgYPdfcBXzW0d+jXk=;
        b=DCr1Li0kcJbQZpkcEcXH4eoAmKTBiO4NSpIii/jj/YHvkvIx6233qgnuVTrNRO6ZlP
         3J+H/2PCGjwvbKN/00wcK5hI49Sx+TxhpRo7EhSAqPiKQdqS0wGdK+EEGwXnvqKYF808
         K8XcPK9b0h9lq0IQjsQRPaSQF5HzL7VAvJUp6J1+91REgQJwzv61DVxarkUjWrVWdeUK
         kM8IJ9novckoiB7zLc/n+kIVxce/D8pek9QfyG8ou/UyUxWX0McIjTxAJTE3b+SsEM6W
         tefFr0Dx2vI1TBziQsph/X/1Vx4c4R6U6K9pW7ILvky8clbERbSFRsrqp+vppsogKi2S
         NuLw==
X-Gm-Message-State: AOAM532S8BJR+wGhq82zPnRjn/jIOjCZzvrUWQy5JDPDQUgvd/3luv+h
        UOgy9kO1hDO+nf2K6ji1HTbWwF7hXNqP/Isc
X-Google-Smtp-Source: ABdhPJxtNxlX3e7jclB2CRDTCFsHDIgFhYwHQFha34skmH3sd1hturimO7g/4A+a4S/XrA/j28pXsQ==
X-Received: by 2002:a17:907:7f06:b0:6fe:b81f:f885 with SMTP id qf6-20020a1709077f0600b006feb81ff885mr48271947ejc.621.1654069537754;
        Wed, 01 Jun 2022 00:45:37 -0700 (PDT)
Received: from [192.168.0.179] (xdsl-188-155-176-92.adslplus.ch. [188.155.176.92])
        by smtp.gmail.com with ESMTPSA id e20-20020a056402149400b0042bd75c53casm517464edv.83.2022.06.01.00.45.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 01 Jun 2022 00:45:37 -0700 (PDT)
Message-ID: <c2f1621e-21d0-3836-6bb2-c1fb038856c5@linaro.org>
Date:   Wed, 1 Jun 2022 09:45:36 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.1
Subject: Re: [PATCH 2/5] dt-bindings: clock: Add AST2600 HACE reset definition
Content-Language: en-US
To:     Neal Liu <neal_liu@aspeedtech.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Joel Stanley <joel@jms.id.au>,
        Andrew Jeffery <andrew@aj.id.au>,
        Johnny Huang <johnny_huang@aspeedtech.com>
Cc:     linux-aspeed@lists.ozlabs.org, linux-crypto@vger.kernel.org,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
References: <20220601054204.1522976-1-neal_liu@aspeedtech.com>
 <20220601054204.1522976-3-neal_liu@aspeedtech.com>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <20220601054204.1522976-3-neal_liu@aspeedtech.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 01/06/2022 07:42, Neal Liu wrote:
> Add HACE reset bit definition for ast2600.
> 
> Signed-off-by: Neal Liu <neal_liu@aspeedtech.com>
> Signed-off-by: Johnny Huang <johnny_huang@aspeedtech.com>


Acked-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>



Best regards,
Krzysztof
