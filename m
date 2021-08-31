Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.7 required=3.0 tests=BAYES_00,FROM_LOCAL_HEX,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A47B4C432BE
	for <linux-crypto@archiver.kernel.org>; Tue, 31 Aug 2021 03:12:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8485B60FED
	for <linux-crypto@archiver.kernel.org>; Tue, 31 Aug 2021 03:12:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239317AbhHaDNO (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 30 Aug 2021 23:13:14 -0400
Received: from mail-il1-f197.google.com ([209.85.166.197]:47928 "EHLO
        mail-il1-f197.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231776AbhHaDNN (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 30 Aug 2021 23:13:13 -0400
Received: by mail-il1-f197.google.com with SMTP id j17-20020a926e11000000b0022487646515so10373338ilc.14
        for <linux-crypto@vger.kernel.org>; Mon, 30 Aug 2021 20:12:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=Wnwxv4nrK2cqNyAf6GMI8yFt0pARoTgAFkGLh1UOHV8=;
        b=FKSd4HqkQXEVtq8hIXmnqYNvg7goDwv6jZL3w4cysdnvp7FTe5hqXVo9n33o9B9w2M
         a4Ghp2X4SOWIn74Tm03HfOLknCNR5kmeGeHcQovdCtkr6Fm+cQrMyT+WzyUHym7c8egK
         BkuTDIm7/0TGDccxY55nnMIFu8ZfybXchATwpRBHaXC3jla34j2w58MXD/UPJH2M/d+v
         EmB9wz1Ovt4CAa0lJIfC7AytsKNelmZ6kPiBWVKF1OCjLx5nLjCv1RaV4iotEf7He1nr
         FYrMOU8wtrUdYEFk0PRYF/hYP7n1vNlZabi42nk/83UaCBIfs+XA3mwI1nW5nlZAPi1r
         jr1Q==
X-Gm-Message-State: AOAM530Nmq0U1n37jcWnJQzIGU6LtM/e+PUDpn+R+jlrm3a2ESuryCtc
        c/gHX45rLsmNoOXKf+RbufZ7d7Oi2ztXf8BNkLl9ZwSLzBKV
X-Google-Smtp-Source: ABdhPJwT9gGww4epApyBptPm+bzzC8ANmr6Agdrjgi4izPkBgsZEp67AI+9bLHFstC/1fFiPSPDu/63rjiZxYKZJcthico4u8Pkq
MIME-Version: 1.0
X-Received: by 2002:a05:6638:bcf:: with SMTP id g15mr753125jad.1.1630379538994;
 Mon, 30 Aug 2021 20:12:18 -0700 (PDT)
Date:   Mon, 30 Aug 2021 20:12:18 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000455b3805cad25183@google.com>
Subject: [syzbot] BUG: sleeping function called from invalid context in skcipher_walk_virt
From:   syzbot <syzbot+60f2f66b9e9cdeacb84d@syzkaller.appspotmail.com>
To:     davem@davemloft.net, herbert@gondor.apana.org.au,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    73f3af7b4611 Merge branch 'akpm' (patches from Andrew)
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=15d969e1300000
kernel config:  https://syzkaller.appspot.com/x/.config?x=2fd902af77ff1e56
dashboard link: https://syzkaller.appspot.com/bug?extid=60f2f66b9e9cdeacb84d
compiler:       Debian clang version 11.0.1-2, GNU ld (GNU Binutils for Debian) 2.35.1

Unfortunately, I don't have any reproducer for this issue yet.

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+60f2f66b9e9cdeacb84d@syzkaller.appspotmail.com

RBP: 00007f2759f4b1d0 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000001
R13: 00007ffdba342b3f R14: 00007f2759f4b300 R15: 0000000000022000
BUG: sleeping function called from invalid context at crypto/skcipher.c:482
in_atomic(): 1, irqs_disabled(): 0, non_block: 0, pid: 19258, name: syz-executor.3
1 lock held by syz-executor.3/19258:
 #0: ffff88808b055120 (sk_lock-AF_ALG){+.+.}-{0:0}, at: lock_sock include/net/sock.h:1613 [inline]
 #0: ffff88808b055120 (sk_lock-AF_ALG){+.+.}-{0:0}, at: skcipher_recvmsg+0xbb/0xea0 crypto/algif_skcipher.c:155
Preemption disabled at:
[<ffffffff812edc95>] kernel_fpu_begin_mask+0x75/0x4c0 arch/x86/kernel/fpu/core.c:156
CPU: 1 PID: 19258 Comm: syz-executor.3 Not tainted 5.14.0-rc7-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 __dump_stack lib/dump_stack.c:88 [inline]
 dump_stack_lvl+0x1d3/0x29f lib/dump_stack.c:105
 ___might_sleep+0x4e5/0x6b0 kernel/sched/core.c:9134
 skcipher_walk_virt+0x80/0x6c0 crypto/skcipher.c:482
 xts_crypt+0x8ce/0xb70 arch/x86/crypto/aesni-intel_glue.c:908
 _skcipher_recvmsg crypto/algif_skcipher.c:138 [inline]
 skcipher_recvmsg+0xa74/0xea0 crypto/algif_skcipher.c:157
 sock_recvmsg_nosec net/socket.c:943 [inline]
 sock_recvmsg net/socket.c:961 [inline]
 ____sys_recvmsg+0x293/0x5c0 net/socket.c:2611
 ___sys_recvmsg net/socket.c:2653 [inline]
 do_recvmmsg+0x601/0x1560 net/socket.c:2747
 __sys_recvmmsg net/socket.c:2826 [inline]
 __do_sys_recvmmsg net/socket.c:2849 [inline]
 __se_sys_recvmmsg net/socket.c:2842 [inline]
 __x64_sys_recvmmsg+0x17f/0x220 net/socket.c:2842
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x3d/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x44/0xae
RIP: 0033:0x4665e9
Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 bc ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007f2759f4b188 EFLAGS: 00000246 ORIG_RAX: 000000000000012b
RAX: ffffffffffffffda RBX: 000000000056bf80 RCX: 00000000004665e9
RDX: 0000000000000001 RSI: 0000000020008340 RDI: 0000000000000004
RBP: 00007f2759f4b1d0 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000001
R13: 00007ffdba342b3f R14: 00007f2759f4b300 R15: 0000000000022000
------------[ cut here ]------------
WARNING: CPU: 1 PID: 19258 at arch/x86/kernel/fpu/core.c:159 kernel_fpu_begin_mask+0x3fe/0x4c0 arch/x86/kernel/fpu/core.c:159
Modules linked in:
CPU: 1 PID: 19258 Comm: syz-executor.3 Tainted: G        W         5.14.0-rc7-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
RIP: 0010:kernel_fpu_begin_mask+0x3fe/0x4c0 arch/x86/kernel/fpu/core.c:159
Code: 00 00 65 48 8b 04 25 28 00 00 00 48 3b 44 24 60 0f 85 b0 00 00 00 48 8d 65 d8 5b 41 5c 41 5d 41 5e 41 5f 5d c3 e8 a2 57 51 00 <0f> 0b e9 3f fd ff ff e8 96 57 51 00 eb a1 e8 8f 57 51 00 db e3 eb
RSP: 0018:ffffc900195a7340 EFLAGS: 00010246
RAX: ffffffff812ee01e RBX: 0000000000000001 RCX: 0000000000040000
RDX: ffffc9000fce5000 RSI: 000000000003ffff RDI: 0000000000040000
RBP: ffffc900195a73f0 R08: ffffffff812edd57 R09: ffffed100702f923
R10: ffffed100702f923 R11: 0000000000000000 R12: dffffc0000000000
R13: 1ffff920032b4e6c R14: 0000000000000002 R15: ffffc900195a74a0
FS:  00007f2759f4b700(0000) GS:ffff8880b9d00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00000000014a53ad CR3: 00000000327a9000 CR4: 00000000001506e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 kernel_fpu_begin arch/x86/include/asm/fpu/api.h:40 [inline]
 xts_crypt+0x8f3/0xb70 arch/x86/crypto/aesni-intel_glue.c:912
 _skcipher_recvmsg crypto/algif_skcipher.c:138 [inline]
 skcipher_recvmsg+0xa74/0xea0 crypto/algif_skcipher.c:157
 sock_recvmsg_nosec net/socket.c:943 [inline]
 sock_recvmsg net/socket.c:961 [inline]
 ____sys_recvmsg+0x293/0x5c0 net/socket.c:2611
 ___sys_recvmsg net/socket.c:2653 [inline]
 do_recvmmsg+0x601/0x1560 net/socket.c:2747
 __sys_recvmmsg net/socket.c:2826 [inline]
 __do_sys_recvmmsg net/socket.c:2849 [inline]
 __se_sys_recvmmsg net/socket.c:2842 [inline]
 __x64_sys_recvmmsg+0x17f/0x220 net/socket.c:2842
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x3d/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x44/0xae
RIP: 0033:0x4665e9
Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 bc ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007f2759f4b188 EFLAGS: 00000246 ORIG_RAX: 000000000000012b
RAX: ffffffffffffffda RBX: 000000000056bf80 RCX: 00000000004665e9
RDX: 0000000000000001 RSI: 0000000020008340 RDI: 0000000000000004
RBP: 00007f2759f4b1d0 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000001
R13: 00007ffdba342b3f R14: 00007f2759f4b300 R15: 0000000000022000


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
