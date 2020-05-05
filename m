Return-Path: <SRS0=vF1r=6T=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 97624C47247
	for <linux-crypto@archiver.kernel.org>; Tue,  5 May 2020 23:22:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4D341206FA
	for <linux-crypto@archiver.kernel.org>; Tue,  5 May 2020 23:22:17 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="DCEwEWgC"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728717AbgEEXWQ (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 5 May 2020 19:22:16 -0400
Received: from mail.zx2c4.com ([192.95.5.64]:40617 "EHLO mail.zx2c4.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727989AbgEEXWP (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 5 May 2020 19:22:15 -0400
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTP id 70c7ade0;
        Tue, 5 May 2020 23:09:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha1; c=relaxed; d=zx2c4.com; h=mime-version
        :references:in-reply-to:from:date:message-id:subject:to:cc
        :content-type; s=mail; bh=xOx4lzYKysYBqiibmxpMonx/5es=; b=DCEwEW
        gCpskkl6tu3+0UZXF3igKmZs1FvvZEldP0ADypPumnUN4HuntAZGOfd0FCOzaDmn
        FfZk7owX2akMYQTxURnYyCvGFkHMy7Oj4IG1DMT5LSR4d1canFtLPmvl5kASflqF
        O3/x0asJhzArroBjnDw6Vkdy3s4qHu/aov+91oHQVRDS0zIk/RaQS4yIyLxHXMmR
        BDxg1xme/fjaYAZzCdMgGWFCQrvRtI2MVQAb/oUEKFW8p2fXzUO7A5NETYAUC3mw
        Mz03Bzx7MhzPaqwHshKm8zRc7syPM+dYiwYNv02OB+JKaCf0qFjHRB+7N0latSRD
        7klylWP7wFtvLgRQ==
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 4d39b82e (TLSv1.3:TLS_AES_256_GCM_SHA384:256:NO);
        Tue, 5 May 2020 23:09:37 +0000 (UTC)
Received: by mail-il1-f175.google.com with SMTP id e8so3963132ilm.7;
        Tue, 05 May 2020 16:22:12 -0700 (PDT)
X-Gm-Message-State: AGi0Pub6vbXxtRXDtjj61W9phThyQGqKWQh3Y6Vje4jMSvc/IVft3oLS
        OtbZLvuswYvstCGs/tNWveMgH/xOpA9GDCSf2eM=
X-Google-Smtp-Source: APiQypLue2T1PZHDyVoMLItvPM9erLf9o3z1hoVlFFTiTFuAkiOo+PdWjcpChEdSNuCmPwDF+sEP0SL9dbJHdTGG8zc=
X-Received: by 2002:a92:5c82:: with SMTP id d2mr6382691ilg.231.1588720932156;
 Tue, 05 May 2020 16:22:12 -0700 (PDT)
MIME-Version: 1.0
References: <CAHmME9oMcfY4nwkknwN9c4rB-O7xD4GCAOFPoZCbdnq=034=Vw@mail.gmail.com>
 <20200505215503.691205-1-Jason@zx2c4.com> <CAKwvOdk32cDowvrqRPKDRpf2ZiXh=jVnBTmhM-NWD=Ownq9v3w@mail.gmail.com>
 <20200505222540.GA230458@ubuntu-s3-xlarge-x86> <CAHmME9qs0iavoBqd_z_7Xibyz7oxY+FRt+sHyy+sBa1wQc66ww@mail.gmail.com>
 <202005051617.F9B32B5526@keescook>
In-Reply-To: <202005051617.F9B32B5526@keescook>
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
Date:   Tue, 5 May 2020 17:22:01 -0600
X-Gmail-Original-Message-ID: <CAHmME9q3zFe4e1xnpptJ27zywGqngZK2K7LCVzDSoG__ht=fNA@mail.gmail.com>
Message-ID: <CAHmME9q3zFe4e1xnpptJ27zywGqngZK2K7LCVzDSoG__ht=fNA@mail.gmail.com>
Subject: Re: [PATCH] Kbuild: disable FORTIFY_SOURCE on clang-10
To:     Kees Cook <keescook@chromium.org>
Cc:     Nathan Chancellor <natechancellor@gmail.com>,
        Nick Desaulniers <ndesaulniers@google.com>,
        "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" 
        <linux-crypto@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        clang-built-linux <clang-built-linux@googlegroups.com>,
        Arnd Bergmann <arnd@arndb.de>, George Burgess <gbiv@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, May 5, 2020 at 5:19 PM Kees Cook <keescook@chromium.org> wrote:
>
> On Tue, May 05, 2020 at 04:37:38PM -0600, Jason A. Donenfeld wrote:
> > On Tue, May 5, 2020 at 4:25 PM Nathan Chancellor
> > <natechancellor@gmail.com> wrote:
> > > I believe these issues are one in the same. I did a reverse bisect with
> > > Arnd's test case and converged on George's first patch:
> > >
> > > https://github.com/llvm/llvm-project/commit/2dd17ff08165e6118e70f00e22b2c36d2d4e0a9a
> > >
> > > I think that in lieu of this patch, we should have that patch and its
> > > follow-up fix merged into 10.0.1.
> >
> > If this is fixed in 10.0.1, do we even need to patch the kernel at
> > all? Or can we just leave it be, considering most organizations using
> > clang know what they're getting into? I'd personally prefer the
> > latter, so that we don't clutter things.
>
> I agree: I'd rather this was fixed in 10.0.1 (but if we do want a
> kernel-side work-around for 10.0.0, I would suggest doing the version
> check in the Kconfig for FORTIFY_SOURCE instead of in the Makefile,
> as that's where these things are supposed to live these days).

Indeed this belongs in the Makefile. I can send a patch adjusting
that, if you want, but I think I'd rather do nothing and have a fix be
rolled out in 10.0.1. Clang users should know what to expect in that
regard.

> (Though as was mentioned, it's likely that FORTIFY_SOURCE isn't working
> _at all_ under Clang, so I may still send a patch to depend on !clang
> just to avoid surprises until it's fixed, but I haven't had time to
> chase down a solution yet.)

That might be the most coherent thing to do, at least so that people
don't get some false sense of mitigation.

Jason
