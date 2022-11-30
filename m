Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E1D0CC4332F
	for <linux-crypto@archiver.kernel.org>; Wed, 30 Nov 2022 13:22:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233781AbiK3NWF (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 30 Nov 2022 08:22:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58224 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235844AbiK3NVp (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 30 Nov 2022 08:21:45 -0500
Received: from mail-lf1-x12e.google.com (mail-lf1-x12e.google.com [IPv6:2a00:1450:4864:20::12e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 198B57CAAD
        for <linux-crypto@vger.kernel.org>; Wed, 30 Nov 2022 05:21:39 -0800 (PST)
Received: by mail-lf1-x12e.google.com with SMTP id f13so26898641lfa.6
        for <linux-crypto@vger.kernel.org>; Wed, 30 Nov 2022 05:21:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=EX67p13z8d9r6utOQ3HspL4ZQU3w0yz+MFaOvH14Afg=;
        b=HbKbsmDaHQCbziDgajKR80oOYPdVMbLximh6GWVUvz9kqlJroCPovLR5nuOjq9/uep
         asR8yhq+pOBgRnaYu8Wr4kGSbOInPEYT/bbLLi1cB1nVZdlYzrlolleMsVY4so9dqY+d
         /02g1se7UbNg75PTLaDlhbPCKMtYwsnhXotrZxfehQ1WUakUR+LFiQcYNzKtrXxPh4kA
         +ojt+Nx4Vr6KMaNw1zjihVUH8pe5FDP+fbDVWjj7BAv/dcfHMQG0XSWjMXVv5Vfxtu/f
         MG0PntjAYJvFBVFZk8LneLNgpLQUzYxCdIgD4KuigtuYdSSrIPRUqOy0eWNVXVGqt+/7
         +b6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=EX67p13z8d9r6utOQ3HspL4ZQU3w0yz+MFaOvH14Afg=;
        b=nn3jRhClAn2p3i0F+wiO/N7w9gMZ62cz2I7iXY6XHjhAskT8dBld1Ol3pZ3FJtnS3n
         OBDc6LgjDQjls6Ex4GBNPbv0XFw3CVnvRMDorDQJITkOPajkaSBzgra0UXUuFkHM7TNX
         5punvLRraFj64pMUL7dOZtsSmNElqrWr5x2uD8hXlXy7++tY2woFTUK6eU1x74RO4wBA
         ES3NP6352ipTPx+D6+Xgx0M211PCm1t1th5ic3aWCpZZmZ+b1f6rsFHhtsev04jKCHoA
         rWRazFN6iW5vV3We4Z0CLDrMY8FmV9WP+n1RPqQYoKI3fuDmxD1XixZXkCBluytsXjr8
         A7zA==
X-Gm-Message-State: ANoB5pmroXqb2/zcFv3so6YYBt1lB/BRC7vRPkO5SMugq/rmF1IobPxN
        9XM3oDiynYeH4HiYMBgeIcdY3w==
X-Google-Smtp-Source: AA0mqf52Qf97WPzBKIa/waiBz5xTnEwwOQKDvYKrFoZ8Q2Q4fftU8TGRyTNB6VsgW04a9KygsWryTg==
X-Received: by 2002:a05:6512:32cf:b0:4af:e82f:6013 with SMTP id f15-20020a05651232cf00b004afe82f6013mr17826256lfg.36.1669814497889;
        Wed, 30 Nov 2022 05:21:37 -0800 (PST)
Received: from [192.168.0.20] (088156142067.dynamic-2-waw-k-3-2-0.vectranet.pl. [88.156.142.67])
        by smtp.gmail.com with ESMTPSA id b8-20020a05651c032800b002770e6c620bsm125999ljp.106.2022.11.30.05.21.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 30 Nov 2022 05:21:37 -0800 (PST)
Message-ID: <6de013d9-f2ab-a2d8-1022-2474c037c737@linaro.org>
Date:   Wed, 30 Nov 2022 14:21:36 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Subject: Re: [PATCH 6/6] riscv: dts: starfive: Add crypto and DMA node for
 VisionFive 2
Content-Language: en-US
To:     Jia Jie Ho <jiajie.ho@starfivetech.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>
Cc:     linux-crypto@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-riscv@lists.infradead.org
References: <20221130055214.2416888-1-jiajie.ho@starfivetech.com>
 <20221130055214.2416888-7-jiajie.ho@starfivetech.com>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <20221130055214.2416888-7-jiajie.ho@starfivetech.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 30/11/2022 06:52, Jia Jie Ho wrote:
> Adding StarFive crypto IP and DMA controller node
> to VisionFive 2 SoC.
> 
> Signed-off-by: Jia Jie Ho <jiajie.ho@starfivetech.com>
> Signed-off-by: Huan Feng <huan.feng@starfivetech.com>
> ---
>  .../jh7110-starfive-visionfive-v2.dts         |  8 +++++
>  arch/riscv/boot/dts/starfive/jh7110.dtsi      | 36 +++++++++++++++++++
>  2 files changed, 44 insertions(+)
> 
> diff --git a/arch/riscv/boot/dts/starfive/jh7110-starfive-visionfive-v2.dts b/arch/riscv/boot/dts/starfive/jh7110-starfive-visionfive-v2.dts
> index 450e920236a5..da2aa4d597f3 100644
> --- a/arch/riscv/boot/dts/starfive/jh7110-starfive-visionfive-v2.dts
> +++ b/arch/riscv/boot/dts/starfive/jh7110-starfive-visionfive-v2.dts
> @@ -115,3 +115,11 @@ &tdm_ext {
>  &mclk_ext {
>  	clock-frequency = <49152000>;
>  };
> +
> +&sec_dma {
> +	status = "okay";
> +};
> +
> +&crypto {
> +	status = "okay";
> +};
> diff --git a/arch/riscv/boot/dts/starfive/jh7110.dtsi b/arch/riscv/boot/dts/starfive/jh7110.dtsi
> index 4ac159d79d66..745a5650882c 100644
> --- a/arch/riscv/boot/dts/starfive/jh7110.dtsi
> +++ b/arch/riscv/boot/dts/starfive/jh7110.dtsi
> @@ -455,5 +455,41 @@ uart5: serial@12020000 {
>  			reg-shift = <2>;
>  			status = "disabled";
>  		};
> +
> +		sec_dma: sec_dma@16008000 {

Node names should be generic.
https://devicetree-specification.readthedocs.io/en/latest/chapter2-devicetree-basics.html#generic-names-recommendation

No underscores in node names.

Does not look like you tested the DTS against bindings. Please run `make
dtbs_check` (see Documentation/devicetree/bindings/writing-schema.rst
for instructions).


Best regards,
Krzysztof

