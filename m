Return-Path: <SRS0=KAtS=VF=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_ADSP_CUSTOM_MED,
	DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 342B3C606BD
	for <linux-crypto@archiver.kernel.org>; Mon,  8 Jul 2019 18:20:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0CC3D217F4
	for <linux-crypto@archiver.kernel.org>; Mon,  8 Jul 2019 18:20:10 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="NrN86NZd"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389477AbfGHSUI (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 8 Jul 2019 14:20:08 -0400
Received: from mail-pl1-f196.google.com ([209.85.214.196]:43605 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388125AbfGHSUI (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 8 Jul 2019 14:20:08 -0400
Received: by mail-pl1-f196.google.com with SMTP id cl9so8662384plb.10
        for <linux-crypto@vger.kernel.org>; Mon, 08 Jul 2019 11:20:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=g2mMl6KwIYXNBHYBOGZOdtcvqAB2qYymrOWxZRP8/84=;
        b=NrN86NZdo27WlKo2K1Lq9kt6/hDDu9DCL7KNQhdCQ9aDXCnoMUD+z3533UNFvGQckN
         Tpvfaf4U59arXoe8vMc/TySJuCqpEqWgxUirQoSgm4V2eCBoK4n7Fk+9P2/MeIfHycJk
         kGHwUmwqC1KTcYRqQG8faV93QYZXF0oqKOVcF0mW1jxpkyGaGC0uU/+g9wkCVzl/RSEe
         TiFggmkzxdUHJN7UKMYp26zOJZirp59GpLMFw+jI/EZG5X4Ay42udVF4+56lgZiN+fIK
         IM5G4wCmI4vZjiZ5rpnBpO/RDi/4KRkLqtpxEBDijlapjgQ9VsJhYUPpYQGY2MafMs4R
         p0aQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=g2mMl6KwIYXNBHYBOGZOdtcvqAB2qYymrOWxZRP8/84=;
        b=eHrzHd1w4Xub7uiZORsZD11bvd3C6XUODTRIzn9vrJI6AF91cpsTy5EQ0PturiodYU
         cQp3wrdxoWd3fwttr80GgZs3Gp0abJULCUMq3isDhjl76782wBpK670ZLYi84wS7pQwJ
         u5KeRuBoxNyr2JfSa2OCyc03DkfnDyjBpKsvTZG2UauOGQoMqhRpJZIMY2JlfrlR2fwo
         5RwUq/o85sIC80M7/Fk5JU6SWsMzRId7hgPMWWm5qQWxKdtlS12NfBa3vNf9KZXKgz2M
         0WnIBa+UaNd4gJT/nKVGsrwnulQkGVMyb9Gg8nrV7RD/FCtjEFY+XUsSfph6JUHOZjYr
         J2qg==
X-Gm-Message-State: APjAAAWu7Q5z5FL+b57BaBkQZwqEFw26OhGvqQF1cGMhETFGDs9mqXjP
        DaWJY0IVUgeYWCIugn9MUeg2Y6ODfxgBuNbLMsZZCw==
X-Google-Smtp-Source: APXvYqz6ARuDYE6KR0XLPNBzn3iQS6kfN0RypWZBywNe3QPOouTKN7ddDYBIz6c17I0EC+1oLvFbmqI4mhtEH67SsC0=
X-Received: by 2002:a17:902:b944:: with SMTP id h4mr26209618pls.179.1562610007457;
 Mon, 08 Jul 2019 11:20:07 -0700 (PDT)
MIME-Version: 1.0
References: <CA+icZUX3EOhrUp0Afbo_fK9rb5AbXjbaBFwhj1qmBaHom1b3MA@mail.gmail.com>
 <CAKwvOdn8Za1Dy4QgdDZu1My5oYLJJzyRqYsq+XkpRpnViC6aKQ@mail.gmail.com>
 <20190617182256.GB92263@gmail.com> <CA+icZUV8693G8jgHw2t9qUay4_Ad-7BgNOkL6z+4z8xNXyL=cA@mail.gmail.com>
 <20190703161456.GC21629@sol.localdomain> <CAKwvOdmRdef1PD9NQnOhfeNC_LWAp8a-oYcnxXo1WWGoWnyn0w@mail.gmail.com>
In-Reply-To: <CAKwvOdmRdef1PD9NQnOhfeNC_LWAp8a-oYcnxXo1WWGoWnyn0w@mail.gmail.com>
From:   Nick Desaulniers <ndesaulniers@google.com>
Date:   Mon, 8 Jul 2019 11:19:56 -0700
Message-ID: <CAKwvOdkz3V2WUPc=ak2WpXUjrjV-e-BXNped8kfPAj2p72vASw@mail.gmail.com>
Subject: Re: crypto: x86/crct10dif-pcl - cleanup and optimizations
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     Sedat Dilek <sedat.dilek@gmail.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        linux-crypto@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Clang-Built-Linux ML <clang-built-linux@googlegroups.com>,
        Fangrui Song <maskray@google.com>,
        Peter Smith <peter.smith@linaro.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, Jul 3, 2019 at 11:52 AM Nick Desaulniers
<ndesaulniers@google.com> wrote:
>
> On Wed, Jul 3, 2019 at 9:15 AM Eric Biggers <ebiggers@kernel.org> wrote:
> > Sorry, I am still confused.  Are you saying that something still needs to be
> > fixed in the kernel code, and if so, why?  To reiterate, the byteshift_table
> > doesn't actually *need* any particular alignment.  Would it avoid the confusion
> > if I changed it to no alignment?  Or is there some section merging related
> > reason it actually needs to be 32?
>
> Looks like the section merging of similarly named sections of
> differing alignment in LLD just got reverted:
> https://bugs.llvm.org/show_bug.cgi?id=42289#c8

And re-fixed in:
https://reviews.llvm.org/rL365139
Seems like special care was needed for SHF_STRINGS.
-- 
Thanks,
~Nick Desaulniers
