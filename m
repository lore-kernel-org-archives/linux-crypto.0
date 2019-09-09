Return-Path: <SRS0=QtXc=XE=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2BA89C00307
	for <linux-crypto@archiver.kernel.org>; Mon,  9 Sep 2019 07:54:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 05F2121920
	for <linux-crypto@archiver.kernel.org>; Mon,  9 Sep 2019 07:54:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388596AbfIIHyb (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 9 Sep 2019 03:54:31 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:32932 "EHLO fornost.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388497AbfIIHya (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 9 Sep 2019 03:54:30 -0400
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.0.7])
        by fornost.hmeau.com with smtp (Exim 4.89 #2 (Debian))
        id 1i7EVB-0007f7-DF; Mon, 09 Sep 2019 17:54:22 +1000
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Mon, 09 Sep 2019 17:54:20 +1000
Date:   Mon, 9 Sep 2019 17:54:20 +1000
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Stephen Boyd <swboyd@chromium.org>
Cc:     linux-kernel@vger.kernel.org, Theodore Ts'o <tytso@mit.edu>,
        linux-crypto@vger.kernel.org,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Keerthy <j-keerthy@ti.com>
Subject: Re: [PATCH] random: Use wait_event_freezable() in
 add_hwgenerator_randomness()
Message-ID: <20190909075420.GG21364@gondor.apana.org.au>
References: <20190905164112.245886-1-swboyd@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190905164112.245886-1-swboyd@chromium.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, Sep 05, 2019 at 09:41:12AM -0700, Stephen Boyd wrote:
> Sebastian reports that after commit ff296293b353 ("random: Support freezable
> kthreads in add_hwgenerator_randomness()") we can call might_sleep() when the
> task state is TASK_INTERRUPTIBLE (state=1). This leads to the following warning.
> 
>  do not call blocking ops when !TASK_RUNNING; state=1 set at [<00000000349d1489>] prepare_to_wait_event+0x5a/0x180
>  WARNING: CPU: 0 PID: 828 at kernel/sched/core.c:6741 __might_sleep+0x6f/0x80
>  Modules linked in:
> 
>  CPU: 0 PID: 828 Comm: hwrng Not tainted 5.3.0-rc7-next-20190903+ #46
>  RIP: 0010:__might_sleep+0x6f/0x80
> 
>  Call Trace:
>   kthread_freezable_should_stop+0x1b/0x60
>   add_hwgenerator_randomness+0xdd/0x130
>   hwrng_fillfn+0xbf/0x120
>   kthread+0x10c/0x140
>   ret_from_fork+0x27/0x50
> 
> We shouldn't call kthread_freezable_should_stop() from deep within the
> wait_event code because the task state is still set as
> TASK_INTERRUPTIBLE instead of TASK_RUNNING and
> kthread_freezable_should_stop() will try to call into the freezer with
> the task in the wrong state. Use wait_event_freezable() instead so that
> it calls schedule() in the right place and tries to enter the freezer
> when the task state is TASK_RUNNING instead.
> 
> Reported-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
> Tested-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
> Cc: Keerthy <j-keerthy@ti.com>
> Fixes: ff296293b353 ("random: Support freezable kthreads in add_hwgenerator_randomness()")
> Signed-off-by: Stephen Boyd <swboyd@chromium.org>
> ---
> 
> See https://lkml.kernel.org/r/20190904110038.2bx25byitrejlteu@flow for
> context on the bug report.
> 
>  drivers/char/random.c | 12 +++++-------
>  1 file changed, 5 insertions(+), 7 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
