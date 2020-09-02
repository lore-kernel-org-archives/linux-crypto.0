Return-Path: <SRS0=ze1v=CL=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 42D19C433E2
	for <linux-crypto@archiver.kernel.org>; Wed,  2 Sep 2020 05:50:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F017E20709
	for <linux-crypto@archiver.kernel.org>; Wed,  2 Sep 2020 05:50:49 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="GifpBOwH"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726021AbgIBFut (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 2 Sep 2020 01:50:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45692 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725774AbgIBFut (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 2 Sep 2020 01:50:49 -0400
Received: from mail-qt1-x843.google.com (mail-qt1-x843.google.com [IPv6:2607:f8b0:4864:20::843])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5DCC1C061244
        for <linux-crypto@vger.kernel.org>; Tue,  1 Sep 2020 22:50:48 -0700 (PDT)
Received: by mail-qt1-x843.google.com with SMTP id b3so2773900qtg.13
        for <linux-crypto@vger.kernel.org>; Tue, 01 Sep 2020 22:50:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=73oP7CVmC7HM5f1hMiLAI67t0jOn31cICYYdA5QwIpI=;
        b=GifpBOwHse4rZVYrs6UhJsAc7j1tGGiBI5QDE1qiGPEHn2iRs5kXs1m6LH+h1pJPtF
         Q1lKq9Us+MBikCUPQ7ZbDgSacoA8A3JDDSPWHLmJ43FcZgOUxYvhWX4ruMGwBU+w++MT
         paKghEwlBMdqeXqyfB7bNYBa4iq0LvOfZOfCj8Bzih1hQtGlqefzGMulv/0hfu39WC76
         dDDfqrwppyRpgTXpXQy1odObaEzpVy861nCicaURFzYQckjZx0TDQThD8ZbzTdR7xWLo
         0p53MvCW06dN4rW2Ko+qgmFgaLsJWyT5gZ8Kc7mhptb/ShaYthrItKNqF4rursTkmCTZ
         jF8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=73oP7CVmC7HM5f1hMiLAI67t0jOn31cICYYdA5QwIpI=;
        b=K2odSvNT9eYXpzIJjdBMaX+TcRH+cxxpKWIoOEwdQGCCj9owNde+8R94se5rfH95cd
         w9YMb06mpIiWyCohevjSiBtEWdD+7S8EqgAPZsLLRBLW61QRyMQ16PYqoxsHsyspvq/s
         XUxG19kgt7EBfU+8HbqhVUapOG/cGA71EPkuRKrT8XpR5ILJvnLAV/y46nnx9ljrX7DY
         fYF4S1VplYdNFgbdN435JOAlREnyKGx3flhwJ9KH+kf27IPY7gk/KMAlMj1nsU4J/RgO
         S0wovtRCjt9H+UAtnNTABRjLXV6++RygWCFs4xO2gXx3Ttbm937fqkwZ5JtwfmbKYaO2
         E5rA==
X-Gm-Message-State: AOAM532qAIGCDXIFw5HNK+dD4UOkZZFRR/s10yTth1/K1OGeinq61S6g
        BYKmJLJBpvRADO/ccD3ojazSBduSbZMNRWxjbOU=
X-Google-Smtp-Source: ABdhPJyknkfzDZnKac+pOfFNZY1A99bQgns80X2/ghl15fD81psfyYeoM0/6DYU62jLLZlolSgt1Cs3CpTYhSp7y2Io=
X-Received: by 2002:ac8:1667:: with SMTP id x36mr5308320qtk.51.1599025847205;
 Tue, 01 Sep 2020 22:50:47 -0700 (PDT)
MIME-Version: 1.0
References: <20200827173058.94519-1-ubizjak@gmail.com> <CAMj1kXHChRSxAgMNPpHoT-Z2CFoVQOgtmpK6tCboe1G06xuF_w@mail.gmail.com>
 <CAHmME9p3f2ofwQtc2OZ-uuM_JggJtf93nXWVkuUdqYqxB6baYg@mail.gmail.com> <CAHmME9oemtY5PG9WjbOOtd_xxbMRPb1t5mPoo2rR-y3umYKd5Q@mail.gmail.com>
In-Reply-To: <CAHmME9oemtY5PG9WjbOOtd_xxbMRPb1t5mPoo2rR-y3umYKd5Q@mail.gmail.com>
From:   Uros Bizjak <ubizjak@gmail.com>
Date:   Wed, 2 Sep 2020 07:50:36 +0200
Message-ID: <CAFULd4ZH3s=9nsvNE8Sxf=r-KZJX5NKxFehNo7YU2=2ExwbsQQ@mail.gmail.com>
Subject: Re: [PATCH] crypto/x86: Use XORL r32,32 in curve25519-x86_64.c
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc:     Karthik Bhargavan <karthikeyan.bhargavan@inria.fr>,
        Chris.Hawblitzel@microsoft.com,
        Jonathan Protzenko <protz@microsoft.com>,
        Aymeric Fromherz <fromherz@cmu.edu>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        X86 ML <x86@kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Ard Biesheuvel <ardb@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, Sep 1, 2020 at 9:12 PM Jason A. Donenfeld <Jason@zx2c4.com> wrote:
>
> On Tue, Sep 1, 2020 at 8:13 PM Jason A. Donenfeld <Jason@zx2c4.com> wrote:
> > operands are the same. Also, have you seen any measurable differences
> > when benching this? I can stick it into kbench9000 to see if you
> > haven't looked yet.
>
> On a Skylake server (Xeon Gold 5120), I'm unable to see any measurable
> difference with this, at all, no matter how much I median or mean or
> reduce noise by disabling interrupts.
>
> One thing that sticks out is that all the replacements of r8-r15 by
> their %r8d-r15d counterparts still have the REX prefix, as is
> necessary to access those registers. The only ones worth changing,
> then, are the legacy registers, and on a whole, this amounts to only
> 48 bytes of difference.

The patch implements one of x86 target specific optimizations,
performed by gcc. The optimization results in code size savings of one
byte, where REX prefix is omitted with legacy registers, but otherwise
should have no measurable runtime effect. Since gcc applies this
optimization universally to all integer registers, I took the same
approach and implemented the same change to legacy and REX registers.
As measured above, 48 bytes saved is a good result for such a trivial
optimization.

Uros.
