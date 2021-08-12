Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0312DC4338F
	for <linux-crypto@archiver.kernel.org>; Thu, 12 Aug 2021 10:40:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4A17760FD7
	for <linux-crypto@archiver.kernel.org>; Thu, 12 Aug 2021 10:40:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235404AbhHLKlO (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 12 Aug 2021 06:41:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52184 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234700AbhHLKlN (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 12 Aug 2021 06:41:13 -0400
Received: from mail-ej1-x630.google.com (mail-ej1-x630.google.com [IPv6:2a00:1450:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8706DC061765;
        Thu, 12 Aug 2021 03:40:48 -0700 (PDT)
Received: by mail-ej1-x630.google.com with SMTP id lo4so10534196ejb.7;
        Thu, 12 Aug 2021 03:40:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Cp/s3vlU5WFTroPHhHfA4dE5DhMKa1dsp19BvMnWTZ4=;
        b=mrPQi5ew93qJB70v7OQ2t8la7sHF8w3JNRsIetfnZxSvpuhzZOYVnK/ay+PHyHG/yF
         dGCqzfM1GiqjmypqWslpAOsuv76dHRUwOh31SsRQlpxJ5y7wcEnl599Vit7LkxZzP2eb
         pbV3/G80tGYpqmo+ii374siwtenE5ObBubkpqGnphg+xUHgRPbT9FMdaCmPaEff0CsRK
         qpsS+a4nU77GTzmgvg+aLQkhf1nQiy1kLG8Pq2ChXGQZOBTqB0D91xEaiaN+mcjFk+ek
         CmfOMWQKAsK7Qk9iCvsSkny19pgJ4ZEjfTQrcjhTJoT5utcPzFN3eOPaoNbI9YCayHiU
         2xxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Cp/s3vlU5WFTroPHhHfA4dE5DhMKa1dsp19BvMnWTZ4=;
        b=o1GRhCWpRFPsdJu4rz1MccT/Q0pTmaFvSgr1/xkuZLp6/hun60B5XN+juR6hqZk18s
         xQ1fhREozIcZL/Syd9VhkN0ylMj2+PjwnyQE91wSN8j0a+EKiSA4Oo+68ceUadETk9k+
         wbj9RQv4UCZwlgRUP5JKDNkNSEZ2wQYmKQqyufI6MdkNDAngEBIkg9L4VajjThNOUuL4
         qJtKs+UBpW7ZtTbz309h7loomAJeVvrluQMevkBja4l6mB8pGCNEw1aztFIMSoE06jRH
         hKGxoAj4oYeP4Ax0IheRNjZu38h+s207goDQ1hzxnPNBlSSpe7xW5Pgoa5NOjWjaoBhh
         W8ew==
X-Gm-Message-State: AOAM533sXM2Mq24VZS807Z4WenxPwG0KngQYkNGdiGn9Eo+fPjADrw7i
        XMYzsEcVoq01vb3gEFMrw2DJ4spQ0gFov47h3ge46EQ813ZuDYhw
X-Google-Smtp-Source: ABdhPJyacnVE3owHvyo9vxiHEV0dN5cJra+igFKNNq5Idb+SbkJmRl1G3xNAAUcJP1JwUz6fXhk9JlyLph6KALqj3Cg=
X-Received: by 2002:a17:906:8493:: with SMTP id m19mr2973578ejx.103.1628764847064;
 Thu, 12 Aug 2021 03:40:47 -0700 (PDT)
MIME-Version: 1.0
References: <20210803063149.2821093-1-mudongliangabcd@gmail.com>
 <20210812100437.GA5055@gondor.apana.org.au> <CAD-N9QWGgBBddi5kwTNANKVVdWaQRwagMHvaH592B5GDALpBrg@mail.gmail.com>
 <20210812102954.GA5569@gondor.apana.org.au>
In-Reply-To: <20210812102954.GA5569@gondor.apana.org.au>
From:   Dongliang Mu <mudongliangabcd@gmail.com>
Date:   Thu, 12 Aug 2021 18:40:20 +0800
Message-ID: <CAD-N9QU6r-yLBvJUpV+xy4pgOFnrtquBymthG7k5ddHt20APzg@mail.gmail.com>
Subject: Re: [PATCH v2] crypto: sun8i-ce: fix multiple memory leaks in sun8i_ce_hash_run
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     Corentin Labbe <clabbe.montjoie@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Maxime Ripard <mripard@kernel.org>,
        Chen-Yu Tsai <wens@csie.org>,
        Jernej Skrabec <jernej.skrabec@gmail.com>,
        Eric Biggers <ebiggers@google.com>,
        Xiang Chen <chenxiang66@hisilicon.com>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Corentin Labbe <clabbe@baylibre.com>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Ard Biesheuvel <ardb@kernel.org>, linux-crypto@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-sunxi@lists.linux.dev,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, Aug 12, 2021 at 6:30 PM Herbert Xu <herbert@gondor.apana.org.au> wrote:
>
> On Thu, Aug 12, 2021 at 06:24:25PM +0800, Dongliang Mu wrote:
> > On Thu, Aug 12, 2021 at 6:05 PM Herbert Xu <herbert@gondor.apana.org.au> wrote:
> > >
> > > On Tue, Aug 03, 2021 at 02:31:38PM +0800, Dongliang Mu wrote:
> > > >
> > > > -theend:
> > > > -     kfree(buf);
> > > > +err_result:
> > > >       kfree(result);
> > > > -     crypto_finalize_hash_request(engine, breq, err);
> > > > +err_buf:
> > > > +     kfree(buf);
> > > > +out:
> > > > +     if (!err)
> > > > +             crypto_finalize_hash_request(engine, breq, err);
> > > >       return 0;
> > >
> > > This does not look right.  You're returning zero in case of an error
> >
> > Hi Herbert,
> >
> > Corentin Labbe said,
> >
> > For the error code, I am not sure it is needed, error code is already
> > given to user via crypto_finalize_hash_request().
>
> Yes but your patch changes this.  You're now skipping the finalize
> call and thus throwing away err if it's not zero.
>

I see. Thanks for your comment.

I agree with you and would like to modify "return 0" to "return err"
in the next version.  Even if the parent function does not care about
the return value, it is still necessary to keep the right return
value.

Corentin, how do you think?

> If it's supposed to do this you need to explain it in your patch
> submission.
>
> Cheers,
> --
> Email: Herbert Xu <herbert@gondor.apana.org.au>
> Home Page: http://gondor.apana.org.au/~herbert/
> PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
