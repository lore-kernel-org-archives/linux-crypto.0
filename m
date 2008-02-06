From: Patrick McHardy <kaber@trash.net>
Subject: [HIFN]: Fix invalid config ifdefs for RNG support
Date: Wed, 06 Feb 2008 14:57:57 +0100
Message-ID: <47A9BCE5.5080307@trash.net>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------050709050106020504070004"
Cc: linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:54823 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752027AbYBFN6A (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 6 Feb 2008 08:58:00 -0500
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

This is a multi-part message in MIME format.
--------------050709050106020504070004
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit


--------------050709050106020504070004
Content-Type: text/plain;
 name="x"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="x"

commit 3810a091ff8bc9b5038647a4b32a08267284f3f9
Author: Patrick McHardy <kaber@gw.localnet>
Date:   Wed Feb 6 14:56:09 2008 +0100

    [HIFN]: Fix invalid config ifdefs for RNG support
    
    The CRYPTO_DEV_HIFN_795X_RNG ifdefs are missing the CONFIG_ prefix.
    
    Signed-off-by: Patrick McHardy <kaber@trash.net>

diff --git a/drivers/crypto/hifn_795x.c b/drivers/crypto/hifn_795x.c
index dfbf24c..3110bf7 100644
--- a/drivers/crypto/hifn_795x.c
+++ b/drivers/crypto/hifn_795x.c
@@ -463,7 +463,7 @@ struct hifn_device
 
 	unsigned int		pk_clk_freq;
 
-#ifdef CRYPTO_DEV_HIFN_795X_RNG
+#ifdef CONFIG_CRYPTO_DEV_HIFN_795X_RNG
 	unsigned int		rng_wait_time;
 	ktime_t			rngtime;
 	struct hwrng		rng;
@@ -795,7 +795,7 @@ static struct pci2id {
 	}
 };
 
-#ifdef CRYPTO_DEV_HIFN_795X_RNG
+#ifdef CONFIG_CRYPTO_DEV_HIFN_795X_RNG
 static int hifn_rng_data_present(struct hwrng *rng, int wait)
 {
 	struct hifn_device *dev = (struct hifn_device *)rng->priv;
@@ -880,7 +880,7 @@ static int hifn_init_pubrng(struct hifn_device *dev)
 	dprintk("Chip %s: RNG engine has been successfully initialised.\n",
 			dev->name);
 
-#ifdef CRYPTO_DEV_HIFN_795X_RNG
+#ifdef CONFIG_CRYPTO_DEV_HIFN_795X_RNG
 	/* First value must be discarded */
 	hifn_read_1(dev, HIFN_1_RNG_DATA);
 	dev->rngtime = ktime_get();

--------------050709050106020504070004--
