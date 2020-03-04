Return-Path: <SRS0=WWUc=4V=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_IN_DEF_DKIM_WL autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5BBEFC3F2CD
	for <linux-crypto@archiver.kernel.org>; Wed,  4 Mar 2020 08:59:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2EF882166E
	for <linux-crypto@archiver.kernel.org>; Wed,  4 Mar 2020 08:59:51 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="t45nxzry"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728642AbgCDI7u (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 4 Mar 2020 03:59:50 -0500
Received: from mail-qk1-f194.google.com ([209.85.222.194]:43135 "EHLO
        mail-qk1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728319AbgCDI7u (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 4 Mar 2020 03:59:50 -0500
Received: by mail-qk1-f194.google.com with SMTP id q18so820979qki.10
        for <linux-crypto@vger.kernel.org>; Wed, 04 Mar 2020 00:59:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=P+jMmXTSo2fxNXWVyhqtxpkECUUfyLXXJQ/Qq+zHIkU=;
        b=t45nxzry3NYgFSXkHivggCrJt7bt2CcezPmRDwxMHGIc8qHfUb8/0oDGtuHDytFuBI
         GZDUm6cLW/IXa2iCWYtWErpLSYB01MFLFN/Sx3rLsYvlDKaKRzgq7rXS1mgjs0Qn6871
         bNC8g8Hm9MmokS0ZEC5WjERxWjqI9hUWHqFsgEPHmA+xM+isntCNgEC0q4oisRd/DEHt
         4s/e+T3iHOMH4B2fz2Y8iYTD7fBE+QHLT1VoeG6ybnJvI9iBga5jXmzlx06zmTtqQFNd
         A5UlvBUA8T7ZBAVUynyi+hQKOjH0/PAoqm6i0SEOnh3Alyshwz5eXs+qLASlfCividwM
         JYig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=P+jMmXTSo2fxNXWVyhqtxpkECUUfyLXXJQ/Qq+zHIkU=;
        b=dedADtIlKjPV/Xe2UTPCiy8vaLNO2wE5IgIYsFzKwzZ9Xoy9Ge9YmxJ18dWfL6vEwI
         UfyEz2BLmFdEZ8ZB4/hnjlwQAN9x7tRgL+CjFvVC/BFcTJz34i+GmtdUzcwBY8muwCAM
         mm6Xu2FI5S51vfNhLgBDm2g9+JBbatScKoH9ctz7RUmnblw34+xxqUZX5Ri+mOfYawFg
         tuQGWwQ17HA0/z4Kzso7WNu/Pfwl65Pgg8JxU12YTb71P4iKbhWU4y477DV8m1h8PuE9
         QyRiXHx7Elv/3K5pbtgyaF1gurIKx9wxoSRdw4rsoXRzASUBlqk4wKGdlaoXYEvYNQNj
         SZJg==
X-Gm-Message-State: ANhLgQ190mmk6etuLb3Jl/9oiWQUEhwuW3XZZUz7kxorOlJXHi/7THsQ
        lfQ8ZSyd1OgpprC9/Rme/ojodN/OlsNnpTLM3Lrhbg==
X-Google-Smtp-Source: ADFU+vst6DLKw48grfAaGDLlzabH/C9a8znxSeS/sQBCw/7iv9QIGoVWNaQIg5Rcw226PV2XkpsGdRS+76ycnyAVhQY=
X-Received: by 2002:ae9:e003:: with SMTP id m3mr2003769qkk.250.1583312389274;
 Wed, 04 Mar 2020 00:59:49 -0800 (PST)
MIME-Version: 1.0
References: <000000000000dd909105a002ebe6@google.com> <CACT4Y+ZyhwEsuGK9aJZ=4vXJ_AfHqFn6n5d58H_5E_-o9qHRWA@mail.gmail.com>
 <96b956f4-62cb-83e6-38c2-ca698a862282@moonlit-rail.com>
In-Reply-To: <96b956f4-62cb-83e6-38c2-ca698a862282@moonlit-rail.com>
From:   Dmitry Vyukov <dvyukov@google.com>
Date:   Wed, 4 Mar 2020 09:59:38 +0100
Message-ID: <CACT4Y+b_U6YKujEk9X=NHX45KkL93dLsyu5gS44PpEDi94qS0w@mail.gmail.com>
Subject: Re: INFO: rcu detected stall in sys_keyctl
To:     Kris Karas <linux-1993@moonlit-rail.com>
Cc:     syzbot <syzbot+0c5c2dbf76930df91489@syzkaller.appspotmail.com>,
        David Miller <davem@davemloft.net>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" 
        <linux-crypto@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>,
        Kate Stewart <kstewart@linuxfoundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Eric Biggers <ebiggers@kernel.org>, allison@lohutok.net
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, Mar 4, 2020 at 9:41 AM Kris Karas <linux-1993@moonlit-rail.com> wrote:
>
> Resending this to all the original CCs per suggestion of Dmitry.
> I'm not a member of linux-crypto, no idea if it will bounce; in any
> case, the OOPS I saw does not appear to be crypto related.
>
> Dmitry Vyukov wrote:
> > syzbot wrote:
> >> Call Trace:
> >>   <IRQ>
> >>   __dump_stack lib/dump_stack.c:77 [inline]
> >>   dump_stack+0x197/0x210 lib/dump_stack.c:118
> >>   nmi_cpu_backtrace.cold+0x70/0xb2 lib/nmi_backtrace.c:101
> >>   nmi_trigger_cpumask_backtrace+0x23b/0x28b lib/nmi_backtrace.c:62
> >>   arch_trigger_cpumask_backtrace+0x14/0x20
> >> arch/x86/kernel/apic/hw_nmi.c:38
> >>   trigger_single_cpu_backtrace include/linux/nmi.h:164 [inline]
> >>   rcu_dump_cpu_stacks+0x183/0x1cf kernel/rcu/tree_stall.h:254
> >>   print_cpu_stall kernel/rcu/tree_stall.h:475 [inline]
> >>   check_cpu_stall kernel/rcu/tree_stall.h:549 [inline]
> >>   rcu_pending kernel/rcu/tree.c:3030 [inline]
> >>   rcu_sched_clock_irq.cold+0x51a/0xc37 kernel/rcu/tree.c:2276
> >>   update_process_times+0x2d/0x70 kernel/time/timer.c:1726
> >>   tick_sched_handle+0xa2/0x190 kernel/time/tick-sched.c:171
> >>   tick_sched_timer+0x53/0x140 kernel/time/tick-sched.c:1314
> >>   __run_hrtimer kernel/time/hrtimer.c:1517 [inline]
> >>   __hrtimer_run_queues+0x364/0xe40 kernel/time/hrtimer.c:1579
> >>   hrtimer_interrupt+0x314/0x770 kernel/time/hrtimer.c:1641
> >>   local_apic_timer_interrupt arch/x86/kernel/apic/apic.c:1119 [inline]
> >>   smp_apic_timer_interrupt+0x160/0x610 arch/x86/kernel/apic/apic.c:1144
> >>   apic_timer_interrupt+0xf/0x20 arch/x86/entry/entry_64.S:829
> >>   </IRQ>
> >>
> > +lib/mpi maintainers
> >
> > I wonder if this can also be triggered by remote actors (tls, wifi,
> > usb, etc).
> >
>
> This looks somewhat similar to an OOPS + rcu stall I reported earlier in
> reply to Greg KH's announcement of 5.5.7:
>
>      rcu: INFO: rcu_sched self-detected stall on CPU
>      rcu:    14-....: (20999 ticks this GP)
> idle=216/1/0x4000000000000002 softirq=454/454 fqs=5250
>              (t=21004 jiffies g=-755 q=1327)
>      NMI backtrace for cpu 14
>      CPU: 14 PID: 520 Comm: pidof Tainted: G      D           5.5.7 #1
>      Hardware name: To Be Filled By O.E.M. To Be Filled By O.E.M./X470
> Taichi, BIOS P3.50 07/18/2019
>      Call Trace:
>       <IRQ>
>       dump_stack+0x50/0x70
>       nmi_cpu_backtrace.cold+0x14/0x53
>       ? lapic_can_unplug_cpu.cold+0x44/0x44
>       nmi_trigger_cpumask_backtrace+0x7b/0x88
>       rcu_dump_cpu_stacks+0x7b/0xa9
>       rcu_sched_clock_irq.cold+0x152/0x39b
>       update_process_times+0x1f/0x50
>       tick_sched_timer+0x40/0x90
>       ? tick_sched_do_timer+0x50/0x50
>       __hrtimer_run_queues+0xdd/0x180
>       hrtimer_interrupt+0x108/0x230
>       smp_apic_timer_interrupt+0x53/0xa0
>       apic_timer_interrupt+0xf/0x20
>       </IRQ>
>
> I don't have a reproducer for it, either.  It showed up in 5.5.7 (but
> might be from earlier as it reproduces so infrequently).

Hi Kris,

What follows after this stack? That's the most interesting part. The
part that you showed is common for all stalls and does not mean much,
besides the fact that there is a stall. These can well be very
different stalls in different parts of kernel.
