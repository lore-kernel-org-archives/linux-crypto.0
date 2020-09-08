Return-Path: <SRS0=6HzI=CR=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.4 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 64725C433E2
	for <linux-crypto@archiver.kernel.org>; Tue,  8 Sep 2020 17:24:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 33237206B5
	for <linux-crypto@archiver.kernel.org>; Tue,  8 Sep 2020 17:24:05 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="BvG5P4kR"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728347AbgIHRXr (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 8 Sep 2020 13:23:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39664 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731860AbgIHRXh (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 8 Sep 2020 13:23:37 -0400
Received: from mail-il1-x143.google.com (mail-il1-x143.google.com [IPv6:2607:f8b0:4864:20::143])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C815C061573
        for <linux-crypto@vger.kernel.org>; Tue,  8 Sep 2020 10:23:37 -0700 (PDT)
Received: by mail-il1-x143.google.com with SMTP id m1so16136486ilj.10
        for <linux-crypto@vger.kernel.org>; Tue, 08 Sep 2020 10:23:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=tQgwthE20ie07HsCAy63SL8xGyWY/CUmpluNdtYksmo=;
        b=BvG5P4kR7VUz5JTKW56rDPSCOJ4bHNyvflIawe6IWBSjmiz394QJLzYkqAvvpuTeU/
         or7I+EcKzxWgw076NipX2ZihN96KFf989nTxdLtqbZoCXsnjs0gqEMiTRMCrr7eEWJF6
         Af/cIZ+nuyPNonmVEy/ZCOWvA/kVWSFVBT7ejU1gopNuJVk0UIuI8h0AT/4F/0ed7bOa
         x5W9yICdkjKJTxsXvLlPjQ6M5KsR4mksHrj0gMk2H1kTotUwLaCVe/bDlXn1omWb//2E
         iLsgHDZCq/isFi2qWHS4EKCILq45lfQ7MEeFj1PDwLCyn1oEAfhyXXMgFQK2etvqzSgr
         6Ayw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=tQgwthE20ie07HsCAy63SL8xGyWY/CUmpluNdtYksmo=;
        b=C0Y2GLDHJBsVzXbsmW0eIIxR6LxMdsbtKI1RXijnEklb0nbDF+aV3dZmw4AxIs0BEB
         E3t/gfROHYF05M/lZc2Lr4Bj7JbiiQOSpSfrL18ayP7cYCe0v5bV0BjYWEwLCkKQQoZ8
         ttzAxT74JXL+GMjidcBDYfRs4Sc4sbg/5bBIzTxHb+P4OpPDlMsk2NGZzECHbKARG7XX
         15K+YespFaOG2WpluXhg7kRVngQzfCHeUvnuMUwxhvSnp/PrvDBlmCfGnqOihNzjQGKU
         4cnEtiEjCneUyaIna1gmpLyPe1JJNQyqzMokHu4xbK7Eh8fOLkPcZsmZkqCcVMYS2GqZ
         VbMQ==
X-Gm-Message-State: AOAM531dYxpqFO8REHpdjsSpj2Y/ZvDnIzzklf14QTLm8M9SIeKySiwU
        mBMLAZ7+YabC2tmg12lEJxRDs/41pEU4NkM08AQY7Q==
X-Google-Smtp-Source: ABdhPJze1UOSuoxfUHDCYoiigznjaZSoxKSm1Zi8G6RYu5kzS0bSVOKZU7RVAERLZvKioSiM+jCk4qH9Qkg5j3T+yi4=
X-Received: by 2002:a92:de45:: with SMTP id e5mr26227633ilr.102.1599585816388;
 Tue, 08 Sep 2020 10:23:36 -0700 (PDT)
MIME-Version: 1.0
References: <20200813193239.GA2470@sol.localdomain> <20200821042443.GA25695@gondor.apana.org.au>
In-Reply-To: <20200821042443.GA25695@gondor.apana.org.au>
From:   Elena Petrova <lenaptr@google.com>
Date:   Tue, 8 Sep 2020 18:23:25 +0100
Message-ID: <CABvBcwYqeGw-9oGngEm01dAt8JLxkKCLFFn9409efcLPTsJg+w@mail.gmail.com>
Subject: Re: [PATCH v5] crypto: af_alg - add extra parameters for DRBG interface
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     Eric Biggers <ebiggers@kernel.org>,
        "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" 
        <linux-crypto@vger.kernel.org>,
        Stephan Mueller <smueller@chronox.de>,
        Ard Biesheuvel <ardb@kernel.org>,
        Jeffrey Vander Stoep <jeffv@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, 21 Aug 2020 at 05:24, Herbert Xu <herbert@gondor.apana.org.au> wrote:
>
> Eric Biggers <ebiggers@kernel.org> wrote:
> >
> > Since proto_ops are almost identical, and only one is used in a given kernel
> > build, why not just do:
> >
> > static struct proto_ops algif_rng_ops = {
> >        ...
> > #ifdef CONFIG_CRYPTO_USER_API_RNG_CAVP
> >        .sendmsg        = rng_sendmsg,
> > #else
> >        .sendmsg        = sock_no_sendmsg,
> > #endif
> >        ...
> > };
> >
> > Similarly for .recvmsg(), although I don't understand what's wrong with just
> > adding the lock_sock() instead...  The RNG algorithms do locking anyway, so it's
> > not like that would regress the ability to recvmsg() in parallel.  Also,
> > conditional locking depending on the kernel config makes it more difficult to
> > find kernel bugs like deadlocks.
>
> I want this to have minimal impact on anyone who's not using it.
> After all, this is something that only Google is asking for.
>
> Anyway, I wasn't looking for a compile-time ops switch, but a
> run-time one.
>
> I think what we can do is move the new newsock->ops assignment
> in af_alg_accept up above the type->accept call which would then
> allow it to be overridden by the accept call.
>
> After that you could just change newsock->ops depending on whether
> pctx->entropy is NULL or not in rng_accept_parent.

Ack, done in v6.

> As for the proto_ops duplication I don't think it's that big a
> deal, but if you're really bothered just create a macro for the
> identical bits in the struct.

I didn't create a macro to avoid complicating the code.

Thanks,
Elena
