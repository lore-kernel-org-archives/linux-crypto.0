Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7B95DC433E0
	for <linux-crypto@archiver.kernel.org>; Wed,  3 Feb 2021 11:24:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1FA4164F61
	for <linux-crypto@archiver.kernel.org>; Wed,  3 Feb 2021 11:24:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234119AbhBCLXr (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 3 Feb 2021 06:23:47 -0500
Received: from mail.kernel.org ([198.145.29.99]:34814 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234208AbhBCLXU (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 3 Feb 2021 06:23:20 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id A5E8064F68
        for <linux-crypto@vger.kernel.org>; Wed,  3 Feb 2021 11:22:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612351359;
        bh=zNcbcnfNCH6TNASY0QXEgj3Ckj8D8MtrX2NVBuAyqLc=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=LPrCwdF3DUhcXy0+iTneiD9lyEj5l4im3NONGoV6jI2iXS53pq6XSXN4vaTT0YDjN
         Wjq3C3YIgCYrmIk+MOpjxPdjgSfLGcVVtLvV/PVIX0OdCj7/XHFV2xk0AjasArUNDM
         PvqI6bRqmxGvJGoMFKVcZZZs57zuqFeYPK+FYNTPtA4vDTx7QZqgdydm/L9A3T8MPw
         XSS4ZJQAtUNRZjKDH90V7s+pXVjS6jg1H6vPLcVL9bPEm7nsbYfbHB+qKioIEfG+Ax
         /hg5g1pgVjvz+imtKBRGiqrqzwVGxFNKx3Nwxaf7sM9kTfQcCFYegnOzhUJnoqCIya
         RxR0jQpshX7hA==
Received: by mail-ot1-f49.google.com with SMTP id s107so2354973otb.8
        for <linux-crypto@vger.kernel.org>; Wed, 03 Feb 2021 03:22:39 -0800 (PST)
X-Gm-Message-State: AOAM533oXsjvT50nUfhXyXMQTFbXJLAIut3BNSIaX1sQs8CRPLbPs3Bo
        XUx8vgTinnO6aKZidF1vbB4ZB67EGFtL29d/GAQ=
X-Google-Smtp-Source: ABdhPJyGyo7puvhIc3n2YbrJq88bt4ubVvEAEdelLFiTK0ajoO2U9TBq/l15RaquytvUrqTLkp7mX2o6iUZHcRoPRBI=
X-Received: by 2002:a05:6830:1e2a:: with SMTP id t10mr1751527otr.90.1612351358904;
 Wed, 03 Feb 2021 03:22:38 -0800 (PST)
MIME-Version: 1.0
References: <20210201180237.3171-1-ardb@kernel.org> <YBnQF3KU9Y5YKSmp@gmail.com>
 <CAMj1kXGh0RgK79QWO_VVHKWJiL_50UuXtxHD=nm+pEPDmwzSAw@mail.gmail.com> <20210203111952.GA3285@gondor.apana.org.au>
In-Reply-To: <20210203111952.GA3285@gondor.apana.org.au>
From:   Ard Biesheuvel <ardb@kernel.org>
Date:   Wed, 3 Feb 2021 12:22:27 +0100
X-Gmail-Original-Message-ID: <CAMj1kXGkXb32cVMszBPh-7U18dOiG7TXsi3Le4MTYeWaHeLZ4g@mail.gmail.com>
Message-ID: <CAMj1kXGkXb32cVMszBPh-7U18dOiG7TXsi3Le4MTYeWaHeLZ4g@mail.gmail.com>
Subject: Re: [PATCH 0/9] crypto: fix alignmask handling
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     Eric Biggers <ebiggers@kernel.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, 3 Feb 2021 at 12:19, Herbert Xu <herbert@gondor.apana.org.au> wrote:
>
> On Wed, Feb 03, 2021 at 10:37:10AM +0100, Ard Biesheuvel wrote:
> >
> > One thing that became apparent to me while looking into this stuff is
> > that the skcipher encrypt/decrypt API ignores alignmasks altogether,
> > so this is something we should probably look into at some point, i.e.,
> > whether the alignmask handling in the core API is still worth it, and
> > if it is, make skcipher calls honour them.
> >
> > In the ablkcipher->skcipher conversion I did, I was not aware of this,
> > but I don't remember seeing any issues being reported in this area
> > either, so I wonder how many cases actually exist where alignmasks
> > actually matter.
>
> What do you mean? With both ablkcipher/skcipher the alignmask was
> usually enforced through the walker mechanism.
>

Oops, I missed that completely. Apologies for the noise.
