Return-Path: <SRS0=h4Ng=BW=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D266CC433E0
	for <linux-crypto@archiver.kernel.org>; Wed, 12 Aug 2020 12:47:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AA8BA208A9
	for <linux-crypto@archiver.kernel.org>; Wed, 12 Aug 2020 12:47:17 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="CkVbzUTO"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726698AbgHLMrR (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 12 Aug 2020 08:47:17 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:23303 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726804AbgHLMrQ (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 12 Aug 2020 08:47:16 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1597236434;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=bNVeeayqxB5gOqMlXVa+XrWC0zte8gAoVsQT7Gx8+9w=;
        b=CkVbzUTOwmuUVFjTN1rC0JsqloWKAcF8QPpzfRKmAX/WY5PwiYZ4hXAu5Y6RtI4ENiwyGn
        uzYjO3EeTNWoFrjZY1JkqIuzS+K7YCXbbzl0qCfDem9Wo8+I8QorW7HUjawRXIfqOCRX/N
        UHsrXC/z+Ztb+oI1pMH0aFMmefm6dSQ=
Received: from mail-lf1-f71.google.com (mail-lf1-f71.google.com
 [209.85.167.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-542-SMGZuvd0PLC20IDpEnavdA-1; Wed, 12 Aug 2020 08:47:13 -0400
X-MC-Unique: SMGZuvd0PLC20IDpEnavdA-1
Received: by mail-lf1-f71.google.com with SMTP id x9so569644lfa.8
        for <linux-crypto@vger.kernel.org>; Wed, 12 Aug 2020 05:47:12 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=bNVeeayqxB5gOqMlXVa+XrWC0zte8gAoVsQT7Gx8+9w=;
        b=Bihk/pxjwGGDUDzgSgnsSOsSU/GavNkYh+6HqDR4Fb1l3jPBvQu2F3WgZk5/Lh0O53
         /n86QA1znbzzE+DqdcTMdJDEqCaHjfyqAPc6FBpH8Bn2C28yWDcVByePJUIEt1mIlYea
         hgd437p+5omC1WKnWe7QUeXqryKGOKTHYoz06FGTEAWkSwgJtkY40glScPlQIOGS70ok
         63kpHxBicjgdrmwvz2ygVINoWXVpbb2MtaBOT/SuIvK9oepZa6UM/7SS0yEJuMXdVXut
         7JcUtE+XXi3FN9wBJRCmzmCZS6TWDKecm4QIEifqeBAsAnnFJm8/fm5PE+ltR2vgaK5m
         qb1g==
X-Gm-Message-State: AOAM533b+on05AHuqPR+alPsaPF10rqXaR39FMe3woNgXTaumUtZBBxv
        AWKtBdFQiBsgJCe5T8I3QfqF9HsDVvyRX8SxIaKRa70wT0OycLiq86rm2v4CmbKC9FaI1oTGCKP
        R/H04N9SQPFsy+NxeSRioqjnb+1HqvAW0cLxaQ2+P
X-Received: by 2002:a05:6512:5c7:: with SMTP id o7mr5801937lfo.124.1597236431334;
        Wed, 12 Aug 2020 05:47:11 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJybNEluqNvaAjacQMxXMxmbdXYYkI37Mvk2rvEXVylBrbegHMr+wGytYoL6ZA0b8mZ7I4a27a4VVGSefC4e3z0=
X-Received: by 2002:a05:6512:5c7:: with SMTP id o7mr5801922lfo.124.1597236431064;
 Wed, 12 Aug 2020 05:47:11 -0700 (PDT)
MIME-Version: 1.0
References: <20200812092232.364991-1-omosnace@redhat.com> <20200812123311.GA21384@gondor.apana.org.au>
In-Reply-To: <20200812123311.GA21384@gondor.apana.org.au>
From:   Ondrej Mosnacek <omosnace@redhat.com>
Date:   Wed, 12 Aug 2020 14:47:00 +0200
Message-ID: <CAFqZXNsCDb+C4Kr5i+vRkS1bcughXFuorJDJRgXkzznPigSZfg@mail.gmail.com>
Subject: Re: [PATCH] crypto: af_alg - fix uninitialized ctx->init
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     linux-crypto@vger.kernel.org, Stephan Mueller <smueller@chronox.de>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, Aug 12, 2020 at 2:33 PM Herbert Xu <herbert@gondor.apana.org.au> wrote:
> On Wed, Aug 12, 2020 at 11:22:32AM +0200, Ondrej Mosnacek wrote:
> > This new member of struct af_alg_ctx was not being initialized before
> > use, leading to random errors. Found via libkcapi testsuite.
> >
> > Cc: Stephan Mueller <smueller@chronox.de>
> > Fixes: f3c802a1f300 ("crypto: algif_aead - Only wake up when ctx->more is zero")
> > Signed-off-by: Ondrej Mosnacek <omosnace@redhat.com>
> > ---
> >  crypto/algif_aead.c     | 1 +
> >  crypto/algif_skcipher.c | 1 +
> >  2 files changed, 2 insertions(+)
>
> Thanks for the patch.
>
> > diff --git a/crypto/algif_aead.c b/crypto/algif_aead.c
> > index d48d2156e6210..9b5bd0ff3c47d 100644
> > --- a/crypto/algif_aead.c
> > +++ b/crypto/algif_aead.c
> > @@ -563,6 +563,7 @@ static int aead_accept_parent_nokey(void *private, struct sock *sk)
> >       ctx->more = 0;
> >       ctx->merge = 0;
> >       ctx->enc = 0;
> > +     ctx->init = 0;
> >       ctx->aead_assoclen = 0;
> >       crypto_init_wait(&ctx->wait);
>
> This isn't necessary because there is a memset on ctx already.
>
> > diff --git a/crypto/algif_skcipher.c b/crypto/algif_skcipher.c
> > index a51ba22fef58f..0de035b991943 100644
> > --- a/crypto/algif_skcipher.c
> > +++ b/crypto/algif_skcipher.c
> > @@ -350,6 +350,7 @@ static int skcipher_accept_parent_nokey(void *private, struct sock *sk)
> >       ctx->more = 0;
> >       ctx->merge = 0;
> >       ctx->enc = 0;
> > +     ctx->init = 0;
> >       crypto_init_wait(&ctx->wait);
>
> We should add a memset here for skcipher and get rid of these
> zero assignments.

Makes sense, will do as you suggest in v2.

Thanks,

-- 
Ondrej Mosnacek
Software Engineer, Platform Security - SELinux kernel
Red Hat, Inc.

