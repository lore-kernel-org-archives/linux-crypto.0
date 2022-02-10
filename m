Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EF86AC433EF
	for <linux-crypto@archiver.kernel.org>; Thu, 10 Feb 2022 16:24:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244146AbiBJQYw (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 10 Feb 2022 11:24:52 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:40626 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239459AbiBJQYu (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 10 Feb 2022 11:24:50 -0500
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E224137
        for <linux-crypto@vger.kernel.org>; Thu, 10 Feb 2022 08:24:51 -0800 (PST)
Date:   Thu, 10 Feb 2022 17:24:45 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1644510286;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=533jsIqQTyZGT49BnyJvM90mAluPXrkfvryraWV7Mw4=;
        b=nvNLWYwSFyZ68FEe7ggrFYj3+qfZuIqSsYJhpWDbkswIgm6q81bZDi54Wu3mlVxXjbPF4y
        Qq6wvDiFpvhm/UrJaw8ww0C7ZtIxQR3jEB3XJNyoa7oOlWthe9gDgiCnWH4vhcYcFT0/M0
        fKnW9ai/1Hgjzd2PcbMU1agxHe4ijbND5LcHAAxcrrN1DGmmSjry6SjJ7I7KgCCoJufY+I
        T6p4iXwctouCW1HzB/UGIXxQxbQwLtOFzXEGoZP22KadkXCJIeGgM6ees0jV9vdh6XtHwn
        FxzPzYmlTs+JAC6hIvlBxor+QFANLLGZ0Ena3zbqMhwclufyqJMs/hzufhx33A==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1644510286;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=533jsIqQTyZGT49BnyJvM90mAluPXrkfvryraWV7Mw4=;
        b=+2AgLRfyuewfQQxMhTkgyF20vhdGJ0wEV/n4+No+mKN8/7lXieKHKADA2b2QGHa5vf9UQn
        LwfSAw/R67i2B9Ag==
From:   Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc:     linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Theodore Ts'o <tytso@mit.edu>,
        Sultan Alsawaf <sultan@kerneltoast.com>,
        Jonathan =?utf-8?Q?Neusch=C3=A4fer?= <j.neuschaefer@gmx.net>,
        Eric Biggers <ebiggers@kernel.org>,
        Andy Lutomirski <luto@kernel.org>
Subject: Re: [PATCH v4 1/2] random: remove batched entropy locking
Message-ID: <YgU8Tdoxa0XC1oRy@linutronix.de>
References: <20220209125644.533876-1-Jason@zx2c4.com>
 <20220209125644.533876-2-Jason@zx2c4.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <20220209125644.533876-2-Jason@zx2c4.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 2022-02-09 13:56:43 [+0100], Jason A. Donenfeld wrote:
> Rather than use spinlocks to protect batched entropy, we can instead
> disable interrupts locally, since we're dealing with per-cpu data, and
> manage resets with a basic generation counter. At the same time, we
> can't quite do this on PREEMPT_RT, where we still want spinlocks-as-
> mutexes semantics. So we use a local_lock_t, which provides the right
> behavior for each. Because this is a per-cpu lock, that generation
> counter is still doing the necessary CPU-to-CPU communication.
>=20
> This should improve performance a bit. It will also fix the linked splat
> that Jonathan received with a PROVE_RAW_LOCK_NESTING=3Dy.
>=20
> Suggested-by: Andy Lutomirski <luto@kernel.org>
> Reported-by: Jonathan Neusch=C3=A4fer <j.neuschaefer@gmx.net>
> Tested-by: Jonathan Neusch=C3=A4fer <j.neuschaefer@gmx.net>
> Link: https://lore.kernel.org/lkml/YfMa0QgsjCVdRAvJ@latitude/
> Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
> Cc: Sultan Alsawaf <sultan@kerneltoast.com>
> Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>

Reviewed-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>

Sebastian
