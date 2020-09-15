Return-Path: <SRS0=sLqA=CY=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A00F9C433E2
	for <linux-crypto@archiver.kernel.org>; Tue, 15 Sep 2020 19:05:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3EAB6206A2
	for <linux-crypto@archiver.kernel.org>; Tue, 15 Sep 2020 19:05:07 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="xAOtFxaL";
	dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="/vF0ubIm"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727963AbgIOTFD (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 15 Sep 2020 15:05:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48950 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727915AbgIOTEF (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 15 Sep 2020 15:04:05 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 31089C061788;
        Tue, 15 Sep 2020 12:04:04 -0700 (PDT)
From:   Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1600196642;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=FdxWKAjCFS83IiMhKQBg5fI17hkPi4evmAcGceo04xo=;
        b=xAOtFxaLRLqJPrtW71uHDeLw30N6grk81Lf8XE2Xl0MU5MA4KKhkOrNzJ2osP0x9L4LOYT
        /WtX9XJsgz0GiPSK/bdDMXRNtwYs9HaOE5NpGfa/lwiiCOktd9iH4DwV9sLPiDATlMPeOp
        uiqMoKp2OwAItxo4xSjuZDvQnFLq+UwHQUN1Z2pNp83phZ+1zKIMOsgvI/azCOiuhIW9gp
        myGYkIdr6CED7J5i9uhl2Q5na0tbM7Ax00t/FU7c/red+T9KMWALHJM/QpSxVk13eINkxc
        pzpDY7yTcvnJM0upRkt8qcRYPzTnsfvnLEwEhrI+X7+l1hVHtqZ6nOXxXtAFpQ==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1600196642;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=FdxWKAjCFS83IiMhKQBg5fI17hkPi4evmAcGceo04xo=;
        b=/vF0ubImrcXFCvY9FHrTLQYQaHp8ceb3S1pZCltCZnCIF01ROhqvttt7XXbc47KhNaTkqz
        7CceZN8Blr8z4yAA==
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        Ard Biesheuvel <ardb@kernel.org>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Subject: Re: [PATCH] crypto: lib/chacha20poly1305 - Set SG_MITER_ATOMIC unconditionally
In-Reply-To: <20200915101043.GA27327@gondor.apana.org.au>
References: <CAHk-=wj0eUuVQ=hRFZv_nY7g5ZLt7Fy3K7SMJL0ZCzniPtsbbg@mail.gmail.com> <CAHk-=wjOV6f_ddg+QVCF6RUe+pXPhSR2WevnNyOs9oT+q2ihEA@mail.gmail.com> <20200915033024.GB25789@gondor.apana.org.au> <CAHk-=wgX=ynJAXYYOAM7J8Tee8acERrGOopNu6ZcLN=SEXdGKA@mail.gmail.com> <CAHk-=wie0Kb-+XOZNasoay7AKCaQ8Ew8=LyvWTBeiPXC3v2GSA@mail.gmail.com> <20200915070523.GA26629@gondor.apana.org.au> <878sdb5qp5.fsf@nanos.tec.linutronix.de> <CAMj1kXHsqZzfJ2qmsrUWEU_XWxmR1PhY3zo-yz9Vau90-WphXg@mail.gmail.com> <20200915100506.GA27268@gondor.apana.org.au> <CAMj1kXHAHrCCCTce3aLX0v=TDiWDiiwGaUPZQfqekKAsByMSvg@mail.gmail.com> <20200915101043.GA27327@gondor.apana.org.au>
Date:   Tue, 15 Sep 2020 21:04:01 +0200
Message-ID: <874kny6evy.fsf@nanos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, Sep 15 2020 at 20:10, Herbert Xu wrote:
> On Tue, Sep 15, 2020 at 01:08:31PM +0300, Ard Biesheuvel wrote:
>>
>> But making atomic kmap preemptible/sleepable creates the exact same
>> problem, i.e., that we have no idea which existing callers are
>> currently relying on those preemption disabling semantics, so we can't
>> just take them away. Or am I missing something?
>
> Good point.
>
> Thomas mentioned that RT has been doing this for a while now so
> perhaps someone has studied this problem already? Thomas?

RT is substituting preempt_disable() with migrate_disable() which pins
the task on the CPU so that per CPU stuff still works. And we did quite
some staring whether there is code which purely relies on the
preempt_disable() to prevent reentrancy, but there is almost none.

Though we don't have migrate disable on !RT and PeterZ is not a great
fan of making it available as it wreckages schedulability - though IMO
not much more than preempt disable :)

Thanks,

        tglx
