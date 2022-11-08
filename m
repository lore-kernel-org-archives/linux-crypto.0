Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0D795C4332F
	for <linux-crypto@archiver.kernel.org>; Tue,  8 Nov 2022 11:25:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233856AbiKHLZ0 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 8 Nov 2022 06:25:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36072 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234100AbiKHLY4 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 8 Nov 2022 06:24:56 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF4884C259
        for <linux-crypto@vger.kernel.org>; Tue,  8 Nov 2022 03:24:51 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 46F1B6151B
        for <linux-crypto@vger.kernel.org>; Tue,  8 Nov 2022 11:24:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29320C433D7;
        Tue,  8 Nov 2022 11:24:50 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
        dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="Jb88upNS"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
        t=1667906687;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=eGOEvnfEDBwMlLvalqFBh9kapf8egqFgB8q1TSu5lwk=;
        b=Jb88upNSeYcKCTiCEi2rnBSZ7BG0fOKUobYolQVK0w8kLCXBOz23EFeeACXGJKir49GwnC
        xscFs+ukCe7fjp3QCUjKA3v5uKIVf1MseE2A5xe+8cWzgxtalSa5G1ozewilIBJ2CrDzKH
        hodMgS7ui+r97z3Hkxaccie/LNYwbb4=
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 61d0a669 (TLSv1.3:TLS_AES_256_GCM_SHA384:256:NO);
        Tue, 8 Nov 2022 11:24:47 +0000 (UTC)
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
To:     herbert@gondor.apana.org.au, linux-crypto@vger.kernel.org,
        AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@collabora.com>
Cc:     "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Dominik Brodowski <linux@dominikbrodowski.net>
Subject: [PATCH v4] hw_random: use add_hwgenerator_randomness() for early entropy
Date:   Tue,  8 Nov 2022 12:24:13 +0100
Message-Id: <20221108112413.199669-1-Jason@zx2c4.com>
In-Reply-To: <Y2o22ODqUZNO4NsR@zx2c4.com>
References: <Y2o22ODqUZNO4NsR@zx2c4.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Rather than calling add_device_randomness(), the add_early_randomness()
function should use add_hwgenerator_randomness(), so that the early
entropy can be potentially credited, which allows for the RNG to
initialize earlier without having to wait for the kthread to come up.

This requires some minor API refactoring, by adding a `sleep_after`
parameter to add_hwgenerator_randomness(), so that we don't hit a
blocking sleep from add_early_randomness().

Reviewed-by: Dominik Brodowski <linux@dominikbrodowski.net>
Acked-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
---
Changes v3->v4:
- Check `sleep_after` argument before calling `kthread_should_stop()` to
  avoid crash when not called from a kthread.

 drivers/char/hw_random/core.c |  8 +++++---
 drivers/char/random.c         | 12 ++++++------
 include/linux/random.h        |  2 +-
 3 files changed, 12 insertions(+), 10 deletions(-)

diff --git a/drivers/char/hw_random/core.c b/drivers/char/hw_random/core.c
index cc002b0c2f0c..63a0a8e4505d 100644
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
+		add_hwgenerator_randomness(rng_fillbuf, bytes_read, entropy, false);
+	}
 }
 
 static inline void cleanup_rng(struct kref *kref)
@@ -528,7 +530,7 @@ static int hwrng_fillfn(void *unused)
 
 		/* Outside lock, sure, but y'know: randomness. */
 		add_hwgenerator_randomness((void *)rng_fillbuf, rc,
-					   entropy >> 10);
+					   entropy >> 10, true);
 	}
 	hwrng_fill = NULL;
 	return 0;
diff --git a/drivers/char/random.c b/drivers/char/random.c
index 4591d55cb135..6b7aca683b81 100644
--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -711,7 +711,7 @@ static void __cold _credit_init_bits(size_t bits)
  * the above entropy accumulation routines:
  *
  *	void add_device_randomness(const void *buf, size_t len);
- *	void add_hwgenerator_randomness(const void *buf, size_t len, size_t entropy);
+ *	void add_hwgenerator_randomness(const void *buf, size_t len, size_t entropy, bool sleep_after);
  *	void add_bootloader_randomness(const void *buf, size_t len);
  *	void add_vmfork_randomness(const void *unique_vm_id, size_t len);
  *	void add_interrupt_randomness(int irq);
@@ -891,11 +891,11 @@ void add_device_randomness(const void *buf, size_t len)
 EXPORT_SYMBOL(add_device_randomness);
 
 /*
- * Interface for in-kernel drivers of true hardware RNGs.
- * Those devices may produce endless random bits and will be throttled
- * when our pool is full.
+ * Interface for in-kernel drivers of true hardware RNGs. Those devices
+ * may produce endless random bits, so this function will sleep for
+ * some amount of time after, if the sleep_after parameter is true.
  */
-void add_hwgenerator_randomness(const void *buf, size_t len, size_t entropy)
+void add_hwgenerator_randomness(const void *buf, size_t len, size_t entropy, bool sleep_after)
 {
 	mix_pool_bytes(buf, len);
 	credit_init_bits(entropy);
@@ -904,7 +904,7 @@ void add_hwgenerator_randomness(const void *buf, size_t len, size_t entropy)
 	 * Throttle writing to once every reseed interval, unless we're not yet
 	 * initialized or no entropy is credited.
 	 */
-	if (!kthread_should_stop() && (crng_ready() || !entropy))
+	if (sleep_after && !kthread_should_stop() && (crng_ready() || !entropy))
 		schedule_timeout_interruptible(crng_reseed_interval());
 }
 EXPORT_SYMBOL_GPL(add_hwgenerator_randomness);
diff --git a/include/linux/random.h b/include/linux/random.h
index 2bdd3add3400..728b29ade208 100644
--- a/include/linux/random.h
+++ b/include/linux/random.h
@@ -17,7 +17,7 @@ void __init add_bootloader_randomness(const void *buf, size_t len);
 void add_input_randomness(unsigned int type, unsigned int code,
 			  unsigned int value) __latent_entropy;
 void add_interrupt_randomness(int irq) __latent_entropy;
-void add_hwgenerator_randomness(const void *buf, size_t len, size_t entropy);
+void add_hwgenerator_randomness(const void *buf, size_t len, size_t entropy, bool sleep_after);
 
 #if defined(LATENT_ENTROPY_PLUGIN) && !defined(__CHECKER__)
 static inline void add_latent_entropy(void)
-- 
2.38.1

