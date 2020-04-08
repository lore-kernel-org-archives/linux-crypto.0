Return-Path: <SRS0=EmbF=5Y=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.4 required=3.0 tests=FROM_LOCAL_HEX,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B4937C2BA1B
	for <linux-crypto@archiver.kernel.org>; Wed,  8 Apr 2020 07:48:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 96C5E2074F
	for <linux-crypto@archiver.kernel.org>; Wed,  8 Apr 2020 07:48:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726652AbgDHHsP (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 8 Apr 2020 03:48:15 -0400
Received: from mail-il1-f197.google.com ([209.85.166.197]:37161 "EHLO
        mail-il1-f197.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726366AbgDHHsP (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 8 Apr 2020 03:48:15 -0400
Received: by mail-il1-f197.google.com with SMTP id z89so5968611ilk.4
        for <linux-crypto@vger.kernel.org>; Wed, 08 Apr 2020 00:48:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=CGxHHWD1n3LkBxz2Gb3ke3O4d2pEApLZAEdHel6vwXM=;
        b=fSD2llC1i26AuIpolV9g5UXR96ULrkoxYAUAi7Y9PYS3xMNAmsRNsGKpS1UmMJcy1e
         otUbD4Cj4FYL+0tfv9uoLKLI1dRcnRr2koD42pPSnZ4OCSIjkh/a1XwJr55jtsxin76X
         /tC+gh7AuriZby+guaTpVowdABCn8wNHCwnDMghii817Udr3JWMY16zYmvZPHxhdlVIc
         ZWcEIevs6zLHHgU5P3mNVlrRdEqtzAOx0cwyBmM4YfN3y2u+9Aj2nBmoqAMUsmcERJMA
         Di1DftuKyO80MoY14ISJNnEK2GrJNaEUhuVb4PG3npq+/eU09jM5wHzf3ePcCwQ4rwKO
         /U2A==
X-Gm-Message-State: AGi0PuY5F6STHFxeswVtYonRY+xtMJp9t3MnmUX6S/YuK4F1uqKdzudK
        zn4vhxLdbpB/id6IWLf9VElYjowpXbHzG3swbt8KDffY8okr
X-Google-Smtp-Source: APiQypISrfHjq2lbhi3NLHt0P0DqizOwunS4hKOYik7JU3Ql3OMr0otRPsi0xCqyk4eUr3SWdZZ/fsxw8iR71gIqgVZ1yZr+clMW
MIME-Version: 1.0
X-Received: by 2002:a5d:87c6:: with SMTP id q6mr5717612ios.163.1586332093822;
 Wed, 08 Apr 2020 00:48:13 -0700 (PDT)
Date:   Wed, 08 Apr 2020 00:48:13 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000f2bc9505a2c2b808@google.com>
Subject: WARNING in af_alg_make_sg
From:   syzbot <syzbot+3be1a33f04dc782e9fd5@syzkaller.appspotmail.com>
To:     akpm@linux-foundation.org, bgeffon@google.com, davem@davemloft.net,
        herbert@gondor.apana.org.au, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, peterx@redhat.com,
        syzkaller-bugs@googlegroups.com, torvalds@linux-foundation.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hello,

syzbot found the following crash on:

HEAD commit:    763dede1 Merge tag 'for-linus-5.7-rc1' of git://git.kernel..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=12b919c7e00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=12205d036cec317f
dashboard link: https://syzkaller.appspot.com/bug?extid=3be1a33f04dc782e9fd5
compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=142f3b8fe00000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=159bd23fe00000

The bug was bisected to:

commit 4426e945df588f2878affddf88a51259200f7e29
Author: Peter Xu <peterx@redhat.com>
Date:   Thu Apr 2 04:08:49 2020 +0000

    mm/gup: allow VM_FAULT_RETRY for multiple times

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=1408ea9fe00000
final crash:    https://syzkaller.appspot.com/x/report.txt?x=1608ea9fe00000
console output: https://syzkaller.appspot.com/x/log.txt?x=1208ea9fe00000

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+3be1a33f04dc782e9fd5@syzkaller.appspotmail.com
Fixes: 4426e945df58 ("mm/gup: allow VM_FAULT_RETRY for multiple times")

------------[ cut here ]------------
WARNING: CPU: 1 PID: 7094 at crypto/af_alg.c:404 af_alg_make_sg+0x399/0x400 crypto/af_alg.c:404
Kernel panic - not syncing: panic_on_warn set ...
CPU: 1 PID: 7094 Comm: syz-executor037 Not tainted 5.6.0-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 __dump_stack lib/dump_stack.c:77 [inline]
 dump_stack+0x188/0x20d lib/dump_stack.c:118
 panic+0x2e3/0x75c kernel/panic.c:221
 __warn.cold+0x2f/0x35 kernel/panic.c:582
 report_bug+0x27b/0x2f0 lib/bug.c:195
 fixup_bug arch/x86/kernel/traps.c:175 [inline]
 fixup_bug arch/x86/kernel/traps.c:170 [inline]
 do_error_trap+0x12b/0x220 arch/x86/kernel/traps.c:267
 do_invalid_op+0x32/0x40 arch/x86/kernel/traps.c:286
 invalid_op+0x23/0x30 arch/x86/entry/entry_64.S:1027
RIP: 0010:af_alg_make_sg+0x399/0x400 crypto/af_alg.c:404
Code: 5c 24 2b 31 ff 89 de e8 c5 b9 f8 fd 84 db 74 0e e8 8c b8 f8 fd 48 8b 04 24 48 89 44 24 70 e8 7e b8 f8 fd 0f 0b e8 77 b8 f8 fd <0f> 0b c7 44 24 4c ea ff ff ff e9 4b ff ff ff 48 89 df e8 40 6e 36
RSP: 0018:ffffc900018779a0 EFLAGS: 00010293
RAX: ffff8880a16b65c0 RBX: ffff8880a4141220 RCX: ffffffff837a763d
RDX: 0000000000000000 RSI: ffffffff837a78f9 RDI: 0000000000000005
RBP: 000000001fef2254 R08: ffff8880a16b65c0 R09: ffffed10142d6cb9
R10: ffff8880a16b65c7 R11: ffffed10142d6cb8 R12: 0000000000000000
R13: dffffc0000000000 R14: 0000000000000000 R15: dffffc0000000000
 hash_sendmsg+0x45c/0xad0 crypto/algif_hash.c:94
 sock_sendmsg_nosec net/socket.c:652 [inline]
 sock_sendmsg+0xcf/0x120 net/socket.c:672
 ____sys_sendmsg+0x6bf/0x7e0 net/socket.c:2362
 ___sys_sendmsg+0x100/0x170 net/socket.c:2416
 __sys_sendmsg+0xec/0x1b0 net/socket.c:2449
 do_syscall_64+0xf6/0x7d0 arch/x86/entry/common.c:295
 entry_SYSCALL_64_after_hwframe+0x49/0xb3
RIP: 0033:0x446999
Code: e8 0c e8 ff ff 48 83 c4 18 c3 0f 1f 80 00 00 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 0f 83 5b 07 fc ff c3 66 2e 0f 1f 84 00 00 00 00
RSP: 002b:00007f1427fb4d98 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
RAX: ffffffffffffffda RBX: 00000000006dbc28 RCX: 0000000000446999
RDX: 0000000000000000 RSI: 00000000200002c0 RDI: 0000000000000005
RBP: 00000000006dbc20 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 00000000006dbc2c
R13: 0000000000000000 R14: 0000000000000000 R15: 0000000068736168
Kernel Offset: disabled
Rebooting in 86400 seconds..


---
This bug is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this bug report. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
For information about bisection process see: https://goo.gl/tpsmEJ#bisection
syzbot can test patches for this bug, for details see:
https://goo.gl/tpsmEJ#testing-patches
