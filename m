Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6A65AC433FE
	for <linux-crypto@archiver.kernel.org>; Fri, 11 Feb 2022 08:26:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344208AbiBKI0w (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 11 Feb 2022 03:26:52 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:55712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245730AbiBKI0v (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 11 Feb 2022 03:26:51 -0500
Received: from smtp-relay-internal-1.canonical.com (smtp-relay-internal-1.canonical.com [185.125.188.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6718EE4E
        for <linux-crypto@vger.kernel.org>; Fri, 11 Feb 2022 00:26:51 -0800 (PST)
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com [209.85.218.70])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-internal-1.canonical.com (Postfix) with ESMTPS id 21E25402B4
        for <linux-crypto@vger.kernel.org>; Fri, 11 Feb 2022 08:26:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1644568010;
        bh=OR7jE1UhZuxjFeUVRgEAKlAE7aaLAk74Il6Prfqk7uw=;
        h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
         In-Reply-To:Content-Type;
        b=ZNcWzwY2zhwd106PwQHMsixNzToCYG9AbPFTFPx6UgX637lncXlE2J0X2FlNZxiod
         oUqsSLJfgDarSd8RHmM8Lm4Zn3SRctahM2g3+EFbzm8j24nmNP9rWb7snKpYHcHNq8
         Rv+bHqz143fl3EJ0MyB24bn4S/YeE6h625ZDahBZ/iALmNTAxqWiRDR3H+Djqbz9jw
         44xa4psHKMGIfLfqPsE6UggAnMCB6OhaqxxU6dixJlivDU6ZGE1MHFl2XIhn7xtCtC
         Saz1dBrvasWBt/9wwYNiSfJkI30QEaCBHSAmjsQhops8r26+KOJjjJkEH+9rimLjHz
         1ahD0eM2tWTyg==
Received: by mail-ej1-f70.google.com with SMTP id m4-20020a170906160400b006be3f85906eso3763970ejd.23
        for <linux-crypto@vger.kernel.org>; Fri, 11 Feb 2022 00:26:50 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=OR7jE1UhZuxjFeUVRgEAKlAE7aaLAk74Il6Prfqk7uw=;
        b=4WRsYUZdBwYhyu91FSg9pneBmWLBDEMFTUUxiWfsMO7Q5ofCQc2k5Zt2FcwhE0fUMU
         avaeXUhVYccxY/LgtioaBi0mQ5ciPMaM1YBRN9UxfUTbXOYyFmvCY92MxFPqSi9h9SqM
         8mkXAWuGet8dUsRIII5QAkt5o2ZesmkcV/CUrq9wUvKu6oG/dQWVXqwffQTricJsSYmK
         ZX4+mNSVuf/y1jv/uQN6KWiJmolRw6JlSOFjtF9dWlvCcbs+d/XtWIK/ws3eXiy2tZmT
         QesH/5w6WXgajdLJ6sXb13BO63Ff7EC+GSACP6am65RUd37O6ow8mcGHsmncCluxMD75
         hgFg==
X-Gm-Message-State: AOAM532KB5iZs0KeU1c2QB8uLVWVmCQubtcYCLCLN9VJEulJC/W9ylF4
        bZtg3QAk1TJwY7h7m7hhB8LwxyX8RYp8bEZTj2clBO4SU+8pd67AXeDVypAmYlPAX5RiTMTxlTT
        vBaKxJT/Fbzax2mMP13f8uRbM70IS3N+DKOyR/p9JqA==
X-Received: by 2002:a17:907:7e8c:: with SMTP id qb12mr404207ejc.539.1644568009814;
        Fri, 11 Feb 2022 00:26:49 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwwbi8tCTvaUprEwRjQBxSIVsyAo4IJ6grHRnlsTdT5gQ/87ce41uK0+9C6Rc1374U2AbHWFQ==
X-Received: by 2002:a17:907:7e8c:: with SMTP id qb12mr404189ejc.539.1644568009644;
        Fri, 11 Feb 2022 00:26:49 -0800 (PST)
Received: from [192.168.0.99] (xdsl-188-155-168-84.adslplus.ch. [188.155.168.84])
        by smtp.gmail.com with ESMTPSA id y11sm7497470edu.2.2022.02.11.00.26.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 11 Feb 2022 00:26:49 -0800 (PST)
Message-ID: <8e44a919-cd2b-669c-aff3-bb79f16c6541@canonical.com>
Date:   Fri, 11 Feb 2022 09:26:48 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PACTH v3 1/3] dt-bindings: crypto: Convert Atmel AES to yaml
Content-Language: en-US
To:     Tudor Ambarus <tudor.ambarus@microchip.com>,
        herbert@gondor.apana.org.au, robh+dt@kernel.org
Cc:     nicolas.ferre@microchip.com, claudiu.beznea@microchip.com,
        alexandre.belloni@bootlin.com, linux-crypto@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        kavyasree.kotagiri@microchip.com, devicetree@vger.kernel.org
References: <20220211082114.452911-1-tudor.ambarus@microchip.com>
 <20220211082114.452911-2-tudor.ambarus@microchip.com>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
In-Reply-To: <20220211082114.452911-2-tudor.ambarus@microchip.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 11/02/2022 09:21, Tudor Ambarus wrote:
> Convert Atmel AES documentation to yaml format. With the conversion the
> clock and clock-names properties are made mandatory. The driver returns
> -EINVAL if "aes_clk" is not found, reflect that in the bindings and make
> the clock and clock-names properties mandatory. Update the example to
> better describe how one should define the dt node.
> 
> Signed-off-by: Tudor Ambarus <tudor.ambarus@microchip.com>
> ---
>  .../crypto/atmel,at91sam9g46-aes.yaml         | 66 +++++++++++++++++++
>  .../bindings/crypto/atmel-crypto.txt          | 20 ------
>  2 files changed, 66 insertions(+), 20 deletions(-)
>  create mode 100644 Documentation/devicetree/bindings/crypto/atmel,at91sam9g46-aes.yaml
> 
> diff --git a/Documentation/devicetree/bindings/crypto/atmel,at91sam9g46-aes.yaml b/Documentation/devicetree/bindings/crypto/atmel,at91sam9g46-aes.yaml
> new file mode 100644
> index 000000000000..fe59ad30b171
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/crypto/atmel,at91sam9g46-aes.yaml
> @@ -0,0 +1,66 @@
> +# SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
> +# Copyright (C) 2022 Microchip Technology, Inc. and its subsidiaries
> +%YAML 1.2
> +---
> +$id: http://devicetree.org/schemas/crypto/atmel,at91sam9g46-aes.yaml#
> +$schema: http://devicetree.org/meta-schemas/core.yaml#
> +
> +title: Atmel Advanced Encryption Standard (AES) HW cryptographic accelerator
> +


Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>


Best regards,
Krzysztof
