Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 83468C433EF
	for <linux-crypto@archiver.kernel.org>; Wed, 13 Jul 2022 13:48:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235479AbiGMNsr (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 13 Jul 2022 09:48:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236155AbiGMNso (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 13 Jul 2022 09:48:44 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A915265F;
        Wed, 13 Jul 2022 06:48:40 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BE641B81FB0;
        Wed, 13 Jul 2022 13:48:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5F12C34114;
        Wed, 13 Jul 2022 13:48:36 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
        dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="ZY1mAJ9m"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
        t=1657720114;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=v5HnWZR28Xh1MYgMzpxCz1icS3a6ZaKE3D1pmlpib5Q=;
        b=ZY1mAJ9mFKSaFI+1pNGEKMMmhEV/hNTct/Lq+R/M2RUPyK4okqqo4qdkVedbwFTPd8F+m3
        VcwDce9cwWxt/zmsusBWUrln/ERU7WaSz3ktXBi7727/4yc5n7hyV4smpBGgH+VXrU2Mi/
        S4exOMWcxUTrQC4Zg389PRl/zmx3nh4=
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id efb3e3ff (TLSv1.3:AEAD-AES256-GCM-SHA384:256:NO);
        Wed, 13 Jul 2022 13:48:34 +0000 (UTC)
Date:   Wed, 13 Jul 2022 15:48:32 +0200
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
To:     Harald Freudenberger <freude@linux.ibm.com>
Cc:     linux390-list@tuxmaker.boeblingen.de.ibm.com,
        linux-crypto@vger.kernel.org, linux-s390@vger.kernel.org,
        jchrist@linux.ibm.com, dengler@linux.ibm.com
Subject: Re: [PATCH] s390/archrandom: remove CPACF trng invocations in irq
 context
Message-ID: <Ys7NMKkrELPT3T6H@zx2c4.com>
References: <20220713131721.257907-1-freude@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20220713131721.257907-1-freude@linux.ibm.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi Harald,

On Wed, Jul 13, 2022 at 03:17:21PM +0200, Harald Freudenberger wrote:
> This patch slightly reworks the s390 arch_get_random_seed_{int,long}
> implementation: Make sure the CPACF trng instruction is never
> called in any interrupt context. This is done by adding an
> additional condition in_task().
> 
> Justification:
> 
> There are some constrains to satisfy for the invocation of the
> arch_get_random_seed_{int,long}() functions:
> - They should provide good random data during kernel initialization.
> - They should not be called in interrupt context as the TRNG
>   instruction is relatively heavy weight and may for example
>   make some network loads cause to timeout and buck.
> 
> However, it was not clear what kind of interrupt context is exactly
> encountered during kernel init or network traffic eventually calling
> arch_get_random_seed_long().
> 
> After some days of investigations it is clear that the s390
> start_kernel function is not running in any interrupt context and
> so the trng is called:
> 
> Jul 11 18:33:39 t35lp54 kernel:  [<00000001064e90ca>] arch_get_random_seed_long.part.0+0x32/0x70
> Jul 11 18:33:39 t35lp54 kernel:  [<000000010715f246>] random_init+0xf6/0x238
> Jul 11 18:33:39 t35lp54 kernel:  [<000000010712545c>] start_kernel+0x4a4/0x628
> Jul 11 18:33:39 t35lp54 kernel:  [<000000010590402a>] startup_continue+0x2a/0x40
> 
> The condition in_task() is true and the CPACF trng provides random data
> during kernel startup.
> 
> The network traffic however, is more difficult. A typical call stack
> looks like this:
> 
> Jul 06 17:37:07 t35lp54 kernel:  [<000000008b5600fc>] extract_entropy.constprop.0+0x23c/0x240
> Jul 06 17:37:07 t35lp54 kernel:  [<000000008b560136>] crng_reseed+0x36/0xd8
> Jul 06 17:37:07 t35lp54 kernel:  [<000000008b5604b8>] crng_make_state+0x78/0x340
> Jul 06 17:37:07 t35lp54 kernel:  [<000000008b5607e0>] _get_random_bytes+0x60/0xf8
> Jul 06 17:37:07 t35lp54 kernel:  [<000000008b56108a>] get_random_u32+0xda/0x248
> Jul 06 17:37:07 t35lp54 kernel:  [<000000008aefe7a8>] kfence_guarded_alloc+0x48/0x4b8
> Jul 06 17:37:07 t35lp54 kernel:  [<000000008aeff35e>] __kfence_alloc+0x18e/0x1b8
> Jul 06 17:37:07 t35lp54 kernel:  [<000000008aef7f10>] __kmalloc_node_track_caller+0x368/0x4d8
> Jul 06 17:37:07 t35lp54 kernel:  [<000000008b611eac>] kmalloc_reserve+0x44/0xa0
> Jul 06 17:37:07 t35lp54 kernel:  [<000000008b611f98>] __alloc_skb+0x90/0x178
> Jul 06 17:37:07 t35lp54 kernel:  [<000000008b6120dc>] __napi_alloc_skb+0x5c/0x118
> Jul 06 17:37:07 t35lp54 kernel:  [<000000008b8f06b4>] qeth_extract_skb+0x13c/0x680
> Jul 06 17:37:07 t35lp54 kernel:  [<000000008b8f6526>] qeth_poll+0x256/0x3f8
> Jul 06 17:37:07 t35lp54 kernel:  [<000000008b63d76e>] __napi_poll.constprop.0+0x46/0x2f8
> Jul 06 17:37:07 t35lp54 kernel:  [<000000008b63dbec>] net_rx_action+0x1cc/0x408
> Jul 06 17:37:07 t35lp54 kernel:  [<000000008b937302>] __do_softirq+0x132/0x6b0
> Jul 06 17:37:07 t35lp54 kernel:  [<000000008abf46ce>] __irq_exit_rcu+0x13e/0x170
> Jul 06 17:37:07 t35lp54 kernel:  [<000000008abf531a>] irq_exit_rcu+0x22/0x50
> Jul 06 17:37:07 t35lp54 kernel:  [<000000008b922506>] do_io_irq+0xe6/0x198
> Jul 06 17:37:07 t35lp54 kernel:  [<000000008b935826>] io_int_handler+0xd6/0x110
> Jul 06 17:37:07 t35lp54 kernel:  [<000000008b9358a6>] psw_idle_exit+0x0/0xa
> Jul 06 17:37:07 t35lp54 kernel: ([<000000008ab9c59a>] arch_cpu_idle+0x52/0xe0)
> Jul 06 17:37:07 t35lp54 kernel:  [<000000008b933cfe>] default_idle_call+0x6e/0xd0
> Jul 06 17:37:07 t35lp54 kernel:  [<000000008ac59f4e>] do_idle+0xf6/0x1b0
> Jul 06 17:37:07 t35lp54 kernel:  [<000000008ac5a28e>] cpu_startup_entry+0x36/0x40
> Jul 06 17:37:07 t35lp54 kernel:  [<000000008abb0d90>] smp_start_secondary+0x148/0x158
> Jul 06 17:37:07 t35lp54 kernel:  [<000000008b935b9e>] restart_int_handler+0x6e/0x90
> 
> which confirms that the call is in softirq context. So in_task() covers exactly
> the cases where we want to have CPACF trng called: not in nmi, not in hard irq,
> not in soft irq but in normal task context and during kernel init.

Reluctantly,

   Acked-by: Jason A. Donenfeld <Jason@zx2c4.com>

I'll let you know if I ever get rid of or optimize the call from
kfence_guarded_alloc() so that maybe there's a chance of reverting this.

One small unimportant nit:

>  	if (static_branch_likely(&s390_arch_random_available)) {
> -		cpacf_trng(NULL, 0, (u8 *)v, sizeof(*v));
> -		atomic64_add(sizeof(*v), &s390_arch_random_counter);
> -		return true;
> +		if (in_task()) {

You can avoid a level of indentation by making this:

    if (static_branch_likely(&s390_arch_random_available) && in_task())

But not my code so doesn't really matter to me. So have my Ack above and
I'll stop being nitpicky :).

Jason
