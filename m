Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 22AD0C7EE43
	for <linux-crypto@archiver.kernel.org>; Mon, 12 Jun 2023 09:59:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235669AbjFLJ7W (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 12 Jun 2023 05:59:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235338AbjFLJ5N (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 12 Jun 2023 05:57:13 -0400
Received: from mail-io1-f80.google.com (mail-io1-f80.google.com [209.85.166.80])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 09A231FE1
        for <linux-crypto@vger.kernel.org>; Mon, 12 Jun 2023 02:42:00 -0700 (PDT)
Received: by mail-io1-f80.google.com with SMTP id ca18e2360f4ac-77accdaa0e0so403672939f.0
        for <linux-crypto@vger.kernel.org>; Mon, 12 Jun 2023 02:42:00 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686562920; x=1689154920;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Uo0nUcpTxKIUFZRtuxSXLMwWUjL4QLmVMNpxBKJbpl8=;
        b=A8Vv2PxsY8KVgngQeX66NB2rHzgIW7X/8Cd/LaGC5b+R9Su73Anv/SClVonZqxNi4Y
         tJW9usR+lSRLlIywxl00sKD7zcNRnlRWJy1PThwgCLFrZSV5YqziWl65O3a+BIZiKs+q
         KWpaHf6iQqlicK0T4tM1+/thlQQoVNRmwf5B8DZVv1jUx2/Yx5FnE1X+s8neKm7F7q7Z
         +WGe0Ykm5joiU7nEl32IuJqewF20STtEQH2yWSWVjLIRNQhisw1/L3b3Lcq7LkbbqqHx
         8XFz8NegzIfyLdrogCZkeQ07NHF9d9xVDiOFu41vnwO1yGo/7U9GRvb766znuYxKOdMZ
         WN4w==
X-Gm-Message-State: AC+VfDyZvObJGfNoY8oFIgD7vVdhkuMDFrZeU5snOmIYJR8axEuYwqKF
        OynHmoHebFmMM6zxYRm5bKxzqR+CZ+hdv8ZE44B2iHrwKAVb
X-Google-Smtp-Source: ACHHUZ6S9Ha+uQ0SRlihV8okGGviuxmZhhGYvYUz77tBwWm20TJkvLk0jwFQvaMil72wIlS2xDvkcHgw65K25qp80JrK/hSDu5wK
MIME-Version: 1.0
X-Received: by 2002:a02:9581:0:b0:40f:cf8b:7c74 with SMTP id
 b1-20020a029581000000b0040fcf8b7c74mr3413248jai.0.1686562920218; Mon, 12 Jun
 2023 02:42:00 -0700 (PDT)
Date:   Mon, 12 Jun 2023 02:42:00 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000c047db05fdeb8790@google.com>
Subject: [syzbot] [crypto?] general protection fault in crypto_shash_final
From:   syzbot <syzbot+14234ccf6d0ef629ec1a@syzkaller.appspotmail.com>
To:     davem@davemloft.net, dhowells@redhat.com,
        herbert@gondor.apana.org.au, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        pabeni@redhat.com, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    37ff78e977f1 mlxsw: spectrum_nve_vxlan: Fix unsupported fl..
git tree:       net-next
console+strace: https://syzkaller.appspot.com/x/log.txt?x=15132add280000
kernel config:  https://syzkaller.appspot.com/x/.config?x=526f919910d4a671
dashboard link: https://syzkaller.appspot.com/bug?extid=14234ccf6d0ef629ec1a
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=1009d065280000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=16fdc72b280000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/41e829152d3c/disk-37ff78e9.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/a594b97acb02/vmlinux-37ff78e9.xz
kernel image: https://storage.googleapis.com/syzbot-assets/b41140b53372/bzImage-37ff78e9.xz

The issue was bisected to:

commit c662b043cdca89bf0f03fc37251000ac69a3a548
Author: David Howells <dhowells@redhat.com>
Date:   Tue Jun 6 13:08:56 2023 +0000

    crypto: af_alg/hash: Support MSG_SPLICE_PAGES

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=1426f12d280000
final oops:     https://syzkaller.appspot.com/x/report.txt?x=1626f12d280000
console output: https://syzkaller.appspot.com/x/log.txt?x=1226f12d280000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+14234ccf6d0ef629ec1a@syzkaller.appspotmail.com
Fixes: c662b043cdca ("crypto: af_alg/hash: Support MSG_SPLICE_PAGES")

general protection fault, probably for non-canonical address 0xdffffc0000000004: 0000 [#1] PREEMPT SMP KASAN
KASAN: null-ptr-deref in range [0x0000000000000020-0x0000000000000027]
CPU: 1 PID: 5006 Comm: kworker/1:3 Not tainted 6.4.0-rc5-syzkaller-00859-g37ff78e977f1 #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 05/25/2023
Workqueue: cryptd cryptd_queue_worker
RIP: 0010:crypto_shash_alg include/crypto/hash.h:827 [inline]
RIP: 0010:crypto_shash_final+0x49/0x120 crypto/shash.c:171
Code: fc ff df 48 c1 ea 03 80 3c 02 00 0f 85 d5 00 00 00 48 b8 00 00 00 00 00 fc ff df 48 8b 5d 00 48 8d 7b 20 48 89 fa 48 c1 ea 03 <80> 3c 02 00 0f 85 a8 00 00 00 48 b8 00 00 00 00 00 fc ff df 48 8b
RSP: 0018:ffffc90003a3fca8 EFLAGS: 00010202
RAX: dffffc0000000000 RBX: 0000000000000000 RCX: 0000000000000000
RDX: 0000000000000004 RSI: ffffffff83df1715 RDI: 0000000000000020
RBP: ffff88801b756b08 R08: 0000000000000005 R09: 00000000ffffff8d
R10: 0000000000000000 R11: 1ffffffff21842f8 R12: ffff888029311988
R13: ffff88801b756b08 R14: ffff888014eaa600 R15: ffff8880b993bd80
FS:  0000000000000000(0000) GS:ffff8880b9900000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f6c11c57440 CR3: 00000000221e4000 CR4: 00000000003506e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <TASK>
 cryptd_hash_final+0xea/0x140 crypto/cryptd.c:580
 crypto_request_complete include/crypto/algapi.h:272 [inline]
 cryptd_queue_worker+0x130/0x1d0 crypto/cryptd.c:181
 process_one_work+0x99a/0x15e0 kernel/workqueue.c:2405
 worker_thread+0x67d/0x10c0 kernel/workqueue.c:2552
 kthread+0x344/0x440 kernel/kthread.c:379
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:308
 </TASK>
Modules linked in:
---[ end trace 0000000000000000 ]---
RIP: 0010:crypto_shash_alg include/crypto/hash.h:827 [inline]
RIP: 0010:crypto_shash_final+0x49/0x120 crypto/shash.c:171
Code: fc ff df 48 c1 ea 03 80 3c 02 00 0f 85 d5 00 00 00 48 b8 00 00 00 00 00 fc ff df 48 8b 5d 00 48 8d 7b 20 48 89 fa 48 c1 ea 03 <80> 3c 02 00 0f 85 a8 00 00 00 48 b8 00 00 00 00 00 fc ff df 48 8b
RSP: 0018:ffffc90003a3fca8 EFLAGS: 00010202
RAX: dffffc0000000000 RBX: 0000000000000000 RCX: 0000000000000000
RDX: 0000000000000004 RSI: ffffffff83df1715 RDI: 0000000000000020
RBP: ffff88801b756b08 R08: 0000000000000005 R09: 00000000ffffff8d
R10: 0000000000000000 R11: 1ffffffff21842f8 R12: ffff888029311988
R13: ffff88801b756b08 R14: ffff888014eaa600 R15: ffff8880b993bd80
FS:  0000000000000000(0000) GS:ffff8880b9900000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f6c11c57440 CR3: 00000000221e4000 CR4: 00000000003506e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
----------------
Code disassembly (best guess), 3 bytes skipped:
   0:	48 c1 ea 03          	shr    $0x3,%rdx
   4:	80 3c 02 00          	cmpb   $0x0,(%rdx,%rax,1)
   8:	0f 85 d5 00 00 00    	jne    0xe3
   e:	48 b8 00 00 00 00 00 	movabs $0xdffffc0000000000,%rax
  15:	fc ff df
  18:	48 8b 5d 00          	mov    0x0(%rbp),%rbx
  1c:	48 8d 7b 20          	lea    0x20(%rbx),%rdi
  20:	48 89 fa             	mov    %rdi,%rdx
  23:	48 c1 ea 03          	shr    $0x3,%rdx
* 27:	80 3c 02 00          	cmpb   $0x0,(%rdx,%rax,1) <-- trapping instruction
  2b:	0f 85 a8 00 00 00    	jne    0xd9
  31:	48 b8 00 00 00 00 00 	movabs $0xdffffc0000000000,%rax
  38:	fc ff df
  3b:	48                   	rex.W
  3c:	8b                   	.byte 0x8b


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
For information about bisection process see: https://goo.gl/tpsmEJ#bisection

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
