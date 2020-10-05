Return-Path: <SRS0=TLUI=DM=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BBAC7C4363A
	for <linux-crypto@archiver.kernel.org>; Mon,  5 Oct 2020 06:24:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 72C30207BC
	for <linux-crypto@archiver.kernel.org>; Mon,  5 Oct 2020 06:24:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1601879099;
	bh=Yrr7GNWUAVWaaz1jIc/uXs8U/IEt8VrM/dIArGoeqEE=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:List-ID:From;
	b=n7Lmirh5ZeotWa9gBJDKUQJF6QucgIi9SRl2B/WpKwDSvvYp5SaHsOPDkimeJTDIr
	 nhWb99I+aDTDGaNLV5q1AaFQcg+eoipiLAJ1glUBm2bbbsblYdVFqRYHEodRuovua5
	 HZJhXiQCR859hQymD/RCJTBT+sgXWWEWplGSSgLc=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725880AbgJEGY6 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 5 Oct 2020 02:24:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:59116 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725267AbgJEGY6 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 5 Oct 2020 02:24:58 -0400
Received: from mail-oo1-f54.google.com (mail-oo1-f54.google.com [209.85.161.54])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A6E6C207EA;
        Mon,  5 Oct 2020 06:24:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601879097;
        bh=Yrr7GNWUAVWaaz1jIc/uXs8U/IEt8VrM/dIArGoeqEE=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=ThJc1ZmtFFTxYDdNdNd+qvSTOF09HxfMQO8wyxvIf3O/jNqXFBOknbeaXhDwLlWAs
         PrdZrskYzZZoD3C1yFpNziMtzwMXM8CWgS2UJsNIFlZq4Gs/IBNJnAl5IpT1GVcSz7
         FfpjLECmQYssfScz4NDLWjzumgZ8IcsQuQBSbbac=
Received: by mail-oo1-f54.google.com with SMTP id b12so1963023oop.13;
        Sun, 04 Oct 2020 23:24:57 -0700 (PDT)
X-Gm-Message-State: AOAM53123GvanQ29Bce+sClk1yAQAIKz/SECzV4FJMN+7Z/kHElaRCtN
        2iyxLcAwjwFtTXgDjQlTl3ur6wDACse/I5RyORc=
X-Google-Smtp-Source: ABdhPJzwJdZHBBVYKQctaaNGjxR/8GlzP9k3E5YR5UECckChEgp4tsYN+VVHxlTisKvVtVRgs7r5+77Nd5DZOWBgB5I=
X-Received: by 2002:a4a:c3ca:: with SMTP id e10mr4325783ooq.41.1601879097030;
 Sun, 04 Oct 2020 23:24:57 -0700 (PDT)
MIME-Version: 1.0
References: <20200930065617.934638-1-palmerdabbelt@google.com>
 <20201002064905.GA27115@infradead.org> <5692716.lOV4Wx5bFT@positron.chronox.de>
 <CAMj1kXEnOh4MBiVVgkhd4P81eRPCVi3+y6JcD58jL45-eh324A@mail.gmail.com> <20201005061918.GB1856@infradead.org>
In-Reply-To: <20201005061918.GB1856@infradead.org>
From:   Ard Biesheuvel <ardb@kernel.org>
Date:   Mon, 5 Oct 2020 08:24:46 +0200
X-Gmail-Original-Message-ID: <CAMj1kXFC=6G1pqFAcjASrKJfzguO3k9Rv-7NsmTaX8qNre5TGw@mail.gmail.com>
Message-ID: <CAMj1kXFC=6G1pqFAcjASrKJfzguO3k9Rv-7NsmTaX8qNre5TGw@mail.gmail.com>
Subject: Re: [PATCH] crypto: jitterentropy - bind statically into kernel
To:     Christoph Hellwig <hch@infradead.org>
Cc:     "Stephan M??ller" <smueller@chronox.de>,
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

On Mon, 5 Oct 2020 at 08:19, Christoph Hellwig <hch@infradead.org> wrote:
>
> On Sun, Oct 04, 2020 at 11:16:10PM +0200, Ard Biesheuvel wrote:
> > On Sun, 4 Oct 2020 at 20:48, Stephan M??ller <smueller@chronox.de> wrote:
> > >
> > > The RISC-V architecture is about to implement the callback
> > > random_get_entropy with a function that is not exported to modules.
> >
> > Why is that? Wouldn't it be better to export the symbol instead?
>
> get_cycles is a low-level time keeping detail that really should not
> be exported, and at least for RISC-V this would be the only modular
> user.  Once that is sorted out I'll audit other common architectures
> to drop the export, as it isn't something that should be used in ramdom
> driver code.

Fair enough.

But this means we should fix the jitterentropy driver rather than
sidestepping the issue by only allowing it to be built in a way where
we don't happen to notice that the symbol in question is not meant for
general consumption.

If jitterentropy is a special case, we could put a alternate
non-'static inline' version of random_get_entropy() in the core
kernel, and only export it if JITTER_ENTROPY is built as a module in
the first place. But I'd prefer it if jitterentropy switches to an API
that is suitable for driver consumption.
