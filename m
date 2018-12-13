Return-Path: <SRS0=KZld=OW=vger.kernel.org=linux-crypto-owner@kernel.org>
Received: from mail-pg1-f194.google.com ([209.85.215.194]:37293 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727343AbeLMIkf (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 13 Dec 2018 03:40:35 -0500
Received: by mail-pg1-f194.google.com with SMTP id 80so726604pge.4
        for <linux-crypto@vger.kernel.org>; Thu, 13 Dec 2018 00:40:34 -0800 (PST)
From: Louis Collard <louiscollard@chromium.org>
To: linux-crypto@vger.kernel.org
Cc: Matt Mackall <mpm@selenic.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Gary R Hook <gary.hook@amd.com>, Michael Buesch <m@bues.ch>,
        PrasannaKumar Muralidharan <prasannatsmkumar@gmail.com>,
        Louis Collard <louiscollard@chromium.org>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        linux-kernel@vger.kernel.org, apronin@chromium.org,
        jarkko.sakkinen@linux.intel.com, linux@mniewoehner.de,
        david.bild@xaptum.com
Subject: [RESEND PATCH] Allow hwrng to initialize crng.
Date: Thu, 13 Dec 2018 16:40:17 +0800
Message-Id: <20181213084017.80850-1-louiscollard@chromium.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Some systems, for example embedded systems, do not generate
enough entropy on boot through interrupts, and boot may be blocked for
several minutes waiting for a call to getrandom to complete.

Currently, random data is read from a hwrng when it is registered,
and is loaded into primary_crng. This data is treated in the same
way as data that is device-specific but otherwise unchanging, and
so primary_crng cannot become initialized with the data from the
hwrng.

This change causes the data initially read from the hwrng to be
treated the same as subsequent data that is read from the hwrng if
it's quality score is non-zero.

The implications of this are:

The data read from hwrng can cause primary_crng to become
initialized, therefore avoiding problems of getrandom blocking
on boot.

Calls to getrandom (with GRND_RANDOM) may be using entropy
exclusively (or in practise, almost exclusively) from the hwrng.

Regarding the latter point; this behavior is the same as if a
user specified a quality score of 1 (bit of entropy per 1024 bits)
so hopefully this is not too scary a change to make.

This change is the result of the discussion here:
https://patchwork.kernel.org/patch/10453893/

Signed-off-by: Louis Collard <louiscollard@chromium.org>
Acked-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
---
 drivers/char/hw_random/core.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/char/hw_random/core.c b/drivers/char/hw_random/core.c
index 95be7228f327..99c3e4127949 100644
--- a/drivers/char/hw_random/core.c
+++ b/drivers/char/hw_random/core.c
@@ -24,6 +24,7 @@
 #include <linux/sched.h>
 #include <linux/slab.h>
 #include <linux/uaccess.h>
+#include <crypto/chacha20.h>
 
 #define RNG_MODULE_NAME		"hw_random"
 
@@ -64,13 +65,17 @@ static size_t rng_buffer_size(void)
 static void add_early_randomness(struct hwrng *rng)
 {
 	int bytes_read;
-	size_t size = min_t(size_t, 16, rng_buffer_size());
+	/* Read enough to initialize crng. */
+	size_t size = 2*CHACHA20_KEY_SIZE;
 
 	mutex_lock(&reading_mutex);
 	bytes_read = rng_get_data(rng, rng_buffer, size, 1);
 	mutex_unlock(&reading_mutex);
 	if (bytes_read > 0)
-		add_device_randomness(rng_buffer, bytes_read);
+		/* Allow crng to become initialized, but do not add
+		 * entropy to the pool.
+		 */
+		add_hwgenerator_randomness(rng_buffer, bytes_read, 0);
 }
 
 static inline void cleanup_rng(struct kref *kref)
-- 
2.13.5
