Return-Path: <SRS0=RobT=Z2=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1C788C43603
	for <linux-crypto@archiver.kernel.org>; Wed,  4 Dec 2019 14:43:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E45AF2073C
	for <linux-crypto@archiver.kernel.org>; Wed,  4 Dec 2019 14:43:04 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="xfGLXTgY"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727880AbfLDOnE (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 4 Dec 2019 09:43:04 -0500
Received: from mail-wm1-f65.google.com ([209.85.128.65]:56249 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727850AbfLDOnE (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 4 Dec 2019 09:43:04 -0500
Received: by mail-wm1-f65.google.com with SMTP id q9so6186528wmj.5
        for <linux-crypto@vger.kernel.org>; Wed, 04 Dec 2019 06:43:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=71DDqTK7SGG12Z0MAUYKioVk43X0P548ZzvubPDcpes=;
        b=xfGLXTgYxFM84Pj6WXIKpkTBhgV8oH+4gBdq1RyvnYhawSBF8J2cwk5zOUkm2AkwBB
         UXLF/UO/MgqC6imITb42Yz650P37738iiPggY/7Tp9sGnRo0mx1LhxkuZcWsaiQtr3Yi
         FkP6cGyRHUH8nI8pLz4H6U0yOjZr1l/4yAUdSdFuoQ7OpX3R+glAHgOtA2W1zIjlhoCT
         WztW2OPjojfkR3LiY03h5r9yKgoOER6NRh/swNhwjJKKOb6pY1/tF/QM0rG1OBONBiCC
         b0xlMYBLBHrOvUh/6gDA5zhdfxwQ86cniJAOZtvVIEgww/uAIJVkOWV3wouQNDgaTQDW
         DH0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=71DDqTK7SGG12Z0MAUYKioVk43X0P548ZzvubPDcpes=;
        b=TgfZt9jSJ8c6w6mh6B6aCCpu5r40IuJfvMWHFy3ohjPM/Vzeql8rMqLpAMcjokpYKb
         vdZ7x1/66WVCqGLY4Dz26BVWtQEsKeL2BS8zfvQVZDm+7g6KOYItDYPRL3UeUtwbBiXJ
         g3Rlczqh+rMnL/0gT+F0arPLrpI0Uxyk0hJrRe97PMIQJbpL6icZvwBXv4upDufSaDxY
         lgTvI3E022ndb0vHw6m+ZR02ndDygEPbUo6BiN9mdybJiQ0m1HDugT4+EjVclEeDHCR3
         PgOKbrbf+0ibzI7kq7OFNYyXtTjdJOJgP4rBwKT7zoFJ34CTfNZ79TSTgwJjYiyfO5xf
         NGeQ==
X-Gm-Message-State: APjAAAWFt7yuzZJNsLEJdrAy7vtRDGnWCLqQsMN/cZMAyWlB4LdDerMS
        0fLIyLBb7MzVYlDzPnR8YwKpWq6e33/3ljGd6sCGOmoWVHE9s/wu
X-Google-Smtp-Source: APXvYqzBzPANQwZqpR4nb5lE+2+ez0DhI/ckjjRRwPhzDCwyB7+Q2eUdDSUNtFtrfiTPS2+MHgWhzJemLpmKh64hA2I=
X-Received: by 2002:a7b:c778:: with SMTP id x24mr25114169wmk.119.1575470581747;
 Wed, 04 Dec 2019 06:43:01 -0800 (PST)
MIME-Version: 1.0
References: <20191201215330.171990-1-ebiggers@kernel.org> <CAKv+Gu_5pcDeXxLnG_5_jMPc0VDBT3CFr5Hnpb-e4irPLu8JDg@mail.gmail.com>
In-Reply-To: <CAKv+Gu_5pcDeXxLnG_5_jMPc0VDBT3CFr5Hnpb-e4irPLu8JDg@mail.gmail.com>
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date:   Wed, 4 Dec 2019 14:42:58 +0000
Message-ID: <CAKv+Gu9fQV4-KFz=wnBkNEHa3F8cWMuX9CG=a67qhVgFkZ=cPw@mail.gmail.com>
Subject: Re: [PATCH 0/7] crypto: more self-test improvements
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" 
        <linux-crypto@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, 3 Dec 2019 at 12:39, Ard Biesheuvel <ard.biesheuvel@linaro.org> wrote:
>
> On Sun, 1 Dec 2019 at 21:54, Eric Biggers <ebiggers@kernel.org> wrote:
> >
> > This series makes some more improvements to the crypto self-tests, the
> > largest of which is making the AEAD fuzz tests test inauthentic inputs,
> > i.e. cases where decryption is expected to fail due to the (ciphertext,
> > AAD) pair not being the correct result of an encryption with the key.
> >
> > It also updates the self-tests to test passing misaligned buffers to the
> > various setkey() functions, and to check that skciphers have the same
> > min_keysize as the corresponding generic implementation.
> >
> > I haven't seen any test failures from this on x86_64, arm64, or arm32.
> > But as usual I haven't tested drivers for crypto accelerators.
> >
> > For this series to apply this cleanly, my other series
> > "crypto: skcipher - simplifications due to {,a}blkcipher removal"
> > needs to be applied first, due to a conflict in skcipher.h.
> >
> > This can also be retrieved from git at
> > https://git.kernel.org/pub/scm/linux/kernel/git/ebiggers/linux.git
> > tag "crypto-self-tests_2019-12-01".
> >
> > Eric Biggers (7):
> >   crypto: aead - move crypto_aead_maxauthsize() to <crypto/aead.h>
> >   crypto: skcipher - add crypto_skcipher_min_keysize()
> >   crypto: testmgr - don't try to decrypt uninitialized buffers
> >   crypto: testmgr - check skcipher min_keysize
> >   crypto: testmgr - test setting misaligned keys
> >   crypto: testmgr - create struct aead_extra_tests_ctx
> >   crypto: testmgr - generate inauthentic AEAD test vectors
> >
>
> I've dropped this into kernelci again, let's see if anything turns out
> to be broken.
>
> For this series,
>
> Acked-by: Ard Biesheuvel <ardb@kernel.org>
>

Results here:
https://kernelci.org/boot/all/job/ardb/branch/for-kernelci/kernel/v5.4-9340-g16839329da69/

Only the usual suspects failed (rk3288)


> >  crypto/testmgr.c               | 574 +++++++++++++++++++++++++--------
> >  crypto/testmgr.h               |  14 +-
> >  include/crypto/aead.h          |  10 +
> >  include/crypto/internal/aead.h |  10 -
> >  include/crypto/skcipher.h      |   6 +
> >  5 files changed, 461 insertions(+), 153 deletions(-)
> >
> > --
> > 2.24.0
> >
