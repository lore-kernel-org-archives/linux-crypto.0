Return-Path: <SRS0=WWUc=4V=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.3 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_IN_DEF_DKIM_WL
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8ABB9C3F2D7
	for <linux-crypto@archiver.kernel.org>; Wed,  4 Mar 2020 08:15:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 59F172166E
	for <linux-crypto@archiver.kernel.org>; Wed,  4 Mar 2020 08:15:31 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="tV1IU1zE"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728532AbgCDIPa (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 4 Mar 2020 03:15:30 -0500
Received: from mail-qt1-f193.google.com ([209.85.160.193]:40194 "EHLO
        mail-qt1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728531AbgCDIPa (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 4 Mar 2020 03:15:30 -0500
Received: by mail-qt1-f193.google.com with SMTP id o10so712611qtr.7
        for <linux-crypto@vger.kernel.org>; Wed, 04 Mar 2020 00:15:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=XYaQQxVSy2LFcixV0usx/fdLhqd23krMhAkcq5zI6GI=;
        b=tV1IU1zEKW6IgOo7X6mrGeplTe1isPnr9wWY3Z8we/1gmJ+yyf6JXV7lhonSkXjcn8
         V/lbZMHPh+WIHoWV48wm+TrG4TPXab/Lw+OPkyfF5MwZHtUnWX+/iK/FJm5qcWwCfOmk
         VH3j2DPykgCAwvu/Ko59JTgIlk8r4NR17EoTYHKjOnW3CC0WEyvqHdQQ3NgvOqop86eX
         1/tx7gjYpiAhMt/fue6UafkNcj7svHcTUQeg6KW5ZOs7BzjeMiahcSmxGZmKaprKLsQZ
         w+Z9CGFQ1m9RGp9/Km9CLLmc+e6nD9qhHH3aXOmZEvwuv1E09yRevTZlCrE47ntHdImP
         wdqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=XYaQQxVSy2LFcixV0usx/fdLhqd23krMhAkcq5zI6GI=;
        b=LUqhI+QKBDi873fuC1dxAJOKtdSkwi2c3ptJyZMItzBKMD2AN9pOKvSRaZ4amoyHRf
         FZKrsYeuuUjTqdGOTwuk+IpmLduDFfq0+apUNyRVHyAZNBWYMoTUAWuBgCUkwiprB3q1
         BWcEAamSpE+oA7ocBfhzgDbtxpuQ/blkCGN4kK3w6JsFNb1Bp0BjJbhwRalSjWifmQit
         L/tWQGPdUBH3MfWVB3oHo4emmvdy9w/53BxqoslC03MoaXCzah9eBUfJgryjN50Hdf+M
         HUGvRkn61ITWJb1+iETl3oejia7txvHCo1CAx3jn8yQC8qHEhqFvO0FnR9cfSqePQpib
         /H+g==
X-Gm-Message-State: ANhLgQ3vk9RAYk4Yw5exWsv9le4nZjdmAp2Un7m/WtkdDF2LzUC+Lf6P
        wZZCXQN+xsmWGKXLo1P7V/abkzZYODTwKBQ08nSUpQ==
X-Google-Smtp-Source: ADFU+vu/aEmWi2FpgD6dYckIMsvmwRFS/0yUIenkrmsbwWHbzZYMT5ZttmNMvF7ANxCaTK+mc93W3fnKgrgZJDpF1o4=
X-Received: by 2002:ac8:3533:: with SMTP id y48mr1371864qtb.380.1583309729203;
 Wed, 04 Mar 2020 00:15:29 -0800 (PST)
MIME-Version: 1.0
References: <000000000000dd909105a002ebe6@google.com>
In-Reply-To: <000000000000dd909105a002ebe6@google.com>
From:   Dmitry Vyukov <dvyukov@google.com>
Date:   Wed, 4 Mar 2020 09:15:17 +0100
Message-ID: <CACT4Y+ZyhwEsuGK9aJZ=4vXJ_AfHqFn6n5d58H_5E_-o9qHRWA@mail.gmail.com>
Subject: Re: INFO: rcu detected stall in sys_keyctl
To:     syzbot <syzbot+0c5c2dbf76930df91489@syzkaller.appspotmail.com>
Cc:     David Miller <davem@davemloft.net>,
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

On Wed, Mar 4, 2020 at 9:08 AM syzbot
<syzbot+0c5c2dbf76930df91489@syzkaller.appspotmail.com> wrote:
>
> Hello,
>
> syzbot found the following crash on:
>
> HEAD commit:    63623fd4 Merge tag 'for-linus' of git://git.kernel.org/pub..
> git tree:       upstream
> console output: https://syzkaller.appspot.com/x/log.txt?x=15257ba1e00000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=9833e26bab355358
> dashboard link: https://syzkaller.appspot.com/bug?extid=0c5c2dbf76930df91489
> compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
>
> Unfortunately, I don't have any reproducer for this crash yet.
>
> IMPORTANT: if you fix the bug, please add the following tag to the commit:
> Reported-by: syzbot+0c5c2dbf76930df91489@syzkaller.appspotmail.com
>
> rcu: INFO: rcu_preempt self-detected stall on CPU
> rcu:    0-....: (1 GPs behind) idle=576/1/0x4000000000000002 softirq=55718/56054 fqs=5235
>         (t=10500 jiffies g=63445 q=1523)
> NMI backtrace for cpu 0
> CPU: 0 PID: 18804 Comm: syz-executor.4 Not tainted 5.6.0-rc3-syzkaller #0
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
> Call Trace:
>  <IRQ>
>  __dump_stack lib/dump_stack.c:77 [inline]
>  dump_stack+0x197/0x210 lib/dump_stack.c:118
>  nmi_cpu_backtrace.cold+0x70/0xb2 lib/nmi_backtrace.c:101
>  nmi_trigger_cpumask_backtrace+0x23b/0x28b lib/nmi_backtrace.c:62
>  arch_trigger_cpumask_backtrace+0x14/0x20 arch/x86/kernel/apic/hw_nmi.c:38
>  trigger_single_cpu_backtrace include/linux/nmi.h:164 [inline]
>  rcu_dump_cpu_stacks+0x183/0x1cf kernel/rcu/tree_stall.h:254
>  print_cpu_stall kernel/rcu/tree_stall.h:475 [inline]
>  check_cpu_stall kernel/rcu/tree_stall.h:549 [inline]
>  rcu_pending kernel/rcu/tree.c:3030 [inline]
>  rcu_sched_clock_irq.cold+0x51a/0xc37 kernel/rcu/tree.c:2276
>  update_process_times+0x2d/0x70 kernel/time/timer.c:1726
>  tick_sched_handle+0xa2/0x190 kernel/time/tick-sched.c:171
>  tick_sched_timer+0x53/0x140 kernel/time/tick-sched.c:1314
>  __run_hrtimer kernel/time/hrtimer.c:1517 [inline]
>  __hrtimer_run_queues+0x364/0xe40 kernel/time/hrtimer.c:1579
>  hrtimer_interrupt+0x314/0x770 kernel/time/hrtimer.c:1641
>  local_apic_timer_interrupt arch/x86/kernel/apic/apic.c:1119 [inline]
>  smp_apic_timer_interrupt+0x160/0x610 arch/x86/kernel/apic/apic.c:1144
>  apic_timer_interrupt+0xf/0x20 arch/x86/entry/entry_64.S:829
>  </IRQ>
> RIP: 0010:__sanitizer_cov_trace_const_cmp4+0x16/0x20 kernel/kcov.c:276
> Code: 48 89 e5 48 8b 4d 08 e8 d8 fe ff ff 5d c3 66 0f 1f 44 00 00 55 89 f2 89 fe bf 05 00 00 00 48 89 e5 48 8b 4d 08 e8 ba fe ff ff <5d> c3 0f 1f 84 00 00 00 00 00 55 48 89 f2 48 89 fe bf 07 00 00 00
> RSP: 0018:ffffc900053877d8 EFLAGS: 00000297 ORIG_RAX: ffffffffffffff13
> RAX: 0000000000000002 RBX: 584279fc973b765a RCX: ffffffff83b71a81
> RDX: 00000000ffffff75 RSI: 0000000000000000 RDI: 0000000000000005
> RBP: ffffc900053877d8 R08: ffff888041a265c0 R09: 0000000000000092
> R10: ffffed1015d0707b R11: ffff8880ae8383db R12: ffff88809eb56398
> R13: 000000003ab2c4e4 R14: 1b0d4377a72d08f5 R15: 00000000ffffff75
>  mpihelp_submul_1+0x161/0x1a0 lib/mpi/generic_mpih-mul3.c:45

+lib/mpi maintainers

I wonder if this can also be triggered by remote actors (tls, wifi, usb, etc).

>  mpihelp_divrem+0x1ce/0x1360 lib/mpi/mpih-div.c:209
>  mpi_powm+0xffb/0x1d20 lib/mpi/mpi-pow.c:205
>  _compute_val crypto/dh.c:39 [inline]
>  dh_compute_value+0x373/0x610 crypto/dh.c:178
>  crypto_kpp_generate_public_key include/crypto/kpp.h:315 [inline]
>  __keyctl_dh_compute+0x9ae/0x1470 security/keys/dh.c:367
>  keyctl_dh_compute+0xcf/0x12d security/keys/dh.c:422
>  __do_sys_keyctl security/keys/keyctl.c:1818 [inline]
>  __se_sys_keyctl security/keys/keyctl.c:1714 [inline]
>  __x64_sys_keyctl+0x159/0x470 security/keys/keyctl.c:1714
>  do_syscall_64+0xfa/0x790 arch/x86/entry/common.c:294
>  entry_SYSCALL_64_after_hwframe+0x49/0xbe
> RIP: 0033:0x45c479
> Code: ad b6 fb ff c3 66 2e 0f 1f 84 00 00 00 00 00 66 90 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 0f 83 7b b6 fb ff c3 66 2e 0f 1f 84 00 00 00 00
> RSP: 002b:00007f872a51fc78 EFLAGS: 00000246 ORIG_RAX: 00000000000000fa
> RAX: ffffffffffffffda RBX: 00007f872a5206d4 RCX: 000000000045c479
> RDX: 0000000020002700 RSI: 0000000020000400 RDI: 0000000000000017
> RBP: 000000000076bfc0 R08: 0000000000000000 R09: 0000000000000000
> R10: 00000000ffffff84 R11: 0000000000000246 R12: 00000000ffffffff
> R13: 00000000000006fa R14: 00000000004c9883 R15: 000000000076bfcc
>
>
> ---
> This bug is generated by a bot. It may contain errors.
> See https://goo.gl/tpsmEJ for more information about syzbot.
> syzbot engineers can be reached at syzkaller@googlegroups.com.
>
> syzbot will keep track of this bug report. See:
> https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
>
> --
> You received this message because you are subscribed to the Google Groups "syzkaller-bugs" group.
> To unsubscribe from this group and stop receiving emails from it, send an email to syzkaller-bugs+unsubscribe@googlegroups.com.
> To view this discussion on the web visit https://groups.google.com/d/msgid/syzkaller-bugs/000000000000dd909105a002ebe6%40google.com.
