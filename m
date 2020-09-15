Return-Path: <SRS0=sLqA=CY=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9C425C433E2
	for <linux-crypto@archiver.kernel.org>; Tue, 15 Sep 2020 09:34:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 613E121974
	for <linux-crypto@archiver.kernel.org>; Tue, 15 Sep 2020 09:34:19 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="nSClhGdc";
	dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="FfYeu1Dc"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726353AbgIOJeS (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 15 Sep 2020 05:34:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726208AbgIOJeQ (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 15 Sep 2020 05:34:16 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0AF3EC06174A;
        Tue, 15 Sep 2020 02:34:15 -0700 (PDT)
From:   Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1600162454;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=KgTKu24A5oqibjmQi1GmpLg9mnb2+2XExxUNI0RCqJ0=;
        b=nSClhGdcIDmJgc3+suPKs718oHCY4qNrT0wVvDtRhVAcpvv5YSsP3mxvdZDpb1piqTek6V
        sYG0UNTsQGYQyasJKFYsIlhDb5ow7zThgXqHPNCeR2LVNseYGNwhaeT4A/HdTjIDqwKjo/
        OZtyB+skYUGL6uTP1k45C5aFqhhewXbynvoMH2DLUu5c8PFZl3GiFXd+bnIPFsxI6NKQyW
        YgwuGBQNda3jnFncA9FlCs9g1JB4Y7ojnHalSRmnDgwXaKURpjgOHcprqRAsOdjIUJ1+j1
        OWbS67UzD9oAPZ39zjcKkT8jJ0fL8OtebxMeUYy4tS4SlXfsZNJUVdsIvuYLmg==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1600162454;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=KgTKu24A5oqibjmQi1GmpLg9mnb2+2XExxUNI0RCqJ0=;
        b=FfYeu1Dcy2FO8bIP/Eu9cbVTM9gEgxEfs7ZgMwarD875636EhnWLk5LVo8ZGF7eZadvJqk
        R8YPh+zbL/qX5UCw==
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        Linus Torvalds <torvalds@linux-foundation.org>
Cc:     Ard Biesheuvel <ardb@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Subject: Re: [PATCH] crypto: lib/chacha20poly1305 - Set SG_MITER_ATOMIC unconditionally
In-Reply-To: <20200915070523.GA26629@gondor.apana.org.au>
References: <20200914204209.256266093@linutronix.de> <CAHk-=win80rdof8Pb=5k6gT9j_v+hz-TQzKPVastZDvBe9RimQ@mail.gmail.com> <871rj4owfn.fsf@nanos.tec.linutronix.de> <CAHk-=wj0eUuVQ=hRFZv_nY7g5ZLt7Fy3K7SMJL0ZCzniPtsbbg@mail.gmail.com> <CAHk-=wjOV6f_ddg+QVCF6RUe+pXPhSR2WevnNyOs9oT+q2ihEA@mail.gmail.com> <20200915033024.GB25789@gondor.apana.org.au> <CAHk-=wgX=ynJAXYYOAM7J8Tee8acERrGOopNu6ZcLN=SEXdGKA@mail.gmail.com> <CAHk-=wie0Kb-+XOZNasoay7AKCaQ8Ew8=LyvWTBeiPXC3v2GSA@mail.gmail.com> <20200915070523.GA26629@gondor.apana.org.au>
Date:   Tue, 15 Sep 2020 11:34:14 +0200
Message-ID: <878sdb5qp5.fsf@nanos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, Sep 15 2020 at 17:05, Herbert Xu wrote:
> On Mon, Sep 14, 2020 at 11:55:53PM -0700, Linus Torvalds wrote:
>>
>> Maybe we could hide it behind a debug option, at least.
>> 
>> Or, alterantively, introduce a new "debug_preempt_count" that doesn't
>> actually disable preemption, but warns about actual sleeping
>> operations..
>
> I'm more worried about existing users of kmap_atomic relying on
> the preemption disabling semantics.  Short of someone checking
> on every single instance (and that would include derived cases
> such as all users of sg miter), I think the safer option is to
> create something brand new and then migrate the existing users
> to it.  Something like
>
> static inline void *kmap_atomic_ifhigh(struct page *page)
> {
> 	if (PageHighMem(page))
> 		return kmap_atomic(page);
> 	return page_address(page);
> }
>
> static inline void kunmap_atomic_ifhigh(struct page *page, void *addr)
> {
> 	if (PageHighMem(page))
> 		kunmap_atomic(addr);
> }

Hmm, that still has the issue that the code between map and unmap must
not sleep and the conversion must carefully check whether anything in
this region relies on preemption being disabled by kmap_atomic()
regardless of highmem or not.

kmap_atomic() is at least consistent vs. preemption, the above not so
much.

I'd rather go for a preemptible/sleepable version of highmem mapping
which is in itself consistent for both highmen and not highmem.

Thanks,

        tglx


