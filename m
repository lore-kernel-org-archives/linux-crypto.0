Return-Path: <SRS0=t+Y3=BH=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 21455C433E1
	for <linux-crypto@archiver.kernel.org>; Tue, 28 Jul 2020 17:26:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 024E72078E
	for <linux-crypto@archiver.kernel.org>; Tue, 28 Jul 2020 17:26:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1595957212;
	bh=hN6WBOxvWaask2wy1x5RArrBUz8OmGFmyQnzEt2dIvY=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:List-ID:From;
	b=w1LSg9qfhfKipcfNW8Wqf58hLAB+In56RYI6HgR2Ef3A9rfI0aiAtT+veVcaHRRXI
	 51y6Wd9sx5W57qQZFDfIFkBeKCr0g5wQ/JyhAV00VYg9QcuYUPuo0/L2Cb7SIg2UX/
	 2OpI9AUY6Xk3PE89x43TDT6PsiI8dMWWOU9ZvvxE=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731826AbgG1R0v (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 28 Jul 2020 13:26:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:42982 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731684AbgG1R0v (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 28 Jul 2020 13:26:51 -0400
Received: from mail-ot1-f49.google.com (mail-ot1-f49.google.com [209.85.210.49])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 641F62078E
        for <linux-crypto@vger.kernel.org>; Tue, 28 Jul 2020 17:26:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595957210;
        bh=hN6WBOxvWaask2wy1x5RArrBUz8OmGFmyQnzEt2dIvY=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=eqHh+iFC0JGhZS+A2ubHmifvDxn8+fbH71Uc8nwgmOq5nh4jsIbVtXxApWZ077fmf
         ylNCkUo7H+eLoN/w5nc3j5xOKsL/mIgUdzE56ofARGqdomjnHDvhfX9s+S5J2xhaRz
         GH9Vv9a7sA9DeRZAJsVmogryM2AeqCM9ToJ2lfFg=
Received: by mail-ot1-f49.google.com with SMTP id a65so6285397otc.8
        for <linux-crypto@vger.kernel.org>; Tue, 28 Jul 2020 10:26:50 -0700 (PDT)
X-Gm-Message-State: AOAM533QJ4Xx3/7UN/G5ClR7QV8c7Jb/kWjNMjNvux4BSginLxTL91jA
        xzjvuL0h2WozuxQv6SLlR4nhPP8V53HqVTzfZUI=
X-Google-Smtp-Source: ABdhPJyPJOzDFRKpT0TP4/NrlGd+JMHJBR4ky3+28Musqkc3f71VYL5MX8/1eu0yDMgjUle1GhLcxtiX2mZqqa6ePKk=
X-Received: by 2002:a05:6830:1094:: with SMTP id y20mr13320496oto.90.1595957209764;
 Tue, 28 Jul 2020 10:26:49 -0700 (PDT)
MIME-Version: 1.0
References: <20200728071746.GA22352@gondor.apana.org.au> <E1k0Jsl-0006Ho-Gf@fornost.hmeau.com>
 <20200728171512.GB4053562@gmail.com> <20200728172239.GA3539@gondor.apana.org.au>
In-Reply-To: <20200728172239.GA3539@gondor.apana.org.au>
From:   Ard Biesheuvel <ardb@kernel.org>
Date:   Tue, 28 Jul 2020 20:26:38 +0300
X-Gmail-Original-Message-ID: <CAMj1kXEGPFeqW2LYCAPHBkR_ruUTnV7AbX7yHgytkRoTfj5Msw@mail.gmail.com>
Message-ID: <CAMj1kXEGPFeqW2LYCAPHBkR_ruUTnV7AbX7yHgytkRoTfj5Msw@mail.gmail.com>
Subject: Re: [v3 PATCH 1/31] crypto: skcipher - Add final chunk size field for chaining
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     Eric Biggers <ebiggers@kernel.org>,
        Stephan Mueller <smueller@chronox.de>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, 28 Jul 2020 at 20:22, Herbert Xu <herbert@gondor.apana.org.au> wrote:
>
> On Tue, Jul 28, 2020 at 10:15:12AM -0700, Eric Biggers wrote:
> >
> > Shouldn't chaining be disabled by default?  This is inviting bugs where drivers
> > don't implement chaining, but leave final_chunksize unset (0) which apparently
> > indicates that chaining is supported.
>
> I've gone through everything and the majority of algorithms do
> support chaining so I think defaulting to on makes more sense.
>
> For now we have some algorithms that can be chained but the drivers
> do not allow it, this is not something that I'd like to see in
> new drivers.
>

So how does one allocate a tfm that supports chaining if their use
case requires it? Having different implementations of the same algo
where one does support it while the other one doesn't means we will
need some flag to request this at alloc time.


> Cheers,
> --
> Email: Herbert Xu <herbert@gondor.apana.org.au>
> Home Page: http://gondor.apana.org.au/~herbert/
> PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
