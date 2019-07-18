Return-Path: <SRS0=4UBR=VP=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E4D8DC7618F
	for <linux-crypto@archiver.kernel.org>; Thu, 18 Jul 2019 21:35:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C4E24208C0
	for <linux-crypto@archiver.kernel.org>; Thu, 18 Jul 2019 21:35:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391429AbfGRVfC (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 18 Jul 2019 17:35:02 -0400
Received: from mail-qt1-f193.google.com ([209.85.160.193]:42437 "EHLO
        mail-qt1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727950AbfGRVfC (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 18 Jul 2019 17:35:02 -0400
Received: by mail-qt1-f193.google.com with SMTP id h18so28814463qtm.9;
        Thu, 18 Jul 2019 14:35:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=iYruTEvMthvxr10Zu7OjRdNgkkTEdsIjVkYLIY65N+o=;
        b=cRkQRDPjRqgx4oaLWNI4lWy8pc8VDTXN/nOVIc7jOrShyXUGxUlYBxg+CLF6oaZuJ4
         K2vMquFhRlpVncrwmLVHgHlp5S8Ue6w/MtVRF3QKpGhJJP0OX6mMJ6qfCKAYYkQB6P+3
         P91/dkGWHrJhZYRu+MVk2MiJ1cjB14+gkAY9zkKARrR1R03YzURpUFdnL2cFU/JWESl2
         WT6eiWDxrr/1Tg57K38pdl52EbRs4a3tOc11Bf2N9R8GWAjvpiduwJEgS30tyjLzqdBC
         ncTbvZamc22+XPTTSsnXZGTZBFWNNjJ6xSc+sdwbgZRD0onNoKn0hv/PPc6VXskW+2Ls
         /chQ==
X-Gm-Message-State: APjAAAUYMFUIMl4ONpEd4WZmXqkMgKxBLcBMFRgAHHIuYBkhN/Bcjlnq
        2i9wzo6QYDTJvXzc5C1CHqdRylegZzxS3SZ0EjU=
X-Google-Smtp-Source: APXvYqxtr+NU0anxDTa+rjTsi47y3YpCe+1y1SmBGjVGmexjOvmm6q7C3ivuMc2a75hl0GPgwE2yvF8aHQRgjt+R+Nc=
X-Received: by 2002:ac8:f99:: with SMTP id b25mr27651367qtk.142.1563485701335;
 Thu, 18 Jul 2019 14:35:01 -0700 (PDT)
MIME-Version: 1.0
References: <20190718135017.2493006-1-arnd@arndb.de> <CAKwvOd=HEjDA7pcsQvONoHgU2JH3xz+9MwHU0pXKathDRQx=nQ@mail.gmail.com>
In-Reply-To: <CAKwvOd=HEjDA7pcsQvONoHgU2JH3xz+9MwHU0pXKathDRQx=nQ@mail.gmail.com>
From:   Arnd Bergmann <arnd@arndb.de>
Date:   Thu, 18 Jul 2019 23:34:44 +0200
Message-ID: <CAK8P3a0s1E2==8k8qo-cJWgVOdHMicvj+VEN9axGo1cmNCu5Hg@mail.gmail.com>
Subject: Re: [PATCH] crypto: aegis: fix badly optimized clang output
To:     Nick Desaulniers <ndesaulniers@google.com>
Cc:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Ondrej Mosnacek <omosnacek@gmail.com>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" 
        <linux-crypto@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        clang-built-linux <clang-built-linux@googlegroups.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, Jul 18, 2019 at 11:17 PM 'Nick Desaulniers' via Clang Built
Linux <clang-built-linux@googlegroups.com> wrote:
> On Thu, Jul 18, 2019 at 6:50 AM Arnd Bergmann <arnd@arndb.de> wrote:
> > diff --git a/crypto/aegis.h b/crypto/aegis.h
> > index 41a3090cda8e..efed7251c49d 100644
> > --- a/crypto/aegis.h
> > +++ b/crypto/aegis.h
> > @@ -34,21 +34,21 @@ static const union aegis_block crypto_aegis_const[2] = {
> >         } },
> >  };
> >
> > -static void crypto_aegis_block_xor(union aegis_block *dst,
> > +static __always_inline void crypto_aegis_block_xor(union aegis_block *dst,
>
> `static inline` would be more concise and expand to the same
> attribute, IIRC.  Not sure if that's worth sending a v2. But for now,

I think I tried that first but it had no effect when CONFIG_OPTIMIZE_INLINING
is set, as the compiler can sometimes ignores a plain 'inline'. The version
I posted was needed to pass the randconfig tests.

> Acked-by: Nick Desaulniers <ndesaulniers@google.com>
>
Thanks,

       Arnd
