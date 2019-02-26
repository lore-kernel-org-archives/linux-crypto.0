Return-Path: <SRS0=wbmp=RB=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.6 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_MUTT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7DF37C43381
	for <linux-crypto@archiver.kernel.org>; Tue, 26 Feb 2019 07:33:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3CD7020C01
	for <linux-crypto@archiver.kernel.org>; Tue, 26 Feb 2019 07:33:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1551166437;
	bh=56Et3mT0Ho3R7n8skecEtZ8NsjH9TYJY3q7UlE11rHw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=PqUb6Vj9ggjHRP7H8qfoU4TyS7xW8dnRQT/7HJwKDtkGCbvjvdFKse2d5u7sF55li
	 q2YxbZW+n5XfJMvRtgEOl4klzZqD09R5uQjBu66iYncSQLV2lQs0eeAG5Tyt7amkjh
	 PLCiikuerPRyENM4xGcgannP0Nur5Hf1EF3HTefc=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725901AbfBZHd4 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 26 Feb 2019 02:33:56 -0500
Received: from mail.kernel.org ([198.145.29.99]:56706 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726690AbfBZHd4 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 26 Feb 2019 02:33:56 -0500
Received: from sol.localdomain (c-107-3-167-184.hsd1.ca.comcast.net [107.3.167.184])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C150C20661;
        Tue, 26 Feb 2019 07:33:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1551166434;
        bh=56Et3mT0Ho3R7n8skecEtZ8NsjH9TYJY3q7UlE11rHw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=uQKjLeGmz/QCwZedSICvPxx1rgc9HfBm5IfJkIDoCryf4+l9VzGRXtk3AyqNvx1xp
         7qdqeqMbGiQrQDNCoTLnvQQa2ASQRAMvMMcdbYG6UwX2EEACGLwMh47hcH/XxIOlT4
         O7yD4buxy4p7Kk7htjdujicqCwn6ayU60ELFvJ+c=
Date:   Mon, 25 Feb 2019 23:33:52 -0800
From:   Eric Biggers <ebiggers@kernel.org>
To:     Dmitry Vyukov <dvyukov@google.com>
Cc:     Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        syzbot <syzbot+c5048caf67d09ee24549@syzkaller.appspotmail.com>,
        borisp@mellanox.com, aviadye@mellanox.com, davejwatson@fb.com,
        Borislav Petkov <bp@alien8.de>,
        "David S. Miller" <davem@davemloft.net>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" 
        <linux-crypto@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@redhat.com>,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        the arch/x86 maintainers <x86@kernel.org>
Subject: Re: general protection fault in gcmaes_crypt_by_sg
Message-ID: <20190226073351.GD676@sol.localdomain>
References: <000000000000b3b10305778f05f5@google.com>
 <CAKv+Gu_-7AWaQhLdc4KLwowUZjKV0zy8spWnFELEyk-Bya+77A@mail.gmail.com>
 <CACT4Y+YqC91oC_==O780gNmOeJmyOn9QR0VRxNtFNJrhp=t7Vg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACT4Y+YqC91oC_==O780gNmOeJmyOn9QR0VRxNtFNJrhp=t7Vg@mail.gmail.com>
User-Agent: Mutt/1.11.3 (2019-02-01)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, Feb 20, 2019 at 05:03:38PM +0100, 'Dmitry Vyukov' via syzkaller-bugs wrote:
> On Mon, Oct 8, 2018 at 12:06 PM Ard Biesheuvel
> <ard.biesheuvel@linaro.org> wrote:
> >
> > (add the TLS maintainers)
> >
> > On 6 October 2018 at 15:04, syzbot
> > <syzbot+c5048caf67d09ee24549@syzkaller.appspotmail.com> wrote:
> > > Hello,
> > >
> > > syzbot found the following crash on:
> > >
> > > HEAD commit:    12ffaa1197f5 Add linux-next specific files for 20181005
> > > git tree:       linux-next
> > > console output: https://syzkaller.appspot.com/x/log.txt?x=16cb7806400000
> > > kernel config:  https://syzkaller.appspot.com/x/.config?x=d6b058a7232046f
> > > dashboard link: https://syzkaller.appspot.com/bug?extid=c5048caf67d09ee24549
> > > compiler:       gcc (GCC) 8.0.1 20180413 (experimental)
> > >
> > > Unfortunately, I don't have any reproducer for this crash yet.
> > >
> > > IMPORTANT: if you fix the bug, please add the following tag to the commit:
> > > Reported-by: syzbot+c5048caf67d09ee24549@syzkaller.appspotmail.com
> 
> 
> This last happened 4 months ago. Probably fixed by something?
> Candidate for closure as obsolete.
> 
> > > @ : renamed from ip6gre0
> > > kasan: CONFIG_KASAN_INLINE enabled
> > > kasan: GPF could be caused by NULL-ptr deref or user memory access
> > > general protection fault: 0000 [#1] PREEMPT SMP KASAN
> > > CPU: 1 PID: 1510 Comm: syz-executor0 Not tainted 4.19.0-rc6-next-20181005+
> > > #88
> > > Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS
> > > Google 01/01/2011
> > > RIP: 0010:scatterwalk_start include/crypto/scatterwalk.h:73 [inline]
> > > RIP: 0010:gcmaes_crypt_by_sg+0x56f/0x2110
> > > arch/x86/crypto/aesni-intel_glue.c:834
> > > Code: c1 e9 03 80 3c 11 00 0f 85 bf 18 00 00 48 8d 78 08 48 89 84 24 50 01
> > > 00 00 48 ba 00 00 00 00 00 fc ff df 48 89 f9 48 c1 e9 03 <0f> b6 14 11 84 d2
> > > 74 09 80 fa 03 0f 8e 6b 15 00 00 44 8b 60 08 48
> > > RSP: 0018:ffff8801852bf120 EFLAGS: 00010202
> > > RAX: 0000000000000000 RBX: ffff88019023c6b0 RCX: 0000000000000001
> > > RDX: dffffc0000000000 RSI: ffffffff8359e06c RDI: 0000000000000008
> > > RBP: ffff8801852bf520 R08: ffff8801850c4300 R09: ffff8801befb0060
> > > R10: ffff8801852bf7b0 R11: ffff8801852bf7db R12: 000000000000000d
> > > R13: 000000000000000d R14: ffff8801852bf238 R15: ffff8801852bf7d0
> > > FS:  00000000025d3940(0000) GS:ffff8801daf00000(0000) knlGS:0000000000000000
> > > CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> > > CR2: 0000001b2d128000 CR3: 00000001cd273000 CR4: 00000000001406e0
> > > DR0: 0000000020000000 DR1: 0000000000000000 DR2: 0000000000000000
> > > DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000600
> > > Call Trace:
> > >  gcmaes_encrypt.constprop.17+0x7d7/0x1190
> > > arch/x86/crypto/aesni-intel_glue.c:929
> > >  generic_gcmaes_encrypt+0x12d/0x186 arch/x86/crypto/aesni-intel_glue.c:1294
> > >  crypto_aead_encrypt include/crypto/aead.h:364 [inline]
> > >  gcmaes_wrapper_encrypt+0x162/0x200 arch/x86/crypto/aesni-intel_glue.c:1127
> > >  crypto_aead_encrypt include/crypto/aead.h:364 [inline]
> > >  tls_do_encryption net/tls/tls_sw.c:534 [inline]
> > >  tls_push_record+0xc12/0x17f0 net/tls/tls_sw.c:583
> > >  tls_sw_push_pending_record+0x22/0x30 net/tls/tls_sw.c:597
> > >  tls_handle_open_record net/tls/tls_main.c:155 [inline]
> > >  tls_sk_proto_close+0x439/0x750 net/tls/tls_main.c:272
> > >  inet_release+0x104/0x1f0 net/ipv4/af_inet.c:428
> > >  inet6_release+0x50/0x70 net/ipv6/af_inet6.c:458
> > >  __sock_release+0xd7/0x250 net/socket.c:580
> > >  sock_close+0x19/0x20 net/socket.c:1142
> > >  __fput+0x3bc/0xa70 fs/file_table.c:279
> > >  ____fput+0x15/0x20 fs/file_table.c:312
> > >  task_work_run+0x1e8/0x2a0 kernel/task_work.c:113
> > >  tracehook_notify_resume include/linux/tracehook.h:188 [inline]
> > >  exit_to_usermode_loop+0x318/0x380 arch/x86/entry/common.c:166
> > >  prepare_exit_to_usermode arch/x86/entry/common.c:197 [inline]
> > >  syscall_return_slowpath arch/x86/entry/common.c:268 [inline]
> > >  do_syscall_64+0x6be/0x820 arch/x86/entry/common.c:293
> > >  entry_SYSCALL_64_after_hwframe+0x49/0xbe
> > > RIP: 0033:0x411051
> > > Code: 75 14 b8 03 00 00 00 0f 05 48 3d 01 f0 ff ff 0f 83 34 19 00 00 c3 48
> > > 83 ec 08 e8 0a fc ff ff 48 89 04 24 b8 03 00 00 00 0f 05 <48> 8b 3c 24 48 89
> > > c2 e8 53 fc ff ff 48 89 d0 48 83 c4 08 48 3d 01
> > > RSP: 002b:00007fff40f9a8d0 EFLAGS: 00000293 ORIG_RAX: 0000000000000003
> > > RAX: 0000000000000000 RBX: 0000000000000004 RCX: 0000000000411051
> > > RDX: 0000001b2da20000 RSI: 0000000000000000 RDI: 0000000000000003
> > > RBP: 0000000000000000 R08: 0000000049ccd1ef R09: 0000000049ccd1f3
> > > R10: 00007fff40f9a800 R11: 0000000000000293 R12: 0000000000000000
> > > R13: 0000000000000001 R14: 000000000000010c R15: 0000000000000000
> > > Modules linked in:
> > > ---[ end trace a8f523110d8ca375 ]---
> > > RIP: 0010:scatterwalk_start include/crypto/scatterwalk.h:73 [inline]
> > > RIP: 0010:gcmaes_crypt_by_sg+0x56f/0x2110
> > > arch/x86/crypto/aesni-intel_glue.c:834
> > > Code: c1 e9 03 80 3c 11 00 0f 85 bf 18 00 00 48 8d 78 08 48 89 84 24 50 01
> > > 00 00 48 ba 00 00 00 00 00 fc ff df 48 89 f9 48 c1 e9 03 <0f> b6 14 11 84 d2
> > > 74 09 80 fa 03 0f 8e 6b 15 00 00 44 8b 60 08 48
> > > RSP: 0018:ffff8801852bf120 EFLAGS: 00010202
> > > RAX: 0000000000000000 RBX: ffff88019023c6b0 RCX: 0000000000000001
> > > RDX: dffffc0000000000 RSI: ffffffff8359e06c RDI: 0000000000000008
> > > RBP: ffff8801852bf520 R08: ffff8801850c4300 R09: ffff8801befb0060
> > > R10: ffff8801852bf7b0 R11: ffff8801852bf7db R12: 000000000000000d
> > > R13: 000000000000000d R14: ffff8801852bf238 R15: ffff8801852bf7d0
> > > FS:  00000000025d3940(0000) GS:ffff8801daf00000(0000) knlGS:0000000000000000
> > > CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> > > CR2: 0000001b2d128000 CR3: 00000001cd273000 CR4: 00000000001406e0
> > > DR0: 0000000020000000 DR1: 0000000000000000 DR2: 0000000000000000
> > > DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000600
> > >
> > >
> > > ---
> > > This bug is generated by a bot. It may contain errors.
> > > See https://goo.gl/tpsmEJ for more information about syzbot.
> > > syzbot engineers can be reached at syzkaller@googlegroups.com.
> > >
> > > syzbot will keep track of this bug report. See:
> > > https://goo.gl/tpsmEJ#bug-status-tracking for how to communicate with
> > > syzbot.
> >
> > --
> > You received this message because you are subscribed to the Google Groups "syzkaller-bugs" group.
> > To unsubscribe from this group and stop receiving emails from it, send an email to syzkaller-bugs+unsubscribe@googlegroups.com.
> > To view this discussion on the web visit https://groups.google.com/d/msgid/syzkaller-bugs/CAKv%2BGu_-7AWaQhLdc4KLwowUZjKV0zy8spWnFELEyk-Bya%2B77A%40mail.gmail.com.
> > For more options, visit https://groups.google.com/d/optout.
> 
> -- 
> You received this message because you are subscribed to the Google Groups "syzkaller-bugs" group.
> To unsubscribe from this group and stop receiving emails from it, send an email to syzkaller-bugs+unsubscribe@googlegroups.com.
> To view this discussion on the web visit https://groups.google.com/d/msgid/syzkaller-bugs/CACT4Y%2BYqC91oC_%3D%3DO780gNmOeJmyOn9QR0VRxNtFNJrhp%3Dt7Vg%40mail.gmail.com.

(As with the other reports of this...)

AFAICS this was fixed by this commit:

	commit d829e9c4112b52f4f00195900fd4c685f61365ab
	Author: Daniel Borkmann <daniel@iogearbox.net>
	Date:   Sat Oct 13 02:45:59 2018 +0200

	    tls: convert to generic sk_msg interface

So telling syzbot:

#syz fix: tls: convert to generic sk_msg interface

The issue was that described in this comment in tls_sw_sendmsg():

                /* Open records defined only if successfully copied, otherwise
                 * we would trim the sg but not reset the open record frags.
                 */
                tls_ctx->pending_open_record_frags = true;

Basically, on sendmsg() to a TLS socket, if the message buffer was partially
unmapped, a TLS record would be marked as pending (and then tried to be sent at
sock_release() time) even though it had actually been discarded.

- Eric
