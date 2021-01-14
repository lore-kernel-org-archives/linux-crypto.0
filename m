Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6E708C433E0
	for <linux-crypto@archiver.kernel.org>; Thu, 14 Jan 2021 08:23:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3254A239EF
	for <linux-crypto@archiver.kernel.org>; Thu, 14 Jan 2021 08:23:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726204AbhANIXn (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 14 Jan 2021 03:23:43 -0500
Received: from mail.kernel.org ([198.145.29.99]:33406 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726089AbhANIXm (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 14 Jan 2021 03:23:42 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 905AB23A05;
        Thu, 14 Jan 2021 08:23:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610612581;
        bh=tcP3FAxNWPO+N4kiJcS2Bq7JbQemWOqO+dy+LA9kwSQ=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=fW62+OOb01l+2muJ3PQpw2bl9Hl68xyktuBP5/yvFz8bThGasc6XuEvN3347R7OHS
         Zxj4CRejF/9OCWcIwgsX2O3p9r/zIuRVrAJtPHvDppCHszohOe6j+laJqeWriLVmsb
         r4ZvRuGrX8BgeO5v4RYacFocrVlpJSKkhnIk9ft6JlhsTQ+RwCe6Z1GprQVYh1dXJJ
         QXA2B0rGvmfaeZc+5SwMzIr3cvV0POh6rsIPze19UXZO8sNCbMdsluc4UMZvyd9Ak4
         MDdERRTnBG3S8qBON0EhGZE1ZPo6Obirf4fvJVRYwZqvVQIKebGbpSk/Tr9xgDKI2S
         vflt6WRXuuWJA==
Received: by mail-ot1-f50.google.com with SMTP id n42so4452023ota.12;
        Thu, 14 Jan 2021 00:23:01 -0800 (PST)
X-Gm-Message-State: AOAM532YflfVmK274y8Q1D8kcN3dz0OahAdegPiAKEJNKsYix2Mwf1Nd
        +S6G3SJY0UfcgY+MjGLWvQNlyi+uB1/DzdFt3sw=
X-Google-Smtp-Source: ABdhPJwHcgXMKdh9dOHzL2cqddSOd8YljSNWI1kjjz2pwydSq/YowUNCd6MfHeKFCFGSl6/v4tcLk9ePu7EpDhm3GhU=
X-Received: by 2002:a05:6830:1c24:: with SMTP id f4mr3779599ote.108.1610612580759;
 Thu, 14 Jan 2021 00:23:00 -0800 (PST)
MIME-Version: 1.0
References: <20201218170106.23280-1-ardb@kernel.org> <20201219020433.GA11077@gondor.apana.org.au>
In-Reply-To: <20201219020433.GA11077@gondor.apana.org.au>
From:   Ard Biesheuvel <ardb@kernel.org>
Date:   Thu, 14 Jan 2021 09:22:49 +0100
X-Gmail-Original-Message-ID: <CAMj1kXHpXAuyomBi1mTopgfgzZni+oWe7AfZgMaK2gUGaiot_g@mail.gmail.com>
Message-ID: <CAMj1kXHpXAuyomBi1mTopgfgzZni+oWe7AfZgMaK2gUGaiot_g@mail.gmail.com>
Subject: Re: [RFC PATCH 0/5] running kernel mode SIMD with softirqs disabled
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Dave Martin <dave.martin@arm.com>,
        Mark Brown <broonie@kernel.org>,
        Eric Biggers <ebiggers@kernel.org>,
        Will Deacon <will@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Ingo Molnar <mingo@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Sat, 19 Dec 2020 at 03:05, Herbert Xu <herbert@gondor.apana.org.au> wrote:
>
> On Fri, Dec 18, 2020 at 06:01:01PM +0100, Ard Biesheuvel wrote:
> >
> > Questions:
> > - what did I miss or break horribly?
> > - does any of this matter for RT? AIUI, RT runs softirqs from a dedicated
> >   kthread, so I don't think it cares.
> > - what would be a reasonable upper bound to keep softirqs disabled? I suppose
> >   100s of cycles or less is overkill, but I'm not sure how to derive a better
> >   answer.
> > - could we do the same on x86, now that kernel_fpu_begin/end is no longer
> >   expensive?
>
> If this approach works not only would it allow us to support the
> synchronous users better, it would also allow us to remove loads
> of cruft in the Crypto API that exist solely to support these SIMD
> code paths.
>
> So I eagerly await the assessment of the scheduler/RT folks on this
> approach.
>

Any insights here? Is there a ballpark upper bound for the duration of
a softirq disabled section? Other reasons why dis/enabling softirq
handling is a bad idea?
