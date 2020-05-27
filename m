Return-Path: <SRS0=h1Lr=7J=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E06FDC433DF
	for <linux-crypto@archiver.kernel.org>; Wed, 27 May 2020 18:24:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CC67B2088E
	for <linux-crypto@archiver.kernel.org>; Wed, 27 May 2020 18:24:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387831AbgE0SYz (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 27 May 2020 14:24:55 -0400
Received: from mout.kundenserver.de ([212.227.126.135]:48571 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387581AbgE0SYy (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 27 May 2020 14:24:54 -0400
Received: from mail-qv1-f42.google.com ([209.85.219.42]) by
 mrelayeu.kundenserver.de (mreue012 [212.227.15.129]) with ESMTPSA (Nemesis)
 id 1N0Ip5-1iqA1z3UIR-00xLd2; Wed, 27 May 2020 20:24:53 +0200
Received: by mail-qv1-f42.google.com with SMTP id l17so1274480qvd.9;
        Wed, 27 May 2020 11:24:52 -0700 (PDT)
X-Gm-Message-State: AOAM533edKJHJBr1DHbZTAKS4NkkP1uIcq1RUWr2S2BsdAy7/9QOjeAJ
        NaQUGFrqQFVeLkixfz4sA2b5QKT+L5QW+Yjiows=
X-Google-Smtp-Source: ABdhPJwlpxngs4ccsRphUYTxHPAqCd4Pt0UuPoyK80QLITdOg+Os/S59DS3fv0e+Hg99ETAobtfiBQ+7oVr2Z7F+ywQ=
X-Received: by 2002:ad4:58cb:: with SMTP id dh11mr24502415qvb.211.1590603891635;
 Wed, 27 May 2020 11:24:51 -0700 (PDT)
MIME-Version: 1.0
References: <20200527141754.1850968-1-arnd@arndb.de> <20200527164219.GB1073507@ubuntu-s3-xlarge-x86>
In-Reply-To: <20200527164219.GB1073507@ubuntu-s3-xlarge-x86>
From:   Arnd Bergmann <arnd@arndb.de>
Date:   Wed, 27 May 2020 20:24:35 +0200
X-Gmail-Original-Message-ID: <CAK8P3a1NS3OCNzD3uCjLmJvdcfLRguaoHtuTKXEuvizmbsQYhA@mail.gmail.com>
Message-ID: <CAK8P3a1NS3OCNzD3uCjLmJvdcfLRguaoHtuTKXEuvizmbsQYhA@mail.gmail.com>
Subject: Re: [PATCH] x86: crypto: fix building crc32c with clang ias
To:     Nathan Chancellor <natechancellor@gmail.com>
Cc:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "the arch/x86 maintainers" <x86@kernel.org>,
        Tim Chen <tim.c.chen@linux.intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Jiri Slaby <jslaby@suse.cz>,
        Peter Zijlstra <peterz@infradead.org>,
        "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" 
        <linux-crypto@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        clang-built-linux <clang-built-linux@googlegroups.com>
Content-Type: text/plain; charset="UTF-8"
X-Provags-ID: V03:K1:87ddE9oVfDuQJlZbxuODdBH44a8g4saDLp4ysMsN/x2VKziMjbb
 YfeXMrc4eeyJQu4EdR2I+UXvL6qpSJJ68XYv5VWNCy3dx7fxJbG62Q37eo7V8D3H7LeDZs7
 ZrXZ1UTaWQw4g9TUzHjC+NeIl9fzva1gT05TMm7PFMsZ+e0V3VHDZwFGaohZlDfvAiywiwZ
 +Xf5mwBgKvrCchldEGE9w==
X-UI-Out-Filterresults: notjunk:1;V03:K0:aW6WiSFhTBU=:aUYQJORymX1W6buhNigfb1
 G0KeJug2h/tGuv8jHu+QzTbROwVvweFoUwR2btT/hH2CpamKO7yABxpWQ0gym1dwnzfqRADmJ
 M7w25GjwomIaC0TIZ3xlswRfKzziJ+44qN+22YdrAQjoUq9r46l0KZGMoaJey+9Yk4rFM8hql
 B+dBqwXw0vUeJMZyx3spLYyXaPTJ7AcfmeD6Ld2OpcHktvaHNktuxB4MkgAf0aytPn/BqRus0
 1sUBGKYkPOryEegT8p6rnyzglgUganHOJlDh1Uii5CZcU046m8pR3qUXB8IIZSQPGCxWsfXls
 CnU8bCVg5p62qeL4nf4dZcDL9YuHVMJOZyFwm7mjHmoAtzZBNct+w0ZHUhAENdyRjH8EAx4NG
 nwhs9IW3GfThosurkVtg1JrD+32XRnQCUpa5NH25Bn8rVArvSSBp8wk7M0hlzMt1XbSHMBRNf
 FUsTO9uo6UFOqAO+uj9x/BEL92ndSENki/CIMAZ+unqYnwWhggAKNLzByDSxQd2GTb6syB3C1
 yRpUjzKrJYiloNGWutzqnmGwSgSrp05hnoupWoQXTDu0Dt33yq88ceiDVL9ywlQq8EK9VGTN1
 K/NKGOc5TuhblP3ywrC/jYnbgsqRkldkjfpmO3A9FtRqocFRlfN2q7qkpX92/Es5xcnYXvcCE
 EdKVXrzK4nHJZWBFOp5I4xM+ghViW7QGqe1MUGpedCeSenhn6mCQhaXRSpPE3yoR5w/2Z7ZRs
 NUXvtHZ8P5a51uNuH83iLGN2m3m4PB4aIxtsrvHMgz5uYXYBRtGkThYoKo1w3YvipPEuXPVbk
 hlndoXK5G/WYT+w0cpthnJNjrsGmsRJjc8qbF3uV1sCPyEwit0=
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, May 27, 2020 at 6:42 PM Nathan Chancellor
<natechancellor@gmail.com> wrote:
>
> On Wed, May 27, 2020 at 04:17:40PM +0200, Arnd Bergmann wrote:
> > The clang integrated assembler complains about movzxw:
> >
> > arch/x86/crypto/crc32c-pcl-intel-asm_64.S:173:2: error: invalid instruction mnemonic 'movzxw'
> >
> > It seems that movzwq is the mnemonic that it expects instead,
> > and this is what objdump prints when disassembling the file.
> >
> > Fixes: 6a8ce1ef3940 ("crypto: crc32c - Optimize CRC32C calculation with PCLMULQDQ instruction")
> > Signed-off-by: Arnd Bergmann <arnd@arndb.de>
>
> We had an identical patch pending from another contributor, see the
> discussion and result in the issue below.
>
> https://github.com/ClangBuiltLinux/linux/issues/1010
>
> Reviewed-by: Nathan Chancellor <natechancellor@gmail.com>
>

Was the other one submitted upstream? If yes, let's use that one.

     Arnd
