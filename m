Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 91A6BC433ED
	for <linux-crypto@archiver.kernel.org>; Fri,  7 May 2021 13:02:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3F13261464
	for <linux-crypto@archiver.kernel.org>; Fri,  7 May 2021 13:02:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236446AbhEGNDX (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 7 May 2021 09:03:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37254 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235836AbhEGNDW (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 7 May 2021 09:03:22 -0400
Received: from mail-qv1-xf2a.google.com (mail-qv1-xf2a.google.com [IPv6:2607:f8b0:4864:20::f2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DAA4DC061574
        for <linux-crypto@vger.kernel.org>; Fri,  7 May 2021 06:02:22 -0700 (PDT)
Received: by mail-qv1-xf2a.google.com with SMTP id dl3so4732632qvb.3
        for <linux-crypto@vger.kernel.org>; Fri, 07 May 2021 06:02:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to;
        bh=sqrFWO6xme0JIYPb3gXMNn77yYlPuy3wGhEbm2jPVuA=;
        b=Q1SrFoOMoPEjGgkZvy3AufZF1psxVG4y7iJ6gq0sbbCxUgxjl1s1GjAop3S9TLRcry
         UEF6KxpOsOhqtX0Xmq+kiNyMkcJDmyXfbG43PPtKCVV3plsDdSNHdq7Upwta5PadPBNA
         xtwbg7pY6s7m2QikOBjmnVJZTgo86iGJuQ0ipz2iRazuMRH+n0510/DoOjkVA1BQayff
         tWlqY9XNRNnEYGr5x5o/zHrr+0zH4O5TRlOXRvQTVMU1PBpk/F4+hjlEKzoZbIbNtQcQ
         cJhd0CDY6LHp/lSyjV3ILdL2d7jTkJMYulmkbv/qKu8Za1Q42TSIWPyupNYJwRP8ePgW
         kVSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to;
        bh=sqrFWO6xme0JIYPb3gXMNn77yYlPuy3wGhEbm2jPVuA=;
        b=DrYlTeIn9jZfZjX4a9EOOJgpcbzelv7q+rV0qYVuiPR30o1AU6qPuS70iSZ8YVi6qm
         o5prb9kcPZPHqtHiLp99KrLiwtrUl7pdA+BcXG70nQ0ClymS/muPj7ZPdFmeLJIKJRrA
         fGL9KGje4SzBcAonKURj01P9FJx6Ey7ooTWGcIrm8UbLbm0WGDcU1sqTjmU6k+E5OTAd
         2loaBPiuOrMGCvn+MOfcVYz5X8y45kyCtuvN3apSC043NU3UkdBv/Oy64OdAoXrc3uEW
         aa/S3d15BsyXdnihsv2Vheh1R1GZTr7edGMbrBmcuLPyIsHnqiG8TOCXF7OGkuXiM1t3
         a5pw==
X-Gm-Message-State: AOAM533yq7lmfNoD5ZARGnyNMe8Xx5kUHDsFFqtpS6r1oejHlA4zAh4m
        VncoKjWcrXoPpAJtqNwtmWHAyHmk71cQsKsoYJjosD32
X-Google-Smtp-Source: ABdhPJwImZM422UNoqWuXx59HbA1RyY0riVcqfFGmCRXEpH54qxRdvrRJ8WWRBkjaJ/sF8dCzV1x+qDWc7xW8ytF6Ng=
X-Received: by 2002:a05:6214:a62:: with SMTP id ef2mr9782998qvb.31.1620392541997;
 Fri, 07 May 2021 06:02:21 -0700 (PDT)
MIME-Version: 1.0
References: <CAE9cyGRzwN8AMzdf=E+rBgrhkDxyV52h8t_cBWgiXscvX_2UtQ@mail.gmail.com>
 <YJTkf0F5IZhqiXI5@sol.localdomain> <CAE9cyGTi9YpC9pcu5-MXtmXu_DM5FEVt9DYrM4AQWQMK7f0=zA@mail.gmail.com>
In-Reply-To: <CAE9cyGTi9YpC9pcu5-MXtmXu_DM5FEVt9DYrM4AQWQMK7f0=zA@mail.gmail.com>
From:   Kestrel seventyfour <kestrelseventyfour@gmail.com>
Date:   Fri, 7 May 2021 15:02:11 +0200
Message-ID: <CAE9cyGRCDP5dv1AJ_5LL5e9vJasuc1_AZFLjZnT-hwYE-CUUFQ@mail.gmail.com>
Subject: Fwd: xts.c and block size inkonsistency? cannot pass generic driver
 comparision tests
To:     linux-crypto@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi Eric,

I agree, that it can't be built on top of the kernels CBC. But in the
hardware CBC, e.g. for encryption I set the IV (encrypted tweak), set
the hardwares aes mode to CBC and start the encrypt of a 16 byte
block, then do an additional xor after that -> result of that full
block is the same as XTS. Then I gfmul the tweak and repeat the
previous starting with setting the tweak as iv.
Doing that is much faster and much more efficient than using the
kernels xts on top of ecb(aes). But it introduces the problem that I
have somehow to handle the CTS after my walk loop that just processes
full blocks or multiples of that. And I am trying to figure out, what
the best way is to do that with the least amount of code in my driver.
I cannot set blocksize to 1, because then the block size comparison to
generic xts fails and If I set the walksize to 1, I get the alignment
and split errors and would have to handle the splits and
missalignments manually.
So actually I need a combination of what the walk does (handle
alignment and splits) plus getting the last complete and incomplete
block after walk_skcipher_done returns -EINVAL. At least thats my
current idea. I could just copy most of the code from xts, but there
is a lot of stuff, that is not needed, if I combine the hardware CBC
and xor to be XEX (XTS without the cipher text stealing).

Thanks.

Am Fr., 7. Mai 2021 um 08:56 Uhr schrieb Eric Biggers <ebiggers@kernel.org>:
>
> On Fri, May 07, 2021 at 07:57:01AM +0200, Kestrel seventyfour wrote:
> > Hi,
> >
> > I have also added xts aes on combining the old hardware cbc algorithm
> > with an additional xor and the gfmul tweak handling. However, I
> > struggle to pass the comparision tests to the generic xts
> > implementation.
>
> XTS can't be built on top of CBC, unless you only do 1 block at a time.
>
> It can be built on top of ECB, which is what the template already does.
>
> Before getting too far into your questions, are you sure that what you're trying
> to do actually makes sense?
>
> - Eric
