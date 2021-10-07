Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 01D03C433EF
	for <linux-crypto@archiver.kernel.org>; Thu,  7 Oct 2021 09:42:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D7B7361139
	for <linux-crypto@archiver.kernel.org>; Thu,  7 Oct 2021 09:42:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232475AbhJGJoU (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 7 Oct 2021 05:44:20 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:35744 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230467AbhJGJoT (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 7 Oct 2021 05:44:19 -0400
Date:   Thu, 7 Oct 2021 11:42:24 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1633599745;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=hXTFpyDfhx6qm6cp9KbouOiVxuKlk0eijeOxEYNJX8c=;
        b=I7zz9I2Svh4dGKF04vuuJXfVoYvxgJdP9zxru27kllAILb0YONqA+9Rsm6PisPCGUxZjcC
        dGD30+hmRciZMuRe95oTH/Sshwu626KrOgb8sSL1lb3tCl2yjFHkgqshac8hjsLjMZWASn
        QQBXT7ZNnh3++vf7q1Dqo+auL+6iXkJ+NXNiHXpBAL9/guv9dB8G2ZVaLh7OAjcaCTTBFK
        bKcWYWo0FCLF0lBIBDv5+2iwKmVd8x0tk2GKhXw2JajMeQDLIItr4avVat4M1ep5HFkU83
        LjKeL8Hxdeq1pUSfeJceFwfZAyMpup+3JHRdh2Trdd/td0EM8mJ3bIZIiO/t4A==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1633599745;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=hXTFpyDfhx6qm6cp9KbouOiVxuKlk0eijeOxEYNJX8c=;
        b=BXEVfhNByUM4Z4iH7VoOU9kVd6oG93jxXTxn278T4oOrrwRA0ornqBQimpyYvWkcJfI6Ak
        W2Ezf3I9W0ZxSMDA==
From:   Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH] crypto: testmgr - Only disable migration in
 crypto_disable_simd_for_test()
Message-ID: <20211007094224.owhdgujcln2zh2eg@linutronix.de>
References: <20210928115401.441339-1-bigeasy@linutronix.de>
 <YVyWrKUk81e10zM7@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <YVyWrKUk81e10zM7@gmail.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 2021-10-05 11:17:16 [-0700], Eric Biggers wrote:
> Hi Sebastian,
Hi,

> The comment above the definition of migrate_disable() in include/linux/preempt.h
> claims that it is a temporary workaround.

It claims that, yes. I think this is due to the scheduler's limitation
and should not encourage to use this over long sections.

> Is there a better way to do this that should be used instead?

An alternative might be to move the whole test into a kworker which is
bound to a specific CPU. So even without disabling preemption/ migration
the per-CPU pointer would remain stable.

> - Eric

Sebastian
