Return-Path: <SRS0=sRio=6G=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A8834C5518B
	for <linux-crypto@archiver.kernel.org>; Wed, 22 Apr 2020 07:39:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 871B12076C
	for <linux-crypto@archiver.kernel.org>; Wed, 22 Apr 2020 07:39:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1587541173;
	bh=RnDWO7dM9txe51VHGs0QOaPAEq5owpW0a53Byz4Aryg=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:List-ID:From;
	b=vEDXlYbAH6WjSc+aWwijsU09WlQ3JJj0srEiEc5CfEGfAsnyVyXS+ehFXIP7d5bJE
	 2AYDAana+OztEEueGkqiUStZVg/d2FAzsiOTzAVX+cJlM4deu4XjJliISl7Z9QQK50
	 IwRnwZIpCsMTaegWuC6zauJBXHfTqLleNcs1F604=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726576AbgDVHjc (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 22 Apr 2020 03:39:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:60084 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726523AbgDVHjc (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 22 Apr 2020 03:39:32 -0400
Received: from mail-io1-f48.google.com (mail-io1-f48.google.com [209.85.166.48])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 62E93206A2;
        Wed, 22 Apr 2020 07:39:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587541171;
        bh=RnDWO7dM9txe51VHGs0QOaPAEq5owpW0a53Byz4Aryg=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=xdLaHAs4ifiovQ8cW9ySsd/SFz/w+PrIrbKhZxCqsVRwP5UCLCbNf4P9lh8AUroot
         G0wDca7ZKtVUu4GoRM/QsyDH5gNgA2rqn178igYJSEAF1DvagLLZn04fsq7tSXejHK
         fpMahL8DQaVY9m3ATQFwqa6/STDJHDmgok6EtmEI=
Received: by mail-io1-f48.google.com with SMTP id e9so1297397iok.9;
        Wed, 22 Apr 2020 00:39:31 -0700 (PDT)
X-Gm-Message-State: AGi0PuYJUL673sXcLZdw+1BHonfqviPtd9fUFVZMB2t7gVrzeTkWux8z
        Q4J8E67X7DjBd4hj9okOV6ZBbaQa6FB4Q6njNtg=
X-Google-Smtp-Source: APiQypIOD3MLCJCWegGwFiasQHrx/Z50Nx7XZRqMk6mTr0/9I4V/gRZuKtyrEjBB3TxLoITpe4F/M+bgvZaWUlhlq3M=
X-Received: by 2002:a02:7785:: with SMTP id g127mr23633017jac.134.1587541170836;
 Wed, 22 Apr 2020 00:39:30 -0700 (PDT)
MIME-Version: 1.0
References: <20200420075711.2385190-1-Jason@zx2c4.com> <20200422040415.GA2881@sol.localdomain>
 <CAHmME9q=hMRjBG=SBX8gCC3qx-t1wdEwMOYx952m9HkByjiofA@mail.gmail.com>
In-Reply-To: <CAHmME9q=hMRjBG=SBX8gCC3qx-t1wdEwMOYx952m9HkByjiofA@mail.gmail.com>
From:   Ard Biesheuvel <ardb@kernel.org>
Date:   Wed, 22 Apr 2020 09:39:19 +0200
X-Gmail-Original-Message-ID: <CAMj1kXE-UZxw0C3WRVh7RfuWE0BNDT4bt4qJa1SyOH3K-qBBcQ@mail.gmail.com>
Message-ID: <CAMj1kXE-UZxw0C3WRVh7RfuWE0BNDT4bt4qJa1SyOH3K-qBBcQ@mail.gmail.com>
Subject: Re: [PATCH crypto-stable] crypto: arch/lib - limit simd usage to
 PAGE_SIZE chunks
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc:     Eric Biggers <ebiggers@kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, 22 Apr 2020 at 09:32, Jason A. Donenfeld <Jason@zx2c4.com> wrote:
>
> On Tue, Apr 21, 2020 at 10:04 PM Eric Biggers <ebiggers@kernel.org> wrote:
> > Seems this should just be a 'while' loop?
> >
> >         while (bytes) {
> >                 unsigned int todo = min_t(unsigned int, PAGE_SIZE, bytes);
> >
> >                 kernel_neon_begin();
> >                 chacha_doneon(state, dst, src, todo, nrounds);
> >                 kernel_neon_end();
> >
> >                 bytes -= todo;
> >                 src += todo;
> >                 dst += todo;
> >         }
>
> The for(;;) is how it's done elsewhere in the kernel (that this patch
> doesn't touch), because then we can break out of the loop before
> having to increment src and dst unnecessarily. Likely a pointless
> optimization as probably the compiler can figure out how to avoid
> that. But maybe it can't. If you have a strong preference, I can
> reactor everything to use `while (bytes)`, but if you don't care,
> let's keep this as-is. Opinion?
>

Since we're bikeshedding, I'd prefer 'do { } while (bytes);' here,
given that bytes is guaranteed to be non-zero before we enter the
loop. But in any case, I'd prefer avoiding for(;;) or while(1) where
we can.
