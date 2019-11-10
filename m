Return-Path: <SRS0=RIhc=ZC=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DF9A4C43331
	for <linux-crypto@archiver.kernel.org>; Sun, 10 Nov 2019 13:56:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BFA412085B
	for <linux-crypto@archiver.kernel.org>; Sun, 10 Nov 2019 13:56:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726402AbfKJN4D (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 10 Nov 2019 08:56:03 -0500
Received: from vps-vb.mhejs.net ([37.28.154.113]:51690 "EHLO vps-vb.mhejs.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726390AbfKJN4D (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 10 Nov 2019 08:56:03 -0500
Received: from MUA
        by vps-vb.mhejs.net with esmtps (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.92.3)
        (envelope-from <mail@maciej.szmigiero.name>)
        id 1iTngz-0000Y5-23; Sun, 10 Nov 2019 14:55:49 +0100
From:   "Maciej S. Szmigiero" <mail@maciej.szmigiero.name>
To:     "Theodore Ts'o" <tytso@mit.edu>
Cc:     Herbert Xu <herbert@gondor.apana.org.au>,
        Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Keerthy <j-keerthy@ti.com>, Stephen Boyd <swboyd@chromium.org>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] random: Don't freeze in add_hwgenerator_randomness() if stopping kthread
Date:   Sun, 10 Nov 2019 14:55:42 +0100
Message-Id: <20191110135543.3476097-1-mail@maciej.szmigiero.name>
X-Mailer: git-send-email 2.23.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Since commit 59b569480dc8
("random: Use wait_event_freezable() in add_hwgenerator_randomness()")
there is a race in add_hwgenerator_randomness() between freezing and
stopping the calling kthread.

This commit changed wait_event_interruptible() call with
kthread_freezable_should_stop() as a condition into wait_event_freezable()
with just kthread_should_stop() as a condition to fix a warning that
kthread_freezable_should_stop() might sleep inside the wait.

wait_event_freezable() ultimately calls __refrigerator() with its
check_kthr_stop argument set to false, which causes it to keep the kthread
frozen even if somebody calls kthread_stop() on it.

Calling wait_event_freezable() with kthread_should_stop() as a condition
is racy because it doesn't take into account the situation where this
condition becomes true on a kthread marked for freezing only after this
condition has already been checked.

Calling freezing() should avoid the issue that the commit 59b569480dc8 has
fixed, as it is only a checking function, it doesn't actually do the
freezing.

add_hwgenerator_randomness() has two post-boot users: in khwrng the
kthread will be frozen anyway by call to kthread_freezable_should_stop()
in its main loop, while its second user (ath9k-hwrng) is not freezable at
all.

This change allows a VM with virtio-rng loaded to write s2disk image
successfully.

Fixes: 59b569480dc8 ("random: Use wait_event_freezable() in add_hwgenerator_randomness()")
Signed-off-by: Maciej S. Szmigiero <mail@maciej.szmigiero.name>
---
 drivers/char/random.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/char/random.c b/drivers/char/random.c
index de434feb873a..2f87910dd498 100644
--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -2500,8 +2500,8 @@ void add_hwgenerator_randomness(const char *buffer, size_t count,
 	 * We'll be woken up again once below random_write_wakeup_thresh,
 	 * or when the calling thread is about to terminate.
 	 */
-	wait_event_freezable(random_write_wait,
-			kthread_should_stop() ||
+	wait_event_interruptible(random_write_wait,
+			kthread_should_stop() || freezing(current) ||
 			ENTROPY_BITS(&input_pool) <= random_write_wakeup_bits);
 	mix_pool_bytes(poolp, buffer, count);
 	credit_entropy_bits(poolp, entropy);
