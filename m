Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6E4C5C4332F
	for <linux-crypto@archiver.kernel.org>; Sat,  5 Nov 2022 20:44:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229517AbiKEUoZ (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 5 Nov 2022 16:44:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229479AbiKEUoZ (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 5 Nov 2022 16:44:25 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 64D13E0F2
        for <linux-crypto@vger.kernel.org>; Sat,  5 Nov 2022 13:44:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E35F460B97
        for <linux-crypto@vger.kernel.org>; Sat,  5 Nov 2022 20:44:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB346C433D6;
        Sat,  5 Nov 2022 20:44:22 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
        dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="F0RKbDv0"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
        t=1667681060;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=znuX4ysjKgHs+5ugNojvf7s4WgKzUG5UmonkOsznGCw=;
        b=F0RKbDv0TU77lzWJdb7DejrFTgXswFouZ7MNaRK0c9rqOD+hukgY1Qsi48sUTfZR8BKY/B
        a1OSMAEmrAZNf7TvmlC+XSHnk0J/kSJlt1yjdkscnrcOmaIIFeGZsyMpNuD90MPmYgX3f/
        dY0NLbtrNkYIozI979581Gl55yHoZ+E=
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 2e7be018 (TLSv1.3:TLS_AES_256_GCM_SHA384:256:NO);
        Sat, 5 Nov 2022 20:44:19 +0000 (UTC)
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
To:     herbert@gondor.apana.org.au, linux-crypto@vger.kernel.org
Cc:     "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: [PATCH] hw_random: use add_hwgenerator_randomness() for early entropy
Date:   Sat,  5 Nov 2022 21:44:17 +0100
Message-Id: <20221105204417.137001-1-Jason@zx2c4.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Rather than calling add_device_randomness(), the add_early_randomness()
function should use add_hwgenerator_randomness(), so that the early
entropy can be potentially credited, which allows for the RNG to
initialize earlier without having to wait for the kthread to come up.

Cc: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
---
 drivers/char/hw_random/core.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/char/hw_random/core.c b/drivers/char/hw_random/core.c
index cc002b0c2f0c..8c0819ce2781 100644
--- a/drivers/char/hw_random/core.c
+++ b/drivers/char/hw_random/core.c
@@ -69,8 +69,10 @@ static void add_early_randomness(struct hwrng *rng)
 	mutex_lock(&reading_mutex);
 	bytes_read = rng_get_data(rng, rng_fillbuf, 32, 0);
 	mutex_unlock(&reading_mutex);
-	if (bytes_read > 0)
-		add_device_randomness(rng_fillbuf, bytes_read);
+	if (bytes_read > 0) {
+		size_t entropy = bytes_read * 8 * rng->quality / 1024;
+		add_hwgenerator_randomness(rng_fillbuf, bytes_read, entropy);
+	}
 }
 
 static inline void cleanup_rng(struct kref *kref)
-- 
2.38.1

