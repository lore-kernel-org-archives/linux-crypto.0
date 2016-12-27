From: Stephan =?ISO-8859-1?Q?M=FCller?= <smueller@chronox.de>
Subject: [PATCH 3/8] random: trigger random_ready callback upon crng_init == 1
Date: Tue, 27 Dec 2016 23:39:57 +0100
Message-ID: <3576149.HSfW5KObBF@positron.chronox.de>
References: <3254875.f5A5oHPdxF@positron.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org
To: Ted Tso <tytso@mit.edu>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:55166 "EHLO mail.eperm.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933022AbcL0Wnq (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 27 Dec 2016 17:43:46 -0500
In-Reply-To: <3254875.f5A5oHPdxF@positron.chronox.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

The random_ready callback mechanism is intended to replicate the
getrandom system call behavior to in-kernel users. As the getrandom
system call unblocks with crng_init == 1, trigger the random_ready
wakeup call at the same time.

Signed-off-by: Stephan Mueller <smueller@chronox.de>
---
 drivers/char/random.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/char/random.c b/drivers/char/random.c
index 482531d..5c26b1c 100644
--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -810,6 +810,7 @@ static int crng_fast_load(const char *cp, size_t len)
 	}
 	if (crng_init_cnt >= CRNG_INIT_CNT_THRESH) {
 		crng_init = 1;
+		process_random_ready_list();
 		wake_up_interruptible(&crng_init_wait);
 		pr_notice("random: fast init done\n");
 	}
-- 
2.9.3
