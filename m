Return-Path: <SRS0=Ym9l=UQ=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 99337C31E50
	for <linux-crypto@archiver.kernel.org>; Mon, 17 Jun 2019 13:59:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6E67E2080C
	for <linux-crypto@archiver.kernel.org>; Mon, 17 Jun 2019 13:59:14 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="bfmCe5Zv"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726822AbfFQN7N (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 17 Jun 2019 09:59:13 -0400
Received: from mail-io1-f65.google.com ([209.85.166.65]:45161 "EHLO
        mail-io1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726489AbfFQN7N (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 17 Jun 2019 09:59:13 -0400
Received: by mail-io1-f65.google.com with SMTP id e3so21240494ioc.12
        for <linux-crypto@vger.kernel.org>; Mon, 17 Jun 2019 06:59:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Ds0uKO2F2VBQKsr2RusLC1lcJKUY+GVXGb2P0niujFc=;
        b=bfmCe5ZvpsbrhWXibP60qlo99R0zU6tV2L2MvNrbM4MncYm4LfPSlrM3ayQ5VzFPEz
         lZiFIdCduTD0iR4PDFOUA6MAbuVQh3ofZ9rToV3LJvfAFGteuaOCPH6MTHR8rTkR3n23
         2IHycpR+EErC2r8W8wLritKg/M98M6GQ+9AzMxiFhLXY41cWxfzQ/X6hTCqTaPZNRcma
         sioi3EDB8jjCW7DPhXK10DUzMLKJQst2Pi8ZXq5lMrrblOUJaDS2+U7Q2zDjfLe9ABNh
         Jp0W8D98pOVi+V+5MFDFp9YP/aMw1l8+zUPy4Ay7/uBlmSrzuxcqmGbL6mg8XBlMKZAB
         rYVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Ds0uKO2F2VBQKsr2RusLC1lcJKUY+GVXGb2P0niujFc=;
        b=luM+rBFdX7geDY82yrUBL6AK8lSfWDxL6l7pBPBvC1OdRsNKww1UE1KMZSWJvEdJ6V
         touxnb7spmspTHyGMoUktk8n0rRTqqWU9z8uZluJT95VDyDzdnmDkcC7HLAgKnMlqHTr
         cBxpjJkoxNDQsqmzNRG3/Jdt5KFj08Hq3hLYzGFnKM9mfOsRvZp/UdON3YXW/nXqcPMb
         9PJyl16lTA/cJ7bAqxpBUROXKQVe5KVkOgx620NcAN2TyOR8tl68H7CYXIyq2tgsj8yW
         3wcRf3oLtw0LVkJpWC31uPQEIUbV671DUYILklc94lCcO8sGNTj/XdFaTJcUocbTVzZt
         pYkw==
X-Gm-Message-State: APjAAAXErTu59M4ocbFNGHBd1/u+ZbR+/vxr/QkYj9mtXxwpCmK0cerS
        zqtZzFunfpLPPxNK4Y1Byx0tVnyS6wsAIErGI5eF8Q==
X-Google-Smtp-Source: APXvYqw8Dm5Maf3dh0eDaPaNRRb4D5ZIJAbg4W7ou2HnqLUzQVCO4UcSCR6xwjeLaf2UN5zBb8rssHpaAwMF+VCUSVA=
X-Received: by 2002:a6b:7312:: with SMTP id e18mr562668ioh.156.1560779952486;
 Mon, 17 Jun 2019 06:59:12 -0700 (PDT)
MIME-Version: 1.0
References: <20190614083404.20514-1-ard.biesheuvel@linaro.org>
 <20190616204419.GE923@sol.localdomain> <CAOtvUMf86_TGYLoAHWuRW0Jz2=cXbHHJnAsZhEvy6SpSp_xgOQ@mail.gmail.com>
 <CAKv+Gu_r_WXf2y=FVYHL-T8gFSV6e4TmGkLNJ-cw6UjK_s=A=g@mail.gmail.com>
 <8e58230a-cf0e-5a81-886b-6aa72a8e5265@gmail.com> <CAKv+Gu9sb0t6EC=MwVfqTw5TKtatK-c8k3ryNUhV8O0876NV7g@mail.gmail.com>
In-Reply-To: <CAKv+Gu9sb0t6EC=MwVfqTw5TKtatK-c8k3ryNUhV8O0876NV7g@mail.gmail.com>
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date:   Mon, 17 Jun 2019 15:59:01 +0200
Message-ID: <CAKv+Gu-LFShLW-Tt7hwBpni1vQRvv7k+L_bpP-wU86x88v+eRg@mail.gmail.com>
Subject: Re: [RFC PATCH 0/3] crypto: switch to shash for ESSIV generation
To:     Milan Broz <gmazyland@gmail.com>
Cc:     Gilad Ben-Yossef <gilad@benyossef.com>,
        Eric Biggers <ebiggers@kernel.org>,
        device-mapper development <dm-devel@redhat.com>,
        linux-fscrypt@vger.kernel.org,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, 17 Jun 2019 at 12:58, Ard Biesheuvel <ard.biesheuvel@linaro.org> wrote:
>
> On Mon, 17 Jun 2019 at 12:39, Milan Broz <gmazyland@gmail.com> wrote:
> >
> > On 17/06/2019 11:15, Ard Biesheuvel wrote:
> > >> I will also add that going the skcipher route rather than shash will
> > >> allow hardware tfm providers like CryptoCell that can do the ESSIV
> > >> part in hardware implement that as a single API call and/or hardware
> > >> invocation flow.
> > >> For those system that benefit from hardware providers this can be beneficial.
> > >>
> > >
> > > Ah yes, thanks for reminding me. There was some debate in the past
> > > about this, but I don't remember the details.
> > >
> > > I think implementing essiv() as a skcipher template is indeed going to
> > > be the best approach, I will look into that.
> >
> > For ESSIV (that is de-facto standard now), I think there is no problem
> > to move it to crypto API.
> >
> > The problem is with some other IV generators in dm-crypt.
> >
> > Some do a lot of more work than just IV (it is hackish, it can modify data, this applies
> > for loop AES "lmk" and compatible TrueCrypt "tcw" IV implementations).
> >
> > For these I would strongly say it should remain "hacked" inside dm-crypt only
> > (it is unusable for anything else than disk encryption and should not be visible outside).
> >
> > Moreover, it is purely legacy code - we provide it for users can access old systems only.
> >
> > If you end with rewriting all IVs as templates, I think it is not a good idea.
> >
> > If it is only about ESSIV, and patch for dm-crypt is simple, it is a reasonable approach.
> >
> > (The same applies for simple dmcryp IVs like "plain" "plain64", "plain64be and "benbi" that
> > are just linear IVs in various encoded variants.)
> >
>
> Agreed.
>
> I am mostly only interested in ensuring that the bare 'cipher'
> interface is no longer used outside of the crypto subsystem itself.
> Since ESSIV is the only one using that, ESSIV is the only one I intend
> to change.

OK, so inferring the block cipher name from the skcipher algo name is
a bit finicky, since the dm-crypt code does that *after* allocating
the TFMs, and allocating the essiv skcipher happens before.
But more importantly, it appears to be allowed currently to use ESSIV
with authenticated modes, which means we'd need both a skcipher and a
aead essiv template, or do some non-trivial hacking to insert the
essiv template in the right place (which I'm not sure is even
possible)

So my main question/showstopper at the moment is: which modes do we
need to support for ESSIV? Only CBC? Any skcipher? Or both skciphers
and AEADs?
