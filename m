Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E6C13C433EF
	for <linux-crypto@archiver.kernel.org>; Mon, 28 Feb 2022 15:34:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231765AbiB1PfP (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 28 Feb 2022 10:35:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59284 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237571AbiB1PfM (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 28 Feb 2022 10:35:12 -0500
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 491B26929F;
        Mon, 28 Feb 2022 07:34:33 -0800 (PST)
Date:   Mon, 28 Feb 2022 16:34:29 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1646062470;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=O+xoOUH6g8lK/tuOxGXMpAp8oFerIC5THYjgTUh9eSE=;
        b=cp8fkLsoI9zpERUE1MVkprCrx889MwLFPshEDhF/yLVgyphbV0HLI9liO8nY6SciQzvm0g
        wBy1gsj1wA6QK0x7oqi6craqtJZbP2KGSYPspM82VWd25pmtpxq59AAcOgoQNqR5sfXYIr
        152RTS7USKanxcMuF0vQYUNxOcM3BxL6iBIgUB3hmyKYFUOi4815pp2vU7bdHnfIXN05wh
        mhnZds+Y2ZDkMrf7SfCMoVeBznsx96T92tEjEtCkZiwCwyifG6l4Z9TElC9OgZfUJnZGnI
        bFCh180dEoXJ+UIfBL7QTnsrZQyKPt2vBo04uwFaclQi3OnAiFcqwSJEgIcMVg==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1646062470;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=O+xoOUH6g8lK/tuOxGXMpAp8oFerIC5THYjgTUh9eSE=;
        b=uQPp/hlY+wL3+TcNMu5CKrHI5XNeB++/oV1LgK3VkELpPyreik7i7SxC8/khrns1FZ0wo9
        zolODMl6NHAEGeCQ==
From:   Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc:     linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Eric Biggers <ebiggers@kernel.org>,
        Theodore Ts'o <tytso@mit.edu>,
        Dominik Brodowski <linux@dominikbrodowski.net>
Subject: Re: [PATCH v2] random: do crng pre-init loading in worker rather
 than irq
Message-ID: <Yhzrhaa+V7S5/Gtk@linutronix.de>
References: <CAHmME9pTfwbs9xUJy_jrdPcrhSyVixSXBM==9EuB8v7ufWe9Pw@mail.gmail.com>
 <20220224152937.12747-1-Jason@zx2c4.com>
 <YhzWE1NqYQFKeL5B@linutronix.de>
 <CAHmME9r7bRh+CeBh98UMVCFgmeMWHQ=r3b-8odgV0tR45hOTbw@mail.gmail.com>
 <YhzcTOIQx5EkujXq@linutronix.de>
 <Yhzl7hgV12an3dhR@zx2c4.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <Yhzl7hgV12an3dhR@zx2c4.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 2022-02-28 16:10:38 [+0100], Jason A. Donenfeld wrote:
> Hi Sebastian,
Hi Jason,

> Ahh, I understand, okay. Yes, I'll change that first paragraph to
> incorporate your wording, as:
> 
> """
> Taking spinlocks from IRQ context is generally problematic for
> PREEMPT_RT. That is, in part, why we take trylocks instead. However, a
> spin_try_lock() is also problematic since another spin_lock() invocation
> can potentially PI-boost the wrong task, as the spin_try_lock() is
> invoked from an IRQ-context, so the task on CPU (random task or idle) is
> not the actual owner.
> """

I didn't expect it that verbose but yes, full ACK from side.
Thank you.

> Jason

Sebastian
