Return-Path: <SRS0=TLUI=DM=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 836FDC4363A
	for <linux-crypto@archiver.kernel.org>; Mon,  5 Oct 2020 06:56:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3AF4A2078A
	for <linux-crypto@archiver.kernel.org>; Mon,  5 Oct 2020 06:56:51 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="ng9feSs+"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725873AbgJEG4v (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 5 Oct 2020 02:56:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725869AbgJEG4v (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 5 Oct 2020 02:56:51 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF42AC0613CE;
        Sun,  4 Oct 2020 23:56:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=JH0LA4ZuyggAVCTfAaYXHSoHoqqf3UMSAcaG4H8OYWQ=; b=ng9feSs+iOaagTDCS7GVS803UG
        FYtJiDiazlMQbCOD7eSn/To5ES0cXenIsuYBC9zsl2M8eCCcF8vztyfDRaKMn20fLaPOxf3wG05DZ
        QOHHQsDwG+RWnfXOYf15tRZDnQE4FvS1PpneP8X6muACi7I3brc0ZrLZu8w6PG0Z4Qr97L7G77e8L
        i+HE7S6F/pSR1VIGaWf8mQxE5Rw27NM7JPcLy9Tlrq87GW/tdYoz+yN05tJIJWxC3GdBPc9nSca4W
        hEWY8WkbcW/LHg4ZGsuGGwnKi7+Mh39JdBrJ4ZJ4co4pn2E2vgVZSfTclzV/HBw4pVLG5VvYwYhX0
        1dY1sLbA==;
Received: from hch by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kPKQO-0002jS-Bx; Mon, 05 Oct 2020 06:56:44 +0000
Date:   Mon, 5 Oct 2020 07:56:44 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     Ard Biesheuvel <ardb@kernel.org>
Cc:     Stephan Mueller <smueller@chronox.de>,
        Christoph Hellwig <hch@infradead.org>,
        Palmer Dabbelt <palmerdabbelt@google.com>,
        linux-riscv <linux-riscv@lists.infradead.org>,
        Android Kernel Team <kernel-team@android.com>,
        kernel test robot <lkp@intel.com>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] crypto: jitterentropy - bind statically into kernel
Message-ID: <20201005065644.GB7462@infradead.org>
References: <20200930065617.934638-1-palmerdabbelt@google.com>
 <20201005061918.GB1856@infradead.org>
 <CAMj1kXFC=6G1pqFAcjASrKJfzguO3k9Rv-7NsmTaX8qNre5TGw@mail.gmail.com>
 <2588700.mWSkj6HvKX@tauon.chronox.de>
 <CAMj1kXFL4gfrK1+zRG9sajTk62yRh3WzBG46KfKD=iM=VQMTAQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMj1kXFL4gfrK1+zRG9sajTk62yRh3WzBG46KfKD=iM=VQMTAQ@mail.gmail.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, Oct 05, 2020 at 08:44:39AM +0200, Ard Biesheuvel wrote:
> On Mon, 5 Oct 2020 at 08:40, Stephan Mueller <smueller@chronox.de> wrote:
> >
> > Am Montag, 5. Oktober 2020, 08:24:46 CEST schrieb Ard Biesheuvel:
> >
> > Hi Ard,
> >
> > > If jitterentropy is a special case, we could put a alternate
> > > non-'static inline' version of random_get_entropy() in the core
> > > kernel, and only export it if JITTER_ENTROPY is built as a module in
> > > the first place. But I'd prefer it if jitterentropy switches to an API
> > > that is suitable for driver consumption.
> >
> > Which API do you have in mind? In user space, I use
> > clock_gettime(CLOCK_REALTIME) which also considers the clock source.
> >
> 
> AFAICT, that call is backed by ktime_get_real_ts64(), which is already
> being exported to modules.

Indeed. No need for my earlier idea..
