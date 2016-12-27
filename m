From: Stephan =?ISO-8859-1?Q?M=FCller?= <smueller@chronox.de>
Subject: [PATCH 4/8] random: remove unused branch in hot code path
Date: Tue, 27 Dec 2016 23:40:23 +0100
Message-ID: <3380804.uZWydldqLU@positron.chronox.de>
References: <3254875.f5A5oHPdxF@positron.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org
To: Ted Tso <tytso@mit.edu>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:55044 "EHLO mail.eperm.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754536AbcL0Wno (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 27 Dec 2016 17:43:44 -0500
In-Reply-To: <3254875.f5A5oHPdxF@positron.chronox.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

The variable ip is defined to be a __u64 which is always 8 bytes on any
architecture. Thus, the check for sizeof(ip) > 4 will always be true.

As the check happens in a hot code path, remove the branch.

Signed-off-by: Stephan Mueller <smueller@chronox.de>
---
 drivers/char/random.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/char/random.c b/drivers/char/random.c
index 5c26b1c..8d4d720 100644
--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -1136,8 +1136,7 @@ void add_interrupt_randomness(int irq, int irq_flags)
 	fast_pool->pool[1] ^= now ^ c_high;
 	ip = regs ? instruction_pointer(regs) : _RET_IP_;
 	fast_pool->pool[2] ^= ip;
-	fast_pool->pool[3] ^= (sizeof(ip) > 4) ? ip >> 32 :
-		get_reg(fast_pool, regs);
+	fast_pool->pool[3] ^= ip >> 32;
 
 	fast_mix(fast_pool);
 	add_interrupt_bench(cycles);
-- 
2.9.3
