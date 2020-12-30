Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 616E0C433DB
	for <linux-crypto@archiver.kernel.org>; Wed, 30 Dec 2020 21:35:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1FAFF2072E
	for <linux-crypto@archiver.kernel.org>; Wed, 30 Dec 2020 21:35:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726214AbgL3Ves (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 30 Dec 2020 16:34:48 -0500
Received: from relay.sw.ru ([185.231.240.75]:56882 "EHLO relay3.sw.ru"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726197AbgL3Ves (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 30 Dec 2020 16:34:48 -0500
Received: from [192.168.15.152]
        by relay3.sw.ru with esmtp (Exim 4.94)
        (envelope-from <ktkhai@virtuozzo.com>)
        id 1kuj5h-00ExIG-La; Thu, 31 Dec 2020 00:33:09 +0300
Subject: [PATCH v2] crypto: Fix divide error in do_xor_speed()
To:     Ard Biesheuvel <ardb@kernel.org>, Arnd Bergmann <arnd@arndb.de>,
        Douglas Anderson <dianders@chromium.org>
Cc:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <160933061716.928967.463919628731790218.stgit@localhost.localdomain>
 <CAMj1kXHTzafF5ZZR5Ornusjt6cd0K-Lczb0Z0FK54jBTv9cKsA@mail.gmail.com>
From:   Kirill Tkhai <ktkhai@virtuozzo.com>
Message-ID: <30381b78-8721-5b4e-e075-300c5af3f9fa@virtuozzo.com>
Date:   Thu, 31 Dec 2020 00:33:18 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.5.1
MIME-Version: 1.0
In-Reply-To: <CAMj1kXHTzafF5ZZR5Ornusjt6cd0K-Lczb0Z0FK54jBTv9cKsA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

crypto: Fix divide error in do_xor_speed()

From: Kirill Tkhai <ktkhai@virtuozzo.com>

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

Fixes: c055e3eae0f1 ("crypto: xor - use ktime for template benchmarking")
Signed-off-by: Kirill Tkhai <ktkhai@virtuozzo.com>
Acked-by: Ard Biesheuvel <ardb@kernel.org>
---

v2: New Year resend :) Added fixes tag.
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
 
