Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 78ECCC433FE
	for <linux-crypto@archiver.kernel.org>; Mon,  7 Nov 2022 12:25:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232123AbiKGMZV (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 7 Nov 2022 07:25:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232132AbiKGMZI (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 7 Nov 2022 07:25:08 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 221AD1B7B1
        for <linux-crypto@vger.kernel.org>; Mon,  7 Nov 2022 04:25:07 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9421160FD2
        for <linux-crypto@vger.kernel.org>; Mon,  7 Nov 2022 12:25:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8CDE0C433D6;
        Mon,  7 Nov 2022 12:25:05 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
        dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="RYXWd3r0"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
        t=1667823902;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=sK2R0nqhp8olboj9mHSV6fxtSecndvhpcB6l9xQGhg0=;
        b=RYXWd3r0dKM4srv7hn2jBX4Ps2Al4YI1jwqp1Co2tpynzeRZMErmSmecK/DHPf2TGHmjLR
        1bXoAXUHHu2VH8Q6xSbYU25tWP/x2aWVkcvCbM9knQm/0CgTjknnKcp8J10C1LTWFi/bfl
        46PjcLeUTuKfmnILEkDgf7L5X1/oNpM=
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 457d2d40 (TLSv1.3:TLS_AES_256_GCM_SHA384:256:NO);
        Mon, 7 Nov 2022 12:25:02 +0000 (UTC)
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
To:     herbert@gondor.apana.org.au, linux-crypto@vger.kernel.org
Cc:     "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Dominik Brodowski <linux@dominikbrodowski.net>,
        Ard Biesheuvel <ardb@kernel.org>
Subject: [PATCH v2] hw_random: treat default_quality as a maximum and default to 1024
Date:   Mon,  7 Nov 2022 13:24:55 +0100
Message-Id: <20221107122455.6169-1-Jason@zx2c4.com>
In-Reply-To: <CAHmME9pjWNGaF+4+ubFuu1AXhRkEbU7mxT-RtOhWVYkAgxXiDg@mail.gmail.com>
References: <CAHmME9pjWNGaF+4+ubFuu1AXhRkEbU7mxT-RtOhWVYkAgxXiDg@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Most hw_random devices return entropy which is assumed to be of full
quality, but driver authors don't bother setting the quality knob. Some
hw_random devices return less than full quality entropy, and then driver
authors set the quality knob. Therefore, the entropy crediting should be
opt-out rather than opt-in per-driver, to reflect the actual reality on
the ground.

For example, the two Raspberry Pi RNG drivers produce full entropy
randomness, and both EDK2 and U-Boot's drivers for these treat them as
such. The result is that EFI then uses these numbers and passes the to
Linux, and Linux credits them as boot, thereby initializing the RNG.
Yet, in Linux, the quality knob was never set to anything, and so on the
chance that Linux is booted without EFI, nothing is ever credited.
That's annoying.

The same pattern appears to repeat itself throughout various drivers. In
fact, very very few drivers have bothered setting quality=1024.

Looking at the git history of existing drivers and corresponding mailing
list discussion, this conclusion tracks. There's been a decent amount of
discussion about drivers that set quality < 1024 -- somebody read and
interepreted a datasheet, or made some back of the envelope calculation
somehow. But there's been very little, if any, discussion about most
drivers where the quality is just set to 1024 or unset (or set to 1000
when the authors misunderstood the API and assumed it was base-10 rather
than base-2); in both cases the intent was fairly clear of, "this is a
hardware random device; it's fine."

So let's invert this logic. A hw_random struct's quality knob now
controls the maximum quality a driver can produce, or 0 to specify 1024.
Then, the module-wide switch called "default_quality" is changed to
represent the maximum quality of any driver. By default it's 1024, and
the quality of any particular driver is then given by:

    min(default_quality, rng->quality ?: 1024);

This way, the user can still turn this off for weird reasons (and we can
replace whatever driver-specific disabling hacks existed in the past),
yet we get proper crediting for relevant RNGs.

Cc: Dominik Brodowski <linux@dominikbrodowski.net>
Cc: Ard Biesheuvel <ardb@kernel.org>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
---
Changes v1->v2:
- Expand commit message a bit.
- Account for erroneous quality=1000 and quirky devices too.

 arch/um/drivers/random.c                          | 1 -
 drivers/char/hw_random/cavium-rng-vf.c            | 1 -
 drivers/char/hw_random/cn10k-rng.c                | 1 -
 drivers/char/hw_random/core.c                     | 9 +++------
 drivers/char/hw_random/mpfs-rng.c                 | 1 -
 drivers/char/hw_random/npcm-rng.c                 | 1 -
 drivers/char/hw_random/s390-trng.c                | 1 -
 drivers/char/hw_random/timeriomem-rng.c           | 2 --
 drivers/char/hw_random/virtio-rng.c               | 1 -
 drivers/crypto/allwinner/sun8i-ce/sun8i-ce-trng.c | 1 -
 drivers/crypto/atmel-sha204a.c                    | 1 -
 drivers/crypto/caam/caamrng.c                     | 1 -
 drivers/firmware/turris-mox-rwtm.c                | 1 -
 drivers/s390/crypto/zcrypt_api.c                  | 6 ------
 drivers/usb/misc/chaoskey.c                       | 1 -
 include/linux/hw_random.h                         | 2 +-
 16 files changed, 4 insertions(+), 27 deletions(-)

diff --git a/arch/um/drivers/random.c b/arch/um/drivers/random.c
index 32b3341fe970..da985e0dc69a 100644
--- a/arch/um/drivers/random.c
+++ b/arch/um/drivers/random.c
@@ -82,7 +82,6 @@ static int __init rng_init (void)
 	sigio_broken(random_fd);
 	hwrng.name = RNG_MODULE_NAME;
 	hwrng.read = rng_dev_read;
-	hwrng.quality = 1024;
 
 	err = hwrng_register(&hwrng);
 	if (err) {
diff --git a/drivers/char/hw_random/cavium-rng-vf.c b/drivers/char/hw_random/cavium-rng-vf.c
index 7c55f4cf4a8b..c99c54cd99c6 100644
--- a/drivers/char/hw_random/cavium-rng-vf.c
+++ b/drivers/char/hw_random/cavium-rng-vf.c
@@ -225,7 +225,6 @@ static int cavium_rng_probe_vf(struct	pci_dev		*pdev,
 		return -ENOMEM;
 
 	rng->ops.read    = cavium_rng_read;
-	rng->ops.quality = 1000;
 
 	pci_set_drvdata(pdev, rng);
 
diff --git a/drivers/char/hw_random/cn10k-rng.c b/drivers/char/hw_random/cn10k-rng.c
index a01e9307737c..c1193f85982c 100644
--- a/drivers/char/hw_random/cn10k-rng.c
+++ b/drivers/char/hw_random/cn10k-rng.c
@@ -145,7 +145,6 @@ static int cn10k_rng_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 		return -ENOMEM;
 
 	rng->ops.read    = cn10k_rng_read;
-	rng->ops.quality = 1000;
 	rng->ops.priv = (unsigned long)rng;
 
 	reset_rng_health_state(rng);
diff --git a/drivers/char/hw_random/core.c b/drivers/char/hw_random/core.c
index 63a0a8e4505d..f34d356fe2c0 100644
--- a/drivers/char/hw_random/core.c
+++ b/drivers/char/hw_random/core.c
@@ -41,14 +41,14 @@ static DEFINE_MUTEX(reading_mutex);
 static int data_avail;
 static u8 *rng_buffer, *rng_fillbuf;
 static unsigned short current_quality;
-static unsigned short default_quality; /* = 0; default to "off" */
+static unsigned short default_quality = 1024; /* default to maximum */
 
 module_param(current_quality, ushort, 0644);
 MODULE_PARM_DESC(current_quality,
 		 "current hwrng entropy estimation per 1024 bits of input -- obsolete, use rng_quality instead");
 module_param(default_quality, ushort, 0644);
 MODULE_PARM_DESC(default_quality,
-		 "default entropy content of hwrng per 1024 bits of input");
+		 "default maximum entropy content of hwrng per 1024 bits of input");
 
 static void drop_current_rng(void);
 static int hwrng_init(struct hwrng *rng);
@@ -172,10 +172,7 @@ static int hwrng_init(struct hwrng *rng)
 	reinit_completion(&rng->cleanup_done);
 
 skip_init:
-	if (!rng->quality)
-		rng->quality = default_quality;
-	if (rng->quality > 1024)
-		rng->quality = 1024;
+	rng->quality = min_t(u16, min_t(u16, default_quality, 1024), rng->quality ?: 1024);
 	current_quality = rng->quality; /* obsolete */
 
 	return 0;
diff --git a/drivers/char/hw_random/mpfs-rng.c b/drivers/char/hw_random/mpfs-rng.c
index 5813da617a48..c6972734ae62 100644
--- a/drivers/char/hw_random/mpfs-rng.c
+++ b/drivers/char/hw_random/mpfs-rng.c
@@ -78,7 +78,6 @@ static int mpfs_rng_probe(struct platform_device *pdev)
 
 	rng_priv->rng.read = mpfs_rng_read;
 	rng_priv->rng.name = pdev->name;
-	rng_priv->rng.quality = 1024;
 
 	platform_set_drvdata(pdev, rng_priv);
 
diff --git a/drivers/char/hw_random/npcm-rng.c b/drivers/char/hw_random/npcm-rng.c
index 1ec5f267a656..4ec3e936b543 100644
--- a/drivers/char/hw_random/npcm-rng.c
+++ b/drivers/char/hw_random/npcm-rng.c
@@ -109,7 +109,6 @@ static int npcm_rng_probe(struct platform_device *pdev)
 	priv->rng.name = pdev->name;
 	priv->rng.read = npcm_rng_read;
 	priv->rng.priv = (unsigned long)&pdev->dev;
-	priv->rng.quality = 1000;
 
 	writel(NPCM_RNG_M1ROSEL, priv->base + NPCM_RNGMODE_REG);
 
diff --git a/drivers/char/hw_random/s390-trng.c b/drivers/char/hw_random/s390-trng.c
index 795853dfc46b..cffa326ddc8d 100644
--- a/drivers/char/hw_random/s390-trng.c
+++ b/drivers/char/hw_random/s390-trng.c
@@ -191,7 +191,6 @@ static struct hwrng trng_hwrng_dev = {
 	.name		= "s390-trng",
 	.data_read	= trng_hwrng_data_read,
 	.read		= trng_hwrng_read,
-	.quality	= 1024,
 };
 
 
diff --git a/drivers/char/hw_random/timeriomem-rng.c b/drivers/char/hw_random/timeriomem-rng.c
index 8ea1fc831eb7..26f322d19a88 100644
--- a/drivers/char/hw_random/timeriomem-rng.c
+++ b/drivers/char/hw_random/timeriomem-rng.c
@@ -145,8 +145,6 @@ static int timeriomem_rng_probe(struct platform_device *pdev)
 		if (!of_property_read_u32(pdev->dev.of_node,
 						"quality", &i))
 			priv->rng_ops.quality = i;
-		else
-			priv->rng_ops.quality = 0;
 	} else {
 		period = pdata->period;
 		priv->rng_ops.quality = pdata->quality;
diff --git a/drivers/char/hw_random/virtio-rng.c b/drivers/char/hw_random/virtio-rng.c
index a6f3a8a2aca6..f7690e0f92ed 100644
--- a/drivers/char/hw_random/virtio-rng.c
+++ b/drivers/char/hw_random/virtio-rng.c
@@ -148,7 +148,6 @@ static int probe_common(struct virtio_device *vdev)
 		.cleanup = virtio_cleanup,
 		.priv = (unsigned long)vi,
 		.name = vi->name,
-		.quality = 1000,
 	};
 	vdev->priv = vi;
 
diff --git a/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-trng.c b/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-trng.c
index c4b0a8b58842..e2b9b9104694 100644
--- a/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-trng.c
+++ b/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-trng.c
@@ -108,7 +108,6 @@ int sun8i_ce_hwrng_register(struct sun8i_ce_dev *ce)
 	}
 	ce->trng.name = "sun8i Crypto Engine TRNG";
 	ce->trng.read = sun8i_ce_trng_read;
-	ce->trng.quality = 1000;
 
 	ret = hwrng_register(&ce->trng);
 	if (ret)
diff --git a/drivers/crypto/atmel-sha204a.c b/drivers/crypto/atmel-sha204a.c
index a84b657598c6..c0103e7fc2e7 100644
--- a/drivers/crypto/atmel-sha204a.c
+++ b/drivers/crypto/atmel-sha204a.c
@@ -107,7 +107,6 @@ static int atmel_sha204a_probe(struct i2c_client *client,
 
 	i2c_priv->hwrng.name = dev_name(&client->dev);
 	i2c_priv->hwrng.read = atmel_sha204a_rng_read;
-	i2c_priv->hwrng.quality = 1024;
 
 	ret = devm_hwrng_register(&client->dev, &i2c_priv->hwrng);
 	if (ret)
diff --git a/drivers/crypto/caam/caamrng.c b/drivers/crypto/caam/caamrng.c
index 77d048dfe5d0..1f0e82050976 100644
--- a/drivers/crypto/caam/caamrng.c
+++ b/drivers/crypto/caam/caamrng.c
@@ -246,7 +246,6 @@ int caam_rng_init(struct device *ctrldev)
 	ctx->rng.cleanup = caam_cleanup;
 	ctx->rng.read    = caam_read;
 	ctx->rng.priv    = (unsigned long)ctx;
-	ctx->rng.quality = 1024;
 
 	dev_info(ctrldev, "registering rng-caam\n");
 
diff --git a/drivers/firmware/turris-mox-rwtm.c b/drivers/firmware/turris-mox-rwtm.c
index c2d34dc8ba46..6ea5789a89e2 100644
--- a/drivers/firmware/turris-mox-rwtm.c
+++ b/drivers/firmware/turris-mox-rwtm.c
@@ -528,7 +528,6 @@ static int turris_mox_rwtm_probe(struct platform_device *pdev)
 	rwtm->hwrng.name = DRIVER_NAME "_hwrng";
 	rwtm->hwrng.read = mox_hwrng_read;
 	rwtm->hwrng.priv = (unsigned long) rwtm;
-	rwtm->hwrng.quality = 1024;
 
 	ret = devm_hwrng_register(dev, &rwtm->hwrng);
 	if (ret < 0) {
diff --git a/drivers/s390/crypto/zcrypt_api.c b/drivers/s390/crypto/zcrypt_api.c
index f94b43ce9a65..4bf36e53fe3e 100644
--- a/drivers/s390/crypto/zcrypt_api.c
+++ b/drivers/s390/crypto/zcrypt_api.c
@@ -53,10 +53,6 @@ MODULE_LICENSE("GPL");
 EXPORT_TRACEPOINT_SYMBOL(s390_zcrypt_req);
 EXPORT_TRACEPOINT_SYMBOL(s390_zcrypt_rep);
 
-static int zcrypt_hwrng_seed = 1;
-module_param_named(hwrng_seed, zcrypt_hwrng_seed, int, 0440);
-MODULE_PARM_DESC(hwrng_seed, "Turn on/off hwrng auto seed, default is 1 (on).");
-
 DEFINE_SPINLOCK(zcrypt_list_lock);
 LIST_HEAD(zcrypt_card_list);
 
@@ -2063,8 +2059,6 @@ int zcrypt_rng_device_add(void)
 			goto out;
 		}
 		zcrypt_rng_buffer_index = 0;
-		if (!zcrypt_hwrng_seed)
-			zcrypt_rng_dev.quality = 0;
 		rc = hwrng_register(&zcrypt_rng_dev);
 		if (rc)
 			goto out_free;
diff --git a/drivers/usb/misc/chaoskey.c b/drivers/usb/misc/chaoskey.c
index 87067c3d6109..6fb5140e29b9 100644
--- a/drivers/usb/misc/chaoskey.c
+++ b/drivers/usb/misc/chaoskey.c
@@ -200,7 +200,6 @@ static int chaoskey_probe(struct usb_interface *interface,
 
 	dev->hwrng.name = dev->name ? dev->name : chaoskey_driver.name;
 	dev->hwrng.read = chaoskey_rng_read;
-	dev->hwrng.quality = 1024;
 
 	dev->hwrng_registered = (hwrng_register(&dev->hwrng) == 0);
 	if (!dev->hwrng_registered)
diff --git a/include/linux/hw_random.h b/include/linux/hw_random.h
index 77c2885c4c13..8a3115516a1b 100644
--- a/include/linux/hw_random.h
+++ b/include/linux/hw_random.h
@@ -34,7 +34,7 @@
  * @priv:		Private data, for use by the RNG driver.
  * @quality:		Estimation of true entropy in RNG's bitstream
  *			(in bits of entropy per 1024 bits of input;
- *			valid values: 1 to 1024, or 0 for unknown).
+ *			valid values: 1 to 1024, or 0 for maximum).
  */
 struct hwrng {
 	const char *name;
-- 
2.38.1

