Return-Path: <SRS0=CUNG=U2=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.4 required=3.0 tests=FROM_LOCAL_HEX,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2FFC3C48BD7
	for <linux-crypto@archiver.kernel.org>; Thu, 27 Jun 2019 16:37:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F0E302133F
	for <linux-crypto@archiver.kernel.org>; Thu, 27 Jun 2019 16:37:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726441AbfF0QhG (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 27 Jun 2019 12:37:06 -0400
Received: from mail-io1-f71.google.com ([209.85.166.71]:38564 "EHLO
        mail-io1-f71.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726431AbfF0QhG (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 27 Jun 2019 12:37:06 -0400
Received: by mail-io1-f71.google.com with SMTP id h4so3225957iol.5
        for <linux-crypto@vger.kernel.org>; Thu, 27 Jun 2019 09:37:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=0gbawlg+5nxGY4BTH06fjIa4wIW7pEalqj9wAN0JBD8=;
        b=Sy4hmDTnAdm2wV39HgaQVlySgyT4uxIsiHHVqMrEc3djt6EG5s17Xc8BDlYBloiItT
         D3rn4WNIEaux30qLrltz9xF2L+Bps4Hw4M2V088hXbqA8fqmaRMSS33cjWPk9ZWo7Oai
         OZYE0EkjVnCFSZXaqj3WBCgnLzbYbPN8FSAd4UvyDiqopFs0PQqxYnUYRsfJYyQyafhc
         awPvflEKw8u0i5ZgBUpETm7TuS/i81oNElgT0GFf+x1/effyB0zC1ts5YSxcUPUna0UV
         jnkUHxShfAGPy+mToTaROEwMs9ZS9QjJO4nB6LpEm2WzP7vVAhbViqPZymNas/vtnOiM
         zb1A==
X-Gm-Message-State: APjAAAUL6QzBsOK6oOWlK7zyRn5RdlPWDpP93YterHNT4QrCQCLOdWg9
        bYZla7pdDFI4mzdb+EThzmsPDxRsQdBDW8j8EZcG7dJ6vp0j
X-Google-Smtp-Source: APXvYqys4Ct1w0+UN6MEsxgCYkRAcYG/Kw7D7YdZ+rgbYg+n/HSuR9A8VdDjRKI3hW+upt3CSXKHfvdiVMmnRBewb3HygnUF58R3
MIME-Version: 1.0
X-Received: by 2002:a6b:b257:: with SMTP id b84mr5963036iof.137.1561653425042;
 Thu, 27 Jun 2019 09:37:05 -0700 (PDT)
Date:   Thu, 27 Jun 2019 09:37:05 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000a97a15058c50c52e@google.com>
Subject: KMSAN: uninit-value in aesti_encrypt
From:   syzbot <syzbot+6f50c99e8f6194bf363f@syzkaller.appspotmail.com>
To:     davem@davemloft.net, glider@google.com,
        herbert@gondor.apana.org.au, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hello,

syzbot found the following crash on:

HEAD commit:    3351e2b9 usb-fuzzer: main usb gadget fuzzer driver
git tree:       kmsan
console output: https://syzkaller.appspot.com/x/log.txt?x=135d0c06a00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=40511ad0c5945201
dashboard link: https://syzkaller.appspot.com/bug?extid=6f50c99e8f6194bf363f
compiler:       clang version 9.0.0 (/home/glider/llvm/clang  
80fee25776c2fb61e74c1ecb1a523375c2500b69)
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=1534241aa00000

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+6f50c99e8f6194bf363f@syzkaller.appspotmail.com

==================================================================
BUG: KMSAN: uninit-value in subshift crypto/aes_ti.c:148 [inline]
BUG: KMSAN: uninit-value in aesti_encrypt+0x1238/0x1bc0 crypto/aes_ti.c:292
CPU: 1 PID: 11187 Comm: syz-executor.2 Not tainted 5.2.0-rc4+ #5
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS  
Google 01/01/2011
Call Trace:
  __dump_stack lib/dump_stack.c:77 [inline]
  dump_stack+0x191/0x1f0 lib/dump_stack.c:113
  kmsan_report+0x162/0x2d0 mm/kmsan/kmsan.c:611
  __msan_warning+0x75/0xe0 mm/kmsan/kmsan_instr.c:304
  subshift crypto/aes_ti.c:148 [inline]
  aesti_encrypt+0x1238/0x1bc0 crypto/aes_ti.c:292
  crypto_cipher_encrypt_one include/linux/crypto.h:1753 [inline]
  crypto_cbcmac_digest_update+0x3cf/0x550 crypto/ccm.c:871
  crypto_shash_update crypto/shash.c:107 [inline]
  shash_ahash_finup+0x659/0xb20 crypto/shash.c:276
  shash_async_finup+0xbb/0x110 crypto/shash.c:291
  crypto_ahash_op+0x1cd/0x6e0 crypto/ahash.c:368
  crypto_ahash_finup+0x8c/0xb0 crypto/ahash.c:393
  crypto_ccm_auth+0x14b2/0x1570 crypto/ccm.c:230
  crypto_ccm_encrypt+0x272/0x8d0 crypto/ccm.c:309
  crypto_aead_encrypt include/crypto/aead.h:331 [inline]
  tls_do_encryption net/tls/tls_sw.c:521 [inline]
  tls_push_record+0x341a/0x4f70 net/tls/tls_sw.c:730
  bpf_exec_tx_verdict+0x1454/0x1c90 net/tls/tls_sw.c:770
  tls_sw_sendmsg+0x15bd/0x2740 net/tls/tls_sw.c:1033
  inet_sendmsg+0x48e/0x750 net/ipv4/af_inet.c:798
  sock_sendmsg_nosec net/socket.c:646 [inline]
  sock_sendmsg net/socket.c:665 [inline]
  __sys_sendto+0x905/0xb90 net/socket.c:1958
  __do_sys_sendto net/socket.c:1970 [inline]
  __se_sys_sendto+0x107/0x130 net/socket.c:1966
  __x64_sys_sendto+0x6e/0x90 net/socket.c:1966
  do_syscall_64+0xbc/0xf0 arch/x86/entry/common.c:302
  entry_SYSCALL_64_after_hwframe+0x63/0xe7
RIP: 0033:0x4592c9
Code: fd b7 fb ff c3 66 2e 0f 1f 84 00 00 00 00 00 66 90 48 89 f8 48 89 f7  
48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff  
ff 0f 83 cb b7 fb ff c3 66 2e 0f 1f 84 00 00 00 00
RSP: 002b:00007f01788fdc78 EFLAGS: 00000246 ORIG_RAX: 000000000000002c
RAX: ffffffffffffffda RBX: 0000000000000006 RCX: 00000000004592c9
RDX: ffffffffffffff7f RSI: 00000000200005c0 RDI: 0000000000000003
RBP: 000000000075c070 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 00007f01788fe6d4
R13: 00000000004c707f R14: 00000000004dc260 R15: 00000000ffffffff

Uninit was stored to memory at:
  kmsan_save_stack_with_flags mm/kmsan/kmsan.c:201 [inline]
  kmsan_save_stack mm/kmsan/kmsan.c:213 [inline]
  kmsan_internal_chain_origin+0xcc/0x150 mm/kmsan/kmsan.c:414
  __msan_chain_origin+0x6b/0xe0 mm/kmsan/kmsan_instr.c:200
  __crypto_xor+0x1e8/0x1470 crypto/algapi.c:1019
  crypto_xor include/crypto/algapi.h:214 [inline]
  crypto_cbcmac_digest_update+0x2ba/0x550 crypto/ccm.c:865
  crypto_shash_update crypto/shash.c:107 [inline]
  shash_ahash_finup+0x659/0xb20 crypto/shash.c:276
  shash_async_finup+0xbb/0x110 crypto/shash.c:291
  crypto_ahash_op+0x1cd/0x6e0 crypto/ahash.c:368
  crypto_ahash_finup+0x8c/0xb0 crypto/ahash.c:393
  crypto_ccm_auth+0x14b2/0x1570 crypto/ccm.c:230
  crypto_ccm_encrypt+0x272/0x8d0 crypto/ccm.c:309
  crypto_aead_encrypt include/crypto/aead.h:331 [inline]
  tls_do_encryption net/tls/tls_sw.c:521 [inline]
  tls_push_record+0x341a/0x4f70 net/tls/tls_sw.c:730
  bpf_exec_tx_verdict+0x1454/0x1c90 net/tls/tls_sw.c:770
  tls_sw_sendmsg+0x15bd/0x2740 net/tls/tls_sw.c:1033
  inet_sendmsg+0x48e/0x750 net/ipv4/af_inet.c:798
  sock_sendmsg_nosec net/socket.c:646 [inline]
  sock_sendmsg net/socket.c:665 [inline]
  __sys_sendto+0x905/0xb90 net/socket.c:1958
  __do_sys_sendto net/socket.c:1970 [inline]
  __se_sys_sendto+0x107/0x130 net/socket.c:1966
  __x64_sys_sendto+0x6e/0x90 net/socket.c:1966
  do_syscall_64+0xbc/0xf0 arch/x86/entry/common.c:302
  entry_SYSCALL_64_after_hwframe+0x63/0xe7

Uninit was created at:
  kmsan_save_stack_with_flags+0x37/0x70 mm/kmsan/kmsan.c:201
  kmsan_internal_alloc_meta_for_pages+0x123/0x510 mm/kmsan/kmsan_hooks.c:102
  kmsan_alloc_page+0x7a/0xf0 mm/kmsan/kmsan_hooks.c:246
  __alloc_pages_nodemask+0x144d/0x6020 mm/page_alloc.c:4700
  alloc_pages_current+0x6a0/0x9b0 mm/mempolicy.c:2132
  alloc_pages include/linux/gfp.h:511 [inline]
  skb_page_frag_refill+0x15e/0x560 net/core/sock.c:2349
  sk_page_frag_refill+0xa4/0x330 net/core/sock.c:2369
  sk_msg_alloc+0x203/0x1050 net/core/skmsg.c:37
  tls_alloc_encrypted_msg net/tls/tls_sw.c:284 [inline]
  tls_sw_sendmsg+0xb6a/0x2740 net/tls/tls_sw.c:953
  inet_sendmsg+0x48e/0x750 net/ipv4/af_inet.c:798
  sock_sendmsg_nosec net/socket.c:646 [inline]
  sock_sendmsg net/socket.c:665 [inline]
  __sys_sendto+0x905/0xb90 net/socket.c:1958
  __do_sys_sendto net/socket.c:1970 [inline]
  __se_sys_sendto+0x107/0x130 net/socket.c:1966
  __x64_sys_sendto+0x6e/0x90 net/socket.c:1966
  do_syscall_64+0xbc/0xf0 arch/x86/entry/common.c:302
  entry_SYSCALL_64_after_hwframe+0x63/0xe7
==================================================================


---
This bug is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this bug report. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
syzbot can test patches for this bug, for details see:
https://goo.gl/tpsmEJ#testing-patches
