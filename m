Return-Path: <SRS0=xlya=UL=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EEF6FC31E46
	for <linux-crypto@archiver.kernel.org>; Wed, 12 Jun 2019 17:09:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C4AA921019
	for <linux-crypto@archiver.kernel.org>; Wed, 12 Jun 2019 17:09:08 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="oFsPySWd"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729565AbfFLRJH (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 12 Jun 2019 13:09:07 -0400
Received: from mail-io1-f66.google.com ([209.85.166.66]:38261 "EHLO
        mail-io1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726004AbfFLRJH (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 12 Jun 2019 13:09:07 -0400
Received: by mail-io1-f66.google.com with SMTP id k13so13572816iop.5
        for <linux-crypto@vger.kernel.org>; Wed, 12 Jun 2019 10:09:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=gi0ghm+XPYB6pEJtUt03LOWoqX3M4u5q9bEfWUfgFUY=;
        b=oFsPySWdMJdlADJ2STTjzjkGPGPnnSOJOuPrx2TaDoTokdIoozCYhjKxsngaycvOKP
         BqJBwV7QQo6JGZJ+LbotB83He9dLBGkG1ggXw4wbDJdc/HkfZwkXWvUtJENYE8FBRSa+
         gILZzdiWOjYHVpndKHv5IVWfp/9RGgvDcX/raKl56uOq7VniN4KzFjVV8HqhHpR65Hn9
         U7DRcbIiAvPPRYKbc3IwPke8v2+T5VsrFcMMaALpH7FtgIQt/OT2RRtwKCjTaKEOrbZq
         bhSAIhgJdNrgqCsrtK1f1JqQ6E8Pk5faO/s7y2Kl/NWfcTDGy/KY5B41gU1ZYYRVbzs5
         Nz7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=gi0ghm+XPYB6pEJtUt03LOWoqX3M4u5q9bEfWUfgFUY=;
        b=jFiM78BhAm7XehGpF8fJUfp7J98jd1Izt89XOT5WQCShFcRUMnJtZ9upAttifJTHrJ
         y0gAyzTAN+N+GDpKvMAI5AjpDExKcWqDYD6CDIw2E7ZePOAKzaLTZWddaIObHsSUu1Pv
         zHfEFT/bbgb1OyeAM9gN9UdJXWYwjm4wElLoIy76bdVaL16fE/x89QzAvH2pEDcn36sP
         NOpJGmh86NGSVRnbX8TRGOZ9qFWu5L2fFhLeTLY0ki3wUpv/NUM4LeBkhVA7V1kwkMmN
         8vzbbGYUmkwrIV9UTcj3ZHmzUayjASYtJ/I7f7Kv26AoXB7uzUSBtLp3jKXVK5YMDjgN
         7LyQ==
X-Gm-Message-State: APjAAAX6+Gy0wQ4PI6ur6N0pj45sPcsl5Na5al+WQ9EUbpeAuF7XCZv1
        IV3vwgy4ts63fJZJiy+jdvg2z4dzQv5Cwrnen+dIFNNnR2k=
X-Google-Smtp-Source: APXvYqw3Ybh+JwyXjFTr6QIi+YpELp7b6MYbc1kLqZAwD6yCPgN/KyfZbh2E/I/BGglm/l7RzgYP4NyHPVhagDQq0oA=
X-Received: by 2002:a5d:8794:: with SMTP id f20mr3933999ion.128.1560359346540;
 Wed, 12 Jun 2019 10:09:06 -0700 (PDT)
MIME-Version: 1.0
References: <20190612124838.2492-1-ard.biesheuvel@linaro.org>
 <20190612135823.5w2dkibl4r7qcxx4@gondor.apana.org.au> <CAKv+Gu83M9_3DbAz9u_nmLs=4VL-BJh_L-FsEcFRAf4c2P=Gpw@mail.gmail.com>
In-Reply-To: <CAKv+Gu83M9_3DbAz9u_nmLs=4VL-BJh_L-FsEcFRAf4c2P=Gpw@mail.gmail.com>
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date:   Wed, 12 Jun 2019 19:08:52 +0200
Message-ID: <CAKv+Gu9UXUGPpdp=Ajff=rFNbbTzXrgb-q0E5j=wJ3H1pVGjkQ@mail.gmail.com>
Subject: Re: [RFC PATCH 00/20] AES cleanup
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
Cc:     "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" 
        <linux-crypto@vger.kernel.org>, Eric Biggers <ebiggers@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, 12 Jun 2019 at 16:00, Ard Biesheuvel <ard.biesheuvel@linaro.org> wrote:
>
> On Wed, 12 Jun 2019 at 15:58, Herbert Xu <herbert@gondor.apana.org.au> wrote:
> >
> > On Wed, Jun 12, 2019 at 02:48:18PM +0200, Ard Biesheuvel wrote:
> > >
> > > All the patches leading up to that are cleanups for the AES code, to reduce
> > > the dependency on the generic table based AES code, or in some cases, hardcoded
> > > dependencies on the scalar arm64 asm code which suffers from the same problem.
> > > It also removes redundant key expansion routines, and gets rid of the x86
> > > scalar asm code, which is a maintenance burden and is not actually faster than
> > > the generic code built with a modern compiler.
> >
> > Nice, I like this a lot.
> >
> > I presume you'll be converting the AES cipher users throughout
> > the kernel (such as net/ipv4/tcp_fastopen) at some point, right?
> >
>
> Yes. I am currently surveying which users need to switch to a proper
> mode, and which ones can just use the unoptimized library version
> (such as tcp_fastopen).

Would anyone mind if I switch the TCP fastopen code to SipHash instead
of AES? I can see in the archives that Dave wasn't a fan at the time,
but for a MAC over ~16 bytes of input, it is actually a much more
better choice than what we have now. And calling into the AES cipher
twice, as we do for IPv6 connections, is even worse, since you take
the hit of invoking a SIMD cipher twice in cases where the cipher is
provided by a SIMD based implementation.
