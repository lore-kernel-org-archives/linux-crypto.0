Return-Path: <SRS0=WqbL=AT=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 70DCCC433E0
	for <linux-crypto@archiver.kernel.org>; Wed,  8 Jul 2020 13:41:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4B0D0206E9
	for <linux-crypto@archiver.kernel.org>; Wed,  8 Jul 2020 13:41:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1594215698;
	bh=8p2MeO53N4LFHo14H/Wf4TMxCwYMC//FC4iUC98Jggc=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:List-ID:From;
	b=Xf/x8Wj7yuE0tm1bmcPMQyYY/9XMCq0B6R/bDSnIJUDfvqQOKVkLtUGFRUTisgavI
	 RGKOEgU/Mc9KW7euhgqhCj61JnClnFvX/zTtGqHmY4YzzmbL10ASYChT+aDyIx8ybB
	 Fd+CyfOLkmymyUs7OQBdklas1SYA6/gr57AkE8zo=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728932AbgGHNlh (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 8 Jul 2020 09:41:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:39720 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728210AbgGHNlh (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 8 Jul 2020 09:41:37 -0400
Received: from mail-oo1-f50.google.com (mail-oo1-f50.google.com [209.85.161.50])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B996F206E9
        for <linux-crypto@vger.kernel.org>; Wed,  8 Jul 2020 13:41:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594215696;
        bh=8p2MeO53N4LFHo14H/Wf4TMxCwYMC//FC4iUC98Jggc=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=ntI6XtkLpHlx8H1tAwp/+6rhq5WmAK4k8P5i01wDnr54TXDRHdDE3wtR02kP+ePPw
         Gpwm+g3Cn36x8ULkHyKCR3lkDAKydFMuq6xBQisumIIWq8oB4XtbPHgVPTqswrORVr
         NBgLty0oZ5hpzj0qBdOuyd1hBqPkzM+hL3cKJhug=
Received: by mail-oo1-f50.google.com with SMTP id z127so5302006ooa.3
        for <linux-crypto@vger.kernel.org>; Wed, 08 Jul 2020 06:41:36 -0700 (PDT)
X-Gm-Message-State: AOAM531G20wJ8uNtvFmwcsk8u5JHl37kgGhIWyUchORR0oU4B7Ayvght
        c9yDjRGea4axJAINPzkCtFM4k2NIPP2YMscq1X8=
X-Google-Smtp-Source: ABdhPJz/q98S9S1t5P2z/iouORqyJnPnGQ+c0CJtNynYW/nsre80n7a+B1vzRZC9J5bK+9Pu1wDYWCWCZUbh3Blrt1Y=
X-Received: by 2002:a4a:de8d:: with SMTP id v13mr28486733oou.45.1594215696103;
 Wed, 08 Jul 2020 06:41:36 -0700 (PDT)
MIME-Version: 1.0
References: <CY4PR0401MB3652172E295BA60CBDED9EE8C3670@CY4PR0401MB3652.namprd04.prod.outlook.com>
 <CAMj1kXFGPkpaKy9NunG0sefv3bc+ETDu6H2T8RcQaKAk+tTMJg@mail.gmail.com> <CY4PR0401MB3652D4CA49D9ECBE9FC150B0C3670@CY4PR0401MB3652.namprd04.prod.outlook.com>
In-Reply-To: <CY4PR0401MB3652D4CA49D9ECBE9FC150B0C3670@CY4PR0401MB3652.namprd04.prod.outlook.com>
From:   Ard Biesheuvel <ardb@kernel.org>
Date:   Wed, 8 Jul 2020 16:41:24 +0300
X-Gmail-Original-Message-ID: <CAMj1kXG-DswQMOVty=Fyer5-9QyvmFyskW4SRVa__GU+gwTCZQ@mail.gmail.com>
Message-ID: <CAMj1kXG-DswQMOVty=Fyer5-9QyvmFyskW4SRVa__GU+gwTCZQ@mail.gmail.com>
Subject: Re: question regarding crypto driver DMA issue
To:     "Van Leeuwen, Pascal" <pvanleeuwen@rambus.com>
Cc:     "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, 8 Jul 2020 at 16:35, Van Leeuwen, Pascal <pvanleeuwen@rambus.com> wrote:
>
> Hi Ard,
>
> Thanks for responding!
>
> > > For the situation where this problem is occuring, the actual buffers are stored inside
> > > the ahash_req structure. So my question is: is there any reason why this structure may
> > > not be DMA-able on some systems? (as I have a hunch that may be the problem ...)
> > >
> >
> > If DMA is non-coherent, and the ahash_req structure is also modified
> > by the CPU while it is mapped for DMA, you are likely to get a
> > conflict.
> >
> Ah ... I get it. If I dma_map TO_DEVICE then all relevant cachelines are flushed, then
> if the CPU accesses any other data sharing those cachelines, they get read back into
> the cache. Any subsequent access of the actual result will then read stale data from
> the cache.
>
> > It should help if you align the DMA-able fields sufficiently, and make
> > sure you never touch them while they are mapped for writing by the
> > device.
> >
> Yes, I guess that is the only way. I also toyed with the idea of using dedicated properly
> dma_alloc'ed buffers with pointers in the ahash_request structure, but I don't see how
> I can allocate per-request buffers as there is no callback to the driver on req creation.
>
> So ... is there any magical way within the Linux kernel to cacheline-align members of
> a structure? Considering cacheline size is very system-specific?
>

You can use __cacheline_aligned as a modifier on struct members that
are accessed by the device. However, this is a typical value, not a
worst case value, and since this is taken into account at compile
time, you really need a worst case value.

On arm64, the maximum CWG (Cache Writeback Granule) value is 2k, which
is a bit excessive, so it might help to do this at runtime. One thing
you might do is increase the reqsize at TFM init time (in which case
you could also check whether the device is cache coherent for DMA),
and have a helper that gives you the address of the sub-struct inside
the request struct based on the current cache alignment.
