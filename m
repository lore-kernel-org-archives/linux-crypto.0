Return-Path: <SRS0=pw/0=7L=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 543CEC433DF
	for <linux-crypto@archiver.kernel.org>; Fri, 29 May 2020 12:00:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 308BA20776
	for <linux-crypto@archiver.kernel.org>; Fri, 29 May 2020 12:00:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1590753628;
	bh=bx/0rENky0xYxtckxv/+DIl6VrrnMCAkBaTV2a5azo4=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:List-ID:From;
	b=uG4gTWuLDE9SdJ5d/+DLfGI0BQ4kGSQa92ziozKyvTM8lpWe3er4cORZjJ9+WXOsJ
	 2LxA3vzScCR/QHyXenycwdUE/UaeVgOLiPDZaWmYUfBcaz2aTqX4hQp7KXEl9IAas7
	 FumZPU6rMV183Ucv5+SxPPy5rxdGW3It1mRWF2es=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726161AbgE2MA1 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 29 May 2020 08:00:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:54690 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725775AbgE2MA1 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 29 May 2020 08:00:27 -0400
Received: from mail-io1-f45.google.com (mail-io1-f45.google.com [209.85.166.45])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 97E0320776
        for <linux-crypto@vger.kernel.org>; Fri, 29 May 2020 12:00:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1590753626;
        bh=bx/0rENky0xYxtckxv/+DIl6VrrnMCAkBaTV2a5azo4=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=eJ+NZH20I3Rkp0wHzZL22t35STNLvsmOaQFINjFbXP3gaxH3whA6+G4R/W2jbjdBz
         f68apPn6ou5GxsVPDYoBKE88jIZO3/GBQ78Rh0F09wUYO4T6MUKkkdc4siPnskM5/2
         XIQkwgneXPkDV5/3b63NrKvWWAbzhD29u6nuIJQ4=
Received: by mail-io1-f45.google.com with SMTP id q8so1996876iow.7
        for <linux-crypto@vger.kernel.org>; Fri, 29 May 2020 05:00:26 -0700 (PDT)
X-Gm-Message-State: AOAM531N0ia8TH8PC6INuPrIw8Z1naXs8VRYDQhogZZTyIimQZ1GeIrv
        5OETV7wmeIRKGghc2WGhbBEIiOPPz4yjrWVrTEo=
X-Google-Smtp-Source: ABdhPJzpX4auNPdZ+cI8NDL1W30V/wsHV1VShKXDqxvwqwVlVUjFyyiZ5t7YFglBVNDADKmcy1z3+W+eAuV2iewsTfQ=
X-Received: by 2002:a05:6602:2dcd:: with SMTP id l13mr6215873iow.203.1590753625984;
 Fri, 29 May 2020 05:00:25 -0700 (PDT)
MIME-Version: 1.0
References: <20200519190211.76855-1-ardb@kernel.org> <20200528073349.GA32566@gondor.apana.org.au>
 <CAMj1kXGkvLP1YnDimdLOM6xMXSQKXPKCEBGRCGBRsWKAQR5Stg@mail.gmail.com>
 <20200529080508.GA2880@gondor.apana.org.au> <CAMj1kXE43VvEXyYQF=s5HybhF6Wq23wDTrvTfNV9d4fUVZZ8aw@mail.gmail.com>
 <20200529115126.GA3573@gondor.apana.org.au>
In-Reply-To: <20200529115126.GA3573@gondor.apana.org.au>
From:   Ard Biesheuvel <ardb@kernel.org>
Date:   Fri, 29 May 2020 14:00:14 +0200
X-Gmail-Original-Message-ID: <CAMj1kXFFPKWwwSpLnPmNa_Up1syMb7T5STG7Tw8mRuRqSzc9vw@mail.gmail.com>
Message-ID: <CAMj1kXFFPKWwwSpLnPmNa_Up1syMb7T5STG7Tw8mRuRqSzc9vw@mail.gmail.com>
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

On Fri, 29 May 2020 at 13:51, Herbert Xu <herbert@gondor.apana.org.au> wrote:
>
> On Fri, May 29, 2020 at 10:20:27AM +0200, Ard Biesheuvel wrote:
> >
> > But many implementation do not return an output IV at all. The only
> > mode that requires it (for the selftests to pass) is CBC.
>
> Most modes can be chained, e.g., CBC, PCBC, OFB, CFB and CTR.
> As it stands algif_skcipher requres all algorithms to support
> chaining.
>

Even if this is the case, it requires that an skcipher implementation
stores an output IV in the buffer that skcipher request's IV field
points to. Currently, we only check whether this is the case for CBC
implementations, and so it is quite likely that lots of h/w
accelerators or arch code don't adhere to this today.


> > For XTS, we would have to carry some metadata around that tells you
> > whether the initial encryption of the IV has occurred or not. In the
>
> You're right, XTS in its current form cannot be chained.  So we
> do need a way to mark that for algif_skcipher.
>
> > CTS case, you need two swap the last two blocks of ciphertext at the
> > very end.
>
> CTS can be easily chained.  You just need to always keep two blocks
> from being processed until you reach the end.
>

This might be feasible for the generic CTS driver wrapping h/w
accelerated CBC. But how is this supposed to work, e.g., for the two
existing h/w implementations of cts(cbc(aes)) that currently ignore
this?
