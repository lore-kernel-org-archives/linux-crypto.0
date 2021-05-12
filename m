Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1303BC433B4
	for <linux-crypto@archiver.kernel.org>; Wed, 12 May 2021 22:23:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D229161419
	for <linux-crypto@archiver.kernel.org>; Wed, 12 May 2021 22:23:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229854AbhELWYR (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 12 May 2021 18:24:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:49648 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1391312AbhELV0L (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 12 May 2021 17:26:11 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1608F613F7
        for <linux-crypto@vger.kernel.org>; Wed, 12 May 2021 21:25:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620854703;
        bh=f95kky9fWPP9zmOAqEAX7s3lv8BZDFV+H/qK5UnLA5Y=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=HZguiLPH5qdbXAdBg478u9jptd5qxHD/I1Amhw3QGV1r4dOZcrZ0BrqqZcgJiYPUK
         NabD9JhMOTmZrHnm95ThqAbRAhmYImRURAdQraL/FNwiunW91rOoEKCWivfsNi8bUY
         ZlPvK4za5i6NpONGTNYQW4TSfT8e/JdR6v7v0UYYQ6TkTuOELqI/pWlbivg3JXXk39
         ZD/0bPkgeJ7kXbVHw3UbitKM/oGXOPQZ9mwsseb1XFajKkd63rTU4iqEwHBP8zx+Yg
         Lxhht5t/s74TgeHcsviEACyGjrAxPl1OIXDmU+sj974I71bRt5Nh0cjTRVrdP58OMj
         DRYS3HiU5SMsg==
Received: by mail-ot1-f44.google.com with SMTP id i23-20020a9d68d70000b02902dc19ed4c15so17889057oto.0
        for <linux-crypto@vger.kernel.org>; Wed, 12 May 2021 14:25:03 -0700 (PDT)
X-Gm-Message-State: AOAM532wdHMlygSDARvgBI8aSSzDIS2WihK0kSxM6xjrvLb0x++rXLEA
        uuJtLyrJV3CrdpmMZnJrkm9y6mSc/oQ2BoZGA5g=
X-Google-Smtp-Source: ABdhPJyqF400LwQmcv8n0cvc2qRMttw1kHSf37IPM7sk7LtlHoXuad+DAhDwnwZps9xMbduti9tZZpgD41cySXXo43A=
X-Received: by 2002:aca:4056:: with SMTP id n83mr386361oia.47.1620854702296;
 Wed, 12 May 2021 14:25:02 -0700 (PDT)
MIME-Version: 1.0
References: <20210512184439.8778-1-ardb@kernel.org> <20210512184439.8778-3-ardb@kernel.org>
 <YJw1KLD8bCLTd+Oc@gmail.com>
In-Reply-To: <YJw1KLD8bCLTd+Oc@gmail.com>
From:   Ard Biesheuvel <ardb@kernel.org>
Date:   Wed, 12 May 2021 23:24:51 +0200
X-Gmail-Original-Message-ID: <CAMj1kXFg8Viy-+h1Nsd1dXsc2KdwtDvdv4e1YeEKMnoLRhszow@mail.gmail.com>
Message-ID: <CAMj1kXFg8Viy-+h1Nsd1dXsc2KdwtDvdv4e1YeEKMnoLRhszow@mail.gmail.com>
Subject: Re: [PATCH v3 2/7] crypto: aead - disallow en/decrypt for non-task or
 non-softirq context
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Will Deacon <will@kernel.org>,
        Android Kernel Team <kernel-team@android.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, 12 May 2021 at 22:06, Eric Biggers <ebiggers@kernel.org> wrote:
>
> On Wed, May 12, 2021 at 08:44:34PM +0200, Ard Biesheuvel wrote:
> > In order to ensure that kernel mode SIMD routines will not need a scalar
> > fallback if they run with softirqs disabled, disallow any use of the
> > AEAD encrypt and decrypt routines from outside of task or softirq context.
> >
> > Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
> > ---
> >  crypto/aead.c | 10 ++++++++++
> >  1 file changed, 10 insertions(+)
> >
> > diff --git a/crypto/aead.c b/crypto/aead.c
> > index 16991095270d..b5304b3d3314 100644
> > --- a/crypto/aead.c
> > +++ b/crypto/aead.c
> > @@ -87,6 +87,11 @@ int crypto_aead_encrypt(struct aead_request *req)
> >       unsigned int cryptlen = req->cryptlen;
> >       int ret;
> >
> > +     if (!(alg->cra_flags & CRYPTO_ALG_ASYNC) &&
> > +         WARN_ONCE(!in_task() && !in_serving_softirq(),
> > +                   "synchronous call from invalid context\n"))
> > +             return -EBUSY;
> > +
> >       crypto_stats_get(alg);
> >       if (crypto_aead_get_flags(aead) & CRYPTO_TFM_NEED_KEY)
> >               ret = -ENOKEY;
> > @@ -104,6 +109,11 @@ int crypto_aead_decrypt(struct aead_request *req)
> >       unsigned int cryptlen = req->cryptlen;
> >       int ret;
> >
> > +     if (!(alg->cra_flags & CRYPTO_ALG_ASYNC) &&
> > +         WARN_ONCE(!in_task() && !in_serving_softirq(),
> > +                   "synchronous call from invalid context\n"))
> > +             return -EBUSY;
> > +
> >       crypto_stats_get(alg);
> >       if (crypto_aead_get_flags(aead) & CRYPTO_TFM_NEED_KEY)
> >               ret = -ENOKEY;
>
> This probably should go after crypto_stats_get() so that the error gets counted
> in the stats (if stats are enabled) -- analogous to how the ENOKEY error is
> counted.
>
> Likewise for the skcipher patch.
>

Good point, I'll fix that
