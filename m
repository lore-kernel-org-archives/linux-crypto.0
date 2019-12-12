Return-Path: <SRS0=MXL1=2C=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BD7A6C43603
	for <linux-crypto@archiver.kernel.org>; Thu, 12 Dec 2019 17:29:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 77D1021655
	for <linux-crypto@archiver.kernel.org>; Thu, 12 Dec 2019 17:29:09 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="EmHL+Bcw"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730168AbfLLR3J (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 12 Dec 2019 12:29:09 -0500
Received: from frisell.zx2c4.com ([192.95.5.64]:51821 "EHLO frisell.zx2c4.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730137AbfLLR3I (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 12 Dec 2019 12:29:08 -0500
Received: by frisell.zx2c4.com (ZX2C4 Mail Server) with ESMTP id a014490b
        for <linux-crypto@vger.kernel.org>;
        Thu, 12 Dec 2019 16:33:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha1; c=relaxed; d=zx2c4.com; h=mime-version
        :references:in-reply-to:from:date:message-id:subject:to:cc
        :content-type; s=mail; bh=CMZ9DmZ4PZVT10LvwCat+YczfpE=; b=EmHL+B
        cwLVxTR2xx4v6QTV3Dh1iXnkb+orvLbC61R7ts+QsGEm6wfWkPukL6WTZxdI8Qet
        10rj3j6a+/Qg+xeJS+50s3DggfaDIyAdM93vq6GuSK32yp2qi20bnk0VvCSayXjJ
        plDRxldyl4I/7d1/l3NRoYtuplk1196vSP43wM9CPjBhORx3QSDLRlT6DW/e6rZI
        xs/RnoAayS8acoBSxfL2qxUSdPIevPKmCIdQAF2c1ayagZDePcLJgKueJtveH3UN
        YntBeoWdLgXEqPj2UAQ57oOUCi9UuLdfojGXjjgfq05JTVrbLRgZZjdPLrGabHwl
        P/UEN/vyaO8NRbfw==
Received: by frisell.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id fc3c91d9 (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256:NO)
        for <linux-crypto@vger.kernel.org>;
        Thu, 12 Dec 2019 16:33:18 +0000 (UTC)
Received: by mail-ot1-f46.google.com with SMTP id g18so2729936otj.13
        for <linux-crypto@vger.kernel.org>; Thu, 12 Dec 2019 09:29:06 -0800 (PST)
X-Gm-Message-State: APjAAAWQo6OLC3EjEnhIrLcK6KjLAyasW42ZXcLF/8YXbQOCnDx1HGWB
        wpF35jl7UdCcByLFcqm9xN36EuzKtO4N0dK5VTQ=
X-Google-Smtp-Source: APXvYqwAJEe2lqxmO+H0ny837SARiCfKeBP8PKAn4z0prwI5zagCQ8CGor3LkFIbcibAMP74vkP0gU/2c7mKdX8z9qQ=
X-Received: by 2002:a9d:674f:: with SMTP id w15mr9503285otm.243.1576171746296;
 Thu, 12 Dec 2019 09:29:06 -0800 (PST)
MIME-Version: 1.0
References: <CAHmME9o4s3B_KUKYAzJr6xNaKdiLSGMJz-EyzP7RUptya1FqMg@mail.gmail.com>
 <20191212172154.GA100563@gmail.com>
In-Reply-To: <20191212172154.GA100563@gmail.com>
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
Date:   Thu, 12 Dec 2019 18:28:55 +0100
X-Gmail-Original-Message-ID: <CAHmME9pauFTcNnrEyf4XzSmQZm=NW3sDX8U+62u+wuyR30knSw@mail.gmail.com>
Message-ID: <CAHmME9pauFTcNnrEyf4XzSmQZm=NW3sDX8U+62u+wuyR30knSw@mail.gmail.com>
Subject: Re: adiantum testmgr tests not running?
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, Dec 12, 2019 at 6:21 PM Eric Biggers <ebiggers@kernel.org> wrote:
>
> Hi Jason,
>
> On Thu, Dec 12, 2019 at 04:33:25PM +0100, Jason A. Donenfeld wrote:
> > Hey Eric,
> >
> > I had to do this ugly hack to get the adiantum testmgr tests running.
> > Did you wind up doing the same when developing it, or was there some
> > other mechanism that invoked this naturally? I see all the other
> > primitives running, but not adiantum.
> >
> > Jason
> >
> > diff --git a/crypto/chacha_generic.c b/crypto/chacha_generic.c
> > index 8beea79ab117..f446b19429e9 100644
> > --- a/crypto/chacha_generic.c
> > +++ b/crypto/chacha_generic.c
> > @@ -117,7 +117,9 @@ static struct skcipher_alg algs[] = {
> >
> >  static int __init chacha_generic_mod_init(void)
> >  {
> > - return crypto_register_skciphers(algs, ARRAY_SIZE(algs));
> > + int ret = crypto_register_skciphers(algs, ARRAY_SIZE(algs));
> > + BUG_ON(alg_test("adiantum(xchacha20,aes)", "adiantum", 0, 0));
> > + return ret;
> >  }
> >
>
> You need to do something which instantiates the template, since "adiantum" is a
> template, not an algorithm itself.  The easiest way to do this is with AF_ALG,
> e.g.:
>
> python3 <<EOF
> import socket
> s = socket.socket(socket.AF_ALG, 5, 0)
> s.bind(("skcipher", "adiantum(xchacha12,aes)"))
> s.bind(("skcipher", "adiantum(xchacha20,aes)"))
> EOF
>
> All the other templates work this way too.  So for more general testing of the
> crypto API, I've actually been running a program that uses AF_ALG to try to bind
> to every algorithm name for which self-tests are defined.

Ahh, that makes sense. Upon registration I guess it will hit that
crypto notifier block, which then will call into the testmgr code.
Thanks.

Well, the good news is that the new poly1305 code works fine on
Adiantum. I'll have a v3 submitted shortly.

Jason
