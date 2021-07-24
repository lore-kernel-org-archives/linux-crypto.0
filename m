Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 44D86C4338F
	for <linux-crypto@archiver.kernel.org>; Sat, 24 Jul 2021 09:42:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 154F260E9C
	for <linux-crypto@archiver.kernel.org>; Sat, 24 Jul 2021 09:42:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234970AbhGXJCA (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 24 Jul 2021 05:02:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234867AbhGXJCA (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 24 Jul 2021 05:02:00 -0400
Received: from mail-yb1-xb2f.google.com (mail-yb1-xb2f.google.com [IPv6:2607:f8b0:4864:20::b2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61689C061575
        for <linux-crypto@vger.kernel.org>; Sat, 24 Jul 2021 02:42:32 -0700 (PDT)
Received: by mail-yb1-xb2f.google.com with SMTP id x192so6284894ybe.0
        for <linux-crypto@vger.kernel.org>; Sat, 24 Jul 2021 02:42:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=benyossef-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=7tYxS44DZXuUv9URTnjvq6oxZimO6tOjzUCMqYf4ByY=;
        b=fS94OPaO2ncoYyCIikIVmo/sZkwMtFLOXKzOsUeLanL8BITBYDCV1YILRWwTMksCkw
         TfoQNU6Cr0HCQzEoJgYcZQiyjuzNCY5xLT7Bo51gwX9+i2KqkyHTklQpzbSv1luio/LY
         NQtmI9nstTxQPLbOFLSkcNs0l3uw6EwEcNxz5egdnGmmeOiP7JqTUOfmaTDXRo3KJpaE
         TnoVUJnu628/L2ObJezJNRlL9ZoU5LPwCId7ZRWYbAYUFU2yInkLA2wbPzn9W6HmXyYw
         0q1AWGIlnEHpHfybo9xJpQGZl/MNwyAMbsUq5G1LIp95dUFGNrNkYyNYNcsrz0vWd6R1
         VWJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=7tYxS44DZXuUv9URTnjvq6oxZimO6tOjzUCMqYf4ByY=;
        b=bTn5J6tTZ+QhmXLv9/Bbv6QfhfXhPGZRoc//4pzQTBty4Zi707FZ16rncS0xR9CSYT
         5ufXEZZNAkCMzeTiIARw83KyalsLoCzUo1Zwn5w1b1puhia8o6dhYK2A+gW4LG6wkoK8
         Tjc3vUEag4jPTQqeTwnO38VHcg3VbHZ6kFsAvJ00J61QgBqgUUUEgNj4RxTOUK2HQ+l2
         9YJi2VL3ROIfu/3z5JgYV+PWl7ap/p3KdPxi9aRVYzVyh9U+XY+aZBBngraCy8M5AIHr
         Oxr1ejZUXLTPc42BR5dXashFTmbLtDEJmJ0qXoR4uhsyxt+n0bVnCZtHpitDczzYOQvs
         Se2g==
X-Gm-Message-State: AOAM5324sNcITSFoIv8oGdAZDv7MXxIh2YN+RPVDly+Hr8xXdd1JF4/i
        q6iEoDTuyb2B/ZDUDS2tyKuqIC5RXzMpQ6JNSgOM4Q==
X-Google-Smtp-Source: ABdhPJxlu2XSyoavrBrcCO/jf574yf29ouOmE8PgWlEqn3nya/k/X3GIlDMuG6vUT/nNrzp81FVxpP713F/IJOv3reY=
X-Received: by 2002:a5b:7c4:: with SMTP id t4mr11530643ybq.509.1627119750875;
 Sat, 24 Jul 2021 02:42:30 -0700 (PDT)
MIME-Version: 1.0
References: <f04c8f1d-db85-c9e1-1717-4ca98b7c8c35@linaro.org> <YPrsScKf/YlKmNfU@gmail.com>
In-Reply-To: <YPrsScKf/YlKmNfU@gmail.com>
From:   Gilad Ben-Yossef <gilad@benyossef.com>
Date:   Sat, 24 Jul 2021 12:42:20 +0300
Message-ID: <CAOtvUMfwbBr44qOCma4RaH_RoC35x00N=O1Ejaxc+5EPGY8rUw@mail.gmail.com>
Subject: Re: Extending CRYPTO_ALG_OPTIONAL_KEY for cipher algorithms
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     Thara Gopinath <thara.gopinath@linaro.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, Jul 23, 2021 at 7:20 PM Eric Biggers <ebiggers@kernel.org> wrote:
>
> On Fri, Jul 23, 2021 at 06:13:50AM -0400, Thara Gopinath wrote:
> > Hi
> >
> > I have a requirement where the keys for the crypto cipher algorithms ar=
e
> > already programmed in the h/w pipes/channels and thus the ->encrypt()
> > and ->decrypt() can be called without set_key being called first.
> > I see that CRYPTO_ALG_OPTIONAL_KEY has been added to take care of
> > such requirements for CRC-32. My question is can the usage of this flag
> > be extended for cipher and other crypto algorithms as well. Can setting=
 of
> > this flag indicate that the algorithm can be used without calling set_k=
ey
> > first and then the individual drivers can handle cases where
> > both h/w keys and s/w keys need to be supported.
>
> CRYPTO_ALG_OPTIONAL_KEY isn't meant for this use case, but rather for alg=
orithms
> that have both keyed and unkeyed versions such as BLAKE2b and BLAKE2s, an=
d also
> for algorithms where the "key" isn't actually a key but rather is an init=
ial
> value that has a default value, such as CRC-32 and xxHash.
>
> It appears that that the case you're asking about is handled by using a
> different algorithm name, e.g. see the "paes" algorithms in
> drivers/crypto/ccree/cc_cipher.c.

Yeap, seems like another use case for "protected keys" like CryptoCell
and the IBM mainframe.
I gave a talk about this you might find useful -
https://www.youtube.com/watch?v=3DGbcpwUBFGDw

Feel free to contact me if you have questions.

Cheers,
Gilad

--=20
Gilad Ben-Yossef
Chief Coffee Drinker

values of =CE=B2 will give rise to dom!
