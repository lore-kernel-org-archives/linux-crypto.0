Return-Path: <SRS0=WWUc=4V=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 01F97C3F2CD
	for <linux-crypto@archiver.kernel.org>; Wed,  4 Mar 2020 08:58:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D438E20870
	for <linux-crypto@archiver.kernel.org>; Wed,  4 Mar 2020 08:58:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727176AbgCDI6a (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 4 Mar 2020 03:58:30 -0500
Received: from hua.moonlit-rail.com ([45.79.167.250]:40400 "EHLO
        hua.moonlit-rail.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726860AbgCDI6a (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 4 Mar 2020 03:58:30 -0500
X-Greylist: delayed 1087 seconds by postgrey-1.27 at vger.kernel.org; Wed, 04 Mar 2020 03:58:29 EST
Received: from 209-6-248-230.s2276.c3-0.wrx-ubr1.sbo-wrx.ma.cable.rcncustomer.com ([209.6.248.230] helo=boston.moonlit-rail.com)
        by hua.moonlit-rail.com with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.93)
        (envelope-from <linux-1993@moonlit-rail.com>)
        id 1j9PZl-00062L-Pi; Wed, 04 Mar 2020 03:40:21 -0500
Received: from springdale.moonlit-rail.com ([192.168.71.35])
        by boston.moonlit-rail.com with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.93)
        (envelope-from <linux-1993@moonlit-rail.com>)
        id 1j9PZk-00057S-CC; Wed, 04 Mar 2020 03:40:20 -0500
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
References: <000000000000dd909105a002ebe6@google.com>
 <CACT4Y+ZyhwEsuGK9aJZ=4vXJ_AfHqFn6n5d58H_5E_-o9qHRWA@mail.gmail.com>
From:   Kris Karas <linux-1993@moonlit-rail.com>
Message-ID: <96b956f4-62cb-83e6-38c2-ca698a862282@moonlit-rail.com>
Date:   Wed, 4 Mar 2020 03:40:20 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <CACT4Y+ZyhwEsuGK9aJZ=4vXJ_AfHqFn6n5d58H_5E_-o9qHRWA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Resending this to all the original CCs per suggestion of Dmitry.
I'm not a member of linux-crypto, no idea if it will bounce; in any 
case, the OOPS I saw does not appear to be crypto related.

Dmitry Vyukov wrote:
> syzbot wrote:
>> Call Trace:
>>   <IRQ>
>>   __dump_stack lib/dump_stack.c:77 [inline]
>>   dump_stack+0x197/0x210 lib/dump_stack.c:118
>>   nmi_cpu_backtrace.cold+0x70/0xb2 lib/nmi_backtrace.c:101
>>   nmi_trigger_cpumask_backtrace+0x23b/0x28b lib/nmi_backtrace.c:62
>>   arch_trigger_cpumask_backtrace+0x14/0x20 
>> arch/x86/kernel/apic/hw_nmi.c:38
>>   trigger_single_cpu_backtrace include/linux/nmi.h:164 [inline]
>>   rcu_dump_cpu_stacks+0x183/0x1cf kernel/rcu/tree_stall.h:254
>>   print_cpu_stall kernel/rcu/tree_stall.h:475 [inline]
>>   check_cpu_stall kernel/rcu/tree_stall.h:549 [inline]
>>   rcu_pending kernel/rcu/tree.c:3030 [inline]
>>   rcu_sched_clock_irq.cold+0x51a/0xc37 kernel/rcu/tree.c:2276
>>   update_process_times+0x2d/0x70 kernel/time/timer.c:1726
>>   tick_sched_handle+0xa2/0x190 kernel/time/tick-sched.c:171
>>   tick_sched_timer+0x53/0x140 kernel/time/tick-sched.c:1314
>>   __run_hrtimer kernel/time/hrtimer.c:1517 [inline]
>>   __hrtimer_run_queues+0x364/0xe40 kernel/time/hrtimer.c:1579
>>   hrtimer_interrupt+0x314/0x770 kernel/time/hrtimer.c:1641
>>   local_apic_timer_interrupt arch/x86/kernel/apic/apic.c:1119 [inline]
>>   smp_apic_timer_interrupt+0x160/0x610 arch/x86/kernel/apic/apic.c:1144
>>   apic_timer_interrupt+0xf/0x20 arch/x86/entry/entry_64.S:829
>>   </IRQ>
>>
> +lib/mpi maintainers
>
> I wonder if this can also be triggered by remote actors (tls, wifi, 
> usb, etc).
>

This looks somewhat similar to an OOPS + rcu stall I reported earlier in 
reply to Greg KH's announcement of 5.5.7:

     rcu: INFO: rcu_sched self-detected stall on CPU
     rcu:    14-....: (20999 ticks this GP) 
idle=216/1/0x4000000000000002 softirq=454/454 fqs=5250
             (t=21004 jiffies g=-755 q=1327)
     NMI backtrace for cpu 14
     CPU: 14 PID: 520 Comm: pidof Tainted: G      D           5.5.7 #1
     Hardware name: To Be Filled By O.E.M. To Be Filled By O.E.M./X470 
Taichi, BIOS P3.50 07/18/2019
     Call Trace:
      <IRQ>
      dump_stack+0x50/0x70
      nmi_cpu_backtrace.cold+0x14/0x53
      ? lapic_can_unplug_cpu.cold+0x44/0x44
      nmi_trigger_cpumask_backtrace+0x7b/0x88
      rcu_dump_cpu_stacks+0x7b/0xa9
      rcu_sched_clock_irq.cold+0x152/0x39b
      update_process_times+0x1f/0x50
      tick_sched_timer+0x40/0x90
      ? tick_sched_do_timer+0x50/0x50
      __hrtimer_run_queues+0xdd/0x180
      hrtimer_interrupt+0x108/0x230
      smp_apic_timer_interrupt+0x53/0xa0
      apic_timer_interrupt+0xf/0x20
      </IRQ>

I don't have a reproducer for it, either.  It showed up in 5.5.7 (but 
might be from earlier as it reproduces so infrequently).

Kris


