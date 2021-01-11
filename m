Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EC760C433E0
	for <linux-crypto@archiver.kernel.org>; Mon, 11 Jan 2021 20:57:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 99C0222CF8
	for <linux-crypto@archiver.kernel.org>; Mon, 11 Jan 2021 20:57:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727363AbhAKU5r (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 11 Jan 2021 15:57:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36680 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727057AbhAKU5k (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 11 Jan 2021 15:57:40 -0500
Received: from merlin.infradead.org (merlin.infradead.org [IPv6:2001:8b0:10b:1231::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24DCFC061795
        for <linux-crypto@vger.kernel.org>; Mon, 11 Jan 2021 12:57:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=merlin.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=YWiCSKdvpxPRYaVsebSzCwwmgmOb7KYLFetYHLNPAQ8=; b=gZ9Z4xVauLZL3k6djMfNK9zMHM
        ZS8KlwtONxjM+3Dtn2WyuFRkxHiRJh0lO41cwq29/arGq8BRAD6OosK4cNvrUwDRwSvQFE0by41i8
        8FY/B6GDUjbRdv+AogrK+wrJzLUwuOXDEP6xPegiBGCUtkFnc92mJYK+eHVFt9eKx8Jh7aIWnHe7B
        zik/XhR50VUJsmBvtMcAj6OpdMomm/uxYQCHndrRuegmimsclKGaM8T3MKH0T7X80i4CbnHxdQpLq
        E+Eumw5ZFTp9cWRV1bdN/ZjO7E9Z3j0hkQc4nWjl2NHotY9en9ZuJbJEX5VbA2odUTcpo0/3TJyJv
        TPgKdr8A==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=noisy.programming.kicks-ass.net)
        by merlin.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kz4F9-0004TM-1P; Mon, 11 Jan 2021 20:56:51 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id 665813010C8;
        Mon, 11 Jan 2021 21:56:49 +0100 (CET)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id E57272C538DBD; Mon, 11 Jan 2021 21:56:48 +0100 (CET)
Date:   Mon, 11 Jan 2021 21:56:48 +0100
From:   Peter Zijlstra <peterz@infradead.org>
To:     Ard Biesheuvel <ardb@kernel.org>
Cc:     Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Eric Biggers <ebiggers@google.com>
Subject: Re: [PATCH 0/7] crypto: switch to static calls for CRC-T10DIF
Message-ID: <X/y7kOIJSKQs1FCv@hirez.programming.kicks-ass.net>
References: <20210111165237.18178-1-ardb@kernel.org>
 <CAMj1kXEBPjmCGPPme=rXqadLQeNdqzeyr7uw1WsUoHUqQv1_LQ@mail.gmail.com>
 <CAMj1kXHLBDUGZbc7dw0bd5K4ecPLmnDYMwrPA7yGzA0VNaJWgw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMj1kXHLBDUGZbc7dw0bd5K4ecPLmnDYMwrPA7yGzA0VNaJWgw@mail.gmail.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, Jan 11, 2021 at 07:36:20PM +0100, Ard Biesheuvel wrote:
> On Mon, 11 Jan 2021 at 18:27, Ard Biesheuvel <ardb@kernel.org> wrote:
> > On Mon, 11 Jan 2021 at 17:52, Ard Biesheuvel <ardb@kernel.org> wrote:

> > > Special request to Peter to take a look at patch #2, and in particular,
> > > whether synchronize_rcu_tasks() is sufficient to ensure that a module
> > > providing the target of a static call can be unloaded safely.
> >
> > It seems I may have managed to confuse myself slightly here: without
> > an upper bound on the size of the input of the crc_t10dif() routine, I
> > suppose we can never assume that all its callers have finished.
> >
> 
> Replying to self again - apologies.
> 
> I think this is actually correct after all: synchronize_rcu_tasks()
> guarantees that all tasks have passed through a 'safe state', i.e.,
> voluntary schedule(), return to userland, etc, which guarantees that
> no task could be executing the old static call target after
> synchronize_rcu_tasks() returns.

Right, I think it should work.

My initial question was why you'd want to support the unreg at all.
AFAICT these implementations are tiny, why bother having them as a
module, or if you insist having them as a module, why allowing removal?
