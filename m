Return-Path: <SRS0=EmbF=5Y=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 42A2CC2D0EA
	for <linux-crypto@archiver.kernel.org>; Wed,  8 Apr 2020 15:18:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0EE5D206F5
	for <linux-crypto@archiver.kernel.org>; Wed,  8 Apr 2020 15:18:27 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Po8uKwKe"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728040AbgDHPS0 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 8 Apr 2020 11:18:26 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:44252 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728360AbgDHPSZ (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 8 Apr 2020 11:18:25 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1586359104;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=/ihK2X8/8hKS+Dwwu485A0c8mY5IW2uiYdm2HC3B6+Y=;
        b=Po8uKwKerfH2k0V29MEpcuPD9PzMHxp58+RTTd/PD5iYHoj3peiLJzoXXVM9wpMkYCwAeo
        1Tm8XQl0tMJououjGU7sV/Ilcj27MYgphoM+6dy/opFRmpX7E+x8lCMFVo09V41DXjP0xw
        sMvs4c/ZnEfA0GCXHpqGsOmIsM+MiK4=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-200-Z_PN5Qk3OqCZGGBvxmMqVA-1; Wed, 08 Apr 2020 11:18:22 -0400
X-MC-Unique: Z_PN5Qk3OqCZGGBvxmMqVA-1
Received: by mail-wr1-f71.google.com with SMTP id o10so4257219wrj.7
        for <linux-crypto@vger.kernel.org>; Wed, 08 Apr 2020 08:18:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=/ihK2X8/8hKS+Dwwu485A0c8mY5IW2uiYdm2HC3B6+Y=;
        b=dsAnAkl3XD5Ojq+IibZvYeQSAp0FbwRfQEb963Mvf7zfNJP3U38p8j4C3dxDCof0bP
         8eAZe2KLziUHMJYmYN13WitDnRatIpnMO2NpZo7fCk+2Bybrg+ZJL83LjZKTs9QRbZAr
         CLt8bLU7nG0ycAuqnOzs4ONfpENe5GTOPImUG2M9mLV55B2/Kf/MjQZa2GV+yl5Gr7AT
         Sd6sk5Gs0CDFtAiXfXMgDSQaESD+x2PBn24XsihHajRakPptP2Ar7rY8lEUJp5qDxAd9
         RTnUc01cIrBIX2nGSlHere0MJZe3zghKtmUj6Lx0SuYRdR9T9QxeixLgvvdBQSoUB6Rf
         E0pg==
X-Gm-Message-State: AGi0PuacnqWQhC5YI+TnJYqUcyHf14CTD4YCq/gSm1dgFTbQw/t81mXX
        o0fPVM6sRflvnOj2/8hpOF2iyyTEwkKNYFDewZq4df080gp/9QHU7znQeZzOTMumqsJeLveRdIU
        bD6ghkklpn3qgzTUvnLwpTnNC
X-Received: by 2002:a7b:cf27:: with SMTP id m7mr5209498wmg.58.1586359100701;
        Wed, 08 Apr 2020 08:18:20 -0700 (PDT)
X-Google-Smtp-Source: APiQypKUH0Y1rBm9wmvsjZ4/pRfa3T9aubTTViUTWLqlNKYb/3CJkRoSl+Ti6P0oQAD2Pj/rm3IfXA==
X-Received: by 2002:a7b:cf27:: with SMTP id m7mr5209469wmg.58.1586359100254;
        Wed, 08 Apr 2020 08:18:20 -0700 (PDT)
Received: from xz-x1 ([2607:9880:19c0:32::3])
        by smtp.gmail.com with ESMTPSA id d133sm4292915wmc.27.2020.04.08.08.18.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Apr 2020 08:18:19 -0700 (PDT)
