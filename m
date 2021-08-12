Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BAF8CC4338F
	for <linux-crypto@archiver.kernel.org>; Thu, 12 Aug 2021 10:24:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9428E60FBF
	for <linux-crypto@archiver.kernel.org>; Thu, 12 Aug 2021 10:24:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234921AbhHLKZS (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 12 Aug 2021 06:25:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48698 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234362AbhHLKZS (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 12 Aug 2021 06:25:18 -0400
Received: from mail-ej1-x629.google.com (mail-ej1-x629.google.com [IPv6:2a00:1450:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EFEADC061765;
        Thu, 12 Aug 2021 03:24:52 -0700 (PDT)
Received: by mail-ej1-x629.google.com with SMTP id b15so10521238ejg.10;
        Thu, 12 Aug 2021 03:24:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=lAh9DOdcJ3AKWMys8jX22Sn3J/EvQJoBUpAz3Mifi7Y=;
        b=FuBgqDya2SMkvuzIHwWeMn0SPDEhxcF29PLUldLp1NFrLY5+fD7Rp6jGS5BNHlZlhJ
         n8ldXVE1XB9H30jAnNzno+qV4GAWfDzxLbvvM23nYM82AJjqHteMjm5DNesrBD8HzBAd
         wbMu/SXn/DPnLIoZiQ/Nw26qJU5cmH1yuarRlU9z8+tbKit8vwWJy5ZhLswPtbHcxfDU
         wl3P3wO4TE7WjhH1m5YdZ/+C6Ipbtr/pprwqJ3UR5KN1CWJregTCj4OwPGHb3yA0Q7vD
         DV8stnj6DbayS7mGIUBcqn8DbGixiBB+GL3oqJvXkrbBOpxUiA7zFTF4ATsy32Px1TXL
         /mdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=lAh9DOdcJ3AKWMys8jX22Sn3J/EvQJoBUpAz3Mifi7Y=;
        b=GeEm9xcoa468hIBrywhPHnjfO+EfDfDPCw/iE99FvL1apexha39d1AFLBOyfEaKU7Q
         05cyIx+YPOQW+Ug8KUKt1lAAWAu4p3T8eFW7QJzip8SW6HT1uitavDgVcrjISwlAWzQl
         l8FYC6y17AKzjiu98lG2EJfUTcF8FI2pWY4agVfIuC0rAD4qIx3HzuDYH/mtZP6W7h6s
         p5ZpRPc/pxciYI1epiEAKuOyodIjT6tqTn+/nbEHtn2KxRZBzz+DOgubdB2ech1YEMYq
         X9yfW5hl670ddEHZ914LRmk3v5voY1MmUEuzgyAg6sWvA/FmQaR+WYw0rnb5rhV5aoNz
         blaQ==
X-Gm-Message-State: AOAM531nG09s6VSVyWjagJnK2A+ho4ikJ8OOsTouEUbN5/RWjEYkUrwl
        rZV6uABE3qsbEpfnesUd8jYdffgt7erDKQc5Db0=
X-Google-Smtp-Source: ABdhPJx3waPDU8WaSHHfmm2MI9XVdW007l7jwQHyxXP19vdrXuLfYGA/G01rd25ZVycRVcaSoB5/vWXK30VC+KjB2VA=
X-Received: by 2002:a17:906:b0d4:: with SMTP id bk20mr2815864ejb.535.1628763891324;
 Thu, 12 Aug 2021 03:24:51 -0700 (PDT)
MIME-Version: 1.0
References: <20210803063149.2821093-1-mudongliangabcd@gmail.com> <20210812100437.GA5055@gondor.apana.org.au>
In-Reply-To: <20210812100437.GA5055@gondor.apana.org.au>
From:   Dongliang Mu <mudongliangabcd@gmail.com>
Date:   Thu, 12 Aug 2021 18:24:25 +0800
Message-ID: <CAD-N9QWGgBBddi5kwTNANKVVdWaQRwagMHvaH592B5GDALpBrg@mail.gmail.com>
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

On Thu, Aug 12, 2021 at 6:05 PM Herbert Xu <herbert@gondor.apana.org.au> wrote:
>
> On Tue, Aug 03, 2021 at 02:31:38PM +0800, Dongliang Mu wrote:
> >
> > -theend:
> > -     kfree(buf);
> > +err_result:
> >       kfree(result);
> > -     crypto_finalize_hash_request(engine, breq, err);
> > +err_buf:
> > +     kfree(buf);
> > +out:
> > +     if (!err)
> > +             crypto_finalize_hash_request(engine, breq, err);
> >       return 0;
>
> This does not look right.  You're returning zero in case of an error

Hi Herbert,

Corentin Labbe said,

For the error code, I am not sure it is needed, error code is already
given to user via crypto_finalize_hash_request().
The "return 0" is for crypto/crypto_engine API, returning an error
will not change anything since we dont have retry_support.

So I propose you to focus on dma_map_xxx() fix patch.

See details in [1]. P.S., my previous patch returns err variable.

[1] https://lkml.org/lkml/2021/7/26/164


>
> Cheers,
> --
> Email: Herbert Xu <herbert@gondor.apana.org.au>
> Home Page: http://gondor.apana.org.au/~herbert/
> PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
