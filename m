Return-Path: <SRS0=G1bP=6P=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.4 required=3.0 tests=FROM_LOCAL_HEX,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C6DBEC47253
	for <linux-crypto@archiver.kernel.org>; Fri,  1 May 2020 17:01:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A422724954
	for <linux-crypto@archiver.kernel.org>; Fri,  1 May 2020 17:01:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729210AbgEARBQ (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 1 May 2020 13:01:16 -0400
Received: from mail-io1-f71.google.com ([209.85.166.71]:48265 "EHLO
        mail-io1-f71.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728841AbgEARBP (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 1 May 2020 13:01:15 -0400
Received: by mail-io1-f71.google.com with SMTP id i15so5413283iog.15
        for <linux-crypto@vger.kernel.org>; Fri, 01 May 2020 10:01:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=RXQpc62kSGkieGeA+LlsoP9mjY9J70bhJpsTt05TsFw=;
        b=doxOME8/uykyGRhtH/xUJuEAs06A3tEHtA2bUwuAq3xh+Lb5H+rIL4MQ0vfVdGdXDS
         9cD5AT+7wLsWeZPzbLQoRJkUqwtdy0DL/RfGi21ypebV/8qoWfpi2QtNP5XjYEdvDlXI
         G2ULCBVdW2Z/uoNcLKEMVg5kx1syjiwIJs0y8A5GRJp8VJvpZ47irhK+IzbeQCNeorZE
         ssraQJQu2+jyTqwLANWsr2u/ei5Yu9CeEgEfIUitSMz6Qu2DNgvq5ShrtNdJR0nJN4Hr
         a+XWfmhXscaYYl3Y+LFSakBU5flvziNs+nXpmQcQc04eyQeQDPptkIRHvep84CyZShLD
         7FfA==
X-Gm-Message-State: AGi0Pubfz9O1R/as3W/fwFP4ZChbSSzyQ6wiFTesjJc1vIMSxth37rfb
        TAOl/I4wvvgQMqXAc1Qmy0MZcYXipdmrrAB3fXcc1fx22Nlt
X-Google-Smtp-Source: APiQypIzNJ+x5Y3uKtb3IfQ5XLDifFgOYtn+MHEdrYUkg6wI9sVWvi8qk8nt/Rn8e/zCPbjhAlkKxNeJQfSsm2DWMef9rc/17379
MIME-Version: 1.0
X-Received: by 2002:a5d:9c88:: with SMTP id p8mr4639755iop.200.1588352474474;
 Fri, 01 May 2020 10:01:14 -0700 (PDT)
Date:   Fri, 01 May 2020 10:01:14 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000004f67705a4992160@google.com>
Subject: WARNING: refcount bug in crypto_mod_get
From:   syzbot <syzbot+afb77bdbaca0cda9e991@syzkaller.appspotmail.com>
To:     ardb@kernel.org, davem@davemloft.net, herbert@gondor.apana.org.au,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        syzkaller-bugs@googlegroups.com, t-kristo@ti.com
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hello,

syzbot found the following crash on:

HEAD commit:    6a8b55ed Linux 5.7-rc3
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=11b91564100000
kernel config:  https://syzkaller.appspot.com/x/.config?x=5b075813ec8b93cd
dashboard link: https://syzkaller.appspot.com/bug?extid=afb77bdbaca0cda9e991
compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=12f8067fe00000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=17fd8028100000

The bug was bisected to:

commit b877ad1a135c802d4529a72aa82faf46ef5db097
Author: Ard Biesheuvel <ardb@kernel.org>
Date:   Tue Nov 5 14:01:04 2019 +0000

    crypto: omap-aes-gcm - check length of assocdata in RFC4106 mode

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=147c2208100000
final crash:    https://syzkaller.appspot.com/x/report.txt?x=167c2208100000
console output: https://syzkaller.appspot.com/x/log.txt?x=127c2208100000

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+afb77bdbaca0cda9e991@syzkaller.appspotmail.com
Fixes: b877ad1a135c ("crypto: omap-aes-gcm - check length of assocdata in RFC4106 mode")

------------[ cut here ]------------
refcount_t: addition on 0; use-after-free.
WARNING: CPU: 0 PID: 7775 at lib/refcount.c:25 refcount_warn_saturate+0x169/0x1e0 lib/refcount.c:25
Kernel panic - not syncing: panic_on_warn set ...
CPU: 0 PID: 7775 Comm: syz-executor692 Not tainted 5.7.0-rc3-syzkaller #0
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
RIP: 0010:refcount_warn_saturate+0x169/0x1e0 lib/refcount.c:25
Code: 06 31 ff 89 de e8 87 b9 dc fd 84 db 0f 85 36 ff ff ff e8 4a b8 dc fd 48 c7 c7 a0 5b 72 88 c6 05 b2 1c ee 06 01 e8 4f f3 ad fd <0f> 0b e9 17 ff ff ff e8 2b b8 dc fd 0f b6 1d 97 1c ee 06 31 ff 89
RSP: 0018:ffffc90002797bf8 EFLAGS: 00010286
RAX: 0000000000000000 RBX: 0000000000000000 RCX: 0000000000000000
RDX: 0000000000000000 RSI: ffffffff815ce171 RDI: fffff520004f2f71
RBP: 0000000000000002 R08: ffff88809d9e6400 R09: ffffed1015cc66a9
R10: ffff8880ae633547 R11: ffffed1015cc66a8 R12: ffff8880a403a048
R13: ffff88809df99d00 R14: ffffed1013bf33a5 R15: ffff888099925048
 refcount_add include/linux/refcount.h:204 [inline]
 refcount_inc include/linux/refcount.h:241 [inline]
 crypto_alg_get crypto/internal.h:87 [inline]
 crypto_mod_get+0xc6/0xf0 crypto/api.c:37
 crypto_spawn_alg.isra.0+0xa8/0x110 crypto/algapi.c:723
 crypto_spawn_tfm2+0x19/0xb0 crypto/algapi.c:763
 crypto_spawn_aead include/crypto/internal/aead.h:102 [inline]
 pcrypt_aead_init_tfm+0x144/0x273 crypto/pcrypt.c:182
 crypto_aead_init_tfm+0x138/0x1a0 crypto/aead.c:140
 crypto_create_tfm+0xd5/0x2f0 crypto/api.c:454
 crypto_alloc_tfm+0x100/0x340 crypto/api.c:526
 aead_bind+0x69/0x170 crypto/algif_aead.c:483
 alg_bind+0x260/0x530 crypto/af_alg.c:182
 __sys_bind+0x20e/0x250 net/socket.c:1662
 __do_sys_bind net/socket.c:1673 [inline]
 __se_sys_bind net/socket.c:1671 [inline]
 __x64_sys_bind+0x6f/0xb0 net/socket.c:1671
 do_syscall_64+0xf6/0x7d0 arch/x86/entry/common.c:295
 entry_SYSCALL_64_after_hwframe+0x49/0xb3
RIP: 0033:0x441359
Code: e8 ac e8 ff ff 48 83 c4 18 c3 0f 1f 80 00 00 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 0f 83 eb 08 fc ff c3 66 2e 0f 1f 84 00 00 00 00
RSP: 002b:00007ffd04b593e8 EFLAGS: 00000246 ORIG_RAX: 0000000000000031
RAX: ffffffffffffffda RBX: 00000000004a2378 RCX: 0000000000441359
RDX: 0000000000000058 RSI: 0000000020000040 RDI: 0000000000000003
RBP: 000000000000e5c5 R08: 00000000004002c8 R09: 00000000004002c8
R10: 0000000000000004 R11: 0000000000000246 R12: 00000000004020d0
R13: 0000000000402160 R14: 0000000000000000 R15: 0000000000000000
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
