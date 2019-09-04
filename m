Return-Path: <SRS0=oAbn=W7=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 487F1C3A5A7
	for <linux-crypto@archiver.kernel.org>; Wed,  4 Sep 2019 11:00:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2AE072339D
	for <linux-crypto@archiver.kernel.org>; Wed,  4 Sep 2019 11:00:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729356AbfIDLAv convert rfc822-to-8bit (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 4 Sep 2019 07:00:51 -0400
Received: from Chamillionaire.breakpoint.cc ([193.142.43.52]:46328 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728961AbfIDLAv (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 4 Sep 2019 07:00:51 -0400
Received: from bigeasy by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <bigeasy@linutronix.de>)
        id 1i5T1j-0002fS-0j; Wed, 04 Sep 2019 13:00:39 +0200
Date:   Wed, 4 Sep 2019 13:00:38 +0200
From:   Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        Stephen Boyd <swboyd@chromium.org>
Cc:     linux-kernel@vger.kernel.org, Theodore Ts'o <tytso@mit.edu>,
        linux-crypto@vger.kernel.org, Matt Mackall <mpm@selenic.com>,
        Keerthy <j-keerthy@ti.com>, Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH] random: Support freezable kthreads in
 add_hwgenerator_randomness()
Message-ID: <20190904110038.2bx25byitrejlteu@flow>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <20190822055519.GB3860@gondor.apana.org.au>
User-Agent: NeoMutt/20180716
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 2019-08-22 15:55:19 [+1000], Herbert Xu wrote:
> Patch applied.  Thanks.
[ ff296293b3538 ("random: Support freezable kthreads in add_hwgenerator_randomness()") ]

and since kthread_freezable_should_stop() has might_sleep() in it, I get
this:

|: do not call blocking ops when !TASK_RUNNING; state=1 set at [<00000000349d1489>] prepare_to_wait_event+0x5a/0x180
|: WARNING: CPU: 0 PID: 828 at kernel/sched/core.c:6741 __might_sleep+0x6f/0x80
|: Modules linked in:
|:
|: CPU: 0 PID: 828 Comm: hwrng Not tainted 5.3.0-rc7-next-20190903+ #46
|: RIP: 0010:__might_sleep+0x6f/0x80
…
|: Call Trace:
|:  kthread_freezable_should_stop+0x1b/0x60
|:  add_hwgenerator_randomness+0xdd/0x130
|:  hwrng_fillfn+0xbf/0x120
|:  kthread+0x10c/0x140
|:  ret_from_fork+0x27/0x50

Sebastian
