Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E144DC4320A
	for <linux-crypto@archiver.kernel.org>; Sat, 28 Aug 2021 07:47:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C39CC610CE
	for <linux-crypto@archiver.kernel.org>; Sat, 28 Aug 2021 07:47:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233335AbhH1Hry (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 28 Aug 2021 03:47:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56010 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230208AbhH1Hry (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 28 Aug 2021 03:47:54 -0400
Received: from mail-wr1-x435.google.com (mail-wr1-x435.google.com [IPv6:2a00:1450:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0CF8C0613D9;
        Sat, 28 Aug 2021 00:47:03 -0700 (PDT)
Received: by mail-wr1-x435.google.com with SMTP id q11so13890250wrr.9;
        Sat, 28 Aug 2021 00:47:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=AK9mFIjyJpl3hXe9Hogzqd/0krNaNdau3tE1oAPxLAs=;
        b=FmFYVV/lxsJ0deuAFIdO4cUnBFNYVdrTzwVm+GLV/zi+BHTq0/mFHfVLoPMUHT8kpK
         kN8LSNnqAlWJEijL+CFu61aut4oq8y7/Eurwi2hkW3cNVJi7kfhFJ9366PAIGK3QYTQ3
         +m1gwqg2EiGnvj7O5D/6SwASdarXWRf1KtQappCEWwzuD+c+ltRQjiDKVNci28+t4i3a
         qDK55/E3WzuKL1Xc8DNY+tPZZmQrb9P5f4Tzsyb3uQHCARMmLlWzuoHF5apbNwJ3N5ny
         63iwsWjdMxlNjQODdOlouEAAy9X1j6lgR0tXppBJcmlYZTxMB6j209kqaSrejsTUuy7j
         /q+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=AK9mFIjyJpl3hXe9Hogzqd/0krNaNdau3tE1oAPxLAs=;
        b=btvzdszomV7235bngW1RJmGQvBmqZ77ObR6llAg0r4a5SlcsbcYcf2MheCFAYsmzoU
         GF+ILVNWUq3s1cv78nNoAm1hoz9AaSE0H99bLjeIuexyF1ceoYAWRdFGcU7Gi2a/ovE9
         DUTYZmuob3e5Fk/K1pv0SA23lGhSQmwpnt7Wrn7t0JijtKvQyj6nkJE2HH9HsQAQIx/M
         PnFcxl20LDsd/rZuZYrdtVLLcXjOXzTm5r6FkTFBbhOXbrih/3nNjJbkZXR873zUji2D
         Z4g4u8eeh5HaFRHW9E5MLCKGW6ux+sOijGdoCCnsrzzZTTA5xu8e9AYxdsaXMnxEINmy
         Yt1A==
X-Gm-Message-State: AOAM533RmA2iNq79zMCMFkS1aW9lfe1M940JBzELDeNBwZrrhQynwkoW
        agkyakEYNybE8Fej9Pvc7380COyC/RVEeLnFdps=
X-Google-Smtp-Source: ABdhPJyRKqyMBnxGsZalCT7QKyEmbB7zs5Qk5AAamZiUAHWAq1pdzdmZWEg7ZZtKaDGJr962vltPF0J3ENklyaDc7Gk=
X-Received: by 2002:adf:b7c2:: with SMTP id t2mr5643419wre.375.1630136822435;
 Sat, 28 Aug 2021 00:47:02 -0700 (PDT)
MIME-Version: 1.0
References: <20210822103107.28974-1-lukas.bulwahn@gmail.com> <20210827083842.GF21571@gondor.apana.org.au>
In-Reply-To: <20210827083842.GF21571@gondor.apana.org.au>
From:   Sandy Harris <sandyinchina@gmail.com>
Date:   Sat, 28 Aug 2021 15:46:50 +0800
Message-ID: <CACXcFm=sRBr6cORdyntuOum6n4dJpKv+vTZSi98_JrDWWKF1NQ@mail.gmail.com>
Subject: Re: [PATCH] crypto: sha512: remove imaginary and mystifying clearing
 of variables
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     Lukas Bulwahn <lukas.bulwahn@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Nathan Chancellor <nathan@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        clang-built-linux@googlegroups.com,
        kernel-janitors@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, Aug 27, 2021 at 4:40 PM Herbert Xu <herbert@gondor.apana.org.au> wrote:
>
> On Sun, Aug 22, 2021 at 12:31:07PM +0200, Lukas Bulwahn wrote:
> > The function sha512_transform() assigns all local variables to 0 before
> > returning to its caller with the intent to erase sensitive data.
> > ....
> >
> >   The assignments to clear a through h and t1/t2 are optimized out by the
> >   compiler because they are unused after the assignments.

Just no.

You are right, there is a problem here. I thank you for pointing it
out & I've already fixed it in some of my own code.

However, I think your solution is dead wrong. You are correct that
these assignments are useless because the compiler will optimise them
out, and that's a problem. However, it is not at all "mistiifying";
they are there for an obvious reason, to avoid leaving state that
might be useful to an enemy. That is quite a small risk, but then it
is a small mitigation, so worth doing.

The correct solution is not to just remove the assignments, but rather
to replace them with code that will not be optimised away, force the
compiler to do what we need. We already do that for operations that
clear various arrays and structures, using memzero_explicit() rather
than memset(). Similarly, we should replace the assignments with calls
to this macro:

/*
    clear a variable
    in a way the compiler will not optimise out
*/
#define clear(x)  memzero_explicit( &x, sizeof(x) )
