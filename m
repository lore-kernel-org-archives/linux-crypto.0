Return-Path: <SRS0=t+Y3=BH=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8A45CC433E1
	for <linux-crypto@archiver.kernel.org>; Tue, 28 Jul 2020 17:46:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 627EC2070B
	for <linux-crypto@archiver.kernel.org>; Tue, 28 Jul 2020 17:46:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1595958415;
	bh=Bfx1WpjRVNiQcOtSUmTxtcAcwW1gsSDGWHXmqoz5zUw=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:List-ID:From;
	b=hUAITzUhYiXCMXnYD8k6uEThxHxS2+3IMbtlcQzwUnpMqkBwyQ6I2soMhGCUVnqao
	 0uN+24oKBZmFwkpLH4CNI6BjnNzPg1tWGARrAllIYtbCbXI1FM4LnbsleXSwV3QdSE
	 y6geY+KUQdRW7uV9Dc8xFbPxLlj+C8BFDpnahHxw=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728362AbgG1Rqz (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 28 Jul 2020 13:46:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:53030 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728163AbgG1Rqy (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 28 Jul 2020 13:46:54 -0400
Received: from mail-ot1-f41.google.com (mail-ot1-f41.google.com [209.85.210.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1469C2070B
        for <linux-crypto@vger.kernel.org>; Tue, 28 Jul 2020 17:46:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595958414;
        bh=Bfx1WpjRVNiQcOtSUmTxtcAcwW1gsSDGWHXmqoz5zUw=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=qvruHbYNvoHAyqfFc1TAPJyPPoqxFv86JulAjnRdJQf+nQ/NLtPm5GqxmcYh4u5cA
         D6vaUZcHgZfI1M4pYei3m5x3VfRQB2I5xdngwAPgE4U8uif8t9KkOUQFpDmY4Mp2ww
         BxvA4ko87RJQAdXbRdvJeA41m/R3m1zgZTXvpSRs=
Received: by mail-ot1-f41.google.com with SMTP id t18so15511332otq.5
        for <linux-crypto@vger.kernel.org>; Tue, 28 Jul 2020 10:46:54 -0700 (PDT)
X-Gm-Message-State: AOAM533ckcJSeQ3I7mOjODE7q8iFYGNR3IFYr4ItpwKSy1mI5MPmMKQF
        cb1aVmOSA+K8QJ8o0Lj68PBni4zGfoYRWlkPCHM=
X-Google-Smtp-Source: ABdhPJzUwgb2T1oUWc4QL5oACLSHulTWm6BPakGYAznQXE5ctqjMz+JUNBk1J95uuO/K7vouZMK5mg089ITDEBcKSnM=
X-Received: by 2002:a9d:3b23:: with SMTP id z32mr7875601otb.77.1595958413451;
 Tue, 28 Jul 2020 10:46:53 -0700 (PDT)
MIME-Version: 1.0
References: <20200728071746.GA22352@gondor.apana.org.au> <E1k0Jsl-0006Ho-Gf@fornost.hmeau.com>
 <20200728171512.GB4053562@gmail.com> <20200728172239.GA3539@gondor.apana.org.au>
 <CAMj1kXEGPFeqW2LYCAPHBkR_ruUTnV7AbX7yHgytkRoTfj5Msw@mail.gmail.com> <20200728173009.GA3620@gondor.apana.org.au>
In-Reply-To: <20200728173009.GA3620@gondor.apana.org.au>
From:   Ard Biesheuvel <ardb@kernel.org>
Date:   Tue, 28 Jul 2020 20:46:42 +0300
X-Gmail-Original-Message-ID: <CAMj1kXE+GsPUfQ0zd9Lc_eb-AQBUVu=OGR4nJsWZ6myOVVT+Ng@mail.gmail.com>
Message-ID: <CAMj1kXE+GsPUfQ0zd9Lc_eb-AQBUVu=OGR4nJsWZ6myOVVT+Ng@mail.gmail.com>
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

On Tue, 28 Jul 2020 at 20:30, Herbert Xu <herbert@gondor.apana.org.au> wrote:
>
> On Tue, Jul 28, 2020 at 08:26:38PM +0300, Ard Biesheuvel wrote:
> >
> > So how does one allocate a tfm that supports chaining if their use
> > case requires it? Having different implementations of the same algo
> > where one does support it while the other one doesn't means we will
> > need some flag to request this at alloc time.
>
> Yes we could add a flag for it.  However, for the two users that
> I'm looking at right now (algif_skcipher and sunrpc) this is not
> required.  For algif_skcipher it'll simply fall back to the current
> behaviour if chaining is not supported, while sunrpc would only
> use chaining with cts where it is always supported.
>

Ok, now I'm confused again: if falling back to the current behavior is
acceptable for algif_skcipher, why do we need all these changes?


> Cheers,
> --
> Email: Herbert Xu <herbert@gondor.apana.org.au>
> Home Page: http://gondor.apana.org.au/~herbert/
> PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
