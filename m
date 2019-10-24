Return-Path: <SRS0=tzqc=YR=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.4 required=3.0 tests=FROM_LOCAL_HEX,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EBAA5CA9EAF
	for <linux-crypto@archiver.kernel.org>; Thu, 24 Oct 2019 17:02:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C023920650
	for <linux-crypto@archiver.kernel.org>; Thu, 24 Oct 2019 17:02:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2410025AbfJXRCL (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 24 Oct 2019 13:02:11 -0400
Received: from mail-il1-f197.google.com ([209.85.166.197]:45857 "EHLO
        mail-il1-f197.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2410023AbfJXRCL (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 24 Oct 2019 13:02:11 -0400
Received: by mail-il1-f197.google.com with SMTP id w9so16082767ilo.12
        for <linux-crypto@vger.kernel.org>; Thu, 24 Oct 2019 10:02:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=gnBVB/MCcAJVEx5kLX5YbPi7DcmZ/XW3gOmdfm/l+IA=;
        b=GrYWX1XzPuswO2LJR0vYS4vpHwfc2uC/+n+bjgYT63g98vIT9y5WbGbkGJGfRg5/V0
         78/0QOTJg5YmtoEHRJA/qu8OvJ+7pYWlN7Sqs5z5Dg1UUjN9gGtUJCf22r+5+SuACEE4
         X3SMsRgdtPhj3YBa1llbOYysHjkBynUz+4tuvJQmKXVYNzG6HycuVnzI6wjZ4EfUoXt6
         L9yJ9UjaI7jGg7vBE7K49jMgPzUJVIGj29/tRaD4/Qx4za4hfZ+ONYPKCc486XAwAzhJ
         SCfb1/u95+I0wjVjDCzpQDNEAj+jEd41A1IYWI8HxXaJPlxh0/+G0bFIiFcplOQN4FLN
         /ZCw==
X-Gm-Message-State: APjAAAW/OLHIHn3UAu19/fyipmkrUYlDBxlkvk87T/vznRTMzvLVhgO1
        d1vnhFz0ZCcaJ/SA/qI9Djxt2Umw3CQsBcN7yluyTIziIsIS
X-Google-Smtp-Source: APXvYqwLrzXvLYspWxVGMVkDRKKtVf4XeXPJuGmcakuCAHepWXmGZfBZv+K8zdKynEexb7HeYziOoQZhYu/LXY4PeumEjm9NEvkP
MIME-Version: 1.0
X-Received: by 2002:a92:9a54:: with SMTP id t81mr44665340ili.147.1571936528622;
 Thu, 24 Oct 2019 10:02:08 -0700 (PDT)
Date:   Thu, 24 Oct 2019 10:02:08 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000065ef5f0595aafe71@google.com>
Subject: KMSAN: uninit-value in aes_encrypt (2)
From:   syzbot <syzbot+9e3b178624a8a2f8fa28@syzkaller.appspotmail.com>
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

HEAD commit:    3c8ca708 test_kmsan.c: fix SPDX comment
git tree:       https://github.com/google/kmsan.git master
console output: https://syzkaller.appspot.com/x/log.txt?x=14129497600000
kernel config:  https://syzkaller.appspot.com/x/.config?x=c07a3d4f8a59e198
dashboard link: https://syzkaller.appspot.com/bug?extid=9e3b178624a8a2f8fa28
compiler:       clang version 9.0.0 (/home/glider/llvm/clang  
80fee25776c2fb61e74c1ecb1a523375c2500b69)
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=11331128e00000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=140b47ef600000

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+9e3b178624a8a2f8fa28@syzkaller.appspotmail.com

IPv6: ADDRCONF(NETDEV_CHANGE): hsr0: link becomes ready
8021q: adding VLAN 0 to HW filter on device batadv0
=====================================================
BUG: KMSAN: uninit-value in subshift lib/crypto/aes.c:149 [inline]
BUG: KMSAN: uninit-value in aes_encrypt+0x12d5/0x1bd0 lib/crypto/aes.c:282
CPU: 0 PID: 12200 Comm: syz-executor134 Not tainted 5.4.0-rc3+ #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS  
Google 01/01/2011
Call Trace:
  __dump_stack lib/dump_stack.c:77 [inline]
  dump_stack+0x191/0x1f0 lib/dump_stack.c:113
  kmsan_report+0x14a/0x2f0 mm/kmsan/kmsan_report.c:110
  __msan_warning+0x73/0xf0 mm/kmsan/kmsan_instr.c:245
  subshift lib/crypto/aes.c:149 [inline]
  aes_encrypt+0x12d5/0x1bd0 lib/crypto/aes.c:282
  aesti_encrypt+0xe8/0x130 crypto/aes_ti.c:31
  crypto_cipher_encrypt_one include/linux/crypto.h:1763 [inline]
  crypto_cbcmac_digest_update+0x3cf/0x550 crypto/ccm.c:871
  crypto_shash_update crypto/shash.c:107 [inline]
  shash_ahash_finup+0x659/0xb20 crypto/shash.c:276
  shash_async_finup+0xbb/0x110 crypto/shash.c:291
  crypto_ahash_op+0x1cd/0x6e0 crypto/ahash.c:368
  crypto_ahash_finup+0x8c/0xb0 crypto/ahash.c:393
  crypto_ccm_auth+0x14b2/0x1570 crypto/ccm.c:230
  crypto_ccm_encrypt+0x283/0x840 crypto/ccm.c:309
  crypto_aead_encrypt+0xf2/0x180 crypto/aead.c:99
  tls_do_encryption net/tls/tls_sw.c:521 [inline]
  tls_push_record+0x341e/0x4e50 net/tls/tls_sw.c:730
  bpf_exec_tx_verdict+0x1454/0x1c80 net/tls/tls_sw.c:770
  tls_sw_sendmsg+0x158d/0x2710 net/tls/tls_sw.c:1033
  inet6_sendmsg+0x2d8/0x2e0 net/ipv6/af_inet6.c:576
  sock_sendmsg_nosec net/socket.c:637 [inline]
  sock_sendmsg net/socket.c:657 [inline]
  __sys_sendto+0x8fc/0xc70 net/socket.c:1952
  __do_sys_sendto net/socket.c:1964 [inline]
  __se_sys_sendto+0x107/0x130 net/socket.c:1960
  __x64_sys_sendto+0x6e/0x90 net/socket.c:1960
  do_syscall_64+0xb6/0x160 arch/x86/entry/common.c:291
  entry_SYSCALL_64_after_hwframe+0x63/0xe7
RIP: 0033:0x441cf9
Code: 43 02 00 85 c0 b8 00 00 00 00 48 0f 44 c3 5b c3 90 48 89 f8 48 89 f7  
48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff  
ff 0f 83 0b 13 fc ff c3 66 2e 0f 1f 84 00 00 00 00
RSP: 002b:00000000007eff08 EFLAGS: 00000246 ORIG_RAX: 000000000000002c
RAX: ffffffffffffffda RBX: 0000000000000003 RCX: 0000000000441cf9
RDX: fffffffffffffee0 RSI: 00000000200005c0 RDI: 0000000000000003
RBP: 00000000007eff30 R08: 0000000000000000 R09: 00000000000000b6
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000403490
R13: 0000000000403520 R14: 0000000000000000 R15: 0000000000000000

Uninit was stored to memory at:
  kmsan_save_stack_with_flags mm/kmsan/kmsan.c:151 [inline]
  kmsan_internal_chain_origin+0xbd/0x170 mm/kmsan/kmsan.c:319
  __msan_chain_origin+0x6b/0xe0 mm/kmsan/kmsan_instr.c:179
  __crypto_xor+0x1e8/0x1470 crypto/algapi.c:992
  crypto_xor include/crypto/algapi.h:213 [inline]
  crypto_cbcmac_digest_update+0x2ba/0x550 crypto/ccm.c:865
  crypto_shash_update crypto/shash.c:107 [inline]
  shash_ahash_finup+0x659/0xb20 crypto/shash.c:276
  shash_async_finup+0xbb/0x110 crypto/shash.c:291
  crypto_ahash_op+0x1cd/0x6e0 crypto/ahash.c:368
  crypto_ahash_finup+0x8c/0xb0 crypto/ahash.c:393
  crypto_ccm_auth+0x14b2/0x1570 crypto/ccm.c:230
  crypto_ccm_encrypt+0x283/0x840 crypto/ccm.c:309
  crypto_aead_encrypt+0xf2/0x180 crypto/aead.c:99
  tls_do_encryption net/tls/tls_sw.c:521 [inline]
  tls_push_record+0x341e/0x4e50 net/tls/tls_sw.c:730
  bpf_exec_tx_verdict+0x1454/0x1c80 net/tls/tls_sw.c:770
  tls_sw_sendmsg+0x158d/0x2710 net/tls/tls_sw.c:1033
  inet6_sendmsg+0x2d8/0x2e0 net/ipv6/af_inet6.c:576
  sock_sendmsg_nosec net/socket.c:637 [inline]
  sock_sendmsg net/socket.c:657 [inline]
  __sys_sendto+0x8fc/0xc70 net/socket.c:1952
  __do_sys_sendto net/socket.c:1964 [inline]
  __se_sys_sendto+0x107/0x130 net/socket.c:1960
  __x64_sys_sendto+0x6e/0x90 net/socket.c:1960
  do_syscall_64+0xb6/0x160 arch/x86/entry/common.c:291
  entry_SYSCALL_64_after_hwframe+0x63/0xe7

Uninit was created at:
  kmsan_save_stack_with_flags+0x3f/0x90 mm/kmsan/kmsan.c:151
  kmsan_internal_alloc_meta_for_pages mm/kmsan/kmsan_shadow.c:362 [inline]
  kmsan_alloc_page+0x153/0x370 mm/kmsan/kmsan_shadow.c:391
  __alloc_pages_nodemask+0x149d/0x60c0 mm/page_alloc.c:4794
  alloc_pages_current+0x68d/0x9a0 mm/mempolicy.c:2188
  alloc_pages include/linux/gfp.h:511 [inline]
  skb_page_frag_refill+0x2b0/0x580 net/core/sock.c:2372
  sk_page_frag_refill+0xa4/0x330 net/core/sock.c:2392
  sk_msg_alloc+0x203/0x1050 net/core/skmsg.c:37
  tls_alloc_encrypted_msg net/tls/tls_sw.c:284 [inline]
  tls_sw_sendmsg+0xb56/0x2710 net/tls/tls_sw.c:953
  inet6_sendmsg+0x2d8/0x2e0 net/ipv6/af_inet6.c:576
  sock_sendmsg_nosec net/socket.c:637 [inline]
  sock_sendmsg net/socket.c:657 [inline]
  __sys_sendto+0x8fc/0xc70 net/socket.c:1952
  __do_sys_sendto net/socket.c:1964 [inline]
  __se_sys_sendto+0x107/0x130 net/socket.c:1960
  __x64_sys_sendto+0x6e/0x90 net/socket.c:1960
  do_syscall_64+0xb6/0x160 arch/x86/entry/common.c:291
  entry_SYSCALL_64_after_hwframe+0x63/0xe7
=====================================================


---
This bug is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this bug report. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
syzbot can test patches for this bug, for details see:
https://goo.gl/tpsmEJ#testing-patches
