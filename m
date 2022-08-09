Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8425BC19F2D
	for <linux-crypto@archiver.kernel.org>; Tue,  9 Aug 2022 05:47:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235086AbiHIFrH (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 9 Aug 2022 01:47:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44620 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229976AbiHIFrG (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 9 Aug 2022 01:47:06 -0400
Received: from mail-lf1-x12a.google.com (mail-lf1-x12a.google.com [IPv6:2a00:1450:4864:20::12a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4EDB1BEAD
        for <linux-crypto@vger.kernel.org>; Mon,  8 Aug 2022 22:47:04 -0700 (PDT)
Received: by mail-lf1-x12a.google.com with SMTP id e15so15666003lfs.0
        for <linux-crypto@vger.kernel.org>; Mon, 08 Aug 2022 22:47:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=5LBQJymvxNHE24FaPTYPnqJCdE1pFFrxPDyluiIfEnc=;
        b=kBvlTxpCOc5yaYvsppc8dS4mw7EXR/4QpqKBKhq00yO3Jv5hBVhBuwd6ub3f2wxDYk
         nkAxBhpDh6d0aZl3Iq5V7ZxwsxD3XzbAxz00VeASRTPVjw5CiP0zEAKYuimVwln1UBb3
         sA9ytrIe1SxMnvtdI3mrLXE2PMKzH5s/Jo1+zUojl1Sz3ypUMEESTKGQ2lS/8mc7lX4m
         D7Tn8un3arGcnF2TdIk4EzGBzuAlFY9PL1ssbRjP51oy3ZWU0KFhxnkfUD3yMfr5tZG9
         oQhGqI2HTvlFhfuQvbOhad1ourha+qmSa9OrmEJ2FtN1/9qpunXSgjm49s83X6B/ZqnG
         MqsA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=5LBQJymvxNHE24FaPTYPnqJCdE1pFFrxPDyluiIfEnc=;
        b=JC2cLr9lVn6skLEo7KdY3koV0zbTrv86r2UrYIXpBOmsy93StC8hWbJ54idPbH3yyb
         yOliOLhkUOgsJQb28lxNi/nvLumeZWqOFtH95QVp86qJVF8FUBezOiPxJ6IQBX2S2LZc
         BTwMJcBDCI/xHEaBKpvd2qYH9WdSjW/R+pGaTVh0v6rgWVdFdsT1duTgNO2BI0dZdp2Q
         Wt0J40GNN4ppnxTdLg00ji/ar2Jx57pDGQJu/XwkXRGnVB2wYm/tddF0yBG84y1d9dDG
         WX9HqL0vD3hkL8e9rwkidCFIB/mKkPHN8j8K7x6uXUWqKv2e31TowmiVv/2+Ehl7MtW9
         yK0Q==
X-Gm-Message-State: ACgBeo0Xro8zgwnTUdtNLQIbfESzZP8PPDB5SFqnxf/pkVbkZYm5aJEo
        D3qfmWvWt+SC1mHwBf87B+tbCQ==
X-Google-Smtp-Source: AA6agR499O4vzQhRHFVBRwbN0SJDy9NXAQre2YictNprW6je38pUaKfxM07XbZ/bVPFhFXBEHu92hA==
X-Received: by 2002:ac2:59c2:0:b0:48b:1827:dd43 with SMTP id x2-20020ac259c2000000b0048b1827dd43mr7951297lfn.132.1660024023224;
        Mon, 08 Aug 2022 22:47:03 -0700 (PDT)
Received: from [192.168.1.39] ([83.146.140.105])
        by smtp.gmail.com with ESMTPSA id z18-20020a2e3512000000b0025e2ff06c19sm1549428ljz.50.2022.08.08.22.47.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 08 Aug 2022 22:47:02 -0700 (PDT)
Message-ID: <c2ce0563-86fc-6049-ee53-b45753335352@linaro.org>
Date:   Tue, 9 Aug 2022 08:47:01 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.12.0
Subject: Re: [RFC PATCH 2/6] dt-bindings: crypto: add binding for eip29t2
 public key accelerator (PKA)
Content-Language: en-US
To:     Daniel Parks <danielrparks@ti.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Nishanth Menon <nm@ti.com>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        Tero Kristo <kristo@kernel.org>
Cc:     linux-crypto@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
References: <cover.1659985696.git.danielrparks@ti.com>
 <856cbf3a002b5d400bbbdb7aa914ab5b8681a96e.1659985696.git.danielrparks@ti.com>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <856cbf3a002b5d400bbbdb7aa914ab5b8681a96e.1659985696.git.danielrparks@ti.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 08/08/2022 22:12, Daniel Parks wrote:
> The PKA is a mmio-only asymmetric crypto accelerator available on
> certain K3 devices.
> 
> Signed-off-by: Daniel Parks <danielrparks@ti.com>
> ---
>  .../inside-secure,safexcel-eip29t2.yaml       | 49 +++++++++++++++++++
>  1 file changed, 49 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/crypto/inside-secure,safexcel-eip29t2.yaml
> 
> diff --git a/Documentation/devicetree/bindings/crypto/inside-secure,safexcel-eip29t2.yaml b/Documentation/devicetree/bindings/crypto/inside-secure,safexcel-eip29t2.yaml
> new file mode 100644
> index 000000000000..b1e195a108cc
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/crypto/inside-secure,safexcel-eip29t2.yaml
> @@ -0,0 +1,49 @@
> +# SPDX-License-Identifier: (GPL-2.0-only or BSD-2-Clause)
> +%YAML 1.2
> +---
> +$id: http://devicetree.org/schemas/crypto/inside-secure,safexcel-eip29t2.yaml#
> +$schema: http://devicetree.org/meta-schemas/core.yaml#
> +
> +title: K3 SoC SA2UL PKA crypto module

If this is the child mentioned in patch #1, then this should be first
patch and your next one should reference it.

> +
> +maintainers:
> +  - Daniel Parks <danielrparks@ti.com>
> +
> +description: |
> +  Asymmetric crypto accelerator
> +
> +properties:
> +  compatible:
> +    const: inside-secure,safexcel-eip29t2
> +
> +  reg:
> +    items:
> +      - description: control registers
> +      - description: mapped memory
> +
> +  interrupts:
> +    items:
> +      - description: PKA interrupt

This could be "maxItems:1" because your description actually does not
bring anything new, but current choice is also OK.

Best regards,
Krzysztof
