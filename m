Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8E381C433DB
	for <linux-crypto@archiver.kernel.org>; Tue,  5 Jan 2021 08:05:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4940422257
	for <linux-crypto@archiver.kernel.org>; Tue,  5 Jan 2021 08:05:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726097AbhAEIFf (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 5 Jan 2021 03:05:35 -0500
Received: from mo4-p00-ob.smtp.rzone.de ([81.169.146.216]:8433 "EHLO
        mo4-p00-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725766AbhAEIFf (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 5 Jan 2021 03:05:35 -0500
X-Greylist: delayed 36595 seconds by postgrey-1.27 at vger.kernel.org; Tue, 05 Jan 2021 03:05:34 EST
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1609833699;
        s=strato-dkim-0002; d=chronox.de;
        h=Date:To:From:Subject:Message-ID:From:Subject:Sender;
        bh=hKdna6KPNLtDSP3KiZlS2z+SaGRm/1fOMKo2bAsC3AI=;
        b=je3VeWh60vyoypNMyCRIbc6WODMAJTb4Atsu1JNZ20gNWOSI5AsXVqPKn1AqumcWwL
        FfwkkN8cxSmlHDo/Uxk5EXLteO+rt+Prx9m0UhnZrjNXNz1ooJAS453WJYfmQe29cmnG
        z7QtgkUODWOjoHA56OPjlyGEGGzG92hO7MG8XOvaEIrNwsQb/5azc3ISLiLFQxRrkvHi
        nnLffOnlYALXbZjwzyZL3JdJXoWN6ZuV2TwpJuT1JrpQxL0Fsg1nC+/Bl8SKI6krH+6b
        V6PsjaHevxAtYb5wUG5Y1wuEEq5J7gFEOaJ5/Zz/4MTRxezPccIV2cDa5xNMfzaudCCS
        ScsA==
X-RZG-AUTH: ":P2ERcEykfu11Y98lp/T7+hdri+uKZK8TKWEqNzyCzy1Sfr67uExK884EC0GFGHavJSlCkMJYXg=="
X-RZG-CLASS-ID: mo00
Received: from tauon.chronox.de
        by smtp.strato.de (RZmta 47.10.7 DYNA|AUTH)
        with ESMTPSA id h02bd9x0581dzAu
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
        (Client did not present a certificate)
        for <linux-crypto@vger.kernel.org>;
        Tue, 5 Jan 2021 09:01:39 +0100 (CET)
Message-ID: <5835e225936bd461a9920270432df9b165fda953.camel@chronox.de>
Subject: Testmgr: invalid lock context
From:   Stephan Mueller <smueller@chronox.de>
To:     linux-crypto <linux-crypto@vger.kernel.org>
Date:   Tue, 05 Jan 2021 09:01:39 +0100
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.38.2 (3.38.2-1.fc33) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi,

with the current cryptodev-2.6 tree and the Linus rc-2 tree, I get the
following during boot:

[    0.837048] =============================
[    0.837079] [ BUG: Invalid wait context ]
[    0.837079] 5.11.0-rc1+ #215 Not tainted
[    0.837079] -----------------------------
[    0.837079] cryptomgr_test/137 is trying to lock:
[    0.837079] ffffffff914e8e98 (depot_lock){..-.}-{3:3}, at:
stack_depot_save+0x1c8/0x4e0
[    0.837079] other info that might help us debug this:
[    0.837079] context-{5:5}
[    0.837079] 2 locks held by cryptomgr_test/137:
[    0.837079]  #0: ffffffff910aaa00 (rcu_read_lock){....}-{1:3}, at:
__queue_work+0x65/0x8e0
[    0.837079]  #1: ffff88807ea34fd8 (&pool->lock){....}-{2:2}, at:
__queue_work+0x244/0x8e0
[    0.837079] stack backtrace:
[    0.837079] CPU: 1 PID: 137 Comm: cryptomgr_test Not tainted 5.11.0-rc1+
#215
[    0.837079] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS
1.14.0-1.fc33 04/01/2014
[    0.837079] Call Trace:
[    0.837079]  dump_stack+0x9a/0xcc
[    0.837079]  __lock_acquire.cold+0xdd/0x345
[    0.837079]  ? stack_trace_call+0xd3/0x5a0
[    0.837079]  ? deref_stack_reg+0x93/0xb0
[    0.837079]  ? preempt_count_sub+0x14/0xc0
[    0.837079]  ? lockdep_hardirqs_on_prepare+0x230/0x230
[    0.837079]  ? preempt_count_sub+0x14/0xc0
[    0.837079]  ? unwind_next_frame+0x235/0xb80
[    0.837079]  ? ret_from_fork+0x1f/0x30
[    0.837079]  lock_acquire+0x241/0x650
[    0.837079]  ? stack_depot_save+0x1c8/0x4e0
[    0.837079]  ? lock_release+0x440/0x440
[    0.837079]  ? arch_stack_walk+0x88/0xf0
[    0.837079]  ? ret_from_fork+0x1f/0x30
[    0.837079]  _raw_spin_lock_irqsave+0x3e/0x60
[    0.837079]  ? stack_depot_save+0x1c8/0x4e0
[    0.837079]  stack_depot_save+0x1c8/0x4e0
[    0.837079]  kasan_save_stack+0x32/0x40
[    0.837079]  ? kasan_save_stack+0x1b/0x40
[    0.837079]  ? kasan_record_aux_stack+0xb7/0xe0
[    0.837079]  ? insert_work+0x2d/0x130
[    0.837079]  ? __queue_work+0x36d/0x8e0
[    0.837079]  ? queue_work_on+0x78/0x80
[    0.837079]  ? alg_test.cold+0xbb/0xc0
[    0.837079]  ? cryptomgr_test+0x36/0x60
[    0.837079]  ? kthread+0x213/0x240
[    0.837079]  ? ret_from_fork+0x1f/0x30
[    0.837079]  ? lockdep_hardirqs_on_prepare+0x230/0x230
[    0.837079]  ? lockdep_hardirqs_on_prepare+0x230/0x230
[    0.837079]  ? cryptomgr_test+0x36/0x60
[    0.837079]  ? ret_from_fork+0x1f/0x30
[    0.837079]  ? lock_acquire+0x241/0x650
[    0.837079]  ? lock_release+0x440/0x440
[    0.837079]  ? lock_release+0x440/0x440
[    0.837079]  ? do_raw_spin_lock+0x119/0x1b0
[    0.837079]  ? rwlock_bug.part.0+0x60/0x60
[    0.837079]  kasan_record_aux_stack+0xb7/0xe0
[    0.837079]  insert_work+0x2d/0x130
[    0.837079]  __queue_work+0x36d/0x8e0
[    0.837079]  ? rcu_read_lock_sched_held+0x3f/0x70
[    0.837079]  queue_work_on+0x78/0x80
[    0.837079]  alg_test.cold+0xbb/0xc0
[    0.837079]  ? test_cipher+0x330/0x330
[    0.837079]  ? __kthread_parkme+0x66/0xf0
[    0.837079]  ? lock_downgrade+0x3b0/0x3b0
[    0.837079]  ? mark_held_locks+0x24/0x90
[    0.837079]  ? lockdep_hardirqs_on_prepare+0x133/0x230
[    0.837079]  ? _raw_spin_unlock_irqrestore+0x47/0x60
[    0.837079]  ? lockdep_hardirqs_on+0x79/0x100
[    0.837079]  ? preempt_count_sub+0x14/0xc0
[    0.837079]  ? crypto_acomp_scomp_free_ctx+0x70/0x70
[    0.837079]  cryptomgr_test+0x36/0x60
[    0.837079]  kthread+0x213/0x240
[    0.837079]  ? kthread_create_worker_on_cpu+0xd0/0xd0
[    0.837079]  ret_from_fork+0x1f/0x30

I will also have a look into this.

Ciao
Stephan

