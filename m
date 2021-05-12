Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2EFF8C2B9F2
	for <linux-crypto@archiver.kernel.org>; Wed, 12 May 2021 22:23:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F205161420
	for <linux-crypto@archiver.kernel.org>; Wed, 12 May 2021 22:23:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232353AbhELWYT (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 12 May 2021 18:24:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:54886 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1391836AbhELVc3 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 12 May 2021 17:32:29 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 98558613F7
        for <linux-crypto@vger.kernel.org>; Wed, 12 May 2021 21:31:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620855078;
        bh=OAAlNOf1uOXTWb17XYkxTD2FRz+0rfsKiFX8+G83r0o=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=u0wt+mvVnpqtUirH/i1z/hLrWQc1u8GiS1LRUg2uLxhAWeV7lr8NND/061hJBw8c5
         2e3hKJjVy1KOY/n568ac9ZBjtiA8kYErjPs7hZ6zmmU3KSEYoAptnHUPgcipmO3siG
         wN7kZ02vFBHpv0EUlRSDDd/FnHjBfoqH65vqPml/tVCMQdpWkxgQLE/E/DYIJfWn2K
         XR4nVSsyaF1CGOArSrRLfXQPbs5P8CK4SWfeOGLXml96+WRRXtMpZnCnZ1ewXp85+f
         T6sCn57AvwDRDtpRC2j9+nohAsP7n2zbsrJTOi01gCn/ivD5vtfsxvMJjhDeoIhpaw
         2GbRfp0rjFH0w==
Received: by mail-ot1-f44.google.com with SMTP id 36-20020a9d0ba70000b02902e0a0a8fe36so15588425oth.8
        for <linux-crypto@vger.kernel.org>; Wed, 12 May 2021 14:31:18 -0700 (PDT)
X-Gm-Message-State: AOAM5300ynicrN8DyiFpnNJK+B81TvhTvgePoTsw6fcjBko7ddu+NHt8
        8y8raPsYQQQ5r5SfUIQ6Bpj1/37VGJANgjFltZc=
X-Google-Smtp-Source: ABdhPJyrUMSRYMeITDk5+ILCDguAypmRVcPtQOTC2Xo5lgpzcNFod81nouBZbhXIWcH8a7oJ+AgJk3CCQCDUoOQ5H4w=
X-Received: by 2002:a9d:69c5:: with SMTP id v5mr31870218oto.108.1620855077847;
 Wed, 12 May 2021 14:31:17 -0700 (PDT)
MIME-Version: 1.0
References: <20210512184439.8778-1-ardb@kernel.org> <YJw2Z5zlFtAx9koA@gmail.com>
In-Reply-To: <YJw2Z5zlFtAx9koA@gmail.com>
From:   Ard Biesheuvel <ardb@kernel.org>
Date:   Wed, 12 May 2021 23:31:06 +0200
X-Gmail-Original-Message-ID: <CAMj1kXF6XU8MLHZYAEnNa4v0G0k1vshxNkXpZ8ijG-BxzV=5fw@mail.gmail.com>
Message-ID: <CAMj1kXF6XU8MLHZYAEnNa4v0G0k1vshxNkXpZ8ijG-BxzV=5fw@mail.gmail.com>
Subject: Re: [PATCH v3 0/7] running kernel mode SIMD with softirqs disabled
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Will Deacon <will@kernel.org>,
        Android Kernel Team <kernel-team@android.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, 12 May 2021 at 22:11, Eric Biggers <ebiggers@kernel.org> wrote:
>
> On Wed, May 12, 2021 at 08:44:32PM +0200, Ard Biesheuvel wrote:
> > This is a follow-up to [0], but given that the arm64 architectural
> > pieces have been merged for arm64, the only remaining changes are crypto
> > specific. Therefore, the audience has been reduced to those people who
> > are likely to care about these specifics.
> >
> > Patch #1 addresses an issue in the skcipher walker which doesn't handle
> > zero sized AEAD inputs entirely consistently, which is uncovered by the
> > change in patch #7.
> >
> > Patches #2 and #3 add some sanity checks to the public AEAD and skcipher
> > APIs to limit their availibility to either task or softirq context
> > (which is the only way in which they are currently being used). Adding
> > this restriction permits the arm64 crypto code to get rid of all scalar
> > fallbacks, given that on this architecture, softirqs are no longer
> > served while the SIMD unit is being used in kernel mode, which means
> > that the scalar fallbacks are never needed. These are removed in the
> > remaining 4 patches.
> >
> > [0] https://lore.kernel.org/linux-arm-kernel/20210302090118.30666-1-ardb@kernel.org/
>
> Did you check whether any updates to the self-tests in testmgr.c are warranted?
> Specifically, is disabling the use of SIMD for testing still something that
> makes sense?
>

The situation is not ideal, but I am not sure what we can do about
this: the scalar fallbacks are gone, which means that the SIMD unit
will be used in the test even if testmgr attempts to disable it. But
keeping the scalar fallbacks just for the test suite makes no sense
either. So I don't think we should change anything, other than perhaps
document this somewhere (any suggestions on a place to put that)

Note that the library routines, as well as shashes (which are
sometimes exposed via library routines, e.g., CRC-T10DIF and CRC-32,
and maybe others) are different, which is why their scalar fallbacks
are retained. There, we need the testmgr to override SIMD availability
to ensure that combinations of the SIMD and scalar code are tested.
