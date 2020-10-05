Return-Path: <SRS0=TLUI=DM=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9DBD7C4363A
	for <linux-crypto@archiver.kernel.org>; Mon,  5 Oct 2020 06:44:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5B4FA2080A
	for <linux-crypto@archiver.kernel.org>; Mon,  5 Oct 2020 06:44:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1601880292;
	bh=wsAVEaV1+h1cDZGoNWJx95GIyKoJhBW7f/aAlsRaZi0=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:List-ID:From;
	b=e1IJMU/p7M+MoW1SOSac3dnFu0e0xefjK7vq2QtVYE4T2GDSryppVVHyci6xE1zTP
	 wGpz3BlR0tPlw/5DxtKn46cbhFQc/TmHr4YpfgDZOPEyMCOzBSEyxBMkeTTWCXTKop
	 PdM8EFI4DxPFTI5OfUeSDZB+PUx4s4qjBdGvohCc=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725885AbgJEGov (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 5 Oct 2020 02:44:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:35520 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725881AbgJEGov (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 5 Oct 2020 02:44:51 -0400
Received: from mail-oi1-f180.google.com (mail-oi1-f180.google.com [209.85.167.180])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D8B162083B;
        Mon,  5 Oct 2020 06:44:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601880291;
        bh=wsAVEaV1+h1cDZGoNWJx95GIyKoJhBW7f/aAlsRaZi0=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=i8rGxo6JPfgAgmgQZLNkgC4n7PLiYYbnTKY/fMM8grr7zqt7WfvBskF/auZcnUYLp
         Lr20+zeyZ3g7xCTbOdEwbqxVo67XfcUT2iuncGiJ8fm4z4r846eH988apXeGGmHxLX
         o/SuOxWdx+53ExQovJWw5yYVDs0pwP8+ve5nTTqM=
Received: by mail-oi1-f180.google.com with SMTP id z26so7755266oih.12;
        Sun, 04 Oct 2020 23:44:50 -0700 (PDT)
X-Gm-Message-State: AOAM530CdnNO2FYqXThAs4nBiS22Ehf9YxsbhMiNohf1xeDGnZY0oJNb
        Un+CcFtRNxOsDdD2JnYtsDvn8GyQboKJz/BH0Ww=
X-Google-Smtp-Source: ABdhPJyEZCGyj5e57q59leoKnW6YWhhIYyupKGdmMavLkSJgFy4/I0xNh6NzK3ZRa9LfvAyoGzOKA9XsxaxydYUqh/U=
X-Received: by 2002:aca:d845:: with SMTP id p66mr7393683oig.47.1601880290247;
 Sun, 04 Oct 2020 23:44:50 -0700 (PDT)
MIME-Version: 1.0
References: <20200930065617.934638-1-palmerdabbelt@google.com>
 <20201005061918.GB1856@infradead.org> <CAMj1kXFC=6G1pqFAcjASrKJfzguO3k9Rv-7NsmTaX8qNre5TGw@mail.gmail.com>
 <2588700.mWSkj6HvKX@tauon.chronox.de>
In-Reply-To: <2588700.mWSkj6HvKX@tauon.chronox.de>
From:   Ard Biesheuvel <ardb@kernel.org>
Date:   Mon, 5 Oct 2020 08:44:39 +0200
X-Gmail-Original-Message-ID: <CAMj1kXFL4gfrK1+zRG9sajTk62yRh3WzBG46KfKD=iM=VQMTAQ@mail.gmail.com>
Message-ID: <CAMj1kXFL4gfrK1+zRG9sajTk62yRh3WzBG46KfKD=iM=VQMTAQ@mail.gmail.com>
Subject: Re: [PATCH] crypto: jitterentropy - bind statically into kernel
To:     Stephan Mueller <smueller@chronox.de>
Cc:     Christoph Hellwig <hch@infradead.org>,
        Palmer Dabbelt <palmerdabbelt@google.com>,
        linux-riscv <linux-riscv@lists.infradead.org>,
        Android Kernel Team <kernel-team@android.com>,
        kernel test robot <lkp@intel.com>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, 5 Oct 2020 at 08:40, Stephan Mueller <smueller@chronox.de> wrote:
>
> Am Montag, 5. Oktober 2020, 08:24:46 CEST schrieb Ard Biesheuvel:
>
> Hi Ard,
>
> > If jitterentropy is a special case, we could put a alternate
> > non-'static inline' version of random_get_entropy() in the core
> > kernel, and only export it if JITTER_ENTROPY is built as a module in
> > the first place. But I'd prefer it if jitterentropy switches to an API
> > that is suitable for driver consumption.
>
> Which API do you have in mind? In user space, I use
> clock_gettime(CLOCK_REALTIME) which also considers the clock source.
>

AFAICT, that call is backed by ktime_get_real_ts64(), which is already
being exported to modules.

Could you please check whether that works for your driver?
