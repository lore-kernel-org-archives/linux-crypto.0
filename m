Return-Path: <SRS0=TLUI=DM=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A5AA5C4363A
	for <linux-crypto@archiver.kernel.org>; Mon,  5 Oct 2020 06:19:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 07E31207BC
	for <linux-crypto@archiver.kernel.org>; Mon,  5 Oct 2020 06:19:31 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="rfUpjTHv"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725867AbgJEGTa (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 5 Oct 2020 02:19:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725267AbgJEGTa (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 5 Oct 2020 02:19:30 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 020D0C0613CE;
        Sun,  4 Oct 2020 23:19:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=jGLMgatw8+YPeZ8gLExrPIHr/pPSgzJ2R4w/NAyNuAQ=; b=rfUpjTHvULZcKWcUmjU3yIa0C0
        UywruIXCF3IxGM+3Remk7eb4rOvPqJhbo8qPSVY5hYoUOT6YlbtvnV8QPM6uIK0dpHia6mcjKxqe0
        SnjVnL3FChJeffK69Pj1Ccl2YmE1eZThAvMvJPY4fsKiHSF0KhDpbOrLhVzNqDMeyILvoQZF67mPy
        zlXm26GavxK/1S1tPViAMQCmRB0dEICTOOTGyyb9zy5XgbbbOHQLJDrk391roHsf7xYBjLw/qOkW9
        xZ6qTheN13371BAIuMUx7mUvXXLpb0rUU6zx9Jbw3nlwn/u0C8MrU7YGCAQRkMj3AKuC/W4TyyMVw
        zgXQPpTA==;
Received: from hch by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kPJqA-0000j1-K8; Mon, 05 Oct 2020 06:19:18 +0000
Date:   Mon, 5 Oct 2020 07:19:18 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     Ard Biesheuvel <ardb@kernel.org>
Cc:     Stephan M??ller <smueller@chronox.de>,
        Palmer Dabbelt <palmerdabbelt@google.com>,
        Christoph Hellwig <hch@infradead.org>,
        linux-riscv <linux-riscv@lists.infradead.org>,
        Android Kernel Team <kernel-team@android.com>,
        kernel test robot <lkp@intel.com>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] crypto: jitterentropy - bind statically into kernel
Message-ID: <20201005061918.GB1856@infradead.org>
References: <20200930065617.934638-1-palmerdabbelt@google.com>
 <20201002064905.GA27115@infradead.org>
 <5692716.lOV4Wx5bFT@positron.chronox.de>
 <CAMj1kXEnOh4MBiVVgkhd4P81eRPCVi3+y6JcD58jL45-eh324A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMj1kXEnOh4MBiVVgkhd4P81eRPCVi3+y6JcD58jL45-eh324A@mail.gmail.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Sun, Oct 04, 2020 at 11:16:10PM +0200, Ard Biesheuvel wrote:
> On Sun, 4 Oct 2020 at 20:48, Stephan M??ller <smueller@chronox.de> wrote:
> >
> > The RISC-V architecture is about to implement the callback
> > random_get_entropy with a function that is not exported to modules.
> 
> Why is that? Wouldn't it be better to export the symbol instead?

get_cycles is a low-level time keeping detail that really should not
be exported, and at least for RISC-V this would be the only modular
user.  Once that is sorted out I'll audit other common architectures
to drop the export, as it isn't something that should be used in ramdom
driver code.
