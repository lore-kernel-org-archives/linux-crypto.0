Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E3CC3C433E6
	for <linux-crypto@archiver.kernel.org>; Wed,  3 Feb 2021 09:38:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 94E7164F7C
	for <linux-crypto@archiver.kernel.org>; Wed,  3 Feb 2021 09:38:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233404AbhBCJiE (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 3 Feb 2021 04:38:04 -0500
Received: from mail.kernel.org ([198.145.29.99]:37094 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232992AbhBCJiD (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 3 Feb 2021 04:38:03 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1450F64F74
        for <linux-crypto@vger.kernel.org>; Wed,  3 Feb 2021 09:37:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612345042;
        bh=bKa1v5WLhs+4JOYntOC7GUyfLrk2a6zlCSkr55pE6+c=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=r7hvXND8+mFQrPFNNSZrIKjR3+n1hyGNZgEW0WgLX5wxxA0vyhGk2/79cq/Wmr/kb
         L1damdNnEnPYIUD74dvbVkrAYzbcXECpuesGKg8fHtgcnxtZB5d55xYf8zqxNqhiFR
         FoLu8ap7MeKVg5RKeqDyiGfKAuolfZ12Vf4QwpPIfEphCWFpK+prJC8sftOh9AtLiB
         HwKMsrFz3Hy/ZP6P+nfprjPn/6W2yKYJC8XmTMxzfpUTynSTYkRHcmjZeuzTnLxA57
         Cz9IgVZ0vZxjDPlJZ/rIVqCEucGNiSgbJhwV7soDpfMU2rtoE+BAdhi2T4k+GDS59F
         5jFeALsjlkgEQ==
Received: by mail-ot1-f52.google.com with SMTP id d7so22765052otf.3
        for <linux-crypto@vger.kernel.org>; Wed, 03 Feb 2021 01:37:22 -0800 (PST)
X-Gm-Message-State: AOAM530t+MeOMTXfHkCxqAM8MAxGf89R6bigjpw9SXwdqKEFB5315JZx
        Lx5qdNszN2DACP4a/JsUFHTFBPp/gmo86AE4ACw=
X-Google-Smtp-Source: ABdhPJyrUJeCy2NiJwnvuCbA8mtyf2wTeBZkubD0jJWVIxBZqRTf/tg+r2TK7nsb2o0oVkjqsdiOi3fgL94T0sMl0Jg=
X-Received: by 2002:a05:6830:1614:: with SMTP id g20mr1404853otr.77.1612345041225;
 Wed, 03 Feb 2021 01:37:21 -0800 (PST)
MIME-Version: 1.0
References: <20210201180237.3171-1-ardb@kernel.org> <YBnQF3KU9Y5YKSmp@gmail.com>
In-Reply-To: <YBnQF3KU9Y5YKSmp@gmail.com>
From:   Ard Biesheuvel <ardb@kernel.org>
Date:   Wed, 3 Feb 2021 10:37:10 +0100
X-Gmail-Original-Message-ID: <CAMj1kXGh0RgK79QWO_VVHKWJiL_50UuXtxHD=nm+pEPDmwzSAw@mail.gmail.com>
Message-ID: <CAMj1kXGh0RgK79QWO_VVHKWJiL_50UuXtxHD=nm+pEPDmwzSAw@mail.gmail.com>
Subject: Re: [PATCH 0/9] crypto: fix alignmask handling
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, 2 Feb 2021 at 23:20, Eric Biggers <ebiggers@kernel.org> wrote:
>
> On Mon, Feb 01, 2021 at 07:02:28PM +0100, Ard Biesheuvel wrote:
> > Some generic implementations of vintage ciphers rely on alignmasks to
> > ensure that the input is presented with the right alignment. Given that
> > these are all C implementations, which may execute on architectures that
> > don't care about alignment in the first place, it is better to use the
> > unaligned accessors, which will deal with the misalignment in a way that
> > is appropriate for the architecture in question (and in many cases, this
> > means simply ignoring the misalignment, as the hardware doesn't care either)
> >
> > So fix this across a number of implementations. Patch #1 stands out because
> > michael_mic.c was broken in spite of the alignmask. Patch #2 removes tnepres
> > instead of updating it, given that there is no point in keeping it.
> >
> > The remaining patches all update generic ciphers that are outdated but still
> > used, and which are the only implementations available on most architectures
> > other than x86.
> >
> >
> >
> > Ard Biesheuvel (9):
> >   crypto: michael_mic - fix broken misalignment handling
> >   crypto: serpent - get rid of obsolete tnepres variant
> >   crypto: serpent - use unaligned accessors instead of alignmask
> >   crypto: blowfish - use unaligned accessors instead of alignmask
> >   crypto: camellia - use unaligned accessors instead of alignmask
> >   crypto: cast5 - use unaligned accessors instead of alignmask
> >   crypto: cast6 - use unaligned accessors instead of alignmask
> >   crypto: fcrypt - drop unneeded alignmask
> >   crypto: twofish - use unaligned accessors instead of alignmask
> >
> >  crypto/Kconfig            |   3 +-
> >  crypto/blowfish_generic.c |  23 ++--
> >  crypto/camellia_generic.c |  45 +++----
> >  crypto/cast5_generic.c    |  23 ++--
> >  crypto/cast6_generic.c    |  39 +++---
> >  crypto/fcrypt.c           |   1 -
> >  crypto/michael_mic.c      |  31 ++---
> >  crypto/serpent_generic.c  | 126 ++++----------------
> >  crypto/tcrypt.c           |   6 +-
> >  crypto/testmgr.c          |   6 -
> >  crypto/testmgr.h          |  79 ------------
> >  crypto/twofish_generic.c  |  11 +-
> >  12 files changed, 90 insertions(+), 303 deletions(-)
>
> Thanks for fixing this up!  These patches all look good to me, and all the
> self-tests still pass.  You can add:
>
> Reviewed-by: Eric Biggers <ebiggers@google.com>
>

Thanks Eric

One thing that became apparent to me while looking into this stuff is
that the skcipher encrypt/decrypt API ignores alignmasks altogether,
so this is something we should probably look into at some point, i.e.,
whether the alignmask handling in the core API is still worth it, and
if it is, make skcipher calls honour them.

In the ablkcipher->skcipher conversion I did, I was not aware of this,
but I don't remember seeing any issues being reported in this area
either, so I wonder how many cases actually exist where alignmasks
actually matter.
