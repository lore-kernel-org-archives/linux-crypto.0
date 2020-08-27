Return-Path: <SRS0=IKCX=CF=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C34FEC433DF
	for <linux-crypto@archiver.kernel.org>; Thu, 27 Aug 2020 19:12:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A8E5220707
	for <linux-crypto@archiver.kernel.org>; Thu, 27 Aug 2020 19:12:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726802AbgH0TML (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 27 Aug 2020 15:12:11 -0400
Received: from mout.kundenserver.de ([212.227.126.130]:51453 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726217AbgH0TML (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 27 Aug 2020 15:12:11 -0400
Received: from mail-qt1-f173.google.com ([209.85.160.173]) by
 mrelayeu.kundenserver.de (mreue009 [212.227.15.129]) with ESMTPSA (Nemesis)
 id 1MI5YN-1kQY180hEd-00F8cb; Thu, 27 Aug 2020 21:12:09 +0200
Received: by mail-qt1-f173.google.com with SMTP id s16so5466633qtn.7;
        Thu, 27 Aug 2020 12:12:08 -0700 (PDT)
X-Gm-Message-State: AOAM530+E3lTESCOzfSjs0XQ8qMNRt/gseORMyI5ADU1CRZWf1jnqMX2
        im7gz4j9w5E4FU662l7KXEi7oS3unZYHU2sCkiY=
X-Google-Smtp-Source: ABdhPJw+EArXZgXPjTSlMpKXPTOCSg68mzTCJLgLPGwcSgT0kaAMa3+ESnArOyRY8vKEKWcSZ3Y3GojZIw9BZzhKPWI=
X-Received: by 2002:ac8:4652:: with SMTP id f18mr19785013qto.142.1598555527951;
 Thu, 27 Aug 2020 12:12:07 -0700 (PDT)
MIME-Version: 1.0
References: <202008271145.xE8qIAjp%lkp@intel.com> <20200827080558.GA3024@gondor.apana.org.au>
 <CAMj1kXHJrLtnJWYBKBYRtNHVS6rv51+crMsjLEnSqkud0BBaWw@mail.gmail.com>
 <20200827082447.GA3185@gondor.apana.org.au> <CAHk-=wg2RCgmW_KM8Gf9-3VJW1K2-FTXQsGeGHirBFsG5zPbsg@mail.gmail.com>
 <CAHk-=wgXW=YLxGN0QVpp-1w5GDd2pf1W-FqY15poKzoVfik2qA@mail.gmail.com>
In-Reply-To: <CAHk-=wgXW=YLxGN0QVpp-1w5GDd2pf1W-FqY15poKzoVfik2qA@mail.gmail.com>
From:   Arnd Bergmann <arnd@arndb.de>
Date:   Thu, 27 Aug 2020 21:11:52 +0200
X-Gmail-Original-Message-ID: <CAK8P3a10oUYQHrSu-2rsa_rVemz3K+NBQtsuazn=dBAntsx1cw@mail.gmail.com>
Message-ID: <CAK8P3a10oUYQHrSu-2rsa_rVemz3K+NBQtsuazn=dBAntsx1cw@mail.gmail.com>
Subject: Re: lib/crypto/chacha.c:65:1: warning: the frame size of 1604 bytes
 is larger than 1024 bytes
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     Herbert Xu <herbert@gondor.apana.org.au>,
        Ard Biesheuvel <ardb@kernel.org>,
        kernel test robot <lkp@intel.com>,
        Peter Oberparleiter <oberpar@linux.ibm.com>,
        Kees Cook <keescook@chromium.org>,
        Andrey Ryabinin <aryabinin@virtuozzo.com>,
        kbuild-all@lists.01.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Provags-ID: V03:K1:rTGqvJp83cJvMl7PXhpT5npUgzEZjaJBngQQyqMDgjCmE0/Gi70
 JqIMY3G8MLjBXxL86mdAzHXCwQhCF+2ZHcCr5bHBAetJpq8u26xxDYwor/BhGqVq16zfVce
 zQZTFwcroWzaeucxsyunge347rVzcy0kd6FN3MSXoFYpBa3E9zCrVTIyYggWAARGvkkkEYZ
 xg3QQcGtSWM3v3uBbUj3g==
X-UI-Out-Filterresults: notjunk:1;V03:K0:3VzedD9GP/Q=:FCHiPVRz5+gKVGDFVZ7H5o
 8IwiKxJvOXhJ+g86BeUfEgLViezfCLzXSFO78+ZWcz/pZLkd5mpV5UY+Vz/O+4pmBbb1m3T6o
 LV3Qj58BER05K/BFX97uq0dmjHq30DsSySi/lEKD/zXl8VTA8IC5R0kSnKlBMnVvw7lCTREh/
 K53/hEjyeDS3pIrDSJdBr7TkFaqoOkPuqJP8dM5kktm2hmExMEbDOtX/TWhBzU/JpgXAPgGr7
 FZz+/tXO/PkJ2t+Th3JVZTJTZ+XWhVohrYaRTn6kR1R5XD49TfLf8H4dg37DW4NfYv/HsBGVW
 4tQSOqGnqlN3d3Yx7V36qfIrCLisx2I8jbjtLMPtPVlK4IKORLAEC0T6a3RYmlfNhOhYzPtYA
 ijY6LRb/kaxmbgfYJOoCzyANxH58yjvRw6rT2xh3yoD93kDRPA444aIe0D8sr5B3DNwi9q45H
 sxU73vQwUytdfGh++AD1CucUW7XFmE9kSkuofwuEmmSt2ukmkTgAijm4o+aMFD6lBUZqBQPqL
 /MFRwRd5YzZnbk3RxcOpt7HcjLjWxYz4zLyShTSoQS1MkyaKDO3Fqi+mK16693o/28bVadNzo
 BLcpb3BVOQ+vmF43POb8vG8xHNSIuV/tKpY3HrbkEtBxesRPj+EDeMfAFJLO2Vz4gYkLMFhG+
 lyHdTjOg0cKV6GlDFXDkONbBbSH9bViqZpTHuEwU8DcDhF/itLigNxpU1sR1Zfv+vHYt9XtFo
 897+tgSq1IY+WDVyaiIlP/WUvCtDZes5vF2x0QsTtrEZXliB7quwZwF+KBDjcR/HQE/4e53GI
 mpBO7WNTvOIp1jxXh4jGq+2olvVieAU+Gtnud9aNfWmqO8fVnurByFFoni0KuD/29OJd9LIFS
 kXbH0Tkg8ajN5V4KOraI7c+3a9hkAwxtTF5jIjLV8GhDtzwVvKG4zIKRqvJY7roDM6zISluHN
 kiC2bQn8FHnhnOkA6UL6LTuFieYY6q+qxuM47EthPg/C01MlbuvWH
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, Aug 27, 2020 at 7:55 PM Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> On Thu, Aug 27, 2020 at 10:34 AM Linus Torvalds
> <torvalds@linux-foundation.org> wrote:
> >
> > How are you guys testing? I have UBSAN and GCOV on, and don't see
> > crazy frames on either i386 or x86-64.
>
> Oh, never mind. I also have COMPILE_TEST on, so it ends up disabling
> GCOV_PROFILE_ALL and UBSAN_SANITIZE_ALL.

Ah right, that explains why I never saw the warning in my randconfig
build tests, I run those with COMPILE_TEST force-enabled.

       Arnd
