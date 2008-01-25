From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [build bug] ./drivers/crypto/hifn_795x.c
Date: Sat, 26 Jan 2008 09:45:45 +1100
Message-ID: <20080125224545.GA1757@gondor.apana.org.au>
References: <20080125222150.GA22401@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-kernel@vger.kernel.org,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
	Evgeniy Polyakov <johnpol@2ka.mipt.ru>
To: Ingo Molnar <mingo@elte.hu>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:55590 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754440AbYAYWqS (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 25 Jan 2008 17:46:18 -0500
Content-Disposition: inline
In-Reply-To: <20080125222150.GA22401@elte.hu>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, Jan 25, 2008 at 11:21:50PM +0100, Ingo Molnar wrote:
> 
> randconfig testing found this (post-v2.6.24) build bug:
> 
>  drivers/built-in.o: In function `hifn_unregister_rng':
>  hifn_795x.c:(.text+0x17bbd9): undefined reference to `hwrng_unregister'
>  drivers/built-in.o: In function `hifn_probe':
>  hifn_795x.c:(.text+0x17df70): undefined reference to `hwrng_register'
> 
> config attached.

Thanks for the report.  This is casued by

> CONFIG_HW_RANDOM=m
> CONFIG_CRYPTO_DEV_HIFN_795X=y

I'll fix it with the following patch.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
--
diff --git a/drivers/crypto/Kconfig b/drivers/crypto/Kconfig
index 74bd599..8a70a9e 100644
--- a/drivers/crypto/Kconfig
+++ b/drivers/crypto/Kconfig
@@ -88,10 +88,16 @@ config CRYPTO_DEV_HIFN_795X
 	select CRYPTO_DES
 	select CRYPTO_ALGAPI
 	select CRYPTO_BLKCIPHER
+	select HW_RANDOM if CRYPTO_DEV_HIFN_795X_RNG
 	depends on PCI
 	help
 	  This option allows you to have support for HIFN 795x crypto adapters.
 
-
+config CRYPTO_DEV_HIFN_795X_RNG
+	bool "HIFN 795x random number generator"
+	depends on CRYPTO_DEV_HIFN_795X
+	help
+	  Select this option if you want to enable the random number generator
+	  on the HIFN 795x crypto adapters.
 
 endif # CRYPTO_HW
diff --git a/drivers/crypto/hifn_795x.c b/drivers/crypto/hifn_795x.c
index 16413e5..dfbf24c 100644
--- a/drivers/crypto/hifn_795x.c
+++ b/drivers/crypto/hifn_795x.c
@@ -463,7 +463,7 @@ struct hifn_device
 
 	unsigned int		pk_clk_freq;
 
-#if defined(CONFIG_HW_RANDOM) || defined(CONFIG_HW_RANDOM_MODULE)
+#ifdef CRYPTO_DEV_HIFN_795X_RNG
 	unsigned int		rng_wait_time;
 	ktime_t			rngtime;
 	struct hwrng		rng;
@@ -795,7 +795,7 @@ static struct pci2id {
 	}
 };
 
-#if defined(CONFIG_HW_RANDOM) || defined(CONFIG_HW_RANDOM_MODULE)
+#ifdef CRYPTO_DEV_HIFN_795X_RNG
 static int hifn_rng_data_present(struct hwrng *rng, int wait)
 {
 	struct hifn_device *dev = (struct hifn_device *)rng->priv;
@@ -880,7 +880,7 @@ static int hifn_init_pubrng(struct hifn_device *dev)
 	dprintk("Chip %s: RNG engine has been successfully initialised.\n",
 			dev->name);
 
-#if defined(CONFIG_HW_RANDOM) || defined(CONFIG_HW_RANDOM_MODULE)
+#ifdef CRYPTO_DEV_HIFN_795X_RNG
 	/* First value must be discarded */
 	hifn_read_1(dev, HIFN_1_RNG_DATA);
 	dev->rngtime = ktime_get();
