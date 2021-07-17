Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0D765C636CD
	for <linux-crypto@archiver.kernel.org>; Sat, 17 Jul 2021 21:26:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E6BC561151
	for <linux-crypto@archiver.kernel.org>; Sat, 17 Jul 2021 21:26:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233721AbhGQV3e (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 17 Jul 2021 17:29:34 -0400
Received: from mail-vk1-f173.google.com ([209.85.221.173]:35534 "EHLO
        mail-vk1-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231542AbhGQV3d (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 17 Jul 2021 17:29:33 -0400
Received: by mail-vk1-f173.google.com with SMTP id d7so2969850vkf.2;
        Sat, 17 Jul 2021 14:26:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=5XAK7+Gzh6ieUWzhfnNuMlvI9N6Gdn2a7QuEsKGdrmI=;
        b=WOhJ54ThX1910pZdfOoOLLltmo4c2ABqT73CgoA0dJ2bzOf6G5nQVecaJwzXnb2WdC
         eQ99IX6ZWhHHxEhda18VjUD4gNgx6jFugS9Bt2AUOj1mrjXiKVMTQbAcgvogqCWrsxCv
         2uMURxKoKnNF8FUu+aQPCeybWTXUkV9AgwFNxdNwHqZQwv9MIRqO8g4janiG9YKroa+J
         GQUl52T/mC/JmvAyTs5L+yilGjcSt8AkRP5X1lo4jPJvK0uLjQBojXOljFvsNFLpBHHT
         e1uawz3n/zEnC+pKcEBmKj0GG4o/IphI9vgGjWT3yOzRHb4uClFZBMRie4OXflA8I1Ms
         jdTA==
X-Gm-Message-State: AOAM531Me8zXKY1Ab469L1D8O3dPr4kj466c4kEpRRQ4gMUCHw9NyeMd
        jYsL+8C5upXPkRGaWLKisHZKsx955Y5YFs0hLb8=
X-Google-Smtp-Source: ABdhPJxKtXqo7qX7mahoa3XiRLqE8QXZHw2p1elWbvQVbW2yxP2VBcyH4F+ae1VpHCI1QWGOlvgIFuopgxhAvZh4mhc=
X-Received: by 2002:a05:6122:a12:: with SMTP id 18mr18049497vkn.1.1626557195307;
 Sat, 17 Jul 2021 14:26:35 -0700 (PDT)
MIME-Version: 1.0
References: <20201210200315.2965567-1-robh@kernel.org> <20201210200315.2965567-5-robh@kernel.org>
In-Reply-To: <20201210200315.2965567-5-robh@kernel.org>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Sat, 17 Jul 2021 23:26:24 +0200
Message-ID: <CAMuHMdU7f_zhHfnSNmY03bfBN5Kd2mO2N=yi5XTYwDNsd2XBFA@mail.gmail.com>
Subject: Re: [PATCH 4/4] dt-bindings: Remove PicoXcell bindings
To:     Rob Herring <robh@kernel.org>
List-Id: <soc.lore.kernel.org>
Cc:     Jamie Iles <jamie@jamieiles.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>, arm-soc <soc@kernel.org>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        "open list:OPEN FIRMWARE AND FLATTENED DEVICE TREE BINDINGS" 
        <devicetree@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi Rob,

(replying to an old patch that was applied a while ago)

On Thu, Dec 10, 2020 at 9:06 PM Rob Herring <robh@kernel.org> wrote:
> PicoXcell has had nothing but treewide cleanups for at least the last 8
> years and no signs of activity. The most recent activity is a yocto vendor
> kernel based on v3.0 in 2015.
>
> Cc: Jamie Iles <jamie@jamieiles.com>
> Cc: linux-crypto@vger.kernel.org
> Signed-off-by: Rob Herring <robh@kernel.org>

> --- a/Documentation/devicetree/bindings/net/macb.txt
> +++ b/Documentation/devicetree/bindings/net/macb.txt
> @@ -7,8 +7,6 @@ Required properties:
>    Use "cdns,sam9x60-macb" for Microchip sam9x60 SoC.
>    Use "cdns,np4-macb" for NP4 SoC devices.
>    Use "cdns,at32ap7000-macb" for other 10/100 usage or use the generic form: "cdns,macb".
> -  Use "cdns,pc302-gem" for Picochip picoXcell pc302 and later devices based on
> -  the Cadence GEM, or the generic form: "cdns,gem".

Note that (a) the generic form is still used as the sole compatible
value in arch/arm64/boot/dts/lg/lg131[23].dtsi, and the Linux driver
matches against it, and (b) arch/arm/boot/dts/zynq-7000.dtsi uses
the generic form as a secondary compatible value.

Gr{oetje,eeting}s,

                        Geert


--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
