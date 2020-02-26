Return-Path: <SRS0=wQ8K=4O=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B4CDAC4BA10
	for <linux-crypto@archiver.kernel.org>; Wed, 26 Feb 2020 14:43:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8C65B24680
	for <linux-crypto@archiver.kernel.org>; Wed, 26 Feb 2020 14:43:02 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=benyossef-com.20150623.gappssmtp.com header.i=@benyossef-com.20150623.gappssmtp.com header.b="rZKYZyZe"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726974AbgBZOnC (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 26 Feb 2020 09:43:02 -0500
Received: from mail-ua1-f65.google.com ([209.85.222.65]:44204 "EHLO
        mail-ua1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727362AbgBZOm7 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 26 Feb 2020 09:42:59 -0500
Received: by mail-ua1-f65.google.com with SMTP id a33so1031107uad.11
        for <linux-crypto@vger.kernel.org>; Wed, 26 Feb 2020 06:42:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=benyossef-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=2driM7PVKhUuwY8TYsAiPgtqDfJ1mYTYuG83+3NODao=;
        b=rZKYZyZe5pecUg6ri7spyGNlVIyke9HtZIFWZAO5W3oJk2MG4xqdy++MHeGXvyk2mA
         WRNiGwLHqe6E1FAGMonL03AJRUsQr1yuV0OKuCuqrm6Pni++rP2T+xfcmnOGwmKQ3R8m
         +bfV/GYHBchauekkGjlSIc7gDgqJsuFxAIwVxcrf5eKBlGTUfIsbqJhdtUAW2Iyy76Sg
         SbWghbJWh570IvRvtLULVWnrSGM7hygFOYVyfX7Q3DIHUezDALez8PMnpn8mdqGc4I4p
         skK0TBi9QlhXRb8869GtBswUI8uEQeWvmnjkpP4Qad5PHd7O4oF6tV+szldTCsV2hvRq
         PbeA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=2driM7PVKhUuwY8TYsAiPgtqDfJ1mYTYuG83+3NODao=;
        b=g9Xo00a+0HYSJrux1zSkc9CCJmuhFN+fsJi79GTc7LtwMY0GMqTkHp4Jg2EzD6ESfT
         PsBNrp28qeKEHXh7bUsfay1gw4nssmIdQtoQ8MuT4jHQpaFWBUim/dswshsm9LUBRNc/
         EV1tUwHa0ll/v2nGzP3FoY+JiRIQXoEbQ4jsoluSgnep3n722B1vgYCsoj4nweGw9AtK
         am4BImqJLP7SFkcab18mOFA2/qHW38lA2fN6G8R16jpSdenxGYiN+VwnPU7ZqneviPyH
         hkEBbKtUOh4Yi5tsxphKFnloU23XPPjwXv+ezBNy8vORr3bPbzjnghv+4GIRREQfOGTB
         PJew==
X-Gm-Message-State: APjAAAUwRJwuwclAY4eEdcemluW00iAZan3JmmqywT0S5s6Dl3pSDP4t
        spSGmpeN6OjjqE6jxpiMyIzEm+4MDbkSAdHGw963kg==
X-Google-Smtp-Source: APXvYqzkgKGcDiFlA58U+y0xkwzn4e25+jVwn5rMMEn8FbTSxS0DJ1hIBhPWzwyEFGqNfRJOZMch419/ZIU78qM1Vds=
X-Received: by 2002:a9f:226d:: with SMTP id 100mr3924729uad.107.1582728176625;
 Wed, 26 Feb 2020 06:42:56 -0800 (PST)
MIME-Version: 1.0
References: <20200225154834.25108-1-gilad@benyossef.com> <20200225154834.25108-2-gilad@benyossef.com>
 <20200225194551.GA114977@gmail.com>
In-Reply-To: <20200225194551.GA114977@gmail.com>
From:   Gilad Ben-Yossef <gilad@benyossef.com>
Date:   Wed, 26 Feb 2020 16:42:45 +0200
Message-ID: <CAOtvUMeWB=MiYfzkrPjOctOufKJ8Q81E3m6bq8GJY-enbG6Qjg@mail.gmail.com>
Subject: Re: [PATCH 1/2] crypto: testmgr - use generic algs making test vecs
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Ofir Drang <ofir.drang@arm.com>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Linux kernel mailing list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, Feb 25, 2020 at 9:45 PM Eric Biggers <ebiggers@kernel.org> wrote:
>
> On Tue, Feb 25, 2020 at 05:48:33PM +0200, Gilad Ben-Yossef wrote:
> > Use generic algs to produce inauthentic AEAD messages,
> > otherwise we are running the risk of using an untested
> > code to produce the test messages.
> >
> > As this code is only used in developer only extended tests
> > any cycles/runtime costs are negligible.
> >
> > Signed-off-by: Gilad Ben-Yossef <gilad@benyossef.com>
> > Cc: Eric Biggers <ebiggers@kernel.org>
>
> It's intentional to use the same implementation to generate the inauthent=
ic AEAD
> messages, because it allows the inauthentic AEAD input tests to run even =
if the
> generic implementation is unavailable.

That is a good.
We can simply revert to the same implementation if the generic one is
not available.

>
> > @@ -2337,8 +2338,42 @@ static int test_aead_inauthentic_inputs(struct a=
ead_extra_tests_ctx *ctx)
> >  {
> >       unsigned int i;
> >       int err;
> > +     struct crypto_aead *tfm =3D ctx->tfm;
> > +     const char *algname =3D crypto_aead_alg(tfm)->base.cra_name;
> > +     const char *driver =3D ctx->driver;
> > +     const char *generic_driver =3D ctx->test_desc->generic_driver;
> > +     char _generic_driver[CRYPTO_MAX_ALG_NAME];
> > +     struct crypto_aead *generic_tfm =3D NULL;
> > +     struct aead_request *generic_req =3D NULL;
> > +
> > +     if (!generic_driver) {
> > +             err =3D build_generic_driver_name(algname, _generic_drive=
r);
> > +             if (err)
> > +                     return err;
> > +             generic_driver =3D _generic_driver;
> > +     }
> > +
> > +     if (!strcmp(generic_driver, driver) =3D=3D 0) {
> > +             /* Already the generic impl? */
> > +
> > +             generic_tfm =3D crypto_alloc_aead(generic_driver, 0, 0);
>
> I think you meant the condition to be 'if (strcmp(generic_driver, driver)=
 !=3D 0)'
> and for the comment to be "Not already the generic impl?".

Yes, of course. Silly me,

>
> > +             if (IS_ERR(generic_tfm)) {
> > +                     err =3D PTR_ERR(generic_tfm);
> > +                     pr_err("alg: aead: error allocating %s (generic i=
mpl of %s): %d\n",
> > +                     generic_driver, algname, err);
> > +                     return err;
> > +             }
>
> This means the test won't run if the generic implementation is unavailabl=
e.
> Is there any particular reason to impose that requirement?
>
> You mentioned a concern about the implementation being "untested", but it
> actually already passed test_aead() before getting to test_aead_extra().
>

The impetus to write this patch came from my experience debugging a
test failure with the ccree driver.
At some point while tweaking around I got into a situation where the
test was succeeding (that is, declaring the message inauthentic) not
because the mutation was being detected but because the generation of
the origin was producing a bogus ICV.
At that point it seemed to me that it would be safer to "isolate" the
original AEAD messages generation from the code that was being teste.

> We could also just move test_aead_inauthentic_inputs() to below
> test_aead_vs_generic_impl() so that it runs last.

This would probably be better, although I think that this stage also
generates inauthentic messages from time to time, no?

At any rate, I don't have strong feelings about it either way. I defer
to your judgment whether it is worth it to add a fallback to use the
same implementation and fix what needs fixing or drop the patch
altogether if you think this isn't worth the trouble - just let me
know.

Thanks,
Gilad



--=20
Gilad Ben-Yossef
Chief Coffee Drinker

values of =CE=B2 will give rise to dom!
