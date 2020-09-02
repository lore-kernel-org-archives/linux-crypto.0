Return-Path: <SRS0=ze1v=CL=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 20FE5C433E2
	for <linux-crypto@archiver.kernel.org>; Wed,  2 Sep 2020 09:17:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E7F162087D
	for <linux-crypto@archiver.kernel.org>; Wed,  2 Sep 2020 09:17:58 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="FgAXutFv"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726400AbgIBJR5 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 2 Sep 2020 05:17:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49242 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726307AbgIBJR4 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 2 Sep 2020 05:17:56 -0400
Received: from merlin.infradead.org (merlin.infradead.org [IPv6:2001:8b0:10b:1231::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E315FC061244
        for <linux-crypto@vger.kernel.org>; Wed,  2 Sep 2020 02:17:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=merlin.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=ZnearYLs9EAIjRLhenewv8wpyf6ZjBlTieaIgpiCvRI=; b=FgAXutFvWZotVv/+SUruPU58fq
        OTwMCUWfym9BW16aBAVC2LSpvjb/3hC0MQAohOj3CwN3heE/WtlRPaZFqxt6MDsk0MQmQ6E7C5Ikr
        d1zYqudfWSxdWw2z0jO+8j9SrNsIcJDP3jNVy3gx7PpXwCLgjZpGYl+M2r6I5jZYepFHjiXHdjcyI
        IkQDrP13wLppi64ywsJhaHn3Tb+T+ccPia2GCHUUATQS+MgPFbMPNZFx6VBw9OxXP1iHiBBdJh5Ic
        lS6aupD2dDG7ZhBW1XCctk+X81aeELgQazwQZAiocAOL1b5fESqWxzulkxTVKhTuys90D2nvSo64L
        H991ObbQ==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=noisy.programming.kicks-ass.net)
        by merlin.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kDOtj-0007u6-Mr; Wed, 02 Sep 2020 09:17:44 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id BE49A304B92;
        Wed,  2 Sep 2020 11:17:41 +0200 (CEST)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id 850AC20598A34; Wed,  2 Sep 2020 11:17:41 +0200 (CEST)
Date:   Wed, 2 Sep 2020 11:17:41 +0200
From:   peterz@infradead.org
To:     Uros Bizjak <ubizjak@gmail.com>
Cc:     "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Karthik Bhargavan <karthikeyan.bhargavan@inria.fr>,
        Chris.Hawblitzel@microsoft.com,
        Jonathan Protzenko <protz@microsoft.com>,
        Aymeric Fromherz <fromherz@cmu.edu>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        X86 ML <x86@kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Ard Biesheuvel <ardb@kernel.org>
Subject: Re: [PATCH] crypto/x86: Use XORL r32,32 in curve25519-x86_64.c
Message-ID: <20200902091741.GX1362448@hirez.programming.kicks-ass.net>
References: <20200827173058.94519-1-ubizjak@gmail.com>
 <CAMj1kXHChRSxAgMNPpHoT-Z2CFoVQOgtmpK6tCboe1G06xuF_w@mail.gmail.com>
 <CAHmME9p3f2ofwQtc2OZ-uuM_JggJtf93nXWVkuUdqYqxB6baYg@mail.gmail.com>
 <CAHmME9oemtY5PG9WjbOOtd_xxbMRPb1t5mPoo2rR-y3umYKd5Q@mail.gmail.com>
 <CAFULd4ZH3s=9nsvNE8Sxf=r-KZJX5NKxFehNo7YU2=2ExwbsQQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAFULd4ZH3s=9nsvNE8Sxf=r-KZJX5NKxFehNo7YU2=2ExwbsQQ@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, Sep 02, 2020 at 07:50:36AM +0200, Uros Bizjak wrote:
> On Tue, Sep 1, 2020 at 9:12 PM Jason A. Donenfeld <Jason@zx2c4.com> wrote:
> >
> > On Tue, Sep 1, 2020 at 8:13 PM Jason A. Donenfeld <Jason@zx2c4.com> wrote:
> > > operands are the same. Also, have you seen any measurable differences
> > > when benching this? I can stick it into kbench9000 to see if you
> > > haven't looked yet.
> >
> > On a Skylake server (Xeon Gold 5120), I'm unable to see any measurable
> > difference with this, at all, no matter how much I median or mean or
> > reduce noise by disabling interrupts.
> >
> > One thing that sticks out is that all the replacements of r8-r15 by
> > their %r8d-r15d counterparts still have the REX prefix, as is
> > necessary to access those registers. The only ones worth changing,
> > then, are the legacy registers, and on a whole, this amounts to only
> > 48 bytes of difference.
> 
> The patch implements one of x86 target specific optimizations,
> performed by gcc. The optimization results in code size savings of one
> byte, where REX prefix is omitted with legacy registers, but otherwise
> should have no measurable runtime effect. Since gcc applies this
> optimization universally to all integer registers, I took the same
> approach and implemented the same change to legacy and REX registers.
> As measured above, 48 bytes saved is a good result for such a trivial
> optimization.

Could we instead implement this optimization in GAS ? Then we can leave
the code as-is.