Date:   Wed, 8 Apr 2020 11:18:15 -0400
From:   Peter Xu <peterx@redhat.com>
To:     Hillf Danton <hdanton@sina.com>
Cc:     syzbot <syzbot+3be1a33f04dc782e9fd5@syzkaller.appspotmail.com>,
        akpm@linux-foundation.org, bgeffon@google.com, davem@davemloft.net,
        herbert@gondor.apana.org.au, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com,
        torvalds@linux-foundation.org, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: WARNING in af_alg_make_sg
Message-ID: <20200408151815.GG66033@xz-x1>
References: <000000000000f2bc9505a2c2b808@google.com>
 <20200408095849.15236-1-hdanton@sina.com>
 <20200408151213.GE66033@xz-x1>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20200408151213.GE66033@xz-x1>
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, Apr 08, 2020 at 11:12:13AM -0400, Peter Xu wrote:
> On Wed, Apr 08, 2020 at 05:58:48PM +0800, Hillf Danton wrote:
> > 
> > On Wed, 08 Apr 2020 00:48:13 -0700
> > > syzbot found the following crash on:
> > > 
> > > HEAD commit:    763dede1 Merge tag 'for-linus-5.7-rc1' of git://git.kernel..
> > > git tree:       upstream
> > > console output: https://syzkaller.appspot.com/x/log.txt?x=12b919c7e00000
> > > kernel config:  https://syzkaller.appspot.com/x/.config?x=12205d036cec317f
> > > dashboard link: https://syzkaller.appspot.com/bug?extid=3be1a33f04dc782e9fd5
> > > compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
> > > syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=142f3b8fe00000
> > > C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=159bd23fe00000
> > > 
> > > The bug was bisected to:
> > > 
> > > commit 4426e945df588f2878affddf88a51259200f7e29
> > > Author: Peter Xu <peterx@redhat.com>
> > > Date:   Thu Apr 2 04:08:49 2020 +0000
> > > 
> > >     mm/gup: allow VM_FAULT_RETRY for multiple times
> > > 
> > > bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=1408ea9fe00000
> > > final crash:    https://syzkaller.appspot.com/x/report.txt?x=1608ea9fe00000
> > > console output: https://syzkaller.appspot.com/x/log.txt?x=1208ea9fe00000
> > > 
> > > IMPORTANT: if you fix the bug, please add the following tag to the commit:
> > > Reported-by: syzbot+3be1a33f04dc782e9fd5@syzkaller.appspotmail.com
> > > Fixes: 4426e945df58 ("mm/gup: allow VM_FAULT_RETRY for multiple times")
> > > 
> > > ------------[ cut here ]------------
> > > WARNING: CPU: 1 PID: 7094 at crypto/af_alg.c:404 af_alg_make_sg+0x399/0x400 crypto/af_alg.c:404
> > > Kernel panic - not syncing: panic_on_warn set ...
> > > CPU: 1 PID: 7094 Comm: syz-executor037 Not tainted 5.6.0-syzkaller #0
> > > Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
> > > Call Trace:
> > >  __dump_stack lib/dump_stack.c:77 [inline]
> > >  dump_stack+0x188/0x20d lib/dump_stack.c:118
> > >  panic+0x2e3/0x75c kernel/panic.c:221
> > >  __warn.cold+0x2f/0x35 kernel/panic.c:582
> > >  report_bug+0x27b/0x2f0 lib/bug.c:195
> > >  fixup_bug arch/x86/kernel/traps.c:175 [inline]
> > >  fixup_bug arch/x86/kernel/traps.c:170 [inline]
> > >  do_error_trap+0x12b/0x220 arch/x86/kernel/traps.c:267
> > >  do_invalid_op+0x32/0x40 arch/x86/kernel/traps.c:286
> > >  invalid_op+0x23/0x30 arch/x86/entry/entry_64.S:1027
> > > RIP: 0010:af_alg_make_sg+0x399/0x400 crypto/af_alg.c:404
> > > Code: 5c 24 2b 31 ff 89 de e8 c5 b9 f8 fd 84 db 74 0e e8 8c b8 f8 fd 48 8b 04 24 48 89 44 24 70 e8 7e b8 f8 fd 0f 0b e8 77 b8 f8 fd <0f> 0b c7 44 24 4c ea ff ff ff e9 4b ff ff ff 48 89 df e8 40 6e 36
> > > RSP: 0018:ffffc900018779a0 EFLAGS: 00010293
> > > RAX: ffff8880a16b65c0 RBX: ffff8880a4141220 RCX: ffffffff837a763d
> > > RDX: 0000000000000000 RSI: ffffffff837a78f9 RDI: 0000000000000005
> > > RBP: 000000001fef2254 R08: ffff8880a16b65c0 R09: ffffed10142d6cb9
> > > R10: ffff8880a16b65c7 R11: ffffed10142d6cb8 R12: 0000000000000000
> > > R13: dffffc0000000000 R14: 0000000000000000 R15: dffffc0000000000
> > >  hash_sendmsg+0x45c/0xad0 crypto/algif_hash.c:94
> > >  sock_sendmsg_nosec net/socket.c:652 [inline]
> > >  sock_sendmsg+0xcf/0x120 net/socket.c:672
> > >  ____sys_sendmsg+0x6bf/0x7e0 net/socket.c:2362
> > >  ___sys_sendmsg+0x100/0x170 net/socket.c:2416
> > >  __sys_sendmsg+0xec/0x1b0 net/socket.c:2449
> > >  do_syscall_64+0xf6/0x7d0 arch/x86/entry/common.c:295
> > >  entry_SYSCALL_64_after_hwframe+0x49/0xb3
> > 
> > Make gup feed back correct error code in case of bailout.
> > 
> > --- a/mm/gup.c
> > +++ b/mm/gup.c
> > @@ -1325,8 +1325,11 @@ retry:
> >  		 * start trying again otherwise it can loop forever.
> >  		 */
> >  
> > -		if (fatal_signal_pending(current))
> > +		if (fatal_signal_pending(current)) {
> > +			if (!pages_done)
> > +				pages_done = -EINTR;
> >  			break;
> > +		}
> >  
> >  		*locked = 1;
> >  		down_read(&mm->mmap_sem);
> > 
> 
> CC Thomas too.
> 
> Sorry for all these mess...
> 
> Frankly speaking I didn't notice get_user_pages_fast() forbids
> returning zero while __get_user_pages() allowed it...  Ideally I think
> the gup callers should check against ret>0 to know exactly how many
> valid pages we've got, but it's not an excuse good enough...
> 
> Hillf, would you mind kick the syzbot directly next time when post the
> fix?  I'll make bold to do that for you this time, Thanks!

