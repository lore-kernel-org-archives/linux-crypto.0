Return-Path: <SRS0=ef2Z=W3=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B8166C3A5A6
	for <linux-crypto@archiver.kernel.org>; Sat, 31 Aug 2019 18:01:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8661B22D37
	for <linux-crypto@archiver.kernel.org>; Sat, 31 Aug 2019 18:01:53 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="RIfDlQUr"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728485AbfHaSBw (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 31 Aug 2019 14:01:52 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:39799 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728481AbfHaSBw (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 31 Aug 2019 14:01:52 -0400
Received: by mail-wm1-f65.google.com with SMTP id n2so9252537wmk.4
        for <linux-crypto@vger.kernel.org>; Sat, 31 Aug 2019 11:01:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=6Q2+KFE0sIU/EIq/wrGK7tKxHUi9SkrCcdU2MvIW2ko=;
        b=RIfDlQUr/Hvm0YswD6AeiXioAiyZ2pM7jXlAG6eQl6JTawGXUtJ1UeIjkOu7vf2S2n
         S2yCREij53IJR+Senki4AzIGXdQp9Je8N//wdL20NiTbugmYhBiCqA6HsKbW0QxCoG1i
         eDcdNOE1MrNRZf6kjez9r5O8P1sHVtfKyHpZQhJhYJipR1dnchaBEocKJiKaVB/KPTvh
         CEAysjSNLMDuuf2fu5Foomzp0U4X9XoTOItJMtNJ2rlR2YuIouCsFYZa8C7BCtGGmd2g
         pKYq4SSUNGIHbEZGixTONFJVR8mlZ8/cFd7RSODDeLwb8OnoAzlLONR3poBZuXJrcRI1
         IPiw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=6Q2+KFE0sIU/EIq/wrGK7tKxHUi9SkrCcdU2MvIW2ko=;
        b=C0Te9u1AjS4kBf83ItTM5DwQXHdM5oyZ+C/ZrGjtNgrjQMEfCyDEVmTEj97x4StQUt
         xjRFfRG+KmYfhP8Dp1WcQxiKbXHl73xRBYkNOUYUvPAXHCDvF6jOpwx9sScZA+erR/HW
         4l61xrd+IZ7LzzE8lfWEiTBA/HFSGV7Kueg8Xuw45XDbF4qCHGh9vveBSidel/FR7jiI
         yd1bWVFJwK9MAVe8LAby/izZZkD4PMZqPqH8IyMOuV5Dvkg8BRK/+s4s5Sa98mQjdSpj
         r1xZI/EPPj+uC73n2VbH/ZrVN8gFtvMInINbDRrMfIrwJ85FpNsd6haI6f/VP6BDpDGE
         Ce1g==
X-Gm-Message-State: APjAAAUs7pvb2hq7FFjVd6lYTytuWQGUnaZyJOL0n5bX38/T8dnxp0iy
        87VR3V04iefFYsXC4aZlJ/WaMLWcJgOc0bNv2q5vhg==
X-Google-Smtp-Source: APXvYqwQZRie6aebCjNKkyHeawhP4iPHb6hr/xESIfFsvnJ7Ab0GGtG1ZjfUGERyE+wPHE5idXEnJnCbLb8cC9vVuAA=
X-Received: by 2002:a05:600c:231a:: with SMTP id 26mr24648632wmo.136.1567274504208;
 Sat, 31 Aug 2019 11:01:44 -0700 (PDT)
MIME-Version: 1.0
References: <20190821143253.30209-1-ard.biesheuvel@linaro.org>
 <20190821143253.30209-9-ard.biesheuvel@linaro.org> <20190830080347.GA6677@gondor.apana.org.au>
In-Reply-To: <20190830080347.GA6677@gondor.apana.org.au>
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date:   Sat, 31 Aug 2019 21:01:33 +0300
Message-ID: <CAKv+Gu-4QBvPcE7YUqgWbT31gdLM8vcHTPbdOCN+UnUMXreuPg@mail.gmail.com>
Subject: Re: [PATCH 08/17] crypto: skcipher - add the ability to abort a
 skcipher walk
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" 
        <linux-crypto@vger.kernel.org>, Eric Biggers <ebiggers@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, 30 Aug 2019 at 11:03, Herbert Xu <herbert@gondor.apana.org.au> wrote:
>
> On Wed, Aug 21, 2019 at 05:32:44PM +0300, Ard Biesheuvel wrote:
> > After starting a skcipher walk, the only way to ensure that all
> > resources it has tied up are released is to complete it. In some
> > cases, it will be useful to be able to abort a walk cleanly after
> > it has started, so add this ability to the skcipher walk API.
> >
> > Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
> > ---
> >  crypto/skcipher.c                  | 3 +++
> >  include/crypto/internal/skcipher.h | 5 +++++
> >  2 files changed, 8 insertions(+)
> >
> > diff --git a/crypto/skcipher.c b/crypto/skcipher.c
> > index 5d836fc3df3e..973ab1c7dcca 100644
> > --- a/crypto/skcipher.c
> > +++ b/crypto/skcipher.c
> > @@ -140,6 +140,9 @@ int skcipher_walk_done(struct skcipher_walk *walk, int err)
> >               goto already_advanced;
> >       }
> >
> > +     if (unlikely(!n))
> > +             goto finish;
> > +
> >       scatterwalk_advance(&walk->in, n);
> >       scatterwalk_advance(&walk->out, n);
> >  already_advanced:
> > diff --git a/include/crypto/internal/skcipher.h b/include/crypto/internal/skcipher.h
> > index d68faa5759ad..bc488173531f 100644
> > --- a/include/crypto/internal/skcipher.h
> > +++ b/include/crypto/internal/skcipher.h
> > @@ -148,6 +148,11 @@ int skcipher_walk_aead_decrypt(struct skcipher_walk *walk,
> >                              struct aead_request *req, bool atomic);
> >  void skcipher_walk_complete(struct skcipher_walk *walk, int err);
> >
> > +static inline void skcipher_walk_abort(struct skcipher_walk *walk)
> > +{
> > +     skcipher_walk_done(walk, walk->nbytes);
> > +}
>
> Couldn't you just abort it by supplying an error in place of
> walk->bytes? IOW I'm fine with this helper but you don't need
> to touch skcipher_walk_done as just giving it an negative err
> value should do the trick.
>

This might be a problem with the implementation of
skcipher_walk_done() in general rather than a limitation in this
particular case, but when calling skcipher_walk_done() with a negative
err value, we never kunmap the src and dst pages. So should I propose
a fix for that instead? Or are the internal callers dealing with this
correctly? (and is it forbidden for external callers to pass negative
values?)
