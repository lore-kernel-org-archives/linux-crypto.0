Return-Path: <SRS0=IzQh=TY=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,T_DKIMWL_WL_HIGH,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9513EC072B5
	for <linux-crypto@archiver.kernel.org>; Fri, 24 May 2019 13:12:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6DF7421773
	for <linux-crypto@archiver.kernel.org>; Fri, 24 May 2019 13:12:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1558703558;
	bh=tKhfPrX2dmO9ezZf6mxbxY2vAhUhNpSLsakl1Bxcyn8=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:List-ID:From;
	b=qqRg7/ERJTkoxiM8ietYwLpAYJffyUB1hY6DsRBc/5CsBz6pKxmxl22UMCzOc0DLQ
	 MWGe+WYOKT8H9WRUeCOrMpcjiY6dBrdWhuqYfvFRG3k+9S3CuAHWt3WhhBJUWICw7Y
	 yd77BNd/G4bCZwFhrckRp30aXtrvaNPWCrHd4/PE=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391408AbfEXNMh (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 24 May 2019 09:12:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:59694 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391397AbfEXNMh (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 24 May 2019 09:12:37 -0400
Received: from mail-qk1-f170.google.com (mail-qk1-f170.google.com [209.85.222.170])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 87BD0217D7
        for <linux-crypto@vger.kernel.org>; Fri, 24 May 2019 13:12:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1558703556;
        bh=tKhfPrX2dmO9ezZf6mxbxY2vAhUhNpSLsakl1Bxcyn8=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=JkcxGakF+Lt+HcMtxOk5+lb7xkkBqdRowf6VjuTwcxl8rgelrqzX3+h+Pg4MF64Ow
         WPZDmDyINebWgNQkuaR8vSw/H7FpvjepMI6DXpKdlxb5AOkorGd7vHnXsRO+d3onFg
         WBhSVQ7SVRSUIFbHsHgVZ/WzzkhsG8oQ8xPfrG80=
Received: by mail-qk1-f170.google.com with SMTP id z6so7406148qkl.10
        for <linux-crypto@vger.kernel.org>; Fri, 24 May 2019 06:12:36 -0700 (PDT)
X-Gm-Message-State: APjAAAW6PcdNqEyWqLvivRvgCI6wqR0ZtJWSlwG3FOVL8Qi5WyIH7zf/
        jyx70hZFFXH9hwgvsl+vLbxoHFNFsdx4TpFHCQ==
X-Google-Smtp-Source: APXvYqytTZgQGqqQMRjS9lXYbNOzAf9R1ZAcqfOe/G+YmoNDnkd6kBPF7aX7Hz/UmEwStEIVkTh/H4BaFIw2vsk6/AA=
X-Received: by 2002:ae9:c208:: with SMTP id j8mr7226668qkg.264.1558703555792;
 Fri, 24 May 2019 06:12:35 -0700 (PDT)
MIME-Version: 1.0
References: <20190430162910.16771-1-ard.biesheuvel@linaro.org> <20190430162910.16771-6-ard.biesheuvel@linaro.org>
In-Reply-To: <20190430162910.16771-6-ard.biesheuvel@linaro.org>
From:   Rob Herring <robh+dt@kernel.org>
Date:   Fri, 24 May 2019 08:12:24 -0500
X-Gmail-Original-Message-ID: <CAL_JsqLioethaQ2ekxyeG1QkCwPQKcE4daDMAJXtWwXOEABmGQ@mail.gmail.com>
Message-ID: <CAL_JsqLioethaQ2ekxyeG1QkCwPQKcE4daDMAJXtWwXOEABmGQ@mail.gmail.com>
Subject: Re: [PATCH 5/5] dt-bindings: add Atmel SHA204A I2C crypto processor
To:     Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc:     "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" 
        <linux-crypto@vger.kernel.org>,
        "moderated list:ARM/FREESCALE IMX / MXC ARM ARCHITECTURE" 
        <linux-arm-kernel@lists.infradead.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Joakim Bech <joakim.bech@linaro.org>,
        Mark Rutland <mark.rutland@arm.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, Apr 30, 2019 at 11:29 AM Ard Biesheuvel
<ard.biesheuvel@linaro.org> wrote:
>
> Add a compatible string for the Atmel SHA204A I2C crypto processor.
>
> Cc: Rob Herring <robh+dt@kernel.org>
> Cc: Mark Rutland <mark.rutland@arm.com>
> Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
> ---
>  Documentation/devicetree/bindings/crypto/atmel-crypto.txt | 13 +++++++++++++
>  1 file changed, 13 insertions(+)
>
> diff --git a/Documentation/devicetree/bindings/crypto/atmel-crypto.txt b/Documentation/devicetree/bindings/crypto/atmel-crypto.txt
> index 6b458bb2440d..a93d4b024d0e 100644
> --- a/Documentation/devicetree/bindings/crypto/atmel-crypto.txt
> +++ b/Documentation/devicetree/bindings/crypto/atmel-crypto.txt
> @@ -79,3 +79,16 @@ atecc508a@c0 {
>         compatible = "atmel,atecc508a";
>         reg = <0xC0>;
>  };
> +
> +* Symmetric Cryptography (I2C)

This doesn't really seem to be related to the rest of the file which
are all sub-blocks on SoCs. You could just add this one to
trivial-devices.yaml.

> +
> +Required properties:
> +- compatible : must be "atmel,atsha204a".
> +- reg: I2C bus address of the device.
> +- clock-frequency: must be present in the i2c controller node.

That's a property of the controller and doesn't belong here.

> +
> +Example:
> +atsha204a@c0 {

crypto@c0

> +       compatible = "atmel,atsha204a";
> +       reg = <0xC0>;
> +};
> --
> 2.20.1
>
