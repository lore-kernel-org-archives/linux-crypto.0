Return-Path: <SRS0=Bmkv=B7=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0B5C2C433DF
	for <linux-crypto@archiver.kernel.org>; Fri, 21 Aug 2020 10:54:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D9D0D20656
	for <linux-crypto@archiver.kernel.org>; Fri, 21 Aug 2020 10:54:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1598007273;
	bh=icq2ihwE52D3z0yseo1An/vISRkCcLVlJ+0+3Svvd1M=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:List-ID:From;
	b=a/spgoODAz2MlM3N8e+GleyzgjE/gzaXkcy0j5bUAavidHJ4HP1YDf4SW7dkGgjbX
	 4ohnF5lNBcmM9sMzvSVC85XEZ8exIiegndUSuZcMyGXhADnnx20P8mCPlXwxkSPEjI
	 xZOWmGMkceZIuWF+ZHqD8I5zMGBAuZuF3xFIJVl8=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727103AbgHUKyd (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 21 Aug 2020 06:54:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:45864 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728114AbgHUKwu (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 21 Aug 2020 06:52:50 -0400
Received: from mail-oi1-f179.google.com (mail-oi1-f179.google.com [209.85.167.179])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C46F7207BB
        for <linux-crypto@vger.kernel.org>; Fri, 21 Aug 2020 10:52:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598007169;
        bh=icq2ihwE52D3z0yseo1An/vISRkCcLVlJ+0+3Svvd1M=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=kujDMC88aqWU4C0Tk0kwpnDNUKwKZBwwDmPG7B3IFHSmxEpYLwEXmqHgVxmsbbhH8
         rgyDp12x4hYwiL66gMAvZRukU26kAKsHiE25l0ZIV5i4F6R4x7BwkfiXLeWzImQLt3
         LxMmYLd+9xF/GtL+mBi2ufC2Q/f/t1u4RiOX/tho=
Received: by mail-oi1-f179.google.com with SMTP id b22so1151884oic.8
        for <linux-crypto@vger.kernel.org>; Fri, 21 Aug 2020 03:52:49 -0700 (PDT)
X-Gm-Message-State: AOAM5336fXD2zsxJyLSGtH8AfwDY7ariZ0i7CdW/2jfy/A+q6RgN3XIH
        TEmIDxKfjQFtNDDOSbKv/+CYyjLNA17nvQR8gYw=
X-Google-Smtp-Source: ABdhPJwqxKcSXGM61h08yvSgPVUe3PO1fFQINDzUR7PB/HW6ZYWjfZn8kUnDZ4JrzbagBvQRMCLLKQ5YUYTONN5BiXI=
X-Received: by 2002:aca:d8c5:: with SMTP id p188mr1247174oig.47.1598007169142;
 Fri, 21 Aug 2020 03:52:49 -0700 (PDT)
MIME-Version: 1.0
References: <87ft8l1nuo.fsf@kernel.org> <20200821035454.GA25551@gondor.apana.org.au>
In-Reply-To: <20200821035454.GA25551@gondor.apana.org.au>
From:   Ard Biesheuvel <ardb@kernel.org>
Date:   Fri, 21 Aug 2020 12:52:38 +0200
X-Gmail-Original-Message-ID: <CAMj1kXGwAjrhgFt7ayO=S0UMdDu2KSqv=4R22poGRj_HDhQqRw@mail.gmail.com>
Message-ID: <CAMj1kXGwAjrhgFt7ayO=S0UMdDu2KSqv=4R22poGRj_HDhQqRw@mail.gmail.com>
Subject: Re: [build break] aegis128-neon-inner.c fails to build on v5.9-rc1
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        "David S. Miller" <davem@davemloft.net>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Felipe Balbi <balbi@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, 21 Aug 2020 at 05:55, Herbert Xu <herbert@gondor.apana.org.au> wrote:
>
> On Mon, Aug 17, 2020 at 03:03:11PM +0300, Felipe Balbi wrote:
> >
> > Hi,
> >
> > I'm not sure if there's already a patch for this, but I notices arm64
> > allmodconfig fails to build with GCC 10.2 as shown below:
> >
> > crypto/aegis128-neon-inner.c: In function 'crypto_aegis128_init_neon':
> > crypto/aegis128-neon-inner.c:151:3: error: incompatible types when initializing type 'unsigned char' using type 'uint8x16_t'
> >   151 |   k ^ vld1q_u8(const0),
> >       |   ^
> > crypto/aegis128-neon-inner.c:152:3: error: incompatible types when initializing type 'unsigned char' using type 'uint8x16_t'
> >   152 |   k ^ vld1q_u8(const1),
> >       |   ^
> > crypto/aegis128-neon-inner.c:147:29: warning: missing braces around initializer [-Wmissing-braces]
> >   147 |  struct aegis128_state st = {{
> >       |                             ^
> > ......
> >   151 |   k ^ vld1q_u8(const0),
> >       |   {
> >   152 |   k ^ vld1q_u8(const1),
> >   153 |  }};
> >       |  }
> >
> > Confirmation of GCC version follows:
> >
> > $ aarch64-linux-gnu-gcc --version
> > aarch64-linux-gnu-gcc (GCC) 10.2.0
> > Copyright (C) 2020 Free Software Foundation, Inc.
> > This is free software; see the source for copying conditions.  There is NO
> > warranty; not even for MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
>
> Ard, can you please take a look at this?
>

This is a known regression in GCC [0] that has already been fixed. GCC
10.3 should work fine.


[0] https://gcc.gnu.org/bugzilla/show_bug.cgi?id=96377
