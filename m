Return-Path: <SRS0=pw/0=7L=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B93A4C433DF
	for <linux-crypto@archiver.kernel.org>; Fri, 29 May 2020 13:10:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 94F6C206B6
	for <linux-crypto@archiver.kernel.org>; Fri, 29 May 2020 13:10:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1590757856;
	bh=fpqVd2S6sw1KSq77Y2DVJhgyP64rnlywDZYYuZ+bqz0=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:List-ID:From;
	b=UW3YGTk3ukKZNut11seAZStAUCsCu0WVQNmO2d+gHmpL57UXigXMIyZw0q1QGCQB1
	 NaLswFG5TsAE7/bAtsSYyeKQCJqT/CFZbDYXrUJ85JWPFoYcJjyJNgyKH7phhuEndC
	 YF3QMNXRGCqhukUMZF95ARdvicnMB0qr/lhYu2Pc=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726593AbgE2NK4 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 29 May 2020 09:10:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:50344 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726509AbgE2NKz (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 29 May 2020 09:10:55 -0400
Received: from mail-io1-f50.google.com (mail-io1-f50.google.com [209.85.166.50])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 30969207F5
        for <linux-crypto@vger.kernel.org>; Fri, 29 May 2020 13:10:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1590757855;
        bh=fpqVd2S6sw1KSq77Y2DVJhgyP64rnlywDZYYuZ+bqz0=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=eyRv3lIf3nxOiFUyHfQJOkkCF749DBt8NILeq+Jgngy9UVmPvm3I40r6vL/31mJx/
         J5XjucqOBosTU96NxUq31/pw9bhedn3Gn19rP26AojfMwpXY0/uHGmFJEqNBbXLMuQ
         xm+Xml7hLNLNp5SnjbHXKcuVMC87stHOG7biVwu0=
Received: by mail-io1-f50.google.com with SMTP id m81so1236017ioa.1
        for <linux-crypto@vger.kernel.org>; Fri, 29 May 2020 06:10:55 -0700 (PDT)
X-Gm-Message-State: AOAM532oKB19LvGy9n+mmCroYek/O/dWTvbmwY7G+pbFS4/Xng9fUEL8
        310LHtbSDh4cV8uwBOm8K07Y86hRwPS+f5BQutU=
X-Google-Smtp-Source: ABdhPJxrjkBcfs0Pwb8hm9j6Z8KfUMTzH62EGj9Zul7v3MunXRuE7aVAAm7CDPLbyG0PafBWgbNWcL0q0mVGSBLO7Ws=
X-Received: by 2002:a05:6638:a50:: with SMTP id 16mr6709322jap.71.1590757854581;
 Fri, 29 May 2020 06:10:54 -0700 (PDT)
MIME-Version: 1.0
References: <20200519190211.76855-1-ardb@kernel.org> <20200528073349.GA32566@gondor.apana.org.au>
 <CAMj1kXGkvLP1YnDimdLOM6xMXSQKXPKCEBGRCGBRsWKAQR5Stg@mail.gmail.com>
 <20200529080508.GA2880@gondor.apana.org.au> <CAMj1kXE43VvEXyYQF=s5HybhF6Wq23wDTrvTfNV9d4fUVZZ8aw@mail.gmail.com>
 <20200529115126.GA3573@gondor.apana.org.au> <CAMj1kXFFPKWwwSpLnPmNa_Up1syMb7T5STG7Tw8mRuRqSzc9vw@mail.gmail.com>
 <20200529120216.GA3752@gondor.apana.org.au>
In-Reply-To: <20200529120216.GA3752@gondor.apana.org.au>
From:   Ard Biesheuvel <ardb@kernel.org>
Date:   Fri, 29 May 2020 15:10:43 +0200
X-Gmail-Original-Message-ID: <CAMj1kXF2-jJ6yGh9m759V2858_c45txoUBgKirvR-4z4GOHUfQ@mail.gmail.com>
Message-ID: <CAMj1kXF2-jJ6yGh9m759V2858_c45txoUBgKirvR-4z4GOHUfQ@mail.gmail.com>
Subject: Re: [RFC/RFT PATCH 0/2] crypto: add CTS output IVs for arm64 and testmgr
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        Eric Biggers <ebiggers@kernel.org>,
        Stephan Mueller <smueller@chronox.de>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, 29 May 2020 at 14:02, Herbert Xu <herbert@gondor.apana.org.au> wrote:
>
> On Fri, May 29, 2020 at 02:00:14PM +0200, Ard Biesheuvel wrote:
> >
> > Even if this is the case, it requires that an skcipher implementation
> > stores an output IV in the buffer that skcipher request's IV field
> > points to. Currently, we only check whether this is the case for CBC
> > implementations, and so it is quite likely that lots of h/w
> > accelerators or arch code don't adhere to this today.
>
> They are and have always been broken because algif_skcipher has
> always relied on this.
>

OK, so the undocumented assumption is that algif_skcipher requests are
delineated by ALG_SET_IV commands, and that anything that gets sent to
the socket in between should be treated as a single request, right? I
think that makes sense, but do note that this deviates from Stephan's
use case, where the ciphertext stealing block swap was applied after
every call into af_alg, with the IV being inherited from one request
to the next. I think that case was invalid to begin with, I just hope
no other use cases exist where this unspecified behavior is being
relied upon.

> > This might be feasible for the generic CTS driver wrapping h/w
> > accelerated CBC. But how is this supposed to work, e.g., for the two
> > existing h/w implementations of cts(cbc(aes)) that currently ignore
> > this?
>
> They'll have to disable chaining.
>
> The way I'm doing this would allow some implementations to allow
> chaining while others of the same algorithm can disable chaining
> and require the whole request to be presented together.
>

Fair enough.
