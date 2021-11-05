Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 843EEC433F5
	for <linux-crypto@archiver.kernel.org>; Fri,  5 Nov 2021 18:00:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 605F660FE3
	for <linux-crypto@archiver.kernel.org>; Fri,  5 Nov 2021 18:00:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234403AbhKESDF (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 5 Nov 2021 14:03:05 -0400
Received: from mail-ua1-f52.google.com ([209.85.222.52]:34561 "EHLO
        mail-ua1-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234172AbhKESDE (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 5 Nov 2021 14:03:04 -0400
Received: by mail-ua1-f52.google.com with SMTP id b3so18615577uam.1;
        Fri, 05 Nov 2021 11:00:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=au20GLB/AwFB4ER6edB7mFBdjMKbP9KemXLMUAQRuws=;
        b=70Dqg0zFTz+/ywAeju2PWoodLqcdhCFbWmjzEUuhGlPpRWuMSdO3tJVTUWzwJUOOkb
         S0/KWBkHkcPapoSDAdm5tUEZDOUiJKU1AmLJbFjERBwFzwJSp38y/hkfjfIJp18dND8o
         an7nHz80az2RvXeIj7qUxyZHyqJotferXqWPIEO6x9LUl/S121i8h5mIVEMBECjQpBmk
         OYNtX9tXgEJfJzVaRMyopKsqSYWGpuNhtbCsWEDovXxudirmmn3wYse55uLVHZavYEQI
         yBVEgSTzPxTPGa0Aas3+NZnYyb1KRCz+yIxdpHiNy3qAB29KZuyw8tkSgeQRMRRLqzq5
         T+tA==
X-Gm-Message-State: AOAM530/Aa5W5yV56KNyiRqQUmqFHyvsu6Q9mLGy2wNnjn29Jckg0Q/x
        o5NWmcn0KKVd+Lg7QuDZz1S5gxh7ckWhtQ==
X-Google-Smtp-Source: ABdhPJzZ4L16A2hBj8cb2dUszxMli3hyl/+Vw64MVMiTXnEhdd3j0I5qjUma5n6AzczusEiwpvE7bA==
X-Received: by 2002:a67:ec10:: with SMTP id d16mr7351906vso.58.1636135224152;
        Fri, 05 Nov 2021 11:00:24 -0700 (PDT)
Received: from mail-ua1-f51.google.com (mail-ua1-f51.google.com. [209.85.222.51])
        by smtp.gmail.com with ESMTPSA id i27sm1432100uab.8.2021.11.05.11.00.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 05 Nov 2021 11:00:23 -0700 (PDT)
Received: by mail-ua1-f51.google.com with SMTP id i6so18539501uae.6;
        Fri, 05 Nov 2021 11:00:23 -0700 (PDT)
X-Received: by 2002:ab0:15a1:: with SMTP id i30mr56283928uae.122.1636135223241;
 Fri, 05 Nov 2021 11:00:23 -0700 (PDT)
MIME-Version: 1.0
References: <20211003002801.GA5435@gondor.apana.org.au> <YV0K+EbrAqDdw2vp@archlinux-ax161>
 <20211019132802.GA14233@gondor.apana.org.au> <alpine.DEB.2.22.394.2111021636040.2330984@ramsan.of.borg>
 <DM6PR04MB708155E447FD9A79AB89686DE78D9@DM6PR04MB7081.namprd04.prod.outlook.com>
 <CAMuHMdW1wLAt9Y=-GMMuk8HWE3UnRgKNMmD9fq34Rq8J7QyrzQ@mail.gmail.com>
 <20211104121612.GA8044@gondor.apana.org.au> <CAMuHMdWAAWWS+TgeN1AajHBS5w9-datMEeXqAN8RjxRd9bX63Q@mail.gmail.com>
 <20211104133044.GA8563@gondor.apana.org.au> <YYP5ypSPOcP4WGCr@shredder> <20211105072608.GA13584@gondor.apana.org.au>
In-Reply-To: <20211105072608.GA13584@gondor.apana.org.au>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Fri, 5 Nov 2021 19:00:12 +0100
X-Gmail-Original-Message-ID: <CAMuHMdVg5X00xhsYOnC84md-dNADGGL3mT3qqn3925AJFmqbMw@mail.gmail.com>
Message-ID: <CAMuHMdVg5X00xhsYOnC84md-dNADGGL3mT3qqn3925AJFmqbMw@mail.gmail.com>
Subject: Re: crypto: api - Fix boot-up crash when crypto manager is disabled
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     Ido Schimmel <idosch@idosch.org>,
        Damien Le Moal <Damien.LeMoal@wdc.com>,
        Nathan Chancellor <nathan@kernel.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Vladis Dronov <vdronov@redhat.com>,
        Simo Sorce <ssorce@redhat.com>,
        Eric Biggers <ebiggers@kernel.org>,
        "llvm@lists.linux.dev" <llvm@lists.linux.dev>,
        kernel test robot <lkp@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Guenter Roeck <linux@roeck-us.net>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi Herbert,

On Fri, Nov 5, 2021 at 8:26 AM Herbert Xu <herbert@gondor.apana.org.au> wrote:
> Could you all try this patch please?
>
> ---8<---
> When the crypto manager is disabled, we need to explicitly set
> the crypto algorithms' tested status so that they can be used.
>
> Fixes: cad439fc040e ("crypto: api - Do not create test larvals if...")
> Reported-by: Geert Uytterhoeven <geert@linux-m68k.org>
> Reported-by: Ido Schimmel <idosch@idosch.org>
> Reported-by: Guenter Roeck <linux@roeck-us.net>
> Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

Thanks!

Tested-by: Geert Uytterhoeven <geert@linux-m68k.org>

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
