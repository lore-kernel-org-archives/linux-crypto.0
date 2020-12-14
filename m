Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 28AC5C4361B
	for <linux-crypto@archiver.kernel.org>; Mon, 14 Dec 2020 21:17:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DE9C22247F
	for <linux-crypto@archiver.kernel.org>; Mon, 14 Dec 2020 21:17:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387650AbgLNVQz (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 14 Dec 2020 16:16:55 -0500
Received: from inet10.abb.com ([138.225.1.74]:55964 "EHLO inet10.abb.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726557AbgLNVQy (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 14 Dec 2020 16:16:54 -0500
X-Greylist: delayed 13465 seconds by postgrey-1.27 at vger.kernel.org; Mon, 14 Dec 2020 16:16:53 EST
Received: from gitsiv.ch.abb.com (gitsiv.keymile.net [10.41.156.251])
        by inet10.abb.com (8.14.7/8.14.7) with SMTP id 0BEHUoXo010976;
        Mon, 14 Dec 2020 18:30:50 +0100
Received: from ch900154.keymile.net (ch900154.keymile.net [172.31.40.201])
        by gitsiv.ch.abb.com (Postfix) with ESMTP id B6B10610841F;
        Mon, 14 Dec 2020 18:30:50 +0100 (CET)
From:   Luca Dariz <luca.dariz@hitachi-powergrids.com>
To:     linux-crypto@vger.kernel.org
Cc:     Luca Dariz <luca.dariz@hitachi-powergrids.com>,
        Matt Mackall <mpm@selenic.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Colin Ian King <colin.king@canonical.com>,
        Holger Brunck <holger.brunck@hitachi-powergrids.com>,
        Valentin Longchamp <valentin.longchamp@hitachi-powergrids.com>
Subject: [PATCH] hwrng: fix khwrng lifecycle
Date:   Mon, 14 Dec 2020 18:29:33 +0100
Message-Id: <20201214172933.25580-1-luca.dariz@hitachi-powergrids.com>
X-Mailer: git-send-email 2.24.3
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

There are two issues with the management of the kernel thread to gather
entropy:
* it can terminate also if the rng is removed, and in this case it doesn'=
t
  synchronize with kthread_should_stop(), but it directly sets hwrng_fill
  to NULL. If this happens after the NULL check but before kthread_stop()
  is called, we'll have a NULL pointer dereference.
* if we have a register/unregister too fast, it can happen that the kthre=
ad
  is not yet started when kthread_stop is called, and this seems to leave=
 a
  corrupted or uninitialized kthread struct. This is detected by the
  WARN_ON at kernel/kthread.c:75 and later causes a page domain fault.

CC: Matt Mackall <mpm@selenic.com>
CC: Herbert Xu <herbert@gondor.apana.org.au>
CC: Colin Ian King <colin.king@canonical.com>
CC: Holger Brunck <holger.brunck@hitachi-powergrids.com>
CC: Valentin Longchamp <valentin.longchamp@hitachi-powergrids.com>
Signed-off-by: Luca Dariz <luca.dariz@hitachi-powergrids.com>
---
 drivers/char/hw_random/core.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/char/hw_random/core.c b/drivers/char/hw_random/core.=
c
index 8c1c47dd9f46..5845da93c7f4 100644
--- a/drivers/char/hw_random/core.c
+++ b/drivers/char/hw_random/core.c
@@ -31,6 +31,7 @@ static struct hwrng *current_rng;
 /* the current rng has been explicitly chosen by user via sysfs */
 static int cur_rng_set_by_user;
 static struct task_struct *hwrng_fill;
+static struct completion hwrng_started =3D COMPLETION_INITIALIZER(hwrng_=
started);
 /* list of registered rngs, sorted decending by quality */
 static LIST_HEAD(rng_list);
 /* Protects rng_list and current_rng */
@@ -432,12 +433,15 @@ static int hwrng_fillfn(void *unused)
 {
 	long rc;
=20
+	complete(&hwrng_started);
 	while (!kthread_should_stop()) {
 		struct hwrng *rng;
=20
 		rng =3D get_current_rng();
-		if (IS_ERR(rng) || !rng)
-			break;
+		if (IS_ERR(rng) || !rng) {
+			msleep_interruptible(10000);
+			continue;
+		}
 		mutex_lock(&reading_mutex);
 		rc =3D rng_get_data(rng, rng_fillbuf,
 				  rng_buffer_size(), 1);
@@ -462,6 +466,8 @@ static void start_khwrngd(void)
 	if (IS_ERR(hwrng_fill)) {
 		pr_err("hwrng_fill thread creation failed\n");
 		hwrng_fill =3D NULL;
+	} else {
+		wait_for_completion(&hwrng_started);
 	}
 }
=20
--=20
2.24.3

