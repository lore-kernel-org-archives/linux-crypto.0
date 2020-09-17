Return-Path: <SRS0=yTfj=C2=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A4002C433E2
	for <linux-crypto@archiver.kernel.org>; Thu, 17 Sep 2020 06:15:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 475E0206DC
	for <linux-crypto@archiver.kernel.org>; Thu, 17 Sep 2020 06:15:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1600323334;
	bh=tL6gjWMJo0qGba/PkTy5wElVt4dtX03beAqPAXruTE0=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:List-ID:From;
	b=uBCuiuhMIBwu0vhY08TUm/LHuvo7LOIKgXpg11FakLbxlnKaQbEyhuMIQIwIxPOG/
	 m9OpS2ydFUQ9JqeXFGvGW4dQtTVKOx7hK6l6gc6FyFBWxhfGKuIiRVLcqz6LShLl9f
	 U4KUd/5+3SOfgUAPzhFa+HzeiK0QEkm6Udk3MtEM=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726187AbgIQGPd (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 17 Sep 2020 02:15:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:41704 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726180AbgIQGPc (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 17 Sep 2020 02:15:32 -0400
X-Greylist: delayed 431 seconds by postgrey-1.27 at vger.kernel.org; Thu, 17 Sep 2020 02:15:31 EDT
Received: from mail-ot1-f43.google.com (mail-ot1-f43.google.com [209.85.210.43])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F37C021D43
        for <linux-crypto@vger.kernel.org>; Thu, 17 Sep 2020 06:08:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600322900;
        bh=tL6gjWMJo0qGba/PkTy5wElVt4dtX03beAqPAXruTE0=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=Wr7Imjh2dJM7LqHIYerEW/ta8TNi+2HHcrQa9zWSWjs8Qiz6oFxkb8h7DiEN0I9f4
         AHJDnpm+OSTFKnYeRR4/dlyaW8+ZtEGJY1Tv+/eXbmLUarHAQvYpks3a/9gmQ8YtGe
         4QFW3QiwMOmH08e5j5O8t0asCg4A9qU5tJlyIXRQ=
Received: by mail-ot1-f43.google.com with SMTP id c10so827114otm.13
        for <linux-crypto@vger.kernel.org>; Wed, 16 Sep 2020 23:08:19 -0700 (PDT)
X-Gm-Message-State: AOAM532Cf3l1qh1Km2i6JKSx4Ozxec/GpUniAk15oIhyB1blZIb0FRDu
        cp45I3rEklEBWqCPx4iaGIEjpOHSdMtMFhUVAKc=
X-Google-Smtp-Source: ABdhPJyVb0Pvvr5t/7O1sytqG4mfZvSozNgONeYxXT76SzZ+PNtzEuIAsg+/HFD+GRnJgZ9VPCkk6cXeTkItrHEnwWg=
X-Received: by 2002:a9d:6193:: with SMTP id g19mr18250382otk.108.1600322899254;
 Wed, 16 Sep 2020 23:08:19 -0700 (PDT)
MIME-Version: 1.0
References: <20200916061418.9197-1-ardb@kernel.org> <CAKwvOdmqFoVxQz9Z_9sM_m3qykVbavnUnkCvy_G2S2aPEofTog@mail.gmail.com>
In-Reply-To: <CAKwvOdmqFoVxQz9Z_9sM_m3qykVbavnUnkCvy_G2S2aPEofTog@mail.gmail.com>
From:   Ard Biesheuvel <ardb@kernel.org>
Date:   Thu, 17 Sep 2020 09:08:08 +0300
X-Gmail-Original-Message-ID: <CAMj1kXE-WJoT0GhCzGGqF4uzVNCqdd1O0SZ9xbHP25eQMCUsqw@mail.gmail.com>
Message-ID: <CAMj1kXE-WJoT0GhCzGGqF4uzVNCqdd1O0SZ9xbHP25eQMCUsqw@mail.gmail.com>
Subject: Re: [PATCH v2 0/2] crypto: arm/sha-neon - avoid ADRL instructions
To:     Nick Desaulniers <ndesaulniers@google.com>
Cc:     "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" 
        <linux-crypto@vger.kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Stefan Agner <stefan@agner.ch>,
        Peter Smith <Peter.Smith@arm.com>,
        clang-built-linux <clang-built-linux@googlegroups.com>,
        Jian Cai <jiancai@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, 17 Sep 2020 at 03:53, Nick Desaulniers <ndesaulniers@google.com> wrote:
>
> On Tue, Sep 15, 2020 at 11:14 PM Ard Biesheuvel <ardb@kernel.org> wrote:
> >
> > Remove some occurrences of ADRL in the SHA NEON code adopted from the
> > OpenSSL project.
> >
> > I will leave it to the Clang folks to decide whether this needs to be
> > backported and how far, but a Cc stable seems reasonable here.
> >
> > Cc: Nick Desaulniers <ndesaulniers@google.com>
> > Cc: Stefan Agner <stefan@agner.ch>
> > Cc: Peter Smith <Peter.Smith@arm.com>
>
> Tested-by: Nick Desaulniers <ndesaulniers@google.com>
>

Thanks!

> Thanks Ard:
> compile+boot tested each combination of:
>
> [gcc, clang]x[defconfig, defconfig+CONFIG_THUMB2_KERNEL=y].
>
> Now, if I additionally apply:
> 1. this series
> 2. the adr_l series:
> https://lore.kernel.org/linux-arm-kernel/20200914095706.3985-1-ardb@kernel.org/
> 3. unrelated fix for -next #1:
> https://lore.kernel.org/lkml/20200916200255.1382086-1-ndesaulniers@google.com/
> 4. unrelated fix for -next #2:
> https://lore.kernel.org/linux-mm/20200917001934.2793370-1-ndesaulniers@google.com/
> 5. small fixup to 01/12 from #2:
> https://lore.kernel.org/linux-arm-kernel/CAMj1kXFmF_24d-7W8AWTJR-PCcja7bUdHhYKptGQmsV4vNp=sA@mail.gmail.com/
> 6. vfp fixup for thumb+gcc:
> https://lore.kernel.org/linux-arm-kernel/CAMj1kXHEpPc0MSoMrCxEkyb44AkLM2NJJGtOXLpr6kxBHS0vfA@mail.gmail.com/
> 7. disable CONFIG_IWMMXT https://github.com/ClangBuiltLinux/linux/issues/975
>
> Then build with Clang's integrated assembler:
> $ ARCH=arm CROSS_COMPILE=arm-linux-gnueabihf- make LLVM=1 LLVM_IAS=1 -j71
>
> I see a bunch of warnings
> (https://github.com/ClangBuiltLinux/linux/issues/858) which we will
> fix, but I am able to build and boot.  (CONFIG_THUMB2_KERNEL=y has
> many more issues, so I didn't pursue that further).
>
> Either way, these two adrl patches go a long way towards getting Clang
> to assemble an ARCH=arm kernel; thank you for all of the work that
> went into them.
>

My pleasure :-)

> One thing I noticed was that if I grep for `adrl` with all of the
> above applied within arch/arm, I do still see two more instances:
>
> crypto/sha256-armv4.pl
> 609:    adrl    $Ktbl,K256
>
> crypto/sha256-core.S_shipped
> 2679:   adrl    r3,K256
>
> Maybe those can be fixed up in patch 01/02 of this series for a v2?  I
> guess in this cover letter, you did specify *some occurrences of
> ADRL*.  It looks like those are guarded by
> 605 # ifdef __thumb2__
> ...
> 608 # else
> 609   adrl  $Ktbl,K256
>
> So are these always built as thumb2?
>

No need. The code in question is never assembled when built as part of
the kernel, only when building OpenSSL for user space. It appears
upstream has removed this already, but they have also been playing
weird games with the license blocks, so I'd prefer fixing the code
here rather than pulling the latest version.
