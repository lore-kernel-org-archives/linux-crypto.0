Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 796A6C433F5
	for <linux-crypto@archiver.kernel.org>; Wed, 13 Oct 2021 13:04:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5CDC6610CB
	for <linux-crypto@archiver.kernel.org>; Wed, 13 Oct 2021 13:04:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231294AbhJMNGD (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 13 Oct 2021 09:06:03 -0400
Received: from mout.kundenserver.de ([212.227.17.24]:36415 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231516AbhJMNGC (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 13 Oct 2021 09:06:02 -0400
Received: from mail-wr1-f45.google.com ([209.85.221.45]) by
 mrelayeu.kundenserver.de (mreue108 [213.165.67.113]) with ESMTPSA (Nemesis)
 id 1M7sM0-1meTfg1hQY-0053nk; Wed, 13 Oct 2021 15:03:58 +0200
Received: by mail-wr1-f45.google.com with SMTP id r7so8143753wrc.10;
        Wed, 13 Oct 2021 06:03:58 -0700 (PDT)
X-Gm-Message-State: AOAM532deevjCKNRsTK3QplimFN3rRsPI+gWcQK1HOWK8cZwoz6T89pu
        RE2YyhtZkLNAmHTpdoN18fhuZCXDZ6qK4pf71w0=
X-Google-Smtp-Source: ABdhPJxrqmezALSBTO/BTYl8vNqV31BBADHOaBtQOotspl4zEqXFT9c7CCMDgePjQq0qoxmKIaQg8BmmJRdC0kZoEJA=
X-Received: by 2002:a05:600c:1548:: with SMTP id f8mr13062202wmg.35.1634130237935;
 Wed, 13 Oct 2021 06:03:57 -0700 (PDT)
MIME-Version: 1.0
References: <20211011152941.12847-1-vegard.nossum@oracle.com>
 <YWbQd51r8R3BprMi@kroah.com> <1bfd3945-3487-31ab-5489-9c12c759276b@oracle.com>
In-Reply-To: <1bfd3945-3487-31ab-5489-9c12c759276b@oracle.com>
From:   Arnd Bergmann <arnd@arndb.de>
Date:   Wed, 13 Oct 2021 15:03:41 +0200
X-Gmail-Original-Message-ID: <CAK8P3a05E2muUiy0KcRgzhGef-Xg99_pY3gnDpWt7uHmbTxVGg@mail.gmail.com>
Message-ID: <CAK8P3a05E2muUiy0KcRgzhGef-Xg99_pY3gnDpWt7uHmbTxVGg@mail.gmail.com>
Subject: Re: [PATCH] staging: ks7010: select CRYPTO_HASH/CRYPTO_MICHAEL_MIC
To:     Vegard Nossum <vegard.nossum@oracle.com>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Arnd Bergmann <arnd@arndb.de>, linux-staging@lists.linux.dev,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Randy Dunlap <rdunlap@infradead.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" 
        <linux-crypto@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Provags-ID: V03:K1:g5pi1PT7/bTFPDH4BswBgDSug71I9IFuCMcnFhyW6XNEeEmNOAV
 hHyE0EPeJNHdzMJA3+BLejxpY18Vi5YVuDDu972WML9BhMWKI1aHmz4ANa/x1JisEnUofFn
 q/9leCPfVcs86y7bg0xsnF+wqC6f9VakuO/483wws0DfC3nUZPwryJfBiJ+gHcyxRcnWUj4
 +XcQTMSUss60//Vldt5xw==
X-UI-Out-Filterresults: notjunk:1;V03:K0:HOSRj9vWFng=:r2VdZPsvJVAUpgkx5eOHab
 QnJM3l7EnFLJILbhOX9urY68W5X/Ze/4qbBqeHz1JCh7bVEXT5UgbSidebh7lFdQcGpgsudfC
 9Xa1Dq0bviis9rF+luBnJQb0LFTvvjSsFxfaMOcp90jfeXCuWVLMEg87y+emkhfaQ7dXZvkzQ
 4QEX7m+YebRoQGXPN5xaOZ6cmJEakw7s58xiSTORTUMSTyuA2TqAgZPkPg1RUoqKMzrR2pJBZ
 aLaomllnnTk+gigGVk+RedaPUsIa8at+Yve4TDTKsDSsnvMMlF0o6hP9E4hDNV4MspInri7Ea
 FiPWSstQ4IDXZfKKI1bRZF3dWL10Dcn4T4SWOKotK++EH6WsH4ezY4iaMSjG69kxx2YCjWmqM
 2vIC1VAK8Wp28Dv9rHgdhEgotiuBy6pvMMi0eaFbbUS4R+XhBaqa3E7yEahn+IIAFr8I09IyG
 wJZ3eePZpYbhRi/LxQHpSr6cTso/LW8q1oNxDg+VOFI4DQI+FATGF3HT7+RWs/mN4G+zKbEFJ
 Gb8XIBA1M/fGhs23QwXKrGFDwpLn3jf13bbCUB+mFIZwX1xl4fe9DnqESY/JATGiuZSqwUjLp
 Vtvm/XscIdRTUTCNi/eVK8vyOF7meQEh/Jksb2juzXR/f3+41Mc+BTG90Oj/HGTQRlPxMPxGo
 EiLZKI8tge/UgWNOPWyPV6Raas8wPfuJe/RXPpwCshiLr8w59C9sLcaLzFBEQjXamTtJN+q26
 qQAohWAsmKKyvgBDJT6liuoGF6dybV/agdzM2w==
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, Oct 13, 2021 at 2:51 PM Vegard Nossum <vegard.nossum@oracle.com> wrote:
> On 10/13/21 2:26 PM, Greg Kroah-Hartman wrote:
> > On Mon, Oct 11, 2021 at 05:29:41PM +0200, Vegard Nossum wrote:
> >> Fix the following build/link errors:
> >>
> >>   ld: drivers/staging/ks7010/ks_hostif.o: in function `michael_mic.constprop.0':
> >>   ks_hostif.c:(.text+0x95b): undefined reference to `crypto_alloc_shash'
> >>   ld: ks_hostif.c:(.text+0x97a): undefined reference to `crypto_shash_setkey'
> >>   ld: ks_hostif.c:(.text+0xa13): undefined reference to `crypto_shash_update'
> >>   ld: ks_hostif.c:(.text+0xa28): undefined reference to `crypto_shash_update'
> >>   ld: ks_hostif.c:(.text+0xa48): undefined reference to `crypto_shash_finup'
> >>   ld: ks_hostif.c:(.text+0xa6d): undefined reference to `crypto_destroy_tfm'
> >>
> >> Signed-off-by: Vegard Nossum <vegard.nossum@oracle.com>
> >> ---
> >>  drivers/staging/ks7010/Kconfig | 3 +++
> >>  1 file changed, 3 insertions(+)
> >>
> >> diff --git a/drivers/staging/ks7010/Kconfig b/drivers/staging/ks7010/Kconfig
> >> index 0987fdc2f70db..8ea6c09286798 100644
> >> --- a/drivers/staging/ks7010/Kconfig
> >> +++ b/drivers/staging/ks7010/Kconfig
> >> @@ -5,6 +5,9 @@ config KS7010
> >>      select WIRELESS_EXT
> >>      select WEXT_PRIV
> >>      select FW_LOADER
> >> +    select CRYPTO
> >> +    select CRYPTO_HASH
> >> +    select CRYPTO_MICHAEL_MIC
> >
> > Let's try to rely on 'depend' and not 'select' please.
>
> I used 'select' because it seemed to be the established pattern for
> these options.

Yes, this is the correct way to do it here. In general, using "depends on"
is better than "select", especially when crossing subsystem boundaries,
however mixing the two is what really hurts because of the circular
dependencies you'd get.

The only way we could use 'depends on' here would be to change all
the other drivers to do the same.

> Compare:
>
> $ find -name '*Kconfig*' | xargs git grep 'depends on CRYPTO$' | wc --lines
> 1
>
> $ find -name '*Kconfig*' | xargs git grep 'select CRYPTO$' | wc --lines
> 66
>
> $ find -name '*Kconfig*' | xargs git grep 'depends on CRYPTO' | wc --lines
> 87
>
> $ find -name '*Kconfig*' | xargs git grep 'select CRYPTO' | wc --lines
> 1005
>
> That said, I have found several other cases where CRYPTO_* algorithms
> are getting 'select'-ed without also selecting CRYPTO/CRYPTO_HASH, so I
> definitely see the problem you're trying to address.
>
> I've added some more people on Cc to see if there is a consensus on the
> best way to do this for the CRYPTO* options going forwards. Thoughts,
> anybody?

I don't think there is much point in trying to change the
existing pattern for crypto. We might want to change some of those
that use 'depends on' at the moment for consistency, though most of
those look correct as well.

        Arnd
