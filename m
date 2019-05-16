Return-Path: <SRS0=FyHQ=TQ=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 129E1C04AAF
	for <linux-crypto@archiver.kernel.org>; Thu, 16 May 2019 16:06:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D82EF20815
	for <linux-crypto@archiver.kernel.org>; Thu, 16 May 2019 16:06:18 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="uGmXrzUW"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726336AbfEPQGS (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 16 May 2019 12:06:18 -0400
Received: from mail-io1-f68.google.com ([209.85.166.68]:40773 "EHLO
        mail-io1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726529AbfEPQGS (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 16 May 2019 12:06:18 -0400
Received: by mail-io1-f68.google.com with SMTP id s20so3017643ioj.7
        for <linux-crypto@vger.kernel.org>; Thu, 16 May 2019 09:06:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=l76NcH5cHUwJAvvJuChpqeFUnjGCgPi9xk7n4++L00s=;
        b=uGmXrzUW+1z24r3t/lx9WvPQtGQKfUL5O7qK4ZKBDmyu0QMU6bFsIFj5qmsv9n5koS
         FiIRVmp4KwjQTutO6UtIcB9bKoBbLORMhxm3N81dzF8uQTLYLLcz92FnrH694/y0dzeN
         h12emR7V2Sq0LI7beZ3NgfS1jsZ2d/A93HoMwuwoGRVPJrqkCciQzzfkH6Y9gclEFfe+
         sEtzp8clgBF9jV+QyG2BBN0i7z7PMBkiqhQScCAoEqo+VHKzsQoGZCvqAupIxcqdKA6U
         jq5gioNo+E9a7vNQkHGd2UyoyfMuq9M7QiBiaYKNVVx0vExuBJ0VprcNYc/MhFTERhla
         xRIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=l76NcH5cHUwJAvvJuChpqeFUnjGCgPi9xk7n4++L00s=;
        b=Cvq4lED6rcDtx6OjNL0/evzrs0B0ZYIGabyxVfTjxB0o4N10cM1B+hGED/LjL6RLgN
         DftZHzWHvkxFKcQe95tXbj594O3lTKx3dqRKVNGE1uXKtEvmyDVBOkErfXyjkjRqT6Gh
         nMyRmvLBUuwPUBj6Lx4NTAUwxqu+3uiay212mW/edBNkEWrCa0DLTqiBpnYl0yt1yljV
         Dw8dSSarYDSfmeGLlNc8kIVevztc+Wwgiau5DOjS1ZTcO7vwzCt8XfhBwFeoSV6glLP4
         Lj8PDrT/KonxhOjgIfhqinLIl2/eQdhGftzgn8gSIX9SZYxbEyjs0i8DbWOVYkbQ+4lO
         OZYA==
X-Gm-Message-State: APjAAAU+CSOJ/fGdRA7gFuc/0tDfa5jM4Evgej3oSDxJpBvuiprYgzQM
        3mjGgRWyH3WHv9N8m/CoU9j13Yqbc8tLYPajqqohlVknsxY=
X-Google-Smtp-Source: APXvYqywh4ufDRQ+1VM/1bI1+KBx9S5ksORHmCsmKaGMWGPjQBu+uCNciI4ja4dIz8R0VSXRXWrpYJAT//cO1DLrJUU=
X-Received: by 2002:a6b:ea12:: with SMTP id m18mr28822415ioc.173.1558022777062;
 Thu, 16 May 2019 09:06:17 -0700 (PDT)
MIME-Version: 1.0
References: <20190430162910.16771-1-ard.biesheuvel@linaro.org> <20190430162910.16771-6-ard.biesheuvel@linaro.org>
In-Reply-To: <20190430162910.16771-6-ard.biesheuvel@linaro.org>
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date:   Thu, 16 May 2019 18:06:05 +0200
Message-ID: <CAKv+Gu96ZVOXSp+3nHrPOoQUJRNgW5MG8wOv_Refyo8yL54RjA@mail.gmail.com>
Subject: Re: [PATCH 5/5] dt-bindings: add Atmel SHA204A I2C crypto processor
To:     "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" 
        <linux-crypto@vger.kernel.org>,
        Devicetree List <devicetree@vger.kernel.org>
Cc:     linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Joakim Bech <joakim.bech@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

(+ devicetree list)

On Tue, 30 Apr 2019 at 18:29, Ard Biesheuvel <ard.biesheuvel@linaro.org> wrote:
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
> +
> +Required properties:
> +- compatible : must be "atmel,atsha204a".
> +- reg: I2C bus address of the device.
> +- clock-frequency: must be present in the i2c controller node.
> +
> +Example:
> +atsha204a@c0 {
> +       compatible = "atmel,atsha204a";
> +       reg = <0xC0>;
> +};
> --
> 2.20.1
>

If there are no objections to this patch, may I please have an ack?
