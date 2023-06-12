Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5D7A7C7EE45
	for <linux-crypto@archiver.kernel.org>; Mon, 12 Jun 2023 09:59:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229528AbjFLJ7Y (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 12 Jun 2023 05:59:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37004 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234942AbjFLJ5L (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 12 Jun 2023 05:57:11 -0400
Received: from mail-io1-f78.google.com (mail-io1-f78.google.com [209.85.166.78])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98A2D1BE9
        for <linux-crypto@vger.kernel.org>; Mon, 12 Jun 2023 02:42:00 -0700 (PDT)
Received: by mail-io1-f78.google.com with SMTP id ca18e2360f4ac-77accdaa0e0so403672639f.0
        for <linux-crypto@vger.kernel.org>; Mon, 12 Jun 2023 02:42:00 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686562920; x=1689154920;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=07KNzP3E6i3EPVULFtSRa0Vyl0F6K8FPQdxwSoWudsk=;
        b=X9J6NXCNhosR9GchjWmTycnHPXGVDimJBhYrEosE2CGAz1BBgc1kBGvFYiN0SiciaR
         YO5F5NAaNl/cI5lOnHehd9ezxS8me6U7ZfLhfzsb8JPsMman/QEYRGTwSfuYIe5e528q
         nUqb/6m5ZDqxtDiX/2vp0qT03ghtNlW69q0C//m7P8+kM9hAiWy7lqFW4kQnc+Y5GQBe
         cSi/0nyr9oMt7KD7DnlY16ndgQKBgSPClnUWlenZ9V1IdQGVFhrQi8NmuMK7znp51F5e
         THWB2hhIsH31aBo6HeBsL1qZoJtLKlC7eBnJT2rdha0df3bF9yIxRYqZzFaGOyADdIqa
         oltw==
X-Gm-Message-State: AC+VfDzo+DgVKFCdFzfU+7Z0Vqz/Q3bLOfOPRstwy+gyJxvNbvidR4+m
        ooxTBT9QdF8NdQoH7OL0B/EK58JmnV4hwx+FwcTRTPE9xpjo
X-Google-Smtp-Source: ACHHUZ4Wset5wfbLTe3ritPtC+ON4nHU063N7X4sRf4uEZS8JMKZBYfgUE+nJPVRPe+A/oFwWu+MlciBZ1Dt2No0OoumITHzU0Gs
MIME-Version: 1.0
X-Received: by 2002:a05:6638:110a:b0:420:cdb2:a6cc with SMTP id
 n10-20020a056638110a00b00420cdb2a6ccmr3389707jal.3.1686562919988; Mon, 12 Jun
 2023 02:41:59 -0700 (PDT)
Date:   Mon, 12 Jun 2023 02:41:59 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000bcca3205fdeb87fb@google.com>
Subject: [syzbot] [crypto?] general protection fault in crypto_shash_finup
From:   syzbot <syzbot+4e2e47f32607d0f72d43@syzkaller.appspotmail.com>
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

HEAD commit:    e431e712c836 Merge branch 'sfc-tc-encap-actions-offload'
git tree:       net-next
console+strace: https://syzkaller.appspot.com/x/log.txt?x=17e7771b280000
kernel config:  https://syzkaller.appspot.com/x/.config?x=526f919910d4a671
dashboard link: https://syzkaller.appspot.com/bug?extid=4e2e47f32607d0f72d43
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=12610c75280000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=171cdef1280000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/35e2db144233/disk-e431e712.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/ecf37a1cef2c/vmlinux-e431e712.xz
kernel image: https://storage.googleapis.com/syzbot-assets/a3da92090562/bzImage-e431e712.xz

The issue was bisected to:

commit c662b043cdca89bf0f03fc37251000ac69a3a548
Author: David Howells <dhowells@redhat.com>
Date:   Tue Jun 6 13:08:56 2023 +0000

    crypto: af_alg/hash: Support MSG_SPLICE_PAGES

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=12392407280000
final oops:     https://syzkaller.appspot.com/x/report.txt?x=11392407280000
console output: https://syzkaller.appspot.com/x/log.txt?x=16392407280000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+4e2e47f32607d0f72d43@syzkaller.appspotmail.com
Fixes: c662b043cdca ("crypto: af_alg/hash: Support MSG_SPLICE_PAGES")

general protection fault, probably for non-canonical address 0xdffffc0000000004: 0000 [#1] PREEMPT SMP KASAN
KASAN: null-ptr-deref in range [0x0000000000000020-0x0000000000000027]
CPU: 0 PID: 9 Comm: kworker/0:1 Not tainted 6.4.0-rc5-syzkaller-01107-ge431e712c836 #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 05/25/2023
Workqueue: cryptd cryptd_queue_worker
RIP: 0010:crypto_shash_alg include/crypto/hash.h:827 [inline]
RIP: 0010:crypto_shash_finup+0x53/0x160 crypto/shash.c:198
Code: fc ff df 48 c1 ea 03 80 3c 02 00 0f 85 05 01 00 00 48 b8 00 00 00 00 00 fc ff df 48 8b 5d 00 48 8d 7b 20 48 89 fa 48 c1 ea 03 <80> 3c 02 00 0f 85 d8 00 00 00 48 b8 00 00 00 00 00 fc ff df 4c 8b
RSP: 0018:ffffc900000e7ba0 EFLAGS: 00010202
RAX: dffffc0000000000 RBX: 0000000000000000 RCX: 0000000000000000
RDX: 0000000000000004 RSI: ffffffff83df35bf RDI: 0000000000000020
RBP: ffff888028350b08 R08: 0000000000000005 R09: 0000000000000000
R10: 0000000000000000 R11: 1ffffffff218470c R12: ffff8880123fa1c0
R13: ffff888029582ac8 R14: 0000000000000014 R15: 0000000000000000
FS:  0000000000000000(0000) GS:ffff8880b9800000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f251034e440 CR3: 000000007cc84000 CR4: 00000000003506f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <TASK>
 shash_ahash_finup+0xdf/0x3a0 crypto/shash.c:333
 cryptd_hash_finup+0xce/0x120 crypto/cryptd.c:597
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
RIP: 0010:crypto_shash_finup+0x53/0x160 crypto/shash.c:198
Code: fc ff df 48 c1 ea 03 80 3c 02 00 0f 85 05 01 00 00 48 b8 00 00 00 00 00 fc ff df 48 8b 5d 00 48 8d 7b 20 48 89 fa 48 c1 ea 03 <80> 3c 02 00 0f 85 d8 00 00 00 48 b8 00 00 00 00 00 fc ff df 4c 8b
RSP: 0018:ffffc900000e7ba0 EFLAGS: 00010202
RAX: dffffc0000000000 RBX: 0000000000000000 RCX: 0000000000000000
RDX: 0000000000000004 RSI: ffffffff83df35bf RDI: 0000000000000020
RBP: ffff888028350b08 R08: 0000000000000005 R09: 0000000000000000
R10: 0000000000000000 R11: 1ffffffff218470c R12: ffff8880123fa1c0
R13: ffff888029582ac8 R14: 0000000000000014 R15: 0000000000000000
FS:  0000000000000000(0000) GS:ffff8880b9800000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f251034e440 CR3: 000000002aa8e000 CR4: 00000000003506f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
----------------
Code disassembly (best guess), 3 bytes skipped:
   0:	48 c1 ea 03          	shr    $0x3,%rdx
   4:	80 3c 02 00          	cmpb   $0x0,(%rdx,%rax,1)
   8:	0f 85 05 01 00 00    	jne    0x113
   e:	48 b8 00 00 00 00 00 	movabs $0xdffffc0000000000,%rax
  15:	fc ff df
  18:	48 8b 5d 00          	mov    0x0(%rbp),%rbx
  1c:	48 8d 7b 20          	lea    0x20(%rbx),%rdi
  20:	48 89 fa             	mov    %rdi,%rdx
  23:	48 c1 ea 03          	shr    $0x3,%rdx
* 27:	80 3c 02 00          	cmpb   $0x0,(%rdx,%rax,1) <-- trapping instruction
  2b:	0f 85 d8 00 00 00    	jne    0x109
  31:	48 b8 00 00 00 00 00 	movabs $0xdffffc0000000000,%rax
  38:	fc ff df
  3b:	4c                   	rex.WR
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
