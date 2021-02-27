Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.7 required=3.0 tests=BAYES_00,FROM_LOCAL_HEX,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 46BF0C433DB
	for <linux-crypto@archiver.kernel.org>; Sat, 27 Feb 2021 23:39:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 074A164E28
	for <linux-crypto@archiver.kernel.org>; Sat, 27 Feb 2021 23:39:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230090AbhB0Xiz (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 27 Feb 2021 18:38:55 -0500
Received: from mail-io1-f72.google.com ([209.85.166.72]:54760 "EHLO
        mail-io1-f72.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230040AbhB0Xiz (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 27 Feb 2021 18:38:55 -0500
Received: by mail-io1-f72.google.com with SMTP id w26so10063941iow.21
        for <linux-crypto@vger.kernel.org>; Sat, 27 Feb 2021 15:38:39 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=Zl4y18V2kGpk2rxwQFCYfIWCUoTSTuHRsWuuxIxETdI=;
        b=UTNwUXftTbKy1RW2w3QPAAQWSIMFuxtrsEKBaAmbQWXGigMp0zTwv9wA7SaATq7KMi
         mw1/x9PQgbfxzz7KLvZtNlEq/EiYJULk+p/Rp0hhfH6yJx27bBQLZCFdbJrKwQhLL4CC
         IqAkq25pFQWf3nmt0GabTjZNhuDMBNh4hqULmnJs3UqMxo1dKDvHLgLlRyUhCn2aWCZE
         isAAXUDiwNB+cafeZQyQSGa1yzMhKoO1C8yCqOFyPyANokd5SCUZQgaam8+XpjCWM4nS
         250axUHZmg8vdMdsZZwYVwbANit8XBoqdy0i3cr5lqmsaevkvapAQKfKgY4tgJwT3Dp9
         /9Bg==
X-Gm-Message-State: AOAM530WVX4S0SFR/OGpNZPmkHO9o8AyX2nObRaMxGQ6gBhVbdClSwIE
        WPKzbvigIeQhns+LRmhhDkGSUXSnd8j4VcW0OeyjAAVUbR2I
X-Google-Smtp-Source: ABdhPJwldLZXUzL7FQr3CnbXt6BXy5SWmWMF2vqQnKq6VSdhDtWCxsYbosx0PukrTTieaSLtxKkUXNUsWJ2FZU/CD+YX+RHtAElT
MIME-Version: 1.0
X-Received: by 2002:a05:6638:d8a:: with SMTP id l10mr9311439jaj.2.1614469094346;
 Sat, 27 Feb 2021 15:38:14 -0800 (PST)
Date:   Sat, 27 Feb 2021 15:38:14 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000de949705bc59e0f6@google.com>
Subject: general protection fault in crypto_destroy_tfm
From:   syzbot <syzbot+12cf5fbfdeba210a89dd@syzkaller.appspotmail.com>
To:     davem@davemloft.net, herbert@gondor.apana.org.au,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    29c395c7 Merge tag 'x86-entry-2021-02-24' of git://git.ker..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=15246466d00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=c581c545cb4ffac7
dashboard link: https://syzkaller.appspot.com/bug?extid=12cf5fbfdeba210a89dd
compiler:       Debian clang version 11.0.1-2

Unfortunately, I don't have any reproducer for this issue yet.

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+12cf5fbfdeba210a89dd@syzkaller.appspotmail.com

general protection fault, probably for non-canonical address 0xdffffc0000000002: 0000 [#1] PREEMPT SMP KASAN
KASAN: null-ptr-deref in range [0x0000000000000010-0x0000000000000017]
CPU: 0 PID: 12596 Comm: syz-executor.2 Not tainted 5.11.0-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
RIP: 0010:crypto_destroy_tfm+0x3b/0x260 crypto/api.c:568
Code: 48 89 fb e8 c7 d7 db fd 48 85 db 0f 84 0c 02 00 00 48 89 1c 24 49 bc 00 00 00 00 00 fc ff df 4c 8d 7d 10 4c 89 fb 48 c1 eb 03 <42> 80 3c 23 00 74 08 4c 89 ff e8 76 ff 1f fe 48 8b 45 10 48 89 44
RSP: 0018:ffffc90001aff798 EFLAGS: 00010203
RAX: ffffffff839ca5e9 RBX: 0000000000000002 RCX: 0000000000040000
RDX: ffffc9000dd37000 RSI: 000000000000aeb0 RDI: 000000000000aeb1
RBP: 0000000000000006 R08: ffffffff839ca4e5 R09: fffffbfff1f28ab5
R10: fffffbfff1f28ab5 R11: 0000000000000000 R12: dffffc0000000000
R13: ffff888012f78000 R14: ffff888012f78080 R15: 0000000000000016
FS:  00007fe6e40b8700(0000) GS:ffff8880b9c00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00000000014a53ad CR3: 0000000029fb0000 CR4: 00000000001506f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 crypto_free_aead include/crypto/aead.h:191 [inline]
 llsec_key_alloc net/mac802154/llsec.c:156 [inline]
 mac802154_llsec_key_add+0x930/0xe50 net/mac802154/llsec.c:249
 ieee802154_add_llsec_key+0x61/0x80 net/mac802154/cfg.c:338
 rdev_add_llsec_key net/ieee802154/rdev-ops.h:260 [inline]
 nl802154_add_llsec_key+0x4ca/0x7b0 net/ieee802154/nl802154.c:1584
 genl_family_rcv_msg_doit net/netlink/genetlink.c:739 [inline]
 genl_family_rcv_msg net/netlink/genetlink.c:783 [inline]
 genl_rcv_msg+0xe4e/0x1280 net/netlink/genetlink.c:800
 netlink_rcv_skb+0x190/0x3a0 net/netlink/af_netlink.c:2502
 genl_rcv+0x24/0x40 net/netlink/genetlink.c:811
 netlink_unicast_kernel net/netlink/af_netlink.c:1312 [inline]
 netlink_unicast+0x786/0x940 net/netlink/af_netlink.c:1338
 netlink_sendmsg+0x9ae/0xd50 net/netlink/af_netlink.c:1927
 sock_sendmsg_nosec net/socket.c:654 [inline]
 sock_sendmsg net/socket.c:674 [inline]
 ____sys_sendmsg+0x519/0x800 net/socket.c:2350
 ___sys_sendmsg net/socket.c:2404 [inline]
 __sys_sendmsg+0x2bf/0x370 net/socket.c:2437
 do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
 entry_SYSCALL_64_after_hwframe+0x44/0xae
RIP: 0033:0x465ef9
Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 bc ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007fe6e40b8188 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
RAX: ffffffffffffffda RBX: 000000000056c008 RCX: 0000000000465ef9
RDX: 0000000000000000 RSI: 00000000200000c0 RDI: 0000000000000004
RBP: 00000000004bcd1c R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 000000000056c008
R13: 00007fffc1f33d2f R14: 00007fe6e40b8300 R15: 0000000000022000
Modules linked in:
---[ end trace c6264ccb84eba4a4 ]---
RIP: 0010:crypto_destroy_tfm+0x3b/0x260 crypto/api.c:568
Code: 48 89 fb e8 c7 d7 db fd 48 85 db 0f 84 0c 02 00 00 48 89 1c 24 49 bc 00 00 00 00 00 fc ff df 4c 8d 7d 10 4c 89 fb 48 c1 eb 03 <42> 80 3c 23 00 74 08 4c 89 ff e8 76 ff 1f fe 48 8b 45 10 48 89 44
RSP: 0018:ffffc90001aff798 EFLAGS: 00010203
RAX: ffffffff839ca5e9 RBX: 0000000000000002 RCX: 0000000000040000
RDX: ffffc9000dd37000 RSI: 000000000000aeb0 RDI: 000000000000aeb1
RBP: 0000000000000006 R08: ffffffff839ca4e5 R09: fffffbfff1f28ab5
R10: fffffbfff1f28ab5 R11: 0000000000000000 R12: dffffc0000000000
R13: ffff888012f78000 R14: ffff888012f78080 R15: 0000000000000016
FS:  00007fe6e40b8700(0000) GS:ffff8880b9d00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000001b2d228000 CR3: 0000000029fb0000 CR4: 00000000001506e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