I got one extra "#"... Doing it again...

#syz test: https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git master

8<--------------------------------------------------------------------
From 380003a56efc125565143c91ee6cefd7b3eba869 Mon Sep 17 00:00:00 2001
From: Hillf Danton <hdanton@sina.com>
Date: Wed, 8 Apr 2020 11:01:25 -0400
Subject: [PATCH] mm/gup: Let __get_user_pages_locked() return -EINTR for fatal
 signal

__get_user_pages_locked() will return 0 instead of -EINTR after commit
4426e945df588 which added extra code to allow gup detect fatal signal
faster.  Restore that behavior.

CC: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Hillf Danton <hdanton@sina.com>
[peterx: write commit message]
Signed-off-by: Peter Xu <peterx@redhat.com>
---
 mm/gup.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/mm/gup.c b/mm/gup.c
index afce0bc47e70..6076df8e04a4 100644
--- a/mm/gup.c
+++ b/mm/gup.c
@@ -1326,8 +1326,11 @@ static __always_inline long __get_user_pages_locked(struct task_struct *tsk,
 		 * start trying again otherwise it can loop forever.
 		 */
 
-		if (fatal_signal_pending(current))
+		if (fatal_signal_pending(current)) {
+			if (!pages_done)
+				pages_done = -EINTR;
 			break;
+		}
 
 		ret = down_read_killable(&mm->mmap_sem);
 		if (ret) {
-- 
2.24.1

-- 
Peter Xu

