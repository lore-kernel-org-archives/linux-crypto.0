Return-Path: <SRS0=4LZm=7H=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1E2F1C433E0
	for <linux-crypto@archiver.kernel.org>; Mon, 25 May 2020 07:46:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EC9F520679
	for <linux-crypto@archiver.kernel.org>; Mon, 25 May 2020 07:46:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1590392774;
	bh=fgqR3OQ1PtjHSkmtV10P2hHKo5KnIbUACEU4h7/NwDY=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:List-ID:From;
	b=NUhJAEVAnGl4yEu1Y0DF3jZI40+O1X90jC3+DqR+APYpHVKVEmGh9QLy5syh/TmK9
	 G9oJvUkzaRA/l8vD6hBJcqWBdzzZFqvGsB/FS7p6Q12kr9mDc56ntQoCMGUdv5xA/E
	 yP+rHSQBICFenwHQQ02sOgDAYVNPEFz4SCp8bAeM=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389162AbgEYHqN (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 25 May 2020 03:46:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:47278 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389105AbgEYHqN (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 25 May 2020 03:46:13 -0400
Received: from mail-il1-f178.google.com (mail-il1-f178.google.com [209.85.166.178])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2AA8B2084C;
        Mon, 25 May 2020 07:46:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1590392772;
        bh=fgqR3OQ1PtjHSkmtV10P2hHKo5KnIbUACEU4h7/NwDY=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=18NjHvk8ScXaincZb/YmfsI/QWRTplgkBTpu2YO6xlvUH9+CRSqSUsuJc+m0WsfwR
         Hrivql4XcabyAJcADV4htQDQUsebbxcwc5z8OLIL7h17y3/Z/qxoKZaswCs2GJCXzY
         3oijNN+ovScPzBf0r3oycDR/sgKHxZ/e5USy3VSE=
Received: by mail-il1-f178.google.com with SMTP id c20so16572051ilk.6;
        Mon, 25 May 2020 00:46:12 -0700 (PDT)
X-Gm-Message-State: AOAM5313MxXw++WMcE0QOIIQ40fdcg0n1X6bed9QLLb2/OVjpx2P8Ayw
        l9EIVcEBKV/yXjjV/qTBLE8fDOYndhxz8AEfiEg=
X-Google-Smtp-Source: ABdhPJyznDWuSesPLw+JJ+5BL9aOApZTfftAlcgXJD7CkLN8jcHhBFDwqaPXE/x7YTJsngd0cfoo32pizca9o+KxyyU=
X-Received: by 2002:a92:5ec1:: with SMTP id f62mr20911209ilg.80.1590392771546;
 Mon, 25 May 2020 00:46:11 -0700 (PDT)
MIME-Version: 1.0
References: <20200512141113.18972-1-nicolas.toromanoff@st.com>
 <20200512141113.18972-6-nicolas.toromanoff@st.com> <CAMj1kXGs6UgkKb5+tH2B-+26=tbjHq3UUY2gxfcRfMb1nGVuFA@mail.gmail.com>
 <67c25d90d9714a85b52f3d9c2070af88@SFHDAG6NODE1.st.com>
In-Reply-To: <67c25d90d9714a85b52f3d9c2070af88@SFHDAG6NODE1.st.com>
From:   Ard Biesheuvel <ardb@kernel.org>
Date:   Mon, 25 May 2020 09:46:00 +0200
X-Gmail-Original-Message-ID: <CAMj1kXGo+9aXeYppGSheqhC-pNeJCcEie+SAnWy_sAiooEDMsQ@mail.gmail.com>
Message-ID: <CAMj1kXGo+9aXeYppGSheqhC-pNeJCcEie+SAnWy_sAiooEDMsQ@mail.gmail.com>
Subject: Re: [PATCH 5/5] crypto: stm32/crc: protect from concurrent accesses
To:     Nicolas TOROMANOFF <nicolas.toromanoff@st.com>
Cc:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Alexandre TORGUE <alexandre.torgue@st.com>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        "linux-stm32@st-md-mailman.stormreply.com" 
        <linux-stm32@st-md-mailman.stormreply.com>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, 25 May 2020 at 09:24, Nicolas TOROMANOFF
<nicolas.toromanoff@st.com> wrote:
>
> Hello,
>
> > -----Original Message-----
> > From: Ard Biesheuvel <ardb@kernel.org>
> > Sent: Friday, May 22, 2020 6:12 PM>
> > On Tue, 12 May 2020 at 16:13, Nicolas Toromanoff
> > <nicolas.toromanoff@st.com> wrote:
> > >
> > > Protect STM32 CRC device from concurrent accesses.
> > >
> > > As we create a spinlocked section that increase with buffer size, we
> > > provide a module parameter to release the pressure by splitting
> > > critical section in chunks.
> > >
> > > Size of each chunk is defined in burst_size module parameter.
> > > By default burst_size=0, i.e. don't split incoming buffer.
> > >
> > > Signed-off-by: Nicolas Toromanoff <nicolas.toromanoff@st.com>
> >
> > Would you mind explaining the usage model here? It looks like you are sharing a
> > CRC hardware accelerator with a synchronous interface between different users
> > by using spinlocks? You are aware that this will tie up the waiting CPUs
> > completely during this time, right? So it would be much better to use a mutex
> > here. Or perhaps it would make more sense to fall back to a s/w based CRC
> > routine if the h/w is tied up working for another task?
>
> I know mutex are more acceptable here, but shash _update() and _init() may be call
> from any context, and so I cannot take a mutex.
> And to protect my concurrent HW access I only though about spinlock. Due to possible
> constraint on CPUs, I add a burst_size option to force slitting long buffer into smaller one,
> and so decrease time we take the lock.
> But I didn't though to fallback to software CRC.
>
> I'll do a patch on top.
> In in the burst_update() function I'll use a spin_trylock_irqsave() and use software CRC32 if HW is already in use.
>

Right. I didn't even notice that you were keeping interrupts disabled
the whole time when using the h/w block. That means that any serious
use of this h/w block will make IRQ latency go through the roof.

I recommend that you go back to the drawing board on this driver,
rather than papering over the issues with a spin_trylock(). Perhaps it
would be better to model it as a ahash (even though the h/w block
itself is synchronous) and use a kthread to feed in the data.
