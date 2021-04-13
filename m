Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.7 required=3.0 tests=BAYES_00,FROM_LOCAL_HEX,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5CCCDC433ED
	for <linux-crypto@archiver.kernel.org>; Tue, 13 Apr 2021 05:44:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 290EC61004
	for <linux-crypto@archiver.kernel.org>; Tue, 13 Apr 2021 05:44:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343827AbhDMFoi (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 13 Apr 2021 01:44:38 -0400
Received: from mail-io1-f71.google.com ([209.85.166.71]:50539 "EHLO
        mail-io1-f71.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245735AbhDMFoh (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 13 Apr 2021 01:44:37 -0400
Received: by mail-io1-f71.google.com with SMTP id a1so10385026iow.17
        for <linux-crypto@vger.kernel.org>; Mon, 12 Apr 2021 22:44:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=J5b//R78831zM4Ss3o6NkqUcVQQPCbS453yaDVWH/Vs=;
        b=YkUz+jDXv9s8ZOAxyQcCCUI7YWX/Mu8ojgjul6Ib/MkvLY4RwbMHNzFfVyTqsYyvwO
         yohjhfUjvDiW3tmYS3UvJsNKWCr2WiNugMGC/lZ4BZYcVbAC9dgTqsEcNIS0rkr/PdA3
         BbuZ7tnwFAjbtp+qG2aoibszoiGsUeFPTkYdNFCdhhpVXQAiDrHRxDgwqdpVcs9lvM2T
         /X8Qwv4NrwkrEkaPAl5E1a1mtQpDdG7VoBFo3Qd8gBnUP12sKrj6h7tskFcCRY+HslAp
         pakoDEWCODa+e9U6rJrQvRTkbPF7z0VC33M2/7fQQxyLxDL6CQl7nh6EYI1hVofTa0NN
         kMQg==
X-Gm-Message-State: AOAM530ob0oekMwufvV5D1mBwtmKvazJGxDm04778QSe05SrJK+Z9jds
        M5P72pFlndoTXabe1z6pikV/BDeNW8I5Q6RhOnyflUjqUUyh
X-Google-Smtp-Source: ABdhPJy+sZUkg1hcJlwWeqyJcA3cvZrEDaJz8z8E9vswgCdfzcJbHFPg4IpNWs2hdoUqEZNkpKMT2vmB7cLSKqq7Ciz+a5vsto5d
MIME-Version: 1.0
X-Received: by 2002:a92:c9d1:: with SMTP id k17mr27614336ilq.60.1618292658270;
 Mon, 12 Apr 2021 22:44:18 -0700 (PDT)
Date:   Mon, 12 Apr 2021 22:44:18 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000009f87005bfd41f0e@google.com>
Subject: [syzbot] KASAN: use-after-free Read in skcipher_walk_next
From:   syzbot <syzbot+4061a98a8ab454dde8ff@syzkaller.appspotmail.com>
To:     davem@davemloft.net, herbert@gondor.apana.org.au,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    4fa56ad0 Merge tag 'for-linus' of git://git.kernel.org/pub..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=17dbd09ad00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=9320464bf47598bd
dashboard link: https://syzkaller.appspot.com/bug?extid=4061a98a8ab454dde8ff

Unfortunately, I don't have any reproducer for this issue yet.

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+4061a98a8ab454dde8ff@syzkaller.appspotmail.com

==================================================================
BUG: KASAN: use-after-free in memcpy include/linux/fortify-string.h:191 [inline]
BUG: KASAN: use-after-free in skcipher_next_copy crypto/skcipher.c:292 [inline]
BUG: KASAN: use-after-free in skcipher_walk_next+0xb69/0x1680 crypto/skcipher.c:379
Read of size 2785 at addr ffff8880781c0000 by task kworker/u4:3/204

CPU: 0 PID: 204 Comm: kworker/u4:3 Not tainted 5.12.0-rc6-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Workqueue: pencrypt_parallel padata_parallel_worker
Call Trace:
 __dump_stack lib/dump_stack.c:79 [inline]
 dump_stack+0x141/0x1d7 lib/dump_stack.c:120
 print_address_description.constprop.0.cold+0x5b/0x2f8 mm/kasan/report.c:232
 __kasan_report mm/kasan/report.c:399 [inline]
 kasan_report.cold+0x7c/0xd8 mm/kasan/report.c:416
 check_region_inline mm/kasan/generic.c:180 [inline]
 kasan_check_range+0x13d/0x180 mm/kasan/generic.c:186
 memcpy+0x20/0x60 mm/kasan/shadow.c:65
 memcpy include/linux/fortify-string.h:191 [inline]
 skcipher_next_copy crypto/skcipher.c:292 [inline]
 skcipher_walk_next+0xb69/0x1680 crypto/skcipher.c:379
 skcipher_walk_done+0x7a3/0xf00 crypto/skcipher.c:159
 gcmaes_crypt_by_sg+0x377/0x8a0 arch/x86/crypto/aesni-intel_glue.c:694

The buggy address belongs to the page:
page:ffffea0001e07000 refcount:0 mapcount:-128 mapping:0000000000000000 index:0x1 pfn:0x781c0
flags: 0xfff00000000000()
raw: 00fff00000000000 ffffea0001e06808 ffffea0001c67008 0000000000000000
raw: 0000000000000001 0000000000000004 00000000ffffff7f 0000000000000000
page dumped because: kasan: bad access detected

Memory state around the buggy address:
 ffff8880781bff00: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
 ffff8880781bff80: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
>ffff8880781c0000: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
                   ^
 ffff8880781c0080: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
 ffff8880781c0100: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
==================================================================


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
