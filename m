Return-Path: <SRS0=EmbF=5Y=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.4 required=3.0 tests=FROM_LOCAL_HEX,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 33555C2BA16
	for <linux-crypto@archiver.kernel.org>; Wed,  8 Apr 2020 15:12:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0CEFA20787
	for <linux-crypto@archiver.kernel.org>; Wed,  8 Apr 2020 15:12:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726754AbgDHPMp (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 8 Apr 2020 11:12:45 -0400
Received: from mail-il1-f198.google.com ([209.85.166.198]:40047 "EHLO
        mail-il1-f198.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729467AbgDHPMl (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 8 Apr 2020 11:12:41 -0400
Received: by mail-il1-f198.google.com with SMTP id d18so1285262ilq.7
        for <linux-crypto@vger.kernel.org>; Wed, 08 Apr 2020 08:12:39 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to:cc;
        bh=B8H7F5N3xhpnu0cuEvuqeHEM1UyehCMDiAQUZ8A44M8=;
        b=ft6VS4lj65ueXAq87YWByHvJIBMslEVfYaT/nsmDeEH8Qzf/yJYGdhH7Y/hM6v8i1v
         ayLWapBuMdu440jwquB7c35CAwZrPKgFeo14DaUtkcQtPu1p67/vM+X0hkgdVMMsjQPp
         YSAVrUd3jjcpNM3+XiCgmcZffBSI4Dflb2PJ7HLX6RTkG1AZlHizpOswaUTNRpXGaee8
         0o2brzDfXHVeNnHeXuU3IExtltFTOdXYKwAOXumY0qn31NHG3dksdle2h357AEZwmTXU
         nxYUDwwGEDXPkyclJghnZcUlC63sKAqELwnMEJ7uLkNGA1TgcRyZEa09tLz1yDyVMRDG
         CJ6g==
X-Gm-Message-State: AGi0PuYxn5Y52Ekm/CpDJzG3R3smF/QalF0MQcLFzI7v+lZNUFxB0Nlw
        EYiikCPwsl3cXrAeBoo1jNk/ebIKFUQokaq5pOdR16oVfYZu
X-Google-Smtp-Source: APiQypIw78JHKjhB+j0Glb7K1dSHJ3rZZKUptkGDO/woVDSlTQLfWodDE84Nn1NCUDR3wOty5ZBVBCo0f+LP7Xw27A0pYv17MwGb
MIME-Version: 1.0
X-Received: by 2002:a92:af8c:: with SMTP id v12mr184656ill.6.1586358758901;
 Wed, 08 Apr 2020 08:12:38 -0700 (PDT)
Date:   Wed, 08 Apr 2020 08:12:38 -0700
In-Reply-To: <20200408151213.GE66033@xz-x1>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000004f8fee05a2c8ee0b@google.com>
Subject: Re: Re: WARNING in af_alg_make_sg
From:   syzbot <syzbot+3be1a33f04dc782e9fd5@syzkaller.appspotmail.com>
To:     Peter Xu <peterx@redhat.com>
Cc:     akpm@linux-foundation.org, bgeffon@google.com, davem@davemloft.net,
        hdanton@sina.com, herbert@gondor.apana.org.au,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        peterx@redhat.com, syzkaller-bugs@googlegroups.com,
        torvalds@linux-foundation.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

> On Wed, Apr 08, 2020 at 05:58:48PM +0800, Hillf Danton wrote:
>> 
>> On Wed, 08 Apr 2020 00:48:13 -0700
>> > syzbot found the following crash on:
>> > 
>> > HEAD commit:    763dede1 Merge tag 'for-linus-5.7-rc1' of git://git.kernel..
>> > git tree:       upstream
>> > console output: https://syzkaller.appspot.com/x/log.txt?x=12b919c7e00000
>> > kernel config:  https://syzkaller.appspot.com/x/.config?x=12205d036cec317f
>> > dashboard link: https://syzkaller.appspot.com/bug?extid=3be1a33f04dc782e9fd5
>> > compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
>> > syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=142f3b8fe00000
>> > C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=159bd23fe00000
>> > 
>> > The bug was bisected to:
>> > 
>> > commit 4426e945df588f2878affddf88a51259200f7e29
>> > Author: Peter Xu <peterx@redhat.com>
>> > Date:   Thu Apr 2 04:08:49 2020 +0000
>> > 
>> >     mm/gup: allow VM_FAULT_RETRY for multiple times
>> > 
>> > bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=1408ea9fe00000
>> > final crash:    https://syzkaller.appspot.com/x/report.txt?x=1608ea9fe00000
>> > console output: https://syzkaller.appspot.com/x/log.txt?x=1208ea9fe00000
>> > 
>> > IMPORTANT: if you fix the bug, please add the following tag to the commit:
>> > Reported-by: syzbot+3be1a33f04dc782e9fd5@syzkaller.appspotmail.com
>> > Fixes: 4426e945df58 ("mm/gup: allow VM_FAULT_RETRY for multiple times")
>> > 
>> > ------------[ cut here ]------------
>> > WARNING: CPU: 1 PID: 7094 at crypto/af_alg.c:404 af_alg_make_sg+0x399/0x400 crypto/af_alg.c:404
>> > Kernel panic - not syncing: panic_on_warn set ...
>> > CPU: 1 PID: 7094 Comm: syz-executor037 Not tainted 5.6.0-syzkaller #0
>> > Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
>> > Call Trace:
>> >  __dump_stack lib/dump_stack.c:77 [inline]
>> >  dump_stack+0x188/0x20d lib/dump_stack.c:118
>> >  panic+0x2e3/0x75c kernel/panic.c:221
>> >  __warn.cold+0x2f/0x35 kernel/panic.c:582
>> >  report_bug+0x27b/0x2f0 lib/bug.c:195
>> >  fixup_bug arch/x86/kernel/traps.c:175 [inline]
>> >  fixup_bug arch/x86/kernel/traps.c:170 [inline]
>> >  do_error_trap+0x12b/0x220 arch/x86/kernel/traps.c:267
>> >  do_invalid_op+0x32/0x40 arch/x86/kernel/traps.c:286
>> >  invalid_op+0x23/0x30 arch/x86/entry/entry_64.S:1027
>> > RIP: 0010:af_alg_make_sg+0x399/0x400 crypto/af_alg.c:404
>> > Code: 5c 24 2b 31 ff 89 de e8 c5 b9 f8 fd 84 db 74 0e e8 8c b8 f8 fd 48 8b 04 24 48 89 44 24 70 e8 7e b8 f8 fd 0f 0b e8 77 b8 f8 fd <0f> 0b c7 44 24 4c ea ff ff ff e9 4b ff ff ff 48 89 df e8 40 6e 36
>> > RSP: 0018:ffffc900018779a0 EFLAGS: 00010293
>> > RAX: ffff8880a16b65c0 RBX: ffff8880a4141220 RCX: ffffffff837a763d
>> > RDX: 0000000000000000 RSI: ffffffff837a78f9 RDI: 0000000000000005
>> > RBP: 000000001fef2254 R08: ffff8880a16b65c0 R09: ffffed10142d6cb9
>> > R10: ffff8880a16b65c7 R11: ffffed10142d6cb8 R12: 0000000000000000
>> > R13: dffffc0000000000 R14: 0000000000000000 R15: dffffc0000000000
>> >  hash_sendmsg+0x45c/0xad0 crypto/algif_hash.c:94
>> >  sock_sendmsg_nosec net/socket.c:652 [inline]
>> >  sock_sendmsg+0xcf/0x120 net/socket.c:672
>> >  ____sys_sendmsg+0x6bf/0x7e0 net/socket.c:2362
>> >  ___sys_sendmsg+0x100/0x170 net/socket.c:2416
>> >  __sys_sendmsg+0xec/0x1b0 net/socket.c:2449
>> >  do_syscall_64+0xf6/0x7d0 arch/x86/entry/common.c:295
>> >  entry_SYSCALL_64_after_hwframe+0x49/0xb3
>> 
>> Make gup feed back correct error code in case of bailout.
>> 
>> --- a/mm/gup.c
>> +++ b/mm/gup.c
>> @@ -1325,8 +1325,11 @@ retry:
>>  		 * start trying again otherwise it can loop forever.
>>  		 */
>>  
>> -		if (fatal_signal_pending(current))
>> +		if (fatal_signal_pending(current)) {
>> +			if (!pages_done)
>> +				pages_done = -EINTR;
>>  			break;
>> +		}
>>  
>>  		*locked = 1;
>>  		down_read(&mm->mmap_sem);
>> 
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
>
> #syz test: #https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git master

"#https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git" does not look like a valid git repo address.

>
> 8<--------------------------------------------------------------------
> From 380003a56efc125565143c91ee6cefd7b3eba869 Mon Sep 17 00:00:00 2001
> From: Hillf Danton <hdanton@sina.com>
> Date: Wed, 8 Apr 2020 11:01:25 -0400
> Subject: [PATCH] mm/gup: Let __get_user_pages_locked() return -EINTR for fatal
>  signal
>
> __get_user_pages_locked() will return 0 instead of -EINTR after commit
> 4426e945df588 which added extra code to allow gup detect fatal signal
> faster.  Restore that behavior.
>
> CC: Thomas Gleixner <tglx@linutronix.de>
> Signed-off-by: Hillf Danton <hdanton@sina.com>
> [peterx: write commit message]
> Signed-off-by: Peter Xu <peterx@redhat.com>
> ---
>  mm/gup.c | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
>
> diff --git a/mm/gup.c b/mm/gup.c
> index afce0bc47e70..6076df8e04a4 100644
> --- a/mm/gup.c
> +++ b/mm/gup.c
> @@ -1326,8 +1326,11 @@ static __always_inline long __get_user_pages_locked(struct task_struct *tsk,
>  		 * start trying again otherwise it can loop forever.
>  		 */
>  
> -		if (fatal_signal_pending(current))
> +		if (fatal_signal_pending(current)) {
> +			if (!pages_done)
> +				pages_done = -EINTR;
>  			break;
> +		}
>  
>  		ret = down_read_killable(&mm->mmap_sem);
>  		if (ret) {
> -- 
> 2.24.1
>
>
> -- 
> Peter Xu
>
