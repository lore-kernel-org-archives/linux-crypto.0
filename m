Return-Path: <SRS0=VKJi=YH=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5C6E4C4CECE
	for <linux-crypto@archiver.kernel.org>; Mon, 14 Oct 2019 14:14:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2D74B2083B
	for <linux-crypto@archiver.kernel.org>; Mon, 14 Oct 2019 14:14:11 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="FIcBvQ5b"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732389AbfJNOOK (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 14 Oct 2019 10:14:10 -0400
Received: from frisell.zx2c4.com ([192.95.5.64]:32803 "EHLO frisell.zx2c4.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732330AbfJNOOK (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 14 Oct 2019 10:14:10 -0400
Received: by frisell.zx2c4.com (ZX2C4 Mail Server) with ESMTP id 3adb28b2
        for <linux-crypto@vger.kernel.org>;
        Mon, 14 Oct 2019 13:25:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha1; c=relaxed; d=zx2c4.com; h=mime-version
        :references:in-reply-to:from:date:message-id:subject:to:cc
        :content-type; s=mail; bh=Hw4I1VtSMEFPaDVFyWsDMs2cS4A=; b=FIcBvQ
        5bKx4LrHOKA1R4tTM+5NuRuRGrQOb8KUgzN87+Amgcx66FuX/ETCeLRCRAmIBAfw
        dIAUySF7+J64utOzlXlIIRKE4g65FcdZhkc+IoMuohxipPbbv2qLwG3FQmbreJT+
        bsLSid6qeGVQ1oZHKqrXpZGJ0eAa+FaP/r6uQYaERMolwcWs/G8tOMVHedZGRcky
        aRQ9lkRcpWOs8FKziSRnKxcJ76yiY+WTJCdCyvdyXSr8o3UZeObAguISS7gl5s7L
        Da+OBmVefxJ2RAXP8TkU/QbsOqVurkhHnzLTMvbASlDVwnCDz7F/1+CCy/xf1TXq
        YCfNVK1xYDkkQ6QA==
Received: by frisell.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id d4d56ac1 (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256:NO)
        for <linux-crypto@vger.kernel.org>;
        Mon, 14 Oct 2019 13:25:56 +0000 (UTC)
Received: by mail-oi1-f176.google.com with SMTP id 83so13871744oii.1
        for <linux-crypto@vger.kernel.org>; Mon, 14 Oct 2019 07:14:07 -0700 (PDT)
X-Gm-Message-State: APjAAAXKXJJuFYlC9VcMhQI2kOOhVEAYjonPc5jsx8HFWOaB5yoe1mSc
        kGYd79HTCojp9aJ280IHQg3vwbDbU419gipDDbU=
X-Google-Smtp-Source: APXvYqyWzRRIrigngvj0a2wGzmIvfMCv4+JVu4BfuISgNc/SXb0F1ZJWwecNFGOCehZGnPoRgQRTO3TA3TSkUgz7t0U=
X-Received: by 2002:aca:5b89:: with SMTP id p131mr25249979oib.52.1571062445852;
 Mon, 14 Oct 2019 07:14:05 -0700 (PDT)
MIME-Version: 1.0
References: <20191007164610.6881-1-ard.biesheuvel@linaro.org> <20191007164610.6881-25-ard.biesheuvel@linaro.org>
In-Reply-To: <20191007164610.6881-25-ard.biesheuvel@linaro.org>
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
Date:   Mon, 14 Oct 2019 16:13:53 +0200
X-Gmail-Original-Message-ID: <CAHmME9o5hHERnrT_V2EmL9GYRNGpOyos1pmwUHN71vt8yPb+ow@mail.gmail.com>
Message-ID: <CAHmME9o5hHERnrT_V2EmL9GYRNGpOyos1pmwUHN71vt8yPb+ow@mail.gmail.com>
Subject: Re: [PATCH v3 24/29] crypto: lib/curve25519 - work around Clang stack
 spilling issue
To:     Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc:     Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        David Miller <davem@davemloft.net>,
        Samuel Neves <sneves@dei.uc.pt>, Arnd Bergmann <arnd@arndb.de>,
        Eric Biggers <ebiggers@google.com>,
        Andy Lutomirski <luto@kernel.org>,
        Martin Willi <martin@strongswan.org>,
        Rene van Dorst <opensource@vdorst.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi Ard,

On Mon, Oct 7, 2019 at 6:46 PM Ard Biesheuvel <ard.biesheuvel@linaro.org> wrote:
> Arnd reports that the 32-bit generic library code for Curve25119 ends
> up using an excessive amount of stack space when built with Clang:
>
>   lib/crypto/curve25519-fiat32.c:756:6: error: stack frame size
>       of 1384 bytes in function 'curve25519_generic'
>       [-Werror,-Wframe-larger-than=]
>
> Let's give some hints to the compiler regarding which routines should
> not be inlined, to prevent it from running out of registers and spilling
> to the stack. The resulting code performs identically under both GCC
> and Clang, and makes the warning go away.

Are you *sure* about that? Couldn't we fix clang instead? I'd rather
fixes go there instead of gimping this. The reason is that I noticed
before that this code, performance-wise, was very inlining sensitive.
Can you benchmark this on ARM32-noneon and on MIPS32? If there's a
performance difference there, then maybe you can defer this part of
the series until after the rest lands, and then we'll discuss at
length various strategies? Alternatively, if you benchmark those and
it also makes no difference, then it indeed makes no difference.

Jason
