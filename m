Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2A7EFC4332F
	for <linux-crypto@archiver.kernel.org>; Thu, 15 Dec 2022 10:43:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229988AbiLOKnk (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 15 Dec 2022 05:43:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49536 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229628AbiLOKni (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 15 Dec 2022 05:43:38 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D4E91F624
        for <linux-crypto@vger.kernel.org>; Thu, 15 Dec 2022 02:43:37 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E308061C64
        for <linux-crypto@vger.kernel.org>; Thu, 15 Dec 2022 10:43:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 514E8C433F0
        for <linux-crypto@vger.kernel.org>; Thu, 15 Dec 2022 10:43:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1671101016;
        bh=OoHLEYDUVrZrVOUU45vnTiSYfgNHD7oFP4tFDdXhv4Q=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=ixJuzXSPHUObBBx7BXO2E47q62M05NCP0jZlo6n3pOFzQyEWZiUKq9G6kJc+eg9Qg
         3vaEiZzSHRUuSOktsC2cspLLRMOz1wf0zYHNeoqyZpK0S3VWVmYyQy+JFVnd7QfLi/
         dbbqVa4w0wNIpeXTXFzqLEadhaFGVh/czffaDx4jjgS9UHwnw4E8hOWqnnpKtjeUau
         SXQavmep75LbmODLOtfpAWfvsR0P4peuXDXyciVSoJdI2PJGO0SkQ5eZ4UeXdchnCj
         dEa6gCDvkZYdjO5qWyM/t1fYUDulmzfQVgLYBsXN1G0lB5aJcpw8hXaG4zLRddxX92
         bU2KISUnBf+5g==
Received: by mail-lj1-f180.google.com with SMTP id z4so9497657ljq.6
        for <linux-crypto@vger.kernel.org>; Thu, 15 Dec 2022 02:43:36 -0800 (PST)
X-Gm-Message-State: ANoB5plzg/WQXIulb/CExKQUPgNW3oGnAWbkMupQq6dygmGoSnYjAjqe
        O9S5u08pMnrw0y3LxTLBuwaLMYgcfupMm4IrN3Q=
X-Google-Smtp-Source: AA0mqf4A1vg+KDAOAK5kS7gxIpojg51zx8KoZMW+TXScw+LBEnp4j1zdE5X5JBbkuGrE0w/gLl7kVClE/7LX6cX477M=
X-Received: by 2002:a05:651c:1603:b0:26d:d603:8df2 with SMTP id
 f3-20020a05651c160300b0026dd6038df2mr28479730ljq.189.1671101014271; Thu, 15
 Dec 2022 02:43:34 -0800 (PST)
MIME-Version: 1.0
References: <20221207103936.2198407-1-ardb@kernel.org> <20221207103936.2198407-3-ardb@kernel.org>
 <CACRpkdYiHQQtw2=iPKos3sXEkeErTNxR7T0FPBrCqhQxtxhCkA@mail.gmail.com>
In-Reply-To: <CACRpkdYiHQQtw2=iPKos3sXEkeErTNxR7T0FPBrCqhQxtxhCkA@mail.gmail.com>
From:   Ard Biesheuvel <ardb@kernel.org>
Date:   Thu, 15 Dec 2022 11:43:22 +0100
X-Gmail-Original-Message-ID: <CAMj1kXFPDXp4OfjKYzM0namfbAijbuCfiEaDC9+jAhd1GFY6FA@mail.gmail.com>
Message-ID: <CAMj1kXFPDXp4OfjKYzM0namfbAijbuCfiEaDC9+jAhd1GFY6FA@mail.gmail.com>
Subject: Re: [PATCH v2 2/2] ARM: permit non-nested kernel mode NEON in softirq context
To:     Linus Walleij <linus.walleij@linaro.org>
Cc:     linux-arm-kernel@lists.infradead.org, linux@armlinux.org.uk,
        linux-crypto@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, 15 Dec 2022 at 11:27, Linus Walleij <linus.walleij@linaro.org> wrote:
>
> On Wed, Dec 7, 2022 at 11:39 AM Ard Biesheuvel <ardb@kernel.org> wrote:
>
> > We currently only permit kernel mode NEON in process context, to avoid
> > the need to preserve/restore the NEON register file when taking an
> > exception while running in the kernel.
> >
> > Like we did on arm64, we can relax this restriction substantially, by
> > permitting kernel mode NEON from softirq context, while ensuring that
> > softirq processing is disabled when the NEON is being used in task
> > context. This guarantees that only NEON context belonging to user space
> > needs to be preserved and restored, which is already taken care of.
> >
> > This is especially relevant for network encryption, where incoming
> > frames are typically handled in softirq context, and deferring software
> > decryption to a kernel thread or falling back to C code are both
> > undesirable from a performance PoV.
> >
> > Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
>
> So boosting WireGuard as primary SW network encryption user?

Essentially, although the use case that inspired this work is related
to IPsec not WireGuard, and the crypto algorithm in that case (GCM) is
~3x faster than WG's chacha20poly1305, which makes the performance
overhead of asynchronous completion even more significant. (Note that
GCM needs the AES and PMULL instructions which are usually only
available when running the 32-bit kernel on a 64-bit core, whereas
chacha20poly1305 uses ordinary NEON instructions.)

But Martin responded with a Tested-by regarding chacha20poly1305 on
IPsec (not WG) where there is also a noticeable speedup, so WG on
ARM32 should definitely benefit from this as well.

> This is really neat, BTW:
> Reviewed-by: Linus Walleij <linus.walleij@linaro.org>
>

Thanks!
