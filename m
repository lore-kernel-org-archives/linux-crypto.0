Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5EC17C4332F
	for <linux-crypto@archiver.kernel.org>; Thu, 15 Dec 2022 11:48:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229611AbiLOLsh (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 15 Dec 2022 06:48:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229637AbiLOLsg (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 15 Dec 2022 06:48:36 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E80A29CB0
        for <linux-crypto@vger.kernel.org>; Thu, 15 Dec 2022 03:48:35 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 11184B819DC
        for <linux-crypto@vger.kernel.org>; Thu, 15 Dec 2022 11:48:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CDAECC433EF
        for <linux-crypto@vger.kernel.org>; Thu, 15 Dec 2022 11:48:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1671104912;
        bh=Gg8q2ym69rZ0M+aNFiSyUTelYKwAoQUA/qdd1iu4xBQ=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=rfh17U1e0RABXnOVbgW1VQaK8TTjlueSEOpHAjOCd+vRAckMdLhIDrYe8ruhvfzoD
         NSlyS3bi47yliCj3AfdhNRXBetZKwZDWnUAor9aAdb0rSLfFPi09lkomYhOmK4BsP0
         ANCXuPQyq5cSWKODSWJej5EGBuI/Hdqh2/wrsMUGvmejD73mOwQISk1q9lLX3VMKDz
         td90AROjNAemhM1GdaxStYahdviXlK5c5XgtF3GEep2zmCF8L/oz5S7YyPIML1C6ho
         I9BV3OFh3icmFJR0dCOhovl8oce3w+pKr8ZGHxBeUHUUk5bB0F6MN1T0hGlnp9g+dG
         T7HlAY8uHNqjw==
Received: by mail-lj1-f179.google.com with SMTP id s10so9679677ljg.1
        for <linux-crypto@vger.kernel.org>; Thu, 15 Dec 2022 03:48:32 -0800 (PST)
X-Gm-Message-State: ANoB5pm3z+pmXpJTU/DByKcxK5UsaDCk34x/SaDtkjS6m57eYXc+dtxi
        yw3pXsLgRph2x2M57uO3jAkP+im6Ew0IlVEwQHU=
X-Google-Smtp-Source: AA0mqf4h6bGdUmBHz1JLajQ8Fws9v5htujGyw+HDR7Evcsv/ec4il/zSHBiNYpvdsAXSeM+WVBEKC1M2nDik3eMC3tY=
X-Received: by 2002:a05:651c:b14:b0:277:7eef:1d97 with SMTP id
 b20-20020a05651c0b1400b002777eef1d97mr27225042ljr.516.1671104910835; Thu, 15
 Dec 2022 03:48:30 -0800 (PST)
MIME-Version: 1.0
References: <20221207103936.2198407-1-ardb@kernel.org> <20221207103936.2198407-3-ardb@kernel.org>
 <CACRpkdYiHQQtw2=iPKos3sXEkeErTNxR7T0FPBrCqhQxtxhCkA@mail.gmail.com>
 <CAMj1kXFPDXp4OfjKYzM0namfbAijbuCfiEaDC9+jAhd1GFY6FA@mail.gmail.com> <Y5r8OrCrjfil0LWs@shell.armlinux.org.uk>
In-Reply-To: <Y5r8OrCrjfil0LWs@shell.armlinux.org.uk>
From:   Ard Biesheuvel <ardb@kernel.org>
Date:   Thu, 15 Dec 2022 12:48:19 +0100
X-Gmail-Original-Message-ID: <CAMj1kXH9KXo=YipRGw9LS3KjZ0d+xh3dvAUt4AuMRpHqV-b5Gw@mail.gmail.com>
Message-ID: <CAMj1kXH9KXo=YipRGw9LS3KjZ0d+xh3dvAUt4AuMRpHqV-b5Gw@mail.gmail.com>
Subject: Re: [PATCH v2 2/2] ARM: permit non-nested kernel mode NEON in softirq context
To:     "Russell King (Oracle)" <linux@armlinux.org.uk>
Cc:     Linus Walleij <linus.walleij@linaro.org>,
        linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org,
        Arnd Bergmann <arnd@arndb.de>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, 15 Dec 2022 at 11:51, Russell King (Oracle)
<linux@armlinux.org.uk> wrote:
>
> On Thu, Dec 15, 2022 at 11:43:22AM +0100, Ard Biesheuvel wrote:
> > On Thu, 15 Dec 2022 at 11:27, Linus Walleij <linus.walleij@linaro.org> wrote:
> > >
> > > On Wed, Dec 7, 2022 at 11:39 AM Ard Biesheuvel <ardb@kernel.org> wrote:
> > >
> > > > We currently only permit kernel mode NEON in process context, to avoid
> > > > the need to preserve/restore the NEON register file when taking an
> > > > exception while running in the kernel.
> > > >
> > > > Like we did on arm64, we can relax this restriction substantially, by
> > > > permitting kernel mode NEON from softirq context, while ensuring that
> > > > softirq processing is disabled when the NEON is being used in task
> > > > context. This guarantees that only NEON context belonging to user space
> > > > needs to be preserved and restored, which is already taken care of.
> > > >
> > > > This is especially relevant for network encryption, where incoming
> > > > frames are typically handled in softirq context, and deferring software
> > > > decryption to a kernel thread or falling back to C code are both
> > > > undesirable from a performance PoV.
> > > >
> > > > Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
> > >
> > > So boosting WireGuard as primary SW network encryption user?
> >
> > Essentially, although the use case that inspired this work is related
> > to IPsec not WireGuard, and the crypto algorithm in that case (GCM) is
> > ~3x faster than WG's chacha20poly1305, which makes the performance
> > overhead of asynchronous completion even more significant. (Note that
> > GCM needs the AES and PMULL instructions which are usually only
> > available when running the 32-bit kernel on a 64-bit core, whereas
> > chacha20poly1305 uses ordinary NEON instructions.)
> >
> > But Martin responded with a Tested-by regarding chacha20poly1305 on
> > IPsec (not WG) where there is also a noticeable speedup, so WG on
> > ARM32 should definitely benefit from this as well.
>
> It'll be interesting to see whether there is any noticable difference
> with my WG VPN.
>

Using WireGuard with the same 32-bit KVM guest communicating with its
64-bit host using virtio-net, I get a 44% speedup in the host->guest
direction. The other direction performs exactly the same, which is
unsurprising as it doesn't involve NEON crypto in softirq context at
all.

BEFORE
======

ardb@vm32:~$ iperf3 -c 192.168.11.2
Connecting to host 192.168.11.2, port 5201
[  5] local 192.168.11.1 port 40144 connected to 192.168.11.2 port 5201
[ ID] Interval           Transfer     Bitrate         Retr  Cwnd
[  5]   0.00-1.00   sec  25.8 MBytes   216 Mbits/sec    0    397 KBytes
[  5]   1.00-2.00   sec  25.9 MBytes   217 Mbits/sec    0    397 KBytes
[  5]   2.00-3.00   sec  27.0 MBytes   226 Mbits/sec    0    397 KBytes
[  5]   3.00-4.00   sec  26.5 MBytes   222 Mbits/sec    0    397 KBytes
[  5]   4.00-5.00   sec  26.2 MBytes   220 Mbits/sec    0    397 KBytes
[  5]   5.00-6.00   sec  26.1 MBytes   219 Mbits/sec    0    436 KBytes
[  5]   6.00-7.00   sec  26.2 MBytes   220 Mbits/sec    0    458 KBytes
[  5]   7.00-8.00   sec  26.2 MBytes   220 Mbits/sec    0    458 KBytes
[  5]   8.00-9.00   sec  26.5 MBytes   222 Mbits/sec    0    480 KBytes
[  5]   9.00-10.00  sec  26.9 MBytes   225 Mbits/sec    0    480 KBytes
- - - - - - - - - - - - - - - - - - - - - - - - -
[ ID] Interval           Transfer     Bitrate         Retr
[  5]   0.00-10.00  sec   263 MBytes   221 Mbits/sec    0             sender
[  5]   0.00-10.00  sec   262 MBytes   220 Mbits/sec                  receiver


ardb@sudo:~$ iperf3 -c 192.168.11.1
Connecting to host 192.168.11.1, port 5201
[  5] local 192.168.11.2 port 46340 connected to 192.168.11.1 port 5201
[ ID] Interval           Transfer     Bitrate         Retr  Cwnd
[  5]   0.00-1.00   sec  47.5 MBytes   398 Mbits/sec    0   1.75 MBytes
[  5]   1.00-2.00   sec  45.0 MBytes   377 Mbits/sec   18   1.35 MBytes
[  5]   2.00-3.00   sec  43.8 MBytes   367 Mbits/sec    0   1.47 MBytes
[  5]   3.00-4.00   sec  45.0 MBytes   377 Mbits/sec    0   1.56 MBytes
[  5]   4.00-5.00   sec  45.0 MBytes   377 Mbits/sec    0   1.63 MBytes
[  5]   5.00-6.00   sec  42.5 MBytes   357 Mbits/sec    0   1.68 MBytes
[  5]   6.00-7.00   sec  43.8 MBytes   367 Mbits/sec    0   1.71 MBytes
[  5]   7.00-8.00   sec  43.8 MBytes   367 Mbits/sec    0   1.73 MBytes
[  5]   8.00-9.00   sec  45.0 MBytes   377 Mbits/sec    0   1.74 MBytes
[  5]   9.00-10.00  sec  43.8 MBytes   367 Mbits/sec    0   1.75 MBytes
- - - - - - - - - - - - - - - - - - - - - - - - -
[ ID] Interval           Transfer     Bitrate         Retr
[  5]   0.00-10.00  sec   445 MBytes   373 Mbits/sec   18             sender
[  5]   0.00-10.04  sec   444 MBytes   371 Mbits/sec                  receiver

iperf Done.


AFTER
=====

ardb@vm32:~$ iperf3 -c 192.168.11.2
Connecting to host 192.168.11.2, port 5201
[  5] local 192.168.11.1 port 44004 connected to 192.168.11.2 port 5201
[ ID] Interval           Transfer     Bitrate         Retr  Cwnd
[  5]   0.00-1.00   sec  26.2 MBytes   220 Mbits/sec    0    399 KBytes
[  5]   1.00-2.00   sec  25.9 MBytes   217 Mbits/sec    0    399 KBytes
[  5]   2.00-3.00   sec  26.0 MBytes   218 Mbits/sec    0    444 KBytes
[  5]   3.00-4.00   sec  26.8 MBytes   225 Mbits/sec    0    485 KBytes
[  5]   4.00-5.00   sec  26.4 MBytes   222 Mbits/sec    0    542 KBytes
[  5]   5.00-6.00   sec  26.6 MBytes   223 Mbits/sec    0    568 KBytes
[  5]   6.00-7.00   sec  25.4 MBytes   213 Mbits/sec    0    568 KBytes
[  5]   7.00-8.00   sec  25.9 MBytes   217 Mbits/sec    0    568 KBytes
[  5]   8.00-9.00   sec  26.7 MBytes   224 Mbits/sec    0    568 KBytes
[  5]   9.00-10.00  sec  25.9 MBytes   217 Mbits/sec    0    568 KBytes
- - - - - - - - - - - - - - - - - - - - - - - - -
[ ID] Interval           Transfer     Bitrate         Retr
[  5]   0.00-10.00  sec   262 MBytes   220 Mbits/sec    0             sender
[  5]   0.00-9.99   sec   261 MBytes   219 Mbits/sec                  receiver

iperf Done.

ardb@sudo:~$ iperf3 -c 192.168.11.1
Connecting to host 192.168.11.1, port 5201
[  5] local 192.168.11.2 port 49838 connected to 192.168.11.1 port 5201
[ ID] Interval           Transfer     Bitrate         Retr  Cwnd
[  5]   0.00-1.00   sec  61.2 MBytes   514 Mbits/sec    0   1.59 MBytes
[  5]   1.00-2.00   sec  66.2 MBytes   555 Mbits/sec    0   1.67 MBytes
[  5]   2.00-3.00   sec  65.0 MBytes   545 Mbits/sec   79   1.24 MBytes
[  5]   3.00-4.00   sec  63.8 MBytes   535 Mbits/sec    0   1.36 MBytes
[  5]   4.00-5.00   sec  63.8 MBytes   535 Mbits/sec    0   1.46 MBytes
[  5]   5.00-6.00   sec  63.8 MBytes   535 Mbits/sec    0   1.53 MBytes
[  5]   6.00-7.00   sec  62.5 MBytes   524 Mbits/sec    0   1.59 MBytes
[  5]   7.00-8.00   sec  65.0 MBytes   545 Mbits/sec   99   1.18 MBytes
[  5]   8.00-9.00   sec  65.0 MBytes   545 Mbits/sec    0   1.25 MBytes
[  5]   9.00-10.00  sec  65.0 MBytes   545 Mbits/sec    0   1.30 MBytes
- - - - - - - - - - - - - - - - - - - - - - - - -
[ ID] Interval           Transfer     Bitrate         Retr
[  5]   0.00-10.00  sec   641 MBytes   538 Mbits/sec  178             sender
[  5]   0.00-10.02  sec   638 MBytes   535 Mbits/sec                  receiver

iperf Done.
