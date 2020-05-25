Return-Path: <SRS0=4LZm=7H=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C5A90C433E2
	for <linux-crypto@archiver.kernel.org>; Mon, 25 May 2020 09:07:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A690E2068D
	for <linux-crypto@archiver.kernel.org>; Mon, 25 May 2020 09:07:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1590397647;
	bh=xDu8dLlglr8K91hawwE4cfFpH4NGPUCe5IF8bxHut2s=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:List-ID:From;
	b=gmLpAqJNuF7lU1rLio/9+5QUFH0By17Cn0r51EsNeAksnau7Yawj5zFI76CHtb3eb
	 +pM+dccE0xdF0jEkQ0NIcfKy/N6GfKIbJsqmgB+jyeMIFotKwY1ITcwV37QMUjlsqU
	 /ylMCN+gJ7ynMkc7nY5aGcRWpEfSIOJHPyqo5bX4=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389299AbgEYJHX (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 25 May 2020 05:07:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:60894 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389294AbgEYJHX (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 25 May 2020 05:07:23 -0400
Received: from mail-io1-f49.google.com (mail-io1-f49.google.com [209.85.166.49])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2C1A42084C;
        Mon, 25 May 2020 09:07:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1590397642;
        bh=xDu8dLlglr8K91hawwE4cfFpH4NGPUCe5IF8bxHut2s=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=upEMwLfGG5pi9p3K+vxuXs0az7TTBHDo3uDDF39m77SbroYEeZD/9pMK4LQikloap
         8CL2mVxo9pGdax86qxQdcF9OuLcvTsUZDZ0epvACsdnVbtxrucAkIAkdFjlth9FrD5
         g+D4mvILxfAzLGL1l4SxRtW6mkFw/KD3ZUTdkBEs=
Received: by mail-io1-f49.google.com with SMTP id p20so4563429iop.11;
        Mon, 25 May 2020 02:07:22 -0700 (PDT)
X-Gm-Message-State: AOAM5336C0Y+mSontXSUUPqg/mgEscLEZLSQvgLZuTMlykGbwjlYgXHB
        SZZEZQVz4GgFAimIjHAvQgZJjMmzUTi9iyaREe8=
X-Google-Smtp-Source: ABdhPJyCtr20yxFYDZawW3EBVKQBnR7JS6BmYQvfftEGhtPaFgT0QoTcn8YZlJtxk8v/BozcEBSD/6TfBBAMnfTAchU=
X-Received: by 2002:a02:3341:: with SMTP id k1mr19168056jak.74.1590397641457;
 Mon, 25 May 2020 02:07:21 -0700 (PDT)
MIME-Version: 1.0
References: <20200512141113.18972-1-nicolas.toromanoff@st.com>
 <20200512141113.18972-6-nicolas.toromanoff@st.com> <CAMj1kXGs6UgkKb5+tH2B-+26=tbjHq3UUY2gxfcRfMb1nGVuFA@mail.gmail.com>
 <67c25d90d9714a85b52f3d9c2070af88@SFHDAG6NODE1.st.com> <CAMj1kXGo+9aXeYppGSheqhC-pNeJCcEie+SAnWy_sAiooEDMsQ@mail.gmail.com>
 <bd6cac3bd4c74db1a403df58082028fd@SFHDAG6NODE1.st.com>
In-Reply-To: <bd6cac3bd4c74db1a403df58082028fd@SFHDAG6NODE1.st.com>
From:   Ard Biesheuvel <ardb@kernel.org>
Date:   Mon, 25 May 2020 11:07:10 +0200
X-Gmail-Original-Message-ID: <CAMj1kXFwt6cs-MJhAeMRF4-yiddm=ezq=qvSjA_sRAX+_Gdqhw@mail.gmail.com>
Message-ID: <CAMj1kXFwt6cs-MJhAeMRF4-yiddm=ezq=qvSjA_sRAX+_Gdqhw@mail.gmail.com>
Subject: Re: [PATCH 5/5] crypto: stm32/crc: protect from concurrent accesses
To:     Nicolas TOROMANOFF <nicolas.toromanoff@st.com>,
        Eric Biggers <ebiggers@kernel.org>
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

(+ Eric)

On Mon, 25 May 2020 at 11:01, Nicolas TOROMANOFF
<nicolas.toromanoff@st.com> wrote:
>
> > -----Original Message-----
> > From: Ard Biesheuvel <ardb@kernel.org>
> > Sent: Monday, May 25, 2020 9:46 AM
> > To: Nicolas TOROMANOFF <nicolas.toromanoff@st.com>
> > Subject: Re: [PATCH 5/5] crypto: stm32/crc: protect from concurrent accesses
> >
> > On Mon, 25 May 2020 at 09:24, Nicolas TOROMANOFF
> > <nicolas.toromanoff@st.com> wrote:
> > >
> > > Hello,
> > >
> > > > -----Original Message-----
> > > > From: Ard Biesheuvel <ardb@kernel.org>
> > > > Sent: Friday, May 22, 2020 6:12 PM>
> > > > On Tue, 12 May 2020 at 16:13, Nicolas Toromanoff
> > > > <nicolas.toromanoff@st.com> wrote:
> > > > >
> > > > > Protect STM32 CRC device from concurrent accesses.
> > > > >
> > > > > As we create a spinlocked section that increase with buffer size,
> > > > > we provide a module parameter to release the pressure by splitting
> > > > > critical section in chunks.
> > > > >
> > > > > Size of each chunk is defined in burst_size module parameter.
> > > > > By default burst_size=0, i.e. don't split incoming buffer.
> > > > >
> > > > > Signed-off-by: Nicolas Toromanoff <nicolas.toromanoff@st.com>
> > > >
> > > > Would you mind explaining the usage model here? It looks like you
> > > > are sharing a CRC hardware accelerator with a synchronous interface
> > > > between different users by using spinlocks? You are aware that this
> > > > will tie up the waiting CPUs completely during this time, right? So
> > > > it would be much better to use a mutex here. Or perhaps it would
> > > > make more sense to fall back to a s/w based CRC routine if the h/w is tied up
> > working for another task?
> > >
> > > I know mutex are more acceptable here, but shash _update() and _init()
> > > may be call from any context, and so I cannot take a mutex.
> > > And to protect my concurrent HW access I only though about spinlock.
> > > Due to possible constraint on CPUs, I add a burst_size option to force
> > > slitting long buffer into smaller one, and so decrease time we take the lock.
> > > But I didn't though to fallback to software CRC.
> > >
> > > I'll do a patch on top.
> > > In in the burst_update() function I'll use a spin_trylock_irqsave() and use
> > software CRC32 if HW is already in use.
> > >
> >
> > Right. I didn't even notice that you were keeping interrupts disabled the whole
> > time when using the h/w block. That means that any serious use of this h/w
> > block will make IRQ latency go through the roof.
> >
> > I recommend that you go back to the drawing board on this driver, rather than
> > papering over the issues with a spin_trylock(). Perhaps it would be better to
> > model it as a ahash (even though the h/w block itself is synchronous) and use a
> > kthread to feed in the data.
>
> I thought when I updated the driver to move to a ahash interface, but the main usage
> of crc32 is the ext4 fs, that calls the shash API.
> Commit 877b5691f27a ("crypto: shash - remove shash_desc::flags") removed possibility
> to sleep in shash callback. (before this commit and with MAY_SLEEP option set, using
> a mutex may have been fine).
>

According to that commit's log, sleeping is never fine for shash(),
since it uses kmap_atomic() when iterating over the scatterlist.

> By now the solution I see is to use the spin_trylock_irqsave(), fallback to software crc *AND* capping burst_size
> to ensure the locked section stay reasonable.
>
> Does this seems acceptable ?
>

If the reason for disabling interrupts is to avoid deadlocks, wouldn't
the switch to trylock() with a software fallback allow us to keep
interrupts enabled?
