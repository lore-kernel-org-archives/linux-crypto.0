Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4C769EB64DA
	for <linux-crypto@archiver.kernel.org>; Fri, 14 Jul 2023 12:33:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235811AbjGNMdz (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 14 Jul 2023 08:33:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235423AbjGNMdo (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 14 Jul 2023 08:33:44 -0400
Received: from mail-oi1-f208.google.com (mail-oi1-f208.google.com [209.85.167.208])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 299AA1FC8
        for <linux-crypto@vger.kernel.org>; Fri, 14 Jul 2023 05:33:43 -0700 (PDT)
Received: by mail-oi1-f208.google.com with SMTP id 5614622812f47-39ecef7a101so2917255b6e.2
        for <linux-crypto@vger.kernel.org>; Fri, 14 Jul 2023 05:33:43 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689338022; x=1691930022;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=a/PtvzxIas2zR1ya8bd5qiSh+Ju/22GKnM05TIFi9sA=;
        b=dP5ofHoV/oLR4B9NmEactf0FV5oIXg9SRPOWrYdYKZAH8JyI5mG2dyUu59fXpkXSLu
         loCZeOaPZXyM9V8w004tKts/VJsm2H6uTC/fj9P+Dz9cN9jxbiBbonJFi9zG86COEk5E
         1qIVqEkF3MVGb0AEFmDjatxrOlxvlkvdgsOISIhufbLplHYfcwzKB61bPRwP/90Uj70S
         lIrnEjMTNGR/lYRo5ywRUQiFRYF6QP/Gocpw1rpuMArd5rbk0N+l0siNVucIxYywRixL
         o/Z/bXkhPSBDoUVcp/Ln7RL47zr39AD+7J1HsRrc0927YbKAg9XOCMXGhJGNfjJx0XUP
         73xw==
X-Gm-Message-State: ABy/qLbONzN+QjRQJ34Pu1DIQbdIaChhazJfVyzr/XKJrd+RWcPVMivz
        wQk7FgzCbE9km3wu3TVpx3qfVfTC8qI6+n2vrx+0wPlEOYMa
X-Google-Smtp-Source: APBJJlHLvOcL6iCTX34qlHFrOnRO9iN4WebS97Ae10RYVI9fSHmlaDKYPARf+F/In8VOIyTdLvssnN3HESdSnB4MQK77WeWf+/Ij
MIME-Version: 1.0
X-Received: by 2002:a05:6808:e82:b0:3a4:1e93:8988 with SMTP id
 k2-20020a0568080e8200b003a41e938988mr6542129oil.10.1689338022584; Fri, 14 Jul
 2023 05:33:42 -0700 (PDT)
Date:   Fri, 14 Jul 2023 05:33:42 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000bde775060071a8d7@google.com>
Subject: [syzbot] [crypto?] KMSAN: uninit-value in af_alg_free_resources
From:   syzbot <syzbot+cba21d50095623218389@syzkaller.appspotmail.com>
To:     davem@davemloft.net, herbert@gondor.apana.org.au,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    3f01e9fed845 Merge tag 'linux-watchdog-6.5-rc2' of git://w..
git tree:       upstream
console+strace: https://syzkaller.appspot.com/x/log.txt?x=14bac16aa80000
kernel config:  https://syzkaller.appspot.com/x/.config?x=1542573e31cfbec5
dashboard link: https://syzkaller.appspot.com/bug?extid=cba21d50095623218389
compiler:       Debian clang version 15.0.7, GNU ld (GNU Binutils for Debian) 2.35.2
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=15dd215aa80000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=14530318a80000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/4f212a7e36fe/disk-3f01e9fe.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/de6b12daf908/vmlinux-3f01e9fe.xz
kernel image: https://storage.googleapis.com/syzbot-assets/2c1992ff2aaa/bzImage-3f01e9fe.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+cba21d50095623218389@syzkaller.appspotmail.com

=====================================================
BUG: KMSAN: uninit-value in af_alg_free_sg crypto/af_alg.c:545 [inline]
BUG: KMSAN: uninit-value in af_alg_free_areq_sgls crypto/af_alg.c:778 [inline]
BUG: KMSAN: uninit-value in af_alg_free_resources+0x3d1/0xf60 crypto/af_alg.c:1117
 af_alg_free_sg crypto/af_alg.c:545 [inline]
 af_alg_free_areq_sgls crypto/af_alg.c:778 [inline]
 af_alg_free_resources+0x3d1/0xf60 crypto/af_alg.c:1117
 _skcipher_recvmsg crypto/algif_skcipher.c:144 [inline]
 skcipher_recvmsg+0x6a0/0x1a20 crypto/algif_skcipher.c:157
 sock_recvmsg_nosec net/socket.c:1020 [inline]
 sock_recvmsg net/socket.c:1041 [inline]
 __sys_recvfrom+0x505/0x810 net/socket.c:2186
 __do_sys_recvfrom net/socket.c:2204 [inline]
 __se_sys_recvfrom net/socket.c:2200 [inline]
 __x64_sys_recvfrom+0x126/0x1d0 net/socket.c:2200
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x41/0xc0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x63/0xcd

Uninit was created at:
 slab_post_alloc_hook+0x12f/0xb70 mm/slab.h:767
 slab_alloc_node mm/slub.c:3470 [inline]
 __kmem_cache_alloc_node+0x536/0x8d0 mm/slub.c:3509
 __do_kmalloc_node mm/slab_common.c:984 [inline]
 __kmalloc+0x121/0x3c0 mm/slab_common.c:998
 kmalloc include/linux/slab.h:586 [inline]
 sock_kmalloc+0x128/0x1c0 net/core/sock.c:2683
 af_alg_alloc_areq+0x41/0x2a0 crypto/af_alg.c:1188
 _skcipher_recvmsg crypto/algif_skcipher.c:71 [inline]
 skcipher_recvmsg+0x514/0x1a20 crypto/algif_skcipher.c:157
 sock_recvmsg_nosec net/socket.c:1020 [inline]
 sock_recvmsg net/socket.c:1041 [inline]
 __sys_recvfrom+0x505/0x810 net/socket.c:2186
 __do_sys_recvfrom net/socket.c:2204 [inline]
 __se_sys_recvfrom net/socket.c:2200 [inline]
 __x64_sys_recvfrom+0x126/0x1d0 net/socket.c:2200
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x41/0xc0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x63/0xcd

CPU: 0 PID: 5031 Comm: syz-executor370 Not tainted 6.5.0-rc1-syzkaller-00006-g3f01e9fed845 #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 07/03/2023
=====================================================


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.

If the bug is already fixed, let syzbot know by replying with:
#syz fix: exact-commit-title

If you want syzbot to run the reproducer, reply with:
#syz test: git://repo/address.git branch-or-commit-hash
If you attach or paste a git patch, syzbot will apply it before testing.

If you want to change bug's subsystems, reply with:
#syz set subsystems: new-subsystem
(See the list of subsystem names on the web dashboard)

If the bug is a duplicate of another bug, reply with:
#syz dup: exact-subject-of-another-report

If you want to undo deduplication, reply with:
#syz undup
