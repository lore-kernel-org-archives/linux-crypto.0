Return-Path: <SRS0=TLUI=DM=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C07F0C4363A
	for <linux-crypto@archiver.kernel.org>; Mon,  5 Oct 2020 06:44:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6431A206C3
	for <linux-crypto@archiver.kernel.org>; Mon,  5 Oct 2020 06:44:09 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="DMlgHEhy"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725896AbgJEGoI (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 5 Oct 2020 02:44:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725891AbgJEGoI (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 5 Oct 2020 02:44:08 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59AEEC0613CE;
        Sun,  4 Oct 2020 23:44:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=iRWIFXu9IPejAwjRd+GboHZ88cTR/5W5Zq6fO1ic9O4=; b=DMlgHEhyHSc6X2C3Lr2WraccDZ
        VfjiaMKfrp78RiHwjwBRAVhsVRAqDVuV1XFlntQOgD6oYgEcRalr7AXh5g8OWyxIUfR767DD/y0cO
        ZkcAcBJXRxqqwROTBPc7UKTwtkXsh6BzsY1gBv1FNi0vFaU9Vvhs+wIpiFhp1M3iNgDZqVgUn02wg
        dxPkahaxT64ZWhRtCqCv7btUekJ3E2iQ+Y0MfhXh5UfzgqaEkGUGB4e0hflfAHA677Eigpr0xzkiK
        K5/BCZlQpRyopV/AyZNtNDUVXbep1LYr5ErS5oo6osLPGAIN2xXhZK1B+gchSNRb5Cq2o4bge/UVL
        51mnLo5w==;
Received: from hch by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kPKE5-00020y-1l; Mon, 05 Oct 2020 06:44:01 +0000
Date:   Mon, 5 Oct 2020 07:44:00 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     Stephan Mueller <smueller@chronox.de>
Cc:     Christoph Hellwig <hch@infradead.org>,
        Ard Biesheuvel <ardb@kernel.org>,
        Palmer Dabbelt <palmerdabbelt@google.com>,
        linux-riscv <linux-riscv@lists.infradead.org>,
        Android Kernel Team <kernel-team@android.com>,
        kernel test robot <lkp@intel.com>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] crypto: jitterentropy - bind statically into kernel
Message-ID: <20201005064400.GA7462@infradead.org>
References: <20200930065617.934638-1-palmerdabbelt@google.com>
 <20201005061918.GB1856@infradead.org>
 <CAMj1kXFC=6G1pqFAcjASrKJfzguO3k9Rv-7NsmTaX8qNre5TGw@mail.gmail.com>
 <2588700.mWSkj6HvKX@tauon.chronox.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2588700.mWSkj6HvKX@tauon.chronox.de>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

[adding Thomas]

On Mon, Oct 05, 2020 at 08:40:25AM +0200, Stephan Mueller wrote:
> > If jitterentropy is a special case, we could put a alternate
> > non-'static inline' version of random_get_entropy() in the core
> > kernel, and only export it if JITTER_ENTROPY is built as a module in
> > the first place. But I'd prefer it if jitterentropy switches to an API
> > that is suitable for driver consumption.
> 
> Which API do you have in mind? In user space, I use 
> clock_gettime(CLOCK_REALTIME) which also considers the clock source.

We could probably add a kernel_clock_gettime which contains the
clock_gettime syscal implementation minus the put_timespec64.  Thomas,
is this something that fits your timekeeping vision?
