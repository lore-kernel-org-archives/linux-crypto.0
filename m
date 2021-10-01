Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A7A95C433F5
	for <linux-crypto@archiver.kernel.org>; Fri,  1 Oct 2021 10:58:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 88FC3613A0
	for <linux-crypto@archiver.kernel.org>; Fri,  1 Oct 2021 10:58:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353703AbhJALAP (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 1 Oct 2021 07:00:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60608 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353421AbhJALAC (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 1 Oct 2021 07:00:02 -0400
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F8A8C061775
        for <linux-crypto@vger.kernel.org>; Fri,  1 Oct 2021 03:58:18 -0700 (PDT)
Received: by mail-ed1-x536.google.com with SMTP id bd28so33190321edb.9
        for <linux-crypto@vger.kernel.org>; Fri, 01 Oct 2021 03:58:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=TTPu8WxtNfGWy6R5J1kog5z5I/HdOclpvXu9/TjPYkI=;
        b=B3n84obtuH7/Si/VlCtf999g8dmTgTCF7dKj2Y+QtfZRj9P/Ei0BDjyll/MPzeBR3p
         lZKj7iiD5IE4rSJs4rG7VXvz+GVY0hKYusNJf8O6b5RNrLuW+wokveyxAQbBQQem8L7m
         rUtXTEzLPpQcupg44C/C7i3GCX9fsMZpzN3FJHtxql5SlFo/cIy3VGHGIEBhrmx4B0gQ
         KD5dLJSr3j+dwPuMFFTNX2rmXmZNWsKx2DapKheI8AsDsbokl8XpH1hxxlfHFB2SCZOk
         mio1id1dA9aTUJEiWNgbx4vzND9FlZhZJNwVfMoqcNchr8i6vdtbgZw1jQI3wF6GXBoX
         spUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=TTPu8WxtNfGWy6R5J1kog5z5I/HdOclpvXu9/TjPYkI=;
        b=Ba+WotkIBuFm4IiMX6D/Qu+o4k2TZSxoLd5KB4zxk8V0qCrDVxZ4zKa4D8LXGLkcmg
         NF7IyYdByE2Bq1KYWVbdyO95qXk6Kt6/QBxhs4xTxEGBP/MN9iaL3mGGVJ6BJoy2LgmU
         KTJQOVsbhDMpXBWhVQLi65VWLfB7RnQjKBdnjr7Oe3HQRVQ5zUia0IvxduLS51/NazzI
         slUgdIQvNBPzRADc6Z/JOWJkCUxWz55in4ilXDBrmM+NzF/v5FVOOFehS+KIBYWMQozk
         CHubtLkm5fmCK5DiD1Z3J4bASqKfu6jgCu3OqtlmmlEuav+gAj31AkRZOgnETGi7+x/L
         Y4Ow==
X-Gm-Message-State: AOAM531PCkKoXdKu/9a7kbVmN8j6IHr3gve37YQiPr5PZIlmgoPon4ov
        XRe5wmT7jaQtmBeAGLj8MdgROdo98GxCnArtvXUg7exk9kVoRQ==
X-Google-Smtp-Source: ABdhPJwkF1v2pLCEee/7m9lD3UfOJZ8LUK6b8P9lh2U8MQoc3XULSTy6PlmyP5Bwm2WP9Skoc3BaD2s0lMvBcqFqvdM=
X-Received: by 2002:a17:906:318b:: with SMTP id 11mr5664872ejy.493.1633085896597;
 Fri, 01 Oct 2021 03:58:16 -0700 (PDT)
MIME-Version: 1.0
References: <20210913071251.GA15235@gondor.apana.org.au> <20210917002619.GA6407@gondor.apana.org.au>
 <YVNfqUVJ7w4Z3WXK@archlinux-ax161> <20211001055058.GA6081@gondor.apana.org.au>
In-Reply-To: <20211001055058.GA6081@gondor.apana.org.au>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Fri, 1 Oct 2021 16:28:05 +0530
Message-ID: <CA+G9fYvZC3+hfkMXWte1vUmmO9jLnTNnCrVMhHYnJjw15MWzSw@mail.gmail.com>
Subject: Re: [v2 PATCH] crypto: api - Fix built-in testing dependency failures
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     Nathan Chancellor <nathan@kernel.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Vladis Dronov <vdronov@redhat.com>,
        Simo Sorce <ssorce@redhat.com>,
        Eric Biggers <ebiggers@kernel.org>, llvm@lists.linux.dev,
        lkft-triage@lists.linaro.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi Herbert,


I do see the reported problem while building modules.
you may use the steps to reproduce.

On Fri, 1 Oct 2021 at 11:58, Herbert Xu <herbert@gondor.apana.org.au> wrote:
>
> On Tue, Sep 28, 2021 at 11:32:09AM -0700, Nathan Chancellor wrote:
> >
> > This patch as commit 3cefb01905df ("crypto: api - Fix built-in testing
> > dependency failures") in -next (along with the follow up fix) causes the
> > following depmod error:
> >
> > $ make -skj"$(nproc)" ARCH=powerpc CROSS_COMPILE=powerpc-linux- INSTALL_MOD_PATH=rootfs ppc44x_defconfig all modules_install
> > depmod: ERROR: Cycle detected: crypto -> crypto_algapi -> crypto
> > depmod: ERROR: Found 2 modules in dependency cycles!
> > make: *** [Makefile:1946: modules_install] Error 1
> >
> > Initially reported on our CI:
> >
> > https://github.com/ClangBuiltLinux/continuous-integration2/runs/3732847295?check_suite_focus=true
>
> That's weird, I can't reproduce this.  Where can I find your Kconfig
> file? Alternatively, can you identify exactly what is in algapi that
> is being depended on by crypto?
>
> The crypto module should be at the very base and there should be no
> depenedencies from it on algapi.  The algapi module is meant to be
> on top of crypto obviously.


#!/bin/sh

# TuxMake is a command line tool and Python library that provides
# portable and repeatable Linux kernel builds across a variety of
# architectures, toolchains, kernel configurations, and make targets.
#
# TuxMake supports the concept of runtimes.
# See https://docs.tuxmake.org/runtimes/, for that to work it requires
# that you install podman or docker on your system.
#
# To install tuxmake on your system globally:
# sudo pip3 install -U tuxmake
#
# See https://docs.tuxmake.org/ for complete documentation.


tuxmake --runtime podman --target-arch mips --toolchain gcc-10
--kconfig rt305x_defconfig


# to reproduce this build locally: tuxmake --target-arch=mips
--kconfig=rt305x_defconfig --toolchain=gcc-10 --wrapper=sccache
--environment=KBUILD_BUILD_TIMESTAMP=@1633074287
--environment=KBUILD_BUILD_USER=tuxmake
--environment=KBUILD_BUILD_HOST=tuxmake
--environment=SCCACHE_BUCKET=sccache.tuxbuild.com --runtime=podman
--image=855116176053.dkr.ecr.us-east-1.amazonaws.com/tuxmake/mips_gcc-10
config default kernel xipkernel modules dtbs dtbs-legacy debugkernel
headers
make --silent --keep-going --jobs=8
O=/home/tuxbuild/.cache/tuxmake/builds/current ARCH=mips
CROSS_COMPILE=mips-linux-gnu- 'CC=sccache mips-linux-gnu-gcc'
'HOSTCC=sccache gcc' rt305x_defconfig
make --silent --keep-going --jobs=8
O=/home/tuxbuild/.cache/tuxmake/builds/current ARCH=mips
CROSS_COMPILE=mips-linux-gnu- 'CC=sccache mips-linux-gnu-gcc'
'HOSTCC=sccache gcc'
make --silent --keep-going --jobs=8
O=/home/tuxbuild/.cache/tuxmake/builds/current ARCH=mips
CROSS_COMPILE=mips-linux-gnu- 'CC=sccache mips-linux-gnu-gcc'
'HOSTCC=sccache gcc' uImage.gz
make --silent --keep-going --jobs=8
O=/home/tuxbuild/.cache/tuxmake/builds/current ARCH=mips
CROSS_COMPILE=mips-linux-gnu- 'CC=sccache mips-linux-gnu-gcc'
'HOSTCC=sccache gcc' modules_install INSTALL_MOD_STRIP=1
INSTALL_MOD_PATH=/home/tuxbuild/.cache/tuxmake/builds/current/modinstall
depmod: ERROR: Cycle detected: crypto -> crypto_algapi -> crypto
depmod: ERROR: Found 2 modules in dependency cycles!
make[1]: *** [/builds/linux/Makefile:1961: modules_install] Error 1
make: *** [Makefile:226: __sub-make] Error 2
make: Target 'modules_install' not remade because of errors.


--
Linaro LKFT
https://lkft.linaro.org
