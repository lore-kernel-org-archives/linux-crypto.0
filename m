Return-Path: <SRS0=pw/0=7L=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F0D55C433E1
	for <linux-crypto@archiver.kernel.org>; Fri, 29 May 2020 08:20:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CB02D20810
	for <linux-crypto@archiver.kernel.org>; Fri, 29 May 2020 08:20:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1590740440;
	bh=JTAYp8cwsGEAWE/e9SeXZyS0wQGEvpQa7xc0cDYqMzo=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:List-ID:From;
	b=wkgvQVkMMn+MCQXmqrs8c7xPaTFM0EmD7YnppDZHS3sttgeJpwEd4JiQw/cGltjY7
	 6nEcoJlHtN0jT8yHgNjw5QYqbT1ywQ+0kMZXztckwnyoLuQaOVuYpb4TBgQvMd5H3U
	 VVJ4eUYmc4lD0BIFEWGcapRufzNbp8rrbqVWi2+k=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726235AbgE2IUk (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 29 May 2020 04:20:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:42922 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725821AbgE2IUj (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 29 May 2020 04:20:39 -0400
Received: from mail-io1-f41.google.com (mail-io1-f41.google.com [209.85.166.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 817332065C
        for <linux-crypto@vger.kernel.org>; Fri, 29 May 2020 08:20:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1590740439;
        bh=JTAYp8cwsGEAWE/e9SeXZyS0wQGEvpQa7xc0cDYqMzo=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=tI1pkgNHylSXYyP4Dq0XRQzI8TJxq9EMFzKJZyby995N4XPSKTYq9Q3RkdIwhCA9l
         myou2+EXU5m85yc2EAkgle5hLlgfB4P2YThMIlchNRf3IPZxy93sfI5FZJ35k6ZtYy
         c+YlhP2J+lZHR/kj1cPUYeWwAzrOf4E8jbuQS5gc=
Received: by mail-io1-f41.google.com with SMTP id y5so1394305iob.12
        for <linux-crypto@vger.kernel.org>; Fri, 29 May 2020 01:20:39 -0700 (PDT)
X-Gm-Message-State: AOAM530LX9ejBvnCvleu0tXL5r88mrZGPnlkwSdSAfDsNydx/Eh4qF25
        jcUezmePPNYupIefpsl7OPMm6cXKimpQlBT+qxs=
X-Google-Smtp-Source: ABdhPJyCSIQExnvtGY4/9BZN6drHOpsFdJFI8IINpxyV3I+gPfPkhnq8dRBBRDIk3aoiXN/yzFLRk7IbCr9rkg/HpIU=
X-Received: by 2002:a6b:5b02:: with SMTP id v2mr5660075ioh.161.1590740438929;
 Fri, 29 May 2020 01:20:38 -0700 (PDT)
MIME-Version: 1.0
References: <20200519190211.76855-1-ardb@kernel.org> <20200528073349.GA32566@gondor.apana.org.au>
 <CAMj1kXGkvLP1YnDimdLOM6xMXSQKXPKCEBGRCGBRsWKAQR5Stg@mail.gmail.com> <20200529080508.GA2880@gondor.apana.org.au>
In-Reply-To: <20200529080508.GA2880@gondor.apana.org.au>
From:   Ard Biesheuvel <ardb@kernel.org>
Date:   Fri, 29 May 2020 10:20:27 +0200
X-Gmail-Original-Message-ID: <CAMj1kXE43VvEXyYQF=s5HybhF6Wq23wDTrvTfNV9d4fUVZZ8aw@mail.gmail.com>
Message-ID: <CAMj1kXE43VvEXyYQF=s5HybhF6Wq23wDTrvTfNV9d4fUVZZ8aw@mail.gmail.com>
Subject: Re: [RFC/RFT PATCH 0/2] crypto: add CTS output IVs for arm64 and testmgr
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        Eric Biggers <ebiggers@kernel.org>,
        Stephan Mueller <smueller@chronox.de>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, 29 May 2020 at 10:05, Herbert Xu <herbert@gondor.apana.org.au> wrote:
>
> On Thu, May 28, 2020 at 10:33:25AM +0200, Ard Biesheuvel wrote:
> >
> > The reason we return output IVs for CBC is because our generic
> > implementation of CTS can wrap any CBC implementation, and relies on
> > this output IV rather than grabbing it from the ciphertext directly
> > (which may be tricky and is best left up to the CBC code)
>
> No that's not the main reason.  The main user of chaining is
> algif_skcipher.
>

But many implementation do not return an output IV at all. The only
mode that requires it (for the selftests to pass) is CBC.

> > So if you are saying that we should never split up algif_skcipher
> > requests into multiple calls into the underlying skcipher, then I
> > agree with you. Even if the generic CTS seems to work more or less as
> > expected by, e.g., the NIST validation tool, this is unspecified
> > behavior, and definitely broken in various other places.
>
> I was merely suggesting that requests to CTS/XTS shouldn't be
> split up.  Doing it for others would be a serious regression.
>

Given that in these cases, doing so will give incorrect results even
if the input size is a whole multiple of the block size, I agree that
adding this restriction will not break anything that is working
consistently at the moment.

But could you elaborate on the serious regression for other cases? Do
you have anything particular in mind?

> However, having looked at this it would seem that the effort
> in marking CTS/XTS is not that different to just adding support
> to hold the last two blocks of data so that CTS/XTS can support
> chaining.
>

For XTS, we would have to carry some metadata around that tells you
whether the initial encryption of the IV has occurred or not. In the
CTS case, you need two swap the last two blocks of ciphertext at the
very end.

So does that mean some kind of init/update/final model for skcipher? I
can see how that could address these issues (init() would encrypt the
IV for XTS, and final() would do the final block handling for CTS).
Just holding two blocks of data does not seem sufficient to me to
handle these issues.
