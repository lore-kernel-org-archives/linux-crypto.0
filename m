Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A5D45C43334
	for <linux-crypto@archiver.kernel.org>; Mon,  6 Jun 2022 07:23:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230188AbiFFHXM (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 6 Jun 2022 03:23:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44372 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230392AbiFFHXE (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 6 Jun 2022 03:23:04 -0400
Received: from mail-ej1-x634.google.com (mail-ej1-x634.google.com [IPv6:2a00:1450:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 682BEBB5
        for <linux-crypto@vger.kernel.org>; Mon,  6 Jun 2022 00:23:01 -0700 (PDT)
Received: by mail-ej1-x634.google.com with SMTP id q1so27177403ejz.9
        for <linux-crypto@vger.kernel.org>; Mon, 06 Jun 2022 00:23:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=vfnaQ4smw+KgX15hin83GBkysb52zahcEdPRKs8bkOg=;
        b=pC/Qa4Krj7RNRHVG7Xh2KYRWWPHMQtGRbRGIetXDGbSdVA21anYdrJYYwyALs2VMYX
         bwwypHFH2+KQRIlffVL6+2limzoOAauHSFQNHW/oGyEkz1ONR47IsM6fKybF7hEyErRV
         XHr+SYdu+p7pmxwXwDRLhQs4rS2xGiae5pEg+hJilghhdSN6xDCYTlyuBye2rfxvLr42
         1WeH3WSWNX1N+/jmI1Lo5lW15BC+EmfZww5q6/ZAnKXof2xhK6xxL0duLR99aZTrQw0Y
         Td8A6jkJDGB233rvfOV2oE9p63zaifR15tHMz7XxtHWQvzJFxVZgB7nAxkIM4DRPaW0C
         5tOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=vfnaQ4smw+KgX15hin83GBkysb52zahcEdPRKs8bkOg=;
        b=TFDtTPlUH/jbTedDOLEEIIafURqsn2fBI1jtwx76Szhv/AwDgaiZLVhfCcabFQLG8d
         gGgln898X0vNAbqHJcuHlUhhMYceYf6e+O+RY/7WwKMtui/QSqBbur27n3rEdZocjjAi
         oF94qBctJrXV0qOMm4jb06XGplb9m9OVmfUaJj6qplVDcCKQ3/y4fbA+UNXPlKkpxsz9
         BkWTFElbkg5cuawximwRnIewmQbTRxD+5wuwfAigMd191PbNb25eYurnMS9h4Qjn/EEJ
         rzmtvDkyHh3PISXqHuwRbPrj6HgzNpOoKXyPEv+LLEn5VMgDSdMvpgUkZ4eVsg9NZ5fk
         Oyag==
X-Gm-Message-State: AOAM533s7cJ9Tb45GEgZsR/iowT+M09c/AYusrmYYvWDoxgu/4/PwoCw
        lIuzehatsytNgYQOqu+lsP7C1A==
X-Google-Smtp-Source: ABdhPJzwaYd6IaBpfzwUsA4bAkGr8QzrdvNm2CozvFR5qXSLzG76K65KUqmBOt/kZPzEqwzsMibjpg==
X-Received: by 2002:a17:907:2c65:b0:70e:c2ee:781b with SMTP id ib5-20020a1709072c6500b0070ec2ee781bmr13594605ejc.281.1654500180012;
        Mon, 06 Jun 2022 00:23:00 -0700 (PDT)
Received: from [192.168.0.181] (xdsl-188-155-176-92.adslplus.ch. [188.155.176.92])
        by smtp.gmail.com with ESMTPSA id f12-20020a17090631cc00b006fee961b9e0sm5964547ejf.195.2022.06.06.00.22.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 06 Jun 2022 00:22:59 -0700 (PDT)
Message-ID: <e6967010-b3a5-e0e8-4f30-97fe5a13b49a@linaro.org>
Date:   Mon, 6 Jun 2022 09:22:58 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH v2 4/5] dt-bindings: crypto: add documentation for aspeed
 hace
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
        linux-kernel@vger.kernel.org, BMC-SW@aspeedtech.com
References: <20220606064935.1458903-1-neal_liu@aspeedtech.com>
 <20220606064935.1458903-5-neal_liu@aspeedtech.com>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <20220606064935.1458903-5-neal_liu@aspeedtech.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 06/06/2022 08:49, Neal Liu wrote:
> Add device tree binding documentation for the Aspeed Hash
> and Crypto Engines (HACE) Controller.
> 
> Signed-off-by: Neal Liu <neal_liu@aspeedtech.com>
> Signed-off-by: Johnny Huang <johnny_huang@aspeedtech.com>


Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>


Best regards,
Krzysztof
