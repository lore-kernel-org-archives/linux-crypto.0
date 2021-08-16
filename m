Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3D4A3C4338F
	for <linux-crypto@archiver.kernel.org>; Mon, 16 Aug 2021 13:39:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 27B4761359
	for <linux-crypto@archiver.kernel.org>; Mon, 16 Aug 2021 13:39:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236707AbhHPNk2 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 16 Aug 2021 09:40:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238816AbhHPNkX (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 16 Aug 2021 09:40:23 -0400
Received: from mail-ed1-x52e.google.com (mail-ed1-x52e.google.com [IPv6:2a00:1450:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 67895C0698C5;
        Mon, 16 Aug 2021 06:22:13 -0700 (PDT)
Received: by mail-ed1-x52e.google.com with SMTP id b7so26462976edu.3;
        Mon, 16 Aug 2021 06:22:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ASKfOUpZVAKtKzShqT3td46CJv+FH9BqYMNcktsexHo=;
        b=IcBlsysZ3ws214IXTNUrCb+4+DCBm2SCE3c2JJUL51h6dJBKF7Ula8/ob58WJ2k0Cy
         FEZGtmG1NZYmGAts9FtG2XE/HJ9M843p4t4PU60ERpqzs4zwSqYWgN2XuMd+ihWFP/yv
         rGHOO9ST32fto7q/TQRueLCBGLMF3huT1BD3tFRwsnzyBrU3vTQ571+4kDHGPVkBwrVw
         +912H8BxXAm1Vyc1ojbRdp3xiIWUBKeJF4A1z7yDucdj/IHJWLX2lwCvi1UlkXT/qsRj
         DFg5w+st1jy8gPlwybQpWDfgZVk27vmOxuG/qT3AVWfIE2wfqqx/NjJJcZ+L0esWgr1B
         oeuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ASKfOUpZVAKtKzShqT3td46CJv+FH9BqYMNcktsexHo=;
        b=rCaYeE4nT2Pf2vOeXOgFiaM9nnrWYxjhpAU2Kfpa57Vthn07hmgOFewrsTy7UPq9ok
         i2TbV/tgU1lrxtCeP/UWTYooKMbAX3fkNejlZYWKt4gTupQaDAQm4EVGQzDD+8XPw7KC
         +c5IokUJh7Vb79j0GHoW0AWFPk2PkohiG7VO39LL5zjlnMkL9vXvxzu+IG7IYE71KJi4
         NtNYyhmJ1gbJOZrUCrDE1RLY7nCVxkCjYK/4VKtlPb22R+STTA+iUkJj+MEDuf4/bkK+
         XG1YBfQ7V7hylVapjRe+bC8wwZ95WhfuJg26Dz7OmG8e4AY8c1GR5RtdekYoXvzDqj0F
         DxcA==
X-Gm-Message-State: AOAM530U/94yHHlGBFyq/GQC3GvCD8Olf9gtk4aAqCX8gluplCpDFy33
        sVxJOHUtYR2P+YW9xNv1mWPTFie7MfXYD9Q+5CkkwlngyOTnwsCk
X-Google-Smtp-Source: ABdhPJx//v0XFjAw696+fxHOjjII7EueTho7mjMVcewyNR038dnvShSmcCCRNZTFY7RXYVxbYyXC1TDmTnk3eFMRwfE=
X-Received: by 2002:a05:6402:288b:: with SMTP id eg11mr20341402edb.241.1629120131918;
 Mon, 16 Aug 2021 06:22:11 -0700 (PDT)
MIME-Version: 1.0
References: <20210803063149.2821093-1-mudongliangabcd@gmail.com>
 <20210812100437.GA5055@gondor.apana.org.au> <CAD-N9QWGgBBddi5kwTNANKVVdWaQRwagMHvaH592B5GDALpBrg@mail.gmail.com>
 <20210812102954.GA5569@gondor.apana.org.au> <CAD-N9QU6r-yLBvJUpV+xy4pgOFnrtquBymthG7k5ddHt20APzg@mail.gmail.com>
 <20210812104318.GA5780@gondor.apana.org.au>
In-Reply-To: <20210812104318.GA5780@gondor.apana.org.au>
From:   Dongliang Mu <mudongliangabcd@gmail.com>
Date:   Mon, 16 Aug 2021 21:21:45 +0800
Message-ID: <CAD-N9QVz3W1E0D4i9iVTpkHVaB_Y9u1_HK2VW+FoQKJ9H8krrA@mail.gmail.com>
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

On Thu, Aug 12, 2021 at 6:43 PM Herbert Xu <herbert@gondor.apana.org.au> wrote:
>
> On Thu, Aug 12, 2021 at 06:40:20PM +0800, Dongliang Mu wrote:
> >
> > I agree with you and would like to modify "return 0" to "return err"
> > in the next version.  Even if the parent function does not care about
> > the return value, it is still necessary to keep the right return
> > value.
>
> Well if the parent is ignoring the error then returning the error
> there obviously isn't going to help.

If so, do I still need to change my current patch?

Dongliang Mu

>
> Cheers,
> --
> Email: Herbert Xu <herbert@gondor.apana.org.au>
> Home Page: http://gondor.apana.org.au/~herbert/
> PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
