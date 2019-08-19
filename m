Return-Path: <SRS0=LpGJ=WP=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 75BF6C3A5A0
	for <linux-crypto@archiver.kernel.org>; Mon, 19 Aug 2019 15:02:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 428F2206BB
	for <linux-crypto@archiver.kernel.org>; Mon, 19 Aug 2019 15:02:48 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="IIWESImL"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726636AbfHSPCr (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 19 Aug 2019 11:02:47 -0400
Received: from mail-pg1-f194.google.com ([209.85.215.194]:34881 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726168AbfHSPCr (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 19 Aug 2019 11:02:47 -0400
Received: by mail-pg1-f194.google.com with SMTP id n4so1384112pgv.2
        for <linux-crypto@vger.kernel.org>; Mon, 19 Aug 2019 08:02:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=+9CFzHn8s+laxI8BbiaNVGIUIea83s76+v8r3smRCVQ=;
        b=IIWESImL05HMdmUWCk7CdXrrVK8p5KTTQdpU+vD0tyj6k4l5CVrh7/SOYo0/Nh+qgE
         fb/MR66i9vge+5vwNE6dzWU9Xw/R3JCtnaV+N351JYa8E6+N5+Zd+g7zhq/JYrpy+ZMM
         29J2lx5q6HOXKXBvJVA+P3JdMJrF+Jw+NEhIA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=+9CFzHn8s+laxI8BbiaNVGIUIea83s76+v8r3smRCVQ=;
        b=PZjEBnDFqlaVB6jhAuH0PR0XvRs28PedlANCPAnFpf3+jDgjh94mpPQRFfAhH0TGGR
         1FGBOgwXlgaKBP+oBAyldCj/ijzHfF4O5FdkUKpkw0Obbrv+LyaX9Yz2VDbk9bGG1t3U
         x0iH9+88+XiuHe/eepy25OCLSMrGJHeyhXupv6y9bYWzi1FIoqMztkmAlLdFmgfbyA1F
         /fPYxbY4AJWQsF5kW+XU34XNfhtgBp5jDKqJQ6ea/9KJJrsDGN/amNIW64W17isE3HDb
         ugKmWbI3Mpqn2sGE9QMknRq9FvHQzPC2IJfq/ZkICHZICjMAmdM++KFumgywpCyFPwbS
         /u/A==
X-Gm-Message-State: APjAAAXvcOBVtUxm8S/cWmm1D1gu9JJ3M1LjELsULtAB7jVBUvEx7DS0
        ZvH8b3qUovbkyn96fxjbzbSJxA==
X-Google-Smtp-Source: APXvYqzs2lOTNxW35ufSm0/m7vXPfoTFMAUBPDgN2Ry7bYC+9vBffiCW4vSFFWlMZJF4Wsf0xiGRKw==
X-Received: by 2002:a63:c03:: with SMTP id b3mr20765485pgl.23.1566226966877;
        Mon, 19 Aug 2019 08:02:46 -0700 (PDT)
Received: from smtp.gmail.com ([2620:15c:202:1:fa53:7765:582b:82b9])
        by smtp.gmail.com with ESMTPSA id w2sm22773353pjr.27.2019.08.19.08.02.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Aug 2019 08:02:46 -0700 (PDT)
From:   Stephen Boyd <swboyd@chromium.org>
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     linux-kernel@vger.kernel.org, "Theodore Ts'o" <tytso@mit.edu>,
        linux-crypto@vger.kernel.org, Matt Mackall <mpm@selenic.com>,
        Keerthy <j-keerthy@ti.com>
Subject: [PATCH] random: Support freezable kthreads in add_hwgenerator_randomness()
Date:   Mon, 19 Aug 2019 08:02:45 -0700
Message-Id: <20190819150245.176587-1-swboyd@chromium.org>
X-Mailer: git-send-email 2.23.0.rc1.153.gdeed80330f-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

The kthread calling this function is freezable after commit 03a3bb7ae631
("hwrng: core - Freeze khwrng thread during suspend") is applied.
Unfortunately, this function uses wait_event_interruptible() but doesn't
check for the kthread being woken up by the fake freezer signal. When a
user suspends the system, this kthread will wake up and if it fails the
entropy size check it will immediately go back to sleep and not go into
the freezer. Eventually, suspend will fail because the task never froze
and a warning message like this may appear:

 PM: suspend entry (deep)
 Filesystems sync: 0.000 seconds
 Freezing user space processes ... (elapsed 0.001 seconds) done.
 OOM killer disabled.
 Freezing remaining freezable tasks ...
 Freezing of tasks failed after 20.003 seconds (1 tasks refusing to freeze, wq_busy=0):
 hwrng           R  running task        0   289      2 0x00000020
 [<c08c64c4>] (__schedule) from [<c08c6a10>] (schedule+0x3c/0xc0)
 [<c08c6a10>] (schedule) from [<c05dbd8c>] (add_hwgenerator_randomness+0xb0/0x100)
 [<c05dbd8c>] (add_hwgenerator_randomness) from [<bf1803c8>] (hwrng_fillfn+0xc0/0x14c [rng_core])
 [<bf1803c8>] (hwrng_fillfn [rng_core]) from [<c015abec>] (kthread+0x134/0x148)
 [<c015abec>] (kthread) from [<c01010e8>] (ret_from_fork+0x14/0x2c)

Check for a freezer signal here and skip adding any randomness if the
task wakes up because it was frozen. This should make the kthread freeze
properly and suspend work again.

Fixes: 03a3bb7ae631 ("hwrng: core - Freeze khwrng thread during suspend")
Reported-by: Keerthy <j-keerthy@ti.com>
Tested-by: Keerthy <j-keerthy@ti.com>
Signed-off-by: Stephen Boyd <swboyd@chromium.org>
---

Probably needs to go via Herbert who routed the patch this is fixing.

 drivers/char/random.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/drivers/char/random.c b/drivers/char/random.c
index 5d5ea4ce1442..e2e85ca16410 100644
--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -2429,6 +2429,7 @@ void add_hwgenerator_randomness(const char *buffer, size_t count,
 				size_t entropy)
 {
 	struct entropy_store *poolp = &input_pool;
+	bool frozen = false;
 
 	if (unlikely(crng_init == 0)) {
 		crng_fast_load(buffer, count);
@@ -2439,9 +2440,12 @@ void add_hwgenerator_randomness(const char *buffer, size_t count,
 	 * We'll be woken up again once below random_write_wakeup_thresh,
 	 * or when the calling thread is about to terminate.
 	 */
-	wait_event_interruptible(random_write_wait, kthread_should_stop() ||
+	wait_event_interruptible(random_write_wait,
+			kthread_freezable_should_stop(&frozen) ||
 			ENTROPY_BITS(&input_pool) <= random_write_wakeup_bits);
-	mix_pool_bytes(poolp, buffer, count);
-	credit_entropy_bits(poolp, entropy);
+	if (!frozen) {
+		mix_pool_bytes(poolp, buffer, count);
+		credit_entropy_bits(poolp, entropy);
+	}
 }
 EXPORT_SYMBOL_GPL(add_hwgenerator_randomness);
-- 
Sent by a computer through tubes

