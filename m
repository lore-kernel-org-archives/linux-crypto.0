Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DD8EBC433EF
	for <linux-crypto@archiver.kernel.org>; Tue, 16 Nov 2021 14:42:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C1FC163219
	for <linux-crypto@archiver.kernel.org>; Tue, 16 Nov 2021 14:42:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237701AbhKPOpB (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 16 Nov 2021 09:45:01 -0500
Received: from mail.kernel.org ([198.145.29.99]:47308 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237777AbhKPOoK (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 16 Nov 2021 09:44:10 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 210E46323D;
        Tue, 16 Nov 2021 14:41:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637073673;
        bh=BI3DXbE9gpfIqWL9BnbaNZ6E/Bn4OUk2FHNYGVBobTk=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=TrvFSCcMyTIR9IVO+ThXMrw0tcoffWYWpf8myCun9FASehWutNb10MQ+3WMjGLM/M
         zfY5FGVJTlE38W0ko3zcTDyujAjvyyj5MCTi7ylgWp+F9HEFoMwUSyV+LNxCjgodq2
         Z7mZ9KHIt3W8feRD9nZ5zHEkuT57rWzyZBDxh170wVA4KhvnnXsd0MzDFXSbvT/U5Z
         Ew54jUQAx6AAwhxNxTQqYpPspXnrvSr4915YbGoiyDhm+iBs/7q7VRvAVOMHL3+U8D
         X9xlejw09rBzZ7MikbKxcblj6WtV20RYxktX/h8dErc0M9UIZij4uSOid1OGFY44HW
         l2y7cZoAF3/PA==
Received: by mail-ot1-f42.google.com with SMTP id u18-20020a9d7212000000b00560cb1dc10bso33810457otj.11;
        Tue, 16 Nov 2021 06:41:13 -0800 (PST)
X-Gm-Message-State: AOAM530HLwUC7wa1rKwZS9E3xh6BQAbtn5GZHhDGhU/cr0LdFtNoLgy0
        tI2ChKtSuKHxAEuRs2pt+PraYAFp91d7/6YHN2k=
X-Google-Smtp-Source: ABdhPJyz182iVRGs2o144bv5JsNE7qgZa+kRxcT3JaTqZi5BX2Ugif7IVqr45uC7Ts3OoFdaw6xmJmhcM99DAzDQNNM=
X-Received: by 2002:a9d:6c54:: with SMTP id g20mr6710255otq.30.1637073672398;
 Tue, 16 Nov 2021 06:41:12 -0800 (PST)
MIME-Version: 1.0
References: <CACXcFmkO0g2YRjvfknKXr_ZnJaMg2cpvOsLq=h1ZcB=hg9NK8w@mail.gmail.com>
In-Reply-To: <CACXcFmkO0g2YRjvfknKXr_ZnJaMg2cpvOsLq=h1ZcB=hg9NK8w@mail.gmail.com>
From:   Ard Biesheuvel <ardb@kernel.org>
Date:   Tue, 16 Nov 2021 15:41:00 +0100
X-Gmail-Original-Message-ID: <CAMj1kXE5rZdUoNd4vqXDCuNbHuwapnxskU1pabQax4LVvUWxgg@mail.gmail.com>
Message-ID: <CAMj1kXE5rZdUoNd4vqXDCuNbHuwapnxskU1pabQax4LVvUWxgg@mail.gmail.com>
Subject: Re: [PATCH 0/8] memset() in crypto code
To:     Sandy Harris <sandyinchina@gmail.com>
Cc:     LKML <linux-kernel@vger.kernel.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, 16 Nov 2021 at 12:20, Sandy Harris <sandyinchina@gmail.com> wrote:
>
> Fairly often we want to clear some memory in crypto code; it holds
> things we are done using and do not want to leave lying around where
> an enemy might discover them. Typical examples are crypto keys or
> random numbers we have generated and used for output.
>
> The obvious way to do this is with memset(address,0,bytes) but there
> is a problem with that; because we are done using that memory, the
> compiler may optimise away the "useless" memset() call. Using
> memzero_explicit(address,bytes) instead solves the problem; that
> function is designed to resist the optimisation.
>
> There are well over 100 memset() calls in .c files in the crypto and
> security directories. I looked at them all and found about a dozen in
> eight files that I thought should be changed to memzero_explicit().
> Here they are as patches 1 to 8 in this series.
>
> I did read some code & think moderately carefully, but I do not know
> the code deeply & it is possible I have made some errors. I think
> false positives (making unnecessary changes) are more likely than
> false negatives (not catching necessary changes).

Hello Sandy,

As Greg alluded in reply to one of these patches, memzero_explicit()
is only usually needed for stack variables, because in those cases,
the compiler is able to infer that the memset() is the last thing that
touches the variable before it goes out of scope, and so memset()ing
it can be omitted.

Variables that are passed into a function by pointer reference have a
life time that is not known to the callee, and so there is no way the
compiler can elide memset() calls, which means that using
memzero_explicit() in such cases is not needed. The exception is
functions with static linkage that may end up being inlined into their
callers, but in the crypto subsystem, many such functions are invoked
indirectly via exported function pointers, which makes inlining
impossible.
