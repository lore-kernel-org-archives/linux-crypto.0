Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DE63FC433FE
	for <linux-crypto@archiver.kernel.org>; Wed, 23 Mar 2022 16:46:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237372AbiCWQsN (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 23 Mar 2022 12:48:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33462 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245518AbiCWQrz (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 23 Mar 2022 12:47:55 -0400
Received: from mout.kundenserver.de (mout.kundenserver.de [212.227.17.10])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9382DEB2
        for <linux-crypto@vger.kernel.org>; Wed, 23 Mar 2022 09:46:25 -0700 (PDT)
Received: from mail-wm1-f54.google.com ([209.85.128.54]) by
 mrelayeu.kundenserver.de (mreue108 [213.165.67.113]) with ESMTPSA (Nemesis)
 id 1M2OAi-1nVP5E3Are-003sH2; Wed, 23 Mar 2022 17:41:18 +0100
Received: by mail-wm1-f54.google.com with SMTP id 123-20020a1c1981000000b0038b3616a71aso1231626wmz.4;
        Wed, 23 Mar 2022 09:41:18 -0700 (PDT)
X-Gm-Message-State: AOAM531Nxs/XarV9jd9ywPi9FCuU+fSNA+0hfrkLNG8pTaniV5dIm110
        LwmR/5AEa9LypK5YEAuqTMg9M76Y+GeDLwYnDAo=
X-Google-Smtp-Source: ABdhPJzQ6+sWLiXr8Hp2o8LXfAR2AuwxHJYkOgUowaeEKHIJ0SuNttg2LIiHKo5yBPCGx6C4R7ZFcmIhEjJe1vVdEm0=
X-Received: by 2002:a05:600c:4b83:b0:38c:49b5:5bfc with SMTP id
 e3-20020a05600c4b8300b0038c49b55bfcmr10553256wmp.33.1648053678343; Wed, 23
 Mar 2022 09:41:18 -0700 (PDT)
MIME-Version: 1.0
References: <20220217162848.303601-1-Jason@zx2c4.com> <20220322155820.GA1745955@roeck-us.net>
 <YjoUU+8zrzB02pW7@sirena.org.uk> <0d20fb04-81b8-eeee-49ab-5b0a9e78c9f8@roeck-us.net>
 <YjsOHmvDgAxwLFMg@sirena.org.uk> <ebafdf77-5d96-556b-0197-a172b656bb01@roeck-us.net>
 <CAK8P3a1hzmXTTMsGcCA2ekEHnff+M7GrYSQDN4bVfVk6Ui=Apw@mail.gmail.com> <YjtIVymPEZ4t16tP@sirena.org.uk>
In-Reply-To: <YjtIVymPEZ4t16tP@sirena.org.uk>
From:   Arnd Bergmann <arnd@arndb.de>
Date:   Wed, 23 Mar 2022 17:41:01 +0100
X-Gmail-Original-Message-ID: <CAK8P3a0Fzryo8Wi2exbQz=qXKGOGU6yxP0FGowa-fJkr0aGJFg@mail.gmail.com>
Message-ID: <CAK8P3a0Fzryo8Wi2exbQz=qXKGOGU6yxP0FGowa-fJkr0aGJFg@mail.gmail.com>
Subject: Re: [PATCH v1] random: block in /dev/urandom
To:     Mark Brown <broonie@kernel.org>
Cc:     Arnd Bergmann <arnd@arndb.de>, Guenter Roeck <linux@roeck-us.net>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" 
        <linux-crypto@vger.kernel.org>,
        linux-arch <linux-arch@vger.kernel.org>,
        Dinh Nguyen <dinguyen@kernel.org>,
        Nick Hu <nickhu@andestech.com>,
        Max Filippov <jcmvbkbc@gmail.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        "David S . Miller" <davem@davemloft.net>,
        Yoshinori Sato <ysato@users.sourceforge.jp>,
        Michal Simek <monstr@monstr.eu>,
        Borislav Petkov <bp@alien8.de>, Guo Ren <guoren@kernel.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Joshua Kinard <kumba@gentoo.org>,
        David Laight <David.Laight@aculab.com>,
        Dominik Brodowski <linux@dominikbrodowski.net>,
        Eric Biggers <ebiggers@google.com>,
        Ard Biesheuvel <ardb@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andy Lutomirski <luto@kernel.org>,
        Kees Cook <keescook@chromium.org>,
        Lennart Poettering <mzxreary@0pointer.de>,
        Konstantin Ryabitsev <konstantin@linuxfoundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Theodore Ts'o" <tytso@mit.edu>
Content-Type: text/plain; charset="UTF-8"
X-Provags-ID: V03:K1:Nrnd2roAseJI6Rsq/gsTAvzXGUaLxalm6mS+yRoH6hjNj5E+ybe
 pjtUwrVkpNs4hw53lZDlcaj0RFwRa4SZ3gERjEcy//2/PFqlwGBnQjrdJtf9YXTdJZk8sxB
 f2SwahfUlt4yZKd9WLSPAU6ultg9xJXGZbAw5nVATNXvJjkFaxSfV4XK7z7QKlRU2CSECPL
 MGJi1RdQzugAzEYfQsgDA==
X-UI-Out-Filterresults: notjunk:1;V03:K0:HQwygQXpUv0=:LjVQAU7zBVgJ0TkwLeHsoI
 x1AtlIxe/2BkE0oNP1BUlvjxO3aVqiIGDn2UrwGxsVg5Xuig1Xn0NHUWSFsisZy9W7OfXFotB
 Frq03lxs/6pjx9FMma89OypaGD/caIYc5NOXEDIC2WImxZG4qwvLMi2UiIA39Bys5wq0QaVvW
 6YojZCMit8HhZlZx2quE+Z8tut09W9YwHiHqmJOFy4uVo4DlVJeWNZl5mpBiVwbRS9MEtxltJ
 d+KPStjp2wWRaE8H/03Jg+8FsU0fDV8+lNRxDXEoIF2IzxhmUB0P3GXKA2g44D8XSk/6GFrbl
 dBSr5FQehG80NXMeUKhyW6/hgugeiltluqbkSqfOegCuC1yxgVxBSTJELeISOalSf43XGX+ep
 Z4Jc/w1MPLFv1tGugE8hNIkF/tA9ahJqS7xoeuT+5FV99skGSsiLJmFcHNUWpGpDzguAo1viC
 eqgmvN8mtMwY56w6pJsz/Hdub8UecVFwMooLa0b6fBg8BA41Xu7xbVj4Mg/rO7X1CVw+QYfjS
 Z82aPv+VsHUt9GFaKjdI9MZkYmTxxtOCIFC1QPK0T9f2bdLZsKaE/5HAaF94MDuKr5q0Ce6Ci
 0bnYT8h2Wdzu2m6JhHKNBkuyXzIBPQaUONTk9492Jc7ddYZPeVSqCjLTfgpeHkLZNlg4J7f3g
 w7sV8QIty8ydCSt+QYjtzePCSop3iMqxb21iAHXHTIINJ/TFWr5Gg9xKAhxIV9n6btyzdk/6M
 Ip3Rt48dcCJ36yllWwvGDzol1UpCR4Rgf+Q3MtKWNbNzwjJa8PhyjsAM588sLUcm7GcD2VvSL
 prOtVWaWOUuRU54CIdEFiX9fMmSw84r4nZOm5JnNaT74lJdvzA=
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, Mar 23, 2022 at 5:18 PM Mark Brown <broonie@kernel.org> wrote:
>
> On Wed, Mar 23, 2022 at 04:53:13PM +0100, Arnd Bergmann wrote:
> > On Wed, Mar 23, 2022 at 3:23 PM Guenter Roeck <linux@roeck-us.net> wrote:
>
> > > I don't think it is entirely academic. versatile-pb fails for me;
> > > if it doesn't fail at KernelCI, I'd like to understand why - not to
> > > fix it in my test environment, but to make sure that I _don't_ fix it.
> > > After all, it _is_ a regression. Even if that regression is triggered
> > > by bad (for a given definition of "bad") userspace code, it is still
> > > a regression.
>
> > Maybe kernelci has a virtio-rng device assigned to the machine
> > and you don't? That would clearly avoid the issue here.
>
> No, nothing I can see in the boot log:
>
> https://storage.kernelci.org/next/master/next-20220323/arm/versatile_defconfig/gcc-10/lab-baylibre/baseline-qemu_arm-versatilepb.html
>
> and I'd be surprised if virtio devices made it through with a specific
> platform emulation.

In general they do: virtio devices appear as regular PCI devices
and get probed from there, as long as the drivers are available.

It looks like the PCI driver does not get initialized here though,
presumably because it's not enabled in versatile_defconfig.
It used to also not be enabled in multi_v5_defconfig, but I have
merged a patch from Anders that enables it in 5.18 for the
multi_v5_defconfig.

> However it looks like for that test the init
> scripts didn't do anything with the random seed (possibly due to running
> from ramdisk?) so we'd not have hit the condition.

Right.

     Arnd
