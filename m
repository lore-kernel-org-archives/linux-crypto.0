From: Stephan Mueller <smueller@chronox.de>
Subject: [PATCH] hwrng: core - zeroize buffers with random data
Date: Sat, 22 Oct 2016 15:57:05 +0200
Message-ID: <5934786.pstHyKoYpf@positron.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: linux-crypto@vger.kernel.org, Andy Lutomirski <luto@amacapital.net>
To: herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:46282 "EHLO mail.eperm.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S934258AbcJVN5K (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 22 Oct 2016 09:57:10 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Herbert,

As requested by Andy, I have created the following patch. This patch is against the cryptodev-2.6 tree and applies cleanly. However, due to Andy's patch to Linus' tree, the patch will fail to apply to that tree.

How would you want to proceed? Do you want to pull Andy's patch into your cryptodev-2.6 tree which means I will rework the patch?

Thanks
Stephan

---8<---

The HWRNG core allocates two buffers during initialization which are
used to obtain random data. After that data is processed, it is now
zeroized as it is possible that the HWRNG core will not be asked to
produce more random data for a long time. This prevents leaving such
sensitive data in memory.

Signed-off-by: Stephan Mueller <smueller@chronox.de>
---
 drivers/char/hw_random/core.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/char/hw_random/core.c b/drivers/char/hw_random/core.c
index d2d2c89..f976641 100644
--- a/drivers/char/hw_random/core.c
+++ b/drivers/char/hw_random/core.c
@@ -92,6 +92,7 @@ static void add_early_randomness(struct hwrng *rng)
 	mutex_unlock(&reading_mutex);
 	if (bytes_read > 0)
 		add_device_randomness(rng_buffer, bytes_read);
+	memset(rng_buffer, 0, size);
 }
 
 static inline void cleanup_rng(struct kref *kref)
@@ -287,6 +288,7 @@ static ssize_t rng_dev_read(struct file *filp, char __user *buf,
 		}
 	}
 out:
+	memset(rng_buffer, 0, rng_buffer_size());
 	return ret ? : err;
 
 out_unlock_reading:
@@ -425,6 +427,7 @@ static int hwrng_fillfn(void *unused)
 		/* Outside lock, sure, but y'know: randomness. */
 		add_hwgenerator_randomness((void *)rng_fillbuf, rc,
 					   rc * current_quality * 8 >> 10);
+		memset(rng_fillbuf, 0, rng_buffer_size());
 	}
 	hwrng_fill = NULL;
 	return 0;
-- 
2.7.4
