Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9BFAEC433EF
	for <linux-crypto@archiver.kernel.org>; Fri, 17 Dec 2021 14:59:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237698AbhLQO7r (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 17 Dec 2021 09:59:47 -0500
Received: from smtp-relay-internal-0.canonical.com ([185.125.188.122]:36626
        "EHLO smtp-relay-internal-0.canonical.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237699AbhLQO7r (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 17 Dec 2021 09:59:47 -0500
Received: from mail-lf1-f70.google.com (mail-lf1-f70.google.com [209.85.167.70])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-internal-0.canonical.com (Postfix) with ESMTPS id 5978B40703
        for <linux-crypto@vger.kernel.org>; Fri, 17 Dec 2021 14:59:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1639753186;
        bh=MelU3SMHwWCoWgQGcng8T0F8tu5Ji7Wc6RArgT+BeXI=;
        h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
         In-Reply-To:Content-Type;
        b=wCu+IukT3BeoOQOYln5UsPTBnwb/6uy0rHdqcBkSBiS+2AzFSHFWwsPy/i9xcerdB
         bgwuarwSdm1e6+Hrm7tkLJu6G8V1HvR4bTvJ2LtvsECXybEHCboMDnowzTy0VN5/77
         UCtzfnW8VZPVLlCH1/R25C89+UlWEhXjgwsAl/R504t9l/l1k9o3DZ3AAZCAKr3FTw
         VXs8ELD/qyFNDb2w2B9gCR/J+3qlhzV/lMV8VKv3MWj8UCwOqFWvDFsYMPaQkFai7N
         HRA6gVKU+KSpcQE1a5mtMNJyh/pSVwacfwVCC26MH08ekkWNt5TWOMfO/QEfwXIWlt
         GEO3hlc4tL1wg==
Received: by mail-lf1-f70.google.com with SMTP id o11-20020a056512230b00b0041ca68ddf35so997540lfu.22
        for <linux-crypto@vger.kernel.org>; Fri, 17 Dec 2021 06:59:46 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=MelU3SMHwWCoWgQGcng8T0F8tu5Ji7Wc6RArgT+BeXI=;
        b=0IzgAURhF51rTqP79iXBZy9j34LX16CZZt6dumj3pZuvb7fU1cd3EGCBZtsfiiM3qg
         k8VIXnjgMoFWjthze6de0H3c6fuJz2Ow0gTNoiJykpxHcl9w/46oVVE5qDNlrSibDdSP
         4Jffp0EbN54ewnhI0R4Emo8cNi5EGQF/dSYarObG4HlkQ/GbQzpJ9SA0nD6UvGeOuIQR
         /M0Vv/YRx4oMtfHZG712EvhsSgMx1Hlmt8P/rICvG7dgkPeNUfoB72whY1UV5LXts9vm
         WMAK8Ukzx4cdIHJFJ7o3mxeBy4Ry2TRyKcGEIJxZrHcVO97sySbKKHf8AtzuZA12N1Gt
         FtSQ==
X-Gm-Message-State: AOAM532G9XDwQYrrdp82dL7KEo7GIrUucPUqAmDPbYjd25YIaKqHsnZM
        tcRDrGYBywGzyPsILL0nzXBm5mJ2ulix2jp+h10Ts4zMihIsco3UieJruaNQxzbImpYP1IGzdCT
        IpMKS4GZd9nPSyXtMKcg9TMyAqEIzaNvX3B0zLeyEmw==
X-Received: by 2002:a05:6512:1151:: with SMTP id m17mr3312074lfg.414.1639753184831;
        Fri, 17 Dec 2021 06:59:44 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwX3iHx/NQRikos1eLTnz73uw8eLg8t6q9e2UaRo1h3MxDjjO6FmRhNO4HZayVZ1aVIIc+2tQ==
X-Received: by 2002:a05:6512:1151:: with SMTP id m17mr3312038lfg.414.1639753184651;
        Fri, 17 Dec 2021 06:59:44 -0800 (PST)
Received: from [192.168.3.67] (89-77-68-124.dynamic.chello.pl. [89.77.68.124])
        by smtp.gmail.com with ESMTPSA id bn17sm1751216ljb.22.2021.12.17.06.59.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 17 Dec 2021 06:59:44 -0800 (PST)
Message-ID: <d5c996b7-9ac3-d7a9-4c21-307068afb84e@canonical.com>
Date:   Fri, 17 Dec 2021 15:59:42 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.1
Subject: Re: [PATCH v2 14/17] riscv: dts: microchip: add fpga fabric section
 to icicle kit
Content-Language: en-US
To:     conor.dooley@microchip.com, linus.walleij@linaro.org,
        bgolaszewski@baylibre.com, robh+dt@kernel.org,
        jassisinghbrar@gmail.com, paul.walmsley@sifive.com,
        palmer@dabbelt.com, aou@eecs.berkeley.edu, a.zummo@towertech.it,
        alexandre.belloni@bootlin.com, broonie@kernel.org,
        gregkh@linuxfoundation.org, thierry.reding@gmail.com,
        u.kleine-koenig@pengutronix.de, lee.jones@linaro.org,
        linux-gpio@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-i2c@vger.kernel.org,
        linux-pwm@vger.kernel.org, linux-riscv@lists.infradead.org,
        linux-crypto@vger.kernel.org, linux-rtc@vger.kernel.org,
        linux-spi@vger.kernel.org, linux-usb@vger.kernel.org
Cc:     geert@linux-m68k.org, bin.meng@windriver.com, heiko@sntech.de,
        lewis.hanly@microchip.com, daire.mcnamara@microchip.com,
        ivan.griffin@microchip.com, atish.patra@wdc.com
References: <20211217093325.30612-1-conor.dooley@microchip.com>
 <20211217093325.30612-15-conor.dooley@microchip.com>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
In-Reply-To: <20211217093325.30612-15-conor.dooley@microchip.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 17/12/2021 10:33, conor.dooley@microchip.com wrote:
> From: Conor Dooley <conor.dooley@microchip.com>
> 
> Split the device tree for the Microchip MPFS into two sections by adding
> microchip-mpfs-fabric.dtsi, which contains peripherals contained in the
> FPGA fabric.
> 
> Signed-off-by: Conor Dooley <conor.dooley@microchip.com>
> ---
>  .../boot/dts/microchip/microchip-mpfs-fabric.dtsi   | 13 +++++++++++++
>  .../dts/microchip/microchip-mpfs-icicle-kit.dts     |  4 ++++
>  arch/riscv/boot/dts/microchip/microchip-mpfs.dtsi   |  1 +
>  3 files changed, 18 insertions(+)
>  create mode 100644 arch/riscv/boot/dts/microchip/microchip-mpfs-fabric.dtsi
> 
> diff --git a/arch/riscv/boot/dts/microchip/microchip-mpfs-fabric.dtsi b/arch/riscv/boot/dts/microchip/microchip-mpfs-fabric.dtsi
> new file mode 100644
> index 000000000000..234c1f9bea40
> --- /dev/null
> +++ b/arch/riscv/boot/dts/microchip/microchip-mpfs-fabric.dtsi
> @@ -0,0 +1,13 @@
> +// SPDX-License-Identifier: (GPL-2.0 OR MIT)
> +/* Copyright (c) 2020-2021 Microchip Technology Inc */
> +
> +/ {
> +	corePWM0: pwm@41000000 {

Lowercase labels please, so could be "core_pwm0".


Best regards,
Krzysztof
