Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4DCDBC433EF
	for <linux-crypto@archiver.kernel.org>; Thu,  7 Oct 2021 17:53:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2A33161245
	for <linux-crypto@archiver.kernel.org>; Thu,  7 Oct 2021 17:53:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233768AbhJGRy7 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 7 Oct 2021 13:54:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:60786 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242757AbhJGRy6 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 7 Oct 2021 13:54:58 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BF95861260;
        Thu,  7 Oct 2021 17:53:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1633629184;
        bh=KzF8yYmPCU4O/8GaNBYN1xyFvuIHeLvLOhWGmA2sVLM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ps3CIlNYT/7Hjd6Jy4rSLB7RvSN54NxZz1IvPF5ihEgElQil4SVbNMUD5FnKLDw/a
         O92rzchrt+UodfGO71IRA7h8NmxBZM7wBOKa2JpP67WMo3LM5DZ8C0NP1Sl7wSMU7Y
         b06WWAL5wk20WhCrA5StMAUGriiBfadEpPzFifoz2AzMjNWhXCq7m+tFLjwK9fLuKQ
         AqShYsb2yvqWKeLaygk6DDs9X0WlIK1VWbIao8dtdrpN52k9x9WPFQqCDOVYuEZUc2
         MIkUoBHdPLTCV5K+D11NbNhRD7KdnTga2+MXMdbYBvrx9Tes9ZbbW9xA2y4pcGuA7P
         0zmTyUUhFV06w==
Date:   Thu, 7 Oct 2021 10:53:03 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc:     linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH] crypto: testmgr - Only disable migration in
 crypto_disable_simd_for_test()
Message-ID: <YV8z/9WVdq3gM8rw@gmail.com>
References: <20210928115401.441339-1-bigeasy@linutronix.de>
 <YVyWrKUk81e10zM7@gmail.com>
 <20211007094224.owhdgujcln2zh2eg@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211007094224.owhdgujcln2zh2eg@linutronix.de>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, Oct 07, 2021 at 11:42:24AM +0200, Sebastian Andrzej Siewior wrote:
> On 2021-10-05 11:17:16 [-0700], Eric Biggers wrote:
> > Hi Sebastian,
> Hi,
> 
> > The comment above the definition of migrate_disable() in include/linux/preempt.h
> > claims that it is a temporary workaround.
> 
> It claims that, yes. I think this is due to the scheduler's limitation
> and should not encourage to use this over long sections.
> 
> > Is there a better way to do this that should be used instead?
> 
> An alternative might be to move the whole test into a kworker which is
> bound to a specific CPU. So even without disabling preemption/ migration
> the per-CPU pointer would remain stable.
> 

It's only individual test cases that need to use the SIMD disabled flag, not the
whole test.  An algorithm test could involve 100 test cases, any subset of which
use the SIMD disabled flag and the others don't.  So the assumption is that this
can be a relatively fine-grained knob.  Executing different individual test
cases on different threads sounds painful.  Your simple change to use
migrate_disable() looks much better, but I'm not sure how to reconcile that with
the claim that migrate_disable() is a temporary workaround.

- Eric
