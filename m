Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3321CC433EF
	for <linux-crypto@archiver.kernel.org>; Tue,  3 May 2022 12:18:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232146AbiECMWX (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 3 May 2022 08:22:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34212 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231719AbiECMWW (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 3 May 2022 08:22:22 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 58C5ADEF8
        for <linux-crypto@vger.kernel.org>; Tue,  3 May 2022 05:18:50 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BF193B81D9E
        for <linux-crypto@vger.kernel.org>; Tue,  3 May 2022 12:18:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A825C385A9;
        Tue,  3 May 2022 12:18:47 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
        dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="Ca7Xuehc"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
        t=1651580324;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=7FDALlYNPhdRDQWwYICOtMs1YQ71mosXOR2frwFV/+M=;
        b=Ca7Xuehcu5tRKR/UBYvqdi9nfJhWdc47eSEUu76mWOA3cRqDgMqqvG9xPWa7BaC5mtrjr+
        xpq/MU5IWdILXeEoQ4DP6+EmC6bxmdfbVnXkjl54ob+dYgABJRwxkh4OB8O8KOjV52jFcg
        T+4BAsiso3cjw15osqiH2Oils9Gm6s0=
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 33b99bca (TLSv1.3:AEAD-AES256-GCM-SHA384:256:NO);
        Tue, 3 May 2022 12:18:44 +0000 (UTC)
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
To:     linux-kernel@vger.kernel, linux-crypto@vger.kernel.org
Cc:     "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Theodore Ts'o <tytso@mit.edu>,
        Dominik Brodowski <linux@dominikbrodowski.net>
Subject: [PATCH] random: do not use batches when !crng_ready()
Date:   Tue,  3 May 2022 14:18:36 +0200
Message-Id: <20220503121836.522258-1-Jason@zx2c4.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

It's too hard to keep the batches synchronized, and pointless anyway,
since in !crng_ready(), we're updating the base_crng key really often,
where batching only hurts. So instead, if the crng isn't ready, just
call into get_random_bytes(). At this stage nothing is performance
critical anyhow.

Cc: Theodore Ts'o <tytso@mit.edu>
Cc: Dominik Brodowski <linux@dominikbrodowski.net>
Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
---
 drivers/char/random.c | 15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

diff --git a/drivers/char/random.c b/drivers/char/random.c
index 346c9b16a7f1..53b8237687ed 100644
--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -610,6 +610,11 @@ u64 get_random_u64(void)
 
 	warn_unseeded_randomness(&previous);
 
+	if  (!crng_ready()) {
+		_get_random_bytes(&ret, sizeof(ret));
+		return ret;
+	}
+
 	local_lock_irqsave(&batched_entropy_u64.lock, flags);
 	batch = raw_cpu_ptr(&batched_entropy_u64);
 
@@ -644,6 +649,11 @@ u32 get_random_u32(void)
 
 	warn_unseeded_randomness(&previous);
 
+	if  (!crng_ready()) {
+		_get_random_bytes(&ret, sizeof(ret));
+		return ret;
+	}
+
 	local_lock_irqsave(&batched_entropy_u32.lock, flags);
 	batch = raw_cpu_ptr(&batched_entropy_u32);
 
@@ -820,10 +830,8 @@ static void credit_entropy_bits(size_t nbits)
 
 	if (unlikely(crng_init == 0 && entropy_count >= POOL_FAST_INIT_BITS)) {
 		spin_lock_irqsave(&base_crng.lock, flags);
-		if (crng_init == 0) {
-			++base_crng.generation;
+		if (crng_init == 0)
 			crng_init = 1;
-		}
 		spin_unlock_irqrestore(&base_crng.lock, flags);
 	}
 
@@ -1029,7 +1037,6 @@ int __init rand_initialize(void)
 	_mix_pool_bytes(utsname(), sizeof(*(utsname())));
 
 	extract_entropy(base_crng.key, sizeof(base_crng.key));
-	++base_crng.generation;
 
 	if (arch_init && trust_cpu && !crng_ready()) {
 		crng_init = 2;
-- 
2.35.1

