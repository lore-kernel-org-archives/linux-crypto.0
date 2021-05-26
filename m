Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B43AFC2B9F7
	for <linux-crypto@archiver.kernel.org>; Wed, 26 May 2021 09:12:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9034D61248
	for <linux-crypto@archiver.kernel.org>; Wed, 26 May 2021 09:12:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233629AbhEZJON (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 26 May 2021 05:14:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:48012 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233283AbhEZJOJ (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 26 May 2021 05:14:09 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E080561437
        for <linux-crypto@vger.kernel.org>; Wed, 26 May 2021 09:12:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622020358;
        bh=S55ODqqujtzXgLmsiAgw1ByZLYfqR9g87VvzDp7c4G0=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=pmno4fJAawdTFJND6vDyf9+1mO23CLBAuZbmHIGlZ86jZeWKsCNbvrWBNDiowEBjL
         vNU1V72Rq5aLVysw3/mnuHUgwGNyU6qPeOtr8CtCfYLUm3JJ8UrsEhuVHpGqCQy5T8
         b59zIpC2qqVdPf14Av9cR2r2vsqMVKjb0dut6QXHFdXlW48sX3Aj9ekdZRafkm6anf
         zU9wWTbc03c3isRR5I9bDWwN/N1vBReeigs2Yb9GNu23wisP2/Qq+X/78PZyEeoHvV
         /r5lGhyCwYy0FsQwAkaaBCpPql7qOoGhutvjapnew6lMMsqLlQXdi7felrTX/NZT9m
         SGLTtpbPPC09A==
Received: by mail-oi1-f180.google.com with SMTP id v22so848557oic.2
        for <linux-crypto@vger.kernel.org>; Wed, 26 May 2021 02:12:38 -0700 (PDT)
X-Gm-Message-State: AOAM532QX7TrrpVzw6/DLrB7aTLL+HLQE6c0/JcwLDskjfz06PN4Fx7e
        WAJjkocRUrMqeI3Otoo0pPItUPszxmrakmIt04c=
X-Google-Smtp-Source: ABdhPJx4pGCqMvqMOn8usurPsH6vgk+Qz3yoKsF3tBBTGpUk6G+5N4ttwhmqVyUgLOju5rBnFY0Z+G6q2jJwr3bzdVE=
X-Received: by 2002:aca:1b14:: with SMTP id b20mr1137966oib.174.1622020358246;
 Wed, 26 May 2021 02:12:38 -0700 (PDT)
MIME-Version: 1.0
References: <20210521102053.66609-1-ardb@kernel.org> <20210521102053.66609-5-ardb@kernel.org>
 <YKwf9wmioRxrKOGO@gmail.com>
In-Reply-To: <YKwf9wmioRxrKOGO@gmail.com>
From:   Ard Biesheuvel <ardb@kernel.org>
Date:   Wed, 26 May 2021 11:12:27 +0200
X-Gmail-Original-Message-ID: <CAMj1kXF-t6JHU_8qKekSNf8W5yrTc8Xdk8_hFnMRDm3iU7nG5w@mail.gmail.com>
Message-ID: <CAMj1kXF-t6JHU_8qKekSNf8W5yrTc8Xdk8_hFnMRDm3iU7nG5w@mail.gmail.com>
Subject: Re: [PATCH v5 4/5] crypto: arm64/aes-ccm - remove non-SIMD fallback path
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        herbert@gondor.apana.org.au, will@kernel.org,
        kernel-team@android.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, 24 May 2021 at 23:51, Eric Biggers <ebiggers@kernel.org> wrote:
>
> On Fri, May 21, 2021 at 12:20:52PM +0200, Ard Biesheuvel wrote:
> > AES/CCM on arm64 is implemented as a synchronous AEAD, and so it is
> > guaranteed by the API that it is only invoked in task or softirq
> > context. Since softirqs are now only handled when the SIMD is not
> > being used in the task context that was interrupted to service the
> > softirq, we no longer need a fallback path. Let's remove it.
> >
> > Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
> > ---
> >  arch/arm64/crypto/aes-ce-ccm-core.S |   1 +
> >  arch/arm64/crypto/aes-ce-ccm-glue.c | 181 ++++++--------------
> >  2 files changed, 53 insertions(+), 129 deletions(-)
>
> This doesn't just remove the no-SIMD fallback, but it also does some
> refactoring.  Notably, it starts to process all the authenticated data in one
> kernel_neon_begin() / kernel_neon_end() pair rather than many.  Can you explain
> why that is okay now when previously it wasn't, and also split this into two
> separate commits?
>

OK.

For the record, the reason is that, even though kernel_neon_begin/end
are reasonably cheap these days, the common case for CCM (given its
use in networking context) is for the auth/encrypt/finalize routines
to each be called a single time, without any potentially sleeping
calls into the skcipher walk layer in between. Now that we are doing
more work in there (disable softirq processing as well as preemption),
it was a suitable occasion to do some refactoring that I have had on
my list for a while now.
