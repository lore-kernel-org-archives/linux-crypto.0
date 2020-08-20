Return-Path: <SRS0=QJ87=B6=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 172E6C433E1
	for <linux-crypto@archiver.kernel.org>; Thu, 20 Aug 2020 07:48:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E13252076E
	for <linux-crypto@archiver.kernel.org>; Thu, 20 Aug 2020 07:48:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1597909703;
	bh=A0df3RBaUO8Zj+0OS3pHHk3R4LI3SIQau+UpDVpRiCs=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:List-ID:From;
	b=hUh98ofkGQNaS6imqCzby9Yh+laXtHJe5k7IDHp8P3UoAQaxsiy3jy4yAPuaQ7zYm
	 R68qhVqjUaeAAUlYimuo6h7S+3IDOpZefKbl/0FhYl9Ok1WVpluiKfRMlqPqmMs5YM
	 TTLc3gjAsONNm96yehhPuRVBdJhsbSBVnHL3rMcE=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726325AbgHTHsX (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 20 Aug 2020 03:48:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:57672 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726664AbgHTHsP (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 20 Aug 2020 03:48:15 -0400
Received: from mail-ot1-f54.google.com (mail-ot1-f54.google.com [209.85.210.54])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4080D21775
        for <linux-crypto@vger.kernel.org>; Thu, 20 Aug 2020 07:48:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597909694;
        bh=A0df3RBaUO8Zj+0OS3pHHk3R4LI3SIQau+UpDVpRiCs=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=c6Q/acTi7Z+SxuPuIiSRHw4R89sDtK5RGWknQd7ROUcJ3eJaaBHv2NfS5CnGVeJsM
         Snr1W4cxJvxAKIM7RBUPcUc/I8AR7iE9Zh2SuyRF3xn4894CA22X0aSbxbNDO7DC/3
         X8rIgN2ioi4yc8nkPoIs+B75xMHJAZM2JXMScCSQ=
Received: by mail-ot1-f54.google.com with SMTP id q9so735453oth.5
        for <linux-crypto@vger.kernel.org>; Thu, 20 Aug 2020 00:48:14 -0700 (PDT)
X-Gm-Message-State: AOAM5320GPw4CjFbDGAopT91XVrAdNLFYnH5/V8PaxSH0aWxgXUuht8q
        zMsgySrBQwxjWzXYzZ67CwyaPUT9W7UeUhvVVUY=
X-Google-Smtp-Source: ABdhPJwZje/dAdbS/DAK0PVvc6lWTLr1uKAtQuGxTUPznL86k1KKNPHE0UmQyFg3HNCRTEJQHGumYL6xqralwKuBvAY=
X-Received: by 2002:a05:6830:1d8c:: with SMTP id y12mr1356962oti.77.1597909693547;
 Thu, 20 Aug 2020 00:48:13 -0700 (PDT)
MIME-Version: 1.0
References: <bee1a9ce-25d1-2520-5f6a-3966bfa501d2@candelatech.com>
 <20200818223359.GA27712@gondor.apana.org.au> <8b248ef3-d4c7-43fd-6ae4-1c3381597579@candelatech.com>
 <CAMj1kXFaQsCw_7x8NKNHfMfEC=NdWCxd7V6S3VnAFdOg+-Letg@mail.gmail.com>
 <20200820070142.GA21343@gondor.apana.org.au> <CAMj1kXEdkQUZ_d33N5T5_ELyqRomBKF8Nn+gquo7nrVBMMP-gA@mail.gmail.com>
 <20200820070645.GA21395@gondor.apana.org.au> <CAMj1kXE6QDxjNKSpzTrxe+QU0DF9CYp-W7bGe1AyFzYHOJQ41Q@mail.gmail.com>
 <20200820072910.GA21631@gondor.apana.org.au> <CAMj1kXFR2SSdE7oi6YKsWG1OvpXpo+584XSiMCSL0V-ysOMc5A@mail.gmail.com>
 <20200820074414.GA21848@gondor.apana.org.au>
In-Reply-To: <20200820074414.GA21848@gondor.apana.org.au>
From:   Ard Biesheuvel <ardb@kernel.org>
Date:   Thu, 20 Aug 2020 09:48:02 +0200
X-Gmail-Original-Message-ID: <CAMj1kXHAo8LzKZd9cuwhZzP3ikYr1Bd_zjrnBRDrAU8M=92RWQ@mail.gmail.com>
Message-ID: <CAMj1kXHAo8LzKZd9cuwhZzP3ikYr1Bd_zjrnBRDrAU8M=92RWQ@mail.gmail.com>
Subject: Re: [PATCH 0/5] crypto: Implement cmac based on cbc skcipher
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     Ben Greear <greearb@candelatech.com>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Eric Biggers <ebiggers@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, 20 Aug 2020 at 09:44, Herbert Xu <herbert@gondor.apana.org.au> wrote:
>
> On Thu, Aug 20, 2020 at 09:33:21AM +0200, Ard Biesheuvel wrote:
> >
> > > On my machine the performance difference on a 1472-byte request
> > > between SIMD and generic is 2161 vs. 7558 (cycles).
> >
> > Sure. But your machine does not have the pathological FPU
> > preserve/restore performance.
>
> Why does that matter? These are numbers for cbc-aesni which means
> just a single preserve/restore for the whole request.
>

No, that is the whole problem. The CCM template has a CBCMAC
implementation that wraps the bare cipher, which means it invokes
crypto_cipher_encrypt_one() for each 16 bytes of input, and each of
those calls involves a FPU preserve/restore.

> Or are you saying on Ben's machine cbc-aesni would have worse
> performance vs. aes-generic?
>

Yes, given the pathological overhead of FPU preserve/restore for every
block of 16 bytes processed by the cbcmac wrapper.

> > The mac80211 CCMP code uses a synchronous ccm aead, which gets backed
> > by a skcipher+ahash combo by the ccm template. So a synchronous ahash
> > is fine for this particular case.
>
> OK I was just grepping for cmac so didn't see this.
>
> For this case, I think it's even more important that it be converted
> over to async because its sending path is also in user context just
> like IPsec.
>

Indeed.

cmac() is not really relevant for performance, afaict. Only cbcmac()
is used for bulk data.

> So simply by sending wireless packets you can hog the CPU while
> doing SIMD in kernel context which would then kill the receive
> path if you're using the generic fallback.
>
> Cheers,
> --
> Email: Herbert Xu <herbert@gondor.apana.org.au>
> Home Page: http://gondor.apana.org.au/~herbert/
> PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
