Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E513EC433F5
	for <linux-crypto@archiver.kernel.org>; Thu, 11 Nov 2021 22:59:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CCB7761264
	for <linux-crypto@archiver.kernel.org>; Thu, 11 Nov 2021 22:59:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234419AbhKKXCr (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 11 Nov 2021 18:02:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59246 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234240AbhKKXCq (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 11 Nov 2021 18:02:46 -0500
Received: from mail-lf1-x12b.google.com (mail-lf1-x12b.google.com [IPv6:2a00:1450:4864:20::12b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC342C0613F5
        for <linux-crypto@vger.kernel.org>; Thu, 11 Nov 2021 14:59:56 -0800 (PST)
Received: by mail-lf1-x12b.google.com with SMTP id c32so17698447lfv.4
        for <linux-crypto@vger.kernel.org>; Thu, 11 Nov 2021 14:59:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=5D3+4vJF30PnckXaBwwWrlTwdIUWKxzS4vTsfPc8j0o=;
        b=J6EayESLNmMLm+bc+qFM6+QK9dseJHiwJiSt9baF/ify2YbXjSf8dA5d0PAANCtBOZ
         EKqoZTX9ZI6RNKYH8gkWuUOhT/cy1q7QHkV821rFCovm5m0SsE4H9JuMCKZB8LyK+6Tm
         P17xBqI21hEG9tIWnia3OVm/bzGh88eGB1qg8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=5D3+4vJF30PnckXaBwwWrlTwdIUWKxzS4vTsfPc8j0o=;
        b=S//KHZYHeGYA7S2pvrVxclQwduTIgzkJ/U6I9hmtp2+K6EG2Q3zMPBHt91HaNMIE8t
         tPW35dR2L8yt6ZU+C7bCFU3PH52YtOGEg2iCcPIrYvkjScYUnjaN4kcNHpSBSATcRCv0
         reoOzTtJpL+Wt1ttnsBY8G33IpEHQb6bqSFYYojfpRl24/6pAIreHK3njywm5+MNFhyK
         X5kkcP23MHe2ZDEMuloT6UIe0/8Ee2g0VZv8ed4YB59APB7+P5HyUhBolvQUUa0qdx4Y
         AKb0R6Dnw/7FLNCsC8EfbS3eoftyU8wHECuLVPJypBLsYPtNhiBhqN+FhqVjH/BzQxNr
         /BfA==
X-Gm-Message-State: AOAM531v0HLzSzBRZ2NaIfOXQOE4Ika0Csa1l0b0JDFaFb9WGXvxPEwF
        gwVQk8/hAOnRaVBrEscaItp3UYKiEhN5k/mN
X-Google-Smtp-Source: ABdhPJw5DWAqkRINoKFC/MfyvdrYG14V9CTPgQHPQXj+T7YY2Be/dUOpebAkKHjp0MK8LoWh1nfJPg==
X-Received: by 2002:a05:6512:238d:: with SMTP id c13mr9991622lfv.350.1636671594216;
        Thu, 11 Nov 2021 14:59:54 -0800 (PST)
Received: from mail-lj1-f180.google.com (mail-lj1-f180.google.com. [209.85.208.180])
        by smtp.gmail.com with ESMTPSA id n15sm397415ljm.32.2021.11.11.14.59.52
        for <linux-crypto@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 11 Nov 2021 14:59:52 -0800 (PST)
Received: by mail-lj1-f180.google.com with SMTP id 13so14856745ljj.11
        for <linux-crypto@vger.kernel.org>; Thu, 11 Nov 2021 14:59:52 -0800 (PST)
X-Received: by 2002:a2e:530b:: with SMTP id h11mr10485841ljb.95.1636671592076;
 Thu, 11 Nov 2021 14:59:52 -0800 (PST)
MIME-Version: 1.0
References: <20211109013058.22224-1-nickrterrell@gmail.com> <471E6457-AF14-4E84-9197-BF30C3DCFFEB@fb.com>
In-Reply-To: <471E6457-AF14-4E84-9197-BF30C3DCFFEB@fb.com>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Thu, 11 Nov 2021 14:59:36 -0800
X-Gmail-Original-Message-ID: <CAHk-=wg3Bqbn=V5kbd-5Rz9xzC_hNyOpNLPPTavZ1Zhdz1dt=w@mail.gmail.com>
Message-ID: <CAHk-=wg3Bqbn=V5kbd-5Rz9xzC_hNyOpNLPPTavZ1Zhdz1dt=w@mail.gmail.com>
Subject: Re: [GIT PULL] zstd changes for v5.16
To:     Nick Terrell <terrelln@fb.com>
Cc:     Nick Terrell <nickrterrell@gmail.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>,
        "squashfs-devel@lists.sourceforge.net" 
        <squashfs-devel@lists.sourceforge.net>,
        "linux-f2fs-devel@lists.sourceforge.net" 
        <linux-f2fs-devel@lists.sourceforge.net>,
        LKML <linux-kernel@vger.kernel.org>,
        Kernel Team <Kernel-team@fb.com>, Chris Mason <clm@fb.com>,
        Petr Malat <oss@malat.biz>, Yann Collet <cyan@fb.com>,
        Christoph Hellwig <hch@infradead.org>,
        =?UTF-8?B?TWljaGHFgiBNaXJvc8WCYXc=?= <mirq-linux@rere.qmqm.pl>,
        David Sterba <dsterba@suse.cz>,
        Oleksandr Natalenko <oleksandr@natalenko.name>,
        Felix Handte <felixh@fb.com>,
        Eric Biggers <ebiggers@kernel.org>,
        Randy Dunlap <rdunlap@infradead.org>,
        Paul Jones <paul@pauljones.id.au>,
        Tom Seewald <tseewald@gmail.com>,
        Sedat Dilek <sedat.dilek@gmail.com>,
        Jean-Denis Girard <jd.girard@sysnux.pf>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, Nov 10, 2021 at 10:47 AM Nick Terrell <terrelln@fb.com> wrote:
>
> I just wanted to make sure that you=E2=80=99ve received my pull request. =
I=E2=80=99m a newbie
> here, so I want to make sure I=E2=80=99m not making a stupid mistake that=
 means you=E2=80=99ve
> missed my message. I=E2=80=99d hate for this PR to not even be considered=
 for merging
> in this window because of some mistake I=E2=80=99ve made.

Oh, it's in my queue, but it's basically at the end of my queue
because I will need to take a much deeper look into what's going on.

It's not just that you're a new source of pulls, it's also that this
is a big change and completely changes the organization of the zlib
stuff. So every time I look at my list of pending pulls, this always
ends up being "I'll do all the normal ones first".

So it's not lost, but this is the kind of pull that I tend to do when
my queues have emptied. Which they haven't done yet..

               Linus
