Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5DD5FC433E6
	for <linux-crypto@archiver.kernel.org>; Wed, 30 Dec 2020 12:19:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2B91322227
	for <linux-crypto@archiver.kernel.org>; Wed, 30 Dec 2020 12:19:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726322AbgL3MTE (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 30 Dec 2020 07:19:04 -0500
Received: from relay.sw.ru ([185.231.240.75]:40288 "EHLO relay3.sw.ru"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726203AbgL3MTE (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 30 Dec 2020 07:19:04 -0500
Received: from [192.168.15.77] (helo=localhost.localdomain)
        by relay3.sw.ru with esmtp (Exim 4.94)
        (envelope-from <ktkhai@virtuozzo.com>)
        id 1kuaPt-00EufO-5p; Wed, 30 Dec 2020 15:17:25 +0300
Subject: [PATCH] crypto: Fix divide error in do_xor_speed()
From:   Kirill Tkhai <ktkhai@virtuozzo.com>
To:     herbert@gondor.apana.org.au, davem@davemloft.net,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        ktkhai@virtuozzo.com
Date:   Wed, 30 Dec 2020 15:17:35 +0300
Message-ID: <160933061716.928967.463919628731790218.stgit@localhost.localdomain>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Latest (but not only latest) linux-next panics with divide
error on my QEMU setup.

The patch at the bottom of this message fixes the problem.

xor: measuring software checksum speed
divide error: 0000 [#1] PREEMPT SMP KASAN
PREEMPT SMP KASAN
CPU: 3 PID: 1 Comm: swapper/0 Not tainted 5.10.0-next-20201223+ #2177
RIP: 0010:do_xor_speed+0xbb/0xf3
Code: 41 ff cc 75 b5 bf 01 00 00 00 e8 3d 23 8b fe 65 8b 05 f6 49 83 7d 85 c0 75 05 e8
 84 70 81 fe b8 00 00 50 c3 31 d2 48 8d 7b 10 <f7> f5 41 89 c4 e8 58 07 a2 fe 44 89 63 10 48 8d 7b 08
 e8 cb 07 a2
RSP: 0000:ffff888100137dc8 EFLAGS: 00010246
RAX: 00000000c3500000 RBX: ffffffff823f0160 RCX: 0000000000000000
RDX: 0000000000000000 RSI: 0000000000000808 RDI: ffffffff823f0170
RBP: 0000000000000000 R08: ffffffff8109c50f R09: ffffffff824bb6f7
R10: fffffbfff04976de R11: 0000000000000001 R12: 0000000000000000
R13: ffff888101997000 R14: ffff888101994000 R15: ffffffff823f0178
FS:  0000000000000000(0000) GS:ffff8881f7780000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000000000000 CR3: 000000000220e000 CR4: 00000000000006a0
Call Trace:
 calibrate_xor_blocks+0x13c/0x1c4
 ? do_xor_speed+0xf3/0xf3
 do_one_initcall+0xc1/0x1b7
 ? start_kernel+0x373/0x373
 ? unpoison_range+0x3a/0x60
 kernel_init_freeable+0x1dd/0x238
 ? rest_init+0xc6/0xc6
 kernel_init+0x8/0x10a
 ret_from_fork+0x1f/0x30
---[ end trace 5bd3c1d0b77772da ]---

Signed-off-by: Kirill Tkhai <ktkhai@virtuozzo.com>
---
 crypto/xor.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/crypto/xor.c b/crypto/xor.c
index eacbf4f93990..8f899f898ec9 100644
--- a/crypto/xor.c
+++ b/crypto/xor.c
@@ -107,6 +107,8 @@ do_xor_speed(struct xor_block_template *tmpl, void *b1, void *b2)
 	preempt_enable();
 
 	// bytes/ns == GB/s, multiply by 1000 to get MB/s [not MiB/s]
+	if (!min)
+		min = 1;
 	speed = (1000 * REPS * BENCH_SIZE) / (unsigned int)ktime_to_ns(min);
 	tmpl->speed = speed;
 


