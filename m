Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 79B58C433EF
	for <linux-crypto@archiver.kernel.org>; Thu,  7 Oct 2021 19:03:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 51C2B61175
	for <linux-crypto@archiver.kernel.org>; Thu,  7 Oct 2021 19:03:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243826AbhJGTF3 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 7 Oct 2021 15:05:29 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:38882 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233903AbhJGTF2 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 7 Oct 2021 15:05:28 -0400
Date:   Thu, 7 Oct 2021 21:03:32 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1633633413;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=W4t2yyAN8aJI/VwXqElExVPr9t7mXbAytkDI3tvM9DU=;
        b=WTVUhjOhlTC4Zm6rfySiCE9PiX9Ejrlf1kS115+X3iplhC3orhtZah+VC5wW8Spk6piJdK
        odoX+YNYjJKmnWxrwMJNPykk4XNi1Va8o43CKHkP5r/bZkRDqfNMGkzMpf/xZUd3Rd3Ca1
        oXmaUU1UbAwGgipXsiRWqQGew72ThuIHR1vuRvvd9i8qIpAOtlqc59bwFxjUalsXh1AAAP
        V1ruAROzu8OYgbLfNgNLqAz3m6+tylP+tadFhivUdqDTgxGzQPgYAO7tIzN2OfW/VxNovR
        6L8T/WJX8iz/Ot+lBEhe3tqT6bvvxwgzOMfVuAmiB0A1/0/YKUsro7EhgtDxiQ==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1633633413;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=W4t2yyAN8aJI/VwXqElExVPr9t7mXbAytkDI3tvM9DU=;
        b=V/YlpcyvYcUCecIRdhYpAVBA731q5VXHyxaG5wROjPA/86jfdkY6fVpyu8dwCmaPvG+tXw
        xPXVeHZ/bT1HrdDw==
From:   Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH] crypto: testmgr - Only disable migration in
 crypto_disable_simd_for_test()
Message-ID: <20211007190332.3gijssg4lbwfxv6j@linutronix.de>
References: <20210928115401.441339-1-bigeasy@linutronix.de>
 <YVyWrKUk81e10zM7@gmail.com>
 <20211007094224.owhdgujcln2zh2eg@linutronix.de>
 <YV8z/9WVdq3gM8rw@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <YV8z/9WVdq3gM8rw@gmail.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 2021-10-07 10:53:03 [-0700], Eric Biggers wrote:
> On Thu, Oct 07, 2021 at 11:42:24AM +0200, Sebastian Andrzej Siewior wrote:
> > An alternative might be to move the whole test into a kworker which is
> > bound to a specific CPU. So even without disabling preemption/ migration
> > the per-CPU pointer would remain stable.
> > 
> 
> It's only individual test cases that need to use the SIMD disabled flag, not the
> whole test.  An algorithm test could involve 100 test cases, any subset of which
> use the SIMD disabled flag and the others don't.  So the assumption is that this
> can be a relatively fine-grained knob.  Executing different individual test
> cases on different threads sounds painful.  Your simple change to use
> migrate_disable() looks much better, but I'm not sure how to reconcile that with
> the claim that migrate_disable() is a temporary workaround.

Now that you bring it up, I was under the impression that the
"SIMD-disabled" flag is only changed by the tcrypt module not by the
individual tests which are performed at the algorithm lookup time. If it
is the latter than yes, it will be painful. If it is just tcrypt then
you could wrap the whole test-suite (at module init's time) into the
kworker and bind it to one CPU).

Maybe Peter can bring light into the temporary workaround but it does
look like simplest thing here.

> - Eric

Sebastian
