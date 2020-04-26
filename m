Return-Path: <SRS0=DsWe=6K=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.4 required=3.0 tests=FROM_LOCAL_HEX,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A53EBC2BA1A
	for <linux-crypto@archiver.kernel.org>; Sun, 26 Apr 2020 06:08:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1E75D2070A
	for <linux-crypto@archiver.kernel.org>; Sun, 26 Apr 2020 06:08:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726101AbgDZGIO (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 26 Apr 2020 02:08:14 -0400
Received: from mail-io1-f72.google.com ([209.85.166.72]:44040 "EHLO
        mail-io1-f72.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725468AbgDZGIN (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 26 Apr 2020 02:08:13 -0400
Received: by mail-io1-f72.google.com with SMTP id o20so16817141ioa.11
        for <linux-crypto@vger.kernel.org>; Sat, 25 Apr 2020 23:08:13 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=QyNKLTN58Ugk/DWSxRQyYsBPGSFn2k5C9pT4xBIXNpc=;
        b=hyqlIonfCSAuvQ3p269jupVh0wIP8BuWWlUNea7E08v2uI9BIostiNOSR1r6X3qJe+
         9SJt9XlRXO/XR79c+B/OK3L93cVEaK1YbM3OY6mCqUhNwXUevLa7g1QU3elIipoT8ML2
         ZcFL+zG1ZSF/J+gdvDkdWl9i1HA4Iw0UBvfDbWleoRLstw2H2u0XKfF/MvbhJUXjS2wO
         hvofZyNnFpJpG/lOzzMe3ZexK8DvhxtvNYM1sMxVZgq3nnOZHdNEMi4Keb0F1AUhsoNo
         NBxjfa7dCbrFwOILhL42DK6z3YfFxldIQNu6nOqAXvwmyXObtHDaTtv03293+Hs02e6i
         1RDw==
X-Gm-Message-State: AGi0PuYQZRe2vzvydZscdFykume8nkMnIDpC8/4gKWzQqha3QjZOphv5
        CtBXCqq/n9u4LFALfA27+y8vqnOmPV5rhnnA/lnuO2WNINnM
X-Google-Smtp-Source: APiQypIjOx2y7kTNaamViFv55RSK11j+fCGL7KTnjQN/VQieHZsjItWskJ/judSz/vDYkpRp69B0IgTHx4MuIvxA9Gh/ic5xEalU
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:141:: with SMTP id j1mr16475865ilr.100.1587881292868;
 Sat, 25 Apr 2020 23:08:12 -0700 (PDT)
Date:   Sat, 25 Apr 2020 23:08:12 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000068331605a42b6c22@google.com>
Subject: KMSAN: uninit-value in __crc32c_le_base (2)
From:   syzbot <syzbot+5dee08649ac6f0707a43@syzkaller.appspotmail.com>
To:     davem@davemloft.net, glider@google.com,
        herbert@gondor.apana.org.au, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hello,

syzbot found the following crash on:

HEAD commit:    9535d09e page_alloc: drop a call to kmsan_split_page()
git tree:       https://github.com/google/kmsan.git master
console output: https://syzkaller.appspot.com/x/log.txt?x=10445b58100000
kernel config:  https://syzkaller.appspot.com/x/.config?x=a5915107b3106aaa
dashboard link: https://syzkaller.appspot.com/bug?extid=5dee08649ac6f0707a43
compiler:       clang version 10.0.0 (https://github.com/llvm/llvm-project/ c2443155a0fb245c8f17f2c1c72b6ea391e86e81)
userspace arch: i386
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=17b1f930100000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=112a03f0100000

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+5dee08649ac6f0707a43@syzkaller.appspotmail.com

=====================================================
BUG: KMSAN: uninit-value in crc32_body lib/crc32.c:121 [inline]
BUG: KMSAN: uninit-value in crc32_le_generic lib/crc32.c:179 [inline]
BUG: KMSAN: uninit-value in __crc32c_le_base+0xbdd/0xd10 lib/crc32.c:202
CPU: 0 PID: 8830 Comm: syz-executor078 Not tainted 5.6.0-rc7-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 __dump_stack lib/dump_stack.c:77 [inline]
 dump_stack+0x1c9/0x220 lib/dump_stack.c:118
 kmsan_report+0xf7/0x1e0 mm/kmsan/kmsan_report.c:118
 __msan_warning+0x58/0xa0 mm/kmsan/kmsan_instr.c:215
 crc32_body lib/crc32.c:121 [inline]
 crc32_le_generic lib/crc32.c:179 [inline]
 __crc32c_le_base+0xbdd/0xd10 lib/crc32.c:202
 chksum_update+0xb2/0x110 crypto/crc32c_generic.c:88
 crypto_shash_update+0x4e9/0x550 crypto/shash.c:106
 shash_ahash_update crypto/shash.c:246 [inline]
 shash_async_update+0x113/0x1d0 crypto/shash.c:254
 crypto_ahash_update include/crypto/hash.h:547 [inline]
 hash_sendpage+0x8ef/0xdf0 crypto/algif_hash.c:168
 kernel_sendpage net/socket.c:3791 [inline]
 sock_sendpage+0x1e1/0x2c0 net/socket.c:950
 pipe_to_sendpage+0x38c/0x4c0 fs/splice.c:458
 splice_from_pipe_feed fs/splice.c:512 [inline]
 __splice_from_pipe+0x539/0xed0 fs/splice.c:636
 splice_from_pipe fs/splice.c:671 [inline]
 generic_splice_sendpage+0x1d5/0x2d0 fs/splice.c:844
 do_splice_from fs/splice.c:863 [inline]
 direct_splice_actor+0x19e/0x200 fs/splice.c:1037
 splice_direct_to_actor+0x8a9/0x11e0 fs/splice.c:992
 do_splice_direct+0x342/0x580 fs/splice.c:1080
 do_sendfile+0xff5/0x1d10 fs/read_write.c:1520
 __do_compat_sys_sendfile fs/read_write.c:1602 [inline]
 __se_compat_sys_sendfile+0x301/0x3c0 fs/read_write.c:1585
 __ia32_compat_sys_sendfile+0x11a/0x160 fs/read_write.c:1585
 do_syscall_32_irqs_on arch/x86/entry/common.c:339 [inline]
 do_fast_syscall_32+0x3c7/0x6e0 arch/x86/entry/common.c:410
 entry_SYSENTER_compat+0x68/0x77 arch/x86/entry/entry_64_compat.S:139
RIP: 0023:0xf7f34d99
Code: 90 e8 0b 00 00 00 f3 90 0f ae e8 eb f9 8d 74 26 00 89 3c 24 c3 90 90 90 90 90 90 90 90 90 90 90 90 51 52 55 89 e5 0f 34 cd 80 <5d> 5a 59 c3 90 90 90 90 eb 0d 90 90 90 90 90 90 90 90 90 90 90 90
RSP: 002b:00000000ffe3de3c EFLAGS: 00000296 ORIG_RAX: 00000000000000bb
RAX: ffffffffffffffda RBX: 0000000000000005 RCX: 0000000000000003
RDX: 0000000000000000 RSI: 00000000ffffffff RDI: 0000000000000004
RBP: 0000000020000480 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000000000
R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000

Uninit was stored to memory at:
 kmsan_save_stack_with_flags mm/kmsan/kmsan.c:144 [inline]
 kmsan_internal_chain_origin+0xad/0x130 mm/kmsan/kmsan.c:310
 kmsan_memcpy_memmove_metadata+0x272/0x2e0 mm/kmsan/kmsan.c:247
 kmsan_memcpy_metadata+0xb/0x10 mm/kmsan/kmsan.c:267
 kmsan_copy_to_user+0x50/0x90 mm/kmsan/kmsan_hooks.c:262
 _copy_to_user+0x15a/0x1f0 lib/usercopy.c:33
 copy_to_user include/linux/uaccess.h:174 [inline]
 proc_put_long kernel/sysctl.c:2260 [inline]
 __do_proc_dointvec+0xed3/0x1a70 kernel/sysctl.c:2385
 do_proc_dointvec kernel/sysctl.c:2412 [inline]
 proc_dointvec+0x139/0x160 kernel/sysctl.c:2572
 proc_do_sync_ports+0x26a/0x500 net/netfilter/ipvs/ip_vs_ctl.c:1803
 proc_sys_call_handler+0xa92/0xd00 fs/proc/proc_sysctl.c:616
 proc_sys_read+0xc6/0xe0 fs/proc/proc_sysctl.c:630
 do_loop_readv_writev fs/read_write.c:714 [inline]
 do_iter_read+0x8df/0xe10 fs/read_write.c:935
 vfs_readv+0x1ee/0x280 fs/read_write.c:1053
 kernel_readv fs/splice.c:365 [inline]
 default_file_splice_read+0xb1d/0x11d0 fs/splice.c:422
 do_splice_to fs/splice.c:892 [inline]
 splice_direct_to_actor+0x5d8/0x11e0 fs/splice.c:971
 do_splice_direct+0x342/0x580 fs/splice.c:1080
 do_sendfile+0xff5/0x1d10 fs/read_write.c:1520
 __do_compat_sys_sendfile fs/read_write.c:1602 [inline]
 __se_compat_sys_sendfile+0x301/0x3c0 fs/read_write.c:1585
 __ia32_compat_sys_sendfile+0x11a/0x160 fs/read_write.c:1585
 do_syscall_32_irqs_on arch/x86/entry/common.c:339 [inline]
 do_fast_syscall_32+0x3c7/0x6e0 arch/x86/entry/common.c:410
 entry_SYSENTER_compat+0x68/0x77 arch/x86/entry/entry_64_compat.S:139

Local variable ----tmp.i@__do_proc_dointvec created at:
 proc_put_long kernel/sysctl.c:2256 [inline]
 __do_proc_dointvec+0xd1b/0x1a70 kernel/sysctl.c:2385
 proc_put_long kernel/sysctl.c:2256 [inline]
 __do_proc_dointvec+0xd1b/0x1a70 kernel/sysctl.c:2385
=====================================================


---
This bug is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this bug report. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
syzbot can test patches for this bug, for details see:
https://goo.gl/tpsmEJ#testing-patches
