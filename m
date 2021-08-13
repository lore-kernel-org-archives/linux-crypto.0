Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.7 required=3.0 tests=BAYES_00,FROM_LOCAL_HEX,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8889CC432BE
	for <linux-crypto@archiver.kernel.org>; Fri, 13 Aug 2021 10:04:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7127360E09
	for <linux-crypto@archiver.kernel.org>; Fri, 13 Aug 2021 10:04:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239207AbhHMKEk (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 13 Aug 2021 06:04:40 -0400
Received: from mail-io1-f72.google.com ([209.85.166.72]:34464 "EHLO
        mail-io1-f72.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239619AbhHMKDw (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 13 Aug 2021 06:03:52 -0400
Received: by mail-io1-f72.google.com with SMTP id o8-20020a0566021248b029058d0f91164eso5137462iou.1
        for <linux-crypto@vger.kernel.org>; Fri, 13 Aug 2021 03:03:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=PwHnua1MRSkM55cL5lJZc/tqOzaEJb9p+ZlZGQxsT/0=;
        b=iD4e9KTaJJW5HRi9GJSOqJpMUIlbG/Ts0kXcYTcTe/ovZ7Uljxf6QRxZhtH4DZn4Go
         Q0FlrojEsirsaRnZUKA17fEJL/j04MACd14eyudKjLsQIDd1Mai+g/dJtIka4PBp65eS
         QgmdS4QlvM037N+jFlwUrGwXppAA3WuPCst+duZiyYx4H6iyDltrUqPhsncH2QkpKURL
         amnIE9wsTdLOJNNts4FRTzz7lM7CnTWlbaLTK/EPcUqZDWI8cTFqorySeZZQPqF5CPqj
         gY4h6nbF2g4HTCMbivbKTI5KJGfAz9IDhfcOkd0IJoD1hv/MTM5VmVl1us9FOfW4lPzA
         1ldg==
X-Gm-Message-State: AOAM533z9pvgtSqMR8eG7dz8sgV8ShuDarq87fU0srU55HT0rpCJAzIi
        hbw44YSlVrGkNmNxPW6P07L0lkhIw5peRDqbjDKyHGXrN4Js
X-Google-Smtp-Source: ABdhPJxI8Q8KjD/NRrrnotWgA7SBp0CNhrx/fugxw5gwc9SHcW7aPk5G9LIwfX0QYP9TaLLrKkL80/fJWfwkYNEk/8xELY8W2qwr
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:1d89:: with SMTP id h9mr1188392ila.46.1628849006091;
 Fri, 13 Aug 2021 03:03:26 -0700 (PDT)
Date:   Fri, 13 Aug 2021 03:03:26 -0700
In-Reply-To: <00000000000006e7be05bda1c084@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000066a78105c96df6a3@google.com>
Subject: Re: [syzbot] general protection fault in scatterwalk_copychunks (4)
From:   syzbot <syzbot+66e3ea42c4b176748b9c@syzkaller.appspotmail.com>
To:     davem@davemloft.net, herbert@gondor.apana.org.au,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

syzbot has found a reproducer for the following issue on:

HEAD commit:    f8fbb47c6e86 Merge branch 'for-v5.14' of git://git.kernel...
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=11d1a779300000
kernel config:  https://syzkaller.appspot.com/x/.config?x=171d57d5a48c8cad
dashboard link: https://syzkaller.appspot.com/bug?extid=66e3ea42c4b176748b9c
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.1
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=13b8db9e300000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=16c21581300000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+66e3ea42c4b176748b9c@syzkaller.appspotmail.com

general protection fault, probably for non-canonical address 0xdffffc0000000001: 0000 [#1] PREEMPT SMP KASAN
KASAN: null-ptr-deref in range [0x0000000000000008-0x000000000000000f]
CPU: 0 PID: 58 Comm: kworker/u4:3 Not tainted 5.14.0-rc5-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Workqueue: pencrypt_parallel padata_parallel_worker
RIP: 0010:scatterwalk_start include/crypto/scatterwalk.h:68 [inline]
RIP: 0010:scatterwalk_pagedone include/crypto/scatterwalk.h:88 [inline]
RIP: 0010:scatterwalk_pagedone include/crypto/scatterwalk.h:77 [inline]
RIP: 0010:scatterwalk_copychunks+0x4db/0x6a0 crypto/scatterwalk.c:50
Code: ff df 80 3c 02 00 0f 85 b4 01 00 00 49 8d 44 24 08 4d 89 26 48 89 c2 48 89 44 24 18 48 b8 00 00 00 00 00 fc ff df 48 c1 ea 03 <0f> b6 04 02 84 c0 74 08 3c 03 0f 8e 77 01 00 00 48 b8 00 00 00 00
RSP: 0018:ffffc900011d7628 EFLAGS: 00010202
RAX: dffffc0000000000 RBX: 0000000000000000 RCX: 0000000000000000
RDX: 0000000000000001 RSI: ffffffff83d3dc23 RDI: 0000000000000003
RBP: 0000000000000000 R08: 0000000000000000 R09: ffff88801903a69b
R10: ffffffff83d3dbd3 R11: 0000000000086088 R12: 0000000000000000
R13: 0000000000000001 R14: ffffc900011d7888 R15: 0000000000000000
FS:  0000000000000000(0000) GS:ffff8880b9c00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000020000100 CR3: 000000001d355000 CR4: 00000000001506f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 skcipher_next_slow crypto/skcipher.c:278 [inline]
 skcipher_walk_next+0x7af/0x1680 crypto/skcipher.c:363
 skcipher_walk_first+0xf8/0x3c0 crypto/skcipher.c:446
 skcipher_walk_aead_common+0x7a5/0xbc0 crypto/skcipher.c:539
 gcmaes_crypt_by_sg+0x31d/0x890 arch/x86/crypto/aesni-intel_glue.c:658
 gcmaes_encrypt+0xe2/0x230 arch/x86/crypto/aesni-intel_glue.c:722
 generic_gcmaes_encrypt+0x12e/0x190 arch/x86/crypto/aesni-intel_glue.c:1071
 crypto_aead_encrypt+0xaa/0xf0 crypto/aead.c:94
 crypto_aead_encrypt+0xaa/0xf0 crypto/aead.c:94
 pcrypt_aead_enc+0x13/0x70 crypto/pcrypt.c:82
 padata_parallel_worker+0x60/0xb0 kernel/padata.c:157
 process_one_work+0x98d/0x1630 kernel/workqueue.c:2276
 process_scheduled_works kernel/workqueue.c:2338 [inline]
 worker_thread+0x85c/0x11f0 kernel/workqueue.c:2424
 kthread+0x3e5/0x4d0 kernel/kthread.c:319
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:295
Modules linked in:
---[ end trace d7f7427ae496b704 ]---
RIP: 0010:scatterwalk_start include/crypto/scatterwalk.h:68 [inline]
RIP: 0010:scatterwalk_pagedone include/crypto/scatterwalk.h:88 [inline]
RIP: 0010:scatterwalk_pagedone include/crypto/scatterwalk.h:77 [inline]
RIP: 0010:scatterwalk_copychunks+0x4db/0x6a0 crypto/scatterwalk.c:50
Code: ff df 80 3c 02 00 0f 85 b4 01 00 00 49 8d 44 24 08 4d 89 26 48 89 c2 48 89 44 24 18 48 b8 00 00 00 00 00 fc ff df 48 c1 ea 03 <0f> b6 04 02 84 c0 74 08 3c 03 0f 8e 77 01 00 00 48 b8 00 00 00 00
RSP: 0018:ffffc900011d7628 EFLAGS: 00010202
RAX: dffffc0000000000 RBX: 0000000000000000 RCX: 0000000000000000
RDX: 0000000000000001 RSI: ffffffff83d3dc23 RDI: 0000000000000003
RBP: 0000000000000000 R08: 0000000000000000 R09: ffff88801903a69b
R10: ffffffff83d3dbd3 R11: 0000000000086088 R12: 0000000000000000
R13: 0000000000000001 R14: ffffc900011d7888 R15: 0000000000000000
FS:  0000000000000000(0000) GS:ffff8880b9c00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000020000100 CR3: 000000000b68e000 CR4: 00000000001506f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
----------------
Code disassembly (best guess), 1 bytes skipped:
   0:	df 80 3c 02 00 0f    	filds  0xf00023c(%rax)
   6:	85 b4 01 00 00 49 8d 	test   %esi,-0x72b70000(%rcx,%rax,1)
   d:	44 24 08             	rex.R and $0x8,%al
  10:	4d 89 26             	mov    %r12,(%r14)
  13:	48 89 c2             	mov    %rax,%rdx
  16:	48 89 44 24 18       	mov    %rax,0x18(%rsp)
  1b:	48 b8 00 00 00 00 00 	movabs $0xdffffc0000000000,%rax
  22:	fc ff df 
  25:	48 c1 ea 03          	shr    $0x3,%rdx
  29:	0f b6 04 02          	movzbl (%rdx,%rax,1),%eax <-- trapping instruction
  2d:	84 c0                	test   %al,%al
  2f:	74 08                	je     0x39
  31:	3c 03                	cmp    $0x3,%al
  33:	0f 8e 77 01 00 00    	jle    0x1b0
  39:	48                   	rex.W
  3a:	b8 00 00 00 00       	mov    $0x0,%eax

