Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 74B46C4332F
	for <linux-crypto@archiver.kernel.org>; Sun,  6 Nov 2022 01:50:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229551AbiKFBu4 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 5 Nov 2022 21:50:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229499AbiKFBuz (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 5 Nov 2022 21:50:55 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5A85FD16
        for <linux-crypto@vger.kernel.org>; Sat,  5 Nov 2022 18:50:53 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2C6F960BBD
        for <linux-crypto@vger.kernel.org>; Sun,  6 Nov 2022 01:50:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 04FA4C433D6;
        Sun,  6 Nov 2022 01:50:51 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
        dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="pVWUYX+K"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
        t=1667699450;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Cj96hh536vMSLqCrxoCX0QYlQHL3Z+DGdVEXRAKhCPg=;
        b=pVWUYX+KWddejhslUTVP9eMhRo/SobW9mnqHzLImF18Y2d/fkz2ZdwxGQiOVfSV1CEI3Iw
        vMwlRBAD8zycMdQruTRV+/WnxbD/UIu69vABqhYZSHKVpKUOcH4cZliPj00Zg9MVZ9JUiZ
        oFdgpMtpzPXj4s8DgYJWUhyGHCrQnvw=
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id cfe48899 (TLSv1.3:TLS_AES_256_GCM_SHA384:256:NO);
        Sun, 6 Nov 2022 01:50:49 +0000 (UTC)
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
To:     herbert@gondor.apana.org.au, linux-crypto@vger.kernel.org
Cc:     "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: [PATCH v2] hw_random: use add_hwgenerator_randomness() for early entropy
Date:   Sun,  6 Nov 2022 02:50:42 +0100
Message-Id: <20221106015042.98538-1-Jason@zx2c4.com>
In-Reply-To: <CAHmME9r=xGdYa1n16TTgdfvzLkc==hGr+1v3eZmyzpEX+437uw@mail.gmail.com>
References: <CAHmME9r=xGdYa1n16TTgdfvzLkc==hGr+1v3eZmyzpEX+437uw@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Rather than calling add_device_randomness(), the add_early_randomness()
function should use add_hwgenerator_randomness(), so that the early
entropy can be potentially credited, which allows for the RNG to
initialize earlier without having to wait for the kthread to come up.

Since we don't want to sleep from add_early_randomness(), we also
refactor the API a bit so that hw_random/core.c can do the sleep, this
time using the correct function, hwrng_msleep, rather than having
random.c awkwardly do it.

Cc: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
---
 drivers/char/hw_random/core.c | 13 +++++++++----
 drivers/char/random.c         |  9 +++++----
 include/linux/random.h        |  2 +-
 3 files changed, 15 insertions(+), 9 deletions(-)

diff --git a/drivers/char/hw_random/core.c b/drivers/char/hw_random/core.c
index cc002b0c2f0c..f6bbe0d8b95d 100644
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
@@ -499,6 +501,7 @@ static int hwrng_fillfn(void *unused)
 	while (!kthread_should_stop()) {
 		unsigned short quality;
 		struct hwrng *rng;
+		unsigned long sleep;
 
 		rng = get_current_rng();
 		if (IS_ERR(rng) || !rng)
@@ -527,8 +530,10 @@ static int hwrng_fillfn(void *unused)
 			entropy_credit = entropy;
 
 		/* Outside lock, sure, but y'know: randomness. */
-		add_hwgenerator_randomness((void *)rng_fillbuf, rc,
-					   entropy >> 10);
+		sleep = add_hwgenerator_randomness((void *)rng_fillbuf, rc,
+						   entropy >> 10);
+		if (sleep)
+			hwrng_msleep(rng, jiffies_to_msecs(sleep));
 	}
 	hwrng_fill = NULL;
 	return 0;
diff --git a/drivers/char/random.c b/drivers/char/random.c
index 4591d55cb135..16ee170151a9 100644
--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -893,9 +893,9 @@ EXPORT_SYMBOL(add_device_randomness);
 /*
  * Interface for in-kernel drivers of true hardware RNGs.
  * Those devices may produce endless random bits and will be throttled
- * when our pool is full.
+ * when our pool is full. Returns suggested sleep time in jiffies.
  */
-void add_hwgenerator_randomness(const void *buf, size_t len, size_t entropy)
+unsigned long add_hwgenerator_randomness(const void *buf, size_t len, size_t entropy)
 {
 	mix_pool_bytes(buf, len);
 	credit_init_bits(entropy);
@@ -904,8 +904,9 @@ void add_hwgenerator_randomness(const void *buf, size_t len, size_t entropy)
 	 * Throttle writing to once every reseed interval, unless we're not yet
 	 * initialized or no entropy is credited.
 	 */
-	if (!kthread_should_stop() && (crng_ready() || !entropy))
-		schedule_timeout_interruptible(crng_reseed_interval());
+	if (crng_ready() || !entropy)
+		return crng_reseed_interval();
+	return 0;
 }
 EXPORT_SYMBOL_GPL(add_hwgenerator_randomness);
 
diff --git a/include/linux/random.h b/include/linux/random.h
index 2bdd3add3400..02ef65fc02c2 100644
--- a/include/linux/random.h
+++ b/include/linux/random.h
@@ -17,7 +17,7 @@ void __init add_bootloader_randomness(const void *buf, size_t len);
 void add_input_randomness(unsigned int type, unsigned int code,
 			  unsigned int value) __latent_entropy;
 void add_interrupt_randomness(int irq) __latent_entropy;
-void add_hwgenerator_randomness(const void *buf, size_t len, size_t entropy);
+unsigned long add_hwgenerator_randomness(const void *buf, size_t len, size_t entropy);
 
 #if defined(LATENT_ENTROPY_PLUGIN) && !defined(__CHECKER__)
 static inline void add_latent_entropy(void)
-- 
2.38.1

