Return-Path: <SRS0=yTfj=C2=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.4 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_IN_DEF_DKIM_WL autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1FDEAC43461
	for <linux-crypto@archiver.kernel.org>; Thu, 17 Sep 2020 01:01:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B97F6206D4
	for <linux-crypto@archiver.kernel.org>; Thu, 17 Sep 2020 01:01:08 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="g7ls+wXD"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726115AbgIQBBF (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 16 Sep 2020 21:01:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726043AbgIQBBF (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 16 Sep 2020 21:01:05 -0400
X-Greylist: delayed 427 seconds by postgrey-1.27 at vger.kernel.org; Wed, 16 Sep 2020 21:01:05 EDT
Received: from mail-pl1-x642.google.com (mail-pl1-x642.google.com [IPv6:2607:f8b0:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89225C06174A
        for <linux-crypto@vger.kernel.org>; Wed, 16 Sep 2020 17:53:57 -0700 (PDT)
Received: by mail-pl1-x642.google.com with SMTP id q12so178682plr.12
        for <linux-crypto@vger.kernel.org>; Wed, 16 Sep 2020 17:53:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=UHXe8iYDqbXJhcZhqaDlBEYhOfPuDW+vWctFtPj2bbY=;
        b=g7ls+wXDCDWAV+tSWIM69z92zxElt2pZ0KGYV0VcG/MgoggQU7BugvHKxqqlZH6+sn
         371BpilhWjSDLK9fuFz0CSmS1hFpznnJ8888BRiwTSsuEHF6Ov+S5K1k7ppeNKFZeDFg
         U1UosgeU4jYESuI4Pkl+o6VOAU8z41ZNbN+k/VZTT6YjsM25yfBpu764kleaZ7YEEq8k
         7GIZfBbZaiLWT4CTNG8CuCgrnr4y4QJURH9jr7JzAqtyQphTP4iZUNjKKZrqV/dSIWUm
         YOW9bc4PjZjn3LWW4ewpaRB7E7j1RvrBBp3ywMCGkk1xJ/BkSs02vrSDno77HSQBaU48
         KngA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=UHXe8iYDqbXJhcZhqaDlBEYhOfPuDW+vWctFtPj2bbY=;
        b=pQPrvX7tIe1dCqqG/TJgfLR95cl1pMuE1S4vJH1P7ovlbbwTjTIipQT1qebg+XFIC7
         3rZIzAIhNydor1Ahc+If8DhDKQ+PtKFUzg/wW6mN5GSy36LUKyI4fo2FZW57Sjr2LlpU
         aawYcmgnW+336QRLU7uGwt5ihsbi2yyNBdmWWP1dQ8DdbMuSSZ+EmxhWS0NVyKu2ruXn
         mIPRc5V/8txHrY7kouGe/sVKOP8iYUbFwTD1uvt5rXufLSKHBlz5s6YCBv5WfgROCRgT
         iOmhse+1cSYWvlNYLZhuRpbCQr54cRdeyrwbKaswbzq3a46bfFENhYz6MyxuED0xkzth
         EPEg==
X-Gm-Message-State: AOAM530a+k/FE3bk01CQCte4l26nw5l2rnUAHEHPsoyyQvwgF5Lwti9c
        CsgdwukIZW6k0y6hA4nl0q/QjGQqAtj0bzwFyeYqWA==
X-Google-Smtp-Source: ABdhPJwaAAIRWSLpwx6D7k6rxiH+JSiPbfrxESVtn+/sb5aLzZNi6gbFEL4rFKkU0Lh4GACgPMOKkkoYQlny2X0b6FQ=
X-Received: by 2002:a17:90b:698:: with SMTP id m24mr6193138pjz.32.1600304036522;
 Wed, 16 Sep 2020 17:53:56 -0700 (PDT)
MIME-Version: 1.0
References: <20200916061418.9197-1-ardb@kernel.org>
In-Reply-To: <20200916061418.9197-1-ardb@kernel.org>
From:   Nick Desaulniers <ndesaulniers@google.com>
Date:   Wed, 16 Sep 2020 17:53:44 -0700
Message-ID: <CAKwvOdmqFoVxQz9Z_9sM_m3qykVbavnUnkCvy_G2S2aPEofTog@mail.gmail.com>
Subject: Re: [PATCH v2 0/2] crypto: arm/sha-neon - avoid ADRL instructions
To:     Ard Biesheuvel <ardb@kernel.org>
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

On Tue, Sep 15, 2020 at 11:14 PM Ard Biesheuvel <ardb@kernel.org> wrote:
>
> Remove some occurrences of ADRL in the SHA NEON code adopted from the
> OpenSSL project.
>
> I will leave it to the Clang folks to decide whether this needs to be
> backported and how far, but a Cc stable seems reasonable here.
>
> Cc: Nick Desaulniers <ndesaulniers@google.com>
> Cc: Stefan Agner <stefan@agner.ch>
> Cc: Peter Smith <Peter.Smith@arm.com>

Tested-by: Nick Desaulniers <ndesaulniers@google.com>

Thanks Ard:
compile+boot tested each combination of:

[gcc, clang]x[defconfig, defconfig+CONFIG_THUMB2_KERNEL=y].

Now, if I additionally apply:
1. this series
2. the adr_l series:
https://lore.kernel.org/linux-arm-kernel/20200914095706.3985-1-ardb@kernel.org/
3. unrelated fix for -next #1:
https://lore.kernel.org/lkml/20200916200255.1382086-1-ndesaulniers@google.com/
4. unrelated fix for -next #2:
https://lore.kernel.org/linux-mm/20200917001934.2793370-1-ndesaulniers@google.com/
5. small fixup to 01/12 from #2:
https://lore.kernel.org/linux-arm-kernel/CAMj1kXFmF_24d-7W8AWTJR-PCcja7bUdHhYKptGQmsV4vNp=sA@mail.gmail.com/
6. vfp fixup for thumb+gcc:
https://lore.kernel.org/linux-arm-kernel/CAMj1kXHEpPc0MSoMrCxEkyb44AkLM2NJJGtOXLpr6kxBHS0vfA@mail.gmail.com/
7. disable CONFIG_IWMMXT https://github.com/ClangBuiltLinux/linux/issues/975

Then build with Clang's integrated assembler:
$ ARCH=arm CROSS_COMPILE=arm-linux-gnueabihf- make LLVM=1 LLVM_IAS=1 -j71

I see a bunch of warnings
(https://github.com/ClangBuiltLinux/linux/issues/858) which we will
fix, but I am able to build and boot.  (CONFIG_THUMB2_KERNEL=y has
many more issues, so I didn't pursue that further).

Either way, these two adrl patches go a long way towards getting Clang
to assemble an ARCH=arm kernel; thank you for all of the work that
went into them.

One thing I noticed was that if I grep for `adrl` with all of the
above applied within arch/arm, I do still see two more instances:

crypto/sha256-armv4.pl
609:    adrl    $Ktbl,K256

crypto/sha256-core.S_shipped
2679:   adrl    r3,K256

Maybe those can be fixed up in patch 01/02 of this series for a v2?  I
guess in this cover letter, you did specify *some occurrences of
ADRL*.  It looks like those are guarded by
605 # ifdef __thumb2__
...
608 # else
609   adrl  $Ktbl,K256

So are these always built as thumb2?

>
> Ard Biesheuvel (2):
>   crypto: arm/sha256-neon - avoid ADRL pseudo instruction
>   crypto: arm/sha512-neon - avoid ADRL pseudo instruction
>
>  arch/arm/crypto/sha256-armv4.pl       | 4 ++--
>  arch/arm/crypto/sha256-core.S_shipped | 4 ++--
>  arch/arm/crypto/sha512-armv4.pl       | 4 ++--
>  arch/arm/crypto/sha512-core.S_shipped | 4 ++--
>  4 files changed, 8 insertions(+), 8 deletions(-)
>
> --
> 2.17.1
>


-- 
Thanks,
~Nick Desaulniers
